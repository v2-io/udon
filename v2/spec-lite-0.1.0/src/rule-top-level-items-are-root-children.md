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

# Top-level items are the root's children, in order

*Every node made from a top-level item of the source is a child of the «root-node», in source order.*

## Statement

Every node made directly from a top-level item of the source MUST be a child of the «root-node», in source order.

## Grounds

- [[decision:implied-root]] (Joseph, 2026-09-29): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Explanation

![[dat/implied-root.yaml#root_single_top_level_element]]

## Working notes

- **Joseph's words** (2026-09-29, `.int/STEWARD-VERBATIM.md`):
  > We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

  and earlier (2026-08-07):
  > … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

- Top-level `:label` lines and top-level text are open (04; the outline's `rule:top-level` gap); case `root_top_level_label` in [[fixture:implied-root]] holds the readings.
