# OPEN — live questions only

**Status:** 2026-07-22. Closed → [DECISIONS.md](DECISIONS.md). Language carve-outs with their demand-side reasons now also live in [`current-0.9.1-spec/CARVEOUTS.md`](current-0.9.1-spec/CARVEOUTS.md) — that register is the fuller statement for anything spec-shaped; rows here are the ledger-level index.

> **How to hold these rows (jaw, 2026-07-28):** the questions here — especially the 2026-07-28 probe/seed sections — are posed against a *current (already stale) snapshot* of spec-vs-path/schema/meta thinking, and several "shouldn't be asked yet on a spec that hasn't been written yet. It's precisely our current work that will make the answers self-evident in the future." Treat anything open here or in the spec as **open for guidance from the schema/path/meta territory work** — valuable for ideation pros/cons, not a pending-steward-ruling queue. Do not press the rows as binary calls; expect several to dissolve or become self-evident as the territories mature. And the cost of pressing them early is not merely rulings-to-be-overruled — that is the *lucky* case: "More likely it would have become highly constrictive thinking that served some arbitrary hypothesis turned concrete instead of serving the project or truth or the agents using the tools" (jaw, 2026-07-28).

---

## Still open

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **ML** | Multi-line / line-bound policy — **possibly a dissolved question**: if `[…]`/strings/etc. are sugar for dialect-typed captures, each capture's grammar owns its own line-span, and there is no per-construct table to close. Do **not** close in the greenfield per-construct framing. | **WAIT-DEMAND** (reframed) | Array-as-sugar insight + framing critique: pipeline-discussion (Joseph, 2026-07-21 morning). Old strawmen: [.archived/second-pass/OPEN-ML-STRAWMEN.md](.archived/second-pass/OPEN-ML-STRAWMEN.md) — archaeology of the old framing, not a decision table to finish. |
| **S3** | Multiple keys surface + uniqueness + @ resolution | WAIT-DEMAND | Paths spike §6; Joseph lean valid. |
| **S4** | `InconsistentIndentation` prose-only? | STEWARD / fact | Grammar intent. |
| **S12** | Nested envelope routing | WAIT-DEMAND | With dialects. |
| **W1e** | Exact Attr value **event encoding** | WAIT-DEMAND | Direction **W1d** closed. Agent-utility + paths may pull. |
| **IND** | **No-sibling indentation default** — when a tool computes insertion indentation and the destination has no siblings to read from, no ratified rule names the default unit. Needs a spec sentence. | agent-suggested (open) | Demand evidence: `udon-needs/01-ideation/02-provenanced/copies/I2-scenarios/03-modifying.scenarios.udon` ("nothing ratified names the default unit"); STEWARD-CALLS #5, Joseph 7/21: add unless redundant — verified not redundant (CORE's 2-space note is non-normative style only). |

---

## Demand harvest (not pins)

Provisional proposals from spikes — **re-open in spikes**, promote to DECISIONS only when ready:

| Source | Pointers |
|--------|----------|
| [.archived/second-pass/spikes/paths/NOTES.md](.archived/second-pass/spikes/paths/NOTES.md) §8 | D1–… boundary demands (relational lookup, terminators, wire W3 pressure) — parked pending the needs map |
| [.archived/second-pass/spikes/agent-utility/NOTES.md](.archived/second-pass/spikes/agent-utility/NOTES.md) §8 | P-A…P-H (stage products, partial-doc verdict, edit tool, ornamental out of happy path) — parked pending the needs map |

### Already absorbed (do not re-open as OPEN rows)

| Demand | Absorbed as |
|--------|-------------|
| agent-utility **P-B** (partial-doc verdict) | **C6** / **R2** / **D-pack** |
| agent-utility **P-A** (stage products) | **W0** direction (sufficiency at product boundaries); the archived PIPELINE stage picture is *not* carried forward — see pipeline-discussion |
| agent-utility **P-D** (ornamental out of happy path) | PIPELINE ornamental criterion + SEMANTICS (direction) |
| paths **D1** / **D7** (interim raw `@`) | **W3** |
| paths **D9** (`at`/`all` convention) | Host/tool — not Core OPEN |

