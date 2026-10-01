---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Working notes may hold anything; each is dispositioned before freeze"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["aat-refactored coordinator (agent, Opus 5.5), under delegated authority (setup-delegated-to-coordinator)"]
consulted: [spec-lite fork (agent, Opus 5.5), second look (agent, a8c456643520439c2)]
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: [{adr: permanent-notes-in-body, how: invalidated, scope: full}]
superseded-by: [{adr: notes-drained-not-history, how: revised, scope: partial}]
closes: []
leaves-open: []
---

# Working notes may hold anything; each is dispositioned before freeze

## Context and Problem Statement

[[decision:working-notes-and-frozen]] says every record may have working notes, and a record with any notes cannot be considered frozen. Its reopen condition asked what happens to notes that are not open work: cautions, regression guards, sources, a fixture case's reason for existing.

[[decision:permanent-notes-in-body]] answered by restricting working notes to open work. That narrowed what Joseph had just ruled ("every record has the ability to have working-notes"), and nothing he said asked for a content restriction. This record withdraws it.

## Decision Drivers

* Keep Joseph's ruling as he gave it: notes anywhere, no freeze while any remain.
* Give the frozen rule a defined drain, so that notes don't only accumulate.

## Assumptions

* That ASF's Gate 4 is the right prior art: at its `candidate` stage every Working Notes item is resolved, deferred or promoted, and the section is emptied. (**recorded**: `~/src/arch/asf/doc/sop/format.sop.md`, "Gate 4: Notes disposition")
* That the drain must be usable before freeze, not only at it. ASF's 2026-07-07 process review found Gate 4 had never run because no segment reached `candidate`, so its notes only grew. (**recorded**: `~/src/arch/asf/msc/meta-process-review-2026-07-07/01-theory-content-lifecycle-findings.md`)

## Considered Options

* Notes hold anything; each is dispositioned before a record is frozen (chosen)
* Notes hold only open work; permanent material goes in the body at once (the superseded record)

## Decision Outcome

Chosen: working notes may hold anything, at any stage. A record can be considered frozen only once every note has been **dispositioned**:

- **resolved**: incorporated into the body, or found moot, and deleted;
- **kept**: moved into a body section the kind's cadence names (for example Why, Sources, Cautions or Regression guards);
- **deferred**: moved to an outline row (`gap` or `proposed`), a question, or the changelog, with its reason;
- **promoted**: made into a record of its own, and cited.

A disposition is allowed at any time, not only at freeze; the frozen check is only where it becomes required. A note that must outlive freeze is not a working note, and that includes the evidence behind a verification level. That pointer is written into frontmatter by the act that verifies, beside the level ([[decision:per-kind-verification-and-status]] said "with a pointer to the evidence" and didn't say where).

Made under the authority Joseph delegated on 2026-09-30 ([[decision:setup-delegated-to-coordinator]]). It is in force, and awaits his ratification.

### Quote

> 1. Policy should be that every record has the ability to have working-notes, but it cannot be considered frozen (if there is such an equivalent field in that kind, like 'final' or 'fully-verified') if there are any notes in it.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

> Also, 3 I guess, making sure there is allowances for working-notes everywhere...
>
> — Joseph, 2026-09-30T16:19Z (§1.12)

> If you are looking at everything holistically and thoughfully to be an exemplar for moving the udon work forward which will move verisectorium and the agentic systems framework / theory forward-- I am happy to defer to you for the rest of those and other decisions related to the setup. Just mark decisions as made by you from authority given from me and as still needing ratification (where applicable)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.11)

### Positive Consequences

* Joseph's ruling stands unnarrowed.
* The frozen rule has a drain with four named exits.
* Notes already moved into body sections, such as the example records' Why and Cautions sections, are dispositions, and stand.

### Negative Consequences

* Freezing a record costs a pass over its notes.
* Verification evidence needs a frontmatter field (`evidence`), which neither kinds file declares yet.

### What changes

* `adr/TEMPLATE.md` drops "open work only" from its Working-notes guidance.
* `sop/src/conv-working-notes.md`, `conv-record-cadence.md` and `conv-fixtures.md` state the four dispositions in place of the restriction. A fixture case may keep `notes:`; `why:` is the kept form.
* `sop/src/conv-verification-and-status.md`: the verifying act writes `evidence` in frontmatter, not a working note.

## Reopen when

* A note fits none of the four dispositions.
* Records reach freeze with notes routinely deferred rather than resolved. That would mean the drain only moves the pile.
* Joseph declines to ratify it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* How this meets the exemplar condition of the delegation: it restores Joseph's own ruling, and borrows a drain the estate already designed, adjusted for the one failure the estate measured in it.
