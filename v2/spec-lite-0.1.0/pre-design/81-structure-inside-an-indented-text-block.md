# 81 — A `|name` line inside a block of text: element or text? And what happens when text lines shift left?

## The question

Once an element has lines of text, its first text line sets the text's left edge (the "content base"). Two things then need rules:

1. **A deeper line that starts with a marker.**

   ```udon
   |note
     Here is some text,
       |b looks like an element
     and more text.
   ```

   Is `|b` an element (child of `note`), or two characters of text?

2. **A later line that sits left of the first text line but still inside the element.**

   ```udon
   |note
       Indented four.
     Indented two.
   ```

   Is the second line text of `note` (with a warning, and the left edge moved), or something else?

## Why lite must decide

Prose pasted from Markdown is full of both shapes: indented code examples, hanging list continuations, quoted blocks, paragraphs that start at 2–3 spaces. The answers decide whether pasted prose stays prose, and whether a lite document with such prose is valid lite.

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md` (undecided list)**, verbatim with indentation:
  ```text
  * Is this meaningful:
      |hello
        here is some text
          |am I a node? whose node am I? The texts? |hello's with a warning?
            interpreted simply as text, with warning?
  ```
- **Dec 2025, `_archive/SPEC-INDENTS.md` §Automatic Prose Dedentation:** the first indented line sets `content_base`; later lines at ≥ base keep their extra spaces; a line < base but still inside the element "emit[s] warning about inconsistent indentation" and becomes the new base; "Valid range for indented content: between parent's `|`+1 (exclusive) and any inline child's `|` (inclusive)." "Earlier lines may have been 'over-stripped' compared to later lines. **This is intentional**: the warning signals the inconsistency to the user."
- **0.10.0 §2.1 "Exception — text interior"** and **§7.2 rule 5:** "A line deeper than an established base is *inside the text*: markers there are literal. Structure resumes at or left of the base."
- **2026-07-11 prose-collision spike** (`_archive/spikes/prose-collision-2026-07.md`, all CommonMark spec examples as UDON prose): "Zero silent text mutations across the corpus." "All 19 warning-only examples emit 'Inconsistent indentation' — markdown's own indentation conventions (indented code blocks, hanging list continuations, tab/space mixes, 2–3-space paragraph leads) look like UDON's dedent hazard. Content survives untouched."
- **S4** (`v2/OPEN.md`): whether the shift-left warning fires for comment-continuation lines too is unruled.
- **ROOT-BASE** (`v2/OPEN.md`, file 04 Q1): the same rules at the top level are unstated.

## Alternatives

### Q1 — a marker line deeper than the text's left edge

**A — text (0.10.0).**
```text
document
└ element note
    └ text "Here is some text,\n  |b looks like an element\nand more text.\n"
```

**B — structure wherever a line starts with a marker (column decides the parent).**
```text
document
└ element note
    ├ text "Here is some text,\n"
    ├ element b
    │   $main "looks like an element"
    └ text "and more text.\n"
```

**C — text, with a warning** (the 2011 question's last option).

**D — reserved in lite** (error, bytes kept) so a later version can choose.

### Q2 — a text line left of the first text line

**A — warning; the left edge moves to the new line; earlier lines stay as stripped (0.7, 0.10.0).**
```text
document
└ element note
    └ text "Indented four.\nIndented two.\n"      ; anomaly: warning, inconsistent indentation
```

**B — the left edge is the leftmost text line of the whole block** (needs the whole block before any line can be stripped — looks ahead):
```text
    └ text "  Indented four.\nIndented two.\n"
```

**C — the left edge is fixed by the element's own column + 1; nothing is stripped beyond that.**

**D — an error in lite** (the document is not valid lite).

## Interactions

- [04](04-root-and-top-level-text.md) Q1: the same question at the top level.
- [03](03-semicolon-in-prose.md): `;` at the text's left edge vs deeper.
- [80](80-which-spaces-are-content.md): extra indentation kept as text.
- [11](11-code-blocks.md): fences inside text.
- [12](12-missing-values-and-what-counts-as-valid.md): whether the warning keeps a document valid lite.
