# Schema layer (stub)

**Status:** stub only — not Core. Constraint lives here, never in recognition.  
**Related:** DECISIONS (Core vs Schema split), agent-utility spike (edit/validate path), OPEN S3 uniqueness (may be schema-shaped).

---

## Role

| Layer | Job |
|-------|-----|
| **Core / SPEC** | What the text *is* (ADM) |
| **Schema** | What is *allowed* (cardinality, required keys, vocabularies, app duplicate policy beyond the Core menu) |
| **Dialect** | What non-core values *mean* / type to |

Schema judges an ADM (or resolved model). It MUST NOT redefine recognition.

---

## Menus Core already names

- Duplicate definitions: `error | allow-if-identical | first-wins | last-wins | keep-all` (+ warn) — default **error** (**R14**). Schema MAY tighten, not invent outside menu without a Core amendment.

---

## Demand-shaped (later)

From agent-utility: schema-conforming apply after edit; progressive soft/hard guarantees.  
From paths: uniqueness of multi-key / type-scoped PK may be schema or resolution policy — **do not invent here**.

---

## Day-one

No full schema language. This stub exists so suite prose can point at “Schema” without implying it is Core.
