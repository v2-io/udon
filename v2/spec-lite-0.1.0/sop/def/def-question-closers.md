---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [closer, steward-purpose, steward-fact, awaiting, agent-open]
per: []
depends: [def:record-kinds, def:decision]
---

# closer · steward-purpose · steward-fact · awaiting · agent-open

*Every open ⟦question⟧ names its ⟦closer⟧: who may close it, and why. Only Joseph closes a ⟦steward-purpose⟧ or ⟦steward-fact⟧ question, an ⟦awaiting⟧ question waits on something named, and any agent with the context may close an ⟦agent-open⟧ one.*

## Terms

- **closer:** who may close a ⟦question⟧, together with the reason. Naming it keeps a question from being routed to Joseph merely by habit, and from being settled by an agent when only Joseph can settle it.
- **steward-purpose:** only Joseph can close it, because only what lite is *for* decides between the alternatives. No argument or measurement settles it.
- **steward-fact:** only Joseph can close it, because only he knows the answer (for example, what he meant, or what he recalls).
- **awaiting:** anyone can close it once a named question or piece of work closes first.
- **agent-open:** any agent with the context can close it from the ⟦objective⟧s, ⟦principle⟧s, and evidence. This is the default; Joseph may override it.

## Invariants

- A question routed to Joseph carries its reason (⟦steward-purpose⟧ or ⟦steward-fact⟧). Without a stated reason, the default is ⟦agent-open⟧.
- Joseph's arguments and measurements count as evidence like anyone's. Only his purpose and his own knowledge are reserved to him.
- A closed question stays on record, with its answer or its reopen condition, so it is not asked again.

## Working notes

- Sources:
  - verisectorium RC1 `07-DISPOSITION-AND-GAP-ECONOMICS` supplies steward-fact, awaiting-ground, and agent-open;
  - steward-purpose was added in the aat-refactored fresh-view review (2026-09-29) for questions only a purpose can decide;
  - this file shortens awaiting-ground to "awaiting".
- The spec outline's working notes carry the SOP side's closer proposals for the pre-design questions, as input. Routing them belongs to the udon team (`sop/influx/jaw-proposal-and-feedback.md` §1.10); Joseph expects them to want an open-question kind, and intends to vote for a `wut/` directory.
