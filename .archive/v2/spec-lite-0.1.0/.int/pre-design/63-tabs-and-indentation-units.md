# 63 — Tabs in indentation: Error, Warning-with-keep, or something else — and is there an indentation unit?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

UDON's hierarchy is indentation (column of the first non-space character). A tab in a line's indentation has no agreed column. What does lite do with it, and does lite say anything about the **size** of an indent step, or leave every consistent choice equal?

```udon
|a
	|b        <- one tab
  |c          <- two spaces
```

## What the texts say (chronological)

- **Joseph, 2025-12-24**, answering an agent's parser-unit-test questions: *"Error on tab."* (`~/.claude/history.jsonl` line 5624.) The libudon fixture `error_cases.yaml` carried `tab_character_error`; Jan 2026 the fixture was corrected from two `NoTabs` errors to one (line 7748: "I'm not sure why it would want two NoTabs errors... can you fix the fixture please?"). Spaces-only was already in the archived Dec 2025 specs (`_archive/SPEC.md` "Spaces only (no tabs)"; `_archive/analysis.md` "Error on mixed tabs/spaces? Decision: Yes. Be strict. Spaces only."). `_archive/SPEC-INDENTS.md` itself does not mention tabs.
- **2026-07-16, delegated to an agent** and recorded in `spec/CORE.md` ~line 1798 / CHANGELOG 0.9.0-alpha.2: "A tab anywhere in indentation (mixed or tabs-only) is the `NoTabs` error; a tab *inside* prose, a value, or a comment is ordinary content" ("tabs illegal in indentation only").
- **0.10.0 §2 and the STEWARD ledger L4**: tab in indentation is a **Warning**, the line kept best-effort as text of the current column owner (rejecting "live CORE: line lost"). 0.10.01 NUANCE-AUDIT: "derives — severity-by-loss: a coherent keep exists."
- Tab-as-content elsewhere: 2026-07-11 grammar aliases (`<tab>` as a char-class name) are descent-grammar matters, not document syntax.

The same question with the same shape was asked by the Dec 2025 usability agents: "Indentation-based parsing is brittle with copy-paste and display contexts… Editor ambiguity (when should indent increase?)".

## Alternatives

### A — Warning, keep the line as text of the current owner (0.10.01)

```text
element a
  ├ text "\t|b\n"          ; anomaly: Warning, tab in indentation, line kept as text
  └ element c   (col 2)
```
The document loads; the writer is told; nothing is lost. Cost: the tree the writer intended (b inside a) is not the tree produced, silently for consumers who ignore warnings.

### B — Error, line lost or document rejected (the pre-0.10 stance)

Strict; matches "Error on tab" and Python 3's TabError. Cost: violates 0.10's keep-everything principle (G8) unless "Error" means "keep and flag".

### C — Tab counts as a defined number of columns (for example to the next multiple of 8, or exactly 1, or 4)

Friendly to tab-indenting editors and Makefile-minded authors; adds a rule and an implicit editor-width dependency. Two people's files disagree if the number is left to the host.

### D — Pure geometry unit-agnostic

Spaces only, and lite says nothing about unit size: `|a` / ` |b` / `  |c` are all legal shapes. Sub-question: is recommending a unit (2 spaces) *style* only? (0.10.01: "consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a rule; tooling default unit stays open, CARVEOUTS IND.")

## Sub-questions

- Tab inside a **text block's** indentation (the stripped part of a prose line): same rule, or content (0.9: "a tab inside prose … is ordinary content")? The distinction matters for a tab after the content base in a code-like line.
- Tab *after* the first non-space character is never indentation; is that stated anywhere lite readers will see?
- Does the answer change for a tab-indented **root-level** line vs nested?

## Interactions

- [80-which-spaces-are-content](80-which-spaces-are-content.md) (other survey, not read) and [04](04-root-and-top-level-text.md) (root indentation), [11](11-code-blocks.md) (fences strip nothing), [52](52-inconsistent-sibling-columns.md).
