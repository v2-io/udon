---
slug: context-economy
type: finding
evidence: [T2, T4, T5]
status: cross-tier-convergent; mechanism families kept distinct
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure, persistence-is-imported]
sources:
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C7, C8, C11, SWE-Pruner singleton
  - ../01-ideation/02-provenanced/syntheses/asf-dossier.md  # obs-context-turnover DL budget; §4.2
  - ../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # finding 7 (response-size hazard)
---

# Context is a hard budget, and the ecosystem built an economy around it

**Claim.** The context window is a joint description-length budget —
strategy + world-model + task specification under one capacity (T4's frame:
window limits are a structural ceiling on sustainable strategy complexity,
and "context-stuffing helps to a point, then degrades" is an
information-rate fact, not folklore). Shipped practice has independently
built a whole economy against that budget, in **distinct mechanism
families that downstream design must not merge** (the anti-collapse
discipline — they route to different repairs):

## The mechanism families (T2)

1. **Don't load it until needed — deferred tool loading.** Name-only
   registration + on-demand schema fetch; ~3 independent arrivals in the
   same 2026 window once lineage is corrected (Claude Code is the origin;
   qwen-code explicitly mirrors it and inherits gemini-fork infrastructure;
   codex and kimi-code are the more plausibly independent arrivals —
   tier2-lineage C7, "partial lineage"). The digest's pre-correction read
   called this the strongest recent-advancement convergence in Tier 2; the
   corrected form is more modest but still notable: >85% token reduction
   cited, with accuracy degrading past 30–50 loaded tools.
2. **Don't let one result flood the window — disk-spill with preview.**
   ~2000 lines / ~50KB thresholds recur; full output parked on disk,
   recoverable by path. T5 corroboration: unbounded tool-response size is a
   measured shipped hazard (a 5K→250K-token inflation incident) — the
   external world is paying for the absence of this mechanism.
3. **Shrink each result before it lands — content-aware pruning.** The
   SWE-Pruner singleton: a small model skims raw tool output per-call
   against a declared `context_focus_question`. Different lever than
   size-based truncation; kept distinct.
4. **Compact the conversation itself.** Two sub-shapes: XML state-snapshot
   prompts ("this snapshot is the agent's *only* memory") and first-person
   handoff notes. This family is where #persistence-is-imported's warning
   bites hardest — compaction that replaces history rather than pointing at
   it produced the lived false-confidence failure.

T4 adds the buffer architecture underneath: capture / triage / processing as
separable stages (triage reading signal statistics, not content — staying
goal-clean), and the ephemeral/persistent channel duality (quick-view
snapshots vs durable stores have different design physics).

## What it generates

- **For the harness:** provision all four families deliberately — they are
  complements, not alternatives; a harness optimizing only one (e.g. ever
  more aggressive compaction) inherits the failure the others prevent. Keep
  ephemeral instruments and durable stores architecturally distinct.
- **For UDON:** compact-but-legible is a *theory-priced* property (the DL
  budget), which is the honest frame for the size-comparison pitch; spilled
  and deferred artifacts are documents agents re-enter cold — self-describing
  structure and stable addressing (#addressing-is-the-long-pole) are what
  make family-2 artifacts usable rather than merely stored; and a
  standardized "focused subtree + breadcrumb" payload
  (#progressive-disclosure-read-path) is the notation-side complement of
  family 3.

## Honest edges

The numeric thresholds are JS-family folklore (shared lineage), not derived
constants. Whether structure-aware pruning beats question-driven small-model
pruning is unmeasured — a candidate experiment once UDON payloads exist in a
real harness loop.
