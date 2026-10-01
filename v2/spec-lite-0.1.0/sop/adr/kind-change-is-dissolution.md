---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A change of kind is dissolution and emergence, not a mutation; `was:` is provenance"
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

# A change of kind is dissolution and emergence, not a mutation; `was:` is provenance

## Context and Problem Statement

If identity is (kind, slug), what happens when a record's kind changes (`sop/influx/jaw-proposal-and-feedback.md` §1.6)?

## Decision Drivers

* How a record can fail defines its kind; if that changes, so does nearly everything else.

## Assumptions

* None recorded.

## Considered Options

* Treat it as a rename with an alias
* Treat it as dissolution and emergence (chosen)

## Decision Outcome

Chosen: the old record is retired, and its content is integrated, reconstructively, into one or more new records of the new kind(s). `was:` on a new record is a historical provenance marker.

- A link to the old `kind:slug` resolves to the retired record, which carries forward pointers. It never silently follows to the new one.
- A rename (same kind, new slug) is different: it is an alias the resolver follows.

### Quote

> it's rare because it really does require one to essentially retire the old and integrate it reconstructively into new kind(s) -- so much changes (including its authority and verification level etc. etc.) or rather, because the very way "it can fail" changes, it's really not so much a mutation as a dissolution and emergence of something else. Which allows for was as a historical provinance marker etc.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.6)

### Positive Consequences

* Authority and verification never carry over by accident.

### Negative Consequences

* Kind changes cost more work.

### What changes

* The resolver distinguishes aliases (rename) from `was:` (provenance).

## Reopen when

* Kind changes turn out to be common.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

