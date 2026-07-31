# v2/ — the UDON v2 effort (demand-first)

**Live bodies of work** (updated 2026-07-31):

| Here | Role |
|------|------|
| [`current-0.9.1-spec/`](current-0.9.1-spec/) | **The language baseline.** Ruled law consolidated into one clean suite — the base of operations agents work *from*. Not the 0.10 successor (see **C7** in the ledger). |
| [`udon-needs/`](udon-needs/) | **The demand-side work.** Gathering (phase 1, complete) → synthesis (phase 2, the tooling report) → priorities → decisions → parsers/utilities → … → Parsing Framework. |
| [`theory/`](theory/) | **Claim layer (early).** Process norms + demand ranking only; **no theory foundation yet** (sterilized P* frame deleted). Start at [`theory/README.md`](theory/README.md). |
| [`DECISIONS.md`](DECISIONS.md) | Thin present-truth ledger — ruled language law and steward marks; append-only. |
| [`OPEN.md`](OPEN.md) | Live questions only. |
| [`.archived/`](.archived/) | First-pass greenfield clean-rooms + second-pass night spine; INDEX maps value vs. mistake and graduation order. |

## How they relate

The 0.9.1 suite says **what the language is right now**, including — deliberately — [what it leaves unspecified and why](current-0.9.1-spec/CARVEOUTS.md). The demand-side work says **what agents actually need**. The theory corpus integrates consequences of both into **one claim per file**, under collision and bare-gap discipline, so design probes can cite a slug rather than re-open a spike. Neither demand nor theory is the 0.10 design; that comes when demand work reaches its decision stages. A spike or design probe should read the suite's carve-out register first — each open item carries the demand-side reason it is open and what would close it.

## Origin of the demand-first turn

This directory was reduced to a seed on 2026-07-21: a night of autonomous spine-building (spec/wire/process skeletons) ran ahead of demand-side understanding and was archived wholesale. The lesson, now the operating rule: **end-user needs generate the architecture; the architecture is never drawn first and back-filled.** The deliberation record is [`udon-needs/pipeline-discussion.md`](udon-needs/pipeline-discussion.md); the history and cherry-pick map is [`.archived/INDEX.md`](.archived/INDEX.md).

## Working here

**Arriving for theory / claim work?** → [`theory/README.md`](theory/README.md). Short path: `FORMAT.md` → `UDON-THEORY-canon.outline.udon` → `src/` in outline order. The old spikes orientation is archived at [`theory/to-integrate/archived/spikes-README.2026-07-28.md`](theory/to-integrate/archived/spikes-README.2026-07-28.md) (substance still useful; paths and gap conventions are not current). `OUTLINE-possibilities.outline.udon` is possibility texture only — not an ordering to build against.

**Arriving for demand work?** Agents under `udon-needs/` are covered by [`udon-needs/CLAUDE.md`](udon-needs/CLAUDE.md) (ratified 2026-07-22, any substrate) — research diversion, de-novo testimony as evidence, the ideation mandate, and the four writing bars. Read it before starting.

Elsewhere in the repo: `../spec/CORE.md` + `../spec/msc/CHANGELOG.md` remain the 0.9.0-alpha.2 record and rulings ledger (no work continues there); `../core/` is the differential parser oracle (0.8-lineage — not the 0.9.1 conformance instrument); `../defining-udon.md` is the documentation philosophy any spec suite is held to.
