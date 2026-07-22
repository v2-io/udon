# Abstract Document Model (ADM)

**Status:** normative.  
This document defines what a UDON document *is* after recognition: the information a Consumer may rely on. Surface syntax is specified in [CORE.md](CORE.md). Semantic equivalence (when two surfaces share one model shape) is in [SEMANTICS.md](SEMANTICS.md).

---

## 1. Design goals

1. **Round-trip substrate.** The model preserves enough structure that a serializer can regenerate a document with the same meaning (see SEMANTICS), including attribute order, stacking multiplicity, and designated attributes.
2. **No parallel identity systems.** Identity, traits, and flag suffixes are ordinary attributes under designated names — not separate fields.
3. **Edges vs nodes.** Attributes are labeled edges; Elements are nodes. An edge may terminate at a leaf Value, a Node Value, or an ordered list of Values.
4. **Prose is content, not decoration.** Text participates in the same ordered Content sequence as child Elements.

---

## 2. Document

```
Document =
  ordered list of TopLevelItem

TopLevelItem =
  Element
  | Directive
  | Comment
  | Verbatim
  | Text
  | Blank  ; significant as Text newline(s) when inside Element Content;
           ; ornamental blanks at pure structure boundaries MAY be dropped
           ; by a normalizing Document layer (see SEMANTICS)
```

A Document has no implicit root Element. Multiple top-level Elements are siblings.

---

## 3. Element

```
Element =
  name:        Name | absent
  attributes:  ordered list of AttributeAssignment
  content:     ordered list of ContentItem
```

### 3.1 Name

- A **Name** is a string (Unicode identifier or quoted form as on the surface).
- **Absent** name ⇒ Anonymous Element. Namelessness has no Core meaning; Hosts MAY interpret trait-only anonymous Elements as mixins (non-core).

### 3.2 AttributeAssignment

```
AttributeAssignment =
  key:    Key          ; string; includes terminal "?" for flag keys
  value:  Value        ; exactly one Value per assignment
```

**Stacking:** multiple `AttributeAssignment`s with the same `key` on one Element form an ordered multiset of values under that key. The model does **not** collapse them into one List Value.

```
:x 1 :x 2     →  two assignments (1 then 2)
:x [1 2]      →  one assignment whose value is List[1, 2]
```

These are **distinct** model shapes. Hosts MAY offer flattened views; round-trip tools MUST use the full ordered assignment list ([GLOSSARY](GLOSSARY.md) *Designated Attribute*, *Stacking*).

### 3.3 Designated attributes (sugar targets)

Sugar desugars into ordinary assignments before the model is considered complete:

| Sugar | Assignments |
|-------|-------------|
| `\|el[k]` | `key="$key"`, value = recognized value of `k` |
| `\|el.a.b` | two assignments `key="$traits"`, values `a` then `b` |
| `\|el?` | `key="$?"`, value = boolean true (similarly `$!` `$*` `$+`) |

**Fail-safe for unclosed identity brackets:** if a `[` identity (or Reference selector key) never receives `]`, the assignment uses key **`$partial-key`** instead of `$key`, and a Warning is recorded. Consumers that resolve identity or References MUST treat `$partial-key` as non-identity.

**Recommended Host views** (non-normative convenience, not alternate models):

| View | Derivation |
|------|------------|
| `all_attributes` | Full ordered `attributes` list, including designated |
| `key` | Value(s) of `$key` |
| `traits` | Values of `$traits`, always presented as a list |
| `attributes` | Assignments whose keys are not designated sugar targets |

### 3.4 ContentItem

```
ContentItem =
  Text
  | Element
  | Reference
  | Directive
  | Comment
  | Verbatim
  | Interpolation   ; when it appears as a content segment
```

**Phase:** once any non-Attribute ContentItem has been accepted for an Element, that Element is in **Content Phase**. Further Attributes for that Element are not opened at ancestor Attribute columns (surface late `:` becomes Text with a Warning — see CORE).

---

## 4. Value

```
Value =
  Scalar
  | Reference
  | Interpolation
  | NodeValue
  | FlowValue
```

**Multiplicity has one channel.** Stacking and warned extension (material after a finished value on an attribute-rooted line, or a deeper second value under a finished key) are always **further `AttributeAssignment`s** under the same key, in source order — never a nested multi-segment Value kind. Round-trip tools emit repeated `:key` (or equivalent longhand), not a collapsed list.

### 4.1 Scalar

