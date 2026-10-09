---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [framed-comments-on-node-lines]
depends: [rule:comment-blocks, rule:nesting]
consequences: []
test-fixtures: []
---

# A comment block owns the deeper lines under it

*Every line indented deeper under a `;` line is part of that comment, never parsed.*

## Statement

Every line indented deeper than a comment block's `;` line MUST be part of that comment, and MUST NOT be parsed.

```udon
; a note
  still the note |el
|el
```
```tree
root
  ; " a note\nstill the note |el"
  |el
```

## Grounds

- [[decision:framed-comments-on-node-lines]]: "available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): One `;` can silence a whole block, including structure that is itself failing to parse.

- Not discussed: how the continuation lines are stripped (0.10.0: the first continuation line sets the strip column).
