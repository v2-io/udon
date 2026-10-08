---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "A bare |name later on an element's line is a child at its own column, not a $main value"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["01"]
leaves-open: ["51"]
---

# A bare |name later on an element's line is a child at its own column, not a $main value

## Context and Problem Statement

0.10.0 says both: §2.1 makes `|a |b |c` the same as the vertical form (children), while §6.4/§6.10's "self-announcing values become `$main` values" makes `b` a value. The 01 history found every explicit statement since 2011 saying child, including Joseph's own examples, and the value reading entering 0.10.0 through rewording (`.int/pre-design/01-sameline-element-child-or-value.discussion.md`).

## Decision Drivers

* Same-line writing is the vertical form written sideways ("pseudo-line-feeds", "pretend the same-line part has each of its parts on consecutive new lines": Joseph's earlier words, quoted in the 01 history).
* The value reading's uniformity is not real: the next non-blank line's indentation would still need special-casing (Joseph, under the Quote).

## Assumptions

* None recorded beyond the drivers.

## Considered Options

* Child at its true column (chosen).
* `$main` value of the element.
* (Raised in history, not pursued) siblings: `|a |b |c` gives `a` two children.

## Decision Outcome

Chosen: a bare `|name` written later on an element's line is a child, at its true column, exactly as if it began the next line there.

- Non-bare forms on an element's line (`|{…}`, `<…>`, `@{…}`, quoted strings, numbers, lists) remain `$main` values. (From the agent's description, which Joseph answered "Yes": assent weight.)
- After a still-open label (`|el :x |em hi`) the element is that label's value, as before.
- A fence after a finished value or on an element's line is likewise a child.

```udon
|table |tr |td A1
           |td A2
```
gives `table └ tr ├ td "A1" └ td "A2"`. The cost: `|card |title Hello` followed by a block `:id 7` makes `id` a late attribute (warned).

### Quote

> Yes, you already know my lean as well. And the value-reading-uniformity gain isn't very uniform because the parser and spec would still need to special case the indent behavior of the next non-blank line underneath. I am open to revisiting it only if it turns out we were missing some crucial advantage that is worth essentially obfuscating one of udon's most notable [elegances].
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His word: "my lean", with a high bar for revisiting ("only if … some crucial advantage"). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* The aligned-table idiom works; the teaching rule "same-line parts are consecutive lines" is exactly true.

### Negative Consequences

* Bare and non-bare forms on an element's line land in different places (children vs `$main` values).
* Late-attribute warning in the `|card |title Hello` + block attributes case.

### What changes

* The line rule states it; 0.10.0's §6.4/§6.10 wording is not carried into lite.

## Reopen when

* A crucial advantage of the value reading turns up.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

