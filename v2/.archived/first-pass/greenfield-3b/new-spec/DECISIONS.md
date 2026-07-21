# Greenfield decisions

This file lists deliberate choices in the greenfield-3b rewrite where the
scrubbed input was open, provisional, multi-named, or implementation-primed.
Each item records **what**, **why**, and **user-facing impact**.

Items that change or pin user-visible behavior are marked **[BEHAVIOR]**.
Items that only reorganize language are marked **[ORG]**.

---

## D1 — Multi-line delimited constructs  **[BEHAVIOR]** *(revised after Fable)*

**Source:** CORE left most delimited constructs “deliberately undefined” across
newlines; only `|{…}`, Fence, and `<…>` were settled multi-line. Joseph noted
single-line-only decisions would not last.

**Original pin (withdrawn as a single atom):** all delimited forms multi-line.

**Revised decision — per-construct rows** (ratify separately):

| Construct | Multi-line? | Notes |
|-----------|-------------|--------|
| Inline element `\|{…}` | **Yes** (settled) | Already source-settled |
| Fence | **Yes** (settled) | Already source-settled |
| Envelope `<…>` | **Yes** (settled) | Already source-settled |
| Quoted strings | **Yes** (this suite) | Structured values want it; see also D7/O15 |
| Lists `[…]` | **Yes** (this suite) | Newlines = item whitespace |
| Interpolation `!{{…}}` | **Yes** (this suite) | Prefer multi-line over silent close |
| Identity `[…]` / ref selector key | **Line-bound** (this suite) | Protects `$partial-key` fail-safe; unclosed at newline → `$partial-key` + Warning, not swallow-to-EOF |
| Inline comment `;{…}` | **Open** — [OPEN O16](OPEN.md) | Failure mode is document-swallow; decide with dialect/inline work |
| Inline directive/verbatim `!{…}` / `!{:…}` | **Open** — [OPEN O16](OPEN.md) | Same concern |

**Impact of the revision:** An editing accident `|el[k` + next structural line
again yields `$partial-key` (fail-safe lives). Unclosed `;{` / `!{{` are *not*
yet licensed to consume the rest of the document; until O16 closes, treat
cross-line as at-your-own-risk for those forms only.

**Reasoning (Fable):** Uniformity is purchasable without making identity and
inline-comment typos misfile the remainder of a stream. Geometric vs delimited
stays the taxonomy; line-bound is a *close rule for specific delimited forms*,
not a third extent kind.

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

## D3 — Root-level attributes  **[BEHAVIOR]** *(severity refined after Fable)*

**Source:** Undefined (parser free-floating attribute; “do not rely”).

**Decision:** **Warning** (not Error); keep line as Document-level Text
including `:`. Nothing is lost — severity tracks loss (§14.1).

**Impact:** No portable meaning for top-level `:key`. Bytes preserved. Hosts
that want hard-fail may promote via Consumer policy.

**Reasoning:** Attributes are edges of Elements; root edges without a node are
not in the ADM. Keep-everything + “Error means loss” forbids Error here.

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

## D7 — In-string escapes  **[BEHAVIOR → OPEN]** *(re-opened after Fable)*

**Original pin:** `\\` and matching `\"`/`\'` inside quoted strings.

**Status now:** **Withdrawn as a closed pin.** Multi-line strings remain under
D1 (strings row). Interior escape policy is **[OPEN O15](OPEN.md)** — genuine
fork:

| Option | Pros | Cons |
|--------|------|------|
| A — positional purity: no interior escapes; use the other quote kind | Keeps §9 “`\` is position only”; `C:\Users\new` stays literal | Cannot embed both quote kinds in one string without Host convention |
| B — Core minimal: `\\` + delimiter quote only (old D7) | Expresses any string in one quote kind | Fifth, non-positional use of `\`; mixed `\n` literal-pair surprises |
| C — doubling only (`""` inside `"`) | No backslash story | Collides with list adjacent-quoted items `["x""y"]` = two items |

**This suite’s interim posture (not a ratification claim):** Option **A** —
no interior Core escapes; contain one quote kind with the other. Aligns with
Fable/2a and preserves positional `\`. Marked interim in CORE §11.3 until O15
closes.

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

## D16 — Grammar companion file  **[ORG]** (peer revision)

**Source:** greenfield-3a’s three-pillar split; Gemini feedback that CORE’s
mechanical rules are thorough but heavy, and that `pop while` must be easy to
find.

**Decision:** Add non-normative [GRAMMAR.md](GRAMMAR.md) as a scannable
implementer extract. CORE remains authoritative (including an explicit
`pop while new_column <= stack_top.base_column` spelling in §3.2). On conflict,
CORE wins.

**Impact:** None on document bytes; improves dual-track reading (parser vs
Host/ADM).

---

## D17 — Fable pass tightenings  **[ORG]** / light **[BEHAVIOR]**

Peer review (`feedback-fable.md`, 2026-07-20). Applied:

| Item | Change |
|------|--------|
| D1 | Split per-construct; identity line-bound; inline `;{`/`!{` open (O16) |
| D7 | Re-opened as O15; interim Option A (no interior string escapes) |
| D3 severity | Root attr → Warning (nothing lost) |
| MODEL MultiSegment | Dropped; warned extension = further assignment only |
| MODEL text law | Stated once; scattered clauses are consequences |
| Bare-token boundary | Guard-failing marker chars are not boundaries |
| Reference fail-safe | Selector carries partial flag, not `$partial-key` attribute path |
| GRAMMAR markers | `\` removed from marker table (positional only) |
| SEMANTICS integers | Cross-pointer: base-normalized equivalence ≠ byte round-trip |

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
