---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: true
per: [per-kind-verification-and-status, no-max-for-lite, notes-disposition-at-freeze]
depends: [def:record-fields, def:record-kinds, conv:record-flags]
---

# Verification-level and status, per kind

*Each ⟦kind⟧ declares its own verification ladder. A record's ⟦verification-level⟧ is written only by the act that verifies it, with evidence. ∂(status) is computed per kind from that level and the flags. No one types a standing word.*

## Statement

- **Each kind declares its verification ladder** in `.vsect/kinds.yaml` (`verification:`).
  - In this corpus the ladders are mostly about authorization: an accepted decision behind the record. Evidence, such as fixtures or a parser agreeing, comes second.
  - A kind with no ladder (decision) shows `—`, because its `status` and ⟦decided-by⟧ carry this.
- **⟦verification-level⟧ is written only by the act that verifies**, never by hand afterwards. The same act writes ⟦evidence⟧ into frontmatter beside the level: a pointer to what was checked and how ([[decision:notes-disposition-at-freeze]]). It is not a working note, because it must outlive freeze. Proposed, not yet decided: the pointer carries the git hash of the text that was checked.
  - With the hash, an edit to that text after the check makes the level stale, and the linter can show it as stale.
  - That gives reset-on-edit behavior without anyone remembering to reset anything.
- **∂(status) is computed per kind** from the record's verification-level and its three flags, and is shown as the ∂(status) column. It is the headline a reader should take right now, with any open finding shown first.
- **No hand-set standing anywhere.** `max` is not used in udon-lite.

## How a violation shows

- A verification-level with no `evidence` beside it, or with its evidence only in working notes.
- A level whose recorded hash is older than the record's last edit (stale), once the hash is adopted.
- A typed status word.
- A `max:` field.

## Discussion
- Joseph: verification-level "depends on the kind-- depends on how sure it is to not 'fail' per kind" (§1.1). Later: "assuming verification level is kind-specified (since, for example, it's mostly about authorized decision in our case)" (§1.7 item 8).
- On status: "seems like a calculated field that has a different measure depending on the kind (and possibly other flags/fields)" (§1.7 item 2).
- On max: "Let's drop max altogether for udon-lite for now unless there's something important that it's giving us" (§1.9 item 10).
- (Quotes from `sop/influx/jaw-proposal-and-feedback.md`.)
- Recording the hash of the text that was checked was the coordinator's addition in feedback (§3.9). [[decision:per-kind-verification-and-status]] records it as a proposal, not yet decided.

## Working notes

- `needs-work: true`: the ladders in the kinds files are placeholders, taken from the feedback round's examples (§3.9, §3.13), and need confirming kind by kind, in both `sop/.vsect/kinds.yaml` and the spec store's `.vsect/kinds.yaml`.
- **Recorded at Joseph's request (§1.8 item 8):** this is the core of verisectorium's epistemology.
  - What this corpus surfaced: verification-level is not one ladder but a ladder each kind declares. In a spec it is mostly authorization; in a theory like AAT it is derivation and evidence.
  - RC1 doesn't yet say how a kind's single level relates to its several dimensions, or how a corpus of mostly *decided* records differs from one of mostly *derived* records.
  - That note is in `sop/influx/jaw-proposal-and-feedback.md` §3.14. It should go back to RC1 03 and 10 through verisectorium's influx.
