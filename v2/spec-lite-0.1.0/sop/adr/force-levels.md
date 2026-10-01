---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "An objective's force is non, desired or required"
status: superseded
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: [{adr: force-levels-four, how: invalidated, scope: full}]
closes: []
leaves-open: []
---

# An objective's force is non, desired or required

## Context and Problem Statement

The purpose layer gave objectives a `force` field with four values: `non`, `desired`, `required`, `critical`. Nothing separated `required` from `critical`. Joseph's own framing had three levels: objective, non-objective, and a critical level he suggested calling "req".

## Decision Drivers

* Each value must be distinguishable by how a breach is treated.

## Assumptions

* None recorded.

## Considered Options

* Three levels: `non`, `desired`, `required` (chosen)
* Four levels, with `critical` separate

## Decision Outcome

Chosen: `force` takes `non` (an explicit non-goal), `desired` (an objective, met if possible) or `required` (a requirement; a rule set that breaches it is defective). `required` is Joseph's critical level, under his suggested name. `critical` is retired until some case shows a fourth level is needed.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Every value has a different treatment.

### Negative Consequences

* If a fourth level is ever needed, records will be re-graded.

### What changes

* `sop/src/conv-purpose-layer.md`, `sop/def/def-record-fields.md` and `def-record-kinds.md` drop `critical`. `obj:reserve-dont-ignore` keeps its empty `force` for the udon team; its working-notes lean becomes `required`.

## Pros and Cons of the Options

### Three levels (chosen)

* Good, because each level changes what happens on a breach.

### Four levels

* Bad, because nothing yet distinguishes `required` from `critical`.

## Reopen when

* Two required objectives conflict, and one must yield.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* Superseded by [[decision:force-levels-four]]: dropping `critical` reversed a split Joseph had already agreed to (18:23Z, §1.12), which the delegation did not cover.

