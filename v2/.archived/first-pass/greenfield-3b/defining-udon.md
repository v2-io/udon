# Defining UDON: Best Practices for Specification and Pedagogy

When designing a new markup format like UDON, separating the documentation into distinct pillars—the **Grammar**, the **Official Specification**, and the **Pedagogy**—is critical to its adoption and success. A common pitfall for language designers is attempting to write a single document that teaches a beginner how to write the syntax while simultaneously instructing a compiler engineer how to parse it. 

This report delves into how to structure these three pillars, drawing on lessons from best-in-class formats like JSON, CommonMark, and TOML.

---

## Part 1: The Grammar (The Mathematical Skeleton)

The grammar is a strict, machine-readable set of rules (often written in EBNF, PEG, or structured as a state machine) that dictates the structural "shape" of valid syntax. It is authored exclusively for parser generators, compiler engineers, and core implementers. The grammar's sole responsibility is defining what sequences of characters are valid. It knows *where* a string goes, but not what it *means*. It should be kept entirely separate from semantic rules and user-facing explanations.

### The Principle of Isolation (Terminology)
Never let parser implementation jargon bleed into the outer layers. If the Grammar defines an `InterpolatedDynamicBlockToken`, the Pedagogy should simply call it a "Dynamic Block." The Grammar should be treated as internal tooling vocabulary, while the Specification bridges the gap by explicitly stating: *"A Dynamic Block (represented in the grammar as `InterpolatedDynamicBlockToken`)..."*

---

## Part 2: The Official Specification (The "Legal Contract")

The official specification is not a tutorial; it is a rigid, often dry, legal contract between the format designer and tool implementers. Its primary goal is the absolute elimination of ambiguity.

### 1. The 4 C's: Clear, Concise, Correct, Complete
A specification must ruthlessly adhere to the "Four C's". Avoid ambiguous language, and do not rely on prose to describe syntax if a formal grammar definition is available. 

### 2. Use Standardized "Requirement" Language
Adopt the strict terminology of **RFC 2119** (e.g., `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`).[^6] This eliminates guesswork. If a parser encounters a missing newline, the spec must explicitly state whether it `MUST` throw an error or `MAY` silently recover.

### 3. Enforce Strict Error Handling (The JSON Lesson)
A robust specification must spend as much time defining what happens when rules are broken as it does defining the "happy path." 

**Case Study: JSON (RFC 8259)** JSON's massive success is largely due to its ruthless simplicity and strict error handling. The specification explicitly defines that a parser `MUST` accept all valid texts, but it offers zero leeway for non-standard extensions like trailing commas or comments.[^1] By forcing parsers to fail loudly on invalid input, JSON prevented a fragmented ecosystem of "almost-JSON" flavors.

**Takeaway for UDON:** The spec must explicitly mandate parser behavior for edge cases. For instance, if an author leaves a `|{` inline element unclosed at the end of a line, the spec must dictate whether a compliant parser `MUST` throw a fatal error, `SHOULD` attempt recovery, or `MAY` silently convert it to plain text. 

### 4. Standardization Through Test-Driven Conformance
A specification written purely in prose is virtually guaranteed to contain contradictions. The modern gold standard is to pair the written specification with a comprehensive, language-agnostic conformance test suite.

**Case Study: CommonMark & TOML** CommonMark was created specifically to formalize the language, aiming to ensure that "the same input must always produce the same output."[^2] To achieve this, it relies heavily on a massive suite of JSON-based test fixtures. Similarly, the TOML specification relies heavily on the `toml-test` framework, forcing any developer claiming "TOML compliance" to pass hundreds of edge-case tests.[^3]

**Takeaway for UDON:** UDON's "compliance-fixture group" is exactly the right approach. The `CORE.md` specification should explicitly state that passing the canonical fixture suite is the *only* definition of compliance.

### 5. Define the Abstract Document Model (ADM)
A parser doesn't just read strings; it builds data structures. A great specification defines the exact shape of the resulting Abstract Syntax Tree (AST) or Document Object Model. If UDON allows attributes to stack (e.g., `:class red :class bold`), the specification must define whether the resulting ADM represents this as an array of values, a concatenated string, or if it mandates a fatal error for duplicate keys.

### 6. Separate Rationale from Rules
Implementers reading a spec to fix a bug don't want to read a philosophical essay on *why* a design choice was made. Keep the "why" in a separate "Rationale" or "Design Document" (or explicitly box it out as non-normative text). The spec itself should be purely instructional.

