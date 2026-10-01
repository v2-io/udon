---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Frontmatter flags show — on rows that have no document"
status: accepted
decided-by: ratified
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

# Frontmatter flags show — on rows that have no document

## Context and Problem Statement

Gap rows and undrafted proposed rows have no frontmatter, yet they are the rows most likely to be awaiting a decision (`sop/influx/jaw-proposal-and-feedback.md` §3.8, §1.7 item 1).

## Decision Drivers

* Keep the notation clean: a ※ column is only ever frontmatter.

## Assumptions

* None recorded.

## Considered Options

* `—`, with the pending decision recorded in its ADR or pre-design question (chosen)
* Let the outline author the flags for rows with no document

## Decision Outcome

Chosen: a ※ flag column shows `—` on rows with no document. A pending decision about such a row lives in the decision record or question it concerns.

### Quote

> isn't this already answered by my prior comments? — / ∅ Are you talking about a non ※ / ∂ column?
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.7)

*Authority: Joseph's quoted words are a question confirming the coordinator's reading; the reading is the coordinator's, so this is `ratified`.*

### Positive Consequences

* No authored column hiding among the ※ columns.

### Negative Consequences

* A reader must look at the decision or question to see that a gap is waiting on the steward.

### What changes

* Nothing yet.

## Reopen when

* A view needs to show pending decisions on doc-less rows at a glance.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* **Open for Joseph:** a `landed` row whose doc-state is `missing` (known canon, not yet drafted). By his own definitions its flags are applicable but missing, which is `∅`, not `—`. As written, this decision gives `—` to every row with no document. [[decision:row-type]]'s working note gives the reading under which `∅` is right: the orthogonal proposal makes `landed` + `missing` valid. Also, a pending decision now lives in its ADR or in the working notes of the record it concerns, since open questions moved to working notes ([[decision:open-questions-in-working-notes]]).
