---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "awaiting-decision means awaiting the store's declared decider"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# awaiting-decision means awaiting the store's declared decider

## Context and Problem Statement

`awaiting-decision` was defined as "waiting for the steward". In lite's store, decisions belong to the udon team ([[decision:our-side-is-example]]), so "the steward" is ambiguous there.

## Decision Drivers

* A flag must name whose call it waits on.

## Assumptions

* The udon team may designate its own decider. (**recorded**: the coordinator's, at decision time; it is the decider under delegation)

## Considered Options

* Each store declares its decider (chosen)
* Always the steward

## Decision Outcome

Chosen: `awaiting-decision: true` means the record is waiting on its store's declared decider. Each store declares one in its `.vsect/kinds.yaml` (`decider:`):

- the SOP store's is Joseph (steward);
- the spec store's is the udon team's decider, Joseph unless the team declares otherwise.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: it keeps Joseph's definition of the flag ("waiting for steward to review and make a decision") while leaving lite's decisions to the udon team ([[decision:our-side-is-example]]).*

### Positive Consequences

* The flag reads the same everywhere, and its target is explicit.

### Negative Consequences

* None identified.

### What changes

* `.vsect/kinds.yaml` declares `decider: udon team (Joseph unless declared otherwise)`; `sop/.vsect/kinds.yaml` declares `decider: Joseph (steward)`. `sop/def/def-record-fields.md` updates its definition of the flag.

## Pros and Cons of the Options

### Per-store decider (chosen)

* Good, because the same flag works in stores with different owners.

### Always the steward

* Bad, because it misattributes lite's decisions.

## Reopen when

* The udon team declares a decider.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

