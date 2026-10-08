---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Matching full UDON's reading of a lite document is a design aspiration, not a promise"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [vsect, parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: reserve-not-ignore, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: ["60", "12 Q1"]
---

# Matching full UDON's reading of a lite document is a design aspiration, not a promise

## Context and Problem Statement

[[decision:reserve-not-ignore]] carried the agent-worded promise that "any document a lite parser accepts produces the same tree under every future full version of UDON". Assembling lite on 2026-10-08, the agent asked what that comparison covers: node meta such as line and column, and the raw text of `<…>` and `@{…}`, which full UDON will later parse into structure of its own. Joseph had been reading the phrase as something else (the document → tree → document → tree ornamentation check), and answered by downgrading the promise. This replaces only the promise in [[decision:reserve-not-ignore]]; its reservation stands, and [[decision:reserved-is-an-error]] stands unchanged.

## Decision Drivers

* Full UDON will change the tree shape of some things lite carries: "Opaque spans for example now will be their own branch in the AST later, among other things" (Joseph, under the Quote).

## Assumptions

* Refusing future syntax outright (an error, no tree) still prevents the confusion that motivated lite; a strict tree-identity promise is not needed for that. (**inferred, unconfirmed**: the agent's reading of why reservation survives the downgrade.)

## Considered Options

* Keep the promise, and define what "the same tree" covers (the agent's framing; the agent's own motive was to exclude meta from it).
* Downgrade it to an aspiration: compatible where practical, "as compatible as possible" where not (chosen).

## Decision Outcome

Chosen: an aspiration, not a promise. Lite's design aims for documents that full UDON reads the same way, where practical; where not practical, as compatible as possible.

A consequence Joseph stated with the call: node meta is safe to evolve beyond lite.

### Quote

> wrt "same tree" -- let us downgrade that to an aspiration, not a directive or promise. Opaque spans for example now will be their own branch in the AST later, among other things. We can say that's a design aspiration where practical, and where impractical we attempt to make it as "compatible as possible". […] Under this adjustment I think meta is clearly safe to evolve beyond lite.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`, session `293bb1ee`)

*His word: a direct call ("let us downgrade"), with no lean or ruling word. His own call, so `steward`. The phrase "same tree" was the agent's; Joseph noted he had been reading it as "the doc->ast->doc->ast identity - ornamentation check" (same message), which is a different property and is not decided here (pre-design 60).*

### Positive Consequences

* Lite's rules no longer have to be weighed against every future version's tree shape.
* Meta can be designed for lite's tooling now (vsect's need for source spans) without freezing it.

### Negative Consequences

* A lite tool and a later full-UDON tool may build differently shaped trees for the same accepted document.

### What changes

* [[obj:reserve-dont-ignore]]: the promise becomes an aspiration (clause 2); the refusal (clause 1) is unchanged.
* [[prop:forward-stability]] becomes a compatibility review, not a pass/fail property.
* [[decision:reserved-is-an-error]]'s first driver cited the promise; it now stands on its second driver alone (Joseph's 2026-10-01 reason: keeping the bytes of deferred syntax in 0.9 and 0.10 caused confusion and slowed the language). Its outcome is unaffected.
* (lite) Forward stability: from promise to aspiration.

## Reopen when

* A consumer turns out to need a hard compatibility guarantee for some part of the tree.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- The ornamentation round-trip check Joseph had in mind (document → tree → document → tree, identical the second time) is a separate property, pre-design 60; it has no record yet.
