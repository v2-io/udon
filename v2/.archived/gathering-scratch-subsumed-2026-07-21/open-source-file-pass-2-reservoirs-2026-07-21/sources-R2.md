---
pass: open-source-file-pass-2-reservoirs-2026-07-21
author: Grok (sources-R2)
date: 2026-07-21
status: prospective path map only — no body extracts, no needs synthesis
posture: inclusion-biased; overlap with pass-1 (A/B/C) is fine and expected
bias: empirical / experimental / historical *usage ideation* reservoirs —
      “what UDON might be for,” creative enablement, agent free-use answers —
      not syntax law and not re-listing last week’s design-of-record spine
method: filesystem walk + spot-reads for provenance; pass-1 maps used only to
        avoid bulk re-exhaustion of the TODO/design surface
---

# Sources-R2 — underweighted usage-ideation reservoirs

**What this is.** A second open path map, deliberately biased away from the obvious recent design/TODO/live-lane material that pass-1 (A∪B∪C) already exhaustively listed. Preference: buried empirical corpora, experimental agent answers, historical “why this notation exists,” free-form “I would use this for…,” and easy-to-gloss-over secondary analysis tooling.

**What this is not.** Needs synthesis. Body extracts. A re-index of `design/udon-agentic.md`, `TODO-UTILS`, CORE, or the quarantine extracts.

**How to use.** Absolute paths. Trees as units when the whole folder is the mining grain. Prefer include when unsure. Reconcile later with A/B/C.

---

## 0. Already well-known (skip detail)

Pass-1 already mapped these thoroughly — open originals if needed, but do **not** treat re-listing them as progress for this pass:

- Live lanes: `TODO-UTILS`, `TOOLING-WISHLIST`, `ux/TODO-{AGENT,HUMAN}-UX`, `spec/TODO-*`, `core/TODO-*`
- Design-of-record essays under `/Users/josephwecker-v2/src/udon/design/` (agentic tools, paths, guarantees, schema, ACP, GBNF, …)
- Live consumer *documents* registry (`CONSUMERS.md` + vivarium/ASF/autopax `.udon` files) — listed below only where they are *validation* of older enablement predictions, not as a fresh inventory
- Rowan/autopax/operata schema-versioning surface (dedicated map already: `…/sources-schema-versioning.md`)
- Sapientia/zoetica/ennaos/nexum agentic-tooling ideology (maps under `…/agentic-tooling-sources/`)
- v2 `.archived/` night-spine supply ontology (`PIPELINE`, `WIRE`, `ADM`…) — only selective demand tables were already flagged; skip re-spine

Sibling maps (do not treat as exclusive coverage):

| Path | Role |
|------|------|
| `…/scratch/open-source-file-pass-2026-07-21/sources-{A,B,C}.md` | Pass-1 inclusive maps |
| `…/needs-map.md` | Seed situations S1–S12 |
| `…/agentic-tooling-sources/*.md` + `sources-schema-versioning.md` | Domain maps |
| `…/_quarantine/overprescribed-pass-2026-07-21-grok/` | Hint list only — not preferred input |

---

## 1. PRIMARY RESERVOIR — Dec 2025 usability corpus (underweighted as “stale”)

**Whole tree unit:** `/Users/josephwecker-v2/src/udon/test/usability/`

Pass-1 listed this as “stale models/spec — still evidence,” often one row or a short §3b. That gloss buried the **creative use-case** signal. The harness explicitly ran open-ended “what might UDON enable / apply to” experiments; estate review (`_archive/REVIEW-JULY-2026.md` §~3) later found that 27 topic-enablement runs **predicted July 2026 adopters** (process maps, vivarium experiment narratives, audit/pre-registration) seven months early.

### 1a. Load-bearing tracks for “what is UDON *for*” (mine first)

