---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
per: [key-brackets-and-lists]
depends: [def:string, def:text, def:typed-value]
consequences: [rule:key-escapes]
---

# A key holds a value

*The inside of `[key]` is read by the ordinary value rules.*

## Statement

1. The inside of a key (`[…]` directly after an element's name) MUST be read by the same value rules as an attribute value.

## Grounds

- "I agree with your lean toward (a)" — the inside stays a value (Joseph, 2026-10-08): [[decision:key-brackets-and-lists]]; his August position, no syntax divergence between key interiors and attribute values.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|step[1]
|step["01"]
|cite[@{ref.key}]
```
```tree
root
  |step
    :$key 1
  |step
    :$key "01"
  |cite
    :$key ‹@{ref.key}›
```

## Working notes

- **Joseph's words:**

  > 1. (keys) -- You're right-- I also forgot about key particulars. I agree with your lean toward (a) -- I do worry about "string" being its own distinct type from "text" :-)
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Keeps keys and attribute values one value grammar, as Joseph wanted in August; only the bracket and escape handling is shared with the opaque spans.
- Open: where unquoted text inside a key ends (at the `]`, presumably).
- An element as a key (`[|name …]`) is not decided.
