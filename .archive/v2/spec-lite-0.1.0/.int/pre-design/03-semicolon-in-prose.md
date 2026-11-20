# 03 — Does ` ; ` inside a paragraph start a comment?

## The question

In a block of text under an element, a framed ` ; ` (with spaces around it) appears mid-line. Is it a **comment start**, or **ordinary text**?

## Why it matters

Markdown-style prose often contains " ; ". If it starts a comment, the rest of that line silently leaves the text. Everything is still kept, as a comment, but the text is no longer what the author wrote.

## What the texts say

- **0.10.0 §8 position table:** "In block text **at** the content base → line comment"; "In block text deeper than the base → literal."
  - It doesn't say whether "at the content base" means only a `;` at the start of the line, or any framed ` ; ` on a line that starts at the base.
- **OPEN SEMI-BASE:** the old parser treats mid-line ` ; ` in block text as literal; CORE-as-written arguably makes it a comment. Both readings are internally coherent.
- **Same-line and attribute lines** are settled: `|li Item ; TODO` → comment. This question is only about block text.

## Alternatives

### A — framed ` ; ` starts a comment anywhere in block text at the content base

```udon
|p
  Keep calm ; carry on.
  Next line.
```
```text
document
└ element p
    ├ text "Keep calm\n"
    ├ comment "carry on."
    └ text "Next line.\n"
```

### B — in block text, only a `;` at the start of a line is a comment; mid-line ` ; ` is text

```udon
|p
  Keep calm ; carry on.
  ; a maintainer note
  Next line.
```
```text
document
└ element p
    ├ text "Keep calm ; carry on.\n"
    ├ comment "a maintainer note"
    └ text "Next line.\n"
```

### C — no comments inside block text except inline `;{…}`

Line-start `;` in prose is text. Comments in prose use `;{…}` only.

```udon
|p
  ; not a comment here
  Text ;{but this is} continues.
```
```text
document
└ element p
    ├ text "; not a comment here\n"
    └ text "Text " · inline-comment "but this is" · " continues.\n"
```

## Interactions

- [10](10-inline-elements-and-inline-comments.md): whether `;{…}` is in lite.
- [04](04-root-and-top-level-text.md): the same question for text at the top level.
- 0.10.0 §8 "continuation": a line comment owns everything indented deeper than it.
