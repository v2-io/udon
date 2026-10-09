---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: [nested-attributes-reserved]
depends: []
consequences: [rule:reserved-spellings]
---

# A `:label` line under an open attribute value is an error

*An attribute can't have attributes.*

## Statement

A `:label` line directly under an attribute whose value is still open MUST be an error.

## Grounds

- Joseph, 2026-10-08: "nested attributes right now should be a reserved construction that causes an error in lite"; "`:label`-under-open-attribute: error reserved construction" ([[decision:nested-attributes-reserved]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|db
  :port
    :nested 1
```
An error at 3:5: nested attributes are reserved.

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Right-- nested attributes right now should be a reserved construction that causes an error in lite.
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > :label-under-open-attribute:  error reserved construction
- Scope: only the line directly under the label, or any `:label`-shaped line anywhere in an open attribute's body (0.10.0's K8 covered both)? Not discussed.
