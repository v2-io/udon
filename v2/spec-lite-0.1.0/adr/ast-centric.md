---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lite is specified as the tree it produces, not as an event stream"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: []
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["13", "60", "86", "91"]
---

# Lite is specified as the tree it produces, not as an event stream

## Context and Problem Statement

UDON's core parser is streaming: it emits events, and earlier specs spent much discussion on the event stream (the "wire") versus the tree. Lite needed one of them as what the spec defines.

## Decision Drivers

* Simplicity: "I will be very persuaded by things that simplify the grammar or rules without violating the principle of least surprise" (same message), the source of [[prin:simplest-grammar-without-surprise]].

## Assumptions

* None recorded.

## Considered Options

* Specify lite as an event stream, as the mainline parser works.
* Specify lite as the tree it produces (chosen).

## Decision Outcome

Chosen: lite is specified as the tree it produces, for simplicity.

Not decided here: what the tree holds (13, 60), its written transcript for comparing parsers (86), and whether lite promises one-pass reading (91).

### Quote

> There used to be a lot of discussion about wire vs ast -- because the core parser is streaming/event of course. Lite can be specified as AST-centric for simplicity.
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:18Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`. His modal was "can be": he proposed it unprompted, and the agent's summary a few minutes later listed the tree as the spec as decided, without objection from him.*

### Positive Consequences

* Rules, fixtures and the spec's teaching all speak about one object, the tree.

### Negative Consequences

* Streaming behavior, if lite promises any, has to be stated separately.

### What changes

* Fixtures give an expected tree for each input.

## Reopen when

* A lite consumer needs a guarantee that only an event-level spec can give.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- His leans on what the tree holds (node metadata, `same_line`, "content < content+meta < content+meta+ornament") are in `.int/pre-design/STEWARD-2026-09-29.md`; they bear on 13 and 60, which this record leaves open.
- Whether lite inherits bounded lookahead from the streaming parser it must agree with is 91.
