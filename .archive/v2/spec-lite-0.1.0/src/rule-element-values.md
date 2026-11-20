---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: []
consequences: [rule:element-after-attribute-with-no-value]
---

# An attribute's value may be an element

*Attributes can hold elements.*

## Statement

An attribute's value MAY be an element.

## Grounds

- "My lean is keep" (Joseph, 2026-10-08; the Discussion below).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :x |em hi
```
````tree
root
  |el
    :x |em
      :$main ‹hi›
````

## Discussion

*Carried 2026-10-09 from the decision record `adr/node-valued-attributes-in.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** 0.10.0 lets an attribute's value be an element (`:author` with `|person` under it; `:x |em hi`). Pre-design 64 asked whether lite keeps that, or limits attributes to scalars, text and lists as Joseph's 2026-01-13 "udon-xml" flavor did. The agent listed it among the root questions on 2026-10-08.

**Options considered.**

* Keep element-valued attributes (chosen, as a lean).
* Leave them out of lite.
* Only in block form under the attribute.

**Drivers.**

* None stated with the lean. His earlier reasons, given as "not a decision — pondering" on 2026-07-15 (quoted in pre-design 64): attributes are labeled from the parent's side; the label is conserved and values accumulate under it; children are positional; "an element automatically has a hash-table available and an array available… it seems a little arbitrary to require that only the array can hold additional elements."

**How firm.** His word: "lean". Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]). The follow-up he attached is open work (working notes), not a pending decision.

**Costs accepted.**

* The direction from lite to XML loses something (elements as attribute values have no XML spelling); see [[obj:represent-xml-html]].

**Reopen when.**

* A lite consumer needs the narrower XML-shaped model.

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 5. My lean is keep. If so, see what cluster 2 does to this "root decisions" list
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Don't know what you're asking to confirm here. I still lean toward keep them.
- His attached follow-up ("see what cluster 2 does to this 'root decisions' list") was later answered by him: "Don't know what you're asking to confirm here. I still lean toward keep them." Nothing further is owed on it.
- Values written on the lines under an attribute are [[rule:attribute-bodies]], not yet discussed.
