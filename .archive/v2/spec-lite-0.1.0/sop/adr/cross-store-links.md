---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Cross-store references are [[store/kind:slug]], with stores declared by name"
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

# Cross-store references are [[store/kind:slug]], with stores declared by name

## Context and Problem Statement

Records in one store sometimes need to cite records in another: the spec store's examples cite SOP conventions; definitions cite the addressing theory's terms in `../references/def/`. The helpers used file paths for now, which ties links to layout.

## Decision Drivers

* References name records, not locations ([[decision:directories-organizational]]).
* One reference form, extended rather than replaced.

## Assumptions

* Store roots are stable enough to declare once per store. (**recorded**: the coordinator's, at decision time; it is the decider under delegation)

## Considered Options

* `[[store/kind:slug]]` with named stores (chosen)
* File paths
* `[[store:kind:slug]]`

## Decision Outcome

Chosen:

- **An unqualified `[[kind:slug]]`** resolves within the current store.
- **A reference into another store** is `[[store/kind:slug]]`: for example `[[sop/conv:outline]]` from the spec store, `[[spec/rule:implied-root]]` from the SOP store, and `[[references/def:binding]]` for the addressing theory.
- **Each store declares the stores it may reference** by name in its `.vsect/kinds.yaml` (`stores: {name: path-to-root}`). The target store's own kinds file then resolves the `kind:slug`.
- **Non-record files** (influx documents, READMEs) are still linked by relative path.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: it extends Joseph's one reference form rather than adding a second, and leaves resolution to the store that owns the record, as his kinds-file design does.*

### Positive Consequences

* Moving a store means one path change, in one declaration.
* Resolution reuses each store's own kinds file.

### Negative Consequences

* A store name is one more thing to keep stable.

### What changes

* `.vsect/kinds.yaml` declares `stores: {sop: sop}`; `sop/.vsect/kinds.yaml` declares `stores: {spec: .., references: ../../references}`.
* Path links between stores in the examples become `[[store/kind:slug]]` when next edited.

## Pros and Cons of the Options

### `[[store/kind:slug]]` (chosen)

* Good, because `/` reads as "inside", and slugs never contain it.

### `[[store:kind:slug]]`

* Bad, because two colons are ambiguous when the store name is omitted.

### File paths

* Bad, because they break when layout changes.

## Reopen when

* A store with no stable root (e.g. a database-backed don store) needs referencing.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* The references corpus (`../references/`) has no `.vsect/kinds.yaml` yet. Until it does, `[[references/def:binding]]` resolves by its `def/def-<slug>.ud` convention, which is noted in the SOP store's kinds file.
