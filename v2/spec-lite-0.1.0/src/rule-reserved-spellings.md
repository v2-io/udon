---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: [reserve-not-ignore, reserved-is-an-error]
depends: [rule:prose-line-start-reserved, rule:attribute-after-attribute-with-no-value, rule:nested-attributes, rule:nil-spelling, rule:missing-value, rule:opaque-span-raw-text]
consequences: [obj:reserve-dont-ignore]
---

# The reserved spellings

*The bare list of what lite refuses, and where.*

## Statement

Each spelling in this table MUST be an error where the table says.

| Reserved | Where |
|---|---|
| `!` followed by a name, `:`, `[`, `.` or `<` (`!if`, `!:sh:`, `![img](src)`) | at the start of any line, prose included, and on an element's or attribute's line |
| `!{` (`!{…}`, `!{{…}}`) | anywhere it would open, prose included |
| `@` followed by a name, `[`, `.` or `<` (`@jw`, `@[k]`, `@.t`, `@<…>`) | at the start of any line, prose included, and as a value |
| an attribute with no value followed by another attribute | on an element's or attribute's line ([[rule:attribute-after-attribute-with-no-value]]) |
| an attribute line owned by an attribute | in an attribute's body ([[rule:nested-attributes]]) |
| `@` followed by a name, `@[`, `@.` or `@<` (`@jw`, `@[k]`, `@.t`, `@<…>`) | on an element's or attribute's line |

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
- **Joseph, 2026-10-21**, confirming the de novo audit's reading of the PEG against this table: "The card's do need to be updated to reflect the ![img](src) and @[k] errors that are now standard errors as they should have been (as reserved constructs)." So the `!` and `@` rows cover every form (name, `:`, `[`, `.`, `<`) wherever a start is recognized, a Markdown image at a line start included; the bare `null` row left this table the same day ([[rule:nil-spelling]]: text with a warning).
- Not yet discussed: spellings floated in the past (pre-design 56).
