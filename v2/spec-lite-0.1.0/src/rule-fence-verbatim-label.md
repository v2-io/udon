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

# A label ending in `-` keeps every byte

*When a fence's label ends in `-`, nothing is stripped from its body.*

## Statement

When a fence's label ends in `-`, its body MUST keep every byte; nothing is stripped.

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
    ```diff- " context line\n-removed\n"
```

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

- Open: whether the `-` stays part of the label in the «tree» (shown kept); what a bare ```` ```- ```` means.
