---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The outline must always be true; every cell belongs to one of four concerns"
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

# The outline must always be true; every cell belongs to one of four concerns

## Context and Problem Statement

Outline tables were mixing four different sources of truth in one "state" column: official data from segment frontmatter, rows that exist only in the outline, copies of frontmatter values, and view or process concerns. That made it impossible to say what would make a cell false. Raised by Joseph on 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.1).

## Decision Drivers

* A reader must be able to trust every outline cell without trusting whoever typed it.
* Each cell needs one named source of truth, so that anything that can drift can be linted.

## Assumptions

* That a linter (bespoke now, vsect later) will exist to check the reflected cells. (**recorded**: "which needs a bin/ script to lint and/or update", §1.1)

## Considered Options

* Four concerns, each cell belonging to exactly one (chosen)
* Keep the single mixed `state` column

## Decision Outcome

Chosen: every outline cell belongs to exactly one concern:

1. canon data, which lives in segment frontmatter;
2. outline-only material relevant to the canon as it comes together (gaps, proposed rows, examples, templates);
3. reflections of canon, which a script lints or updates;
4. process and view/projection concerns.

Ordering belongs to concern 2 or 3, or a little of both, depending on whether segments carry a partial order (they carry `depends:`). The governing principle: the outline must always be true.

### Quote

> there is also right now a conflation between what is *official* canonical data-- contained in the frontmatter of the segments themselves, vs what in the outline only but relevant to the canon as it comes together … The principle is that THE OUTLINE MUST ALWAYS BE TRUE.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.1)

### Positive Consequences

* Only concern-3 cells can drift, and those are exactly what the linter checks.
* Rows that exist only in the outline (gaps, proposals) are true by the outline's own declaration.

### Negative Consequences

* Until a linter exists, concern-3 cells are checked by hand.

### What changes

* `main.outline.md` columns get re-typed by concern (the next task after the SOPs).
* [[decision:row-type]], [[decision:column-notation]] and [[decision:doc-state-conforms]] build on this.

## Reopen when

* The four-way split fails to place some real column or row.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* Ordering is partly open: see [[decision:order-lint]].
