---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [def:string, def:text, def:typed-value, rule:key-holds-a-value]
consequences: [rule:adjacent-quoted-strings]
---

# List items are whitespace-separated values

*A `[…]` list holds values separated by whitespace; the opaque-span escape rule does not apply to it.*

## Statement

1. A list (`[…]` in a value position) MUST be read as a sequence of values separated by whitespace.

## Grounds

- "arrays are their own thing completely-- multiple whitespace delimited values" (Joseph, 2026-10-08): [[rule:key-holds-a-value]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|cfg :tags [a "b c" 3]
```
```tree
root
  |cfg
    :tags [‹a› "b c" 3]
```

## Working notes

- **Joseph's words:**

  > consequences: understood, agreed.  and #2, you're right-- key-brackets should follow the same rules, but arrays are their own thing completely-- multiple whitespace delimited values.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Lists hold several values, so they keep their own reading rather than the opaque spans' raw text.
- Not yet discussed (gaps): an unquoted item's extent, `[]` versus `[ ]`, nesting, commas, backslashes in bare items, embeds as items.
