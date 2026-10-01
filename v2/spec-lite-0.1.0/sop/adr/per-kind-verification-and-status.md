---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "verification-level is declared per kind; ∂(status) is computed per kind"
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

# verification-level is declared per kind; ∂(status) is computed per kind

## Context and Problem Statement

What verifies a record differs by kind, and by corpus. In spec-lite it is mostly authorized decision (`sop/influx/jaw-proposal-and-feedback.md` §1.7 items 2 and 8, §3.9, §3.14).

## Decision Drivers

* No hand-set strength: what verifies a record is written only by the act that verifies it.
* Kind-specific measures.

## Assumptions

* In this corpus, most records' verification is mostly about authorized decision. (**recorded**, §1.7 item 8)

## Considered Options

* One verification ladder for all kinds
* A ladder declared per kind (chosen)

## Decision Outcome

Chosen: each kind declares its verification ladder in `kinds.yaml`. `verification-level` is a frontmatter field written only by the act that verifies, with a pointer to the evidence. ∂(status) is calculated per kind, from that kind's measure and the flags.

### Quote

> seems like a calculated field that has a different measure depending on the kind (and possibly other flags/fields), right? … sounds good... assuming verification level is kind-specified (since, for example, it's mostly about authorized decision in our case). … this is kind of the very critical core of verisectorium's epistemology in general-- something that might need more clarity later or a revisit of RC1 etc.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.7–§1.8)

### Positive Consequences

* Status can't drift, because it is computed.

### Negative Consequences

* The ladders are placeholders until each kind's is confirmed.

### What changes

* `kinds.yaml` gains a `verification:` ladder per kind.

## Reopen when

* RC1 is revisited on how a kind's verification-level relates to its dimensions (§3.14 note).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* The git hash in the evidence pointer (for staleness) is a proposal, not yet decided.
