# 10 — Inline elements `|{…}` (in) and inline comments `;{…}` (?)

## Settled (Joseph, 2026-09-29)

`|{…}` inline elements are in lite; they are critical for XML/HTML-style use.

## Current rules for `|{…}` (0.10.0 §5.6, §6.4, §7.3)

- Closes at the matching `}`, counting nested braces. Can span lines.
- Inside: name, `[key]`, `.traits`, attributes, and text. Only inline forms nest inside; block `|name` does not.
- Interior text is kept exactly, single spaces included.
- `|{}` is a valid empty anonymous inline element.
- `\|{` is literal text.
- A bare `;` inside braces is literal.
- In prose it is part of the running text. At a value position it is the value. Several on an element's line stack as `$main` values (K9).
- A `|{` at the start of a line begins a text line.

```udon
|p See |{a :href /docs the docs} and |{em this}.
|ul |{li one} |{li two}
|el :label |{em Hi}
```
```text
document
├ element p
│   $main "See " · inline a(href "/docs"; "the docs") · " and " · inline em("this") · "."
├ element ul
│   $main inline li("one")
│   $main inline li("two")
└ element el
    label inline em("Hi")
```

*(The `p` line: its text starts with a word, so it is one text value, with the inline elements as pieces of it. On the `ul` line the brace forms come first, so each is its own value.)*

## Questions for lite

### Q1 — Are the rules above complete for lite?

In particular: a `|{…}` spanning lines, and what happens to the continuation lines' indentation (0.10.0: "continuation indentation is geometry" — stripped how exactly?).

```udon
|p A |{em very long
       emphasized} run.
```

### Q2 — Are inline comments `;{…}` in lite?

```udon
|p Text ;{a note} more text.
```

- **A, in:** `$main "Text " · inline-comment "a note" · " more text."`. When stripped, the spaces around it stay (0.10.0: both framing spaces are kept).
- **B, reserved in lite.**
- **C, literal text in lite.** (Not forward-safe if a future version treats it as a comment.)

### Q3 — The "running text vs separate values" distinction on an element's line

The two cases:
- `|p See |{em x}` — the text starts first, so the whole rest is one text value with the inline element as a piece of it.
- `|p |{em x} see` — the brace form comes first, so it is a value, then `see` is a second `$main` value.

Is that distinction wanted in lite, or should an element's line be simply "running text, with inline elements as pieces"?

## Interactions

- [01](01-sameline-element-child-or-value.md): block `|b` vs brace `|{b}` on an element's line.
- [03](03-semicolon-in-prose.md): comments in prose.
- [13](13-ast-shape.md): how running text with pieces is represented.
