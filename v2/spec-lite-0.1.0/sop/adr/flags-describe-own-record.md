---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "A flag describes its own record; what it rests on is derived"
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

# A flag describes its own record; what it rests on is derived

## Context and Problem Statement

`sop/src/conv-record-flags.md` counts "`awaiting-decision: false` on a record that cites an undecided decision" as a violation. So the flag is copied by hand onto every record that cites a pending decision. Two cases show the copy is wrong or ambiguous:

- [[decision:order-lint]] and [[decision:proxy-before-threshold]] are deferred on purpose, with `awaiting-decision: false`, while the conventions citing them carry `true`.
- Every record citing a delegated decision would need `true` until Joseph ratifies, and `false` again after, with no edit to the record itself.

## Decision Drivers

* Joseph defined `awaiting-decision` as "whether or not it's waiting for steward to review and make a decision". That describes the record itself.
* A hand-copied flag drifts from what it copies; a derived value cannot.

## Assumptions

* That a linter will derive what a record rests on from its `per:` citations. (**recorded**: "which needs a bin/ script to lint and/or update", §1.1)

## Considered Options

* Each flag describes only its own record; what a record rests on is derived (chosen)
* Copy `awaiting-decision: true` onto every record citing a pending or deferred decision

## Decision Outcome

Chosen: each of the three flags describes only its own record. `awaiting-decision: true` means the decider is being asked to decide something about this record. Whether a record rests on a decision that is deferred, unratified or superseded is derived from its `per:` citations, and a view may show it as a ∂ column. A deliberately deferred decision carries `awaiting-decision: false`, because nobody is being asked to decide it now.

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> awaiting-decision?: true or false -- whether or not it's waiting for steward to review and make a decision
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.1)

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Ratifying a decision changes no other record.
* "Rests on something unsettled" becomes visible everywhere it applies, not only where someone remembered to copy a flag.

### Negative Consequences

* Until the linter exists, what a record rests on is visible only by following its `per:`.

### What changes

* `sop/src/conv-record-flags.md` drops the copying violation and points at the derived value.
* [[conv:ordering]] and [[conv:purpose-layer]] set `awaiting-decision: false` unless something about them is itself awaiting a decision.

## Reopen when

* A record needs to signal that it waits on a decision about another record, and `per:` can't carry that.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* How this meets the exemplar condition of the delegation: it keeps Joseph's definition of the flag, and puts the dependency where [[decision:outline-always-true]] puts every reflection, in a derived cell a linter can check.
