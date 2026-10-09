---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [embeds-are-pieces-of-text, backslash-by-position]
depends: [rule:line-scan]
consequences: [rule:framed-backslash-frame, rule:embeds-in-text, rule:value-line-escapes, rule:backslash-empty-text, rule:framed-comments, rule:inline-element-reads-like-a-line]
---

# Same-line text ends at a block form

*On an element's or attribute's line, unquoted text runs until a block form or a framed ` \ `.*

## Statement

On an element's or attribute's line, unquoted text MUST end at the first of: a space followed by `|name`, a space followed by `:label`, a framed ` ; `, a framed ` \ `, or the end of the line.

## Grounds

- Joseph, 2026-10-08: "text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or :" ([[decision:embeds-are-pieces-of-text]]).
- Joseph, 2026-10-09: "We definitely still need backslash as our other 'text terminator'" ([[decision:backslash-by-position]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a x \ y :b 2
```
````tree
root
  |el
    :a ‹x›
    :$main ‹y›
    :b 2
````

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > I am under the impression that any embedded construct is meant to be embedded in text/string, and that *on sameline* text is always assumed to be non-delimited text which ends with a *block* form of ;, |, or : -- whereas embedded forms just stay part of the text
- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > We definitely still need backslash as our other "text terminator" in addition to the ones we said earlier-- hitting a new |... ;... or :... (block) construct. That is *different* (maybe significantly) than the previous iterations that treated [\] as the *beginning* of text. This is for sameline only I'm pretty sure.
- Reasoning (agent's): with embeds as pieces, nothing inside a text can end it except a block form or the framed backslash, so the end of same-line text is one rule.
- The spaces before whatever ends the text are not part of it ([[rule:space-before-text-end]]).
- Embedded forms don't end the text ([[rule:embeds-in-text]]).
