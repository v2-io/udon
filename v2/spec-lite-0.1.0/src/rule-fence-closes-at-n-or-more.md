---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: [fence-nesting-by-length]
depends: [rule:fence-opens-with-backticks]
consequences: [rule:fence-closer-trailing-text-is-error, rule:fence-closer-is-a-line, rule:fence-body-not-scanned, rule:fence-line-comments]
---

# A fence closes at N or more backticks

*A fence of length N closes at the first later line whose first non-space content is N or more backticks.*

## Statement

1. A fence of length N MUST close at the first later line whose first non-space content is a run of N or more backticks.

## Grounds

- [[decision:fence-nesting-by-length]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

`````udon
````md
```js
x
```
````
`````
```tree
root
  ```md "```js\nx\n```\n"
```

## Working notes

- **Joseph's words:**

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** The CommonMark rule for nesting by length.
