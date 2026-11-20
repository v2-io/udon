"""A one-for-one transcription of the repaired PEG block in ../peg-2026-10-21.md
(2026-10-21), for one-line inputs, so that the grammar as written can be run on
the card cases rather than only read.  Uses the combinators of peg_as_written.py.

Modeling choices, as in the review's harness:
  WS = one or more spaces; EOL = "\\n"; EOB = zero-width at end of a one-line
  document; LABEL = [A-Za-z_$][A-Za-z0-9_$-]*; NAME-FIRST = [A-Za-z_$];
  NUMBER = [+-]?[0-9]+(\\.[0-9]+)?; BOUND = WS / EOL / "]"; ESCAPABLE = the
  coordinator's proposed set in rule-value-line-escapes; RAW/INTERIOR = to the
  matching closer on the line.
Multi-line behavior (EOB by column, prose, fence bodies) is not modeled.
Run:  python3 peg_v2.py < cases.txt
"""
import re, sys
from peg_as_written import (P, FAIL, lit, rx, seq, alt, star, plus, opt, andp, notp,
                            any_char, cap, matched, show)

class ParseError(Exception):
    pass

def error(what):
    def f(p, i): raise ParseError(f"{what} at col {i}: {p.s[i:i+14]!r}")
    return f

def commit(opener, g, what):
    def f(p, i):
        if not p.at(i, opener): return FAIL
        r = g(p, i)
        if r is FAIL: raise ParseError(f"unclosed {what} at col {i}")
        return r
    return f

G = {}
def R(name):  # late binding against THIS grammar's table
    def f(p, i): return G[name](p, i)
    return f
WS = rx(r" +"); EOL = lit("\n")
def EOF(p, i): return (i, None) if i >= len(p.s) else FAIL
def EOB(p, i): return (i, None) if p.s[i:].strip("\n") == "" else FAIL
LABEL = rx(r"[A-Za-z_$][A-Za-z0-9_$-]*"); NAME_FIRST = rx(r"[A-Za-z_$]")
FENCE = seq(rx(r"```+"), notp(rx(r"[^\n]*`")))
BS_SEP = seq(WS, lit("\\"), alt(WS, andp(EOL)))
NUMBER = rx(r"[+-]?[0-9]+(\.[0-9]+)?"); BOUND = andp(alt(WS, EOL, lit("]")))
ESCAPABLE = rx(r"[|:;@!{}\"'\[<0-9+\-`\\.]")
DIGIT = rx(r"[0-9]"); HEX = rx(r"[0-9A-Fa-f]")
QUOTE = alt(lit('"'), lit("'"))

# starts and their guards
G["element-start"]   = seq(lit("|"), notp(lit("{")), notp(alt(WS, EOL)))
G["attribute-start"] = seq(lit(":"), andp(alt(NAME_FIRST, QUOTE)))
G["framed-semicolon"]= seq(lit(";"), notp(lit("{")), andp(alt(WS, EOL)))
G["fence-start"]     = seq(FENCE, notp(lit("{")))
G["reserved-start"]  = seq(alt(lit("@"), lit("!")), andp(alt(NAME_FIRST, lit(":"), lit("["), lit("."), lit("<"))))
G["_start"] = alt(R("element-start"), R("attribute-start"), R("framed-semicolon"), R("fence-start"), R("reserved-start"))

# strings
G["dq-char"]   = seq(notp(alt(lit('"'), lit("\\"), EOL)), any_char)
G["hex-run"]   = seq(HEX, star(alt(HEX, lit("_"))))
G["dq-escape"] = seq(lit("\\"), alt(rx(r'[\\"\'/#ntrfe]'), seq(lit("0"), notp(DIGIT)), seq(lit("x"), rx(r"[0-7]"), HEX),
                      seq(lit("u{"), R("hex-run"), star(seq(WS, R("hex-run"))), lit("}")), seq(lit("u"), HEX, HEX, HEX, HEX),
                      error("unknown escape")))
G["double-quoted-string"] = cap("double-quoted-string", commit('"', seq(lit('"'), star(alt(R("dq-escape"), R("dq-char"))), lit('"')), "string"))
G["sq-escape"] = seq(lit("\\"), alt(lit("'"), lit("\\")))
G["sq-char"]   = seq(notp(alt(lit("'"), EOL)), any_char)
G["single-quoted-string"] = cap("single-quoted-string", commit("'", seq(lit("'"), star(alt(R("sq-escape"), R("sq-char"))), lit("'")), "string"))
G["delimited-string"] = alt(R("double-quoted-string"), R("single-quoted-string"))

# scalars
G["number"]  = cap("number", seq(NUMBER, BOUND))
G["boolean"] = cap("boolean", seq(alt(lit("true"), lit("false")), BOUND))
G["nil"]     = cap("nil", seq(lit("nil"), BOUND))
G["angle"]   = cap("angle", commit("<", matched("<", ">"), "<…>"))

