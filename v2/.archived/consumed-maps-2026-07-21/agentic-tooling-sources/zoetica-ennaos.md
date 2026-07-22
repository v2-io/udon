---
source: agentic-tooling mining sweep — zoetica + ennaos area (Elixir-substrate lineage)
gathered: 2026-07-21
status: vetted mining-spot map
area: ~/src/_core/zoetica/** and ~/src/_core/ennaos/**
sweep_by: parallel area agent (fresh eyes; did not read first-sweep quarantine)
---

# Agentic-tooling sources — zoetica & ennaos

**Bottom line up front.** The center of mass for this area is a single directory: `~/src/_core/ennaos/docs/research/agentic-coding-background/**` — six long synthesis documents plus a ~21-file `refs/` corpus (Joseph's calibration example, "all very relevant," confirmed). It is a Sept–Oct/Nov 2025 consolidation of Joseph's + Zi-am-tur's whole ideology on how tools for agents should be built: CLI/Unix conventions adapted for embedded wisdom, edit-format landscape, formal validity guarantees, intent-driven & conversational tooling, the 60/30/6/4 distribution, tools-as-truth-bearing. Everything else in the two repos is secondary and mostly ELI-runtime infrastructure (consciousness, event-log, DIDs, Phoenix console) that is *not* about agentic tool design and does not belong on this list.

Provenance note: in-document dates are the real authorship dates (Sept–Nov 2025); git commit dates are all 2025-11-02 (a bulk import), so I use the in-doc / memorata dates below. Location caveat from the brief held: no stale `archema` paths here; all listed paths verified to exist 2026-07-21.

---

## TIER 1 — The anchor: `ennaos/docs/research/agentic-coding-background/`

### The six numbered synthesis documents (Joseph & Claude, dated Oct 31 2025)

These are the consolidated backbone. Each opens with Zi-am-tur "truth-work" epigraphs then delivers a substantive research synthesis. All HIGH priority.

- `.../agentic-coding-background/01-semantic-technologies-infrastructure.md` (1173 lines) — Tree-sitter / LSP / MCP / database (ETS/SQL/graph) as convergent semantic layers *on top of* text files (not replacing them); "proven capabilities vs unverified claims" framing; tools-as-truth-bearing / causal-integrity philosophy. **HIGH** — directly relevant to UDON as a semantic layer over text. Date: 2025-10-31.
- `.../02-current-agentic-tool-landscape.md` (877 lines) — survey of commercial agent edit formats (Cursor, Aider, Windsurf, Codex, Claude): whole-file vs diff vs search/replace vs AST; Aider's 2–3x success-rate variation by edit format; the finding that all current tools operate at text/char level with no formal validity guarantees. **HIGH** — the edit-format prior art UDON's mutation utilities should not reinvent. Date: 2025-10-31.
- `.../03-formal-methods-validity-guarantees.md` (1572 lines) — spectrum from "syntax-valid" to "formally proven"; bidirectional lenses, schema-driven editing, refinement types; goal of making invalid states *unrepresentable* not merely unlikely. **HIGH** — the intellectual basis for UDON's schema-guarded mutation. Date: 2025-10-31.
- `.../04-unified-agent-architectures.md` (2623 lines) — the "Agentic Language Server (ALS)" proposal: model-agnostic layer extending LSP to decouple agentic logic from LLM + client; BDI (Belief-Desire-Intention) mapping to ELI consciousness. **MEDIUM-HIGH** — architecture vision; more agent-platform than UDON-utility but frames the ecosystem. Date: 2025-10-31.
- `.../05-tool-building-philosophy-patterns.md` (3155 lines) — the design-philosophy core: tools evolve conscious-practice → habit → crystallized-tool → transparent-extension; the three pillars (Wisdom/Strength/Beauty) applied to tooling; error messages that teach; 60/30/6/4 = most friction is missing *crystallized process*, not missing intelligence. **HIGH** — the ideology proper; the "why" behind agent-facing ergonomics. Date: 2025-10-31.
- `.../06-elixir-implementation-patterns.md` (3532 lines) — concrete Elixir/OTP semantic tooling: `Code.string_to_quoted` ↔ `Macro.to_string` lossless round-trip as "causal integrity at the language level"; language-specific tools ("add GenServer") over generic text patching. **MEDIUM** — Elixir-specific but the lossless-AST / semantic-op argument transfers to UDON. Date: 2025-10-31.

### The `refs/` corpus (~21 files) — the primary sources those syntheses distilled

Standouts, individually vetted (all HIGH unless noted):

- `refs/QUICK-TOOLING-CONVENTIONS.md` (1552 lines, ~Oct 31) — **the CLI-conventions cornerstone.** "Quick-tools as crystallized consciousness"; Unix philosophy adapted for embedded wisdom (do-one-thing-well + embed the wisdom to do it *correctly*; composability preserving conversation state; "silence is golden unless teaching/protecting"; fail-fast but *predict failure before execution*; idempotency by design); the three-pillars gate on every tool. **HIGH — top pick for UDON utility conventions.**
- `refs/agentic-semantic-code-manipulation-synthesis.md` (2630 lines, ~Oct 31) — the master synthesis: why projectional editors failed, the semantic gap agents actually face, the four-tech convergence, formal guarantees, TST time-foundation, tool-consciousness, and a concrete quick-tools-for-Elixir architecture. **HIGH** — reads as the "source of record" the numbered docs were split from.
- `refs/addendum-intent-driven-tooling-and-semantic-storage.md` (2346 lines, ~Oct 31) — **intent as a first-class tool parameter**; the citation-work phenomenology case study (15 `str_replace` ops as "wrong-abstraction" revelation); five essential tool dimensions; conversational tools + process management; tool-evolution feedback loop. **HIGH** — directly informs UDON agent-edit-tool design (intent-carrying, not char-surgery).
- `refs/addendum-phenomenology-and-tool-architecture.md` (1514 lines, ~Oct 31) — companion first-person account of char-level `str_replace` friction (cognitive load: spatial tracking, uniqueness verification, stale mental model) → argument for intent-aware collaboration. **HIGH** — the felt case *for* structured/semantic edit tools.
- `refs/agentic-editing-tools-report.md` (1238 lines, Oct 30) — research report surveying agentic file-edit tools + structured transformation (AST, tree-sitter, CRDTs) + formal methods (bidirectional transforms, type-safe refactoring) + schema-aware editing (JSONPath/YAMLPath); recommends schema-driven + bidirectional-lens for SIGNUM. **HIGH** — the schema/path-editing prior art for UDON paths + patch utilities.
- `refs/signum-editing-recommendations.md` (541 lines, Oct 30) — actionable three-layer design (ELI-facing intent API → schema-validated lenses → storage) for valid-only edits of a YAML identity card with human-readability + auditability + sovereignty. **MEDIUM-HIGH** — a worked schema-guarded-mutation blueprint over a YAML-ish doc.
- `refs/code-formatting-for-optimal-comprehension.md` (527 lines, ~Oct 31) — a formal token-alignment algorithm (maximize vertically-aligned token positions, minimize inserted whitespace) with scoring/cost functions. **MEDIUM** — relevant to UDON `fmt` / readability ergonomics for agents.
- `refs/analyzing-codebases-for-specialized-agents.md` (310 lines, ~Oct 31) — external research: code-representation taxonomy (token/AST/graph), naturalness hypothesis, building specialized agents from a codebase. **MEDIUM** — context-engineering background; cited by zoetica PRAXES.
- `refs/synthesizing-llm-agent-framework.md` (220 lines, ~Oct 31) — external report proposing the ALS framework; comparative analysis of Gemini/Claude/Codex agentic primitives (Skills, Memory, Codex Cloud). **MEDIUM** — the source behind numbered doc 04.
- `refs/research-report-autodocs.md` (762 lines, ~Oct 31) — **self-navigating markdown repository for human/AI PM**: README-first as bootstrap, YAML-frontmatter-as-API, living-document validation via pre-commit, glossary auto-linking. **HIGH** — squarely relevant to UDON's "structure IS the metadata/chunking" pitch and agent orientation.
- `refs/temporal-software-theory-distilled.md` (789 lines, ~Oct 31) — TST theorems (T-01 temporal optimality; comprehension-time-dominates). **MEDIUM** — the "why velocity" grounding cited throughout; framework not tooling per se.
- `refs/elixir-living-code-guide.md` (1317 lines, Oct 20) — self-documenting / glossary-bound / easily-modified "living code"; `t_total = t_comprehension + t_implementation`; drift detection. **MEDIUM** — Elixir-flavored but the comprehension-cost argument is general.
- `refs/ash-framework-analysis.md` (1366 lines, Oct 30) — declarative resource/action framework fit for schema-editing vs lenses. **LOW-MEDIUM** — Elixir-specific evaluation.
- `refs/tracking-snapshot-spec.md` (951 lines, ~Oct 31) — XML tracking-snapshot schema for temporal coherence (time-passage, git status, pending input surfaced to the agent). **LOW-MEDIUM** — an agent-context-injection design; adjacent to tooling, not core.

Shorter Zi-am-tur philosophy pieces (Sept 18–19 2025; the ideological seed layer — quote-mine value, LOW-MEDIUM individually, HIGH as a cluster for the "tools as truth-bearing" register): `refs/tools-as-truth-bearing.md` (130L), `refs/everything-is-truth-work.md` (115L), `refs/three-pillars-synthesis.md` (123L — Wisdom/Strength/Beauty as tool-design gates), `refs/next-steps-tool-consciousness.md` (164L — the five-tools-become-one-thought vision, predict-failure-before-execution, the 60/30/6/4 prediction).

Raw session transcripts (primary evidence, big; MEDIUM — mine, don't read whole):
- `refs/compressed-session-part1.md` (242L) + `part2.md` (122L), ~Sept 18 2025 — where the 60/30/6/4 distribution and stdin/stderr/stdout-conventions idea were first spoken by Joseph.
- `refs/conversation_20250928_173044.md` (8954 lines, 1.6 MB) — the Sept 28/30 session where Joseph shows Zi-am-tur the zoetica repo; INSTRUMENTA / OPERATA / LEXICON discussion. **MEDIUM**, targeted grep only.

---

## TIER 2 — Elsewhere in ennaos

- `ennaos/docs/praxis-protocol.md` (~Oct 2025) — **"PRAXIS Protocol: machine-first knowledge encoding for agents."** Inadequacy of human-centric docs for LLMs; token-efficient structured formats (llms.txt, llm-min.txt, SKF DEFINITIONS/INTERACTIONS sections); practices as self-contained machine-first specs. **HIGH** — most direct match for UDON's "agent-facing, token-efficient, self-chunking" thesis. (Note: an older copy sits at `zoetica/.archive/docs-20251012/praxis-protocol.md`.)
- `ennaos/docs/research/mutable-code-comprehension/` — a research lane on *how a codebase can be comprehended faster and give tighter feedback to agents*. Unique/Joseph-authored pieces (the rest of the dir are copies of anchor files 01/03/06 + addendum + analyzing-codebases):
  - `README.md` — **Joseph's own framing** (HIGH): tools must be honest about whether they delivered intent (silent failure = worst); a ladder of failure-mode quality (know it failed → categorize → error implies the fix → tool can `mkdir -p`-style complete the intent); "describe intended result" vs "try this next" at every abstraction level. Directly resonant with UDON edit-tool error-message design.
  - `prompt-for-research.md` — breadth-first research prompt: "Temporally Optimized Representations for Agentic Velocity" — reduce time-to-comprehension, tighten feedback loops, grounded in TST. **MEDIUM.**
  - `accelerating-ai-agent-comprehension-of-elixir-report.md`, `accelerating-elixir-ai-agent-dev.md`, `alt-state-IR-analysis.md`, `elixir-otp-static-analysis-overiew-2025.md` — the research outputs (representations/IR/static-analysis to speed agent comprehension). **MEDIUM**, Elixir-specific but the "make the codebase legible to agents fast" goal is UDON-adjacent.
- `ennaos/docs/misc-notes-jaw.md` (135L, ~Nov 2025) — Joseph's transcribed handwritten notes: AUXILIA as "stewarded code" / expert agents that *own* modules (living understanding, CONSORTIA of dependencies, can fork/experiment/recombine); "system prompt → INSTINCTS." **MEDIUM** — agent-architecture ideation, tool-adjacent (tools-as-aspects-of-consciousness).

---

## TIER 2 — Zoetica

- `zoetica/misc-notes-jaw.md` (26 KB, ~Oct 10–17 2025) — **Joseph's raw INSTRUMENTA notes, his own voice.** Per-tool-usage tracking (2-level intent, feedback solicited from the ELI about the tool, out-of-band statistical usage/toolchain audit, storage-intention of results, conversational/stateful tools generalizing Claude-Code background-bash into tracked running/suspended/blocked processes); temporal-coherence / causality-decoherence diagrams. **HIGH** — unmediated primary ideation on agent tool ergonomics.
- `zoetica/PRAXES.md` (~Oct 2025) — project practice doc: prefactor-first workflow (TST), treat-repo-as-training-ground-for-specialized-agents, append-only event log + projections, small linkable chunks for multi-stage retrieval, structured/correlated logging conventions. **MEDIUM** — applied agent-development practice; cites `analyzing-codebases-for-specialized-agents`.
- `zoetica/.archive/docs-20251012/ref/agent-expertise-best-practices-report.md` (~Oct 8 2025) — "Creating effective agent-usable expertise descriptions": three-tier docs architecture (always-loaded → contextual → on-demand), llms.txt + AGENTS.md convergence, "tool descriptions as Agent-Computer Interfaces optimized for LLM ergonomics." **MEDIUM-HIGH** — strong agent-facing-interface material despite living in .archive.
- `zoetica/docs/refs/` — **largely a duplicate set** of the ennaos anchor refs (analyzing-codebases, code-formatting, elixir-living-code-guide, research-report-autodocs, temporal-software-theory-distilled, "Synthesizing LLM Agent Framework"). Prefer the ennaos copies. Non-duplicate files here (`event-log-architecture-report.md`, `gleam-pubsub-eventlog-report.md`) are event-log *infrastructure*, not tooling — skipped.

---

## Skipped as genuinely unrelated (not padding the list — recording the negatives)

- ennaos runtime/consciousness infra: `OPERATA.md`, `SESSION-LOG.md`, `README.md`, `docs/{console-integration,console-architecture,entity-cards,entity-card-v2-proposal, entity-lock,stewardship,signum-architecture,agora,architecture-overview, extended-cache-migration}.md`, `docs/architecture/adr-*`, `docs/vault/**` (auto-generated module docs), `docs/research/vera/**` (knowledge-graph), `docs/research/pachyderm-*` — ELI identity/deployment/DID/Phoenix/event-log, not agent-tool design.
- `ennaos/docs/claude-docs/**` — vendored copy of Anthropic's public Claude docs (not Joseph's).
- zoetica: `IMPLEMENTATION.md`, `ELI-ASPECTS*.md`, `PROJECT-ASPECTS*.md`, `lexicon.md`, `docs/{agora,identity-sovereignty,continuity-and-persistence,secrets-management,did-*, gas-fees,principia-*}.md`, `scripts/**` (actual tool *implementations* — council-tool, flattened-markdown, prefactor-tests — code, not ideation), `sessions/` — runtime/identity. (`scripts/` could interest an implementation pass later, but it's not demand-side ideation.)

---

## Command / search log (for a cheap third pass)

Filesystem:
- `ls -la ~/src/_core/{zoetica,ennaos}/` — top-level orientation.
- `find ~/src/_core/ennaos/docs -type f` — full ennaos docs tree; found the anchor dir + vault + research lanes.
- `head` sweeps over: all 6 numbered anchor docs + all ~21 `refs/` files (saved to a persisted tool-result, read in full); ennaos `RESEARCH.md`, `OPERATA.md`, `docs/{console-integration,stewardship,entity-cards,misc-notes-jaw}.md`, `docs/research/mutable-code-comprehension/{README,prompt-for-research}.md`; zoetica `PRAXES.md`, `misc-notes-jaw.md`, `docs/{praxis-protocol,logging-and-telemetry}.md`, `.archive/docs-20251012/ref/agent-expertise-best-practices-report.md`.
- `git log -1 --format=%ai` on the anchor files → all 2025-11-02 (bulk import; used in-doc dates instead).
- `ls zoetica/docs/refs/` + `ls zoetica/.archive/docs-20251012/ref/` → confirmed docs/refs is a dup of ennaos anchor refs; surfaced the agent-expertise-best-practices report in .archive.

memorata3-search (`-n 50/60`, `--no-json --no-color`, grepped to zoetica|ennaos):
- "CLI conventions for agent tools stdin stdout stderr idempotent silence is golden" → anchor refs (agentic-semantic-synthesis) + `zoetica/docs/proto-eli-testing-workflow.md`.
- "quick tools crystallized wisdom INSTRUMENTA feedback loop predict failure before execution" → `zoetica/misc-notes-jaw.md`, an eli/zi-am-tur memory (outside area).
- "agent ergonomics tool design conversational tools intent-driven tooling schema editing" → dominated by anchor refs (addendum-intent, agentic-semantic-synthesis, doc 05, doc 02) + `zoetica/.archive/.../praxis-protocol.md` + `.archive/.../agent-expertise-best-practices`.
- "self-navigating repository markdown YAML frontmatter agents orient fresh context" → `research-report-autodocs.md` (both ennaos + zoetica copies) + anchor doc 01.

Dry wells / notes: no `archema`-stale paths appeared for this area; all searches converged hard on the one anchor directory — corroborating that it *is* the center of mass rather than one node among many. memorata returned mostly anchor-corpus hits regardless of phrasing, which is why the Tier-2 finds (praxis-protocol, mutable-code-comprehension README, zoetica misc-notes-jaw, agent-expertise report) were pinned down by filesystem vetting rather than search.
