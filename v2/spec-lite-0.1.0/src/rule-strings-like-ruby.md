---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [def:string]
consequences: [rule:no-interpolation, rule:double-quote-escapes, rule:single-quote-escapes, rule:quoted-names-and-labels, rule:newline-in-string-is-error, def:string]
---

# Quoted strings read as Ruby strings

*`"…"` and `'…'` make a «string» read essentially as Ruby reads it, closed at the next unescaped matching quote.*

## Statement

1. A `"…"` or `'…'` string MUST be read as Ruby reads a string literal of the same quote, except as the other string cards say (no interpolation; the escape lists); the result is a «string», a single piece.

## Grounds

- "I think "..." and '...' should essentially be just like ruby strings" (Joseph, 2026-10-08): the Discussion below.

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|q :a "it's" :b 'say "hi"'
```
```tree
root
  |q
    :a "it's"
    :b "say \"hi\""
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/quoted-strings-like-ruby.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** 0.10.0 had no escapes inside quoted strings: a string ends at the next quote of its own kind, so a string holding both quote kinds, or a newline, had no single-line spelling (L2; pre-design 75). Lite needs to carry what JSON strings carry. On 2026-10-08 (~20:58Z, summarized in `.int/STEWARD-VERBATIM.md`) the agent put escapes as three options, leaning C with raw single quotes:

- A: strings take escapes; opaque spans keep any `\X` gives `X`;
- B: one rule everywhere, JSON's escapes plus the span's closer, any other `\X` an error;
- C: the same as B, but any other `\X` kept as written.

Joseph answered with a fourth option of his own, opening "Not sure I saw this question". It differs from the agent's lean in two ways: single quotes take `\'`, so they aren't raw; and spans keep their own rule. Asked then about two edges, he confirmed that an unknown escape in `"…"` is an error and that `#{…}` passes through as text.

**Options considered.**

* No escapes; end at the next same quote (0.10.0, L2).
* The agent's A, B or C, with raw single quotes (lean C).
* Essentially Ruby's string rules (Joseph's own option; chosen). Ruby itself silently drops the backslash of an unknown escape, which is option A's behavior for strings; Joseph chose an error instead.

**Drivers.**

* None stated.

**How firm.** His words: "I think … should essentially be just like ruby strings"; on newlines, "I'm going to lean with you"; on the edges, "right" and "go ahead and error". On the list: "agree" (`\s`, surrogate pairs), "I can support" (`\v` `\a`), "I'm fine erroring as reserved for right now" (`\b`). The rest of the list is the report's proposal as relayed to him, unobjected (assent by non-objection); the `\u{…}` spacing details are an agent default. His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* Windows paths and regexes in `"…"` need doubled backslashes, or `'…'`.
* A single-quoted string can't hold a newline at all (no raw newline, no `\n`).
* JSON strings containing `\b` (backspace) are errors until `\b` is allowed.
* Ruby writers lose octal (`"\033"`, use `\e`), `\s`, and the silent drop of unknown escapes.

**Reopen when.**

* A Ruby escape proves surprising in practice.
* `\b` is wanted, e.g. for terminal output (Joseph: "It sure makes certain terminal behavior easier by having it instead of ansi sequences... (like animated character)"). Note that JSON writers emit `\b`, so JSON pasted into lite may hit the error.

**Joseph's words not already quoted on this card.**

> I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences.
>
> — Joseph, 2026-10-08 (same file, earlier message)

> ruby strings:  right--- no interpolation, #{} gets passed through as normal text, and go ahead and error on unknown escape sequences in "". I *think* we actually have an improved set of escape sequences defined in the mainline old 0.9 udon spec if you want to send an agent looking for anything about it and/or suggesting any modifications that would line it up to match our number notations etc. better that we have defined for (non-delimited) values.
>
> — Joseph, 2026-10-08 (same file, later message)
## Working notes

- **Joseph's words:**

  > Not sure I saw this question, but I wanted to mention that I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`), different than our "general matching + escaping" for arrays, typed values, keys, and embeds.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** A syntax agents already know well; "essentially" leaves room for the departures on the escape cards.
- "Essentially" is his word; the departures are on [[rule:no-interpolation]], [[rule:double-quote-escapes]] and [[rule:single-quote-escapes]].
- Open: two strings back to back (`:a "x""y"`), and a closing quote followed directly by letters (`:a "abc"def`).
- His worry about «string» being a distinct type from «text»: a reading option may present a text without embeds as a string ([[decision:representational-options]]).
