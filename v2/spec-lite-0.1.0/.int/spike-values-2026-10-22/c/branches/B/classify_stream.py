#!/usr/bin/env python3
"""Branch B check: classify a bare run by its whole spelling with O(1) state,
fed in arbitrary chunks, and measure what a kind-first emitter must hold.

The primitive grammar here is ILLUSTRATIVE (strict, JSON-like plus `_` and
0x/0o/0b); the real set is the `core` fork's question. What this checks is
structural and holds for any regular primitive grammar with no spaces in it:

  1. the hand-written DFA agrees with a regex reference (fuzzed), so a
     constant-state classifier exists;
  2. it is chunk-seam invariant (state carries across feeds);
  3. under a kind-at-close wire the parser forwards every byte at once
     (holds 0 bytes for typing);
  4. under a kind-first wire with a spelled cap N, holdback never exceeds N,
     including Joseph's adversarial `4938222...2412124p`.

Run: python3 -I classify_stream.py
"""
import random
import re

# ---- reference grammar (regex) ---------------------------------------------
D = r"[0-9](?:_?[0-9])*"
INT = rf"-?(?:0|[1-9](?:_?[0-9])*)"
REF = re.compile(
    rf"(?:{INT}"                                    # integer
    rf"|-?0x[0-9A-Fa-f](?:_?[0-9A-Fa-f])*"          # hex
    rf"|-?0o[0-7](?:_?[0-7])*"                       # octal
    rf"|-?0b[01](?:_?[01])*"                         # binary
    rf"|{INT}(?:\.{D}(?:[eE][+-]?{D})?|[eE][+-]?{D})"  # float
    rf"|true|false|nil)"
)

def ref_kind(s):
    if not REF.fullmatch(s):
        return "text"
    if s in ("true", "false"):
        return "boolean"
    if s == "nil":
        return "nil"
    if re.fullmatch(r"-?0[xob].*", s) or re.fullmatch(INT, s):
        return "integer"
    return "float"

# ---- constant-state DFA ------------------------------------------------------
# States are small strings; DEAD means "text, decided". One state variable
# plus a keyword index is all that is carried between bytes or chunks.
DIG = set("0123456789")
HEX = set("0123456789abcdefABCDEF")
OCT = set("01234567")
BIN = set("01")
BASES = {"x": HEX, "o": OCT, "b": BIN}
KW = ("true", "false", "nil")

ACCEPT = {"zero": "integer", "int": "integer", "bdig": "integer",
          "frac": "float", "exp": "float"}

class Classifier:
    __slots__ = ("st", "kw", "n", "base")

    def __init__(self):
        self.st, self.kw, self.n, self.base = "start", None, 0, None

    def feed(self, s):
        for c in s:
            self.step(c)
            if self.st == "DEAD":
                return

    def step(self, c):
        st = self.st
        self.n += 1
        if st == "start":
            if c == "-": self.st = "sign"
            elif c == "0": self.st = "zero"
            elif c in DIG: self.st = "int"
            else:
                for k in KW:
                    if c == k[0]:
                        self.st, self.kw = "kw", k
                        return
                self.st = "DEAD"
        elif st == "sign":
            self.st = "zero" if c == "0" else "int" if c in DIG else "DEAD"
        elif st == "zero":
            if c in BASES and self.base is None:
                self.base = BASES[c]; self.st = "bpre"
            elif c == ".": self.st = "dot"
            elif c in "eE": self.st = "e"
            else: self.st = "DEAD"          # no leading zeros, no `0_`
        elif st == "int":
            if c in DIG: pass
            elif c == "_": self.st = "int_"
            elif c == ".": self.st = "dot"
            elif c in "eE": self.st = "e"
            else: self.st = "DEAD"
        elif st == "int_":
            self.st = "int" if c in DIG else "DEAD"
        elif st == "bpre":
            self.st = "bdig" if c in self.base else "DEAD"
        elif st == "bdig":
            if c in self.base: pass
            elif c == "_": self.st = "bpre"
            else: self.st = "DEAD"
        elif st == "dot":
            self.st = "frac" if c in DIG else "DEAD"
        elif st == "frac":
            if c in DIG: pass
            elif c == "_": self.st = "frac_"
            elif c in "eE": self.st = "e"
            else: self.st = "DEAD"
        elif st == "frac_":
            self.st = "frac" if c in DIG else "DEAD"
        elif st == "e":
            self.st = "esign" if c in "+-" else "exp" if c in DIG else "DEAD"
        elif st == "esign":
            self.st = "exp" if c in DIG else "DEAD"
        elif st == "exp":
            if c in DIG: pass
            elif c == "_": self.st = "exp_"
            else: self.st = "DEAD"
        elif st == "exp_":
            self.st = "exp" if c in DIG else "DEAD"
        elif st == "kw":
            i = self.n - 1
            if i < len(self.kw) and c == self.kw[i]:
                pass
            else:
                self.st = "DEAD"

    def kind(self):
        if self.st == "kw":
            if self.n == len(self.kw):
                return {"true": "boolean", "false": "boolean", "nil": "nil"}[self.kw]
            return "text"
        return ACCEPT.get(self.st, "text")

