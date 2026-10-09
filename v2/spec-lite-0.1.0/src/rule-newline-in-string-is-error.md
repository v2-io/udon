---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
per: [errors-stop-parsing]
depends: [rule:strings-like-ruby]
consequences: []
---

# A raw newline in a string is an error

*A quoted string must close on the line it opens; `\n` writes a newline in `"…"`.*

## Statement

1. A raw line ending inside a quoted string, including one escaped by a `\` at the end of the line, MUST be reported as an error.

## Grounds

- "I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences" (Joseph, 2026-10-08): [[rule:strings-like-ruby]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "line one\nline two"
|q :b "line one
 line two"
```
```tree
root
  |q
    :a "line one\nline two"
✗ error newline-in-string 2:13
```

## Working notes

- **Joseph's words:**

  > My current lean is that any *error* right now is a failure / stop. That would include #3 on your ways it can end being part of #1 instead, and I think should apply to a label with no value, any tab characters found in block mode, and unclosed embedded |,;,@ nodes or unclosed strings, etc. I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences. I also think that partial-key, unclosed [...  is an error.   Disallowed == error == stop/fail. In some ways it will be treated more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong. Whereas *warnings* are for "this *is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do..."
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** A string that runs onto the next line blurs indentation; `\n` covers the need.
- A single-quoted string can't hold a newline at all (no `\n` there): a known cost.
