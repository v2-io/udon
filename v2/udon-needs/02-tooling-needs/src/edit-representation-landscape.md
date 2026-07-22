---
slug: edit-representation-landscape
type: finding
evidence: [T2, T5, T3, T4]
status: cross-tier-convergent; T2 counts lineage-corrected
stage: drafted
consumers: both
depends: [errors-that-teach, method-evidence-tiers]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # Part A, C1–C4, Part C, Part D.1
  - ../../01-ideation/02-provenanced/syntheses/tier2-lineage.md
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 1, 2
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 1
---

# The edit-representation landscape: text-level, guarantee-free, and empirically decisive

**Claim.** How an agent *expresses an edit* is the single most
consequential interface choice in shipped agentic tooling. The externally
measured swing between edit formats on one model was 14% → 57% task
success — roughly four-to-one, from format choice alone (measured on
fine-tuned 7B-class models; frontier numbers will differ). The most-used
editing tool's own benchmarks report two-to-three-fold variation — a
figure that reaches this report second-hand, corroborating the direction
without pinning the size. And across all of it, *every* shipping
approach edits at the text level, with **no validity guarantee** for the
artifact being edited. That absence is the gap this whole part of the
report converges on (the
[guarded-mutation chapter](schema-guarded-mutation.md)).

## The landscape

Fourteen real harnesses were examined at source level; copying and
invention are distinguished throughout ([the shipping-practice
report](../reports/shipping-practice.md) carries the full examination).
Three paradigms ship today:

1. **Exact find-and-replace** — old text, new text; fail loudly on zero
   matches or more than one; a mandatory read of the file first.
   Near-universal — largely by adoption of Claude Code's design rather
   than independent arrival, which still says something: nothing has
   displaced it.
2. **Patch envelopes** — a fenced patch dialect (`*** Begin Patch …`)
   with one published origin (OpenAI's cookbook) and zero independent
   arrivals; one harness hardens it by constraining the decoder with the
   patch grammar so a malformed patch cannot be emitted at all.
3. **Hash-anchored lines** — one harness addresses each line by its
   position *plus a short hash of its content*, and applies edits as an
   atomic bottom-up batch where one stale anchor rejects the whole
   batch. The only materially different addressing paradigm shipping
   anywhere: content-addressed rather than quoted-text-addressed.

**The one genuine independent convergence.** At least five teams, same
shape, different implementations: a **graduated tolerance ladder** on
top of exact matching — try byte-exact, then whitespace-flexible, then
anchor-and-similarity tiers, and in one case escalate to a second model
call that repairs the edit. The convergent insight underneath: a
model-emitted "old text" is reliably *almost* right and reliably *not
byte-exact*. Every mature team hit that wall and built the same-shaped
cushion rather than trusting exact match or falling back to whole-file
rewrites.

**The abandonment that shaped the landscape — scoped honestly.** The
aider project tried routing edits through JSON tool-call arguments and
killed the mechanism (its code still raises "Deprecated" there): models
of that era mangled the structured arguments. Within the ecosystem
sampled here, edits-as-marked-up-text is what everyone ships. But the
negative result is family- and era-scoped, not a law: in the
Gemini/Antigravity ecosystem, tool-call editing with schema validation
at the tool layer is the successful default (a dissent from a
Gemini-family reviewer, carried in the
[counter-register](counter-register.md)). The honest statement: in the
Claude/OpenAI-lineage world examined here, text-dialect editing won and
one team's abandonment of the alternative is on record; elsewhere the
alternative is alive. Its second half: five separate sources show
harnesses routing *per model* — different edit formats, different
prompts, per model family. **No shipping harness treats the edit
contract as model-agnostic.**

## External corroboration (published research, independently checked)

- Line-number-indexed diffs fail catastrophically (the 14%-vs-57% figure
  above); structure-aware diffs match whole-file accuracy at more than
  30% lower cost — though the accuracy edge itself is thin (a point and
  a half, in a single benchmark cell). The aider project measures format
  *compliance* separately from correctness, and defaults unfamiliar
  models to whole-file rewrites as the easiest thing to emit correctly.
- The SWE-agent work (NeurIPS 2024) established the frame this whole
  part rests on: agents are a distinct user category — an
  *agent-computer interface* is a real design surface — and guarded
  edits with concise feedback measurably change solve rates.

## The lived and theoretical anchors

An agent's own account of editing without the loud-refusal shape shows
the failure directly (the [refusal chapter](errors-that-teach.md)
carries it). The theory explains *why* representation dominates: the
edit channel is action and observation at once — it is how the agent
acts on the artifact *and* how it learns whether its model of the
artifact was right, so its ambiguity is priced twice (the
[observation chapter](tools-are-observation-infrastructure.md)).

## What it generates

- **For UDON:** the bar a structural edit representation must clear is
  now precise — match the tolerance ladder's *reliability* (models can
  emit it correctly) while adding the thing no shipping tool has:
  **validity guarantees**. The ladder exists because text addressing is
  brittle; stable structural addressing (the
  [addressing chapter](addressing-is-the-long-pole.md)) attacks the
  cause rather than cushioning the symptom. The hash-anchor batch is
  prior art for freshness semantics (the
  [freshness chapter](freshness-and-atomicity.md)); grammar-constrained
  patch emission is prior art for making the representation itself
  impossible to mis-emit.
- **For the harness:** adopt the ladder consciously — it is the
  empirical floor; expect per-model routing; and treat edit-format
  compliance as a measurable, model-specific quantity. The aider
  project's public leaderboard discipline is the model to copy.

## What this opens (ideas, not designs)

- ✦ **The ladder as a published contract.** Every team built its
  tolerance ladder privately. Standardized — with each result declaring
  *which tier matched* — edit reliability would become comparable
  across tools and models, and a tier-2 match (whitespace-flexible)
  could warn where a tier-0 match (byte-exact) stays silent.
- ✦ **Path plus hash.** The landscape presents structural addressing and
  content-hash anchoring as different paradigms; nothing prevents their
  composition — a structural path names the place, a content hash pins
  the version, and staleness becomes detectable *at the address level*
  regardless of how the document moved underneath. Neither alone
  delivers that.
- ✦ **A compliance arena for structural edits.** The "precise bar" above
  is runnable: the same edit tasks, the same models, the tolerance
  ladder versus a schema-guarded structural representation,
  compliance and correctness scored separately. Before UDON claims its
  edit tool beats the ladder, this is the experiment that would know.
- ✦ **Edit dialects as declared capability.** Harnesses route edit formats
  per model by folklore and testing. Models (or their cards) could
  *declare* which edit dialects they are trained against — turning the
  universal ad-hoc routing into negotiation over stated capability.

## Honest edges

No shipping harness handles multi-file atomic transactions except the
hash-anchor batch within single batches — a named gap with no coverage
anywhere in the examined ecosystem. And the uniformity of
find-and-replace is weak evidence of *optimality* — it is strong
evidence only that it is good enough to survive under current model
capabilities, within a sample heavy in one lineage; the first look at
another lineage immediately produced the counter-example above.
