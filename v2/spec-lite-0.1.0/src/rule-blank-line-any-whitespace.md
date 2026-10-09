---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [blank-and-empty-lines, column-shifting-whitespace-is-an-error]
depends: [def:blank-line, rule:blank-line-sets-no-indent, rule:column-shifting-whitespace-error]
consequences: []
---

# A blank line may hold any whitespace

*A «blank-line» may hold tabs and any other Unicode whitespace; the column error does not apply to it.*

## Statement

A «blank-line» MAY hold tabs and any other Unicode whitespace; [[rule:column-shifting-whitespace-error]] does not apply to it.

## Grounds

- Joseph, 2026-10-08: "I would however suggest that 'blank-lines' allow tabs and other unicode ws because blank lines don't set indent/dedent levels" ([[decision:blank-and-empty-lines]]).

## Epistemic status

Chosen. No fixture yet.

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > Tab rule-- right.  I would however suggest that "blank-lines" allow tabs and other unicode ws because blank lines don't set indent/dedent levels.
- **Reasoning:** the column error exists because such whitespace "make[s] the true column position ambiguous"; a blank line sets no column, so there is nothing to make ambiguous.

- Follows from [[rule:blank-line-sets-no-indent]]: whitespace that sets no column can't make a column ambiguous.
