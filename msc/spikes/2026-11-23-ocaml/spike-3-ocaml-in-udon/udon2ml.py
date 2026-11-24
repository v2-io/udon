#!/usr/bin/env python3
"""
udon2ml.py — Prototype 1:1 "OCaml written in UDON" compiler (Spike 3).

Parses a genuine indentation-sensitive UDON v2 subset (elements |name[key].trait,
attributes :k v, sameline nesting, inline elements |{...}, lists [...], prose blocks
with @{ref} ubiquitous-language links, ; comments, ``` fences), lowers it directly
into idiomatic OCaml (.ml) with `# line "file.ud"` source directives, checks prose
@{...} references against declared OCaml symbols, and optionally compiles + runs via
`ocamlc`.
"""

from __future__ import annotations

import argparse
import dataclasses
from dataclasses import dataclass, field
import os
import re
import subprocess
import sys
from typing import Any


# ---------------------------------------------------------------------------
# Layer 1: UDON AST & Faithful Indentation/Sameline Parser
# ---------------------------------------------------------------------------

@dataclass
class Val:
    line: int


@dataclass
class VStr(Val):
    value: str


@dataclass
class VInt(Val):
    value: int


@dataclass
class VFloat(Val):
    value: float


@dataclass
class VBool(Val):
    value: bool


@dataclass
class VNil(Val):
    pass


@dataclass
class VList(Val):
    items: list[Val]


@dataclass
class VAngle(Val):
    raw: str


@dataclass
class VElem(Val):
    elem: "Element"


@dataclass
class VText(Val):
    raw: str


@dataclass
class Attr:
    name: str
    value: Val | None
    line: int
    col: int


@dataclass
class Node:
    line: int


@dataclass
class Prose(Node):
    text: str


@dataclass
class Comment(Node):
    text: str


@dataclass
class Fence(Node):
    name: str | None
    body: str


@dataclass
class Element(Node):
    name: str | None
    keys: list[Val] = field(default_factory=list)
    traits: list[str] = field(default_factory=list)
    attrs: list[Attr] = field(default_factory=list)
    main: list[Val] = field(default_factory=list)
    children: list[Node] = field(default_factory=list)
    col: int = 0

    def get_attr(self, name: str) -> Val | None:
        for a in self.attrs:
            if a.name == name:
                return a.value
        return None

    def get_attrs(self, name: str) -> list[Val]:
        return [a.value for a in self.attrs if a.name == name and a.value is not None]


class ParseError(Exception):
    def __init__(self, msg: str, filename: str, line: int, col: int = 0):
        super().__init__(f"{filename}:{line}:{col + 1}: UDON parse error: {msg}")
        self.filename = filename
        self.line = line
        self.col = col


LABEL_FIRST = re.compile(r"[A-Za-z_$]")
LABEL_CONT = re.compile(r"[A-Za-z0-9_\-/:?*+]")
INT_RE = re.compile(r"^-?[0-9]+$")
FLOAT_RE = re.compile(r"^-?[0-9]+\.[0-9]+$")


