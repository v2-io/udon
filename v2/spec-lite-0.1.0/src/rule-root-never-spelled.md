---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [implied-root]
depends: [rule:one-root-node]
consequences: []
test-fixtures: [implied-root]
---

# The root node is never spelled

*No spelling in the source opens, closes or names the «root-node»; a top-level element named `document` or `root` is an ordinary child.*

## Statement

A lite parser MUST NOT read any spelling in the source as opening, closing or naming the «root-node»: a top-level element named `document` or `root` is an ordinary child.

## Grounds

- [[decision:implied-root]] (Joseph, 2026-09-29): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Explanation

Think of the «document» as an outermost element you never write. Writing `|document` at the top makes a child that happens to be called `document`:

![[dat/implied-root.yaml#root_is_never_spelled]]

## Working notes

- **Joseph's words** (2026-09-29, `.int/STEWARD-VERBATIM.md`):
  > We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

  and earlier (2026-08-07):
  > … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).
