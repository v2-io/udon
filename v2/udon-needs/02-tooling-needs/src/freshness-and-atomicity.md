---
slug: freshness-and-atomicity
type: principle
evidence: [T2, T3, T1, T4]
status: cross-tier-convergent (read-gate universal in T2; collision lived in T3)
stage: drafted
consumers: both
depends: [edit-representation-landscape]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C6, hashline singleton, kimi ToolAccesses
  - ../../01-ideation/02-provenanced/commentary/spikes/paths-NOTES.md  # D5, D6
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 14 (multi-writer)
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # P-C
---

# Freshness and atomicity: edits bind to the file as it is *now*

**Claim.** Three related invariants recur across every tier that touches
writing, and together they form the transaction discipline of agent
mutation: (1) **read-before-edit** as a hard, code-enforced gate — an edit is
only meaningful against a state the agent has actually observed;
(2) **apply-time re-resolution** — addresses re-resolve against the current
file at write time, never trusted from cache ("paths re-resolve at write
time; never trust cache over file"); (3) **atomic multi-site application** —
a batch either fully applies or fully refuses.

## The evidence

- **Universal in shipping practice (and its sharpest formulation):** read-before-edit is
  enforced in code (typed error, dedicated modules) across 8+ harnesses —
  a hard invariant, not a prompt suggestion. grok-build's hashline makes
  freshness *content-addressed*: anchors are valid only for the file state
  at read time, and **one stale anchor rejects the whole batch** — the
  cleanest shipped statement of freshness+atomicity as one mechanism.
  kimi-code's `ToolAccesses` (per-call declared read/write footprints so the
  scheduler runs only non-conflicting calls concurrently) is the same
  concern lifted to the scheduler.
- **Lived:** Zi-am-tur's sibling-collision account — two agents editing
  the same document, the multi-writer wound — plus practica's soft-claiming
  convention. Multi-agent concurrent edit is a real, present condition, not
  a future scenario.
- **The design corpus:** the agentic-ux principles state (2) verbatim; the
  addressing exploration hardens it into a rule (#addressing-is-the-long-pole,
  table row D6): *path evaluation for a patch is against the pre-patch
  tree* — compare-and-swap composition, so a batch of edits has one
  consistent addressing frame.
- **The theory:** refusal atomicity as unconfounded law signal
  (#errors-that-teach); and the fork/divergence analysis
  (checkpoint-forking failure modes) gives the deep version of why two
  writers over one artifact need explicit reconciliation, not hope.

## What it generates

- **For UDON's edit substrate:** the transaction shape in
  #schema-guarded-mutation inherits all three invariants; failure vocabulary
  must distinguish *stale* (file changed since read) from *not-found* from
  *not-unique* (#addressing-is-the-long-pole's failure vocabulary), because
  the repairs differ — re-read vs re-derive vs disambiguate. Semantic merge
  (the one early design idea never absorbed into the
  tool suite: structure-aware merge with annotation accumulation) is the
  known missing piece above single-writer transactions — carried as an open
  demand, not designed here.
- **For the harness:** enforce the read gate in code, not prose; consider
  declared-footprint concurrency (the ToolAccesses shape) once multi-agent
  sessions are normal; and surface staleness as its own teaching refusal
  ("the file may have changed since you read it" — the stale-model
  hypothesis named to the agent).

## Honest edges

Atomic *multi-file* transactions remain the corpus-wide gap (only hashline's
single-batch semantics comes close). Nothing in the evidence yet prices
optimistic-vs-pessimistic concurrency for agent workloads — soft-claiming
(a working convention) and footprint-scheduling (one shipped scheduler)
are single points, not a convergence.
