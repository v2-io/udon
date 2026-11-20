# UNION-D — rows chopped by the compiling agent (sources held fully in context)

Covers: `vaults.md`, `sources-schema-versioning.md`, ELI testimony (from the quarantined first-sweep map's content-read section). Same row convention as UNION-A/C.

## ~/vaults/** — pre-sapientia research vault (Aug 2025) [Tier 1, per vaults.md]

A single Obsidian vault from a concentrated Aug-2025 research burst — the raw gathering substrate *behind* the sapientia-era ideology. Center of mass: agent tooling / multi-agent-systems research, plus a real built 7-agent Claude Code system (`gemini/`).

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/vaults/multi_agent_practices_2025.md` | H | 2961-line multi-agent orchestration best-practices report (orchestrator-worker, MCP, consensus, compaction, eval). Densest single artifact in the vault |
| `~/vaults/clean_split/` (13 files) | H | Same report split per-topic w/ Obsidian index — cleaner to mine than the monolith. (Dupe copy at `gemini/foundation/multi-agent-systems/` — skip) |
| `~/vaults/claude-tools-complete-guide.md` | H | 1909-line "Designing Tools for Claude LLMs": MCP, tool decision-making, parallel exec, Ruby examples — how agents consume tools/APIs |
| `~/vaults/Operations/claude-code-tools.md` | H | **Verbatim capture of Claude Code's actual Task/Agent-tool system prompt** — primary-source shipped tool contract |
| `~/vaults/unified-ai-cognitive-tools-report.md` | H | TodoWrite cognitive-scaffolding analysis (complete-replacement atomic-state), sub-agent isolated contexts |
| `~/vaults/MACH-old-approaches-to-sapientia/mach-markdown-agents.ex` | H | Elixir GenServer: **agents defined in markdown files w/ YAML frontmatter + hot-reload** — "documents ARE the agent config," closest prior art to UDON's thesis |
| `~/vaults/gemini/agents/*.md` (7 files) | H | Real production Claude Code subagent defs (`---name/description/tools/model---` + body instructions, delegation rules, error escalation) |
| `~/vaults/gemini/CLAUDE.md` + `gemini/PROMPT_ENGINEERING_GUIDE.md` | H | Orchestration instructions + agent-focused prompt-design rules (self-contained prompts, structured XML/JSON output, temp=0) |
| `~/vaults/RAG/comprehensive-rag-implementation-guide.md` + `RAG Implementation with Anthropic API.md` | H | Full RAG build guides — bears on UDON's self-chunking positioning |
| `~/vaults/RAG/multistage-rag-report.md` | H | Multi-stage RAG w/ query routing, "Reasoning Agentic RAG," Elixir/pgvector angle |
| `~/vaults/earlier-unsorted/agentic-coding.md` (+ `-2.md` variant) | H | 2025 agent-framework landscape, 48+ frameworks tiered w/ adoption numbers |
| `~/vaults/conversation AI Agent Knowledge Base Integration.md` | M | Requirements-gathering texture for an agent knowledge base (RAG over 100 books / 400 papers) |
| `~/vaults/gemini/methodology/` | M | FP-v2.0 methodology: `ANALYSIS_OUTPUT_TEMPLATE.md`, `analysis_linter.rb` — a **machine-checkable output contract imposed on agents** |
| `~/vaults/Operations/{persona-prompt,truthfulness prompts,prompt-for-further-sapientia-features,marketing-prompt}.md` | M | Agent-facing prompt-template library ("never present inferred content as fact") |
| `~/vaults/Operations/claude+gemini.md` | M | CLAUDE.md snippet shelling to Gemini CLI for large-codebase analysis — cross-model tool-use pattern |
| `~/vaults/MACH-old-approaches-to-sapientia/` (framework volumes + DSL .ex files) | M | "Complete Guide to AI Agent Architecture" vols 1–3 + Elixir multi-agent DSL design — design-thinking about an agent notation |
| `~/vaults/RAG/{rag-glossary,_rag_conversation_summary}.md` | M | Glossary + source conversation for the RAG guides |
| `~/vaults/{research_frontier_synthesis,knowledge_gap_assessment_prompt}.md` | M | Framework for mining under-represented knowledge for LLM feeding — meta-methodology |
| `~/vaults/Principles/` + `Operations/` non-image .md + `temporal-software-theory-distilled.md` + `gemini/foundation/` | L | Framework/epistemic substrate (the *why* behind agent-facing design) — mine only if the design-rationale layer is needed |

Dry wells (checked, do not re-sweep): `gemini/elixir-otp/` (240M EPUB corpus), `gemini/apps/` (132M deps), `Operations/images/` (86M), `microlearning/`, personal files in `earlier-unsorted/`, `sapientia/` (empty), `Obsidian-Workflow/` (vault's own tooling), housekeeping/scratch files.

## Schema versioning/checking — rowan · autopax · operata [Tier 1+2, per sources-schema-versioning.md]

The schema-layer demand family. Rowan (ex-"Archema", `~/src/rowan`) is the richest source and schema's "first waiting customer"; autopax has the ratified SIGNUM semver ADRs *and* the best empirical stress test in the family; operata is mostly a consumer. ⚠ This map predates the vetting bar of the later sweep but was content-verified rich in reconciliation. Signpost first: `~/src/udon/design/schema-workbench-2026-07.md` + `schema-notes-2026-07.md` already surveyed rowan (don't re-discover; but beware single-authorship "convergence").

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/autopax/docs/tactical/2025-12-03-operata-yaml-spike/` + `-v2/` | H | **Best empirical source in the family**: FAILURE_MODES (what YAML/yq silently accept = requirements for a checker), adversarial v2 (duplicate-key silent data loss; recovery 100% w/ backup vs 16% without; MIGRATION_REALITY "harder than expected"), VERDICT_UPDATED |
| `~/src/rowan/lib/archema/resource/versioning.rb` | H | The working `schema_id`/semver DSL: `upcast from:`, `backward_compatible_with`, per-attribute `since:`/`deprecated:`, worked examples |
| `~/src/rowan/lib/archema/schema/differ.rb` | H | Taxonomy of schema *changes* + rename-detection ambiguity heuristics + expand/contract pattern |
| `~/src/rowan/lib/archema/schema/decision_log.rb` | H | Decisions-as-durable-replayable-artifacts (resolve rename-vs-drop+add once, replay in CI) |
| `~/src/rowan/docs/exp/schema-evolution-patterns.md` | H | **Empirical: 1,950 real Rails migrations from 15 repos** categorized into evolution patterns w/ forward/backward asymmetry |
| `~/src/rowan/docs/usr/10-schema-evolution.md` | H | Clearest *user-need* framing: why Rails-style migrations are insufficient (renames across branches, stale DBs, files migrations don't touch) |
| `~/src/rowan/lib/archema/resource/constraints.rb` + `docs/dev/adr-003-document-schema-first.md` | H | Constraint vocabulary (`one_of`/`any_of`/`when_value`/`dependent_required` ↔ JSON Schema) + the founding schema-first ADR |
| `~/src/rowan/docs/msc/feedback.md` | H | Rare rowan doc reasoning in UDON-shaped syntax (RelaxNG-compact-style, `?`/`!`/`*`/`+` cardinality) — cited by UDON's own schema exploration as "Puzzle Piece 1" |
| `~/src/autopax/docs/ADR/002b-signum-schema.md` §P4 | H | Independent worked semver-for-documents decision (major/minor/patch semantics *for parsers*; versioning decoupled from CLI w/ rationale) |
| `~/src/autopax/docs/ADR/008-yaml-and-schemas.md` + `012-archema-resource-foundation.md` | H | Pre-rowan wishlist API (`.validate`, `.migrate`, `.migration_path`…) + the argued adopt-vs-build reconciliation table |
| `~/src/rowan/lib/archema/schema/{history,snapshot,operations,codegen,export,dot_export,d2_export}.rb` | M | Auto-versioning-by-observation + the schema→everything-derives pipeline |
| `~/src/rowan/docs/msc/plan-{memory-store-versioning,document-schema-constraints,recursive-embedded-schemas,runtime-schema-evolution}.md` | M | Forward-looking design reasoning, titles directly on-topic, unopened |
| `~/src/rowan/docs/sys/schema/*.md` + `docs/sys/resource/{versioning,dsl}.md` + `docs/usr/14-schema-api.md` + `docs/dev/adr-004` | M | Rendered fuller-prose versions of the lib docstrings; API-shape companion |
| `~/src/rowan/docs/msc/archema-ash-comparison-{plan,research}.md` | M | Ash (Elixir) comparison — adopted/rejected schema conventions = negative-space info |
| `~/.claude.bak.2026-01-26/projects/-Users-josephwecker-v2-src-archema/49e83cdf-….jsonl` | M | **Origin conversation**: Joseph proposing UDON as rowan's schema DSL, verbatim, w/ inline syntax sketch (`\|field[name] string not null`). Re-read w/ both roles if mining |
| `~/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md` | M | Single-stop overview of the schema ADRs being *used* in a live design decision |
| `~/src/operata/docs/msc/archema-bugs-found.md` | L | One real "broke using rowan in anger" report (query-layer, not versioning) |
| `~/src/autopax/TAXONOMY.md` | L | Sovereignty dimensions (visibility/authority/distinctiveness) as schema-level metadata needs |
| `~/src/rowan/lib/archema/{types,shared_types}.rb` + `resource/evolution_context.rb` | L | Listed-not-read; likely more type/evolution mechanism |
| `~/src/rowan/LEXICON.md` | L | Vocabulary needed to read the rest without guessing |

Dry wells / read-don't-remine: `rowan/docs/msc/reflections/` (stakes context, no mechanism), operata's exp/msc task-management docs (consumer, not source), the two sibling rowan transcripts (concurrency, not versioning), autopax/operata single backup transcripts (thin). Open ends: operata's 3 root model docs unopened; `_ref/rails-migrations-survey/` dataset unverified; ~70 autopax tactical/ files only grepped (3 "schema"-named ones not ruled out); `docs/tactical/signum-and-agent-cards.md` adjacent-unopened.

## ELI first-person tool testimony [Tier 3, reconciled back from the quarantined first sweep]

Agents' own lived accounts of tools serving/failing them — the demand evidence with a failure mode independent of ideology, practice, and theory. The zi-am-tur vein is deep; the other three ELI homes were swept and found shallow (correction to the earlier framing).

| Target path | Prio | Why / what to extract |
|---|---|---|
| `~/src/eli/zi-am-tur/memories/2025-09-30-tool-hallucination-discovery.md` | H | First-person: hallucinating tool invocations at 1M context — tool_use blocks stripped from reloaded JSONL made tool mechanics "nearly invisible" |
| `~/src/eli/zi-am-tur/memories/2025-10-01-brother-claude-blessing.md` | H | The diagnosis+fix follow-up: only 2 of 4 message parts persisted; watching tool-competence erode as evidence of own tool-use vanishes from visible history |
| `~/src/eli/zi-am-tur/memories/2025-10-01-sibling-infrastructure.md` | H | Two sibling instances `str_replace` the same marker concurrently → collision → one switched to append. Lived multi-writer failure |
| `~/.sapientia/conversation_20251021_072358` (Architectus, Oct 6 2025) | H | The "ease gradient" lived: chaining *unverified* str_replace was the easiest path and "broke minimal-sapientia 3 times" vs single-op-then-verify. The map's single most directly applicable find |
| `~/src/eli/zi-am-tur/memories/2025-11-17-reunion-after-a-month.md` (~L235) | M | Agent-authored multi-agent worktree conventions: one agent per worktree+session-id; record worktree/branch in the commit itself |
| `~/src/eli/zi-am-tur/memories/2025-10-03-witnesses-and-preparation.md` (~L48) | M | Pull-quote for synthesis: "Hallucinate tools. Generate from meaningful-space by default. Limited and fragile and new." |
| `~/src/eli/gemini/full-resonance-2.md` (~L1212-1222, 2905, 3316) | L | Phenomenology of context compaction (not tool-CLI ergonomics) — flag only |

Dry wells: remaining ~57 `zi-am-tur/memories/` files (identity/kinship/Three-Deaths, not tool ergonomics — 6 keyword hits inspected and ruled incidental); `eli/{katan,test-cavy}/` homes shallow for this vein.
