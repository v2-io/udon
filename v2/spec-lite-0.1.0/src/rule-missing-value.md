---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [missing-values]
depends: []
consequences: []
---

# A bare `:label` is an error

*Implicit missing values aren't supported.*

## Statement

A `:label` with nothing after it on its line and nothing indented under it MUST be an error, whose message says implicit missing values aren't supported and names `nil`, `''` and `\`.

## Grounds

- Joseph, 2026-10-09: "`:a` by itself should be an error something along the lines of 'implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)...'" ([[decision:missing-values]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :d
```
An error at 1:5: implicit missing value; write `nil`, `''` or `\`.

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > the primary reason for erroring on missing values was not because they shouldn't be representable -- … but because we have reserved nested attribute-labels as a potential construct.
