---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Single-kind reference fields take bare slugs; multi-kind fields and prose take kind:slug"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: kind-slug-references, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# Single-kind reference fields take bare slugs; multi-kind fields and prose take kind:slug

## Context and Problem Statement

[[decision:kind-slug-references]] says every reference is `[[kind:slug]]`. Some frontmatter fields can only ever point at one kind: `per` at decisions, `test-fixtures` at fixtures. Others, like `depends`, point at several.

## Decision Drivers

* No reference resolves by guessing.
* No redundant syntax where the field already fixes the kind.

## Assumptions

* None recorded.

## Considered Options

* Bare slugs where the field fixes a single kind; `kind:slug` elsewhere (chosen)
* `kind:slug` everywhere, including single-kind fields

## Decision Outcome

Chosen:

- **A frontmatter field whose referents are all of one kind** takes bare slugs. The field declares the kind: `per` → decision, `test-fixtures` → fixture.
- **A field that can point at several kinds** (`depends`), **and all prose links**, take `kind:slug`.
- **Each single-kind field's kind is declared** in the store's `.vsect/kinds.yaml` (a `fields:` map), so the rule is checkable.

This refines [[decision:kind-slug-references]]; it does not reverse it, because a single-kind field already supplies the kind.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

*Authority: Joseph ruled "[[kind:slug]] everywhere", and this carves an exception, so it is a partial revision of his ruling (`supersedes`: [[decision:kind-slug-references]]). His ratification of this record is what makes the carve-out his.*

*How this meets the exemplar condition of the delegation: it narrows a ruling of Joseph's, so it is offered as a partial revision for his ratification to decide, rather than as a refinement that needs none.*

### Positive Consequences

* Frontmatter stays short where the kind is implied.

### Negative Consequences

* Two spellings exist; the field's declaration decides which applies.

### What changes

* `.vsect/kinds.yaml` in both stores gains `fields: {per: decision, test-fixtures: fixture}`.
* `sop/src/conv-references.md` already states this provisionally; it now cites this record.

## Pros and Cons of the Options

### Bare slugs in single-kind fields (chosen)

* Good, because the field fixes the kind.
* Bad, because a reader must know which fields are single-kind.

### `kind:slug` everywhere

* Good, because there is one spelling.
* Bad, because `per: [decision:x, decision:y]` repeats what the field already says.

## Reopen when

* A single-kind field needs to point at a second kind.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* **Open:** a single-kind field citing a record in another store, e.g. a decision in the SOP store from the spec store, is written `store/slug` (`per: [sop/outline-is-current-truth]`), following [[decision:cross-store-links]]. A fixture case's `exercises` is also single-kind (rule). The spec store's `fields:` now declares it, on the fork's reading that the linter checks case-level fields too; this record doesn't yet say whether case-level fields count.
