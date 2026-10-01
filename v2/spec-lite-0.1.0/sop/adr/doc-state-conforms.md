---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "∂(doc-state) is missing · drafted · conforms, computed by the linter"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5), spec-lite fork (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# ∂(doc-state) is missing · drafted · conforms, computed by the linter

## Context and Problem Statement

The outline needs to show whether a row's document exists and is well-formed, without introducing a promotion ladder (`sop/influx/jaw-proposal-and-feedback.md` §1.1, §1.2).

## Decision Drivers

* Three exhaustive, mutually exclusive values that can move in both directions.
* Computed, so it can't go stale.

## Assumptions

* Format conformance can be judged per kind by a lint. (**inferred, unconfirmed**; no lint exists yet)

## Considered Options

* `missing · drafted · verified` (Joseph's first spelling)
* `missing · drafted · conforms` (chosen, "for brevity's sake")

## Decision Outcome

Chosen: ∂(doc-state) with values `missing`, `drafted`, `conforms`.

- `conforms` means format-conformant for the row's kind, not content-verified.
- The linter computes the value; it is never typed.
- New checks (fixtures passing, links resolving) arrive as separate flags beside it, never as more values of this field.

### Quote

> either the doc is missing, written but not necessarily formatted correctly, or written and formatted correctly. What am I missing? … I noted "doc-verified" distinct from general verified, but yeah, let's just change it to "conforms" for brevity's sake though.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.2)

### Positive Consequences

* No hand-set value to drift.
* Keeps "verified" free for content-level checks.

### Negative Consequences

* Until a linter exists, the value is computed by hand.

### What changes

* `main.outline.md` and `sop/main.outline.md` show ∂(doc-state) wherever a view chooses to.

## Reopen when

* Some kind needs a fourth document state that is not a separate flag.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* The agents first called this a ladder; Joseph showed the three values are exhaustive and reversible, and the objection was withdrawn (§1.2).
