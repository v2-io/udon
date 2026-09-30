# 57 — Line breaks inside text: kept, soft, or hard — and what a trailing `\` means

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

Three linked details of text in the lite tree:

1. Is every line break inside a text block kept in the tree as `"\n"`, or is the tree allowed to join lines (Markdown-style "soft" breaks)?
2. Is the **last** line break of a text run part of the text?
3. Does a `\` at the end of a text line mean anything — a deliberate ("hard") line break — and does it need a space before it?

```udon
|p
  first line
  second line\
  third line \
  fourth line
|q
```

## Where it has come up (chronological)

- **Joseph, 2026-01-03**: *"I wonder if we should allow "hard return" semantics by\ backslashing before newline."* (written attached, no space before the `\`).
- **Joseph, 2026-01-13**: *"We already have a tentative rule: trailing backslash means \ deliberately preserved newline. Unless in a raw or ``` block / directive, we don't make any guarantees except that one potentially... and we say "it's up to the consumer to decide if they want to automatically put spaces between everything and dedup multiple spaces..."* His example event list shows `Text "more text\n"` for the line ending in `\` and no `\n` on the others.
- **Joseph, 2026-07-14**, considering backslash line *continuation* and setting it aside: *"In practice, the one place I can see it ostensibly useful is continuing a same-line list of (:attribute value)s. But that then gets complicated … just gets too complicated I think... Within prose itself, if a trailing backslash were simply passed through as usual, the app-layer gets to decide that it removes the subsequent newline... So... in the end... I say backslash anywhere else is passed through and gets application-level decisions on its meaning (like escape sequences or escaped newline and so forth and so on)."* Then: *"backslash always forces prose (and is consumed / not passed on) when at head-position."*
- **R1 / text-wire recast (2026-07-19)**: the text reconstructs by pure in-order concatenation, and line terminators are text. So every interior line break is kept.
- **0.10.0 §7.4 "final-terminator disposition"**: a run's final terminator is ornamental (the consumer trims it); an author's framed `\` at the very end of a line (an empty forced tail) is an **explicit** newline and is kept — quoting Joseph: *"The only reason I'd put the backslash at the end like that is because I *do* want the explicit newline."*
- **0.10.0 §4**: a `\` attached at the end of a token (`line\`) is a literal backslash ("a trailing `\` inside a token … pass[es] through"). Only the framed form (space before) is the operator.

So under 0.10.0, `second line\` keeps a literal backslash and `third line \` forces a kept newline. Joseph's 2026 examples wrote the attached form.

## Alternatives

### For (1): interior line breaks

- **A** — kept exactly (R1): `text "first line\nsecond line\n…"`.
- **B** — kept in the tree, but the spec says a consumer may treat them as soft (Joseph 2026-01-13's "up to the consumer").

### For (2): the final line break

- **A** — part of the text (the pre-design files' tree notation shows `text "…\n"`).
- **B** — not part of the text; the tree records the run without it (0.10.0's "ornamental, trimmed by the consumer," moved into the tree).

### For (3): trailing `\`

- **A** — framed only (0.10.0): `third line \` = explicit kept newline; `second line\` = literal backslash.
- **B** — attached also counts when it is the last character of the line: `second line\` = explicit newline; a literal trailing backslash is written `\\`.
- **C** — no line-end meaning in lite (reserved or literal); decide with the Markdown layer.

## Interactions

- [13](13-ast-shape.md) Q5: text representation.
- [02](02-escape-inside-open-value.md): the framed/attached `\` split generally.
- Markdown's own hard-break forms (two trailing spaces; a trailing `\`) — Markdown inside UDON text is not interpreted by the core (0.10.0 §7.1), so a Markdown renderer would see the backslash under A for (3).
