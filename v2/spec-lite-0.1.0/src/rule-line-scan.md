---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: []
consequences: [rule:waiting-label, rule:leftover-values, rule:text-value-end, rule:inline-element-reads-like-a-line]
---

# One scan for element lines and attribute lines

*Same-line material is read the same way whether the line starts with an element or an attribute.*

## Statement

Material on an element's line and material on an attribute's line MUST be read by the same rule.

## Grounds

- Joseph, 2026-09-29: "All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness"; reaffirmed 2026-10-08 as "the final word".

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|element[k] :attr this value :another <34>
|element
   :attr this value :another <34>
```
Both lines give `attr ‹this value›` and `another <34>`.

## Discussion

*Carried 2026-10-09 from the decision record `adr/line-ownership-main.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** What the rest of a line belongs to has been answered five ways since 2011 (pre-design 71). On 2026-09-29 Joseph reaffirmed `$main` and named "attribute-sameline": same-line processing treated exactly the same whether the line starts with an element or an attribute. He said then that it wasn't a final verdict. On 2026-10-08 the agent listed "who owns the rest of a line" as a root question, citing that reaffirmation as the strongest input, and Joseph answered that it is the final word.

**Options considered.**

* `$main` with attribute-sameline (chosen).
* The element's line as text (0.7, 2011) and the other historical answers in pre-design 71 and 73.

**Drivers.**

* One behavior for element lines and attribute lines: "All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness" (Joseph, 2026-09-29).
* A real-world use: element lines followed by attribute lines (`|term Lexicon Entry` then `:added <2026-10-01>`, `:status frozen`), "a crucial real-world use reason" (Joseph, 2026-09-29).

**How firm.** His words: "conjecture" and "not a final verdict" on 09-29; "the final word unless you uncover a nuance" on 10-08, which upgrades it. His own call, so `steward`.

**Reopen when.**

* A nuance conflicts with other latest thinking (his condition).

**Joseph's words not already quoted on this card.**

> Another thing *that may not have been discussed* but only thought at the time-- it allows us to treat sameline processing exactly the same if we are *sameline on an attribute*: […] I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute. […]
>
> ok... conceptually I am more and more convinced that the feeling that $main was a good idea *is* a truly good idea, [even though] you say only 5 survives and it's the one I don't understand. All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness.
>
> It seems.  This isn't a final verdict-- this is my current understanding.
>
> — Joseph, 2026-09-29 evening (2026-09-30T01:55:54Z), `.int/STEWARD-VERBATIM.md` (carried there whole from session `5930da5d`)
## Working notes

- Joseph's words (2026-09-30T01:55Z, `.int/STEWARD-VERBATIM.md`):

  > I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute. … conceptually I am more and more convinced that the feeling that $main was a good idea *is* a truly good idea, [even though] you say only 5 survives and it's the one I don't understand. All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness.
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 2. And that is the final word unless you uncover a nuance that conflicts with some other "latest thinking"
- The rule itself is [[rule:waiting-label]], [[rule:leftover-values]] and [[rule:text-value-end]].
