---
slug: edit-representation-landscape
type: finding
evidence: [T2, T5, T3, T4]
status: cross-tier-convergent; T2 counts lineage-corrected
stage: drafted
consumers: both
depends: [errors-that-teach, method-evidence-tiers]
sources:
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # Part A, C1–C4, Part C, Part D.1
  - ../01-ideation/02-provenanced/syntheses/tier2-lineage.md
  - ../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 1, 2
  - ../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 1
---

# The edit-representation landscape: text-level, guarantee-free, and empirically decisive

**Claim.** How an agent expresses an edit is the single most consequential
interface choice in shipped agentic tooling — format choice swings success
2–3× — and *every* shipping approach edits at the text/character level with
**no validity guarantee** for the artifact being edited. That absence is the
gap this whole part of the report converges on (#schema-guarded-mutation).

## The landscape (T2, 14 real harnesses, lineage-corrected)

Three paradigms ship today:

1. **Exact str-replace** (old_string/new_string; fail loud on 0 or >1
   matches; read-before-edit gate) — near-universal, **largely by
   convention-adoption of Claude Code's design** rather than independent
   arrival. Survivorship evidence: nothing has displaced it.
2. **Patch envelopes** (`*** Begin Patch …` V4A) — **one origin** (OpenAI's
   cookbook), zero independent arrivals; codex's version is
   grammar-constrained (lark) rather than free-text-then-parsed.
3. **Hashline anchor-editing** (grok-build singleton) — `LINE:HASH→content`
   anchors; atomic bottom-up batch where one stale anchor rejects the whole
   batch. The only materially different addressing paradigm in Tier 2:
   content-addressed-by-hash instead of by-quoted-text.

**The one genuine independent convergence** (survives lineage correction,
≥5 teams, shape-convergent/implementation-divergent): the **graduated
fuzzy-match ladder** layered on exact matching — whitespace-flexible →
anchor/similarity tiers → (singleton escalation) a second LLM call to repair
the edit. The convergent insight: LLM-emitted `old_string` is reliably
*almost* right and reliably *not byte-exact*; every mature team hit this
wall and built the same-shaped tolerance rather than trusting exact match or
falling back to whole-file.

**The abandonment that explains the landscape:** aider tried tool-call
(JSON-function) editing and killed it (`RuntimeError("Deprecated")`) —
models mangled structured arguments. The ecosystem's convergence on
prompt-dialect editing is the residue of that negative result, not taste.
Model-conditional routing (per-model edit formats, per-model prompts, 5
sources) is the second half of that lesson: **no shipping harness treats the
edit contract as model-agnostic.**

## External corroboration (T5, adversarially verified)

- Line-number-indexed diffs catastrophically fail (14.07% vs 57.07% pass@1,
  7B model); structure-aware diffs match/beat whole-file at >30% lower cost;
  aider measures format *compliance* separately from correctness and
  defaults unfamiliar models to whole-file as easiest-to-emit. (Caveat
  travels: headline numbers are fine-tuned-7B-era, not frontier.)
- SWE-agent (NeurIPS 2024): agents are a distinct user category; guarded
  edits and concise feedback measurably change solve rates — the ACI thesis
  underneath this whole part.

## T3/T4 anchors

Architectus's testimony shows the failure when the refusal-shape is absent
(#errors-that-teach); T4 grounds *why* representation dominates: the edit
channel is simultaneously action semantics (the C3 gate) and an observation
channel whose ambiguity the κ×A law prices (#tools-are-observation-infrastructure).

## What it generates

- **For UDON:** the bar a structural edit representation must clear is now
  precise — beat the fuzzy-ladder's *reliability* (models emit it correctly)
  while adding what no shipping tool has: **validity guarantees**. The
  fuzzy-ladder exists because text addressing is brittle; stable structural
  addressing (#addressing-is-the-long-pole) attacks the cause rather than
  cushioning the symptom. Hashline's stale-anchor-rejects-all is prior art
  for freshness semantics (#freshness-and-atomicity); grammar-constrained
  emission (codex) is prior art for making the representation itself
  un-mis-emittable.
- **For the harness:** adopt the ladder consciously (it is the empirical
  floor), expect per-model routing, and treat "edit-format compliance" as a
  measurable, model-specific quantity — aider's leaderboard discipline is
  the model to copy.

## Honest edges

Nobody in Tier 2 addresses multi-file atomic transactions except hashline's
batch semantics (named gap, carried in RESIDUALS). And the uniformity of
str-replace is weak evidence of *optimality* — it is strong evidence only
that it is good enough to survive under current model capabilities.
