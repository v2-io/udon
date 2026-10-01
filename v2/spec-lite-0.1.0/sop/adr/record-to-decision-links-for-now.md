---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "For now, records cite decisions and the reverse is derived"
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

# For now, records cite decisions and the reverse is derived

## Context and Problem Statement

A record names the decisions it rests on in its own `per:`. A decision names the records it moves in "What changes", as `[[kind:slug]]` links, but only as they stood when it was decided. It keeps no maintained list of the records that rest on it: `affects` was dropped because it had drifted ([[decision:sop-decisions-follow-template]]).

That choice was made for drift, not designed. [[decision:landed-may-be-missing]] then exposed a gap: a `landed` row with no document has no `per:`, so nothing machine-readable connects it to the decision that landed it. Joseph, on hearing that decisions don't point back to records: "that might be problematic. I hope that's shown as an implementation choice for right now in case it needs to be revisited".

## Decision Drivers

* A fact kept by hand in two places drifts.
* A decision should not lose sight of what rests on it when records are deleted, moved or never written.

## Assumptions

* That a linter can invert `per:` across a store, the same way it derives ∂ columns. (**recorded**: the coordinator's, at decision time)

## Considered Options

* Records cite decisions; the reverse is derived; a decision's "What changes" is its trail at decision time (chosen, for now)
* Decisions also keep a maintained list of the records resting on them
* Links stored in both directions by a tool (vsect), never by hand

## Decision Outcome

Chosen, as an implementation choice for now:

- **A record cites the decisions it rests on**, in `per:`. That is the only maintained link between them.
- **What rests on a decision is derived** by inverting `per:` across the store. A view may show it.
- **A decision's "What changes" is its trail at decision time**: the records it moved, as `[[kind:slug]]` links. It is not kept current afterwards, and git holds what followed.
- **A `landed` row with no document** has no `per:`, so its decision citation shows `∅`, like its flags. The decision is found by searching `adr/`.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> That sounds like what we'd expect. A decision doesn't point to records though... hmmmm.... that might be problematic. I hope that's shown as an implementation choice for right now in case it needs to be revisited...
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.16)

*How this meets the exemplar condition of the delegation: it records as provisional a choice that had been made only by dropping a field, and names what would reopen it, as Joseph asked.*

### Positive Consequences

* Nothing kept by hand can drift.
* The direction is now a recorded choice with its reopen conditions, not a side effect of dropping `affects`.

### Negative Consequences

* When a record is deleted or moved, its `per:` goes with it, and the decision no longer shows that anything rested on it; only git does.
* A landed row with no document can't be linked to its decision mechanically.

### What changes

* `sop/src/conv-row-type.md`: its open note on where a document-less landed row cites its decision is answered.
* `sop/src/conv-outline.md`: the violation "a `landed` row whose record cites no decision" applies only to rows with a document.

## Reopen when

* A deleted or moved record leaves a decision whose consequences can't be traced without git archaeology.
* Landed rows without documents become common enough that searching `adr/` for their decisions is a burden.
* vsect stores links in both directions, so a reverse link costs nothing by hand.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
