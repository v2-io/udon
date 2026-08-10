# Carve-outs — deliberately unspecified, with reasons

**Normative as to scope:** every item here is *deliberately not specified* in this suite (0.10.0-alpha.1; register unchanged from 0.9.1 except as noted in rows). Authors MUST NOT rely on any particular behavior; implementations MUST NOT treat their own behavior as settling one. Each carve-out carries the **demand-side reason it is open** — so no future reader closes it in a framing the reason has already invalidated — and what would actually close it.

This register exists because of a measured failure: three clean-room rewrites (2026-07-20) were handed the spec without these reasons, and all three diligently *closed* the multi-line question per-construct — diligence on a wrongly-framed question producing well-organized irrelevance. The openness is design intent; the reason is the load-bearing part.

> Interim behavior notes below are **descriptive, never normative** (ratified S2): fixtures pinning them must be framed "PINS CURRENT BEHAVIOR"; a future version may redefine with a warning first, never a silent meaning change.

```text
index: ML(closes: dialects/value-typing spike) · ENV-ROUTE(dialect spike)
· ENV-EMPTY(dialect layer) · PATHS(paths spike) · PRAGMA(dialect+schema)
· DIALECT-DEF(dialect spike) · MD(companion work) · MIXIN(host demand)
· ANNOT(paths/dialects/schema) · IND(editing-tool demand)
· RC-SPELL(standard-types dialect) · S4-SCOPE(steward call)
· UNI(version-pin ruling) · S9(ornamentation work) · W(demand-gated wire)
· CODES(W4 reconciliation)
```

---

## ML — multi-line policy for the remaining delimited forms

**What:** whether quoted strings, `[…]` lists, identity/selector brackets, `!{{…}}` interpolation, `;{…}`, and `!{…}`/`!{:kind:…}` may span a line terminator. (Settled and *not* open: `|{…}`, fence, `<…>` are multi-line.)

**Why open — possibly a dissolved question:** if bracketed/quoted captures turn out to be sugar for **dialect-typed captures** (e.g. `[…]` ≈ a ws-delimited-array capture; geometric block capture a second sugar for the same thing), then each capture's grammar owns its own line-span exactly as nested `<…>` routing already does — and there is no per-construct table to close. Deciding rows now would pin answers the dialect mechanism would immediately overrule. (Joseph, 2026-07-21, pipeline-discussion; OPEN ML.)

**Interim (descriptive):** strings/interpolation span; lists and identity keys close at the newline with content kept + Warning (identity via `$partial-key`). The identity case doubles as the fail-safe: an editing accident `|el[k` does not swallow the rest of the document.

**Closes when:** the dialects / value-typing spikes (arc 3) settle the capture mechanism against the demand map — not by ruling table rows.

## ENV-ROUTE — nested envelope routing (S12)

**What:** who routes inner typed values in `<r: <i: 3 -7> 0d83.23>` — the core grammar consuming and handing off, or the active dialect driving an implicit dialect stack. Only the `<>`-balanced span is guaranteed today.

**Why open:** routing *is* the dialect invocation mechanism; specifying it before the dialect definition/declaration/compilation picture exists would bake in a pipeline shape demand hasn't chosen. The in-vivo possibility that `<` dispatches a specialized sub-parser (the descent timespec grammar exists already) breaks stage-linearity assumptions — that is signal, not a problem to define away.

**Closes when:** the dialect spike runs (the in-vivo timespec probe is the named first experiment).

## ENV-EMPTY — `< >` → nil collapse

**What:** a closed whitespace-only envelope collapses to nil per the empty-brackets ruling — but this is a **dialect-era refinement**. In the no-dialects interim, `<>`/`< >` stays the pass-through string + warning.

**Closes when:** the dialect layer lands (then the single-value-slot rule fires uniformly).

## PATHS — reference selector vs path language

**What:** the `(name, key, traits)` selector is **frozen at three fields** (ruled S14) — no incremental growth; a path syntax replaces it wholesale. Multiple-keys surface, uniqueness interplay, and `@` resolution semantics (S3) wait with it.

**Why open:** paths are the long pole of the demand side — query, edit targeting, template scope-contexts, and schema addressing all pull on one design. Growing the tuple field-by-field is exactly how path debt accumulates. **Cross-document addressing is in scope for the design** (ruled PATH-1 — do not build tools that assume document-scope is permanent). **Inputs the design inherits:** multi-key elements exist (K1, 2026-08-07 — `$key` designators stack), so what `@x[k]` matches against a stacked-key element is a paths question, not a today question; `@` inside identity brackets is likewise deferred here (K2).

**Closes when:** the paths spike runs against the needs map (prior art: the parked paths spike §8 demand tables).

## PRAGMA — dialect/schema declaration (S15)

**What:** how a document binds its dialects, schema, and versions (a pragma, a filename designator, both, or neither).

**Why open:** the binding surface depends on the dialect and schema pictures that don't exist yet; also interacts with mid-stream reconfiguration demand (can the active dialect set change mid-document?). File-naming convention (`<name>.<designator>.udon`) stays application-level meanwhile.

