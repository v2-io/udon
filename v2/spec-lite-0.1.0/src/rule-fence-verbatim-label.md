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

# A trailing `-` on a fence opener marks it verbatim

*The `-` is a flag on the fence, not part of its label, and a verbatim fence's body keeps every byte.*

## Statement

A `-` ending a fence's opener MUST mark the fence verbatim and MUST NOT be part of its label; a verbatim fence's body MUST keep every byte.

````udon
|patch
  ```diff-
 context line
-removed
  ```
````
```tree
root
  |patch
    ```diff verbatim " context line\n-removed\n"
```
A bare ```` ```- ```` is a verbatim fence with no label. *(How the transcript prints the flag waits on [[rule:tree-transcript]].)*

## Grounds

- [[decision:fence-body-indentation]]: Joseph, "'-' suffix for verbatim".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Excellent. I agree completely with your leans as my leans:   normal first-inner-sets-indent+warn-on-dedent   +   '-' suffix for verbatim & all dent changes in meta.   And for the closer-- *transparent to fence body* (i.e., comes *after* the end of the fenced body), indent level sets new current indent level, with dedenting/closing etc. as appropriate. I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 467)

- **Why it matters** (the drafter's reasoning): A body whose first line must sit deeper than later ones (a patch, a code fragment) needs a way to say "strip nothing".

- Joseph, 2026-10-09: "in the AST, no, it would be its own flag. bare ```- should be very obviously a fenced block preserved verbatim." Both follow from "'-' suffix for verbatim"; they should not have been raised as questions.
