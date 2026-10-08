---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: true
title: "Quoted strings are essentially Ruby's: escapes in \"…\" (an unknown one is an error; #{…} is text), only \\' in '…', the same for quoted names and labels; a raw newline inside is an error"
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

# Quoted strings are essentially Ruby's: escapes in "…" (an unknown one is an error; #{…} is text), only \' in '…', the same for quoted names and labels; a raw newline inside is an error

## Context and Problem Statement

0.10.0 had no escapes inside quoted strings: a string ends at the next quote of its own kind, so a string holding both quote kinds, or a newline, had no single-line spelling (L2; pre-design 75). Lite needs to carry what JSON strings carry. On 2026-10-08 (~20:58Z, summarized in `.int/STEWARD-VERBATIM.md`) the agent put escapes as three options, leaning C with raw single quotes:

- A: strings take escapes; opaque spans keep any `\X` gives `X`;
- B: one rule everywhere, JSON's escapes plus the span's closer, any other `\X` an error;
- C: the same as B, but any other `\X` kept as written.

Joseph answered with a fourth option of his own, opening "Not sure I saw this question". It differs from the agent's lean in two ways: single quotes take `\'`, so they aren't raw; and spans keep their own rule. Asked then about two edges, he confirmed that an unknown escape in `"…"` is an error and that `#{…}` passes through as text.

## Decision Drivers

* None stated.

## Assumptions

* None recorded.

## Considered Options

* No escapes; end at the next same quote (0.10.0, L2).
* The agent's A, B or C, with raw single quotes (lean C).
* Essentially Ruby's string rules (Joseph's own option; chosen). Ruby itself silently drops the backslash of an unknown escape, which is option A's behavior for strings; Joseph chose an error instead.

## Decision Outcome

Chosen: `"…"` and `'…'` are essentially Ruby strings.

- **`"…"`** takes escape sequences. **An unknown escape is an error** (e.g. `"C:\Users"`: `\U` isn't an escape). **`#{…}` is not interpolation**: it passes through as text.
- **`'…'`** takes no escapes except `\'`. (`\\` as one backslash is Ruby's rule too and follows from "just like ruby strings"; his example shows only `\'`.) Every other backslash is literal.
- **The same rules apply in quoted names and labels.** Joseph's example: `|'something "hey"\'' weird node name` is an element named `something "hey"'`, followed by `$main` text `weird node name`.
- **A raw newline inside a quoted string is an error** ([[decision:errors-stop-parsing]]); write `\n` instead, in `"…"`. A `\` at the end of a line inside a string is an error too (the agent's statement in the message Joseph answered "right"; it also follows from the newline error).
- This is separate from the rule for `<…>`, `@{…}` and `;{…}` ([[decision:opaque-spans]]).
- **The exact escape list is still open.** Joseph thinks the mainline 0.9 spec has an improved set, and suggests lining it up with lite's number notations; an agent is researching it (`.int/escape-sequences-2026-10-08.md`). The agent's proposal to him was Ruby's set (`\\ \" \n \t \r \0 \s \e \a \b \f \v \xHH \uHHHH \u{…}` and octal).

### Quote

> - Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
>
> — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

> I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences.
>
> — Joseph, 2026-10-08 (same file, earlier message)

> ruby strings:  right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in "". I *think* we actually have an improved set of escape sequences defined in the mainline old 0.9 udon spec if you want to send an agent looking for anything about it and/or suggesting any modifications that would line it up to match our number notations etc. better that we have defined for (non-delimited) values.
>
> — Joseph, 2026-10-08 (same file, later message)

*His words: "I think … should essentially be just like ruby strings"; on newlines, "I'm going to lean with you"; on the edges, "right" and "go ahead and error". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).*

### Positive Consequences

* Any JSON string has a lite spelling.
* Agents already know the rules.
* An unknown escape fails loudly instead of silently losing a backslash.

### Negative Consequences

* Windows paths and regexes in `"…"` need doubled backslashes, or `'…'`.
* A single-quoted string can't hold a newline at all (no raw newline, no `\n`).

### What changes

* [[rule:quoted-strings]]; the element-name and label rules for quoted forms.
* This replaces 0.10.0's "no core in-string escapes" (L2) for lite.

## Reopen when

* A Ruby escape proves surprising in practice.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Open (needs-work): the exact escape list, after the 0.9 research lands in `.int/escape-sequences-2026-10-08.md`.
- His words group "arrays, typed values, keys, and embeds" under "general matching + escaping". That is the first time he has said `[…]` lists and `[key]` brackets share the opaque spans' rule; it wants its own Quote when the list and key rules are written.
