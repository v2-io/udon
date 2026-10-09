---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [reserved-line-starts-in-prose, references-in]
depends: []
consequences: []
---

# `@name` in the middle of a prose line is text

*Only the start of a prose line reserves `@name`.*

## Statement

`@name` in the middle of a prose line MUST be read as text.

## Grounds

- Joseph, 2026-10-08: "(c) passed through + reference", for `email me @joseph or see @{faq}.` ([[decision:reserved-line-starts-in-prose]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|post
  email me @joseph or see @{faq}.
```
````tree
root
  |post
    ‹email me @joseph or see @{faq}.›
````

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > (a), (b) => error,  (c) passed through + reference
- `!word` in the middle of a prose line is text too ([[rule:bang-word-mid-prose]]).