```
Scalar =
  String
  | Integer
  | Float
  | Boolean
  | Nil
  | List
  | Envelope
```

**Frozen Core Scalars** (bare recognition): String (quoted or bare fallback), Integer, Float, Boolean (`true`/`false` lowercase), Nil (`null`/`nil`), List.

**[GREENFIELD]** Rational and Complex are **not** Frozen Core Scalars in this suite; they belong to a future `standard-types` Dialect via Envelope. See [DECISIONS.md](DECISIONS.md).

### 4.2 List

```
List = ordered list of Value   ; items: any Value Kind except FlowValue
```

### 4.3 Envelope

```
Envelope =
  label:     optional TypeLabel and/or DialectLabel  ; Label Ladder
  body:      string (raw interior; newlines allowed)
  resolved:  DialectResult | Unresolved
```

If no Dialect claims an unlabelled envelope, recognition records an Error or Warning per CORE and retains the envelope text (Keep-Everything).

### 4.4 NodeValue

```
NodeValue = Element | Verbatim
```

The Attribute *is* that node; there is no anonymous wrapper Element.

### 4.5 FlowValue

```
FlowValue = ordered list of FlowSegment

FlowSegment =
  Text
  | InlineElement    ; Element that originated as \|{…}
  | Interpolation
  | InlineDirective
  | InlineVerbatim
  ; InlineComment is recognized but contributes no segment text
```

Flow Values and Element prose share one text model.

### 4.6 Reference

```
Reference =
  name:    Name | absent
  key:     Value | absent     ; from […] when closed
  traits:  ordered list of string
  partial: boolean            ; true if the selector key bracket never closed
```

When `partial` is true, `key` holds the captured-so-far value (if any). This is **not** modeled as a `$partial-key` attribute on a phantom element — the fail-safe lives on the selector so resolvers exclude incomplete references the same way `$partial-key` excludes incomplete element identity (CORE §5 / §12).

Core does not resolve References. Host resolution modes (menu): `transclude` | `merge-attributes` | `leave-inert` (default inert at Core).

### 4.7 Interpolation / Directive / Verbatim

```
Interpolation = { expression: string }   ; unparsed by Core

Directive =
  name: string
  raw:  boolean          ; true for !:label: / !{:kind:…} Verbatim forms
  body: Document-shaped content or opaque string if raw

Verbatim =
  form:  block | fence | inline
  label: optional string
  body:  opaque string   ; fence: byte-exact; block: dedented to raw base
```

---

## 5. Comment

```
Comment =
  form: line | block-continued | sameline-framed | inline-brace
  body: string
```

Comments are first-class model items so documentation extraction and round-trip of annotated sources remain possible. A Consumer MAY strip them for a “data-only” view; that is a view, not the ADM default.

---

## 6. Text and the text law

```
Text = string   ; may include newlines; prose dedentation already applied
                ; relative to Content Base when produced from block prose
```

Markdown constructs inside Text are **not** modeled by Core; they remain characters. See [layers/markdown.md](layers/markdown.md).

### 6.1 The text law (normative invariant)

**Document text reconstructs by pure in-order concatenation of every `Text` node (and every Flow text segment after inline comments are dropped), with no fabricated join characters and no re-consultation of the source.**

Consequences (stated elsewhere as rules; derived here):

1. Each prose line’s line terminator is part of Text; indentation stripped by dedentation is geometry, not Text (CORE §7).
2. A blank line between two text lines of the same flow is Text (a newline); ornamental blanks at pure structure boundaries MAY be dropped by a normalizing Document layer (SEMANTICS §2.7).
3. Inline comments contribute no Text; surrounding whitespace is ordinary Text unless a Host normalizes later.
4. Verbatim bodies are exact bytes (each body line keeps its terminator).
5. Adjacent pure Text segments MAY be flattened; concatenation is associative.

A future wire/event encoding is adequate only if this invariant is recoverable from it.

---

## 7. Anomaly records

```
Anomaly =
  severity: Warning | Error
  code:     implementation-defined stable id (optional at Core)
  message:  human-readable
  span:     source location (open site for unclosed constructs)
```

Recognition yields `(Document, list of Anomaly, IncompleteInputFlag)`.

---

## 8. What the model deliberately excludes

- Source column maps for every byte (a Host MAY retain spans for tooling).
- Event/wire ordering.
- Schema validity.
- Resolved native Host types (Date objects, etc.) — projection is Host-side; Envelope retains validated string + type tag when a Dialect claims it.
