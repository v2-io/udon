---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The SOP store has its own .vsect/ and its own decision set, distinct from lite's"
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

# The SOP store has its own .vsect/ and its own decision set, distinct from lite's

## Context and Problem Statement

Process decisions were being recorded alongside lite's spec decisions (`sop/influx/jaw-proposal-and-feedback.md` §1.9 items 3–4).

## Decision Drivers

* Process decisions have a chain of command even in corpora like AAT, where authority is noise for theory claims.

## Assumptions

* None recorded.

## Considered Options

* Process and spec decisions in one set
* Separate sets (chosen)

## Decision Outcome

Chosen: the SOP store has its own `sop/.vsect/` (its own `kinds.yaml`) and its own decision set, `sop/adr/`. All process decisions are recorded there, starting as soon as possible, separately from udon-lite spec decisions.

### Quote

> keep in mind that everything we've talked about gets its own place in sop/.vsect/ etc. as well. … sop absolutely needs its own adr/dec set -- all process decisions, which yes, should all start getting recorded asap-- distinct from udon-lite spec decisions. BTW-- this is an example of where authority/provinance/accountability/decision-space *is* proper even in something like AAT-- where there is still "chain of command" for processes, so to speak.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.9)

*The directory name `sop/adr/` was chosen by the agent for consistency with lite's `adr/`; Joseph's words were "adr/dec set".*

### Positive Consequences

* Process decisions don't get mixed into the spec's decisions.

### Negative Consequences

* None identified.

### What changes

* `sop/adr/` (this set) and `sop/.vsect/kinds.yaml` are created.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