| Path | Why / what the track actually asks | Provenance |
|------|-------------------------------------|------------|
| `/Users/josephwecker-v2/src/udon/test/usability/lib/topic_enablement.rb` | **Topic-seeded enablement.** Random tech/AI/HCI seeds → “unexpected connections or potential applications”; optional DSL-focus variant. Topic list is itself a domain catalog (architecture, MLOps, HCI, multi-agent, …). | Dec 2025 harness |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-topic_enablement-*.yaml` | **~25 raw agent essays** (one per seed). Example seeds present: A/B testing, CQRS, DDD, OpenID Connect, reinforcement learning, feature store, stream processing, JAMstack, HCI, cognitive load, human-in-the-loop, turn-taking, model distillation, transparency, … | 2025-12-23 runs |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-topic_dsl-*.yaml` | **DSL-focused sibling** of topic enablement (“novel DSLs UDON could uniquely facilitate”). Seeds include e.g. chaos engineering. | Same day |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/usability_tester.rb` (`enablement_prompt` ~L507+) | **Free enablement prompt:** what becomes easier / newly possible for agents; inner-loop stability; agent-to-agent; human–agent collab — explicitly invites skepticism. | Harness |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-enablement-*.yaml` | **Free (unseeded) enablement** answers (2 runs found). Dense “I would use this for…” without topic priming. | Same day |
| `/Users/josephwecker-v2/src/udon/test/usability/enablement-synthesis.md` | **Human synthesis of 27 topic-enablement tests** — strong-fit domains (tech docs+specs, compliance/audit, HAI artifacts, living/literate docs), weak-fit honesty, novel insights (inline domain annotation, source-of-truth unification, pre-reg/audit convergence). Highest-leverage *secondary* artifact. | Post-run analysis |

### 1b. Adjacent tracks (usage *shapes* / friction, not pure enablement)

Still useful for demand; lower pure-ideation density than 1a.

