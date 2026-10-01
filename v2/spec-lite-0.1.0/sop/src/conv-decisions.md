---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [sop-own-vsect-and-decisions, sop-decisions-follow-template]
depends: [def:decision, def:supersession]
---

# Decisions are ADRs, with reasoning and assumptions

*One ⟦decision⟧ per file, made from `adr/TEMPLATE.md`. Reasoning and assumptions are required. Supersession replaces in-place editing. When decisions conflict, go back to the decider. There are two separate sets: lite's and the process's.*

## Statement

- **One decision per file**, `adr/<slug>.md` (lite's decisions) or `sop/adr/<slug>.md` (process decisions), made from `adr/TEMPLATE.md`. The filename is the slug, never a number.
- **Two separate sets.**
  - Lite's spec decisions belong to the udon team.
  - This corpus's process decisions belong to the SOP store, and are recorded as soon as they are made.
  - Authority and accountability belong in process decisions even in a corpus where they would be noise for theory claims.
- **Reasoning and assumptions are required.** In the template, the reasoning is the Decision Drivers plus the Outcome's "because"; the assumptions are their own section.
  - Each assumption is marked either *recorded* (stated by a decider at the time) or *inferred, unconfirmed*.
  - Where the source records none, the section says "None recorded". It is never filled in afterwards.
  - `grounds-recorded: reconstructed` marks anything recovered after the fact.
  - An assumption that can break feeds *Reopen when*.
- **Wording.** The decider's own words go in the Quote section. `wording` says whose words the outcome is in (`verbatim` or `rendering`).
- **`status` and `decided-by` are separate fields**, because they move independently.
- **A decision is never edited in place.** Reopening it means a new decision that ⟦supersedes⟧ it, with the supersession typed and scoped (see [[def:supersession]]).
- **When decisions conflict:** don't weigh one decision against the other. Go back to the decider: "when you said X, were you also implying Y?"

## How a violation shows

- An ADR with empty Decision Drivers or Assumptions, instead of one that says "None recorded".
- An outcome edited after acceptance.
- A `supersedes` entry with no matching `superseded-by` entry.
- A process decision filed with lite's decisions, or the other way round.

## Why

- Joseph asked that decisions include reasoning and assumptions, "since those have ended up being critical" (2026-09-30, in the aat-refactored coordinator session; `sop/influx/proposed-verisectorium.md` records the request only as a paraphrase). He supplied the MADR template that `adr/TEMPLATE.md` adapts.
- Separate process decisions: "sop absolutely needs its own adr/dec set -- all process decisions, which yes, should all start getting recorded asap-- distinct from udon-lite spec decisions" (`sop/influx/jaw-proposal-and-feedback.md` §1.9 item 4).
- The conflict protocol comes from `v2/DECISIONS.md`'s provenance note on the K-rows.

## Working notes

- `adr/TEMPLATE.md` sits in the spec store's `adr/`, but both sets use it. If the two sets' needs diverge, the SOP store may want its own copy, made from it.
- The reasoning-and-assumptions quote under Why is from chat, and is not yet in `sop/influx/jaw-proposal-and-feedback.md` §1.
