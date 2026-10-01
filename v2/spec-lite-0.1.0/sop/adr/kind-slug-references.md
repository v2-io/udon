---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Every reference is [[kind:slug]]; a bare [[slug]] does not resolve"
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
superseded-by: [{adr: typed-reference-fields, how: revised, scope: partial}]
closes: []
leaves-open: []
---

# Every reference is [[kind:slug]]; a bare [[slug]] does not resolve

## Context and Problem Statement

With kinds declared in frontmatter, a bare slug is ambiguous whenever two kinds share a noun (`sop/influx/jaw-proposal-and-feedback.md` §1.5–§1.6).

## Decision Drivers

* References must resolve without guessing.
* Links are resolved by limen and vsect, so Obsidian rendering no longer constrains the syntax.

## Assumptions

* None recorded.

## Considered Options

* `[[kind:slug]]` everywhere (chosen)
* A Kind column plus bare `[[slug]]`

## Decision Outcome

Chosen: every reference is `[[kind:slug]]`. A bare `[[slug]]` is underspecified: the linter reports it and never guesses. Identity is the pair (kind, slug), so a slug only has to be unique within its kind. Kind names in links may be canonical names or aliases ([[decision:kinds-yaml-resolution]]).

### Quote

> I agree [[kind:slug]] everywhere-- [[slug]] on its own we will consider underspecified and not resolvable. … No need to worry about obsidian anymore, as I've got 'limen' far enough along to start effectively replacing it, and I get to have limen follow links etc. based on whatever we're deciding here :-)
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.6)

### Positive Consequences

* Same-noun pairs across kinds (`rule:implied-root`, `prop:implied-root`) are fine.
* Links work in prose, not only in tables.

### Negative Consequences

* Every existing link needs rewriting.

### What changes

* Outline links are rewritten as `[[kind:slug]]`.

## Reopen when

* A resolver other than limen or vsect has to render these links.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* Partly revised by [[decision:typed-reference-fields]] (single-kind frontmatter fields take bare slugs), pending Joseph's ratification of that record.

* Aliases in links: "I actually see value in allowing both" (§1.7 item 3).
