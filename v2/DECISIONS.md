# DECISIONS — present ledger (0.10 / v2)

**Status:** seed 2026-07-21; graduated from `.archived/second-pass/` the same
day (first cherry-pick — these closes don't depend on the archived R/A/R/E
pipeline ontology). Where wire rows below say "stage boundaries," read
"product boundaries" — the four-stage picture is archived, the sufficiency
law survives; a definitions-vs-products refinement of **W0** (consulting
loaded dialect/schema *definitions* is configuration, not reachback) is
anticipated but not yet worded. Thin present-truth only.  
**History / life:** `spec/msc/CHANGELOG.md`, greenfields, session vault — not this file.  
**How to amend:** append or overturn with date + provenance; do not silently rewrite history into this file.

Each entry: **what holds now**, a **short why**, and a **cite**. No session digests.

---

## Charter (steward-marked 2026-07-20)

| ID | Holds | Cite |
|----|--------|------|
| **C0** | **Greenfield replacement** of the accreted suite (not brownfield merge into live CORE). | RULING-TABLE jaw 7/20 |
| **C1** | **Seeded authoring** (CHANGELOG + this ledger + greenfields as wording/org); not pure clean-room re-derivation. | same |
| **C2** | Version line **0.10.0** (0.9.x stays transitional history; `core-v0.8.0` gate remains honest). | same |
| **C3** | Suite day-one: SPEC + ADM + GLOSSARY + WIRE + SEMANTICS + DECISIONS + OPEN; optional thin GRAMMAR/pedagogy; **tactical deference to authors**. | same |
| **C4** | Old parser **runnable as differential oracle** until new gate green; not authority; do not intermingle with new stack. | same |
| **C5** | Fixtures assert **events and assembly/ADM product** where useful; profiles **idiomatic / comprehensive / descriptive (non-normative)**. | same |

Process norms: the night's PROCESS.md is archived (`.archived/second-pass/`) pending a post-needs-map rewrite; agent-primary + steward-gate + append-only-ledger norms remain in force informally. Not language law.

---

## Carry from CHANGELOG / 0.9 rulings (CARRY)

Operator seed: **carry as-cited** unless a later Overturn appears. Detail stays in CHANGELOG; wording lands in new SPEC when authored.

