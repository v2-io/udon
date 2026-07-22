---
slug: round-trip-and-span-splice
type: demand
evidence: [T1, T2]
status: estate-convergent; product family open
stage: planned
consumers: udon-primary
depends: [schema-guarded-mutation, freshness-and-atomicity]
sources:
  - ../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §4
  - ../01-ideation/pipeline-discussion.md  # ornamental criterion turns
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # obsidian-linter; yq
  - ../01-ideation/needs-map.md  # S6
---

# PLANNED — Round-trip and span-splice: edit substrate ≠ whole-file fmt

**Claim to develop:** agents need byte identity for untouched spans + model
identity for the change (subtree serialization with correct local geometry);
whole-file house-style fmt is a different product on the same family
(ornamental double-fixpoint criterion); N-way round-trips
(json/toml/yaml/md/rust-native) make "products" an open family, each with a
loss policy. Identity layers (byte / recognition / core-semantic / host)
from the greenfield SEMANTICS work are the vocabulary.

**Synthesis pass:** agent-utility §4 + ornamental turns + linter's
non-commutative-rules caution; specify the lens laws (GetPut/PutGet)
conditional on addressing.
