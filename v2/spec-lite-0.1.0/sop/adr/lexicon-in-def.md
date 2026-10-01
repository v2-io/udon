---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lexicon entries live as def/ records; LEXICON is a generated view"
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

# Lexicon entries live as def/ records; LEXICON is a generated view

## Context and Problem Statement

`.int/README.md` said lite's terms would go in a single `lexicon.md`; the fork set up per-term records in `def/` (`sop/influx/jaw-proposal-and-feedback.md` §1.9 item 5).

## Decision Drivers

* Terms resolve as `[[def:slug]]` like every other record.

## Assumptions

* None recorded.

## Considered Options

* A single `lexicon.md`
* `def/` records plus a generated view (chosen)

## Decision Outcome

Chosen: each store keeps its terms as definition records (`def/` for lite, `sop/def/` for the SOP store), and any lexicon document is a generated view over them.

### Quote

> yes
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.9, item 5, answering the agent's lean "`def/` plus a generated view")

### Positive Consequences

* One mechanism for every record.

### Negative Consequences

* A generator is needed before a readable lexicon exists.

### What changes

* Nothing yet.

## Reopen when

* A single-file lexicon proves easier to maintain.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* For lite's own terms this is our example; the udon team decides for lite.
