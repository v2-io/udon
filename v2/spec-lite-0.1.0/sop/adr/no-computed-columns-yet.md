---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Outlines show no ※ or ∂ columns until a linter exists"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Outlines show no ※ or ∂ columns until a linter exists

## Context and Problem Statement

Computed (∂) and frontmatter-reflected (※) columns are only true while something keeps them true. With no linter yet, a hand-maintained reflection drifts: the spec outline's question column had already disagreed with the records' own `questions:` field on question 89. A "blank means not yet computed" cell state was proposed as an alternative.

## Decision Drivers

* The outline must always be true ([[decision:outline-always-true]]).
* Each view chooses which ※ and ∂ columns to show ([[decision:column-notation]]).

## Assumptions

* A linter (bespoke `bin/`, then vsect) will exist. (**recorded**: Joseph, "which needs a bin/ script to lint and/or update", §1.1; and `bin/` was created for "bespoke processing scripts", §1.12, 18:23Z)

## Considered Options

* No ※ or ∂ columns until a linter exists (chosen)
* Show them, with a blank cell meaning "not yet computed"
* Show them, hand-maintained

## Decision Outcome

Chosen: no outline in this corpus shows a ※ or ∂ column until a linter exists to compute or check it. Each view adds such columns when they can be kept true. No "not yet computed" cell state is introduced.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: it is the weakest of these on that test. It keeps the outline true, but the stronger option, writing the linter, wasn't weighed when it was decided; the working notes say so.*

### Positive Consequences

* No hand-typed reflection can drift.
* No fourth cell state.

### Negative Consequences

* Outlines show less at a glance until the linter exists.

### What changes

* Already applied, provisionally, to `main.outline.md` and `sop/main.outline.md`; this record makes it standing.

## Pros and Cons of the Options

### No columns until a linter (chosen)

* Good, because nothing in an outline can disagree with its source.
* Bad, because a reader opens records to see their state.

### Blank means not computed

* Good, because the columns exist ready for the linter.
* Bad, because it adds a fourth cell state whose meaning expires.

### Hand-maintained

* Bad, because it drifted within a day (question 89).

## Reopen when

* A linter exists: then each view decides which columns to show.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* **A stronger option was not considered when this was decided: write the linter.** A ※ column is a frontmatter read, and the frontmatter is small. A first `bin/` script that fills ※ columns and ∂(doc-state) would make the columns true, rather than hiding them until something does. This decision stays in force only until that script exists, and writing it is the natural next step (raised by the second look, `sop/influx/adr-check-notes.md`).

