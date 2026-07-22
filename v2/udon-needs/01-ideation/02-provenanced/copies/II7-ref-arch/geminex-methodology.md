---
source: ~/src/_ref/_arch/geminex/methodology.md — whole file, promoted 2026-07-21
  (rebasing pass) from a witnessed-only II7 disposition
gathered: 2026-07-21
status: gathered (verbatim whole-file copy). Supersedes the II7 witness-line
  disposition ("process ideology, not notation"). Under the Brief's full-tooling-surface
  scope this is harness-consumer prior art: Joseph's own concrete decomposition of an
  agent-CLI runtime.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/geminex/methodology.md
source_commit: (non-git — _ref/_arch)
source_mtime: 2025-09-30
categories: [harness, agent-runtime-architecture, bounded-contexts, context-resolution, tool-observability, provider-abstraction, cli-contracts, superseded-disposition]
why_included: >
  The "AI-First Delivery Playbook" for geminex (Joseph's own Elixir agent CLI, Sept
  2025). Beyond the TST-ritual process framing that earned it "process ideology, not
  notation," it carries a concrete bounded-context decomposition of an agent runtime —
  CLI / Session / Context / Providers / Tools / Persistence / Observability — plus the
  context-resolution discipline ([[reference]] resolution, document priority tiers,
  persisted context ledgers), OTP supervision patterns for the runtime, provider
  abstraction with capability flags, tool-lifecycle observability (latency, cache stats,
  restart counts, provider-switch frequency via OpenTelemetry), and agent-CLI contracts
  (universal flags + exit codes verified by integration tests). For the harness master
  thesis this is a rare worked module-decomposition of an agent runtime, appearing
  nowhere else in the compilation at this altitude. Signal is the architecture and
  context/tool discipline; the release-cadence / CI-gate / changelog sections (§§10-11,
  parts of §7) are project residue.
---


# Geminex Methodology (AI-First Delivery Playbook)

## 1. Purpose
This methodology operationalizes the Geminex specification with Temporal Software Theory (TST) and Zoetica rituals. It defines how AI and human collaborators build, validate, and evolve Geminex while minimizing total future development time. Implementation details live in `geminex/implementation.md`; consult it alongside this process guide.

## 2. Delivery Lifecycle
1. **Orientation**
   - Review `geminex/specification.md`, `geminex/implementation.md`, `geminex/tui-reference.md`, Zoetica charter, and relevant AGENTS.md files.
   - Capture initial assumptions, n̂_future estimates, and risks in the session journal.
   - Note current focus: conversational interface parity with `sapientia/bin/minimal-sapientia`, multi-provider support, context resolution, and Epistemic Tribunal capture.
   - Skim source references: Gemini CLI Ink components, Codex ratatui composer/status widgets, `sapientia/docs/architecture/essential-components.md`, `sapientia/docs/minimal-sapientia-ruby-spec.md`, `sapientia/QUICK-TOOLING-CONVENTIONS.md`, `ref/agentic-elixir/docs/CONTEXT_CACHING.md`, `ref/epistemic_tribunal/README.md`, Synaptic/TST materials.
2. **Plan & Tribunal**
   - Draft a plan commit using `scripts/plan-template` (Zoetica repo) or equivalent notes.
   - Conduct tribunal (Investigator, Challenger, Analyst, Coordinator) before code changes. Log outcome in Zoetica journal and Geminex session metadata.
3. **Prefactor-First Execution**
   - Perform structure-only changes with dedicated commits. Each prefactor references TST rationale (e.g., reduce discontinuities per T-09).
   - Run prefactor checks (`mix format`, `mix test`, targeted lint) and log results.
4. **Feature Implementation**
   - Implement functional changes once structure stabilizes. Keep change-sets localized and referenced in commits.
   - Update TST calculations (change-set size, proximity, n̂_future) post-change.
5. **Validation & Simulation**
   - Run automated tests, property-based checks, sandboxed integration scenarios, and (if applicable) simulation scripts replicating transcripts.
