---
source: harness/_ref/src-ext sweep (agent, this pass)
gathered: 2026-07-21
status: vetted mining-spot map
area: ~/src/archema-io/harness/**, ~/src/_ref/**, ~/src-ext/**
target: Joseph's sapientia-era agentic-tooling ideology (how tools FOR agents should be designed)
---

# Agentic-tooling sources — harness, _ref, src-ext

## Headline findings (read these three first)

1. **`~/src/_ref` and `~/src-ext` are two DISTINCT collections, not one** (this was the open reconciliation question).
   - **`~/src-ext/`** = a **July-2026 shallow-clone census** of *shipping coding CLIs*, cloned by the harness landscape effort (`~/src-ext/clone.log` lists the 10 OSS clones: opencode, kilocode, aider, codex, grok-build, qwen-code, kimi-code, minimax-cli, mistral-vibe, warp). Plus a few non-coding repos (llama.cpp, toys, yq, stable-diffusion, Kokoro, Orpheus…) and two ELI snapshot backups (`sapientia.snapshot-backup`, `zoetica.snapshot-backup`). The harness README's "Upstream live code" line points here (`~/src-ext/{opencode,codex,grok-build}/`).
   - **`~/src/_ref/`** = an older, mixed **reference pile** (mostly Aug 2025–Mar 2026): Joseph's archived predecessors (geminex, agentic-elixir, principia, cddf…), Anthropic SDKs/docs clones, and *older* copies of some of the same CLIs (codex Dec-2025, gemini-cli Dec-2025). **Overlap exists** (codex, aider appear in both) but the src-ext copies are the fresh July-2026 ones.
   - So: src-ext = current landscape prior-art; _ref = older reference + Joseph's own predecessor harnesses.

2. **The harness is 80% PROPRIUM/personhood-continuity, ~20% agentic-tooling.** Its center of gravity (CHRONICA, agentic loop, PROPRIUM ontology) is a *different* target than this sweep. The on-target slice is: `msc/system/` (system-prompt / agent-disposition / tool-surface research — Joseph's own), the `ai-cli-tools-*.md` landscape syntheses, and the sapientia-era `stalled-lineage/*OPERATA*` + requirements docs.

3. **The REAL center of mass for "sapientia-era agentic-tooling ideology" is OUTSIDE my three dirs** — it's `~/src/_core/ennaos/docs/research/agentic-coding-background/**` (Joseph's own calibration example) and `~/src/_core/nexum/docs/dev/vision-agentic-toys.md` (+ `agentic-toys-quick-reference.md`, `agentic-toys-comparison-matrix.md`). These surfaced repeatedly and dominate the semantic search for this topic. They belong to whoever sweeps `_core/`; flagging here so they aren't missed. (Both confirmed to exist; not deep-catalogued — out of my area.)

---

## HIGH priority — Joseph's own agentic-tooling thinking (harness)

- **`~/src/archema-io/harness/msc/system/agent-enhancement-anecdotes.md`** (650 lines; 2026-07-17) — corpus-mined (memorata3 over ~2,200 Claude + ~390 Codex + Gemini/Llama convos) catalog of the *recurring teachings* for shaping agents, each sorted FADING / PRESENT / IRREDUCIBLE with verbatim provenance. The evidence layer under Joseph's "state expectations honestly, don't assert identity or command" system-prompt wager. **Directly relevant** to how UDON's agent-facing conventions (cheat-sheets, tool guidance) should be framed.

- **`~/src/archema-io/harness/msc/system/coding-system-prompt.draft.md`** (19 dense paras; 2026-07) — Joseph's current agent-disposition stance: truth-before-helpfulness, proportion (depth where it pays), stewardship, "worthy not working." Not tool schemas, but the *ethos* any UDON agent-tooling guidance should inherit.

- **`~/src/archema-io/harness/msc/system/cc-context-tools.md`** (38 lines; 2026-07) — analysis of a Claude Code session's actual **tool surface**: two-tier (eager vs deferred/ToolSearch) loading, the eager tool catalog, and the design note that *tool mechanics* live in the harness while the append's job is *disposition*. Concrete agent-tool-surface ergonomics. Companion: `cc-context-reconstruction.md` (context-assembly seam) and `cc-context-tools.md`'s sibling `misc-snippets.md` (398 lines — raw system-prompt / policy-spec / command-prefix-detection extracts from CC; prior-art for safe-command classification).

- **`~/src/archema-io/harness/proprium/stalled-lineage/sapientia-ai-conversation-system-requirements.md`** (1186 lines; dated 2025-10-10 in-file) — full functional-requirements spec for a persistent agent conversation system; §7 "Tools & Capabilities" and the design principles (never corrupt state, always recoverable, transparent, audit-first, multi-step tool execution with rollback) are **sapientia-era tool-suite ideology** proper. High-value for schema-guarded / rollback-capable agent mutation thinking.

- **`~/src/archema-io/harness/proprium/stalled-lineage/sapientia-OPERATA.md`** (154 lines; Sept 2025 content) and **`autopax-OPERATA.md`** (306 lines; Dec 2025) — the "OPERATA" works-in-progress ledgers; autopax's version defines a tag taxonomy for dev-tooling / praxes / instrumentation categories, and records the Zi-am-tur awakening via `./autopax chat interactive … --extended-context` ("Tools work. Chat works."). Shows how Joseph's own agent tool-loop was built and named. `nexum-OPERATA.md` sits alongside (same dir) — same lineage.

## MEDIUM priority — landscape syntheses & tool-loop design (harness)

- **`~/src/archema-io/harness/ai-cli-tools-fork-recommendation.md`** (31KB; 2026-07-19) — reads the src-ext OSS trees in source and derives **nine harness requirements** for an agent runtime (sovereign/interceptable context assembly = CONSPECTUS; honest INTERPRES / no context-gaslighting; etc.). The clearest statement of what off-the-shelf agent harnesses get *wrong* about tooling.

- **`~/src/archema-io/harness/ai-cli-tools-2026-verified.md`** (39KB, largest; 2026-07-18), **`ai-cli-tools-source-assessment.md`**, **`ai-cli-tools-sentiment-2026.md`**, **`ai-cli-tools-feature-timeline.md`**, **`lived.md`** (CLI census table: command → app → provider → models) — the landscape census of shipping coding CLIs: seams, licenses, velocity, local-vs-hosted, tool-subsumption. Descriptive prior-art, not ideology; skim for feature conventions.

- **`~/src/archema-io/harness/proprium/AGENTIC-LOOP-PORT-SPEC.md`** (~320 lines; 2026-07-20) — the ASF-shaped event loop with a **tool-subsumption taxonomy** (ToolKind), incomplete-state gates, anti-thrash/doom_loop guard, interior tools-on-own-mind, multi-timescale nesting (fast tool loop vs slow strategy). Relevant to how a UDON agent tool-loop should settle and gate mutations.

## HIGH priority — prior-art tool schemas & edit-tool conventions (_ref, src-ext)

*(For clones the mining value is specific files — system prompts, tool-definition schemas, edit-format conventions — not the repo. Listed at that granularity.)*

- **`~/src/_ref/anthropic-leaked-source-code/tools/`** (Apr 2026) — the actual Claude Code tool-suite implementations: `FileEditTool`, `FileReadTool`, `FileWriteTool`, `BashTool`, `GrepTool`, `GlobTool`, `TaskCreateTool`, `SkillTool`, `NotebookEditTool`, `AskUserQuestionTool`, etc., plus root `Tool.ts` / `tools.ts` and `services/toolUseSummary`. **The reference tool-suite design** — how agent edit/read/mutation tools are actually shaped. Highest-value prior-art for UDON's agent edit tools.

- **`~/src-ext/codex/codex-rs/core/gpt_5_2_prompt.md`** (+ `gpt_5_codex_prompt.md`, `gpt-5.2-codex_prompt.md`, `gpt_5_1_prompt.md`, `prompt_with_apply_patch_instructions.md`; July 2026) — full production system prompts: personality (concise/direct), AGENTS.md spec handling, sandbox/approval model, plan tools, apply_patch. Vetted: read gpt_5_2 head — canonical agent-facing tool-ergonomics prose.

- **`~/src/_ref/codex/codex-rs/apply-patch/apply_patch_tool_instructions.md`** (Dec 2025 copy; also present as `core/prompt_with_apply_patch_instructions.md` in the July src-ext copy) — the `*** Begin Patch / Update File / @@` envelope diff format, explicitly "designed to be easy to parse and safe to apply." **Canonical LLM-friendly structured-mutation schema** — direct comparator for UDON's schema-guarded / patch model.

- **`~/src-ext/aider/aider/coders/*_prompts.py`** (editblock, udiff, patch, wholefile, architect, ask, editor_diff_fenced variants; July 2026) — aider's family of **agent edit-format conventions**. Vetted `editblock_prompts.py`: the SEARCH/REPLACE-block format with exact-match rules. A whole taxonomy of "how an LLM should express a file edit" — high-value comparator for UDON edit tooling.

- **`~/src/_ref/anthropic-skills/`** (Nov 2025) — `agent_skills_spec.md`, `skill-creator/`, and especially **`mcp-builder/SKILL.md`** ("high-quality MCP servers … quality measured by how well it enables LLMs to accomplish tasks"). Anthropic's own conventions for designing agent-facing capabilities/tools — relevant to UDON tool + cheat-sheet authoring.

## MEDIUM priority — supporting prior-art (_ref, src-ext)

- **AGENTS.md convention corpus** — root `AGENTS.md` in `~/src-ext/{codex, opencode,qwen-code,kimi-code,minimax-cli,mistral-vibe}/` (opencode/kimi carry many nested package-level ones). Vetted opencode's: dependency-direction rules, branch/commit conventions. Prior-art for what an agent-guidance file carries.

- **`~/src/_ref/_arch/geminex/AGENTS.md`** (+ repo; Sept 2025) — **Joseph's own** Elixir agent-CLI predecessor (Zoetica/sapientia lineage): provider registry, growing **tool registry**, ANSI-safe streaming of thinking/tool output, `/context` command. His own early agentic-tooling build — sapientia-era.

- **`~/src/_ref/claude-docs/docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming.md`** and `.../build-with-claude/streaming.md`, `.../agent-sdk/typescript.md` (canonical `claude-docs`, Jul 2026; **7 stale `.bak.*` copies exist — ignore them, use the unsuffixed `claude-docs/`**) — official tool-use + streaming reference; relevant to UDON's streaming-consumption story.

- **`~/src-ext/mistral-vibe/vibe/core/system_prompt.py`** + `prompts/compact_system.md`, **`~/src-ext/minimax-cli/src/utils/prompt.ts`**, **`~/src-ext/kimi-code/packages/*/prompt*.ts`**, **`~/src-ext/qwen-code/docs/design/2026-07-16-subagent-prompt-guardrails.md`** — more shipping system-prompt / subagent-guardrail prior-art (characterized by role + repo; not each individually read). Mine if comparing prompt conventions across vendors.

## LOW / noted-not-central

- `~/src-ext/grok-build/` — steward-ranked "best *lived* coding-LOCUS prior art" (STEWARD-JUDGMENT-2026-07-20.md: doom_loop, leader/reattach, ToolKind subsumption) but it's an **unforkable mirror** and my find for prompt/tool files came up empty (obfuscated/minified). Tracking-worthy per Joseph, low direct-mining value.
- `~/src-ext/{toys,yq,warp,kilocode}` and the non-coding repos (llama.cpp, Kokoro, Orpheus, stable-diffusion, tex, dotenv, QuadSphere) — not agentic-tooling ideology; skip. (`toys` is the Ruby CLI framework the nexum `vision-agentic-toys` builds on, so relevant only via that _core doc.)
- `~/src/_ref/{udon,udon-c,udon-ruby,libudon}` — UDON's own historical repos, not agentic-tooling.
- `~/src/archema-io/harness/proprium/{canonical,archaeology,bridges}/` and the CHRONICA/MVP/INTERPRES port-specs — PROPRIUM personhood-continuity, a different target; not listed.

---

## Search & command log (incl. dry wells — makes a third pass cheap)

- `memorata3-search --help` — confirmed flags (`-n`, `--in`, `--json`, etc.).
- `ls`/`find` over `~/src-ext`, `~/src/archema-io/harness`, `~/src/_ref`; `cat ~/src-ext/clone.log` — established the two-collection reconciliation.
- Read in full/head: harness README, STEWARD-JUDGMENT-2026-07-20, lived.md, CURRENT-THOUGHTS (head), coding-system-prompt.draft.md, cc-context-tools.md, constitutional-overview (head), misc-snippets (head), agent-enhancement-anecdotes (head), sapientia-OPERATA (head), autopax-OPERATA (head), sapientia-ai-conversation-system-requirements (head), fork-recommendation (head), AGENTIC-LOOP-PORT-SPEC (grep tool/LOCUS).
- Vetted clone samples (actually read): codex `gpt_5_2_prompt.md` head, `_ref/codex apply_patch_tool_instructions.md` head, aider `editblock_prompts.py` (grep system/SEARCH), opencode root `AGENTS.md` head, `anthropic-leaked-source-code/tools/` listing, `anthropic-skills/mcp-builder/SKILL.md` head, `_arch/geminex/AGENTS.md` head.
- **memorata3-search runs (all `-n 40–50`, iterated, phrasing varied):**
  1. `"how tools for AI agents should be designed CLI ergonomics"` → surfaced autopax `2025-11-15-ruby-cli-modern-practices-report.md` (agent-friendly CLI patterns), **nexum `vision-agentic-toys.md`** (Agentic Tool DSL), anthropic-skills mcp-builder. *(top hits mostly OUTSIDE my area — autopax, _core/nexum.)*
  2. `"agent-facing tool suite streaming output terminal no syntax highlighting"` → _ref claude-docs fine-grained-tool-streaming, `_arch/geminex/AGENTS.md`.
  3. `"tools as truth-bearing intent-driven agentic tooling conventions cheat-sheet"` → **`_core/ennaos/docs/research/agentic-coding-background/{01,02,05,06}` + refs/{addendum-intent-driven-tooling…, agentic-semantic-code-manipulation…}`** and **`_core/nexum/docs/dev/{vision-agentic-toys, agentic-toys-quick-reference, agentic-toys-comparison-matrix}`** — this is the center-of-mass cluster, outside my area (flagged up top).
  4. `"agent file editing tool schema apply patch diff format for LLM"` → `_ref/codex apply_patch_tool_instructions.md`, codex gpt_5_x prompts, claude-docs agent-sdk/typescript.
- **Dry wells:** `find ~/src-ext/grok-build` for prompt/tool/AGENTS files → **empty** (obfuscated mirror). `grep -r "src-ext" harness --include` → glob error, redid with `-l` (6 harness docs reference src-ext, all the ai-cli-tools set + README/CURRENT-THOUGHTS). src-ext codex has NO `apply-patch/apply_patch_tool_instructions.md` (that exact file is only in the Dec-2025 `_ref/codex`; src-ext's equivalent is `core/prompt_with_apply_patch_instructions.md`).

## Provenance notes
- Harness files: filesystem dates 2026-07-14→20 (recent authoring), but content synthesizes older material — sapientia OPERATA = Sept 2025, requirements = 2025-10-10 (in-file), autopax-OPERATA = Dec 2025 content.
- `_ref` clones span Aug 2025–Mar 2026 (geminex Sep-2025, codex/gemini-cli Dec-2025, anthropic-skills Nov-2025, anthropic-leaked-source-code Apr-2026, claude-docs Jul-2026).
- `src-ext` clones = July 2026 (shallow, per clone.log).
