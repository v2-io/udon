---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Directories are organizational only"
status: accepted
decided-by: steward
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

# Directories are organizational only

## Context and Problem Statement

The proposal had tied kinds to directories ("Lives in"), and an agent had read meaning into where a file sits (`sop/influx/jaw-proposal-and-feedback.md` §1.4).

## Decision Drivers

* Records should be findable wherever they are, or later in a database.
* Outline links name the record, not its location.

## Assumptions

* None recorded.

## Considered Options

* Directories are organizational conveniences only (chosen)
* Directory implies kind

## Decision Outcome

Chosen: within a store, the directory that holds an atom implies nothing about it, and even keeping one kind per directory is not enforced for now. Tooling finds records wherever records are.

- The boundary of the SOP store (`sop/`) is not a mere directory: the SOP store is its own small verisectorium ([[decision:sop-own-vsect-and-decisions]]).
- Directories do determine *where to look*, through the explicit glob list in [[decision:kinds-yaml-resolution]].

### Quote

> subdirectories are often flat directories that share the same *kind* or small set of *kinds* -- but are for organizational purposes only-- I don't believe the directory that stores an atom should be used to imply or indicate anything other than that for right now-- and even *that* much doesn't necessarily need to be enforced right now.
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.4)

### Positive Consequences

* Records can be reorganized without changing their identity.

### Negative Consequences

* The agents misapplied this once to the SOP store boundary; the clarification above records the limit.

### What changes

* The proposal's "Lives in" column becomes "usually kept in".

## Reopen when

* A store migrates to a database, and "where to look" stops being paths.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

