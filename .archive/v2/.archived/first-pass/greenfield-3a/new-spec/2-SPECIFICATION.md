# UDON Specification (The Semantic Domain)

**Universal Document & Object Notation**  
*Version 0.9.0-alpha.2 (Draft)*

This document defines the **semantics** of a valid UDON document, establishing what the constructs mean independently of how they are parsed. For the formal lexical grammar and parser mechanics, see [1-GRAMMAR.md](1-GRAMMAR.md).

---

## 1. The Abstract Document Model (ADM)

An UDON document conceptually resolves into an **Abstract Document Model (ADM)**. A conformant host MUST project the parsed source into this model.

The ADM is a **forest of TopLevelItems** (Elements, Directives, Comments, Prose). The document itself does NOT have an implicit root element. Multiple top-level Elements are true siblings.

### 1.1 Element Structure

Every Element in the ADM consists of exactly three things:
1. **Name** (Optional string): What the element is. 
2. **Attributes** (Ordered list of Key-Value assignments): Labeled metadata describing what properties belong to the element.
3. **Children** (Ordered sequence): The content of the element, which may be a mix of other Elements, Prose Content, Comments, Directives, and Verbatim nodes.

There are no separate, intrinsic fields for "identity" or "traits" in the core model. They are syntactic sugar that desugars into specially-designated attributes.

**Anonymous Elements as Core:**  
An element's name is optional. Forms like `|[key]`, `|.trait`, and `|?` produce valid, ordinary Elements with no name that carry attributes and children exactly like named elements.

### 1.2 The Core vs. Host Boundary

UDON's core semantics deliberately leave three domains to the consuming host environment:
- **Projection:** How the host turns a validated string into a native application value.
- **Constraint (Schema):** What is *allowed* or *required* (e.g., "this element MUST have a `$key`"). 
- **Exotic Typing (Dialects):** What non-core value patterns mean. Core UDON recognizes the syntax of the `<...>` envelope, but a **Dialect** interprets the contents.

---

## 2. Attributes and Values

Attributes are labeled edges belonging to an Element. 

**Root-Level Error:** A line-initial `:key` at the document root (without an owning Element) is an Error. The line is kept as document-level text.

### 2.1 Tail Ownership (The 3 Rows of Priority)

When text flows on a line, ownership is decided by priority:
1. **Collecting:** If an attribute to the left still needs a value, or is a block attribute on its own line, the text belongs to that attribute's value. *(Trailing material after a finished block attribute is ingested as a multi-segment value with a Warning).*
2. **Sameline Decompress:** Else, the nearest element on the same line to the left owns the text as child prose.
3. **Prose:** Else, ordinary indent/dedent ownership applies.

### 2.2 Plain Attributes vs. Flag Keys

Attribute keys that terminate with a `?` character are **Flag Keys** (e.g., `:ready?`).

