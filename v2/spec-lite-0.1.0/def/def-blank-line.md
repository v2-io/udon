---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [empty-line, blank-line]
per: []
depends: [rule:blank-line-sets-no-indent]
consequences: [rule:blank-line-sets-no-indent, rule:blank-line-any-whitespace, rule:blank-line-whitespace-in-text]
---

# empty-line · blank-line

*An «empty-line» is a newline with nothing before it on its line; a «blank-line» is an «empty-line» or a line of only whitespace.*

## Terms

- **empty-line:** a newline that is the first character of the «document» or directly follows another newline.
- **blank-line:** an «empty-line», or a line holding only Unicode whitespace. Every «empty-line» is a «blank-line».

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > That reminds me-- if it's not already a rule or planned-- we need to make sure we explicitly denote "blank lines" distinct from (a superset with) "empty lines" -- blank lines do *not* change indent levels. In some cases whitespace on blank lines is considered ornamentation, in some cases it can be part of prose:

  > Your defined terms are my intention yes-- empty would be a newline as the first of the document or any newline directly after an earlier newline. blank can be empty or have (unicode specified) whitespace.
