# 05 — Can quoted strings and `[…]` lists continue onto the next line?

## The question

A quoted string or a `[…]` list is opened and not closed before the end of the line. Does it **continue** to its closing `"` or `]`, **close at the end of the line** with a warning, or is it an **error**?

## Background

- **0.10.0 §13.2:** multi-line strings and lists are "deliberately not specified." It gives a reason: if lists and strings turn out to be shorthand for dialect-typed boxes, the box's own rules would decide, so the question should not be closed construct by construct (OPEN ML).
- **Old parser:** strings continue across lines; lists and `[key]` brackets close at end of line with a warning.
- **0.10.1-draft (misfire):** made lists span lines; its own audit found that a forgotten `]` then swallows the rest of the document.

For lite, the forward contract matters. If lite chooses "close at end of line" and a later version chooses "continue," any document that relied on the lite reading would change meaning. It is safe only if lite treats that document as not-valid-lite (see [12](12-missing-values-and-what-counts-as-valid.md)).

## Alternatives (strings and lists may be decided separately)

### A — both continue to their closer

```udon
|el :note "first line
second line" :tags [a b
c]
```
```text
document
└ element el
    note "first line\nsecond line"
    tags ["a" "b" "c"]
```

The accident case:

```udon
|el :tags [a b
|next
|more
```
```text
document
└ element el
    tags ["a" "b" "|next" "|more"]    ; + warning: unclosed list at end of input; result: incomplete-input
```

### B — both close at end of line, with a warning

```udon
|el :note "first line
second line"
```
```text
document
└ element el
    note "first line"               ; warning: unclosed string
    ├ text "second line\"\n"
```

### C — reserved in lite: an unclosed string or list at end of line is not valid lite (error; bytes kept as in B)

Lite stays silent on the question, so any future answer is compatible.

### D — strings continue; lists close at end of line (the old parser's behavior)

## Related: `[key]` brackets

0.10.0 closes an unclosed identity bracket at end of line, giving `$partial-key` plus a warning. That rule protects against editing accidents and is not contested. It is listed here for consistency.

## Interactions

- [07](07-untyped-angle-box.md): 0.10.0 settled that `<…>` does continue across lines.
- [10](10-inline-elements-and-inline-comments.md): 0.10.0 settled that `|{…}` continues across lines.
- [12](12-missing-values-and-what-counts-as-valid.md): what "valid lite" means.
