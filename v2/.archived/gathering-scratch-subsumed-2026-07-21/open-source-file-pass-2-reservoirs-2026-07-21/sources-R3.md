# Open source-file pass 2 — R3 (reservoirs / under-weighted)

**Date:** 2026-07-21  
**Role:** Path map only — prospective sources for end-user / agent **needs and usage ideation**.  
**Bias:** empirical, historical, creative enablement; easy-to-gloss-over material.  
**Not:** re-exhausting design essays, TODO spines, CORE law, or last week’s supply-side suite.

Overlap with open pass A/B/C and Fable maps is intentional. Prefer inclusion when unsure.

---

## 0. Already well-known — skip detail here

These were thoroughly path-mapped in `…/scratch/open-source-file-pass-2026-07-21/sources-{A,B,C}.md`, the quarantine design/UX haul, `sources-schema-versioning.md`, and `agentic-tooling-sources/*`. Reconcile against those; do **not** re-mine this pass as if they were missing:

- Live design corpus under `/Users/josephwecker-v2/src/udon/design/*.md` (positioning, agentic, paths, schema workbench, guarantees, ACP, GCG, …)
- Active TODO lanes (`TODO-UTILS`, `TODO-META`, `ux/TODO-*`, `spec/TODO-*`, `core/TODO-*`)
- `v2/DECISIONS.md`, `v2/OPEN.md`, live `spec/CORE.md` + companions
- Fable `needs-map.md`, schema-versioning map, sapientia/zoetica/autopax agentic-tooling maps
- Live consumer inventory mechanics in `CONSUMERS.md` + ASF/vivarium/autopax docs (already tabulated)
- Quarantine extracts under `_quarantine/overprescribed-pass-2026-07-21-grok/` (not coverage ceiling; not preferred bulk input)

---

## 1. PRIMARY GOLD — Dec 2025 usability corpus (re-weight, do not gloss as “stale”)

**Tree:** `/Users/josephwecker-v2/src/udon/test/usability/`

Open pass A listed this under “stale evidence” and under-weighted the **creative use-case** signal. Spec/models are dated; the **answers about what UDON is for** are still the densest empirical reservoir in-repo.

### 1a. Why this is load-bearing

| Track | Approx. raw files | What it is | Mining priority for “what UDON is *for*” |
|-------|-------------------|------------|------------------------------------------|
| **`topic_enablement`** | ~27 yamls | Random tech/AI/HCI seed → novel applications + honest “irrelevant” | **Highest** |
| **`enablement`** | 2 yamls | Free “what might UDON enable (incl. for agents)?” | **Highest** |
| **`topic_dsl`** | 5 yamls | Same seed style, DSL-focus addendum | **High** (DSL / dialect demand texture) |
| **`realistic` / `validated`** | ~20 + ~30 yamls | Produce real document genres (recipe, experiment report, conversation log, YAML→UDON…) | **High** as *genre inventory*; lower as free ideation |
| **`context_comparison`** | ~22 yamls | Fixed task list × context depth (config, mixed tutorial, org chart, inline science, schema, liquid template) | **High** — tasks encode intended use shapes |
| **`learning_curve` / `invention` / `interpretation`** | smaller | Learnability / redesign-your-own-notation / interpret | **Secondary** for demand (invention = convergence evidence, not use catalog) |

### 1b. Paths — prompts & harness (what was *asked*)

