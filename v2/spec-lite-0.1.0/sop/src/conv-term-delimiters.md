---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [term-delimiters, lexicon-in-def]
depends: [def:record, def:sop-kinds]
---

# Defined terms are delimited

*A term used in its defined sense is always delimited: `«…»` for lite (domain) terms, `⟦…⟧` for SOP terms. Each store's lexicon is its `def/` records, with a generated view.*

## Statement

- **When a term is used in its defined sense, it is delimited:**
  - «term» for lite's own terms, defined in the spec store's `def/`;
  - `⟦term⟧` for SOP terms, defined in `sop/def/`.
- **The term inside the delimiters is a term name exactly as its definition lists it** in its `terms:` frontmatter. Plural and inflected forms may add the ending outside the closing delimiter: ⟦record⟧s.
- **The defining entry itself** writes the term in bold where it defines it, and delimits other terms it uses.
- **Backticks are for code, not terms.**
- **Each store's lexicon is its `def/` records.** A LEXICON view is generated from them and never hand-edited.

## How a violation shows

A delimited term that no `terms:` list contains (a dangle); a term that two definitions both list (a collide); an empty pair of delimiters; a defined term used in its defined sense but left undelimited. The last needs a reader, since no linter can catch it.

## Why

- Joseph: "officially defined terms should always be deliniated-- we need some kind of syntax, even if it's not traditional markdown" (`sop/influx/jaw-proposal-and-feedback.md` §1.8).
- The glyphs were settled after feedback. Lite terms, the more frequent kind, took `«…»`. `⟦…⟧` went to SOP terms, because single guillemets `‹…›` are easily confused with `<…>` typed values in monospace (§3.15, §4).
- Lexicon in `def/` with a generated view: settled in §4.

## Working notes

- **The ending-outside rule is this record's proposal.** Writing ⟦record⟧s with the plural inside would dangle, since the term is `record`. The ending goes outside the delimiter instead.
- **Where defined terms are delimited so far:** the carved SOP records use `⟦…⟧` for their main uses. The spec store's samples (`src/`, `def/`, `obj/`, `main.outline.md`) now use `«…»`, but `.int/README.md` still prescribes the old backtick convention and a single `lexicon.md`. Changing it is the udon team's business.
- **Collision to resolve:** the decision field `status` and the record-level ∂(status) share a name. They are kept apart as ⟦status⟧ (a decision's lifecycle, in `def:decision`) and ⟦record-status⟧ (in `def:record-fields`).
