---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:column-shifting-whitespace-error]
consequences: [rule:no-break-space-counts-as-space, rule:column-shifting-whitespace-error, rule:same-line-element-is-child]
---

# Columns are counted in spaces

*Indentation, and the column of anything later on a line, are counted in U+0020 SPACE characters.*

## Statement

Indentation, and the column of anything later on a line, MUST be counted in U+0020 SPACE characters.

## Grounds

- [[rule:column-shifting-whitespace-error]] (Joseph, 2026-10-08): other whitespace "make[s] the true column position ambiguous".

## Epistemic status

Chosen. No fixture yet.

## Working notes

- **Joseph's words** (2026-10-08 and 10-09, `.int/STEWARD-VERBATIM.md`):
  > tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.

  > I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.

  > I forgot that $main can have a following node etc.-- I agree, error
- **Reasoning:** the premise is ambiguity of the true column. Anything that could shift a later marker's column is ambiguous; whitespace after the line's last marker shifts nothing.

- What a column counts after non-ASCII characters on a line (characters, bytes or display width) is open (79 Q4).
- No indentation unit is specified; whether to name one for tools is open.
