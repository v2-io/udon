---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Open questions live in records' working notes (or discussion), not in outlines"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5)]
informed: [spec-lite fork (agent, Opus 5.5), udon team]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Open questions live in records' working notes (or discussion), not in outlines

## Context and Problem Statement

When spec-lite was first structured as a verisectorium, its open pre-design questions were dumped into the spec's main outline as an Open-questions table, and as a question column on each row. Open questions were then the main thing in its influx. Joseph clarified that this was a guess, not the shape of a well-written spec.

## Decision Drivers

* An outline presents current truth ([[decision:outline-is-current-truth]]).
* Traditionally, open questions are what working notes are for.

## Assumptions

* None recorded.

## Considered Options

* Open questions as an outline table and column (the first carving's guess)
* Open questions in the working notes of the records they bear on, or in a discussion record when they are more permanently open (chosen)

## Decision Outcome

Chosen: in this corpus, open questions live in the working notes of the records they bear on. Questions that stay open more permanently live in discussion. They are not tabulated in outlines. A record with open questions in its working notes cannot be considered frozen ([[decision:working-notes-and-frozen]]).

### Quote

> Traditionally, open questions have been the bread and butter of "working notes" (and sometimes "discussion" if they are more permanently open questions). That's where I'd probably recommemd they stay in this context. The original dump of questions into the main outline as we verisectified this spec-lite was a guess due to open questions being the main thing in influx at the time. It's not a reflection of a well-written spec.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*This is a process decision for how this side structures the example spec. Whether lite's own corpus uses a question kind is the udon team's call.*

### Positive Consequences

* The main outline reads as the spec's current state.
* Each question sits beside the record it bears on.

### Negative Consequences

* No single list of all open questions exists until a view is generated from working notes.

### What changes

* `main.outline.md` loses its Open-questions table and its Pre-design column; each record's working notes carry the questions that bear on it.
* Rows with no document keep their questions in the outline's working notes until their record exists.

## Reopen when

* The udon team adopts an open-question kind (Joseph intends to vote for a `wut/` directory). Questions would then become records that working notes point to.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

