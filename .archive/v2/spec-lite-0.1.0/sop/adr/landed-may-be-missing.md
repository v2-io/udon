---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A landed row may have no document"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["aat-refactored coordinator (agent, Opus 5.5)"]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: row-type, how: revised, scope: partial}, {adr: flags-on-docless-rows, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# A landed row may have no document

## Context and Problem Statement

[[decision:row-type]] said `landed` "implies drafted". That clause came from Joseph's first list in §1.1 ("landed (implies drafted)"), which his orthogonal proposal then replaced by pairing `row-type` with `doc-state`, where `missing` is one value. [[decision:flags-on-docless-rows]] gave `—` to the flag cells of every row with no document, landed or not.

## Decision Drivers

* Joseph split `row-type` from `doc-state` to make them orthogonal: "ok... making these more orthogonal" (§1.1).
* `—` means not applicable and `∅` means applicable but missing ([[decision:column-notation]]).

## Assumptions

* None recorded.

## Considered Options

* A `landed` row may have doc-state `missing` (chosen)
* `landed` implies drafted

## Decision Outcome

Chosen: a `landed` row may have doc-state `missing`. It happens when:

- the record is small and its core is covered by the row's description, or sits in `.int/` or influx and hasn't been moved yet;
- the record was refactored away and the outline wasn't updated.

On such a row the flags apply but have no document to come from, so its ※ flag cells show `∅`, not `—`. [[decision:flags-on-docless-rows]]'s `—` still holds for rows that aren't `landed`.

### Quote

> 2. landed (a row state) *can* have a doc-state missing. Often this is when it is pretty small and the core is covered in the table description field and/or something in .int / influx that just hasn't been moved to the right place yet. It also comes up when something gets refactored away and the agent forgets to update the outline.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.15)

*The `∅` follows from Joseph's notation ([[decision:column-notation]]) once landed + missing is valid. That consequence is the coordinator's reading.*

### Positive Consequences

* The outline can hold landed content that is small or not yet moved, without inventing a document.
* A landed row with `∅` cells is visible, which is what catches the second case, an outline left stale by a refactor.

### Negative Consequences

* A landed + missing row looks the same whether it is a small record carried by its description or a stale row. Only a reader can tell which.

### What changes

* `sop/src/conv-row-type.md` already allows it; it gains the two cases.
* `sop/src/conv-column-notation.md` and `sop/src/conv-record-flags.md` give `∅` to flags on landed rows with no document.

## Reopen when

* Landed + missing rows turn out to be mostly stale, and a linter should treat them as errors.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
