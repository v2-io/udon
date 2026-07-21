# SEMANTICS — equivalence layers (skeleton)

**Status:** skeleton 2026-07-21. Expand with suite authoring.  
**Normative intent:** when two surfaces or models “mean the same” at Core.

---

## Layers of sameness

| Layer | Compared | Typical use |
|-------|----------|-------------|
| **Byte identity** | Exact source | Storage, hashing |
| **Recognition identity** | Same events + recognition-verdict (+ optional trivia) | Faithful round-trip tooling |
| **Core semantic equivalence** | ADM after Core normalization | “Same document” for data |
| **Host projection equality** | After dialect resolve + native types | Application equality |

Claim the layer by name; do not say “same” unqualified.

---

## Core normalization (sketch — not final)

Must **not** collapse:

- Stacking vs list: `:x 1 :x 2` ≠ `:x [1 2]`
- `$partial-key` vs `$key`
- Node value vs flow with braces

May normalize (when claimed):

- Sugar vs longhand designated attributes
- `null` ≡ `nil`
- Integer base spelling for *semantic* equality (not recognition-identity round-trip)
- Adjacent pure Text segment flattening
- Ornamental blanks per [PIPELINE.md](PIPELINE.md) criterion

Detail: greenfield-3b `SEMANTICS.md` as wording mine; re-author under DECISIONS.

---

## Round-trip

| Serializer | Success criterion |
|------------|-------------------|
| Faithful | Recognition-identical ADM (comments if present), sugar/base/quote tolerances |
| Data | Core semantic equivalence; may strip comments/ornamental |

Forbidden silent changes: stacking↔list, promote `$partial-key`, reorder attributes/content without naming a repair mode.

---

## Open

- Float equality — OPEN S17  
- Full ornamental catalogue — criterion first (PIPELINE), instances later  
