---
source: Part II §6 "Elsewhere" extraction sweep — witness lines & flags
gathered: 2026-07-21
status: commentary — 1–2 line witnesses, dry-well records, and steward-facing flags for
  rows that resolved as existence/shape evidence rather than copies or characterizations.
paths:
  - (see each entry)
categories: [witness, scope-flag, cross-tier-flag, dry-well, divergence]
why_included: >
  The residue of §6 that isn't a copy or a characterization: the out-of-strict-scope vaults
  deposit (a steward call + a Part III overlap), a genuinely thin row, and the cross-cutting
  observations phase-2 should carry forward from this area.
---

# Part II §6 "Elsewhere" — witness lines, flags, and cross-cutting notes

## FLAG for Joseph / the reconciler — the out-of-`~/src` vaults deposit (rows 8–9)

The TARGET-FILES §6 rows for `~/vaults/**` are marked **"H/M (if brought in scope)"** and explicitly flagged as a scope call: *is `~/vaults` in bounds for this gathering pass?* Two things the extractor should know, kept here rather than acted on:

1. **The material is real and on-target.** Verified by reading (not just `ls`):
   - `~/vaults/gemini/archive/analysis-v1/analysis/**` (~14 files, ~2025-08-22/25, source_mtime 2025-08-23) — book analyses (The Pragmatic Programmer ch.1–9, Release It! ch.1,4,5, ELIXIR_BEST_PRACTICES) where **13 files carry an explicit "### Practicability for AI Agents" section** reframing classic software-engineering practice as concrete AI-agent recommendations (e.g. "AI agents should recommend PartitionSupervisor when detecting frequent DynamicSupervisor.start_child calls"; "recommend ETS concurrency optimizations when detecting shared-state patterns"). This is exactly the "how tools/practice for agents should be shaped" ideology target.
   - `~/vaults/Operations/claude-code-tools.md` (source_mtime 2025-08-20) — a **verbatim dump of the actual Claude Code tool-suite prompts** (the Task/Agent tool guidance, Bash, etc.). Prior-art on how the primary agent tool presents its tools to the agent, Aug-2025 snapshot.
   - `~/vaults/gemini/archive/AGENT_FIX_RECOMMENDATIONS.md` (source_mtime 2025-08-23) — **lived multi-agent-delegation failure evidence**: a debugging report on why a research-coordinator "attempts to use the Task tool but ends up doing all work itself" (invalid `model: claude-sonnet-4` ids, `subagent_type` invocation mismatch). Agent-tooling failure testimony — the tool's audience describing where delegation broke.

2. **It overlaps Part III, which OWNS a dedicated vaults sweep.** Part III's header states: *"Vaults IS in scope — a dedicated map existed; Part II §elsewhere's vaults rows are complementary finds, cross-check before double-spawning."* Per that, I have **not** done a full extraction of these files (that would duplicate Part III's dedicated work). This flag records the finds so they aren't lost at the §6/Part III seam and surfaces the steward question. **Recommended disposition:** let the Part III vaults owner extract; if that sweep's scope excludes `analysis-v1/**` or the `Operations/` file, these three deposits are worth a COPY (the "Practicability for AI Agents" sections) + a CHARACTERIZE (the AGENT_FIX delegation post-mortem). Deferring the call rather than guessing, per the Brief.

## Witness — rowan YAML cheatsheet (thin row)

`~/src/rowan/docs/ref/yaml-syntax-cheatsheet.md` (Dec 2025, source_commit 0ecf61a) — a hand-distilled "YAML 1.2.2 Syntax Cheatsheet … for developers working with YAML configuration files." Not agent-tool ideology; a human YAML reference for rowan users. **The single witness worth carrying:** the mere existence of a carefully hand-authored YAML cheatsheet inside a serious 2025 project is small corroboration of UDON's founding premise — that YAML's surface is footgun-dense enough to need a survival guide. One line, no copy. (Agrees with the map's "mention only.")

## Cross-cutting notes for phase-2 (carried forward from §6)

- **The §6 center of mass is the `sar` cluster, and it is Tier-1 ideology, not periphery.** The three `ai-*` docs + `error-messages-plan` are Joseph's Nov-2025 "AI-FIRST" manifesto — an entire language project premised on *designing development and its tools for agent cognition*. Copied as excerpts (`copies/II6-elsewhere/sar-*`). Highest-leverage single artifact: `sar-ai-applied-tst-excerpt.md` (documentation-primacy, context-window-as-temporal-unit, the agent-tooling wishlist: LSP-in-system-reminders / graph-based editing / instant semantic feedback / context-budget tooling).

- **A genuine CROSS-TIER convergence sits in an L/M-rated archived file.** `sar/.archive/DOMAIN_UPDATES.md` (excerpted) triangulates, in one place, Tier-3 ELI testimony (Zi-am-tur: *"Every tool we create is an act of truth-bearing… every helpful error message is love made operational"*), Tier-2 shipped-practice (Aider's measured 15–20%-less-lazy-coding diff-vs-whole-file finding, reframed as *phenomenological fit between tool and task*), and Tier-1 ideology (tools-as-crystallized-wisdom, the 60/30/6/4 work distribution, dual-memory). The row rated it "mine only if gaps remain"; it is not gap-filler — it is the compilation's prized shape. Flagged for the synthesizers' cross-tier cluster on **edit-format / truth-bearing tools**.

- **Two divergences from the TARGET-FILES map surfaced (not reconciled):**
  1. **rowan doc-tooling was under-weighted.** The map said "rowan-specific … mention only"; the primary source's framing chapters are on-target agent-tooling ideology (the "Dual-Audience / Agentic Consumer" thesis, llms.txt, "agents thrive on explicit schema," legacy HTML "actively hostile to this new consumer"). Copied as `copies/II6-elsewhere/rowan-dual-audience-docs-excerpt.md` with the divergence noted inline.
  2. **shoshin is peripheral-to-notation but central-to-the-harness-memory-question.** The map's "peripheral" is right for UDON/CLI but wrong for the harness consumer's "memory & context systems" axis; characterized as `characterizations/II6-shoshin-memory-context-design.md`.

- **Same-author convergence, not corroboration (flagged per Brief's convergence discipline):** shoshin's `CONSPECTUS` (inspectable assembled context) ↔ the harness fork-recommendation's `CONSPECTUS` (sovereign/interceptable context assembly, Part II §8) ↔ sapientia's never-corrupt-state/append-only requirements (Part II §8) ↔ the append-only live UDON consumer logs (Part I §5). All one author — coherence, worth noting for the "trustworthy context/memory" cluster, but NOT cross-tier triangulation.