def dfa_kind(s, chunks=None):
    c = Classifier()
    if chunks is None:
        c.feed(s)
    else:
        for ch in chunks:
            c.feed(ch)
    return c.kind()

# ---- emitters ---------------------------------------------------------------
def emit_kind_at_close(chunks):
    """Forward each chunk as it arrives; announce kind at the close."""
    c, held_max, out = Classifier(), 0, []
    for ch in chunks:
        c.feed(ch)
        out.append(("chunk", ch))          # nothing held for typing
    out.append(("close", c.kind()))
    return out, held_max

def emit_kind_first_capped(chunks, N):
    """Hold bytes only while the run could still be a primitive and is <= N
    characters; past N it is text by rule, so the kind is known."""
    c, held, held_max, out, decided = Classifier(), [], 0, [], None
    total = 0
    for ch in chunks:
        for x in ch:
            total += 1
            if decided:
                out.append(("chunk", x)); continue
            c.step(x)
            held.append(x)
            held_max = max(held_max, len(held))
            if c.st == "DEAD" or total > N:
                decided = "text"
                out.append(("open", "text")); out.append(("chunk", "".join(held))); held = []
    if not decided:
        k = c.kind() if total <= N else "text"
        out.append(("open", k)); out.append(("chunk", "".join(held)))
    out.append(("close", None))
    return out, held_max

# ---- tests ------------------------------------------------------------------
def fuzz(n=200000, seed=7):
    rnd = random.Random(seed)
    alphabet = "0123456789_-+.eExobABCFfalsetruni p"
    bad = 0
    for _ in range(n):
        s = "".join(rnd.choice(alphabet) for _ in range(rnd.randint(1, 9)))
        if " " in s:
            continue
        a, b = ref_kind(s), dfa_kind(s)
        cut = sorted(rnd.sample(range(len(s) + 1), min(3, len(s) + 1)))
        parts = [s[i:j] for i, j in zip([0] + cut, cut + [len(s)])]
        c = dfa_kind(s, parts)
        if not (a == b == c):
            bad += 1
            if bad < 10:
                print("MISMATCH", repr(s), a, b, c)
    return bad

CASES = ["web", "8080", "localhost", "true", "3", "0.5", "01234", "1.10",
         "nil", "1984", "1984 is a novel", "1949", "9.99", "1", "2", "three",
         "12345678901234567890123", "0xFF", "1e10", "-0", "NaN", "null",
         "false", "2026-01-10", "2026-01-10T14:30Z", "30s", "P1Y2M",
         "27-03-05", "920px", "5m", "50%", "1.5GB", "ssh", "22", "0x73DDF",
         "7", "1_000_000", "1__0", "1_", "+42", ".5", "5.", "1e", "0755",
         "0x" + "f" * 64]

if __name__ == "__main__":
    print("fuzz mismatches (regex vs DFA vs DFA-over-chunks):", fuzz())
    print()
    for s in CASES:
        print(f"{s!r:28} -> {dfa_kind(s)}")
    print()
    adv = "4938" + "2" * 100 + "412124124124p"
    chunks = [adv[i:i + 7] for i in range(0, len(adv), 7)]
    _, h0 = emit_kind_at_close(chunks)
    print("adversarial run, length", len(adv))
    print("  kind-at-close wire: bytes held for typing =", h0,
          "; kind =", dfa_kind(adv, chunks))
    for N in (32, 64, 128):
        out, h = emit_kind_first_capped(chunks, N)
        print(f"  kind-first, cap N={N}: max held = {h}; opened as {out[0][1] if out[0][0]=='open' else [e for e in out if e[0]=='open'][0][1]}")
    big = "1" * 70
    for N in (64, 128):
        out, h = emit_kind_first_capped([big], N)
        k = [e for e in out if e[0] == "open"][0][1]
        print(f"  70-digit integer, cap N={N}: kind = {k}, held = {h}")
