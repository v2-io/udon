---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Every outline row declares a row-type: example, gap, template, exploratory, proposed or landed"
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
superseded-by: [{adr: landed-may-be-missing, how: revised, scope: partial}]
closes: []
leaves-open: []
---

# Every outline row declares a row-type: example, gap, template, exploratory, proposed or landed

## Context and Problem Statement

The outline has several kinds of row that differ in their relationship to canon, and the old `state` column conflated that with document existence (`sop/influx/jaw-proposal-and-feedback.md` §1.1).

## Decision Drivers

* A gap in the theory needs a proper way to be shown.
* Only one kind of row should require a decision.

## Assumptions

* None recorded.

## Considered Options

* A single row-type field with six values (chosen)
* Split into role (example, template, gap, record) and commitment (exploratory, proposed, landed): proposed by the fork, then withdrawn, because the six values are mutually exclusive in this model

## Decision Outcome

Chosen: `row-type`, authored in the outline (concern 2), with values `example`, `gap`, `template`, `exploratory`, `proposed`, `landed`.

- `landed` is the one value that needs a decision; it implies drafted, and it starts the row on the frontmatter fields.
- Rows of the other five types can be placed in an outline without any decision.
- `exploratory` differs from `proposed` in that it does not yet know whether it wants to be proposed.
- Everything from our side is example, proposed or template ([[decision:our-side-is-example]]).

### Quote

> row-type: example, gap, template, exploratory, proposed, landed (becomes proper way to indicate a gap in the theory, "landed" starts them on the ladder below) … exploratory drafted rows (unlike proposed-drafted, these don't know yet if they want to actually be proposed until more exploration is done)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.1)

*The process rule "a landed row cites a decision" was accepted as process on 2026-09-30 ("sure-- although for now, again, just put that as the process in sops with notes for the future linter", §1.7 item 7).*

### Positive Consequences

* "Canon" has a precise meaning: row-type `landed`.
* `landed` plus doc-state `missing` expresses known canon with no first draft yet.

### Negative Consequences

* Hypothesis-grade rows are not a row-type here; Joseph does not expect them to apply to this corpus.

### What changes

* `main.outline.md` gains a row-type column. This side's drafted samples are `example`, and its rows with no document are `proposed`. *(Changed 2026-09-30: this line first said all of this side's rows would be `example`. Marking rows with no document `proposed` is the agents' judgment.)*
* Process rule: a `landed` row must cite at least one decision in `per` (a manual check for now, with a note for the future linter).

## Reopen when

* A row appears that fits none of the six values.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
