# Semantic equivalence and round-trip — 0.10.1-draft

**Status: PROPOSAL DRAFT.** Carried whole from 0.10.0 SEMANTICS — the layer table, the §2 normalization list (sugar expansion; nil/boolean; integer-base; contributions-as-written; inline-vs-block value form; flow flattening; dedentation; ornamental blanks; order significance; `$main`-vs-block; `$partial-key` never `$key`) — with these deltas only:

1. **References compare by head + cardinality + partial flag** (was: selector tuple + partial). Never by determination results.
2. **A held reference (`@<…>`) and a will-be-determined reference (`@…`) with the same head are NOT equivalent** — stance at the surface is data (the whole point of the held form).
3. **Generators compare as elements** (name + assignments + content), species-marked; the retired unparsed-head comparison is gone with the head (DELTAS 2).
4. **Captures compare by geometry-invariant content where the geometries promise it**: value-vs-block-vs-fence spellings of the same vocab/kind/body are equivalent *except* the fence's byte-exactness — a fence whose body differs from a block form's dedented body only by the dedent is the same capture. ⟨PROPOSED; the strict alternative is spelling-significant.⟩
5. **Annotation is the rename of item "comments" throughout**; recognition identity keeps them, value equivalence ignores them — unchanged.

Round-trip requirements and the forbidden-silent-changes list carry, plus one new forbidden change: **a serializer MUST NOT move an item between held and will-be-determined forms** (per delta 2 they are different documents).
