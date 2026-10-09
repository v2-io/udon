---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [blank-and-empty-lines]
depends: [def:blank-line]
consequences: [rule:blank-line-any-whitespace, rule:blank-lines-inside-text, rule:text-left-edge]
---

# A blank line never sets or changes indentation

*A «blank-line» never sets or changes indentation or nesting.*

## Statement

A «blank-line» MUST NOT set or change indentation or nesting.

## Grounds

- [[decision:blank-and-empty-lines]] (Joseph, 2026-10-08): "blank lines do *not* change indent levels".

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

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose:

  > Your defined terms are my intention yes-- empty would be a newline as the first of the document or any newline directly after an earlier newline. blank can be empty or have (unicode specified) whitespace.

- Where a «blank-line» at the edge of a text, or between structure, sits in «meta» is open.
