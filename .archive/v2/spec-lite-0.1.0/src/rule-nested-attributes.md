---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: []
depends: []
consequences: [rule:reserved-spellings, rule:attribute-after-attribute-with-no-value]
---

# An attribute line owned by an attribute is an error

*An attribute can't have attributes.*

## Statement

An attribute line whose owner, by indentation, is an attribute MUST be an error.

## Grounds

- Joseph, 2026-10-08: "nested attributes right now should be a reserved construction that causes an error in lite"; "`:label`-under-open-attribute: error reserved construction".

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|db
  :port
    :nested 1
```
An error at 3:5: nested attributes are reserved. The same holds wherever the attribute line sits in the attribute's body:

```udon
|db
  :note
    Primary only.
    :port 5432
```
An error at 4:5. An attribute line under an element inside the attribute's body belongs to that element and is fine:

```udon
|book
  :author
    |person
      :name Jane
```

## Discussion

*Carried 2026-10-09 from the decision record `adr/nested-attributes-reserved.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `steward`, 2026-10-08.*

**Context.** UDON has no attributes of attributes (K4). In 0.10.0 an attribute-shaped line directly under an open attribute value is kept as text of that value with a warning (K8), leaving the door open to a future grouping sugar (OPEN ATTR-GROUP). The agent asked whether it should be an error in lite.

```udon
|el
  :a
    :b 1        ; 0.10.0: text ":b 1\n" of a, with a warning
```

**Options considered.**

* Text of the open value, with a warning (0.10.0).
* A reserved construction: an error (chosen).

**Drivers.**

* Keep the construction free for later use (a reserved construction), rather than giving it a meaning now. (**inferred, unconfirmed**: the agent's reading of "reserved construction")

**How firm.** His words: "should be a reserved construction". His own call, so `steward`. Decided for this version, and revisitable if undiscovered confounding factors come up ([[decision:decided-for-this-version]]).

**Costs accepted.**

* A value body that genuinely starts with `:word` text must be written another way; whether a line-start `\` escape exists in lite is still open (82). (Since settled: first on a line, `\` is a consumed escape; [[rule:line-start-escape]].)

**Reopen when.**

* A meaning for nested attributes is designed.

## Working notes

- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > Right-- nested attributes right now should be a reserved construction that causes an error in lite.
- Joseph's words (2026-10-08, `.int/STEWARD-VERBATIM.md`):

  > :label-under-open-attribute:  error reserved construction
- Scope follows from nesting: a line's owner is the node it sits under, so any attribute line an attribute owns is covered, wherever in the body it sits. The card used to say "directly under", which read as if the scope were open; Joseph, 2026-10-09: "I don't understand what is still open vs everything already [ruled]". Nothing was open.
