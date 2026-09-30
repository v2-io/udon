# 11 — Code and other raw content in lite

## The situation

`!:kind:` block code is reserved (it uses `!`). That leaves **fences** as lite's only way to hold raw content that must not be parsed as UDON.

## Current fence rules (0.10.0 §10.3)

- A fence (three backticks) opens at any structure position: line start, or on an element's or attribute's line.
- Its indentation sets its parent. The text after the backticks is its kind.
- The body is kept **byte-exact**: no indentation stripped, nothing parsed.
- It closes at a line whose first non-space content is the three backticks followed by end of line, at any indentation.

```udon
|ex
  ```sh
  make build
  ```
```
```text
document
└ element ex
    └ fence sh "  make build\n"        ; byte-exact: the 2 spaces are body
```

## Questions for lite

### Q1 — Code as an attribute value, or on an element's line

Is this what "sameline capture" refers to? In 0.10.0 it was `|el :script !:sh: make build`, which is reserved in lite.

```udon
|job :script ```sh
make build
make test
```
```
```text
document
└ element job
    script fence sh "make build\nmake test\n"
```

Is the fence-as-value form wanted in lite, and is it well-defined? Where does the body start, and which column is the byte-exact body measured from?

### Q2 — Byte-exact vs indentation-stripped

Byte-exact means an indented fence carries its indentation into the body, as in the first example. 0.10.0 recommends putting the closer at column 0 unless the indentation is wanted. For lite, the options are:

- **A)** byte-exact (current);
- **B)** strip the fence line's own indentation from each body line (Markdown's rule);
- **C)** both, with the choice made by the fence's spelling.

### Q3 — Code that itself contains three backticks

Current fences have no length variation, so a body line starting with three backticks closes the fence early. (This was measured: the "fence knot" probe, `theory/to-integrate/refine-more/markdown/`.)

- **A)** Accept it; nested fences need escaping or another tool.
- **B)** Adopt Markdown's rule: an opener of N ≥ 3 backticks closes only at N or more.
  - Is this forward-safe? Under 0.10.0, four backticks are read as three plus a kind starting with a backtick.
- **C)** Also allow `~~~` fences (currently inert text).

### Q4 — Is there a need for an indentation-based (geometric) raw block in lite, with a non-reserved spelling?

0.10.0's recorded practice candidate prefers `!:label:` blocks over fences for embedded material, because an indentation-based block can't be closed early by its content. Lite can't use that spelling.

- **A)** fences only in lite;
- **B)** a lite-legal spelling for a geometric raw block (new grammar); or
- **C)** a `<…>` box for raw content (see [07](07-untyped-angle-box.md) — but a box closes at `>`).

## Interactions

- [07](07-untyped-angle-box.md) and [09](09-reserved-syntax.md).
