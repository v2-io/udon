---
source: Grok Build subagent reconciliation
date: 2026-07-21
status: path-level merge of Grok open maps only — no body extracts, no needs synthesis
inputs:
  - scratch/open-source-file-pass-2026-07-21/sources-{A,B,C}.md
  - scratch/open-source-file-pass-2-reservoirs-2026-07-21/sources-{R1,R2,R3}.md
  - _quarantine/overprescribed-pass-2026-07-21-grok/ (README, GATHERING-INDEX, sources-*, extracts/, spikes/, discussion-excerpts/)
out_of_scope: Fable agentic-tooling-sources/* and sources-schema-versioning.md except where Grok maps already cite the same paths
---

# MERGED — Grok prospective source maps (2026-07-21)

**What this is.** One coherent path picture from *this* line of work only: three open path maps (A∪B∪C), three reservoir reweight maps (R1∪R2∪R3), and a full union including the quarantined overprescribed haul (uniques first-class; method-weight untrusted). Still path-level / notes-from-maps — not a filesystem re-crawl and not needs synthesis.

**How to use.** Sections are **weight bands**, not geography. Within a band, paths appear once. When passes **disagreed on weight**, that is called out explicitly — disagreement is more useful than a flat alphabetical dump.

---

## 0. How the three layers relate

| Layer                            | What agents did                                                                                              | Characteristic failure / strength                                                                                                                          |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Pass 1 — open maps A/B/C**     | Inclusive walk of `udon/`, live consumers, `_ref/`, rowan/autopax/operata, agentic ideology, vaults pointers | High coverage of *obvious recent* design/TODO/live lanes; padded re-lists of files already known; buried empirical gold often one-line (“stale usability”) |
| **Pass 2 — reservoirs R1/R2/R3** | Deliberately *under*-list design/TODO spine; reweight empirical / historical / creative enablement           | Corrects pass-1 weight; track-level grain on `test/usability/`; elevates scenarios, historical objectives, SAR, selective session-vault                    |
| **Quarantine (overprescribed)**  | Constrained design/UX/docs/spikes → bulk-copied extracts                                                     | **Not a coverage map** and not a preferred *weight* for synthesis (method was biased). Still a **full union member**: unique paths, notes, staged snapshots, and “not found” negatives enter the merge as first-class findings with provenance. Redundant copies of paths also in A/B/C/R are optional “also staged” flags; **unique quarantine residue is important**, not discardable. |

**Sibling maps (Grok cited, Fable-owned — do not expand here):**

| Path | Role |
|------|------|
| `…/01-ideation/needs-map.md` | S1–S12 + standing harvest (Fable reseed) |
| `…/agentic-tooling-sources/*.md` | Sapientia / zoetica / nexum / harness / elsewhere |
| `…/sources-schema-versioning.md` | Rowan / autopax / operata schema spots |
| `…/scratch/first-sweep-agentic-tooling/` | Earlier tooling sweep + search log |
| `…/scratch/schema-sources-search-log.md` | Schema search trail |

Grok maps **overlap** those territories on purpose; paths below that land in Fable domains are still *our* findings, but trees are not expanded beyond what A/B/C/R already named.

---

## 1. Weight-disagreement ledger (most important delta)

These are the places where pass-1 gloss and pass-2 reweight **diverge**. Mine using the **pass-2** weight unless you have a reason not to.

| Unit | Pass 1 (A/B/C) | Pass 2 (R1/R2/R3) | Reconciled stance |
|------|----------------|-------------------|-------------------|
| `test/usability/` whole tree | “Stale models/spec — still evidence”; often one § or a few files (`enablement-synthesis`, `AGENT_FEEDBACK`, thin `lib/` sample) | **Primary gold** for “what UDON is *for*”; track-level priorities | **P0 reservoir.** Spec age is real; creative enablement signal is densest in-repo empirical deposit. Treat synthesis as *index*, raw P0 yamls as *primary*. |
| `topic_enablement` / free `enablement` / `topic_dsl` yamls | Buried under “results/udon-*.yaml — sample” | P0 (enablement + topic_enablement) / high-P1 (`topic_dsl` — almost invisible in pass 1) | Mine **response bodies** of these tracks first |
| `realistic` / `context_comparison` **task definitions** in `lib/` | Under-listed vs result yamls | High as **genre inventory / product briefs** without reading every yaml | Prefer TASKS hashes in `realistic_tests.rb` + `context_comparison.rb` before bulk results |
| `invention` / `learning_curve` / `interpretation` / `validated` | Lumped with usability | Explicitly **secondary** for use ideation (validated = feature scoring; invention = notation redesign convergence) | Do not treat as use catalog |
| `test/scenarios/` | Listed (A high, B/C solid) but under-mined relative to design essays | Kept as high demand-density **situation scripts**; mine `.gap` first | **P1 product language** — ops day, not free ideation |
| `design/*.md` agentic/paths/schema/TODO spine | Exhaustively tabulated | Explicitly “already well-known — skip detail” | Keep as **design-of-record band** (§4); do not re-mine as if discovered in R |
| Historical `_ref/udon/doc/objectives.asciidoc` etc. | Present but mid-list | Elevated as original **utility priority matrix**, not syntax law | **P2 historical ideation** — check against modern S* |
| SAR `_ref/_arch/sar/docs/ai-*` | A listed as surprise; B/C lighter | R elevates as Joseph-flagged forgotten agent-first ideology | **Ideology band** — not UDON syntax answers |
| Session vault bulk | Trees listed | Prefer **usage-adjacent** extracts only (process-map conversion, Obsidian HL, orientation utility essay); skip greenfield re-litigation | Selective mine |
| Quarantine (as a *system*) | Constrained method; bulk copies of design spine | Same caution on *method* | **Do not inherit quarantine’s ranking/weight.** Do **include** any path, note, need-class distillation, or staged slice that appears *only* there. For paths also live elsewhere, open the live original for truth; quarantine snapshot is still a finding (“was staged”). |
| `AGENT_FEEDBACK.md` | Often paired with enablement as main usability signal | Friction-heavy aggregator; **not** use encyclopedia | Sample for “what I wanted to do / what hurt,” not catalogs |
| Live consumers + CONSUMERS.md | Full inventory tables | Pointer-only (already mapped); R adds **validation-of-enablement** reading | Keep inventory in §5; use R’s “strong-fit class” lens when mining *uses* |

**Story in one line:** pass 1 padded the last-week design/TODO corridor; pass 2 elevated buried empirical gold (especially usability tracks + scenarios) without deleting the design maps.

---

## 2. Suggested reading order for later mining (union of A/R suggestions)

Opinionated reconcilers’ spine — **not** a needs synthesis:

1. **P0 empirical enablement** — usability P0 tracks + prompts (§3)
2. **P1 day-in-life** — `test/scenarios/` features (esp. `.gap`) + corpus genres
3. **P1 lived wishlists** — TOOLING-WISHLIST, TODO-UTILS, TODO-AGENT-UX, TODO-AUX
4. **P1 demand spikes** — agent-utility / paths NOTES §8 (archived originals)
5. **P1 live consumers** — six `.udon` + ordinum.rs + FORMAT/regula/toolchain + archema-io TODO
6. **P2 genre seeds** — design/examples + realistic/context TASKS
7. **P2 historical utility** — objectives/features/converters lineage
8. **P2 steward ideation** — pipeline-discussion demand turns (prefer full file over quarantine excerpts)
9. **P2 design-of-record** — agentic suite, guarantees, schema notes/workbench, positioning
10. **P3 ideology** — sapientia/harness (via Fable maps), SAR, vault practicability
11. **P3 library contracts** — core tree/stream/span + fixtures discipline
12. **P3 search portals** — memorata / grok memory / remaining JSONL when files run dry

---

## 3. Empirical / ideation reservoirs (elevated by pass 2)

### 3a. PRIMARY — Dec 2025 usability corpus

**Tree unit:** `/Users/josephwecker-v2/src/udon/test/usability/`

| Priority | Track / path | Why (merged notes) | Seen in |
|----------|--------------|--------------------|---------|
| **P0** | `results/udon-topic_enablement-*.yaml` (~25–27) | Seeded creative applications; `task:` = domain catalog; raw diversity > synthesis | R1,R2,R3 detail; A/B/C buried |
| **P0** | `results/udon-enablement-*.yaml` (2) | Free unseeded “what might UDON enable (incl. agents)” | R* |
| **P0** | `lib/topic_enablement.rb` | TOPICS[] seed list + prompt design | R* |
| **P0** | `lib/usability_tester.rb` (`enablement_prompt`) | Agent workflows, A2A, human–agent collab; invites skepticism | R* |
| **P1** | `results/udon-topic_dsl-*.yaml` (5) | DSL-substrate sibling; chaos engineering etc. — **almost invisible in pass 1** | R* |
| **P1** | `enablement-synthesis.md` | Human compression of topic_enablement (strong/weak fit, novel patterns) — **index, not substitute** | All passes |
| **P1** | `lib/realistic_tests.rb` TASKS | Genre production briefs: frontmatter+prose, experiment report, config+comments, conversation log, recipe | R elevates; B thin |
| **P1** | `lib/context_comparison.rb` TASKS | Config, mixed tutorial, org chart, inline science, blog schema, HTML email template | R elevates |
| **P1** | `results/udon-realistic-*.yaml`, `udon-context_comparison-*.yaml` | Sample after task defs | R*; A/C “sample” |
| **P2** | `results/AGENT_FEEDBACK.md` | Aggregated FEEDBACK blocks — friction-heavy | All; R demotes as encyclopedia |
| **P2** | `lib/validated_tests.rb` + `udon-validated-*.yaml` | Feature-expectation scoring of authoring tasks | R* |
| **P2** | `lib/test_definitions.rb` | Learning-curve ladder + stress/translate | All thin |
| **P3** | `udon-invention-*.yaml`, `udon-learning_curve-*.yaml`, `udon-interpretation-*.yaml` | Redesign / onboarding / comprehension — contrast, not use catalog | R* |
| mining aid | `analyze_embeddings.rb`, `embed_sentences.rb`, `analyze_chunks.rb` | Cluster enablement if re-runnable | R* |
| provenance | `ETHICS.md`, `run` | How agents were treated; experiment menu | All |

**Meta-evidence (not substitute for yamls):**  
`/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` — enablement predicted July 2026 adopters (~L163–208 / L179–192); estate review underweighted *raw* application diversity.

### 3b. Day-in-the-life scenarios (high demand density per line)

**Tree unit:** `/Users/josephwecker-v2/src/udon/test/scenarios/`

| Path | Why |
|------|-----|
| `…/README.md` | Op vocabulary (skeleton/at/all/diff/patch/CAS/append); provisional path syntax; `.gap` = explicit affordance gaps |
| `…/features/01-understanding.scenarios.udon` | Morning read journeys |
| `…/features/02-diffing.scenarios.udon` | Diff journeys |
| `…/features/03-modifying.scenarios.udon` | Write/patch; schema-guard-before-write shape |
| `…/features/04-multi-agent.scenarios.udon` | Contention, handoff, concurrent ledger |
| `…/corpus/*.udon` | CORE-0.9 idioms of live genres (see names under §5d) |
| `…/bin/verify` | Corpus clean-parse contract |

**Mining tip (R3):** prefer `.gap` scenarios and `|gap` children first.

### 3c. Free-form “would *I* use this?” judgments

| Path | Why | Pass notes |
|------|-----|------------|
| `…/v2/.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` | Long first-person agent utility: living mixed-content sweet spot; when *not* to use | **R2 only** among maps — do not lose |
| `…/design/positioning.md` | Agent-voice “who for”; dumb-pipe vs comprehending-agent litmus | All; R elevates as *use thesis* |
| `…/_archive/feedback.md` | Opus 4.5 first-contact vs 26 markups | B, R1–R3 |
| `…/session-vault/raw/claude/da5d1672-convert-markdown-to-udon-format-for-process-map.md` | Lived MD→UDON process map; links enablement strong-fit → ASF/vivarium | R2, R3 |
| `…/session-vault/raw/claude/18aabafc-scan-project-and-create-new-parser-fixtures.md` | Closing judgment: agents/humans unhighlighted; self-chunk retrieval | **R2** |
| `…/session-vault/raw/claude/ab1f7ab5-add-udon-syntax-highlighting-to-obsidian.md` | Human UX adoption friction | R1, R3 |
| `…/README.md` (umbrella) | Self-chunking for RAG/embeddings claim — public “what for” | R1, R2 |

### 3d. Steward demand brainstorms (deliberation)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Full fold → accumulation → demand inversion; **mine**: accumulation ~98–130; “what we are missing” ~311–343; morning sampling ~525–542; known sources ~780–790 |
| `…/01-ideation/needs-map.md` | S1–S12 + standing harvest queue (Fable seed — cited by all Grok maps) |
| `…/v2/OPEN.md`, `…/v2/DECISIONS.md` | WAIT-DEMAND boundaries + present-truth pins (constrain products; not need dumps) |
| Quarantine excerpts (hint only — prefer full discussion): `…/_quarantine/…/discussion-excerpts/joseph-{accumulation-and-ornamental,what-we-are-missing,morning-demand-sampling}.md` | Already-copied slices of pipeline-discussion |

### 3e. Archived demand spikes (situation texture — not architecture law)

For spikes also in archive: open archived originals for truth; quarantine copies remain staged findings with frontmatter.

| Path | Why |
|------|-----|
| `…/v2/.archived/INDEX.md` | Kind labels: demand-side vs supply-spine |
| `…/second-pass/spikes/DEMANDS.md` | Index into demand tables |
| `…/spikes/agent-utility/NOTES.md` (+ README) | Generation/stream/edit/payload/fmt; soft/hard; **§8 P-A…P-H** |
| `…/spikes/paths/NOTES.md`, `sketches.udon` | **§8 D*** path boundary demands; relational vs tree; embeddability |
| `…/spikes/memory-import/FINDINGS.md` + `samples/` | Session/memory as document substrate (S10) |
| `…/spikes/session-vault/` | Selective mine (§3c); use `raw/{claude,grok}/INVENTORY.md` first |

**Supply spine under second-pass** (`PIPELINE`, `WIRE`, `ADM`, `SPEC`, …): listed in A/C as secondary archaeology only — **do not re-promote as ontology**.  
Greenfield `agents-thoughts` / feedback-from-* mostly **spec craft** (R: low for pure use ideation).

---

## 4. Design-of-record & lived wishlists (pass-1 strength; R treats as known)

### 4a. Felt needs / open lanes (high density “I reached for X”)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/TOOLING-WISHLIST.md` | Joseph 2026-07-19: events, AST, roundtrip, to-json, fmt |
| `/Users/josephwecker-v2/src/udon/TODO-UTILS.md` | Accessors, coerce, serialize, skeleton/paths, **udon guard**, mixin expansion |
| `/Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md` | Cheat-sheets, harness rebuild, agentic suite, GBNF; **edit-tool critical path** |
| `/Users/josephwecker-v2/src/udon/ux/TODO-HUMAN-UX.md` | Editor / Obsidian / soft-wrap / LSP / tree-sitter keep-or-not |
| `/Users/josephwecker-v2/src/udon/spec/TODO-AUX.md` | Paths + schema + patch aux; `@{…}` embed; rowan as waiting customer |
| `/Users/josephwecker-v2/src/udon/spec/TODO-SPEC-CORE.md`, `TODO-SPEC-OTHER.md`, `TODO-TEXT-WIRE.md` | Open wording / pragma-schema-bind / text reconstruction |
| `/Users/josephwecker-v2/src/udon/core/TODO-CORE-PARSING.md`, `TODO-PARSER.md` | Residuals that **block** utility products (spans, serializer) |
| `/Users/josephwecker-v2/src/udon/TODO-META.md`, `TODO-PUBLISHING.md` | Literate fusion, fixtures-as-UDON, crates/outward docs |
| `/Users/josephwecker-v2/src/udon/tools/descent/TODO-DESCENT.md` (+ standalone `…/src/descent/TODO.md`) | Generator needs; DESC-as-UDON |

### 4b. Agent / tool / guarantee essays

| Path | Why |
|------|-----|
| `…/design/udon-agentic.md` | Design of record tool suite (glance/focus/propose/apply/…) — **full ~1200 lines** |
| `…/design/UDON-AGENT-TOOLS.md` | Dec-2025 brainstorm; Tier-1 merge idea not fully absorbed |
| `…/design/agentic-ux-principles.md` | WHY layer (principles tools re-derive against) |
| `…/design/AGENT-CONTEXT-PROTOCOL.md` | Agent friction phenomenology |
| `…/design/UDON-AS-ACP-FORMAT.md` | UDON as agent-context packaging |
| `…/design/udon-guarantees.md` | Soft/hard, gatekeeper, tool-mediated edit |
| `…/design/GRAMMAR-CONSTRAINED-GENERATION.md` | Guaranteed-valid generation |
| `…/design/positioning.md` | Product “who for” (also §3c) |

### 4c. Paths / AST / schema / genres (demand-facing design)

| Path | Why |
|------|-----|
| `…/design/udon-paths.md` | Stale as authority (TODO-AUX); still mineable situations |
| `…/design/udon-ast.md` | Skeleton, SourceInfo, streaming fragments |
| `…/design/schema-notes-2026-07.md` | Short: surfaces, freezes, forks |
| `…/design/schema-workbench-2026-07.md` | Long survey → rowan + corpus |
| `…/design/udon-schema-exploration.md` | Older SSOT vision |
| `…/design/file-naming.md` | `*.<designator>.udon` conventions |
| `…/design/composite-types.md`, `markdown-layers.md`, `markup-feature-matrix.md` | Type / MD situations / competitive jobs |
| `…/design/semachrome.md`, `desc-design-principles.md`, `descent-experience-2026-07.md` | Coloring; dialect-author friction |
| `…/spec/msc/adjudication-2026-07-paths-and-silences.md` | Path forks packet |
| `…/design/examples/` **tree** | Genre seeds (detail §6a) |
| `…/design/README.md` | Status banners / superseded markers |

**Lower for demand (listed so not “rediscovered”):**  
`design/attribute-model-*` — supply-side, mostly ratified into CORE 0.9 (A/C).

### 4d. Spec companions as *situation* names (not re-spec)

| Path | Why |
|------|-----|
| `…/spec/CORE.md` | Authority; mine host menus carefully |
| `…/spec/DYNAMICS.md`, `MARKDOWN.md`, `TIME-SPEC.md` | Template / MD layer / temporal dialect situations (111 live date attrs) |
| `…/spec/CORE-supplement.md`, `msc/CHANGELOG.md` | Supplement + rulings ledger |
| `…/spec/msc/FULL-EBNF.md` | Illustration only — non-authority |

### 4e. Human UX implementations (product in code form)

| Path | Why |
|------|-----|
| `…/ux/obsidian-udon/` | Live Obsidian plugin |
| `…/ux/autocolors/` + `PLAN.md` + `archaeology-2011/` | Semantic color lineage |
| `…/ux/tree-sitter-udon/`, `udon.tmLanguage.json`, `vim/` | Editor grammars |
| `…/core/udon-wasm/` | Highlight + autocolors engine |
| `…/ux/README.md` | Area map |

---

## 5. Live consumers & runtime demand

### 5a. Registry

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Live inventory, migration surfaces, **unused feature surface**, candidate future classes |
| `/Users/josephwecker-v2/src/udon/bin/find-consumers` | Discovery / re-scan mechanics |

**Unused features called out (quarantine + R1):** no `@`, no `|{…}`, no freeform fences, no `<…>`, no `:key?` yet — product vs overbuild tension.

**Candidate future classes (watchlist, not all live `.udon`):** ADRs, Axiomata, Signa, Operata, Memorata, A2A agent communications, mentoring-feedback, Loci, descent grammars (already UDON).

### 5b. Live `.udon` documents (2026-07-16 scan authority)

| Path | Genre / need residue |
|------|----------------------|
| `…/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Process-map founding; MECE / health tags |
| `…/archema-io/vivarium/DECISIONS.decision-log.udon` | Largest append-only concurrent log; dense date attrs |
| `…/archema-io/vivarium/LEXICON.udon` | Dictionary: identity, relations, `!:md:` tables |
| `…/archema-io/vivarium/doc/PROCESS.udon` | Norms + **safe-subset** authoring; sigil/reflow friction |
| `…/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Machine-read law-data; versioned phases |
| `…/autopax/taxonomy.udon` | Nested taxonomy; multi-value attr 0.8→0.9 hazards |

### 5c. Consumer-host process / loaders / program demand

| Path | Why |
|------|-----|
| `…/vivarium/FORMAT.md` | Cross-doc path schemes |
| `…/vivarium/tabularium/README.md` | Schema-by-filename; `stdin_parse` until CLI |
| `…/vivarium/crates/vivarium-world/src/ordinum.rs` | **Hand parser awaiting libudon** — cleanest library-consumer demand |
| `…/vivarium/doc/plan/regula-conformance-design.md` | Upcoming `.regula.udon` |
| `…/vivarium/doc/toolchain.md`, `ARCHITECTURE.md`, `ASSUMPTIONS.md`, `CLAUDE.md` | Toolchain / agent operating surface (B richer than A) |
| `…/vivarium/core-segment-candidates-2026-07-14.md`, `feedback-from-asf.md` | Meta tooling-lift (C) |
| `…/asf/msc/meta-process-review-2026-07-07/` tree | Findings/reflections; tooling utilization pair `09-tooling-automation-capability-utilization-{findings,reflection}.md` |
| `…/asf/msc/markdown-first-pipeline.md`, `build-markdown-design.md`, `FORMAT.md`, `LEXICON.md` | Adjacent MD pipeline competition (B) |
| `…/archema-io/TODO.md` | Explicit program demand: Rust linters, decision-log tools, archterm YAML→udon |
| `…/archema-io/CHARTER-DRAFT.md`, `charter/concept-matrix.md` | Cross-repo format candidates |
| `…/autopax/TAXONOMY.md`, `docs/ADR/*` (esp. 008 yaml/schemas, 010 MD parse, 002b signum, 012–013) | Candidate ADR class + schema history |
| `…/autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md` | Session texture |

### 5d. Scenario corpus mirrors of live genres

Under `test/scenarios/corpus/`:  
`archema.concept-matrix.udon`, `asf-processes.process-map.udon`, `operata.domain.udon`, `operata-live.workspace.udon`, `terrestris.ordinum.udon`, `vivarium.decision-log.udon`, `vivarium.lexicon.udon`.

### 5e. Need classes distilled from quarantine live-consumers map (not decisions)

Safe subset + lint/fmt CLI · schema = root type = filename designator · identity `[key]` density · unvalidated date attrs → temporal dialect · append-friendly docs · real library parse (not forever hand parsers) · raw dialects inside structured docs · unused features as overbuild signal.

---

## 6. Genre seeds & interchange lineage

### 6a. `design/examples/` (usage shapes)

| Path | Genre signal |
|------|----------------|
| `schema-dsl.udon` | Schema-as-document |
| `ash-like-{billing,inventory,support}.udon` | Resource/domain DSL (rowan-adjacent) |
| `archema-operata.udon`, `operata-intent-graph.udon` | Operata / intent graph |
| `practices-gotchas.udon` | Authoring hazards |
| `docbook-fo-table.udon`, `docbook-graphics.udon`, `mathml-to-latex.udon` | Transform / round-trip (S6) |
| `cheatsheet.udon`, `comprehensive.udon`, `minimal.udon` | Pedagogy ladder (+ usability stimuli) |

### 6b. Conversion matrix (continuous product desire 2011→2026)

| Path | Why |
|------|-----|
| `…/_archive/udon-ruby/bin/{json2udon,md2udon,udon2md,udon2xml,xml2udon,yaml2udon}` | Explicit interchange suite |
| `…/_ref/udon-ruby/bin/` (same names) | Pre-umbrella twin |
| `…/_ref/udon/bin/xml2udon` | Day-one conversion |
| `…/_ref/udon-c/src/udon2xml.c`, `udon_introspect.c` | Convert-out + introspection |
| `…/udon/bin/xml2udon` | Repo-root converter entry (C) |
| TOOLING-WISHLIST / TODO-UTILS | Modern restatement of same class |

### 6c. Competitive / baseline pain (by contrast)

YAML cheatsheets/spec under autopax & rowan `docs/ref/`;  
`design/markup-feature-matrix.md` (26-language survey).

---

## 7. Library / streaming / API surfaces

Encode what hosts *do* with parse products (A/B/C strong; R mostly skips).

| Path | Why |
|------|-----|
| `…/core/udon-core/src/lib.rs` | Dual API: streaming + DOM |
| `…/tree.rs`, `stream_tree.rs`, `span.rs`, `parser_pd.rs` | Tree ergonomics, chunky stream, edit spans, incremental |
| `…/examples/{stdin_parse,gen_events,tree_parse,highlight,show_formats,simple_parse}.rs` | De-facto CLI / half-built tools |
| `…/tests/{stream_tree,tree_api,spans,boundaries,canonical}.rs` | Asserted host contracts |
| `…/fixtures/v0.9/`, `v0.8/`, `exploratory/multi-line.yaml`, `_wip/FINDINGS.md`, `fixtures/README.md` | Compliance product meaning |
| `…/core/generator/*.descent.udon` (+ `temporal-value.desc.setaside`) | Grammar-as-UDON dogfood; dialect precedent |
| `…/tools/descent/` (SYNTAX, implementation-spec, TODO-DESCENT, examples, udon-reader spike) | Meta-language consumer of UDON |
| Standalone `…/src/descent/` | May drift from submodule pin |

---

## 8. Historical / archaeological (utility ambition, not syntax law)

### 8a. Original UDON (~2011) — utility priority matrix

| Path | Why |
|------|-----|
| `…/_ref/udon/doc/objectives.asciidoc` | **Beauty / performance / utility** table: templating 9, language mixing 9, include/layout 9, in-doc schema 7, online processing 6… |
| `…/features.asciidoc`, `compare-to.asciidoc`, `TODO.asciidoc`, `README.asciidoc` | Wishlist, competitive frame, early TODO, pitch |
| `…/description.udon`, `syntax.udon` | Self-describing early docs |
| `…/examples/overview.udon`, `ws-and-comments.udon` | Early feature checklist / experiments |
| `…/latest.txt`, `misc/udon.vim` | Experiment pointers; editor from day one |

**Unconfirmed trail (R1/R2 gap):**  
`…/_ref/udon/.attic/` (`syntax2`, `sample1`, `declang/` predecessor) — referenced by `_archive/analysis.md`; **not confirmed on disk** this cycle.  
Treat as search trail, not path inventory.

### 8b. udon-c / libudon / udon-ruby archives

| Path | Why |
|------|-----|
| `…/_ref/udon-c/docs/{NOTES,DECIDED,TODO}.md`, `README` | Config+hierarchy sketches; early decisions |
| `…/udon-c/test/doc.udon`, `src/udon2xml.c`, `udon_introspect.c`, `lib/udon.h` | Sample + first tools + C API ancestor |
| `…/_ref/libudon/{PLAN,README,CLAUDE}.md` | Pre-umbrella Rust plan; process discipline |
| `…/_ref/udon-ruby/` | Bindings + converter suite |
| `…/_ref/autocolors/` | Standalone semantic-color gem |

### 8c. Umbrella `_archive/` (estate, reboot, converters)

| Path | Why |
|------|-----|
| `REVIEW-JULY-2026.md` | Estate review + enablement meta-evidence |
| `REBOOT-PLAN.md`, `DECIDED.bak.md`, `FULL-SPEC-TODO.bak.md` | Pre-reboot capability lists |
| `analysis.md`, `feedback.md`, `HARNESS-AUDIT-2026-07.md` | Revival narrative; first-contact; harness product audit |
| `eof-model-proposal-2026-07.md`, `TODO-EOF-refactor.md` | EOF / recovery product |
| `decisions-superseded/` | Historical *why* for identity/fences/dialects moves |
| `spikes/` (prose-collision, explicit-stack, …) | Product collision concerns |
| `udon-ruby/` submodule | Conversion suite (see §6b) |
| `core/_archive/PARSER-GEN-HISTORY.md`, `generator/` | Generator ambitions |

### 8d. v2 night archive — selective (beyond demand spikes in §3e)

Brownfield: `BIG-PICTURE`, `DIRECTION`, `wire-value-model`.  
Greenfield: `new-spec/OPEN*`, dialect trees — comparative product factorings only. Night `SCHEMA.md` / `WARNING-CODES.md` / `pedagogy/OUTLINE.md` — demand residue if filtered; supply chapters parked.

---

## 9. Waiting customers & adjacent ecosystems (Grok-cited overlap with Fable)

**Prefer Fable’s dedicated maps for depth.** Below is the Grok-union of high-signal entry points only.

### 9a. Rowan (first waiting schema customer)

ADRs: document-schema-first, programmatic schema API, dig-style filter paths.  
Code: `lib/archema/resource/versioning.rb`, `schema/` subsystem, `constraints.rb`, `agentic/tool_export.rb`.  
Docs: `usr/10-schema-evolution`, `usr/14-schema-api`, `exp/schema-evolution-patterns`, `exp/path-centric-query-dsl`, `exp/2025-12-03-schema-migration…`, msc plans (constraints, runtime evolution, recursive embedded, memory-store versioning), `sys/schema/`, `sys/agentic/tool-export`, `KEY_FILES.md`.  
Adjacent empirical: `rowan/test/usability/results/` (R3: hallway method sibling), `docs/dev/hallway-usability-at-scale.md`, `_ref/rails-migrations-survey/`.

### 9b. Autopax

ADRs 002b/008/010/012/013; instrumenta + templates system docs; agents tree; OPERATA.md; HANDOFF; exp sessions on schema/doc tools/intent; live `taxonomy.udon`.

### 9c. Operata

Storage/system/principles exps; `docs/sys/`; `LEXICON.yaml` (contrast LEXICON.udon); idealized/advanced project models; design examples under udon (no live `*.udon` found under operata root — quarantine live-consumers).

### 9d. Agentic-tooling ideology (roots only — Fable owns detail)

| Center | Paths Grok named |
|--------|------------------|
| Sapientia | `cli-conventions/` (esp. ai-agent, mcp), QUICK-TOOLING-CONVENTIONS, ai-conversation-system-requirements, MIN-*/minimal-*, OPERATA, `udon.md` sketch, `tasks/TASK_001_DOCUMENT_PARSER.md` (YAML-frontmatter agent format **problem shape**), dialog-tool-spec, CACHING_AND_FILE_API |
| Nexum / zoetica / ennaos / synaptic | vision-agentic-toys, OPERATA, docs trees, TEST-AGENT-PROMPT |
| Harness | README, CURRENT-THOUGHTS, lived, ai-cli-tools-*, proprium/ (AGENTIC-LOOP, MVP, stalled-lineage survey), dossier/, cc-context-tools, agent-enhancement-anecdotes |
| Practica | coordination affordances, diagnostic surfaces, failure-mode defaults, operata-study, task-issue tools survey |
| SAR (elevated R) | `ai-applied-tst.md`, `ai-tst-ideas-and-opportunities.md`, `ai-tst-vision.md`, `error-messages-plan.md`, OPERATA, indent-languages |
| Other | `AGENTIC-DELEGATION.md` (archema-io + root), `_ref/_arch/sapientia-weaver-session/tasks/TASK_001…` (R2 problem-shape twin) |

