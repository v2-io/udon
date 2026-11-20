---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A critical objective is also required, for now"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["aat-refactored coordinator (agent, Opus 5.5)"]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# A critical objective is also required, for now

## Context and Problem Statement

[[decision:force-critical-is-ctq]] defines `required` as an intention for this version and `critical` as critical to quality. Read literally, `critical` was not tied to a version, so it was unstated whether a CTQ objective is also an intention for this version.

## Decision Drivers

* None recorded.

## Assumptions

* None recorded.

## Considered Options

* `critical` implies `required` (chosen)
* Treat CTQ and version intention as separate axes

## Decision Outcome

Chosen: a `critical` objective is assumed, for now, to be `required` as well: an intention for this version that is also expected to have an outsized impact. A ⟦requirement⟧ is still an objective with force `required` or `critical`.

### Quote

> 1. critical should be assumed (for now) to be required.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.15)

### Positive Consequences

* `force` stays one ordered scale: `non` < `desired` < `required` < `critical`.

### Negative Consequences

* An objective that is critical to quality but not intended for this version has no value that says so.

### What changes

* `sop/def/def-record-fields.md` and `sop/src/conv-purpose-layer.md` say that `critical` includes `required`.

## Reopen when

* A CTQ objective needs deferring past this version (Joseph's "for now").

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
