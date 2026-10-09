---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [missing-values, nested-attributes-reserved]
depends: []
consequences: [rule:reserved-spellings]
---

# A label with no value followed by another label is an error

*`:a :b 1` would nest an attribute under an attribute.*

## Statement

A `:label` with no value followed on the same line by another `:label` MUST be an error.

## Grounds

- Joseph, 2026-10-09: `:a :b 1` "should error not as a deletion detector (although it serves that purpose) but due to nested attributes being reserved" ([[decision:missing-values]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a :b 1
```
An error: nested attributes are reserved.

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I agree fully, except the `:a :b 1` should error not as a deletion detector (although it serves that purpose) but due to nested attributes being reserved
