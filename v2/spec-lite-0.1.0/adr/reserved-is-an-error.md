---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A reserved spelling is an error: parsing halts with what is known, and a tree exists only for a compliant document"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: reserve-not-ignore, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: ["09 Q2", "09 Q3", "12 Q1"]
---

# A reserved spelling is an error: parsing halts with what is known, and a tree exists only for a compliant document

## Context and Problem Statement

[[decision:reserve-not-ignore]] says a lite parser recognizes future syntax "just well enough to refuse it", and its Outcome adds, from the agent's 2026-09-29 wording, that the parser "keeps the bytes and reports that the spelling is reserved". What the refusal is had two readings on record:

- Joseph's 2026-08-30 tiny-parser request: the parsers "would need to warn when there are constructs … that it encounters that it won't parse";
- his 2026-09-29 and 09-30 words: "disallow", and "It will *reserve* those other constructs so that the parser errors".

Mainline UDON's ledger also gives "error" a specific meaning, "Error = loss only" (`v2/DECISIONS.md` L0): kept bytes would make a refusal a warning there. This replaces the "keeps the bytes" part of [[decision:reserve-not-ignore]]; that record's contract and its reasons stand.

## Decision Drivers

* A lite document must never be read in a way a future full parser would read differently ([[decision:reserve-not-ignore]]).
* The 0.9 and 0.10 specs also deferred decisions about `!` directives and references, but kept the bytes. That ambiguity caused a lot of confusion and slowed the language's evolution for a season (Joseph, under the Quote).

## Assumptions

* Keeping the bytes of deferred syntax is what made 0.9 and 0.10's deferral ambiguous; refusing them outright removes that ambiguity. (**recorded**, under the Quote)

## Considered Options

* Warn, keep the bytes, and go on (the 2026-08-30 request).
* Error, keep the bytes in the tree, and go on (the 2026-09-29 agent wording).
* Error and halt: report everything known, and assume no tree unless the document is compliant (chosen).

## Decision Outcome

Chosen: a reserved spelling is an error, because keeping the bytes of deferred syntax, as 0.9 and 0.10 did, left an ambiguity that caused confusion and slowed the language; lite deliberately goes further and disallows them completely.

- A lite parser halts at it, and reports what it knows: what was found, and where.
- A tree is assumed only for a compliant document. A document with a reserved spelling in it has no lite tree.
- "Error" here means *not lite*, which is not mainline's "error = loss".

Not decided here, by Joseph's own words: whether the error is as drastic as in normal UDON or in streaming, for example whether a parser may report more than the first one, or what a streaming consumer has already been given when it halts. What "compliant" requires beyond having no reserved spelling (warnings, other anomalies) is 12 Q1.

### Quote

> I forgot I even *had* a discussion about udon-lite in August. I was wrong about warn. It should error. There is still some flexibility on whether or not we want "error" to be as drastic as in normal udon or streaming etc. But I think we basically halt parsing at that point with all the info and assume an AST only if the udon is compliant.
>
> — Joseph, 2026-10-01 (about 03:30Z), `.int/STEWARD-VERBATIM.md`

> To reiterate-- older 0.9 and 0.10 specs in udon (not lite) also deferred decisions about special syntaxes like ! directives and references-- but retained the bytes. That ambiguity caused a lot of confusion and made the language evolve a lot slower for a season-- hence the very deliberate call right now in udon-lite to go further and disallow them completely.
>
> — Joseph, 2026-10-01 (about 03:45Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`, made on being shown that his 2026-08-30 request said "warn". The second quote, minutes later, gives his reasoning; it was added to Drivers, Assumptions and the Outcome's "because" then, as grounds stated at the time of the decision.*

### Positive Consequences

* No tool ever builds on a partial reading of a document that full UDON would read differently.
* The question of what the tree keeps for a reserved spelling (09 Q2, Q3) mostly disappears: there is no tree.

### Negative Consequences

* A document with one reserved spelling yields no tree at all in lite, which is harsh on the live corpus documents that already use `!:kind:` blocks or `@{…}` (see [[decision:reserve-not-ignore]]).
* "Error" now means two things across the estate: *not lite* here, *something was lost* in mainline's ledger.

### What changes

* [[decision:reserve-not-ignore]]'s "keeps the bytes" is replaced; it gains the `superseded-by` entry.
* Lite's reserved-spellings and validity rules are written on this footing.
* (lite) Forward stability: strengthened; nothing containing a reserved spelling is ever accepted.

## Reopen when

* The live corpus needs lite tooling on documents that contain reserved forms, and a partial tree with errors turns out to be needed, without bringing back the ambiguity this decision exists to remove.
* The "how drastic" question is settled differently for streaming.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- 09 Q2 and Q3 (what the tree keeps for a refused spelling, and the lines under it) now matter only for error reporting: what the report includes, not what a tree holds.
