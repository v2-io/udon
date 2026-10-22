---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
strength: lean
per: [errors-stop-parsing, leans-are-working-spec]
depends: [def:anomaly]
consequences: [rule:main-label-colon-warns]
---

# Errors and warnings say "Did you mean …?"

*Wherever a likely intended spelling exists, an error or warning names it.*

## Statement

1. Every error and warning lite defines SHOULD carry a "Did you mean …?" suggestion: the spelling that would most likely give what the writer meant. Each card that defines an error or warning states its suggestion, or says why it has none.

## Grounds

Joseph's direction (2026-10-22): "with "Did you mean?: .... " which we should do with as many warnings/errors as possible as a rule." Lite's readers and writers are mostly agents, who fix what a message tells them to fix ([[prin:simplest-grammar-without-surprise]]).

## Explanation

```udon
|el :path "C:\Users"
|server host: localhost
```
```text
✗ error unknown-escape 1:15   Did you mean '…' (no escapes) or "C:\\Users"?
⚠ warning main-label-colon 2:9   Did you mean :host localhost?
```

## Working notes

- The cards written before 2026-10-22 mostly name a fix in their examples already ([[rule:missing-value]]'s message, [[rule:nil-spelling]], [[rule:double-quote-escapes]]); each needs its suggestion stated when [[view:anomalies]] is assembled.
- Related: "Errors that teach" in `obj.future/candidates.md`.
