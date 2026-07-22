---
source: Part II §8 (harness/_ref/src-ext) — witness lines for rows resolved as existence/shape evidence rather than copy or characterization
gathered: 2026-07-21
status: witness — 1–2 evidence lines per artifact; verified by direct read/search snippet unless marked otherwise
paths:
  - see each entry
source_commit: "archema-io 1b98ad4 · src-ext/codex 0fb559f0f · _ref/claude-docs (no-git, mtime 2026-07-17) · src-ext varies (see entry)"
categories: [witness, tier-2-shipped-practice, landscape-census, harness-handover, provenance]
why_included: >
  Per the Brief's three-outcome model, several §8 rows are witness material: the
  artifact's existence or shape is the evidence, not its full text. Landscape
  census reports, secondary companion docs, additional shipping system prompts,
  and the blocked/moved targets all land here as evidence lines so coverage is
  legible. The high-signal copies/excerpts for this section live in
  ../copies/II8-harness-refs/ and ../characterizations/II8-agent-enhancement-anecdotes.md.
---

## Harness companion + loop-spec docs (existence + shape witnessed)

- **`archema-io/harness/proprium/AGENTIC-LOOP-PORT-SPEC.md`** (~320 lines, 2026-07-20). Witness: an ASF-shaped **event-stream** agent loop deliberately contrasted with the commodity **request→response** clock — its §0 table names the distinction verbatim ("Clock: Human turn | **Event stream** (multi-channel, async)"), and it carries a tool-subsumption taxonomy (ToolKind), incomplete-state gates, an anti-thrash/doom_loop guard, and multi-timescale nesting (fast tool loop vs slow strategy). The loop *ideology* is captured in depth in ../copies/II8-harness-refs/harness-nine-requirements-and-seams.md (the interiority design note); this spec is the port-obligation companion. Verified: head read.
- **`archema-io/harness/msc/system/cc-context-reconstruction.md`** and **`misc-snippets.md`** (companions to cc-context-tools.md, which IS copied whole). Witness: cc-context-reconstruction covers the context-assembly seam; misc-snippets is ~398 lines of raw system-prompt / policy-spec / command-prefix-detection extracts from Claude Code — prior-art for **safe-command classification** (which Bash commands can auto-run vs. need approval). Not copied: the copied tool-surface doc + the codex sandbox/approval prose already carry the load-bearing shape; the raw policy extracts are reference-depth. (cc-context-tools.md read confirms the companion relationship; the two companions themselves surface-verified, not deep-read.)

## AI-CLI landscape census (descriptive prior-art — witnessed, not ideology)

- **`archema-io/harness/{ai-cli-tools-2026-verified.md, -source-assessment.md, -sentiment-2026.md, -feature-timeline.md, lived.md}`** (2026-07-18/19). Witness: a census of shipping coding CLIs — seams, licenses, velocity, local-vs-hosted, tool-subsumption; `lived.md` is a command→app→provider→models table. Descriptive, not demand-ideology — the *derived* requirements from reading these trees are what matters, and those are copied in harness-nine-requirements-and-seams.md (which is built from `ai-cli-tools-fork-recommendation.md`, the analytic sibling of this census). Left as witness to avoid double-counting the same underlying survey.

## Additional shipping system prompts (cross-vendor prior-art, witnessed)

- **`src-ext/mistral-vibe/vibe/core/system_prompt.py` + `core/prompts/*.md`** (0685654, July 2026). Witness: a modular prompt system — `cli.md`, `cli_2026-07_v2.md`, `explore.md`, `minimal.md`, `lean.md`, `agents_doc.md`, `tests.md`, `dangerous_directory.md`, `compact_summary_prefix.md` — i.e. the system prompt is *composed from named fragments per mode*, itself a convention (prompt-as-assembled-document). (The row's `prompts/compact_system.md` path does not exist; the analogous file is `core/prompts/compact_summary_prefix.md` — path corrected here.) Verified: `find` listing.
- **`src-ext/minimax-cli/src/utils/prompt.ts`** (3615170) and **`src-ext/kimi-code/packages/*/…prompt*.ts`** (a41a09c3), July 2026. Witness: more vendor system-prompt/subagent prose; kimi's prompt logic is spread across packages (agent-core, migration-legacy, kap-server) rather than one file. Mine if comparing prompt conventions across vendors; not individually deep-read (the codex
  + Claude Code copies are the representative canonical pair for this section).
