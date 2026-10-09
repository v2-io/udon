---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [no-break-space-counts-as-space]
depends: [rule:columns-count-spaces, def:anomaly]
consequences: []
---

# A no-break space counts as a space, with a warning

*A U+00A0 NO-BREAK SPACE where it sets a column counts as one space, with a «warning».*

## Statement

A U+00A0 NO-BREAK SPACE where it sets a column MUST count as one space, and the parser MUST report a «warning».

## Grounds

- [[decision:no-break-space-counts-as-space]] (Joseph, 2026-10-09): "treat it same as a normal space but with a warning". Its column isn't ambiguous (Unicode gives it a space's width); the warning is because it's invisible and other tools disagree about it.

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
⍽⍽|a
```
(`⍽` = U+00A0.) `a` is indented two columns, with a «warning».

## Working notes

- **Joseph's words** (2026-10-08/09; the first message is not yet in `.int/STEWARD-VERBATIM.md`, copied from the session):
  > It does make me wonder if we need to allow utf non-breaking-space though, since that shouldn't lead to ambiguity (? right? is it by definition supposed to be the same width as a normal space?)

  > 4. Please tell me your reasoning, as there's no ambiguity about column positions with that character in particular.

  > 2. Yes-- treat it same as a normal space but with a warning.
- **Reasoning:** Unicode's note on U+00A0 says it "should be the same width as the space 0020", so its column isn't ambiguous and an error would be the wrong tool. The agent's case for a warning: it's invisible, and other tools disagree about whether it is whitespace (`grep '^  |el'` misses the line; Python's `lstrip()` strips it, `lstrip(' ')` doesn't), so it is correct lite that may not be what was meant.

- A no-break space inside text, values or fence bodies, where it sets no column, is plain content with no warning: the agent's reading, not yet put to Joseph.
