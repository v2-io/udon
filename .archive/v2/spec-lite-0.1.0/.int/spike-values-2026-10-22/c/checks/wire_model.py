"""A model (not lite's grammar) of streaming a bare run under four wire disciplines.

The run is fed in chunks. We measure the most bytes any stage must hold before it
can emit them. The classifier is a small DFA for a strict decimal number
(-?(0|[1-9][0-9]*)(\.[0-9]+)?), plus true/false/nil; trailing spaces are counted,
not stored. This is enough to show where holdback comes from; the real number
grammar is a bigger DFA with the same property (finite state).
"""
import sys

KW = {"true", "false", "nil"}

class Classifier:
    # finite-state: states for the number DFA + a bounded keyword prefix check
    def __init__(self):
        self.st = "start"; self.kw = ""; self.kw_live = True; self.spaces = 0
    def feed(self, ch):
        if ch == " ":
            self.spaces += 1; return
        if self.spaces:  # a space followed by more content: no primitive can contain one
            self.st = "text"; self.kw_live = False; self.spaces = 0
        if self.kw_live:
            self.kw += ch
            if not any(k.startswith(self.kw) for k in KW): self.kw_live = False
        s = self.st
        if s == "text": return
        if s == "start": self.st = "sign" if ch == "-" else "zero" if ch == "0" else "int" if ch.isdigit() else "text"
        elif s == "sign": self.st = "zero" if ch == "0" else "int" if ch.isdigit() else "text"
        elif s in ("zero", "int"):
            if ch == "." : self.st = "dot"
            elif ch.isdigit() and s == "int": pass
            else: self.st = "text"
        elif s in ("dot", "frac"): self.st = "frac" if ch.isdigit() else "text"
    def kind(self):
        if self.kw_live and self.kw in KW: return self.kw
        return {"zero": "integer", "int": "integer", "frac": "float"}.get(self.st, "text")
    def could_still_be_primitive(self):
        return self.st != "text" or self.kw_live

def run(run_text, chunk=4096, cap=None):
    """Return max bytes held by: parser emitting kind-first (B-first), parser emitting
    kind-at-close (B-close), a kind-first JSON transcoder fed by B-close, and C (bare is text)."""
    c = Classifier(); held_first = 0; max_first = 0; emitted_first = False; n = 0
    for ch in run_text:  # measured per character, so chunk size can't hide holdback
        c.feed(ch); n += 1
        if cap is not None and n > cap and c.could_still_be_primitive():
            c.st = "text"; c.kw_live = False  # the spelled cap: longer runs are text
        if not emitted_first:
            if c.could_still_be_primitive():
                held_first = n  # must hold everything: kind still unknown
            else:
                emitted_first = True; held_first = 0  # kind known (text): flush and stream
        max_first = max(max_first, held_first)
    return {
        "kind": c.kind(),
        "B kind-first parser holds": max_first,
        "B kind-at-close parser holds": min(chunk, len(run_text)),  # one chunk in flight, plus O(1) DFA state
        "JSON transcoder after B-close holds": max_first,           # it must choose `"` or not: same prefix
        "C parser holds": min(chunk, len(run_text)),
    }

if __name__ == "__main__":
    N = 1_000_000
    cases = {
        "4938…2p (Joseph's)": "4" * N + "p",
        "4938…2 (an integer)": "4" * N,
        "7 apples": "7 apples",
        "text from the start": "a" * N,
        "1984 is a novel": "1984 is a novel",
    }
    for cap in (None, 64):
        print(f"--- cap = {cap}")
        for name, t in cases.items():
            r = run(t, cap=cap)
            print(f"{name:24} {r}")
