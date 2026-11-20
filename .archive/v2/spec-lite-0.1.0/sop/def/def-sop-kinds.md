---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [sop-store, directive, convention, reference]
per: [sop-own-vsect-and-decisions, kind-in-frontmatter, sop-kind-convention]
depends: [def:record, def:record-kinds]
---

# sop-store · directive · convention · reference

*The ⟦sop-store⟧ records how work is done in this corpus, apart from what lite is. Besides ⟦definition⟧s and ⟦decision⟧s it holds three kinds, told apart by how they fail: ⟦directive⟧s, ⟦convention⟧s, and ⟦reference⟧s.*

## Terms

- **sop-store:** `sop/`, the part of this corpus that records how work is done here, kept apart from the spec store it serves. It is a small verisectorium of its own, with its own ⟦main-outline⟧, its own `sop/.vsect/kinds.yaml`, its own ⟦decision⟧s in `sop/adr/` (separate from lite's spec decisions), and its own ⟦integration-surface⟧, `sop/influx/`.
- **directive** (`dir`): a practice to carry out at a named moment (its `when:`). For example: how to orient on arrival; how to route an item out of influx.
  - It fails by not firing when its moment comes, by misleading, or by going stale.
  - It is repaired by moving its trigger to where the moment actually occurs, by rewriting it, or by refreshing it.
  - Whether it fires can only be seen by watching work being done.
- **convention** (`conv`): a standing rule about how ⟦record⟧s and ⟦view⟧s are shaped, such as field values, notation, naming, or references.
  - It fails by being ambiguous, by being contradicted by what is in the corpus, or by colliding with another convention.
  - It is repaired by clarifying it, fixing the violating records, or superseding it.
  - Whether it holds can be seen in the artifacts themselves, so each convention is written so that a linter could check it.
- **reference** (`ref`): working facts that other ⟦record⟧s rely on and that change as the world changes, such as named hazards or where things are usually kept.
  - It fails by going stale or by being wrong about its source.
  - It is repaired by re-checking it against the source and refreshing it.

## Invariants

- ⟦definition⟧s and ⟦decision⟧s mean the same in the ⟦sop-store⟧ as in the spec store.
- A ⟦directive⟧ states its moment. A practice with no trigger is a hope, not a directive.
- A ⟦convention⟧ states how a violation would show up in the corpus, so a linter can check it later.
- A ⟦reference⟧ names its source.
- Directives and conventions take their authority from the decisions they cite in ⟦per⟧, never from their own wording.

## Discussion

- **Why these three:** they fail differently. A directive fails at a moment, which only watching work reveals. A convention fails in the artifacts, where a linter can find it. A reference fails as the world moves.
- **Precedent:** the verisectorium template's SOP outline has `directive` and `reference`. `convention` is new here. It holds what the template spreads across `form-*` and `claim-*` segments, and what this corpus mostly consists of: notation, field values, and reference syntax.

## Working notes

