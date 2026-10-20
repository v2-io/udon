---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
strength: lean
context: rule-newline-in-string-is-error.context.md
per: [errors-stop-parsing, leans-are-working-spec]
depends: [def:delimited-string, rule:strings-like-ruby]
consequences: []
---

# A raw line ending in a delimited string is an error

*A «delimited-string» must close on the line it opens; `\n` writes a newline in a «double-quoted-string».*

## Statement

1. A raw line ending inside a «delimited-string», including one escaped by a `\` at the end of the line, MUST be reported as an error.

## Grounds

Keeps every line's indentation readable: a string that ran onto the next line would hide where that line's structure starts, and `\n` covers the need. A lean; see the [context](rule-newline-in-string-is-error.context.md) file. Revisit as needed.

## Implications

- Multi-line text in a «double-quoted-string» is written with `\n`: `"line one\nline two"`.
- A «single-quoted-string» can't hold a line ending at all, since it has no `\n`.
- Text that really spans lines belongs in prose or a fence.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "line one\nline two"
|q :b "line one
 line two"
```
```tree
root
  |q
    :a "line one\nline two"
✗ error newline-in-string 2:13
```
