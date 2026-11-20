---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Officially defined terms are always delimited: «…» for domain terms, ⟦…⟧ for SOP terms"
status: accepted
decided-by: ratified
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5), spec-lite fork (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# Officially defined terms are always delimited: «…» for domain terms, ⟦…⟧ for SOP terms

## Context and Problem Statement

Defined terms were marked with backticks, which collide with code spans, and there was no way to tell a lite term from an SOP term (`sop/influx/jaw-proposal-and-feedback.md` §1.8, §3.15).

## Decision Drivers

* Always delimit officially defined terms.
* Lintable: every delimited term must resolve to a definition.

## Assumptions

* In a spec about `<…>`, single angle quotes `‹…›` would be confused with angle brackets. (**inferred, unconfirmed**, the agent's concern)

## Considered Options

* `«…»` for SOP terms and `‹…›` for domain terms (Joseph's first suggestion)
* `«…»` for domain terms and `⟦…⟧` for SOP terms (chosen)

## Decision Outcome

Chosen: officially defined terms are always delimited. `«…»` marks domain (lite) terms, and `⟦…⟧` marks SOP-store terms. Backticks are for code only.

### Quote

> officially defined terms should always be deliniated-- we need some kind of syntax, even if it's not traditional markdown-- «...» maybe for sop-related, and ‹...› for domain-defined? something like that?
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.8)
>
> And, on the agent's counter-proposal: "i can sustain your lean" (§1.9).

*`decided-by: ratified`: Joseph proposed delimiting; the glyph assignment was the agent's lean, which he sustained.*

### Positive Consequences

* Backticks are freed for code.

### Negative Consequences

* The delimiters are not standard markdown.

### What changes

* The backtick convention for terms (`.int/README.md`) is replaced in this side's files.

## Reopen when

* Rendering or typing the glyphs proves costly.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

