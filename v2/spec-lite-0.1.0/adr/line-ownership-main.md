---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Same-line material: one behavior for lines that start with an element and lines that start with an attribute, through $main"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["02", "13 Q3", "53", "71", "73", "74"]
---

# Same-line material: one behavior for lines that start with an element and lines that start with an attribute, through $main

## Context and Problem Statement

What the rest of a line belongs to has been answered five ways since 2011 (pre-design 71). On 2026-09-29 Joseph reaffirmed `$main` and named "attribute-sameline": same-line processing treated exactly the same whether the line starts with an element or an attribute. He said then that it wasn't a final verdict. On 2026-10-08 the agent listed "who owns the rest of a line" as a root question, citing that reaffirmation as the strongest input, and Joseph answered that it is the final word.

## Decision Drivers

* One behavior for element lines and attribute lines: "All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness" (Joseph, 2026-09-29).
* A real-world use: element lines followed by attribute lines (`|term Lexicon Entry` then `:added <2026-10-01>`, `:status frozen`), "a crucial real-world use reason" (Joseph, 2026-09-29).

## Assumptions

* None recorded.

## Considered Options

* `$main` with attribute-sameline (chosen).
* The element's line as text (0.7, 2011) and the other historical answers in pre-design 71 and 73.

## Decision Outcome

Chosen: `$main` and attribute-sameline. Same-line material behaves the same on a line that starts with an element and a line that starts with an attribute.

The mechanics, as the agent renders them from 0.10.0 §6.5 (the 09-29 summary called it "0.10.0 §6.5's ownership rule under a clearer name"; the rendering is the agent's, under his "final word"): same-line material belongs first to a label still waiting for its value; after a value finishes, on an element's line further values stack as the element's `$main`, and on an attribute's line they stack on that attribute; further `:label`s open new attributes on both kinds of line.

Not decided here: how far an unquoted value runs (71), escapes inside an open value (02), the element line as a typed slot (73), text continuing below (53), values below the label (74), and whether `$main` sits in the tree as an attribute or as the first child (13 Q3; his 09-29 lean was the first child with `same_line` meta). The agent's plan is to follow 0.10.0 on these unless a nuance turns up, and to show Joseph examples where they bite; that plan is not part of his call.

### Quote

> Another thing *that may not have been discussed* but only thought at the time-- it allows us to treat sameline processing exactly the same if we are *sameline on an attribute*: […] I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute. […]
>
> ok... conceptually I am more and more convinced that the feeling that $main was a good idea *is* a truly good idea, [even though] you say only 5 survives and it's the one I don't understand. All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness.
>
> It seems.  This isn't a final verdict-- this is my current understanding.
>
> — Joseph, 2026-09-29 evening (2026-09-30T01:55:54Z), `.int/STEWARD-VERBATIM.md` (carried there whole from session `5930da5d`)

> 2. And that is the final word unless you uncover a nuance that conflicts with some other "latest thinking"
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`), answering the agent's "who owns the rest of a line" with the 09-29 reaffirmation as the strongest input

*His words: "conjecture" and "not a final verdict" on 09-29; "the final word unless you uncover a nuance" on 10-08, which upgrades it. His own call, so `steward`.*

### Positive Consequences

* One scan for both kinds of line.

### Negative Consequences

* None identified beyond those already recorded for 0.10.0's value rules.

### What changes

* The line rule.

## Reopen when

* A nuance conflicts with other latest thinking (his condition).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- His 2026-09-29 lean on a `same_line` meta flag ("allow sameline=true metadata still…") is not recorded as a decision; meta is free to evolve ([[decision:forward-compat-aspiration]]).
