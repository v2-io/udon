---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [per, depends, test-fixtures, narrates, flags, awaiting-second, awaiting-decision, needs-work, verification-level, evidence, record-status, layer, force, serves, threshold-on, committed]
per: [flags-on-docless-rows, per-kind-verification-and-status, no-max-for-lite, fixtures-are-records, kind-slug-references, open-questions-in-working-notes, typed-reference-fields, force-levels-four, decider-per-store, notes-disposition-at-freeze, links-to-unwritten-records, force-critical-is-ctq]
depends: [def:record, def:record-kinds, def:outline]
---

# per · depends · test-fixtures · narrates · flags · awaiting-second · awaiting-decision · needs-work · verification-level · evidence · record-status · layer · force · serves · threshold-on · committed

*The frontmatter fields a ⟦record⟧ may carry: its links (⟦per⟧, ⟦depends⟧, ⟦test-fixtures⟧, ⟦narrates⟧), the three ⟦flags⟧, its ⟦verification-level⟧ with its ⟦evidence⟧, and computed ⟦record-status⟧, and the fields particular to the spec store's kinds. ⟦kind⟧ itself is defined in [[def:record-kinds]], and a ⟦decision⟧'s own fields in [[def:decision]].*

## Terms

### Links

- **per:** the slugs of the ⟦decision⟧s this ⟦record⟧ rests on. The field is typed to one kind, so its values are bare decision slugs: `per: [row-type]` ([[decision:typed-reference-fields]]).
- **depends:** the records whose *text* this record uses. The field is untyped, so each value carries its kind: `depends: [def:record]`. When a record listed here changes, the dependent is due for a re-read.
- **test-fixtures:** on a ⟦rule⟧, the ⟦fixture⟧ records that pin it. The field is typed to one kind, so its values are bare fixture slugs: `test-fixtures: [implied-root]`.
- **narrates** (explanations): the records an ⟦explanation⟧ describes. A change to any of them marks the explanation stale.

### Flags

- **flags:** the three true/false fields below. Each says who or what moves next.
  - **awaiting-second:** waiting for another entity to give the ⟦record⟧ a thorough once-over.
  - **awaiting-decision:** waiting for the store's declared decider to review and decide ([[decision:decider-per-store]]). Each store names its decider in its kinds file (`decider:`): Joseph (steward) for the SOP store; for the spec store, the udon team's decider, who is Joseph unless the team declares otherwise.
  - **needs-work:** waiting for known work. If true, the details, or a pointer to an audit report or spike result, are in the record's ⟦working-notes⟧.

### Verification

- **verification-level:** how far the ⟦record⟧ has been checked, on a ladder its ⟦kind⟧ declares in `.vsect/kinds.yaml`. It is written only by the act that verifies, together with ⟦evidence⟧. See [[conv:verification-and-status]].
- **evidence:** beside ⟦verification-level⟧, a pointer to what the verifying act checked and how, written by that act. It lives in frontmatter, not in working notes, because it must outlive freeze ([[decision:notes-disposition-at-freeze]]).
- **record-status:** the headline computed from a record's ⟦verification-level⟧ and its ⟦flags⟧, shown as the ∂(status) column. It is computed per kind and never typed.

### Spec-store fields

- **layer** (rules): which part of lite a ⟦rule⟧ governs: `source` · `element` · `value` · `text` · `reserved` · `anomaly` · `tree`. It is not a kind.
- **force** (objective-level kinds: objectives, and principles and fitness where they carry one): `non` (an explicit non-goal) · `desired` (met if possible) · `required` (an intention for this version) · `critical` (critical to quality, CTQ: because of other factors, expected to have an outsized impact on the success or utility of the spec). A requirement is an objective with force `required` or `critical` ([[decision:force-levels-four]], [[decision:force-critical-is-ctq]]). It is a field of its own: the RFC 2119 words in a Statement don't stand in for it.
- **serves** (fitness): the ⟦principle⟧ or principles a ⟦fitness⟧ measures progress toward.
- **threshold-on** (objectives): the ⟦fitness⟧ whose minimum passing value this ⟦objective⟧ sets.
- **committed** (threshold objectives): the date the threshold was set. Every measurement it gates must be dated after this.

## Invariants

- These fields are canon data (⟦concern⟧ 1). An ⟦outline⟧ shows them only as ※ or ∂ columns (see [[def:outline]]).
- Each field holds one value that can change independently of the others. Where two values could change independently, they get two fields.
- No field holds a hand-typed standing word (see [[def:record]]).
- `per` and `depends` point only at records that exist, or at records an outline row of their store names but that are not written yet, which a linter reports as *unwritten* ([[decision:links-to-unwritten-records]]). An entry with no document and no outline row is a dangle.
- A ※ outline column that disagrees with its record's field is a finding, and the record wins.
- On a row with no document, ※ columns show `—` (see [[conv:record-flags]]).

## Why

- **No `questions` field.** Open questions live in a record's working notes ([[decision:open-questions-in-working-notes]]), so frontmatter doesn't repeat them. A record waiting on its decider says so with `awaiting-decision`.

## Working notes

- **Name collision:** the record field shown as ∂(status) has the same name as a decision's `status` (its lifecycle), which is a different thing. This entry names the record's term ⟦record-status⟧ to keep the two apart. Whether a field gets renamed is not decided here.
