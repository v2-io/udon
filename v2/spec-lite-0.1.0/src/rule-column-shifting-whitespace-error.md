---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [errors-stop-parsing]
depends: [rule:columns-count-spaces, def:anomaly]
consequences: [rule:whitespace-after-last-marker, rule:blank-line-any-whitespace, rule:columns-count-spaces]
---

# Other whitespace where it could shift a node's column is an error

*A tab, or any Unicode whitespace other than a space or a no-break space, in a line's indentation or before a later marker on the line, is an «error».*

## Statement

A tab, or any Unicode whitespace other than U+0020 and U+00A0, in a line's indentation or anywhere on a line before a later marker whose column it could shift, is an «error».

## Grounds

- Joseph, 2026-10-08 (Discussion below): "any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail"; on `|p Intro⇥text |em x`: "I forgot that $main can have a following node etc.-- I agree, error".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
⇥|a                   ; error: tab in indentation
|a :x 1⇥|b            ; error: b's column is ambiguous
|a :x some⇥value :y 1 ; error: a marker follows on the line
|p Intro⇥text |em x   ; error: |em follows
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/column-shifting-whitespace-is-an-error.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** UDON's nesting is by column. A tab has no agreed width, so a tab in indentation makes a line's column ambiguous. 0.10.0 kept such a line as text with a warning (L4); earlier versions made it an error. Same-line elements also sit at their true columns ([[rule:same-line-element-is-child]]), so whitespace before a later marker on a line matters as well.

**Options considered.**

* Warning, line kept as text (0.10.0, L4).
* A tab counts as a fixed number of columns.
* An error wherever it could shift a node's column (chosen).

**Drivers.**

* Such whitespace "make[s] the true column position ambiguous" (Joseph, under the Quote).

**How firm.** His words: "I think"; then "Tab rule-- right", "I would however suggest" (blank lines), "the right call". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Tab-indented files are not lite.

**Reopen when.**

* Tab-indented authoring turns out to matter for a lite consumer.

**Joseph's words not already quoted on this card.**

> […] and I think should apply to a label with no value, any tab characters found in block mode, […]
>
> — Joseph, 2026-10-08 (same file, earlier message)

> Tab rule-- right.  I would however suggest that "blank-lines" allow tabs and other unicode ws because blank lines don't set indent/dedent levels.
>
> I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.
>
> — Joseph, 2026-10-08 (same file, later message)
## Working notes

- **Joseph's words** (2026-10-08 and 10-09, `.int/STEWARD-VERBATIM.md`):
  > tabs:  I think any tab (or other unicode whitespace other than the normal space) in a spot that changes column positions for nodes is an error/fail.  -- so any on a "sameline" run except as part of the $main text or final attribute's value, would cause a fail, under the premise that such whitespaces make the true column position ambiguous.

  > I think that inner some<tab>value throwing an error is the right call here. Excellent edge case to check.

  > I forgot that $main can have a following node etc.-- I agree, error
- **Reasoning:** the premise is ambiguity of the true column. Anything that could shift a later marker's column is ambiguous; whitespace after the line's last marker shifts nothing.

- A tab in a text block's stripped indentation: open.
- Tabs inside block text past the indentation that places the line shift no node's column, so under the confirmed reading they are content. That is the agent's reading of Joseph's "any tab characters found in block mode"; only a case that genuinely conflicts needs to go back to him (carried from the retired record).
