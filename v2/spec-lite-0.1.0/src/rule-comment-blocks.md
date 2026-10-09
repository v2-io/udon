---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [framed-comments-on-node-lines]
depends: [rule:nesting]
consequences: [rule:comment-block-owns-deeper-lines, rule:comments-in-tree]
test-fixtures: []
---

# A line starting with `;` is a comment

*A line whose first non-space character is `;` is a comment.*

## Statement

A line whose first non-space character is `;` MUST be a comment.

```udon
|config
  ; the old settings
  :timeout 60
```
```tree
root
  |config
    :timeout 60
    ; " the old settings"
```

## Grounds

- [[decision:framed-comments-on-node-lines]]: comments are "available as their own block".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): Commenting out a block is a primary use of comments.

- Not discussed: whether the comment's text keeps the space after `;` (shown kept); the order of attributes and comment children in the tree (shown: attributes first).
