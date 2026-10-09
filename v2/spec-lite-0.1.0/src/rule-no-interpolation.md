---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: [quoted-strings-like-ruby]
depends: [rule:strings-like-ruby]
consequences: []
---

# No interpolation in strings

*`#{…}` inside a quoted string is ordinary text.*

## Statement

1. `#{…}` inside a quoted string MUST be kept as the characters written; nothing is interpolated.

## Grounds

- "no interpolation, #{} gets passed through as normal text" (Joseph, 2026-10-08): [[decision:quoted-strings-like-ruby]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

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

## Working notes

- **Joseph's words:**

  > ruby strings:  right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in "".
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Lite resolves and evaluates nothing; `#{…}` stays text so a full UDON or a consumer can decide later.
- `\#` is also an escape in `"…"` ([[rule:double-quote-escapes]]), so a Ruby writer's reflex `"\#{x}"` gives the same `#{x}`.