| Path | Why / provenance |
|------|------------------|
| `/Users/josephwecker-v2/src/udon/test/usability/lib/topic_enablement.rb` | Prompt + **TOPICS[] seed list** (architecture, infra, ML, HCI, agentic UX, trust/ethics…) — seed inventory is itself a domain catalog |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/usability_tester.rb` | `enablement_prompt` (agent workflows, A2A, human–agent collab); invention/interpret/learning-curve prompts |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/context_comparison.rb` | **TASKS** hash: config, mixed_doc, nested org chart, inline_heavy experiment, schema, template email |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/realistic_tests.rb` | **TASKS**: YAML frontmatter+prose, experiment report, YAML config+comments, conversation log, recipe |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/validated_tests.rb` | Same genre tasks with feature-expectation scoring |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/test_definitions.rb` | Learning-curve context ladder + stress/translation task design |
| `/Users/josephwecker-v2/src/udon/test/usability/run` | CLI surface: `topics`, `enablement`, `realistic`, `context`, … — what operators thought worth running |
| `/Users/josephwecker-v2/src/udon/test/usability/ETHICS.md` | How agents were treated; optional FEEDBACK channel design (insight harvest rules) |

### 1c. Paths — synthesis already done (entry, not substitute for raw)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/usability/enablement-synthesis.md` | Domains with strong/weak fit; novel inline-annotation patterns (RL, dialogue, XAI); source-of-truth unification; pre-registration/audit dual-use — **compressed** view of topic_enablement |
| `/Users/josephwecker-v2/src/udon/test/usability/results/AGENT_FEEDBACK.md` | Aggregated `# FEEDBACK:` blocks — friction + some enablement asides; noisier than raw yamls |

### 1d. Paths — raw result yamls (mine by track, not as one blob)

Globs under `/Users/josephwecker-v2/src/udon/test/usability/results/`:

| Glob | Priority | Note |
|------|----------|------|
| `udon-topic_enablement-*.yaml` | **P0** | Full creative answers; `task:` line names the seed domain |
| `udon-enablement-*.yaml` | **P0** | Agent-centric free enablement |
| `udon-topic_dsl-*.yaml` | **P1** | DSL/substrate ideation |
| `udon-realistic-*.yaml` | **P1** | What agents *produce* when asked for genres |
| `udon-context_comparison-*.yaml` | **P1** | Same; pairs with TASKS keys |
| `udon-validated-*.yaml` | **P2** | Scoring overlay on realistic-like tasks |
| `udon-learning_curve-*.yaml` | **P3** | Pedagogy/context-size, not application catalog |
| `udon-invention-*.yaml` | **P3** | Notation redesign convergence — secondary for use ideation |
| `udon-interpretation-*.yaml` | **P3** | Comprehension of given syntax |

**Sampling tip:** open by `task:` field first (topic names), then mine `response:` bodies for applications / skepticism. Do not dump wholesale into phase-2 synthesis.