class LineScanner:
    """Scans a single line (or inline |{...} span) in UDON value mode."""

    def __init__(self, s: str, line: int, base_col: int, filename: str, stop_at_brace: bool = False):
        self.s = s
        self.pos = 0
        self.n = len(s)
        self.line = line
        self.base_col = base_col
        self.filename = filename
        self.stop_at_brace = stop_at_brace

    @property
    def col(self) -> int:
        return self.base_col + self.pos

    def eof(self) -> bool:
        return self.pos >= self.n or (self.stop_at_brace and self.s[self.pos] == "}")

    def peek(self, offset: int = 0) -> str:
        idx = self.pos + offset
        if idx >= self.n:
            return ""
        return self.s[idx]

    def skip_ws(self) -> int:
        start = self.pos
        while self.pos < self.n and self.s[self.pos] == " ":
            self.pos += 1
        return self.pos - start

    def at_framed_comment(self) -> bool:
        if self.pos >= self.n or self.s[self.pos] != ";":
            return False
        if self.pos + 1 < self.n and self.s[self.pos + 1] == "{":
            return False
        return self.pos + 1 == self.n or self.s[self.pos + 1] == " "

    def at_framed_backslash(self) -> bool:
        if self.pos >= self.n or self.s[self.pos] != "\\":
            return False
        return self.pos + 1 == self.n or self.s[self.pos + 1] == " "

    def at_element_start(self) -> bool:
        if self.pos >= self.n or self.s[self.pos] != "|":
            return False
        nxt = self.peek(1)
        if not nxt or nxt in (" ", "{"):
            return False
        return True

    def at_attr_start(self) -> bool:
        if self.pos >= self.n or self.s[self.pos] != ":":
            return False
        nxt = self.peek(1)
        return bool(nxt) and (bool(LABEL_FIRST.match(nxt)) or nxt in ('"', "'"))

    def parse_quoted(self) -> str:
        q = self.s[self.pos]
        start_col = self.col
        self.pos += 1
        out: list[str] = []
        while self.pos < self.n:
            ch = self.s[self.pos]
            if ch == q:
                self.pos += 1
                return "".join(out)
            if ch == "\\":
                self.pos += 1
                if self.pos >= self.n:
                    raise ParseError("unterminated escape in string", self.filename, self.line, self.col)
                esc = self.s[self.pos]
                self.pos += 1
                if q == "'":
                    if esc in ("'", "\\"):
                        out.append(esc)
                    else:
                        out.append("\\" + esc)
                else:
                    mapping = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", '"': '"', "'": "'"}
                    out.append(mapping.get(esc, esc))
            else:
                out.append(ch)
                self.pos += 1
        raise ParseError(f"unclosed {q}-string", self.filename, self.line, start_col)

    def parse_label(self) -> str:
        if self.eof():
            raise ParseError("expected label", self.filename, self.line, self.col)
        if self.s[self.pos] in ('"', "'"):
            return self.parse_quoted()
        if not LABEL_FIRST.match(self.s[self.pos]):
            raise ParseError(f"invalid label start {self.s[self.pos]!r}", self.filename, self.line, self.col)
        start = self.pos
        self.pos += 1
        while self.pos < self.n and LABEL_CONT.match(self.s[self.pos]):
            self.pos += 1
        return self.s[start:self.pos]

    def parse_key(self) -> Val:
        assert self.s[self.pos] == "["
        start_col = self.col
        self.pos += 1
        depth = 1
        start = self.pos
        while self.pos < self.n and depth > 0:
            ch = self.s[self.pos]
            if ch == "\\":
                self.pos += 2
                continue
            if ch == "[":
                depth += 1
            elif ch == "]":
                depth -= 1
                if depth == 0:
                    inner = self.s[start:self.pos].strip()
                    self.pos += 1
                    return self._parse_atom_from_str(inner, start_col + 1)
            self.pos += 1
        raise ParseError("unclosed [key]", self.filename, self.line, start_col)

    def _parse_atom_from_str(self, raw: str, col: int) -> Val:
        if not raw:
            return VText(self.line, "")
        sub = LineScanner(raw, self.line, col, self.filename)
        val = sub.parse_single_value()
        sub.skip_ws()
        if sub.eof():
            return val
        return VText(self.line, raw)

    def parse_inline_element(self) -> VElem:
        # expects "|{"
        start_col = self.col
        self.pos += 2
        self.skip_ws()
        el = self._parse_element_body(start_col, inline=True)
        if self.pos >= self.n or self.s[self.pos] != "}":
            raise ParseError("unclosed inline element |{...}", self.filename, self.line, start_col)
        self.pos += 1
        return VElem(self.line, el)

    def parse_list(self) -> VList:
        assert self.s[self.pos] == "["
        start_col = self.col
        self.pos += 1
        items: list[Val] = []
        while True:
            self.skip_ws()
            if self.pos >= self.n:
                raise ParseError("unclosed [...] list", self.filename, self.line, start_col)
            if self.s[self.pos] == "]":
                self.pos += 1
                return VList(self.line, items)
            items.append(self.parse_list_item())

    def parse_list_item(self) -> Val:
        ch = self.s[self.pos]
        if ch in ('"', "'"):
            return VStr(self.line, self.parse_quoted())
        if ch == "[":
            return self.parse_list()
        if ch == "<":
            return self.parse_angle()
        if ch == "|" and self.peek(1) == "{":
            return self.parse_inline_element()
        start = self.pos
        while self.pos < self.n and self.s[self.pos] not in (" ", "]"):
            if self.stop_at_brace and self.s[self.pos] == "}":
                break
            self.pos += 1
        tok = self.s[start:self.pos]
        return self._classify_scalar(tok)

    def parse_angle(self) -> VAngle:
        assert self.s[self.pos] == "<"
        start_col = self.col
        self.pos += 1
        depth = 1
        start = self.pos
        while self.pos < self.n and depth > 0:
            ch = self.s[self.pos]
            if ch == "\\":
                self.pos += 2
                continue
            if ch == "<":
                depth += 1
            elif ch == ">":
                depth -= 1
                if depth == 0:
                    raw = self.s[start:self.pos]
                    self.pos += 1
                    return VAngle(self.line, raw)
            self.pos += 1
        raise ParseError("unclosed <...> angle span", self.filename, self.line, start_col)

    def _classify_scalar(self, tok: str) -> Val:
        if tok == "true":
            return VBool(self.line, True)
        if tok == "false":
            return VBool(self.line, False)
        if tok == "nil":
            return VNil(self.line)
        if INT_RE.match(tok):
            return VInt(self.line, int(tok))
        if FLOAT_RE.match(tok):
            return VFloat(self.line, float(tok))
        return VText(self.line, tok)

    def parse_single_value(self) -> Val:
        """Parses one value in UDON value mode (up to next start, framed ;, framed \\, EOL, or })."""
        if self.eof():
            raise ParseError("expected value", self.filename, self.line, self.col)
        ch = self.s[self.pos]
        if ch in ('"', "'"):
            return VStr(self.line, self.parse_quoted())
        if ch == "[":
            return self.parse_list()
        if ch == "<":
            return self.parse_angle()
        if ch == "|" and self.peek(1) == "{":
            return self.parse_inline_element()
        if self.at_element_start():
            el, _ = self.parse_element()
            return VElem(self.line, el)

        # Unquoted run up to a start / framed comment / framed backslash / EOL / }
        start = self.pos
        while not self.eof():
            c = self.s[self.pos]
            if c == " ":
                # Look ahead past spaces for a terminator
                j = self.pos
                while j < self.n and self.s[j] == " ":
                    j += 1
                if j >= self.n or (self.stop_at_brace and self.s[j] == "}"):
                    break
                saved = self.pos
                self.pos = j
                is_term = (
                    self.at_element_start()
                    or self.at_attr_start()
                    or self.at_framed_comment()
                    or self.at_framed_backslash()
                    or (self.s[self.pos] == "|" and self.peek(1) == "{")
                    or self.s[self.pos] in ('"', "'", "[", "<")
                )
                self.pos = saved
                if is_term:
                    break
                self.pos = j
                continue
            if c == "|" and self.peek(1) == "{":
                break
            self.pos += 1
        raw = self.s[start:self.pos].strip()
        return self._classify_scalar(raw)

    def parse_element(self) -> tuple[Element, list[Element]]:
        """Parses |head and sameline rest, returning (element, chain_of_sameline_elements)."""
        assert self.s[self.pos] == "|"
        start_col = self.col
        self.pos += 1
        el = self._parse_element_body(start_col, inline=False)
        # Collect sameline element chain for column stack
        chain = [el]
        cur = el
        while True:
            if cur.attrs and isinstance(cur.attrs[-1].value, VElem):
                nxt = cur.attrs[-1].value.elem
                if nxt.col > cur.col:
                    chain.append(nxt)
                    cur = nxt
                    continue
            if cur.children and isinstance(cur.children[-1], Element) and cur.children[-1].line == el.line:
                nxt = cur.children[-1]
                chain.append(nxt)
                cur = nxt
                continue
            break
        return el, chain

    def _parse_element_body(self, start_col: int, inline: bool) -> Element:
        old_stop = self.stop_at_brace
        if inline:
            self.stop_at_brace = True
        try:
            name: str | None = None
            if not self.eof() and self.s[self.pos] not in ("[", ".", " "):
                name = self.parse_label()
            keys: list[Val] = []
            while not self.eof() and self.s[self.pos] == "[":
                keys.append(self.parse_key())
            traits: list[str] = []
            while not self.eof() and self.s[self.pos] == ".":
                self.pos += 1
                traits.append(self.parse_label())

            el = Element(name=name, keys=keys, traits=traits, line=self.line, col=start_col)

            while not self.eof():
                ws = self.skip_ws()
                if self.eof():
                    break
                if ws > 0 and self.at_framed_comment():
                    break
                if ws > 0 and self.at_framed_backslash():
                    self.pos += 1
                    continue
                if self.at_attr_start():
                    attr = self.parse_attr()
                    el.attrs.append(attr)
                    # Note: if attr took a bare sameline |elem, that element consumed rest of line!
                    continue
                if self.at_element_start():
                    child_el, _ = self.parse_element()
                    el.children.append(child_el)
                    break  # sameline child consumed rest of line per rule:sameline-element-is-child
                # Otherwise a value for $main
                val = self.parse_single_value()
                el.main.append(val)
            return el
        finally:
            self.stop_at_brace = old_stop

    def parse_attr(self) -> Attr:
        assert self.s[self.pos] == ":"
        acol = self.col
        self.pos += 1
        aname = self.parse_label()
        self.skip_ws()
        if self.eof() or self.at_framed_comment():
            # Value will be provided on indented lines below (_values-below)
            return Attr(name=aname, value=None, line=self.line, col=acol)
        if self.at_framed_backslash():
            self.pos += 1
            return Attr(name=aname, value=VText(self.line, ""), line=self.line, col=acol)
        val = self.parse_single_value()
        return Attr(name=aname, value=val, line=self.line, col=acol)


