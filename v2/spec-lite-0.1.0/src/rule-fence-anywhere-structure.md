---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:fence-opens-with-backticks, rule:nesting, rule:fence-closes-at-n-or-more]
consequences: []
---

# A fence may open wherever structure can start

*Unlike CommonMark, a fence opens at any indentation and on an element's or attribute's line; its position decides its parent.*

## Statement

1. A fence opener MAY appear at any indentation and on an element's or attribute's line, wherever structure can start; its position MUST decide its parent.

## Grounds

- "we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is" (Joseph, 2026-10-08): [[rule:fence-closes-at-n-or-more]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

````udon
|job :script ```sh
make build
```
````
```tree
root
  |job
    :script ```sh "make build\n"
```

## Working notes

- **Joseph's words:**

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** In UDON a fence's position decides its parent, so it can't be limited to the start of a line as in Markdown.
- The spec should name this as a difference from CommonMark (Joseph's suggestion).
