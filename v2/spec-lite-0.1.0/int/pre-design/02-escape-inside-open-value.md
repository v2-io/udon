# 02 — An escaped character in the middle of a value: does it join the value?

## The question

In `:a hello \:-) how are you?`, the `\` stops ` :-)` from opening a new attribute. Does the escaped material, and the text after it, **continue `a`'s value**, or does it **start the element's `$main` text**?

## Background

K13 split `\` into two operations:

- **Attached `\X`** escapes one character.
- **Framed ` \ `** (spaces around it) means "the rest of this line is plain text."

K10 says an unquoted value ends at a space followed by a real marker (`:label`, `|name`, …), a framed ` ; `, a framed ` \ `, or end of line. 0.10.0 §6.4 states the "joins" reading, flagged as an open lean (working-notes Q8; for-joseph D3).

## Alternatives

### A — escaped material joins the open value

```udon
|element :attribute hello \:-) how are you?
```
```text
document
└ element element
    attribute "hello :-) how are you?"
```

To break out into `$main`, use the framed form:

```udon
|element :attribute hello \ :-) how are you?
```
```text
document
└ element element
    attribute "hello"
    $main ":-) how are you?"
```

### B — any escape after a value starts `$main`

```udon
|element :attribute hello \:-) how are you?
```
```text
document
└ element element
    attribute "hello"
    $main ":-) how are you?"
```

The framed form gives the same result. The attached and framed forms then differ only in whether later markers on the line stay live:

```udon
|el :a x \:-) y :b 2        ; B, attached: b is still an attribute
|el :a x \ :-) y :b 2       ; framed: ":b 2" is text
```

## More cases (true under both alternatives, for comparison)

```udon
|el :count \7 apples        ; count = "7 apples" (escaped digit: text, not a number)
|el :a \                    ; a = "" (kept empty string, no warning)
|el :hello \:value          ; hello = ":value"
```

## Interactions

- [05](05-values-across-lines.md) and [01](01-sameline-element-child-or-value.md): ownership on a line.
- The emoticon trade-off (0.10.0 §3 least-surprise note): ` :-)` on a same line opens an attribute unless escaped or quoted.
