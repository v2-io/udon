---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Primary outlines are named main.outline.md"
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

# Primary outlines are named main.outline.md

## Context and Problem Statement

Outline filenames varied (`spec.outline.md`, `SOP.outline.md` in the verisectorium template) (`sop/influx/jaw-proposal-and-feedback.md` §1.9–§1.10).

## Decision Drivers

* A normalized name for each store's primary outline, while it remains one view among possibly many.

## Assumptions

* None recorded.

## Considered Options

* `spec.outline.md` / `sop/sop.outline.md`
* `main.outline.md` in every store (chosen)

## Decision Outcome

Chosen: each store's primary outline is `main.outline.md`, lower case: `main.outline.md` for lite, `sop/main.outline.md` for the SOP store. It is still just one among possibly many views.

### Quote

> btw-- I vote lower case on sop/sop.outline.md … I think we should normalize primary outlines, even while keeping them as "just one among possibly many views" -- main.outline.md -- if you wouldn't mind changing spec to main and then sop/main.outline.md as well.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.9–§1.10)

### Positive Consequences

* Tools can find a store's primary view without configuration.

### Negative Consequences

* None identified.

### What changes

* `spec.outline.md` was renamed `main.outline.md` on 2026-09-30.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

