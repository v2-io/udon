---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "<…>, @{…} and ;{…} are opaque spans: raw text in the tree; for now, matched brackets, \\X gives X, and a newline inside is an error in lite"
status: accepted
decided-by: steward
decided: "2026-10-08"
updated: 2026-10-08
deciders: [Joseph (steward)]
consulted: ["udon-team agent (agent, Opus 5.5)"]
informed: [parser implementers]
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: ["07 Q1", "07 Q2", "07 Q3"]
leaves-open: ["07 Q4", "07 Q5", "89"]
---

# <…>, @{…} and ;{…} are opaque spans: raw text in the tree; for now, matched brackets, \X gives X, and a newline inside is an error in lite

## Context and Problem Statement

Lite carries `<…>` without reading it ([[decision:explicit-typed-value-in]]), which left open where it ends, whether it spans lines, and what the tree holds. On 2026-10-08 `@{…}` references came into lite carried the same way ([[decision:references-in]]). So one interim rule for both delimited spans was needed. Later the same day Joseph leaned toward `;{…}` comments in prose "with the same escape rules" ([[decision:inline-comments-in-prose]]); how far this record applies to `;{…}` is below.

## Decision Drivers

* "I vote yes, raw text, for typed delimited values (<...>) and references @{...}" (Joseph, under the Quote).
* A convention that is "either already used, intuitive, and/or easily remembered" (Joseph).
* "The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently" (Joseph). The agent's point that this holds only if lite refuses what it doesn't define led to the newline error.
* The error must not read as a UDON-wide prohibition (Joseph, the caveat on the message wording).

## Assumptions

* Unescaped matched brackets inside a span are more useful (HTML-ish content) than an escape-everything rule. (**recorded**: Joseph, "it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something)")
* The cost to `\`-heavy content (regexes, Windows paths) is acceptable: such content doubles its backslashes. (**recorded**: the agent named the cost; Joseph accepted the lean)

## Considered Options

* Ends where: matched brackets (chosen, as an interim convention) vs the first closer.
* Escapes: only the span's own brackets and `\`, with every other `\X` literal, vs any `\X` gives `X` (chosen).
* A newline inside: warn and close the span at the line's end (Joseph's first suggestion); count warned documents as not accepted (the agent's other alternative); an error in lite (chosen, on the agent's point that a warned-and-accepted reading would make a later multi-line rule change meaning).

## Decision Outcome

Chosen, for `<…>` and `@{…}`, as Joseph's interim convention:

- **The tree carries the raw text** between the delimiters, escapes resolved, with no meaning attached. For `<…>` this is read as: no split into a type label and a body (the reading of "raw text"; answers 07 Q3).
- **Extent: matched brackets.** An unescaped opener inside the span nests and must be matched; the span ends at the closer that balances its own opener.
- **Escapes: any `\X` gives `X`** inside the span, whatever `X` is; an escaped bracket doesn't count toward matching. Joseph's example: `@{this { another thing \\ \"Hello\"\} }}` carries `this { another thing \ "Hello"} }`.
- **A newline inside the span is an error in lite, for now.** The message says that *lite* doesn't support newlines in that construct (e.g. "lite doesn't support newlines in a typed value"), so it is not taken as a UDON-wide rule. A command-line flag to accept it with a warning may be added if someone asks for it, not before.
- **`;{…}`:** Joseph gave it "the same escape rules (matched {} and \ escape-all)" and, asked separately, made a newline inside it "simply reserved with error" too, because such newlines "make dedent level ambiguous in several corner cases" (second Quote below).

### Quote

> I vote yes, raw text, for typed delimited values (<...>) and references @{...}.
>
> With the opaque delimited spans (typed values and references) -- I think we can adopt an interim convention of matched braces, warn and pseudo-close span on newline, and detect and unescape either just backslash-escaped brackets for that thing, or potentially consider any single backslash '\' followed by another character as just that next character-- e.g.:   `@{this { another thing \\ \"Hello\"\} }}`  ->  `this { another thing \ "Hello"} }` etc. -- some convention that is either already used, intuitive, and/or easily remembered etc.
>
> The rule on where it ends doesn't need to be fixed now if the eventual rule is *broader* than what we allow currently.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I'm ok though turning the newline in the opaque spans into an error for now, with the caveat that the error message explains that '**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition. If some user needs to accept it anyway with a warning we can give a command-line flag to disable it-- *when*/if it's requested/needed. […]
>
> I'm OK with your lean on the opaque escaping -- note that it is still allowing unescaped *matched* brackets (which doesn't help the regex example, but would help, e.g., an html example or something).
>
> — Joseph, 2026-10-08 (same file, next message)

> 2. I'm ok keeping it simple with lite 1.0 and saying newlines in embedded comments are simply reserved with error. The main issue is similar to fence-closing lines-- they make dedent level ambiguous in several corner cases.
>
> — Joseph, 2026-10-08 (same file, later), on `;{…}`

*His words: "I vote" (raw text), "I think we can adopt an interim convention" (matched brackets), "I'm ok … for now" (the newline error, the agent's proposal), "I'm OK with your lean" (the any-`\X` escape, the agent's lean), "I'm ok keeping it simple" (the `;{…}` newline). Raw text and matched brackets are his own calls (`steward`); the newline errors and the escape rule are `supported` parts. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`).*

### Positive Consequences

* One rule for both delimited spans lite carries unread.
* HTML-ish content (`<a <b> c>`, `{…}` inside `@{…}`) needs no escaping when balanced.

### Negative Consequences

* Regexes and Windows paths inside a span double their backslashes (`<re:\\d+>`).
* An unbalanced bracket in content (`<a -> b>`, `@{x}y}`) has to be escaped.
* Resolving every `\X` to `X` in the tree means a future interior grammar that gives `\` its own meaning (a path grammar's `\.`, say) reads `@{a\.b}` differently from lite, which hands over `a.b`. Acceptable under [[decision:forward-compat-aspiration]]; keeping the unresolved source text in meta would recover it.
* A multi-line typed value, reference or inline comment can't be written in lite.

### What changes

* [[rule:explicit-typed-values]] and the reference rule are written on this footing; [[def:typed-value]]'s open question about a type label is answered: raw text only.
* (lite) Forward stability: a later version may widen the newline rule without changing any document lite accepted.

## Reopen when

* Demand for multi-line spans appears (the flag first, then a rule).
* `\`-heavy content inside spans turns out common enough that doubling is a real cost.
* The interim convention is replaced (Joseph called it interim).

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Still open for `<…>`: the empty `<>` and `< >`, and exactly which value positions take it.
- Unclosed at end of input (no newline involved): an error, as every unclosed delimiter is ([[decision:errors-stop-parsing]]).
