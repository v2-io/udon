---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [typed-value, explicit-typed-value, implicit-typed-value, type-label]
per: [explicit-typed-value-in, references-vocabulary]
depends: []
---

# typed-value · explicit-typed-value · implicit-typed-value · type-label

*A «typed-value» gets its type from its spelling alone. Spelled `<…>`, it is an «explicit-typed-value», whose text lite carries without attaching meaning. Spelled any other way, it is an «implicit-typed-value».*

## Terms

- **typed-value:** a value that is not a node, and whose type is given by its spelling alone, never by value-sniffing (guessing a type from what the text looks like). Every «typed-value» is either an «explicit-typed-value» or an «implicit-typed-value».
  - *Avoid:* "box", the pre-design files' word for an «explicit-typed-value» before 2026-09-29.
- **explicit-typed-value:** a value spelled `<…>`. Lite finds where it ends and carries its text, and attaches no meaning to the text or to any «type-label» in it.
- **implicit-typed-value:** a «typed-value» not spelled `<…>`, such as an unquoted word, a quoted string, or a list. Lite reads its type from its spelling.
  - *Avoid:* "bare value". The sources use it for two different sets: every value outside `<…>` (0.10's "bare set" includes strings and lists), and unquoted values only.
- **type-label:** the part of an «explicit-typed-value»'s text that its author writes to name what the rest is meant to be, as `u64` in `<u64:0xff>`.
  - *Avoid:* "label" alone, which UDON uses for an attribute's name.

## Invariants

- Lite attaches no meaning to an «explicit-typed-value». Its text stays text, including text that looks like a date, a time, or a duration.
- No «typed-value» is typed by what its text looks like. `2026-09-29` unquoted is not a date in lite, and `<2026-09-29>` is not one either.

## Examples

- In `:when <2026-09-29>`, the value is an «explicit-typed-value» whose text is `2026-09-29`. Lite does not know it is a date.
- In `:size <u64:0xff>`, the author wrote `u64` as a «type-label». Lite attaches no meaning to it or to `0xff`.
- In `:name web :port "8080"`, both values are «implicit-typed-value»s, and both are strings.

## Why

- **"By spelling, never by value-sniffing" is used here as common ground, not as a decided principle.** It is also proposed as [[prin:syntactic-typing]] (0.10.0 G6, not yet re-decided for lite). No alternative in 66 or 72 types by content, so the definition holds whichever is chosen. If lite ever adopted content-based typing, these terms would need restating, not just the principle.

## Cautions

- **K9 drew the line between node values and «typed-value»s differently.** It listed `!{{…}}` beside `"…"`, `<…>`, `[…]` and numbers as "self-announcing values", and gave the model an "InlineElement value kind" (`v2/DECISIONS.md`). Here a value that is a node, such as an inline element or an element given as an attribute's value (question 64), is not a «typed-value».
- **A «type-label» is not resolved or evaluated in lite.** The addressing theory's [[references/def:generator]] names "interpretation-under-a-named-vocabulary, as with typed literals" as an open candidate, which "may instead reduce to a reference into a vocabulary's scope". A «type-label» is where such a reading would attach in full UDON's dialects. Lite needs no answer, because it does neither with anything in `<…>`.

## Working notes

- **Open questions that bear on these terms** (numbers are files in `.int/pre-design/`):
  - **66 and 72: which unquoted spellings get a type other than string.** Under every alternative in both files, typing is by spelling. What differs is the set: 0.10.0's full set, a smaller set, or no types at all, so that every unquoted word is a string. 72's option C also refuses some edge spellings (`0x1F`, `1_000`, `02134`) as reserved rather than typing them. `:port 8080` holds an «implicit-typed-value» under all of them. Whether it is the integer 8080 or the string `"8080"` is the open part.
  - **07 Q3: does lite's tree carry a «type-label» apart from the rest of the text?** Under option A, lite carries only the raw text, and the «type-label» exists only in the author's intent. Under B, lite splits it off. B also needs a rule for when a `:` separates a label (`<10:30:00>`, `<http://x.io>`). Until that rule exists, «type-label» is defined only where the author's intent is plain, as with `u64`. 07's label ladder (`<dialect:type:content>`) would also give a label several parts. Whether «type-label» then names the whole prefix or one part is open with Q3.
  - **07 Q1, Q2, Q5, and 89: where `<…>` ends, whether it spans lines, where it may appear, and what the empty `<>` is.** They settle which spellings are «explicit-typed-value»s. They don't change what the term means.
- **The seeded decision may say something 07 Q3 leaves open.** `explicit-typed-value-in`, as rendered, says lite "carries its text and optional type label". That can be read as carrying the label separately (07 Q3-B) or as carrying raw text that may contain one (Q3-A). This record doesn't pick. The rendering is a coordinator's, so the question goes back to Joseph: "when you said lite carries its text and optional type label, did you mean as two separate things?"
- **The reading of "bare" is an unconfirmed inference.** `references-vocabulary`, as rendered, names the terms: "the lite term for an `<…>` or bare value is `typed value` (explicit / implicit)". This record reads "bare" as 0.10's bare set: every value outside `<…>`, including quoted strings and lists (66, 72). Under that reading, explicit and implicit cover every «typed-value» between them. If "bare" meant only unquoted values, quoted strings and lists would be values that are neither, and «typed-value» would need a third species or a narrower definition.
- **"value" and "node" are undelimited until [[def:attribute]] defines "value"** and draws the node-value line in the first caution explicitly.
- **Known work for [[prop:forward-stability]]:** carry the claim that lite's set of typed spellings has to be fixed now. If a later full UDON gave a type to an unquoted spelling that lite reads as a string, a lite «tree» would change under the full parser, breaking [[obj:reserve-dont-ignore]] (72, "Why lite must decide"). It is a derived claim, not part of these terms.
- **Awaiting the udon team's decider** (`awaiting-decision: true`, [[sop/decision:decider-per-store]]): the two questions back to Joseph above bear directly on these terms. The flag describes only this record ([[sop/decision:flags-describe-own-record]]).
- **`per:` cites decisions that are not ADRs yet.** `explicit-typed-value-in` and `references-vocabulary` are seeded decisions, rendered in `.old/vsect-init/DECISIONS.md`. Converting them is the udon team's. Until then both entries dangle. That this record rests on them is derived from `per:`, not carried in its flags.
