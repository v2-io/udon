# Semantic equivalence and round-trip

**Status:** normative for equivalence claims; examples non-normative.  
Defines when two Documents (or two surfaces) **mean the same** at Core, so
Hosts can normalize without inventing silent language forks.

---

## 1. Layers of sameness

| Layer | What is compared | Typical use |
|-------|------------------|-------------|
| **Byte identity** | Exact source | Storage, hashing |
| **Recognition identity** | ADM shape including Comments, spans optional | Faithful round-trip tooling |
| **Core semantic equivalence** | ADM after Core normalization (§2) | “Same document” for data |
| **Host projection equality** | After Dialect resolution + native types | Application equality |

This document defines **Core semantic equivalence**. Stricter layers are always
allowed; looser layers are Host-defined and MUST be named when claimed.

---

## 2. Core normalization (canonical ADM)

Two Documents are **Core-semantically equivalent** when their ADMs are equal
after the following normalizations (applied in order):

### 2.1 Sugar expansion

All Identity, Classification, and Flag Suffix sugar is expanded to Designated
Attribute assignments. Surfaces that already use longhand Designated Attributes
compare equal to their sugar forms.

```udon
|el[k].a?     ≡    |el :'$key' k :'$traits' a :'$?' true
```

### 2.2 Nil and boolean spelling

- `null` ≡ `nil` (same Nil value).
- Boolean and Nil only when alone at boundary (already model-level).

### 2.3 Integer base spelling

Integer values compare by mathematical value and signedness, not base spelling:
`255` ≡ `0xFF` ≡ `0b11111111` for Core semantic equivalence.

**Not normalized:** Float decimal spelling that would change IEEE-adjacent
representation concerns — compare by the recognized literal string if Hosts
need bit-exact floats; Core semantic equivalence treats `1.0` and `1.00` as
equal Float values when both recognized as Float.

### 2.4 List vs stacking — NOT collapsed

These remain **distinct**:

```udon
:x 1 :x 2      ≠    :x [1 2]
```

A Host “values(x) → [1,2]” view is a projection, not Core equivalence.

### 2.5 Flow Value text flattening

Adjacent pure Text segments in a Flow Value MAY be concatenated. Inline
Elements and Interpolations remain structural segments.

Inline comments `;{…}` are removed for Core semantic equivalence of *values*
(they are still present for recognition-identity round-trip if Comments are
kept in Content).

### 2.6 Prose dedentation already applied

Text in the ADM is post-dedentation. Source indent differences that yield the
same Content Base stripping produce equal Text.

### 2.7 Ornamental blank lines

Blank lines that appear **only** between structural siblings and carry no
author-visible prose MAY be dropped by Core normalization. Blank lines that
are part of Element Text content MUST be kept.

### 2.8 Attribute order

Order of **different** Keys is significant (round-trip and semantics for
ordered consumers). Order of Stacking under one Key is significant.
Reordering assignments across Keys is **not** Core-equivalent.

### 2.9 Content order

Order of ContentItems is significant.

### 2.10 References

References compare by Selector tuple, not by resolved target. Resolution is
Host-layer.

### 2.11 Unresolved Envelopes

Envelopes compare by label ladder + raw body string when unresolved. After a
Dialect resolves them, Host projection equality MAY differ from Core
equivalence.

### 2.12 `$partial-key` vs `$key`

Never equivalent. Fail-safe naming is semantic.

---

## 3. Round-trip requirements

### 3.1 Recognition → serialize → recognize

A **faithful serializer** SHOULD emit a surface that recognition maps to an ADM
**recognition-identical** to the input ADM (Comments included if present), up
to:

- sugar vs longhand Designated Attributes (§2.1)
- integer base spelling (§2.3)
- quote style (`"` vs `'`) for strings that need no escapes
- ornamental blanks (§2.7)

### 3.2 Minimum data round-trip

A **data serializer** MAY strip Comments and ornamental blanks and use Core
semantic equivalence (§2) as the success criterion.

### 3.3 Forbidden silent changes

Serializers MUST NOT:

- Collapse stacking into Lists or vice versa
- Promote `$partial-key` to `$key`
- Drop multi-segment Values without an explicit Host “repair” mode that records
  Anomalies
- Reorder Attributes or Content

---

## 4. Equivalence examples (non-normative)

```udon
; equivalent (sugar)
|user[1].admin?
|user :'$key' 1 :'$traits' admin :'$?' true

; equivalent (nil spelling)
|el :a null
|el :a nil

; NOT equivalent (stacking vs list)
|el :t a :t b
|el :t [a b]

; NOT equivalent (node vs flow)
|el :x |em hi
|el :x |{em hi}

; equivalent (sameline vs block attrs, same order)
|el :a 1 :b 2
|el
  :a 1
  :b 2
```

Sameline vs block Attribute placement is Core-equivalent when assignment order
and values match and no ownership/phase differences arise.

```udon
; NOT necessarily equivalent — phase / ownership
|el :a 1 tail
  :b 2
; vs
|el :a 1 :b 2
  tail
```

---

## 5. Relation to anomaly posture

Keep-Everything implies the ADM may contain Warning-annotated structure that a
strict Schema would reject. Core semantic equivalence still compares that
structure. A Host “valid document” predicate is Schema/Document-layer and MUST
be stated separately from Core equivalence.