### 9e. Peripheral (thin / S10-adjacent)

shoshin event/memory schemas · firmatum PROPRIUM · memorata IMPROVEMENTS / memory-curation · umi patterns · eli-migration-prep taxonomy · relata · obsidian-linter/help refs · rbs_json_schema · vox (dry) · ops (dry) · `~/src/tmp/udon.md` · `2026-02-18-long-conversation-emerson.txt`.

---

## 10. Quarantine — full union member (method-biased, not null)

**Root:**  
`/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/_quarantine/overprescribed-pass-2026-07-21-grok/`

**Policy (corrected):**

| Stance | Meaning |
|--------|---------|
| **Not a coverage map** | Don’t treat the constrained pass as “we already covered demand-side gathering.” |
| **Not a weight oracle** | Don’t inherit its ranking or “design/UX first” framing. |
| **Not gap-fill target** | Don’t define the next pass as “fill holes relative to quarantine.” |
| **Full union member** | Any **unique** path, note, distillation, staged snapshot, or negative finding that appears *only* here is a first-class merge result — often *more* important to surface because no other pass has it. |
| **Redundant copies** | Paths also in A/B/C/R: open live originals for current truth; quarantine copy is optional provenance (“was staged under frontmatter”). |

### 10a. Unique or high-value quarantine residue (do not discard)

