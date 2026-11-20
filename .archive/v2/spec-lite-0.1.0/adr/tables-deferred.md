---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Whether lite has a structured table construct is left for later"
status: proposed
decided-by: proposed
decided: ""
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [udon agent of session 5930da5d (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["08"]
---

# Whether lite has a structured table construct is left for later

## Context and Problem Statement

Joseph listed "better markdown-like tables" among the possibly open things for lite. The agent answered that Markdown tables written with pipe-space already pass through as prose, that a structured table would be new design, and that it would keep tables out of lite 0.1.0, "unless you meant something narrower".

## Decision Drivers

* None recorded.

## Assumptions

* None recorded.

## Considered Options

* The agent's: keep structured tables out of lite 0.1.0 and treat them as a separate question.

## Decision Outcome

Undecided, deliberately: Joseph left the decision for later. His words carry two readings, and this record holds both:

- he agreed to the agent's proposal, so structured tables are out of lite 0.1.0;
- he deferred the whole question, including whether lite 0.1.0 needs one.

Either way, how existing Markdown tables and pipes behave in lite text is still lite's to settle (08), and he asked about the divider row `|---|---` directly.

### Quote

> I'm ok leaving that decision for tables for now. What about `|---|---....` ?
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

*`awaiting-decision: false`, because the deferral is his and nobody is being asked to decide it now.*

### Positive Consequences

* None identified.

### Negative Consequences

* None identified.

### What changes

* Nothing yet.

## Reopen when

* The text rules reach pipes and Markdown tables (08), or a structured table is wanted.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