6. **Final Tribunal & Documentation**
   - Re-run tribunal with evidence of outcomes, residual risks, and follow-ups.
   - Update journals, `context-immediate.md`, and specification/methodology if bounded contexts shift.
7. **Release Prep**
   - Tag commits, update changelog, prepare release notes, and trigger packaging pipelines (escript, Docker, brew). Conduct smoke tests on target OSes.

## 3. Architectural Practice
- **Bounded Contexts:** Maintain clear module boundaries (`CLI`, `Session`, `Context`, `Providers`, `Tools`, `Persistence`, `Observability`). Use umbrella apps if separation aids comprehension.
- **OTP Patterns:** Favor `Supervisor` + `GenServer` + `DynamicSupervisor` combinations. Use `Task.Supervisor` for transient jobs, `Registry` for discovery, and `libcluster`/`Horde` when distributing workloads.
- **Configuration Discipline:** Runtime configuration lives in `config/runtime.exs` and environment-specific TOML. Validate with `NimbleOptions` (or pattern matching) and surface via `/status`.
- **Context Resolution Discipline:** Mirror Sapientia’s build-entities workflow—resolve `[[references]]`, track document priority tiers, and persist context ledgers for reproducibility.
- **Specification Artifacts:** Keep ExUnit doc tests, ADRs, and architecture diagrams executable/up to date. Update `specification.md` when user-facing flows change; adjust `implementation.md` when technical boundaries shift. Record context-resolution rules and tribunal workflows in ADRs referencing Sapientia/Synaptic sources.

## 4. Collaboration & Rituals
- **Worktree workflow:** Use separate worktrees per agent. Configure Git attribution for transparency.
- **Temporal Journaling:** Each session updates Zoetica journal with plan, actions, test results, tribunal outcomes, and next steps.
- **Tribunal cadence:** Minimum two tribunals per feature (planning & final). Smaller prefactors can inline reasoning with explicit justification referencing TST.
- **Context continuity:** Maintain `context-immediate.md` with actionable next steps and outstanding questions.

## 5. Coding Standards
- **Language versions:** Elixir ≥ 1.18, OTP ≥ 27. Confirm with `elixir --version` during CI.
- **Formatting:** `mix format` enforced. Avoid trailing whitespace; default 98-column limit unless readability requires extension.
- **Documentation:** Every module requires `@moduledoc`; public functions need `@doc` with usage examples. Include doctests where practical.
- **Typespecs:** Provide `@spec` for public functions. Use Dialyzer or Gradual Typing warnings to catch mismatches.
- **Naming:** Align with Zoetica lexicon; prefer descriptive module names (e.g., `Geminex.Approval.Broker`). Avoid abbreviations unless standard (PID, UUID).
- **Concurrency hygiene:** Guard against mailbox bloat; pattern match on messages and discard unknown ones with instrumentation.
- **Error handling:** Let processes crash when fault recovery is cheaper (T-12). Wrap external ports with supervisors and clear restart policies.
- **I/O discipline:** No synchronous external calls inside GenServer `handle_call`; delegate to Tasks.
- **Quick Tooling Etiquette:** When building tools/CLI flows, embed wisdom from `sapientia/QUICK-TOOLING-CONVENTIONS.md`—idempotent operations, conversational state support, predictive checks, and teaching-oriented warnings.