- A Flag Key provided with no explicit value MUST evaluate to the boolean `true`.
- **Flag Rule:** If `:key?` is followed by anything other than exactly `true`, `false`, `null`, or `nil`, the flag evaluates to `true`, and the following material is re-owned by the continuing scan (it is never the flag's body).
- A Plain Key provided with no explicit value is a semantic anomaly. The parser MUST assign it a `nil` value and emit an Error (non-halting).

### 2.3 Value Kinds

An attribute's value MUST be one of the following kinds:

1. **Scalar:** An integer, float, boolean, nil, string, list (`[...]`), or explicitly typed envelope (`<...>`).   
   *(List Items MUST NOT contain flow values; each item is a discrete token. Adjacent quoted strings are preserved).*
2. **Reference:** An `@`-prefixed selector targeting another Element.
3. **Interpolation:** A `!{{...}}` expression left unparsed for host evaluation.
4. **Node:** A fully constructed Element assigned directly to the attribute in block form (`|name`).
5. **Prose Content:** A text flow.

### 2.4 Node Values (The One-Way Door)

An attribute MAY take an entire Element as its value by using the block form (`|name`). 
- **One-Way Door:** The node value is a one-way door on its line. Once the node opens, its scan owns its interior. `|api :headers |header :timeout 30` binds `timeout` to the *header*, not the *api*.
- **Brace Form:** The brace form `|{name}` in value position is NOT a node value; it commits the value to a Prose Content text flow.
- **Attribute-Under-Attribute:** Writing a deeper `:key` directly under an attribute without a named Node carrier is an Error. The line is ingested as text of the open value.

### 2.5 Explicit Typing (The Envelope)

Any value type outside the frozen core scalars MUST be written inside an explicit typing envelope: `<...>`. An unlabelled envelope MUST be offered to the active dialects in priority order. An explicitly labelled envelope (`<dialect:type:value>`) MUST be routed directly. Envelopes may span newlines.

---

## 3. Sugar: Identity, Traits, and Suffixes

These forms desugar directly into ordinary attributes within the ADM.

- **Identity (`[key]`):** Desugars to `:'$key'`. Identity is contiguous; a space breaks identity.
- **Traits (`.trait`):** Desugars to `:'$traits'`. Traits stack into a list. The trait value is a Unicode identifier, and absorbs trailing flag suffix characters (`* ! ? +`), meaning `.foo?` is exactly the trait `"foo?"`.
- **Flag Suffixes (`?`, `!`, `*`, `+`):** Desugar to explicit boolean `true` assignments on matching `$`-prefixed attributes (`:'$?' true`). A suffix binds to the element identity; if placed after a trait, it MUST be space-separated to avoid absorption.

**Naming Rules (XID):**  
A bare element name or trait is a Unicode identifier. The first character MUST carry the `XID_Start` property. Subsequent characters MUST carry `XID_Continue` or be a hyphen `-` or slash `/`. Characters outside this set (e.g., `.`, `[`, `:`) end the bare name. Names with invalid characters must be quoted (`|'weird name'`).

If an Identity key is left unclosed at EOF, the core MUST desugar it to `:'$partial-key'` to prevent the host from acting on a truncated identifier, emitting a Warning.

---

## 4. Frozen Core Scalars

The following types are recognized by syntax alone and constitute the **frozen core scalar set**:

- **Strings:** Quoted (`"..."` or `'...'`) or bare fallback text.
- **Booleans:** The exact bare keywords `true` and `false`.
- **Nil:** The exact bare keywords `null` and `nil`.
- **Integers:** Base-10 (optional `0d`), Hexadecimal (`0x`), Octal (`0o`), and Binary (`0b`).
- **Floats:** Decimal numbers containing a `.` or exponent `e`/`E`.
- **Lists (`[...]`):** A space-delimited array of values.

*(Note: Bare Rationals and Complex numbers are NOT Core Scalars. They belong to a Dialect).*

---

## 5. References and Duplicate Definitions

The `@` symbol denotes a **Reference**. A Reference acts as a selector tuple matching `(element-name, key, traits)`.

### 5.1 Resolution and Duplicates
A Reference is completely **inert** at the core level. Resolving it is strictly a Host/Document-layer responsibility.

Because `|` always defines a new element, two elements of the same type sharing a key (`|user[1]`) is a duplicate definition. A Document Builder MUST expose a policy (defaulting to error) for how to handle duplicates (`allow-if-identical`, `first-wins`, `last-wins`, `keep-all`).

---

## 6. Verbatim Content

Content that must avoid UDON parsing entirely is **Verbatim Content**. The ADM captures Verbatim content as opaque bytes.

- **Block Form:** `!:lang:` captures indented lines exactly as written, stripping only the baseline geometry indentation.
- **Inline Form:** `!{:kind: ...}` captures content via brace-counting.
- **Fences:** ``` exactly preserves all bytes and whitespace between the backticks, bypassing automatic prose dedentation entirely. Fences may be opened at any head position, and closed at any indent.
