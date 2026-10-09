---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Leans, support and likes are working spec to act on decisively; they stay soft so open questions and parser implementers can rework them"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: []
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: decided-for-this-version, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# Leans, support and likes are working spec to act on decisively; they stay soft so open questions and parser implementers can rework them

## Context and Problem Statement

[[decision:decided-for-this-version]] made every accepted lite decision decided for this version, whatever word Joseph used, revisitable when undiscovered confounding factors come up. Joseph then said why he often declines to rule and gives a lean, support or a like instead, and what that softness is for. This refines what "decided" means; [[decision:decided-for-this-version]] otherwise stands.

## Decision Drivers

* Remaining open questions will interfere with tentative positions (Joseph, under the Quote).
* The strength of his word calibrates revisiting (Joseph).
* Parser implementers are a critical stakeholder who start only once the spec is complete enough, and their findings are critical input to it (Joseph).

## Assumptions

* None recorded.

## Considered Options

* Only one option was on the table.

## Decision Outcome

Chosen:

- **A lean, support or like is enough to act on decisively, as working spec.**
- They are kept softer than rulings for three reasons:
  - slight reworks are expected as remaining open questions run into tentative positions;
  - the strength of his word helps calibrate revisiting;
  - above all, **parser implementers may propose changes** where a lean or a supported call stands, when working through fixtures and test cases they see a semantic benefit to undoing it, a significant grammar simplification, or a performance gain. When a rule starts churning and obscuring the grammar, the implementer checks whether it rests on a lean that could have gone either way, and tells Joseph what would disappear if it leaned the other way.
- The process is not full waterfall.

### Quote

> (btw-- maybe make a note that when I decline to rule on things and instead support of lean or even like-- again those are enough to act decisively on as "working spec" -- the main reason I leave them softer is because I expect there to continue to be slight reworks as remaining open questions interfere with the tentative positions, because (as already recorded) it retains the strength of the position to help calibrate revisiting things, but *also* because I will want the parser implementers to be able to propose changes in these areas especially where, as they work through fixtures and test cases etc. etc., they see some semantic benefit to undoing a lean, or they see a significant grammar simplification or performance improvement etc. etc. In other words, when they start churning and obscuring the grammar in order to get a rule to work right-- they can see "oh, this was a lean that could have potentially gone either way- or was just 'supported'-- let's tell Joseph that if it leaned the *other* way this technical issue or complication would disappear...".  So, there is a critical stakeholder that will only start once the spec is "complete" enough-- but also that is a critical input for the spec. Or, in other words, it's not going to be full-waterfall methodology no matter how good we are at making it coherent :-))
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

*His words: "maybe make a note". His own call, so `steward`.*

### Positive Consequences

* Records can be acted on now, and the people who meet the grammar's costs first have a named path to change it.

### Negative Consequences

* None identified.

### What changes

* Each record's word line under its Quote is what an implementer reads to know whether a call is a lean.
* `adr/TEMPLATE.md` points here beside [[decision:decided-for-this-version]].

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
