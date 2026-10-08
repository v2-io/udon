---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "An attribute's value may be an element in lite"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["64"]
leaves-open: ["74"]
---

# An attribute's value may be an element in lite

## Context and Problem Statement

0.10.0 lets an attribute's value be a node (`:author` with `|person` under it; `:x |em hi`). Pre-design 64 asked whether lite keeps that, or limits attributes to scalars, text and lists as Joseph's 2026-01-13 "udon-xml" flavor did. The agent listed it among the root questions on 2026-10-08.

## Decision Drivers

* None stated with the lean. His earlier reasons, given as "not a decision — pondering" on 2026-07-15 (quoted in pre-design 64): attributes are labeled from the parent's side; the label is conserved and values accumulate under it; children are positional; "an element automatically has a hash-table available and an array available… it seems a little arbitrary to require that only the array can hold additional elements."

## Assumptions

* None recorded.

## Considered Options

* Keep node-valued attributes (chosen, as a lean).
* Leave them out of lite.
* Only in block form under the label.

## Decision Outcome

Chosen: keep. An attribute's value may be an element.

This settles that elements are allowed as attribute values. How values written on the lines under a label are read (one element, several, mixed with text) is 74, left open.

### Quote

> 5. My lean is keep. If so, see what cluster 2 does to this "root decisions" list
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His word: "lean". Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`). The follow-up he attached is open work (working notes), not a pending decision.*

### Positive Consequences

* The "attributes are edges, elements are nodes" model stays whole.

### Negative Consequences

* The direction from lite to XML loses something (elements as attribute values have no XML spelling); see [[obj:represent-xml-html]].

### What changes

* The rules for values below the label.

## Reopen when

* A lite consumer needs the narrower XML-shaped model.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open: Joseph's attached follow-up, "see what cluster 2 does to this 'root decisions' list". The only answer so far is the agent's one line (most of the line-ownership cluster follows from 0.10.0). A worked answer, with examples, is owed.
