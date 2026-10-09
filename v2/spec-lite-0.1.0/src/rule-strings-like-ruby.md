---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: [quoted-strings-like-ruby]
depends: [def:string]
consequences: [rule:no-interpolation, rule:double-quote-escapes, rule:single-quote-escapes, rule:quoted-names-and-labels, rule:newline-in-string-is-error]
---

# Quoted strings read as Ruby strings

*`"…"` and `'…'` make a «string» read essentially as Ruby reads it, closed at the next unescaped matching quote.*

## Statement

1. A `"…"` or `'…'` string MUST be read as Ruby reads a string literal of the same quote, except as the other string cards say (no interpolation; the escape lists); the result is a «string», a single piece.

## Grounds

- "I think "..." and '...' should essentially be just like ruby strings" (Joseph, 2026-10-08): [[decision:quoted-strings-like-ruby]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "it's" :b 'say "hi"'
```
```tree
root
  |q
    :a "it's"
    :b "say \"hi\""
```

## Working notes

- **Joseph's words:**

  > Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** A syntax agents already know well; "essentially" leaves room for the departures on the escape cards.
- "Essentially" is his word; the departures are on [[rule:no-interpolation]], [[rule:double-quote-escapes]] and [[rule:single-quote-escapes]].
- Open: two strings back to back (`:a "x""y"`), and a closing quote followed directly by letters (`:a "abc"def`).
- His worry about «string» being a distinct type from «text»: a reading option may present a text without embeds as a string ([[decision:representational-options]]).
