---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lite's defined terms are written «…» where used in their defined sense"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Lite's defined terms are written «…» where used in their defined sense

## Context and Problem Statement

On 2026-09-29 Joseph asked that lite's defined terms be written in backticks ("so that `typed value` is clearly a term and not just gloss"). That call was never written as a record, and the same night's lexicon was deleted. The next day, on the SOP side, he decided that "officially defined terms should always be deliniated", proposing guillemets; the agent there swapped his glyph assignment so that domain terms, the more frequent ones, take `«…»` and SOP terms take `⟦…⟧`, and he sustained that ([[sop/decision:term-delimiters]]). Lite's own use was left to the udon team. This record replaces the 2026-09-29 backtick call for lite.

## Decision Drivers

* Defined terms must read as terms, not as general words (his reason on 2026-09-29, unchanged).
* Backticks are needed for code, which this spec is full of. (**inferred, unconfirmed** as Joseph's: the SOP side's argument, `sop/influx/jaw-proposal-and-feedback.md` §3.15)
* Lite's terms must be told apart from the SOP store's.

## Assumptions

* None recorded.

## Considered Options

* Backticks (his 2026-09-29 call).
* Guillemets: `«…»` for lite's terms, as the SOP store assigns to domain terms (chosen).

## Decision Outcome

Chosen: a lite term used in its defined sense is written `«…»`, with the term name exactly as its definition lists it. Backticks are for code.

### Quote

> officially defined terms should always be deliniated-- we need some kind of syntax, even if it's not traditional markdown-- «...» maybe for sop-related, and ‹...› for domain-defined? something like that?
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.8)

> yes, the guillamets were my decision for defined terms
>
> — Joseph, 2026-10-01 (`.int/STEWARD-VERBATIM.md`), confirming this record

*Delimiting defined terms with guillemets is his own call, so `steward`. The assignment of `«…»` to domain terms was the SOP-side agent's swap, which he sustained.*

### Positive Consequences

* Code spans and defined terms no longer share a spelling.

### Negative Consequences

* The delimiters are not standard Markdown.

### What changes

* `.int/README.md`'s "Writing convention" (backticks) is replaced.

## Reopen when

* Typing or rendering the glyphs proves costly.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
