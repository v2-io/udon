---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The kept-notes section is Discussion, not Why; outlines have none"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["aat-refactored coordinator (agent, Opus 5.5)"]
informed: [spec-lite fork (agent, Opus 5.5)]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# The kept-notes section is Discussion, not Why; outlines have none

## Context and Problem Statement

Agents named the body section for kept notes and rationale "Why", gave every SOP convention and directive a Why section, and added a Why section to the spec store's outline. Joseph had not decided either choice. ASF's format SOP already names this section: "Discussion — interpretation, connections — brief".

## Decision Drivers

* Use the estate's existing name where one exists.
* An outline is a view of current truth ([[decision:outline-is-current-truth]]); notes about the view don't belong in it.

## Assumptions

* None recorded.

## Considered Options

* "Discussion", and no notes section in outlines (chosen)
* Keep "Why"

## Decision Outcome

Chosen:

- **The body section for kept notes, rationale and interpretation is `## Discussion`**, in every kind that has one, including conventions and directives.
- **An outline has no such section.** The spec store's outline instead opens by pointing to the SOP store's own outline, which covers how outlines and the rest of the corpus work.

### Quote

> Ah, this is one of the decisions I didn't ratify-- a separate section in outlines that is for retained working notes?  I think you meant "Discussion" unless you have a good reason for "Why" that I'm just missing somehow

> Yes. Could you go ahead and delete the why section and instead set up a link and brief description above the legend (as first thing under "Working on UDON..." that discusses the fact that the SoPs have their own outline which covers, amont other things, how the outlines work etc. etc.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.20), the second answering "can I mark 'Discussion, not Why, and no notes section in outlines' as your decided position?"

### Positive Consequences

* One section name across the estate.

### Negative Consequences

* None identified.

### What changes

* Every `## Why` in both stores becomes `## Discussion`.
* `sop/src/conv-record-cadence.md` and `sop/src/conv-working-notes.md` name Discussion, and the cadence says outlines have no notes section.
* `main.outline.md` drops its Why section and opens with a pointer to [`sop/main.outline.md`](../main.outline.md).

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
