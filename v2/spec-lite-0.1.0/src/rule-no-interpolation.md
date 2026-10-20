---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: decided
context: rule-no-interpolation.context.md
per: [decided-for-this-version]
depends: [def:delimited-string, rule:strings-like-ruby]
consequences: []
---

# No interpolation in delimited strings

*`#{…}` inside a «delimited-string» is ordinary characters.*

## Statement

1. `#{…}` inside a «delimited-string» MUST be kept as the characters written; nothing is interpolated.

## Grounds

Lite evaluates nothing, so `#{…}` stays characters for a full UDON or a consumer to decide about later. Debated and decided; see the [context](rule-no-interpolation.context.md) file. Revisit as needed.

## Implications

- A Ruby writer's `"#{x}"` gives the six characters `#{x}`; so does the escaped `"\#{x}"`, since `\#` is an escape ([[rule:double-quote-escapes]]).

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "x #{y} z"
```
```tree
root
  |q
    :a "x #{y} z"
```
