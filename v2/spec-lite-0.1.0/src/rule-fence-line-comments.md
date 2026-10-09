---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [fence-line-comments]
depends: [rule:fence-opens-with-backticks, rule:fence-closes-at-n-or-more]
consequences: [rule:comments-in-tree]
test-fixtures: []
---

# Comments on fence lines

*A framed ` ; ` may follow a fence opener's label, or a closer's backticks.*

## Statement

A framed ` ; ` after a fence opener's label MUST end the label and start a comment; one MAY follow a closer's backticks.

````udon
|job :script ```sh ; run in CI
make build
``` ; end of script
````
```tree
root
  |job
    :script ```sh "make build\n"
    ; " run in CI"
    ; " end of script"
```

## Grounds

- [[decision:fence-line-comments]] (the coordinator's call under Joseph's grant; "I support your decision on the comments").

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): Fence lines behave like the other structure lines.

- **Joseph's words:**

  > And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  > Agree no backticks on the fence's label-- which also guarantees that there is no worry about opening and closing a fence on the same line. Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > I support your decision on the comments
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** One comment rule for lines that open or close a node.
- Where these comments sit in the «tree» is the drafter's placement, not discussed.
- Anything other than a framed comment after a closer's backticks is an error ([[rule:fence-closer-trailing-text-is-error]]).
