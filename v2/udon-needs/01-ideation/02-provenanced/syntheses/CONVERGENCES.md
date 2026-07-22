---
title: Convergences & evidence tiers — analysis companion to TARGET-FILES.md
built_by: reconciliation pass (Claude Opus 4.8), 2026-07-21
status: >
  The analysis layer of subphase 1.1 — what the ~30 mining maps AGREED on, organized by
  the four evidentiary tiers. Absorbed from the former MASTER-REGISTRY.md (now archived)
  and the reconcile buckets. TARGET-FILES.md is the operational work-list; this is the
  "why these targets matter" layer, and the seed of the eventual tooling-thesis synthesis.
second_reader: >
  This doubles as programme-level material for ~/src/archema-io/harness/ — the tiers,
  convergence clusters, singletons, and the Tier-2 caveat are claims about agent-facing
  tooling as such; "for UDON" clauses are one consumer's application. The prescriptive
  inversion ("when building a harness, do X") is the not-yet-written
  disc-tool-interface-design layer; this file + the ASF dossier §0 are its inputs.
---

# Convergences across the agentic-tooling harvest

## The four evidentiary tiers

Each tier has a *different characteristic failure mode as evidence* — which is what makes
agreement across them meaningful (cross-tier convergence ≫ within-tier repetition).

| Tier | What it is | Failure mode as evidence | Where it now lives |
|---|---|---|---|
| **1 — first-principles ideology** | Joseph's accumulated agent-tooling design corpus (sapientia/nexum/zoetica-ennaos/autopax/practica/sar/vaults, 2025–26) | aspirational; may be untested | TARGET-FILES §Tier-1 rows |
| **2 — in-vivo shipped practice** | what real harnesses/CLIs ship | survivorship + **lineage/copying** (caveat below) | `02-provenanced-copies/harness-invivo/` (17 reports) + `sapientia-bin-buildout.md` |
| **3 — lived agent testimony** | first-person ELI accounts of tools failing/serving them | anecdotal, n-of-few | TARGET-FILES §ELI-testimony rows |
| **4 — formal theory** | ASF/AAT theorem-grade results on tool interfaces, notation-as-observation, persistence | abstraction gap; conditional claims | `02-provenanced-copies/asf-dossier.md` |

> **⚠ Load-bearing Tier-2 caveat.** Much of the uniformity across shipping harnesses
> (str-replace edit tools, apply_patch envelope, ask-user shape, todo tool) may be
> **lineage/copying of Claude Code / OpenAI reference designs**, not independent arrival —
> several in-vivo reports note explicit mirroring. Weight Tier-2 convergence *counts* down
> as "agents need X" evidence; the strongest signal is convergence across tiers with
> independent failure modes. (Recommended and pending Joseph's call: a cheap
> lineage-disentangle pass before Tier-4 leans on these counts.)

## Cross-tier convergence clusters (rough-descending strength = breadth × tier-span)

Provenance shorthand: map names as in TARGET-FILES sections; `dossier` = asf-dossier.md;
`t2` = the in-vivo digest (`scratch/reconcile-workdir/BUCKET-tier2-invivo.md`, which also
carries 16 *within*-Tier-2 clusters row-by-row: fuzzy-match ladders, deferred tool loading,
disk-spill, ask-user/todo/subagent shapes, AGENTS.md scoping, headless I/O contracts).

