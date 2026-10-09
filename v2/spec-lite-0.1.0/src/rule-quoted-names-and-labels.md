---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: element
per: []
depends: [rule:strings-like-ruby]
consequences: []
---

# Quoted names and labels use the string rules

*An element name or attribute label written in quotes is read by the same rules as a quoted string.*

## Statement

1. A quoted element name (`|'…'`, `|"…"`) or quoted attribute label (`:'…'`, `:"…"`) MUST be read by the same rules as a quoted string of that quote.

## Grounds

- "including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`" (Joseph, 2026-10-08): [[rule:strings-like-ruby]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|'something "hey"\'' weird node name
```
```tree
root
  |"something \"hey\"'"
    :$main ‹weird node name›
```

## Working notes

- **Joseph's words:**

  > Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** One quoting rule wherever quotes appear.
- Open: once decoded, may a name contain a newline or control characters (`|"a\nb"`)?
