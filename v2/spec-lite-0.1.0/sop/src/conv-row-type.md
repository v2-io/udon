---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [row-type, landed-not-integrated, landed-may-be-missing, record-to-decision-links-for-now]
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
  | `landed` | committed canon | usually; ∂(doc-state) may show `missing` (see below) |

- Every value except `landed` can be written without a decision. Moving a row to `landed` needs a ⟦decision⟧, and the record cites it in ⟦per⟧.
- **A `landed` row may have no document** ([[decision:landed-may-be-missing]]). Typically:
  - the record is small, and its core is covered by the row's description, or still sits in `.int/` or influx, not yet moved out;
  - the record was refactored away and the outline wasn't updated.

  Its ∂(doc-state) is then `missing`, and its ※ flag cells show `∅`, not `—` ([[conv:column-notation]]). It has no `per:` either, so its decision citation also shows `∅`; the decision is found by searching `adr/` ([[decision:record-to-decision-links-for-now]]).
- `landed` is a row-type and nothing else. The influx outcome is ⟦integrated⟧ (see [[def:integration]]).
- A file's location says nothing about row-type. The outline is the authority. A drafted `proposed` or `exploratory` file in `src/` makes no claim of being canon.

## How a violation shows

- A row with no row-type, or with a value outside the six.
- A `landed` row with a document whose record cites no decision.
- `landed` used anywhere as an influx outcome.

## Why

- Joseph's proposal: "row-type: example, gap, template, exploratory, proposed, landed … 'landed' starts them on the ladder below" (`sop/influx/jaw-proposal-and-feedback.md` §1.1).
- His amendment: "landed != integrated (which should be used for tracking influx stuff…)" (§1.4).
- One field, not two: an `example` never lands, so the six values exclude one another (§3.2).

## Working notes

- "Hypothesis-grade claims" were in Joseph's first list of things an outline can hold without a decision, "(I don't think those will apply here)". There is no row-type for them. If one is ever needed, it is a proposed new value.