def parse_udon(source: str, filename: str = "<input>") -> Element:
    """Parse a complete UDON document into a $root Element."""
    lines = source.splitlines()
    root = Element(name="$root", line=1, col=-1)

    # Stack items: ("elem", col, Element) or ("attr", col, Attr)
    stack: list[tuple[str, int, Any]] = [("elem", -1, root)]

    # Pending prose accumulator attached to current top element
    prose_owner: Element | None = None
    prose_left_edge: int | None = None
    prose_lines: list[tuple[int, str]] = []  # (line_no, raw_line)

    def flush_prose() -> None:
        nonlocal prose_owner, prose_left_edge, prose_lines
        if prose_owner is not None and prose_lines:
            # Trim leading/trailing blank lines per rule:edge-blank-lines
            while prose_lines and not prose_lines[0][1].strip():
                prose_lines.pop(0)
            while prose_lines and not prose_lines[-1][1].strip():
                prose_lines.pop()
            if prose_lines:
                edge = prose_left_edge or 0
                dedented = []
                for _, raw in prose_lines:
                    if not raw.strip():
                        dedented.append("")
                    elif len(raw) >= edge and raw[:edge] == " " * edge:
                        dedented.append(raw[edge:])
                    else:
                        dedented.append(raw.lstrip(" "))
                prose_owner.children.append(Prose(line=prose_lines[0][0], text="\n".join(dedented)))
        prose_owner = None
        prose_left_edge = None
        prose_lines = []

    i = 0
    n = len(lines)
    while i < n:
        raw_line = lines[i]
        line_no = i + 1

        if not raw_line.strip():
            if prose_owner is not None:
                prose_lines.append((line_no, raw_line))
            i += 1
            continue

        # Reject leading tabs per rule:column-shifting-whitespace-error
        indent = 0
        while indent < len(raw_line) and raw_line[indent] == " ":
            indent += 1
        if indent < len(raw_line) and raw_line[indent] == "\t":
            raise ParseError("tab in indentation is forbidden in UDON", filename, line_no, indent)

        rest = raw_line[indent:]

        # If currently in prose under prose_owner and indent > prose_left_edge,
        # rule:deeper-marker-lines-are-text says even marker lines are prose!
        if prose_owner is not None and prose_left_edge is not None and indent > prose_left_edge:
            prose_lines.append((line_no, raw_line))
            i += 1
            continue

        # Check whether this line starts a block construct
        starts_comment = rest.startswith(";") and not rest.startswith(";{")
        starts_fence = rest.startswith("```") and "`" not in rest[3:]
        starts_elem = rest.startswith("|") and len(rest) > 1 and rest[1] not in (" ", "{")
        starts_attr = rest.startswith(":") and len(rest) > 1 and (bool(LABEL_FIRST.match(rest[1])) or rest[1] in ('"', "'"))

        is_structure = starts_comment or starts_fence or starts_elem or starts_attr

        if is_structure:
            flush_prose()
            # Close blocks at col >= indent
            while len(stack) > 1 and stack[-1][1] >= indent:
                stack.pop()

            top_kind, top_col, top_obj = stack[-1]

            if starts_comment:
                # Consume comment line and all deeper lines
                c_lines = [rest[1:].lstrip(" ")]
                j = i + 1
                while j < n:
                    nxt = lines[j]
                    if not nxt.strip():
                        c_lines.append("")
                        j += 1
                        continue
                    nxt_ind = len(nxt) - len(nxt.lstrip(" "))
                    if nxt_ind > indent:
                        c_lines.append(nxt[indent + 1:] if len(nxt) > indent else "")
                        j += 1
                    else:
                        break
                if top_kind == "elem":
                    top_obj.children.append(Comment(line=line_no, text="\n".join(c_lines).strip()))
                i = j
                continue

            if starts_fence:
                ticks = 0
                while ticks < len(rest) and rest[ticks] == "`":
                    ticks += 1
                tag = rest[ticks:].strip() or None
                body_lines = []
                j = i + 1
                while j < n:
                    nxt = lines[j]
                    stripped = nxt.lstrip(" ")
                    if stripped.startswith("`" * ticks) and not stripped.lstrip("`").strip():
                        j += 1
                        break
                    body_lines.append(nxt)
                    j += 1
                if top_kind == "elem":
                    top_obj.children.append(Fence(line=line_no, name=tag, body="\n".join(body_lines)))
                i = j
                continue

            if starts_attr:
                if top_kind != "elem":
                    raise ParseError("attribute cannot nest directly under another attribute", filename, line_no, indent)
                sc = LineScanner(rest, line_no, indent, filename)
                attr = sc.parse_attr()
                top_obj.attrs.append(attr)
                if attr.value is None:
                    # Expect indented value below
                    stack.append(("attr", indent, attr))
                elif isinstance(attr.value, VElem):
                    # Push sameline element chain onto stack
                    cur = attr.value.elem
                    stack.append(("elem", cur.col, cur))
                    while cur.children and isinstance(cur.children[-1], Element) and cur.children[-1].line == line_no:
                        cur = cur.children[-1]
                        stack.append(("elem", cur.col, cur))
                i += 1
                continue

            if starts_elem:
                sc = LineScanner(rest, line_no, indent, filename)
                el, chain = sc.parse_element()
                if top_kind == "attr":
                    if top_obj.value is None:
                        top_obj.value = VElem(line_no, el)
                    else:
                        raise ParseError(
                            f"attribute :{top_obj.name} already received a value; wrap multiple items in |list",
                            filename,
                            line_no,
                            indent,
                        )
                    # Pop attr now that it got its value, and push element chain
                    stack.pop()
                    for cel in chain:
                        stack.append(("elem", cel.col, cel))
                else:
                    top_obj.children.append(el)
                    for cel in chain:
                        stack.append(("elem", cel.col, cel))
                i += 1
                continue

        else:
            # Prose line!
            # First close blocks whose col >= indent (unless continuing prose under current owner)
            if prose_owner is not None and indent <= prose_owner.col:
                flush_prose()
            while len(stack) > 1 and stack[-1][1] >= indent:
                flush_prose()
                stack.pop()

            top_kind, top_col, top_obj = stack[-1]
            if top_kind == "attr":
                # Indented text value under an attribute
                if top_obj.value is None:
                    top_obj.value = VText(line_no, rest.strip())
                else:
                    if isinstance(top_obj.value, VText):
                        top_obj.value = VText(top_obj.value.line, top_obj.value.raw + "\n" + rest.strip())
                i += 1
                continue

            if prose_owner is not top_obj:
                flush_prose()
                prose_owner = top_obj
                prose_left_edge = indent
            elif prose_left_edge is not None and indent < prose_left_edge:
                prose_left_edge = indent
            prose_lines.append((line_no, raw_line))
            i += 1

    flush_prose()
    return root


# ---------------------------------------------------------------------------
# Layer 2: OCaml Lowerer + Ubiquitous-Language @{ref} Checker
# ---------------------------------------------------------------------------

INFIX_OPS = {
    "add": "+",
    "sub": "-",
    "mul": "*",
    "div": "/",
    "mod": "mod",
    "eq": "=",
    "neq": "<>",
    "lt": "<",
    "le": "<=",
    "gt": ">",
    "ge": ">=",
    "and": "&&",
    "or": "||",
    "cat": "^",
    "cons": "::",
    "append": "@",
}

NARY_OPS = {"add", "mul", "and", "or", "cat", "append"}

# Meta attributes consumed by language forms (not treated as record fields / labeled args)
STRUCT_META = {"sig", "is", "of", "type", "params", "args", "labeled", "ret", "when", "on", "from", "test", "then", "else", "pat"}


def norm_ident(name: str) -> str:
    """Normalize UDON kebab/slash/question identifier into valid OCaml identifier."""
    if "/" in name:
        return ".".join(norm_ident(part) for part in name.split("/"))
    if "." in name:
        return ".".join(norm_ident(part) for part in name.split("."))
    out = name.replace("-", "_")
    if out.endswith("?"):
        out = out[:-1] + "_q"
    return out


def norm_type_expr(raw: str) -> str:
    """Normalize kebab-case identifiers inside a type expression like 'attr-name list -> bool'."""
    def repl(m: re.Match[str]) -> str:
        tok = m.group(0)
        if tok == "->":
            return tok
        return norm_ident(tok)
    return re.sub(r"->|[A-Za-z_][A-Za-z0-9_\-/?]*", repl, raw)


def norm_var_ref(raw: str) -> str:
    """Normalize a single expression atom like 'e.attr-name' or 'List/map' or 'node'."""
    return norm_ident(raw)


def ocaml_str(s: str) -> str:
    escaped = (
        s.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\t", "\\t")
        .replace("\r", "\\r")
    )
    return f'"{escaped}"'


def clean_comment_text(s: str) -> str:
    # Escape (* and *) inside OCaml comments and rewrite @{sym} -> [sym] for odoc
    s = s.replace("(*", "( *").replace("*)", "* )")
    s = re.sub(r"@\{([^}]+)\}", lambda m: f"[{m.group(1)}]", s)
    return s


class LowerError(Exception):
    def __init__(self, msg: str, filename: str, line: int):
        super().__init__(f"{filename}:{line}: Lowering error: {msg}")
        self.filename = filename
        self.line = line