Still provisional (no pin): paths D2–D6, D8; agent-utility P-C, P-E–P-H; **P-G**/**ML** wait on demand scenarios.

---

## Open from the 2026-07-22 session

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **N-jargon** | Are `Structure Position` / `Line Scan` parser-jargon bleeding into the user-facing spec, against `defining-udon.md`'s isolation principle? A cross-substrate reviewer (agy/Gemini) argued yes and proposed author-centric names. The names are ledger-ruled (**N-pos**, **N-scan**), so overturning is a steward call. | STEWARD | `current-0.9.1-spec/.reviews/STEWARD-FLAGS.md`; review-agy finding 1 |
| **IND-2** | Should the spec name a default indentation unit for *automated generation* (not human authoring)? New demand evidence: without one, different tools pick different defaults and thrash a file's indentation across agents. Sharpens the existing **IND** row rather than replacing it. | STEWARD | review-agy finding 3; attached to IND |
| **FIX-FRAME** | The 0.9.1 suite added a suite-level MUST NOT on fixtures that pin the interim multi-line behavior as *language* behavior (only "PINS CURRENT PARSER" framing allowed). It edges normative and is flagged for ratification-or-revert. | STEWARD | `current-0.9.1-spec/DELTAS.md` organizational paragraph; review-grok L2 |
| **SEG-SPLIT** | When do the tooling report's chapters split into constituent claim segments (ASF style)? Joseph expects to feel compelled "within the next few days"; the readiness signal is a deepening cycle ending with *"the structure held"* as a finding. | steward-timed | `udon-needs/02-tooling-needs/notes/for-OUTLINE.md` §"The coming segmentation" |

---

## Open from the 2026-08-07 session (identity & attribute-shape)

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **ATTR-GROUP** | Prefix-DRY grouping sugar for attribute keys (Stylus-style nesting that desugars to flat keys) — attributes-of-attributes proper are rejected (K4), but Joseph: "I still don't mind it as basic nested naming convention to DRY the prefix." Separator/spelling is part of the question: `-` and `/` are both legal key-continue characters, so neither is lexically guarded; `/` is the existing namespacing convention. | WAIT-DEMAND | jaw 2026-08-07; spike (archived: `.archived/attr-as-element-spike-2026-08-07.md`, namespace fork §2) |
| ~~**ATTR-ITEMS**~~ | Closed same day → DECISIONS **K6** (explicit nil, four-state model kept) + **K7** (first-line value position). | closed | jaw 2026-08-07 |
| **UNIF-PASS** | The K5 unification's spec-text authoring pass, with its remaining unadjudicated sub-rulings (spike §1.1/§3/§4): fate of the *same-line* trailing-text Warning on block attribute lines (deeper content is warning-free; the sameline join-hazard case was never ruled); do flags take content; identity-interior restrictions beyond block-forms (inline forms / framed ` ; ` in brackets — unruled); directive details (`!else` has no adjacency slot in value position pre-unification; flag rule 2 should name `!name`; "anywhere an element can" excludes list items/brackets); MODEL `Assignment`/SEMANTICS rewording ("exactly one value per assignment" is now contradicted by K5). **K10 adds**: §6.4's terminator-set rewrite (unquoted text value = quoted string closing at space+block-start / framed ` ; ` / EOL / context terminator) and rescoping §2.2's commit-to-prose to block text only. **K9 adds its spec-text restructuring here too**: `$main` sugar row (MODEL §3.1) + the text-law scope line (MODEL §6: `$main` is not text material) + InlineElement value kind (MODEL §4) + CORE §2.2/§5.3/§6.3–6.8/§7.1 rewrites + SEMANTICS forbidden-changes row (tail reflow is a semantic edit) and §4 example revisions — draft record in `theory/to-integrate/primary/K9-DRAFT-2026-08-08.md`. *(K8, 2026-08-08, closed three former items here: the sugar door-shut sentence, L6's severity → Warning, and the §6.7/§6.8 seam — all landed in CORE.)* | authoring pass | spike (archived: `.archived/attr-as-element-spike-2026-08-07.md`) |

## Open from the 2026-08-08 session (parked pending interleaved-attributes completion)

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| ~~**ESC-BREAKOUT**~~ | **Closed 2026-08-08 → DECISIONS K10** (same day): framed `\` is one of the terminating markers for unquoted text values, so the multi-token breakout works (`:a some words \ and body` → a="some words", `$main`="and body"); the single-token case was already law. Original research question below, kept for the record: | closed → K10 | jaw 2026-08-08 |
| | *(record)* Should a framed `\` terminate an already-**committed** flow value on a sameline attribute, handing the rest of the line to the element (its content, or `$main` under the proposal in flight)? **History (jaw 2026-08-08, verbatim intent):** "One of the primary uses of `\` was to break out of attribute-value pairs on sameline. We had to put it in place when we started associating the text with the most recent attribute instead of the prior 0.8 and earlier behavior … where `\|e :a x y z` would assign 'x' as the value for `:a`, and 'y z' is the child text for `\|e`. … when we changed it, it made it more visually coherent, but it became difficult to say 'and now the body line'." **Precise current state (verified against 0.9.1 CORE §6.4/§4):** the breakout *works after a single bare token* (`\` is a guard-confirmed boundary marker: `\|e :a x \ y z` → a="x", element text "y z") but *cannot fire once flow has committed* (two+ bare words → flow runs to EOL; mid-flow `\` is literal; framed ` ; ` stays live). If the multi-token breakout was ratified intent, CORE-as-written is buggy — research the 0.8/0.9 CHANGELOG + old parser before ruling. Interacts with: `C:\Users`-style literals (the framing requirement is the guard), the `$main` proposal, and case 4 of the interleaved-attributes worksheet. **Deliberately parked**: jaw — "so we can continue focusing on the interleaved attributes concept until it's complete first." | STEWARD / research | jaw 2026-08-08, this session |

## Open from the 2026-07-28 schema seed (design-territory; no ruling implied)

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **DEBT-DISCHARGE** | UDON's schema position (defer-to-read judgment) plus the estate's measured "contraction never happens" suggested **monotonically accumulating, never-discharged read-time debt**. **Joseph brainstorm O4 (pre-validation):** the never-contracts observation is a *tooling-absence symptom*, not a law — so the primary discharge route is a third one the original framing missed: **make contraction affordable** (declared old/new coexistence — `!{was: site}`-style — with a safe-removal end state), which was rowan's intended core affordance. Remaining open: the adjudicator artifact (O5), the coexistence-window semantics, and pricing at corpus scale. | WAIT-DEMAND (design) | seed §1.0; discussion-thoughts O1/O4/O5 (`theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon`, pre-validation); doc-store report §6.6 |
| **LINEAGE** | **Identity-over-time has no owner.** `!{was: site}`-style declarations (the O4-brainstorm mechanism) say neither what a value *means* (dialect) nor what is *allowed* (schema) — they claim **identity across a rename**, and CORE §1.1's owner table (Projection/Host · Constraint/Schema · Exotic-typing/Dialect · Resolution/Host · Duplicates/Document-layer · Mixin/Host) has no row for it. An unowned mechanism is how layer boundaries get traded by accident. Two candidate placements with consequences are laid out in the schema seed (dynamics-tier: degrades to an inert no-op when unresolved, but not path-addressable — collides with the annotation demand; designated `$was` attribute: addressable and constrainable by existing law, but visible data to every consumer). | STEWARD | schema seed (O4/O5 integration pass); discussion-thoughts O4/O5 (pre-validation) |
| **GOV-REGIME** | Contraction safety is decidable only as far as the adjudicator's observability reaches (an RDBMS knows a column is unused because every write passes one gate; a document corpus generally cannot) — implying **governed vs wild document regimes**: governed debt discharges, wild debt really is monotonic, and a document leaving governance silently acquires a permanent untracked obligation. Whether regime membership should be explicit lands on **PRAGMA**. | WAIT-DEMAND (design; attaches to PRAGMA) | schema seed, same pass |

## Open from the 2026-07-28 terminator probe (measured; three-way facts, no verdicts)

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **REF-SLASH** | Does `/` continue a *reference* name? The descent grammar's reference name-class omits `/` while the element name-class includes it; CORE §5.2's identifier rule (`XID_Continue` + `-` + `/`) doesn't distinguish. This single fact decides whether `@`-prefixed path-*to* forms and the include primitive are reachable at all. | STEWARD / fact | `v2/spikes/paths-ideation/terminator-table.md`; ~130 probed cases |
| **REF-BRACKET** | Is the `@[…]` selector bracket a raw capture or a value slot? Joseph's `@[core://… # main-findings]` include sketch parses *perfectly* today as one Reference — but only via the interim raw-after-`@` wire (W3), not because CORE says so. | STEWARD | same file |

## Open from the 2026-07-28 markdown probes (measured; three-way facts, no verdicts)

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **ROOT-BASE** | Does document-root block text have a content base? CORE §7.2 is written entirely in terms of *"the element"* and never states the root case; the current parser silently discards all leading whitespace on root text lines (no anomaly), and the same gap yields 5 spurious fence recognitions (indented fences in list items). A spec gap the parser filled silently — needs a ruling, not a bug-fix-by-default. | STEWARD | `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` (divergence 1); measured over the full 652-example CommonMark corpus |
| **SEMI-BASE** | Framed ` ; ` in block text *at* the content base: CORE §8's position table says it comments there; the parser only honors it on an element's sameline tail. Decides whether ` ; ` is a live collision-table hazard — markdown prose containing `" ; "` is **silently truncated** under CORE-as-written, safe under the parser. Both readings internally coherent. | STEWARD | same file (divergence 2) |

## Explicitly not OPEN

CARRY + 2026-07-21 closes (incl. **L0**, **L1**, **L4**, W0/W1d, …) → DECISIONS.  
Path *language design* → paths spike, not silent SPEC growth.
