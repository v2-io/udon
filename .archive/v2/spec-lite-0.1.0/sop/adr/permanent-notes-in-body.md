---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Permanent notes go in the body; working notes hold only open work"
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
superseded-by: [{adr: notes-disposition-at-freeze, how: invalidated, scope: full}]
closes: []
leaves-open: []
---

# Permanent notes go in the body; working notes hold only open work

## Context and Problem Statement

[[decision:working-notes-and-frozen]] bars a record with working notes from being considered frozen. Its reopen condition is "some kind needs to carry permanent notes that are not open work": cautions, regression guards, a fixture case's reason for existing.

## Decision Drivers

* Keep the frozen rule simple and checkable.
* Permanent explanation is part of what a record says, not work left to do.

## Assumptions

* None recorded.

## Considered Options

* Permanent notes move into body sections; working notes hold only open work (chosen)
* Exempt some working notes from the frozen rule

## Decision Outcome

Chosen: working notes hold only open work (questions, doubts, unverified leads, known work). Permanent material lives in the body, under a section the kind's cadence names: for example **Why**, **Cautions** or **Regression guards**. In a fixture file, a case's permanent reason goes in a `why:` field, and `notes:` holds only open work.

This answers [[decision:working-notes-and-frozen]]'s reopen condition without reopening it: permanent notes are not working notes.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* The frozen rule needs no exceptions.
* A reader knows that anything in working notes is unfinished.

### Negative Consequences

* Writers must decide, per note, whether it is open work or permanent.

### What changes

* `sop/src/conv-working-notes.md` and `sop/src/conv-record-cadence.md` gain the body sections; `dat/implied-root.yaml` cases gain `why:` where a note is a permanent reason.

## Pros and Cons of the Options

### Body sections (chosen)

* Good, because "notes present" keeps one meaning.

### Exemptions

* Bad, because every note would need classifying before the frozen check could run.

## Reopen when

* A note turns out to be neither open work nor body material.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

