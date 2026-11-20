---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: []
depends: [rule:text-value-end, rule:embeds-in-text]
consequences: []
---

# Inside `|{…}`, an unquoted value ends as on an element's line, or at the `}`

*Inside an inline element, an unquoted attribute value ends where it would on an element's line, and the closing `}` also ends it.*

## Statement

Inside an inline element `|{…}`, an unquoted attribute value MUST end where it would on an element's line ([[rule:text-value-end]]), or at the closing `}`.

## Grounds

- Joseph, 2026-10-09, reading three link spellings by "rules already well established":

  > |{a :href "/" Home}  will do what the user hopes (Home is $main which by default is first child)
  > |{a :href / \ Home}  same
  > |{a :href / Home}    keep as an example to watch for and avoid.
- His idiom from 2026-10-08/09: `|p See |{a :href /docs \ the docs}` ([[rule:text-value-end]]).
- Joseph's ruling R2, 2026-07-16 (`spec/msc/CHANGELOG.md`, "R2 embedded = element-rooted sameline (+`}`)").

## Epistemic status

Joseph's reading. Embeds as a whole are not designed yet (Joseph, 2026-10-09: "we haven't correctly designed embeds yet or thought through the issues fully").

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|p See |{a :href "/" Home} or |{a :href / \ Home}.
|p See |{a :href / Home}.
```
````tree
root
  |p
    :$main ‹See |{a :href "/" ‹Home›} or |{a :href ‹/› ‹Home›}.›
  |p
    :$main ‹See |{a :href ‹/ Home›}.›
````
In the first two, `href` ends at the closing quote or the framed ` \ `, and `Home` is left over. **Where `Home` goes inside the braces (`$main`, or the inline element's own text) waits for the embeds discussion**; the tree shows it unplaced.

**Watch for and avoid:** `|{a :href / Home}` gives `href` the text `/ Home` and the link no text. Nothing ends the unquoted value before `}`.

## Working notes

- Joseph, 2026-10-09: "*we still haven't discussed $main applying everywhere, braces included -- please stop assuming it's a rule until embeds have been discussed -- what I was correcting earlier was the *incorrect* assumptions about `|p |a :href / Home` being correct whether here or in braces. I *think* that means it will mean $main is standard, but don't know yet*". The card earlier stated `$main` as the rule; that is withdrawn.
- 0.10.0 §5.6 said "the `$main` sugar does not apply inside braces"; Joseph (2026-10-09): "a (poorly reasoned) decision by an agent, not my decision (that I remember- if it was, it was poorly reasoned by me)."
- The same value ending holds on a line: `|nav :aria-label Site |a :href / \ Home` is Joseph's spelling (2026-10-09).
- Still to discuss under embeds: where left-over text goes inside braces; line breaks inside `|{…}` (not ruled either way; 0.10.0 had them multi-line); nested inline forms; `;{…}` inside braces.
