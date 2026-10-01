---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [flags-on-docless-rows, decider-per-store, flags-describe-own-record]
depends: [def:record-fields, conv:column-notation]
---

# The three flags

*⟦awaiting-second⟧, ⟦awaiting-decision⟧ and ⟦needs-work⟧ live in frontmatter as true or false. Each says who or what moves next on this record, and only this record.*

## Statement

- **Every ⟦record⟧ carries the three flags** in its frontmatter:
  - `awaiting-second: true` while it waits for another entity's thorough once-over;
  - `awaiting-decision: true` while it waits for its store's declared decider to review and decide ([[decision:decider-per-store]]): Joseph (steward) for the SOP store, and the udon team's decider for the spec store.;
  - `needs-work: true` while it waits on known work. When it is true, the details, or a pointer to the audit, spike, or finding, are in the record's ⟦working-notes⟧.
- **The act that resolves a flag clears it.**
  - The second reader clears `awaiting-second`.
  - The decision clears `awaiting-decision`, and the record cites the decision in ⟦per⟧.
  - The work clears `needs-work`, and its working note is removed or rewritten.
- **A flag describes only its own record** ([[decision:flags-describe-own-record]]). `awaiting-decision: true` means the decider is being asked to decide something about this record. Whether a record rests on a decision that is deferred, unratified or superseded is derived from its ⟦per⟧ citations, and a view may show it as a ∂ column; it is never copied into the record's flags. A deliberately deferred decision carries `awaiting-decision: false`, because nobody is being asked to decide it now.
- **Outlines may show a flag as a ※ column.** On rows with no document it shows `—`, and any pending decision about such a row lives in its ADR or question (see [[conv:column-notation]]).

## How a violation shows

- A record missing a flag.
- `needs-work: true` with no working note behind it.
- `awaiting-decision: true` set only because of something the record cites, rather than something about the record itself.

## Why

- Joseph's proposal defined the three flags, "recorded canonically in the yaml frontmatter" (`sop/influx/jaw-proposal-and-feedback.md` §1.1).
- The rule for rows with no document answers §1.7 item 1.

## Working notes

- **Optional sharpening** (§3.8, not adopted). `awaiting-second` could name the kind of look it needs (format check, re-derivation, reader test), and `needs-work` could carry its pointer inline. Either would let the linter catch a flag that has outlived its reason. Plain booleans come first.
