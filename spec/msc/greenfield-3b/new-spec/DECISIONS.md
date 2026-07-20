# Greenfield decisions

This file lists deliberate choices in the greenfield-3b rewrite where the
scrubbed input was open, provisional, multi-named, or implementation-primed.
Each item records **what**, **why**, and **user-facing impact**.

Items that change or pin user-visible behavior are marked **[BEHAVIOR]**.
Items that only reorganize language are marked **[ORG]**.

---

## D1 — Multi-line delimited constructs  **[BEHAVIOR]**

**Source:** CORE left most delimited constructs “deliberately undefined” across
newlines; only `|{…}`, Fence, and `<…>` were settled multi-line. Joseph noted
single-line-only decisions would not last.

**Decision:** All Delimited Constructs MAY span multiple lines. Interior
newlines are content (Lists: whitespace between items). Unclosed at true EOF
still Warning + Incomplete Input.

**Impact:** Documents that break strings, arrays, identity keys, interpolations,
or inline comments across lines become defined (legal) rather than
at-your-own-risk. Recognizers that previously closed arrays/keys at newline will
need to follow this contract when reimplemented.

**Reasoning:** Uniform extent model (geometric vs delimited only); matches
envelope/inline element; enables multi-line typed and structured values without
a second exception list.

---

## D2 — Rational and complex leave bare core  **[BEHAVIOR]**

**Source:** CORE marked bare `1/3r`, `3+4i` provisional / candidates for dialect.

**Decision:** Not Frozen Core Scalars. Future `standard-types` (or similar)
Dialect via Envelope. Until Dialects load, those spellings are ordinary bare
text if unquoted.

**Impact:** Authors who relied on bare rational/complex typing must use
Envelopes once the Dialect exists. No contradiction with frozen-set principle.

**Reasoning:** Bare recognition is a one-way door; compositional numbers fit
Envelope + Dialect better than eternal bare growth.

---

## D3 — Root-level attributes  **[BEHAVIOR]**

**Source:** Undefined (parser free-floating attribute; “do not rely”).

**Decision:** Error; keep line as Document-level Text including `:`.

**Impact:** No portable meaning for top-level `:key`. Bytes preserved.

**Reasoning:** Attributes are edges of Elements; root edges without a node are
not in the ADM. Error + keep beats silent free-float.

---

## D4 — Vocabulary stabilization  **[ORG]**

**Retired** freeform, embedded, positional (close-axis), blob, head position,
wire/event (from contract), raw-as-free-noun. See GLOSSARY §8.

**Renamed for contract:** Structure Position, Line Scan, Geometric/Delimited,
Verbatim family, Flow Value, Recognition (vs “the parser”).

**Impact:** None on document bytes; large impact on implementer/reader clarity.

---

## D5 — Pillar split  **[ORG]**

**Decision:** Middle-pillar suite: GLOSSARY + MODEL + CORE + SEMANTICS +
dialects + layers; pedagogy separate; grammar deferred; wire omitted.

**Reasoning:** Matches `defining-udon.md`; stops implementation jargon from
being the language definition.

---

## D6 — Anomaly posture retained, re-scoped  **[ORG]** (+ light **[BEHAVIOR]** clarify)

**Decision:** Keep-Everything remains recognition default. Halt/reject/fail-on-
warning are Consumer policies (menu), not alternate recognition modes.

**Reasoning:** Round-trip and LLM/stream partial inputs need retention.
JSON-style hard reject remains available *above* recognition without forking
the language.

---

## D7 — Strings and Lists multi-line escapes  **[BEHAVIOR]** (subset of D1)

**Decision:** Quoted strings multi-line with newline-as-content. Minimal Core
escapes: `\\` and delimiter quote only.

**Reasoning:** Avoid underspecified `\n` wars; Hosts may interpret more in
Dialects later. Keeps Core small.

---

## D8 — Temporal as envelope-only Dialect  **[BEHAVIOR]** (affirms CORE direction)

**Decision:** Recast TIME-SPEC as `temporal@1`; bare dates are strings. Value
*grammar inside* envelopes preserved from TIME-SPEC.

**Impact:** Aligns companion with CORE; fixes documented contradiction.

---

## D9 — Comment continuation strip  **[BEHAVIOR]** (pins open ruling)

**Source:** “content-base shape vs verbatim from comment column — needs ruling.”

**Decision:** First continuation line establishes strip column (same shape as
prose Content Base).

**Reasoning:** One mental model for continued geometric text; matches source’s
primary description.

---

## D10 — Inline raw / framed comments in `|{…}`  **[BEHAVIOR]** (pins)

**Decision:**

- Inside `|{…}`, only `;{…}` comments; bare `;` literal (no framed sameline).
- Inline Verbatim allowed as Flow segment in value position.

**Reasoning:** Removes UNDEFINED/CURRENT dual; keeps inline model small.

---

## D11 — `$partial-key` name kept  **[ORG]**

Provisional name in source; retained for fail-safe identity. Rename would break
no documents but would churn Hosts; not worth greenfield churn.

---

## D12 — Selector tuple model kept  **[ORG]**

Path-syntax future noted; current contract remains `(name, key, traits)`.

---

## D13 — Attribute-under-attribute keep shape  **[BEHAVIOR]** (pins)

**Decision:** Error + ingest offending line as Text of open value.

**Reasoning:** Matches Keep-Everything; source already leaned this way.

---

## D14 — Round-trip / equivalence  **[ORG]**

New [SEMANTICS.md](SEMANTICS.md) defines equivalence classes so AST
normalization can be discussed without equating all surface spellings.

---

## D15 — No inventing wire/event  **[ORG]**

Omitted on purpose; post-spec grammar/parser rewrite will own that layer.

---

## Not changed (user-facing behavior held)

- Marker set and Guards (including `|` Markdown table safety)
- Sugar desugaring table
- Stacking vs List orthogonality
- Ownership rows / collecting asymmetry
- Inline-Brace Principle and Bare Token Boundary
- Flag Key re-owning rules
- Node Value One-Way Door; block vs brace
- Nesting Rule / sameline column nesting
- Prose Dedentation algorithm
- Verbatim three forms
- Reference inertness; mixin non-core
- Duplicate definition as Document-layer menu
- Frozen bare set philosophy (minus rational/complex)
- Envelope Label Ladder and unlabelled dispatch order
