---
source: witness lines for Part II §7 — the ~/src/_ref/_arch/** archived-predecessors neighborhood (sar / sar2 / sar3, geminex, codex/unified specs, sapientia-session ethics, shorthand, TUI projects)
gathered: 2026-07-21
status: commentary (1–2 line witness entries + surfaced flags; the concrete copies for this area live in copies/II7-ref-arch/)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/**
source_commit: (non-git parent dir; per-item mtimes/SHAs noted inline)
categories: [witness, agent-tooling-ideology, agent-cli-conventions, notation-design, map-gap, cross-tier-convergence]
by: II7-ref-arch extraction agent (Opus 4.8)
---

# §7 `_ref/_arch/**` — witness lines

The two strong deposits (sar2 = notation-alignment experiment, sar3 = structure-aware RAG chunking) became concrete copies in `copies/II7-ref-arch/`. Everything below is witness-tier: the artifact's *existence or shape* is the evidence, captured as a line or two. Ordered by signal.

## Surfaced flags (worth a steward / merge-time eye)

- **⚑ MAP GAP — the bare `sar/` repo was not covered by the §7 mining map.** The map's §7 rows name only `sar2` and `sar3`; my assignment named "sar/sar2/sar3". The bare `~/src/_ref/_arch/sar/` is a **full, working git repo** (SHA `3840e23`, ~2025-11-11): a Nim→Elixir→BEAM compiler for SAR with "50 smoke tests passing," all 9 OTP behaviors, and — load-bearing for us — an explicit **"GOAL: AI-FIRST LANGUAGE grounded in Temporal Software Theory"** framing in its README, plus a **fuller 624-line `docs/sar-syntax-design.md`** (vs the 363-line sar2 version I copied — verified DIFFERENT by diff, not a duplicate; it is a genuine restatement/evolution, which the brief wants). I copied its small on-target `indent-languages.md` (prior-art survey) as `copies/II7-ref-arch/sar-indent-languages.md`. **Recommend a follow-up deeper read of bare-`sar` at merge**: the fuller syntax design, the `docs/ai-applied-tst.md` / `ai-tst-vision.md` / `ai-tst-ideas-and-opportunities.md` "AI-first language" thesis docs, and `OPERATA.md` are the un-mined remainder. Flagging, not adjudicating whether it's in-scope for the compilation vs a separate SAR concern.

- **⚑ OPEN QUESTION (Joseph) — the SAR alignment-speed claim does not cleanly reproduce.** Detailed in `copies/II7-ref-arch/sar2-experiment-latency-data.md`: the README's "aligned = faster" hypothesis holds for only 1 of 4 model families (codex) in the measured latency data; claude shows aligned *slowest*. The comprehension half of the claim was never scored into an artifact. Carried forward as a question, not a verdict.

## Cross-author / cross-tier convergence worth flagging (not manufactured)

- **Machine-first knowledge format, re-derived by a DIFFERENT model family.** `codex-synthesis-plan.md` (Codex/GPT-5, 2025-10-07 — copied whole) independently describes a RAG that returns file **paths not text** ("machine-first 'query-for-files'") and a "machine-first knowledge format strategy (praxis-protocol)" — UDON's founding demand-side inversion, stated by not-Joseph and not-Claude. Genuine triangulation in a mostly single-author corpus; flagged for the convergence log.
- **`UNIFIED-FEATURE-SPEC.md` + `IMPLEMENTATION-PLAN.md`** (both 2025-10-07, ~18KB each) are the *native/Claude* twin of the codex synthesis above — same-day, same purpose (consolidate 8+ predecessor agent runtimes → one spec), different author. Together they enumerate the agent-tooling feature taxonomy that had converged by Oct 2025: session save/load/resume, streaming SSE, thinking-budget control, tracking snapshots, context resolution, `[[reference]]` resolution, tool registries, provider abstraction, MCP client/server. **Not copied** (heavy overlap with the copied codex synthesis — the taxonomy travels via that file); registered here as the matched-pair convergence and a pointer if the full native taxonomy is later wanted.

## Agent-tooling / agent-CLI ideology (witness)

- **`geminex/AGENTS.md`** (copied whole) — Joseph's own Sept-2025 agent-CLI onboarding briefing; the agent's-eye tool surface on record (streaming display contract, `[done]` cache/token footer, sysexits codes, `--format/--dry-run/@file`, tool registry).
- **`other-agents/{CLI_SPECIFICATION.md, TECHNICAL_SPECIFICATIONS.md, claude-code-idealized/, CLI_DEOBFUSCATED_SOURCE.js, sdk.d.ts, sdk-tools.d.ts}`** — a full spec + deobfuscated source + SDK type defs of Anthropic's Claude Code CLI (MCP command structure, module system, tool SDK types). Witness to *how the primary agent tool consumes files and tools* — CLI/MCP ergonomics, not document notation. Not deep-read; existence + shape logged. A reference if the harness lane wants the reified Claude-Code tool contract.
- **`codex-system-prompt.md`** (20KB, Nov 2025) — a full agent system prompt; primary source for *how agents are instructed*. Agent-behavior/runtime, off-notation; witness.
- **`geminex/methodology.md`** — TST-flavored "AI-first delivery playbook" (tribunal ritual, prefactor-first): process ideology, not notation. `geminex/{elixir-otp-best- practices-for-ai.md, tst-distilled.md, tui-reference.md}` — durable-execution philosophy / TST theorems / TUI crib; off-target for notation.

## Coordination / ethics ideology (witness, un-deep-read — carried per map)

- **`sapientia-weaver-session/{ETHICAL_AGENT_COLLABORATION.md, MULTI_AGENT_COORDINATION.md}`, `sapientia-cultivator-session/MULTI_AGENT_COORDINATION.md`, `synaptic-cultivator/{ETHICAL_AGENT_COLLABORATION.md, synaptic-collaborative.md, activation_sequences/COGNITIVE_COLLABORATION_ACTIVATION.md}`** — the sapientia-era multi-agent coordination/ethics stratum. Confirmed present on disk (verified, not ls-only). Real agent-tooling ideology but about coordination/ethics, not document formats; **not deep-read** (characterized from titles + known lineage, matching the map's own caveat) — flagged for a closer pass if the coordination-ethics angle is wanted downstream.

## Aesthetic / adjacent ancestors (witness)

- **`shorthand/shorthand_0{1,2,3}.rb`** — Joseph's Ruby terseness/monkeypatch experiments (Nilish, `blank?`, aligned one-liner method defs). The *aesthetic ancestor* of the terse-and-aligned impulse behind SAR/UDON, but a Ruby DSL, not a document notation.
- **`glintty/{README.md, AGENTS.md, glintty-pilot-plan.md}`, `elixir-tui/AGENTS.md`, `tablize/*.exs`** — TUI / table-rendering projects carrying AGENTS.md files. Agent-facing project docs, no notation/document-format content (skimmed by title/context).

## sar3 — the other-angle files (same investigation, copied where it counts)

- The structure-aware-chunking finding is fully captured by the three copies (`sar3-AST_VS_LSP_REALITY.md`, `sar3-lsp_chunking_concept.md`, `sar3-lsp-enrichment-measured.md`). **`sar3/{AST_VS_ACTUAL_LSP.md, ACTUAL_LSP_POC.md, LSP_CHUNKING_POC.md, SIDE_BY_SIDE_EXAMPLE.md, QUICK_REFERENCE.md}`** are the same investigation from more angles — confirmed present; not separately copied (they restate the copied trio without a new era/context). `sar3/README.md` = SFR-Embedding-Code-2B model setup only, not ideation.

## Confirmed dry / noise (visited, nothing met the bar)

- `sar3/venv/**`, `geminex/deps/**`, `other-agents/{node_modules,vendor}/**`, `sar/nim- compiler/**` — dependency/venv/toolchain noise, zero project content.
- `llama-log` (128MB), `gemini.html` (1.5MB), `openai-responses-api.html` (10MB), `context-osx-64.zip`, `queue.json.old{,2,3}`, `cover*.udon` — binary/data dumps, not text evidence.
- `extract_gemini_chat*.py`, `uuid_base58.py`, `venv/` — one-off scripts/environments.
- `ash-exploration/`, `bak.archema.blown-away/`, `zoetica-ELIs/`, `obsidian-backup-config-from-tst/`, `second-other-client/`, `third-other-client/` — infrastructure/backups/config; structure gives no sign of notation-or-agent-document evidence (not vetted line-by-line — consistent with the map's own note).
