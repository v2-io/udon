---
source: open source-file pass 2 — reservoirs (Grok Build subagent), 2026-07-21
pass: sources-R1
status: prospective path map only — no body extracts, no needs synthesis
posture: bias toward buried empirical / historical / creative-use ideation;
  under-list the obvious 0.9 design/TODO spine the first open pass already exhausted
overlap: intentional with sources-A/B/C and agentic/schema maps
---

# Prospective sources — pass R1 (reservoirs / underweighted)

**What this is.** Path map for phase-1 gathering: places where people (or models in experiments) brainstormed **what UDON might be for**, creative applications, enablement scenarios, “I would use this for…”, genre seeds — not syntax law and not a re-walk of last week’s design-of-record.

**How to read.** Absolute paths. Prefer inclusion when unsure. Overlap with `open-source-file-pass-2026-07-21/sources-{A,B,C}.md` is fine; this pass **reweights** rather than re-enumerating those maps.

**Method.** Walked the Dec-2025 usability tree at file/track granularity; original 2011-era lineages; archived Dec-2025 revival notes; v2 archived demand spikes (for situation texture, not as architecture law); live consumer unused-feature surface; a few outside-`udon/` surprises already flagged by Joseph / pass A. Did **not** re-catalog design essays, TODO lanes, or greenfield suites.

---

## 0. Already well-known — skip detail

First open pass (A/B/C) + Fable agentic/schema maps already cover these at path density. Treat as **pointers only** for reconciliation; do not mine this document for their bodies:

| Unit | Where listed |
|------|----------------|
| Live design spine (`design/udon-agentic.md`, `UDON-AGENT-TOOLS.md`, ACP, guarantees, paths, schema essays, positioning…) | A §2b, B/C design tables, quarantine design/UX map |
| TODO / wishlist lanes (`TODO-UTILS`, `TOOLING-WISHLIST`, `ux/TODO-*`, `spec/TODO-*`) | A §2a |
| Live consumer docs + loaders (vivarium, ASF process map, autopax taxonomy, `ordinum.rs`) | A §4, B §4, live-consumers map |
| Agentic-tooling ideology (sapientia CLI, harness, zoetica/ennaos, nexum) | `agentic-tooling-sources/*`, A §12 |
| Waiting customers (rowan schema evolution, autopax ADRs) | A §11, `sources-schema-versioning.md` |
| v2 deliberation (`pipeline-discussion.md`, `needs-map.md`, DECISIONS/OPEN) | A §1; quarantine discussion-excerpts |
| Greenfield / second-pass **supply** spine under `v2/.archived/` | INDEX.md — park for wording; not use-ideation primary |

**Exception within “already mapped”:** `test/usability/` and `test/scenarios/` appear in A/B/C but were **glossed as stale evidence / BDD corpus**. Below they are re-opened at reservoir grain.

---

## 1. Primary reservoir — Dec 2025 usability enablement (load-bearing)

**Whole tree:** `/Users/josephwecker-v2/src/udon/test/usability/`

**Provenance:** Dec 2025 hallway-style agent eval harness. Models/spec stale (floor, not ceiling — REVIEW-JULY-2026 §). Still the densest **empirical “what might UDON enable”** deposit in the estate. Joseph’s session reaction: open pass underweighted creative use-case signal under a “stale usability corpus” gloss.

### 1a. How to rank tracks (opinionated for miners)

| Priority | Track | Why for *usage ideation* |
|----------|--------|---------------------------|
| **P0** | `topic_enablement` | Random tech/AI/HCI seed → novel application brainstorms; ~25 yamls |
| **P0** | `enablement` | Free “what might UDON enable (incl. for agents)”; 2 rich yamls |
| **P0** | `topic_dsl` | Same seed family, **DSL-substrate** framing; 5 yamls — under-listed even vs enablement |
| **P1** | `enablement-synthesis.md` | Human synthesis of 27 topic-enablement runs (domains strong/weak fit) |
| **P1** | Task **prompt** code in `lib/` | What was *asked* is itself a need/use proxy |
| **P2** | `realistic` / `context_comparison` TASKS | Genre prompts (recipe, experiment, conversation log, mixed tutorial, schema, template…) |
| **P2** | `AGENT_FEEDBACK.md` | Aggregated free-text — **more friction/skepticism than catalogs**; sample, don’t treat as use encyclopedia |
| **P3** | `invention` / `learning_curve` / `interpretation` | Notation redesign / onboarding measurement — weak for “what for”; keep for contrast |
| **P3** | `validated` | Mechanical scoring of authoring tasks — onboarding evidence, not enablement catalogs |

