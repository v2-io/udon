# The UDON Document Model (ADM)

**Status:** normative. This is the **ADM** — the Abstract Document Model of `defining-udon.md` §5, the DECISIONS charter (C3/C5), and the prior drafts; "Document Model" and "ADM" name the same pillar. Defines what recognition produces — the information a consumer may rely on. Surface syntax is [CORE.md](CORE.md); equivalence is [SEMANTICS.md](SEMANTICS.md). *(0.10.0-alpha.1 — the value-space unification; terminology per GLOSSARY: an assignment has a **label**; "key" is identity only.)*

A conforming implementation MUST expose a representation from which this model is recoverable without loss; it MAY use any concrete encoding (tree, event stream, cursor API) that preserves it. *(This suite deliberately specifies no event/wire encoding — see README. The adequacy test for any future one is §6: the text law must be recoverable from it.)*

---

## 1. Document

```
Document = {
  content:   [Node]       ; ordered, top-level
  anomalies: [Anomaly]    ; in source order
  result:    complete | incomplete-input
}
```

- `content` holds every top-level node in source order. There is no implicit root element; multiple top-level elements are true siblings.
- `result` is `incomplete-input` iff at least one delimited construct was still open at true end of input (CORE §13.3); otherwise `complete`. Warnings and errors never affect `result`.
- Equivalent API shapes are allowed if information-equivalent (ruled D-pack).

## 2. Nodes

```
Node = Element | Text | Comment | Verbatim | Directive
     | Reference | BlankLine
```

Interpolations are deliberately **not** a top-level Node kind: a line-initial `!{{…}}` fails the `!` block guard (identifier or `:` required) and is flow text whose sole segment is the interpolation — interpolations surface only as flow **Segments** (§4) and as whole values / identity keys.

`BlankLine` is a recognition-layer node for blank/whitespace-only lines not protruding past a content base (CORE §7.4); it contributes `"\n"` to text reconstruction. Interpretation (interior = newline; edges = ornamentation) is the consumer's; a consumer MAY keep literal BlankLine nodes for reversibility.

## 3. Element and Assignment

```
Element    = {
  name:        Name?           ; absent for anonymous elements
  assignments: [Assignment]    ; ordered; source order (late ones warned — CORE §6.9)
  content:     [Node]          ; ordered
}
Assignment = { label: Label, content: [Item] }   ; ordered, heterogeneous (ruled K5)
Item       = Value | Node | Comment              ; §4; a comment in a deferred body is kept
```

