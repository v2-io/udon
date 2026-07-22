---
title: Gathering index — phase (1) front door
updated_by: single-writer curation pass (Claude Opus 4.8), 2026-07-21 (post-extraction reconciliation)
status: current — reflects the completed 2026-07-21 extraction fan-out (~270 provenanced artifacts)
---

# Phase (1) gathering — front door

**Read me first.** The 2026-07-21 extraction fan-out is **done**: ~30 mining-spot maps
were dissolved into one target union, then ~16 parallel agents worked its rows into
**~270 provenanced artifacts** under `02-provenanced/`. This index is the map of what
landed and where the (few) open items are. If you're a phase-(2) synthesis agent, orient
here, then read [`../BRIEF-agentic-tooling-compilation.md`](../BRIEF-agentic-tooling-compilation.md)
(the standing brief — purposes, tiers, quality bars) and
[`02-provenanced/syntheses/CONVERGENCES.md`](02-provenanced/syntheses/CONVERGENCES.md)
(the four evidentiary tiers + 18 cross-tier clusters — the highest-value content).

## The plan / actuals / ledger triad

Three files hold the state; their relationship *is* the tracking system (no reconcile
script — the diff is read by eye, and as of this pass it's folded into the plan itself):

| File | Role |
|---|---|
| **[`01-reconciled-target-files/TARGET-FILES.md`](01-reconciled-target-files/TARGET-FILES.md)** | **The plan.** ~300 spawnable target rows, one per unique target across all maps, priority + why + work-mode. As of 2026-07-21 **every row carries a ✔/○dry/⊘blocked/☐ disposition marker folded from the ledger** — so remaining work reads at a glance (see its "Extraction status" header for the legend). |
| **[`02-provenanced/LEDGER.md`](02-provenanced/LEDGER.md)** | **The actuals.** 286 append-only lines, one per target *visit* (date · disposition · output · by · note), dry/blocked visits included. Append-only by design — parallel appends don't collide where edits would. The per-file record; TARGET-FILES is its reconciled projection. |
| **[`02-provenanced/syntheses/CONVERGENCES.md`](02-provenanced/syntheses/CONVERGENCES.md)** | **The analysis.** Why targets were prioritized: four evidentiary tiers, 18 cross-tier agreement clusters, singletons, the Tier-2 lineage-vs-convergence caveat — **now resolved by** [`tier2-lineage.md`](02-provenanced/syntheses/tier2-lineage.md) (read its Part 4 rules before citing any Tier-2 vote-count). |

## What `02-provenanced/` holds, by genre (~270 artifacts)

Genre carries **trust level**: a verbatim copy can't be wrong about its source; a
characterization can; a synthesis carries its own reading-log provenance; commentary is
witness-line evidence. Frontmatter template + provenance conventions live in
[`README.md`](README.md).

### `copies/` — 219 verbatim files/spans (with provenance frontmatter)

| Cluster | # | Cluster | # |
|---|--:|---|--:|
| `extracts/` (grok early pass, in-repo design/consumer) | 14 | `II2-zoetica-ennaos/` | 34 |
| `discussion-excerpts/` (3 Joseph pipeline-discussion turns) | 3 | `II3-nexum/` | 14 |
| `I1-usability/` | 5 | `II4-autopax-practica/` | 43 |
| `I2-scenarios/` (incl. 7-file `corpus/` mirror) | 12 | `II5-dialogs/` | 5 |
| `I3-design-of-record/` | 12 | `II6-elsewhere/` | 6 |
| `I4-genre-seeds/` | 7 | `II7-ref-arch/` | 10 |
| `I5-live-consumers/` | 7 | `II8-harness-refs/` | 7 |
| `I7-seam-addendum/` | 2 | `III-schema/` | 19 |
| `II1-sapientia/` | 11 | `III-vaults/` | 8 |

### `characterizations/` — 28 extraction-by-report

- `harness-invivo/` — **17** per-repo tool-usage maps (14 shipping harnesses + claude-docs + obsidian×2 + yq).
- **11** top-level reports (sapientia architecture/dialogs, shoshin memory-design, vaults agents-as-documents + context-memory survey, III-schema pipeline, I1 usability corpus, I7 archaeology + library API surfaces, sapientia-bin buildout, II8 anecdotes).

### `syntheses/` — 4 already-integrated secondary documents

`asf-dossier.md` (+ `-reading-log.md`; Tier-4 theory) · `CONVERGENCES.md` (tiers + 18 clusters) · `tier2-invivo-digest.md` (read-across of the 17 in-vivo maps) · `tier2-lineage.md` (copying-vs-convergence disentangle: apply_patch = one origin not five; fork pairs collapsed; C2 fuzzy-ladder + C16 headless-contract survive as genuine convergence). *Register + cross-link these — don't decompose or re-derive them.*

### `commentary/` — 19 witness + demand-spike files

16 per-section witness files (`*-witness.md` — 1–2-line evidence, dry-wells, steward flags per area) + `spikes/` (grok's demand spikes: agent-utility notes, paths notes + sketches).

## Steward calls — open questions for Joseph

**[`STEWARD-CALLS.md`](STEWARD-CALLS.md)** (at the `01-ideation` root) collects the
questions the fan-out agents surfaced-not-guessed — vaults scope, Tier-2 lineage
disentangle, path-boundary rulings, the SAR alignment-speed counter-result, the
ELI-testimony-not-landed gap, and more. Each links to the witness file with full context.
Rulings get marked inline; a later curation pass sweeps resolved rows out. TARGET-FILES
markers cite these as `SC#N`.

## Deferred reservoirs — available on question, not swept

Two sources deliberately **not** mined in the fan-out (reach for them when a specific
question wants an answer, don't sweep now) — full rationale in [`README.md`](README.md)
§"Deferred reservoirs":

- **Raw session corpora** (`~/.claude/projects/**`, `~/.sapientia/`, cc-raw jsonls, session-vault) — question-shaped empirics: edit-tool failure rates across model generations, retry-cascade shapes, the year-long evolution of harness+model tool-use capability.
- **External landscape via `/deep-research`** — commissioned per-question when synthesis hits a claim wanting outside corroboration.

## Quarantine / archive map — reference, do not resurrect

| Location | What | Rule |
|---|---|---|
| `scratch/first-sweep-agentic-tooling/` | The quarantined first sweep (failed the vetted-bar) | Stays quarantined. Its one good tier — ELI first-person testimony — was reconciled forward into TARGET-FILES Part III (see `SC#11`: content reconciled, but *not* re-landed as `02-provenanced/` artifacts). |
| `scratch/reconcile-workdir/` | UNION chop passes | The union's assembly provenance. |
| `scratch/{grok-pass-*, schema-sources-search-log}.md` | grok pass bookkeeping + search logs | Provenance only. |
| `v2/.archived/consumed-maps-2026-07-21/` (6) | The ~30 mining maps, dissolved into TARGET-FILES | Recoverable, never deleted; nothing below TARGET-FILES survives only as a pointer to them. |
| `v2/.archived/{first-pass,second-pass,gathering-scratch-subsumed-2026-07-21}/` | Superseded earlier passes | Reference. |

## Standing open items (post-fan-out)

- **⊘ Blocked residual:** TARGET-FILES rows 763–764 (rowan `types`/`shared_types`/`evolution_context.rb` + `LEXICON.md`) — deferred for budget, a known residual, not a dry well.
- **☐ In-scope residual:** the `~/vaults` book-analyses (row 607) + `AGENT_FIX_RECOMMENDATIONS` (row 608 half) — un-extracted. Vaults is **ruled in-scope** (`SC#1`, jaw 7/21) and Part III extracted it broadly, so these are ordinary residuals a later phase can pick up, not scope-blocked.
- **☐ ELI testimony not re-landed:** rows 776–782 carried via the first-sweep quarantine but not written as `02-provenanced/` artifacts — `SC#11`.
- **Tier-2 lineage-vs-convergence disentangle** (recommended before synthesis leans on Tier-2 counts) — `SC#3`; also in `CONVERGENCES.md` §standing.
- **Residual gaps** (CONVERGENCES §standing): `_ref/{principia,cddf,crew-first}`; dossier pass-4 targets; grok §13 gaps; **Joseph's end-user ideation dump — primary when it lands.**
