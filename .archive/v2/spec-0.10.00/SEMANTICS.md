# Semantic equivalence and round-trip

**Status:** normative for equivalence claims; examples non-normative.  
Defines when two documents (or two surfaces) **mean the same** at core, so hosts can normalize without inventing silent language forks. *(0.10.0-alpha.1 — terminology per GLOSSARY: assignments have labels; "key" is identity only.)*

---

## 1. Layers of sameness

| Layer | Compares | Typical use |
|---|---|---|
| **Byte identity** | exact source | storage, hashing |
| **Recognition identity** | model shape incl. comments (spans optional) | faithful round-trip tooling |
| **Core semantic equivalence** | model after §2 normalization | "same document" for data |
| **Host projection equality** | after dialect resolution + native types | application equality |

This document defines **core semantic equivalence**. Stricter layers are always allowed; looser ones are host-defined and MUST be named when claimed.

*(The ornamental double-round-trip fixpoint — strip ornamental → model → house-style, twice, model and bytes stable — is the demand-side criterion this layer table feeds; its full definition belongs to the v2 work, not this suite.)*

## 2. Core normalization

Two documents are core-semantically equivalent when their models are equal after, in order:

1. **Sugar expansion.** All identity/trait/suffix/`$main` sugar expanded to designated assignments; sugar and longhand compare equal (`|el[k].a? Title` ≡ `|el :$key k :$traits a :$? true :$main Title`). Quoted and unquoted spellings of the same label compare equal (`:$key` ≡ `:'$key'`).
2. **Nil and boolean spelling.** `null` ≡ `nil`.
3. **Integer base spelling.** Compare by mathematical value: `255` ≡ `0xFF` ≡ `0b11111111`. **Not round-trip safe by design** — never use §2 alone as a recognition-identity check. This item applies to **Integers only**: Float equality is **not part of core equivalence** (host profile, or omitted). Two Float values compare equal at this layer only under a *named* host Float-equality profile, and documents compared under different profiles carry **no portable core-equivalence claim**; absent a profile, Floats compare by recognized lexical form like any other unresolved value.
4. **Contributions compare as written — nothing collapses or flattens.** Each occurrence of a label is one contribution; a bracketed list is one contribution that is a sequence; documents compare by their contributions in order. So `:x 1 :x 2` (two contributions) ≠ `:x [1 2]` (one) in the model — the grouping an author writes is data. The **default read** may coincide across spellings (`:attr |{a} |{b}` and `:attr [|{a} |{b}]` both read `[a b]` — until a further contribution stacks and the grouping distinguishes them); read-coincidence is a view fact, never model equivalence. The spelling difference itself is **ornamentation** (CORE §6.7) — assemblers may annotate flavor; faithful serializers preserve it.
5. **Inline-vs-block value form at a value-expected position.** `:x |em hi` ≡ `:x |{em hi}` — both bind the element as the value. Mid-flow, an inline form is a segment and no such equivalence applies.
6. **Flow flattening.** Adjacent pure text segments may concatenate; inline elements and interpolations remain structural segments. Inline comments are absent from *value* equivalence (they contribute no text) while still present for recognition identity.
7. **Dedentation already applied.** Source indent differences yielding the same stripping produce equal text.
8. **Ornamental blanks.** Edge blanks at pure structure boundaries may be dropped; blanks interior to text may not (they are text — the text law).
9. **Order is significant** — across labels, within a label's stack and content, and across element content. Reordering is never core-equivalent. Assignment-vs-content interleaving (late attributes, K14) is source order and significant at recognition identity; whether it is significant at *core equivalence* is flagged in working-notes (lean: not significant — the Warning already marks it).
10. **`$main` vs block text: not equivalent.** Sameline text and next-line text are different documents by design — `|el title` ≠ `|el` ⏎ indented `title`.
11. **References** compare by selector tuple (+ partial flag), never by resolved target.
12. **Unresolved envelopes** compare by ladder + raw body.
13. **`$partial-key` vs `$key`: never equivalent.** Fail-safe naming is semantic.

## 3. Round-trip requirements

- A **faithful serializer** SHOULD emit a surface recognizing back to a recognition-identical model (comments included), up to: sugar vs longhand, integer base spelling, quote style for strings needing no workaround, and ornamental blanks.
- A **data serializer** MAY strip comments and ornamental blanks and use §2 as its success criterion.
- **Forbidden silent changes** — a serializer or formatter MUST NOT: collapse stacking into lists or vice versa; promote `$partial-key` to `$key`; **move text between the sameline (`$main`) and block positions** (reflowing a sameline value into a body, or joining a body line onto the element line, is a semantic edit); reorder assignments or content; convert an accepted late attribute into text or vice versa.

## 4. Examples (non-normative)

```udon
; equivalent (sugar)
|user[1].admin? Joined 2025.
|user :$key 1 :$traits admin :$? true :$main "Joined 2025."

; NOT equivalent (stacking vs list)
|el :t a :t b
|el :t [a b]

; equivalent (inline vs block form at a value position)
|el :x |em hi
|el :x |{em hi}

; NOT equivalent ($main vs block text)
|el some title text
|el
  some title text

; equivalent (sameline vs block attributes, same order)
|el :a 1 :b 2
|el
  :a 1
  :b 2
```

## 5. Relation to the anomaly posture

Keep-everything means the model may contain warning-annotated structure a strict schema would reject; core equivalence still compares it (a late attribute compares as the attribute it is). A host "valid document" predicate is schema/document-layer and MUST be stated separately from equivalence.
