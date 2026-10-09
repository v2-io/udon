---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [fence-body-indentation]
depends: [rule:fence-body-not-scanned, rule:text-left-edge]
consequences: [rule:fence-body-shallower-line, rule:fence-verbatim-label, rule:fence-dedent-in-meta]
test-fixtures: []
---

# A fence body is dedented by its first line

*Unless the label ends in `-`, a fence body's first non-blank line sets its left edge, and each line loses that many leading spaces.*

## Statement

Unless its label ends in `-`, a fence body's first non-blank line MUST set its left edge, and each body line MUST lose that many leading spaces.

````udon
|rule[implied-root]
  |example
    ```udon
    |document
      |section
    ```
````
```tree
root
  |rule
    :$key ‹implied-root›
    |example
      ```udon "|document\n  |section\n"
```

## Grounds

- [[decision:fence-body-indentation]]: "normal first-inner-sets-indent".
- Joseph's principle recorded there: only notation on the opener and the first line's indentation carry intent; nothing is read from the fence delimiter's own column.

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Hold on... I just started reading your response and am concerned with "suppose a fence body's first line sits deeper than the fence itself..."  I am not sure we can *ever* ascribe any intent to the indent level of the fence delimiter itself in udon. I actually am continuing to read and I don't think the rest of anything rests on that supposition, so I think we see eye to eye-- just as long as we're clear that in udon we only start having clues about intent via special notation on the open (if there are any) and the first line's indent level.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 416)

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): Only notation on the opener and the first line's indentation tell the parser anything about intent.
