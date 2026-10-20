---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: value
strength: lean
context: rule-adjacent-quoted-strings.context.md
per: [leans-are-working-spec]
depends: [def:delimited-string, rule:strings-like-ruby, rule:leftover-values, rule:list-items-whitespace-separated]
consequences: []
---

# Two «delimited-string»s with nothing between them are two values, with a warning

*`"x""y"` is two values, not one string and not an error; the parser warns.*

## Statement

Two «delimited-string»s written with nothing between them MUST be read as two values, and the parser MUST report a default-on «warning».

## Grounds

Follows from the value rules: a closing quote ends its «delimited-string», and what follows is the next value ([[rule:leftover-values]], [[rule:list-items-whitespace-separated]]). The warning is a lean; see the [context](rule-adjacent-quoted-strings.context.md) file. Revisit as needed.

## Implications

- The usual way to get `"x""y"` by accident is an unescaped quote inside a string: `"say "hi" now"` silently becomes three values. The warning catches it; write `"say \"hi\" now"` or `'say "hi" now'`.
- A warning fixes the reading: `"x""y"` is two values in lite, not something left open for a later version.

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
Warnings at 1:13 and 2:10: two delimited strings with no space between them. On an element's line the second value goes to `$main`, as in `|el :a "x" "y"`.

## Working notes

- Not discussed: a closing quote followed directly by an unquoted word (`:a "abc"def`). By the same rules it is the «delimited-string» `"abc"` then the «text» `def`; whether it warns too is open.
