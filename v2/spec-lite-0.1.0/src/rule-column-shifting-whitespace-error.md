---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [column-shifting-whitespace-is-an-error, errors-stop-parsing]
depends: [rule:columns-count-spaces, def:anomaly]
consequences: [rule:whitespace-after-last-marker, rule:blank-line-any-whitespace]
---

# Other whitespace where it could shift a node's column is an error

*A tab, or any Unicode whitespace other than a space or a no-break space, in a line's indentation or before a later marker on the line, is an «error».*

## Statement

A tab, or any Unicode whitespace other than U+0020 and U+00A0, in a line's indentation or anywhere on a line before a later marker whose column it could shift, is an «error».

## Grounds

- [[decision:column-shifting-whitespace-is-an-error]] (Joseph, 2026-10-08): "any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail"; on `|p Intro⇥text |em x`: "I forgot that $main can have a following node etc.-- I agree, error".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
⇥|a                   ; error: tab in indentation
|a :x 1⇥|b            ; error: b's column is ambiguous
|a :x some⇥value :y 1 ; error: a marker follows on the line
|p Intro⇥text |em x   ; error: |em follows
```

## Working notes

- **Joseph's words** (2026-10-08 and 10-09, `.int/STEWARD-VERBATIM.md`):
  > tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.

  > I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.

  > I forgot that $main can have a following node etc.-- I agree, error
- **Reasoning:** the premise is ambiguity of the true column. Anything that could shift a later marker's column is ambiguous; whitespace after the line's last marker shifts nothing.

- A tab in a text block's stripped indentation: open.
