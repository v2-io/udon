# Semantic equivalence and round-trip

**Status:** normative for equivalence claims; examples non-normative.
Defines when two documents (or two surfaces) **mean the same** at core, so
hosts can normalize without inventing silent language forks.

---

## 1. Layers of sameness

| Layer | Compares | Typical use |
|---|---|---|
| **Byte identity** | exact source | storage, hashing |
| **Recognition identity** | model shape incl. comments (spans optional) | faithful round-trip tooling |
| **Core semantic equivalence** | model after §2 normalization | "same document" for data |
| **Host projection equality** | after dialect resolution + native types | application equality |

This document defines **core semantic equivalence**. Stricter layers are
always allowed; looser ones are host-defined and MUST be named when
claimed.

*(The ornamental double-round-trip fixpoint — strip ornamental → model →
house-style, twice, model and bytes stable — is the demand-side criterion
this layer table feeds; its full definition belongs to the v2 work, not
this consolidation.)*

## 2. Core normalization

Two documents are core-semantically equivalent when their models are equal
after, in order:

1. **Sugar expansion.** All identity/trait/suffix sugar expanded to
   designated assignments; sugar and longhand compare equal
   (`|el[k].a?` ≡ `|el :'$key' k :'$traits' a :'$?' true`).
2. **Nil and boolean spelling.** `null` ≡ `nil`.
3. **Integer base spelling.** Compare by mathematical value: `255` ≡
   `0xFF` ≡ `0b11111111`. **Not round-trip safe by design** — never use §2
   alone as a recognition-identity check. This item applies to **Integers
   only**: Float equality is **not part of core equivalence** (ruled S17 —
   host profile, or omitted). Two Float values compare equal at this layer
   only under a *named* host Float-equality profile, and documents compared
   under different profiles carry **no portable core-equivalence claim**;
   absent a profile, Floats compare by recognized lexical form like any
   other unresolved value. (Decimal-vs-IEEE value, NaN, signed zero, and
   lexical preservation are all profile territory, not core law.)
4. **Stacking vs list — NOT collapsed.** `:x 1 :x 2` ≠ `:x [1 2]`, ever. A
   host "values(x) → [1,2]" view is a projection, not equivalence.
5. **Flow flattening.** Adjacent pure text segments may concatenate; inline
   elements and interpolations remain structural segments. Inline comments
   are absent from *value* equivalence (they contribute no text) while
   still present for recognition identity.
6. **Dedentation already applied.** Source indent differences yielding the
   same stripping produce equal text.
7. **Ornamental blanks.** Edge blanks at pure structure boundaries may be
   dropped; blanks interior to text may not (they are text — the text
   law).
8. **Order is significant** — across keys, within a key's stack, and
   across content. Reordering is never core-equivalent.
9. **References** compare by selector tuple (+ partial flag), never by
   resolved target.
10. **Unresolved envelopes** compare by label ladder + raw body.
11. **`$partial-key` vs `$key`: never equivalent.** Fail-safe naming is
    semantic.

## 3. Round-trip requirements

- A **faithful serializer** SHOULD emit a surface recognizing back to a
  recognition-identical model (comments included), up to: sugar vs
  longhand, integer base spelling, quote style for strings needing no
  workaround, and ornamental blanks.
- A **data serializer** MAY strip comments and ornamental blanks and use §2
  as its success criterion.
- **Forbidden silent changes** — a serializer MUST NOT: collapse stacking
  into lists or vice versa; promote `$partial-key` to `$key`; merge warned
  extensions into a single list value without an explicit host repair mode
  that records anomalies; reorder assignments or content.

## 4. Examples (non-normative)

```udon
; equivalent (sugar)
|user[1].admin?
|user :'$key' 1 :'$traits' admin :'$?' true

; NOT equivalent (stacking vs list)
|el :t a :t b
|el :t [a b]

; NOT equivalent (node vs flow)
|el :x |em hi
|el :x |{em hi}

; equivalent (sameline vs block, same order, no ownership differences)
|el :a 1 :b 2
|el
  :a 1
  :b 2

; NOT necessarily equivalent — phase / ownership differ
|el :a 1 tail
  :b 2
|el :a 1 :b 2
  tail
```

## 5. Relation to the anomaly posture

Keep-everything means the model may contain warning-annotated structure a
strict schema would reject; core equivalence still compares it. A host
"valid document" predicate is schema/document-layer and MUST be stated
separately from equivalence.