### 1b. Prompt / harness design (what was asked)

| Path | Why / provenance |
|------|------------------|
| `/Users/josephwecker-v2/src/udon/test/usability/lib/topic_enablement.rb` | Seed list (architecture, cloud, data, AI/ML, HCI, conversational/agentic UX, trust/ethics…) + prompt: “unexpected connections / potential applications”; optional **DSL focus** branch |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/usability_tester.rb` | `enablement_prompt`: what becomes easier/possible; inner-loop stability; agent-to-agent; human-agent collab; invites skepticism |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/realistic_tests.rb` | Real-world **genre** tasks: YAML frontmatter+prose, experiment report, YAML config+comments, conversation log, recipe-from-scratch |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/context_comparison.rb` | TASKS as product genres: web-server config, mixed API tutorial, org chart, inline-heavy science prose, **blog schema**, **HTML email template** (liquid-ish) |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/validated_tests.rb` | Same realistic genres + expected feature scoring (what “good structure” meant) |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/test_definitions.rb` | Learning-curve context ladder + stress/translation sources — pedagogy/onboarding shape |
| `/Users/josephwecker-v2/src/udon/test/usability/run` | CLI surface: `enablement`, `topics`, `context`, `realistic`, `validated`, `invention`, … — documents the intended experiment menu |
| `/Users/josephwecker-v2/src/udon/test/usability/ETHICS.md` | How agents were treated (honesty, no fabricated turns, “why not how”) — frames trust of answers |

### 1c. Syntheses & secondary analysis (already partly distilled)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/usability/enablement-synthesis.md` | Domains strong fit (tech docs+specs, compliance/audit, human-AI collab, living/literate docs) + weak fit honesty + recurring critiques |
| `/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` | § onboarding + enablement (~L163–208): corpus predicted July 2026 adopters; critiques pre-echo core-vs-dialect / tooling chicken-egg — **meta-evidence**, not substitute for yamls |
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_embeddings.rb` | Embedding/cluster analysis over topic-enablement responses (pattern recovery aid if re-run) |
| `/Users/josephwecker-v2/src/udon/test/usability/embed_sentences.rb` | Sentence-level embed pipeline for same corpus |
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_chunks.rb` | Chunk analysis companion |

### 1d. Raw result yamls — by track (mine responses, sample if needed)

**P0 — free enablement (2 files):**

- `/Users/josephwecker-v2/src/udon/test/usability/results/udon-enablement-20251223-180230-6187510c.yaml`
- `/Users/josephwecker-v2/src/udon/test/usability/results/udon-enablement-20251223-180727-b1685096.yaml`

**P0 — topic enablement (~25 files; topics observed include A/B testing, RL, JAMstack, HCI, turn-taking, stream processing, feature store, transparency, OpenID Connect, DDD, cognitive load, CQRS, model distillation, human-in-the-loop, …):**

Whole glob unit:

`/Users/josephwecker-v2/src/udon/test/usability/results/udon-topic_enablement-20251223-*.yaml`

Examples (not exclusive):

- `…/udon-topic_enablement-20251223-184852-9fc1d817.yaml` — A/B testing
- `…/udon-topic_enablement-20251223-185036-dcda4e58.yaml` — CQRS
- `…/udon-topic_enablement-20251223-185128-a826abd2.yaml` — Transparency
- `…/udon-topic_enablement-20251223-185224-03252006.yaml` — HCI
- `…/udon-topic_enablement-20251223-185314-c33f4aff.yaml` — OpenID Connect
- `…/udon-topic_enablement-20251223-185406-61136b09.yaml` — Model distillation
- `…/udon-topic_enablement-20251223-185556-8ac341c0.yaml` — JAMstack
- `…/udon-topic_enablement-20251223-185651-d340330f.yaml` — Domain-driven design
- `…/udon-topic_enablement-20251223-190153-840d6472.yaml` — Reinforcement learning
- `…/udon-topic_enablement-20251223-190423-7134d2f4.yaml` — Stream processing
- `…/udon-topic_enablement-20251223-190525-aff1e5fd.yaml` — Feature store
- `…/udon-topic_enablement-20251223-190624-b22657f9.yaml` — Human-in-the-loop
- `…/udon-topic_enablement-20251223-191006-d1802bd1.yaml` — Cognitive load
- `…/udon-topic_enablement-20251223-192244-94012874.yaml` — Turn-taking

