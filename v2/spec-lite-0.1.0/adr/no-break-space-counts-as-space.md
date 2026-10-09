---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A no-break space (U+00A0) counts as a normal space wherever it sets a column, with a warning"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: column-shifting-whitespace-is-an-error, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# A no-break space (U+00A0) counts as a normal space wherever it sets a column, with a warning

## Context and Problem Statement

[[decision:column-shifting-whitespace-is-an-error]] made any Unicode whitespace other than the ordinary space an error where it could shift a node's column; that covered the no-break space. Joseph asked for the reasoning behind keeping it an error, noting "there's no ambiguity about column positions with that character in particular." The coordinator revised its lean to one column plus a warning, and he agreed. This replaces that record's rule for U+00A0 only; every other non-space whitespace stays an error there.

## Decision Drivers

* No column ambiguity: Unicode says U+00A0 "should be the same width as the space 0020", and its East Asian width is Neutral (the coordinator's reasoning; Joseph's own point that there is no ambiguity about its column).
* Still worth a warning: it is invisible, and other tools disagree about whether it is whitespace. (**inferred, unconfirmed** as Joseph's driver: the coordinator's reasoning, which he answered "Yes".)

## Assumptions

* None recorded.

## Considered Options

* An error, as for other non-space whitespace (the coordinator's first lean).
* A normal space, silently.
* A normal space with a warning (chosen).

## Decision Outcome

Chosen: a no-break space counts as a normal space wherever it sets a column, with a warning. It is correct lite that may not be what was meant.

```udon
|a :x 1⍽|b            ; ⍽ = U+00A0: b is at column 8, with a warning
⍽⍽|a                  ; indentation of two columns, with a warning
```

### Quote

> 2. Yes-- treat it same as a normal space but with a warning.
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`), answering the coordinator's revised lean (one column plus a warning); its reasoning is in the two agent messages before, summarized there

> Please tell me your reasoning, as there's no ambiguity about column positions with that character in particular.
>
> — Joseph, 2026-10-08 (same file, earlier), on the first lean (an error)

*His words: "Yes-- treat it same as a normal space but with a warning." His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* A no-break space that slipped in (pasted from a word processor or a web page) doesn't stop parsing, and the author is told.

### Negative Consequences

* A no-break space where a column is set goes through with only a warning.

### What changes

* [[decision:column-shifting-whitespace-is-an-error]] gains a `superseded-by` entry for U+00A0.
* [[rule:columns-and-indentation]]; the anomaly inventory lists the warning.

## Reopen when

* Tools or authors are surprised by the column a no-break space gives.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Inside text, values and fence bodies, where it sets no column, a no-break space is plain content with no warning. This is the agent's reading, from the coordinator's earlier stated lean ("stays ordinary content in text, values and fence bodies"); not yet put to Joseph as its own question.
