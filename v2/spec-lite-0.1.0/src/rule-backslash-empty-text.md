---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-value-end, rule:missing-value]
consequences: []
---

# `:a \` is an empty text

*A label followed only by a framed backslash gets an empty text.*

## Statement

`:label \` with nothing else MUST give the label an empty text.

## Grounds

- Joseph, 2026-10-09: "`:a \` is a perfectly reasonable way to stand in for `:a ''`/`:a ""`"; "\ (for empty text)" ([[rule:missing-value]]). It falls out of [[rule:text-value-end]]: the text ended before it had any piece.

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a \ :b ''
```
````tree
root
  |el
    :a ‹›
    :b ""
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > So I actually lean `:a \` is a perfectly reasonable way to stand in for `:a ''`/`:a ""`, OR as a rule to stand for "explicitly no value specified" which reads by default to be equivalent to null
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I agree fully, except the `:a :b 1` should error … and `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
- Reasoning (agent's): it needs no special case: the framed backslash ends a text that has no pieces yet.
