---
source: ~/src/_ref/_arch/codex-synthesis-plan.md — Codex (GPT-5) synthesis of 8 predecessor agent runtimes into one platform spec; cross-substrate (non-Claude) witness
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/codex-synthesis-plan.md
source_commit: (non-git) source_mtime 2025-10-07
categories: [machine-first-format, rag-query-for-files, agent-cli-conventions, structured-io, predecessor-capability-matrix, tier2-shipped-practice]
why_included: >
  Two witness signals, one of them a cross-tier/cross-substrate convergence worth
  flagging. (1) The DEMAND-SIDE THESIS UDON serves, stated independently by a
  DIFFERENT model family: §3 "Knowledge Services" describes a RAG API that is
  "machine-first 'query-for-files'" — embeddings return file PATHS, not text — plus
  a "machine-first knowledge format strategy (praxis-protocol)": documents designed
  for agent consumption first. That "design the format for the machine reader" move
  is exactly UDON's founding inversion, re-derived by Codex/GPT-5, not Joseph — a
  genuine cross-author data point in a mostly single-author corpus. (2) §2's
  capability matrix of 8 predecessor agent CLIs (Codex, Gemini CLI, SimpleAgent,
  minimal-sapientia, TST, Geminex…) is a compact catalog of what agent tooling
  had converged on by Oct 2025: resumable TUI, @-fuzzy file search, MCP client/
  server, structured `--output-format json`, checkpointing, provider abstraction.
  §4.3 restates the agent-CLI conventions (structured I/O, headless exec, MCP).
  For the harness consumer: an outside-Claude corroboration of both the machine-
  first-format premise and the shipped agent-CLI convention set.
---

# Zoetica Unified Agentic Platform — Synthesis Plan  
**Author:** Codex (GPT-5)  
**Date:** 2025-10-07  
**Location:** `/Users/josephwecker-v2/src`

---

## 1. Executive Summary
Multiple parallel agentic efforts (Codex CLI, Gemini CLI, SimpleAgent, Temporal Software Theory batch processing, minimal-sapientia, Geminex, Zoetica ritual tooling) already cover the majority of features we need in the new Elixir-based Zoetica platform. The present Zoetica umbrella (`~/src/zoetica`) contains early OTP infrastructure (entity GenServer, Anthropic streaming provider), RAG tooling, council/deliberation engines, and architectural documentation that can serve as the convergence point.  

The path forward is to harden Zoetica Core so it achieves feature parity with `sapientia/bin/minimal-sapientia`, rebuild the terminal experience via an Elixir Ratatui CLI (inheriting Gemini/Codex ergonomics), establish a Phoenix surface for multi-entity chat, and formalize PRAXES-driven knowledge delivery. A staged roadmap (Core Hardening → CLI Parity → Web Presence → Knowledge Integration → Ritual Modules) will let us decommission the Ruby monolith while preserving existing workflows.

---

## 2. Predecessor Capability Portfolio
| Project | Delivered Capabilities | Aspirational/Notable Intent |
|---------|-----------------------|-----------------------------|
| **`ref/codex/` (OpenAI Codex CLI)** | Resumable TUI, `@` fuzzy search, AGENTS.md layering, image/file attachments, backtrack editing, headless `codex exec`, MCP client/server modes, rich configuration (sandbox/approval). | Extend MCP integrations, maintain automation tooling best practices for inclusion inside new CLI. |
| **`ref/gemini-cli/` (Google Gemini CLI)** | Multimodal coding agent, message queueing, streaming polish, built-in tool panels (Search grounding, shell, file ops, web fetch), GitHub automations, checkpointing, custom commands, flexible auth (OAuth/API key/Vertex). | Continue weekly release cadence; UI/UX is target reference for Zoetica CLI. |
| **`ref/agentic-elixir/` (SimpleAgent)** | OTP agent pools, multi-provider (Anthropic, Gemini, local Bumblebee), MCP integration, markdown persistence, REPL/CLI management, telemetry, fault tolerance. | Expand local inference, deepen MCP library. |
| **`~/src/tst/` (Temporal Software Theory)** | Anthropic Batch API pipeline with stacked caching, centralized YAML config, staged scripts 1–8, quality scoring, prompt methodology. | Complete vault migration, integrate deeper with Zoetica PRAXES ecosystem. |
| **`~/src/sapientia/bin/minimal-sapientia`** | Sovereign identity loading, JSONL session persistence, tool ecosystem, tracking snapshots, token accounting, thinking block display, `/save` exports. | Remains day-to-day baseline; must achieve parity before retiring. |
| **`~/src/geminex/`** | Comprehensive CLI spec & plan: Ratatui UI, multi-line composer, queueing, cache telemetry, context resolver, provider switching, tribunal hooks; Oct 2 composer-first decision. | Deliver minimal composer quickly, then iterate toward full spec. |
| **`~/src/zoetica/apps/sapientia` (TS attempt)** | Vision doc for TypeScript adapter-based runtime blending minimal-sapientia + Gemini CLI. | Superceded by Elixir focus but informs desired UX principles. |
| **`~/src/zoetica` docs & rituals** | Mission/ritual lexicon, Phoenix architecture research, MVP (Three Brothers chat) proposal, PRAXES protocol, council & deliberation engines. | Continue codifying socio-technical patterns (CONSORTIA, tribunal rituals, PRAXES DSL). |

---