### 1e. Paths — analysis tooling (mining aid, not content)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_embeddings.rb` | Semantic clustering of topic_enablement / topic_dsl via ollama+pgvector — **if re-runnable**, accelerates mining |
| `/Users/josephwecker-v2/src/udon/test/usability/embed_sentences.rb` | Sentence-level chunk embed for same corpus |
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_chunks.rb` | Chunk analysis companion |

Estate review already cited convergence (`_archive/REVIEW-JULY-2026.md` ~topic-enablement / enablement-synthesis) — that citation underweighted *raw* diversity of applications.

---

## 2. Day-in-the-life agent journeys (BDD usage situations)

**Tree:** `/Users/josephwecker-v2/src/udon/test/scenarios/`

Commissioned as “typical day of multiple agents understanding, diffing, modifying.” Higher **demand density per line** than design essays. Open pass listed it; still under-mined relative to essays.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/scenarios/README.md` | Op vocabulary (skeleton/at/all/diff/patch/CAS/append); `.gap` = explicit affordance gaps |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/01-understanding.scenarios.udon` | Orient, path resolve, fail-loudly, trait filters |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/02-diffing.scenarios.udon` | Diff journeys |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/03-modifying.scenarios.udon` | Patch / write |
| `/Users/josephwecker-v2/src/udon/test/scenarios/features/04-multi-agent.scenarios.udon` | Concurrent append, handoff, contention — decision-log / multi-agent ledger use |
| `/Users/josephwecker-v2/src/udon/test/scenarios/corpus/*.udon` | Synthetic but CORE-0.9 idioms of live genres (process-map, ordinum, decision-log, lexicon, operata workspace…) |
| `/Users/josephwecker-v2/src/udon/test/scenarios/bin/verify` | Corpus contract (what “usable day” requires of parse) |

Mine **`.gap` scenarios and `|gap` children** first — they name wanted capabilities the packet doesn’t cover.

---

## 3. Document *genres* as examples (usage shapes, not design-of-record)

Prefer these over attribute-model essays when mining “what people put in UDON.”

### 3a. Design examples (umbrella)

| Path | Genre signal |
|------|----------------|
| `/Users/josephwecker-v2/src/udon/design/examples/archema-operata.udon` | Domain/resource DSL (Ash-like) |
| `/Users/josephwecker-v2/src/udon/design/examples/operata-intent-graph.udon` | Intent graph + query DSL with Ruby escape hatch |
| `/Users/josephwecker-v2/src/udon/design/examples/ash-like-billing.udon` | Billing domain DSL |
| `/Users/josephwecker-v2/src/udon/design/examples/ash-like-inventory.udon` | Inventory domain DSL |
| `/Users/josephwecker-v2/src/udon/design/examples/ash-like-support.udon` | Support domain DSL |
| `/Users/josephwecker-v2/src/udon/design/examples/schema-dsl.udon` | Schema-as-document |
| `/Users/josephwecker-v2/src/udon/design/examples/docbook-fo-table.udon` | Transform / publishing round-trip |
| `/Users/josephwecker-v2/src/udon/design/examples/docbook-graphics.udon` | Graphics markup transform |
| `/Users/josephwecker-v2/src/udon/design/examples/mathml-to-latex.udon` | Math notation transform |
| `/Users/josephwecker-v2/src/udon/design/examples/practices-gotchas.udon` | Idiomatic authoring pedagogy-as-document |
| `/Users/josephwecker-v2/src/udon/design/examples/comprehensive.udon` | Full-surface showcase (also used as usability context) |
| `/Users/josephwecker-v2/src/udon/design/examples/cheatsheet.udon` / `minimal.udon` | Teaching ladder contexts |

### 3b. Live consumers (pointer only — inventory already mapped)

When mining **situations**, not migration counts: process maps, growing decision logs, lexicons, ordinum law-data, taxonomies, safe-subset authoring norms. Registry:

- `/Users/josephwecker-v2/src/udon/CONSUMERS.md` — live table + **§ Candidate future consumers** (ADRs, Axiomata, Signa, Memorata, A2A agent communications, mentoring-feedback, Loci, descent grammars already UDON) — these are **stated intended use classes** from drained `notes/NEXT.md`

---

## 4. Archived demand spikes & session residue (v2 night — under-mined for *use*)

Archive is law-not; still rich for **what agents need to do with documents**.

### 4a. Demand-side spikes (high)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/DEMANDS.md` | Index into demand tables |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/NOTES.md` | Generation/stream/edit/payload/fmt; memory handoff; soft/hard; **§8 P-A…P-H** boundary products |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/agent-utility/README.md` | Orient only |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/NOTES.md` | Paths §8 demand table; relational vs tree; embeddability |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/paths/sketches.udon` | Path sketch situations |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/FINDINGS.md` | Session/memory as document substrate (S10-adjacent) |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/memory-import/samples/` | Import shape samples |

Quarantine copies of agent-utility/paths NOTES also under  
`…/_quarantine/…/spikes/` — same content, already gathered once.

### 4b. Session vault — selective mine (usage friction, not greenfield grammar re-litigation)

**Tree:** `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/`

Most sessions are orientation / greenfield rewrite (supply-heavy). Prefer these **usage-adjacent** extracts:

| Path | Why |
|------|-----|
| `…/raw/claude/da5d1672-convert-markdown-to-udon-format-for-process-map.md` | **Lived** MD→UDON conversion for process maps; Obsidian plugin install |
| `…/raw/claude/ab1f7ab5-add-udon-syntax-highlighting-to-obsidian.md` | Human UX adoption friction |
| `…/raw/claude/305776aa-context-loading-for-deep-codebase-understanding.md` | Agent context / large-doc load (if present in body) |
| `…/raw/grok/019f7328-thorough-exploration.md` | Wide exploration (sample for “what agents notice they need”) |
| `…/raw/claude/INVENTORY.md` + `…/raw/grok/INVENTORY.md` | Catalog of what was exported |
| `…/NOTES.md` + `…/README.md` | How to retrieve history; vault shape |

Skip bulk re-mining of pure greenfield suite sessions unless hunting a specific demand turn.

### 4c. Archive index (routing only)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/INDEX.md` | Kind labels: which spikes are demand-side vs supply-spine |

Greenfield `agents-thoughts.md` / peer feedback under `first-pass/greenfield-3{a,b}/` are mostly **spec craft** — low priority for usage ideation.

---

## 5. Joseph deliberation turns (demand brainstorms already partly excerpted)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Full deliberation record; known sources list ~780–790; morning demand sampling ~525–542; “what we are missing” ~311–343; accumulation list ~98–130 |
| `…/_quarantine/…/discussion-excerpts/joseph-morning-demand-sampling.md` | Extract of template/dialect/schema-guarded-edit sampling |
| `…/_quarantine/…/discussion-excerpts/joseph-what-we-are-missing.md` | Utility / paths / dialects / schema confidence gaps |
| `…/_quarantine/…/discussion-excerpts/joseph-accumulation-and-ornamental.md` | Host-side product needs (typing, liquid, schema, ornamental fixpoint) |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/01-ideation/needs-map.md` | S1–S12 seeds + **standing harvest queue** (this pass feeds that queue) |

---

## 6. Historical lineage (2011 → revival) — product ambition, not syntax law

Open pass C listed these; keep as **utility priority matrix** and early converter desires, not DECIDED syntax.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/udon/doc/objectives.asciidoc` | Beauty/utility/performance priority table: templating 9, language mixing 9, include/layout 9, in-doc schema 7, online processing 6… |
| `/Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc` | Early wishlist (data- or freetext-centric, relational, schema, transforms, binary transport) |
| `/Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc` | Competitive compare frame |
| `/Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc` | Launch + **udon2xml/xml2udon, udon2json/json2udon** as day-one product |
| `/Users/josephwecker-v2/src/_ref/udon/examples/overview.udon` | Early feature checklist / aspirational surface |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/NOTES.md` | Config/include sketches (`|dependencies`, pip, language) — early *config+prose* use |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/TODO.md` / `DECIDED.md` / `README` | Historical; DECIDED is syntax, low for use ideation |
| `/Users/josephwecker-v2/src/_ref/udon-c/src/udon2xml.c` / `udon_introspect.c` | Conversion + introspection as continuous product desires |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/bin/` | Converter suite lineage (json/md/xml/yaml) |
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | Dec-2025 revival narrative (TST frame + repo map); superseded decisions marked |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Fresh-model first-contact review transcript (impressions + concerns) |

---

## 7. Felt tooling demand from real friction (short list)

Not design essays — “I needed this while working”:

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/TOOLING-WISHLIST.md` | events dump, ast pretty, roundtrip CLI, to-json, fmt — **agent-facing debug surface** |
| `/Users/josephwecker-v2/src/udon/ux/TODO-AGENT-UX.md` | Cheat-sheets, harness rebuild, edit tool critical path (pointer only; well-known) |
| `/Users/josephwecker-v2/src/udon/TODO-UTILS.md` | Utils lane (pointer) |

---

## 8. Sibling / outside-repo empirical & ideology reservoirs

### 8a. Rowan — same “hallway usability at scale” method (schema DSL)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/rowan/docs/dev/hallway-usability-at-scale.md` | Method statement that also drove UDON usability corpus |
| `/Users/josephwecker-v2/src/rowan/test/usability/results/` *(large yaml tree)* | Agent interaction with schema/DSL-shaped APIs — **adjacent** enablement texture, not UDON syntax |

### 8b. SAR — AI-first language ideology (not UDON, strong agent-dev demand analogs)

Flagged by Joseph as easy-to-forget find. Use for **agent-first product pressure**, not notation:

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md` | TST reframed for agent cognition; docs-as-codebase |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list; session workflow; anti-patterns |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md` | Measurement / velocity framing |
| `/Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md` | Errors that teach domain concepts |

(See also `agentic-tooling-sources/elsewhere.md` for vetted dry wells.)

### 8c. Outside `~/src` — vaults (agent practicability analyses)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/vaults/gemini/archive/analysis-v1/analysis/**` | Book analyses with **“Practicability for AI Agents”** sections (elsewhere map flagged HIGH if in scope) |
| `/Users/josephwecker-v2/vaults/gemini/analysis/pragmatic-programmer/` | Related analysis set |

### 8d. Meta analysis of the UDON project (context only)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/tmp/udon.md` | Apr-2026 project analysis (mentions usability framework, agent tools, use cases) — secondary |

### 8e. Search portals for still-buried discussion (not files yet)

Pipeline + needs-map explicitly name these as mines:

- **`memorata3-search`** (or current memorata hybrid) over Joseph’s writing + AI transcripts — “past udon survey ideation”, udon-c-era discussions, multi-agent brainstorms
- **Grok memory search** over `~/.grok/memory/udon-4fdadfea/` session flushes
- **Claude project JSONL** under `~/.claude/projects/-Users-josephwecker-v2-src-udon/` (session-vault notes: MB-scale originals; vault extracts already staged for many)

These are **search strategies**, not paths to open once — run when file maps run dry.

---

## 9. Lightweight competitive / pedagogy context (secondary)

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/design/markup-feature-matrix.md` | 26-language survey — “what users expect from markup” |
| `/Users/josephwecker-v2/src/udon/defining-udon.md` | Grammar / Spec / Pedagogy pillars — **how** to document, not use cases; only for pedagogy needs |
| `/Users/josephwecker-v2/src/udon/design/AGENT-CONTEXT-PROTOCOL.md` | Agent friction lived list (scope stack, pre-edit warnings) — seeds UDON-as-payload |
| `/Users/josephwecker-v2/src/udon/design/UDON-AS-ACP-FORMAT.md` | “Format is the protocol” thesis + payload examples (syntax dated) |

---

## 10. Suggested mining order (for a later extract pass)

1. **P0:** `udon-topic_enablement-*.yaml` + `udon-enablement-*.yaml` + `topic_enablement.rb` TOPICS / prompts  
2. **P0:** `enablement-synthesis.md` as map, then raw yamls for applications synthesis missed  
3. **P1:** `test/scenarios/features/*` especially `.gap` + multi-agent  
4. **P1:** `context_comparison` + `realistic_tests` TASKS + a sample of those yamls  
5. **P1:** `v2/.archived/…/spikes/agent-utility/NOTES.md` §8 + paths NOTES §8  
6. **P2:** design/examples genre docs; CONSUMERS future-watchlist classes  
7. **P2:** historical objectives + converter lineage; TOOLING-WISHLIST  
8. **P2:** selective session-vault (process-map conversion, Obsidian HL)  
9. **P3:** Rowan usability results; SAR AI-first docs; vault practicability sections  
10. **P3:** memorata / grok memory / remaining Claude JSONL for pre-2026 survey talk

---

## 11. Brief feedback on the brief

- Re-weighting **topic_enablement / enablement** as primary is correct; the synthesis alone loses domain diversity and skeptical “weak fit” signal.  
- **Task definitions** (context_comparison / realistic) are under-used as need proxies — they name document genres without reading every yaml.  
- **Session vault** is large; inventory-first mining beats re-export.  
- **Rowan usability** and **SAR** are not UDON content but carry method + agent-product pressure that map cleanly onto utility ideation.  
- Still missing as *durable files* (only search portals): 15yo udon-c conversation dumps and Joseph’s “incoming end-user ideation dump” named in needs-map.

---

## Provenance of this map

Filesystem walks of `test/usability`, `test/scenarios`, `v2/.archived`, `_ref/udon*`, `design/examples`, `CONSUMERS.md`, sibling rowan/sar/vaults paths; cross-check against open pass A/B/C underweighting of the usability tree; session memory on Joseph’s “hidden reservoir” reaction. )
