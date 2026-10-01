---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [kind-change-is-dissolution]
depends: [def:record-kinds, def:supersession, conv:references]
---

# A change of kind is dissolution, not mutation

*A ⟦record⟧ never changes its ⟦kind⟧. When content needs a different kind, the old record is retired, and one or more new records are made from it.*

## Statement

- **A record's kind never changes.** If content turns out to belong to a different kind, three things happen:
  - the old record is retired and stays on record as history;
  - one or more new records are made from it, each built up again under its own kind, with its own way to fail, its own authority, and its own ⟦verification-level⟧, which starts fresh;
  - each new record names the old one in `was:`, as provenance. In [[def:supersession]] terms this is `invalidated`, not `revised`.
- **A reference to the old `[[kind:slug]]` resolves to the retired record**, which carries forward pointers. The resolver never follows it on to the new record, because the new record makes a different claim and fails a different way.
- **A rename is different.** Same kind, new slug: the old slug becomes an alias that does resolve to the renamed record.

## How a violation shows

A record whose `kind:` changed in its own history; a new record that inherited a verification-level from a record of another kind; a resolver that follows `was:`.

## Why

- Joseph: "it's rare because it really does require one to essentially retire the old and integrate it reconstructively into new kind(s) -- so much changes (including its authority and verification level etc. etc.) or rather, because the very way 'it can fail' changes, it's really not so much a mutation as a dissolution and emergence of something else. Which allows for was as a historical provinance marker etc." (`sop/influx/jaw-proposal-and-feedback.md` §1.6).

## Working notes

- The rename-versus-kind-change split in resolution was worked out in feedback (§3.11). What decides it: can the old reference be followed without changing what it claims?
