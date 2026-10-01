---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The suffix characters ? ! * + lose their special status on elements"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [udon agent of session 5930da5d (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["06"]
---

# The suffix characters ? ! * + lose their special status on elements

## Context and Problem Statement

In 0.10.0 a trailing `?` `!` `*` `+` on an element desugars to a designated attribute (`|field?` → `:$? true`). The agent's lean was to leave suffixes out of lite, "since you'd left retiring them open". Joseph answered that retiring them was what he wanted.

## Decision Drivers

* Joseph's recollection of the original intent, under Assumptions.

## Assumptions

* The intent was to make them "just another allowed identity character". (**recorded**, with Joseph's own caveat: "I am *pretty sure* (we'll need to look into it)")

## Considered Options

* Keep the sugar (0.10.0).
* Leave suffixes out of lite (the agent's lean).
* Retire their special status (chosen).

## Decision Outcome

Chosen: the suffix characters lose their special status on elements. What they become is not decided here. Joseph's recollection of the intent is "just another allowed identity character"; which tokens that covers (element names, keys, traits, or the position after a key, as in `|process[k]?`) is 06's to settle and take back to him, as the "look into it" he asked for. The edge cases (`|?`, a spaced suffix) are 06 too.

### Quote

> suffixes I wanted to retire their *special status* -- I am *pretty sure* (we'll need to look into it) that the intent was to make it just another allowed identity character.
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

*His own call, stated in his own words, so `steward`. Keeping "reserved in lite" open as one of 06's alternatives is held only on his own hedge ("pretty sure (we'll need to look into it)"): the agent's lean had been to leave suffixes out of lite, and his answer chose retirement instead.*

### Positive Consequences

* One less piece of sugar in lite.

### Negative Consequences

* Until 06 closes, lite can't say whether `|field?` is an element named `field?` or a refusal.

### What changes

* The rule for element names will take 06's answer.

## Reopen when

* 06's history shows the intent was something else.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- 06's history found the move to ordinary identifier characters made in Joseph's words for traits (2026-07-12) and for attribute labels (K12), with no record of it for element names (from the second look, `.int/adr-second-look-2026-09-30.md`; not re-checked here). That is the first thing to bring back to him.
