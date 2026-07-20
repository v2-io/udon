# UDON Specification (The Semantic Domain)

**Universal Document & Object Notation**
*Version 0.9.0-alpha.2 (Draft)*

This document defines the **semantics** of a valid UDON document, establishing what the constructs mean independently of how they are parsed. For the formal lexical grammar and parser mechanics, see [1-GRAMMAR.md](1-GRAMMAR.md).

---

## 1. The Abstract Document Model (ADM)

An UDON document conceptually resolves into an **Abstract Document Model (ADM)**. A conformant host MUST project the parsed source into this model.

The ADM is an ordered tree where every node is an **Element**. The document itself is implicitly a root Element holding the top-level definitions.

### 1.1 Element Structure

Every Element in the ADM consists of exactly three things:
1. **Name** (Optional string): What the element is. 
2. **Attributes** (Ordered list of Key-Value assignments): Labeled metadata describing what properties belong to the element.
3. **Children** (Ordered sequence): The content of the element, which may be a mix of other Elements and Prose Content (text).

There are no separate, intrinsic fields for "identity" or "traits" in the core model. They are syntactic sugar that desugars into specially-designated attributes.

### 1.2 The Core vs. Host Boundary

UDON's core semantics deliberately leave three domains to the consuming host environment:
- **Projection:** How the host turns a validated string into a native application value (e.g., turning `"2025-01-01"` into a `Date` object).
- **Constraint (Schema):** What is *allowed* or *required* (e.g., "this element MUST have a `$key`"). The core specifies what a document *is*, while a Schema specifies what a document *must look like*.
- **Exotic Typing (Dialects):** What non-core value patterns mean. Core UDON recognizes the syntax of the `<...>` envelope, but a **Dialect** interprets the contents.

---

## 2. Attributes and Values

Attributes are labeled edges belonging to an Element. 

### 2.1 Stacking and Multi-Segment Values

When the same attribute key is assigned multiple times on a single Element, the values MUST **stack**. Stacking means the attribute's value is an ordered list of assignments, preserved in source order.

Furthermore, if text material arrives after a block attribute's value has finished, it MUST be ingested as a further segment of that key's value array, and the parser MUST emit a Warning. This ensures no data is dropped while alerting the user to an unintended multi-segment value. 

### 2.2 Plain Attributes vs. Flag Keys

Attribute keys that terminate with a `?` character are **Flag Keys** (e.g., `:ready?`).

- A Flag Key provided with no explicit value MUST evaluate to the boolean `true`.
- **Flag Rule:** If `:key?` is followed by anything other than `true`, `false`, `null`, or `nil`, the flag evaluates to `true`, and the following material is re-owned by the continuing scan (it is never the flag's body).
- A Plain Key (e.g., `:count`) provided with no explicit value is a semantic anomaly. The parser MUST assign it a `nil` value and emit an Error (non-halting).

### 2.3 Value Kinds

An attribute's value MUST be one of the following kinds:

1. **Scalar:** An integer, float, boolean, nil, string, list (`[...]`), or an explicitly typed envelope (`<...>`). (Inline lists `[...]` parse each item independently and forbid flow values inside).
2. **Reference:** An `@`-prefixed selector targeting another Element.
3. **Interpolation:** A `!{{...}}` expression left unparsed for host evaluation.
4. **Node:** A fully constructed Element assigned directly to the attribute in block form (`|name`). (The brace form `|{name}` in value position is text, not a Node).
5. **Prose Content:** A text flow.

### 2.4 Deferred Block Values

If an attribute key is provided on a block line with no value, the parser treats any deeper indented lines beneath it as the multi-line value (a Deferred Block). This is concatenation-equivalent for text, and is the standard way to assign deeply nested structure to an attribute.

### 2.5 Explicit Typing (The Envelope)

To prevent accidental re-typing and strictly separate core from dialects, any value type outside the frozen core scalars (Section 4) MUST be written inside an explicit typing envelope: `<...>`.

Core UDON treats the envelope as a boundary. An unlabelled envelope (`<value>`) MUST be offered to the active dialects in priority order. An explicitly labelled envelope (`<dialect:type:value>`) MUST be routed directly. Envelopes may span newlines.

---

## 3. Sugar: Identity, Traits, and Suffixes

UDON provides syntactic sugar for common classification patterns. These forms MUST desugar directly into ordinary, specially-designated attributes within the ADM.

- **Identity (`[key]`):** Desugars to the attribute `:'$key'`. Example: `|user[123]` becomes `|user :'$key' 123`.
- **Traits (`.trait`):** Desugars to the attribute `:'$traits'`. Because attributes stack, multiple traits become a list. Example: `|btn.large.red` becomes `|btn :'$traits' large :'$traits' red`.
- **Flag Suffixes (`?`, `!`, `*`, `+`):** Desugar to explicit boolean `true` assignments on matching `$`-prefixed attributes. Example: `|field?` becomes `|field :'$?' true`.

If an Identity key is left unclosed due to End of Input or a line break, the core MUST desugar the captured fragment to `:'$partial-key'` to prevent the host from acting on a truncated identifier, and MUST emit a Warning.

---

## 4. Frozen Core Scalars

The following types are recognized by syntax alone and constitute the **frozen core scalar set**. No new types will ever be added to bare recognition.

- **Strings:** Quoted (`"..."` or `'...'`) or bare fallback text.
- **Booleans:** The exact bare keywords `true` and `false`.
- **Nil:** The exact bare keywords `null` and `nil`.
- **Integers:** Base-10 (optional `0d` prefix), Hexadecimal (`0x`), Octal (`0o`), and Binary (`0b`).
- **Floats:** Decimal numbers containing a `.` or exponent `e`/`E`.
- **Lists (`[...]`):** A space-delimited array of values.

*(Note: Bare Rationals and Complex numbers are currently parsed but are candidates for migration to a standard `<...>` dialect).*

---

## 5. References and Mixins

The `@` symbol denotes a **Reference**.

### 5.1 The Selector Tuple
A Reference acts as a selector tuple matching `(element-name, key, traits)`. Traits in a selector are filtering criteria, not augmentations.

### 5.2 Resolution
A Reference is completely **inert** at the core level. The ADM stores the reference, but resolving it (via transclusion, attribute merging, or keeping it as an inert pointer) is strictly a Host/Document-layer responsibility.

### 5.3 Duplicate Definitions
Because `|` always defines, two elements of the same type sharing a key (`|user[1]`) is a duplicate definition. This is a Document-layer concern. A Document Builder MUST expose a policy (defaulting to error) for how to handle duplicates (`allow-if-identical`, `first-wins`, `last-wins`, `keep-all`).

### 5.4 Mixins
An anonymous element (e.g., `|.shared-defaults`) carrying attributes MAY act as a Mixin. A host MAY choose to inherit attributes from this Mixin into any Element carrying the same trait. Like references, Mixin resolution is a host behavior, not a core requirement.

---

## 6. Verbatim Content

Content that must avoid UDON parsing entirely is **Verbatim Content**. The ADM captures Verbatim content as opaque bytes with an optional label.

- **Block Form:** `!:lang:` captures indented lines exactly as written, stripping only the baseline geometry indentation. The body may begin on the directive line itself.
- **Inline Form:** `!{:kind: ...}` captures content via brace-counting.
- **Fences:** ``` exactly preserves all bytes and whitespace between the backticks, bypassing automatic prose dedentation entirely. Fences may be opened at any head position.
