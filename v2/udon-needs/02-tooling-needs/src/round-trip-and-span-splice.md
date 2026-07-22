---
slug: round-trip-and-span-splice
type: demand
evidence: [T1, T2]
status: estate-convergent demand; product family deliberately open
stage: drafted
consumers: udon-primary (harness: edit-tool substrate requirements)
depends: [schema-guarded-mutation, freshness-and-atomicity]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §4 read whole
  - ../../pipeline-discussion.md  # ornamental criterion turns (~L98–130, 500s)
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # obsidian-linter, yq singletons
  - ../../01-ideation/needs-map.md  # S6
---

# Round-trip and span-splice: the edit substrate is not the formatter

**Claim.** Agents editing documents need **byte identity for untouched
spans** and **model identity for the changed span** — serialize a subtree
with correct geometry relative to its insertion site, splice it in, leave
every other byte alone. Whole-file house-style formatting is a *different
product* that shares machinery but must never be the write path's default.
Conflating the two produces bad edit tools; the corpus states this from
three directions.

## The evidence

- **T1 (the spike, §4 — why agents care, and it isn't aesthetics):** edit
  tools need span-splicing because minimal-changeset economics (the TST
  proximity results) and diff/patch-against-disk both require untouched
  regions to stay byte-identical. The demand list: serialize a subtree
  with correct indent for its destination; escape correctly without the
  agent thinking about it; re-apply idempotently under stable paths (the
  lens laws — GetPut/PutGet — conditional on addressing). "Agents mostly
  want model-level certainty + local spatial correctness, not global
  pretty. Humans want fmt. Both are real; conflating them produces bad
  edit tools."
- **T1 (the ornamental criterion — the testable line between the two
  products):** Joseph's double-fixpoint test from the pipeline discussion:
  strip discretionary geometry → model → emit house style; do it again;
  model and bytes must be stable. **Ornamental** = geometry that changes
  look without changing the assembled meaning (extra blanks, alignment
  padding, indent width beyond minimum); **comments are not ornamental**
  (they are nodes). This gives "what may fmt touch?" a criterion instead
  of a taste war — and gives the edit tool its converse rule: the agent
  write path preserves non-touched bytes and never runs house-style
  unless asked (spike proposal P-D: ornamental is out of the agent happy
  path).
- **T2 (prior art at the two edges):** yq demonstrates the query side of
  structural round-trip — `match()` returning `{string, offset, length,
  captures}` plus line/column operators: position as first-class queryable
  data, exactly the span substrate splicing needs. And obsidian-linter is
  the honest warning at the fmt edge: its own README admits rule
  combinations interfere and lint rules are "not cleanly composable" —
  many independently-toggleable style rules are a non-commutative system,
  which is an argument for a single coherent house-style profile over a
  rule bazaar.
- **The identity-layer vocabulary** (from the greenfield SEMANTICS work,
  now corpus): byte identity / recognition identity / core-semantic
  identity / host-projection equality. The edit substrate operates at byte
  identity for context and core-semantic identity for the change; fmt
  operates between recognition and core-semantic identity; **N-way
  round-trips** (json / toml / yaml / markdown / rust-native — S6) each
  pick a layer and a loss policy, which is why "products" is an open
  family, not four fixed nouns (the DAG-not-line lesson).

## What it generates

- **For UDON:** the serializer/spans substrate sits on the critical path
  *before* edit v0 (the T1 build order); W1d (self-delimiting value
  extents) and the text law (pure-concat reconstruction) are the wire-side
  prerequisites already ruled. The open design work — sugar-aware
  round-trip (writing `$traits` back as `.trait`), where emit-style
  profiles live — belongs to the round-trip product family and should be
  shaped by the fixpoint criterion, not by per-case taste.
- **For the harness:** any document-state tool it ships inherits the same
  split: mutation preserves bytes, normalization is a separate explicit
  act. (Git-diff legibility of agent edits — a human-verification surface,
  #steering-and-verification-surfaces — depends on exactly this.)

## Honest edges

The lens-law framing is stated, not proven, for UDON's model (idempotent
re-apply under stable paths is a *target*, unverified against the real
AST); nothing here has running code yet. The ornamental criterion is
ratified as a criterion but its full boundary (what counts as
discretionary geometry in every construct) is unenumerated — that
enumeration is fmt-product work, and doing it prematurely was the archived
night-spine's exact mistake.
