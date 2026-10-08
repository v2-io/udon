---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A framed ` ; ` comment may follow a fence opener's label and a fence closer; anything else after a closer is an error"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: ["udon-team agent (agent, Opus 5.5) under delegated authority (Joseph, 2026-10-08: \"I'll leave it up to you\"; no grant slug exists)"]
consulted: []
informed: [Joseph (steward)]
wording: verbatim
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# A framed ` ; ` comment may follow a fence opener's label and a fence closer; anything else after a closer is an error

## Context and Problem Statement

Deciding that a fence's closing line takes part in nesting ([[decision:fence-closer-is-a-line]]), Joseph left two calls to the agent: whether a ` ; ` comment may follow the closer, and whether one may follow the opener on its line. He recommended an error for anything else after the closer.

## Decision Drivers

* One comment rule: a framed ` ; ` comments on lines that start structure ([[decision:framed-comments-on-node-lines]]); a fence line is such a line.

## Assumptions

* Labels containing a framed ` ; ` are not needed (a label is a language name or similar). (**inferred, unconfirmed**: the delegate's)

## Considered Options

* Allow on both (chosen).
* Disallow on either, and mark it open for future discussion (Joseph's instruction if no).

## Decision Outcome

Chosen:

- A framed ` ; ` (at least one space on each side, Joseph's definition) may follow the label on a fence's opening line, ending the label, and may follow the backticks on a closing line.
- Anything else after a closer's backticks is an error (Joseph's recommendation, adopted by the delegate).
- What such a comment owns below it follows whatever 78 settles for element and attribute lines.

````udon
|job :script ```sh ; run in CI
make build
``` ; end of script
````

(A fence opener on an attribute line, as here, is arguably already covered by Joseph's framed-comment ruling; the delegated call really bites for fences at the start of a line and for closers.)

The grant: Joseph, 2026-10-08, "I'll leave it up to you whether or not to allow a ' ; ' comment after the backticks on the same line, but recommend an error/failure on anything else. […] Comment being allowed after the fence opener on its line is up to you as well, but if it's no on either or both of those mark it as 'open for future discussion' or something equivalent." (`.int/STEWARD-VERBATIM.md`)

> I support your decision on the comments
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`, later)

*The delegate's call; Joseph has since supported it, so `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Fence lines behave like the other structure lines.

### Negative Consequences

* A label can't contain a framed ` ; `.

### What changes

* The fence rule.

## Reopen when

* The decider declines it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Consequence, confirmed by Joseph ("I like our rules (recorded)"): a body line starting with N or more backticks followed by other text is a closer with trailing text, so an error ([[decision:fence-closer-is-a-line]]).
