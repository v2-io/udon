# The UDON Abstract Document Model (ADM)

**Normative.** This document defines the data shape that parsing a UDON document produces. The syntax specification (SPEC.md) says which inputs mean what; *this* document says what "what" is. A conforming implementation MUST expose a representation from which the model below is recoverable without loss; it MAY use any concrete encoding (tree, event stream, cursor API) that preserves it.

Terminology is per GLOSSARY.md. Requirement words (MUST, SHOULD, MAY) are per RFC 2119.

---

## 1. Document

A **Document** is:

```
Document := {
  content:   [Node]        // ordered, top-level
  anomalies: [Anomaly]     // in source order
  result:    complete | incomplete-input
}
```

- `content` holds every top-level node in source order.
- `anomalies` is the flat collection of warnings and errors (SPEC §11); each carries severity, source location, and the location of the *opening* of the construct it concerns where applicable.
- `result` is `incomplete-input` iff at least one delimited extent was still open at true end of input (SPEC §11.4); otherwise `complete`. Warnings and errors do not affect `result`.

## 2. Nodes

```
Node := Element | Text | Comment | Verbatim | Directive
      | Interpolation | Reference
```

**Element:**

```
Element := {
  name:       String?          // absent for anonymous elements
  attributes: [Assignment]     // ordered; all precede content
  content:    [Node]           // ordered children: nodes and flow segments
}
```

There are no identity, trait, or flag fields. `[key]`, `.trait`, and flag suffixes exist only in the surface syntax; in the model they are ordinary assignments to designated attributes (`$key`, `$traits`, `$?`, `$!`, `$*`, `$+`; `$partial-key` for an unclosed identity). An element written `|el[k].a.b?` and one written `|el :'$key' k :'$traits' a :'$traits' b :'$?' true` are **identical** in the model. Implementations MUST NOT distinguish them.

**Comment** carries its text (content is inert — never interpreted, always carried). **Verbatim** carries `form` (`block` | `fence` | `inline`), an optional `label`, and its exact body. **Directive** carries its name, its unparsed head-line remainder, and UDON-parsed content. **Interpolation** carries its unparsed expression text. **Reference** carries the selector `(name?, key?, traits)`.

## 3. Attributes

```
Assignment := { key: String, value: Value }
```

- `attributes` is an **ordered sequence of assignments**, not a map. Order is source order, across keys.
- **Stacking is the model.** Multiple assignments to one key are multiple entries. There is no last-wins, no merging, no implicit list-formation at this layer. `:x 1 :x 2` is two assignments; `:x [1 2]` is one assignment whose value is a list. Implementations MUST preserve the distinction.
- A **warned extension** (SPEC §5.7) appears as an additional assignment to the same key, in order, with its warning in `anomalies`.
- A missing value (plain key, no value material) appears as an assignment with value Nil plus an error in `anomalies` — the shape never carries less than the source suggested.

```
Value := Scalar | List | Envelope | Reference | Interpolation
       | Node | Flow
Scalar := String | Integer | Float | Boolean | Nil
List   := [Value]                  // items typed independently
Envelope := { label: String?, dialect: String?, body: String }
           // untyped until a dialect claims it (SPEC §10.4)
Node   := Element | Verbatim      // the node-value forms
Flow   := [Segment]
```

## 4. Text and flow

```
Segment := Text | InlineElement | Interpolation | InlineDirective
         | InlineVerbatim | Comment
Text := String   // literal character data, terminators included
```

**The text law.** The document's text material reconstructs by **pure in-order concatenation of Text** across the model — no joining characters are fabricated, no source re-consultation is needed, and nothing else carries text. Consequences, all normative:

1. Every text line carries its own line terminator as part of its Text. Indentation removed by dedentation (SPEC §6.2) is geometry, not text.
2. A blank line **between two text lines of the same flow** is text: it contributes its newline. A blank line not adjacent to text on both sides within one flow is **ornamental** — structure-level whitespace that contributes nothing to any Text. Implementations MAY retain ornamental blank lines as round-trip trivia but MUST NOT surface them as content.
3. Inline comments contribute no Text (the flow around them concatenates as if the comment, but not its surrounding whitespace, were absent).
4. A verbatim body is its exact bytes; each body line keeps its terminator.
5. Flow resolves to text once each segment's layer processes it (comments stripped, interpolations evaluated, inline elements rendered); an implementation MAY flatten adjacent Text segments, since concatenation is associative.

## 5. Views (recommended, non-normative shape; normative substrate)

The substrate is `attributes` as defined above, designated attributes included. Hosts SHOULD offer:

- **`all_attributes`** — the assignment sequence exactly as parsed, in order, `$`-designated entries included. The round-trip view.
- **`key` / `traits` / `attributes`** — the ergonomic split: `key` = the value(s) of `$key`; `traits` = the values of `$traits`, **always a list** (`[]`, `["a"]`, `["a","b"]`); `attributes` = every non-designated assignment. Flag suffixes surface from `$?` and friends.

`traits`-always-a-list is the one normalization beyond a straight read. **Round-trip caution:** ergonomic views can collapse what the model keeps distinct (`:x 1 :x 2` vs `:x [1 2]` may both read `[1, 2]`); provenance- sensitive tooling MUST work from the substrate, not a flattened view.

## 6. Anomalies

```
Anomaly := {
  severity: warning | error
  location: source position of the anomaly
  opened_at: source position?   // for unclosed extents: where it opened
  message:  String
}
```

Severity is exactly two-valued and defined by loss: **warning** = everything kept; **error** = something lost (SPEC §11.2). Whether accumulated anomalies justify dropping, halting, or rejecting is a consumer policy (menu vs. knob), never encoded in the model.

## 7. What the model deliberately excludes

- **Resolution.** References are inert selectors; mixin inheritance, transclusion, and duplicate-definition policy are consumer concerns over a complete model (SPEC §9).
- **Dialect projection.** An Envelope is carried as its lexical body until a dialect claims it; the model never holds a half-typed value.
- **Constraint.** Nothing in the model is invalid by schema; schemas judge the model, they do not shape it.
- **Markdown.** Text is opaque; any Markdown inside it is above the parse.
