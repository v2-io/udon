---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [framed-comments-on-node-lines]
depends: [rule:text-value-end]
consequences: [rule:comments-in-tree]
test-fixtures: []
---

# A framed ` ; ` on an element or attribute line

*On a line that begins with an element or an attribute, a ` ; ` with a space on each side starts a comment to the end of the line.*

## Statement

On a line that begins with an element or an attribute, a `;` with at least one space on each side MUST start a comment that runs to the end of the line.

```udon
|li Item ; TODO
|el :a 1 ; note
|el :url x;y
```
```tree
root
  |li
    :$main ‹Item›
    ; " TODO"
  |el
    :a 1
    ; " note"
  |el
    :url ‹x;y›
```

## Grounds

- [[decision:framed-comments-on-node-lines]]: "' ; ' only counts as a comment when part of sameline and with at least one space on each side."

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 1.  I vote for strict-lean except ' ; ' only counts as a comment when part of sameline and with at least one space on each side. Comments: available on node or attribute started lines, and available as their own block, which also comments everything in that block that is indented further as per the usual with blocks and the indentation. (a), (b) => error,  (c) passed through + reference,  (d) passed through, (e) parsed as a node unless indented further than that in prose that has already started or escaped with \ or a space after the first pipe.
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 290)

- **Why it matters** (the drafter's reasoning): Comments belong on structure lines; in prose a ` ; ` is ordinary punctuation.

- Not discussed: where such a comment sits in the «tree» (shown as a child of the element whose line it ends — the drafter's placement); whether it owns deeper lines (78).
