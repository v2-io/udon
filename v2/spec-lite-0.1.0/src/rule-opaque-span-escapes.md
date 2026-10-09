---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: [opaque-span-escapes-strict]
depends: [rule:opaque-span-raw-text]
consequences: []
---

# Escapes inside opaque spans

*Inside `<…>`, `@{…}` and `;{…}` only `\\` and the span's own delimiters may be escaped.*

## Statement

1. Inside an opaque span, `\\` and the span's own delimiters (`\<` `\>` in `<…>`; `\{` `\}` in `@{…}` and `;{…}`) MUST be read as escapes, and any other backslash MUST be reported as an error.

## Grounds

- "only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use for now until something asks us to make an exception" (Joseph's lean, adopted, 2026-10-08): [[decision:opaque-span-escapes-strict]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :re <re:\\d+> :a <x:a\>b>
|el :bad <re:\d+>
```
```tree
root
  |el
    :re <re:\\d+>     ← raw text re:\d+
    :a <x:a\>b>       ← raw text x:a>b
✗ error unknown-escape 2:13
```

## Working notes

- **Joseph's words:**

  > With your \n = three things note-- it's true. I'm not worried about the string versions but I'm now wondering if, for the other opaque delimiters we might be better off in lite-0.1.0 at least only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use for now until something asks us to make an exception-- similar to the "..." unrecognized escape attempts.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Strict now, broader later if something asks; it also turns `<re:\d+>` into a loud error rather than a silent `re:d+`.
- An escaped delimiter doesn't count toward matching ([[rule:matched-pairs-need-no-escape]]).
