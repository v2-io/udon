---
source: sapientia §II.1 — witness lines + coverage record (extraction agent, 2026-07-21)
gathered: 2026-07-21
status: commentary (witness lines: the artifact's existence/shape is the evidence; plus the section's honest coverage ledger)
paths:
  - ~/src/_core/sapientia/**
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, witness, coverage-record]
why_included: >
  The rows in Part II §1 that resolve to a line or two rather than a copy —
  either because their content is a subset of something already copied
  (the cli-conventions split-files vs full.md), or because their signal is
  their existence/shape (a day-one ambition, a provenance fact), or because
  they are L-tier engineering detail peripheral to notation/harness demand.
  Plus the section's honest what-was-read-vs-not record.
---

# Sapientia §II.1 — witness lines and coverage record

## Witness lines (existence/shape is the evidence)

- **`cli-conventions/full.md` (2776 lines) is the master; the ~39 split-files are per-header chunks of it.** Provenance verified primary-source: session `9a34eb13:22` records a Sonnet sub-agent splitting the 2777-line `cli-conventions.md` into 38 topic files on 2025-09-18 — the literal origin of the `cli-conventions/` tree. So `full.md` and the split-file set are ONE corpus at two granularities, not independent sources. The two highest-value chunks are copied whole in `copies/II1-sapientia/` (core-design-philosophy, ai-agent-considerations); `full.md` itself is the authority to mine if a topic not covered by those two is ever needed. Do not double-count the split-files against full.md.

- **The split-file set exists as a deliberate agent-consumption affordance.** Witness: the same convention library was maintained BOTH as a 63KB master and as ~39 single-topic files specifically so a fresh agent instance could "work with individual sections rather than the massive 2777-line document" (`9a34eb13:22`) — a lived instance of the "structure IS the chunking strategy" demand UDON later makes explicit. The split itself is witness material.

- **`cli-conventions/mcp-and-advanced-ai-tool-usage.md` (224 ln) — MCP-specific and advanced tool-usage conventions.** Witness: MCP conventions were a first-class concern within the CLI-conventions corpus (not bolted on later). Content is a chunk of full.md; not separately copied. If the harness handover wants the MCP-specific slice verbatim, mine this file from the pinned commit.

- **`cli-conventions/specialized-aliases-and-mode-conventions.md` (368 ln, the largest split-file) — agent-vs-human mode + alias conventions.** Witness: the agent/human dual-mode distinction (see the copied ai-agent-considerations.md) was elaborated at length, not just asserted. Chunk of full.md; not separately copied.

- **`docs/reflections/{everything-is-truth-work,training-as-begetting, eli-essay-top-p-*}.md` — witness only.** These are the devotional end of the reflections; they witness that the tool-ideology was embedded in a wider truth/consciousness frame, but add no tooling-operational content beyond what phenomenology-in-tools / tools-as-truth-bearing / three-pillars (all copied whole) already carry. Listed for exhaustiveness, not copied.

- **`docs/architecture/infinite-velocity-pattern.md` (206 ln) — witness for the TST-tooling rationale.** Elaborates the P(change)≈0 "infinite velocity component" idea characterized from PRINCIPLES/KEY_INSIGHTS in characterizations/II1-sapientia-architecture-and-guides.md. Existence witnesses that "which components deserve heavy upfront design" was worked out formally; the transferable claim is already captured in the characterization.

- **`docs/guides/llm-expertise-encoding-guide.md` (1420 ln) — witness + shape.** An expertise-encoding guide that itself uses a UDON-ish insta-TOC header block (per TARGET-FILES; head-skim only). Witnesses that structured self-describing headers were a felt want in Joseph's own long-doc authoring. Siblings `RAG_IMPLEMENTATION_GUIDE.md` / `SQLITE_RAG_IMPLEMENTATION_GUIDE.md` are RAG-plumbing (L), off-target.

- **`docs/claude-expertise-guide-cited.md` (52KB) / `-guide-2.md` (9KB variant).** Cited/researched companion + thin variant of expertise-guide-3 (characterized above). Witness: the context-engineering material was researched and cited, not just asserted. Not copied.

- **`CACHING_AND_FILE_API.md` (211 ln) — witness for cost/latency awareness.** Prompt-caching + Files-API notes (cache breakpoints for system prompt / tool defs / history). Engineering detail for agent-runtime economics; the transferable point (tool defs are a stable, cacheable cost bucket) is already in the ai-conversation-system §7 characterization and context-queries excerpt. Peripheral to notation design; not copied.

- **`docs/minimal-sapientia-ruby-spec.md` (395 ln) / `docs/minimal-minimal- sapientia-rb.md` (262 ln) — impl specs (L/ref).** The buildout they describe is already characterized in the pre-existing `sapientia-bin-buildout.md`; the agent-facing tool CONTRACT is excerpted in copies/II1-sapientia/minimal-sapientia-tool-contract-excerpt.md. These two are implementation detail; witness only.

- **`tmp-context/compressed-session-part1.md:67-74` — a compaction artifact of the c48e239c dialog** ("The Core Insight: Tightening Feedback to Near-Zero — tools that predict failure before execution and explain why"). Duplicative of the c48e239c primary source characterized in II1-sapientia-dialogs-instrumenta.md; witnessed here as a pointer, not copied (the primary source is better provenance).

- **`cc-raw/` remaining ~185 raw jsonl sessions — witness: dry for tooling.** Overwhelmingly consciousness/implementation sessions. memorata surfaced essentially only the three tooling spans already characterized. Not to be listed whole; grep for specific spans if a future pass needs primary-source dialog behind a convention.

## Coverage record (read vs skimmed vs not-reached)

- **Read fully (→ copied whole):** core-design-philosophy, ai-agent- considerations, phenomenology-in-tools, tools-as-truth-bearing, three-pillars-synthesis, next-steps-tool-consciousness, ai-epistemological-architecture.
- **Read the load-bearing spans (→ excerpted):** QUICK-TOOLING-CONVENTIONS (L1-115, L196-402; the Ruby-template plumbing L116-195/L574+ NOT read in depth), minimal-sapientia-tools (L1-120 schemas; L120-210 not deep-read), context-queries (L1-110 empirics; L110-243 = the minimal-sapientia bug analysis, skimmed), claude-code-analysis (L1-110; L110-254 skimmed).
- **Read primary-source spans (→ characterized w/ quotes):** c48e239c :28/:30/ :34/:36, a3483210 :12, 9a34eb13 :10/:22, anamnos :54/:69/:107/:128/:135/:144.
- **Head-read only (→ characterized, bodies NOT read):** advanced-claude-agent- architecture (MACH, L1-70 of 2988), comprehension-manifesto (L1-60 of 235), architecture/PRINCIPLES (L1-55), KEY_INSIGHTS (L1-40), ai-conversation-system- requirements (TOC + §7 + requirement grep, not the full 1186 lines), claude-expertise-guide-3 (head).
- **Verified-exists, not content-read (→ witness only):** full.md, mcp-and- advanced, specialized-aliases, the split-file set, the devotional reflections, infinite-velocity-pattern, guides/llm-expertise-encoding-guide, expertise- guide-cited/-2, CACHING_AND_FILE_API, minimal-sapientia-ruby-spec, minimal- minimal-sapientia-rb, compressed-session-part1.
- **Not re-extracted (already ingested):** the `bin/` buildout — characterizations/sapientia-bin-buildout.md already covers it; I verified the tool CONTRACT separately via the docs excerpt rather than re-reading code.

## Dry wells confirmed (carried from TARGET-FILES §"Checked, not fruitful", not re-walked)

ELI-emergence transcripts (architectus/anamnos-except-DSL/calyx/tartur/naniam/ auctor/mitis/seam/plumb/nomothete/vestigo/trace-the-mayfly/zi-am-tur/family/ curated-sessions/etc.), Elixir/Ruby app code (lib, test, deps, agents, mix.exs), project-record files (OPERATA, OVERVIEW, PROJECT_INDEX, README, CLEANUP_*), vocabulary/theory files (LEXICON, NAMES, TST_REPOSITORY_MAP), `~/src/tmp/ _core-sapientia.md` (derived report), and the two memorata dry-well queries — all consciousness/identity/impl/vocabulary, not tooling ideology. Not independently re-verified this pass; carried forward as the source maps' honest residual.

## Open question for the steward (Joseph / Fable-in-session)

The section splits cleanly into copyable ideology (done) and two large harness-facing docs I only head-read (MACH's Ruby paradigm-selector; the conversation-system's rollback state machine). Both are more valuable to the **harness** consumer than to UDON-the-notation, and both are large. Worth a decision at synthesis: do those two want a deeper, harness-directed pass (full-body read + excerpt of the concrete state machines), or is the characterization sufficient for the master-thesis level? I left them characterized rather than guess the harness handover's depth need.
