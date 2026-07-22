# Phase (1) — Gathering & Ideation: subphases and layout

Phase (1) of the demand-side flow (see `../README.md` for the full flow) runs through four subphases, per Joseph's framing (2026-07-21, verbatim):

> "I suspect it will be easiest to phase it as 'potential source files' -> verify they are relevant and not already present (verbatim that is; restated or w/ different context would be good though IMO) -> copy file or relevant span to a file in 1-gathering w/ provenance in frontmatter -> analyze for (2) type stuff, categories, etc.-- and flesh out the frontmatter / metadata some more + add any top-banner description of why it is included '... This is an *older* version of this other one, but it articulates the reason why a bit more meaningfully...' type annotation/editorial."

| Subphase | Work | Lives in |
|----------|------|----------|
| **1.1 Target identification** | Mining-spot maps / source listings ("potential source files"), reconciled into a prioritized target queue | [`01-reconciled-target-files/`](01-reconciled-target-files/) |
| **1.2 Verification** | Per-target: confirm relevance; confirm not already present *verbatim* (restated-in-different-context is wanted, with editorial) | happens en route 01 → 02 |
| **1.3 Provenanced intake** | Copy file or relevant span here — or characterize/synthesize where verbatim copy is the wrong move — provenance in frontmatter | [`02-provenanced/`](02-provenanced/) |
| **1.4 Annotation & pre-analysis** | Categories, `why_included` banners, phase-(2)-facing metadata — fleshed out in place on the intake | in place, within `02-…` |

## Layout

- **`01-reconciled-target-files/`** — subphase-1.1 output: **`TARGET-FILES.md`**, the flat spawnable target-file union — one row per unique target across all ~30 mining maps (the maps themselves were dissolved into it 2026-07-21 and archived at `v2/.archived/consumed-maps-2026-07-21/`), priorities carried from the maps' own tiering, merged annotations, editorial + dry-wells inline, per-section [COPY]/[CHARACTERIZE] work-mode markers. Extraction agents spawn against its rows.
- **`02-provenanced/`** — subphases 1.3/1.4 output, by genre: `copies/` (verbatim spans w/ provenance: grok's extracts + discussion-excerpts), `characterizations/` (extraction-by-report: the 17 `harness-invivo/` reports, `sapientia-bin-buildout.md`), `syntheses/` (the ASF dossier + reading log, `CONVERGENCES.md` — tiers, 18 cross-tier clusters, the Tier-2 lineage caveat — and the tier-2 digest), `commentary/` (grok's demand spikes). The genres carry different trust: copies can't be wrong about their source; characterizations can; syntheses carry reading-log provenance.
- **`needs-map.md`** — gathered ideation seed (situations S1–S12); an input to phase (2)'s deliverable shape, not a source listing or a copy.
- **`scratch/`** — search logs, the reconcile workdir (UNION chop passes = the union's assembly provenance), grok pass bookkeeping, and the quarantined first sweep (see its README before touching).
- **`GATHERING-INDEX.md`** — the running front door / state of the phase.
- **`02-provenanced/LEDGER.md`** — append-only extraction ledger: one line per target *visit* (date · disposition · output · by · note), dry visits included. The quick view of what's accumulating in 02 with no reconciliation script: TARGET-FILES is the plan, the ledger is the actuals, their diff is the remaining work. Append-only by design — parallel agents' appends don't collide where edits would.

## Frontmatter template for `02-provenanced/` files

Every file landing in `02-provenanced/{copies,characterizations,syntheses,commentary}/` carries YAML frontmatter in this shape (settled 2026-07-21 from grok's convention, in uniform use across all existing copies):

```yaml
---
source: <descriptive origin — repo file / consumer doc / discussion turn / sweep>
gathered: <YYYY-MM-DD>
status: <gathered / characterization / synthesis — never authoritative;
  partial extracts say so explicitly ("head only — full file ~N lines")>
paths:
  - <actual source location; repo-relative for this repo, absolute for
    external; append :start-end line-spans for excerpts and jsonl>
source_commit: <git SHA of the source repo at gather time; source_mtime
  for non-git sources. Optional but expected for anything external or
  long-lived — "live originals may advance" is only checkable against a
  pin. (The theory's own point: verifiability of the past, not its
  presence, is what makes a copy trustworthy.)>
categories: [<phase-2 tags>]
why_included: <one line of editorial — or carry it as a top banner
  blockquote in the body when it wants more room>
---
```

The 17 pre-template files (grok's extracts + excerpts) predate `source_commit`; their gather date locates the commits if ever needed — backfill is optional-queue work, not a blocker.

## The session-transcript corpus — dialog content is IN scope; only bulk telemetry is deferred

**Correction (2026-07-21, after a misapplied exclusion):** an earlier version of this section ("raw session corpora — query it, don't sweep it") was over-generalized from Joseph's note and got applied by audit agents as a *class exclusion on content hits* — the opposite of the standing instruction. The actual rule:

- **Dialog content in transcripts is a first-class source.** memorata3-search over the session corpora (~/.claude/projects/**, ~/.claude.bak.*, ~/.sapientia/, cc-raw jsonls, curation transcripts, session-vault) is how much of this corpus was found, and any span a search surfaces is an **ordinary candidate**: read it, judge it against the vision question, land/witness/dismiss-with-reason. There is no transcript class exclusion. Never classify a search-surfaced span as excluded *by location*.
- **What IS deferred** is a different thing entirely — an **empirical statistical analysis over the `tool_use`/`tool_result` records** of those sessions (failure-result rates, retry cascades, capability evolution across a year of Anthropic models). Note the disjointness: **memorata3 does not even index tool-use lines** — it indexes conversational text — so a memorata3 hit is *by construction* dialog content and can never belong to this deferred class. The two aren't slices of one search space; they're different data planes needing different methods (jq/ scripts vs. semantic search). The telemetry analysis is commissioned when a specific question bounds it.
- **External landscape via /deep-research** — commissioned per-question (first commission landed 2026-07-21: `02-provenanced/syntheses/external-landscape-2026-07.md`).

Standing brief for agents working this material (purposes, quality bars, conventions): [`../BRIEF-agentic-tooling-compilation.md`](../BRIEF-agentic-tooling-compilation.md).
