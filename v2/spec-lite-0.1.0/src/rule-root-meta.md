---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [forward-compat-aspiration]
depends: [rule:one-root-node, def:document]
consequences: []
test-fixtures: [implied-root]
---

# A parser may attach meta to the root

*A parser may attach «meta» to the «root-node» that the source doesn't write, such as the filename.*

## Statement

A lite parser MAY attach «meta» to the «root-node» that is not written in the source, such as the filename.

## Grounds

- [[rule:one-root-node]] (Joseph, 2026-09-29): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."; [[decision:ast-centric]].

## Epistemic status

Chosen. No fixture yet.

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`), downgrading "same tree" to an aspiration:
  > … Under this adjustment I think meta is clearly safe to evolve beyond lite.

- How root «meta» is represented is open (13 Q1, 84 Q4).
