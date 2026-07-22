---
title: Gathering index — phase (1) front door
updated_by: reconciliation pass (Claude Opus 4.8), 2026-07-21
status: front door only — the full reconciled picture lives in MASTER-REGISTRY.md
note: >
  grok-early-pass/GATHERING-INDEX.md is Grok's earlier pass-scoped intake record and is
  preserved unchanged; this top-level index supersedes it as the front door.
---

# Phase (1) gathering — front door

**Start here → [`01-reconciled-target-files/MASTER-REGISTRY.md`](01-reconciled-target-files/MASTER-REGISTRY.md)** — the reconciled registry
across all gathering: the four evidentiary tiers, full inventory with trust, the
cross-tier convergence map (the highest-value signal), a topic index, dedup-vs-Grok,
and the verify→copy→annotate queue.

## What's staged (registered in full in the master registry)

| Cluster | Location | Role |
|---|---|---|
| Fable area maps (7) + support (4) + ASF dossier | `01-reconciled-target-files/agentic-tooling-sources/` | vetted mining maps; `asf-dossier.md` is the Tier-4 *result* (theory), not a map |
| In-vivo harness maps (17) | `01-reconciled-target-files/agentic-tooling-sources/harness-invivo/` | Tier-2 shipped-practice; digested in `scratch/reconcile-workdir/BUCKET-tier2-invivo.md` |
| Situation seeds | `needs-map.md` | S1–S12 + standing harvest queue |
| Schema-versioning map | `01-reconciled-target-files/sources-schema-versioning.md` | rowan/autopax/operata schema (⚠ earlier bar; rich) |
| Grok six-map merge | `01-reconciled-target-files/MERGED-six-maps.md` | path-union; uniquely elevates usability corpus + scenarios + consumers |
| Grok pass (maps/extracts/spikes/excerpts) | `02-provenanced-copies/grok-early-pass/` | reference only — do not modify |
| ELI first-person testimony (Tier 3) | reconciled from quarantine | see master registry §1f |
| Quarantine (first sweep) | `scratch/first-sweep-agentic-tooling/` | do NOT promote (ELI section excepted) |
| Reconciliation buckets | `scratch/reconcile-workdir/` | phase-2 aids; disposable |

## Supersession review (2026-07-21, reconciliation pass) — verdict: nothing further to archive

A per-file review for "fully superseded → move to `v2/.archived/`" was run after the
registry landed. Findings, so it isn't redone:
- **Already archived (prior session):** grok's `MERGED-grok-source-maps.md` (the merge
  that unioned the quarantine) — at `../.archived/gathering-scratch-subsumed-2026-07-21/
  open-source-file-pass-2026-07-21/`. It was the only fully-superseded artifact.
- **`02-provenanced-copies/grok-early-pass/` stays intact.** Its own README establishes: the *pass* is
  quarantined-as-method, but every unique path/extract/annotation is first-class input.
  Verified per-file: the `extracts/` carry grok's verify→copy→**annotate** stage
  (frontmatter categories + why_included are unique work, not copies); `spikes/` are
  unique demand residue; `discussion-excerpts/` duplicate the live
  `../pipeline-discussion.md` verbatim **but** their annotation layer is unique and the
  live file's line numbers can drift — kept as the stable annotated copies. Grok's inner
  `GATHERING-INDEX.md` is function-superseded as a front door (this file + the registry
  replace it) but is the pass's internal navigation and provenance-convention record —
  content-unique, stays with its pass.
- **`scratch/first-sweep-agentic-tooling/` stays.** Quarantined but not fully
  represented: its ELI-testimony section carries texture (quotes, line pointers, the
  negative findings on the other three ELI homes) that registry §1f only summarizes.
- **`scratch/reconcile-workdir/` buckets stay** until phase (2) consumes the registry
  (registry §1e points into the Tier-2 bucket).

## Phase handoff
Phase (1) → (2) still owes the **verify → copy-with-provenance → annotate** progression;
the master registry §6 leaves it as a prioritized copy-queue (ordered by convergence
strength) rather than pre-executing it. Open steward calls: master registry §7.
