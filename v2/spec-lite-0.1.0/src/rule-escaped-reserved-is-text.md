---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [reserved-is-an-error]
depends: [rule:prose-passes-through]
consequences: []
---

# An escaped reserved spelling is text

*Escaping a reserved form is how to write it as text.*

## Statement

A reserved spelling written with an escape that lite defines MUST be read as text, not as reserved.

## Grounds

- Joseph, 2026-10-09: reserved constructs mean "don't use them, including by properly escaping them".

## Epistemic status

Decided for this version. Which escapes exist on an element's or attribute's line is still open ([[rule:value-line-escapes]]).

## Explanation

```udon
|post
  \@alice said so.
```
````tree
root
  |post
    ‹@alice said so.›
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > One issue would be sameline @ (without @{...}) -- I believe we decided that was a reserved construct that errors if tried-- so we would need to allow it to be escaped as well-- same with !. Which means we have this other side of what the reserved constructs mean: don't use them, including by properly escaping them.
- Reasoning (agent's): if a reserved form can't be escaped, ordinary text that happens to start with `@` or `!` has no lite spelling at all.
