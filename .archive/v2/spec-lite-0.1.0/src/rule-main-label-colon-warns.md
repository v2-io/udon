---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: anomaly
strength: lean
per: [leans-are-working-spec]
depends: [rule:unquoted-run-is-one-value, rule:leftover-values, rule:warnings-can-be-toggled, rule:anomalies-suggest-a-fix]
consequences: []
---

# `$main` text that starts with `label: ` warns

*`|server host: localhost` is the text `host: localhost`; the parser warns and suggests `:host localhost`.*

## Statement

1. When an element's `$main` text begins with a bare label followed directly by `:` and a space, the parser MUST report a «warning», suggesting the attribute spelling (`:label value`).

## Grounds

Joseph, 2026-10-22: "Definitely let's add the $main text with colon-suffixed first-word warning". Writers trained on YAML and similar notations write `key: value`; without the warning it is silently `$main` text.

## Explanation

```udon
|server host: localhost
|li Note: keep it dry
```
````tree
root
  |server
    :$main ‹host: localhost›
  |li
    :$main ‹Note: keep it dry›
````
Both warn: "`host:` reads as text here; did you mean `:host localhost`?" The second is the common case where nothing is wrong.

## Working notes

- **Default-on or default-off:** not stated by Joseph. The agent proposed default-off (2026-10-22), since `|li Note: keep it dry` and `|h1 Chapter 3: The Return` are ordinary text and would warn under default-on.
- Only the first word of `$main` is checked; `|h1 Chapter 3: The Return` doesn't warn, because `3:` isn't first.
- Context: suffix colons as an attribute spelling (`|element first: 1 second: 2`) were Joseph's ideation and set aside the same day (verbatim record, 2026-10-22), because a `word: ` start would end any text holding one.
