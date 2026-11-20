---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "No mixing: one record, one kind, one frontmatter per file"
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

# No mixing: one record, one kind, one frontmatter per file

## Context and Problem Statement

Should a file hold parts of several kinds, or several named records (`sop/influx/jaw-proposal-and-feedback.md` §1.6)?

## Decision Drivers

* Markdown has no good way to hold several frontmatters.
* Files have just been settled as the referent for addressing.

## Assumptions

* Full udon's logical stores (don) will later allow document parts to be addressed like database records. (**recorded**, §1.6)

## Considered Options

* Allow mixed or multi-record files
* One record per file (chosen)

## Decision Outcome

Chosen: for now, no mixing. One record, one kind, one frontmatter per file. Anchors inside a file (headings, fixture case ids) are addressable parts of that record, not records of their own.

### Quote

> I think for right now we need to *not* allow mixing -- because we have no good way to have multiple frontmatters in a single markdown segment, as well as the fact that we've pretty much just landed on addressing having files as a referent.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.6)

### Positive Consequences

* The file is the unit of identity, frontmatter and review.

### Negative Consequences

* Some concerns that would read well together must be split.

### What changes

* Mixed segments with headed parts (the fitness discussion) split into separate records once a part is reused or found wrong on its own.

## Reopen when

* Full udon stores make sub-file records addressable.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

