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

# A `:label` line owned by an attribute is an error

*An attribute can't have attributes.*

## Statement

A `:label` line whose owner, by indentation, is an attribute MUST be an error.

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
An error at 3:5: nested attributes are reserved. The same holds wherever the `:label` line sits in the attribute's body:

```udon
|db
  :note
    Primary only.
    :port 5432
```
An error at 4:5. A `:label` line under an element inside the attribute's body belongs to that element and is fine:

```udon
|book
  :author
    |person
      :name Jane
```

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Right-- nested attributes right now should be a reserved construction that causes an error in lite.
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > :label-under-open-attribute:  error reserved construction
- Scope follows from nesting: a line's owner is the node it sits under, so any `:label` line an attribute owns is covered, wherever in the body it sits. The card used to say "directly under", which read as if the scope were open; Joseph, 2026-10-09: "I don't understand what is still open vs everything already [ruled]". Nothing was open.