- `assignments` is an **ordered sequence, not a map**. Order is source order, across labels. Late assignments (after the element's block content began) are legal-with-Warning (K14); position relative to content is recoverable from source order for round-trip tooling that needs it (host spans — §8).
- **Stacking is the model.** Multiple assignments to one label are multiple entries — no last-wins, no merging, no implicit list-formation, no warning (K11). `:x 1 :x 2` is two assignments; `:x [1 2]` is one whose sole item is a List. Implementations MUST preserve the distinction.
- **The common case is a one-item content.** An assignment whose content is a single Value is the ordinary attribute; a deferred body yields heterogeneous items (CORE §6.5). Sugar-produced assignments always have exactly one item and are born finished (K8).
- A missing value (label with no material) is an assignment with content `[Nil]` plus an Error — the shape never carries less than the source suggested, and empty content `[]` never legitimately exists (ruled K6).

### 3.1 Designated attributes (sugar targets)

Sugar desugars **before the model is considered complete**:

| Surface | Assignments |
|---|---|
| `\|el[k]` | `$key` = recognized value of `k` (each bracket one assignment — K1) |
| `\|el.a.b` | `$traits` = `a`, then `$traits` = `b` |
| `\|el?` (`!` `*` `+`) | `$?` (`$!` `$*` `$+`) = true |
| `\|el some text` | `$main` = the sameline material, value by value (stacked — K9) |
| unclosed `[` | **`$partial-key`** = captured value (+ Warning) |

An element written `|el[k].a.b? Title` and one written `|el :$key k :$traits a :$traits b :$? true :$main Title` are **identical** in the model; implementations MUST NOT distinguish them. (`$key` keeps its spelling — it *is* the identity key, held by an assignment whose **label** is `$key`.) Consumers that resolve identity or references MUST treat `$partial-key` as non-identity.

### 3.2 Recommended host views (non-normative shape; normative substrate)

- **`all_assignments`** — the assignment sequence exactly as parsed, designated entries included. The round-trip view.
- **`key` / `traits` / `attributes`** — the ergonomic split: `key` = the value(s) of `$key`; `traits` = the values of `$traits`, **always a list**; `attributes` = every non-designated assignment.
- **`main` / `first_is_main`-style knobs** — `$main` presentation is a host parameter: expose as an attribute, or re-inject as the first content slot ("it's an attribute on the wire, and depends on the parser parameters to decide how you want it in the AST"). Round-trip and provenance-sensitive tooling MUST work from the substrate.

Ergonomic views can collapse what the model keeps distinct (`:x 1 :x 2` vs `:x [1 2]` may both read `[1,2]`); the substrate keeps them apart.

## 4. Values

```
Value  = Scalar | Reference | Interpolation | InlineElement
       | InlineVerbatim | NodeValue | TextValue
Scalar = String | Integer | Float | Boolean | Nil | List | Envelope
List   = [Value]                     ; items: any Value kind except TextValue
Envelope   = { dialect: String?, type: String?, body: String,
               resolved: DialectResult | Unresolved }
NodeValue  = Element | Verbatim | Directive   ; the value IS the node — no wrapper
                                              ; (Directive carried unresolved — K3)
TextValue  = [Segment]               ; flow: text runs + inline segments
Segment    = Text | InlineElement | Interpolation
           | InlineDirective | InlineVerbatim
           ; inline comments are recognized but contribute no segment text
Reference  = { name: Name?, key: Value?, traits: [String],
               partial: Boolean }
Interpolation = { expression: String }        ; unparsed by core
Directive  = { name: String, head: String,    ; head-line remainder, unparsed
               content: [Node] }
Verbatim   = { form: block | fence | inline, kind: String?,
               body: String }                 ; fence byte-exact; block dedented to raw base
```

- `InlineElement` / `InlineVerbatim` appear both as **values** (at a clean value position — CORE §6.4, ruled K9) and as **segments** inside a TextValue (mid-flow). The two placements are distinct in the model exactly as far as the surface distinguishes them.
- An unresolved Envelope retains its full lexical body (keep-everything); the model never holds a half-typed value.
- A Reference with `partial: true` carries the captured-so-far key; the fail-safe lives on the selector so resolvers exclude incomplete references exactly as `$partial-key` excludes incomplete identity.
- Text values and element block text share one flow model (Segments).

## 5. Comment

```
Comment = { form: line | continued | sameline | inline, body: String }
```

Comments are first-class model items — carried, never interpreted — so documentation extraction and round-trip of annotated sources remain possible. Stripping is a view, not the model default. A comment inside a deferred assignment body is an Item of that assignment (CORE §6.5).

## 6. Text and the text law

```
Text = String    ; may include newlines; dedentation already applied
```

**The text law (normative invariant).** The document's text material reconstructs by **pure in-order concatenation** of every Text (and every flow text segment of block text, after inline comments are dropped, with `BlankLine` contributing `"\n"`) — no fabricated join characters, no re-consultation of the source.

**Scope (ruled K9):** assignments are not text material — including `$main`. Sameline text lives in the model as `$main` assignments, and presenting it as document text (stitching, ordering against content) is a **host view** over the substrate, not part of the law. This is deliberate: it is what lets the model distinguish sameline text from block text structurally rather than via span metadata.

Consequences (derived, all normative):

1. Each block-text line's terminator is part of its Text; indentation stripped by dedentation is geometry, not text.
2. A blank line between two text lines of one flow is text (its newline); blanks at pure structure boundaries are ornamentation a consumer may drop — but never surface as content (CORE §7.4, incl. the final-terminator disposition).
3. Inline comments contribute no text; their framing whitespace is ordinary text (preserved — ruled S18).
4. A verbatim body is exact bytes; every body line keeps its terminator.
5. Adjacent pure Text segments MAY be flattened; concatenation is associative.

Anything a consumer must consult the source to reconstruct is a model hole. A future wire/event encoding is adequate **only if** this invariant is recoverable from it.

## 7. Anomalies

```
Anomaly = {
  severity:  warning | error
  location:  source position
  opened_at: source position?    ; for unclosed constructs: the opener
  message:   String
  code:      String?             ; stable id — spellings not yet contract
}
```

Severity is two-valued and defined by loss (CORE §14.1); the sole core Error is the missing required value. Whether accumulated anomalies justify dropping, halting, or rejecting is consumer policy — never encoded in the model. *(Warning-code spellings are working names pending the SPEC-vocabulary + generator-derivation reconciliation — ruled W4; do not cement them as contract.)*

## 8. What the model deliberately excludes

- **Event/wire ordering and encoding** (deratified flat wire; successor direction W0/W1d lives in the v2 ledger, not here).
- **Resolution** — references stay inert selectors; mixins, transclusion, and duplicate policy are consumer concerns over a complete model.
- **Dialect projection** — envelopes carry lexical bodies until claimed.
- **Constraint** — nothing in the model is invalid by schema; schemas judge the model, they do not shape it.
- **Markdown** — text is opaque; anything inside it is above recognition.
- **Per-byte span maps** — hosts MAY retain spans for tooling (assignment-vs-content interleaving order for faithful serializers rides here).
