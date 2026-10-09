---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "In prose, beyond indentation, lite specifies only a leading \\ (consumed), embedded forms, and escaped embedded forms (literal, escape consumed)"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["82"]
---

# In prose, beyond indentation, lite specifies only a leading \ (consumed), embedded forms, and escaped embedded forms (literal, escape consumed)

## Context and Problem Statement

[[decision:backslash-by-position]] left open what `\|{` does in prose. The agent asked, leaning toward "makes the embedded form literal". Joseph ruled it, and stated the whole of what lite specifies inside prose.

## Decision Drivers

* Prose should carry as few rules as possible. (**inferred, unconfirmed** as his driver: the agent's reading of "those are the only behaviors we specify".)

## Assumptions

* None recorded.

## Considered Options

* Only one option was on the table (the agent's lean, which he ruled).

## Decision Outcome

Chosen. On a prose line, beyond indentation (indent and dedent), lite specifies only:

- **a leading `\`**, after any whitespace: read specially and consumed ([[decision:backslash-by-position]]);
- **embedded forms** (`|{…}`, `@{…}`, `;{…}`): detected ([[decision:embeds-are-pieces-of-text]]);
- **escaped embedded forms** (`\|{`, `\@{`, `\;{`): literal, passed through with the escape consumed.

Everything else in a prose line is passed through as written.

```udon
|p
  See \|{em this} written literally, and |{em this} as an element.
```
```text
p └ text["See |{em this} written literally, and ", em("this"), " as an element."]
```

### Quote

> 3. Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
>
> — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

*His words: "Agreed, 100%, ruled". His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Prose is close to plain text: Markdown and code-ish text pass through.

### Negative Consequences

* None identified.

### What changes

* [[rule:text-blocks]], [[rule:escapes]]; [[decision:backslash-by-position]]'s `\|{` edge is settled.

## Reopen when

* None recorded.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- His "if memory serves correctly" hedges the "only behaviors" clause. What happens at the start of a line before it becomes prose is not in tension with it, on the agent's reading: a line starting `|name`, `:label`, `;` or a fence is structure, and `@name` or `!word` at a prose line's start is a reserved error ([[decision:reserved-line-starts-in-prose]]), both decided before the line's text begins. To confirm when the text rule is written.
