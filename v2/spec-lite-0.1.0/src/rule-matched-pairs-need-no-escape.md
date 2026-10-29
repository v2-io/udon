---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [rule:unclosed-delimiter-is-error, rule:key-holds-a-value, rule:opaque-span-raw-text]
consequences: [rule:opaque-span-escapes, rule:key-escapes]
---

# Matched pairs inside a delimited form need no escape

*Inside `@{…}`, `;{…}` and a key, an unescaped opener nests and is closed by its own closer; the form ends at the closer that matches its opener.*

## Statement

1. Inside an opaque span (`@{…}`, `;{…}`) or a key (`[…]`), an unescaped occurrence of the form's opening bracket MUST be matched by a closing bracket before the form itself can close; such matched pairs are content and need no escape.

## Grounds

- "an interim convention of matched braces"; "it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something)" (Joseph, 2026-10-08): [[rule:opaque-span-raw-text]].
- Keys take the same bracket matching: [[rule:key-holds-a-value]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :x <a <b> c> :r @{docs/{a b}}
```
```tree
root
  |el
    :x <a <b> c>
    :r ‹@{docs/{a b}}›
```

## Working notes

- **`<…>` is ordinary text (Joseph, 2026-10-29: not reserved, "such as html or xml"):** this card now covers `@{…}` and `;{…}` only. Notes below that discuss `<…>` are history, to move to a context file at the next edit.

- **Joseph's words:**

  > I vote yes, raw text, for typed delimited values (<...>) and references @{...}. […] With the opaque delimited spans (typed values and references) -- I think we can adopt an interim convention of matched braces, warn and pseudo-close span on newline, and detect and unescape either just backslash-escaped brackets for that thing, or potentially consider any single backslash '\' followed by another character as just that next character […] The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > I'm OK with your lean on the opaque escaping -- note that it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something).
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Matched brackets keep common content (HTML-ish `<a <b> c>`, nested braces in a path) writable without escapes; only an unbalanced bracket needs one.
- Joseph called matched brackets an "interim convention" for the spans; "the rule on where it ends doesn't need to be fixed now if the eventual rule is *broader*".
