# 06 — The suffix characters `? ! * +` on elements

## Settled direction (Joseph, 2026-09-29)

The special status goes away. Joseph recalls the intent was to make these ordinary identity characters; that recollection is to be confirmed by the history pass. This file lays out what "no special status" could concretely mean.

## Current rule (0.10.0 §5.4)

A trailing `?` `!` `*` `+` on an element desugars to a designated attribute with value `true`:

- `|field?` → `|field :$? true`
- They stack: `|field?!` → `$? true` and `$! true`.
- Allowed positions: after the name, after the key, or space-separated at the end.

Related rules already in place:
- These characters are ordinary characters inside **traits** (`.foo?` is the trait `foo?`) and anywhere inside **attribute labels** (K12).
- They are **not** name-continue characters for element names.
- They are in the `|` guard, so `|?` opens an anonymous element.

The texts gloss them as intended for schema/grammar readings: `?` optional, `!` required, `*` zero-or-more, `+` one-or-more.

## Alternatives

### A — keep the sugar (0.10.0)

```udon
|field[name]?
```
```text
document
└ element field
    $key "name"
    $?   true
```

### B — they are ordinary characters of the element name (and of keys, as they already are of traits)

```udon
|field? :type string
|items* :of item
|el.bar?
```
```text
document
├ element field?
│   type "string"
├ element items*
│   of "item"
└ element el
    $traits "bar?"
```

Sub-questions under B:
- May they appear anywhere in a name (`|a?b`) or only at the end?
- What does `|field[name]?` mean — a suffix on a key is no longer a name character. Error, `$main "?"`, or not allowed?
- What does `|?` mean — an element whose name is `?`, or an anonymous element?
- What does a lone space-separated ` ?` mean — `$main "?"`?

### C — reserved in lite: a suffix character after an element's name or key is refused

Lite stays silent, and the full language decides later.

```udon
|field?
```
```text
document
└ reserved "|field?"          ; anomaly: error, reserved syntax
```

## Interactions

- [09](09-reserved-syntax.md): if C.
- [13](13-ast-shape.md): designated `$`-attributes.
- Reference cardinality ideas (`@tags*`) are future `@` syntax and out of lite, but they reuse these characters.
