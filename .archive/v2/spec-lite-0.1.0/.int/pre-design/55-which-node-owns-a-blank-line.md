# 55 — Which node owns a blank line between two pieces of structure?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

Lite is specified as a tree. A blank line that sits where one element ends and the next begins has to land *somewhere* in that tree (or be dropped). Where?

```udon
|a
  |b
    text of b

  |c
|d
```

Does the blank line belong to `b` (the node above it), to `a` (the parent of both `b` and `c`), or to nothing?

[13](13-ast-shape.md) Q5 asks whether edge blank lines are kept or dropped. This file is the placement question that follows if they are kept.

## Where it has come up (chronological)

- **Joseph, 2026-01-13**, giving an expected event list where a blank line after `|beta` is emitted *inside* beta, before beta closes: *"There's no way at this point for the parser to know what the intent is coming up — whether a is effectively closed and is onto siblings or more children of a. Having the blank-line tied to what's immediately above it as a child keeps both options open. Making it a peer of |a would preclude something like this:"*
  ```udon
  |a some text

    finishing the text
  ```
- **Joseph, 2026-01-13**: *"a line with only spaces on it should *not*, according to the spec, be indent/dedent sensitive at all — it should be equivalent to a double-newline unless in raw triple-backtick mode."* And on the spaces themselves: *"I'm perfectly ok with having the whole thing collapse … I'm also OK preserving the spaces there and letting the AST/DOM builder decide."*
- **Joseph, 2026-07-19** (ruling S6, which became R15), distinguishing four kinds of blank line: whitespace protruding past the text's column is kept as text; blank lines inside text are "just extra newlines in the text"; *"blank lines in *non-prose* mode / positional construct detection etc. are (or should be) considered *UDON-level decoration* … (Maybe call this ornamentation, vs text-literal or something)"*; and *"blank lines that don't have whitespace extending to the head position but that otherwise trail the text blob are a bit ambiguous … I think ideally we would say it's ornamentation but that would require some lookahead if implemented at the event parser … But I can also be ok making the app level strip the newlines if it wants to."* His proposed split: the event level marks them all `BlankLine`; *"in the AST builder we can decide that blank lines that are surrounded by text get turned into extra newlines, while blanklines that are before or after a text starts are discarded as udon ornamentation or some other construct like literal blanklines in the ast for round-trip / reversibility."* Lite, being specified as the tree, is where that AST-builder decision has to be made.
- **R15 / 0.10.0 §7.4** (two-layer model): blank lines are recognized; interior blanks in text are newlines; leading/trailing blanks at structure boundaries are "ornamentation."
- **S9 (DECISIONS; 0.10.0 CARVEOUTS §S9)**: "exact placement of blank-line nodes relative to dedents at structure boundaries" is **deferred**. Consumers follow the ornamentation model, not node order.

## Alternatives

### A — the blank line belongs to the deepest node open above it (Joseph's 2026-01-13 event order)

```text
document
├ element a
│   ├ element b
│   │   ├ text "text of b\n"
│   │   └ blank
│   └ element c
└ element d
```

### B — the blank line belongs to the parent of the next structure line

```text
document
├ element a
│   ├ element b
│   │   └ text "text of b\n"
│   ├ blank
│   └ element c
└ element d
```

B needs the next non-blank line before it can place the blank (lookahead across any number of blank lines).

### C — blank lines at structural seams are not in the tree (ornamentation), only inside text

A round-trip formatter then needs spans or a flavor annotation (K15-style) to reproduce them.

## Sub-questions

- The trailing blank lines at the end of the document: root, or the last open node?
- Blank lines *before* an element's first text line. Joseph, 2026-07-15, on
  ```udon
  |el




     and now the real prose starts
  ```
  *"^ sets the head-position *and* seems to imply that the earlier newlines are part of prose, even though the parser wasn't sure at first... but I could also be OK with those being automatically trimmed..."* Same message, on blank lines after an attribute: *"since it never tries to turn into text, newlines and whitespace are block-level udon-level decoration."*

## Interactions

- [13](13-ast-shape.md) Q5 (text representation, blank nodes).
- [04](04-root-and-top-level-text.md): blank lines at the top level.
- Any canonical-writing-form rule depends on this (a formatter has to put blank lines back).
