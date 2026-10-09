---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [sameline-element-is-child]
depends: [rule:columns-count-spaces]
consequences: [rule:lines-follow-same-line-columns]
---

# An element later on a line is a child, at its true column

*A bare `|name` written later on an element's line is a child of the element before it on the line, at the column of its `|`.*

## Statement

A bare `|name` written later on an element's line MUST be a child of the element before it on that line, sitting at the column of its `|`.

## Grounds

- [[decision:sameline-element-is-child]] (Joseph, 2026-10-08): every explicit statement since 2011 reads it as a child; the value reading would obscure "one of udon's most notable [elegances]".

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

## Working notes

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > Yes, you already know my lean as well. And the value-reading-uniformity gain isn't very uniform because the parser and spec would still need to special case the indent behavior of the next non-blank line underneath. I am open to revisiting it only if it turns out we were missing some crucial advantage that is worth essentially obfuscating one of udon's most notable [elegances].
- **Reasoning (from the 01 history):** every explicit statement since 2011 reads it as a child; the `$main`-value reading entered 0.10.0 through a reworded sentence, not a decision. Under the value reading the aligned table idiom breaks: the two cells land in different places.

- After a label still waiting for its value, an element is that label's value instead (Part IV).
- `|{…}` on the line is a piece of text, not an element here ([[def:text]]).
- A cost the decision names: `|card |title Hello` followed by a block `:id 7` makes `id` an attribute after content, with a warning.
