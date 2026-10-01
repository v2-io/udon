---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Who decided and what the decider did are two fields: deciders, and decided-by"
status: accepted
decided-by: supported
decided: "2026-09-30"
updated: 2026-09-30
deciders: ["udon-team agent (agent, Opus 5.5)"]
consulted: []
informed: [aat-refactored coordinator (agent, Opus 5.5)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Who decided and what the decider did are two fields: deciders, and decided-by

## Context and Problem Statement

Lite's decisions are written from `adr/TEMPLATE.md`, which is the udon team's file. Its `decided-by` field came from the seven-value vocabulary of 2026-08-08 (references, third edition), carried through the verisectorium template. That vocabulary puts two facts into one field: who made the call, and what the store's decider did about it. The SOP store's records already show the strain, set out in `sop/influx/proposed-decision-authority.md` §2: a record whose `deciders` is Joseph and whose `decided-by` says an agent made the call; one value, `supported`, meaning both "delegated, not yet looked at" and "looked at and lightly backed".

Lite's decisions will mostly have one shape: an agent lays out the alternatives with a lean, and Joseph assents in a few words. That is exactly the case the one-field vocabulary can't describe, so the question had to be settled before lite's first decisions were written. The proposal states that lite's template changes only if the udon team adopts it (§3.3).

## Decision Drivers

* Two values that move independently don't share a field (verisectorium RC1, `02-RECORD-OBJECT-MODEL`, DIMENSION; the fusion test in `03-DIMENSIONS`).
* A record must never present an agent's call or reading as Joseph's (vivarium `core/src/norm-decision-authority.md`: "Tags must not launder an agent opinion into Joseph's decision").
* The label is where readers' attention goes, so each value should say what it takes to revisit the decision, not only who stands behind it (proposal §1.4 and §2.5).
* Joseph's own definitions of his acts, 2026-08-14: "a 'ruled' by Josph implies Joseph might have a reason that wasn't stated. 'ratified' means he thought through it and would like to know if someone feels differently. 'supported' means he had no objections at that time." (quoted in the proposal §1.1 from `theory/influx/model-2026-08-14/steward-failure-modes-2026-08-14.verbatim.md`; I have not opened that file).

## Assumptions

* The SOP store and the spec store keep using one template. (**recorded**: `sop/src/conv-decisions.md`, "made from `adr/TEMPLATE.md`"; this is the decider's own assumption at decision time)
* Most of lite's decisions will be an agent's described options plus Joseph's brief assent. (**recorded**: the decider's, at decision time, from the shape of the 2026-09-29 session; if lite's decisions turn out mostly to be Joseph's own unprompted calls, the split matters less)
* `steward` is kept, rather than folded into `ratified` or `ruled`, mainly because about 25 SOP records already use it. (**recorded**: the decider's; it is churn-avoidance, not principle)

## Considered Options

* Keep the seven values as they are.
* Split the two facts: `deciders` says who made the call, `decided-by` says what the store's decider did (chosen; the proposal's §3, with its §5 leans taken on every question).
* Split them, and also fold `steward` into `ratified` or `ruled` (the proposal's option B on its question 5).

## Decision Outcome

Chosen: split the two facts, as `sop/influx/proposed-decision-authority.md` §3 proposes, taking its leans on the questions that bear on lite's store (1–6 and 10).

- **`deciders` says who made the call**, with a role: `steward`, `agent`, `council`, and the qualifier `under delegated authority (<grant slug>)`. Whose *proposal* it was goes in the provenance note under the Quote.
- **`decided-by` says what the store's decider did about this record.** The store's decider is declared in its `.vsect/kinds.yaml`; for lite that is "the udon team's decider (Joseph unless the team declares otherwise)". The values:

  | Value | What happened | Revisiting it |
  |---|---|---|
  | `proposed` | Nobody with standing has decided. | Change it freely. |
  | `delegated` | A delegate decided under a named grant; the decider hasn't acted on this record. | Anyone may raise it; superseding it falls within the same grant; the decider may support, ratify, rule or decline it. |
  | `supported` | The decider saw it and had no objections at that time. | Cheap: bring what changed. |
  | `ratified` | The decider thought it through and would like to know if someone feels differently. | Bring the disagreement to the decider, with reasons. |
  | `ruled` | The decider's call, which may rest on a reason not stated. | Work out your best understanding of why it was made, check that understanding with the decider, then decide together; never argue from reconstructed reasons alone. |
  | `steward` | The decider's own call, stated in his own words. | As `ratified`. |
  | `defacto` | In force by practice; nobody with standing decided it. | Free; it invites a decision. |

- **No decision is set in stone** (Joseph's note on this record). Every value can be revisited; they differ in the path, not the license. The path reading is the proposal's question 7, which rests on his 2026-08-14 definitions ("All very different statements about who knows, what kind of grounds there are, and what the remediation is"); whether it reconciles his statements as he meant them is his to say.
- **`council` is a role in `deciders`, not a value**, and its standing comes from a grant. An unacted council decision is `delegated`.
- **`transition` leaves `decided-by`.** A rejected or superseded decision that still has leftovers somewhere is `status: rejected` or `superseded`, with `needs-work: true` and a working note saying where the leftover is.
- **At the moment of assent, ask.** When the decider assents to an agent's description, the agent asks then which act it was ("can I mark that as your decided position?"). If nobody asked, record `supported`. Recording `supported` when he thought it through understates his position, which is also a misattribution, so asking is the normal path and the default is the fallback.

### Quote

> I will support (officially) your decision on decision authority :-)  Please note with the decisioin that it (and any other decision) is not set in stone, that's part of why this process exists, so that we can see what assumptions went into some decision and know when it's appropriate to revisit for the sake of the real goals instead of momentum/inertia and appeals-to-authority.
>
> — Joseph, 2026-09-30 (`.int/STEWARD-VERBATIM.md`, session `fdcff70f`)

*The Outcome is the deciding agent's own text (`wording: verbatim`). The proposal it adopts was written by an Opus 5.5 agent for the aat-refactored coordinator. Joseph's words above are his act on this record: `supported`. What he supported was the decision as described to him in chat: "adopt the split for lite", plus asking at the moment of assent. He did not answer the proposal's ten questions himself.*

*Corrected the same evening, before anything relied on it: the `ruled` row had dropped the step Joseph prescribed on 2026-08-14 ("let me make sure i've thought through my best understanding of why that decision was made, and then I'll bring it up with Joseph, have him verify whether my assumptions about why it was made are true", quoted from the second look, `.int/adr-second-look-2026-09-30.md`); and a clause making delegated calls in force before the decider acts, the proposal's question 9 about the SOP store's grant, had been generalized into a lite rule he wasn't asked about. Both are now as above.*

### Positive Consequences

* A record can say "Joseph agreed to an agent's proposal" and "Joseph made this call lightly" without either field contradicting the other.
* Each value tells a later reader what revisiting it costs, so a decision's label invites the right kind of reopening instead of deference.

### Negative Consequences

* The SOP store's records were written to the old meanings. Until its own set is brought into line, the same words mean slightly different things in the two sets, which share one template.
* `steward` and `ratified` now differ only in where the call came from, which `deciders` already says. That small overlap is kept on purpose, to avoid churn.

### What changes

* `adr/TEMPLATE.md`: the frontmatter comments for `decided-by` and `deciders`, its notes on `status` and `decided-by`, its section on delegated decisions, and its rules after acceptance.
* The SOP store's own records and definitions (`sop/def/def-decision.md`, its group A and B records) are the coordinator's to bring into line, or not; a note is left in `sop/influx/udon-team-notes.md`.
* Lite's seeded decisions are written under these values.
* (lite) Forward stability: none.

## Pros and Cons of the Options

### Split the two facts (chosen)

* Good, because each field holds one value that moves independently.
* Good, because the values say how to revisit, which is what Joseph's note asks the process to make visible.
* Bad, because a shared template now carries meanings the SOP store's existing records don't follow yet.

### Keep the seven values

* Good, because nothing changes.
* Bad, because lite's most common decision shape can't be recorded without contradiction.

### Also fold `steward` away

* Good, because it removes the last overlap.
* Bad, because it means re-grading about 25 records whose authority is not in doubt.

## Reopen when

* The SOP store declines the split for its own set, and one template carrying two meanings proves confusing.
* Lite's decisions turn out mostly to be Joseph's own calls, so the split carries little.
* A council is chartered as a store's decider and needs something the role-in-`deciders` form can't express.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- **Pending: Joseph's own definitions** (2026-10-01, `.int/STEWARD-VERBATIM.md`): *sustained* = he fully endorses and decides on someone else's proposed lean; *ratified* = he endorses an already-decided item after the fact. Under those, this record's `ratified` ("thought it through") conflates timing with firmness. A revised value set adding `sustained` has been proposed to him; once he confirms, it supersedes the value table here (revised, partial), and the records labelled under it are re-labelled.
