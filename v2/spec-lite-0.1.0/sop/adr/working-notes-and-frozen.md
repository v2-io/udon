---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Any record may have working notes; a record with notes cannot be considered frozen"
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

# Any record may have working notes; a record with notes cannot be considered frozen

## Context and Problem Statement

Joseph had asked the fork for "allowances for working-notes everywhere". The fork's convention (`conv:working-notes`) turned that into a stricter rule: every record ends with a Working notes section, present even when empty. Nothing recorded the policy as a decision.

## Decision Drivers

* A partial or unverified position needs a sanctioned place to live.
* A record that still carries notes has open work, and its standing should not claim otherwise.

## Assumptions

* None recorded.

## Considered Options

* Working notes required on every record, present even when empty (the fork's convention)
* Working notes allowed on every record, and their presence bars a record from being considered frozen (chosen)

## Decision Outcome

Chosen:

- **Every record may have working notes.**
- **A record with any working notes cannot be considered frozen.** That applies wherever its kind has an equivalent of "frozen", such as a `final` state or the top rung of its verification ladder.
- **Whether an empty Working notes heading must be present is not part of the policy.** It doesn't matter to Joseph or to the engine.

### Quote

> Policy should be that every record has the ability to have working-notes, but it cannot be considered frozen (if there is such an equivalent field in that kind, like 'final' or 'fully-verified') if there are any notes in it. Whether or not the header has to be there when its empty is irrelevant to me and the engine.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Open work visibly blocks a claim of finality, and a linter can check it: the top rung, or `final`, together with non-empty working notes, is a violation.

### Negative Consequences

* A record can't reach its kind's final state until its notes are cleared or moved: into the changelog, a question record, or the body once settled.

### What changes

* `sop/src/conv-working-notes.md` drops "always present, even when empty" and gains the frozen rule.
* `sop/src/conv-record-cadence.md` treats a Working notes section as optional.
* Each kind's verification ladder in `kinds.yaml`: its top rung, or any `final`-like state, is unreachable while working notes are non-empty.

## Reopen when

* Some kind needs to carry permanent notes that are not open work.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* Its reopen condition is answered, without reopening it, by [[decision:notes-disposition-at-freeze]]: notes may hold anything, and each is dispositioned before freeze.

* `adr/TEMPLATE.md` (lite's, the udon team's) still says working notes are "always present, even if empty". That's harmless under this policy, but the udon team may want to align it.
