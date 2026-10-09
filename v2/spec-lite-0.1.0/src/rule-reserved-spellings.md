---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: [reserve-not-ignore, reserved-is-an-error]
depends: [rule:prose-line-start-reserved, rule:label-after-empty-label, rule:nested-attributes, rule:nil-spelling, rule:missing-value, rule:opaque-span-raw-text]
consequences: [obj:reserve-dont-ignore]
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
| a `:label` line owned by an attribute | in an attribute's body ([[rule:nested-attributes]]) |
| `@` followed by a name, `@[`, `@.` or `@<` (`@jw`, `@[k]`, `@.t`, `@<…>`) | on an element's or attribute's line |
| a bare `null` where `nil` would be read | as a value ([[rule:nil-spelling]]) |

## Grounds

- Reserve, don't ignore; a reserved spelling is an error ([[decision:reserve-not-ignore]], [[decision:reserved-is-an-error]]); listed without explanation.
- `@{…}` is not reserved: it is a reference ([[rule:opaque-span-raw-text]]).

## Epistemic status

Decided for this version, row by row. The list is not complete.

## Discussion

*Carried 2026-10-09 from the decision record `adr/reserved-list-form.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-09-29.*

**Context.** Lite refuses future syntax ([[decision:reserve-not-ignore]]). Writing that down raises a question of form: does lite's spec explain what each reserved spelling will mean in full UDON, or only say what is reserved?

**Options considered.**

* Explain each reserved form.
* List them on their own, saying only which characters or constructions are reserved (chosen).

**Drivers.**

* None recorded beyond the Quote.

**How firm.** His own call, so `steward`.

**Costs accepted.**

* A reader who meets a refusal learns that a spelling is reserved, not why.

**Reopen when.**

* Readers of lite need to know what a reserved form is for, to avoid it sensibly.

## Working notes

- Joseph's words (2026-09-30T16:02Z, `.int/STEWARD-VERBATIM.md`):

  > It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future.
- Joseph's words (2026-09-30T02:12Z, `.int/STEWARD-VERBATIM.md`):

  > Let's put reserved ones in their own file and not explain them other than what characters or constructions are reserved.
- Joseph, 2026-10-09, confirming the `@` forms on element and attribute lines (as in 0.10.0 and `.int/reserved.md`): "correct".
- `@name` and `!word` in the middle of a prose line are text ([[rule:prose-passes-through]]); `!{` stays reserved there.
- Not yet discussed: spellings floated in the past (pre-design 56).
