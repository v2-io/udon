---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [line-ownership-main]
depends: []
consequences: [rule:waiting-label, rule:leftover-values, rule:text-value-end]
---

# One scan for element lines and attribute lines

*Same-line material is read the same way whether the line starts with an element or an attribute.*

## Statement

Material on an element's line and material on an attribute's line MUST be read by the same rule.

## Grounds

- Joseph, 2026-09-29: "All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness"; reaffirmed 2026-10-08 as "the final word" ([[decision:line-ownership-main]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|element[k] :attr this value :another <34>
|element
   :attr this value :another <34>
```
Both lines give `attr ‹this value›` and `another <34>`.

## Working notes

- Joseph's words (2026-09-30T01:55Z, `.int/STEWARD-VERBATIM.md`):

  > I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute. … conceptually I am more and more convinced that the feeling that $main was a good idea *is* a truly good idea, [even though] you say only 5 survives and it's the one I don't understand. All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness.
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 2. And that is the final word unless you uncover a nuance that conflicts with some other "latest thinking"
- The rule itself is [[rule:waiting-label]], [[rule:leftover-values]] and [[rule:text-value-end]].