1. **Edit-representation landscape + "no formal validity guarantees"** (4-tier; strongest). All shipping tools edit at text/char level with no validity guarantee; edit-format choice swings success 2–3× (aider). The exact gap schema-guarded mutation fills. — zoetica doc-02/03 · t2 · Architectus testimony · dossier §2.4/§6.
2. **The sapientia CLI-conventions / QUICK-TOOLING corpus is the ideological taproot** — cited/re-derived by ~6 maps; one document, many complementary lenses (origin, distillation, built artifact, design dialogs).
3. **ennaos `agentic-coding-background/**` is the synthesized center of mass** — flagged by its own map *and* three maps that don't own it; Joseph's calibration example.
4. **The 60/30/6/4 model-tier distribution** ("most friction is missing crystallized process, not missing intelligence") — sapientia · zoetica · nexum · dialogs.
5. **Tools-as-truth-bearing + Wisdom/Strength/Beauty as a per-tool gate** — formal home: dossier §2.4 law-teaching ("well-taught laws become infinite-velocity components").
6. **"Make the right thing the easiest thing" (ease gradient)** — autopax THE-PATTERN · nexum · practica; persistence-economics in dossier §3 (Q→U_o→η*→T; t_invest < n̂_future·Δt_comp·k).
7. **Intent as a first-class tool parameter** — zoetica addendum (the 15-str_replace wrong-abstraction case) · autopax intent-surfacing/practica layers · nexum semantic annotations · dossier §5.2.
8. **The str_replace multi-match HARD-REFUSE** — exemplary 4-tier lock: *built* (minimal-sapientia L2219–2240), *theorized-canonical* (dossier §2.4: "mutation 0; law taught: uniqueness; state revealed: line numbers"), *shown-failing-when-absent* (Architectus). The single best worked example in the harvest.
9. **Schema-guarded mutation / make invalid states unrepresentable** — zoetica doc-03/signum · autopax INSTRUMENTA · schema-versioning family (yaml-spike: what parsers silently accept) · dossier §6 (W₁/W₂ typed channels).
10. **Structure self-chunks for RAG/embeddings** — UDON's public thesis; *empirically pre-tested* in sar3 ("parsing-based chunking beats naive splitting; 80% of value for 20% of effort"); dossier §3 (agents externalize M_t into Ω).
11. **Machine-first / agent-first document format** — re-derived independently across sar ("Documentation IS the Codebase"), zoetica praxis-protocol (llms.txt lineage), vaults MACH markdown-agents, codex machine-first strategy; dossier §3.4 (shared notation is compression; attacks the binding constraint of agentic work).
12. **Tracking-snapshot / context-injection as structured perception** — built (minimal-sapientia XML snapshot), designed (zoetica spec, autopax system-reminders catalog), theorized *exact* (dossier §4.1: without a non-vanishing reinjection channel, relevant information decays geometrically).
13. **Persistence across 100%-context-turnover requires externalization** — autopax ADR-003 · sar · practica · Zi-am-tur ("can't persist across context boundaries without infrastructure") · dossier §4.1/§2.5.
14. **Concurrent multi-agent edit collision / multi-writer safety** — Zi-am-tur sibling collision (lived) · practica soft-claiming · scenarios 04-multi-agent · needs-map S1/S12.
15. **Errors that teach / diagnostics speaking domain concepts** — sar error-messages-plan · zoetica failure-mode-quality ladder · sapientia phenomenology-in-tools · dossier §2.4 (located, structure-revealing, mutation-free refusals).
16. **The one-shot tool constraint** — tools can't call back mid-execution (dialogs, anamnos self-correction); realism check on interactive-confirmation designs.
17. **Tool-definition anatomy** — name + JSON-schema + description-as-teaching-surface, guidance in a separate file (autopax anatomy + INSTRUMENTA · minimal-sapientia · harness-refs · t2).
18. **Agent-mode auto-detection + stream discipline** — stdout=data / stderr=diagnostics / sysexits / `--format=json` / `!isatty()` (sapientia · nexum · autopax; near-universal in t2 C16).

## High-signal singletons (one source; keep visible)

