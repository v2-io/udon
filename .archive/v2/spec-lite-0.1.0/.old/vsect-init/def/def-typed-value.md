---
kind: definition
terms: [typed-value, explicit-typed-value, implicit-typed-value, type-label]
state: [drafted]
per: [explicit-typed-value-in, references-vocabulary]
depends: []
questions: ["07", "66", "72", "89"]
max: decided
---

# typed-value · explicit-typed-value · implicit-typed-value · type-label

A **typed-value** is a value whose kind is fixed by how it is spelled, never by inspecting its content. An **explicit-typed-value** is spelled `<…>`: lite finds where it ends and carries its text, with an optional **type-label**, and attaches no meaning to either. An **implicit-typed-value** is a bare spelling that lite itself assigns a type to, such as a number.

## Terms

- **typed-value:** a value whose kind is fixed by its spelling. *Avoid:* "box", the pre-design files' word before 2026-09-29.
- **explicit-typed-value:** a value spelled `<…>`, carried as text (and possibly a `type-label`), with no meaning attached by lite.
- **implicit-typed-value:** a bare value whose type lite assigns from its spelling.
- **type-label:** the optional part of an `explicit-typed-value` that names what its text is meant to be.

## Invariants

- Lite never interprets the text of an `explicit-typed-value`: dates, times, and durations inside `<…>` stay text in lite.
- Which bare spellings are `implicit-typed-value`s is a closed list; nothing outside it is typed by its content.

## Examples

- `<2026-09-29>` is an `explicit-typed-value` whose text is `2026-09-29`; lite does not know it is a date.
- `42` as an attribute value is an `implicit-typed-value` (an integer), if 72 keeps integers in the bare set.

## Working notes

- **Decided:** `explicit-typed-value-in` and `references-vocabulary` in `../DECISIONS.md`.
- **Open, and deliberately not settled here:**
  - where `<…>` ends (07 Q1) and whether it spans lines (07 Q2);
  - whether the label is split from the body, and when a `:` counts as the label separator (07 Q3);
  - the empty `<>` (07 Q4, 89) and where `<…>` may appear (07 Q5);
  - the exact bare set (72, 66).
- The second invariant is 0.10.0's frozen-bare-set rule (G6), carried forward rather than re-decided for lite. 66 asks whether lite types bare values at all. If lite types none, `implicit-typed-value` becomes an empty term and should be deleted, not kept.
