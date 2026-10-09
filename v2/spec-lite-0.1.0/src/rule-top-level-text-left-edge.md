---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:one-root-node, rule:text-left-edge]
consequences: []
---

# When a document starts with prose, that text's left edge is column 0

*Leading spaces on a document's first prose lines are kept as content.*

## Statement

When a «document»'s first line is prose, the left edge of that text MUST be column 0, so spaces before its first character are content.

## Grounds

- Joseph, 2026-10-09 (a lean): "If the first line of a file is prose, I lean toward preserving any leading whitespace-- or rather, I should say, setting the leftmost edge as the active indent. Or, said another way possibly-- implicit-root at -1 indent and if the first line is prose it has its indent level set to 0."

## Epistemic status

Joseph's lean, working spec.

## Explanation

```udon
  indented first line
    more indented
back to zero
```
````tree
root
  ‹  indented first line
      more indented
  back to zero›
````

## Working notes

- Inside an element the first text line sets the left edge at its own column ([[rule:text-left-edge]]); at the top level of a document that starts with prose, the edge is column 0 instead.
- History: the old parser stripped every top-level line's leading spaces silently (pre-design 04, "ROOT-BASE"), which lost Markdown indentation at the top level.
- Not discussed: top-level prose that comes after top-level elements or attribute lines.
