---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "An objective's force is non, desired, required or critical"
status: accepted
decided-by: ratified
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5), second look (agent, a8c456643520439c2)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: force-levels, how: invalidated, scope: full}]
superseded-by: []
closes: []
leaves-open: []
---

# An objective's force is non, desired, required or critical

## Context and Problem Statement

Joseph asked that objectives, non-objectives and critical objectives be distinguished, and that "req" be proposed for requirement or critical requirement. The fork proposed a `force` field rather than separate kinds, with four values, as the second of three refinements. Joseph agreed to all three.

[[decision:force-levels]] then dropped `critical`, on the ground that nothing yet separated it from `required`. That reversed a split Joseph had agreed to, under delegated authority that covered setup decisions still open, not ones he had already settled. This record restores his agreement.

## Decision Drivers

* Keep what Joseph agreed to.
* A severity difference is a field, not a kind: all four values fail the same way (the rules breach them) and differ only in how serious a breach is.

## Assumptions

* That "the three refinements" Joseph agreed to at 18:23Z are those in the fork's reply at 18:18Z, which listed `force: non | desired | required | critical`. (**recorded**: the fork's transcript, `subagents/agent-a709e77019230eca0.jsonl`, 2026-09-30T18:18:05Z)

## Considered Options

* Four levels, `non | desired | required | critical` (chosen)
* Three levels, dropping `critical` (the superseded record)

## Decision Outcome

Chosen: `force` takes `non` (an explicit non-goal), `desired` (an objective, met if possible), `required` or `critical`. A **requirement** is an objective whose force is `required` or `critical`, and that is the only spelling. Joseph agreed to this split; what separates `required` from `critical` is still open (see Working notes).

### Quote

> Also, we should probably distinguish between  objectives, non-objectives, and critical-objectives (as sub-categories, however that is most cleanly done)
>
> — Joseph, 2026-09-30T18:16Z (`sop/influx/jaw-proposal-and-feedback.md` §1.12)

> Excellent-- I agree with the three refinements.
>
> — Joseph, 2026-09-30T18:23Z (§1.12), answering the fork's refinements, the second of which was "Make objective / non-objective / critical a field, not three kinds. … Something like `force: non | desired | required | critical`."

### Positive Consequences

* The value Joseph asked to have distinguished is kept.

### Negative Consequences

* Until the distinction is stated, writers can't choose between `required` and `critical` by rule.

### What changes

* `sop/src/conv-purpose-layer.md`, `sop/def/def-record-fields.md` and `def-record-kinds.md` restore `critical`.

## Reopen when

* Joseph says what separates `required` from `critical`, and the answer changes the values.
* A real case shows `critical` is never used differently from `required`.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* **Open for Joseph: what separates `required` from `critical`?** Candidates, none decided: a `critical` breach blocks a release while a `required` one is a known defect that can ship; or `critical` objectives are the ones no later version may relax (reserve-don't-ignore would be one).
* `decided-by: ratified` because the four values were the fork's proposal and Joseph agreed to it; the definition still open above is not covered by that agreement.
