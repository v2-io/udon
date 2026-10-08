---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A :label line directly under an open attribute value is reserved in lite (an error)"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["74"]
---

# A :label line directly under an open attribute value is reserved in lite (an error)

## Context and Problem Statement

UDON has no attributes of attributes (K4). In 0.10.0 a `:label`-shaped line directly under an open attribute value is kept as text of that value with a warning (K8), leaving the door open to a future grouping sugar (OPEN ATTR-GROUP). The agent asked whether it should be an error in lite.

```udon
|el
  :a
    :b 1        ; 0.10.0: text ":b 1\n" of a, with a warning
```

## Decision Drivers

* Keep the construction free for later use (a reserved construction), rather than giving it a meaning now. (**inferred, unconfirmed**: the agent's reading of "reserved construction")

## Assumptions

* None recorded.

## Considered Options

* Text of the open value, with a warning (0.10.0).
* A reserved construction: an error (chosen).

## Decision Outcome

Chosen: a `:label` line directly under an open attribute value is a reserved construction. In lite it is an error, which stops parsing ([[decision:errors-stop-parsing]]).

### Quote

> Right-- nested attributes right now should be a reserved construction that causes an error in lite.
>
> earlier:
> - :label-under-open-attribute:  error reserved construction
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His words: "should be a reserved construction". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`).*

### Positive Consequences

* A future grouping or nesting sugar can give the construction a meaning without changing any lite document.

### Negative Consequences

* A value body that genuinely starts with `:word` text must be escaped or quoted.

### What changes

* The reserved-spellings rule lists the construction; the rule for values below a label refers to it.

## Reopen when

* A meaning for nested attributes is designed.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Scope to confirm when the rule is written: only the line directly under the label, or any `:label`-shaped line anywhere in an open attribute's body (0.10.0's K8 covered both, including a `:`-shaped line deeper under a finished value).
