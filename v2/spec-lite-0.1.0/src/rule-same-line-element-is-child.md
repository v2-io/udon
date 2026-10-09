---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:columns-count-spaces]
consequences: [rule:lines-follow-same-line-columns, def:node, rule:element-after-waiting-label]
---

# An element later on a line is a child, at its true column

*A bare `|name` written later on an element's line is a child of the element before it on the line, at the column of its `|`.*

## Statement

A bare `|name` written later on an element's line MUST be a child of the element before it on that line, sitting at the column of its `|`.

## Grounds

- Joseph, 2026-10-08 (Discussion below): every explicit statement since 2011 reads it as a child; the value reading would obscure "one of udon's most notable [elegances]".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
|a |b |c
```
```tree
root
  |a
    |b
      |c
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/sameline-element-is-child.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-10-08.*

**Context.** 0.10.0 says both: §2.1 makes `|a |b |c` the same as the vertical form (children), while §6.4/§6.10's "self-announcing values become `$main` values" makes `b` a value. The 01 history found every explicit statement since 2011 saying child, including Joseph's own examples, and the value reading entering 0.10.0 through rewording (`.int/pre-design/01-sameline-element-child-or-value.discussion.md`).

**Options considered.**

* Child at its true column (chosen).
* `$main` value of the element.
* (Raised in history, not pursued) siblings: `|a |b |c` gives `a` two children.

**Drivers.**

* Same-line writing is the vertical form written sideways ("pseudo-line-feeds", "pretend the same-line part has each of its parts on consecutive new lines": Joseph's earlier words, quoted in the 01 history).
* The value reading's uniformity is not real: the next non-blank line's indentation would still need special-casing (Joseph, under the Quote).

**How firm.** His word: "my lean", with a high bar for revisiting ("only if … some crucial advantage"). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Bare and non-bare forms on an element's line land in different places (children vs `$main` values).
* Late-attribute warning in the `|card |title Hello` + block attributes case.

**Reopen when.**

* A crucial advantage of the value reading turns up.

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > Yes, you already know my lean as well. And the value-reading-uniformity gain isn't very uniform because the parser and spec would still need to special case the indent behavior of the next non-blank line underneath. I am open to revisiting it only if it turns out we were missing some crucial advantage that is worth essentially obfuscating one of udon's most notable [elegances].
- **Reasoning (from the 01 history):** every explicit statement since 2011 reads it as a child; the `$main`-value reading entered 0.10.0 through a reworded sentence, not a decision. Under the value reading the aligned table idiom breaks: the two cells land in different places.

- After a label still waiting for its value, an element is that label's value instead (Part IV).
- `|{…}` on the line is a piece of text, not an element here ([[def:text]]).
- A cost the decision names: `|card |title Hello` followed by a block `:id 7` makes `id` an attribute after content, with a warning.
