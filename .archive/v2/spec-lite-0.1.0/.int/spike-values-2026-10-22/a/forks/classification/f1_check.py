"""F1 check: does classifying a bare run require holding it back?

Three claims, each tested here (run: python3 -I f1_check.py):
  1. The run's extent never depends on what it spells (the scanner below never
     consults the classifier; tested by computing extents with and without it).
  2. The classification can be computed by a finite-state machine fed the run's
     characters as they stream, with no buffer, and announced at the close
     (a "trailer"); the characters themselves are emitted as they arrive.
  3. That trailer equals the typed-primitive view's function (a whole-text
     match of the completed text), for every run: tested on a fixed battery and
     on random fuzz against Python regexes that read the completed text.

Scope (honest): the scanner models the sameline run of
[[rule:unquoted-run-is-one-value]]: it ends at a space followed by a start
(`|x`, `:x`, a framed ` ; `, a framed ` \\ `) or at the line end; embeds
`|{...}`, `@{...}`, `;{...}` are pieces (no nesting modeled). Fences, escapes
and Unicode labels are not modeled. Label-start is approximated as a letter,
`$`, `'` or `"`.
"""
import random, re, sys

# ---------- classifier: a hand-written DFA, no buffer ----------
# Set "json": nil | true | false | JSON number (RFC 8259 grammar)
# Set "quantity": additionally a JSON number followed by a unit [A-Za-z%]+ ,
#   where the unit may not begin with e/E followed by digit/sign (that is an exponent).
KW = ["nil", "true", "false"]

class Classifier:
    __slots__ = ("st", "kw", "kwpos", "allow_quantity")
    def __init__(self, allow_quantity=False):
        self.st = "start"; self.kw = None; self.kwpos = 0
        self.allow_quantity = allow_quantity
    def feed(self, c):
        s = self.st
        if s == "dead": return
        if s == "start":
            if c == "-": self.st = "sign"
            elif c == "0": self.st = "zero"
            elif c in "123456789": self.st = "int"
            elif c in "ntf":
                for k in KW:
                    if k[0] == c: self.kw, self.kwpos, self.st = k, 1, "kw"
            else: self.st = "dead"
        elif s == "kw":
            if self.kwpos < len(self.kw) and self.kw[self.kwpos] == c: self.kwpos += 1
            else: self.st = "dead"
        elif s == "sign":
            self.st = "zero" if c == "0" else ("int" if c in "123456789" else "dead")
        elif s in ("zero", "int", "frac", "exp"):
            if c.isdigit() and s != "zero": pass
            elif c == "." and s in ("zero", "int"): self.st = "dot"
            elif c in "eE" and s in ("zero", "int", "frac"): self.st = "e"
            elif self.allow_quantity and (c.isalpha() or c == "%"): self.st = "unit"
            else: self.st = "dead"
        elif s == "dot": self.st = "frac" if c.isdigit() else "dead"
        elif s == "e":
            if c in "+-": self.st = "esign"
            elif c.isdigit(): self.st = "exp"
            elif self.allow_quantity and (c.isalpha() or c == "%"): self.st = "unit"   # 2em: unit "em"
            else: self.st = "dead"
        elif s == "esign": self.st = "exp" if c.isdigit() else "dead"
        elif s == "unit":
            if not (c.isalpha() or c == "%"): self.st = "dead"
    def close(self):
        s = self.st
        if s == "kw" and self.kwpos == len(self.kw): return self.kw
        if s in ("zero", "int"): return "integer"
        if s in ("frac", "exp"): return "decimal"
        if s == "unit" or (s == "e" and self.allow_quantity): return "quantity"
        return None

# ---------- the view: a whole-text regex over the completed text ----------
NUM = r"-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?"
def view(text, allow_quantity=False):
    if text in KW: return text
    if re.fullmatch(NUM, text):
        return "decimal" if re.search(r"[.eE]", text) else "integer"
    if allow_quantity and re.fullmatch(r"-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?[A-Za-z%]+", text):
        return "quantity"
    if allow_quantity and re.fullmatch(r"-?(0|[1-9][0-9]*)(\.[0-9]+)?[eE]", text):
        return "quantity"   # "2e" : number 2, unit "e"
    return None

# ---------- scanner: run extent; emits characters as they come ----------
def is_label_start(c): return c.isalpha() or c in "$'\""

