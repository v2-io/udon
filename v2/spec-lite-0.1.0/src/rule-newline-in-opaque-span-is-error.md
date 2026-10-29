---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
per: []
depends: [rule:opaque-span-raw-text]
consequences: []
---

# A newline in an opaque span is an error, worded as lite's limit

*`<…>`, `@{…}` and `;{…}` must close on their own line; the error says lite doesn't support the newline.*

## Statement

1. A line ending inside `<…>`, `@{…}` or `;{…}` MUST be reported as an error whose message says that lite doesn't support newlines in that construct.

## Grounds

- "turning the newline in the opaque spans into an error for now, with the caveat that the error message explains that '**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition" (Joseph, 2026-10-08): [[rule:opaque-span-raw-text]].
- `;{…}`: "newlines in embedded comments are simply reserved with error … they make dedent level ambiguous in several corner cases" (same record).

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :when <2026-01-01
  /2026-06-30>
```
```text
✗ error newline-in-typed-value 1:10   ← "lite doesn't support newlines in a typed value"
```

## Working notes

- **Joseph's words:**

  > I'm ok though turning the newline in the opaque spans into an error for now, with the caveat that the error message explains that '**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition. If some user needs to accept it anyway with a warning we can give a command-line flag to disable it-- *when*/if it's requested/needed.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > 2. I'm ok keeping it simple with lite 1.0 and saying newlines in embedded comments are simply reserved with error. The main issue is similar to fence-closing lines-- they make dedent level ambiguous in several corner cases.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Newlines inside these spans make the dedent level ambiguous in corner cases; the message names lite so the limit isn't read as a UDON-wide rule.
- A command-line flag to accept it with a warning, "*when*/if it's requested/needed".