These are reasons quarantine earns its place in a merge beyond “inventory of duplicates”:

| Finding | Why unique / useful |
|---------|---------------------|
| **`sources-live-consumers.md` need-class distillation** | Compact consumer-derived need list (safe-subset CLI, filename=schema designator, identity density, unvalidated dates, append-friendly roots, hand-parser→libudon, raw dialects in structured docs, unused-feature surface). Open maps inventory consumers; this *names need classes*. |
| **Staged consumer heads** (`consumer-vivarium-PROCESS-head.udon`, `DECISIONS-head.udon`) | Portable excerpts with gather frontmatter — not a substitute for full files, but a ready mining unit if the live path moves. |
| **Discussion excerpts** (three Joseph demand turns) | Portable slices of pipeline-discussion with line provenance — still open the full discussion for context; the slices are explicit prioritization of *which* turns are demand-texture. |
| **`sources-udon-repo-design-ux.md` extract-status table** | Records what was copied vs “not yet” *at that moment* — different artifact than A/B/C path lists. |
| **Partial heads of large design files** (`udon-agentic-head`, `UDON-AGENT-TOOLS-head`) | Explicit “head only” decision: full file still live; quarantine marks that the open maps may re-list the whole path without noting size/staleness tradeoffs. |
| **Frontmatter on every extract** (`source`, `gathered`, `paths`, `categories`, `why_included`) | Provenance experiment for phase (1) — useful template whether or not body copies are preferred. |
| **Negatives** (no operata `*.udon`, no `ops/` hits) | Still evidence; also in open maps, reinforced. |

