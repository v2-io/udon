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

## Discussion

- **"By spelling, never by value-sniffing" is used here as common ground, not as a decided principle.** It is 0.10.0's G6, not yet re-decided for lite. No alternative in 66 or 72 types by content, so the definition holds whichever is chosen. If lite ever adopted content-based typing, these terms would need restating, not just the principle.


## Working notes

- **For Joseph:** the seeded `explicit-typed-value-in` says lite "carries its text and optional type label". Did that mean as two separate things (07 Q3)?
- **`per:` cites seeded decisions that are not ADRs yet** (`.old/vsect-init/DECISIONS.md`), so those entries dangle until the udon team converts them.
- **Open questions** bearing on these terms: 66, 72, 07, 89.
