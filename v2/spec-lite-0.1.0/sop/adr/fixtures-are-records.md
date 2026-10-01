---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Fixture files are records of kind fixture that no outline lists"
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

# Fixture files are records of kind fixture that no outline lists

## Context and Problem Statement

The agents first proposed making fixture files "mechanism files" outside the record kinds, while giving them more record machinery. Joseph pointed out the contradiction (`sop/influx/jaw-proposal-and-feedback.md` §1.7 item 10, §1.8 item 10).

## Decision Drivers

* What the corpus consists of is defined by the kinds map, not by outline membership.

## Assumptions

* None recorded.

## Considered Options

* Fixtures as non-record mechanism files (withdrawn)
* Fixtures as records of kind `fixture` at file grain, listed in no outline (chosen)

## Decision Outcome

Chosen: a fixture file is a record of kind `fixture`, at file grain, with its kind in a top-level YAML key. No outline need list it. Case ids are stable named anchors inside the record, never reused. Rules cite fixture files with `test-fixtures:`, and prose may transclude a case with `![[dat/<slug>.yaml#<case-id>]]`. Propagating fixture changes through the citing rule's git hash is parked as a note for the future linter.

### Quote

> it really is the kinds-map that tells us what the corpus is-- reinforcing the idea that outlines are just views/projections (although I'm not suggesting that that will continue to hold in the future-- there very well might be a call for `at least one canonical full view`-- maybe not, but the "outline = view" is a *working theory* and not a fixed ideal).
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.8)

> It's a kind of record that is used for mechanisms outside of the outline...
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.6), and §1.7 item 10, objecting to the agents' attempt to make fixtures non-records

### Positive Consequences

* Fixtures stay under the same machinery as every other record.

### Negative Consequences

* "Outline = view" is a working theory; if a canonical full view is ever required, unlisted records need revisiting.

### What changes

* `fixture` stays in the record kinds, with the note that a record may be listed in no outline.

## Reopen when

* A canonical full view becomes required.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* **Authority corrected (2026-09-30):** first recorded as `supported`. Joseph's own words (§1.6, and his objection in §1.7 item 10) state the core claim, that fixtures are records which no outline need list, so it is `steward`. The details (stable named case ids; parking hash-based change propagation) are the agents'.
