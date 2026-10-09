---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [backslash-by-position]
depends: [rule:text-value-end]
consequences: []
---

# The spaces around a framed ` \ ` are frame

*The framed backslash and its spaces are consumed; neither is content.*

## Statement

A framed ` \ ` that ends same-line text MUST be consumed, and the spaces on either side of it MUST NOT be part of any text.

## Grounds

- Joseph, 2026-10-09: "wrt ' \ ' spaces around it as frame-- I support that" ([[decision:backslash-by-position]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|nav :aria-label Site |a :href / \ Home
|p See |{a :href /docs \ the docs}
```
````tree
root
  |nav
    :aria-label ‹Site›
    |a
      :href ‹/›
      :$main ‹Home›
  |p
    :$main ‹See |{a :href ‹/docs› :$main ‹the docs›}›
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > wrt " \ " spaces around it as frame-- I support that.
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > |nav :aria-label Site |a :href / \ Home  ; this would be the correct way I would think. / |p See |{a :href /docs \ the docs} ; and this for the other.
