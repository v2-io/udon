---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Template files are not records, and never resolve"
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

# Template files are not records, and never resolve

## Context and Problem Statement

`adr/TEMPLATE.md` matches the decision kind's glob `adr/<slug>.md`, so it would resolve as `[[decision:TEMPLATE]]`.

## Decision Drivers

* A template has a kind's shape, but asserts nothing.

## Assumptions

* None recorded.

## Considered Options

* Template files are excluded from resolution by name (chosen)
* Move templates to a separate directory

## Decision Outcome

Chosen: a file named `TEMPLATE.md`, or `<kind>.template.md`, is a template, not a record. Resolution never matches it, and kinds files state the exclusion. An outline may still list a template as a `template` row.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: a template asserts nothing, so letting it answer a lookup would make the corpus claim something nobody said.*

### Positive Consequences

* Templates can sit beside the records they shape.

### Negative Consequences

* The exclusion is by name, so it is a convention to keep.

### What changes

* Both `.vsect/kinds.yaml` files gain `exclude: ["**/TEMPLATE.md", "**/*.template.md"]`.

## Pros and Cons of the Options

### Exclude by name (chosen)

* Good, because the template stays where writers look for it.

### Separate directory

* Bad, because directories carry no meaning here ([[decision:directories-organizational]]), so it wouldn't be enough on its own.

## Reopen when

* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

