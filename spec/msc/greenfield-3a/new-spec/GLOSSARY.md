# UDON Glossary (Source of Truth)

**Universal Document & Object Notation**
*Version 0.9.0-alpha.2 (Draft)*

To maintain **Ruthless Consistency**, this glossary serves as the single source of truth for all terminology used in the UDON ecosystem. When discussing UDON, you MUST use these terms exactly as defined here.

---

## 1. Core Semantic Concepts

- **Abstract Document Model (ADM):** The ordered tree structure that a valid UDON document resolves into. It consists exclusively of Elements, Attributes, and Prose Content.
- **Element:** The structural backbone of UDON (the "node"). An Element possesses a name, an ordered list of Attributes, and an ordered sequence of Children.
- **Attribute:** A labeled edge belonging to an Element. Values assigned to the same attribute key on a single Element **stack** into an ordered list.
- **Prose Content:** A sequence of opaque text and inline formatting that belongs to an Element as its child.
- **Identity:** The unique identifier of an Element within its type, written as `[key]`. Desugars to the `:'$key'` attribute.
- **Trait:** A classification string applied to an Element, written as `.trait`. Desugars to the `:'$traits'` attribute.
- **Flag Key:** An attribute key ending in `?` (e.g., `:ready?`). It evaluates to boolean `true` if no explicit value is provided.

## 2. Values and Typing

- **Scalar:** The frozen set of core types recognized syntactically without an envelope: Strings, Booleans, Nil, Integers, Floats, and Lists (`[...]`).
- **Explicit Typing Envelope:** The `<...>` syntax used to assign a Dialect-specific type to a value.
- **Node Value:** An entire Element assigned directly as the value of an Attribute, rather than as a child of the parent Element.
- **Interpolation:** An expression wrapped in `!{{...}}` that the Host evaluates and injects into the ADM.
- **Reference:** An inert selector tuple (Element-name, Key, Traits) starting with `@`. It acts as a pointer for the Host to resolve.
- **Verbatim Content:** Content captured exactly as written without UDON parsing, utilizing the block `!:lang:`, inline `!{:kind:}`, or triple-backtick fence ``` forms.

## 3. Parser and Grammar Terms

*(Note: These terms describe the mechanical extraction of the ADM from bytes. They should generally be isolated from semantic and user-facing documentation).*

- **Marker:** A structural prefix character (`|`, `:`, `!`, `;`, `@`, ```, `\`) active at the start of a line or in the sameline scan.
- **Sameline Scan:** The parser state immediately following an Element definition where subsequent elements and attributes on the same line are captured before the line commits to Prose Content.
- **Bare-Token Boundary:** The lookahead point where the parser decides if an unquoted word is a single-value token (because a block-form marker follows) or the start of a Prose Content sequence.
- **Content Base Column:** The calculated indentation level of a block of Prose Content, used to automatically strip leading whitespace from subsequent lines.
- **Inline Brace Form:** The `|{...}`, `!{{...}}`, and `;{...}` constructs. Encountering one of these never closes a bare token; it commits the parser to a Prose sequence.

## 4. Ecosystem Boundaries

- **Core:** The syntactic rules and ADM projection guaranteed by every conformant UDON parser.
- **Host:** The application or environment interpreting the ADM.
- **Schema:** A set of constraints defining what an UDON document is *allowed* or *required* to contain (e.g., cardinality, required attributes).
- **Dialect:** An extension that gives meaning to Explicit Typing Envelopes (`<...>`) and Dynamics (`!`). (e.g., `temporal@1`).
