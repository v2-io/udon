---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: tree
per: [reserved-line-starts-in-prose]
depends: [rule:prose-line-start-reserved]
consequences: []
---

# `!word` in the middle of a prose line is text

*Only the start of a prose line reserves `!word`.*

## Statement

`!` followed by a word in the middle of a prose line MUST be read as text.

## Grounds

- Joseph, 2026-10-09, on "`!word` in the middle of a prose line (`![img](x)`, `!=`) is plain text, just as mid-line `@joseph` is": "correct".

## Epistemic status

Decided for this version.

## Explanation

```udon
|p
  See ![the chart](chart.png) and note that a != b.
```
````tree
root
  |p
    ‹See ![the chart](chart.png) and note that a != b.›
````

## Working notes

- `!{` is reserved anywhere it would open, prose included ([[rule:reserved-spellings]]); this card is about `!` followed by anything else.
- Reasoning (agent's): Markdown images and ordinary punctuation use `!` mid-line; the line start is where a directive would be read.
- Written 2026-10-09 while only partly oriented after a context compaction. Joseph, same day: "partial orientation will also cause you to generalize incorrectly and assert new rules that should be obvious derivations of existing conventions and rules." Check whether this is its own rule or a derivation of existing ones before relying on it.
