---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: [fence-closer-is-a-line]
depends: [rule:fence-closes-at-n-or-more, rule:nesting]
consequences: []
---

# A fence's closing line nests at its own column

*The closer is not part of the body; its column then closes open elements at or right of it, like any line.*

## Statement

1. A fence's closing line MUST NOT be part of the body, and its column MUST then act as any line's column does for nesting.

## Grounds

- "*transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate" (Joseph, 2026-10-08): [[decision:fence-closer-is-a-line]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

````udon
|abcdef |ghijkl :something ```txt
     body…
     ```
       |next
````
```tree
root
  |abcdef
    |ghijkl
      :something ```txt "body…\n"
    |next          ← the closer at column 5 closed ghijkl
```

## Working notes

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Every non-blank line takes part in nesting by its column, as comment lines do; a closer is just another line, and what you see matches the structure.
- Recommended placement (aligned with the opener) is advice for [[expl:writing-lite]], not a rule.
