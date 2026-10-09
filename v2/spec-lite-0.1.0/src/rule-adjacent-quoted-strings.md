---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
per: []
depends: [rule:strings-like-ruby, rule:leftover-values, rule:list-items-whitespace-separated]
consequences: []
---

# Two quoted strings with nothing between them are two values, with a warning

*`"x""y"` is two values, not one string and not an error; the parser warns.*

## Statement

Two quoted strings written with nothing between them MUST be read as two values, and the parser MUST report a «warning».

## Grounds

- Joseph, 2026-10-09: "I kind of feel like "x""y" should, as you say, be two items, but also throw a warning. call it a lean for now." A lean.
- "Two items" is already 0.10.0's reading for lists (§11.5: "`["x"y]` and `["x""y]` are two items each"); a closing quote ends its string, and what follows is the next value ([[rule:leftover-values]]).

## Epistemic status

Joseph's lean, working spec.

## Explanation

```udon
|el :tags ["x""y"]
|el :a "x""y"
```
````tree
root
  |el
    :tags ["x" "y"]
  |el
    :a "x"
    :$main "y"
````
Warnings at 1:13 and 2:10: two quoted strings with no space between them.

On an element's line the second value goes to `$main`, by [[rule:leftover-values]], like `|el :a "x" "y"`.

## Working notes

- Why a warning (the agent's reading of his lean): the common way to get `"x""y"` by accident is an unescaped quote inside a string (`"say "hi" now"`), which this reading silently splits; the warning catches it.
- That the rule covers value slots as well as lists is the agent's reading of "two items" under one value grammar.
- Not discussed: a closing quote followed directly by an unquoted word (`:a "abc"def`). By the same rules it is the string `"abc"` then the text `def`; whether it warns too is open.
- A warning in lite fixes the reading for good (only errors leave a reading open for later), so "two values" is now the lite reading of `"x""y"`.