class Compiler:
    def __init__(self, filename: str, emit_line_directives: bool = True):
        self.filename = filename
        self.emit_line_directives = emit_line_directives
        self.declared_symbols: set[str] = set()
        self.prose_refs: list[tuple[int, str]] = []  # (line, raw_ref)
        self.has_tests = False

    def register_sym(self, udon_name: str) -> None:
        if not udon_name or udon_name == "_":
            return
        low = udon_name.lower()
        self.declared_symbols.add(low)
        self.declared_symbols.add(norm_ident(udon_name).lower())

    def scan_prose_refs(self, prose: Prose) -> None:
        for m in re.finditer(r"@\{([^}]+)\}", prose.text):
            self.prose_refs.append((prose.line, m.group(1).strip()))

    def check_prose_refs(self) -> list[tuple[int, str]]:
        """Return list of (line, ref) that do not resolve to any declared symbol."""
        missing: list[tuple[int, str]] = []
        for line, ref in self.prose_refs:
            candidates = {
                ref.lower(),
                norm_ident(ref).lower(),
            }
            # Simple English plural tolerance: @{nodes} -> node, @{entries} -> entry
            if ref.lower().endswith("s"):
                base = ref[:-1]
                candidates.add(base.lower())
                candidates.add(norm_ident(base).lower())
            if ref.lower().endswith("ies"):
                base = ref[:-3] + "y"
                candidates.add(base.lower())
                candidates.add(norm_ident(base).lower())
            if not (candidates & self.declared_symbols):
                missing.append((line, ref))
        return missing

    def line_dir(self, line: int) -> str:
        if not self.emit_line_directives:
            return ""
        return f'# {line} "{self.filename}"\n'

    def _key_str(self, el: Element, idx: int = 0) -> str:
        if idx >= len(el.keys):
            raise LowerError(f"|{el.name} requires a [name] key", self.filename, el.line)
        k = el.keys[idx]
        if isinstance(k, (VText, VStr)):
            return k.raw if isinstance(k, VText) else k.value
        raise LowerError(f"|{el.name} key must be a name", self.filename, el.line)

    def _val_as_type(self, v: Val) -> str:
        if isinstance(v, VText):
            return norm_type_expr(v.raw)
        if isinstance(v, VAngle):
            return norm_type_expr(v.raw)
        if isinstance(v, VStr):
            return norm_type_expr(v.value)
        raise LowerError(f"expected type expression, got {type(v).__name__}", self.filename, v.line)

    def _val_as_ident_list(self, v: Val) -> list[str]:
        if isinstance(v, VList):
            out = []
            for item in v.items:
                if isinstance(item, VText):
                    out.append(item.raw)
                elif isinstance(item, VStr):
                    out.append(item.value)
                else:
                    raise LowerError("expected identifier in list", self.filename, item.line)
            return out
        if isinstance(v, VText):
            return v.raw.split()
        raise LowerError("expected identifier list [...]", self.filename, v.line)

    def compile_document(self, root: Element) -> str:
        # First pass: detect whether any |test[...] exists
        self._detect_tests(root)
        # Collect declared symbols up-front for ubiquitous-language reference checking
        self._collect_symbols(root)

        parts: list[str] = []
        parts.append(f"(* Generated from {self.filename} by udon2ml.py *)\n")
        if self.has_tests:
            parts.append(
                "let __udon_pass = ref 0\n"
                "let __udon_fail = ref 0\n"
                "let __udon_run_test name f =\n"
                "  try\n"
                "    f ();\n"
                "    incr __udon_pass;\n"
                "    Printf.printf \"  [PASS] %s\\n\" name\n"
                "  with exn ->\n"
                "    incr __udon_fail;\n"
                "    Printf.printf \"  [FAIL] %s: %s\\n\" name (Printexc.to_string exn)\n\n"
            )

        for child in root.children:
            code = self.lower_struct_item(child, indent="")
            if code:
                parts.append(code)

        if self.has_tests:
            parts.append(
                "\nlet () =\n"
                "  Printf.printf \"Summary: %d passed, %d failed\\n\" !__udon_pass !__udon_fail;\n"
                "  if !__udon_fail > 0 then exit 1\n"
            )
        return "".join(parts)

    def _detect_tests(self, el: Element) -> None:
        if el.name == "test":
            self.has_tests = True
        for ch in el.children:
            if isinstance(ch, Element):
                self._detect_tests(ch)

    def _collect_symbols(self, node: Node) -> None:
        if isinstance(node, Prose):
            self.scan_prose_refs(node)
            return
        if not isinstance(node, Element):
            return
        if node.name in ("module", "sig", "functor", "type", "fn", "let", "val", "field", "arg", "param"):
            if node.keys:
                k = node.keys[0]
                if isinstance(k, VText):
                    self.register_sym(k.raw)
            if node.name == "type":
                if "record" in node.traits:
                    for a in node.attrs:
                        if a.name not in STRUCT_META:
                            self.register_sym(a.name)
                if "variant" in node.traits:
                    for ch in node.children:
                        if isinstance(ch, Element) and ch.name:
                            self.register_sym(ch.name)
                            for a in ch.attrs:
                                if a.name not in STRUCT_META:
                                    self.register_sym(a.name)
            if node.name == "fn":
                for attr_name in ("args", "labeled"):
                    av = node.get_attr(attr_name)
                    if av is not None:
                        for p in self._val_as_ident_list(av):
                            self.register_sym(p)
        for ch in node.children:
            self._collect_symbols(ch)

    # -- Structure items -----------------------------------------------------

    def lower_struct_item(self, node: Node, indent: str) -> str:
        if isinstance(node, Prose):
            return f"{indent}(** {clean_comment_text(node.text)} *)\n\n"
        if isinstance(node, Comment):
            return f"{indent}(* {clean_comment_text(node.text)} *)\n"
        if isinstance(node, Fence):
            if node.name == "ocaml":
                return self.line_dir(node.line) + node.body + "\n\n"
            return f"{indent}(* fence:{node.name or ''} *)\n"
        assert isinstance(node, Element)

        name = node.name
        if name == "open":
            mod = norm_ident(self._key_str(node))
            return f"{self.line_dir(node.line)}{indent}open {mod}\n\n"
        if name == "include":
            mod = norm_ident(self._key_str(node))
            return f"{self.line_dir(node.line)}{indent}include {mod}\n\n"
        if name == "sig":
            return self.lower_sig(node, indent)
        if name == "module":
            return self.lower_module(node, indent)
        if name == "functor":
            return self.lower_functor(node, indent)
        if name == "type":
            return self.lower_type(node, indent, in_sig=False)
        if name == "fn":
            return self.lower_fn_top(node, indent)
        if name == "let":
            return self.lower_let_top(node, indent)
        if name == "test":
            return self.lower_test(node, indent)
        if name == "main":
            body = self.lower_block(node.children, indent + "  ")
            return f"{self.line_dir(node.line)}{indent}let () =\n{body}\n\n"

        raise LowerError(f"unsupported top-level/structure element |{name}", self.filename, node.line)

    def lower_sig(self, el: Element, indent: str) -> str:
        sname = norm_ident(self._key_str(el))
        out = [self.line_dir(el.line), f"{indent}module type {sname} = sig\n"]
        for ch in el.children:
            if isinstance(ch, Prose):
                out.append(f"{indent}  (** {clean_comment_text(ch.text)} *)\n\n")
            elif isinstance(ch, Comment):
                out.append(f"{indent}  (* {clean_comment_text(ch.text)} *)\n")
            elif isinstance(ch, Element):
                if ch.name == "type":
                    out.append(self.lower_type(ch, indent + "  ", in_sig=True))
                elif ch.name == "val":
                    vname = norm_ident(self._key_str(ch))
                    tv = ch.get_attr("type")
                    if tv is None:
                        raise LowerError(f"|val[{vname}] requires :type", self.filename, ch.line)
                    doc = self._leading_doc(ch, indent + "  ")
                    out.append(doc)
                    out.append(f"{self.line_dir(ch.line)}{indent}  val {vname} : {self._val_as_type(tv)}\n\n")
                elif ch.name == "include":
                    out.append(f"{indent}  include {norm_ident(self._key_str(ch))}\n")
                else:
                    raise LowerError(f"unsupported |sig item |{ch.name}", self.filename, ch.line)
        out.append(f"{indent}end\n\n")
        return "".join(out)

    def lower_module(self, el: Element, indent: str) -> str:
        mname = norm_ident(self._key_str(el))
        sig_v = el.get_attr("sig")
        sig_ann = f" : {norm_ident(sig_v.raw)}" if isinstance(sig_v, VText) else ""
        out = [self.line_dir(el.line), f"{indent}module {mname}{sig_ann} = struct\n"]
        for ch in el.children:
            out.append(self.lower_struct_item(ch, indent + "  "))
        out.append(f"{indent}end\n\n")
        return "".join(out)

    def lower_functor(self, el: Element, indent: str) -> str:
        mname = norm_ident(self._key_str(el))
        params: list[str] = []
        body_items: list[Node] = []
        for ch in el.children:
            if isinstance(ch, Element) and ch.name == "param":
                pname = norm_ident(self._key_str(ch))
                psig = ch.get_attr("sig")
                if not isinstance(psig, VText):
                    raise LowerError(f"|param[{pname}] requires :sig", self.filename, ch.line)
                params.append(f"({pname} : {norm_ident(psig.raw)})")
            else:
                body_items.append(ch)
        sig_v = el.get_attr("sig")
        sig_ann = f" : {norm_ident(sig_v.raw)}" if isinstance(sig_v, VText) else ""
        out = [self.line_dir(el.line), f"{indent}module {mname} {' '.join(params)}{sig_ann} = struct\n"]
        for ch in body_items:
            out.append(self.lower_struct_item(ch, indent + "  "))
        out.append(f"{indent}end\n\n")
        return "".join(out)

    def _leading_doc(self, el: Element, indent: str) -> str:
        docs = [clean_comment_text(ch.text) for ch in el.children if isinstance(ch, Prose)]
        if not docs:
            return ""
        joined = "\n\n".join(docs)
        return f"{indent}(** {joined} *)\n"

    def lower_type(self, el: Element, indent: str, in_sig: bool) -> str:
        tname = norm_ident(self._key_str(el))
        kw = "and" if "and" in el.traits else "type"
        pv = el.get_attr("params")
        tparams = ""
        if pv is not None:
            ps = [f"'{norm_ident(p)}" for p in self._val_as_ident_list(pv)]
            tparams = (ps[0] + " ") if len(ps) == 1 else f"({', '.join(ps)}) "

        doc = self._leading_doc(el, indent)
        prefix = f"{doc}{self.line_dir(el.line)}"

        # Alias
        is_v = el.get_attr("is")
        if is_v is not None:
            return f"{prefix}{indent}{kw} {tparams}{tname} = {self._val_as_type(is_v)}\n\n"

        # Record
        if "record" in el.traits:
            fields_out: list[str] = []
            for a in el.attrs:
                if a.name in STRUCT_META:
                    continue
                if a.value is None:
                    raise LowerError(f"record field :{a.name} missing type", self.filename, a.line)
                fields_out.append(f"{indent}  {norm_ident(a.name)} : {self._val_as_type(a.value)};\n")
            for ch in el.children:
                if isinstance(ch, Element) and ch.name == "field":
                    fname = norm_ident(self._key_str(ch))
                    ftv = ch.get_attr("type")
                    if ftv is None:
                        raise LowerError(f"|field[{fname}] missing :type", self.filename, ch.line)
                    fdoc = self._leading_doc(ch, indent + "  ")
                    fields_out.append(f"{fdoc}{indent}  {fname} : {self._val_as_type(ftv)};\n")
            return f"{prefix}{indent}{kw} {tparams}{tname} = {{\n{''.join(fields_out)}{indent}}}\n\n"

        # Variant / ADT
        if "variant" in el.traits:
            arms: list[str] = []
            for ch in el.children:
                if isinstance(ch, Prose):
                    continue
                if isinstance(ch, Comment):
                    arms.append(f"{indent}  (* {clean_comment_text(ch.text)} *)\n")
                    continue
                if not isinstance(ch, Element) or not ch.name:
                    raise LowerError("variant constructor must be an |Element", self.filename, ch.line)
                cname = norm_ident(ch.name)
                cdoc_parts = [clean_comment_text(x.text) for x in ch.children if isinstance(x, Prose)]
                cdoc = f" (** {' '.join(cdoc_parts)} *)" if cdoc_parts else ""
                of_v = ch.get_attr("of")
                rec_attrs = [a for a in ch.attrs if a.name not in STRUCT_META]
                rec_fields = [x for x in ch.children if isinstance(x, Element) and x.name == "field"]
                if "record" in ch.traits or rec_attrs or rec_fields:
                    f_lines = []
                    for a in rec_attrs:
                        if a.value is None:
                            raise LowerError(f"inline record field :{a.name} missing type", self.filename, a.line)
                        f_lines.append(f"{indent}      {norm_ident(a.name)} : {self._val_as_type(a.value)};\n")
                    for rf in rec_fields:
                        fn = norm_ident(self._key_str(rf))
                        ft = rf.get_attr("type")
                        if ft is None:
                            raise LowerError(f"|field[{fn}] missing :type", self.filename, rf.line)
                        f_lines.append(f"{indent}      {fn} : {self._val_as_type(ft)};\n")
                    arms.append(f"{indent}  | {cname} of {{\n{''.join(f_lines)}{indent}    }}{cdoc}\n")
                elif of_v is not None:
                    arms.append(f"{indent}  | {cname} of {self._val_as_type(of_v)}{cdoc}\n")
                else:
                    arms.append(f"{indent}  | {cname}{cdoc}\n")
            return f"{prefix}{indent}{kw} {tparams}{tname} =\n{''.join(arms)}\n"

        if in_sig:
            return f"{prefix}{indent}{kw} {tparams}{tname}\n\n"
        raise LowerError(f"|type[{tname}] needs .record, .variant, or :is", self.filename, el.line)

    def _fn_params_and_body(self, el: Element) -> tuple[str, list[Node]]:
        params: list[str] = []
        # Labeled params from :labeled [...]
        lab_v = el.get_attr("labeled")
        if lab_v is not None:
            for p in self._val_as_ident_list(lab_v):
                params.append(f"~{norm_ident(p)}")
        # Positional params from :args [...]
        args_v = el.get_attr("args")
        if args_v is not None:
            for p in self._val_as_ident_list(args_v):
                params.append(norm_ident(p))

        body_nodes: list[Node] = []
        for ch in el.children:
            if isinstance(ch, Element) and ch.name == "arg":
                aname = norm_ident(self._key_str(ch))
                atv = ch.get_attr("type")
                is_lab = "labeled" in ch.traits
                if is_lab:
                    if atv is not None:
                        params.append(f"~({aname} : {self._val_as_type(atv)})")
                    else:
                        params.append(f"~{aname}")
                else:
                    if atv is not None:
                        params.append(f"({aname} : {self._val_as_type(atv)})")
                    else:
                        params.append(aname)
            else:
                body_nodes.append(ch)
        if not params:
            params = ["()"]
        return " ".join(params), body_nodes

    def lower_fn_top(self, el: Element, indent: str) -> str:
        fname = norm_ident(self._key_str(el))
        kw = "and" if "and" in el.traits else ("let rec" if "rec" in el.traits else "let")
        param_str, body_nodes = self._fn_params_and_body(el)
        ret_v = el.get_attr("ret")
        ret_ann = f" : {self._val_as_type(ret_v)}" if ret_v is not None else ""

        # Extract top-level prose doc comments before first code child
        docs: list[str] = []
        expr_nodes: list[Node] = []
        seen_code = False
        for n in body_nodes:
            if not seen_code and isinstance(n, Prose):
                docs.append(clean_comment_text(n.text))
            else:
                seen_code = True
                expr_nodes.append(n)
        doc_str = f"{indent}(** {' '.join(docs)} *)\n" if docs else ""
        is_v = el.get_attr("is")
        if is_v is not None:
            body = indent + "  " + self.lower_val(is_v, indent + "  ")
        else:
            body = self.lower_block(expr_nodes, indent + "  ")
        return f"{doc_str}{self.line_dir(el.line)}{indent}{kw} {fname} {param_str}{ret_ann} =\n{body}\n\n"

    def lower_let_top(self, el: Element, indent: str) -> str:
        lname = norm_ident(self._key_str(el))
        kw = "and" if "and" in el.traits else ("let rec" if "rec" in el.traits else "let")
        tv = el.get_attr("type")
        t_ann = f" : {self._val_as_type(tv)}" if tv is not None else ""
        docs: list[str] = []
        expr_nodes: list[Node] = []
        seen_code = False
        for n in el.children:
            if not seen_code and isinstance(n, Prose):
                docs.append(clean_comment_text(n.text))
            else:
                seen_code = True
                expr_nodes.append(n)
        doc_str = f"{indent}(** {' '.join(docs)} *)\n" if docs else ""
        rhs = self._rhs_of_let(el, expr_nodes, indent + "  ")
        return f"{doc_str}{self.line_dir(el.line)}{indent}{kw} {lname}{t_ann} =\n{rhs}\n\n"

    def lower_test(self, el: Element, indent: str) -> str:
        tname = self._key_str(el)
        body = self.lower_block(el.children, indent + "  ")
        return (
            f"{self.line_dir(el.line)}{indent}let () = __udon_run_test {ocaml_str(tname)} (fun () ->\n"
            f"{body}\n"
            f"{indent})\n\n"
        )

    # -- Expressions & Blocks ------------------------------------------------

    def _rhs_of_let(self, el: Element, expr_nodes: list[Node], indent: str) -> str:
        is_v = el.get_attr("is")
        if is_v is not None:
            return indent + self.lower_val(is_v, indent)
        if el.main:
            return indent + self.lower_main_expr(el.main, indent)
        if expr_nodes:
            return self.lower_block(expr_nodes, indent)
        raise LowerError(f"|let[{el.keys}] has no value", self.filename, el.line)

    def lower_block(self, nodes: list[Node], indent: str) -> str:
        """Lower a sequence of sibling nodes inside an expression block (let-chains, do, prose comments, final expr)."""
        lines: list[str] = []
        # Find last non-prose, non-comment node
        code_indices = [idx for idx, n in enumerate(nodes) if isinstance(n, Element)]
        if not code_indices:
            return f"{indent}()"
        last_code_idx = code_indices[-1]

        for idx, n in enumerate(nodes):
            if isinstance(n, Prose):
                lines.append(f"{indent}(* {clean_comment_text(n.text)} *)")
                continue
            if isinstance(n, Comment):
                lines.append(f"{indent}(* {clean_comment_text(n.text)} *)")
                continue
            if isinstance(n, Fence):
                if n.name == "ocaml":
                    lines.append(f"{indent}({n.body})")
                continue
            assert isinstance(n, Element)
            is_last = idx == last_code_idx

            if n.name == "let":
                lname = norm_ident(self._key_str(n))
                kw = "let rec" if "rec" in n.traits else "let"
                tv = n.get_attr("type")
                t_ann = f" : {self._val_as_type(tv)}" if tv is not None else ""
                rhs = self._rhs_of_let(n, n.children, indent + "  ").strip()
                lines.append(f"{self.line_dir(n.line)}{indent}{kw} {lname}{t_ann} = {rhs} in")
                if is_last:
                    lines.append(f"{indent}()")
            elif n.name == "fn":
                fname = norm_ident(self._key_str(n))
                kw = "and" if "and" in n.traits else ("let rec" if "rec" in n.traits else "let")
                param_str, body_nodes = self._fn_params_and_body(n)
                ret_v = n.get_attr("ret")
                ret_ann = f" : {self._val_as_type(ret_v)}" if ret_v is not None else ""
                body = self.lower_block(body_nodes, indent + "  ")
                # Peek if next code node is |fn.and
                next_is_and = False
                for nxt in nodes[idx + 1:]:
                    if isinstance(nxt, Element):
                        next_is_and = (nxt.name == "fn" and "and" in nxt.traits)
                        break
                trailer = "" if next_is_and else " in"
                lines.append(f"{self.line_dir(n.line)}{indent}{kw} {fname} {param_str}{ret_ann} =\n{body}{trailer}")
                if is_last:
                    lines.append(f"{indent}()")
            elif n.name == "do":
                e = self._single_expr_from_elem(n, indent)
                lines.append(f"{indent}{e}{'' if is_last else ';'}")
            elif n.name == "assert":
                e = self._single_expr_from_elem(n, indent)
                lines.append(f"{self.line_dir(n.line)}{indent}assert ({e}){'' if is_last else ';'}")
            else:
                e = self.lower_expr_elem(n, indent)
                lines.append(f"{indent}{e}{'' if is_last else ';'}")
        return "\n".join(lines)

    def _single_expr_from_elem(self, el: Element, indent: str) -> str:
        is_v = el.get_attr("is")
        if is_v is not None:
            return self.lower_val(is_v, indent)
        if el.main:
            return self.lower_main_expr(el.main, indent)
        code_children = [c for c in el.children if isinstance(c, Element)]
        if len(code_children) == 1:
            return self.lower_expr_elem(code_children[0], indent)
        if code_children:
            return "(\n" + self.lower_block(el.children, indent + "  ") + f"\n{indent})"
        raise LowerError(f"|{el.name} requires an expression", self.filename, el.line)

    def lower_val(self, v: Val, indent: str) -> str:
        if isinstance(v, VStr):
            return ocaml_str(v.value)
        if isinstance(v, VInt):
            return f"({v.value})" if v.value < 0 else str(v.value)
        if isinstance(v, VFloat):
            return f"({v.value})" if v.value < 0 else str(v.value)
        if isinstance(v, VBool):
            return "true" if v.value else "false"
        if isinstance(v, VNil):
            return "None"
        if isinstance(v, VList):
            items = [self.lower_val(it, indent) for it in v.items]
            return "[" + "; ".join(items) + "]"
        if isinstance(v, VAngle):
            return f"({v.raw})"
        if isinstance(v, VElem):
            return self.lower_expr_elem(v.elem, indent)
        if isinstance(v, VText):
            toks = v.raw.split()
            if len(toks) == 1:
                return norm_var_ref(toks[0])
            return "(" + " ".join(norm_var_ref(t) for t in toks) + ")"
        raise LowerError(f"unknown value {v!r}", self.filename, v.line)

    def lower_main_args(self, vals: list[Val], indent: str) -> list[str]:
        out: list[str] = []
        for v in vals:
            if isinstance(v, VText):
                for tok in v.raw.split():
                    out.append(self._atom_from_tok(tok))
            else:
                out.append(self.lower_val(v, indent))
        return out

    def _atom_from_tok(self, tok: str) -> str:
        if tok == "true":
            return "true"
        if tok == "false":
            return "false"
        if tok == "nil":
            return "None"
        if INT_RE.match(tok):
            return f"({tok})" if tok.startswith("-") else tok
        if FLOAT_RE.match(tok):
            return f"({tok})" if tok.startswith("-") else tok
        return norm_var_ref(tok)

    def lower_main_expr(self, vals: list[Val], indent: str) -> str:
        args = self.lower_main_args(vals, indent)
        if len(args) == 1:
            return args[0]
        return "(" + " ".join(args) + ")"

    def lower_expr_elem(self, el: Element, indent: str) -> str:
        name = el.name or ""

        if name == "val":
            return self._single_expr_from_elem(el, indent)

        if name == "begin":
            return "(\n" + self.lower_block(el.children, indent + "  ") + f"\n{indent})"

        if name == "fun":
            params: list[str] = []
            for k in el.keys:
                if isinstance(k, VText):
                    params.append(norm_ident(k.raw))
            av = el.get_attr("args")
            if av is not None:
                params.extend(norm_ident(p) for p in self._val_as_ident_list(av))
            if not params:
                params = ["()"]
            is_v = el.get_attr("is")
            if is_v is not None:
                body = self.lower_val(is_v, indent + "  ")
                return f"(fun {' '.join(params)} -> {body})"
            if el.main:
                body = self.lower_main_expr(el.main, indent + "  ")
                return f"(fun {' '.join(params)} -> {body})"
            code_kids = [c for c in el.children if isinstance(c, Element)]
            if len(code_kids) == 1 and len(el.children) == 1 and code_kids[0].line == el.line:
                body = self.lower_expr_elem(code_kids[0], indent + "  ")
                return f"(fun {' '.join(params)} -> {body})"
            body = self.lower_block(el.children, indent + "  ")
            return f"(fun {' '.join(params)} ->\n{body}\n{indent})"

        if name == "list":
            items = self.lower_main_args(el.main, indent)
            for ch in el.children:
                if isinstance(ch, Element):
                    items.append(self.lower_expr_elem(ch, indent + "  "))
            if not items:
                return "[]"
            if len(items) <= 3 and all("\n" not in it for it in items):
                return "[" + "; ".join(items) + "]"
            sep = f";\n{indent}  "
            return f"[\n{indent}  " + sep.join(items) + f"\n{indent}]"

        if name == "record":
            f_strs = []
            for a in el.attrs:
                if a.name in STRUCT_META:
                    continue
                if a.value is None:
                    raise LowerError(f"|record field :{a.name} missing value", self.filename, a.line)
                f_strs.append(f"{norm_ident(a.name)} = {self.lower_val(a.value, indent + '  ')}")
            rec_body = "{ " + "; ".join(f_strs) + " }" if all("\n" not in s for s in f_strs) and len(f_strs) <= 3 else (
                "{\n" + "".join(f"{indent}  {s};\n" for s in f_strs) + f"{indent}}}"
            )
            if el.keys:
                tname = norm_ident(self._key_str(el))
                return f"({rec_body} : {tname})"
            return rec_body

        if name == "update":
            base = norm_var_ref(self._key_str(el))
            f_strs = []
            for a in el.attrs:
                if a.name in STRUCT_META:
                    continue
                if a.value is None:
                    raise LowerError(f"|update field :{a.name} missing value", self.filename, a.line)
                f_strs.append(f"{norm_ident(a.name)} = {self.lower_val(a.value, indent + '  ')}")
            return f"{{ {base} with {'; '.join(f_strs)} }}"

        if name == "if":
            return self.lower_if(el, indent)

        if name == "cond":
            return self.lower_cond(el, indent)

        if name == "match":
            return self.lower_match(el, indent)

        if name == "pipe":
            return self.lower_pipe(el, indent)

        if name == "not":
            args = self._collect_call_pos_args(el, indent)
            if len(args) != 1:
                raise LowerError("|not expects 1 argument", self.filename, el.line)
            return f"(not ({args[0]}))"

        if name in INFIX_OPS:
            op = INFIX_OPS[name]
            args = self._collect_call_pos_args(el, indent)
            if len(args) < 2:
                raise LowerError(f"|{name} expects at least 2 arguments, got {len(args)}", self.filename, el.line)
            if len(args) > 2 and name not in NARY_OPS:
                raise LowerError(f"|{name} expects 2 arguments, got {len(args)}", self.filename, el.line)
            return "(" + f" {op} ".join(f"({a})" if " " in a and not (a.startswith("(") and a.endswith(")")) else a for a in args) + ")"

        # Uppercase -> Variant constructor!
        if name and name[0].isupper() and "/" not in name:
            cname = norm_ident(name)
            rec_attrs = [a for a in el.attrs if a.name not in STRUCT_META]
            if rec_attrs:
                f_strs = []
                for a in rec_attrs:
                    if a.value is None:
                        raise LowerError(f"|{cname} field :{a.name} missing value", self.filename, a.line)
                    f_strs.append(f"{norm_ident(a.name)} = {self.lower_val(a.value, indent + '  ')}")
                return f"({cname} {{ {'; '.join(f_strs)} }})"
            args = self._collect_call_pos_args(el, indent)
            if not args:
                return cname
            if len(args) == 1:
                arg = args[0]
                if " " in arg and not (arg.startswith("(") and arg.endswith(")")) and not (arg.startswith("[") and arg.endswith("]")):
                    arg = f"({arg})"
                return f"({cname} {arg})"
            raise LowerError(f"constructor |{cname} expects 0 or 1 payload (or inline record attrs), got {len(args)}", self.filename, el.line)

        # General function application (including Module/func and labeled :attr args!)
        fn_name = norm_ident(name)
        parts = [fn_name]
        # Labeled args from attributes
        for a in el.attrs:
            if a.name in STRUCT_META:
                continue
            if a.value is None:
                raise LowerError(f"|{name} labeled arg :{a.name} missing value", self.filename, a.line)
            val_s = self.lower_val(a.value, indent + "  ")
            parts.append(f"~{norm_ident(a.name)}:({val_s})")
        # Positional args from $main + child elements
        for arg in self._collect_call_pos_args(el, indent):
            if " " in arg and not (arg.startswith("(") and arg.endswith(")")) and not (arg.startswith("[") and arg.endswith("]")) and not (arg.startswith("{") and arg.endswith("}")):
                arg = f"({arg})"
            parts.append(arg)
        if len(parts) == 1:
            return fn_name
        return "(" + " ".join(parts) + ")"

    def _collect_call_pos_args(self, el: Element, indent: str) -> list[str]:
        args = self.lower_main_args(el.main, indent)
        for ch in el.children:
            if isinstance(ch, Element):
                args.append(self.lower_expr_elem(ch, indent + "  "))
        return args

    def lower_if(self, el: Element, indent: str) -> str:
        test_v = el.get_attr("test")
        then_v = el.get_attr("then")
        else_v = el.get_attr("else")

        cond_s: str | None = None
        then_s: str | None = None
        else_s: str | None = None

        if test_v is not None:
            cond_s = self.lower_val(test_v, indent + "  ")
        elif el.main:
            cond_s = self.lower_main_expr(el.main, indent + "  ")

        if then_v is not None:
            then_s = self.lower_val(then_v, indent + "  ")
        if else_v is not None:
            else_s = self.lower_val(else_v, indent + "  ")

        for ch in el.children:
            if not isinstance(ch, Element):
                continue
            if ch.name == "then":
                then_s = self._branch_body(ch, indent + "  ")
            elif ch.name == "else":
                else_s = self._branch_body(ch, indent + "  ")
            elif cond_s is None:
                cond_s = self.lower_expr_elem(ch, indent + "  ")

        if cond_s is None or then_s is None or else_s is None:
            raise LowerError("|if requires condition, |then, and |else", self.filename, el.line)
        return f"(if {cond_s} then\n{then_s}\n{indent}else\n{else_s})"

    def lower_cond(self, el: Element, indent: str) -> str:
        branches: list[tuple[str | None, str]] = []
        for ch in el.children:
            if not isinstance(ch, Element):
                continue
            if ch.name == "when":
                tv = ch.get_attr("test")
                if tv is not None:
                    c = self.lower_val(tv, indent + "  ")
                    b = self._branch_body(ch, indent + "  ")
                elif ch.main:
                    c = self.lower_main_expr(ch.main, indent + "  ")
                    b = self._branch_body(ch, indent + "  ")
                else:
                    # Sameline child is condition, remaining children are body
                    elems = [x for x in ch.children if isinstance(x, Element)]
                    if not elems:
                        raise LowerError("|when requires a condition", self.filename, ch.line)
                    c = self.lower_expr_elem(elems[0], indent + "  ")
                    rest_nodes = [x for x in ch.children if x is not elems[0]]
                    is_v = ch.get_attr("is")
                    if is_v is not None:
                        b = self.lower_val(is_v, indent + "  ")
                    else:
                        b = self.lower_block(rest_nodes, indent + "  ")
                branches.append((c, b))
            elif ch.name == "else":
                branches.append((None, self._branch_body(ch, indent + "  ")))
        if not branches or branches[-1][0] is not None:
            raise LowerError("|cond requires a final |else branch", self.filename, el.line)
        out = []
        for idx, (c, b) in enumerate(branches):
            if idx == 0:
                out.append(f"(if {c} then\n{indent}  {b}")
            elif c is not None:
                out.append(f"\n{indent}else if {c} then\n{indent}  {b}")
            else:
                out.append(f"\n{indent}else\n{indent}  {b})")
        return "".join(out)

    def _branch_body(self, el: Element, indent: str) -> str:
        is_v = el.get_attr("is")
        if is_v is not None:
            return indent + self.lower_val(is_v, indent)
        if el.main:
            return indent + self.lower_main_expr(el.main, indent)
        return self.lower_block(el.children, indent)

    def lower_pipe(self, el: Element, indent: str) -> str:
        from_v = el.get_attr("from")
        stages: list[str] = []
        if from_v is not None:
            init = self.lower_val(from_v, indent + "  ")
        elif el.main:
            init = self.lower_main_expr(el.main, indent + "  ")
        else:
            code_kids = [c for c in el.children if isinstance(c, Element)]
            if not code_kids:
                raise LowerError("|pipe requires an initial expression", self.filename, el.line)
            init = self.lower_expr_elem(code_kids[0], indent + "  ")
            stages = [self.lower_expr_elem(c, indent + "  ") for c in code_kids[1:]]
            return "(" + f"\n{indent}  |> ".join([init] + stages) + ")"

        for ch in el.children:
            if isinstance(ch, Element):
                stages.append(self.lower_expr_elem(ch, indent + "  "))
        return "(" + f"\n{indent}  |> ".join([init] + stages) + ")"

    def lower_match(self, el: Element, indent: str) -> str:
        on_v = el.get_attr("on")
        arm_nodes: list[Node] = []
        if on_v is not None:
            scrut = self.lower_val(on_v, indent + "  ")
            arm_nodes = el.children
        elif el.main:
            scrut = self.lower_main_expr(el.main, indent + "  ")
            arm_nodes = el.children
        else:
            # First sameline child is scrutinee
            if el.children and isinstance(el.children[0], Element) and el.children[0].line == el.line:
                scrut = self.lower_expr_elem(el.children[0], indent + "  ")
                arm_nodes = el.children[1:]
            else:
                raise LowerError("|match requires a scrutinee", self.filename, el.line)

        arms_out: list[str] = []
        for ch in arm_nodes:
            if isinstance(ch, Prose):
                arms_out.append(f"{indent}  (* {clean_comment_text(ch.text)} *)\n")
                continue
            if isinstance(ch, Comment):
                arms_out.append(f"{indent}  (* {clean_comment_text(ch.text)} *)\n")
                continue
            assert isinstance(ch, Element)
            pat = self.lower_pattern_elem(ch)
            when_v = ch.get_attr("when")
            guard = f" when {self.lower_val(when_v, indent + '    ')}" if when_v is not None else ""
            is_v = ch.get_attr("is")
            if is_v is not None:
                body = self.lower_val(is_v, indent + "    ")
                arms_out.append(f"{self.line_dir(ch.line)}{indent}  | {pat}{guard} -> {body}\n")
            else:
                body = self.lower_block(ch.children, indent + "    ")
                arms_out.append(f"{self.line_dir(ch.line)}{indent}  | {pat}{guard} ->\n{body}\n")
        return f"(match {scrut} with\n{''.join(arms_out)}{indent})"

    def lower_pattern_elem(self, el: Element) -> str:
        name = el.name or ""
        if name in ("_", "default"):
            if el.keys:
                return norm_ident(self._key_str(el))
            return "_"
        if name == "empty":
            return "[]"
        if name == "true":
            return "true"
        if name == "false":
            return "false"
        if name == "cons":
            h = norm_ident(self._key_str(el, 0))
            t = norm_ident(self._key_str(el, 1))
            return f"{h} :: {t}"
        if name == "case":
            pv = el.get_attr("pat")
            if pv is not None:
                return self.lower_pattern_val(pv)
            if el.main:
                return " ".join(self.lower_pattern_val(v) for v in el.main)
            if el.keys:
                return self.lower_pattern_val(el.keys[0])
            raise LowerError("|case requires a pattern", self.filename, el.line)
        if name == "record":
            return self._record_pattern(el)

        # Variant constructor pattern (e.g. |Element[e], |Some[x], |None, |Fence :tag |Some[t] :exact true)
        cname = norm_ident(name)
        rec_attrs = [a for a in el.attrs if a.name not in STRUCT_META]
        if rec_attrs or "partial" in el.traits:
            return f"{cname} {self._record_pattern(el)}"
        if el.keys:
            if len(el.keys) == 1:
                return f"{cname} {self.lower_pattern_val(el.keys[0])}"
            inner = ", ".join(self.lower_pattern_val(k) for k in el.keys)
            return f"{cname} ({inner})"
        if el.main:
            inner = " ".join(self.lower_pattern_val(v) for v in el.main)
            return f"{cname} ({inner})"
        return cname

    def _record_pattern(self, el: Element) -> str:
        fields = []
        for a in el.attrs:
            if a.name in STRUCT_META:
                continue
            if a.value is None:
                fields.append(norm_ident(a.name))
            else:
                fields.append(f"{norm_ident(a.name)} = {self.lower_pattern_val(a.value)}")
        if "partial" in el.traits:
            fields.append("_")
        return "{ " + "; ".join(fields) + " }"

    def lower_pattern_val(self, v: Val) -> str:
        if isinstance(v, VStr):
            return ocaml_str(v.value)
        if isinstance(v, VInt):
            return str(v.value)
        if isinstance(v, VBool):
            return "true" if v.value else "false"
        if isinstance(v, VNil):
            return "None"
        if isinstance(v, VList):
            return "[" + "; ".join(self.lower_pattern_val(x) for x in v.items) + "]"
        if isinstance(v, VElem):
            return f"({self.lower_pattern_elem(v.elem)})"
        if isinstance(v, VText):
            return norm_ident(v.raw)
        raise LowerError(f"unsupported pattern value {v!r}", self.filename, v.line)


