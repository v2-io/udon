---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: decided
context: rule-single-quote-escapes.context.md
per: [decided-for-this-version]
depends: [def:delimited-string, rule:strings-like-ruby]
consequences: []
---

# Escapes in «single-quoted-string»s

*In a «single-quoted-string» only `\'` and `\\` are «escape-sequence»s; every other backslash is literal.*

## Statement

1. In a «single-quoted-string», `\'` MUST give `'` and `\\` MUST give `\`; every other backslash MUST be kept as a literal backslash.

## Grounds

Ruby's rule for single quotes, part of the decision in [[rule:strings-like-ruby]]. Debated and decided; see the [context](rule-single-quote-escapes.context.md) file. Revisit as needed.

## Implications

- Single quotes are the home for backslash-heavy text: `'C:\Users\me'`, `'\d+\s*'`.
- A single-quoted string can't end in a lone backslash: `'C:\'` doesn't close (the `\'` is an escaped quote), so the string runs to the end of the line, an error. Write `'C:\\'`.
- A single-quoted string can't hold a line ending at all.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :p 'C:\Users\me' :s 'it\'s'
```
```tree
root
  |q
    :p "C:\\Users\\me"
    :s "it's"
```