| ID | Holds (one line) | Cite |
|----|------------------|------|
| **R1** | Text reconstructs by pure in-order concat of text-bearing events; `BlankLine` ≡ `"\n"`. | CHANGELOG TEXT-WIRE 2026-07-19; TODO-TEXT-WIRE |
| **R2** | Geometric close silent at EOF; delimited unclosed → warn + keep; incomplete-input when still open at true EOF. | CHANGELOG 2026-07-17/18 |
| **R3** | **0.9:** remaining delimited multi-line largely **undefined / warn-before-disallow**. **0.10 design proper** (incl. greenfield multi-line pins) is **not settled here** — see OPEN multi-line (WAIT-DEMAND). | CHANGELOG S2; table R3 |
| **R4** | Inline braces are never bare-token boundary markers (`*{` principle); commit flow; block `\|name` binds node value. | CHANGELOG densification 2026-07-19 |
| **R5** | Unclosed identity → `$partial-key` (+ warn), not `$key`. | CHANGELOG; HOLD/RELEASE |
| **R6** | Attribute substrate: flag keys, plain missing value → Nil+error, stacking; **attr-under-attr error status**. Kept shape → **L6**. | CHANGELOG attr-model 2026-07-15/16 |
| **R7** | Bare dates are strings; temporal → envelope / dialect. | CORE + carve-out |
| **R8** | Flat Attr wire **deratified**; value extent must not be inference-only. | CHANGELOG + CORE banner 2026-07-19 |
| **R9** | S-batch: suffix stacking, empty `\|{}`, interp-as-key, blank/ws two-layer (R15), final-terminator disposition, etc. | CHANGELOG second batch 2026-07-19 |
| **R11** | Keep-everything at recognition where coherent; halt/reject is consumer menu. | CORE anomaly posture |
| **R12** | Unclosed emission order: content → `Unclosed*` → `End` (uniform). | CHANGELOG 2026-07-18 |
| **R13** | Micro-batch: UnclosedInlineDirective/Raw; nameless `!{`@EOF → prose `Text "!{"`; empty forced-text `:a \` ≡ empty string; `<>` interim BareValue+NoDialectsLoaded; EOF≡eol+full-dedent for remaining edges. | CHANGELOG 2026-07-18 |
| **R14** | Duplicate definitions: document-layer menu `error \| allow-if-identical \| first-wins \| last-wins \| keep-all` (+ optional warn); default **error**. | CORE References; greenfield convergence |
| **R15** | Blank/ws two-layer: non-protruding blank/ws → `BlankLine`; past content-base → prose; etc. | CHANGELOG S6 |
| **R16** | Empty closed identity/brackets → nil key (not empty list); `[ ]` → empty array. | CHANGELOG empty-brackets |
| **R17** | Array items use full value rules (refs/interps allowed). | CHANGELOG §1.8 |
| **R18** | Multiple suffixes stack (`\|field?!`). | CHANGELOG S1 |
| **R19** | Empty `\|{}` valid empty anonymous embedded. | CHANGELOG S4 |
| **R20** | Framed ` ; ` inside `\|{…}` **out for now** (bare `;` literal); revisit with dialects. | CHANGELOG alpha.1 |
| **R21** | Bare numeric recognition frozen to **integer + float** only. | CHANGELOG 0.8.0-alpha.1 |

Attribute-model nail-downs (stacking, flags, node values, scan, bare-token boundary, …) remain in CHANGELOG 2026-07-15/16 — carry by that batch when authoring SPEC; not re-enumerated here.

---

## Operator reaffirmations (present 0.10 seed)

| ID | Holds | Provenance |
|----|--------|------------|
| **L5** | Rational/complex **not** bare core scalars → dialect/envelope when specified. | Reaffirms **R21** + greenfield consensus; not a new invention |

---

## Operator / panel-lean closes (2026-07-21)

High-consensus greenfield + pipeline leans, landed thin. **Overturn freely** via PROCESS if wrong. History/life stays in vault.

### Wire & fixtures

| ID | Holds | Why (short) |
|----|--------|-------------|
| **W0** | **Sufficiency / no-reachback** is WIRE law at stage boundaries: each stage’s product must suffice for the next without consulting earlier products (source bytes, re-derived indent). Recognition→assembly is the first instance. | Text-wire (R1) is the partial instance; deratification (R8) is the exhibit. Stage *payloads* still demand-shaped (OPEN/spikes). |
| **W1d** | Attribute values are **self-delimiting** (explicit value extent on the wire). Inference-only extent stays void (R8). | Direction only — exact event spelling/encoding remains open until utils/paths pull detail. |
| **W2** | Wire refresh is **phased**: value-extent fix first; broader Text-role/vocab refresh named backlog inside WIRE. | Realistic; unblocks grammar without boiling ocean. |
| **W3** | References: **interim raw** after `@` for first gate; structured when shared identity machinery makes it cheap. | Paths will force the question. |
| **W4** | Warning codes: **SPEC vocabulary + generator derivation** (both); must agree. | Descent already partial-derives. |
| **W5** | Prefer **one Text** + enclosing brackets for role; escalate to distinct roles only if fold/assembly still can’t classify. | Coherent after W1d. |
| **C6** | Fixtures that need it carry a **recognition-verdict** field (e.g. `result: incomplete`); incomplete-input is not an event (R2). | Pairs with C5 profiles. |

### Language

| ID | Holds | Why (short) |
|----|--------|-------------|
| **L2** | **No Core in-string escapes**; close at next same quote; embed the other quote kind. Positional `\` stays pure. | 2a/3b lean; doubling collides with list `["x""y"]`. |
| **L6** | Attr-under-attr **kept shape**: offending line is **text of the open value** + error (status already R6). | Keep-everything; teaches named-carrier idiom. |
| **L7** | Comment continuation strip uses **content-base shape** (first continuation line sets strip column). | Same mental model as prose/raw bodies. |
| **L4** | Tab in indentation: **keep** as text of current owner (best-effort); **Warning** (under **L0**); **not** line-lost. | Rejects live CORE “line lost.” |
| **S8** | Raw `!:label: ` with empty same-line body → **empty body** (not “no body”). | Uniform “after separator is body.” |
| **S11** | Inline raw `!{:kind:…}` in value position → **flow segment** (inline-brace principle). | Matches `*{`. |
| **S13** | Mixins remain **host experiment**; Core specifies nothing required. | All greenfields. |
| **S14** | Until paths: keep ref **(name, key, traits)**; **no incremental growth** of the tuple. | Avoid path debt. |
| **S15** | Pragma / filename designator: **OPEN stub** only for now. | Not day-one law. |
| **S16** | Markdown four layers: **companion stub**, not full Layer-1 in core day one. | Above recognition. |

### Packaging (authoring layout)

| ID | Holds |
|----|--------|
| **P1** | Author new suite under **`v2-spec/`** until cutover; live `spec/` stays oracle/record. |
| **P2** | Parallel agents OK under PROCESS (areas propose; class-qualified closes). |
| **P3** | Thin non-normative **GRAMMAR** extract OK day one; **SPEC wins** on conflict. |
| **P4** | Pedagogy day one: **outline only**. |
| **P5** | Dialects day one: **thin stubs or pointers**, not full specs. |

### Severity & root attr (2026-07-21 panel-lean)

| ID | Holds | Why (short) |
|----|--------|-------------|
| **L0** | **Error = loss only.** If every author-visible byte is kept as structure or Text, severity is **Warning** (unless a more specific rule names Error for *absent intended value* — e.g. plain `:key` → Nil+Error under R6). | Mechanically checkable; matches keep-everything and 2a; avoids “illegal geometry” taste. Schema/CI “fail on error” means *loss*, not style. |
| **L1** | Root-level `:key` (no owning Element): **Warning** + keep as **document-level Text** (including `:`). Not a free-floating Attribute in the ADM. | Attributes are edges of Elements; no phantom owner. Bytes preserved → Warning under L0. Portable meaning: none — do not rely on root attrs as data. |

### Deferred design (explicit, thin)

| ID | Holds |
|----|--------|
| **S9** | BlankLine vs dedent **placement** deferred; consumers should follow ornamentation / SEMANTICS, not stream order alone. |
| **S17** | Float semantic equality is a **Host profile** (or omit from Core equivalence); not Core bit-law. |
| **S18** | Inline-comment framing whitespace: **preserve** both framing spaces on strip (live CURRENT) until dialects revisit. |
| **D-pack** | Document packaging for the suite is **`{ content, anomalies, result }`** with `result ∈ { complete, incomplete-input }` (**R2**, **C6**). Equivalent API shapes allowed if information-equivalent. |
| **N-pos** | Canonical name for recognition state: **Structure Position** (3b). Alias “open position” (2a) allowed in prose once; new suite text SHOULD use Structure Position. |
| **N-scan** | Canonical name: **Line Scan** (3b). Alias “the scan” (2a) allowed once; new suite text SHOULD use Line Scan. |

---

## Steward marks (post-gathering, 2026-07-21)

| ID | Holds | Cite |
|----|--------|------|
| **PATH-1** | **Cross-document addressing is in scope for path design** ("documents in path are definitely in scope"). Overrules the scenarios corpus's document-scope-boundary lean; path design must not foreclose multi-document addressing. | STEWARD-CALLS #4, jaw 7/21; `udon-needs/01-ideation/02-provenanced/commentary/I2-scenarios-witness.md` |

## Steward marks (three-arc fork, 2026-07-21/22 evening session)

| ID | Holds | Cite |
|----|--------|------|
| **C7** | **`v2/current-0.9.1-spec/` is the consolidation *baseline*, not the C0/C2 successor.** Joseph forked three arcs: (1) a 0.9.1-consolidation suite as the clean base of operations ("a base of operations that is not crufty… doesn't require sending agents to 4 different places"), consolidating current law + best greenfield organization + defining-udon pillars, with carve-outs carrying their demand-side reasons; (2) the `udon-needs/02-tooling-needs/` synthesis monograph; (3) informed spikes after 1+2. **C0–C2's 0.10 greenfield-replacement line is unchanged** — 0.9.1 is the floor it launches from. No work continues on the 0.9.0-alpha.x route; old `spec/` remains record/oracle until cutover ("I need to not worry right now about oracles or gates"). | jaw, this session (2026-07-21/22); relayed by Fable-parent. Resolves review-B finding M1 (`current-0.9.1-spec/.reviews/review-B.md`). |

## Steward marks (2026-07-22 — conventions ruled in session)

These are **cross-cutting authoring conventions**, not language law; they bind
any agent writing in this estate's markdown corpora (and are echoed in
`udon-needs/CLAUDE.md` for the agents who work there).

| ID | Holds | Cite |
|----|--------|------|
| **X1** | **Segment references** are written `[[stem\| #stem]]` — no path, no filename suffix, one space after the pipe so Obsidian renders the display as a tag. Cross-corpus into ASF: `[[stem\| #asf/{aat,tst,llm,eli}/stem]]`. Future namespaces as needed (`#logos/…`, `#vivia/…`, harness later). Relocation-stable by construction: the reference keeps working if the corpus is interned into ASF. Implies archema-global stem uniqueness — acceptable; collisions are self-evident in a flat `src/`. | jaw 2026-07-22; settles the `volume:slug` row ASF's FORMAT left TBD |
| **X2** | **`#` is a canonicity marker, not a link style — reserved for canonical segments only.** Project documents (ledgers, specs, companions) take the plain form with a prose label: `[[DECISIONS.md\|design ledger]]`. Suffix optional there; the load-bearing difference is the absence of `#`. | jaw 2026-07-22 |
| **X3** | **Never wrap a slug in back-ticks when a reference is meant** — a backticked slug "is the worst of all worlds": renders poorly, invisible to tag statistics and search, not clickable, cannot jump. Code-ticks are for literal code and literal syntax examples only. | jaw 2026-07-22 |
| **X4** | **`## Working Notes` is an unconstrained in-file side-car.** Not canonical, not part of any deliverable, and **not bound by the rules that bind body prose** — a note may repeat a downstream claim, rely on a downstream segment, and discuss anything at any length. It is for open work, in-progress thinking, and ideas whose routing and disposition aren't clear yet. The single prohibition: it is **not a historical log** — that is git and the relevant CHANGELOG. | jaw 2026-07-22 |
| **X5** | **Body prose may point at a downstream segment** to anticipate a question that segment addresses; it **may not** restate that segment's claim in a form that might not stay evergreen, and it **may not rely on** it — with one exception, **appendix segments may be depended on in reverse** ("the derivation this relies on is in appendix segment xyz"). Working Notes are exempt (X4). | jaw 2026-07-22, correcting an over-tight reading |
| **X6** | **Terminology:** a **chapter** is a container (an outline heading plus its table of segments); a **segment** is a file carrying one claim. Corpora where chapter currently equals file are transitional and need no renaming — the words survive the eventual split. | jaw 2026-07-22 |

## Overturns

*(none yet)*

---

## Pointers

- Open work: [OPEN.md](OPEN.md)  
- Deliberation seed: [udon-needs/pipeline-discussion.md](udon-needs/pipeline-discussion.md)  
- Archive map: [.archived/INDEX.md](.archived/INDEX.md) (PROCESS, FIXTURES, session vault, spikes — all there)  
- CHANGELOG: [`../spec/msc/CHANGELOG.md`](../spec/msc/CHANGELOG.md)
