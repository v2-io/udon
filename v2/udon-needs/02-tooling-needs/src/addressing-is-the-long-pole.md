---
slug: addressing-is-the-long-pole
type: demand
evidence: [T1, T2, T3]
status: cross-tier-convergent (demand); all syntax questions deliberately open
stage: drafted
consumers: both (udon-primary; feeds the phase-3 paths spike directly)
depends: [schema-guarded-mutation, freshness-and-atomicity]
sources:
  - ../01-ideation/02-provenanced/commentary/spikes/paths-NOTES.md  # whole; D1–D9; §10 questions
  - ../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §3
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # yq singleton
  - ../01-ideation/02-provenanced/copies/I2-scenarios/  # scenario journeys (spelling provisional)
  - v2/DECISIONS.md PATH-1; v2/OPEN.md S3, S14
---

# Addressing is the long pole

**Claim.** Almost every agentic affordance in this report bottoms out on
**stable structural addressing**: the edit tool (target of the mutation),
error-as-menu (refusals speak in paths), skeletons (copy-pasteable path
lines), query (`at`/`all`), references, semantic merge, impact analysis,
even template directives (scope-context-as-UDON pulls dynamics toward path
expressions — a second, independent pull the pipeline discussion surfaced).
Paths were twice independently named the long pole. This segment carries the
*demand shape* the evidence pins; it deliberately designs no syntax — that
is the phase-3 spike's job, now with an informed floor.

## What the evidence pins

1. **Relational-first is the observed mental model.** The scenarios corpus's
   one-day sample: almost every real query starts with any-depth lookup
   (`||element[key]` as type-scoped primary-key access); root-to-leaf
   navigation is secondary. Evidence, not a decree — but it inverts the
   XPath-shaped default and should be stress-tested, not assumed away.
2. **`at` vs `all` as distinct verbs** — exactly-one-or-error vs explicitly
   plural (paths D9, "high as convention"); with **loud failure** on miss:
   silent JSONPath-style empty sets teach the wrong habit (dead-end #7).
3. **Failure vocabulary is part of the language:** PathNotFound /
   PathNotUnique / ReferencePlural (and stale — #freshness-and-atomicity)
   are *different bugs with different repairs*; match multiplicity vs
   stacked-value multiplicity vs reference multiplicity must not merge
   (the anti-collapse discipline applied to addressing).
4. **Embeddability is the binding constraint.** A path language that cannot
   live inside documents (clean terminators at value boundaries, arrays,
   brace forms) forks addressing into two dialects — the named dead end.
   The spike's terminator stress-table is started but unfinished; the
   subset question (in-doc references as a true subset of the tool
   language) is the load-bearing open.
5. **Position-as-data prior art:** yq's `match()` → `{string, offset,
   length, captures}` plus line/column operators — a query language
   treating source position as first-class queryable data; directly
   relevant to spans and the edit substrate.
6. **Ruled and standing:** cross-document addressing is **in scope** for
   path design (PATH-1 — do not foreclose multi-document); the selector
   tuple does not grow incrementally (S14: keep `(name, key, traits)` until
   a path language replaces it whole); multiple-keys interaction is open
   (S3).

## Open questions the spike inherits (the informed floor)

The paths spike's §10 list stands as the best current question set — chief
among them: smallest in-doc reference subset that is still a true subset;
where multi-segment paths terminate in every value context (needs the
forced table or a small grammar probe); whether positional addressing is
ever syntax or stays host-side indexing over `all()`; prose/comment
addressing (today: none — so no `set` on a paragraph; API-positional in v1
per D8); flags/attr-value predicates as filters.

**Who reads this and when:** the phase-3 paths spike takes this segment +
paths-NOTES as its brief-context; the harness reads §failure-vocabulary and
error-as-menu as requirements on any tool that reports locations to agents
(regardless of notation).

## Honest edges

Everything here except PATH-1/S14 (ruled) rests on a one-day scenario
sample plus design-corpus convergence that shares an author. The spike
exists precisely because this is a demand map, not a validated design;
frequency data (e.g. how often attr-value predicates are wanted) is not yet
real measurement.