### 10b. Maps written in-quarantine

| File | Scope |
|------|--------|
| `sources-udon-repo-design-ux.md` | In-repo design/UX/utils; extract status table |
| `sources-live-consumers.md` | Live external consumers + **need classes** (§10a) |
| `GATHERING-INDEX.md` | Inventory of staged files + next-gather notes from that pass |

### 10c. Spikes copied (whole) — also in open/R maps; prefer archived originals for truth

| Quarantine path | Original |
|-----------------|----------|
| `spikes/agent-utility-NOTES.md` | `v2/.archived/…/agent-utility/NOTES.md` |
| `spikes/paths-NOTES.md` | `…/paths/NOTES.md` |
| `spikes/paths-sketches.udon` | `…/paths/sketches.udon` |

### 10d. Extracts (whole unless noted) — mostly redundant with open maps’ *paths*; snapshots remain findings

| Extract | Original | Merge note |
|---------|----------|------------|
| `agentic-ux-principles.md` | `design/agentic-ux-principles.md` | Also heavily in A/B/C |
| `TODO-AGENT-UX.md` | `ux/TODO-AGENT-UX.md` | Same |
| `TODO-UTILS.md` | `TODO-UTILS.md` | Same |
| `TOOLING-WISHLIST.md` | `TOOLING-WISHLIST.md` | Same |
| `CONSUMERS.md` | `CONSUMERS.md` | Same |
| `positioning.md` | `design/positioning.md` | Same |
| `udon-guarantees.md` | `design/udon-guarantees.md` | Same |
| `UDON-AS-ACP-FORMAT.md` | `design/UDON-AS-ACP-FORMAT.md` | Same |
| `schema-notes-2026-07.md` | `design/schema-notes-2026-07.md` | Same |
| `GRAMMAR-CONSTRAINED-GENERATION.md` | `design/GRAMMAR-CONSTRAINED-GENERATION.md` | Same |
| `udon-agentic-head.md` | `design/udon-agentic.md` (**head only**) | Unique *staging choice* — see §10a |
| `UDON-AGENT-TOOLS-head.md` | `design/UDON-AGENT-TOOLS.md` (**head only**) | Same |
| `consumer-vivarium-PROCESS-head.udon` | vivarium `doc/PROCESS.udon` head | Unique staged slice — §10a |
| `consumer-vivarium-DECISIONS-head.udon` | vivarium DECISIONS head | Unique staged slice — §10a |

