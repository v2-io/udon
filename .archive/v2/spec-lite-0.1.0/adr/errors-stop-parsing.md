---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "In lite every error stops parsing with no tree; warnings are for correct lite that may not do what was meant"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers, vsect]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: [{card: rule:missing-value, how: revised, scope: partial}]
closes: ["12 Q1", "12 Q2"]
leaves-open: ["12 Q3", "05", "89"]
---

# In lite every error stops parsing with no tree; warnings are for correct lite that may not do what was meant

## Context and Problem Statement

[[decision:reserved-is-an-error]] made a reserved spelling an error that halts parsing, and left open how drastic other errors are. 0.10.0 had three endings: a tree plus anomalies, an error that still produces a tree (a `:label` with no value gets `nil`), and a tree marked incomplete when a delimited construct is open at end of input. On 2026-10-08 the agent asked whether documents with warnings still count as lite, proposing to stop only for what lite deliberately doesn't define. Joseph answered that every error stops.

## Decision Drivers

* "Disallowed == error == stop/fail" (Joseph, under the Quote).
* Lite should behave "more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong" (Joseph).

## Assumptions

* None recorded.

## Considered Options

* Stop only for what lite deliberately doesn't define; other errors produce a tree (the agent's proposal).
* Every error stops (chosen).

## Decision Outcome

Chosen: **right now, an error is a failure: the parser stops, reports what it found and where, and produces no tree.** A document is valid lite when it has no errors; warnings don't make it invalid.

Errors (each stops parsing):

- a reserved spelling ([[decision:reserved-is-an-error]]), including a `:label` line directly under an open attribute value ([[rule:nested-attributes]]);
- a `:label` with no value;
- an unclosed `|{…}`, `;{…}` or `@{…}`, an unclosed quoted string, or an unclosed `[` key (no `$partial-key`), all in his words;
- an unclosed `<…>`, an unclosed `[…]` list, or an unclosed fence: not in his words, but covered by "something missing a closing delimiter is just a straight-up error", and listed in the agent's restatement of his errors (2026-10-08 ~20:58Z, summarized in `.int/STEWARD-VERBATIM.md`), which he answered questioning only a different item. Assent by non-objection;
- input ending inside any delimited construct (the "incomplete" ending folds into this one);
- a newline inside a quoted string ([[rule:strings-like-ruby]]; `\n` and the other escapes are allowed) or inside an opaque span ([[rule:opaque-span-raw-text]]);
- a tab or other non-space whitespace where it could shift a node's column ([[rule:column-shifting-whitespace-error]]);
- text after a fence closer's backticks, other than a framed comment ([[rule:fence-line-comments]]).

Warnings are for "technically correct udon/udon-lite" that "does do a specific thing-- but possibly not what you intended". The tree is produced and carries them. Which anomalies remain warnings is the agent's reading of that definition, to confirm when the anomaly inventory is written: an attribute written after the element's content has begun; a text line, or a fence body line, shallower than the established left edge (the edge moves).

### Quote

> My current lean is that any *error* right now is a failure / stop. That would include #3 on your ways it can end being part of #1 instead, and I think should apply to a label with no value, any tab characters found in block mode, and unclosed embedded |,;,@ nodes or unclosed strings, etc. I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences. I also think that partial-key, unclosed [...  is an error.   Disallowed == error == stop/fail. In some ways it will be treated more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong. Whereas *warnings* are for "this *is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do..."
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His words: "My current lean", "I think should apply", "I'm going to lean with you", "I also think". "#3 … being part of #1": the agent's third ending (a tree marked incomplete) merges into the first (stop, no tree). Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* No tool ever builds on a tree from a document with an error in it.
* Errors are unambiguous for authors: something is wrong, fix it.

### Negative Consequences

* "Error" now means something different in lite (stop) from 0.10.0's ledger (something was lost; recognition continues).
* An editing accident such as a missing `]` gives no tree at all, where 0.10.0 kept going with `$partial-key`.

### What changes

* [[rule:valid-lite]] and [[rule:anomaly-inventory]] are written on this footing; `$partial-key` is not part of lite's tree.
* Fixtures for each error give the error, not a tree.

## Reopen when

* Tools on the live corpus need partial trees from documents with errors.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open: whether a `[…]` list may span lines (05). "Newlines within delimited strings" is read here as quoted strings; the agent's restatement had "a newline inside any delimited span", unobjected.
- Open: what "any tab characters found in block mode" covers beyond what [[rule:column-shifting-whitespace-error]] records (being asked).
- Whether a document with only warnings needs any marking beyond the warnings themselves: not stated.
- For the anomaly inventory: 0.10.0's top-level `:label` warning (pre-design 04 Q2, 12's table) is in neither list yet; to decide with the root's attributes.
- Not decided: whether a parser may keep scanning after an error to report more errors (still producing no tree).
- For the anomaly inventory: a no-break space where it sets a column is a warning, by Joseph's own call ([[rule:no-break-space-counts-as-space]]).
- "A `:label` with no value" is refined by [[rule:missing-value]]: `:a \` is an empty text; `:a :b 1` and a bare `:a` are errors.
