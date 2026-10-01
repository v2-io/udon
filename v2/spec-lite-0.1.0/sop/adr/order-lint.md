---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Outline order checked against depends: (undecided)"
status: proposed
decided-by: proposed
decided: ""
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

# Outline order checked against depends: (undecided)

## Context and Problem Statement

Whether and how outline order is checked against the `depends:` partial order (`sop/influx/jaw-proposal-and-feedback.md` §1.1, §3.6).

## Decision Drivers

* None recorded.

## Assumptions

* None recorded.

## Considered Options

* Concern 3: order of documented rows linted against `depends:`; concern 2: forward-reference markers and the order of doc-less rows authored in the outline (the agents' proposal)

## Decision Outcome

Undecided. Left open until the outline linter is needed.

### Quote

> for this project-- undecided for now-- you can leave it open until we have enough to start needing the outline linter working. for now we're just getting the policy/sops/skeleton in place
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.7)

### Positive Consequences

* None identified.

### Negative Consequences

* None identified.

### What changes

* Nothing yet.

## Reopen when

* The outline linter is needed.

## Working notes

* `awaiting-decision: false` because Joseph deliberately deferred this call (see Quote); the deferral, not a decision, clears the flag.

