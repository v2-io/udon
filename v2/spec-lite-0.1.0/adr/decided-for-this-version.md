---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "An accepted lite decision is decided for this version whatever word Joseph used, and can be revisited when undiscovered confounding factors come up"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# An accepted lite decision is decided for this version whatever word Joseph used, and can be revisited when undiscovered confounding factors come up

## Context and Problem Statement

On 2026-10-08 Joseph distinguished leans from rulings ("[rulings] seem strong enough to essentially propagate into other decisions and tradeoffs, whereas leans shouldn't cost much to reconsider"). The records written that day then had to say which three of his calls were leans and which rulings, and the agent asked him. He answered that from the spec's perspective there is no difference.

## Decision Drivers

* No sense of orthodoxy should attach to his words as issues come up, now or during parser implementation (Joseph, under the Quote).

## Assumptions

* None recorded.

## Considered Options

* Tier each record by his word (lean, preference, vote, ruling), with different standing.
* Mark them decided for this version, keep his own word, and note that decided can be revisited (chosen).

## Decision Outcome

Chosen:

- **An `accepted` lite decision is decided for this version of lite**, whatever word Joseph used for his position. He wrote "lite-1.0"; the spec in progress is `spec-lite-0.1.0`, and this record reads "lite-1.0" as this first lite.
- **Each record keeps his own word** (lean, strong lean, preference, vote, ruling) under its Quote.
- **"Decided" can be revisited if and when undiscovered confounding factors come up**, now or during parser implementation.
- His answer was about three records the agent asked about ("them"). This record extends it to every accepted lite decision, on his general words "no difference from the spec's perspective".

### Quote

> 1. As I explained earlier, no difference from the spec's perspective. Preserve them as what I said so that as other issues come up now or during parser implementation there isn't some sense of orthodoxy to adhere to. You are free to mark them as "decided" for lite-1.0 assuming you have a footnote somewhere that says that decided can be revisited if/when undiscovered confounding factors come up.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His words: "You are free to mark them as 'decided' … assuming you have a footnote". His own call, so `steward`. This record is that footnote; `adr/TEMPLATE.md` points to it.*

### Positive Consequences

* Records can be acted on without weighing how firm each of his words was.

### Negative Consequences

* `decided-by` now carries little for spec records beyond the word line (see [[decision:decision-authority]]'s working notes).

### What changes

* Every 2026-10-08 lite record cites this one beside his word.

## Reopen when

* A difference between lite 0.1.x and a later lite 1.0 starts to matter for whether a decision carries forward (then ask him what "lite-1.0" meant).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
