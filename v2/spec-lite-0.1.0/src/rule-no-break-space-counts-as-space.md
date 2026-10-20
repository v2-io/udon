---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:columns-count-spaces, def:anomaly, rule:warnings-can-be-toggled]
consequences: []
---

# A no-break space counts as a space, with a default-off warning

*A U+00A0 NO-BREAK SPACE where it sets a column counts as one space; the parser has a «warning» for it, off unless turned on.*

## Statement

A U+00A0 NO-BREAK SPACE where it sets a column MUST count as one space. The parser MUST have a «warning» for it, which is off by default ([[rule:warnings-can-be-toggled]]).

## Grounds

- Joseph, 2026-10-09 (Discussion below): "treat it same as a normal space but with a warning". Its column isn't ambiguous (Unicode gives it a space's width); the warning is because it's invisible and other tools disagree about it.

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
⍽⍽|a
```
(`⍽` = U+00A0.) `a` is indented two columns, with a «warning».

## Discussion

*Carried 2026-10-09 from the decision record `adr/no-break-space-counts-as-space.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** [[rule:column-shifting-whitespace-error]] made any Unicode whitespace other than the ordinary space an error where it could shift an element's or attribute's column; that covered the no-break space. Joseph asked for the reasoning behind keeping it an error, noting "there's no ambiguity about column positions with that character in particular." The coordinator revised its lean to one column plus a warning, and he agreed. This replaces that record's rule for U+00A0 only; every other non-space whitespace stays an error there.

**Options considered.**

* An error, as for other non-space whitespace (the coordinator's first lean).
* A normal space, silently.
* A normal space with a warning (chosen).

**Drivers.**

* No column ambiguity: Unicode says U+00A0 "should be the same width as the space 0020", and its East Asian width is Neutral (the coordinator's reasoning; Joseph's own point that there is no ambiguity about its column).
* Still worth a warning: it is invisible, and other tools disagree about whether it is whitespace. (**inferred, unconfirmed** as Joseph's driver: the coordinator's reasoning, which he answered "Yes".)

**How firm.** His words: "Yes-- treat it same as a normal space but with a warning." His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* A no-break space where a column is set goes through with only a warning.

**Reopen when.**

* Tools or authors are surprised by the column a no-break space gives.

## Working notes

- **Joseph's words** (2026-10-08/09; the first message is not yet in `.int/STEWARD-VERBATIM.md`, copied from the session):
  > It does make me wonder if we need to allow utf non-breaking-space though, since that shouldn't lead to ambiguity (? right? is it by definition supposed to be the same width as a normal space?)

  > 4. Please tell me your reasoning, as there's no ambiguity about column positions with that character in particular.

  > 2. Yes-- treat it same as a normal space but with a warning.
- **Reasoning:** Unicode's note on U+00A0 says it "should be the same width as the space 0020", so its column isn't ambiguous and an error would be the wrong tool. The agent's case for a warning: it's invisible, and other tools disagree about whether it is whitespace (`grep '^  |el'` misses the line; Python's `lstrip()` strips it, `lstrip(' ')` doesn't), so it is correct lite that may not be what was meant.

- A no-break space inside text, values or fence bodies, where it sets no column, is plain content with no warning: the agent's reading, not yet put to Joseph.
- **Joseph, 2026-10-20:** "I'm considering allowing non-breakings spaces if they aren't already as equivalent to spaces." They already are, with a warning (this card); open whether the warning stays.
- **Default-off, Joseph 2026-10-20:** "warning on non-breaking space -- let's distinguish between default-on and default-off warnings and specify that the parser should allow them to be toggled. This would be a default-off (our first, AFAIK)". The 2026-10-09 Discussion above says "with a warning"; the warning stays, now off unless a user turns it on.
