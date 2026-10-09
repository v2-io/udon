---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: text
per: [backslash-by-position, embeds-are-pieces-of-text]
depends: [rule:text-value-end]
consequences: []
---

# Inside `|{…}`, a framed backslash ends an attribute value

*In an inline element, ` \ ` ends the current attribute's value and what follows is the element's interior text.*

## Statement

1. Inside an inline element `|{…}`, a framed ` \ ` MUST end the current attribute's value, and what follows it up to the closing `}` MUST be the inline element's interior text.

## Grounds

- Joseph's corrected link idiom, `|p See |{a :href /docs \ the docs}` (2026-10-09): [[decision:backslash-by-position]].

## Epistemic status

A rule, chosen, not derived. Checkable by fixtures.

## Explanation

*(Teaching; adds nothing to the Statement.)*

```udon
|p See |{a :href /docs \ the docs}.
```
```tree
root
  |p
    :$main ‹See |{a :href ‹/docs› ‹the docs›}.›
```

## Working notes

- **Joseph's words:**

  > We definitely still need backslash as our other "text terminator" in addition to the ones we said earlier-- hitting a new |... ;... or :... (block) construct. […] |nav :aria-label Site |a :href / \ Home  ; this would be the correct way I would think.
  > |p See |{a :href /docs \ the docs} ; and this for the other.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)
  > wrt " \ " spaces around it as frame-- I support that.
  >
  > — Joseph, 2026-10-08/09 (`.int/STEWARD-VERBATIM.md`)

- **Reasoning:** Gives the HTML link idiom a spelling: the value ends at the framed backslash and the rest is link text.
- Without the ` \ `, `href` takes everything to the `}` (`/docs the docs`) and the link has no text; whether that stays is pre-design 50, still open.
- The spaces around the `\` are frame, not content ([[rule:text-value-end]]).
