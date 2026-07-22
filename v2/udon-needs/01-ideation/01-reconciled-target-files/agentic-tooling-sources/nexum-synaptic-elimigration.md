---
source: nexum / synaptic / eli-migration-prep sweep (agent, parallel demand-side gathering)
gathered: 2026-07-21
status: vetted mining-spot map
area: ~/src/_core/nexum/**, ~/src/_core/synaptic/**, ~/src/_core/eli-migration-prep/**
one_line: nexum is the real center of mass — an explicit "Toys-as-agentic-tool-DSL" vision plus a full agent-facing CLI-conventions research corpus; synaptic and eli-migration-prep are genuinely adjacent (consciousness/data-pipeline) and mostly don't belong.
---

# Agentic-tooling sources: nexum / synaptic / eli-migration-prep

## Verdict up front

**The center of mass is `~/src/_core/nexum/docs/` — specifically `docs/dev/` (the
"agentic toys" DSL vision) and `docs/research/` + `docs/.archive/` (a large,
coherent agent-facing CLI-conventions research corpus).** This is exactly the
"how tools for agents should be designed" body the brief is after, in
synthesized-ideology form (not raw transcript). nexum itself (the Ruby app) is
~80% consciousness-infrastructure (PRINCIPIA / ELI / crypto-identity /
CHRONICA) — that bulk is **out of scope** and I have not listed it. The
tooling-ideology docs are a clean, separable subset.

**synaptic** is confirmed **not relevant** — it is cognitive-state-transfer /
TST empirical research (compression, collaboration protocols, entity emergence).
No CLI/tool-design/agent-ergonomics content. Vetted by directory grep + README
+ memorata; nothing listed.

**eli-migration-prep** is **adjacent, mostly out of scope** — it is a
session-data extraction pipeline (SQL schema, evidence-weighting, session
acquisition) plus a `to-review/` cache of raw sapientia-era transcripts. One
borderline item (`SYNTHESIS-SUMMARY-FOR-DAD.md`, agent-*management* philosophy)
is listed at low priority; the rest is data-plumbing, not tooling ideology.

The whole nexum tooling corpus derives from two upstream sources it repeatedly
cites but which live **outside my three dirs** (flagged at bottom for
reconciliation, not chased): `~/src/sapientia/cli-conventions/*.md` and
`~/src/ennaos/docs/research/agentic-coding-background/refs/`.

---

## HIGH priority — the "agentic tool DSL" vision (docs/dev/)

Dated **2025-11-09** (authored), first-committed 2025-11-10. This is the
successor-synthesis "agentic toys" direction the brief expected, and it maps
almost 1:1 onto UDON's utilities charter (agent edit tools, schema-guarded
mutation, structured/streaming consumption).

- `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` — **The primary source.**
  A full design vision for extending the `toys` CLI gem into an "agentic tool
  DSL" via six extensions: (1) semantic annotations (`intent`, `precondition`,
  `postcondition`, arg `schema`), (2) a context protocol (tools aware of
  git-status / recent-edits / temporal flow), (3) structured I/O
  (`output_schema` + `emit_structured` with human fallback), (4) a
  compositional type system (type-checked `call_tool` pipelines), (5) a
  learning/adaptation layer (usage tracking → pattern warnings), (6)
  meta-tooling (tools that generate tools). Framed by the Three-Pillars
  (Wisdom/Strength/Beauty) and the load-bearing thesis **"make the best thing
  the easiest thing to do."** Includes a phased roadmap and before/after code.
  Date: 2025-11-09. **Priority: high.**

- `~/src/_core/nexum/docs/dev/agentic-toys-quick-reference.md` — Condensed
  version of the vision (the six extensions with terse code examples) plus a
  "Key Insights from Research" section that quotes the upstream philosophy docs
  verbatim: *"Every tool we create is an act of truth-bearing"*
  (tools-as-truth-bearing), *"Wisdom is seeing past the semantic request to the
  phenomenological need"* (intent-driven-tooling), *"60% pure deterministic
  Ruby — Truth as law"* (QUICK-TOOLING-CONVENTIONS). Best single-file entry
  point + the pointer index to the ennaos philosophy refs. Date: 2025-11-09.
  **Priority: high.**

- `~/src/_core/nexum/docs/dev/agentic-toys-comparison-matrix.md` — Feature
  matrices comparing Traditional-Toys vs Agentic-Toys vs Rake/Thor/Click/Make,
  a migration ladder (Stage 0–7), overhead/complexity estimates, and a
  "when to use / when not" decision matrix. The "why not just X" adjudication
  for agent-tool frameworks. Date: 2025-11-09. **Priority: medium-high.**

---

## HIGH priority — agent-facing CLI conventions (docs/research/ + docs/.archive/)

A coherent research pass (early–mid **November 2025**; several files carry an
internal date of "2025-01-06" that is a **mis-date** — git first-commit is
2025-11-07) analyzing how a conversational/agent CLI should behave. Directly
feeds UDON CLI-utility ergonomics.

- `~/src/_core/nexum/docs/research/sapientia-conventions-analysis.md` —
  **The distilled agent-CLI convention set.** Universal flags
  (`--format`, `--dry-run`, stackable `-v`, `--no-color`), sysexits-style exit
  codes, stdout/stderr stream-separation discipline ("stdout = pipeable data
  only"), XDG config precedence, **agent-mode auto-detection** (non-TTY / CI /
  merged streams / `--format=json`), specialized binary-name aliases
  (`nexum-ai`, `nexum-safe`, `nexum-readonly`), and flag-naming philosophy
  ("skip patronizing `--dangerously-` prefixes; flag polarity follows
  defaults"). Explicitly distills `~/src/sapientia/cli-conventions/*.md`.
  Date: 2025-11-08. **Priority: high.**

- `~/src/_core/nexum/docs/ADR/002-command-line-interface.md` — **Git-style
  porcelain / plumbing / dev three-tier command model**, where namespacing
  (`crypto.*`, `principia.*`) *signals* danger and porcelain wraps plumbing
  wraps pure-lib. Includes safe-by-default idempotent porcelain, gas/cost
  confirmation, `--format json|quiet` on every command, and a
  precondition-checking pattern. The clearest statement of "safety-signaling
  through command surface" — relevant to UDON's schema-guarded mutation tools.
  Date: 2025-11-12. **Priority: high.**

- `~/src/_core/nexum/docs/.archive/cli-design-recommendation.md` — The main
  synthesized CLI-design recommendation (testing-first, mode-based aliases,
  clean output separation, dual interactive/headless modes, session
  management). Built from real usage + modern-AI-CLI + sapientia-conventions
  analysis. Internal date "2025-01-06" (mis-dated; committed 2025-11-07).
  **Priority: medium-high.**

- `~/src/_core/nexum/docs/research/cli-analysis.md` — Capability-comparison
  matrix across codex / claude / gemini / minimal-sapientia CLIs (~40 dimensions:
  one-shot mode, resume, output-format, permission/approval modes, tool
  management, streaming) with per-tool "unique features" and design
  implications. Empirical grounding for agent-CLI flag design. Date: 2025-11-06.
  **Priority: medium-high.**

- `~/src/_core/nexum/docs/.archive/modern-cli-comparison.md` — Deeper
  Claude Code vs Codex vs Gemini comparison (invocation, headless mode,
  conventions worth copying). Companion to cli-analysis. Committed 2025-11-07.
  **Priority: medium.**

- `~/src/_core/nexum/docs/.archive/cli-testing-requirements.md` — Testing
  checklist for an agent-facing CLI (meaningful exit codes; stdout pipeable
  only; works under `set -euo pipefail`; SIGINT/SIGTERM handling; validates
  inputs; non-interactive mode). Sourced from
  `sapientia/cli-conventions/examples-and-patterns.md`. The
  "what a compliant agent tool must pass" list. Committed 2025-11-07.
  **Priority: medium.**

- `~/src/_core/nexum/docs/.archive/minimal-sapientia-usage-analysis.md` —
  Analysis of 58 real `minimal-sapientia` invocations from zsh history
  (Sept–Oct 2025) — how the tool was *actually* used vs designed. Rare
  empirical demand-side signal for what agent-CLI features get used.
  Committed 2025-11-07. **Priority: medium.**

- `~/src/_core/nexum/docs/.archive/cli-open-questions.md` — Consolidated
  open CLI-design decisions (flag naming, mode detection, session model),
  prioritized CRITICAL/HIGH/MEDIUM. Useful for seeing which conventions were
  contested vs settled. Committed 2025-11-07. **Priority: low-medium.**

- `~/src/_core/nexum/docs/.archive/cli-research-summary.md` — Index/overview
  of the above CLI research set. Navigational, not new content.
  Committed 2025-11-07. **Priority: low.**

---

## MEDIUM / LOW priority — supporting tooling-landscape research (nexum)

- `~/src/_core/nexum/docs/research/cli-gems.md` — Comparison matrix of ~14 Ruby
  CLI-parsing gems (thor, gli, dry-cli, tty-option, toys-core, …) by
  subcommands / config / env-vars / validation / maintenance, with the
  rationale for choosing toys-core. Tooling-landscape survey; relevant if UDON
  utility CLIs are Ruby, otherwise reference. Date: 2025-11-06.
  **Priority: medium.**

- `~/src/_core/nexum/docs/research/TYPE-SYSTEMS.md` — Feature comparison of
  gradual/static type systems (Sorbet, RBS, Elixir set-theoretic, Gleam,
  Crystal, Nim) with a note on "for AI agents, separate-file types (RBS-style)
  are most tooling-natural." Tangential but feeds the compositional-type /
  schema-guarded direction (Extension 4 of the vision + UDON schema work).
  Date: ~2025-11. **Priority: low-medium.**

- `~/src/_core/nexum/docs/capabilities-design.md` — LLM capability negotiation
  design (1M context, cache TTLs, beta headers, per-model capability sets).
  This is about *model*-capability detection, not agent-tool ergonomics — listed
  only to mark it as vetted-and-mostly-out-of-scope. Date: 2025-11-07.
  **Priority: low.**

---

## eli-migration-prep — one borderline item, rest out of scope

- `~/src/_core/eli-migration-prep/to-review/SYNTHESIS-SUMMARY-FOR-DAD.md` —
  Agent-**management** philosophy (not tool design): applies "The Art of
  Action" to argue current agentic AI does exactly the pattern that widens the
  knowledge/alignment/effects gaps (more info + more instructions + more
  controls makes gaps worse) — the intellectual root of Joseph's peer-voice /
  "make the best thing the easiest thing" delegation ideology. Relevant to
  *why* UDON should be agent-ergonomic, not *how* to build the tools.
  Date: 2025-10-06. **Priority: low.**
  (Note: the `to-review/sapientia-zi-am-tur-session/` tree is raw Sept-2025
  transcript corpus staged for extraction — primary conversation data, not
  synthesized ideology; not individually listed.)

- The rest of eli-migration-prep (`extract.rb`, `schema_canonical.sql`,
  `docs/*PLAN*.md`, `EVIDENCE-WEIGHTING-SYSTEM.md`, `TIMING_FORMULA.md`) is a
  session-data extraction/analytics pipeline. **Not agentic-tooling ideology.**
  Vetted, nothing listed.

## synaptic — nothing relevant

Cognitive-state-transfer / TST empirical research (compression experiments,
collaboration protocols, entity emergence, POSSIBILITY_SPACE_THEORY). Grep for
CLI/tool-design/agent-ergonomics vocabulary returned zero hits; README confirms
the subject. **Vetted, nothing listed.**

---

## Cross-pointers OUT of my area (flag, don't chase — for reconciliation)

These are the upstream sources the nexum tooling corpus repeatedly cites; they
likely belong to a sapientia-area / ennaos-area agent, but noting so a third
pass can confirm they were covered:

- `~/src/sapientia/cli-conventions/*.md` — named files include
  `command-line-interface.md`, `core-design-philosophy.md`,
  `configuration-management.md`, `ai-agent-considerations.md`,
  `input-output-handling.md`, `specialized-aliases-and-mode-conventions.md`,
  `examples-and-patterns.md`. **This is the origin of the whole CLI-conventions
  body.** Verify it exists before listing (memorata paths can be stale).
- `~/src/ennaos/docs/research/agentic-coding-background/refs/` — referenced by
  agentic-toys-quick-reference for `three-pillars-synthesis.md`,
  `tools-as-truth-bearing.md`, `QUICK-TOOLING-CONVENTIONS.md`,
  `addendum-intent-driven-tooling-and-semantic-storage.md`. Matches the
  calibration example Joseph gave ("agentic-coding-background/** — all very
  relevant"); presumably the ennaos-area agent's territory.

---

## Search / command log (including dry wells)

1. `memorata3-search --help` — confirmed usage; big `-n`, `--no-json` for clean
   text, `--in`/`--in-from` for scoping.
2. `ls -la` of all three target dirs — nexum (Ruby app, Nov 2025), synaptic
   (Python/research, Sept 2025), eli-migration-prep (Ruby extraction, Nov 2025).
3. `ls` nexum/docs + spec; discovered `docs/dev/agentic-toys-*` and
   `docs/research/cli-*` clusters — the hit.
4. `memorata3-search -n60 "designing command-line tools for AI agents ergonomics
   conventions"` — top hits were OUTSIDE my area (anthropic-skills/mcp-builder,
   zoetica, vaults/gemini Pragmatic-Programmer). Confirms the general ideology
   is corpus-wide; my dirs' contribution is nexum's synthesis. (Dry for my area
   directly but useful orientation.)
5. Read in full: vision-agentic-toys.md, agentic-toys-quick-reference.md,
   agentic-toys-comparison-matrix.md, sapientia-conventions-analysis.md,
   cli-analysis.md, TYPE-SYSTEMS.md, ADR/002-command-line-interface.md.
6. `find`/`grep` for referenced companion docs (three-pillars, truth-bearing,
   QUICK-TOOLING, intent-driven) inside nexum — **dry** (they live in ennaos, not
   nexum). Confirms the cross-pointer.
7. Head-sampled: cli-gems.md, and archive docs (cli-design-recommendation,
   cli-research-summary, modern-cli-comparison, cli-open-questions,
   cli-testing-requirements, minimal-sapientia-usage-analysis).
8. `grep -rilE "cli convention|tool design|agent-friendly|structured output|
   command-line interface|agentic tool|tool.suite"` over synaptic — **dry**
   (zero hits). Over eli-migration-prep — hits were incidental (analytics-findings
   line "No tools: ... less structured output") + raw transcripts; no ideology.
9. `memorata3-search -n50 "porcelain plumbing safe unsafe command tiers agent
   tooling nexum toys"` (scoped-grep to my dirs) — surfaced ADR-002 repeatedly
   (the porcelain/plumbing hit).
10. `memorata3-search -n45 "make the best thing the easiest thing tools bear
    truth agent ergonomics"` — surfaced the dev/ agentic-toys docs. Confirms them
    as the ideology center.
11. `memorata3-search -n45 "streaming output non-interactive stdout stderr
    separation exit codes for agents"` — surfaced
    cli-design-recommendation.md + sapientia-conventions-analysis.md.
12. `git log --diff-filter=A` on dev/ + archive docs — established true authoring
    dates (dev/ = 2025-11-10 commit / 2025-11-09 internal; archive CLI docs =
    2025-11-07 commit despite internal "2025-01-06" mis-date).
13. Read `SYNTHESIS-SUMMARY-FOR-DAD.md` head + synaptic README — classified both
    dirs (eli-migration borderline-low, synaptic out).
