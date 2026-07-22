# Review: current-0.9.1-spec consolidation

**Reviewer:** agy (Gemini 3.1 Pro (High))
**Date:** 2026-07-22

## Findings

### 1. Parser Jargon Bleed in the Rename (Severity: High, Excellence/Fidelity)
* **Location:** `DELTAS.md` (Row 21) and `CORE.md` (§2.2)
* **Primary-source cite:** `defining-udon.md` (Part 1: The Principle of Isolation - "Never let parser implementation jargon bleed into the outer layers.")
* **Finding:** The vocabulary rename explicitly introduces "Line Scan" and "Structure Position" as formal nouns into the specification and pedagogy space. These terms are highly parser-centric and expose internal state-machine semantics. `defining-udon.md` explicitly warns against exactly this: the grammar is for machines, pedagogy and specs should use concepts accessible to a human author. Telling an author they are in "Structure Position" or a "Line Scan" is a leaky abstraction.
* **Suggested Disposition:** Revert or refine the rename for the user-facing spec/pedagogy. Use structural/author-centric terms (e.g., "Element Definition Phase", "Inline Context") rather than scanner-centric terms.

### 2. Pedagogy as a "Stub" Violates Progressive Disclosure (Severity: Medium, Fidelity)
* **Location:** `PEDAGOGY.md` and `README.md`
* **Primary-source cite:** `defining-udon.md` (Part 3: Pedagogy - "Progressive disclosure... shaping mental models")
* **Finding:** Deferring the pedagogy completely to an outline because the "demand side" hasn't settled on idioms (ruled P4) is a risk. `defining-udon.md` highlights that pedagogy is essential for shaping mental models. The absence of a strong pedagogical introduction means that new readers of this spec (including agents reading it to learn UDON) must learn from `CORE.md`, which is dense and explicitly *not* a tutorial.
* **Suggested Disposition:** Even if idioms are open, a "provisional" or "baseline" pedagogy document should be drafted for the agreed-upon core features (e.g., basic structure, attributes vs children) to establish the mental models immediately, rather than leaving it as a pure outline.

### 3. Missing Default Indentation Unit Causes Tooling Drift (Severity: Medium, Fidelity)
* **Location:** `CARVEOUTS.md` (IND) and `CORE.md` (§2.1)
* **Primary-source cite:** `defining-udon.md` (Part 2: Enforce Strict Error Handling)
* **Finding:** The spec leaves the default indentation unit undefined (waiting for editing-tool demand). However, a specification's job is to prevent a fragmented ecosystem. If a default unit is not standardized for automated tooling (even if it's 2 spaces), different tools will choose different defaults, leading to files that constantly thrash indentation sizes when modified by different agents.
* **Suggested Disposition:** The spec `SHOULD` define a standard default indentation (e.g., 2 spaces) for automated generation to ensure tooling stability, even if humans are allowed to use different spacing.

### 4. Splitting out Dialects is an Excellent Choice (Severity: High, Excellence)
* **Location:** `CARVEOUTS.md` (Multiple dialect carveouts)
* **Finding:** The explicit outlining of *why* features like `!{{...}}` and `<...>` meaning are deferred (because they depend on the dialect layer which hasn't been validated against demand) is an exceptional piece of spec-writing. It prevents the premature optimization seen in the earlier greenfield rewrites.
* **Suggested Disposition:** Keep this structure exactly as it is; the reasoning in `CARVEOUTS.md` is robust and prevents diligent but misaligned closures.
