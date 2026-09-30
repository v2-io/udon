# 78 — What does a `;` comment own: just its line, or the indented lines under it too?

## The question

In 0.10.0 a line comment "owns everything indented deeper than it" — so one `;` can silence a whole block. What does lite do with the lines under a comment, and with comments that sit at the end of an element's or attribute's line?

```udon
|config
  ; the old settings
    :timeout 30
    |retry :count 3
  :timeout 60
```

Are `:timeout 30` and `|retry` part of the comment (silenced), or live structure?

## Why lite must decide

Commenting-out is common in config files, and the rule decides whether a stray deeper line after a note silently disappears into a comment. File 03 covers a ` ; ` in the middle of prose; this file covers the lines **below** a comment and comments on structure lines.

## What the texts say, in date order

- **2011, `udon/examples/overview.udon`:** the first lines of the example file are a comment with an indented continuation ("# This is an UDON sample / And the comment keeps on going..."); later: "# Hello comment #1 / This should align / as should this".
- **2011, `udon-c/docs/DECIDED.md` undecided:** "what about a simplification for line-ending comments though? … meh... probably opens a can of worms..."
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Comments): line comment at the document root, sameline, and after attribute values; literal in block prose; `;{…}` inline.
- **2026-01-02, Joseph** (memorata, libudon `31853cab…jsonl:9969`): "the semantics of the comment block are just like the other block types (`|` `!`) except a lot less to do inside it." Comment continuation was implemented that week ("more-indented lines without prefixes are part of comment").
- **2026-07-21, L7** (`v2/DECISIONS.md`): continuation text is stripped like prose — the first continuation line sets the strip column.
- **0.10.0 §8:** "A line comment owns everything indented deeper than it — markers, structure, fences, everything — until a line at or left of its column. … This is what lets one `;` silence an entire block, including structure that is itself failing to parse. Comments participate in the column hierarchy like any node (a comment at column 0 closes everything open)." A `;comment` with no space is still a comment at line start.
- **0.10.1 audit A6** (`spec-0.10.01/working-notes/AUDIT-2026-09-01.md`): the end-of-line comment after a finished value is also "a line comment", so for `:desc ; the description` + deeper lines, or `|el ; note` + `  |child`, "are the deeper lines the annotation's continuation or the assignment's deferred body? … If the sameline annotation owns deeper lines, one trailing `;` silently swallows an element's whole body."
- **2026-07-20 night session** (`.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` L1515–1520, the agent's example, indentation as in the file):
  ```udon
  |el
    :note                 ; key line — no same-line value yet
      first line of value   ; deferred block starts
      second line
  ```
  Here the deeper lines are `note`'s value — the trailing comment owns nothing below. (Joseph's own example the same night, L1686, also puts a trailing comment on a value line: `:this-one-is-ok-too because this text clearly is the value for the attribute ; and this is a comment`.)
- **0.9.1 primer, appendix note 1:** which things between attribute lines end the "attributes come first" window is unstated; "a comment or blank line surely must *not*."
- **Editor practice** (`ux/README.md`, "Known limitations"): the Obsidian highlighter shows continuation lines as prose, "determining them needs cross-line indent state we deliberately don't guess at yet."

## Alternatives

### A — a line comment owns every deeper line (0.10.0)

```text
document
└ element config
    ├ comment "the old settings\n:timeout 30\n|retry :count 3"
    timeout 60
```

(How `timeout 60` is placed relative to the comment is file 13 / file 12 Q3.)

### B — a comment is exactly one line; deeper lines parse normally

```text
document
└ element config
    ├ comment "the old settings"
    timeout 30                    ; + a second timeout 60 (stacked)
    └ element retry
        count 3
```

Silencing a block then needs `;` on every line.

### C — comment continuation only for lines that are not structure (the Jan 2026 parser: continuation stops at `| : ! ;`)

```udon
; a long note that
  wraps onto a second line        ; continuation (plain text)
  |this-is-live                   ; not continuation — parsed
```

### D — comments are reserved beyond the single line: lite accepts one-line comments and refuses (error, bytes kept) any deeper line directly under a comment

## End-of-line comments on structure lines

```udon
|el ; a note about el
  |child                ; child of el, or part of the comment?
|task :desc ; fill in later
    The description.     ; desc's value, or comment continuation?
```

Options: **(i)** an end-of-line comment owns nothing below it (the 2026-07-20 reading); **(ii)** it owns deeper lines like any line comment (0.10.0 as written, per A6); **(iii)** it owns deeper lines only when nothing else could (e.g. no open attribute).

## Other edges

```udon
|a
  |b
; note at column 0
  |c                    ; under A: comment text (the column-0 comment closed a and b, then owns c)
|el
  :a 1
  ; a comment between attributes
  :b 2                  ; still an ordinary attribute, or "late" (file 12 Q3)?
;no-space-after-semicolon     ; comment (0.10.0), with an optional style advisory
```

## Interactions

- [03](03-semicolon-in-prose.md): ` ; ` inside prose.
- [74](74-attribute-values-on-following-lines.md): an attribute's value on following lines vs a trailing comment.
- [12](12-missing-values-and-what-counts-as-valid.md): `:desc ; note` with nothing else — missing value.
- [13](13-ast-shape.md) Q6: comments in the tree.
