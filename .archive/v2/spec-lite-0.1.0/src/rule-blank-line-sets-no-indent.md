---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [def:blank-line]
consequences: [rule:blank-line-any-whitespace, rule:blank-lines-inside-text, rule:text-left-edge, def:blank-line, rule:blank-line-whitespace-in-text]
---

# A blank line never sets or changes indentation

*A «blank-line» never sets or changes indentation or nesting.*

## Statement

A «blank-line» MUST NOT set or change indentation or nesting.

## Grounds

- Joseph, 2026-10-08 (Discussion below): "blank lines do *not* change indent levels".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
|a
  |b

  |c
```
```tree
root
  |a
    |b
    |c
```
The blank line closes nothing: `c` is still `a`'s child.

## Discussion

*Carried 2026-10-09 from the decision record `adr/blank-and-empty-lines.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** Raised by Joseph unprompted while deciding fence bodies, "because it's a little bit subtle". 0.10.0 §7.4 already had the behavior; the terms were not defined.

**Options considered.**

* Only one option was on the table.

**Drivers.**

* The difference matters in text and in fence bodies, where whitespace on a blank line can be content.

**How firm.** His words: "we need to make sure we explicitly denote", "Your defined terms are my intention yes", and "I would however suggest" (tabs on blank lines). His own call, so `steward`.

**Joseph's words not already quoted on this card.**

> I would however suggest that "blank-lines" allow tabs and other unicode ws because blank lines don't set indent/dedent levels.
>
> — Joseph, 2026-10-08 (same file, later)
## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose:

  > Your defined terms are my intention yes-- empty would be a newline as the first of the document or any newline directly after an earlier newline. blank can be empty or have (unicode specified) whitespace.

- Where a «blank-line» at the edge of a text, or between structure, sits in «meta» is open.
- Open (carried from the retired record): which Unicode whitespace counts for a «blank-line» is not named (probably `White_Space`, to confirm); and a tab on a blank line inside text, past the left edge: content like spaces there, and how "past the left edge" is measured for a tab.
