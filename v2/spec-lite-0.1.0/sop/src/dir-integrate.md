---
kind: directive
awaiting-second: true
awaiting-decision: false
needs-work: false
when: "carrying material from .int/ or sop/influx/ into records: carving a proposal into segments, closing a pre-design question, taking in a report"
per: [landed-not-integrated]
depends: [def:integration, conv:row-type]
---

# Carrying material out of an integration surface

*Nothing writes ⟦record⟧s directly from outside. Material waits on an ⟦integration-surface⟧ until someone adjudicates it, then leaves by a recorded ⟦crossing⟧ with one outcome.*

## Statement

1. **Carry, don't copy.** Write the record from the material, citing it. Carried content keeps its source's standing. Material from ASF, v2, or history enters as "the source says so; nothing checked here yet".
2. **Record the crossing** with exactly one outcome: ⟦integrated⟧, ⟦rejected⟧, ⟦needs-review⟧, or ⟦skipped⟧. Record the reason whenever the outcome is not `integrated`. Until an integration log exists, record it in the store's `main.outline.md` working notes.
3. **Pass the ⟦delete-test⟧ before calling an item integrated.** Assume the item disappears. Is every piece of what it carried now in a record, or truly disposable? A note about the remainder does not count as the remainder carried over.
4. **Only a passed delete-test moves an item off the surface.** Half-integrated items stay where they are, with their remainder named.

## Discussion
- Verisectorium's `form-influx-membrane` and `def-integration-replacement`, carried over.
- Joseph's amendment that `integrated` is the influx side's word and `landed` is a row-type (`sop/influx/jaw-proposal-and-feedback.md` §1.4).

## Working notes

- Where crossings are logged is not decided yet. The outline's working notes are the interim place.
