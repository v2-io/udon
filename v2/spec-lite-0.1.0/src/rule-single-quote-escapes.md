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

# Escapes in single-quoted strings

*In `'…'` only `\'` and `\\` are escapes; every other backslash is literal.*

## Statement

1. In a `'…'` string, `\'` MUST give `'` and `\\` MUST give `\`; every other backslash MUST be kept as a literal backslash.

## Grounds

- "escape sequences in "" but not in ''" with his example `|'something "hey"\'' weird node name` (Joseph, 2026-10-08): [[decision:quoted-strings-like-ruby]]. `\\` follows Ruby's rule ("just like ruby strings").

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

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

## Working notes

- **Joseph's words:**

  > Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Single quotes are the home for backslash-heavy text: Windows paths, regular expressions.
- Edge for a fixture: `'C:\'` doesn't close (the `\'` is an escaped quote), so the string runs to the end of the line, an error; write `'C:\\'`.
