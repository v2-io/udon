---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:one-root-node]
consequences: [rule:top-level-attributes]
test-fixtures: [implied-root]
---

# Top-level items are the root's children, in order

*Every node made from a top-level item of the source is a child of the «root-node», in source order.*

## Statement

Every node made directly from a top-level item of the source MUST be a child of the «root-node», in source order.

## Grounds

- [[rule:one-root-node]] (Joseph, 2026-09-29): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Explanation

![[dat/implied-root.yaml#root_single_top_level_element]]

## Working notes

- **Joseph's words** (2026-09-29, `.int/STEWARD-VERBATIM.md`):
  > We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

  and earlier (2026-08-07):
  > … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

- Top-level attribute lines belong to the root ([[rule:top-level-attributes]]); top-level text and columns: [[rule:top-level-text-left-edge]], [[rule:top-level-columns]]. Case `root_top_level_label` in [[fixture:implied-root]] is reading 04-Q2-B.
