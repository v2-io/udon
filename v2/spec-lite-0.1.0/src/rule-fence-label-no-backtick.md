---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:fence-opens-with-backticks, rule:fence-closes-at-n-or-more]
consequences: []
---

# A fence label contains no backtick

*A line that starts with backticks and has a backtick later in it does not open a fence.*

## Statement

1. The rest of a fence's opening line is its label; if it contains a backtick, the line MUST NOT open a fence.

## Grounds

- "Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line" (Joseph, 2026-10-08): [[rule:fence-closes-at-n-or-more]]; CommonMark's rule.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|p
  ```x``` is how you write inline code
```
```tree
root
  |p
    ‹```x``` is how you write inline code›
```

## Working notes

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** CommonMark's rule; it keeps inline code at a line start from opening a fence, and rules out opening and closing on one line.
- A trailing `-` is a verbatim flag, not part of the label ([[rule:fence-verbatim-label]]).
