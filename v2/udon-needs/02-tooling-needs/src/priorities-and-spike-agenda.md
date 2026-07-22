---
slug: priorities-and-spike-agenda
type: synthesis
evidence: [all]
status: synthesis over drafted segments; provisional until planned segments land
stage: drafted
consumers: both
depends: [schema-guarded-mutation, addressing-is-the-long-pole, streaming-and-partial-documents, persistence-is-imported, context-economy]
---

# Priorities, and what the design probes ahead should answer

**Scope note:** first drafted against the spine (2026-07-22 AM), revised
same day after the full back half landed — the ranking below survived the
back-half segments unchanged (they thickened its legs: crystallized-process
under #5, typing/evolution under the schema probe, continuity under #4).
Priorities here are
*demand-strength* rankings (how many independent kinds of evidence ask,
how broadly, and at what measured cost of absence),
not implementation sequencing — that adjudication belongs downstream
(that adjudication belongs to the decision work this report feeds, not to the report).

## The demand ranking (strongest first)

1. **Schema-guarded structural mutation** — 4-tier convergence (plus the
   lived ease-gradient account), measured
   cost of absence (16% unaided recovery), explicit design-of-record demand,
   and the gap no shipping tool fills. Pulls: paths, schema, spans,
   round-trip — which is exactly why it is the organizing customer for the
   design agenda, not one feature among many.
2. **Stable addressing with loud, typed failure** — the long pole;
   everything above and below consumes it.
3. **Partial-document honesty as a public surface** — verdicts, mid-stream
   state, prefix-parseability; the ecosystem pays a standing reassembly tax
   for formats without it.
4. **Reinjection-channel formats** — durable agent state with cold-start
   reconstructibility; the only persistence mechanism there is, with the
   compaction wound as its lived cost.
5. **Teaching refusals + description-as-teaching** as the pervasive error
   contract (cheap everywhere once adopted; the 4-tier lock).
6. **Context-economy compatibility** — compact, self-describing,
   addressable payloads that survive spill/defer/prune machinery.
7. **The headless contract** for every CLI either program ships (floor, not
   differentiator).

## What each design probe inherits (questions, not answers)

**The paths probe** — inherits #addressing-is-the-long-pole whole (its
question floor and demand table, with the full exploration notes in
[the addressing exploration](../reports/addressing-exploration.md)). The three questions the evidence makes decisive: the smallest
in-document reference subset that is a *true* subset of the tool language;
the terminator table (embeddability in every value context — the forced
probe); relational-first vs tree-first as primary mental model
(stress-test the one-day sample against prose-heavy and append-only docs).
Ruled constraints in: PATH-1 (cross-document in scope), S14 (no incremental
tuple growth). Failure vocabulary (NotFound/NotUnique/Plural/Stale) is part
of the deliverable, not polish. One question added by cross-substrate
review (agy): are paths strictly *necessary* for guarded mutation, or one
targeting mechanism among several (exact-match or line-range targeting plus
a post-edit schema check would deliver a weaker-but-sooner guard)? The
probe should answer it rather than assume the dependency.

**The dialects probe** — the least-fed area relative to its leverage (the
morning correction's "real scandal"). The demand-side entry points now on
record: the in-vivo `<…>`→descent-timespec probe (running code forcing
define/compile/declare/invoke/error-surface — both panels' preferred first
move); the template product shape (precompile → interrogate scope → build)
with scope-context-as-UDON pulling directives toward paths; the
`!{{…}}`/`<…>` unification pressure (log, don't unify early); badly-typed
values on an unbounded stream (what does the no-dialect/failed-dialect
event look like to a consumer that can't accumulate?); mid-stream
reconfiguration; and whether array/string captures are sugar for
dialect-typed captures — the reframe that may dissolve ML entirely.

**The schema probe** — runs *against* #schema-guarded-mutation's transaction
shape: static vs composable/nested; what conformance means on a partial
document (compose with verdicts); the guard's failure vocabulary as schema
output; versioning/migration demand (the rowan/autopax/operata family —
planned segment); and the soft/hard profile dial as schema *strictness*
rather than schema *shape*. External anchor: schema-serialization mismatch
as the dominant real-world tool-fault class.

**The value-typing probe** — the frozen-bare-set + envelope boundary is ruled;
what demand still has to shape: unlabelled-dispatch ordering under multiple
dialects, nested-envelope routing (S12), and the recognition-time vs
resolution-time typing split for stream consumers (S2's question). Runs
jointly with the dialects probe or immediately after it.

## Sequencing dissents worth carrying (cross-substrate, 2026-07-22)

Two product-strategy positions from the external reviews, carried visibly
rather than adjudicated here: (a) **near-term ROI first** -- teaching
refusals, partial-document honesty, and a distinct staleness failure class
are shippable improvements *before* the paths+schema program lands; the
demand ranking above is a strength ordering, not a build order that defers
all value behind the long pole. (b) **The human-verification surface is
load-bearing, not garnish** -- fail-plausible (#counter-register row 5) is
the failure class nothing mechanical catches, so Part VII's thinness in the
gathered corpus is a risk to fund against, not evidence of low importance.

## The cross-cutting probe discipline (learned the hard way)

Spikes run against *scenarios from this report's segments* (S1–S12 +
the affordance tables), not free essay prompts; their outputs are demands
on the product graph, never pins (the night-spine lesson, now twice paid
for). And each probe should name what would *falsify* its favorite shape —
the counter-register pattern applied forward.