### 10e. Discussion excerpts — unique staging of steward demand turns

| Extract | Lines in pipeline-discussion |
|---------|------------------------------|
| `joseph-accumulation-and-ornamental.md` | ~98–130 |
| `joseph-what-we-are-missing.md` | ~311–343 |
| `joseph-morning-demand-sampling.md` | ~525–542 |

Full discussion file remains primary for context; these mark which turns quarantine treated as demand-texture.

### 10f. Quarantine admitted “not yet copied” (then)

`test/scenarios/` · schema-workbench · AGENT-CONTEXT-PROTOCOL · udon-paths (pointer) · udon-ast · TODO-AUX · TODO-HUMAN-UX · file-naming · enablement-synthesis · AGENT_FEEDBACK (sample) · design/examples set.

Later **fully path-mapped** by A/B/C and elevated by R — so “not copied into quarantine” ≠ “not found in the Grok line overall.”

### 10g. Quarantine “not found” (negative findings)

- No `*.udon` under `~/src/operata`
- `ops/` no hits in capped search

---

## 11. Search portals & outside-`~/src` trails (not single-file mines)

| Portal / path | Role | Pass notes |
|---------------|------|------------|
| `memorata/` (+ hybrid / memorata3-search) | Query: pre-2015 objectives, “use UDON for”, enablement talk | All; R when files dry |
| `~/.grok/memory/udon-4fdadfea/` | Recent gather decisions / reservoir weighting | Provenance for this cycle |
| Claude project JSONL under `~/.claude/projects/…-udon/` | MB-scale; prefer session-vault extracts first | C, R |
| `…/session-vault/raw/{claude,grok}/INVENTORY.md` | Catalog before re-export | R |
| `~/vaults/gemini/archive/analysis-v1/analysis/**` | “Practicability for AI Agents” book sections | A,R2,R3 — **no UDON string hits** this pass |
| `~/vaults/gemini/analysis/pragmatic-programmer/` | Related | R3 |
| `~/vaults/Operations/claude-code-tools.md`, MCP/Obsidian-workflow notes | Agent-tool ideology | A,R2 |
| Standing harvest (no path yet) | Joseph end-user + ideation dump | needs-map; primary when lands |

