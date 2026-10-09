---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
per: [errors-stop-parsing]
depends: [def:anomaly]
consequences: [rule:matched-pairs-need-no-escape]
---

# An unclosed delimited form is an error

*If a string, list, key, `<…>`, `@{…}`, `;{…}`, `|{…}` or fence is still open where it must close, parsing stops.*

## Statement

1. A delimited form (quoted string, list, key, `<…>`, `@{…}`, `;{…}`, `|{…}`, or fence) that has not reached its closer by the end of its line — or, for a fence, by the end of the input — MUST be reported as an error, and no «tree» is produced.

## Grounds

- "something missing a closing delimiter is just a straight-up error and halt and you've done something wrong"; "unclosed embedded |,;,@ nodes or unclosed strings"; "partial-key, unclosed [...  is an error" (Joseph, 2026-10-08): [[decision:errors-stop-parsing]].
- `<…>`, lists and fences are covered by the first sentence and by the restatement he answered without objection (same record).

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|el :a "unfinished
```
```text
✗ error unclosed-string 1:7
```

## Working notes

- **Joseph's words:**

  > My current lean is that any *error* right now is a failure / stop. That would include #3 on your ways it can end being part of #1 instead, and I think should apply to a label with no value, any tab characters found in block mode, and unclosed embedded |,;,@ nodes or unclosed strings, etc. I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences. I also think that partial-key, unclosed [...  is an error.   Disallowed == error == stop/fail. In some ways it will be treated more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong. Whereas *warnings* are for "this *is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do..."
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Lite is strict here so that a mistake fails loudly at its source; Joseph's model is a programming language's missing delimiter. Stopping with no tree also means no tool ever builds on a half-read document.
- Error codes are placeholders until the anomaly view names them.
- Whether a parser reports only the first error or several is open ([[decision:errors-stop-parsing]]).
- `|{…}` across a line break is not decided: Joseph ruled an *unclosed* embed an error, but whether `|{…}` may continue onto the next line (0.10.0 settled it multi-line) belongs to embed interiors, not yet discussed. The Statement's "by the end of its line" overreaches for `|{…}` until then.