# ---------------------------------------------------------------------------
# CLI Driver
# ---------------------------------------------------------------------------

def main() -> int:
    ap = argparse.ArgumentParser(description="Compile UDON-in-OCaml (.ud) to OCaml (.ml) and optionally run via ocamlc.")
    ap.add_argument("input", help="Input .ud file")
    ap.add_argument("-o", "--out", help="Output .ml file (default: <stem>.ml beside input)")
    ap.add_argument("--no-line-directives", action="store_true", help="Omit # line directives in generated .ml")
    ap.add_argument("--compile", action="store_true", help="Compile generated .ml with ocamlc")
    ap.add_argument("--run", action="store_true", help="Compile with ocamlc and execute resulting bytecode")
    ap.add_argument("--strict-refs", action="store_true", help="Fail if any @{ref} in prose does not match a declared symbol")
    args = ap.parse_args()

    with open(args.input, "r", encoding="utf-8") as f:
        src = f.read()

    root = parse_udon(src, filename=args.input)
    comp = Compiler(filename=args.input, emit_line_directives=not args.no_line_directives)
    ml_code = comp.compile_document(root)

    out_ml = args.out or (os.path.splitext(args.input)[0] + ".ml")
    with open(out_ml, "w", encoding="utf-8") as f:
        f.write(ml_code)

    missing_refs = comp.check_prose_refs()
    total_refs = len(comp.prose_refs)
    print(f"[udon2ml] Lowered {args.input} -> {out_ml} ({len(ml_code.splitlines())} lines)")
    print(f"[udon2ml] Ubiquitous-language @{{ref}} check: {total_refs - len(missing_refs)}/{total_refs} resolved")
    if missing_refs:
        for ln, ref in missing_refs:
            print(f"  [WARN] {args.input}:{ln}: unresolved prose reference @{{{ref}}}")
        if args.strict_refs:
            return 2

    if args.compile or args.run:
        out_exe = os.path.splitext(out_ml)[0] + ".byte"
        cmd = ["ocamlc", "-w", "+8", "-o", out_exe, out_ml]
        print(f"[udon2ml] Running: {' '.join(cmd)}")
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.stdout:
            sys.stdout.write(res.stdout)
        if res.stderr:
            sys.stderr.write(res.stderr)
        if res.returncode != 0:
            return res.returncode
        if args.run:
            print(f"[udon2ml] Executing: {out_exe}")
            run_res = subprocess.run([out_exe], capture_output=True, text=True)
            sys.stdout.write(run_res.stdout)
            sys.stderr.write(run_res.stderr)
            return run_res.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