---

## 12. Intentionally dry / deprioritized (so not rediscovered as “miss”)

- `ops/`, `eli/**`, `embeddings/`, `neurips/`, `archema-io/logos/` — not format tooling
- `vox/` — little UDON
- `core/target/**` — build artifacts
- Attribute-model proposal series as primary demand
- Greenfield full SPEC rewrites as use ideation
- Invention-track usability as primary enablement
- Quarantine *ranking* of design/UX over empirical reservoirs (method bias)
- `semachrome/` at `~/src/semachrome` empty; live note is `design/semachrome.md`

---

## 13. Honest gaps admitted by the maps (union)

1. **`.attic` / `declang`** under `_ref/udon` — unconfirmed on disk  
2. **`memorata` / vault queries** for pre-revival “UDON for…” not landed as files  
3. **Full `find` of `*.udon` under `~/src`** outside CONSUMERS roots (vivarium grows)  
4. **Complete `task:` index** over topic_enablement yamls (only samples grepped)  
5. **Embedding analysis DB** may be gone; scripts remain  
6. **Joseph end-user ideation dump** — standing harvest, no path yet  
7. **Vault search for “UDON”/libudon** — ideology yes; UDON-specific notes maybe other names  
8. **Deep walks unfinished:** sapientia `docs/`, zoetica, ennaos, rowan `docs/ref/patterns/`, vivarium `msc/` — trees or sibling maps only  
9. **`~/vaults/`** flagged but not fully opened in pass 1  
10. **No external crates.io consumers** yet (crate unpublished)  
11. **Harness `agentic-tooling/` consolidation** — verify whether subtree landed  
12. **A2A / ACP third-party specs** named in design, not re-opened  
13. **15yo udon-c conversation dumps** — search portals only  
14. **Fable territories still being mined** — Grok maps cite roots; do not treat as closed

