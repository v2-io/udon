---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: anomaly
strength: lean
context: rule-unclosed-delimiter-is-error.context.md
per: [errors-stop-parsing, leans-are-working-spec]
depends: [def:anomaly, def:delimited-string]
consequences: [rule:matched-pairs-need-no-escape]
---

# An unclosed delimited form is an error

*If a «delimited-string», list, key, `<…>`, `@{…}`, `;{…}`, `|{…}` or fence is still open where it must close, parsing stops.*

## Statement

1. A delimited form («delimited-string», list, key, `<…>`, `@{…}`, `;{…}`, `|{…}`, or fence) that has not reached its closer by the end of its line, or for a fence by the end of the input, MUST be reported as an error, and no «tree» is produced.

## Grounds

A missing closer is treated as a programming language treats it: the parse stops where the mistake is, and no tool builds on a half-read document ([[decision:errors-stop-parsing]]). A lean; see the [context](rule-unclosed-delimiter-is-error.context.md) file. Revisit as needed.

## Implications

- An editing slip such as a missing `]` or `"` gives no tree at all; the error names where the form opened.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :a "unfinished
```
```text
✗ error unclosed-string 1:7
```

## Working notes

- `needs-work`: "by the end of its line" overreaches for `|{…}`. An unclosed embed is an error, but whether `|{…}` may continue onto the next line belongs to the embeds design, not yet discussed.
- Whether a parser reports only the first error or several is open ([[decision:errors-stop-parsing]]).
- Error codes are placeholders until the anomaly view names them.
