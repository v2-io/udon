"""N-std: a reference classifier for the interior of an unlabeled-or-named `<…>`.

Not lite's grammar: a model of the proposal in design.md, to check that
(1) every interior's *class* is decided within a few characters,
(2) its exact kind within a bounded length (with the spelled caps),
(3) every spelling outside the set is an error with a suggestion (the B2 error space).
It classifies and validates; it never converts. Run: python3 -I discriminate.py
"""
import re, calendar

CAP_LABEL, CAP_FRAC, CAP_ZONE = 64, 9, 64
NUM = r"[+-]?(?:0|[1-9](?:_?\d)*)(?:\.\d(?:_?\d)*)?(?:[eE][+-]?\d+)?|0x[0-9A-Fa-f](?:_?[0-9A-Fa-f])*|0o[0-7](?:_?[0-7])*|0b[01](?:_?[01])*"
UNIT = r"(?:[A-Z]{3}|[A-Za-z%\[\]{}'0-9.^/_*-]+)"          # ISO 4217 code, or a UCUM-shaped term
D = r"(\d{4})-(\d{2})-(\d{2})"
T = r"(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{1,%d}))?)?" % CAP_FRAC
OFF = r"(?:Z|[+-]\d{2}:\d{2})"
ZONE = r"\[!?[A-Za-z][A-Za-z0-9_+\-]*(?:/[A-Za-z0-9_+\-]+)*\]"
DUR = r"-?P(?:\d+W|(?:\d+Y)?(?:\d+M)?(?:\d+D)?(?:T(?:\d+H)?(?:\d+M)?(?:\d+(?:\.\d{1,%d})?S)?)?)" % CAP_FRAC
LABEL = r"[A-Za-z][A-Za-z0-9_-]*"

def ok_date(y, m, d):
    y, m, d = int(y), int(m), int(d)
    if not 1 <= m <= 12: return f"month {m:02d} is out of range (01–12)"
    if not 1 <= d <= calendar.monthrange(y, m)[1]: return f"day {d:02d} is not in {y}-{m:02d}"
def ok_time(h, mi, s):
    if int(h) > 23: return f"hour {h} is out of range (00–23)"
    if int(mi) > 59: return f"minute {mi} is out of range (00–59)"
    if s and int(s) > 60: return f"second {s} is out of range (00–60)"

