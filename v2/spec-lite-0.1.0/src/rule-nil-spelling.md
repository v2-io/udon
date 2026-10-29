---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: decided
context: rule-nil-spelling.context.md
per: [decided-for-this-version]
depends: []
consequences: [rule:reserved-spellings, rule:missing-value, def:typed-value]
---

# `null` is the only spelling of null

*A bare `nil` is text, with a warning that points to `null`.*

## Statement

1. `null` standing alone as a value MUST be the null value.
2. A bare `nil` where `null` would be read MUST be text, and the parser MUST report a default-on «warning» suggesting `null`.

## Grounds

Serves [[obj:represent-structured-data]]: `null` is how JSON, YAML and the other text data formats lite stands beside spell it, and what agents write untaught. Decided by fiat; see the [context](rule-nil-spelling.context.md) file. Revisit as needed.

## Implications

- A writer trained on Ruby, Go, Lua or Swift who writes `nil` gets the text `nil` and a warning: "did you mean `null`?".
- Whether a bare `null` is the null value in every reading, or only through a reading over text, follows the bare-values decision (`.int/spike-values-2026-10-22/ADJUDICATION-GUIDE.md`, decision 1); this card fixes only the spelling.

## Explanation

```udon
|el :a null :b nil
```
````tree
root
  |el
    :a null
    :b ‹nil›
````
Warning at 1:16: `nil` is not lite's null; write `null`.
