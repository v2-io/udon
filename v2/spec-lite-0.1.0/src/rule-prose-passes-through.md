---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [prose-backslash-and-embeds, backslash-by-position, framed-comments-on-node-lines]
depends: [rule:line-start-escape, rule:embeds-in-text, rule:prose-escaped-embeds]
consequences: [rule:text-lines-join, rule:semicolon-in-text]
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
```
```tree
root
  |p
    ‹Roses are red, \
    Keep calm ; carry on.
    Tables | like | this, and *Markdown*.›
```

## Grounds

- [[decision:prose-backslash-and-embeds]] (Joseph, "Agreed, 100%, ruled"): "within prose, those are the only behaviors we specify other than the indent/dedent stuff".
- [[decision:backslash-by-position]]: in prose that has started, `\` "is just passed through like everything else except embeds", so a Markdown hard break (`foo\`, `foo \`) survives.
- [[decision:framed-comments-on-node-lines]]: a ` ; ` inside a line of text is text ([[rule:semicolon-in-text]]).

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > 3. Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 650)

- **Why it matters** (the drafter's reasoning): Prose is where Markdown lives, so lite specifies as little there as it can; every rule added to prose is a collision with some Markdown author.

- Line-start structure (`|name`, `:label`, a `;` comment line, a fence) and reserved line starts ([[rule:prose-line-start-reserved]]) are decided before a line becomes prose, so they are not exceptions to this card (the drafter's reading of Joseph's "if memory serves").
- The tree prints a multi-line text one transcript line per source line, which the notation hasn't settled ([[rule:tree-transcript]]).
