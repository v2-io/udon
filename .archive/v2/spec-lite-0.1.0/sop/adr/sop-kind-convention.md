---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Admit convention as an SOP kind, alongside directive and reference"
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

# Admit convention as an SOP kind, alongside directive and reference

## Context and Problem Statement

While carving the SOP store, the fork found that most of what the store holds (notation, field values, naming, reference syntax) is neither a directive (a practice carried out at a named moment) nor a reference (working facts that change as the world does). The verisectorium template's SOP outline has only `directive` and `reference`. The fork proposed a third kind, `convention`, in `sop/def/def-sop-kinds.md`, and flagged it as awaiting a decision.

## Decision Drivers

* A kind is admitted when it fails differently and is repaired differently from every other kind.
* Most of this store's content is rules of form, which a linter could check.

## Assumptions

* A convention's violations show up in the artifacts themselves, so a linter can find them. (**inferred, unconfirmed**: the agents' reading, stated in `def-sop-kinds`)

## Considered Options

* Admit `convention` as a third SOP kind (chosen)
* Fold conventions into `directive`
* Fold conventions into `reference`

## Decision Outcome

Chosen: admit `convention` as an SOP kind.

- **Convention:** a standing rule about how records and views are shaped. It fails by being ambiguous, contradicted by the corpus, or colliding with another convention. It is repaired by clarifying it, fixing the violating records, or superseding it.
- **Directive:** fails by not firing when its moment comes, which only watching work can reveal.
- **Reference:** fails by going stale as the world moves.

### Quote

> 3. sure
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11), answering "`convention` as an SOP kind. My lean is to admit it."

*`decided-by: ratified`: the kind was the agents' proposal; Joseph accepted it.*

### Positive Consequences

* Each convention states how a violation would show up, which is the specification for the future linter.

### Negative Consequences

* It departs from the verisectorium template's two SOP kinds. If it proves out, it should flow back to the template through verisectorium's influx.

### What changes

* `sop/def/def-sop-kinds.md` no longer awaits a decision on this point and cites this record.
* `sop/.vsect/kinds.yaml` already declares `convention`.

## Reopen when

* Conventions turn out to fail and be repaired the same way as directives or references.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

