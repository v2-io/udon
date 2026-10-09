---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [implied-root, ast-centric]
depends: [def:document]
consequences: [rule:top-level-items-are-root-children, rule:root-never-spelled, rule:root-meta]
test-fixtures: [implied-root]
---

# Every document has exactly one root node

*Parsing a «document» produces exactly one «root-node».*

## Statement

A lite parser MUST produce exactly one «root-node» for each «document».

## Grounds

- [[decision:implied-root]] (Joseph, 2026-09-29): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Working notes

- **Joseph's words** (2026-09-29, `.int/STEWARD-VERBATIM.md`):
  > We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc...

  and earlier (2026-08-07):
  > … having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).

- History: 2011 udon-c had an implied root; Dec 2025–Jul 2026 held "no implicit root wrapper" for streaming, fragments and multi-root (`.int/pre-design/70-survey-index.md` §04).
