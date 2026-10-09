---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:line-scan]
consequences: [rule:leftover-values, rule:element-after-waiting-label, rule:inline-element-reads-like-a-line]
---

# A label waiting for its value takes the next value

*The next value on the line goes to the label that has none yet.*

## Statement

A `:label` that has no value yet MUST take the next value on its line.

## Grounds

- The ownership rule of 0.10.0 §6.5, carried under Joseph's "final word" on `$main` ([[rule:line-scan]]; the rendering is the agent's).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a 1 :b "two"
```
````tree
root
  |el
    :a 1
    :b "two"
````

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > 2. And that is the final word unless you uncover a nuance that conflicts with some other "latest thinking"
