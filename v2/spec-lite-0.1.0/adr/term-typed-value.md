---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The term is typed value, explicit (<…>) or implicit, not box or value"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [udon agent of session 5930da5d (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["66", "72"]
---

# The term is typed value, explicit (<…>) or implicit, not box or value

## Context and Problem Statement

The pre-design files called an `<…>` value a "box", which was the agent's placeholder. "Value" alone is ambiguous: every value in UDON has a type.

## Decision Drivers

* A defined term should not read as the general word.

## Assumptions

* All values in UDON have types. (**recorded**)

## Considered Options

* "box" for `<…>`, "value" for the rest (the agent's placeholder).
* "typed literal", the agent's recommendation (RDF's term for a lexical form plus a datatype).
* «typed value», explicit or implicit (chosen).

## Decision Outcome

Chosen: the lite term is «typed value». An «explicit typed value» is spelled `<…>`. An «implicit typed value» is one whose type comes from how it is written, without `<…>`, as in Joseph's own pair: "explicit `|el <42>`", "implicit `|el 42`" (`.int/scratch-jaw.md`). Which spellings get which types is not decided here (66, 72).

### Quote

> what about 'typed-value' instead of box?

> … add entries (just one line for each of these right now please) for "(implicit/explicit) typed value" …

> I fixed "value" which is an ambiguous term we're not using -> typed value like I suggested, to emphasize and clarify it vs the general term, since all values have types in udon.
>
> — Joseph, 2026-09-29 evening (2026-09-30T02:07Z, 02:12Z, 02:21Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`; he chose it over the agent's recommended "typed literal". The qualifier "explicit" was also the agent's fallback ("I'd make it 'explicit typed value'"); the explicit/implicit pair is his own, from his scratch list.*

### Positive Consequences

* The defined term can't be mistaken for the everyday word.

### Negative Consequences

* Whether a quoted string or a list counts as an «implicit typed value» depends on 66 and 72, and on what "bare" means.

### What changes

* Lite's typed-value definition, [[def:typed-value]] (now an `example` row), is to define the terms.

## Reopen when

* Lite decides that some values carry no type of their own.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