## DIALECT-DEF — defining, declaring, validating a dialect

**What:** what a dialect *is* as an artifact — how one is defined, possibly compiled, verified, declared, and invoked; the default active set for unlabelled dispatch; ordering/override rules when several are loaded; whether dialects may override interpolation or inline-element interpretation.

**Why open:** this is the largest named hole in the demand-side work — no dialect spike has ever run. Everything here is one design with the `!{{…}}`/`<…>` overlap question (both dialect-ruled; interpolation text-guaranteed) logged as a unification pressure to *check against the map*, not to unify early.

## MD — Markdown layers (S16)

**What:** which Markdown subset renderers honor, the Markdown-equivalent element vocabulary, conversion/degradation policy. Companion stub only; core text stays opaque.

## MIXIN — mixin semantics (S13)

**What:** trait-matched attribute inheritance stays a host experiment; override rules, multiple-mixin resolution, child/prose inheritance all unspecified. The core gives the mechanism (anonymity + traits + stacking) and nothing more.

## ANNOT — annotation syntax beyond the named-element convention (CHANGELOG C2)

**What:** richer inline annotation than `|{note :confidence 0.7 …}` — deferred to the demand-side work with paths/dialects/schema. (The ASF-side demand for provenance/attestation affordances in agent-durable formats is real gathered evidence for this item, not yet a design.)

## IND — no-sibling indentation default

**What:** when a tool computes insertion indentation and the destination has no siblings to read from, no ratified rule names the default unit (CORE's 2-space note is style, non-normative). Needs one spec sentence.

**Closes when:** editing-tool demand names the unit (evidence: udon-needs scenarios corpus, 03-modifying).

## RC-SPELL — rational/complex spelling in a standard-types dialect

**What:** `1/3r`, `3+4i`, `5i` are ruled out of bare space (L5/R21); their envelope spelling (`<r:…>`, `<c:…>`, composition, nesting) belongs to a standard-types dialect that doesn't exist yet.

## S4-SCOPE — `InconsistentIndentation` scope (prose-only?)

**What:** whether the shallow-line warning fires for prose lines only or also for comment-continuation lines. This suite's prose and Appendix B describe the prose-**and**-continuation extent — **inherited from live CORE's registry, not ratified**: OPEN.md's S4 (a steward/fact question about grammar intent) is still open. The description here is the current state of the code/spec text; do not cite it as settling S4.

**Closes when:** the S4 steward call lands (then OPEN.md's row closes with a cite and this item disappears).

## UNI — Unicode identifier version pin

**What:** which Unicode version's `XID_Start`/`XID_Continue` tables govern bare names/keys/traits. Currently a declared host decision (CORE §5.2): recognizers state their Unicode data version; non-ASCII identifiers are non-portable across different declared versions.

**Why open:** the 0.9 line never versioned it, and inventing a pin in a consolidation would be design, not consolidation. The eventual answer (a pinned version + upgrade procedure, or a permanent declared-profile model) affects conformance-suite portability and belongs with the compliance/versioning work.

**Closes when:** a ruling pins a version (or ratifies the declared-profile model) — likely alongside the first published fixture suite.

## S9 — BlankLine placement at structural seams

**What:** exact placement of blank-line nodes relative to dedents at structure boundaries. Consumers follow the ornamentation model (CORE §7.4), not raw node order.

## W — event/wire encoding (out of this suite by design)

**What:** the flat attribute wire was **deratified** (R8: value extent must never be inference-only); the successor direction (W0 sufficiency / no-reachback at product boundaries, W1d self-delimiting values) and the exact event spelling (W1e) live in the v2 ledger and wait on demand (utils/paths pull). References meanwhile ride the interim raw-text-after-`@` encoding (W3) until shared identity machinery makes structured encoding cheap. This suite specifies the model and its adequacy test (MODEL §6) — any future wire must reconstruct the text law — and otherwise stays silent. The unscrubbed 0.9 `spec/CORE.md` retains the deratified wire text and the event-era parser notes as the historical record; consult it (and `core/generator/*.descent.udon`) for event-layer archaeology, never as contract.

## CODES — warning-code spellings

**What:** anomaly code names (`Unclosed*`, `$partial-key` spelling included) are working names; SPEC vocabulary and generator derivation must agree (ruled W4) before spellings become contract. Implement toward them; do not cement them. The current working inventory is CORE Appendix B (recovered from the unscrubbed registry; severities updated per L0/L4).

---

*Closed, not carve-outs (do not re-open here):* in-string escapes (L2 — none; use the other quote kind), tab-in-indent (L4 — warn + keep), root attributes (L1 — warn + document text), attr-under-attr keep shape (L6), comment-continuation strip (L7), framed ` ; ` inside `|{…}` (R20 — out for now, bare `;` literal; dialect-era revisit noted there), duplicate policy and resolution modes (menus — consumer knobs inside fixed option spaces).
