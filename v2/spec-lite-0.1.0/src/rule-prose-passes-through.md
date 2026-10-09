---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:line-start-escape, rule:embeds-in-text, rule:prose-escaped-embeds, rule:framed-comments, rule:prose-line-start-reserved, rule:text-value-end]
consequences: [rule:text-lines-join, rule:escaped-reserved-is-text, rule:line-start-escape, rule:prose-escaped-embeds]
test-fixtures: []
---

# Prose passes through

*In a prose line, everything other than a leading `\`, embedded forms and escaped embedded forms passes through as written.*

## Statement

Every character of a prose line other than a leading `\` ([[rule:line-start-escape]]), an embedded form ([[rule:embeds-in-text]]) or an escaped embedded form ([[rule:prose-escaped-embeds]]) MUST pass through into the text as written.

```udon
|p
  Roses are red, \
  Keep calm ; carry on.
  Tables | like | this, and *Markdown*.
  email me @joseph, see ![the chart](c.png), or @{faq}.
```
```tree
root
  |p
    ‹Roses are red, \
    Keep calm ; carry on.
    Tables | like | this, and *Markdown*.
    email me @joseph, see ![the chart](c.png), or @{faq}.›
```

Consequences, not separate rules: a ` ; ` partway along a prose line is text; `@name` and `!word` in the middle of a prose line are text (`@{faq}` is still a reference, being an embed). Only line starts are decided differently ([[rule:prose-line-start-reserved]]).

## Grounds

- Joseph, "Agreed, 100%, ruled" (Discussion below): "within prose, those are the only behaviors we specify other than the indent/dedent stuff".
- [[rule:text-value-end]]: in prose that has started, `\` "is just passed through like everything else except embeds", so a Markdown hard break (`foo\`, `foo \`) survives.
- [[rule:framed-comments]]: Joseph, 2026-10-08, "(d) passed through" for `Keep calm ; carry on.`
- [[rule:prose-line-start-reserved]]: Joseph, 2026-10-08, "(c) passed through + reference" for `email me @joseph or see @{faq}.`; on 2026-10-09, "correct" to `!word` mid-line being text.

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Discussion

*Carried 2026-10-09 from the decision record `adr/prose-backslash-and-embeds.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-09.*

**Context.** [[rule:text-value-end]] left open what `\|{` does in prose. The agent asked, leaning toward "makes the embedded form literal". Joseph ruled it, and stated the whole of what lite specifies inside prose.

**Options considered.**

* Only one option was on the table (the agent's lean, which he ruled).

**Drivers.**

* Prose should carry as few rules as possible. (**inferred, unconfirmed** as his driver: the agent's reading of "those are the only behaviors we specify".)

**How firm.** His words: "Agreed, 100%, ruled". His own call, so `steward`. Decided for this version ([[decision:decided-for-this-version]]).

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 3. Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 650)

- **Why it matters** (the drafter's reasoning): Prose is where Markdown lives, so lite specifies as little there as it can; every rule added to prose is a collision with some Markdown author.

- Line-start structure (`|name`, `:label`, a `;` comment line, a fence) and reserved line starts ([[rule:prose-line-start-reserved]]) are decided before a line becomes prose, so they are not exceptions to this card (the drafter's reading of Joseph's "if memory serves").
- The tree prints a multi-line text one transcript line per source line, which the notation hasn't settled ([[rule:tree-transcript]]).
- Folded in 2026-10-09: the cards `rule-semicolon-in-text`, `rule-at-name-mid-prose` and `rule-bang-word-mid-prose` stated consequences of this card as rules of their own. Joseph, 2026-10-09: "partial orientation will also cause you to generalize incorrectly and assert new rules that should be obvious derivations of existing conventions and rules."
- History behind the ` ; ` case: 0.10.0 §2.2 allowed a framed ` ; ` comment inside text-space lines; `.int/history-semicolon-in-text-2026-10-08.md` found no rationale for that and traced it to drift. Lite's rule restores the earlier one (comments in prose are `;{…}`).
- Row notes on table rows are written with `;{…}` ([[rule:inline-comments]]).
