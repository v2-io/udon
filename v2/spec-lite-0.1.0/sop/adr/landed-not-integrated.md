---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "\"landed\" is a row-type; \"integrated\" is an influx outcome"
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

# "landed" is a row-type; "integrated" is an influx outcome

## Context and Problem Statement

"landed" was being used both as a row-type and as an influx crossing outcome (`sop/influx/jaw-proposal-and-feedback.md` §1.4).

## Decision Drivers

* One word, one meaning.

## Assumptions

* None recorded.

## Considered Options

* Rename the influx outcome to `integrated` (chosen)
* Rename the row-type

## Decision Outcome

Chosen: `landed` is used only as a row-type. `integrated` is the influx outcome, tracked from the influx item's side, not in segments or outlines. An influx item can be integrated by landing its content into a row that is only `proposed`; integration is about the influx item, landing is about the row.

### Quote

> landed != integrated (which should be used for tracking influx stuff-- from the perspective of influx stuff- not something we track in the segments or outlines usually)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.4)

### Positive Consequences

* The two terms can combine without contradiction.

### Negative Consequences

* Existing text using "landed" for influx must be swept.

### What changes

* `sop/def/def-integration.md` and `sop/influx/proposed-verisectorium.md` rename the influx outcome to `integrated`.

## Reopen when

* A third sense of either word appears.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