| Path | Why | Track role |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/test/usability/lib/realistic_tests.rb` | Task definitions = **implicit product scenarios**: YAML-frontmatter+prose → UDON; experiment reports; configs-with-comments; conversation logs; recipes from scratch. | Usage shapes agents were asked to produce |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-realistic-*.yaml` | Outputs + LLM-judge scores for those shapes | Empirical production quality |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/context_comparison.rb` | Tasks: web-server config; **mixed tutorial doc**; org chart; inline-heavy science paragraph; blog **schema**; HTML-email **template** — the *prompts* are product briefs | What “success looks like” scenarios |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-context_comparison-*.yaml` | Same tasks across cheatsheet/minimal/comprehensive context levels | Context × genre matrix |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/validated_tests.rb` | Deterministic-scored convert tasks (overlaps realistic genres) | Feature-expectation as need proxy |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-validated-*.yaml` | Validator-scored production runs | Large volume; sample |
| `/Users/josephwecker-v2/src/udon/test/usability/lib/test_definitions.rb` | Learning-curve context ladder + stress/translate definitions | Pedagogy / cold-start needs |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-learning_curve-*.yaml` | How much context before agents can *use* UDON | Onboarding demand |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-invention-*.yaml` | **Redesign-your-own-notation** (convergence test) — *not* use ideation; include only if mining “what agents reinvent as the problem UDON solves” | Secondary / contrast |
| `/Users/josephwecker-v2/src/udon/test/usability/results/udon-interpretation-*.yaml` | Zero-shot “what does this mean?” | Comprehension, not enablement |
| `/Users/josephwecker-v2/src/udon/test/usability/results/AGENT_FEEDBACK.md` | Aggregated `# FEEDBACK:` blocks — mostly post-task **friction** and syntax likes/dislikes; sparse expansive use catalogs. Still mine for “what would make this easier / what I wanted to do.” | Aggregator |
| `/Users/josephwecker-v2/src/udon/test/usability/ETHICS.md` | Constraints on how agents were tested | Provenance / bias |
| `/Users/josephwecker-v2/src/udon/test/usability/run` | CLI surface of all tracks (`enablement`, `topics`, `realistic`, …) | Index of experiment types |
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_embeddings.rb` | **Secondary analysis pipeline** — embed topic_enablement responses (ollama + pgvector) to find semantic clusters of applications | Meta-analysis tool |
| `/Users/josephwecker-v2/src/udon/test/usability/embed_sentences.rb` | Sentence-level embedding of enablement answers | Same pipeline |
| `/Users/josephwecker-v2/src/udon/test/usability/analyze_chunks.rb` | Chunk analysis over corpus | Same pipeline |

**Mining note for reconcilers:** For “what agents would want UDON *for*,” priority is **`topic_enablement` + free `enablement` + `enablement-synthesis.md`
+ `topic_dsl`**, then realistic/context *task definitions*, then AGENT_FEEDBACK. Treat `invention` / pure learning-curve as contrast, not the main reservoir.

---

## 2. Free-form agent “would *I* use this?” judgments (not design docs)

These are durable session or first-contact artifacts where a model answers usage/value questions without being asked to invent syntax.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/grok/019f67df-orientation.md` | Long **first-person agent utility** answer: living mixed-content sweet spot; when *not* to use; handoff/comment tiers; “real advantage, narrowly.” Joseph-prompted, not marketing. | Session vault extract (~orientation) |
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Dec-2025 essay in **agent voice**: “UDON is optimized for agents”; dumb-pipe vs comprehending-agent litmus; self-chunking; when JSON/MD still win. | Moved from `notes/` 2026-07-16 |
| `/Users/josephwecker-v2/src/udon/_archive/feedback.md` | Fresh Opus 4.5 first-contact review + Q&A (Dec 2025) — impressions, comparisons, concerns after studying 26 markups. Estate review quotes it heavily. | Archived notes |
| `/Users/josephwecker-v2/src/udon/_archive/REVIEW-JULY-2026.md` | Especially the **enablement-predicted-adopters** paragraph (~L179–192) and any CTQ/onboarding sections that cite the usability floor. Meta-evidence about the reservoir’s value, not a use-case dump itself. | Estate review 2026-07 |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/da5d1672-convert-markdown-to-udon-format-for-process-map.md` | Lived conversion of a real process map to UDON; later reflections explicitly **link enablement-synthesis strong-fit list → ASF/vivarium adopters**. | Session vault |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/18aabafc-scan-project-and-create-new-parser-fixtures.md` | Closing judgment: fit for “agents and humans reading unhighlighted text… documents that self-chunk for retrieval.” | Session vault |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/grok/INVENTORY.md` | Index into grok vault extracts | Inventory |
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/claude/INVENTORY.md` | Index into claude vault extracts | Inventory |

Greenfield **feedback-from-*** / `agents-thoughts.md` under `v2/.archived/first-pass/greenfield-*` are mostly *spec architecture* reactions — lower for pure use ideation; open only if reconciling “what agents wanted the *language product* to be.”

---

## 3. Day-in-the-life scenarios (scripted usage journeys)

