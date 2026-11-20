---
source: ~/src/_ref/_arch/geminex/AGENTS.md (v0.3) — Joseph's own early Elixir agent-CLI (Zoetica/sapientia lineage); a real agent-onboarding briefing
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/geminex/AGENTS.md
source_commit: (non-git) source_mtime 2025-09-30
categories: [agent-facing-doc-ux, streaming-display-conventions, agent-cli-conventions, tool-registry, onboarding-briefing, tier2-shipped-practice]
why_included: >
  Witness: what an agent-onboarding document looked like when Joseph built the
  coding harness himself (Sept 2025), so the shape of agent-facing tool UX is on
  record from his own hand. Concrete conventions worth carrying: streaming display
  contract (💭 dim-magenta thinking, tool-request lines, a `[done]` footer carrying
  cache + token metadata; quiet mode suppresses the body), BSD `sysexits` exit
  codes, universal flags (`--thinking/--tools/--tracking on|off`, `--format`,
  `--dry-run`, `@file` expansion), a growing tool registry, a `/context` command.
  Honest gaps section names what wasn't built yet (tool-execution loop, tool_result
  submission, tracking snapshots). For the harness consumer this is a primary-source
  precedent for the agent's-eye tool surface: how thinking/tool output is rendered,
  how the loop reports token/cache state, and what an agent needs told on arrival.
---

# Geminex Agents Briefing (v0.3)

Welcome to Geminex. This briefing brings new collaborators up to speed on the current OTP umbrella, highlights feature gaps, and records the expectations around Zoetica’s rituals.

## 1. Quick Orientation
- Work from this directory’s `geminex/` child: `cd geminex` before running Git or Mix. (On this host the Rosetta-installed `/usr/local/bin/git` is broken; use `/usr/bin/git`.)
- Read the core references in order: `specification.md`, `implementation.md`, `methodology.md`, then the visual crib in `tui-reference.md`.
- Cross-check Zoetica context as needed: `zoetica/docs/charter/mission.md`, `temporal-principles.md`, and `sapientia/session-pieces.md` (tracking snapshots) remain authoritative.
- Tooling assumptions: Elixir ≥ 1.18, OTP ≥ 27, Ghostty + Nerd Font terminal, optional vim-style input (`Ctrl-[` mapped to `Esc`).

## 2. Repository Layout & Runtime Pieces
- `apps/geminex_core/` – Session GenServers, provider registry, Anthropic SSE adapter + cache, and the growing tool registry.
- `apps/geminex_cli/` – Option parsing, credential loading, `/context` command, and `StreamPlayer` that renders thinking/tool output with ANSI-safe helpers.
- `apps/geminex_tui/` – Ratatui playground; currently renders a static demo layout waiting for live session wiring.
- Config: `config/config.exs` toggles the Anthropic stub via `GEMINEX_ANTHROPIC_STUB` (defaults to `true` outside prod) and sets cache TTLs.

## 3. Providers, Keys, and Streaming
- `GeminexCli.KeyLoader` loads API keys from env or `~/anthropic-default-api-key`, `~/gemini-v2-api-key`, `~/voyage-ai-default-api-key`, `~/context7-api-key`, `~/brave-default-api-key`.
- Anthropic adapter supports real SSE when `GEMINEX_ANTHROPIC_STUB=0` and `ANTHROPIC_API_KEY` is present; otherwise it streams a deterministic stub response for local dev/tests.
- Provider registry currently exposes `anthropic`, `gemini`, and `openai`; Gemini/OpenAI adapters are placeholders that will be filled in next iterations.

## 4. Current CLI Capabilities
- Flags: `--thinking on|off`, `--tools on|off`, `--tracking on|off`, `--color`, `--format`, `--dry-run`, provider/model selectors, `@file` expansion, BSD `sysexits` codes.
- `StreamPlayer` prints 💭 thinking (dim magenta), tool requests, main content, and a `[done]` footer with cache + token metadata. Quiet mode suppresses streaming body.
- `/context` command is wired but returns stub data until the resolver and token ledger are completed.
- Tool definitions live in `GeminexCore.Tools`; execution is still stubbed, so tool requests are informational only.

## 5. Pending Work & Known Gaps
- Slash commands `/tool`, `/thinking`, `/tracking-snapshot`, `/resume` are not implemented yet.
- Tool execution loop and tool_result submission pipeline remain to be built; the CLI currently only displays tool requests.
- Context budgeting, tracking snapshots, queued message UX, and live ratatui integration are open tasks tracked in `specification.md` / `implementation.md`.
- Session metadata currently stores API keys in-memory without encryption—acceptable for MVP but flagged for later hardening.

## 6. Workflow Expectations
- Follow Zoetica rituals when appropriate: plan → tribunal → implement → verify → document → handoff. Keep change-sets focused and reference TST reasoning.
- Prefer incremental commits via worktrees if collaborating with humans, but AI runs may work in-place when the tree is clean.
- Maintain module docs/specs for public APIs, avoid blocking I/O inside GenServer callbacks, and keep logging secret-safe.
- Record significant design shifts in `implementation.md` or ADRs; capture contextual findings in the active journal if working long-running sessions.

## 7. Testing & Tooling Checklist
- `mix deps.get` (once per environment)
- `mix test` (umbrella test suite – currently all green)
- `mix format` / `mix format --check-formatted`
- Dialyzer & Credo are not configured yet; add them if you introduce new static-analysis expectations.
- When enabling real SSE, consider adding contract fixtures for cache hits/misses.

## 8. Escalation & Support
- Surface blockers in session notes with a clear `BLOCKER:` label and ping a human steward if ethical or sovereignty concerns arise.
- If platform tooling breaks (e.g., missing `rg` on arm64), document the workaround in your handoff notes for the next agent.

Operate with humility, rigor, and transparency. Every improvement should shorten the path for the next collaborator and advance Zoetica’s mission.