**P0 — topic DSL (5 files; enablement + “novel DSLs UDON could facilitate”):**

- `/Users/josephwecker-v2/src/udon/test/usability/results/udon-topic_dsl-20251223-192056-9526d71e.yaml` — Chaos engineering
- `…/udon-topic_dsl-20251223-192151-16ff82ec.yaml`
- `…/udon-topic_dsl-20251223-192241-7cadd564.yaml`
- `…/udon-topic_dsl-20251223-192333-1625c970.yaml`
- `…/udon-topic_dsl-20251223-192423-47a97311.yaml`

**P2 — realistic genre production (~22):**

`/Users/josephwecker-v2/src/udon/test/usability/results/udon-realistic-20251223-*.yaml`

**P2 — context comparison (~21; same TASKS × context levels):**

`/Users/josephwecker-v2/src/udon/test/usability/results/udon-context_comparison-20251223-*.yaml`

**P2/P3 — feedback aggregate + lower-priority tracks:**

| Path / glob | Role |
|-------------|------|
| `…/results/AGENT_FEEDBACK.md` | Mixed tracks’ FEEDBACK blocks; friction-heavy |
| `…/results/udon-invention-*.yaml` | Invent-your-own-notation convergence (~6) |
| `…/results/udon-learning_curve-*.yaml` | Onboarding (~7) |
| `…/results/udon-interpretation-*.yaml` | Interpretation probe (1) |
| `…/results/udon-validated-*.yaml` | Scored authoring (~37) — use for “what tasks agents were asked to *do*”, not catalogs |

