# Phase (1) — Gathering & Ideation: subphases and layout

Phase (1) of the demand-side flow (see `../README.md` for the full flow)
runs through four subphases, per Joseph's framing (2026-07-21, verbatim):

> "I suspect it will be easiest to phase it as 'potential source files' ->
> verify they are relevant and not already present (verbatim that is;
> restated or w/ different context would be good though IMO) -> copy file
> or relevant span to a file in 1-gathering w/ provenance in frontmatter ->
> analyze for (2) type stuff, categories, etc.-- and flesh out the
> frontmatter / metadata some more + add any top-banner description of why
> it is included '... This is an *older* version of this other one, but it
> articulates the reason why a bit more meaningfully...' type
> annotation/editorial."

| Subphase | Work | Lives in |
|----------|------|----------|
| **1.1 Target identification** | Mining-spot maps / source listings ("potential source files"), reconciled into a prioritized target queue | [`01-reconciled-target-files/`](01-reconciled-target-files/) |
| **1.2 Verification** | Per-target: confirm relevance; confirm not already present *verbatim* (restated-in-different-context is wanted, with editorial) | happens en route 01 → 02 |
| **1.3 Provenanced intake** | Copy file or relevant span here, provenance in frontmatter | [`02-provenanced-copies/`](02-provenanced-copies/) |
| **1.4 Annotation & pre-analysis** | Categories, `why_included` banners, phase-(2)-facing metadata — fleshed out in place on the copies | in place, within `02-…` |

## Layout

- **`01-reconciled-target-files/`** — subphase-1.1 output.
  `MASTER-REGISTRY.md` is the front door (four evidentiary tiers, 18
  cross-tier convergence clusters, trust annotations, the prioritized
  copy-queue that drives 1.2/1.3). Beside it: the ~30 vetted mining-spot
  maps (`agentic-tooling-sources/` incl. the 17 in-vivo harness maps and
  the ASF dossier — the dossier is a tier-4 *synthesized result*, not a
  map), `sources-schema-versioning.md`, and grok's `MERGED-six-maps.md`.
- **`02-provenanced-copies/`** — subphases 1.3/1.4 output.
  `grok-early-pass/` is the first resident: 14 extracts + 3
  discussion-excerpts already carrying provenance frontmatter, categories,
  and `why_included` annotation (the furthest-advanced material in the
  pipeline). The extraction pass over the copy-queue lands its copies
  here too.
- **`needs-map.md`** — gathered ideation seed (situations S1–S12); an
  input to phase (2)'s deliverable shape, not a source listing or a copy.
- **`scratch/`** — search logs, reconcile buckets, and the quarantined
  first sweep (see its README before touching).
- **`GATHERING-INDEX.md`** — the running registry of what's staged, with
  the supersession-review record.

Standing brief for agents working this material (purposes, quality bars,
conventions): [`../BRIEF-agentic-tooling-compilation.md`](../BRIEF-agentic-tooling-compilation.md).