---

## 14. Map quality notes (peer feedback, consolidated)

**What worked**

- Path-map-first, overlap-OK avoided re-running the quarantine extract failure.
- Three-way parallel A/B/C gave geography breadth; R1/R2/R3 correctly fixed *weight* without deleting design maps.
- Track-level grain on usability is the single highest-value correction.

**What failed or nearly failed**

- Pass 1’s “stale usability” one-liner hid the densest empirical reservoir.
- Pass 1 padded obvious recent design/TODO files (memory-jog lists, weak labels for buried gold) — useful as *pointers*, poor as *priority*.
- Quarantine over-constrained to design/UX then bulk-copied — correct to quarantine as *method*, wrong to gap-fill against it as coverage, and **wrong (this merge’s earlier draft) to treat unique quarantine residue as second-class**. Union includes uniques; only the *weighting scheme* of the constrained pass is untrusted.
- Risk of double-counting `enablement-synthesis.md` *and* all P0 yamls as independent sources (R1).

**For future maps**

- When a harness tree is multi-experiment, name **tracks**, not only the directory.
- Prefer “skip detail / already known” sections (as R did) over re-tabulating design spines.
- Inventory-first for session vault; don’t re-export JSONL.

---

## 15. Quick “where do I open first?” cards

| If you want… | Open first |
|--------------|------------|
| Creative applications / “what for” | `topic_enablement` + `enablement` yamls + `topic_enablement.rb` + synthesis as index |
| Agent day ops / tool affordances | `test/scenarios/features/*` (`.gap` first) + TODO-UTILS + TODO-AGENT-UX |
| Lived host friction | vivarium PROCESS + DECISIONS + ordinum.rs + CONSUMERS unused surface |
| Product boundary tables | agent-utility NOTES §8 + paths NOTES §8 (archived) |
| Steward texture behind S* | pipeline-discussion demand turns (full file) |
| Historical ambition check | `_ref/udon/doc/objectives.asciidoc` + converter lineage |
| Agent-first ideology (not notation) | SAR ai-* + sapientia cli-conventions (Fable maps) |
| Quarantine uniques (need classes, staged heads, Joseph slices, head-only large design) | §10a — first-class |
| Redundant quarantine copies of live design/TODOs | live originals for truth; snapshots optional |

---

## 16. Source file index (inputs to this merge)

| File | Approx. role |
|------|----------------|
| `…/open-source-file-pass-2026-07-21/sources-A.md` | Inclusive geography; library + historical + rowan/SAR; mining bands |
| `…/sources-B.md` | Inclusive; consumer-host docs; descent; gaps honesty; mining order |
| `…/sources-C.md` | Inclusive; conversion/program-TODO surprises; sapientia TASK_001 |
| `…/open-source-file-pass-2-reservoirs-2026-07-21/sources-R1.md` | Usability track detail; historical; demand spikes; mining bands |
| `…/sources-R2.md` | Usability reweight; free-form utility essays; enablement validation lens |
| `…/sources-R3.md` | Same reweight; scenarios; vaults; rowan usability adjacency |
| `…/_quarantine/…/README.md` | Quarantine policy |
| `…/GATHERING-INDEX.md` | Staged extract inventory |
| `…/sources-udon-repo-design-ux.md` | What was copied vs not from design/UX |
| `…/sources-live-consumers.md` | Live consumer spots + need classes |

---

*End MERGED-grok-source-maps.md — path reconciliation only; no body mining.*
