# 07 — The untyped `<…>` box: exact rules

## Settled (Joseph, 2026-09-29)

`<…>` is in lite as an **untyped box**. A lite parser finds where it ends and carries the raw text; no meaning is attached. Dates and times are not typed in lite; the existing temporal parser may be reattached at implementation time.

## Details to decide

### Q1 — Where does the box end?

0.10.0 §11.6: the matching `>`, depth-counted, so nested boxes parse.

```udon
|el :x <a <b> c> :y 1
```

- **A, depth-counted:** `x = box "a <b> c"`, `y = 1`.
- **B, first `>`:** `x = box "a <b"`, then ` c>` is text on the line.

What about a `>` that is plainly content?

```udon
|el :cond <x > 3>
```

Under both A and B, the box ends at the first `>`: `box "x "`, then ` 3>` follows as text.

### Q2 — Can a box continue onto the next line?

0.10.0 §11.6 says yes ("settled multi-line"), and an unclosed box at end of input is kept with a warning.

```udon
|el :span <2026-01-01
  /2026-06-30>
```

- **A, yes:** `span = box "2026-01-01\n  /2026-06-30"` (or with the indentation stripped?).
- **B, no:** closes at end of line with a warning.

### Q3 — What does the tree carry?

```udon
|el :size <u64:0xff> :when <2026-07-11> :span <temporal:interval:2026-01/2026-06>
```

**A — the whole raw text only**

```text
size box "u64:0xff"
when box "2026-07-11"
span box "temporal:interval:2026-01/2026-06"
```

**B — split the label ladder from the body**

The ladder is `<content>` → `<type:content>` → `<dialect:type:content>`.

```text
size box {type: "u64", body: "0xff"}
when box {body: "2026-07-11"}
span box {dialect: "temporal", type: "interval", body: "2026-01/2026-06"}
```

B needs a rule for when a `:` is a label separator:

```udon
|el :url <http://x.io> :t <10:30:00>
```

Under B, is `http` a type? Is `10` a type? Possible rules:
- A label must be an identifier.
- A label must be followed by `:` and no space.
- The ladder spelling is simply not decided yet, so lite carries only the raw text (that is A).

### Q4 — Empty box

`<>` and `< >`: an empty-string box, nil, or an error? (0.10.0: "a closed empty `<>` stays this interim string; the `< >` → nil collapse is a dialect-era refinement.")

### Q5 — Where may a box appear?

0.10.0: in value positions only — attribute values, `$main`, list items, `[key]` interiors. In prose, `<` is ordinary text (important for HTML-ish prose). Is that the whole rule for lite?

## Interactions

- [05](05-values-across-lines.md): lists containing boxes.
- [09](09-reserved-syntax.md): whether any `<…>` form is reserved rather than carried.
- [13](13-ast-shape.md): the box value in the tree.
