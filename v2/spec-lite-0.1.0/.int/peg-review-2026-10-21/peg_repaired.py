"""A minimally repaired line layer, to check that the failures found in
peg_as_written.py are local (fixable inside the PEG) rather than structural,
and to see which inputs still need a decision.  Every repair is marked R<n>
and corresponds to a numbered finding in .int/peg-review-2026-10-21.md.
Choices on OPEN questions are marked CHOICE and are the reviewer's guesses,
not proposals for the cards.
"""
import peg_as_written as W
from peg_as_written import (G, R, P, FAIL, lit, rx, seq, alt, star, plus, opt, andp, notp,
                            any_char, cap, WS, EOL, EOF, LABEL, FENCE, BS_SEP, show, matched)

class ParseError(Exception):
    pass

def commit(opener, g, what):
    """R9: once a delimited form's opener is seen, failing to close it is an
    error (rule-unclosed-delimiter-is-error), not a backtrack into text."""
    def f(p, i):
        if not p.at(i, opener): return FAIL
        r = g(p, i)
        if r is FAIL: raise ParseError(f"unclosed {what} at col {i}")
        return r
    return f

def error(what, g):
    def f(p, i):
        r = g(p, i)
        if r is FAIL: return FAIL
        raise ParseError(f"{what} at col {i}: {p.s[i:i+12]!r}")
    return f

ORIG = dict(G)
LABEL_FIRST = rx(r"[A-Za-z_$]")
QUOTE = alt(lit('"'), lit("'"))

# R4: guards, from the cards and Joseph's words rather than from "!{" alone
ELEM_START  = seq(lit("|"), notp(lit("{")), notp(alt(WS, EOL)))          # "a space after the first pipe" is text (2026-10-08)
ATTR_START  = seq(lit(":"), andp(alt(LABEL_FIRST, QUOTE)))               # ":name" (rule-text-value-end); ":-)" stays text
FRAMED_SEMI = seq(lit(";"), notp(lit("{")), andp(alt(WS, EOL)))          # framed ";" (rule-framed-comments); CHOICE: EOL counts as frame (def-framed open)
RES_START   = seq(alt(lit("@"), lit("!")), andp(alt(LABEL_FIRST, lit(":"), lit("["), lit("."), lit("<"))))  # rule-reserved-spellings rows
G["start"] = alt(ELEM_START, ATTR_START, FRAMED_SEMI, FENCE, RES_START)

# R6: a keyword or number needs a boundary after it.  CHOICE: WS / EOL / "]" (rule:bare-typing gap)
BOUND = andp(alt(WS, EOL, lit("]")))
G["number"] = cap("number", seq(rx(r"[+-]?[0-9]+(\.[0-9]+)?"), BOUND))
KW = alt(cap("true", seq(lit("true"), BOUND)), cap("false", seq(lit("false"), BOUND)),
         cap("nil", seq(lit("nil"), BOUND)))

# R1: a text never begins at a start.  R10: ":a \" gives an empty text.
G["text"] = cap("text", seq(notp(R("start")), plus(R("piece")), andp(R("text-end"))))
EMPTY_TEXT = cap("text", andp(BS_SEP))

# R5: contexts with their own terminators
key_bare = cap("bare", plus(alt(seq(lit("\\"), alt(lit("\\"), lit("["), lit("]"))),
                                seq(notp(alt(lit("]"), R("embed"), EOL, lit("\\"))), any_char))))
key_text = cap("text", plus(alt(R("embed"), key_bare)))
list_bare = cap("text", plus(seq(notp(alt(lit("]"), WS, EOL)), any_char)))   # CHOICE: an unquoted item ends at WS (rule-list-items open)

G["string"] = alt(commit('"', ORIG["string"], "string"), commit("'", ORIG["string"], "string"))
G["angle"] = commit("<", ORIG["angle"], "<…>")
G["list"] = commit("[", cap("list", seq(lit("["), star(WS),
                 opt(seq(R("list-item"), star(seq(WS, R("list-item"))))), star(WS), lit("]"))), "list")
G["list-item"] = alt(R("string"), R("number"), KW, R("list"), R("angle"), list_bare)
G["key"] = commit("[", cap("key", seq(lit("["), alt(R("string"), R("number"), KW, R("angle"), key_text), lit("]"))), "key")

# R2/R3: value positions exclude elements except where a card allows one
G["scalar"] = alt(R("string"), R("number"), KW, R("list"), R("angle"), R("text"),
                  error("reserved", RES_START))
G["value"] = G["scalar"]

# R7: framed comment, attaching to the item before it
G["framed-comment"] = cap("framed-comment", seq(WS, lit(";"), notp(lit("{")),
                          alt(seq(WS, rx(r"[^\n]*")), andp(EOL))))

# attribute begun mid-line on an element line: ONE value (CHOICE = rule-leftover-values:
# leftovers go to the line's owning element), or an element right after it
# (rule-element-after-attribute-with-no-value), or an empty text before a framed "\".
ATTR_HEAD = seq(lit(":"), andp(alt(LABEL_FIRST, QUOTE)), R("name"))
G["inline-attribute"] = cap("attribute", seq(ATTR_HEAD,
        alt(seq(WS, R("element")), EMPTY_TEXT, seq(WS, R("value"), opt(R("framed-comment"))),
            error("missing value (or :a :b, reserved)", andp(alt(seq(WS, ATTR_START), EOL))))))

# R2: items on a line are separated by WS or by a framed "\" (R8: BS-SEP shares
# the separator role instead of being eaten by the attribute before it).
SEP = alt(BS_SEP, WS)
G["line-item"] = alt(R("inline-attribute"), R("element"), error("reserved", RES_START), cap("main", R("value")))
G["line-rest"] = seq(star(seq(SEP, R("line-item"))), opt(R("framed-comment")))

# element: head, then the rest of its line; no prose or comment-block in value mode
G["element"] = cap("element", seq(ELEM_START, R("head"), R("line-rest"), andp(EOL)))

# attribute at a line start (attribute-line): values stack (rule-leftover-values)
G["attribute-line"] = cap("attribute", seq(ATTR_HEAD,
        alt(seq(WS, R("element")),
            EMPTY_TEXT,
            plus(seq(SEP, R("value"), opt(R("framed-comment"))))), andp(EOL)))

G["line"] = alt(G["comment"], R("element"), R("attribute-line"), error("reserved", RES_START), G["prose"])
G["document"] = seq(star(seq(R("line"), opt(EOL))), EOF)

def parse(src):
    p = P(src if src.endswith("\n") else src + "\n")
    try:
        r = G["document"](p, 0)
    except ParseError as e:
        return f"ERROR {e}"
    if r is FAIL: return "NO PARSE"
    return show(r[1])

if __name__ == "__main__":
    import sys
    for line in sys.stdin:
        line = line.rstrip("\n")
        if not line or line.startswith("#"): continue
        print(f"{line!r:40} => {parse(line)}")
