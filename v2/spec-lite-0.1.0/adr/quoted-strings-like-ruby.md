---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "Quoted strings follow Ruby: escapes in \"…\", only \\' and \\\\ in '…', the same for quoted names and labels; a raw newline inside is an error"
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
closes: []
leaves-open: ["75", "05"]
---

# Quoted strings follow Ruby: escapes in "…", only \' and \\ in '…', the same for quoted names and labels; a raw newline inside is an error

## Context and Problem Statement

0.10.0 had no escapes inside quoted strings: a string ends at the next quote of its own kind, so a string holding both quote kinds, or a newline, had no single-line spelling (L2; pre-design 75). Lite needs to carry what JSON strings carry. Joseph raised it unprompted while answering other questions.

## Decision Drivers

* Quoted strings should behave like a string syntax everyone already knows (Ruby's), separately from the general matching-and-escaping rule of opaque spans (Joseph, under the Quote).
* Disallow newlines inside delimited strings, but allow `\n` and the other common escape sequences (Joseph, earlier the same evening).

## Assumptions

* None recorded.

## Considered Options

* No escapes; end at the next same quote (0.10.0, L2).
* The opaque spans' rule (matched brackets, `\X` gives `X`).
* Ruby's string rules (chosen).

## Decision Outcome

Chosen: `"…"` and `'…'` behave like Ruby strings.

- **`"…"`** takes escape sequences (Ruby's set: `\n`, `\t`, `\\`, `\"`, `\u{…}`, and so on; the exact list is pin work).
- **`'…'`** takes none, except what Ruby allows: `\'` and `\\`. Every other backslash is literal.
- **The same rules apply in quoted names and labels.** Joseph's example: `|'something "hey"\'' weird node name` is an element named `something "hey"'`, followed by `$main` text `weird node name`.
- **A raw newline inside a quoted string is an error** ([[decision:errors-stop-parsing]]); write `\n` instead (in `"…"`).
- This is separate from the rule for `<…>`, `@{…}` and `;{…}` ([[decision:opaque-spans]]).

### Quote

> - Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences.
>
> — Joseph, 2026-10-08 (same file, earlier message)

*His words: "I think … should essentially be just like ruby strings"; on newlines, "I'm going to lean with you". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up (the footnote "Decided for this version" in `adr/TEMPLATE.md`). `awaiting-decision` is true only for the unknown-escape question in Working notes.*

### Positive Consequences

* Any JSON string has a lite spelling.
* Agents already know the rules.

### Negative Consequences

* Windows paths and regexes in `"…"` need doubled backslashes or `'…'`.

### What changes

* [[rule:quoted-strings]]; the element-name and label rules for quoted forms.
* This replaces 0.10.0's "no core in-string escapes" (L2) for lite.

## Reopen when

* A Ruby escape proves surprising in practice.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- **Open, with Joseph:** what an unknown escape does in `"…"`, e.g. `"C:\Users"`. Ruby silently drops the backslash (`\U` gives `U`); the coordinator is offering an error instead.
- Open: Ruby interpolates `#{…}` in `"…"`. Lite has no interpolation; `#{` is presumably literal, to confirm.
- Open: the exact escape list (`\s`, `\e`, octal, `\x`, `\c`, `\M-`…): pin work.
- His words group "arrays, typed values, keys, and embeds" under "general matching + escaping". Whether `[…]` lists and `[key]` brackets take the opaque spans' `\X` escape rule is not yet decided; to confirm when those rules are written.
