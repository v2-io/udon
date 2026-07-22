# 02-tooling-needs — the agentic-tooling monograph (phase 2)

**What this is.** The synthesis phase of the demand-side flow: consolidation,
normalization, and synthesis of everything gathered in
[`../01-ideation/`](../01-ideation/) into one multi-part report on **what
agents — and the humans working with and through them — actually need from
their tools**. It serves two named consumers (see
[`../BRIEF-agentic-tooling-compilation.md`](../BRIEF-agentic-tooling-compilation.md)):

1. **UDON v2** — the demand evidence that phases (3)–(4) (priorities; decisions
   on paths/dialects/schemas/embeds) adjudicate against.
2. **`~/src/archema-io/harness/`** — the programme's consolidated statement on
   agentic tooling, ported over as the basis for the harness work. Segments
   are marked `consumers: udon | harness | both`; where the two diverge, the
   segment says so rather than silently serving one.

**Shape.** ASF-style: [`OUTLINE.md`](OUTLINE.md) carries the whole argument
part-by-part with one table row per segment (claim + stage at a glance);
segments live in [`src/`](src/), one claim-cluster per file, reorderable by
editing the outline alone. Adopted from `~/src/archema-io/asf/` per Joseph's
recommendation, right-sized: no formal-derivation apparatus, but the parts
that earn their keep here — per-segment frontmatter with **epistemic status**,
explicit dependency links, stage tracking, and outline-as-single-spine — are
kept, because this report will be load-bearing for two programs and its
claims inherit the tier of their weakest source.

## How to read a segment

Frontmatter fields:

- `type:` — `finding` (what the evidence shows) · `demand` (what consumers
  need from tools/formats) · `principle` (a design rule the evidence
  supports) · `counterposition` (evidence *against* something we believe) ·
  `method` (how to weigh the evidence) · `synthesis` (cross-segment
  integration).
- `evidence:` — which tiers ground it (T1 first-principles ideology · T2
  in-vivo shipped practice · T3 lived agent testimony · T4 formal theory ·
  T5 external published evidence). **Cross-tier is the gold standard**; the
  corpus is mostly one author, so within-tier agreement is coherence, not
  corroboration, and T2 vote-counts are lineage-corrected per
  [`tier2-lineage.md`](../01-ideation/02-provenanced/syntheses/tier2-lineage.md).
- `status:` — the claim's epistemic standing (`cross-tier-convergent`,
  `theorem-grade-conditional`, `lineage-corrected-survivorship`, `singleton`,
  `contested`, `unmeasured-claim`, …). This is about *truth*, not progress.
- `stage:` — the segment's authoring state (`drafted` · `planned` · `stub`).
  A `planned` row in the outline states its claim and sources but the
  synthesis pass over its primaries has not run — do not cite it downstream
  as if it had.
- `consumers:` — `udon` / `harness` / `both`, with a "who reads this and
  when" line in the body where the divergence matters.
- `sources:` — the `01-ideation` artifacts (and through them the primaries)
  the segment stands on. Every claim traces back through provenanced
  artifacts; re-open the primary at the point you rely on it.

## State of the report

Seeded 2026-07-22. The outline is complete at part level; core segments are
drafted (the spine every later segment hangs from); the remaining segments
are `planned` rows with claims and source lists so the shape of the whole is
visible and any of them can be picked up independently.
[`RESIDUALS.md`](RESIDUALS.md) carries the honest-coverage ledger: what the
drafted segments did *not* absorb, known gaps, and the bolt-on points for the
pieces Joseph expects to spot as the monograph comes together.

Quality bars are the BRIEF's, unchanged: vetted (no claim from an unread
source), provenance always, restatement-with-annotation over verbatim
duplication, convergence discipline, honest coverage, and
transported-judgments-are-stale (a judgment inherited from an upstream
artifact carries its author's charter and date, not this document's).
