---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Everything from the SOP side in spec-lite is example, proposed or template; lite's decisions are the udon team's"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5), spec-lite fork (agent, Opus 5.5)]
informed: [udon team]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Everything from the SOP side in spec-lite is example, proposed or template; lite's decisions are the udon team's

## Context and Problem Statement

The SOP work had drafted spec content (sample rules, definitions, seeded lite decisions) (`sop/influx/jaw-proposal-and-feedback.md` §1.9 items 6 and 8).

## Decision Drivers

* Lite's design belongs to the udon team.

## Assumptions

* None recorded.

## Considered Options

* Only one option was considered.

## Decision Outcome

Chosen: everything written from the SOP side into lite's corpus is example, proposed or template, marked with those row-types. Lite's own decisions (converting its seeded decisions to ADRs, `force` on reserve-don't-ignore, closer routing) are left to the udon team. Inputs are handed over through `.int/`, e.g. `.int/vsect-requirements-on-lite.md`.

### Quote

> leave it to the udon team-- everything from us here is example & proposed & template. BTW-- that's one of our main tasks next after getting the SOPs in place, is actually fixing the outline so that they have the right columns and so that row-type indicates them as examples etc.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.9)

*Joseph expects the udon team to want an open-question kind, and intends to vote for a `wut/` directory for it (§1.10).*

### Positive Consequences

* Clear ownership.

### Negative Consequences

* None identified.

### What changes

* In `main.outline.md`, rows from this side are marked `example` (drafted samples) or `proposed` (rows with no document), and none are `template`. *(Changed 2026-09-30: this line first said all rows would be `example`, which Joseph's "row-type indicates them as examples etc." supports. Marking rows with no document `proposed` is the agents' judgment, for him to confirm.)*

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

