---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:attribute-with-no-value-takes-next-value, rule:element-values, rule:sameline-element-is-child]
consequences: []
---

# An element right after an attribute with no value yet is its value

*A bare `|name` where an attribute still waits for its value becomes that value.*

## Statement

A bare `|name` that follows, on the same line, an attribute still waiting for its value MUST be that attribute's value, and the rest of the line MUST be the element's.

## Grounds

- "After a still-open label (`|el :x |em hi`) the element is that label's value, as before" ([[rule:sameline-element-is-child]], assent weight).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :x |em hi :y 2
```
````tree
root
  |el
    :x |em
      :$main ‹hi›
      :y 2
````

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Yes, you already know my lean as well. And the value-reading-uniformity gain isn't very uniform because the parser and spec would still need to special case the indent behavior of the next non-blank line underneath.
- After a *finished* value, a bare `|name` is a child instead ([[rule:sameline-element-is-child]]).
