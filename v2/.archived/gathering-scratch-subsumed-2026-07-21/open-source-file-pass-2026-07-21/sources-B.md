---
pass: open-source-file-pass-2026-07-21
author: Grok (sources-B)
date: 2026-07-21
status: prospective source map only — no content mining, no body extracts
posture: inclusive / overlap-welcome; prefer listing when unsure
scope: end-user, agent, library-consumer *needs* that might later feed a Parsing Framework
---

# Sources-B — prospective files & trees for demand-side gathering

**What this is.** A path map of places where needs, usage situations, tool desires, consumer friction, schema/path/template/edit/stream ideas, etc. *might* live. Later mining opens these; this pass does not synthesize needs or copy bodies into the gathering tree.

**What this is not.** Coverage of the quarantined overprescribed pass (`01-ideation/_quarantine/`). Those extracts are not the map of coverage. Sibling maps (`sources-agentic-tooling`, `sources-schema-versioning`, quarantined `sources-udon-repo-design-ux` / `sources-live-consumers`) are welcome overlap territory, not exclusions.

**Path style.** Absolute paths under `~/src/...` (and a few outside). Trees are listed when the unit is a whole directory; key files called out when a later miner should open them first.

---

## 0. Orientation for this gathering effort (read for process, also mineable)

| Path | Why it might matter | Provenance |
|------|---------------------|------------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/README.md` | Demand-side flow (1)–(8); why needs precede Parsing Framework | Live v2 home |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Primary deliberation: fold → accumulation → demand inversion → morning sampling list (S1–style situations) | 2026-07-21 discussion record |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/needs-map.md` | Seed situations S1–S12 + standing harvest queue | Fable reseed 2026-07-21 |
| `/Users/josephwecker-v2/src/udon/v2/OPEN.md` | WAIT-DEMAND open questions (ML, paths S3, dialects S12, wire W1e) + pointers into spike demand tables | Graduated live ledger |
| `/Users/josephwecker-v2/src/udon/v2/DECISIONS.md` | What is already decided (so mining doesn't re-litigate as "need") | Live ledger |
| `/Users/josephwecker-v2/src/udon/defining-udon.md` | Project documentation philosophy; outer-layer needs vs impl jargon | Umbrella orientation |
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Live consumer registry + migration surfaces (keys, dates, tools owed) | Rescan 2026-07-16 |

---

## 1. Lived friction & wishlists inside the UDON umbrella (high density)

These are "I reached for X and didn't have it" or open capability lanes — closest to raw demand without being full design docs.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/TOOLING-WISHLIST.md` | Felt needs while working grammar: `udon events`, `udon ast`, roundtrip checkers, JSON round-trip, fmt | Joseph 2026-07-19 scratch |
| `/Users/josephwecker-v2/src/udon/TODO-UTILS.md` | Utils payload: accessors, coerce, serialize/round-trip, skeleton paths view, **udon guard**, paths MVP, linter/hinter, conversion, fmt tabled | Live lane; reboot drain |
| `/Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md` | Agent tool suite, edit-tool critical path, grammar-constrained gen, mid-gen feedback, annotations, handoff/memory, self-chunking | Live agent UX lane |
| `/Users/josephwecker-v2/src/udon/ux/TODO-HUMAN-UX.md` | Human editor/highlighting/Obsidian needs | Live human UX lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-AUX.md` | Path syntax + schema syntax + schema-by-exemplar + aspirational designators — **critical path to edit tool** | Spec aux lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md` | Core open items that may encode deferred needs (cardinality, multi-key, …) | Spec core lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-OTHER.md` | Non-core (pragma/schema bind, dialects, …) | Spec other lane |
| `/Users/josephwecker-v2/src/udon/spec/TODO-TEXT-WIRE.md` | Wire/text reconstruction contract as user-facing guarantee | Wire lane |
| `/Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md` | Parser residual vs CORE — where consumers currently hit lag/surprises | Core residual |
| `/Users/josephwecker-v2/src/udon/core/TODO-PARSER.md` | Parser/API substrate notes (spans, streaming) | Core |
| `/Users/josephwecker-v2/src/udon/TODO-META.md` | Literate fusion, fixtures-as-UDON, dogfood bootstrap traps | Meta lane |
| `/Users/josephwecker-v2/src/udon/TODO-PUBLISHING.md` | Publish/crate surface for library consumers | Publishing |
| `/Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md` | Generator needs driven by UDON grammar (line discipline, state templates, DESC-as-UDON version pin) — library *producer* of parsers | Descent submodule + standalone twin |
| `/Users/josephwecker-v2/src/descent/TODO.md` | Standalone descent repo TODO (may diverge slightly from pin) | Independent repo mirror |

---

## 2. Design corpus (ahead-of-spec ideation — mine as *demand statements*, not as architecture)

Whole tree is prospective; callouts are first-open candidates.

### 2a. Tree unit

- `/Users/josephwecker-v2/src/udon/design/` — full design exploration tree
- `/Users/josephwecker-v2/src/udon/design/examples/` — intended usage shapes (operata, ash-like, schema-dsl, practices-gotchas, …)

### 2b. High-signal design files

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/design/udon-agentic.md` | Design of record for agent tool suite (glance/focus/propose/apply/…) |
| `/Users/josephwecker-v2/src/udon/design/UDON-AGENT-TOOLS.md` | Dec-2025 brainstorm; merge/diff/timeline ideas not all folded into udon-agentic |
| `/Users/josephwecker-v2/src/udon/design/agentic-ux-principles.md` | WHY layer for agent tools (principles that tools must re-derive against) |
| `/Users/josephwecker-v2/src/udon/design/udon-paths.md` | Paths ideation (TODO-AUX: stale as *design authority*, still mineable for situations) |
| `/Users/josephwecker-v2/src/udon/design/udon-ast.md` | AST / SourceInfo / skeleton-view ideas |
| `/Users/josephwecker-v2/src/udon/design/udon-guarantees.md` | Gatekeeper / integrity / "what must not be silently wrong" |
| `/Users/josephwecker-v2/src/udon/design/udon-schema-exploration.md` | Early schema exploration |
| `/Users/josephwecker-v2/src/udon/design/schema-notes-2026-07.md` | Short schema design note (surfaces, orthography, forks) |
| `/Users/josephwecker-v2/src/udon/design/schema-workbench-2026-07.md` | Schema survey index (rowan, corpus, guarantees) — shortcuts rediscovery |
| `/Users/josephwecker-v2/src/udon/design/markdown-layers.md` | Four distinct markdown *user situations* (inside prose / doc schema / convert / render) |
| `/Users/josephwecker-v2/src/udon/design/markup-feature-matrix.md` | Competitive/feature matrix → implied missing capabilities |
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Product positioning / who it's for |
| `/Users/josephwecker-v2/src/udon/design/UDON-AS-ACP-FORMAT.md` | Agent Context Protocol as UDON payloads (streaming, annotations, handoffs) |
| `/Users/josephwecker-v2/src/udon/design/AGENT-CONTEXT-PROTOCOL.md` | ACP companion notes |
| `/Users/josephwecker-v2/src/udon/design/GRAMMAR-CONSTRAINED-GENERATION.md` | Guaranteed-valid generation from models |
| `/Users/josephwecker-v2/src/udon/design/file-naming.md` | Designator / type-in-filename conventions (aspirational schema hook) |
| `/Users/josephwecker-v2/src/udon/design/composite-types.md` | Composite type needs |
| `/Users/josephwecker-v2/src/udon/design/attribute-model-*.md` | Attribute model evolution (what consumers tripped on) |
| `/Users/josephwecker-v2/src/udon/design/descent-experience-2026-07.md` | Authoring *descent* (UDON-as-grammar) friction |
| `/Users/josephwecker-v2/src/udon/design/desc-design-principles.md` | Principles for `.desc`/descent-in-UDON |
| `/Users/josephwecker-v2/src/udon/design/semachrome.md` | Semachrome/coloring as product surface |
| `/Users/josephwecker-v2/src/udon/design/examples/schema-dsl.udon` | Schema-as-UDON sketch |
| `/Users/josephwecker-v2/src/udon/design/examples/operata-intent-graph.udon` | Intent-graph domain as consumer shape |
| `/Users/josephwecker-v2/src/udon/design/examples/ash-like-*.udon` | Rowan/Ash-shaped resource schemas (first waiting customer sketches) |
| `/Users/josephwecker-v2/src/udon/design/examples/practices-gotchas.udon` | Authoring practices & gotchas |
| `/Users/josephwecker-v2/src/udon/design/examples/archema-operata.udon` | Cross-project domain document |
| `/Users/josephwecker-v2/src/udon/design/examples/cheatsheet.udon` | Pedagogy/cheat sheet as document |
| `/Users/josephwecker-v2/src/udon/design/examples/comprehensive.udon` | Kitchen-sink usage |

---

## 3. Day-in-the-life scenarios & usability evidence (usage situations)

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/test/scenarios/` | **Whole tree:** BDD-style multi-agent day (understand/diff/modify/contend) on pseudo-real corpus | Joseph commissioned 2026-07-16 |
| `/Users/josephwecker-v2/src/udon/test/scenarios/README.md` | Intent of the corpus + provisional path syntax note | Same |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/01-understanding.scenarios.udon` | Morning read journeys | Same |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/02-diffing.scenarios.udon` | Midday diff journeys | Same |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/03-modifying.scenarios.udon` | Afternoon write/edit journeys | Same |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/04-multi-agent.scenarios.udon` | Contention, handoff, evening ledger | Same |
| `/Users/josephwecker-v2/src/udon/test/scenarios/corpus/` | Seven pseudo-real docs mirroring live consumers | Same |
| `/Users/josephwecker-v2/src/udon/test/usability/` | Dec-2025 empirical agent usability harness (stale models/spec; still evidence of *what was tested as needs*) | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/enablement-synthesis.md` | Synthesis of enablement findings | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/results/AGENT_FEEDBACK.md` | Agent free-text feedback on UDON | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/test_definitions.rb` | What tasks were considered "usability" | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/realistic_tests.rb` | Realistic task definitions | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/test/usability/ETHICS.md` | Constraints on agent testing | Dec 2025 |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Fresh-model review feedback (uncertainty markers, draft marking, …) | Archive |

---

## 4. Live consumers (actual documents + host project process)

### 4a. Registry & scanners

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Inventory + exposure + migration triggers |
| `/Users/josephwecker-v2/src/udon/bin/find-consumers` | How consumers are discovered/rescanned |

### 4b. Live `.udon` documents (usage, not design)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Founding adopter process map; heavy `[key]` / process suffixes |
| `/Users/josephwecker-v2/src/archema-io/vivarium/DECISIONS.decision-log.udon` | Largest growing decision log; temporal attributes heavy |
| `/Users/josephwecker-v2/src/archema-io/vivarium/LEXICON.udon` | Lexicon as structured document |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/PROCESS.udon` | Process norms; known reflow/sigil-promotion field hazard |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Ordinum taxonomy document |
| `/Users/josephwecker-v2/src/autopax/taxonomy.udon` | Autopax taxonomy live in UDON |

### 4c. Consumer-host process & design (how they *want* to use structured docs)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/toolchain.md` | Toolchain expectations around vivarium docs |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/ARCHITECTURE.md` | Architecture of consumer project |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/design/` | Design system docs (may imply doc formats) |
| `/Users/josephwecker-v2/src/archema-io/vivarium/FORMAT.md` | Format conventions for vivarium |
| `/Users/josephwecker-v2/src/archema-io/vivarium/ASSUMPTIONS.md` | Working assumptions |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/` | Whole review tree: lifecycle of theory content, naming, tooling utilization |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/09-tooling-automation-capability-utilization-findings.md` | Explicit tooling utilization findings |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/09-tooling-automation-capability-utilization-reflection.md` | Reflection companion |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/markdown-first-pipeline.md` | Markdown pipeline as competing/adjacent workflow |
| `/Users/josephwecker-v2/src/archema-io/asf/msc/build-markdown-design.md` | Build/markdown design needs |
| `/Users/josephwecker-v2/src/archema-io/asf/FORMAT.md` | ASF format commitments |
| `/Users/josephwecker-v2/src/archema-io/asf/LEXICON.md` | Lexicon practice (pre/alongside LEXICON.udon) |
| `/Users/josephwecker-v2/src/archema-io/charter/concept-matrix.md` | Cross-repo concept matrix (candidate future UDON) |
| `/Users/josephwecker-v2/src/autopax/TAXONOMY.md` | Markdown sibling of taxonomy.udon |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/` | ADR corpus (candidate class for UDON migration per CONSUMERS watchlist) |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/008-yaml-and-schemas.md` | YAML+schemas ADR |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/010-markdown-parsing-and-validation.md` | Markdown parse/validate needs |
| `/Users/josephwecker-v2/src/autopax/docs/ADR/002b-signum-schema.md` | Signum schema |
| `/Users/josephwecker-v2/src/autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md` | Session on YAML/schemas |

### 4d. Candidate future consumer classes (from CONSUMERS watchlist — find durable docs)

ADRs, Axiomata, Signa, Archema, Operata, Memorata, descent grammars (already UDON), A2A agent communications, mentoring-feedback, Loci — search/host trees when mining, not all live as `.udon` yet.

---

## 5. Spec companions & path/schema session packets

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/spec/CORE.md` | Authority for what exists; also where silence implies open needs |
| `/Users/josephwecker-v2/src/udon/spec/DYNAMICS.md` | Dynamics/template layer status & needs |
| `/Users/josephwecker-v2/src/udon/spec/MARKDOWN.md` | Markdown layer commitments |
| `/Users/josephwecker-v2/src/udon/spec/TIME-SPEC.md` | Temporal dialect (111 live date attrs waiting) |
| `/Users/josephwecker-v2/src/udon/spec/CORE-supplement.md` | Supplemental rulings |
| `/Users/josephwecker-v2/src/udon/spec/msc/CHANGELOG.md` | Rulings ledger — historical "why we needed X" |
| `/Users/josephwecker-v2/src/udon/spec/msc/adjudication-2026-07-paths-and-silences.md` | Path forks + silence handling session packet |
| `/Users/josephwecker-v2/src/udon/spec/msc/FULL-EBNF.md` | Illustration only — not authority, but may encode assumed capabilities |

---

## 6. Library / parser API surface (what embedders need)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/lib.rs` | Public crate surface |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/stream_tree.rs` | Streaming tree product (`TreeStream`) |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/tree.rs` | Tree API |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/span.rs` | Spans for edit tools |
| `/Users/josephwecker-v2/src/udon/core/udon-core/src/parser_pd.rs` | Pushdown parser (mid-parse state for agents) |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/stdin_parse.rs` | Current "see the wire" CLI sketch |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/gen_events.rs` | Event → fixture YAML sketch |
| `/Users/josephwecker-v2/src/udon/core/udon-core/examples/tree_parse.rs` | Tree consumer sketch |
| `/Users/josephwecker-v2/src/udon/core/udon-core/tests/stream_tree.rs` | Streaming tests as contract |
| `/Users/josephwecker-v2/src/udon/core/udon-core/tests/tree_api.rs` | Tree API tests as contract |
| `/Users/josephwecker-v2/src/udon/core/udon-wasm/` | WASM highlighting / autocolors engine (editor consumer) |
| `/Users/josephwecker-v2/src/udon/core/generator/` | Descent grammars as UDON (bootstrapping consumer of own format) |
| `/Users/josephwecker-v2/src/udon/core/fixtures/v0.9/` | What behavior is considered needed/pinned for 0.9 |
| `/Users/josephwecker-v2/src/udon/core/fixtures/exploratory/multi-line.yaml` | Multi-line exploratory needs |
| `/Users/josephwecker-v2/src/udon/core/fixtures/_wip/FINDINGS.md` | WIP fixture findings |

---

## 7. Human + editor UX implementations (product needs in code form)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/ux/README.md` | UX area map |
| `/Users/josephwecker-v2/src/udon/ux/obsidian-udon/` | Obsidian plugin (live human authoring surface) |
| `/Users/josephwecker-v2/src/udon/ux/tree-sitter-udon/` | Tree-sitter grammar + highlight queries |
| `/Users/josephwecker-v2/src/udon/ux/udon.tmLanguage.json` | TextMate grammar |
| `/Users/josephwecker-v2/src/udon/ux/vim/` | Vim syntax |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/` | Semantic coloring plan + 2011 archaeology |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/PLAN.md` | Autocolors product plan |
| `/Users/josephwecker-v2/src/udon/ux/autocolors/archaeology-2011/` | Historical color mapping (long continuity of "readable structure") |

---

## 8. Archived v2 demand spikes & night-spine archaeology

**Mine demand tables carefully** — supply-side PIPELINE ontology is *not* carried forward (see pipeline-discussion); agent-utility/paths §8 demand tables are explicitly parked for needs map.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/INDEX.md` | Map of archived first/second pass |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/DEMANDS.md` | Index of spike demand tables |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/NOTES.md` | Paths boundary demands D* (§8) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/sketches.udon` | Path syntax sketches |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/NOTES.md` | Agent-utility demands P-A…P-H (§8) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/FINDINGS.md` | Memory import as document substrate findings |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/` | Session vault extraction of recent UDON work sessions |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/` | Claude session extracts (orientation, greenfield, EOF, Obsidian HL, …) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/grok/` | Grok session extracts (incl. v2-spec night) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/SCHEMA.md` | Night-spine schema sketch (supply-side — mine only for *named needs*) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/OPEN-ML-STRAWMEN.md` | Multi-line strawmen (WAIT-DEMAND reframed; archaeology) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/PROCESS-FEEDBACK.md` | Process feedback on spine build |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/brownfield/BIG-PICTURE-2026-07-20.md` | Brownfield big picture |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/brownfield/DIRECTION-2026-07-19.md` | Direction notes |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-3a/new-spec/3-DIALECTS.md` | Dialect layer as clean-room need list |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-3b/new-spec/OPEN.md` | Clean-room open questions |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-3b/agents-thoughts.md` | Agent thoughts on greenfield |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-2a/new-spec/OPEN-QUESTIONS.md` | Earlier open questions |
| `/Users/josephwecker-v2/src/udon/v2/.archived/first-pass/greenfield-2a/feedback-from-*.md` | External model feedback on greenfield |

Copies of demand spikes also appear under quarantine for historical reconciliation only — prefer archived originals above.

---

## 9. Umbrella archive & pre-reboot estate (historical needs / defects as evidence)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` | Estate review + defect table (what hurt users/agents) |
| `/Users/josephwecker-v2/src/udon/_archive/REBOOT-PLAN.md` | Reboot plan (drained; still names intended capabilities) |
| `/Users/josephwecker-v2/src/udon/_archive/DECIDED.bak.md` | Pre-reboot decisions ledger |
| `/Users/josephwecker-v2/src/udon/_archive/FULL-SPEC-TODO.bak.md` | Dense predecessor TODO |
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | Analysis notes |
| `/Users/josephwecker-v2/src/udon/_archive/implementation-phase-2.md` | Impl phase needs |
| `/Users/josephwecker-v2/src/udon/_archive/implementation-status.md` | Status snapshot |
| `/Users/josephwecker-v2/src/udon/_archive/parser-strategy.md` | Parser strategy tradeoffs |
| `/Users/josephwecker-v2/src/udon/_archive/HARNESS-AUDIT-2026-07.md` | Harness audit |
| `/Users/josephwecker-v2/src/udon/_archive/eof-model-proposal-2026-07.md` | EOF as product contract |
| `/Users/josephwecker-v2/src/udon/_archive/TODO-EOF-refactor.md` | EOF refactor — streaming/schema/cardinality species distinction |
| `/Users/josephwecker-v2/src/udon/_archive/decisions-superseded/` | Superseded briefs (identity, fences, value dialects, …) — *why* each was needed |
| `/Users/josephwecker-v2/src/udon/_archive/spikes/` | CommonMark collision, explicit stack, prose collision |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/` | Ruby gem + `bin/{json,md,xml,yaml}2udon` conversion sketches |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/README.md` | What conversion surfaces were sold |
| `/Users/josephwecker-v2/src/udon/core/_archive/PARSER-GEN-HISTORY.md` | Generator history / product ambitions |
| `/Users/josephwecker-v2/src/udon/core/_archive/generator/2025-12-28-*.md` | Dec generator session notes |

---

## 10. Historical UDON lineage (`_ref/` — objectives older than the umbrella)

These encode *original* utility claims (templating, mixing, schema, API).

### 10a. Early udon project docs

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/udon/doc/objectives.asciidoc` | **Utility/beauty/performance objectives table** (templating 9, in-doc schema 7, language mixing 9, …) |
| `/Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc` | Feature ambitions |
| `/Users/josephwecker-v2/src/_ref/udon/doc/description.udon` | Self-description as early document |
| `/Users/josephwecker-v2/src/_ref/udon/doc/syntax.udon` | Early syntax as UDON |
| `/Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc` | Competitive comparison concerns |
| `/Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc` | Historical TODO |
| `/Users/josephwecker-v2/src/_ref/udon/README.asciidoc` | Project pitch |
| `/Users/josephwecker-v2/src/_ref/udon/examples/` | Early examples |

### 10b. udon-c era

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/NOTES.md` | Implementation notes / feature list (includes/config paths sketch) |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/DECIDED.md` | Early decisions |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/TODO.md` | Early TODO |
| `/Users/josephwecker-v2/src/_ref/udon-c/README` | C library pitch |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon_introspect.c` | Introspection as product surface |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon2xml.c` | Conversion surface |
| `/Users/josephwecker-v2/src/_ref/udon-c/test/doc.udon` | Early test document |

### 10c. Archived libudon / udon-ruby clones

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/libudon/PLAN.md` | Plan from libudon era |
| `/Users/josephwecker-v2/src/_ref/libudon/README.md` | Crate README |
| `/Users/josephwecker-v2/src/_ref/libudon/_archive/generator/` | Machine-era generator notes + udon-c-era.machine |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/` | Ruby gem archive (conversions, FFI) |

### 10d. Standalone descent (grammar author as UDON user)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/descent/SYNTAX.md` | Descent syntax (authoring experience) |
| `/Users/josephwecker-v2/src/descent/implementation-spec.md` | Generator product requirements |
| `/Users/josephwecker-v2/src/descent/README.md` | Pitch |
| `/Users/josephwecker-v2/src/descent/examples/` | Grammar examples including `udon_complete.desc` |
| `/Users/josephwecker-v2/src/descent/rust/spikes/udon-reader/` | Udon-reader spike (reading descent-as-UDON) |
| `/Users/josephwecker-v2/src/descent/rust/spikes/normalizations/NOTES.md` | Normalization needs |

---

## 11. Schema / versioning / checking ecosystems (rowan · autopax · operata)

Parallel map already exists at `01-ideation/sources-schema-versioning.md` — **overlap intentional**. Condensed high-value entry points for this pass:

### 11a. Rowan (formerly Archema) — first waiting schema customer

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-003-document-schema-first.md` | Document-schema-first founding ADR |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-004-programmatic-schema-api.md` | Programmatic schema API |
| `/Users/josephwecker-v2/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md` | Dig-style paths (cross-pollinates UDON paths) |
| `/Users/josephwecker-v2/src/rowan/docs/dev/open-questions.md` | Open questions |
| `/Users/josephwecker-v2/src/rowan/docs/dev/plan-safe-rdbms-evolution.md` | Safe evolution |
| `/Users/josephwecker-v2/src/rowan/docs/exp/schema-evolution-patterns.md` | Evolution patterns |
| `/Users/josephwecker-v2/src/rowan/docs/exp/path-centric-query-dsl.md` | Path-centric query |
| `/Users/josephwecker-v2/src/rowan/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | Schema migration research |
| `/Users/josephwecker-v2/src/rowan/docs/usr/10-schema-evolution.md` | User-facing schema evolution |
| `/Users/josephwecker-v2/src/rowan/docs/usr/14-schema-api.md` | Schema API user docs |
| `/Users/josephwecker-v2/src/rowan/docs/sys/schema/` | System docs for schema subsystem |
| `/Users/josephwecker-v2/src/rowan/docs/sys/agentic/tool-export.md` | Agentic tool export from resources |
| `/Users/josephwecker-v2/src/rowan/lib/archema/resource/versioning.rb` | Working versioning DSL |
| `/Users/josephwecker-v2/src/rowan/lib/archema/schema/` | Schema history/differ/decision_log/codegen/… |
| `/Users/josephwecker-v2/src/rowan/lib/archema/resource/constraints.rb` | Constraint vocabulary |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-document-schema-constraints.md` | Constraints plan |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-runtime-schema-evolution.md` | Runtime evolution |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-memory-store-versioning.md` | Memory store versioning |
| `/Users/josephwecker-v2/src/rowan/docs/msc/plan-recursive-embedded-schemas.md` | Nested schemas |
| `/Users/josephwecker-v2/src/rowan/docs/ref/migration-survey/` | Migration survey findings |
| `/Users/josephwecker-v2/src/rowan/docs/ref/patterns/` | Pattern catalog (63 files — selective mine) |
| `/Users/josephwecker-v2/src/rowan/test/usability/results/` | Rowan usability results (agent interaction with schema DSL) |
| `/Users/josephwecker-v2/src/rowan/docs/dev/hallway-usability-at-scale.md` | Usability-at-scale thinking |

### 11b. Autopax (YAML schemas, instrumenta, agent tooling)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/autopax/agents/agentic-tooling-misc-notes.md` | Agentic tooling misc notes |
| `/Users/josephwecker-v2/src/autopax/agents/AGENT-PRAXES.md` | Agent praxes |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-12-03-schema-migration-and-versioning-in-ruby-domain-modeling.md` | May mirror/overlap rowan research |
| `/Users/josephwecker-v2/src/autopax/docs/exp/documentation-tool-research-and-comparison.md` | Doc tooling comparison |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-intent-surfacing.md` | Intent surfacing |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-make-right-thing-easiest.md` | DX principle |
| `/Users/josephwecker-v2/src/autopax/docs/exp/2025-11-26-operata-system.md` | Operata system |
| `/Users/josephwecker-v2/src/autopax/docs/system-overview/instrumenta/` | Instrumenta (tools) subsystem docs |
| `/Users/josephwecker-v2/src/autopax/docs/system-overview/templates/` | Template subsystem |
| `/Users/josephwecker-v2/src/autopax/lib/autopax/instrumenta/` | Instrumenta implementation + md notes |
| `/Users/josephwecker-v2/src/autopax/OPERATA.md` | Operata concept in autopax |
| `/Users/josephwecker-v2/src/autopax/HANDOFF.md` | Project handoff state |

### 11c. Operata

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md` | Storage exploration |
| `/Users/josephwecker-v2/src/operata/docs/exp/2025-11-26-operata-system.md` | System |
| `/Users/josephwecker-v2/src/operata/docs/exp/where-operata-fits-in.md` | Positioning |
| `/Users/josephwecker-v2/src/operata/idealized-project-model.md` | Idealized model |
| `/Users/josephwecker-v2/src/operata/advanced-projecet-model.md` | Advanced model (filename typo preserved) |
| `/Users/josephwecker-v2/src/operata/LEXICON.yaml` | Lexicon as YAML (contrast to LEXICON.udon) |
| `/Users/josephwecker-v2/src/operata/docs/sys/` | System docs |

---

## 12. Agentic-tooling ideology (tools as product; CLI/agent ergonomics)

Parallel maps:
- `01-ideation/scratch/first-sweep-agentic-tooling/sources-agentic-tooling.md`
- `01-ideation/agentic-tooling-sources/*.md`

**Overlap welcome.** Condensed centers of gravity for this pass:

### 12a. Sapientia-era tooling ideology

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_core/sapientia/cli-conventions/` | Comprehensive CLI conventions incl. AI-agent & MCP sections (**tree**) |
| `/Users/josephwecker-v2/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md` | Filtered tooling conventions (W/S/B) |
| `/Users/josephwecker-v2/src/_core/sapientia/ai-conversation-system-requirements.md` | AI conversational/tool system requirements |
| `/Users/josephwecker-v2/src/_core/sapientia/minimal-sapientia-feature-parity.md` | Minimal feature parity distillations |
| `/Users/josephwecker-v2/src/_core/sapientia/minimal-sapientia-tools.md` | Minimal tools |
| `/Users/josephwecker-v2/src/_core/sapientia/MIN-SAPIENTIA-SPEC.md` | Min spec |
| `/Users/josephwecker-v2/src/_core/sapientia/OPERATA.md` | Operata concept origin thread |
| `/Users/josephwecker-v2/src/_core/sapientia/docs/` | Architecture/guides/reflections (**tree**, skim for tooling vs ELI) |

### 12b. Nexum / zoetica / ennaos / synaptic

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_core/nexum/docs/dev/vision-agentic-toys.md` | Agentic tool DSL vision |
| `/Users/josephwecker-v2/src/_core/nexum/docs/dev/agentic-toys-*.md` | Quick ref / comparison matrix |
| `/Users/josephwecker-v2/src/_core/nexum/docs/research/cli-analysis.md` | CLI analysis |
| `/Users/josephwecker-v2/src/_core/nexum/docs/research/sapientia-conventions-analysis.md` | Conventions analysis |
| `/Users/josephwecker-v2/src/_core/nexum/OPERATA.md` | Cross-project OPERATA |
| `/Users/josephwecker-v2/src/_core/zoetica/` | OPERATA / tool crystallization in Elixir era (**index via agentic-tooling map**) |
| `/Users/josephwecker-v2/src/_core/ennaos/OPERATA.md` | OPERATA |
| `/Users/josephwecker-v2/src/_core/ennaos/docs/` | Large docs tree — selective for tooling |
| `/Users/josephwecker-v2/src/_core/synaptic/` | Later consolidation notes |

### 12c. Archema harness (agentic loop, CLI survey, stalled lineage)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/archema-io/harness/README.md` | Harness home |
| `/Users/josephwecker-v2/src/archema-io/harness/CURRENT-THOUGHTS.md` | Current thoughts |
| `/Users/josephwecker-v2/src/archema-io/harness/lived.md` | Lived experience |
| `/Users/josephwecker-v2/src/archema-io/harness/ai-cli-tools-*.md` | Survey of AI CLI tools (feature timeline, sentiment, fork rec) |
| `/Users/josephwecker-v2/src/archema-io/harness/STEWARD-JUDGMENT-2026-07-20.md` | Steward judgment |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/AGENTIC-LOOP-PORT-SPEC.md` | Agentic loop port |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/MVP-VERTICAL-SLICE.md` | MVP slice |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/` | Sapientia/autopax/nexum OPERATA snapshots + survey |
| `/Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/SURVEY-sapientia-zoetica-ennaos-nexum.md` | Cross-project survey |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/cc-context-tools.md` | CC context tools |
| `/Users/josephwecker-v2/src/archema-io/harness/msc/system/agent-enhancement-anecdotes.md` | Agent enhancement anecdotes |
| `/Users/josephwecker-v2/src/archema-io/AGENTIC-DELEGATION.md` | Delegation practices |
| `/Users/josephwecker-v2/src/AGENTIC-DELEGATION.md` | Root-level delegation notes (if distinct) |

### 12d. SAR (AI-first language ideology — surprise outside main corridors)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md` | TST through agent cognition lens |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list for AI-first workflows |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md` | Measurement / "invisible visible" vision |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md` | Domain-speaking errors |

### 12e. Practica (coordination affordances / failure modes)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/practica/docs/02-normative/` | Normative commitments for coordination |
| `/Users/josephwecker-v2/src/practica/docs/02-normative/02-coordination-affordances.md` | Coordination affordances |
| `/Users/josephwecker-v2/src/practica/docs/02-normative/04-diagnostic-surfaces.md` | Diagnostic surfaces |
| `/Users/josephwecker-v2/src/practica/docs/02-normative/05-failure-mode-defaults.md` | Failure mode defaults |
| `/Users/josephwecker-v2/src/practica/msc/operata-study.md` | Operata study |
| `/Users/josephwecker-v2/src/practica/ref/task-and-issue-tools-survey.md` | Task/issue tools survey |

---

## 13. Memory / session corpora (durable docs & pointers, not chat as product)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/memorata/` | Hybrid search over writing + transcripts — *index* for further paths |
| `/Users/josephwecker-v2/src/memorata/IMPROVEMENTS.md` | What memory tools need (meta: documents as memory) |
| `/Users/josephwecker-v2/src/memorata/memory-curation/` | Curated principle extracts |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/` | Already-extracted UDON-relevant sessions |
| Grok session memory under `~/.grok/memory/` | Session notes may point at additional durable files |
| Claude project memory under `~/.claude/projects/` | Same for Claude substrates |
| **Flagged outside `~/src`:** `~/vaults/` | Sibling gatherer noted agent-oriented deposit outside src — not opened this pass; reconcilers should assign |

Also: needs-map standing queue mentions Joseph consolidating agentic tooling into `~/src/archema-io/harness/agentic-tooling/` — verify existence at mine time (may still be planned).

---

## 14. Adjacent / surprising / thin-but-listed territories

Inclusion when unsure.

| Path | Why it *might* matter |
|------|------------------------|
| `/Users/josephwecker-v2/src/shoshin/` | Local agent runtime plans; memory/attention *schemas* (tangential) |
| `/Users/josephwecker-v2/src/shoshin/03-tft-event-and-memory-schemas.md` | Event/memory schema language |
| `/Users/josephwecker-v2/src/firmatum/PROPRIUM-ARCHITECTURE-v2.md` | Consciousness infra — only if mining "documents as identity substrate" |
| `/Users/josephwecker-v2/src/umi/docs/umi-patterns.md` | Process supervision patterns (agent runtime adjacent) |
| `/Users/josephwecker-v2/src/umi/_archive/survey-umi-and-archema.md` | UMI/archema survey |
| `/Users/josephwecker-v2/src/vox/implementation-plan.md` | Vox product (audio) — likely dry for UDON needs; listed for completeness |
| `/Users/josephwecker-v2/src/semachrome/` | May be empty/stub; design/semachrome.md is the live note |
| `/Users/josephwecker-v2/src/_core/eli-migration-prep/taxonomy.md` | Taxonomy of sessions/docs |
| `/Users/josephwecker-v2/src/_core/eli-migration-prep/docs/` | Migration prep docs |
| `/Users/josephwecker-v2/src/_ref/autocolors/` | External autocolors ref if present |
| `/Users/josephwecker-v2/src/_ref/obsidian-linter/` | Linter patterns for structured markdown (analog for udon lint) |
| `/Users/josephwecker-v2/src/_ref/obsidian-help/` | Editor UX expectations |
| `/Users/josephwecker-v2/src/_ref/rbs_json_schema/` | Schema language interop prior art |
| `/Users/josephwecker-v2/src/ops/` | Mostly publication; may hold venue/tooling notes only |
| `/Users/josephwecker-v2/src/relata/` | Citation manager — structured metadata consumer class |
| Liquid templates under descent (`/Users/josephwecker-v2/src/descent/lib/descent/templates/`) | Template-as-codegen situation (S4-adjacent) |

---

## 15. Gathering-tree peers (for reconciliation only — not preferred exclusive mines)

| Path | Role |
|------|------|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/sources-schema-versioning.md` | Schema-versioning map |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/scratch/first-sweep-agentic-tooling/sources-agentic-tooling.md` | Agentic-tooling map |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/agentic-tooling-sources/` | Area-split agentic sources |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/scratch/schema-sources-search-log.md` | Schema search log |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/_quarantine/overprescribed-pass-2026-07-21-grok/` | Prior overconstrained pass (do not treat as coverage) |

---

## 16. Suggested mining order (optional; not a mandate)

If a later pass wants a *starting* spine without pretending completeness:

1. **Demand deliberation:** pipeline-discussion + needs-map + OPEN  
2. **Lived wishlists:** TOOLING-WISHLIST, TODO-UTILS, TODO-AGENT-UX, TODO-AUX  
3. **Day-in-life:** test/scenarios features + corpus  
4. **Live consumers:** the six `.udon` docs + PROCESS-MAP meta-review tooling findings  
5. **Demand spikes:** paths/agent-utility NOTES §8  
6. **Historical objectives:** `_ref/udon/doc/objectives.asciidoc` + udon-c NOTES  
7. **Schema customer:** rowan schema ADRs + lib versioning/constraints  
8. **Agent ideology:** sapientia cli-conventions + harness stalled-lineage survey  
9. **Usability evidence:** AGENT_FEEDBACK + enablement-synthesis  
10. **Everything else on this list** as breadth

---

## 17. Gaps / honesty about this pass

- Did **not** fully walk every file under sapientia `docs/`, zoetica, ennaos, rowan `docs/ref/patterns/`, or vivarium `msc/` — listed as trees or via sibling maps.
- Did **not** open `~/vaults/` (flagged by another gatherer).
- Did **not** run `find-consumers` or a full `**/*.udon` filesystem walk outside known inventory; CONSUMERS.md is the 2026-07-16 authority for live `.udon`.
- Did **not** mine session memory for additional durable paths beyond the session-vault already staged under v2/.archived.
- Quarantine extracts deliberately **not** treated as preferred reading; originals listed instead.
- Library-consumer needs from *external* crates.io users: none yet (crate not published) — only internal embedders (wasm, descent vendor, scenarios).

---

## 18. Feedback on the brief (as requested)

- Shape is right: path maps before mining avoids the quarantine failure mode.
- Overlap policy is correct; the expensive miss is whole geographies (historical objectives, day-in-life scenarios, live consumer field hazards) not duplicate design/*.md rows.
- One brief-adjacent risk: "Parsing Framework" as frame can still pull supply-side reading of library APIs; this map intentionally keeps wishlists and scenarios *above* CORE event encoding when mining.

— end sources-B —
