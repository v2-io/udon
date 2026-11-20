---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Outlines hold current truth, the results of decisions, not compilations of the decisions"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5)]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Outlines hold current truth, the results of decisions, not compilations of the decisions

## Context and Problem Statement

The first carving of `sop/main.outline.md` listed every process decision in `sop/adr/` as a row, and raised the question of whether an accepted decision's row should read `landed`.

## Decision Drivers

* An outline is a view of what is currently true.

## Assumptions

* None recorded.

## Considered Options

* List decision records as outline rows
* Keep decisions out of outlines, and cite them from the records that rest on them through `per` (chosen)

## Decision Outcome

Chosen: an outline presents current truth, which is the results of decisions. It is not a compilation of the decisions themselves. Decision records live in their own set (`sop/adr/`, or lite's `adr/`) and are reached through the `per` citations of the records that rest on them. If a view ever does list decisions as a table, an accepted decision's row has row-type `landed`.

### Quote

> in an outline? they usually don't end up in an outline as a table or something, but if they did, the row-type would need to be landed. As for the decision kind, I don't know what "landed" means-- I assume you mean 'accepted' or 'decided' or something.

> outlines are generally meant as *current truth* -- the *results* of decisions -- not big compilations of those decisions...
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*A decision record's own lifecycle is its `status` (`accepted`, …). `landed` is only ever a row-type in a view.*

### Positive Consequences

* Outlines stay readable as the current state of things.

### Negative Consequences

* There is no single listing of decisions until a generated view exists.

### What changes

* The "Process decisions" chapter was removed from `sop/main.outline.md` on 2026-09-30.

## Reopen when

* A need arises to browse decisions in an outline-like view. That would be a separate, generated view, not the main outline.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

