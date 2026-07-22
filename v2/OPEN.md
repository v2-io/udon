# OPEN — live questions only

**Status:** 2026-07-22. Closed → [DECISIONS.md](DECISIONS.md). Language
carve-outs with their demand-side reasons now also live in
[`current-0.9.1-spec/CARVEOUTS.md`](current-0.9.1-spec/CARVEOUTS.md) — that
register is the fuller statement for anything spec-shaped; rows here are the
ledger-level index.

---

## Still open

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **ML** | Multi-line / line-bound policy — **possibly a dissolved question**: if `[…]`/strings/etc. are sugar for dialect-typed captures, each capture's grammar owns its own line-span, and there is no per-construct table to close. Do **not** close in the greenfield per-construct framing. | **WAIT-DEMAND** (reframed) | Array-as-sugar insight + framing critique: pipeline-discussion (Joseph, 2026-07-21 morning). Old strawmen: [.archived/second-pass/OPEN-ML-STRAWMEN.md](.archived/second-pass/OPEN-ML-STRAWMEN.md) — archaeology of the old framing, not a decision table to finish. |
| **S3** | Multiple keys surface + uniqueness + @ resolution | WAIT-DEMAND | Paths spike §6; Joseph lean valid. |
| **S4** | `InconsistentIndentation` prose-only? | STEWARD / fact | Grammar intent. |
| **S12** | Nested envelope routing | WAIT-DEMAND | With dialects. |
| **W1e** | Exact Attr value **event encoding** | WAIT-DEMAND | Direction **W1d** closed. Agent-utility + paths may pull. |
| **IND** | **No-sibling indentation default** — when a tool computes insertion indentation and the destination has no siblings to read from, no ratified rule names the default unit. Needs a spec sentence. | agent-suggested (open) | Demand evidence: `udon-needs/01-ideation/02-provenanced/copies/I2-scenarios/03-modifying.scenarios.udon` ("nothing ratified names the default unit"); STEWARD-CALLS #5, Joseph 7/21: add unless redundant — verified not redundant (CORE's 2-space note is non-normative style only). |

---

## Demand harvest (not pins)

Provisional proposals from spikes — **re-open in spikes**, promote to DECISIONS only when ready:

| Source | Pointers |
|--------|----------|
| [.archived/second-pass/spikes/paths/NOTES.md](.archived/second-pass/spikes/paths/NOTES.md) §8 | D1–… boundary demands (relational lookup, terminators, wire W3 pressure) — parked pending the needs map |
| [.archived/second-pass/spikes/agent-utility/NOTES.md](.archived/second-pass/spikes/agent-utility/NOTES.md) §8 | P-A…P-H (stage products, partial-doc verdict, edit tool, ornamental out of happy path) — parked pending the needs map |

### Already absorbed (do not re-open as OPEN rows)

| Demand | Absorbed as |
|--------|-------------|
| agent-utility **P-B** (partial-doc verdict) | **C6** / **R2** / **D-pack** |
| agent-utility **P-A** (stage products) | **W0** direction (sufficiency at product boundaries); the archived PIPELINE stage picture is *not* carried forward — see pipeline-discussion |
| agent-utility **P-D** (ornamental out of happy path) | PIPELINE ornamental criterion + SEMANTICS (direction) |
| paths **D1** / **D7** (interim raw `@`) | **W3** |
| paths **D9** (`at`/`all` convention) | Host/tool — not Core OPEN |

Still provisional (no pin): paths D2–D6, D8; agent-utility P-C, P-E–P-H; **P-G**/**ML** wait on demand scenarios.

---

## Open from the 2026-07-22 session

| ID | Question | Class | Notes |
|----|----------|-------|--------|
| **N-jargon** | Are `Structure Position` / `Line Scan` parser-jargon bleeding into the user-facing spec, against `defining-udon.md`'s isolation principle? A cross-substrate reviewer (agy/Gemini) argued yes and proposed author-centric names. The names are ledger-ruled (**N-pos**, **N-scan**), so overturning is a steward call. | STEWARD | `current-0.9.1-spec/.reviews/STEWARD-FLAGS.md`; review-agy finding 1 |
| **IND-2** | Should the spec name a default indentation unit for *automated generation* (not human authoring)? New demand evidence: without one, different tools pick different defaults and thrash a file's indentation across agents. Sharpens the existing **IND** row rather than replacing it. | STEWARD | review-agy finding 3; attached to IND |
| **FIX-FRAME** | The 0.9.1 suite added a suite-level MUST NOT on fixtures that pin the interim multi-line behavior as *language* behavior (only "PINS CURRENT PARSER" framing allowed). It edges normative and is flagged for ratification-or-revert. | STEWARD | `current-0.9.1-spec/DELTAS.md` organizational paragraph; review-grok L2 |
| **SEG-SPLIT** | When do the tooling report's chapters split into constituent claim segments (ASF style)? Joseph expects to feel compelled "within the next few days"; the readiness signal is a deepening cycle ending with *"the structure held"* as a finding. | steward-timed | `udon-needs/02-tooling-needs/notes/for-OUTLINE.md` §"The coming segmentation" |

---

## Explicitly not OPEN

CARRY + 2026-07-21 closes (incl. **L0**, **L1**, **L4**, W0/W1d, …) → DECISIONS.  
Path *language design* → paths spike, not silent SPEC growth.
