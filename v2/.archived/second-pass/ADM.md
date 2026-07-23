# Abstract Document Model (ADM) — 0.10 / v2-spec

**Status:** **provisional skeleton** — not full suite prose.  
**Role:** Normative *shape* of what recognition produces: the product  
**assembly** / fixtures may assert (**C5**), and the type language + wire both project against. Surface → [SPEC.md](SPEC.md). Equivalence → [SEMANTICS.md](SEMANTICS.md).  
Wire → [WIRE.md](WIRE.md) (**W0**/**W1d**; encoding OPEN **W1e**).  
**Authority:** [DECISIONS.md](DECISIONS.md). Greenfields are wording mines only.  
Multi-line → [OPEN.md](OPEN.md) **ML**.  
**Terminology:** [GLOSSARY.md](GLOSSARY.md).  
**How to read:** Sections with shapes are load-bearing consensus. **TODO** marks thin spots. No fake completeness.

A conforming implementation MUST expose a representation from which this model is recoverable without loss of model distinctions. It MAY use any concrete encoding (tree, cursor API, event stream under WIRE) that preserves it.

---

## 0. Design goals (skeleton)

1. **Round-trip substrate.** Preserve attribute order, stacking multiplicity, designated attributes, and text-bearing material needed for same-meaning serialize (details → SEMANTICS when drafted).
2. **No parallel identity systems.** Identity, traits, and flag suffixes are ordinary Assignments under designated keys — not separate Element fields.
3. **Edges vs nodes.** Attributes are labeled edges; Elements are nodes. An edge terminates at a Value (leaf, Node value, or Flow).
4. **Prose is content.** Text participates in the same ordered Content sequence as child Elements (not decoration outside the model).
5. **Parser-agnostic product.** ADM is the language product; “AST” is a library encoding of an ADM (or resolved model). Streaming vs one-shot is assembly *scheduling*, not a different meaning model.

---

## 1. Document

**Consensus:** forest at top level — no implicit root Element.

### 1.1 Shape (**D-pack**, **C5**, **C6**)

```
Document := {
  content:   [TopLevelItem]   // ordered
  anomalies: [Anomaly]        // source order
  result:    complete | incomplete-input
}
```

- `result` is `incomplete-input` iff at least one **delimited** extent was still open at true end of input (**R2**); otherwise `complete`.
- Warnings and errors do **not** flip `result` by themselves.
- Incomplete-input is **not** an event (**C6** / **R2**).

**Pinned packaging (**D-pack**):** the preferred shape above is **normative** for the suite. Engines MAY expose equivalent APIs (e.g. separate verdict flag) if information-equivalent to `{ content, anomalies, result }`.

### 1.2 Top-level items

```
TopLevelItem :=
    Element
  | Directive
  | Comment
  | Verbatim
  | Text
  | … blank disposition (see §5)
```

**TODO:** exact TopLevelItem union vs 2a’s `Node` union — align when SPEC lists what is legal at column 0. Root-level `:key` → document Text + Warning (**L1**), not a free-floating Attribute.

---

## 2. Element

```
Element := {
  name:       String | absent     // absent ⇒ Anonymous Element
  attributes: [Assignment]        // ordered; all precede content in model
  content:    [ContentItem]       // ordered
}
```

### 2.1 Name

- **Absent** name ⇒ Anonymous Element. Core assigns no special meaning to namelessness; Hosts MAY treat trait-only anonymous Elements as mixins (non-core; **S13** Host experiment).

### 2.2 Assignment (AttributeAssignment)

```
Assignment := {
  key:   String    // includes terminal "?" for flag keys
  value: Value     // exactly one Value per assignment
}
```

- `attributes` is an **ordered sequence**, not a map. Order is source order across keys.
- **Stacking is the model.** Multiple Assignments to one key are multiple entries. No last-wins, no merge, no implicit list-formation at this layer.
  - `:x 1 :x 2` → two Assignments  
  - `:x [1 2]` → one Assignment whose value is a List  
  Implementations MUST preserve the distinction (CARRY attr-model; **R6**).
- Missing value (plain key, no value material) → Assignment with value **Nil** plus an Error in `anomalies` — shape never carries less than the source suggested (**R6**).
- **Warned extension** (material after a finished value) → further Assignment under the same key, in order, with Warning in `anomalies`.

### 2.3 Designated attributes (sugar targets)

Sugar desugars into ordinary Assignments before the model is considered complete:

| Sugar (illustrative) | Assignments |
|----------------------|-------------|
| `\|el[k]` | `key="$key"`, value = recognized `k` |
| `\|el.a.b` | two `$traits` Assignments, values `a` then `b` |
| `\|el?` (and `!` `*` `+`) | `key="$?"` (etc.), value = boolean true |

**Unclosed identity (**R5**):** if `[` identity never receives `]`, use key **`$partial-key`** (not `$key`) + Warning. Consumers that resolve identity or References MUST treat `$partial-key` as non-identity.

Designated, not reserved: any `$…` key may be written longhand.

### 2.4 Recommended Host views (non-normative convenience)

| View | Derivation |
|------|------------|
| `all_attributes` | Full ordered `attributes`, designated included (round-trip substrate) |
| `key` | Value(s) of `$key` |
| `traits` | Values of `$traits`, **always presented as a list** |
| `attributes` | Assignments whose keys are not designated sugar targets |

`traits`-always-a-list is the one normalization beyond a straight read. Ergonomic views can collapse stacking vs list — provenance-sensitive tools MUST use the substrate.

### 2.5 ContentItem

```
ContentItem :=
    Text
  | Element
  | Reference
  | Directive
  | Comment
  | Verbatim
  | Interpolation    // when it appears as a content segment
```

**Content phase (3b; load-bearing for surface):** once any non-Attribute ContentItem is accepted for an Element, that Element is in content phase — further Attributes for that Element are not opened at ancestor Attribute columns (late `:` → Text + Warning on the surface). **TODO:** full statement in SPEC; listed here so ADM consumers know phase is a recognition product concern, not a second model.

---

## 3. Value

```
Value :=
    Scalar
  | Reference
  | Interpolation
  | NodeValue
  | FlowValue
```

**Multiplicity has one channel:** stacking and warned extension are always further **Assignments** under the same key — never a nested multi-segment Value kind.

### 3.1 Scalar

```
Scalar :=
    String
  | Integer
  | Float
  | Boolean
  | Nil
  | List
  | Envelope
```

**Frozen bare recognition (**R21**, **L5**):** String (quoted or bare fallback),  
Integer, Float, Boolean (`true`/`false` lowercase — surface detail SPEC), Nil (`null`/`nil`), List. **Not** bare: rational, complex → dialect/envelope when specified.

### 3.2 List

```
List := [Value]   // items: full value rules; no FlowValue inside (**R17**)
```

Empty brackets: empty closed identity/brackets → nil key; `[ ]` → empty array (**R16**).

### 3.3 Envelope

```
Envelope := {
  label:   …      // TODO: pin Label Ladder (unlabelled / type / dialect:type) if kept from 3b
  body:    String // raw interior; newlines allowed
  // resolved: Host/dialect concern — Core keeps unresolved body (**keep-everything**)
}
```

Empty `<>` interim: BareValue + NoDialectsLoaded (**R13**) — exact anomaly coding **TODO** with warning registry (**W4**).

### 3.4 NodeValue

```
NodeValue := Element | Verbatim   // incl. Fence form of Verbatim
```

The Attribute *is* that node; no anonymous wrapper Element. Block `\|name` binds node value (**R4**).

### 3.5 FlowValue

```
FlowValue := [FlowSegment]

FlowSegment :=
    Text
  | InlineElement      // Element that originated as |{…}
  | Interpolation
  | InlineDirective
  | InlineVerbatim
  // InlineComment recognized but contributes no Text (see text law)
```

Flow values and Element prose share one text model.

### 3.6 Reference

```
Reference := {
  name:    String | absent
  key:     Value | absent     // from […] when closed
  traits:  [String]           // ordered
  // partial: TODO align with R5 — either selector.partial (3b) or
  //          consumer discipline only; do not invent a third scheme
}
```

Core does not resolve. Host resolution is a **menu** (illustrative: leave-inert default | transclude | merge-attributes — **TODO** pin menu in SPEC; OPEN **S14** lean keep tuple until paths force growth).

### 3.7 Interpolation / Directive / Verbatim / Comment

```
Interpolation := { expression: String }   // unparsed by Core

Directive := {
  name: String
  raw:  Boolean          // true for Verbatim-form openers
  body: …                // Document-shaped content or opaque string if raw
}

Verbatim := {
  form:  block | fence | inline
  label: String | absent
  body:  String          // fence: byte-exact; block: dedented to raw base
}

Comment := {
  form:  line | block-continued | sameline-framed | inline-brace
  body:  String
}
```

Comments are first-class so extraction and annotated round-trip remain possible. Stripping for a “data-only” view is a Host view, not the ADM default.

Empty `\|{}` → valid empty anonymous embedded (**R19**). Framed ` ; ` inside `\|{…}` out for now (**R20**).

---

## 4. Anomaly

```
Anomaly := {
  severity:  warning | error
  location:  source position        // of the anomaly
  opened_at: source position | absent  // unclosed: where construct opened
  message:   String
  code:      … | absent             // stable ids: OPEN W4 (derive / registry / both)
}
```

- **Warning** = content kept; may not match intent.
- **Error** = something lost (2a pure loss axis). Whether illegal geometry without byte-loss is **Warning** (**L0**, **L4**).
- Halt / drop / reject after anomalies is **Consumer menu**, never encoded in the model (**R11**).

Recognition continues through anomalies unless the Consumer stops.

---

## 5. Text and the text law

```
Text := String
// may include newlines; prose dedentation already applied relative to Content Base
```

Markdown (or other markup) inside Text is **not** modeled by Core; characters only. Companion stub OPEN **S16**.

### 5.1 The text law (normative invariant — **R1**)

**Document text reconstructs by pure in-order concatenation of every text-bearing model unit (Text nodes and Flow text segments after inline comments are dropped), with no fabricated join characters and no re-consultation of the source.**

`BlankLine` on the wire (when WIRE defines it) ≡ `"\n"` as a text-bearing unit (**R1**). Do not invent further event vocabulary here.

Consequences (derived; surface rules live in SPEC):

1. Each prose line’s line terminator is part of Text; indentation stripped by dedentation is **geometry**, not Text.
2. A blank line **between two text lines of the same flow** is Text (newline). Ornamental blanks at pure structure boundaries MAY be dropped by a normalizing Document layer (SEMANTICS when drafted; pipeline ornamental criterion). Implementations MAY retain ornamental blanks as round-trip trivia but MUST NOT invent content Text for them.
3. Inline comments contribute no Text; surrounding whitespace is ordinary Text unless a Host normalizes later (**S18**: preserve framing spaces for now).
4. Verbatim bodies are exact bytes (each body line keeps its terminator).
5. Adjacent pure Text segments MAY be flattened; concatenation is associative.

**Blank/ws two-layer (**R15**):** non-protruding blank/ws → blank/text channel; past content-base → prose. Detail SPEC; **S9** defers BlankLine vs dedent placement.

A future wire encoding is adequate only if this invariant is recoverable from it (**W0** lean: sufficiency / no-reachback as WIRE law).

---

## 6. What the model deliberately excludes

| Excluded | Where it lives instead |
|----------|------------------------|
| Surface syntax, scan, guards, multi-line per-construct policy | SPEC; multi-line **OPEN ML** |
| Event / wire ordering and names | WIRE (**W0**–**W5**); old flat Attr wire **deratified** (**R8**) |
| Source column maps for every byte | Host tooling MAY retain spans |
| Reference resolution, mixins, transclusion | Host / Document layer menus |
| Duplicate-definition policy | Document-layer menu (**R14**); default **error** |
| Dialect projection / native Host types | Host after Dialect claims Envelope |
| Schema validity | Schema judges the model; does not shape it |
| Markdown structure | Layer companion (**S16**); Text stays opaque |
| Ornamental serialization policy as Core law | SEMANTICS / utils (`fmt`); not ADM shape |
| Incomplete-input as a stream event | **C6**; document `result` / flag only |

---

## 7. Recognition product (summary)

```
RecognitionResult := {
  document:  Document           // or content + flags per §1 packaging
  // anomalies already on Document in preferred packaging
}
```

Unclosed delimited constructs: keep content, emit Warning, set `incomplete-input` when still open at true EOF (**R2**). Geometric constructs close silently at EOF. Emission order for unclosed surfaces (**R12**): content → Unclosed\* → End — *names provisional until WIRE*.

---

## 8. Skeleton TODOs (authoring queue)

1. Pin Document packaging (`result` field vs triple) with fixture surface (**C5**, **C6**).
2. Pin ContentItem / TopLevelItem unions against SPEC root rules (**L1**).
3. Envelope label ladder + unresolved anomaly coding.
4. Reference `partial` vs element `$partial-key` only (**R5**, **S14**).
5. Severity axis after **L0** panel (loss-only vs loss∪illegal-geometry).
6. SEMANTICS: equivalence ladder, ornamental blanks, stacking≠list restatement.
7. WIRE: sufficiency law (**W0**), self-delimiting attr values (**W1**), vocab.

---

## Pointers

- Vocabulary: [GLOSSARY.md](GLOSSARY.md)  
- Ledger: [DECISIONS.md](DECISIONS.md) · Opens: [OPEN.md](OPEN.md)  
- Front door: [README.md](README.md)  
- Wording mines: `../spec/msc/greenfield-2a/new-spec/ADM.md`, `../spec/msc/greenfield-3b/new-spec/MODEL.md`
