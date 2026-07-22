# OPEN — live questions only

**Status:** 2026-07-21 (graduated from `.archived/second-pass/` same day; ML
re-framed per [pipeline-discussion.md](udon-needs/pipeline-discussion.md)). Closed →
[DECISIONS.md](DECISIONS.md).

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

## Explicitly not OPEN

CARRY + 2026-07-21 closes (incl. **L0**, **L1**, **L4**, W0/W1d, …) → DECISIONS.  
Path *language design* → paths spike, not silent SPEC growth.
