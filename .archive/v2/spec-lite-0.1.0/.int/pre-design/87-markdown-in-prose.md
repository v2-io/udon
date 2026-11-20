# 87 — Is the prose in a lite document Markdown? And what does lite promise about Markdown written inside it?

## The question

Two parts:

1. **Meaning.** When a lite element holds text like `Some **bold** words`, is that Markdown (a renderer should make it bold) or just characters? Does lite name a Markdown flavor, or say nothing?
2. **Survival.** Whatever it means, does Markdown text pasted into a lite element come out unchanged? Where does lite's own syntax still grab it — and what does lite do there?

```udon
|post
  Intro with **bold** and `code`.
  \*not emphasis*
  @alice said:
  !important note
  |Name|Role|
  ```js
  let x = 1;
  ```
      an indented code block
```

## Why lite must decide

Lite is meant for "document layout" as well as data, and most prose written today is Markdown. File 08 covers tables, 03 the ` ; ` case, 11 fences. This file is the general contract, and it gathers the line-start collisions that affect lite in a new way: `@…` and `!…` are **reserved** in lite (file 09), so a prose line starting `@alice` or `!important` would be refused rather than quietly treated as text.

## What the texts say, in date order

- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Prose Content): "Markdown-compatible prose within elements"; "Since `;` is the comment delimiter, `#` has no special meaning in prose. Markdown flows naturally." "**Prefer Markdown over inline UDON in prose.**"
- **2025-12-24, Joseph** (memorata, `history.jsonl:5567`): "In fact... maybe in SPEC we should specify that Udon should generally prefer markdown in prose rather than inline-udon equivalents. And, unlike liquid... we may need to consider markdown parsing as part of the core parsing... A note for SPEC and parser-strategy for now."
- **2026-01-13, Joseph** (memorata, `history.jsonl:7831`): imagined flavors, including "udon-md — subset of udon where all prose (except as specifically typed as a different language in a directive) is assumed to be markdown."
- **2026-02-11, external review** (memorata, `78195b3e…jsonl:454`): "UDON says 'use Markdown for inline formatting.' But which Markdown? CommonMark? GFM? Djot? … if prose sections contain Markdown, then a full UDON processor needs both a UDON parser and a Markdown parser."
- **S16** (`v2/DECISIONS.md`) and **0.10.0 §7.1:** "Text is **opaque** to the core: Markdown inside it is not interpreted"; which subset renderers honor is a companion-layer concern (`spec/MARKDOWN.md` is a stub).
- **2026-07-28 measurement** (`theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md`; all 652 CommonMark spec examples, old parser as instrument): "No CommonMark construct in the corpus triggers any UDON structure except the fence." Byte-exact survival 86.7% when the Markdown sits inside a UDON element, 76.2% at the top level. Remaining losses: indentation read as layout, line-initial `\` consumed (Markdown loses one backslash), tabs. Five clashes found by hand: line-initial `\`; tight tables `|a|b|`; **line-initial `@alice`** (becomes a reference); **line-initial `!word`** (opens a directive); line-initial `:key value`. "The corpus has no GFM."
- **Fence collision** (same report and `fence-knot-table.md`): a Markdown ` ``` ` fence at the text's left edge is a UDON fence (byte-exact body); indented deeper, it is text.

## Alternatives — meaning

**A — prose is opaque characters in lite; nothing is said about Markdown** (0.10.0). **B — lite says prose is intended as Markdown and names a flavor** (CommonMark / GFM / Djot), without interpreting it. **C — lite leaves meaning to the document or application** (a declared flavor, file 84).

## Alternatives — survival at each collision

| Line in prose | Under reserve-don't-ignore | Alternatives |
|---|---|---|
| `\*not emphasis*` | `\` consumed (0.10.0): text `*not emphasis*` | keep the backslash in prose? |
| `@alice said:` | reserved → error, bytes kept | treat `@` at prose line start as text in lite (future `@` then can't start a prose line); require `\@` |
| `!important note` | reserved → error, bytes kept | as above for `!` |
| `:key value` | top-level: file 04; in an element: attribute (late, file 12) | text |
| `|Name|Role|` | element `Name` (file 08) | — |
| ` ```js ` at the left edge | UDON fence (file 11) | text |
| indented 4 spaces | extra indentation kept as text (file 81) | — |

```udon
|post
  @alice said:
```
```text
reserve (lite as decided):   element post
                               └ reserved "@alice said:"    ; anomaly: error, reserved
text-in-prose alternative:   element post
                               └ text "@alice said:\n"
```

Under the second, a future full version could never make a prose line starting with `@name` a reference without changing lite documents' meaning (the lite contract).

## Interactions

- [09](09-reserved-syntax.md): reserved spellings at the start of prose lines.
- [08](08-pipes-and-markdown-tables.md), [03](03-semicolon-in-prose.md), [11](11-code-blocks.md), [81](81-structure-inside-an-indented-text-block.md), [04](04-root-and-top-level-text.md).
- [82](82-escaping-in-lite.md): the line-start `\`.
