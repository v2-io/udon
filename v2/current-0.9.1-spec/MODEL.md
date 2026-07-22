# The UDON Document Model

**Status:** normative. Defines what recognition produces — the information a
consumer may rely on. Surface syntax is [CORE.md](CORE.md); equivalence is
[SEMANTICS.md](SEMANTICS.md).

A conforming implementation MUST expose a representation from which this
model is recoverable without loss; it MAY use any concrete encoding (tree,
event stream, cursor API) that preserves it. *(This suite deliberately
specifies no event/wire encoding — see README. The adequacy test for any
future one is §6: the text law must be recoverable from it.)*

---

## 1. Document

```
Document = {
  content:   [Node]       ; ordered, top-level
  anomalies: [Anomaly]    ; in source order
  result:    complete | incomplete-input
}
```

- `content` holds every top-level node in source order. There is no
  implicit root element; multiple top-level elements are true siblings.
- `result` is `incomplete-input` iff at least one delimited construct was
  still open at true end of input (CORE §13.3); otherwise `complete`.
  Warnings and errors never affect `result`.
- Equivalent API shapes are allowed if information-equivalent (ruled
  D-pack).

## 2. Nodes

```
Node = Element | Text | Comment | Verbatim | Directive
     | Interpolation | Reference | BlankLine
```

`BlankLine` is a recognition-layer node for blank/whitespace-only lines not
protruding past a content base (CORE §7.4); it contributes `"\n"` to text
reconstruction. Interpretation (interior = newline; edges = ornamentation)
is the consumer's; a consumer MAY keep literal BlankLine nodes for
reversibility.

## 3. Element

```
Element = {
  name:       Name?            ; absent for anonymous elements
  attributes: [Assignment]     ; ordered; all precede content
  content:    [Node]           ; ordered
}
Assignment = { key: Key, value: Value }   ; exactly one value per assignment
```

- `attributes` is an **ordered sequence of assignments, not a map**. Order
  is source order, across keys.
- **Stacking is the model.** Multiple assignments to one key are multiple
  entries — no last-wins, no merging, no implicit list-formation.
  `:x 1 :x 2` is two assignments; `:x [1 2]` is one whose value is a List.
  Implementations MUST preserve the distinction.
- A **warned extension** (CORE §6.7) is a further assignment to the same
  key, in order, with its Warning in `anomalies` — never a nested
  multi-segment value kind.
- A missing value (plain key, no material) is an assignment with value Nil
  plus an Error — the shape never carries less than the source suggested.

### 3.1 Designated attributes (sugar targets)

Sugar desugars **before the model is considered complete**:

| Surface | Assignments |
|---|---|
| `\|el[k]` | `$key` = recognized value of `k` |
| `\|el.a.b` | `$traits` = `a`, then `$traits` = `b` |
| `\|el?` (`!` `*` `+`) | `$?` (`$!` `$*` `$+`) = true |
| unclosed `[` | **`$partial-key`** = captured value (+ Warning) |

An element written `|el[k].a.b?` and one written
`|el :'$key' k :'$traits' a :'$traits' b :'$?' true` are **identical** in
the model; implementations MUST NOT distinguish them. Consumers that
resolve identity or references MUST treat `$partial-key` as non-identity.

### 3.2 Recommended host views (non-normative shape; normative substrate)

- **`all_attributes`** — the assignment sequence exactly as parsed,
  designated entries included. The round-trip view.
- **`key` / `traits` / `attributes`** — the ergonomic split: `key` = the
  value(s) of `$key`; `traits` = the values of `$traits`, **always a list**;
  `attributes` = every non-designated assignment; flags surface from `$?`
  and friends.

Ergonomic views can collapse what the model keeps distinct (`:x 1 :x 2` vs
`:x [1 2]` may both read `[1,2]`); round-trip and provenance-sensitive
tooling MUST work from the substrate.

## 4. Values

```
Value  = Scalar | Reference | Interpolation | NodeValue | FlowValue
Scalar = String | Integer | Float | Boolean | Nil | List | Envelope
List   = [Value]                     ; items: any Value kind except FlowValue
Envelope   = { dialect: String?, type: String?, body: String,
               resolved: DialectResult | Unresolved }
NodeValue  = Element | Verbatim     ; the attribute IS the node — no wrapper
FlowValue  = [Segment]
Segment    = Text | InlineElement | Interpolation
           | InlineDirective | InlineVerbatim
           ; inline comments are recognized but contribute no segment text
Reference  = { name: Name?, key: Value?, traits: [String],
               partial: Boolean }
Interpolation = { expression: String }        ; unparsed by core
Directive  = { name: String, head: String,    ; head-line remainder, unparsed
               content: [Node] }
Verbatim   = { form: block | fence | inline, label: String?,
               body: String }                 ; fence byte-exact; block dedented to raw base
```

- An unresolved Envelope retains its full lexical body (keep-everything);
  the model never holds a half-typed value.
- A Reference with `partial: true` carries the captured-so-far key; the
  fail-safe lives on the selector so resolvers exclude incomplete
  references exactly as `$partial-key` excludes incomplete identity.
- Flow values and element prose share one text model (Segments).

## 5. Comment

```
Comment = { form: line | continued | sameline | inline, body: String }
```

Comments are first-class model items — carried, never interpreted — so
documentation extraction and round-trip of annotated sources remain
possible. Stripping is a view, not the model default.

## 6. Text and the text law

```
Text = String    ; may include newlines; dedentation already applied
```

**The text law (normative invariant).** The document's text material
reconstructs by **pure in-order concatenation** of every Text (and every
flow text segment, after inline comments are dropped, with `BlankLine`
contributing `"\n"`) — no fabricated join characters, no re-consultation of
the source.

Consequences (derived, all normative):

1. Each text line's terminator is part of its Text; indentation stripped by
   dedentation is geometry, not text.
2. A blank line between two text lines of one flow is text (its newline);
   blanks at pure structure boundaries are ornamentation a consumer may
   drop — but never surface as content (CORE §7.4, incl. the
   final-terminator disposition).
3. Inline comments contribute no text; their framing whitespace is ordinary
   text (preserved — ruled S18).
4. A verbatim body is exact bytes; every body line keeps its terminator.
5. Adjacent pure Text segments MAY be flattened; concatenation is
   associative.

Anything a consumer must consult the source to reconstruct is a model hole.
A future wire/event encoding is adequate **only if** this invariant is
recoverable from it.

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

Severity is two-valued and defined by loss (CORE §14.1). Whether
accumulated anomalies justify dropping, halting, or rejecting is consumer
policy — never encoded in the model. *(Warning-code spellings are working
names pending the SPEC-vocabulary + generator-derivation reconciliation —
ruled W4; do not cement them as contract.)*

## 8. What the model deliberately excludes

- **Event/wire ordering and encoding** (deratified flat wire; successor
  direction W0/W1d lives in the v2 ledger, not here).
- **Resolution** — references stay inert selectors; mixins, transclusion,
  and duplicate policy are consumer concerns over a complete model.
- **Dialect projection** — envelopes carry lexical bodies until claimed.
- **Constraint** — nothing in the model is invalid by schema; schemas judge
  the model, they do not shape it.
- **Markdown** — text is opaque; anything inside it is above recognition.
- **Per-byte span maps** — hosts MAY retain spans for tooling.
