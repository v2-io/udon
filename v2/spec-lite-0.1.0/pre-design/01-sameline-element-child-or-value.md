# 01 — `|a |b` on one line: is `b` a child of `a`, or `a`'s value?

## The question

When a second `|element` appears on the same line as an element, is it a **child** of the first element, or the first element's **`$main` value** (a node used as a value)?

## Why lite must decide

The texts say both. Every lite parser has to pick one.

- **0.10.0 §2.1:** "Elements introduced later on the same line occupy their true columns: `|a |b |c` is equivalent, for all hierarchy purposes, to the same elements on successive lines at those columns." That makes them children.
- **0.10.0 §6.4 and §6.10:** block-form `|name` is a "self-announcing value" at a value-expected position. On an element's own line, "self-announcing values become `$main` values." That makes `b` a value.
- For **attributes**, the value reading is ruled and uncontested: `:x |em hi` makes the `em` element the value of `x`.
- For **brace forms**, stacking is ruled (K9): `|el |{a} |{b}` gives two `$main` values.

## Alternatives

### A — a block-form element on the element's line is a child

```udon
|a |b |c
```
```text
document
└ element a
    └ element b
        └ element c
```

```udon
|ul |li one
|p Intro text |em emphasized
```
```text
document
├ element ul
│   └ element li
│       $main "one"
└ element p
    $main "Intro text"
    └ element em
        $main "emphasized"
```

Brace forms stay values: `|el |{a} |{b}` → `$main` = `[inline a, inline b]`.

### B — it is a `$main` value (the node is the value)

```udon
|a |b |c
```
```text
document
└ element a
    $main element b
            $main element c
```

The same element is a value on its own line and would be a child if written on the next line:

```udon
|a |b          ; b is a's $main value
|a
  |b           ; b is a's child
```

### C — child, except directly after an open `:label` (where it is that label's value)

This is A plus the ruled attribute case, stated as one rule: "an element opened where an attribute is waiting for its value is that value; otherwise it is a child."

```udon
|api :headers |header :k v
|a :x 1 |b
```
```text
document
├ element api
│   headers element header
│             k "v"
└ element a
    x 1
    └ element b
```

## What follows the line

Under A and C, a following deeper line is placed purely by column. Under B, it is unclear which node owns it:

```udon
|a |b
     |c        ; column 5 — deeper than b's column (3)
```

- Under A/C: `c` is a child of `b`.
- Under B: `c` is either a child of `b`, the value node, or a child of `a`.

## Interactions

- [02](02-escape-inside-open-value.md): how an open value ends.
- [13](13-ast-shape.md): where `$main` lives in the tree.
- 0.10.0 §6.8, "the one-way door": once `|b` opens on a line, the rest of the line is `b`'s.
- `JOSEPH-FOR-0.10.01-FIX.md` example 2 reads `|a :x 1 |b :y 2 |c` as nested children.
