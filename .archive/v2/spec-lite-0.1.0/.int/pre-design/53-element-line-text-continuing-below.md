# 53 — Text on an element's line that continues on the lines below it

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

An author starts a paragraph on the element's own line and keeps going below, often aligned under the first word:

```udon
|later-part This stuff is inner to |later-part
            and, with a slightly different formatting
            preference, is indented quite a ways.
```

Is that **one run of text**, or the element's `$main` value (`"This stuff is inner to |later-part"`) followed by a **separate** block of content text?

## Where it has come up (chronological)

- **Joseph, 2025-12-25** (the message that led to `SPEC-INDENTS.md`): this exact example, with the expected output given as one text run: *"This stuff is inner to |later-part\nand, with a slightly different formatting\npreference-- is indented quite a ways."* Also: `|p Here is |child some text in the child` ⏎ `continuation of prose` is *"equivalent to `<p>Here is <child>some text in the child</child> continuation of prose</p>`."*
- **Joseph, 2025-12-25**, on where the content base comes from: *"the decision is to only start caring about base-indent starting on the next line, so either of these are fine and do not cause warnings"* — `|element-bigger Here's the first line` with the next line at column 2, or aligned at column 16, or at column 7.
- **0.9.x and the 2026-07 greenfields**: the element-line text is the element's content, "as if the indent continued under it" (pre-0.9 CORE "sameline decompress").
- **K9 (2026-08-08)**: element-line text becomes the `$main` attribute, not content. Joseph's reason (sameline-value-space notes, 2026-08-08): *"it allows round-trip transformations from the wire to properly distinguish those same-line main values that it couldn't before without original position metadata."* The guidance that came with it: *"sameline text is a scalar; start a text body next-line-indented."* A host flag (`first_is_main`-style) may re-inject `$main` as the first child.
- **0.10.0 §7.1–7.2**: `$main` "establishes no content base"; the first indented text line does.

## Alternatives

### A — two pieces (0.10.0)

```text
document
└ element later-part
    $main "This stuff is inner to |later-part"
    └ text "and, with a slightly different formatting\npreference, is indented quite a ways.\n"
```

(Also a question under A: is `|later-part` inside the `$main` text an element — [01](01-sameline-element-child-or-value.md) — or text?)

### B — one run: when the next line is text, the element-line text is the first line of the content

```text
document
└ element later-part
    └ text "This stuff is inner to |later-part\nand, with a slightly different formatting\npreference, is indented quite a ways.\n"
```

`$main` exists only when no text block follows (or never; see [13](13-ast-shape.md) Q3). This makes the tree depend on the next line.

### C — A, but the tree presents `$main` + following text as one run (host view), with `$main` kept in the model

## Sub-questions

- Under any alternative, the continuation lines are aligned at column 12 here. Is that column the content base, so nothing extra is kept? (0.10.0: yes — "at most an inline child's column".)
- Does the answer change for `|p Some text |em emphasis` ⏎ `  more text`, where the element line has an element in it?

## Interactions

- [01](01-sameline-element-child-or-value.md), [13](13-ast-shape.md) Q3.
- [05](05-values-across-lines.md): a quoted `$main` string that runs onto the next line.
