---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: tree
per: [nil-only]
depends: []
consequences: []
---

# `nil` is the only spelling of nil

*`null` is not typed.*

## Statement

`nil` standing alone as a value MUST be nil; `null` MUST NOT be read as nil.

## Grounds

- Joseph, 2026-10-09: "let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically" ([[decision:nil-only]]).

## Epistemic status

Decided for this version ([[decision:decided-for-this-version]]).

## Explanation

```udon
|el :a nil
```
````tree
root
  |el
    :a nil
````

## Working notes

- Joseph's words (2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter.
- Consequence: a bare `null` is text unless reserved; whether to reserve it is open.
- Open with Joseph: whether a bare `null` is an error that points to `nil`, or text.
- The rest of the typed set (integers, floats, `true`, `false`) is [[rule:bare-typing]], not yet written; Joseph called it "pretty stable" (2026-10-08).
