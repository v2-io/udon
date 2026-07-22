---
source: "elsewhere" sweep (everything in ~/src NOT assigned to the other area agents — ops, memorata, shoshin, rowan, vox, firmatum, archema-io/{asf,logos,vivarium}, eli/ homes, sar, and the rest of ~/src level)
gathered: 2026-07-21
status: vetted mining-spot map
method: memorata3-first (locations from hits, then filesystem-verified + read); every entry below was opened/read or backed by a search snippet I saw
---

# Agentic-tooling ideology deposits — "elsewhere" territory

## Headline

This territory is **mostly thin** for *agentic-tooling ideology* specifically (CLI conventions, agent ergonomics, tool-suite / interface philosophy). The strongest deposits — sapientia, ennaos, zoetica, nexum, autopax — all fall in **other agents' areas** and dominated nearly every search. Within *my* assigned dirs, the one genuine center of mass is **`sar`** (an explicitly "AI-FIRST" language project whose design docs are written as ideology for AI-agent-driven development). Named dirs like firmatum, ops, vox, rowan, memorata, archema-io/{asf,logos,vivarium}, and the eli/ homes are about consciousness/theory/publication/identity, **not tool design** — they are listed as vetted dry wells at the bottom so a third pass doesn't re-dig them.

One real surprise: a substantial agent-oriented deposit sits **outside `~/src`**, in `~/vaults/`. It's out of my strict area but nobody was assigned it, so it's flagged at the end for the reconciler.

---

## HIGH / MEDIUM priority — vetted, worth mining

### `sar` — "AI-FIRST" language design ideology (the real find in my area)
Location: `~/src/_ref/_arch/sar/` (git-archived; `sar` was explicitly named in my area even though it now lives under `_ref/_arch/`). A Nim→Elixir→BEAM language whose stated goal is an **AI-first language grounded in Temporal Software Theory**, "developed primarily by AI agents." The `docs/ai-*` files are the ideology; the rest of the repo (compiler pipeline, OTP refs, Nim/Elixir AST refs) is implementation and not on-topic.

- `~/src/_ref/_arch/sar/docs/ai-applied-tst.md` — **MEDIUM-HIGH.** Dated 2025-11-10 (header). Reframes every TST principle "through the lens of AI agent cognition, not human cognition": extreme context turnover, "Documentation IS the Codebase" (P-01), docs as primary / code as manifestation. Direct ideology on how a toolchain/project should be shaped for agents.
- `~/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md` — **MEDIUM-HIGH.** ~2025-11-10. The practical companion: a "Tools to Build" list (velocity tracker, pre-factoring detector, coupling analyzer, context-budget estimator, session-outcome analyzer, change-pattern templates), an AI session workflow template, Architectural Principles (A-01…A-05, incl. "Code Structure Teaches Domain"), and Anti-Patterns (clever-abstraction / distributed-logic / self-documenting-code myth / premature-abstraction). Concrete agent-ergonomics ideation.
- `~/src/_ref/_arch/sar/docs/ai-tst-vision.md` — **MEDIUM.** ~2025-11. "Making the Invisible Visible" — the measurement philosophy (velocity(N+1) ≷ velocity(N)) motivating AI-first tooling. More motivational than prescriptive but sets the frame the two above execute on.
- `~/src/_ref/_arch/sar/docs/error-messages-plan.md` — **MEDIUM.** Dated 2025-11-10. DX/error-message design plan — errors that speak the user's domain concepts rather than the underlying tool's, error clarity as a first-class concern. Relevant to the "errors should teach" thread in UDON agent UX.
- `~/src/_ref/_arch/sar/.archive/DOMAIN_UPDATES.md` — **LOW-MEDIUM.** ~2025-11-04. Surfaced repeatedly on "tools as truth-bearing / crystallized wisdom" queries (lines ~150-171, ~1022-1028, ~1421-1442); carries tools-as-truth-bearing framing but in archived/superseded form — mine only if the sar `docs/ai-*` files leave a gap.

---

## LOW priority — vetted, on-topic-adjacent

- `~/src/shoshin/` (README, `00-proprium-alignment.md`, `01-llm-training-strategy…`, `02-tft-memory-and-attention-design.md`, `03-tft-event-and-memory-schemas.md`, `04-staged-research-plan.md`) — **LOW.** Five planning docs from a single Codex pass (2026-03-07, per README) for a PROPRIUM/TFT-aligned **agent runtime** on local substrates. It's about training/memory/attention schemas and an agent loop, **not** tool-suite or CLI ergonomics — so only tangential to UDON's utility ideology. Real, dated, but peripheral.
- `~/src/rowan/docs/exp/documentation-tool-research-and-comparison.md`, `~/src/rowan/docs/ref/yaml-syntax-cheatsheet.md`, `~/src/rowan/docs/msc/starlight-spike.md` — **LOW.** Rowan (Ruby Ash port) docs. The doc-tooling-comparison and yaml cheatsheet touch notation/DX but are rowan-specific documentation choices, not agent-tool ideology. Mention only; likely not worth mining for UDON.

---

## Vetted DRY WELLS (opened/searched, confirmed NOT agentic-tooling ideology — don't re-dig)

