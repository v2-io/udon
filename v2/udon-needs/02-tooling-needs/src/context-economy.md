---
slug: context-economy
type: finding
evidence: [T2, T4, T5]          # genre only; see method-evidence-tiers "three axes"
register: evidenced             # the four families are observed in shipping practice + external measurement; the budget-is-structural backbone is derived from conditional theory; cards are proposed
strength: robust-qualitative    # the four-distinct-families finding holds across harnesses; the DL-budget backbone is conditional (theory, named premises) and the numeric thresholds/measurements are measured-with-caveats — all marked in prose
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure, persistence-is-imported]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C7, C8, C11, SWE-Pruner singleton
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md  # obs-context-turnover DL budget; §4.2
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # finding 7 (response-size hazard)
---

# Context is a hard budget, and the ecosystem built an economy around it

**Claim.** An agent's context window is one shared budget paying for
three things at once — its plan, its picture of the world, and the task
in front of it. The formal theory makes that a structural fact rather
than a budgeting metaphor: window limits are a ceiling on sustainable
plan complexity, and "context-stuffing helps to a point, then degrades"
is an information-rate result, not folklore. Shipping practice, without
citing any of that, has built a whole economy against the same budget —
in **four distinct mechanism families that must not be merged**,
because they fail differently and route to different repairs.

## The four families

1. **Don't load it until needed — deferred tool loading.** Tools
   register by name only; the full schema is fetched on first use. The
   history, told straight: Claude Code originated the design; qwen-code
   explicitly mirrors it (and inherits its fork-parent's
   infrastructure); codex and kimi-code look like genuinely independent
   arrivals in the same 2026 window. One origin plus two or three
   rediscoveries — not five votes, but a real signal. The cited payoff:
   over 85% token reduction on tool definitions, with accuracy
   degrading once thirty to fifty tools are loaded at once.
2. **Don't let one result flood the window — spill to disk with a
   preview.** Around two thousand lines or fifty kilobytes — thresholds
   that recur across harnesses — a tool result stops arriving whole:
   the full output parks on disk, recoverable by path. External
   measurement supplies the cautionary tale for this mechanism's
   absence: a published incident of a tool response inflating from five
   thousand to a quarter-million tokens, in production.
3. **Shrink each result before it lands — content-aware pruning.** One
   research system runs a small model over raw tool output per call,
   skimming it against a declared focus question. A different lever
   than size-based truncation — content-aware, question-relative — and
   kept distinct because merging it with family 2 hides both its cost
   (an extra model in the loop) and its promise (relevance, not just
   size).
4. **Compact the conversation itself.** Two shapes ship: a structured
   state snapshot framed as the agent's *only* memory going forward,
   and first-person handoff notes. This family is where the
   [[persistence-is-imported| persistence chapter]]'s warning bites
   hardest — compaction that *replaces* history rather than pointing at
   it produced the false-confidence failure documented there.

Beneath all four, the theory adds an architecture note: capture,
triage, and processing are separable stages — triage can read signal
statistics without reading content, which keeps it cheap and honest —
and quick-glance instruments differ from durable stores in their whole
design physics, the same split the persistence chapter draws.

## What it generates

- **For the harness:** provision all four families deliberately — they
  are complements, not alternatives; a harness that optimizes only one
  (ever-more-aggressive compaction, say) inherits the failures the
  others prevent. Keep quick-glance instruments and durable stores
  architecturally distinct.
- **For UDON:** compact-but-legible is a theory-priced property — the
  honest frame for the size-comparison pitch. Spilled and deferred
  artifacts are documents an agent re-enters *cold*, so self-describing
  structure and stable addressing (the
  [[addressing-is-the-long-pole| addressing chapter]]) are what make a
  parked artifact usable rather than merely stored. And a standardized
  focused-subtree-plus-breadcrumb payload (the
  [[progressive-disclosure-read-path| read-path chapter]]) is the
  notation-side complement of family 3: relevance-shaped delivery
  without the extra model.

## What this opens (ideas, not designs)

> [!capability] Declared context budget
> **What:** a caller-declared token budget on every tool call, letting
> each tool pick preview depth, spill threshold, and pruning
> aggression per call instead of shipping one global compromise. (The
> [[headless-io-contract| headless-contract chapter]]'s
> agent-identification idea supplies the channel.)
> **Principles that apply:** the joint budget above; crystallized
> process (the tool absorbs a decision the agent now makes by
> guessing).
> **Hypothesized impact:** raises event rate ν (fewer turns burned on
> re-fetching what a right-sized response would have carried), and makes
> each family's contribution to the context description-length budget
> observable and tunable per workload.
> **In tension with:** tool-contract simplicity (one more field
> everywhere); the familiarity cost of deviating from installed shapes.
> **Potential downsides:** budgets become lies if agents cargo-cult a
> number; per-call variance complicates caching.

> [!capability] Spill with a table of contents
> **What:** family-2 spills park a *structured* artifact — a skeleton
> of addresses with the preview attached to the relevant node — so the
> agent expands precisely instead of re-reading linearly.
> **Principles that apply:** parked output is a document re-entered
> cold; addresses beat offsets; progressive disclosure.
> **Hypothesized impact:** cuts comprehension time on re-entry (the
> turnover-multiplied cost the theory prices), and lowers observation
> noise U_o on the parked channel — the artifact stops being a flood
> and becomes an addressable store.
> **In tension with:** family 2's simplicity (byte-truncation is
> format-agnostic; skeletons need a parse).
> **Potential downsides:** skeleton generation on huge outputs has its
> own cost; only pays where output has structure to skeletonize.

> [!capability] Focus questions as standard tool input
> **What:** the pruning family's declared focus question, promoted to
> an ordinary optional field on any tool — receivers may order,
> filter, or annotate output toward it, small model or no.
> **Principles that apply:** intent as parameter (this is intent's
> read-side twin); observation design over observation volume.
> **Hypothesized impact:** drives observation ambiguity A downward on
> the result channel (goal-relevant content forward, interpretive
> residue reduced) at near-zero mechanism cost — family 3's benefit
> given a no-extra-model floor.
> **In tension with:** the one-shot tool constraint (a bad focus
> question can't be renegotiated mid-call).
> **Potential downsides:** an over-trusted focus filter hides the
> unexpected — exactly what an exploring agent sometimes needs to see.

> [!capability] Compaction that emits both layers
> **What:** a compactor that produces its narrative summary *and* a
> machine-readable pointer map (claim → source span) in one pass — the
> summary for reading, the map for verification, neither pretending to
> be the other.
> **Principles that apply:** summaries must point at ground truth, not
> replace it; provenance as first-class text property.
> **Hypothesized impact:** strengthens the reinjection channel's
> integrity (the persistence condition's additive term) while keeping
> update-gain calibration honest after the boundary — the successor's
> trust in each claim becomes checkable, not vibes.
> **In tension with:** compaction's whole point (the map costs tokens;
> though it can live on disk, spilled like any family-2 artifact).
> **Potential downsides:** a wrong pointer map is worse than none —
> verification theater if unaudited.

## Honest edges

The numeric thresholds are one ecosystem's folklore (shared lineage,
JavaScript-era defaults), not derived constants. Whether
structure-aware pruning beats question-driven small-model pruning is
unmeasured — a natural experiment once structured payloads exist in a
real harness loop. And in-session retrieval machinery genuinely
compensates for much of the budget pressure; the hard law lives at the
session boundary, not inside it.