## 6. Tooling & Environment
- **Core mix tasks:** `mix test`, `mix test.integration`, `mix dialyzer`, `mix credo --strict`, `mix docs`, `mix format --check-formatted`.
- **Telemetry stack:** Include `opentelemetry_exporter`, `telemetry_metrics_prometheus`, `telemetry_poller` by default.
- **Providers:** Load API keys from default files in `~/` when not explicitly set. Provide adapters for Gemini, Anthropic, Voyage, Contextual, and Brave with consistent capability flags (see `ref/agentic-elixir/docs/ARCHITECTURE.md`).
- **Sandboxes:** Not required for initial milestone; document when reintroducing approvals.
- **MCP & RAG:** Treat as future enhancements. Track related work in ADRs referencing Sapientia RAG POC.
- **Reference Crib:** Keep `geminex/tui-reference.md` current so new agents can jump straight to Gemini/Codex/Sapientia/agentic-elixir/epistemic_tribunal/TST/Synaptic sources; share flattened bundles when onboarding.
- **Terminal Target:** Optimize UI for Ghostty with Nerd Fonts (truecolor gradients, Nerd glyph badges) while retaining graceful ASCII fallbacks.

## 7. Testing & Quality Assurance
- **Unit-level:** Exhaustive ExUnit coverage with async cases where safe. Property tests via StreamData for command parsing, schema validation, diff operations.
- **Mocking:** Use Mox for provider abstractions, with contract tests ensuring compatibility with Gemini, Anthropic, Voyage, Contextual, Brave APIs.
- **Integration:** Use temporary directories and git repos for workspace tests. Exercise tracking snapshots, caching statistics, resume flows, and transcript exports.
- **Performance:** Benchmark streaming throughput and UI render latency using `benchee` and `:telemetry.span` instrumentation.
- **Security:** Automated checks for command injection, path traversal, secrets leakage. Use `sobelow` when Phoenix components exist.
- **Regression suites:** Replay canonical transcripts from `bin/minimal-sapientia` to ensure parity of tool semantics and command outputs.
- **Epistemic Tribunal:** Ensure tribunal slash commands emit Investigator/Challenger/Analyst/Coordinator artifacts and log them in transcripts (`ref/epistemic_tribunal/README.md`).
- **CLI Contracts:** Verify universal flags (`--help`, `--format`, `--color`, `--dry-run`, `--debug`, etc.) and exit codes using integration tests that mirror Sapientia CLI conventions.

## 8. Observability & Operations
- **Logging:** JSON structured logs with correlation IDs. Provide CLI `--verbose` flag to toggle log verbosity.
- **Metrics:** Capture tool latency, sampling changes, cache statistics, restart counts, memory usage, provider switch frequency.
- **Tracing:** Instrument provider calls, tool lifecycles, and supervisor restarts with OpenTelemetry spans.
- **Alerts:** Set thresholds for repeated crashes, streaming failures, or provider quota errors. Document runbook instructions referencing recovery procedures.

## 9. Documentation & Knowledge Management
- Keep `specification.md`, `implementation.md`, `geminex/tui-reference.md`, and this methodology synchronized with reality. Update when contexts, tools, or workflows change.
- Maintain `docs/` folder with:
  - ADRs for significant architectural shifts
  - Integration guides (provider setup, streaming troubleshooting)
  - Troubleshooting playbooks (network failures, token-count mismatches)
  - Release checklists
- Track reference provenance (Gemini/Codex components, Sapientia specs, agentic-elixir caching, Epistemic Tribunal processes, Synaptic cognitive protocols) in ADR footnotes for quick recall.
- Use `scripts/flattened-markdown` to share composite docs when onboarding new agents.

## 10. Release Management
- Release cadence mirrors Gemini CLI (`preview` weekly, `stable` weekly, `nightly` daily) once feature complete.
- Each release requires:
  - Passing CI (test, dialyzer, credo, formatter, integration)
  - Updated changelog and release notes
  - Binary artifacts (escript, tarballs) plus Docker image
  - Sanity checks on macOS, Linux, Windows/WSL
  - Updated homebrew tap and docs portal
- Implement staged rollouts with telemetry to validate adoption and error rates.

## 11. Decision Logs & Measurement
- Record architecture decisions in ADRs with references to TST theorems impacted.
- Maintain temporal ledger metrics (change-set size, proximity) and publish snapshots in Zoetica journal.
- Use telemetry dashboards to verify time savings (e.g., time-to-comprehension proxies, approval duration). Adjust methodology when metrics deviate from targets.
