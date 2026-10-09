---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
per: []
depends: [rule:key-holds-a-value, rule:matched-pairs-need-no-escape]
consequences: []
---

# Escapes in a key

*In a key's unquoted parts only `\\`, `\[` and `\]` are escapes; any other backslash is an error.*

## Statement

1. In the unquoted parts of a key, `\\`, `\[` and `\]` MUST give `\`, `[` and `]`; any other backslash MUST be reported as an error. A quoted string inside a key follows its own escapes.

## Grounds

- "key-brackets should follow the same rules" as the opaque spans (Joseph, 2026-10-08): [[rule:key-holds-a-value]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|x[a\]b]
```
```tree
root
  |x
    :$key ‹a]b›
```

## Working notes

- **Joseph's words:**

  > consequences: understood, agreed.  and #2, you're right-- key-brackets should follow the same rules, but arrays are their own thing completely-- multiple whitespace delimited values.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Strict for now, like the opaque spans, so later versions can add escapes without changing accepted documents.
