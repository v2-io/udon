---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Inside <…>, @{…} and ;{…}, only \\\\ and the span's own delimiters may be escaped; any other backslash is an error for now"
status: accepted
decided-by: supported
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)", "escape-sequence research agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: [{adr: opaque-spans, how: revised, scope: partial}, {adr: inline-comments-in-prose, how: revised, scope: partial}]
superseded-by: []
closes: []
leaves-open: []
---

# Inside <…>, @{…} and ;{…}, only \\ and the span's own delimiters may be escaped; any other backslash is an error for now

## Context and Problem Statement

[[decision:opaque-spans]] gave the opaque spans the rule "any `\X` gives `X`". The escape-sequence research (`.int/escape-sequences-2026-10-08.md` §4) pointed out that `\n` would then read three ways in lite: a newline in `"…"`, backslash-n in `'…'`, and just `n` in the spans; a regex shows it worst (`<re:\d+>` hands over `re:d+`, silently). The coordinator relayed that note, and Joseph answered with a new lean. This replaces the escape part of [[decision:opaque-spans]] and the same rule restated in [[decision:inline-comments-in-prose]]; their extents, raw-text carrying and newline errors stand.

## Decision Drivers

* Strict now, broader later: error on every other backslash "until something asks us to make an exception-- similar to the "..." unrecognized escape attempts" (Joseph, under the Quote).
* A backslash nobody meant as an escape fails loudly instead of being silently dropped (`<re:\d+>`). (**inferred, unconfirmed** as Joseph's driver: the coordinator's reason for adopting it.)

## Assumptions

* Content in spans rarely needs a backslash before anything but `\` or the span's delimiters. (**inferred, unconfirmed**: the agent's)

## Considered Options

* Any `\X` gives `X` ([[decision:opaque-spans]]).
* JSON-style escapes with unknown `\X` kept as written (the agent's option C, 2026-10-08 ~20:58Z; not taken).
* Only `\\` and the span's own opening or closing delimiter; any other backslash an error (chosen).

## Decision Outcome

Chosen, for `<…>`, `@{…}` and `;{…}`:

- **`\\`** gives `\`.
- **The span's own delimiters** may be escaped: `\<` and `\>` inside `<…>`; `\{` and `\}` inside `@{…}` and `;{…}`. An escaped delimiter doesn't count toward matching.
- **Any other backslash is an error**, for now.
- **Matched, unescaped pairs still need no escape**: `<a <b> c>` and `@{x {y} z}` are fine as written.

```udon
|el :re <re:\\d+>                      ; carries re:\d+
|el :re <re:\d+>                       ; error: \d isn't an escape in a typed value
|p See @{this { another \\ "Hello"\} }} ; reference: this { another \ "Hello"} }
```

Joseph's earlier example `@{this { another thing \\ \"Hello\"\} }}` is now an error at `\"`; inside a span a `"` needs no escape.

### Quote

> With your \n = three things note-- it's true. I'm not worried about the string versions but I'm now wondering if, for the other opaque delimiters we might be better off in lite-0.1.0 at least only allowing \\ and \<opening-or-closing-delimiter> and *erroring* on every other backslash use for now until something asks us to make an exception-- similar to the "..." unrecognized escape attempts.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

*His words: "I'm now wondering if … we might be better off": a lean, which the coordinator agreed with and adopted. Recorded `supported`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* `\n` reads two ways in lite (newline in `"…"`, backslash-n in `'…'`) plus an error in spans, instead of three silent readings.
* Every relaxation later turns an error into a meaning, so no accepted document changes.

### Negative Consequences

* Regexes and paths in typed values double every backslash (`<re:\\d+>`).
* The same `\"` that works in `"…"` is an error inside a span.

### What changes

* [[decision:opaque-spans]] and [[decision:inline-comments-in-prose]] gain `superseded-by` entries for the escape part.
* [[rule:explicit-typed-values]], the reference rule and the inline-comment rule use this escape set.

## Reopen when

* Something asks for an exception (Joseph's condition).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- `[key]` brackets take bracket matching and this escape rule (`\\`, `\[`, `\]`); `[…]` lists don't ([[decision:key-brackets-and-lists]]).
