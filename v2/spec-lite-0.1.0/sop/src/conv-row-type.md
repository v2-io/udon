---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [row-type, landed-not-integrated]
depends: [def:outline, conv:outline]
---

# Row-type

*Every outline row carries exactly one ⟦row-type⟧: `example` · `gap` · `template` · `exploratory` · `proposed` · `landed`. It is authored in the outline. Only `landed` needs a decision.*

## Statement

- Every row has exactly one ⟦row-type⟧, written in the outline (concern 2):

  | Value | Means | Has a document? |
  |---|---|---|
  | `example` | illustration; never lands | usually |
  | `gap` | a suspected or known absence | no |
  | `template` | scaffolding to copy from | yes |
  | `exploratory` | drafted, but not yet sure it wants to be proposed | yes |
  | `proposed` | a candidate | drafted or not |
  | `landed` | committed canon; implies drafted | yes, unless ∂(doc-state) shows `missing` (committed but not yet written) |

- Every value except `landed` can be written without a decision. Moving a row to `landed` needs a ⟦decision⟧, and the record cites it in ⟦per⟧.
- `landed` is a row-type and nothing else. The influx outcome is ⟦integrated⟧ (see [[def:integration]]).
- A file's location says nothing about row-type. The outline is the authority. A drafted `proposed` or `exploratory` file in `src/` makes no claim of being canon.

## How a violation shows

- A row with no row-type, or with a value outside the six.
- A `landed` row whose record cites no decision.
- `landed` used anywhere as an influx outcome.

## Why

- Joseph's proposal: "row-type: example, gap, template, exploratory, proposed, landed … 'landed' starts them on the ladder below" (`sop/influx/jaw-proposal-and-feedback.md` §1.1).
- His amendment: "landed != integrated (which should be used for tracking influx stuff…)" (§1.4).
- One field, not two: an `example` never lands, so the six values exclude one another (§3.2).

## Working notes

- "Hypothesis-grade claims" were in Joseph's first list of things an outline can hold without a decision, "(I don't think those will apply here)". There is no row-type for them. If one is ever needed, it is a proposed new value.
- **Doubt: does `landed` imply drafted?** Joseph's list says "landed (implies drafted)" and, separately, "missing (implies known-canon missing even a first draft)" (§1.1). The feedback folded the second into `landed` plus ∂(doc-state) `missing` (§3.2), and [[decision:row-type]] states both, as does the table above. Whether he meant "implies drafted" to give way hasn't been asked. By the conflict protocol, ask him rather than choose.
