---
source: extraction commentary — TARGET-FILES Part II §3 (Nexum, Synaptic, eli-migration-prep)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/**
  - /Users/josephwecker-v2/src/_core/synaptic/**
  - /Users/josephwecker-v2/src/_core/eli-migration-prep/**
source_commit: nexum c87c75ce20aeaad9290732e17be256601b45a338; eli-migration-prep 6c2b4c036b67aa8bbc58efc008422ac15ecfc523
categories: [witness, area-note, lineage, convergence-discipline]
why_included: >
  Witness lines for the two §3 rows that resolved as existence/shape evidence rather than copies,
  plus one area-level note synthesizers need (lineage vs cross-tier convergence) and the confirmed
  dry wells. The 14 substantive copies for this section live in copies/II3-nexum/.
---

# Part II §3 — Nexum / Synaptic / eli-migration-prep — witness lines & area note

## Witness lines (rows that yielded shape, not a copy)

- **`nexum/docs/research/cli-analysis.md`'s sibling `nexum/docs/.archive/cli-research-summary.md`**
  (committed 2025-11-07) — *witness, not copied.* It is the navigational **index** of the
  Nov-2025 nexum CLI-research cluster ("What Was Done / Documents Created"); by its own framing it
  is "Navigational, not new content." The signal is only that the cluster was consciously assembled
  and self-indexed — the content it points at is copied individually in `copies/II3-nexum/`
  (cli-design-recommendation, cli-analysis, modern-cli-comparison, cli-testing-requirements,
  minimal-sapientia-usage-analysis, cli-open-questions, sapientia-conventions-analysis). Copying the
  index too would only duplicate their headings.

- **`nexum/docs/capabilities-design.md`** (2025-11-07, marked "✅ Implemented (Ruby DSL)") —
  *witness, not copied.* It designs **model**-capability negotiation (context-window sizes, cache
  TTLs, beta headers, thinking modes, per-model capability sets) — i.e. detecting what an LLM
  substrate can do, not what an agent needs from its *tools*. The TARGET-FILES row itself flags it
  "vetted-and-mostly-out-of-scope, listed for completeness." Witnessed here so its existence is on
  the record (a real, shipped concern of the era: agent runtimes had to negotiate substrate
  capabilities at startup) without importing off-question material into the tooling compilation.

## Area note for synthesizers — lineage vs. cross-tier convergence

The nexum tooling corpus (13 of this section's 14 copies) is a **November-2025 synthesis by one
author** that repeatedly and explicitly cites two upstream sources copied/characterized elsewhere in
this union: `~/src/_core/sapientia/cli-conventions/*.md` (Part II §1) and
`~/src/_core/ennaos/docs/research/agentic-coding-background/refs/` (Part II §2). So agreement between
these nexum docs and §1/§2 is **coherence within one author's lineage, not corroboration** — do not
count it as triangulation (per the Brief's convergence discipline; each copy's `why_included` carries
this caveat inline where it matters most, e.g. sapientia-conventions-analysis).

The one place genuine **cross-tier** triangulation lives in this section: `cli-analysis.md` and
`modern-cli-comparison.md` survey *shipped commercial harnesses* (Claude Code, Codex, Gemini CLI) —
Tier-2 evidence. Where Joseph's own conventions (structured output, stream separation, session
resume, permission/approval modes, one-shot/headless mode) line up with what those three independent
tools actually ship, that convergence is real signal, not self-agreement. Flag those alignments as
the high-value content; the 15th target (SYNTHESIS-SUMMARY-FOR-DAD, from eli-migration-prep) sits at
the opposite altitude — the delegation/management *why* beneath all the *how*.

## Dry wells (confirmed, carried forward)

- **synaptic (whole repo)** — cognitive-state-transfer / TST empirical research (compression
  experiments, collaboration protocols, entity emergence, POSSIBILITY_SPACE_THEORY). Prior sweep's
  grep for CLI/tool-design/agent-ergonomics vocabulary returned zero hits; README confirms subject.
  Nothing extractable for this compilation.
- **eli-migration-prep** beyond the one copied item — `extract.rb`, `schema_canonical.sql`,
  `docs/*PLAN*.md`, `EVIDENCE-WEIGHTING-SYSTEM.md`, `TIMING_FORMULA.md` are a session-data
  extraction/analytics pipeline, not tooling ideology. (Its `to-review/sapientia-zi-am-tur-session/`
  transcript tree is handled by Part II §5's dialog sweep, not here.)
- The `vision-agentic-toys.md` companion philosophy files (three-pillars-synthesis, tools-as-truth-
  bearing, QUICK-TOOLING-CONVENTIONS, addendum-intent-driven-tooling) do **not** live inside nexum —
  searched and dry; they live in ennaos (§2) and sapientia (§1). This confirms nexum's vision doc is
  a cross-pointer to upstream, not a duplicate holder of those texts.
