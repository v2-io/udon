---
kind: definition
awaiting-second: true
awaiting-decision: false
needs-work: false
terms: [record, slug, identity, view, main-outline, standing, working-notes]
per: [one-record-per-file, kind-in-frontmatter, kind-slug-references, main-outline-name, working-notes-and-frozen, notes-drained-not-history]
depends: [def:record-kinds]
---

# record · slug · identity · view · main-outline · standing · working-notes

*A ⟦record⟧ is one unit of a corpus that can fail on its own, identified by its ⟦kind⟧ and ⟦slug⟧. Records are read through ⟦view⟧s, of which a store's ⟦main-outline⟧ is the primary one, and what a reader may conclude about a record right now is its ⟦standing⟧.*

## Terms

- **record:** one unit of a corpus that can be wrong, go stale, or be reopened independently of the others: one ⟦rule⟧, one ⟦decision⟧, one term-group, one ⟦directive⟧. One record per file, with one frontmatter. If two parts of a file can fail independently, they are two records.
- **slug:** the name part of a ⟦record⟧'s ⟦identity⟧, written after the ⟦kind⟧ in a reference: `[[rule:implied-root]]`. A slug is a binding in the sense of the addressing theory ([[references/def:binding]]). Keeping it unique within its kind is upkeep, and its two failures, a `dangle` and a `collide`, must be surfaced rather than assumed away.
- **identity:** the pair (⟦kind⟧, ⟦slug⟧). Neither a ⟦record⟧'s position, its directory, nor any number is part of it. A slug need only be unique within its kind, so `[[rule:implied-root]]` and `[[fixture:implied-root]]` are different records.
- **view:** a selection and ordering of ⟦record⟧s that adds no claim of its own: an ⟦outline⟧, a generated lexicon, a list of open questions. Where a view and a record disagree, the record wins.
- **main-outline:** a store's primary ⟦view⟧, named `main.outline.md` (`sop/main.outline.md` for the SOP store). It is one view among possibly many; the name marks it as primary without making it the only one.
- **standing:** what a reader may conclude about a ⟦record⟧ right now. It is computed from what has happened to the record, never typed in, and always evaluated as of a moment. Its headline is the record's ⟦record-status⟧.
- **working-notes:** the closing section any ⟦record⟧ may carry. It holds what is still open or not yet dispositioned: open questions, open threads, doubts, unverified leans, and cautions or dead ends not yet moved to the body. It is drained continually, and it never holds history, which goes to the changelog and to git. A record with working notes cannot be considered frozen ([[conv:working-notes]]).

## Invariants

- No field or cell anywhere holds a hand-typed standing word such as "verified", "solid" or "done". ⟦standing⟧ is computed or absent.
- A ⟦record⟧ whose ⟦working-notes⟧ are non-empty is not at its ⟦kind⟧'s frozen state (a `final`-like status, or the top rung of its verification ladder).

## Examples

- [[spec/rule:implied-root]] and the fixture file it cites, [[spec/fixture:implied-root]], are two ⟦record⟧s with the same ⟦slug⟧ and different ⟦kind⟧s.
- A row in `main.outline.md` is a ⟦view⟧ of a record, not the record.

## Discussion
- These terms render verisectorium RC1 `02-RECORD-OBJECT-MODEL` (record, projection) and `11-LEXICAL-CORE` (identity as a maintained binding), and Joseph's 2026-09-30 decisions in `sop/influx/jaw-proposal-and-feedback.md` §1.5–1.6 and §1.10. They render those sources; they do not quote them.
- This entry defines the unit. Which ⟦kind⟧s exist is declared by each store's kinds map (`.vsect/kinds.yaml`), which is what says what a corpus is (Joseph, §1.8); see [[def:record-kinds]].

## Cautions

- "Outline = view" is a working theory, not a fixed ideal. Joseph has left room for a call for at least one canonical full view (`sop/influx/jaw-proposal-and-feedback.md` §1.8; [[decision:fixtures-are-records]]).
