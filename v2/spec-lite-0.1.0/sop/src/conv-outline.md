---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [outline-always-true, main-outline-name, column-notation, outline-is-current-truth, row-type, landed-may-be-missing, record-to-decision-links-for-now]
depends: [def:outline, def:record]
---

# The outline must always be true

*Every cell in an ⟦outline⟧ belongs to exactly one of four ⟦concern⟧s. Each concern has its own source of truth, so the outline can be true even while the canon is still being assembled.*

## Statement

- **Every cell belongs to exactly one ⟦concern⟧:**
  1. **canon data**, in ⟦record⟧ frontmatter;
  2. **outline-only material relevant to the canon as it comes together**, such as gap, proposed, example, template, and exploratory rows, for which the outline is the authority;
  3. **reflections of canon**: ※ and ∂ columns, which a linter checks and may rewrite;
  4. **process, view, and projection concerns.**
- **A row is true because of what it claims.**
  - A `gap` row claims only that a gap is suspected or known.
  - A `proposed` row claims only that the record is a candidate.
  - A ※ or ∂ cell claims only what its source says.
  - Nothing in an outline claims more than its concern can support.
- **Each store's primary view is `main.outline.md`**: `main.outline.md` for the spec store and `sop/main.outline.md` for the SOP store. It is one view among possibly many.
- **Each table chooses which ※ and ∂ columns to show.** A field that no table shows still exists and is still measured.
- **An outline holds current truth, the results of decisions.** It does not compile the decisions themselves. Decision records are reached through the `per` citations of the records that rest on them ([[decision:outline-is-current-truth]]).

## How a violation shows

A linter could find each of these:

- a ※ or ∂ cell that disagrees with its source;
- a ※ cell on a row with no document that shows anything other than `—`, or other than `∅` if the row is `landed`;
- a row-type value outside the six;
- a `landed` row with a document whose record cites no decision in ⟦per⟧. A `landed` row with no document shows `∅` for its decision citation instead ([[decision:record-to-decision-links-for-now]]).

## Discussion
- Joseph, 2026-09-30: "The principle is that THE OUTLINE MUST ALWAYS BE TRUE. That becomes difficult when we are first assembling it and trying things out etc." (`sop/influx/jaw-proposal-and-feedback.md` §1.1).
- The four concerns are his proposal from the same message. They are what makes that principle achievable: only concern-3 cells can drift, and those are exactly what the linter checks.
- "Outline = view" is a working theory, not a fixed ideal; there may yet be a call for at least one canonical full view (§1.8). The kinds map, not any outline, is what says what the corpus is.
- The check for `landed` rows with no decision in ⟦per⟧ was the fork's addition in feedback (§3.2). Joseph accepted it as process, "with notes for the future linter" (§1.7 item 7), and [[decision:row-type]] records it.

## Working notes