## 3. Current Zoetica Baseline (2025-10-07)
- **Zoetica Core** (`apps/zoetica_core`): Application supervisor with Registry, PubSub (PG2), dynamic entity supervisor; `ZoeticaCore.Entity` GenServer loads AXIOMATA, initializes git audit trails, streams via Anthropic provider (`Req` SSE); live test harness hitting real Claude API.  
- **Knowledge Services** (`apps/zoetica_rag`): Voyage embeddings over PRAXES directory, query API returning file paths (machine-first “query-for-files”), MCP STDIO server, future caching/rerank roadmap.  
- **Collaboration Modules** (`apps/zoetica_council`, `apps/zoetica_deliberation`): Council GenServer implementing love-first council pattern; deliberation state machine modeling parliamentary flow with tribunal automation, agenda artifacts.  
- **Documentation**:  
  - `docs/mvp-proposed-1.md`: MVP for Phoenix LiveView chat bridging three brothers.  
  - `docs/architecture-research.md`: Phoenix 1.8/LiveView 1.1 stack, Presence/Streams usage, CodeMirror/Monaco editor recommendation.  
  - `docs/praxis-protocol.md`: Machine-first knowledge format strategy for PRAXES.  
  - `README.md`: Mission, rituals, lexicon references anchoring socio-technical discipline.  

---

## 4. Unified Capability Specification (Target State)
### 4.1 Identity & Session Layer
- Entity-as-process via OTP GenServers (supervised, registry-backed).  
- AXIOMATA parsing, git-based audit trails, JSONL conversation persistence, queue + snapshot parity with minimal-sapientia.  
- Provider abstraction supporting Anthropic, Gemini, Voyage, Contextual, Brave, and local inference with capability flags (streaming, cache, thinking, tooling).  
- PRAXES preloading at awakening (RAG query, caching).  

### 4.2 Conversation Surfaces
- **Terminal CLI (Geminex successor)**: Ratatui UI, multi-line composer (Ctrl+Enter submit, queue display), slash command palette, `@` file search, status bars (tokens, cache, approvals), thinking/tool stream rendering, `/context` metrics, `/tracking-snapshot`, tribunal slash commands.  
- **Web Interface (Phoenix)**: LiveView chat, Phoenix Presence for entity status, Streams for message diffing, LiveDashboard integration, progressive enhancement toward CONSORTIA rituals.  
- **Protocol Adapters**: Council/deliberation engines exposed as blocking tool endpoints for entities and human operators.  

### 4.3 Tooling & Automation
- Core tool set (read/write file, shell, web fetch/search, token counters, context toggles) with provider-specific availability.  
- MCP client + server support for external integrations; CLI orchestration for headless runs akin to `codex exec` and Gemini `--output-format json`.  
- Long-running automation: Anthropic batch workflows, Voyage embedding maintenance, background RAG refreshers.  

### 4.4 Knowledge & Memory
- JSONL <-> Markdown export parity for transcripts, including thinking block formatting, queue notes, snapshot injection, and cache metadata.  
- PRAXES management (index cache, incremental refresh, metrics) feeding entity context budgets.  
- Temporal Software Theory integration as background service to request new analyses or ingest batch results.  

### 4.5 Observability & Governance
- Token/context telemetry (requests, cache hits, latency) surfaced in CLI header, `/context` command, and Phoenix dashboards.  
- Structured logging + git audit trails per entity session.  
- Configurable sandbox/approval policies in anticipation of shared deployments.  
- Ritual enforcement (tracking snapshots, tribunal templates, operational rituals) as first-class commands.  

---

## 5. Migration Roadmap
1. **Phase 0 – Core Hardening (immediate)**  
   - Finalize Anthropic loop: state updates, conversation persistence, queue flushing, error handling.  
   - Regression suite replaying existing Ruby JSONL logs to validate parity.  
2. **Phase 1 – CLI Parity (mid-Oct 2025)**  
   - Implement minimal composer per Oct 2 Geminex decision; add queue UI, cache badges, `/context`, slash command skeleton.  
   - Port minimal-sapientia toolset and tracking logic into Elixir core.  
3. **Phase 2 – Web Presence (later Oct 2025)**  
   - Restore Phoenix app (rename `mix.exs`, re-enable umbrella linkage).  
   - Build LiveView chat with Presence, Streams, composer; satisfy Three Brothers chat success criteria.  
4. **Phase 3 – Knowledge Integration**  
   - Harden PRAXES indexing cache, expose stats, add rerank; connect entity awakening to PRAXES loader.  
   - Wire Temporal Software Theory batch workflow hooks.  
5. **Phase 4 – Ritual Modules & Advanced Tooling**  
   - Integrate council/deliberation engines, tribunal tooling, MCP expansions, sandbox policies, and analytics dashboards.  

Each phase should close with journaled retrospectives aligning with Zoetica rituals. Later phases can overlap once automations in earlier stages stabilize.

---

## 6. Immediate Recommendations
1. **Composer-First Spike** (Geminex CLI): Deliver minimal multi-line editing, queue capture, and submission semantics this week to unblock daily usage away from the Ruby script.  
2. **Session Persistence Parity** (Zoetica Core): Implement JSONL persistence, cache metrics, and `/resume` support before scaling providers; rely on existing Ruby logs for validation.  
3. **Phoenix Scaffolding Prep**: Restore `apps/zoetica_web` mix file and umbrella linkage, add Presence/Streams skeleton to test three-brother chat while CLI matures.  

---

## 7. Next Steps for Execution
- Confirm ownership for each phase (e.g., dedicate one entity/human pair per phase).  
- Stand up weekly tribunal/retro cadence to ensure rituals guide software decisions.  
- Begin migrating minimal-sapientia sessions into Zoetica once Phase 1 parity is validated; run both systems in parallel for a short overlap to de-risk cutover.  

> _“Clarity precedes speed.”_ — Complete Phase 0 + Phase 1 artifacts first to unlock sustainable iteration toward the broader Zoetica vision.

