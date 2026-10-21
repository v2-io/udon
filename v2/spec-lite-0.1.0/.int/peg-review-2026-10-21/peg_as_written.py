"""Execute the line-level part of .int/peg-2026-10-21.md exactly as written,
to check by running (not by reasoning) what it does with one-line inputs.

Modelling choices (the PEG leaves these to the lexer or marks them OPEN):
  - WS     = one or more U+0020.
  - EOL    = "\n".  EOF = end of input.
  - EOB    = zero-width: succeeds where only an optional "\n" remains before EOF
             (a one-line document closes every open block at its end).  This is
             *generous*: in the grammar as written nothing consumes an element's
             or attribute's own line ending, so a strict EOB-after-EOL model fails
             more inputs than this one does.
  - LABEL  = [A-Za-z_$][A-Za-z0-9_$-]*   (placeholder; the labels discussion is open)
  - number = [+-]?[0-9]+(\.[0-9]+)?       (placeholder for the PEG's "???")
  - escape = the PEG's literal "\\" "[set]"  (i.e. effectively never matches)
  - RAW inside <..> @{..} ;{..} = to the matching closer, nesting, same line.
  - INTERIOR of |{..} = same as RAW (undesigned).
  - quoted-name = a delimited string (the PEG names it but gives no production).
Every production below is transcribed from the PEG block; comments give the
PEG line it comes from.
"""
import re, sys

class P:
    def __init__(self, s): self.s = s
    def at(self, i, lit): return self.s.startswith(lit, i)

FAIL = None

def lit(t):
    def f(p, i): return (i + len(t), None) if p.at(i, t) else FAIL
    return f

def rx(pat):
    r = re.compile(pat)
    def f(p, i):
        m = r.match(p.s, i)
        return (m.end(), m.group(0)) if m else FAIL
    return f

def seq(*fs):
    def f(p, i):
        out = []
        for g in fs:
            r = g(p, i)
            if r is FAIL: return FAIL
            i, v = r
            if v is not None: out.append(v)
        return (i, out if out else None)
    return f

def alt(*fs):
    def f(p, i):
        for g in fs:
            r = g(p, i)
            if r is not FAIL: return r
        return FAIL
    return f

def star(g):
    def f(p, i):
        out = []
        while True:
            r = g(p, i)
            if r is FAIL or r[0] == i and r[1] is None: return (i, out if out else None)
            i, v = r
            if v is not None: out.append(v)
    return f

def plus(g):
    def f(p, i):
        r = star(g)(p, i)
        return r if r[0] != i else FAIL
    return f

def opt(g):
    def f(p, i):
        r = g(p, i)
        return r if r is not FAIL else (i, None)
    return f

def andp(g):
    def f(p, i): return (i, None) if g(p, i) is not FAIL else FAIL
    return f

def notp(g):
    def f(p, i): return (i, None) if g(p, i) is FAIL else FAIL
    return f

def any_char(p, i): return (i + 1, None) if i < len(p.s) else FAIL

def cap(name, g):
    """lowercase rule: capture; value is (name, text-or-children)"""
    def f(p, i):
        r = g(p, i)
        if r is FAIL: return FAIL
        j, v = r
        return (j, (name, v if v else p.s[i:j]))
    return f

def R(name):  # late binding for recursion
    def f(p, i): return G[name](p, i)
    return f

def matched(open_, close):
    def f(p, i):
        if not p.at(i, open_): return FAIL
        j = i + len(open_); depth = 1
        oc = open_[-1]
        while j < len(p.s) and p.s[j] != "\n":
            c = p.s[j]
            if c == "\\" and j + 1 < len(p.s): j += 2; continue
            if c == oc: depth += 1
            elif c == close:
                depth -= 1
                if depth == 0: return (j + 1, None)
            j += 1
        return FAIL
    return f

WS   = rx(r" +")
EOL  = lit("\n")
EOF  = lambda p, i: (i, None) if i == len(p.s) else FAIL
EOB  = lambda p, i: (i, None) if p.s[i:] in ("", "\n") else FAIL
LABEL = rx(r"[A-Za-z_$][A-Za-z0-9_$-]*")
FENCE = rx(r"```+(?=[^`\n]*$)")
BS_SEP = seq(WS, lit("\\"), WS)                       # BS-SEP: WS "\" WS, consumed
HEX = rx(r"[0-9A-Fa-f]")
DIGIT = rx(r"[0-9]")

G = {}
# start <- ("|" / ":" / ";" / "@" / "!" / FENCE) !"{"
G["start"] = seq(alt(lit("|"), lit(":"), lit(";"), lit("@"), lit("!"), FENCE), notp(lit("{")))
# block <- BLANK / comment / element / attribute / fence / reserved / prose   (fence, BLANK omitted)
G["block"] = alt(R("comment"), R("element"), R("attribute"), R("reserved"), R("prose"))
# element <- "|" !"{" head (main block)* main framed-comment? EOB
G["element"] = cap("element", seq(lit("|"), notp(lit("{")), R("head"),
                    star(seq(R("main"), R("block"))), R("main"), opt(R("framed-comment")), EOB))
