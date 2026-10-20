---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:nesting, rule:fence-closes-at-n-or-more]
consequences: [rule:fence-anywhere-structure, rule:fence-label-no-backtick, rule:fence-closes-at-n-or-more, rule:fence-line-comments, rule:fence-body-not-scanned]
---

# A fence opens with three or more backticks

*A run of N ≥ 3 backticks where structure can start opens a fence of length N.*

## Statement

1. A run of three or more backticks (N of them), where a structure line or sameline structure can start, MUST open a fence of length N.

## Grounds

- "nested fences via backtick count >= 3 is my strong preference" (Joseph, 2026-10-08): [[rule:fence-closes-at-n-or-more]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

`````udon
|doc
  ````md
  ```js
  run()
  ```
  ````
`````
```tree
root
  |doc
    ```md "```js\nrun()\n```\n"
```

## Working notes

- **Joseph's words:**

  > Decision A:  We should allow nested fences via backtick count >= 3 is my strong preference.  Is there a standard? I know, for example, that we will not want to follow markdown's standard (in some versions) of requiring that a fence be at the beginning of a line or the first non-whitespace of a line-- we need its indent (including sameline) to decide whose child it is.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Fence length lets a fence hold a fence, which the spec corpus needs for its own examples.
- **Open thought (Joseph, 2026-10-20, to adjudicate later):** "I'm thinking about potentially changing ``` to ~~~  to better distinguish between udon and markdown and to make the ```` type stuff less necessary in the sunny-day case." Not decided; it would touch every fence card and [[rule:text-value-end]]'s list of text terminators.
