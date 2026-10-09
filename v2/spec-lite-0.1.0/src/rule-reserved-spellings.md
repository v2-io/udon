---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: [reserved-list-form, reserve-not-ignore, reserved-is-an-error, reserved-line-starts-in-prose, nested-attributes-reserved, missing-values, references-in]
depends: [rule:prose-line-start-reserved, rule:label-after-empty-label, rule:nested-attributes]
consequences: []
---

# The reserved spellings

*The bare list of what lite refuses, and where.*

## Statement

Each spelling in this table MUST be an error where the table says.

| Reserved | Where |
|---|---|
| `!` followed by a name or `:` (`!if`, `!:sh:`) | at the start of a line, and on an element's or attribute's line |
| `!{` (`!{…}`, `!{{…}}`) | anywhere it would open, prose included |
| `@` followed by a name (`@jw`) | at the start of a prose line, and as a value |
| a `:label` with no value followed by another `:label` | on an element's or attribute's line ([[rule:label-after-empty-label]]) |
| a `:label` line directly under an open attribute value | under an attribute ([[rule:nested-attributes]]) |

## Grounds

- Reserve, don't ignore; a reserved spelling is an error ([[decision:reserve-not-ignore]], [[decision:reserved-is-an-error]]); listed without explanation ([[decision:reserved-list-form]]).
- `@{…}` is not reserved: it is a reference ([[decision:references-in]]).

## Epistemic status

Decided for this version, row by row. The list is not complete.

## Working notes

- Joseph's words (2026-09-30T16:02Z, `.int/STEWARD-VERBATIM.md`):

  > It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future.
- Joseph's words (2026-09-30T02:12Z, `.int/STEWARD-VERBATIM.md`):

  > Let's put reserved ones in their own file and not explain them other than what characters or constructions are reserved.
- Not yet discussed, so not listed: `@[k]`, `@.t`, `@<…>`, and `@name` in the middle of an element's or attribute's line (`.int/reserved.md` had them reserved); spellings floated in the past (pre-design 56); `!word` mid-line in prose.
- Whether a bare `null` is reserved is open ([[rule:nil-spelling]]).
