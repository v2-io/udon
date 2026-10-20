---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
strength: decided
context: rule-key-escapes.context.md
per: [decided-for-this-version]
depends: [rule:key-holds-a-value, rule:matched-pairs-need-no-escape, rule:opaque-span-escapes]
consequences: []
---

# Escapes in a key

*In a key's unquoted parts only `\\`, `\[` and `\]` are «escape-sequences»; any other backslash is an error.*

## Statement

1. In the unquoted parts of a key, `\\`, `\[` and `\]` MUST give `\`, `[` and `]`; any other backslash MUST be reported as an error. A «delimited-string» inside a key follows its own escapes.

## Grounds

The same strict rule as the opaque spans ([[rule:opaque-span-escapes]]): only the form's own brackets and the backslash escape, so a later version can add escapes without changing what any accepted document means. Debated and decided; see the [context](rule-key-escapes.context.md) file. Revisit as needed.

## Implications

- A `]` or `\` in a bare key needs an escape: `|x[a\]b]`.

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

- Not stated anywhere yet: whether a `]` inside a «delimited-string» inside a key (`|x["a]b"]`) ends the key or belongs to the string. The value rules suggest the string is read first; to confirm with the key cards.
