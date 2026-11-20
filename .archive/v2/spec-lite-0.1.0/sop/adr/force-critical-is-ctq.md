---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Force is for objective-level kinds; required is for this version, critical is critical to quality"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["aat-refactored coordinator (agent, Opus 5.5)"]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: force-levels-four, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# Force is for objective-level kinds; required is for this version, critical is critical to quality

## Context and Problem Statement

[[decision:force-levels-four]] kept `force: non | desired | required | critical` on objectives, and left open what separates `required` from `critical`. The coordinator then asked whether `force` should give way to the RFC 2119 key words already used in an objective's Statement (MUST, SHOULD), with a view deriving the force from them.

## Decision Drivers

* Force says how much an objective matters to the spec. The key words in a Statement say what conformance requires. They answer different questions.

## Assumptions

* None recorded.

## Considered Options

* Keep `force` as its own field on objective-level kinds, and define `critical` (chosen)
* Derive force from the RFC 2119 key words in the Statement, collapsing `required` and `critical` into MUST

## Decision Outcome

Chosen:

- **`force` stays a separate field**, carried by the objective-level kinds: objectives, and principles and fitness where they carry one.
- **`required`** is an intention for this version.
- **`critical`** marks a CTQ (critical-to-quality) objective: one that, because of other factors, is expected to have an outsized impact on the success or utility of the spec.

`non` and `desired` keep their meanings from [[decision:force-levels-four]].

### Quote

> Ah right-- objectives (and or principles and or fitness)-- I think that it is appropriate to have this separate force for objective-level kinds here.  
> And with that in mind, I can tell you the difference between required and critical. Required is an intention for this version. Critical is a CTQ objective-- critical to quality-- where, due to other factors, it is expected to have an outsized impact on the success or utility of the [spec, in this case].
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.14)

### Positive Consequences

* Writers can choose between `required` and `critical` by rule.
* `required` is scoped to a version, so a later version can re-grade it without a new decision about the objective itself.

### Negative Consequences

* Force and a Statement's key words can disagree, for example a `desired` objective whose Statement says MUST.

### What changes

* `sop/def/def-record-fields.md` and `sop/src/conv-purpose-layer.md` define `required` and `critical`, and give `force` to principles and fitness as well as objectives.
* `obj:reserve-dont-ignore`'s working note on its force uses these definitions. Setting the value stays the udon team's.

## Reopen when

* A CTQ objective turns out to matter only for this version, or the reverse, and the two axes need separating.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
