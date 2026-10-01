---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Lite carries <…> without reading it: it finds where it ends and hands over the raw text"
status: accepted
decided-by: supported
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
leaves-open: ["07", "89"]
---

# Lite carries <…> without reading it: it finds where it ends and hands over the raw text

## Context and Problem Statement

Dates, times and durations were deliberately removed from bare value parsing, on the idea that they would be the first `<…>` types, with the spelling for a namespace or type left undecided. So lite had to say what, if anything, it does with `<…>`. The agent offered three options.

## Decision Drivers

* Forward safety: `<…>` "always meant 'someone else decides what this is'" (**inferred, unconfirmed** as Joseph's: the agent's argument for option 2, 2026-09-29T23:56Z).
* No spelling for type or namespace labels is decided yet (Joseph, in the Context's first sentence, from his 23:55Z message).

## Assumptions

* Carrying the raw text, with no meaning attached, is forward-stable: a later version can give it meaning without changing the tree lite produced. (**inferred, unconfirmed**: it holds only if the tree records the raw text in a form a later split into label and body doesn't change; see 07 Q3)

## Considered Options

* 1: reserve `<` entirely; lite gets no dates.
* 2: carry `<…>` as an untyped box: lite parses where it ends and hands over the raw text, with no meaning attached (chosen).
* 3: option 2, plus a fixed list of recognized contents in unlabelled boxes (ISO dates, times, datetimes, durations).

## Decision Outcome

Chosen: option 2, "for now". Lite finds where an `<…>` ends and hands over its raw text, attaching no meaning. Dates, times and durations are not typed in lite for now.

- **Deliberately kept open:** a quick subset of core types inside `<…>`, depending on need, which Joseph expects may be a 0.1.1 feature; and reattaching the temporal parser that already exists, at implementation time. Both are anticipated steps of this decision, not reversals of it.

- Not decided here: where it ends (depth-counted or first `>`), whether it spans lines, whether the tree splits a type label from the body, the empty `<>`, and where it may appear (07 Q1–Q5, 89).
- The term for it is «explicit typed value» ([[decision:term-typed-value]]).

### Quote

> w/ dates-- let's go with 2 for now. When we get to implementation we might go ahead and reattach the temporal parser already built.
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

> Correct, I decided option 2 for now, but specifically decided we would stay open to doing a quick subset of core types potentially, depending on need (I kind of suspect that will be a 0.1.1 feature or something).
>
> — Joseph, 2026-10-01 (`.int/STEWARD-VERBATIM.md`), confirming the record

*"2" is the agent's option 2, quoted in the same file. The rendering written into `.int/README.md` afterwards says lite "carries its text and optional type label"; that phrase comes from the agent's own later paraphrase (2026-09-30T02:08Z, recommending "typed literal"), not from option 2, whose words say only "hands over the raw text". This record holds to option 2, and leaves the label question open (07 Q3). `supported` is the default for an assent nobody asked about at the time ([[decision:decision-authority]]).*

### Positive Consequences

* Lite documents can already hold dates and other typed material, unread.
* No label or namespace spelling has to be decided for lite.

### Negative Consequences

* A lite consumer gets dates only as text.

### What changes

* [[def:typed-value]]'s question about "text and optional type label" is answered from the primary: option 2 says raw text; any label split is 07 Q3.

## Reopen when

* Need arises for a quick subset of core types (Joseph expects 0.1.1), or implementation reaches the anticipated reattachment of the temporal parser. Either changes lite's tree for some `<…>` values, so it needs its own decision then.
* A label spelling is decided for full UDON, and lite needs to split it out.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- `decided-by` stays `supported` until the revised value set lands; on Joseph's definitions this is `sustained` ("I decided option 2", choosing among an agent's options).
- "Untyped" in the old title was replaced: under [[decision:term-typed-value]] every value has a type, and lite carries this one without reading it.
