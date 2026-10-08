---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "@{…} references are in lite, carried as references with their raw text; bare @name stays reserved"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [addressing-theory work in v2/references/, vsect]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: reserve-not-ignore, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: ["09 Q1"]
---

# @{…} references are in lite, carried as references with their raw text; bare @name stays reserved

## Context and Problem Statement

[[decision:reserve-not-ignore]] listed `@` references, both `@name` and `@{…}`, among the spellings lite refuses, and [[decision:reserved-is-an-error]] made refusal an error with no tree. The estate already writes `@{term}` throughout its `.ud` documents (the addressing theory's `def/` entries; about 190 uses found by the 09 history pass), so every such document had no lite tree. Joseph opened the 2026-10-08 session proposing to consider allowing `@{…}`, unparsed, and then voted for it. This replaces the `@{…}` part of [[decision:reserve-not-ignore]]'s reserved list; bare `@name` forms stay reserved.

## Decision Drivers

* Carry `@{…}` "but not parsing or checking their inner values-- just having them in the AST as references and that's it" (Joseph, under the Quote).
* "reference is the right name / direction as per address theory" (Joseph).
* Live demand: the corpus's `.ud` files use `@{…}` heavily. (**inferred, unconfirmed** as Joseph's driver: the agent's argument, not restated by him.)

## Assumptions

* Lite only needs the extent of a reference, not its interior grammar; the interior belongs to the addressing theory. (**recorded**: "not parsing or checking their inner values")

## Considered Options

* Keep `@{…}` reserved (the 2026-09-29 list).
* Carry `@{…}` as a reference with its raw text (chosen).

## Decision Outcome

Chosen: `@{…}` is in lite.

- The tree holds a **reference** node carrying the raw text, per [[decision:opaque-spans]]. Lite never resolves or checks it.
- **Where:** in prose (decided: `email me @joseph or see @{faq}.` is text, a reference, then text). In values (`:author @{people/jw}`) and inside `[key]` (`|cite[@{ref.key}]`): Joseph's lean.
- **Bare `@name` stays reserved:** an error at the start of a prose line ([[decision:reserved-line-starts-in-prose]]) and as a value ("Bare `@jw` as a value stays reserved either way", the agent's framing, unobjected). Mid-line in prose, `@name` is plain text. Other bare forms (`@[k]`, `@.t`, `@<…>`) were not discussed; they stay on the reserved list (`.int/reserved.md`) until the reserved-spellings rule is written.

### Quote

> One main thing I think we may need to consider is allowing @{...} references [after all]-- but not parsing or checking their inner values-- just having them in the AST as references and that's it.
>
> — Joseph, 2026-10-08, opening message

> I vote yes, raw text, for typed delimited values (<...>) and references @{...}. […] reference is the right name / direction as per address theory.
>
> — Joseph, 2026-10-08, next message

> (c) passed through + reference […] sub-question: my lean: all three.
>
> — Joseph, 2026-10-08 (all in `.int/STEWARD-VERBATIM.md`)

*His words: "I vote yes" (in, raw), "reference is the right name" (the name), (c) inside his "I vote for strict-lean" answer (prose), "my lean: all three" (values and keys). Allowing `@{…}`, carrying it raw, naming it a reference, and its recognition in prose are his own calls (`steward`). Values and keys are his lean. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`).*

### Positive Consequences

* The corpus's `@{…}`-bearing documents can be lite.
* The reference node gives the addressing theory a place to attach parsed paths later without lite choosing a path grammar.

### Negative Consequences

* Lite fixes how a reference is delimited before the path grammar exists; the path grammar must live inside matched braces with `\X` escapes, or widen it later.

### What changes

* The reserved-spellings rule drops `@{…}`; the value and text rules gain a reference.
* (lite) Forward stability: per [[decision:forward-compat-aspiration]], full UDON may give the reference parsed structure.

## Reopen when

* The addressing theory needs a reference spelling that matched braces can't carry.
* The values or keys position turns out to collide with something (they are leans).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
