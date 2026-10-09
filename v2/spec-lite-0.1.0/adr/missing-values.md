---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Missing values: :a \\ is an empty text; :a :b 1 is an error because nested attributes are reserved; a bare :a is an error that points to nil, '' or \\"
status: accepted
decided-by: steward
decided: "2026-10-09"
updated: 2026-10-09
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: errors-stop-parsing, how: revised, scope: partial}]
superseded-by: []
closes: ["12 Q2"]
leaves-open: []
---

# Missing values: :a \ is an empty text; :a :b 1 is an error because nested attributes are reserved; a bare :a is an error that points to nil, '' or \

## Context and Problem Statement

[[decision:errors-stop-parsing]] listed "a `:label` with no value" as an error, carrying 0.10.0's missing-value error. [[decision:backslash-by-position]] left `:a \` open. Joseph recalled the error's main reason as nested attribute labels being reserved, and leaned toward `:a \` standing for an empty or explicit no-value. The agent replied that the record gives other reasons (2026-07-15: binding; 2026-08-07: the "deletion detector" he ratified), and that `:a \` falls out of "a framed `\` ends the current text" as an empty text. He took that, gave his reason as a new one, and set the message for a bare `:a`.

## Decision Drivers

* Nested attribute labels are reserved ([[decision:nested-attributes-reserved]]), so `:a :b 1` must not read as anything (Joseph, under the Quote).
* Implicit missing values are not supported; the author spells what they mean (Joseph).

## Assumptions

* None recorded.

## Considered Options

* An explicit "no value" node, read by default as nil (Joseph's first lean).
* `:a \` an empty text; `:a :b 1` and a bare `:a` errors (chosen).

## Decision Outcome

Chosen:

- **`:a \`** is an empty text: it falls out of "a framed `\` ends the current text" ([[decision:backslash-by-position]]).
- **`:a :b 1`** is an error, because nested attributes are reserved. (The 2026-08-07 "deletion detector" reason also holds, but it isn't his ground now.)
- **A bare `:a`**, with nothing after it and nothing indented under it, is an error. The message says implicit missing values aren't supported, and points to `nil`, `''` for an empty string, or `\` for an empty text.

```udon
|el :a \          → el (a text[])                    ; empty text
|el :a ''         → el (a "")                        ; empty string
|el :a nil        → el (a nil)
|el :a :b 1       → error: nested attributes are reserved
|el :a            → error: implicit missing value; use nil, '' or \
|el
  :a
    first line    → el (a text["first line"])        ; a value below the label, not missing
```

### Quote

> 1. If you'll recall, the primary reason for erroring on missing values was not because they shouldn't be representable -- (equivalent to null/nil or an explicit 'no-value' that is distinct from those in the AST if we would prefer, with a default read-time option to treat it as null) but because we have reserved nested attribute-labels as a potential construct. So I actually lean `:a \` is a perfectly reasonable way to stand in for `:a ''`/`:a ""`, OR as a rule to stand for "explicitly no value specified" which reads by default to be equivalent to null (or nil? I forget which one we landed on in prior iterations).
>
> — Joseph, 2026-10-09

> 1. Consider it a new argument then :-)
>    I agree fully, except the `:a :b 1` should error not as a deletion detector (although it serves that purpose) but due to nested attributes being reserved, and `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
>
> — Joseph, 2026-10-09 (both in `.int/STEWARD-VERBATIM.md`)

*His words: "I agree fully, except…", with his own reason and message. His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Every empty or absent value is spelled on purpose, and the error teaches the three spellings.

### Negative Consequences

* None identified.

### What changes

* [[decision:errors-stop-parsing]]'s "a `:label` with no value" is replaced by the two cases above.
* [[decision:backslash-by-position]]'s `:a \` edge is settled.
* [[rule:missing-value]] and the anomaly inventory carry the message.

## Reopen when

* Nested attributes get a meaning (then `:a :b 1` needs reconsidering).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- `text[]` is the placeholder AST notation; an empty text has no pieces.