### 7. The Glossary as the Source of Truth
The Specification must contain a centralized Glossary. Every time a new concept is introduced (e.g., "Suffix Stacking" or "Inline Elements"), it must be defined formally in this Glossary. If a term isn't in the Glossary, it shouldn't be capitalized as a formal noun anywhere else.

---

## Part 3: Pedagogy (The "User Manual")

If the specification is written for machines, the pedagogy is written for human authors. Its goal is to reduce cognitive load and establish idiomatic usage.

### 1. Progressive Disclosure
Progressive disclosure is an instructional design strategy that involves revealing information incrementally, preventing cognitive overload by hiding advanced details until the user has mastered the basics.[^4]

**Application in UDON:** A user looking at UDON for the first time should not be immediately confronted with dynamic interpolations (`!{}`), temporal types, or the nuances of the Suffix Stacking rules.
*   **Level 1:** Show UDON acting exactly like Markdown (prose + basic structure).
*   **Level 2:** Introduce block elements (`|heading`) and attributes (`:author`).
*   **Level 3:** Introduce inline elements and dynamics.

### 2. Shaping Mental Models
A mental model is the internal cognitive framework a learner uses to predict how a system works. Effective pedagogy doesn't just list features; it gives the user heuristics (rules of thumb) to help them guess the right syntax.[^5]

**Application in UDON:** UDON's rule for deciding between an Attribute (`:`) and a Child element (`|`) is a perfect example: *"Ask whose name is it? If the label describes the relationship to the parent, it's an attribute; if the name describes the thing itself, it's a child."*

### 3. Relate Before Naming
When introducing adopted terminology, use the "relate before naming" technique. Before hitting the user with a new term, describe it using concepts they already know. 
*   *Poor:* "UDON uses Temporal Types for dates."
*   *Better:* "Just like you might type a date in YAML, UDON natively understands dates and times. We call these **Temporal Types**."

### 4. Idiom Over Allowance
Specifications say what is *possible*; pedagogy says what is *proper*. If a language spec allows a developer to write a single-line conditional in 14 different ways, the official tutorial should present exactly *one* way as the "idiomatic" or correct way.

### 5. Ruthless Consistency
If you decide to call `|` elements "Children" in the pedagogy, you cannot call them "Nodes" in the specification and "Blocks" in an error message. A single, consistent vocabulary must be enforced across all documentation, parser error messages, and API endpoints.

---

## Footnotes

[^1]: **RFC 8259 - The JavaScript Object Notation (JSON) Data Interchange Format.** *"A JSON parser MUST accept all texts that conform to the JSON grammar... [Parsers] MAY accept non-JSON forms or extensions."* Published December 2017. [Link](https://datatracker.ietf.org/doc/html/rfc8259#section-9) (Pulled 2026-07-19)

[^2]: **CommonMark Specification.** Designed to address the ambiguity in original Markdown where different implementations produced wildly different HTML. *"We propose a standard, unambiguous syntax specification for Markdown, along with a suite of comprehensive tests to validate implementations."* [Link](https://spec.commonmark.org/) (Pulled 2026-07-19)

[^3]: **toml-test: A language agnostic test suite for TOML.** Industry standard suite separating tests into `valid/` and `invalid/` directories to ensure parsers fail correctly on bad input. [Link](https://github.com/toml-lang/toml-test) (Pulled 2026-07-19)

[^4]: **Progressive Disclosure in Pedagogy.** *"Progressive disclosure acts as a filter, preventing cognitive overload and ensuring that the learner’s 'cognitive budget' is spent on core concepts that serve as the foundation for future learning."* (Synthesized from educational psychology and UX design principles). [Link](https://www.nngroup.com/articles/progressive-disclosure/) (Pulled 2026-07-19)

[^5]: **Mental Models in Programming.** *"Effective pedagogy aims to help students move from simple, 'folk-theoretical' models to more accurate, technical ones without overwhelming them."* [Link](https://medium.com/@naomiceder/mental-models-and-teaching-programming-7d432b207577) (Pulled 2026-07-19)

[^6]: **RFC 2119 - Key words for use in RFCs to Indicate Requirement Levels.** Formalizes terms like MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, and OPTIONAL. Published March 1997. [Link](https://datatracker.ietf.org/doc/html/rfc2119) (Pulled 2026-07-19)
