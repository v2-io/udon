---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [sameline-element-is-child, node-valued-attributes-in]
depends: [rule:waiting-label, rule:element-values]
consequences: []
---

# An element right after a waiting label is its value

*A bare `|name` where a label still waits for its value becomes that value.*

## Statement

A bare `|name` that follows, on the same line, a `:label` still waiting for its value MUST be that label's value, and the rest of the line MUST be the element's.

## Grounds

- "After a still-open label (`|el :x |em hi`) the element is that label's value, as before" ([[decision:sameline-element-is-child]], assent weight).

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
- After a *finished* value, a bare `|name` is a child instead ([[rule:same-line-element-is-child]]).
