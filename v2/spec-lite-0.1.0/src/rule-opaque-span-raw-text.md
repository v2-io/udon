---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: [opaque-spans, explicit-typed-value-in, references-in]
depends: [def:typed-value]
consequences: [rule:opaque-span-escapes, rule:newline-in-opaque-span-is-error, rule:inline-comments]
---

# Opaque spans carry raw text

*The «tree» holds the text between the delimiters of `<…>`, `@{…}` and `;{…}`, escapes resolved, with no meaning attached.*

## Statement

1. For an explicit typed value `<…>`, a reference `@{…}` or an inline comment `;{…}`, the «tree» MUST carry the raw text between the delimiters, escapes resolved, and lite MUST NOT attach meaning to it (no type-label split, no resolving).

## Grounds

- "I vote yes, raw text, for typed delimited values (<...>) and references @{...}" (Joseph, 2026-10-08): [[decision:opaque-spans]]; `;{…}` takes the same rules ([[decision:inline-comments-in-prose]]).

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :when <2026-07-11> :size <u64:0xff>
```
```tree
root
  |el
    :when <2026-07-11>       ← text, not a date
    :size <u64:0xff>
```

## Working notes

- **Joseph's words:**

  > I vote yes, raw text, for typed delimited values (<...>) and references @{...}. […] With the opaque delimited spans (typed values and references) -- I think we can adopt an interim convention of matched braces, warn and pseudo-close span on newline, and detect and unescape either just backslash-escaped brackets for that thing, or potentially consider any single backslash '\' followed by another character as just that next character […] The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Lite attaches no meaning to typed values or references; a later version may parse their insides (a type label, a path) without lite having guessed.
- Empty spans `<>` and `@{}` are not decided; `:n ;{}` is a text whose only piece is an empty comment (Joseph, 2026-10-09).