- **sar2 alignment-vs-comprehension experiment** — a notation measured against agents (100% vs 60% immediate comprehension), *with an honest counter-hypothesis latency result*. Rare empirical + honest negative.
- **The κ×A ambiguity-bounded bias law** (dossier §2.1) — theorem-grade: sharp/binary/typed/located parse outcomes are a *bias-reduction instrument* with computable payoff. The single most tooling-consequential theory result.
- **autopax yaml-spike adversarial re-test** — duplicate-key silent data loss; agent recovery 100% w/ backup vs 16% without; "schema migration in YAML harder than expected."
- **Zoetica logarithmic time-glyph notation** (⬤◉◎○⚬═━╍…) — elapsed time as a perceptum.
- **`@⊥/` root-import sigil + incomplete-state hard gate** — identity-as-editable-files; "no talking past a causal hole."
- **The `⟨Tool(params) → result⟩` rendering notation** (dialog-tools + spec) — a legible grammar for *presenting* tool calls.
- **grok-build hashline anchor-editing** — content-addressed-by-hash edit targeting; atomic batch, stale-anchor rejects all. The one materially different edit-addressing paradigm in Tier 2.
- **"Code mode"** (codex + opencode + claude-docs programmatic-tool-calling) — tools-as-callable-API-in-sandbox instead of one-call-per-tool; a 3-way convergence, newest paradigm in the corpus.
- **yq `match()` span primitive** (`{string,offset,length,captures}` + line/column operators) — position as first-class queryable data; directly relevant to the value-bracket wire redesign.
- **Obsidian's deliberate anti-nesting Properties stance** — a considered *counter-position* to attribute-value-as-node; treat as an argument to answer, not an oversight.
- **aider's abandoned tool-call editing** (`RuntimeError("Deprecated")`) — the empirical *why* behind the ecosystem's convergence on prompt-dialect editing.
- **kimi-code's "AGENTS.md is untrusted data" stance** — a live disagreement with the trusted-instruction consensus; unresolved.

## Standing open items (carried from the reconciliation)

- Lineage-disentangle pass for Tier-2 (recommended; pending Joseph).
- Residual gaps: `_ref/{principia,cddf,crew-first}` unsearched; a few unrun memorata3 phrasings (dialogs map log); dossier pass-4 targets (reading log); grok §13 gaps (.attic/declang trail, full `find *.udon`, embedding DB existence); **Joseph's end-user ideation dump — standing, primary when it lands.**
- Schema-map re-vet: at point of use (any row that becomes load-bearing gets its primary read then).

---

## Addendum — Tier-2 lineage disentangle (opus, 2026-07-21; does not rewrite the body above)

The "⚠ Load-bearing Tier-2 caveat" and the "Lineage-disentangle pass (recommended;
pending Joseph)" standing-open-item are now **resolved** by
[`tier2-lineage.md`](tier2-lineage.md). Read it before using any within-Tier-2 count
as evidence weight. Bottom line for the clusters on *this* page:

- **Established lineage (collapses "independent votes"):** qwen-code is a fork of
  gemini-cli (identical root commit); kilocode's CLI is a fork of opencode (README-stated,
  `@opencode-ai/*` packages in-tree); grok-build vendors codex's tools; the `apply_patch`
  envelope is **one origin — OpenAI's GPT-4.1 cookbook — with zero independent arrivals**
  (codex origin, opencode/warp/kilocode/grok-build all adopt/vendor/cite it).
- **Probable convention-adoption of Claude Code (not independent invention):** the
  ecosystem-wide str_replace edit tool, the todo tool (most-uniform ⇒ most-copied), and
  the ask-user "(Recommended)" shape. Each is independently *reimplemented* code but one
  *design* adopted — weak as "N teams needed X," fine as survivorship.
- **What survives as genuine independent convergence — lean on these:** the graduated
  **fuzzy-match ladder** (digest C2 — same empirical wall hit by ≥5 independent teams,
  shape-convergent / implementation-divergent) and the **headless I/O contract** (digest
  C16 — independently built against a hard external constraint).

**Effect on the cross-tier clusters #1–18 above: minimal — the caveat threatens the
*within-Tier-2 vote-counts*, not the cross-tier triangulation.** Clusters that stand on
≥2 tiers with independent failure modes (e.g. #1 edit-representation, #8 str_replace
multi-match refuse) survive; their prose should shift from "N harnesses independently
converged" to "uniform across the shipping ecosystem (largely by common descent from
Claude Code / OpenAI reference designs)" — which is a *sharper* statement of the gap UDON
targets, not a weaker one. No cluster on this page needs dropping.
