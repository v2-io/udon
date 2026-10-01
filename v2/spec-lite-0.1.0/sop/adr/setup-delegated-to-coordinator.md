---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Setup decisions for this corpus are delegated to the coordinator, pending ratification"
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

# Setup decisions for this corpus are delegated to the coordinator, pending ratification

## Context and Problem Statement

After a long session of setting up spec-lite-0.1.0 as a verisectorium (the SOP store, the decision set, the examples), several setup decisions remained open. In scope when Joseph delegated: the seven open items the coordinator listed with its leans (cross-store links; links to unwritten records; permanent notes versus the frozen rule; force levels; fixture file shape; who the decider is in lite's records; templates resolving as records), aligning the earlier decisions with the revised template, and the fork's two earlier provisional leans (no computed columns yet; bare slugs in typed fields). Joseph delegated them, and "other decisions related to the setup".

## Decision Drivers

* Keep work moving without routing every setup call through the steward.
* Keep authority honest: delegated calls must be visibly delegated and visibly unratified.

## Assumptions

* That the coordinator treats this corpus as an exemplar for the udon work, verisectorium and ASF. (**recorded**: it is the condition of the delegation)

## Considered Options

* Delegate the remaining setup decisions to the coordinator, marked and pending ratification (chosen)
* Route each one to the steward

## Decision Outcome

Chosen: the remaining setup decisions, and other decisions related to the setup, are delegated to the aat-refactored coordinator. They are made on the condition that the coordinator looks at everything holistically and thoughtfully, as an exemplar for moving the udon work forward, and through it verisectorium and ASF.

Each decision made under this authority:

- names the coordinator as decider, under this record;
- carries `decided-by: supported`;
- carries `awaiting-decision: true` until Joseph ratifies it, where ratification applies;
- carries `awaiting-second: true` until another mind has checked it against its sources.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Setup can proceed at the pace of the work.
* Every delegated call is findable: the decisions citing this record are the coordinator's.

### Negative Consequences

* Delegated calls can accumulate unratified. Ratification is the steward's job, at his pace.

### What changes

* Delegated decisions in `sop/adr/` cite this record.

## Reopen when

* Joseph withdraws or narrows the delegation.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

