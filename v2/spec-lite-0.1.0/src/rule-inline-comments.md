---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [inline-comments-in-prose, embeds-are-pieces-of-text]
depends: [rule:embeds-in-text, rule:opaque-span-raw-text]
consequences: [rule:comments-in-tree]
test-fixtures: []
---

# `;{…}` is a comment piece of text

*In text, `;{…}` is a comment piece.*

## Statement

In text, `;{…}` MUST be a comment piece of that text ([[rule:embeds-in-text]], [[rule:opaque-span-raw-text]]).

```udon
|p
  Second line ;{todo} here.
```
```tree
root
  |p
    ‹Second line ;{todo} here.›
```

## Grounds

- [[decision:inline-comments-in-prose]]: `;{…}` comments "*will* be available in prose".
- [[decision:embeds-are-pieces-of-text]]: embedded forms are pieces of text; "comments show up in the AST".

## Epistemic status

A rule, resting on the decisions in `per`. No fixtures yet.

## Working notes

- **Joseph's words** (copied with the file's bracketed corrections):

  > Give me the full #2 again if you would. I'll give my thoughts on that one and then you can give me the next one (and so on) when you're satisfied we see eye to eye on the current one. The one thing that might be open for #1 is that note about 0.10.0 -- would you launch an agent to dig deep and find out what if any rationale there was behind the comment being available to prose lines.  OHH, btw-- I *do* think ;{...} comments, with essentially opaque spans [in between] with the same escape rules (matched {} and \ escape-all) as the others-- which *will* be available in prose. (strong lean unless someone has a reason it conflicts with something that is likely)
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 300)

  > I am very comfortable having embeds always be a distinct chunk of distinct text as if it were a word for right now, yes. Don't forget comments show up in the AST-- actually, before we go any further, would you propose or have an agent look at everything and propose a quick syntax/notation for expressing the AST here in chat and in the spec and in the fixtures (all the same ideally if it's elegant enough, but with big or minor differences acceptable if necessary).
  >
  > — Joseph (`.int/STEWARD-VERBATIM.md`, line 581)

- **Why it matters** (the drafter's reasoning): It is how a note is attached to a line of prose, such as a table row, now that ` ; ` in prose is text.

- Whether the spaces around `;{…}` are content (shown kept as text) was not discussed (59).
