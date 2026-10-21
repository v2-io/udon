---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:column-shifting-whitespace-error]
consequences: []
---

# After a line's last marker, any whitespace is content

*A tab or other whitespace after the last marker on a line shifts no column, so it is content.*

## Statement

A tab or other Unicode whitespace after the last marker on a line MUST be kept as content.

## Grounds

- [[rule:column-shifting-whitespace-error]]: the confirmed reading, which Joseph answered "right".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
|a :x some⇥value
|a Some⇥title
```
Both are fine: nothing follows the tab on its line.

## Working notes

- **Joseph, 2026-10-21:** trailing whitespace of any kind at the end of a value is ornamentation unless kept with ` \\ ` or quoted (see [[rule:space-before-text-end]]'s note). This card's Statement (a tab after the last marker is content) then holds only for whitespace *inside* a value, not at its end. To reconcile.
- **Joseph's words** (2026-10-08 and 10-09, `.int/STEWARD-VERBATIM.md`):
  > tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.

  > I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.

  > I forgot that $main can have a following node etc.-- I agree, error
- **Reasoning:** the premise is ambiguity of the true column. Anything that could shift a later marker's column is ambiguous; whitespace after the line's last marker shifts nothing.
