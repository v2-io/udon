---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:line-scan, rule:waiting-label]
consequences: [rule:main-is-attribute, rule:inline-element-value-end, rule:adjacent-quoted-strings]
---

# Values left over on a line go to the line's owner

*On an element's line they are `$main` values; on an attribute's line they stack on the attribute.*

## Statement

After a value finishes, a further value on the line MUST be a `$main` value of the element on an element's line, and MUST stack on the attribute on an attribute's line.

## Grounds

- Joseph, 2026-09-29: "$main allows for fully consistent 'sameline' behavior whether the line started with an element or an attribute" ([[rule:line-scan]]; the two cases are the agent's rendering of 0.10.0 §6.5).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|q "hello," she said
|el
  :x "one" two
```
````tree
root
  |q
    :$main "hello,"
    :$main ‹she said›
  |el
    :x "one"
    :x ‹two›
````

## Working notes

- Joseph's words (2026-09-30T01:55Z, `.int/STEWARD-VERBATIM.md`):

  > I'll call this "attribute-sameline" and conjecture that $main allows for fully consistent "sameline" behavior whether the line started with an element or an attribute.
