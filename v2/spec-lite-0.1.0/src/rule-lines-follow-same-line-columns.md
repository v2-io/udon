---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: [sameline-element-is-child]
depends: [rule:same-line-element-is-child]
consequences: []
---

# Following lines see same-line elements as if written vertically

*Lines after a line with same-line elements are placed exactly as if each of those elements had begun its own line at its column.*

## Statement

The lines that follow MUST be placed against the columns of a line's same-line elements exactly as if each had been written on a line of its own at that column.

## Grounds

- [[decision:sameline-element-is-child]]; Joseph's teaching rule (2026-07-28): "just pretend the same-line part has each of its parts on consecutive new lines".

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

## Working notes

- **Joseph's words** (2026-07-28, quoted in `.int/pre-design/01-sameline-element-child-or-value.discussion.md`):
  > "If confused about which thing the indented line is child of-- just pretend the same-line part has each of its parts on consecutive new lines"
