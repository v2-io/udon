---
slug: priorities-and-spike-agenda
type: synthesis
evidence: [all]
status: synthesis over drafted segments; provisional until planned segments land
stage: drafted
consumers: both
depends: [schema-guarded-mutation, addressing-is-the-long-pole, streaming-and-partial-documents, persistence-is-imported, context-economy]
---

# Priorities, and what the informed spikes should probe

**Standing caveat:** this synthesis is drawn from the *drafted* spine; the
planned segments (dialects/templates, typing/schema-boundary, machine-first
documents, continuity, human-side) will thicken it and may reorder the
tail. It exists now because phase-3 spikes were the stated need and the
drafted evidence already constrains them hard. Priorities here are
*demand-strength* rankings (breadth × tier-span × measured cost of absence),
not implementation sequencing — that adjudication belongs downstream
(phase 3/4 per the flow's own rule).

## The demand ranking (strongest first)

1. **Schema-guarded structural mutation** — 5-tier convergence, measured
   cost of absence (16% unaided recovery), explicit design-of-record demand,
   and the gap no shipping tool fills. Pulls: paths, schema, spans,
   round-trip — which is exactly why it is the organizing customer for the
   spike agenda, not one feature among many.
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

## What each phase-3 spike inherits (questions, not answers)

**Paths spike** — inherits #addressing-is-the-long-pole + paths-NOTES §10
whole. The three questions the evidence makes decisive: the smallest
in-document reference subset that is a *true* subset of the tool language;
the terminator table (embeddability in every value context — the forced
probe); relational-first vs tree-first as primary mental model
(stress-test the one-day sample against prose-heavy and append-only docs).
Ruled constraints in: PATH-1 (cross-document in scope), S14 (no incremental
tuple growth). Failure vocabulary (NotFound/NotUnique/Plural/Stale) is part
of the deliverable, not polish.

**Dialects spike** — the least-fed area relative to its leverage (the
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

**Schema spike** — runs *against* #schema-guarded-mutation's transaction
shape: static vs composable/nested; what conformance means on a partial
document (compose with verdicts); the guard's failure vocabulary as schema
output; versioning/migration demand (the rowan/autopax/operata family —
planned segment); and the soft/hard profile dial as schema *strictness*
rather than schema *shape*. External anchor: schema-serialization mismatch
as the dominant real-world tool-fault class.

**Value-typing spike** — the frozen-bare-set + envelope boundary is ruled;
what demand still has to shape: unlabelled-dispatch ordering under multiple
dialects, nested-envelope routing (S12), and the recognition-time vs
resolution-time typing split for stream consumers (S2's question). Runs
jointly with the dialects spike or immediately after its probe.

## The cross-cutting spike discipline (from this corpus's own history)

Spikes run against *scenarios from this report's segments* (S1–S12 +
the affordance tables), not free essay prompts; their outputs are demands
on the product graph, never pins (the night-spine lesson, now twice paid
for). And each spike should name what would *falsify* its favorite shape —
the counter-register pattern applied forward.