# head <- name? key* trait*
G["head"] = seq(opt(R("name")), star(R("key")), star(R("trait")))
# name <- LABEL / quoted-name
G["name"] = cap("name", alt(LABEL, R("string")))
# key <- "[" value "]"
G["key"] = cap("key", seq(lit("["), R("value"), lit("]")))
# trait <- WS* "." LABEL
G["trait"] = cap("trait", seq(star(WS), lit("."), LABEL))
# main <- (WS value)*
G["main"] = cap("main", star(seq(WS, R("value"))))
# attribute <- ":" !"{" name (WS element / (WS value framed-comment?)+) (BS-SEP / EOB)
G["attribute"] = cap("attribute", seq(lit(":"), notp(lit("{")), R("name"),
                    alt(seq(WS, R("element")), plus(seq(WS, R("value"), opt(R("framed-comment"))))),
                    alt(BS_SEP, EOB)))
# comment <- ";" !"{" RAW EOB    (RAW = rest of line here)
G["comment"] = cap("comment", seq(lit(";"), notp(lit("{")), rx(r"[^\n]*"), EOB))
# framed-comment <- WS ";" !"{" (WS RAW / &EOL) EOB
G["framed-comment"] = cap("framed-comment", seq(WS, lit(";"), notp(lit("{")),
                    alt(seq(WS, rx(r"[^\n]*")), andp(EOL)), EOB))
# reserved <- ("@" / "!") !"{"
G["reserved"] = cap("RESERVED-ERROR", seq(alt(lit("@"), lit("!")), notp(lit("{"))))
# prose <- prose-line+ EOB ; prose-line <- "\\"? (embed / escaped-embed / CHAR)* EOL
G["escaped-embed"] = seq(lit("\\"), alt(lit("|{"), lit("@{"), lit(";{"), lit("!{")))
CHAR = seq(notp(alt(EOL, lit("|{"), lit("@{"), lit(";{"), lit("!{"))), any_char)
G["prose-line"] = seq(opt(lit("\\")), star(alt(R("embed"), R("escaped-embed"), CHAR)), EOL)
G["prose"] = cap("prose", seq(plus(R("prose-line")), EOB))
# value <- string / number / "true" / "false" / "nil" / list / angle / element / text / reserved
G["value"] = alt(R("string"), R("number"), cap("true", lit("true")), cap("false", lit("false")),
                 cap("nil", lit("nil")), R("list"), R("angle"), R("element"), R("text"), R("reserved"))
G["number"] = cap("number", rx(r"[+-]?[0-9]+(\.[0-9]+)?"))   # placeholder for "???"
# strings
dq_char = seq(notp(alt(lit('"'), lit("\\"), EOL)), any_char)
dq_escape = seq(lit("\\"), alt(alt(*[lit(c) for c in '\\"\'/#ntrfe']),
                               seq(lit("0"), notp(DIGIT)), seq(lit("x"), rx(r"[0-7]"), HEX),
                               seq(lit("u{"), rx(r"[0-9A-Fa-f][0-9A-Fa-f_]*( [0-9A-Fa-f][0-9A-Fa-f_]*)*"), lit("}")),
                               seq(lit("u"), HEX, HEX, HEX, HEX)))
sq_char = seq(notp(alt(lit("'"), EOL)), any_char)
sq_escape = seq(lit("\\"), alt(lit("'"), lit("\\")))
G["string"] = cap("string", alt(seq(lit('"'), star(alt(dq_escape, dq_char)), lit('"')),
                                seq(lit("'"), star(alt(sq_escape, sq_char)), lit("'"))))
# list <- "[" WS* (value (WS value)*)? WS* "]"
G["list"] = cap("list", seq(lit("["), star(WS), opt(seq(R("value"), star(seq(WS, R("value"))))), star(WS), lit("]")))
# angle <- "<" RAW ">"
G["angle"] = cap("angle", matched("<", ">"))
# text <- piece+ &text-end ; piece <- embed / bare-string
G["text"] = cap("text", seq(plus(R("piece")), andp(R("text-end"))))
G["piece"] = alt(R("embed"), R("bare-string"))
# bare-string <- (escape / !(embed / text-end) .)+ ; escape <- "\\" "[set]"
escape = seq(lit("\\"), lit("[set]"))
G["bare-string"] = cap("bare", plus(alt(escape, seq(notp(alt(R("embed"), R("text-end"))), any_char))))
# text-end <- BS-SEP / WS &start / EOL
G["text-end"] = alt(BS_SEP, seq(WS, andp(R("start"))), EOL)
# embed <- inline-element / reference / inline-comment / reserved-embed
G["embed"] = alt(cap("inline-element", matched("|{", "}")), cap("reference", matched("@{", "}")),
                 cap("inline-comment", matched(";{", "}")), cap("RESERVED-EMBED-ERROR", lit("!{")))
G["document"] = seq(star(R("block")), opt(EOL), EOF)

def show(v, d=0):
    if isinstance(v, tuple):
        name, body = v
        if isinstance(body, str): return f"{name}«{body}»"
        return f"{name}(" + " ".join(show(x) for x in flat(body)) + ")"
    if isinstance(v, list): return " ".join(show(x) for x in flat(v))
    return repr(v)

def flat(v):
    if isinstance(v, list):
        for x in v: yield from flat(x)
    elif v is not None: yield v

def parse(src):
    p = P(src if src.endswith("\n") else src + "\n")
    r = G["document"](p, 0)
    if r is FAIL: return "NO PARSE"
    return show(r[1])

if __name__ == "__main__":
    for line in sys.stdin:
        line = line.rstrip("\n")
        if not line or line.startswith("#"): continue
        print(f"{line!r:40} => {parse(line)}")
