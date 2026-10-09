---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
per: []
depends: [rule:fence-closes-at-n-or-more, rule:fence-closer-is-a-line, rule:fence-line-comments]
consequences: []
---

# Text after a closer's backticks is an error

*After a closing line's backticks only spaces or a framed comment may follow; this also catches a nested opener written with too few backticks.*

## Statement

1. On a fence's closing line, anything after the backticks other than spaces or a framed ` ; ` comment MUST be reported as an error.

## Grounds

- "recommend an error/failure on anything else" (Joseph, adopted by the delegate): [[rule:fence-line-comments]].
- "I like our rules (recorded) for both of those as well, definitely. It would probably be useful to mention that nuance vs commonmark in the spec itself" (Joseph, 2026-10-08): [[rule:fence-closer-is-a-line]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

`````udon
|doc
  ```md
  ```js
  ```
`````
```text
✗ error text-after-fence-closer 3:3   ← open the outer fence with four backticks
```

In CommonMark that line would be body content, and the next bare closer would silently close the outer fence early.

## Working notes

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > 3. I like our rules (recorded) for both of those as well, definitely. It would probably be useful to mention that nuance vs commonmark in the spec itself.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** A nested opener written with too few backticks fails at the line that caused it, instead of silently closing the outer fence later.
