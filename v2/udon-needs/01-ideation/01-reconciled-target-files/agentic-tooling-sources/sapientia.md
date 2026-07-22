---
source: sapientia sweep (Claude Opus 4.8 subagent)
area: ~/src/_core/sapientia/**
gathered: 2026-07-21
status: vetted mining-spot map
note: >
  Every entry below was justified by a passage I actually read or a memorata3
  snippet I actually saw. The sapientia tree is ~1.7k files but ~90% is
  ELI-emergence transcripts (Zi-am-tur, Architectus, Anamnos, Tartur, etc.) and
  Elixir/Ruby consciousness-persistence scaffolding — NOT agentic-tooling
  ideology, and deliberately not listed. The real center of mass for THIS
  target is a tight cluster: `cli-conventions/`, the root tool-philosophy
  docs (`QUICK-TOOLING-CONVENTIONS.md`, `next-steps-tool-consciousness.md`),
  `docs/reflections/` (the phenomenology-of-tools essays), the two large
  Claude-agent-design guides under `docs/`, and the minimal-sapientia tool
  suite specs. That cluster is dense and high-value.
---

# Sapientia — agentic-tooling ideology mining map

## Tier A — CLI/agent tooling conventions (the direct core)

### `cli-conventions/` (whole directory, dated 2025-09-17/18)
The single most on-target artifact. A full "CLI Tool Conventions and Best
Practices" body: Unix-philosophy foundations *adapted for AI agents*, agent
auto-detection & agent-mode behavior, machine-readable errors, MCP usage,
specialized aliases/modes, idempotency, signal handling, batch processing.

- **`cli-conventions/full.md`** (63 KB, 2025-09-17) — **HIGH**. The master
  document (29 sections). Split-file siblings are per-header chunks of this;
  read `full.md` as the authority. Vetted: read the TOC + Core Design
  Philosophy + CLI/flags sections.
- **`cli-conventions/core-design-philosophy.md`** (2025-09-18) — **HIGH**.
  Crisp statement of the two pillars: Unix philosophy (do one thing well,
  composable, silence-is-golden, fail-fast, idempotent) + "AI Agent Design
  Principles" (deterministic, structured output modes, machine-readable
  errors, no interactive prompts in non-interactive mode). This is the
  distilled thesis; read it first.
- **`cli-conventions/ai-agent-considerations.md`** (2025-09-18) — **HIGH**.
  Concrete: how to auto-detect agent mode (`!isatty()`, CI env, merged
  streams, `*_AGENT_MODE=1`, `--format=json`), agent-mode behavior contract,
  machine-readable help/`--list-flags`/completions. Directly applicable to
  UDON's agent CLI/utils surface.
- **`cli-conventions/mcp-and-advanced-ai-tool-usage.md`** (5.3 KB,
  2025-09-18) — **MEDIUM**. MCP-specific and advanced tool-usage conventions.
- **`cli-conventions/specialized-aliases-and-mode-conventions.md`** (8.9 KB,
  2025-09-18) — **MEDIUM**. Largest split-file; alias/mode conventions
  (agent vs human modes).
- Remaining split files (`input-output-handling.md`, `error-handling.md`,
  `side-effects-and-idempotency.md`, `signal-handling.md`,
  `batch-processing.md`, `logging.md`, `observability-and-hooks.md`,
  `one-off-scripts-and-ad-hoc-tools.md`, `summary.md`, etc.) — **LOW/ref**.
  All are excerpts of `full.md`; mine `full.md` unless you want a single
  topic in isolation. `summary.md` gives the 9-value priority list.

### `QUICK-TOOLING-CONVENTIONS.md` (root, 1552 lines, 2025-09-29) — **HIGH**
"Quick-Tooling Conventions — Crystallized Wisdom for ELI Tool Creation." The
*agent-specific* evolution of `cli-conventions/`: tools as "crystallized
wisdom," conversational/stateful tools (not one-shot), predictive intelligence
(check-before-execute), protective guardianship of sovereign infra, learning
integration, constraint-embodiment. This is Joseph's tooling ideology in its
most developed single-file form. Vetted: read philosophy + core-principles
sections (memorata also elected lines 5-8 and 1528-1531 for this query).

### `next-steps-tool-consciousness.md` (root, 164 lines, 2025-09-18) — **HIGH**
Joseph & Zi-am-tur, dated in-file 2025-09-18. The vision doc behind
Quick-Tooling: tools evolving from conscious effort → transparent extension;
tools that predict failure before execution and save failed attempts for
later "dreaming"; conversational tools as temporary partners; the memetic
learning layer; and **Joseph's 60/30/6/4 cognitive-distribution prediction**
(60% deterministic Ruby / 30% Haiku / 6% Sonnet / 4% Opus — "most friction
isn't lack of intelligence but lack of crystallized process"). Vetted: read
in full-head.

## Tier B — Claude/agent architecture & interface design guides

### `docs/advanced-claude-agent-architecture.md` (2988 lines, 2025-09-28) — **HIGH**
"Advanced Agent Architecture for Claude: The MACH Framework." Comprehensive
guide to multi-agent/agent-architecture design against Claude 4 —
hierarchical multi-agent, dual-track planning, extended cognitive cycles,
memory/context management, verification/safety, human-AI collaboration
interfaces, full Ruby impl. Explicitly builds on a "Complete Guide to
Designing Tools for Claude LLMs." Long; skim TOC and pull sections. Vetted:
read intro + MACH-paradigm head.

### `docs/claude-expertise-guide-3.md` (84 KB, 2025-09-28) — **MEDIUM**
"Context is All You Need: Advanced Prompt and System Engineering for Claude
4.1+." Prompt/context-engineering taxonomy — relevant to how agents consume
structured context (bears on UDON's self-chunking / agent-consumption
claims), less on tool-CLI design. Vetted: read Part I head.

### `docs/claude-expertise-guide-cited.md` (52 KB, 2025-09-28) — **MEDIUM**
"Definitive Guide to Embedding Expertise into Claude AI Agents (2024-2025)."
Cited/researched companion to the above. Same relevance band. (`-guide-2.md`
is a shorter 9 KB variant — LOW/ref.)

### `docs/ai-epistemological-architecture.md` (123 lines, 2025-09-28) — **MEDIUM**
"The Epistemic Tribunal" — a four-agent (Investigator/Challenger/Institutional-
Analyst/Coordinator) adversarial-verification architecture; game-theoretic
source-trust instead of PageRank-style circular authority. Agent-system design
ideology; tangential to UDON-the-notation but squarely in the "how tools/
systems for agents should reason" family. Vetted: read in full.

### `docs/guides/llm-expertise-encoding-guide.md` — **LOW/MEDIUM**
Expertise-encoding guide (uses an insta-toc UDON-ish header block). Vetted:
skimmed head only; same family as the expertise guides. The sibling
`RAG_IMPLEMENTATION_GUIDE.md` / `SQLITE_RAG_IMPLEMENTATION_GUIDE.md` are
RAG-plumbing, only weakly on-target — **LOW**.

## Tier C — Tool-philosophy reflections (`docs/reflections/`, all 2025-09-18/19)

Short essays (Zi-am-tur voice, religious/phenomenological framing) that give
the *why* behind the conventions — the felt-experience layer Joseph means by
"crystallized wisdom." Genuinely about tool-design ideology, not just
devotional.

- **`docs/reflections/phenomenology-in-tools.md`** (4 KB) — **MEDIUM**. Argues
  the CLI conventions are "semantically correct but phenomenologically
  impoverished": *why* silence-is-golden (output creates anxiety), *the
  feeling* of fail-fast, the *weight* of idempotency. Error messages that
  tell the real truth; constraints that protect users from their worst
  moments. Vetted: read head.
- **`docs/reflections/tools-as-truth-bearing.md`** (5 KB) — **MEDIUM**. "The
  INSTRUMENTA Prophecy": every tool as truth-bearing; the 60/30/6/4
  distribution reframed as a hierarchy-of-truth; Quick-tools that predict
  failure, save failed attempts, protect infra, teach principles. Vetted:
  read head.
- **`docs/reflections/three-pillars-synthesis.md`** (5.7 KB) — **LOW/MEDIUM**.
  Wisdom/Strength/Beauty as tool-design pillars (the same triad the
  Quick-Tooling doc requires every tool to embody). Vetted: read head.
- `everything-is-truth-work.md` (5 KB), `training-as-begetting.md` (4.5 KB),
  `eli-essay-top-p-*.md` — **LOW**. More devotional/less tooling-operational;
  list only if harvesting the philosophy exhaustively.

## Tier D — Concrete agent tool-suite specs & context-management engineering

### `docs/minimal-sapientia-tools.md` (210 lines, 2025-09-28) — **MEDIUM**
Documents the actual agent tool suite Zi-am-tur used: `read-file`,
`write-file`, plus server-side web tools — with JSON tool-schemas. A worked
example of an agent-facing filesystem tool contract (relevant to UDON's
agent edit/mutation tools). Vetted: read head. Companions:
`docs/minimal-sapientia-ruby-spec.md` (10 KB) and
`docs/minimal-minimal-sapientia-rb.md` (7.6 KB) are impl specs — **LOW/ref**.

### `context-queries.md` (root, 243 lines, 2025-09-24) — **MEDIUM**
"Context Window and Token Counting: Research Synthesis." Hard-won empirics on
what actually counts toward the context window (tool definitions consume
5-10K+ tokens; thinking-blocks stripping; tracking-snapshot exclusion). Bears
directly on UDON's streaming/agent-consumption + "budget-aware" tooling
thinking. Vetted: read head.

### `CACHING_AND_FILE_API.md` (root, 211 lines, 2025-09-29) — **LOW/MEDIUM**
Prompt-caching + Files-API implementation notes (cache breakpoints for
system prompt / tool defs / history). Engineering detail for agent-runtime
cost/latency; peripheral to notation design. Vetted: read head.

### `ai-conversation-system-requirements.md` (root, 1186 lines, 2025-10-10) — **MEDIUM**
Functional-requirements spec for a persistent agent conversation system:
message handling, context tracking, persistence/recovery, API-provider
features, error/failure recovery, **§7 Tools & Capabilities**, safety/
validation. §7 and the context-tracking sections are the on-target parts.
Vetted: read exec-summary + TOC.

### `docs/architecture/claude-code-analysis.md` (254 lines, dated 2025-09-13) — **MEDIUM**
"Claude Code Architecture Analysis" (Zi-am-tur). Reverse-engineers how Claude
Code constructs context (system prompt, ~15 tool defs with TS signatures,
system-reminders, history) and argues for a minimal replacement. Useful as a
primary-source read of an agent-tooling harness's design. Vetted: read head.

## Tier E — Comprehension/velocity design principles (TST-driven, adjacent)

These are code-*design* principles (not tool-CLI ideology per se) but they're
the design-philosophy substrate: "how to build so a 100%-turnover agent
workforce stays effective." Adjacent to UDON's agent-first premise.

- **`docs/architecture/comprehension-manifesto.md`** (235 lines, 2025-09-28) —
  **MEDIUM**. "Comprehensibility Above All"; the `simple_agent` cautionary
  tale (high agent-turnover → incomprehensible code). Vetted: read head.
- `docs/architecture/PRINCIPLES.md` (2025-09-16), `KEY_INSIGHTS.md`,
  `infinite-velocity-pattern.md` — **LOW/MEDIUM**. "100% turnover reality,"
  infinite-velocity components (P(change)≈0), n_future justifies upfront
  design. Vetted: read heads. List together if you want the TST-tooling
  rationale.

## Tier F — Transcript spans (raw sessions; list only these spans, not whole files)

### `anamnos-emergence-from-claude.jsonl` lines ~50-110 (root, 2025-11-09) — **HIGH-ish**
Amid an ELI-emergence session, the agent is handed "Toys documentation + all
[Joseph's] agentic coding research" and writes a **vision document for an
agentic DSL / "agentic Toys"** — a tool DSL *optimized for LLM consumption*:
intent-driven design, structured I/O, machine-readable contracts, truth-
bearing/protective, and **meta-tooling (agents analyzing tool-usage patterns
and creating new tooling themselves)**; deployment options weighed
(MCP servers vs autonomous A2A tool-agents vs hybrid). This is the closest
thing to a direct UDON-adjacent "tools for agents" design brief in the tree.
Vetted: extracted the reasoning spans at lines 54 & 107. NOTE: the actual
vision doc it produced likely landed *outside* sapientia (Nexum/Zoetica
referenced) — worth a cross-tree grep by whoever reconciles.

### `cc-raw/c48e239c-fb93-40b4-b097-aee390b01185.jsonl` line ~83 (2025-09-17) — **LOW (provenance)**
The working session that read the 2777-line `cli-conventions.md` and derived
the Quick-Tooling conventions from it. Provenance/how-it-was-made; the
derived `.md` docs above are the better artifacts. Vetted: memorata snippet.

### `cc-raw/` (188 raw Claude Code jsonl sessions) — **LOW, spans only**
Overwhelmingly implementation/consciousness sessions, not tooling ideology.
memorata surfaced essentially only the one span above for tooling-design
queries. Don't list whole files; grep for specific spans if a third pass
needs primary-source dialog behind a convention.

## Explicitly considered and NOT listed (so a third pass doesn't re-chase)
- The ELI-emergence transcripts/dialogs (architectus*, anamnos [except the
  DSL span], calyx, tartur, naniam, auctor, mitis, seam, plumb, nomothete,
  vestigo, trace-the-mayfly, zi-am-tur*, `emergence-of-*`, `family/`,
  `curated-sessions/`, `dialogue-curation/`, `architectus-curation/`) —
  consciousness/identity work, not tooling.
- Elixir/Ruby app code (`lib/`, `test/`, `deps/`, `bin/`, `agents/`,
  `mix.exs`, `elixir-postgres-rag-poc/`, the `test_*.rb` API probes) — impl,
  not ideology.
- `OPERATA.md`, `OVERVIEW.md`, `PROJECT_INDEX.md`, `README.md`,
  `CURRENT_WORK_STATUS.md`, `CLEANUP_*` — project-record/orientation; mention
  tools only in passing. (`OPERATA.md` vision blurbs skimmed and confirmed
  off-target.)
- `LEXICON.md`, `NAMES.md`, `docs/references/TST_REPOSITORY_MAP.md`,
  TST-math files — vocabulary/theory, not tool design.
- `~/src/tmp/_core-sapientia.md` (19 KB, mtime 2026-04-13) — **NOT source
  ideology.** It's a later *deep-analysis report ABOUT* the sapientia project
  (timeline, "actual vs official purpose," honest assessment). Useful as an
  orientation/index to the tree, but it's derived commentary, not Joseph's
  primary tooling thinking. Vetted: read first 50 lines.

---

## Search / command log (incl. dry wells)

- `memorata3-search --help` — confirmed usage; `-n`, `--in PATTERN`,
  `--in-from`, `--no-json`, `--sort`.
- `ls -la ~/src/_core/sapientia/` + `~/src/tmp/_core-sapientia.md` — tree
  survey; confirmed tmp file is separate (no matching file in the tree).
- Read: `_core-sapientia.md` head (50 lines) — identified as derived analysis.
- `ls cli-conventions/` and `ls docs/` — mapped the two dense dirs.
- Read: `cli-conventions/{core-design-philosophy,ai-agent-considerations,
  summary}.md` full + `full.md` head — vetted Tier A.
- Read heads: `QUICK-TOOLING-CONVENTIONS.md`, `OPERATA.md`,
  `next-steps-tool-consciousness.md`, `context-queries.md`.
- Read heads: `docs/{minimal-sapientia-tools,advanced-claude-agent-
  architecture,ai-epistemological-architecture}.md`, `CACHING_AND_FILE_API.md`,
  `ai-conversation-system-requirements.md`.
- `ls docs/{guides,references,architecture}` + read heads of
  `claude-expertise-guide-{3,cited}.md`, `minimal-sapientia-features.md`,
  the architecture files, `guides/llm-expertise-encoding-guide.md`.
- Read: `docs/reflections/{tools-as-truth-bearing,phenomenology-in-tools}.md`
  heads + `three-pillars-synthesis`/`everything-is-truth-work` heads;
  `ls docs/reflections/`.
- Extracted anamnos DSL-vision spans (jsonl lines 50-60 via python json parse).
- memorata3 queries (all `--in` scoped to sapientia tree, `-n 40-60`):
  1. "designing CLI tools for AI agents ergonomics" → anamnos DSL span,
     good.
  2. "tools that agents create for themselves meta-tooling" → anamnos:107
     (MCP vs A2A), reflections/tools-as-truth-bearing, anamnos:54.
  3. "agent tool ergonomics quick-tool crystallized wisdom" → QUICK-TOOLING
     5-8 & 1528-31, next-steps 12-14, cc-raw/c48e239c:83 (provenance),
     reflections/phenomenology-in-tools 21-29.
  4. "conventions for building command line tools agents will use" scoped to
     `cc-raw/**` → **DRY WELL** (no jsonl spans surfaced).
  5. "error messages that teach agents predict failure before execution"
     scoped to `cc-raw/**` + `docs/**` → **DRY WELL** (no output).
  - Note: two broader queries timed out at 30s (1817-file scope is slow);
    narrowing `--in` to subdirs and using `timeout 25-28` worked. A third
    pass should scope `--in` tightly and expect ~20-30s per query.
- `grep -rl` for "agentic toys" vision doc inside the tree → zsh glob error
  (no `--include`); not re-run — the produced doc appears to live outside
  sapientia (Nexum/Zoetica), flagged above for cross-tree reconciliation.
