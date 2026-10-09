---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [fence-body-indentation]
depends: [rule:fence-body-dedent]
consequences: []
test-fixtures: []
---

# The removed indentation is kept in meta

*The indentation removed from each fence body line is kept in «meta».*

## Statement

The indentation removed from each fence body line MUST be kept in «meta», so the verbatim body can be rebuilt.

## Grounds

- [[decision:fence-body-indentation]]: Joseph, "all dent changes in meta".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): Nothing the author wrote is lost: the verbatim body can always be rebuilt.
