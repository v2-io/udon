---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "The inside of a [key] bracket is a value, with the opaque spans' bracket matching and strict escapes; [ ] lists are their own thing: whitespace-delimited values"
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
closes: []
leaves-open: ["77", "83"]
---

# The inside of a [key] bracket is a value, with the opaque spans' bracket matching and strict escapes; [ ] lists are their own thing: whitespace-delimited values

## Context and Problem Statement

After the opaque spans got a strict escape rule ([[decision:opaque-span-escapes-strict]]), the agent asked whether `[…]` lists and `[key]` brackets follow it (`|el :tags [a\]b c] :k[x\]y]`) or 0.10.0's rule that a backslash mid-word is literal. Joseph had earlier grouped "arrays, typed values, keys, and embeds" under one "general matching + escaping" rule ([[decision:quoted-strings-like-ruby]]). He answered that key brackets follow the same rules and lists don't. The agent then asked what "the same rules" means for keys: (a) only the matching and escape rules carry over and the inside is still a value (`|step[1]` an integer), or (b) a key is an opaque raw-text span. He chose (a).

## Decision Drivers

* Keys are value slots (0.10.0, K2/K16: "a key is not a different syntax, it is a value slot"); (a) keeps that. (**inferred, unconfirmed** as his driver for (a): the agent's reason for the lean he agreed with.)

## Assumptions

* None recorded.

## Considered Options

* Keys and lists both take the strict span rule.
* (a) Key brackets: bracket matching and the strict escape rule; the inside is still a value. Lists: their own rule (chosen).
* (b) A key is an opaque raw-text span.

## Decision Outcome

Chosen:

- **`[key]`:** the inside is a value, by the same value grammar as elsewhere (`|step[1]` is the integer 1, `|step["01"]` the string `"01"`). From the opaque spans it takes only bracket matching and the strict escape rule: `\\`, `\[` and `\]` are the escapes, and any other backslash is an error.
- **`[…]` lists** are "their own thing completely": whitespace-delimited values. The strict span rule doesn't apply to them.

### Quote

> consequences: understood, agreed.  and #2, you're right-- key-brackets should follow the same rules, but arrays are their own thing completely-- multiple whitespace delimited values.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> 1. (keys) -- You're right-- I also forgot about key particulars. I agree with your lean toward (a) -- I do worry about "string" being its own distinct type from "text" :-)
>
> — Joseph, 2026-10-08 (same file, later)

*His words: "you're right" and "I agree with your lean toward (a)" (keys, the agent's lean); "arrays are their own thing completely" (lists, his own words). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* A key and an attribute value read the same; only the bracket's edges differ.

### Negative Consequences

* A `]` or `\` in a bare key needs an escape.

### What changes

* [[rule:keys-and-traits]] and [[rule:lists]].

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- To pin: inside a key, a quoted string follows its own escapes ([[decision:quoted-strings-like-ruby]]); the strict span escapes presumably apply only to the unquoted parts. And an unescaped `[` inside a key opens a nested list by the value grammar (`[[one two]]`), which is the "bracket matching".
- Open: what a backslash does inside a bare list item, and how a list item holds a `]` (quoting, presumably).
- **For the values work:** Joseph's worry about "string" being its own distinct type from "text". 0.10.0 keeps a quoted string and an unquoted text value as different kinds (§6.3).
- A key such as `|cite[@{ref.key}]` holds a text whose one piece is a reference ([[decision:embeds-are-pieces-of-text]]).
