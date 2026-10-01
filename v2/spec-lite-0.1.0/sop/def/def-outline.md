---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [outline, concern, row-type, doc-state, column-marker, cell-mark]
per: [outline-always-true, row-type, doc-state-conforms, column-notation, landed-not-integrated, no-computed-columns-yet, landed-may-be-missing]
depends: [def:record]
---

# outline · concern · row-type · doc-state · column-marker · cell-mark

*An ⟦outline⟧ is a ⟦view⟧ made of tables of rows, and it must always be true. Each of its cells belongs to one ⟦concern⟧. Each row has an authored ⟦row-type⟧ and a computed ⟦doc-state⟧, and ⟦column-marker⟧s and ⟦cell-mark⟧s say where a computed column's values come from and why a cell has none.*

## Terms

- **outline:** a ⟦view⟧ made of tables whose rows point at ⟦record⟧s (or at records that don't exist yet), in reading order. It must always be true: every cell is either authored as a true statement about the collection as it comes together, or reflects canon data and is checked against it.
- **concern:** which of four sources a cell's truth comes from:
  1. canon data, held in ⟦record⟧ frontmatter;
  2. outline-only material relevant to the canon as it comes together (gap, proposed and example rows, and so on), for which the outline is the authority;
  3. reflections of canon, which a linter checks and may rewrite;
  4. process, view, and projection concerns.
- **row-type:** what a row is relative to the canon as it comes together. It is authored in the ⟦outline⟧ (⟦concern⟧ 2), and takes exactly one of these values:
  - `example`: illustration, which never lands;
  - `gap`: a suspected or known absence, with no document;
  - `template`: scaffolding to copy from;
  - `exploratory`: drafted, but not yet sure it wants to be proposed;
  - `proposed`: a candidate, drafted or not;
  - `landed`: committed canon. It is the one value that needs a ⟦decision⟧. Its record is usually drafted, but may be missing ([[decision:landed-may-be-missing]]).
- **doc-state:** whether a row's document exists and conforms to its ⟦kind⟧'s format. It is computed, as the ∂(doc-state) column, for every row that should have a document, and takes exactly one of three values:
  - `missing`: no document;
  - `drafted`: a document exists but does not yet conform to its kind's format;
  - `conforms`: a document exists and conforms.

  The values are exhaustive, move in both directions, and are recomputed rather than typed. A row with no document by its nature (`gap`) shows `—`.
- **column-marker:** a header mark saying where a column's values come from. There are three forms:
  - `※(Field)`: the frontmatter field of that name;
  - `∂(Field)`: derived by the linter or by vsect (※ is a simple special case of ∂);
  - no marker: the column is authored in the ⟦outline⟧.
- **cell-mark:** what the linter writes in a ※ or ∂ cell that has no value:
  - `—`: the column does not apply to this row, because of its ⟦row-type⟧ or ⟦kind⟧, or because the row has no document and isn't `landed` (a `landed` row with no document shows `∅` in its flag cells);
  - `∅`: the column applies, but the value is missing (the linter looked, and nothing was there);
  - `⚠`: the column applies, but the inputs couldn't be read, e.g. unparseable frontmatter or a reference that doesn't resolve.

## Invariants

- Empty, failed, and not-run are always told apart. `∅` is empty and `⚠` is failed; not-run never reaches a cell, because no ⟦outline⟧ shows a ※ or ∂ column until a linter exists ([[decision:no-computed-columns-yet]]).
- Hand-editing a ※ or ∂ cell is a lint failure.
- Each outline table chooses which ※ and ∂ columns to show. Whether a field exists and is measured is a separate question from whether any view shows it.
- Later checks sit beside ⟦doc-state⟧ as separate flags; they are never added as more values of it.
- `landed` is a ⟦row-type⟧ value. ⟦integrated⟧ belongs to influx items and is never used for rows (see [[def:integration]]).

## Discussion
- These terms come from Joseph's proposal and follow-ups in `sop/influx/jaw-proposal-and-feedback.md` §1.1–1.4. The `⚠` cell-mark is the feedback round's addition, adopted in §2.
