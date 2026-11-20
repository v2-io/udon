---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Kind is declared in frontmatter; slug prefix and directory are clues only"
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

# Kind is declared in frontmatter; slug prefix and directory are clues only

## Context and Problem Statement

Kind was being inferred from slug prefixes, and a fixture file carried the rule prefix (`dat/rule-implied-root.yaml`) (`sop/influx/jaw-proposal-and-feedback.md` §1.5).

## Decision Drivers

* The linter must find the right record of the right kind.
* Prefixes were adopted for `ls` legibility in AAT, not as identity.

## Assumptions

* None recorded.

## Considered Options

* Kind from the slug prefix
* Kind declared in frontmatter, with prefix and directory as clues (chosen)

## Decision Outcome

Chosen: frontmatter `kind:` is authoritative. A slug prefix or home directory can hint at the kind, but explicit resolution rules govern ([[decision:kinds-yaml-resolution]]). Naming a record with another kind's prefix is an error however files are organized.

### Quote

> *frontmatter* declares kind, and its home directory and slug prefix *can* be clues / quick indications for kind-- but it will require explicit rules for the outline linter … So naming one kind of record with a prefix of another kind of record is *definitely* a problem regardless of how they're organized. It would be better if it was dat/implied-root.yaml and we can specify a mapping.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.5)

### Positive Consequences

* Slugs no longer need kind prefixes to be unambiguous.

### Negative Consequences

* Files without frontmatter (YAML fixtures) need a top-level `kind:` key.

### What changes

* `dat/rule-implied-root.yaml` → `dat/implied-root.yaml`, cited from the rule by `test-fixtures:`.

## Reopen when

* A record kind emerges that cannot carry frontmatter.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

