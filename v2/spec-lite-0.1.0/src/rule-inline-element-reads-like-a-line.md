---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:line-scan, rule:text-value-end, rule:waiting-label, rule:leftover-values, rule:embeds-in-text]
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
- His idiom from 2026-10-08/09: `|p See |{a :href /docs \ the docs}` ([[rule:text-value-end]]).
- Joseph's ruling R2, 2026-07-16 (`spec/msc/CHANGELOG.md`, "R2 embedded = element-rooted sameline (+`}`)"): inside braces the material reads as on an element's own line, with `}` as one more terminator. The Statement is R2 carried into lite.

## Epistemic status

Joseph's reading for now (R2 plus his three readings of 2026-10-09). Embeds as a whole are not designed yet (Joseph, 2026-10-09: "we haven't correctly designed embeds yet or thought through the issues fully"), so this card is provisional until that discussion.

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
- Consequence: `|{em hi}` and `|em hi` both put `hi` in `$main`.
- Where lite differs from 0.10.0: 0.10.0 §5.6 said "the `$main` sugar does not apply inside braces" and §6.6 sent material left over inside braces to "the inline element's interior content". Lite puts it in `$main`, as everywhere else ("*text children* -- never", Joseph 2026-10-09). Joseph on that 0.10.0 sentence (2026-10-09): "a (poorly reasoned) decision by an agent, not my decision (that I remember- if it was, it was poorly reasoned by me)."
- Still to discuss under embed interiors (Joseph, 2026-10-09: "we haven't discussed embed interiors yet"): line breaks inside `|{…}` (0.10.0 settled them multi-line), nested inline forms, `;{…}` inside braces.
