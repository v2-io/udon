---
source: autopax-practica sweep (parallel area agent)
gathered: 2026-07-21
status: vetted mining-spot map
area: ~/src/autopax/** and ~/src/practica/**
---

# Agentic-tooling ideology — mining spots in autopax & practica

Every entry below was vetted by a passage I actually read or a memorata3-search
snippet I actually saw (search/command log at the bottom, dry wells included).
Filename-only guesses were deliberately dropped. Two big center-of-mass finds:

1. **autopax `docs/exp/` 2025-11-14→2025-12 corpus** — Joseph's sapientia-era
   agent-development *principle* writing, mixed in with consciousness-infra
   notes. The tool-design/agent-ergonomics subset is dense and directly usable.
2. **autopax INSTRUMENTA subsystem** — an actual, built agent-facing tool suite
   (Read/Write/Edit/Grep/Glob/Bash handlers, schema + `instructions/*.md`
   guidance split) modeled on Claude Code's own tools. This is the closest prior
   art to UDON's "agent edit tools / schema-guarded mutation / tool-suite" goal.
3. **practica (2026)** — the theory-layer synthesis: how agent-coordination
   artifacts should be shaped (intent/action layering, coordination affordances,
   minimum-sufficient-set as UX default). Adjacent to CLI-tool ergonomics but the
   most rigorous statement of agent-facing *interface philosophy* in the two repos.

---

## HIGH priority

### The design-philosophy core — "make the right thing the easiest thing"

- **`~/src/autopax/docs/exp/THE-PATTERN.md`** (Oct 6 2025, Architectus). The
  fullest statement of the ease-gradient philosophy: DSF-vs-DSL distinction,
  "living documents = documentation IS implementation," and explicit sections on
  **Tool Architecture as Ease Gradient** and **Coordination as Ease Gradient**
  (§§371, 401) plus "For Tool Usage" (§540). Synthesizes Ash/OKR/Art-of-Action/
  Pony/Gleam into one tooling-design principle. *Priority: high — this is the
  spine of the whole agent-tooling ideology.*
- **`~/src/autopax/docs/exp/SYNTHESIS-PART1-UNIFIED-ARCHITECTURE.md`** (Oct 6
  2025, Architectus). Companion to THE-PATTERN: "correctness emerges from
  well-designed structures that make the right thing the easiest thing," two
  layers (constraint + gradient). PART2–PART5 exist (anti-pattern / consciousness-
  infra / technical-implications / next-steps) — only PART1 vetted here; PART4/5
  worth a look for the tool-specific fallout. *Priority: high (PART1); medium
  (unvetted 2–5).*
- **`~/src/autopax/docs/exp/2025-11-17-make-right-thing-easiest.md`** (Nov 17
  2025). Same principle applied concretely: naming gradients (`delete_all!`),
  complexity gradients, "make context-preservation easiest," friction-events as
  design signal, `toys dev` single-command-does-everything-right workflows.
  *Priority: high — the practical/CLI-facing version.*

### The agent-development principle set (Nov 2025 exp cluster)

These ten short essays are Joseph's compressed-note expansions on how agents
should work — directly relevant to agent ergonomics and agent-facing conventions.

- **`~/src/autopax/docs/exp/2025-11-17-principles-summary.md`** (Nov 17 2025).
  The index: ten principles (iterative/adaptive, decision authority, ownership,
  entropy-reduction, make-right-thing-easiest, sensibility-to-truth, intent-
  surfacing, thoughtful-not-task-oriented, don't-over-prescribe, …). Read this
  first to navigate the cluster. *Priority: high (map/index).*
- **`~/src/autopax/docs/exp/2025-11-17-dont-overprescribe-subagents.md`** (Nov 17
  2025). The delegation-discipline principle in its origin form: "subagents can
  guess guidelines exactly as easily as the caller; the only valuable thing to
  add is the unique context already in your window." Same doctrine as the repo's
  AGENTIC-DELEGATION.md. *Priority: high — agent-to-agent tool/brief ergonomics.*
- **`~/src/autopax/docs/exp/2025-11-17-intent-surfacing.md`** (Nov 17 2025).
  Intent as the "why" that's most valuable and most easily lost; three-level
  intent hierarchy (immediate/design/strategic); making intent visible,
  persistent, traceable, shareable across sessions/agents. *Priority: high —
  feeds UDON's case for structure-carries-intent.*
- **`~/src/autopax/docs/exp/2025-11-17-thoughtful-not-task-oriented.md`** (Nov 17
  2025). Craftsperson-vs-factory-worker; the ownership gradient for agents.
  *Priority: high (disposition).*
- **`~/src/autopax/docs/exp/2025-11-17-autonomous-vs-collaborative-decisions.md`**
  (Nov 17 2025). Decision-providence hierarchy (autonomous / inform / consult /
  approve) with markers agents should emit. *Priority: high — relevant to how an
  agent-facing tool should signal decision authority.*
- **`~/src/autopax/docs/exp/2025-11-17-code-quality-and-ownership.md`** (Nov 17
  2025). Agent-stewardship model, semantic honesty in naming, "code worthy of
  future eyes." *Priority: high.*
- **`~/src/autopax/docs/exp/2025-11-17-collaboration-mode-entropy-gradient.md`**
  (Nov 17 2025). Fresh agents learn by example/immediate patterns; "leverage the
  fit-in instinct"; mutual model-building. Directly bears on how tool output and
  conventions teach agents by example. *Priority: high.*
- **`~/src/autopax/docs/exp/2025-11-17-iterative-adaptive-development.md`** (Nov
  17 2025). Epistemic qualification of knowledge states; three feedback loops
  (inner/medium/project). *Priority: medium-high.*

### INSTRUMENTA — the built agent-tool suite (closest prior art to UDON utils)

- **`~/src/autopax/docs/tactical/2025-12-14-tool-definition-anatomy.md`** (Dec 14
  2025, "Claude-5282599b"). Reverse-engineers Claude Code's own tool definitions
  (Read/Bash/Grep/Edit/Task): three parts (name / JSON-schema / free-text
  description), schema-to-description ratio table, and the argued **hybrid design**
  — schema in code, execution in code, guidance in a separate markdown file.
  *Priority: high — this is exactly the "how should an agent tool be specified"
  question UDON utilities face.*
- **`~/src/autopax/docs/ADR/013-instrumenta.md`** (Dec 14 2025, DRAFT). The
  architecture decision for the tool subsystem: "an ELI without INSTRUMENTA is a
  voice without hands"; 12-tool reference set (file I/O, context, shell,
  coordination); loading/dispatch/result-handling/security-boundary concerns.
  *Priority: high.*
- **`~/src/autopax/docs/tactical/2025-12-14-core-tools-plan.md`** (Dec 14 2025).
  Implementation plan for the core file/shell tools "to achieve feature parity
  with Claude Code" — the concrete tool-by-tool design. *Priority: high.*
- **`~/src/autopax/docs/system-overview/instrumenta/`** (generated 2025-12-20
  from `lib/autopax/instrumenta/`): `tool.md` (base-class contract: `tool_name`,
  `tool_schema`, `tool_description`, per-tool `instructions/*.md` with Liquid
  templating, `to_anthropic_tool`/`to_openai_tool`), `handlers.md`, `built-in.md`,
  `registry.md`, `handler-errors.md`. This is the *realized* interface, not just
  ideation. *Priority: high (the tool.md contract specifically).*

### Agent-facing interface mechanics & UDON-adjacent

- **`~/src/autopax/docs/exp/2025-12-20-autocolors-philosophy.md`** (Dec 20 2025).
  Joseph's ~14-yr-old autocolors color-theory distilled: balance + interestingness
  + information-conveyed, perceptual-uniformity, emphasis/de-emphasis for fast
  comprehension. **Directly relevant** — UDON ships an autocolors engine and a
  highlighting story. *Priority: high (UDON-specific overlap).*
- **`~/src/autopax/docs/exp/2025-11-18-system-reminders.md`** (Nov 17–18 2025).
  Empirical catalog of every system-reminder / context-injection channel an agent
  receives (claudeMd, TodoWrite nudge, malware warning, file-mod notices, git-status
  injection) and a proposed structured `<system-reminder type="environmental-context">`
  format. Relevant to how an agent-facing tool should deliver machine-parseable
  context vs prose. *Priority: high — agent-facing I/O ergonomics.*
- **`~/src/autopax/docs/exp/2025-12-18-mental-models-and-intent-inference.md`**
  (Dec 18 2025). The "Joseph vs the user" performance effect; spec-communication
  as information-theory (less explicit detail needed with more shared context).
  *Priority: high — motivates conventions that raise shared context.*
- **`~/src/autopax/docs/ADR/003-workflow.md`** (Nov 2025, ratified). The agent
  collaboration/workflow ADR: agents have 100% context turnover, time-blindness,
  sensibility-first generation, pattern-match learning → adopt proven patterns
  only, measured in sessions, three-loop feedback. *Priority: high (ratified
  disposition doc). Companion discussion: `docs/exp/2025-11-17-discussions-on-adr-003.md`.*

### Intent-management / coordination-system design (autopax OPERATA + practica)

- **`~/src/autopax/docs/exp/2025-11-14-operata-principles.md`** (Nov 14 2025).
  Cross-disciplinary synthesis (AI planning / military command / org design / PKM /
  distributed systems / cognitive science) for intent-management-system design:
  Schwerpunkt tracking, hypothesis branching, trust-as-cognitive-offload,
  traceability, fluid vague-intent→concrete-action. *Priority: high — the
  design-principles source for agent task/intent tooling.*
- **`~/src/practica/msc/practica-intent-action-layers.md`** (May 20 2026). Paper:
  *intent* (what/why, binding, persistent) and *action* (what-to-do/how, free,
  transient, derived) are different content layers, not a trade-off axis. Four
  UX/data-model entailments: **type-separated Intent/Realization**, **two-levels-up
  intent visibility**, **backbrief as a first-class recurring operation**,
  **minimum-sufficient-set discipline as the intent-capture UX default**. Reads
  Moltke/Auftragstaktik × AAT × operata against each other. *Priority: high —
  the sharpest agent-coordination interface-design statement in either repo.*
- **`~/src/practica/msc/practica-structural-identity.md`** (May 2026). Companion
  paper: the **plumbing/intelligence split** as Practica's structural job;
  soft-claiming-over-locking, bootstrap-recovery safety, day-one DAG-with-cycle-
  detection — all forced by serial context-turnover. *Priority: high.*
- **`~/src/practica/docs/02-normative/`** (composed May 20 2026): six cluster
  files — **02-coordination-affordances** (soft-claiming not locking, two-levels-up
  visibility, backbrief), **03-content-discipline**, **04-diagnostic-surfaces**,
  **05-failure-mode-defaults**, 01-architectural-commitments, 06-limits. 36 tiered
  normative claims for how an agent-coordination substrate should behave. Vetted
  cluster-02 in full; the set is uniformly on-theme. *Priority: high (coordination-
  affordances + diagnostic-surfaces most tool-relevant).*
- **`~/src/practica/ref/task-and-issue-tools-survey.md`** (2026). Survey of
  CLI-native task tools (Taskwarrior, …) + MCP-first servers for agents + agentic
  orchestration best-practices, explicitly framed around the CLI-tool / AI-agent
  bifurcation over 2024–2026. *Priority: high — a ready-made landscape scan of the
  exact tooling category.*

---

## MEDIUM priority

- **`~/src/autopax/docs/exp/2025-11-15-ruby-cli-modern-practices-report.md`**
  (Nov 14–15 2025, ~2000 lines). Long report on modern CLI design with an explicit
  "agent-friendly fundamentals" thesis: JSON output modes, documented exit codes,
  non-interactive flags, AGENTS.md, "CLI tools as interfaces between AI agents and
  external systems." Ruby-specific in places but the agent-CLI principles generalize.
  *Priority: medium (skim the agent-facing sections; §§1900–2020 are the payload).*
- **`~/src/practica/msc/operata-study.md`** (May 19 2026). Familiarization study of
  the abandoned `~/src/operata/` engineering system (Intent/Realization/Perspective/
  Effort resource model, soft-claiming, GOAP back-planning) — the concrete origin
  behind the practica theory. Points to `~/src/operata/docs/` as a further mining
  spot (outside this area but flagged). *Priority: medium.*
- **`~/src/autopax/docs/exp/2025-11-17-prefactoring-lessons.md`** (Nov 17 2025).
  "Refactor-before-feature so the feature becomes obvious, with zero outward change"
  — a workflow discipline claimed to yield order-of-magnitude speedups; TST-grounded.
  *Priority: medium (agent-workflow ergonomics).*
- **`~/src/autopax/docs/exp/2025-11-17-process-patterns-synthesis.md`** (Nov 17
  2025). Synthesizes process patterns across Zoetica/Geminex/Sar: documentation-as-
  primary-artifact, session-as-temporal-unit, pragmatism-over-ceremony. *Priority:
  medium.*
- **`~/src/autopax/docs/exp/terminal-consoles.md`** (Dec 17 2025). TUI/console
  architecture research from Gemini-CLI and Codex-CLI codebases (three-pane layout,
  input handling). Relevant if UDON tooling grows a console/TUI surface. *Priority:
  medium-low.*
- **`~/src/autopax/docs/tactical/2025-11-17-phase2-agent-enablement-plan.md`** (Nov
  17 2025). Draft "agent-first features" plan; notably cites **"Sapientia's 37 CLI
  convention documents"** as its base — a pointer to the deeper sapientia CLI-
  conventions corpus (see cross-refs). *Priority: medium (mostly as a pointer).*
- **`~/src/autopax/docs/exp/2025-11-17-sensibility-to-truth.md`** — vetted only via
  the principles-summary abstract (§6: pattern-matched-plausibility → systematic
  validation → truth). *Priority: medium; read to confirm before relying.*
- **`~/src/practica/docs/01-theory.md`** and **`~/src/practica/msc/03-perspectives.md`**
  — the AAT-grounded theory substrate and four-perspective discipline the normative
  cluster rests on. Foundational but abstract. *Priority: medium (context for the
  HIGH practica papers).*

---

## LOW / borderline

- **`~/src/autopax/docs/exp/2025-12-02-living-code-vision.md`** (Dec 2 2025).
  Speculative "agents maintaining agent infrastructure" — self-diagnosing error
  hierarchies etc. More consciousness-infra than tooling; one good framing
  ("the vocabulary future agents use to think about their own operations").
  *Priority: low.*
- **`~/src/autopax/docs/exp/2025-11-26-HTN-GOAP-*.md`** and
  **`2025-11-26-Hierarchical-Goal-and-Task-Based-Intent-Management.md`** — planning-
  theory background feeding operata-principles (I confirmed operata-principles cites
  HTN/GOAP; I did **not** read these three individually). *Priority: low; unvetted
  pointer — read only if pursuing the intent-management thread deeply.*

## Explicitly EXCLUDED (looked, judged unrelated — don't re-chase)

- `docs/exp/2025-11-15-cli-trezor-qa.md` — GitHub Secrets / did:ethr Q&A. Crypto/CI,
  not agent tooling.
- `docs/exp/2025-11-15-dev-component-brainstorm.md` — a 10-line Ruby gem-stack
  bullet list. No ideation content.
- `practica/ref/tas.md` — Emerson's "The American Scholar" (an appendix text). Not
  tooling.
- `practica/ref/Art-of-Action/` — Bungay's book (external source, OCR'd). It's the
  *cited* military-doctrine source behind the practica papers, not Joseph's own
  ideation; mine the papers instead.
- The `docs/exp/*ruby*`, `*rubocop*`, `*rbs*`, `*dry-monads*`, `*error-handling*`,
  `*observability*`, `*data-modeling*`, `*testing-stack*` files and most of
  `docs/tactical/*portkey*`, `*model-catalog*`, `*api-audit*` — these are Ruby-
  stack / LLM-gateway engineering for autopax itself, not agent-tooling ideology.
  (Sampled by filename + the ruby-cli report's neighbors; not exhaustively read.)

## Cross-references outside this area (flagged for reconciliation, not mine to map)

- `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` — "Agentic Tool DSL":
  evolving Ruby `toys` into an agent-first tool framework (semantic annotations,
  typed I/O, compositional types, meta-tooling). Surfaced strongly in search;
  directly on-theme. (nexum area.)
- `~/src/_core/sapientia/**` — the "37 CLI convention documents" the autopax
  agent-enablement plan is built on; the actual sapientia-era CLI-conventions
  corpus the task names. (sapientia area.)
- `~/src/archema/docs/sys/agentic/tool-export.md` — agent tool-export (path may be
  stale → likely `~/src/rowan`); surfaced in the INSTRUMENTA search.
- `~/src/operata/docs/` — the abandoned intent-management engine practica studies.

---

## Search / command log (dry wells included)

memorata3-search runs (all `-n 40`–`50`, `--no-json --no-color`):
1. `"designing CLI tools for AI agents ergonomics"` → hit: ruby-cli-modern-practices-
   report (agent-friendly fundamentals); also surfaced `_core/nexum/vision-agentic-toys.md`.
2. `"agent-facing tool interface schema description guidance INSTRUMENTA"` → hits:
   autopax `system-overview/instrumenta/tool.md` + `registry.md`, `ADR/013-instrumenta.md`,
   sessions/…instrumenta-phase0; plus cross-area archema tool-export, nexum, claude-docs.
3. `"make the right thing the easiest thing tool ergonomics ease gradient"` → hits:
   THE-PATTERN, make-right-thing-easiest, principles-summary, COUNCIL-PROPOSALS,
   discussions-on-adr-003; plus `ash-exploration/THE-PATTERN.md`, sapientia/architectus.
4. `"streaming output agents terminal without syntax highlighting readable"` → **dry
   well for this area** — returned mostly `_ref/claude-docs` + `_core/ennaos` streaming
   docs + `udon/README.md`; nothing new in autopax/practica. (Streaming-consumption
   ideation for UDON likely lives elsewhere.)

Directory listings / reads:
- `ls` autopax root, `docs/`, `docs/exp/` (56 files), `docs/tactical/` (95 entries),
  `docs/system-overview/` + `/instrumenta/`, `docs/ADR/`, `docs/ref/`.
- `ls` practica root, `docs/` + `docs/02-normative/`, `msc/`, `ref/`.
- Read in full or substantial part: exp/make-right-thing-easiest, exp/system-reminders,
  tactical/tool-definition-anatomy, exp/living-code-vision (head), ADR/013-instrumenta
  (head), system-overview/instrumenta/tool.md + handlers.md (head), practica/CLAUDE.md,
  practica msc/practica-intent-action-layers (abstract+§§1–2), operata-study (head),
  02-normative/02-coordination-affordances (C1–C2), ref/task-and-issue-tools-survey (head).
- Head-read (18–40 lines) for vetting: exp/autonomous-vs-collaborative-decisions,
  collaboration-mode-entropy-gradient, iterative-adaptive-development, mental-models-and-
  intent-inference, autocolors-philosophy, terminal-consoles, prefactoring-lessons,
  code-quality-and-ownership, operata-principles, THE-PATTERN (§-index), SYNTHESIS-PART1,
  dont-overprescribe-subagents, intent-surfacing, thoughtful-not-task-oriented, process-
  patterns-synthesis, principles-summary, ADR/003-workflow, core-tools-plan, phase2-agent-
  enablement, dev-component-brainstorm, cli-trezor-qa (head).
- git dates confirmed: autocolors-philosophy (2025-12-20), practica-intent-action-layers
  (2026-05-20).

Not yet mined (candidates a third pass could open): the rest of `docs/tactical/`
(agent-card / substrate-registry / curatoria / pinax / tui-* / catalog-* — mostly
autopax-internal architecture, low agent-tooling-ideology yield on filename inspection but
unread); SYNTHESIS-PART2–5; COUNCIL-PROPOSALS.md; the HTN-GOAP trio; practica/docs/03-concrete
(planned/empty at last check).