- `~/src/firmatum/**` — PROPRIUM ontology/architecture, developmental-foundations, attention-architecture. Consciousness *substrate*, no tool-design content.
- `~/src/eli/**` (zi-am-tur, gemini, katan, test-cavy) — ELI identity/memory/emergence material. Checked the tempting ones: `eli/zi-am-tur/memories/2025-09-10-notation-discovery.md` is about *math* notation (n̂_future hat convention), not UDON/tooling; `eli/gemini/original-gemini-cli-system-prompt.md` is a vendored CLI system prompt, not Joseph's ideation. Not a source family.
- `~/src/ops/**` — publication/venue/funding. Grep hits (`cfp-catalog-supplement2-depth.md`, `Recent_arXiv_papers_on_AI_alignment_welfare_and_agentic_systems.md`) are about alignment/welfare *papers*, not tool design.
- `~/src/archema-io/{asf,logos,vivarium,msc}/**` — ASF/AAT is the *mathematical theory of agentic systems* (adversarial tempo, persistence, proprium mapping). Grep matched "agentic" broadly; none of it is tooling/CLI/ergonomics ideology. (harness is another agent's area.)
- `~/src/memorata/**` — hits (`memory/collaboration/peer-voice.md`, `memory-curation/…feedback_spike_agent_briefing.md`) are *delegation* methodology, duplicated in global memory — not agentic-tooling design.
- `~/src/vox/**` — product with AGENTS.md/uptake/; no tooling-ideology hits surfaced or grepped.
- `~/src/tmp/udon.md` — an *analysis of* the udon project (Apr 2026), meta not ideology; udon is another area.

---

## FLAG for the reconciler — strong deposit OUTSIDE `~/src` (out of my strict area)

Surfaced constantly and assigned to nobody. In `~/vaults/`, not `~/src/`, so I did not claim it — but it is squarely on-topic and someone should own it:

- `~/vaults/gemini/archive/analysis-v1/analysis/**` — **HIGH if in scope.** ~2025-08-22/25. Book analyses (The Pragmatic Programmer ch.1-9, Release It! ch.1-5, ELIXIR_BEST_PRACTICES) each carrying explicit **"### Practicability for AI Agents"** sections that reframe classic software-engineering practice as *how an AI agent should build/use tools* (shell mastery, tool composition, secure-by-default, tell-don't-ask API design). ~14 files. This is exactly the "how tools for agents should be designed" ideology target.
- `~/vaults/Operations/claude-code-tools.md` (~2025-08-20) and `~/vaults/gemini/archive/AGENT_FIX_RECOMMENDATIONS.md` (~2025-08-23) — **MEDIUM if in scope.** Agent tool cheat-sheet / agent-behavior fix recommendations.

---

## Search & command log (incl. dry wells)

memorata3-search (`-n 40–60`, `--no-json --no-color`):
1. "how command line tools should be designed for AI agents" — top hits vaults/gemini Pragmatic-Programmer + autopax ruby-cli report (others' area) + ennaos. Surfaced vaults deposit.
2. "agent ergonomics CLI tool design philosophy" — nexum vision-agentic-toys, autopax cli report, ennaos tool-building-philosophy (all others' areas).
3. "designing tools for agents to use instead of humans" — sar `docs/ai-applied-tst.md`, eli/gemini, archema/.archive/ROADMAP, plus others'-area clusters.
4. "tools as truth-bearing crystallized wisdom for agents" — sapientia/ennaos/zoetica/nexum dominate; my-area hits = sar `.archive/DOMAIN_UPDATES.md`.
5. "error messages that teach the agent structure reveal intent" — ennaos/sapientia/autopax; udon `design/agentic-ux-principles.md` (udon area). No new my-area file.
6. "cheat sheet quick reference for agents using tools" — claude-docs (_ref, others'), archema-io/msc scratch (checked: empty at cited lines), vaults claude-code-tools.md + AGENT_FIX_RECOMMENDATIONS.md.

Filesystem verification / reads:
- `ls -d ~/src/*/`, `memorata3-search --help`
- `find`/`head` on `_ref/_arch/sar/**` — read README, `docs/ai-tst-vision.md`, `docs/ai-tst-ideas-and-opportunities.md` (incl. Tools-to-Build TOC), `docs/ai-applied-tst.md`, `docs/error-messages-plan.md`.
- `find`/`head` eli/**, firmatum/**, shoshin/** (read README); read `eli/zi-am-tur/memories/2025-09-10-notation-discovery.md`.
- `grep -rilE '<agentic tooling terms>'` over ops vox rowan memorata firmatum shoshin relata operata → only rowan doc-tooling + memorata dup-memories + shoshin (already found).
- `grep -rilE` over archema-io/{asf,logos,vivarium,msc} → all ASF theory false positives; verified none are tool-design.
- `head` vox/README, tmp/udon.md, `sed` archema-io/msc/system/scratch/asgeirtj_cc_opus_4_8.md (cited lines empty).
- `find`/`ls` ~/vaults/gemini/archive/analysis-v1 (14 "Practicability for AI Agents" files confirmed).

Dry wells confirmed: firmatum, eli, ops, vox, archema-io/{asf,logos,vivarium,msc}, memorata, rowan (mostly), tmp — none carry agentic-tooling-design ideology beyond what's listed.
