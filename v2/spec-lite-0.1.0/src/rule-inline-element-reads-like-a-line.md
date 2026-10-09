---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: text
per: [backslash-by-position, embeds-are-pieces-of-text, line-ownership-main]
depends: [rule:line-scan, rule:text-value-end, rule:waiting-label, rule:leftover-values]
consequences: []
---

# Inside `|{…}`, the element's material reads like an element's line

*What follows an inline element's name, up to its closing `}`, is read by the same rules as the material on an element's line.*

## Statement

Inside an inline element `|{name …}`, the material between the name and the closing `}` MUST be read as the material on an element's line is read ([[rule:line-scan]]), so text left over after a finished value is the element's `$main`.

## Grounds

- Joseph, 2026-10-09, reading three link spellings by "rules already well established":

  > |{a :href "/" Home}  will do what the user hopes (Home is $main which by default is first child)
  > |{a :href / \ Home}  same
  > |{a :href / Home}    keep as an example to watch for and avoid.
- His idiom from 2026-10-08/09: `|p See |{a :href /docs \ the docs}` ([[decision:backslash-by-position]]).

## Epistemic status

The three spellings are Joseph's readings. The Statement is the agent's general form of them: one scan for element lines ([[rule:line-scan]]) applied inside the braces. What else an inline element's inside may hold (deeper structure, line breaks) is not discussed yet.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|p See |{a :href "/" Home} or |{a :href / \ Home}.
```
````tree
root
  |p
    :$main ‹See |{a :href "/" :$main ‹Home›} or |{a :href ‹/› :$main ‹Home›}.›
````
The quoted value ends at its closing quote, and the framed ` \ ` ends the unquoted one ([[rule:text-value-end]]); either way `Home` is left over and goes to `$main` ([[rule:leftover-values]]). A reader that presents `$main` as the first child sees the link text there ([[def:reading-option]]).

**Watch for and avoid:** `|{a :href / Home}` gives `href` the text `/ Home` and the link no text. Nothing ends the unquoted value before `}`, so it runs there.

## Working notes

- The same holds on a line: `|nav :aria-label Site |a :href / \ Home` is Joseph's spelling (2026-10-09).
- The spaces around the `\` are frame, not content ([[rule:text-value-end]]).
- Consequence: `|{em hi}` and `|em hi` both put `hi` in `$main`, so item 11 of the 2026-10-09 list (do they differ?) appears to dissolve. Embed interiors as a topic remain to be discussed (Joseph, 2026-10-09: "we haven't discussed embed interiors yet").
- Written 2026-10-09 while only partly oriented after a context compaction. Joseph, same day: "partial orientation will also cause you to generalize incorrectly and assert new rules that should be obvious derivations of existing conventions and rules." Check whether this is its own rule or a derivation of existing ones before relying on it.