**Mining note:** each enablement/topic yaml stores full `prompt` + `response`. Prefer mining **response bodies of P0 tracks** and **task lists in lib/** before bulk-reading invention/validated.

---

## 2. Day-in-the-life product language (situations, not syntax)

Underweighted relative to essays: these files already speak **agent day journeys** in product vocabulary (skeleton/at/all/diff/patch/CAS…).

**Whole tree:** `/Users/josephwecker-v2/src/udon/test/scenarios/`

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/scenarios/README.md` | Intent: multi-agent day; ops vocabulary; provisional path syntax |
| `…/features/01-understanding.scenarios.udon` | Morning read journeys |
| `…/features/02-diffing.scenarios.udon` | Diff journeys |
| `…/features/03-modifying.scenarios.udon` | Write/edit; includes schema-guard-before-write acceptance shape |
| `…/features/04-multi-agent.scenarios.udon` | Contention, handoff, concurrent ledger — whole day |
| `…/corpus/asf-processes.process-map.udon` | Genre: process map |
| `…/corpus/vivarium.decision-log.udon` | Genre: growing decision log |
| `…/corpus/vivarium.lexicon.udon` | Genre: lexicon |
| `…/corpus/terrestris.ordinum.udon` | Genre: ordinum / law-data |
| `…/corpus/operata.domain.udon` | Genre: domain/schema-as-doc |
| `…/corpus/operata-live.workspace.udon` | Genre: workspace instance / mutation target |
| `…/corpus/archema.concept-matrix.udon` | Genre: cross-doc concept matrix |
| `…/bin/verify` | Clean-parse contract for corpus |

---

## 3. Historical / original-era ideation (pre-revival)

Easy to gloss as “old syntax notes.” Actually early **utility & wishlist** thinking + archaeological map into attic.

| Path | Why / provenance |
|------|------------------|
| `/Users/josephwecker-v2/src/_ref/udon/doc/objectives.asciidoc` | Priority matrix: beauty/performance/**utility** (semantic data, hierarchies, document mixing, universal templating, language mixing, in-doc schema, relational, online processing, narrative…) — 2011-era “what UDON is for” in concern form |
| `/Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc` | Short wishlist: data- or freetext-centric, relational, libraries, compression/binary, schema, easy transforms |
| `/Users/josephwecker-v2/src/_ref/udon/doc/description.udon` | Design intent: vast majority of docs acceptable as passthrough |
| `/Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc` | Competitive framing (thin) |
| `/Users/josephwecker-v2/src/_ref/udon/doc/syntax.udon` | Early syntax + scalar menu (supply-ish; skim for *intended* feature surface) |
| `/Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc` | Original TODO trail |
| `/Users/josephwecker-v2/src/_ref/udon/TODO` | Feature checklist (raw) |
| `/Users/josephwecker-v2/src/_ref/udon/examples/overview.udon` | Comprehensive early feature/todo-in-document form; lists paths/refs, templating, transforms as aspirational |
| `/Users/josephwecker-v2/src/_ref/udon/examples/ws-and-comments.udon` | Whitespace/comment experiments |
| `/Users/josephwecker-v2/src/_ref/udon/latest.txt` | Pointers to latest syntax experiments of that era |
| `/Users/josephwecker-v2/src/_ref/udon/bin/xml2udon` | Early interchange product intent |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/NOTES.md` | Worked config-shaped examples (deps/pip) — lived “config + hierarchy” use |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/DECIDED.md` | Embedded forms, grim attributes, freeform — product affordances implied |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/TODO.md` | Open C-era work |
| `/Users/josephwecker-v2/src/_ref/udon-c/test/doc.udon` | Early test document |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon2xml.c`, `…/udon_introspect.c` | Introspection / conversion as first products |

**Attic pointer (may need direct path; analysis claims it):**  
`/Users/josephwecker-v2/src/_ref/udon/.attic/` — `syntax2.udon`, `sample1.udon` (HTML/YAML/receipt examples), `scratch.asciidoc`, **`declang/` predecessor** — if present on disk, high archaeology value for early use sketches. Confirm with listing; pass A flagged via `_archive/analysis.md`.

---

## 4. Dec 2025 revival notes & agent first-contact (not design-of-record)

Often archived as “historical” and skipped when mining **uses**.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | TST-framed revival analysis; maps `_ref/udon` + attic + declang; design priorities restated; repository genealogy |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Opus 4.5 first-contact review vs 26 lightweight markups — impressions, concerns, comparisons (use + friction) |
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Agent-voice positioning essay (status: still holds) — **who UDON is for** and what agents need when scanning/generating; tiers-as-API-contract |
| `/Users/josephwecker-v2/src/udon/README.md` | Self-chunking for RAG/embeddings claim; size comparisons; public “what for” surface (S10 adjacency) |
| `/Users/josephwecker-v2/src/tmp/udon.md` | Apr 2026 project analysis: notes usability harness, agentic tools, RAG/self-segmentation, real-world use framing (meta inventory) |

---

## 5. Archived v2 demand spikes (situation texture — not architecture law)

Parked supply spine is **out of scope** for this map. These residual spikes are the night’s **demand-side** work — situation/product language for agents:

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/DEMANDS.md` | Index into harvests |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/NOTES.md` | Generation/repair, memory/handoff, fmt vs span-splice, stage-products as agent surfaces; §6 convergence list; §7 gaps (self-chunking unmeasured…); **§8 P-A…P-H demand proposals** |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/README.md` | Spike orientation |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/NOTES.md` | Path boundary demands §8 (addressing as use-enabler) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/sketches.udon` | Worked path sketches |
| `/Users/josephwecker-v2/src/udon/v2/.archived/INDEX.md` | What not to promote wholesale |

**Joseph demand brainstorm (durable in deliberation, excerpted once):**

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Especially morning sampling ~L525–542 (templates, dialects, schema-guarded edit, round-trips, mid-stream reconfig) and “what we are missing” ~L311–343 — **highest-texture steward ideation**; needs-map S* compresses it |
| Quarantine mirrors (hint only): `…/_quarantine/.../discussion-excerpts/joseph-morning-demand-sampling.md`, `joseph-what-we-are-missing.md` | Prefer original discussion for mining |

---

## 6. Live usage as negative/positive evidence of *uses*

Not essays — **what people actually do vs what remains unused**.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/CONSUMERS.md` | Live inventory + **unused feature surface** (no `@`, no `|{…}`, no freeform fences, no `<…>`, no `:key?` yet) — demand for tooling/migration *and* evidence of which affordances haven’t been pulled into real work |
| `/Users/josephwecker-v2/src/udon/bin/find-consumers` | How the registry is refreshed |

Live docs themselves are well-mapped in pass A/B; re-list only if mining **genres** (decision log growth, process map, ordinum, taxonomy). Prefer those maps.

---

## 7. Genre seeds in example corpora (implied “I would use this for”)

Not design essays — **documents that encode intended applications**.

### 7a. Modern design/examples

Whole: `/Users/josephwecker-v2/src/udon/design/examples/`

| Path | Genre signal |
|------|----------------|
| `…/schema-dsl.udon` | Schema-as-document |
| `…/ash-like-{billing,inventory,support}.udon` | Resource/domain DSL (rowan-adjacent) |
| `…/archema-operata.udon`, `…/operata-intent-graph.udon` | Operata / intent graph |
| `…/practices-gotchas.udon` | Authoring hazards (agent + human) |
| `…/docbook-fo-table.udon`, `…/docbook-graphics.udon`, `…/mathml-to-latex.udon` | Transform / round-trip genres |
| `…/cheatsheet.udon`, `…/comprehensive.udon`, `…/minimal.udon` | Onboarding artifacts (also **stimuli** for usability runs) |

### 7b. Conversion lineage (S6 product matrix)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/bin/{json2udon,md2udon,udon2md,udon2xml,xml2udon,yaml2udon}` | Explicit interchange products |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/` (if checked out) | Frozen Ruby gem era sibling |
| `/Users/josephwecker-v2/src/_ref/udon/bin/xml2udon` | Earliest conversion product |

---

## 8. Outside-repo ideology reservoirs (adjacent, not UDON-syntax)

Already partly in A §12; listed here only where they inform **agent product expectations** that pull on notation:

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md` | TST through agent cognition (Joseph-flagged forgotten find) |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list for agents |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md` | Measurement philosophy |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md` | Errors that teach domain concepts |
| Sapientia / harness centers | Prefer `agentic-tooling-sources/*.md` — do not re-list |

---

## 9. Session / memory pointers (search surfaces, not wholesale mines)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/` | Extracted sessions; scan titles for product language (e.g. `da5d1672-convert-markdown-to-udon-format-for-process-map.md`, `ab1f7ab5-add-udon-syntax-highlighting-to-obsidian.md`) — mostly orientation/spec, sparse pure enablement |
| `…/session-vault/raw/claude/INVENTORY.md`, `…/grok/INVENTORY.md` | Indexes |
| `/Users/josephwecker-v2/src/memorata/` | Hybrid search over writing + transcripts — **query** for pre-2015 objectives, “use UDON for”, hallway tests |
| `/Users/josephwecker-v2/.grok/memory/udon-4fdadfea/` | Recent gather decisions; not a use-case corpus |
| Standing harvest (no path yet): Joseph’s end-user input + ideation dump | `needs-map.md` standing queue — primary when it lands |

---

## 10. Suggested mining bands for *this* map (not a decision)

1. **P0 yamls + prompts:** `topic_enablement` + `enablement` + `topic_dsl` + `lib/topic_enablement.rb` + `enablement_prompt` in `usability_tester.rb` + `enablement-synthesis.md`.
2. **Genre task lists:** `realistic_tests.rb`, `context_comparison.rb` TASKS; then sample realistic/context yamls if needed.
3. **Day-in-the-life scenarios** + agent-utility §8 demands (product situations).
4. **Historical utility matrix:** `objectives.asciidoc`, `features.asciidoc`, `overview.udon`, analysis/feedback archive.
5. **Positioning + README self-chunking** as claims to **verify or kill** against live consumers / new ideation (not re-author).
6. **CONSUMERS unused-feature surface** as “claimed vs lived” tension.
7. **Joseph pipeline sampling** for demand counterexamples that bend products (templates/dialects/schema-guard) — already in needs-map seeds; re-open for texture lost in S* compression.

---

## 11. Gaps / trails not finished this pass

1. Confirm `_ref/udon/.attic/` + `declang/` on disk; if present, path-list contents.
2. `memorata` / vault queries for pre-revival “UDON for …” notes not in repo.
3. Full `find` of `*.udon` under `~/src` for unregistered consumers (vivarium grows).
4. Whether any **topic_enablement** topics beyond the sampled task lines deserve a topic→file index (easy one-liner over yaml headers).
5. Re-run or re-open embedding DB only if synthesis.md feels insufficient for clustering applications.
6. Incoming Joseph end-user ideation dump when path exists.

---

## 12. Feedback on the brief (peer)

- The **reservoir reweight** is the right correction: pass 1’s “stale usability” framing was accurate about model age and wrong about signal class. The load-bearing files are the **P0 yamls + seed prompt**, not `AGENT_FEEDBACK.md` alone and not invention/learning_curve.
- `topic_dsl` is a quiet sibling of topic_enablement — almost invisible in prior maps; five files still expand “what DSL might emerge.”
- Scenarios + agent-utility spikes are the other under-mined *situation* layer once creative enablement is in hand — different register (ops day vs free ideation), both demand-side.
- Risk for reconcilers: double-counting synthesis.md *and* all 25 yamls as independent sources. Treat synthesis as **index**, yamls as **primary**.

---

*End of sources-R1.md — path map for reconciliation with A∪B∪C; no body mining performed.*
