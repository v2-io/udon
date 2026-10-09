---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [node-valued-attributes-in]
depends: []
consequences: [rule:element-after-waiting-label]
---

# An attribute's value may be an element

*Attributes can hold elements.*

## Statement

An attribute's value MAY be an element.

## Grounds

- "My lean is keep" (Joseph, 2026-10-08; [[decision:node-valued-attributes-in]]).

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

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 5. My lean is keep. If so, see what cluster 2 does to this "root decisions" list
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Don't know what you're asking to confirm here. I still lean toward keep them.
- Values written on the lines under a label are [[rule:attribute-bodies]], not yet discussed.
