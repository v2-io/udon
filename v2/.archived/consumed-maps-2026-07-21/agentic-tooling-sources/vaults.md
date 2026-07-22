---
source: agentic-tooling-sources sweep — area ~/vaults/**
gathered: 2026-07-21
status: vetted mining-spot map
---

# ~/vaults/** — vetted map

## What this deposit IS

`~/vaults/` is a single **Obsidian vault** (has `.obsidian/` with plugins, themes, workspace) dating to a concentrated **research burst in Aug 2025** (most files Aug 18–31 2025; a few later touch-ups into Jan/May 2026, and some imported personal notes back to 2024). It is the **pre-"sapientia" research substrate** — the raw gathering vault behind Joseph's AI-cognitive-framework / agentic-systems work, before that material moved into `~/src/`. Its center of mass is overwhelmingly **agent-facing tooling and multi-agent-systems research**, which makes it a genuine reservoir for this sweep — the earlier "substantial agent-oriented deposit" note was correct.

Rough thematic split:
- **Directly on-topic (agent tooling / multi-agent / RAG / agent-as-markdown):** the top-level report `.md`s, `clean_split/`, `RAG/`, `gemini/` (a *real built* 7-agent Claude Code system), `MACH-old-approaches-to-sapientia/` (a markdown-agent DSL), and a handful of `Operations/` + `earlier-unsorted/` files.
- **Adjacent substrate (AI cognitive/epistemic framework, not tooling per se):** `Principles/`, most of `Operations/`, `MACH` framework-theory volumes, `temporal-software-theory-distilled.md`. Relevant as the *why* behind agent-facing design; not tool-mechanics evidence.
- **Off-topic / personal:** much of `earlier-unsorted/` (family letters, homes for rent, court/hearing notes), `microlearning/` (a startup market-analysis side project), `Operations/images/` (86M of image assets), and the large binary corpora inside `gemini/` (240M of EPUBs, 132M of app deps). Logged as dry wells below.

Note on sizes: `gemini/` is 556M and `Operations/` 87M, but that mass is **binary corpus/assets**, not text — the agentic-tooling-relevant text in each is a small, specific subset called out below.

---

## High priority — direct, substantive agent-tooling evidence

### Multi-agent orchestration research
- **`multi_agent_practices_2025.md`** (2961 lines, Aug 21 2025) — a full "Multi-Agent Coordination and Orchestration: Best Practices 2025" report: orchestrator-worker pattern, MCP tool integration, context management/memory, consensus mechanisms, sub-agents/hierarchy, epistemological models, context compaction, production deployment, eval/observability. Cites Anthropic's Research system, Gemini 2.5 Deep Think. **The single densest artifact here.**
- **`clean_split/`** (13 files, ~2025 lines total, Aug 22 2025) — the same multi-agent report **split into per-topic notes** with an Obsidian index (`_multi-agent-guide-index.md`). One file per topic: `architectural-patterns`, `tool-integration-via-model-context-protocol`, `context-management-and-memory-mechanisms`, `sub-agents-and-hierarchical-structures`, `consensus-mechanisms`, `context-compacting-and-compression`, `evaluation-and-observability`, `framework-evolution-and-current-landscape`, `enterprise-implementation-patterns`, `production-deployment-patterns`, `epistemological-models`, `future-directions-and-research`. Cleaner to mine than the monolith. (A second copy lives at `gemini/foundation/multi-agent-systems/` — same set.)

### Tool design & the actual Claude Code tool surface
- **`claude-tools-complete-guide.md`** (1909 lines, Aug 25 2025) — "Complete Guide to Designing Tools for Claude LLMs (2025)": MCP deep dive, Claude's tool decision-making architecture, tool-design philosophy, parallel tool execution, extended thinking, security/production, testing, plus full Ruby implementation examples. Directly about *how agents consume tools/APIs*.
- **`Operations/claude-code-tools.md`** — **verbatim capture of Claude Code's actual Task/Agent-tool system prompt** (the "Launch a new agent…" spec, when to/not to use the Agent tool, the TypeScript `{description, prompt}` schema). Primary-source evidence of a shipped agent-facing tool contract.
- **`unified-ai-cognitive-tools-report.md`** (512 lines, Aug 25 2025) — "AI Cognitive Tools and Task Management Paradigms": deep analysis of Claude Code's **TodoWrite** cognitive-scaffolding mechanism (complete-replacement atomic-state pattern), sub-agent isolated contexts, extended thinking, computer use, code-first action representation. On-topic for how agents represent/track their own work.

### Agent-as-markdown / notation-for-agents (closest to UDON's thesis)
- **`MACH-old-approaches-to-sapientia/mach-markdown-agents.ex`** — an Elixir `MACH.MarkdownAgents` GenServer: **agents defined in external markdown files with YAML frontmatter + hot-reloading**, frontmatter = structured config, body = documentation *and* agent instructions. This is a concrete "documents ARE the agent config" design — highly relevant to UDON's agent-facing premise.
- **`gemini/agents/*.md`** (7 files, Aug 23 2025) — **real Claude Code subagent definitions** with the standard `---name/description/tools/model---` frontmatter
  + markdown-body instructions (research-coordinator, claim-analyzer, content-extractor, fp-grounding-agent, citation-researcher, quality-validator, output-formatter). Live examples of the markdown-agent format in production use, incl. delegation rules, error-escalation protocols, model/tool assignment.
- **`gemini/CLAUDE.md`** + **`gemini/PROMPT_ENGINEERING_GUIDE.md`** (Aug 2025) — the orchestration instructions and an "AI Agent Prompt Engineering Guide for Claude" (agent-focused design rules: self-contained prompts, structured XML/JSON output for parsing, deterministic temp=0, externalized reasoning). Evidence of what agents need from prompt/config formats.

### RAG (bears on UDON's self-chunking / structured-doc claims)
- **`RAG/comprehensive-rag-implementation-guide.md`** (63K, Aug 20 2025) and **`RAG/RAG Implementation with Anthropic API.md`** (82K) — full RAG build guides against the Anthropic API. Relevant to UDON's "documents self-segment for embeddings/RAG" positioning.
- **`RAG/multistage-rag-report.md`** (19K, Aug 20 2025) — multi-stage RAG with intelligent query routing / "Reasoning Agentic RAG"; includes an Elixir/OTP (pgvector + Bumblebee) implementation angle.
- **`RAG/rag-glossary.md`** (14K) and **`RAG/_rag_conversation_summary.md`** (10K) — glossary + the source conversation that produced the guides.

### Agent-tooling market/landscape surveys
- **`earlier-unsorted/agentic-coding.md`** (238 lines) — "State of AI Agent Building Tools and Development Platforms in 2025": 48+ frameworks tiered (LangChain/LangGraph, AutoGPT, CrewAI, Dify, Cursor, AutoGen, Semantic Kernel, OpenAI Agents SDK, Google ADK, Mastra), with adoption/market numbers and foundational-model coding tools. `agentic-coding-2.md` (203 lines) is a Perplexity-regenerated variant adding a Free* (needs 3rd-party API key) column.

---

## Medium priority — supporting / framing material

- **`conversation AI Agent Knowledge Base Integration.md`** (951 lines, Aug 20 2025) — a full Claude conversation working through options for RAG over 100 books / 400 papers via the Anthropic API + custom orchestration (web-RAG, academic DBs, vector pipelines, chunking for academic content). Requirements- gathering texture for an agent knowledge base.
- **`research_frontier_synthesis.md`** (188 lines) + **`knowledge_gap_assessment_prompt.md`** (127 lines) — a framework/prompt for mining works containing knowledge under- represented in LLM training (temporal/cross-domain/implementation-specificity scoring). Meta-methodology for feeding agents; adjacent, not tool-mechanics.
- **`gemini/methodology/`** — the FP-v2.0 analysis methodology behind the gemini agent system: `ANALYSIS_OUTPUT_TEMPLATE.md`, `analysis_linter.rb` (a Ruby quality gate agents must pass), `examples/` (good/bad worked analyses incl. circuit-breaker, conflicting-evidence, low-confidence patterns). Evidence of a machine-checkable output contract imposed on agents.
- **`Operations/persona-prompt.md`**, **`Operations/truthfulness prompts.md`**, **`Operations/prompt-for-further-sapientia-features.md`**, **`Operations/marketing-prompt.md`** — a small library of agent-facing prompt templates (persona embodiment, "never present inferred content as fact" truthfulness rules). Prompt-engineering evidence.
- **`Operations/claude+gemini.md`** — a CLAUDE.md snippet instructing Claude to shell out to the Gemini CLI (`gemini -p`, `@` file/dir inclusion) for large-codebase analysis exceeding context. A concrete cross-model tool-use pattern.
- **`MACH-old-approaches-to-sapientia/`** (framework volumes) — `MACH-framework-comprehensive.md` (~1668 lines) + volumes 2/3: "The Complete Guide to AI Agent Architecture: From Tools to Cognitive Systems (2025)" — MCP, computer use, adaptive paradigm selection, hierarchical multi-agent, memory/ context. `MACH-discussion-Elixir Multi-Agent DSL Design.md` + the `.ex` files (`mach-elixir-dsl.ex`, `epistemological-hybrid-system.ex`, `hybrid-mach-system.ex`) are a **DSL design for multi-agent systems in Elixir** — design-thinking about an agent notation, medium-relevant to UDON.

---

## Low priority — adjacent substrate (AI cognitive/epistemic framework)

These are the philosophical/foundational layer (truth-seeking AI, first-principles software, cognitive architecture) — the *why* behind agent-facing design, not tooling evidence. Mine only if UDON needs the design-rationale layer.
- **`Principles/`** (14M, mostly the `.md` framework docs + a few PNG/SVG diagrams) — `AI-Cognitive-Framework.md`, `Truth-Seeking-in-AI.md`, `claude-on-truth*.md`, `Claude-memory-and-context.md`, `software-first-principles.md`, `cognitive- architectures-for-ai-true-seeking--claude.md`. Framework theory.
- **`Operations/`** non-image `.md`s — `__FRAMEWORK-*` implementation notes, `AI Reasoning Advances 2024-2025.md`, `ai_reasoning_glossary.md`, `new-developments-so-far.md`. Framework/positioning.
- **`temporal-software-theory-distilled.md`** (46K, Jan 2026) — a later distilled drop of the temporal-software-theory line (predecessor to TFT/AAT). Framework lineage, not agent tooling.
- **`gemini/foundation/`** (excl. the multi-agent-systems copy already listed) — software-first-principles + strategy notes duplicated from `Principles/`.

---

## Dry wells (checked, NOT agent-tooling — logged so they don't get re-swept)

- **`gemini/elixir-otp/`** (240M) — EPUB/book corpus being *analyzed by* the agent system (Elixir/OTP software-engineering books). Source material, not tooling.
- **`gemini/apps/`** (132M) — the monitoring-dashboard app + its dependencies (Vite/node). Build artifacts.
- **`Operations/images/`** (86M) — image assets (brand/marketing/diagrams).
- **`microlearning/`** (356K) — a microlearning-startup market-analysis side project ($8B opportunity, gamification, XR, vertical specializations). Business research, unrelated to agent tooling.
- **`earlier-unsorted/`** — largely personal: `Daughter.md`, `to my love.md`, `hardship letter.md`, `Homes for Rent…Taylorsville.md`, `notes @ hearing.md`, `kids @ wedding.md`, `Suzanna-entries/`, `Joseph-entries/`, plus dated journal files and `neovim_plugins_updated.md` (editor plugin survey). The two `agentic-coding*.md` and some `compass_artifact_*.md` / tech-trends reports are the only agent/tech-relevant items (agentic-coding promoted to High above).
- **`sapientia/`** — empty (0B).
- **`Obsidian-Workflow/`** (120K) — the vault's own tooling (Obsidian MCP scripts, QuickAdd research-capture JS, templates). About operating *this vault*, not about agent notation. Skip unless workflow-automation is of interest.
- **`promissory_note.md`, `scratch.md`, `Software in use.md`, `TODO-resources.md`, `MACH-*.ex` linter/setup** — housekeeping/scratch.

---

## Searches / commands run
- `ls -la ~/vaults/` + `du -sh ~/vaults/*` — established it's an Obsidian vault, Aug 2025 era, with size distribution.
- Listed & sampled heads of every top-level `.md` (claude-tools guide, multi_agent_practices, unified-ai-cognitive-tools, conversation-AI-KB, research_frontier, knowledge_gap).
- `ls` + head-sampled: `clean_split/`, `RAG/`, `gemini/` (README, CLAUDE.md, PROMPT_ENGINEERING_GUIDE, agents/, methodology/, foundation/, analysis/), `Operations/`, `Principles/`, `microlearning/`, `Obsidian-Workflow/`, `earlier-unsorted/`, `MACH-old-approaches-to-sapientia/`.
- Read concrete passages from: research-coordinator agent def, mach-markdown-agents.ex, claude-code-tools.md (Task tool prompt), agentic-coding.md, RAG multistage, MACH-framework-comprehensive, persona/truthfulness prompts.
- `du -sh` breakdowns of `gemini/*/` and `Operations/*/` to locate where the 556M/87M mass actually is (binary corpora/assets, not text) — confirmed the relevant text is a small subset.
- Confirmed `gemini/` is NOT a nested git repo of external origin (has `.git`, i.e. it's Joseph's own project snapshot), `sapientia/` empty.
- Dry-well confirmations: elixir-otp EPUBs, apps/ deps, Operations/images, microlearning, personal files in earlier-unsorted.