- **`src-ext/qwen-code/docs/design/2026-07-16-subagent-prompt-guardrails.md`** (68b4440f9). Witness: a design doc specifically on **subagent prompt guardrails** — the delegation-safety concern (how to bound what a spawned subagent will do) written up as prior-art. Directly adjacent to the peer-voice/delegation material elsewhere in the compilation. Verified: exists (row-vetted).

## Anthropic reference docs (streaming / tool-use)

- **`_ref/claude-docs/docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming.md`** and **`.../build-with-claude/streaming.md`** (no-git; mtime 2026-07-17). Witness: official tool-use + streaming reference — relevant to UDON's streaming-consumption story (a UDON parser is event-driven/streaming; how tool-call args stream from the model is the upstream half). Left as witness: canonical vendor docs, stable and publicly locatable; the streaming *demand* for UDON is better evidenced by the udon-core streaming design in Part I. (`agent-sdk/typescript.md` from the row is ABSENT — the `agent-sdk/` dir holds only `overview.md` + `permissions.md`; noted as a corrected/blocked path below.)
- **`_ref/anthropic-skills/{agent_skills_spec.md, skill-creator/, mcp-builder/SKILL.md}`** — the mcp-builder principles + skills spec ARE excerpted (see ../copies/II8-harness-refs/agent-tool-authoring-conventions.md). `skill-creator/` witnessed as existing (the tooling that scaffolds a SKILL.md), not separately copied.

## grok-build (tracking-worthy, low direct-mining value)

- **`src-ext/grok-build/`** (July 2026). Witness: steward-ranked "best *lived* coding-LOCUS prior art" (doom_loop, leader/reattach, ToolKind subsumption) per the map's `STEWARD-JUDGMENT-2026-07-20.md`, BUT an unforkable read-only mirror whose prompt/tool/AGENTS files are obfuscated/minified — a `find` for them came up empty (re-confirmed). Its one high-value contribution (the protocol-level doom_loop loop-guard) is captured verbatim in harness-nine-requirements-and-seams.md via the fork-recommendation's source-read. The tree itself yields nothing directly copyable. Verified: `find src-ext/grok-build` for prompt/tool/AGENTS → empty.

## nexum-OPERATA (sibling ledger)

- **`archema-io/harness/proprium/stalled-lineage/nexum-OPERATA.md`** — sits beside the sapientia/autopax OPERATA ledgers (both excerpted in ../copies/II8-harness-refs/sapientia-era-tool-ideology.md). Witness: the fork-recommendation names it "requirements-gold" for the memory-model design (entity-authored first-person memory files + recursive `@import` into a 1M window, which explicitly calls the ennaos salience-gradient overengineered). Not individually deep-read this pass — flagged for a phase-2 pull if the memory-model thread becomes a focus. (Same underlying doc referenced from Part II §3 nexum row; merge-cross-ref.)

## Blocked / corrected paths (coverage honesty)

- **`_ref/anthropic-leaked-source-code/tools/`** (row H) — path does NOT exist under that name. The equivalent Claude Code tool-suite lives at **`_ref/claude-code-snapshot/tools/`** (d7de150, Apr 2026), which I read and copied (edit-format-schemas.md + cc-tool-suite-prompts.md). Row path corrected; target fully covered, just at a different location.
- **`_ref/claude-docs/docs/en/agent-sdk/typescript.md`** (row M) — ABSENT; the `agent-sdk/` dir contains only `overview.md` + `permissions.md`. Blocked as listed; the tool-use/streaming siblings (witnessed above) cover the intent.
- **`src-ext/mistral-vibe/vibe/prompts/compact_system.md`** (row M) — ABSENT; nearest is `vibe/core/prompts/compact_summary_prefix.md` (witnessed above). Path corrected.