def scan_run(chars, classify=True, allow_quantity=False, sink=None):
    """chars: an iterator over the line after the value starts.
    Emits content via sink(str) as soon as it is known to be content.
    Returns (class, plain, consumed_extent_len, max_pending)."""
    it = iter(chars)
    cl = Classifier(allow_quantity) if classify else None
    pending_spaces = 0; max_pending = 0; plain = True; n = 0
    look = []  # at most 2 characters of lookahead, the start guard
    def nxt():
        if look: return look.pop(0)
        return next(it, None)
    def peek(k):
        while len(look) < k:
            c = next(it, None)
            if c is None: return None
            look.append(c)
        return look[k-1]
    def emit(s):
        nonlocal n
        n += len(s)
        if sink: sink(s)
    while True:
        c = nxt()
        if c is None: break                       # end of line
        if c == " ":
            pending_spaces += 1; max_pending = max(max_pending, pending_spaces)
            d = peek(1)
            if d is None: break                   # trailing spaces: ornament
            if d == " ": continue
            e = peek(2)
            if d in "|:" and e is not None and is_label_start(e): break   # ' |x' ' :x'
            if d in ";\\" and (e is None or e == " "): break              # framed ' ; ' ' \ '
            # internal spaces are content
            emit(" " * pending_spaces)
            if cl:
                for _ in range(pending_spaces): cl.feed(" ")
            pending_spaces = 0
            continue
        if c in "|@;" and peek(1) == "{":         # an embed: a piece, not plain
            plain = False
            body = c + nxt()
            while True:
                d = nxt()
                if d is None: raise ValueError("unclosed embed")
                body += d
                if d == "}": break
            emit(body)
            if cl: cl.st = "dead"
            continue
        emit(c)
        if cl: cl.feed(c)
    klass = cl.close() if (cl and plain) else None
    return klass, plain, n, max_pending

# ---------- tests ----------
def run_battery():
    cases = [
        ("8080", "integer"), ("-12", "integer"), ("0", "integer"), ("01234", None),
        ("1.10", "decimal"), ("9.99", "decimal"), ("1e10", "decimal"), ("1E+3", "decimal"),
        ("5.", None), (".5", None), ("+42", None), ("1_000", None), ("0xff", None),
        ("nil", "nil"), ("true", "true"), ("false", "false"), ("null", None), ("True", None),
        ("920px", None), ("7 apples", None), ("1984 is a novel", None), ("1984", "integer"),
        ("7 ;{px}", None), ("2026-10-22", None), ("10:12", None), ("60s", None),
        ("8080   ", "integer"),      # trailing spaces are ornament
    ]
    bad = 0
    for text, want in cases:
        got, plain, n, _ = scan_run(text)
        v = view(text.rstrip(" ")) if plain else None
        if got != want or got != v:
            bad += 1; print("MISMATCH", repr(text), "trailer", got, "view", v, "want", want)
    qcases = [("920px", "quantity"), ("1.5em", "quantity"), ("50%", "quantity"), ("2em", "quantity"),
              ("5m", "quantity"), ("30seconds", "quantity"), ("1e3s", "quantity"), ("4x4", None),
              ("0xff", "quantity"),   # 0 then unit "xff": a real hazard of naive quantity, noted
              ("1d12h", None), ("8080", "integer")]
    for text, want in qcases:
        got, plain, n, _ = scan_run(text, allow_quantity=True)
        v = view(text, allow_quantity=True)
        if got != want or got != v:
            bad += 1; print("MISMATCH(q)", repr(text), "trailer", got, "view", v, "want", want)
    # extent: the line ':a VALUE :b x' — extent is the same with and without classifier
    for text, _ in cases[:-1]:
        for tail in [" :b x", " |c", " ; note", " \\ more", ""]:
            a = scan_run(text + tail, classify=True)[2]
            b = scan_run(text + tail, classify=False)[2]
            if a != b: bad += 1; print("EXTENT DIFFERS", repr(text + tail))
    print("battery:", "OK" if bad == 0 else f"{bad} failures")
    return bad

def fuzz(n=200000, seed=1):
    rnd = random.Random(seed); alpha = "0123456789.-+eE_xnilutrefsapm%"
    bad = 0
    for q in (False, True):
        for _ in range(n):
            t = "".join(rnd.choice(alpha) for _ in range(rnd.randint(1, 9)))
            got = scan_run(t, allow_quantity=q)[0]
            if got != view(t, allow_quantity=q):
                bad += 1
                if bad < 10: print("FUZZ MISMATCH", q, repr(t), got, view(t, allow_quantity=q))
    print(f"fuzz: {2*n} runs,", "OK" if bad == 0 else f"{bad} mismatches")
    return bad

def streaming(nd=1_000_000):
    """A 1,000,001-character run: 4938222...2412124p. Characters are emitted as they
    arrive; the first is emitted after one character of input; nothing is buffered
    except a space count and at most 2 lookahead characters."""
    consumed = 0; first_emit_at = None; emitted = 0
    def gen():
        nonlocal consumed
        for c in "4938" + "2" * nd + "412124":
            consumed += 1; yield c
        consumed += 1; yield "p"
    def sink(s):
        nonlocal first_emit_at, emitted
        if first_emit_at is None: first_emit_at = consumed
        emitted += len(s)
    klass, plain, n, maxp = scan_run(gen(), sink=sink)
    print(f"streaming: run of {n} chars; first character emitted after {first_emit_at} consumed;"
          f" class at close = {klass}; max pending spaces = {maxp};"
          f" classifier slots = {Classifier.__slots__}")
    # same run without the trailing p: integer, still nothing held
    consumed = 0; first_emit_at = None
    def gen2():
        nonlocal consumed
        for c in "4938" + "2" * nd:
            consumed += 1; yield c
    klass2, *_ = scan_run(gen2(), sink=sink)
    print(f"streaming: same run without 'p': class at close = {klass2}; first emit after {first_emit_at}")

if __name__ == "__main__":
    b = run_battery(); f = fuzz(); streaming()
    sys.exit(1 if (b or f) else 0)
