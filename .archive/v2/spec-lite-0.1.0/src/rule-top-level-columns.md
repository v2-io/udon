---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:one-root-node]
consequences: []
---

# Top-level lines may start at any column; the root sits at column −1

*The «root-node» counts as being at column −1, so a document may start indented, and a later top-level line that dedents further is still a top-level item.*

## Statement

The «root-node» MUST count as being at column −1: a top-level element or attribute line MAY start at any column, and a later line shallower than every earlier top-level line MUST still be a child of the «root-node», with a «warning».

## Grounds

- Joseph, 2026-10-09 (a lean): "If, for example, the document starts with indented nodes or attributes, those set the indent where they are, and since implicit-root is -1, if a later node dedents further than anything has ever before-- it gets the usual unaligned dedent warning and re-establishes the indentation level but is correctly a sibling of the first thing."
- Joseph, 2025-12-28: "nothing is hardcoded for literal column 0 … Tests shouldn't assume udon starts at column 0."

## Epistemic status

Joseph's lean, working spec.

## Explanation

```udon
  |a
  |b
|c
```
````tree
root
  |a
  |b
  |c
````
Warning at 3:1: `|c` dedents further than the earlier top-level lines.

## Working notes

- "The usual unaligned dedent warning" for structure lines is not carded yet: the nesting rule itself is the gap `rule:nesting`, and siblings at different columns are pre-design 52.
