---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:sameline-element-is-child]
consequences: []
context: rule-lines-follow-sameline-columns.context.md
---

# Following lines see sameline elements as if written vertically

*Lines after a line with sameline elements are placed exactly as if each of those elements had begun its own line at its column.*

## Statement

The lines that follow MUST be placed against the columns of a line's sameline elements exactly as if each had been written on a line of its own at that column.

## Grounds

- [[rule:sameline-element-is-child]]; Joseph's teaching rule (2026-07-28): "just pretend the same-line part has each of its parts on consecutive new lines".

## Epistemic status

Chosen. No fixture yet.

## Explanation

```udon
|table |tr |td A1
           |td A2
```
```tree
root
  |table
    |tr
      |td
        :$main ‹A1›
      |td
        :$main ‹A2›
```

## Cautions

- **A child one column too far right silently gets a different parent.** With the example above, `|td A2` at column 12 instead of 11 is a child of the first `|td`, a cell inside a cell, and nothing warns; at column 10 it lands under `|tr` as intended. (Unlike Python, where an unexpected indent is an error, indenting under any element is legal in lite.) Judged a minor practical risk, not something to design around: agents edit through path-based tools that place indentation themselves, write indentation correctly when generating, and schemas refuse impossible nesting (a `td` inside a `td`). What's left is genuinely recursive structure, where only the writer knows the intent. See the [context](rule-lines-follow-sameline-columns.context.md) file.

## Working notes

- **Joseph's words** (2026-07-28, quoted in `.int/pre-design/01-sameline-element-child-or-value.discussion.md`):
  > "If confused about which thing the indented line is child of-- just pretend the same-line part has each of its parts on consecutive new lines"