Already in pass-1, but kept here as a **usage** unit (not design essays). Commissioned 2026-07-16; BDD-style multi-agent day.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/test/scenarios/` | **Whole tree** |
| `…/README.md` | Intent + provisional path vocabulary |
| `…/features/01-understanding.scenarios.udon` | Morning read journeys |
| `…/features/02-diffing.scenarios.udon` | Diff journeys |
| `…/features/03-modifying.scenarios.udon` | Patch / write journeys |
| `…/features/04-multi-agent.scenarios.udon` | Contention, handoff, durable patch plans |
| `…/corpus/*.udon` | Pseudo-real stand-ins for live consumer genres |

---

## 4. Historical “why UDON exists” lineage (pre-2025 objectives)

Pass-1 listed these lightly; they are the original **utility priority matrix**, not syntax law.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_ref/udon/doc/objectives.asciidoc` | **Original priority matrix**: beauty (readability/learnability/self-description), performance, utility (semantic data, hierarchies, document mixing, templating, language mixing, in-doc schema, relational data, narrative texts, …), support (editor, bindings). Core “what it was *for*.” | ~2011-era |
| `/Users/josephwecker-v2/src/_ref/udon/doc/features.asciidoc` | Sparse wishlist: data- or freetext-centric, relational, libraries, binary transport, schema, transforms | Same |
| `/Users/josephwecker-v2/src/_ref/udon/doc/compare-to.asciidoc` | Competitive set (protobuf, thrift, XML, JSON, YAML, LaTeX, slim, …) — implied job-to-be-done via comparison frame | Same |
| `/Users/josephwecker-v2/src/_ref/udon/doc/TODO.asciidoc` | Historical open wants | Same |
| `/Users/josephwecker-v2/src/_ref/udon/README.asciidoc` | Original project framing | Same |
| `/Users/josephwecker-v2/src/_ref/udon/examples/overview.udon` | Early comprehensive usage example | Same |
| `/Users/josephwecker-v2/src/_ref/udon/examples/ws-and-comments.udon` | Whitespace/comment genre | Same |
| `/Users/josephwecker-v2/src/_ref/udon/doc/syntax.udon`, `…/description.udon` | Self-describing early docs | Same |
| `/Users/josephwecker-v2/src/udon/_archive/analysis.md` | Dec-2025 revival analysis through TST; **repository map including `.attic/` / declang predecessor** — pointer into archaeology that may not all still be on disk | Archived notes |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/DECIDED.md` | Early C-era design decisions | ~2011 C impl |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/TODO.md` | Early open wants | Same |
| `/Users/josephwecker-v2/src/_ref/udon-c/docs/NOTES.md` | Scratch usage sketches (e.g. dependency configs) | Same |
| `/Users/josephwecker-v2/src/_ref/udon-c/test/doc.udon` | Early fixture document as usage sample | Same |
| `/Users/josephwecker-v2/src/_ref/udon-ruby/bin/` | **Conversion matrix** (json/md/xml/yaml ⇄ udon) as product-demand evidence for interchange genres | Pre-umbrella gem |
| `/Users/josephwecker-v2/src/udon/_archive/udon-ruby/bin/` | Same matrix absorbed under umbrella archive | Archive twin |

**Note:** `_archive/analysis.md` references `~/src/_ref/udon/.attic/` (syntax2, sample1, scratch comparative, declang). That tree was **not** visible in a plain listing of `_ref/udon/` this pass (gone, gitignored, or elsewhere). Treat as a **search trail**, not a confirmed path.

---

## 5. Joseph-flagged “forgotten” adjacent ideology — SAR AI-first docs

Joseph (session context) called out rediscovering material under `_ref/_arch/sar/docs/` after open-pass maps barely weighted it. These are **not** UDON use-case dumps; they are AI-agent-driven language/tooling ideation that shapes what a notation *for agents* is asked to support.

| Path | Why | Provenance |
|------|-----|------------|
| `/Users/josephwecker-v2/src/_ref/_arch/sar/` | Whole project: “AI-FIRST” language grounded in TST, developed primarily by agents | ~2025-11 archived |
| `…/docs/ai-tst-ideas-and-opportunities.md` | Tools-to-build list, session workflow, architectural principles, anti-patterns — agent-ergonomics ideation | ~2025-11-10 |
| `…/docs/ai-applied-tst.md` | TST reframed for agent cognition; “documentation IS the codebase” | Same era |
| `…/docs/ai-tst-vision.md` | Measurement philosophy (velocity trajectory) motivating AI-first tooling | Same |
| `…/docs/error-messages-plan.md` | Errors that teach domain concepts (DX for agents) | 2025-11-10 |
| `…/OPERATA.md` | Operata thinking in the SAR tree | Same project |
| `…/indent-languages.md` | Indent-language comparative notes | Same |

---

## 6. Product positioning & README claims that encode use theses

Short list — essays that state *jobs*, not implementation.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/design/positioning.md` | Agent-primary framing; litmus test; advantages list (also in §2) |
| `/Users/josephwecker-v2/src/udon/README.md` | **Self-chunking for RAG/embeddings** section; size-comparison as interchange story; attribute-vs-child pedagogy — public “what it’s for” |
| `/Users/josephwecker-v2/src/udon/design/markup-feature-matrix.md` | 26 lightweight markups compared — competitive job space (LLM fluency, structure, embedded languages) |
| `/Users/josephwecker-v2/src/udon/design/markdown-layers.md` | Four distinct markdown *user situations* (pass-1 already had; keep as situation list) |
| `/Users/josephwecker-v2/src/tmp/udon.md` | Apr 2026 external-ish project analysis — mentions usability harness, RAG/AI features, agent tools as completeness axes (meta, not primary) |
| `/Users/josephwecker-v2/src/2026-02-18-long-conversation-emerson.txt` | Outside visitor synthesis: UDON as format tying axiomata/memorata/principia; self-chunking called out (~L429–436) | Long conversation dump |

---

## 7. Live consumers as *confirmation* of enablement predictions

Not a re-inventory (see CONSUMERS.md). Listed only as **empirical validation** of Dec-2025 enablement strong-fit classes:

| Live path | Enablement class it instantiates |
|-----------|----------------------------------|
| `/Users/josephwecker-v2/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Living governance / process document |
| `/Users/josephwecker-v2/src/archema-io/vivarium/DECISIONS.decision-log.udon` | Append-only decision log / audit-ish accretion |
| `/Users/josephwecker-v2/src/archema-io/vivarium/LEXICON.udon` | Dictionary / relational structured prose |
| `/Users/josephwecker-v2/src/archema-io/vivarium/doc/PROCESS.udon` | Norms + safe-subset authoring contract |
| `/Users/josephwecker-v2/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Machine-read law-data with narrative host project |
| `/Users/josephwecker-v2/src/autopax/taxonomy.udon` | Nested taxonomy as living doc |

**Candidate future classes** (from CONSUMERS watchlist — not live `.udon` yet): ADRs, Axiomata, Signa, Operata, Memorata, A2A agent communications, mentoring-feedback, Loci. When mining “what else might UDON be for,” these names are intentional adoption hypotheses, not files.

---

## 8. Scenario corpus genres as intended product surfaces

`/Users/josephwecker-v2/src/udon/test/scenarios/corpus/` (pseudo-real):

- `archema.concept-matrix.udon` — concept matrix genre
- `asf-processes.process-map.udon` — process map genre
- `operata-live.workspace.udon`, `operata.domain.udon` — operata/workspace
- `terrestris.ordinum.udon` — ordinum/law-data
- `vivarium.decision-log.udon`, `vivarium.lexicon.udon` — decision + lexicon

These encode **what the team believed agents would do** with those genres (understand / diff / modify / multi-agent) more than they encode syntax.

---

## 9. Selective demand spikes (already archived, still usage-shaped)

Mine *§ demand tables*, not pipeline ontology.

| Path | Why |
|------|-----|
| `/Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/DEMANDS.md` | Index of demand tables |
| `…/spikes/agent-utility/NOTES.md` | P-A…P-H agent product demands |
| `…/spikes/paths/NOTES.md` | Path boundary demands D* |
| `…/spikes/memory-import/FINDINGS.md` | Session → memory document substrate |
| `/Users/josephwecker-v2/src/udon/v2/udon-needs/pipeline-discussion.md` | Joseph morning demand *sampling* (templates, dialects, schema-guarded edit, mid-stream reconfig, …) — highest-texture steward ideation; also excerpted under quarantine | Live deliberation |

Quarantine excerpt of that sampling (for convenience, not preferred over primary):  
`…/_quarantine/…/discussion-excerpts/joseph-morning-demand-sampling.md`

---

## 10. Outside `~/src` and oddball trails (thin but surprising)

| Path | Why | Caveat |
|------|-----|--------|
| `/Users/josephwecker-v2/vaults/gemini/archive/analysis-v1/analysis/**` | Book analyses with **“Practicability for AI Agents”** sections — agent-ergonomics ideology, not UDON-specific (elsewhere map already flagged) | No “UDON” string hits in vaults this pass |
| `/Users/josephwecker-v2/vaults/Operations/claude-code-tools.md` | Agent tool cheat-sheet | Ideology-adjacent |
| `/Users/josephwecker-v2/.grok/memory/udon-4fdadfea/` | Session memory pointing at reservoirs (usability track weighting, SAR flag) — provenance for *this* gather cycle | Memory, not product source |
| `/Users/josephwecker-v2/src/memorata/` | Hybrid search over Joseph writing + transcripts — **query surface** for “UDON enable / mixed content / what for” | Search, not a file |
| `/Users/josephwecker-v2/src/_ref/_arch/sapientia-weaver-session/tasks/TASK_001_DOCUMENT_PARSER.md` | “Agents defined as markdown documents” — the **problem shape** (YAML frontmatter + prose) UDON claims to supersede | Adjacent problem statement |
| `/Users/josephwecker-v2/src/_core/sapientia/` | Agentic document/agent-as-markdown lineage (already in agentic maps; keep as problem-space, not re-list) | Overlap |

---

## 11. Explicitly deprioritized for *this* pass (so we don’t rediscover as “missed”)

- Parser/generator diaries, fixture YAML event expectations, CORE wording
- Attribute-model proposal series
- Greenfield clean-room full SPEC rewrites (architecture, not use ideation)
- Invention-track usability as primary enablement (it isn’t)
- Quarantine extracts of TODOs/design heads

---

## 12. Gaps / search trails this pass did not finish

1. **`.attic` / declang** under historical udon — referenced by `_archive/analysis.md`, not confirmed present on disk; check git history / other clones.
2. **memorata hybrid queries** for: `topic enablement`, `mixed content`, “I would use UDON”, pre-2015 objectives dumps not yet files.
3. **Full topic seed list** realized in yaml `task:` fields — only a sample was grepped; a miner should `rg '^task:' results/udon-topic_*.yaml` for the complete domain catalog.
4. **Embedding analysis DB** (`udon_analysis` / ollama) — may hold clustered application themes if still reconstitutable; scripts are durable even if DB is gone.
5. **Joseph’s promised end-user + ideation dump** (needs-map standing harvest) — not present as a path yet; primary when it lands.
6. **Vault search for libudon/UDON** returned no matches this pass; ideology deposits remain, UDON-specific vault notes may still exist under other names.
7. **Live unregistered `*.udon`** outside CONSUMERS scan roots — re-run `bin/find-consumers` before treating inventory as closed.

---

## 13. Suggested mining priority for *usage ideation* only

Opinionated reconcilers’ band — not a needs synthesis:

1. **Gold:** `topic_enablement` yaml corpus + `topic_dsl` + free `enablement` yaml + `enablement-synthesis.md` + prompts in `topic_enablement.rb` / `enablement_prompt`.
2. **Silver:** realistic + context_comparison *task definitions* (product briefs); Grok orientation utility essay; `positioning.md`; `_archive/feedback.md`; REVIEW enablement-prediction paragraph.
3. **Bronze:** scenarios feature files + corpus genres; historical `objectives.asciidoc`; Joseph morning sampling in pipeline-discussion; agent-utility/paths demand spikes §8.
4. **Ideology / problem-space (not UDON answers):** SAR `docs/ai-*`, sapientia document-as-agent, vault “Practicability for AI Agents.”
5. **Validation loop:** live CONSUMERS docs as instances of enablement strong-fit classes (do not re-mine as design).

---

## 14. Feedback on the brief / process (optional)

- The failure mode this pass targets is real: **directory-level “stale usability” one-liners hide track-level gold.** Recommend future maps name *tracks* (`topic_enablement` vs `invention`) whenever a harness tree is multi-experiment.
- Pass-1 inclusion bias was still useful (it *pointed* at the directory); the fix is weight and grain, not deletion of design maps.
- Overlap with A/B/C is intentional; R2’s value is re-weighting, not exclusivity.

---

*End of sources-R2. Path map only.*