def classify(x):
    """Return (kind, decided_at, note). decided_at = 1-based index of the char that fixes the class."""
    if x == "": return ("nil", 1, "")
    c = x[0]
    if c in "\"'": return ("string", 1, "") if len(x) > 1 and x[-1] == c else ("ERROR", 1, "unclosed string")
    if c == "{": return ("value-embed", 1, "see design: `<{…}>`")
    if c == "-" and x[1:2] == "P" or c == "P" and x[1:2] in list("0123456789T"):
        if re.fullmatch(DUR, x) and x not in ("P", "PT", "-P") and not x.endswith("T"): return ("duration", 2, "")
        return ("ERROR", 2, "not an ISO 8601 duration (PnYnMnDTnHnMnS, or PnW alone): components in order")
    if c.isdigit() or c in "+-":
        # the class is fixed by the first non-digit after the leading digit run
        m = re.match(r"[+-]?\d+", x); run = m.group(0) if m else ""; nxt = x[len(run):len(run)+1]; at = len(run) + 1
        if nxt == "-" and len(run) == 4 and run.isdigit():
            for pat, kind in ((rf"{D}T{T}{OFF}{ZONE}", "datetime.zoned"), (rf"{D}T{T}{OFF}", "datetime.offset"),
                              (rf"{D}T{T}", "datetime.local"), (D, "date"), (r"(\d{4})-(\d{2})", "year-month")):
                mm = re.fullmatch(pat, x)
                if mm:
                    g = mm.groups(); e = ok_date(*g[:3]) if len(g) >= 3 else (None if 1 <= int(g[1]) <= 12 else f"month {g[1]} is out of range")
                    e = e or (ok_time(*g[3:6]) if len(g) >= 6 else None)
                    return ("ERROR", at, e) if e else (kind, at, "")
            if "/" in x:
                a, b = x.split("/", 1); ka, kb = classify(a)[0], classify(b)[0]
                if ka != "ERROR" and kb != "ERROR" and "duration" != ka or (ka == "duration" and kb != "duration"):
                    if not (ka == kb == "duration"): return ("interval", len(a) + 1, f"{ka} / {kb}")
                return ("ERROR", len(a) + 1, "an interval is start/end, start/duration or duration/end")
            if " " in x and re.fullmatch(rf"{D} .*", x): return ("ERROR", at, "date and time are joined with T: <%s>" % x.replace(" ", "T", 1))
            if re.fullmatch(r"\d{4}-\d{1,2}-\d{1,2}.*", x): return ("ERROR", at, "dates are zero-padded YYYY-MM-DD: did you mean <%s>?" % "-".join(p.zfill(2) for p in x.split("-")[:3]))
            if " " in x: return ("ERROR", at, "date and time are joined with T: <%s>" % x.replace(" ", "T", 1))
            return ("ERROR", at, "not an RFC 3339 date or date-time")
        if nxt == "-": return ("ERROR", at, "not a number, and a date needs a four-digit year: <YYYY-MM-DD>; for a two-digit year use a named notation, <date(YY-MM-DD): …>")
        if nxt == ":" and len(run) == 2:
            mm = re.fullmatch(rf"{T}({OFF})?", x)
            if mm: e = ok_time(*mm.groups()[:3]); return ("ERROR", at, e) if e else ("time.local" if not mm.group(5) else "ERROR", at, "" if not mm.group(5) else "a time with an offset needs a date: <YYYY-MM-DDT…>")
            if re.search(r" [A-Z]{2,4}$", x): return ("ERROR", at, "zone abbreviations are ambiguous: use an offset or an IANA zone with a date, <2026-01-10T09:00-07:00[America/Los_Angeles]>")
            return ("ERROR", at, "times are HH:MM[:SS[.f]], zero-padded")
        if nxt == ":": return ("ERROR", at, "times are zero-padded HH:MM: did you mean <0%s>?" % x)
        # a number, possibly followed by ` unit`
        num, _, unit = x.partition(" ")
        if not re.fullmatch(NUM, num):
            m2 = re.fullmatch(r"([+-]?\d+(?:\.\d+)?)([A-Za-z%]+)", x)
            if m2: return ("ERROR", len(m2.group(1)) + 1, f"a quantity has a space before its unit: <{m2.group(1)} {m2.group(2)}>" + (" (metres) or <%s min> (minutes); a duration is <PT%sM>" % (m2.group(1), m2.group(1)) if m2.group(2) == "m" else ""))
            return ("ERROR", 1, "not a number in the standard notation")
        if not unit: return ("number", 1, "")
        if re.fullmatch(r"[A-Z]{3}", unit): return ("quantity.money", len(num) + 2, f"ISO 4217 {unit}")
        if re.fullmatch(UNIT, unit): return ("quantity", len(num) + 2, f"UCUM-shaped unit {unit!r}; atom checked by the reader")
        return ("ERROR", len(num) + 2, "not a UCUM unit term")
    if c.isalpha():
        m = re.match(LABEL, x); lab = m.group(0); at = len(lab) + 1; rest = x[len(lab):]
        if len(lab) > CAP_LABEL: return ("ERROR", CAP_LABEL + 1, "a notation name is at most 64 characters")
        if rest == "": return ((lab, at, "") if lab in ("true", "false", "nil") else
                               ("ERROR", at, f"`{lab}` isn't a value inside <…>: did you mean the text {lab} (bare), the string <\"{lab}\">, or a named notation <{lab}: …>?"))
        if rest.startswith("://"): return ("uri", at, "absolute URI, hierarchical (CommonMark autolink shape)")
        if rest.startswith("@"): return ("email", at, "CommonMark email-autolink shape")
        mm = re.match(rf"((?:/{LABEL})*)(\([^()]*\))?:", rest)
        if mm: return ("named", at, f"name={lab}{mm.group(1)} params={mm.group(2)} body={rest[mm.end():].strip()!r}")
        return ("ERROR", at, "after a name inside <…>: `:` (named notation), `://` (URI) or `@` (email)")
    return ("ERROR", 1, f"`{c}` can't start a value inside <…>")

CASES = """2026-10-01|2026-01-10T14:30Z|2026-01-10T14:30Z[America/Denver]|09:00|dt: 2026 PDT|date(YY-MM-DD): 27-03-05
PT30S|30 s|P1Y2M|5 min|5 m|2026-01/2026-06|css: 920px|1.5 GiBy|50 %|37.5 Cel|9.99 USD|rust/i64: 0x73DDF|22
re: \\d+-\\w+|https://example.com|uuid: 0f8fad5b-d9cb-469f-a165-70867728950e|b64: SGVsbG8=|acme/sku: AB-12|20261001|jw@example.com
|nil|true|8080|"1.10"|-P1D|2026-01-10T14:30:00.123456789+05:30|2026-01-10T14:30/PT1H
2026-13-01|2026-02-29|2024-02-29|2026-1-5|5m|50%|2026-01-10 14:30|09:00 PDT|9:30|27-03-05|PT|P1W2D|hello|date:2026-10-01|kbd|= 5|920 px""".replace("\n", "|").split("|")
for x in CASES:
    k, at, note = classify(x)
    print(f"<{x}>".ljust(44), k.ljust(16), f"class fixed at char {at}".ljust(24), note)
