"""Gloss-tier helper for invention I2: given a value line and {value-text: reading},
emit a caret line with each ^reading at the column of that value's first character,
and check readings don't overlap. Also parses a caret line back to (col, reading)
and maps each caret to the value starting at that column (error if none)."""
import re, sys

def gloss(line, pairs):
    out = [" "] * (len(line) + 40)
    cols = []
    for needle, reading in pairs:
        i = line.index(needle)
        cols.append((i, reading))
    cols.sort()
    end = -1
    for c, r in cols:
        if c <= end: raise SystemExit(f"overlap at col {c}: ^{r}")
        tok = "^" + r
        out[c:c+len(tok)] = tok
        end = c + len(tok)
    return "".join(out).rstrip()

def check(value_line, caret_line):
    # value starts: first char of each whitespace-separated token after a ':name ' or in text
    starts = {m.start(): m.group() for m in re.finditer(r"\S+", value_line)}
    res = []
    for m in re.finditer(r"\^(\S+)", caret_line):
        c = m.start()
        res.append((c, m.group(1), starts.get(c, "ERROR: no token starts here")))
    return res

if __name__ == "__main__":
    ex = [
      ("|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod",
       [("8080","u16"),("30s","dur"),("2026-07-21T14:20","datetime")]),
      ("|decision :date 2026-07-21 :at 10:12 :window 60s",
       [("2026-07-21","date"),("10:12","time"),("60s","dur")]),
      ("|job :timeout 5m :length 5m",
       [("5m","min")]),
      ("|part :zip 01234 :version 1.10 :commit 1234567 :id 1e10",
       [("01234","id"),("1.10","ver"),("1234567","sha"),("1e10","id")]),
      ("|ev :on 05-03-27",
       [("05-03-27","dt[DD-MM-YY]")]),
      ("|p Doors open at 19:30 sharp, on 2026-07-21.",
       [("19:30","time"),("2026-07-21","date")]),
    ]
    for line, pairs in ex:
        g = gloss(line, pairs)
        print(line); print(g)
        for c, r, tok in check(line, g): print(f"   col {c:>2} ^{r:<12} -> {tok}")
        print()

def underline(line, spans):
    """spans: [(exact substring, reading)] -> '^~~~~ reading' under each, clang-style."""
    out = [" "] * (len(line) + 60); end = -1
    for needle, reading in sorted(spans, key=lambda p: line.index(p[0])):
        c = line.index(needle)
        tok = "^" + "~" * (len(needle) - 1) + " " + reading
        if c <= end: raise SystemExit("overlap")
        out[c:c+len(tok)] = tok; end = c + len(tok)
    return "".join(out).rstrip()

if __name__ == "__main__":
    for line, spans in [
      ("|p Doors open at 19:30 sharp, on 2026-07-21.", [("19:30","time"),("2026-07-21","date")]),
      ("  The pump ran for 5m at 40.71,-74.00 before the 3rd stop.", [("5m","min"),("40.71,-74.00","geo")]),
    ]:
        print(line); print(underline(line, spans)); print()
