---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: ";{…} inline comments are in lite and work in prose, with the opaque spans' escape rules"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: []
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: [{adr: opaque-span-escapes-strict, how: revised, scope: partial}]
closes: ["10 Q2"]
leaves-open: ["59", "13 Q6"]
---

# ;{…} inline comments are in lite and work in prose, with the opaque spans' escape rules

## Context and Problem Statement

Pre-design 10 asked whether `;{…}` is in lite. On 2026-10-08, framed ` ; ` comments were limited to element and attribute lines ([[decision:framed-comments-on-node-lines]]), and Joseph added his strong lean on `;{…}` as an aside while asking for the history behind that ruling. The history pass that came back afterwards (`.int/history-semicolon-in-text-2026-10-08.md`) found writers reaching for notes at the end of row-shaped text lines, which `;{…}` would serve. That connection is the agent's.

## Decision Drivers

* A comment form inside prose, with the same escape rules as the other opaque spans (Joseph, under the Quote).

## Assumptions

* None recorded.

## Considered Options

* Reserve `;{…}` in lite; treat it as text; or include it (chosen).

## Decision Outcome

Chosen: `;{…}` is in lite and is recognized in prose. Its interior is an "essentially opaque" span with the same escape rules as [[decision:opaque-spans]]: matched `{}`, and `\X` gives `X`.

A newline inside `;{…}` is an error in lite: "simply reserved with error" (Joseph, later the same day; recorded in [[decision:opaque-spans]]).

Not decided here:

- whether comments are carried in the tree and how (13 Q6; "opaque" is read here as "not parsed");
- where else it is recognized, whether the spaces around it are kept, and what `:x ;{}` means (59).

### Quote

> OHH, btw-- I *do* think ;{...} comments, with essentially opaque spans [in between] with the same escape rules (matched {} and \ escape-all) as the others-- which *will* be available in prose. (strong lean unless someone has a reason it conflicts with something that is likely)
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> ;{...}  inline comment -- the only way to do udon-level comments within prose.
>
> — Joseph, 2025-12-25 (`~/.claude/history.jsonl:5702`, via `.int/history-semicolon-in-text-2026-10-08.md` §2): earlier words to the same effect

*His word: "strong lean". Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Per-row notes have a home: `| Free | 60 | 10 |  ;{assumed: inlines processed before markdown}`.

### Negative Consequences

* A comment can't span lines in lite.

### What changes

* The text rules include `;{…}`.

## Reopen when

* Something likely conflicts with it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes
