---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A fixture file is a YAML mapping: kind, flags, depends, notes, cases"
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

# A fixture file is a YAML mapping: kind, flags, depends, notes, cases

## Context and Problem Statement

Fixture files are records ([[decision:fixtures-are-records]]), but YAML has no frontmatter. The helpers used a mapping with a `cases:` key. The alternative is a first YAML document acting as frontmatter.

## Decision Drivers

* One record, one parse.

## Assumptions

* None recorded.

## Considered Options

* A single mapping with `cases:` (chosen)
* A two-document file, the first acting as frontmatter

## Decision Outcome

Chosen: a fixture file is one YAML mapping. Its top-level keys are the record's fields (`kind: fixture`, the three flags, `depends`, `notes`) plus `cases:`, a list of cases each with a stable named `id`. A case's permanent reason goes in `why:` ([[decision:permanent-notes-in-body]]).

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*How this meets the exemplar condition of the delegation: it follows Joseph's own counter-example form (`![[dat/stub.yaml#C7]]`, §1.6): one file, one parse, and cases named so that each can be cited. The `why:` it names is now the kept form under [[decision:notes-disposition-at-freeze]].*

### Positive Consequences

* Any YAML parser reads it in one go; `dat/implied-root.yaml` already has this shape.

### Negative Consequences

* It differs from Markdown records' frontmatter-plus-body shape.

### What changes

* None now. `dat/implied-root.yaml` already conforms, apart from `why:`.

## Pros and Cons of the Options

### Mapping (chosen)

* Good, because it is one parse.

### Two documents

* Bad, because many tools read only the first document.

## Reopen when

* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

