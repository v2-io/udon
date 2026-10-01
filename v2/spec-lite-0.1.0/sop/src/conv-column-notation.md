---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [column-notation, flags-on-docless-rows, no-computed-columns-yet, landed-may-be-missing]
depends: [def:outline, conv:outline]
---

# Column notation and cell marks

*※(Field) means the value comes from that frontmatter field. ∂(Field) means the linter derives it. No marker means the value is authored in the outline. Computed cells with no value show `—`, `∅`, or `⚠`.*

## Statement

- **Column headers carry a ⟦column-marker⟧:**
  - `※(Field)`: the ⟦record⟧'s frontmatter field of that name;
  - `∂(Field)`: derived by the linter or vsect (※ is a simple special case of ∂);
  - no marker: authored in the outline.
- **Nobody hand-edits a ※ or ∂ cell.** The linter writes them.
- **A computed cell with no value carries a ⟦cell-mark⟧:**
  - `—`: not applicable to this row's row-type or kind;
  - `∅`: applicable, but missing (the linter looked, and nothing was there);
  - `⚠`: applicable, but the inputs couldn't be read (unparseable frontmatter, or a reference that doesn't resolve).
- **No outline shows a ※ or ∂ column until a linter exists** to compute or check it ([[decision:no-computed-columns-yet]]). Each view adds such columns when they can be kept true, so no cell ever has to mean "not computed yet".
- **On rows with no document** (`gap` rows, and undrafted `proposed` rows), ※ columns show `—`. **On a `landed` row with no document**, the flags apply but have nothing to come from, so its ※ flag cells show `∅` ([[decision:landed-may-be-missing]]). A pending decision about such a row lives in its ADR or in the pre-design question it concerns, not in the outline.

## How a violation shows

A hand-edited ※ or ∂ cell; an empty computed cell with no mark (once a linter exists); a ※ value on a row with no document.

## Discussion

- Joseph: "Instead of the lock, let's use ∂(Field Name) for derived by the linter and ※(Field Name) for anything that comes from that field name in the frontmatter (a special simplified case of derived)" (`sop/influx/jaw-proposal-and-feedback.md` §1.2).
- Also Joseph: "The outline linter / vsect should write a — or something for cells … where the calculated column is not applicable, and a ∅ when it is *applicable* for that kind, but missing" (§1.3).
- `⚠` was added in feedback so that a failed read never looks like a real absence (§3.7).
- The rule for rows with no document is the answer to §1.7 item 1.

## Working notes

- **An applicability table** (row-type × kind × field → does this column apply?) would tell the linter where `—` belongs, and would double as documentation of each field's scope (§3.7). It isn't written yet.