# embeds
G["inline-element"] = cap("inline-element", commit("|{", matched("|{", "}"), "|{…}"))
G["reference"]      = cap("reference", commit("@{", matched("@{", "}"), "@{…}"))
G["inline-comment"] = cap("inline-comment", commit(";{", matched(";{", "}"), ";{…}"))
G["ERROR-reserved-embed"] = seq(lit("!{"), error("reserved embed"))
G["embed"] = alt(R("inline-element"), R("reference"), R("inline-comment"), R("ERROR-reserved-embed"))

# text (limited prose)
G["text-end"] = alt(BS_SEP, seq(WS, andp(R("_start"))), EOL)
G["escape"]   = seq(lit("\\"), alt(ESCAPABLE, error("unknown escape")))
G["bare-string"] = cap("bare-string", plus(alt(R("escape"), seq(notp(alt(R("embed"), R("text-end"))), any_char))))
G["piece"] = alt(R("embed"), R("bare-string"))
G["text"]  = cap("text", seq(notp(R("_start")), plus(R("piece")), andp(R("text-end"))))

# lists, keys
G["list-text"] = cap("list-text", plus(seq(notp(alt(lit("]"), WS, EOL)), any_char)))
G["list-item"] = alt(R("delimited-string"), R("number"), R("boolean"), R("nil"), R("list"), R("angle"), R("list-text"))
G["list"] = cap("list", commit("[", seq(lit("["), star(WS), opt(seq(R("list-item"), star(seq(WS, R("list-item"))))), star(WS), lit("]")), "list"))
G["key-bare"] = cap("key-bare", plus(alt(seq(lit("\\"), alt(lit("\\"), lit("["), lit("]"))),
                                        seq(notp(alt(lit("]"), R("embed"), lit("\\"), EOL)), any_char))))
G["key-text"] = cap("key-text", plus(alt(R("embed"), R("key-bare"))))
G["key"] = cap("key", commit("[", seq(lit("["), alt(R("delimited-string"), R("number"), R("boolean"), R("nil"), R("angle"), R("key-text")), lit("]")), "key"))

G["value"] = alt(R("delimited-string"), R("number"), R("boolean"), R("nil"), R("list"), R("angle"), R("text"))

# head, items, lines
G["name"]  = cap("name", alt(LABEL, R("delimited-string")))
G["trait"] = cap("trait", seq(star(WS), lit("."), LABEL))
G["head"]  = seq(opt(R("name")), star(R("key")), star(R("trait")))
G["framed-comment"] = cap("framed-comment", seq(WS, R("framed-semicolon"), alt(seq(WS, rx(r"[^\n]*")), andp(EOL))))
G["empty-text"] = cap("text", andp(BS_SEP))
G["ERROR-missing-value"] = seq(andp(alt(seq(WS, R("attribute-start")), EOL)), error("missing value"))
G["ERROR-reserved"] = seq(R("reserved-start"), error("reserved"))
G["attribute"] = cap("attribute", seq(R("attribute-start"), R("name"),
                     alt(seq(WS, alt(R("element"), R("fence"))), R("empty-text"),
                         seq(WS, R("value"), opt(R("framed-comment"))), R("ERROR-missing-value"))))
G["main"] = cap("main", R("value"))
G["_item"] = alt(R("attribute"), R("element"), R("fence"), R("ERROR-reserved"), R("main"))
G["_sep"]  = alt(BS_SEP, WS)
G["_line-rest"] = seq(star(seq(R("_sep"), R("_item"))), opt(R("framed-comment")))
G["element"] = cap("element", seq(R("element-start"), R("head"), R("_line-rest"), andp(EOL)))
G["fence"]   = cap("fence", seq(R("fence-start"), R("head"), R("_line-rest"), andp(EOL)))   # body not modeled
G["attribute-line"] = cap("attribute", seq(R("attribute-start"), R("name"),
                          alt(seq(WS, alt(R("element"), R("fence"))), R("empty-text"),
                              plus(seq(R("_sep"), R("value"), opt(R("framed-comment")))), R("ERROR-missing-value")), andp(EOL)))
G["comment-block"] = cap("comment-block", seq(lit(";"), notp(lit("{")), rx(r"[^\n]*")))
G["escaped-embed"] = cap("escaped-embed", seq(lit("\\"), alt(lit("|{"), lit("@{"), lit(";{"), lit("!{"))))
G["prose-line"] = cap("prose", seq(opt(lit("\\")), star(alt(R("embed"), R("escaped-embed"), seq(notp(EOL), any_char))), andp(EOL)))
G["_block"] = alt(R("comment-block"), R("element"), R("attribute-line"), R("fence"), R("ERROR-reserved"), R("prose-line"))
G["root"] = seq(star(seq(R("_block"), opt(EOL))), EOF)

def parse(src):
    p = P(src if src.endswith("\n") else src + "\n")
    try:
        r = G["root"](p, 0)
    except ParseError as e:
        return f"ERROR {e}"
    if r is FAIL: return "NO PARSE"
    return show(r[1])

if __name__ == "__main__":
    for line in sys.stdin:
        line = line.rstrip("\n")
        if not line or line.startswith("#"): continue
        print(f"{line!r:40} => {parse(line)}")
