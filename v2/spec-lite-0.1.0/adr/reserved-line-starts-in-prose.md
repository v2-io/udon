---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "In prose, @name and !word at the start of a line are errors; @name mid-line is text; a tight |Name|Role| row opens an element"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["09 Q1", "87", "08", "56"]
---

# In prose, @name and !word at the start of a line are errors; @name mid-line is text; a tight |Name|Role| row opens an element

## Context and Problem Statement

Under [[decision:reserved-is-an-error]], how much ordinary Markdown-style prose lite refuses depends on where reserved spellings are recognized inside text. The agent put five lines to Joseph, all in a text block under `|post`:

```udon
|post
  @alice said we should ship.         ; (a)
  !important: read this first.        ; (b)
  email me @joseph or see @{faq}.     ; (c)
  Keep calm ; carry on.               ; (d)
  |Name|Role|                         ; (e)
```

(d) is recorded in [[decision:framed-comments-on-node-lines]].

## Decision Drivers

* None stated.

## Assumptions

* None recorded.

## Considered Options

* Strict: (a) and (b) are errors.
* Lenient: (a), (b) and (e) are plain text, which keeps full UDON from ever giving meaning to `@name` or `!word` at the start of a prose line.

## Decision Outcome

Chosen: strict.

- (a) `@name` and (b) `!word` at the start of a prose line are errors.
- (c) Mid-line, `@joseph` is plain text; `@{faq}` is a reference ([[decision:references-in]]).
- (e) A tight row `|Name|Role|` opens an element, except when it sits deeper than the left edge of text already started above it, is escaped (`\|Name|Role|`), or has a space after the first pipe (`| Name | Role |`).

This settles only these positions. Not decided here: `!word` mid-line (the agent's restatement "Mid-line, `@joseph` and `!important` stay plain text" went unobjected, `supported` weight at most); the brace forms `!{…}` and `!{{…}}`, which stay reserved wherever they would open, mid-prose included (`.int/reserved.md`), so `Hello !{{name}}` mid-line is not text; the rest of 09 Q1's table; and 87's other rows (whether prose is Markdown, `\*`, line-start `:key value`, indented lines).

### Quote

> 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. […] (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His word: "I vote". His own call, so `steward`.*

### Positive Consequences

* Full UDON keeps the freedom to give meaning to `@name` and `!word` at a line start.

### Negative Consequences

* Prose that starts a line with `@alice` or `!important` is not lite; the author escapes it.
* What the rest of `|Name|Role|` becomes after the name `Name` is not yet stated.

### What changes

* The reserved-spellings rule lists these positions.

## Reopen when

* Refusal proves too costly for real prose.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- `|Name|Role|`: whether `|Role|` after the name is a child element, text, or something else follows from the element-name rule; to be shown with examples when names are settled.
- `!word` mid-line (`![img](x)`, `!=`, `!important`): to confirm with Joseph when the reserved-spellings rule is written.
