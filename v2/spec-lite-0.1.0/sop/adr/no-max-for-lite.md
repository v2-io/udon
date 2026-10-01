---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Drop `max` for udon-lite for now"
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

# Drop `max` for udon-lite for now

## Context and Problem Statement

`max` (ceiling) was a column on every row, and was `decided` on nearly all of them (`sop/influx/jaw-proposal-and-feedback.md` §1.9 item 10).

## Decision Drivers

* A field that carries almost no information shouldn't be kept by default.

## Assumptions

* `max` is at first an aspiration or intuition, and later helps define the kind. (**recorded**, §1.9)

## Considered Options

* Keep `max` in frontmatter and show it only for properties
* Drop it for now (chosen)

## Decision Outcome

Chosen: drop `max` for udon-lite for now, unless something important turns out to depend on it.

### Quote

> max is a difficult one because it is essentially an aspiration or intuition at first and basically helps define the 'kind' later. Let's drop max altogether for udon-lite for now unless there's something important that it's giving us.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.9)

### Positive Consequences

* Fewer fields to maintain.

### Negative Consequences

* The ceiling intuition is not recorded anywhere for now.

### What changes

* `max` is removed from `sop/def/def-record-fields.md`, the outlines and the sample frontmatter.

## Reopen when

* Something important is found to depend on the ceiling.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

