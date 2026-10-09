---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "nil is the only spelling of nil; null is no longer typed"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["72"]
---

# nil is the only spelling of nil; null is no longer typed

## Context and Problem Statement

0.10.0 typed both `null` and `nil` as nil (§11.4: "`null` ≡ `nil`"). Lite takes 0.10.0's frozen bare set (`def/def-typed-value.md` working notes). The agent mentioned that 0.10.0 accepted both; Joseph narrowed it.

## Decision Drivers

* "nil is less clunky lexically" (Joseph, under the Quote).
* Deterministic typing gets tighter with one spelling (Joseph).

## Assumptions

* None recorded.

## Considered Options

* `null` and `nil` both (0.10.0).
* `nil` only (chosen).

## Decision Outcome

Chosen: `nil` is the only spelling of nil. `null` is no longer typed.

Open, being asked: under this rule a bare `null` would be ordinary text unless reserved. The coordinator is asking whether a bare `null` should be an error that points to `nil`.

### Quote

> Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter.
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

*His words: "let's go ahead and make". His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]). `awaiting-decision` is true only for bare `null`.*

### Positive Consequences

* One spelling per bare type.

### Negative Consequences

* JSON-trained writers will write `null`; unless it is reserved, it silently becomes text.

### What changes

* [[rule:implicit-typing]]; 72's table.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open with Joseph: bare `null` as an error pointing to `nil`, or as text.
