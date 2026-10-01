---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [integration-surface, crossing, integrated, rejected, needs-review, skipped, delete-test]
per: [landed-not-integrated]
depends: [def:record]
---

# integration-surface · crossing · integrated · rejected · needs-review · skipped · delete-test

*Material from outside waits on an ⟦integration-surface⟧ until a ⟦crossing⟧ adjudicates it, with exactly one outcome: ⟦integrated⟧, ⟦rejected⟧, ⟦needs-review⟧, or ⟦skipped⟧. Only an item that passes the ⟦delete-test⟧ leaves the surface.*

## Terms

- **integration-surface:** where incoming material waits until someone has adjudicated it: `.int/` for the spec store, `sop/influx/` for the SOP store. That material includes pre-design questions and their histories, the steward's statements and leans, survey reports, proposals, and outside notes.
- **crossing:** the adjudication of an item on an ⟦integration-surface⟧, recorded with exactly one outcome: ⟦integrated⟧, ⟦rejected⟧, ⟦needs-review⟧, or ⟦skipped⟧.
- **integrated:** everything the item carried is now in ⟦record⟧s, or has been consciously set down. This is a word about influx items, seen from the influx side. It is never a ⟦row-type⟧.
- **rejected:** judged wrong or not wanted, with the reason recorded.
- **needs-review:** honestly unsure; the item waits for a named reviewer or closer.
- **skipped:** deliberately not taken up now, with the reason recorded.
- **delete-test:** assume the item disappears. Is every piece of what it carried either in a ⟦record⟧ or truly disposable? A note about the remainder does not count as the remainder carried over.

## Invariants

- Nothing writes ⟦record⟧s directly from outside. Material reaches records only by a ⟦crossing⟧.
- Material keeps its source's standing and never gains standing by crossing. Material from ASF, v2, or history enters as "the source says so; nothing checked here yet".
- An item leaves the surface only by passing the ⟦delete-test⟧, never half-dispatched. An item counts as ⟦integrated⟧ only if it passes.
- Integrated and landed combine without contradiction: an influx item can be integrated by carrying its content into a row that is still only `proposed`. Integration is about the item; landing is about the row.

## Working notes

- Sources: verisectorium `form-influx-membrane` (typed outcomes) and `def-integration-replacement` (the delete-test). Joseph's 2026-09-30 amendment separated `landed` from `integrated` (`sop/influx/jaw-proposal-and-feedback.md` §1.4).
- The surfaces are named differently in the two stores: `.int/`, a dot-directory, so it sits behind the canon, and `sop/influx/`, spelled out because it should be prominent there (§1.8). The role is the same.
- Open: whether `.old/` is the outcome of a crossing (skipped? set down?) or lies outside this model.
- **⟦crossing⟧ was restated on 2026-09-30.** It used to read "an item leaving the integration surface", which contradicted the invariant that only a passed ⟦delete-test⟧ moves an item off, and contradicted how the word is used: `sop/main.outline.md` records a crossing whose `needs-review` item stays in influx. Still open: which outcomes leave the surface. By the delete-test, an ⟦integrated⟧ item leaves, and a ⟦rejected⟧ one presumably does too, since its content is judged disposable. A ⟦needs-review⟧ or ⟦skipped⟧ item stays. No record says this yet, and [[dir:integrate]] should agree with whatever is settled.
