---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A link to a record that has an outline row but no document is \"unwritten\", not a dangle"
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

# A link to a record that has an outline row but no document is "unwritten", not a dangle

## Context and Problem Statement

Outlines carry `proposed` rows for records not yet written, and other records sometimes need to name them. The helpers split: some linked them, others wrote them in backticks.

## Decision Drivers

* A proposed record is a real referent, by the outline's own declaration (concern 2).
* A broken link must still be detectable.

## Assumptions

* None recorded.

## Considered Options

* Allow the link; it resolves to the outline row, reported as "unwritten" (chosen)
* Forbid links until a document exists
* Treat it as a dangle

## Decision Outcome

Chosen: a `[[kind:slug]]` with no document resolves to an outline row of that store naming the same `kind:slug`, if one exists. A linter reports it as **unwritten**, which is information, not an error. If no outline row names it either, it is a **dangle**, which is an error.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Records can name what is planned without pretending it exists.
* Real breakage still surfaces.

### Negative Consequences

* The resolver has to read outlines as well as files.

### What changes

* Examples that wrote undrafted records in backticks may link them as `[[kind:slug]]`.

## Pros and Cons of the Options

### Unwritten, not a dangle (chosen)

* Good, because the outline row is the referent until a document exists.

### Forbid

* Bad, because the backtick workaround hides real references from the resolver.

### Dangle

* Bad, because every planned record would read as an error.

## Reopen when

* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

