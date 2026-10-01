---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Reserved spellings are listed on their own, without explaining them"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: []
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["09"]
---

# Reserved spellings are listed on their own, without explaining them

## Context and Problem Statement

Lite refuses future syntax ([[decision:reserve-not-ignore]]). Writing that down raises a question of form: does lite's spec explain what each reserved spelling will mean in full UDON, or only say what is reserved?

## Decision Drivers

* None recorded beyond the Quote.

## Assumptions

* None recorded.

## Considered Options

* Explain each reserved form.
* List them on their own, saying only which characters or constructions are reserved (chosen).

## Decision Outcome

Chosen: lite's reserved spellings are listed in their own record, and not explained beyond which characters or constructions are reserved. Which spellings, and in which positions, is 09.

### Quote

> Let's put reserved ones in their own file and not explain them other than what characters or constructions are reserved.
>
> — Joseph, 2026-09-29 evening (2026-09-30T02:12Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`.*

### Positive Consequences

* Lite's spec makes no promise about what a reserved spelling will mean, so full UDON's design stays free.

### Negative Consequences

* A reader who meets a refusal learns that a spelling is reserved, not why.

### What changes

* The reserved-spellings rule is written as a list; `.int/reserved.md` is its first draft.

## Reopen when

* Readers of lite need to know what a reserved form is for, to avoid it sensibly.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
