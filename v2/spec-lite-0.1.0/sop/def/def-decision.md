---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [decision, status, decided-by, wording, assumption, grounds-recorded, reopen-condition, deciders, consulted, informed]
per: [sop-own-vsect-and-decisions]
depends: [def:record, def:record-kinds]
---

# decision · status · decided-by · wording · assumption · grounds-recorded · reopen-condition · deciders · consulted · informed

*A ⟦decision⟧ records a choice: what was decided, on what reasoning and ⟦assumption⟧s, and what would reopen it. Whether it is in force (⟦status⟧) and who stood behind it (⟦decided-by⟧) are separate fields, and ⟦wording⟧ says whose words its outcome is in.*

## Terms

- **decision** (usually `adr/`): a ⟦record⟧ of a choice, with its reasoning, ⟦assumption⟧s, alternatives, consequences, and ⟦reopen-condition⟧s. Its outcome is never edited in place; changing the choice takes a new decision that ⟦supersedes⟧ it (see [[def:supersession]]).
  - It fails by misattribution, by an interpretation carried as the decider's words, by being overturned silently, or by an assumption that stops holding.
  - It is repaired by correcting the attribution, going back to the decider, or superseding it.
- **status:** the ⟦decision⟧'s lifecycle: `proposed` · `accepted` · `rejected` · `superseded` · `deprecated`.
- **decided-by:** authority, meaning who stood behind the choice and how firmly:
  - `steward`: the steward made the call; an agent or council ratified it.
  - `ratified`: an agent made the call; the steward ratified it.
  - `council`: an agent made the call after red-teaming and unified validation from other agents.
  - `supported`: an agent made the call with provisional steward or council support; it is easier to revisit.
  - `defacto`: "decided" without really being decided; recorded so that the record exists.
  - `proposed`: from the steward or any agent; not blocking anything yet.
  - `transition`: rejected, but still present somewhere; defacto, and being fixed.
- **wording:** `verbatim` if the ⟦decision⟧'s outcome is in the decider's own words, `rendering` if someone else wrote it. A decider's own words go in the decision's Quote section.
- **assumption:** something that must stay true for the ⟦decision⟧ to stay right. Each assumption is marked either *recorded* (stated by a decider at the time) or *inferred, unconfirmed* (an agent's reading, which needs confirming before anything leans on it).
- **grounds-recorded:** `at-decision` if the reasoning and ⟦assumption⟧s were written when the ⟦decision⟧ was made; `reconstructed` if they were recovered afterwards.
- **reopen-condition:** a condition that reopens the ⟦decision⟧, usually an ⟦assumption⟧ breaking. A decision lists its reopen-conditions under *Reopen when*.
- **deciders:** who made the call. Agents are included and marked as agents.
- **consulted:** whose view was asked for before the call, and given.
- **informed:** who needs to know the outcome.

## Invariants

- Each ⟦decision⟧ is one ⟦record⟧ and one file, made from `adr/TEMPLATE.md`. There are two separate sets: lite's spec decisions, kept in `adr/` and belonging to the udon team, and this corpus's process decisions, kept in `sop/adr/` ([[decision:sop-own-vsect-and-decisions]]).
- ⟦status⟧ and ⟦decided-by⟧ are separate fields because they move independently. `accepted` with `supported` is a real and common state: act on it, and revisiting it is cheap.
- Reasoning and ⟦assumption⟧s are never filled in after the fact without being marked `reconstructed`. Where none were recorded, the decision says "None recorded".
- A decision's authority never makes a claim true (see [[def:record-kinds]]).
- A decision's ⟦status⟧ (its lifecycle) is not the record-level ∂(status) column; see ⟦record-status⟧ in [[def:record-fields]].
- When a decision conflicts with something else, go back to the decider ("when you said X, were you also implying Y?"). Do not settle it by weighing one decision against another.

## Discussion
- Sources for these terms:
  - the MADR template Joseph supplied (2026-09-30), for the core structure and ⟦deciders⟧ / ⟦consulted⟧ / ⟦informed⟧;
  - the verisectorium template's `DECISIONS.ud` and the references corpus's decision ledger, for the seven-value ⟦decided-by⟧;
  - `v2/DECISIONS.md`'s K-row provenance note, for the conflict protocol and ⟦wording⟧;
  - RC1 `04-CYCLE`'s decision dimensions (grounding, consultation, accountability, falsifiers), for ⟦grounds-recorded⟧ and ⟦reopen-condition⟧.
- How those RC1 dimensions are carried: consultation by ⟦consulted⟧; accountability by ⟦decided-by⟧; grounding by the prose sections plus ⟦grounds-recorded⟧; falsifiers by *Reopen when*.
