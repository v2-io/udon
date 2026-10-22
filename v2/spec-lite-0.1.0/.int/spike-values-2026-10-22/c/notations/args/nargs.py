"""Prototype of the N-args interior grammar (spike c, fork "args").

Reads one `<…>` value (or `<{…}>` prose embed) and prints its raw tree.
It is a model of the proposed rules in design.md, not lite's grammar:
  - first char after `<`: `>` -> nil; digit/sign/`.`-free number shape -> primitive (M1);
    `"`/`'` -> string primitive; letter -> a label: keyword (nil/true/false) or notation name.
  - a notation's args are items separated by whitespace, lexed as list items are:
    "…" / '…' strings, […] lists, <…> nested values, else an unquoted token that runs to
    whitespace or the closing `>`, and may hold matched [] () {} pairs inside it.
  - names: labels joined by `/` (namespace path); a `:` right after the name is an error.
  - a notation with no arguments is an error; so is a non-space character right after the closing `>`.
Bare tokens are texts (the store's lean); notations read them.
"""
import re, sys

LABEL = re.compile(r"[A-Za-z_][A-Za-z0-9_\-]*(?:/[A-Za-z_][A-Za-z0-9_\-]*)*")
NUM = re.compile(r"[+-]?(0|[1-9](_?[0-9])*)(\.[0-9](_?[0-9])*)?([eE][+-]?[0-9]+)?$|0x[0-9A-Fa-f](_?[0-9A-Fa-f])*$|0o[0-7](_?[0-7])*$|0b[01](_?[01])*$")
KW = {"nil": "nil", "true": "true::bool", "false": "false::bool"}
PAIRS = {"[": "]", "(": ")", "{": "}"}

class Err(Exception): pass

def string(s, i):
    q = s[i]; j = i + 1; out = []
    while j < len(s):
        c = s[j]
        if c == "\\" and j + 1 < len(s):
            nxt = s[j+1]
            if q == "'" and nxt not in "'\\": out.append("\\"); j += 1; continue
            out.append({"n": "\n", "t": "\t"}.get(nxt, nxt) if q == '"' else nxt); j += 2; continue
        if c == q: return '"%s"' % "".join(out), j + 1
        out.append(c); j += 1
    raise Err("unclosed string")

def token(s, i, closer):
    j = i; stack = []
    while j < len(s):
        c = s[j]
        if not stack and (c.isspace() or s.startswith(closer, j)): break
        if c in PAIRS: stack.append(PAIRS[c])
        elif stack and c == stack[-1]: stack.pop()
        elif c in "])}" and not stack: raise Err(f"unmatched {c!r} in token")
        j += 1
    if stack: raise Err("unclosed pair inside a token")
    return "‹%s›" % s[i:j], j

def item(s, i, closer):
    c = s[i]
    if c in "\"'": return string(s, i)
    if c == "[":
        j = i + 1; items = []
        while True:
            while j < len(s) and s[j].isspace(): j += 1
            if j >= len(s): raise Err("unclosed list")
            if s[j] == "]": return "[" + " ".join(items) + "]", j + 1
            v, j = item(s, j, "]"); items.append(v)
    if c == "<": return value(s, i)
    if s.startswith("|{", i):
        depth = 0; j = i
        while j < len(s):
            if s[j] == "{": depth += 1
            elif s[j] == "}":
                depth -= 1
                if depth == 0: return "element(%s)" % s[i+2:j], j + 1
            j += 1
        raise Err("unclosed |{")
    return token(s, i, closer)

def value(s, i=0):
    embed = s.startswith("<{", i)
    opener, closer = ("<{", "}>") if embed else ("<", ">")
    j = i + len(opener)
    while j < len(s) and s[j] == " ": j += 1
    if s.startswith(closer, j): return "nil", j + len(closer)
    c = s[j]
    if c in "\"'":
        v, j = string(s, j)
    elif c.isalpha() or c == "_":
        m = LABEL.match(s, j); name = m.group(0); j = m.end()
        if s.startswith("://", j): raise Err(f"`<{name}://…>` looks like a URL autolink: write the text `\\<{name}://…>`, or `<url {name}://…>` for a URL value")
        if j < len(s) and s[j] == ":": raise Err(f"`{name}:` ends in a colon: did you mean `<{name} …>`?")
        if name in KW:
            v = KW[name]
        else:
            args = []
            while True:
                k = j
                while k < len(s) and s[k].isspace(): k += 1
                if s.startswith(closer, k): j = k; break
                if k == j: raise Err(f"no space after `{name}`")
                a, j = item(s, k, closer); args.append(a)
            if not args: raise Err(f"`<{name}>` has no argument: if this is HTML or a placeholder, escape it as text (`\\<{name}>`)")
            return "nv(%s%s)" % (name, "".join(" " + a for a in args)), j + len(closer)
    else:
        v, j = token(s, j, closer)
        raw = v[1:-1]
        if not NUM.match(raw): raise Err(f"`{raw}` is not a number, nil, a boolean or a string: did you mean the text `{raw}` (unmarked), or a named notation?")
        v = raw + ("::float" if re.search(r"[.eE]", raw) and not raw.startswith("0x") else "::int")
    while j < len(s) and s[j] == " ": j += 1
    if not s.startswith(closer, j): raise Err("a marked primitive holds exactly one value")
    return v, j + len(closer)

if __name__ == "__main__":
    for line in sys.stdin:
        line = line.rstrip("\n")
        if not line or line.startswith("#"): print(line); continue
        try:
            v, j = value(line)
            if j < len(line) and not line[j].isspace():
                raise Err(f"text runs straight on after `>` ({line[j:]!r}): if this is HTML, escape the `<` as `\\<`")
            rest = line[j:].strip()
            print(f"{line:58} => {v}" + (f"   [then {rest!r}]" if rest else ""))
        except Err as e:
            print(f"{line:58} => ERROR: {e}")
