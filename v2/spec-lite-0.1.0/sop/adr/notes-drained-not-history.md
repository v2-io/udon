---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Working notes are drained continually, and never hold history"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["aat-refactored coordinator (agent, Opus 5.5)"]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: notes-disposition-at-freeze, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# Working notes are drained continually, and never hold history

## Context and Problem Statement

[[decision:notes-disposition-at-freeze]] let working notes hold anything, and required each note to be dispositioned only before freeze. It replaced an earlier rule that notes hold only open work, a rule Joseph had not asked for. Joseph then said what he does want: the open-work norm as encouragement rather than enforcement, and one firm exclusion.

## Decision Drivers

* A notes section that has to be re-adjudicated on every read costs every later reader.
* Git and the changelog already hold history, and hold it better.

## Assumptions

* That a changelog record will be defined. `sop/main.outline.md` has it as a `gap` row, [[conv:changelog]]. (**recorded**: Joseph, "the changelog records [which we may not have defined yet]")

## Considered Options

* Only one option was considered: Joseph stated it.

## Decision Outcome

Chosen:

- **Draining is highly encouraged, not enforced.** Working notes should be drained continually, so that for the most part they hold open work only. No check fails on it.
- **Working notes are not for history, changelog entries, or breadcrumbs of past work that won't be needed.** Those belong in the changelog records and in git log history.
- **The norm:** an empty, still-relevant-only notes section is far better than an accumulation of historical cruft that has to be constantly re-adjudicated.

This revises [[decision:notes-disposition-at-freeze]] in one part: notes no longer "may hold anything", because history is excluded. Its four dispositions and its freeze check stand.

### Quote

> First-- maybe re-add your "working notes only hold open work" as "it is highly encouraged but not currently enforced that working notes get drained continually so that they hold open work only for the most part." You can also add this decision I'm articulating now: that working notes are *NOT* for history, changelog, or breadcrumbs for past work that will not be needed. Those things should be part of the changelog records [which we may not have defined yet] and git log history. An empty and "still relevant only" working notes section is, normatively, far superior to an accumulation of historical cruft that has to be constantly readjudicated.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.13)

### Positive Consequences

* Notes stay worth reading.
* A record's history has one home, which git makes checkable.

### Negative Consequences

* Until [[conv:changelog]] is written, history that git alone can't carry has no defined record.

### What changes

* `sop/src/conv-working-notes.md`, `sop/def/def-record.md` and `adr/TEMPLATE.md` state the encouragement and the exclusion.
* Existing working notes in both stores are swept, and history and breadcrumb notes are removed.

## Reopen when

* Draining needs enforcing, because notes accumulate anyway.
* Some past-work note turns out to be needed by a reader, and neither git nor the changelog can reach it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
