---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: true
layer: element
per: []
depends: []
consequences: []
---

# Spaces may come before a trait (provisional)

*`|el .something` is the same as `|el.something`. So an unquoted name can't begin with `.`.*

## Statement

*Provisional (Joseph's lean, 2026-10-12).* A trait MAY be written after one or more spaces following an element's name, key or another trait, and MUST then be the same trait as when written directly after. An unquoted name MUST NOT begin with `.`: `|.asdf` is a nameless element with the trait `asdf`, and an element named `.asdf` is written `|'.asdf'`.

## Grounds

- Joseph, 2026-10-12: "I definitely lean toward allowing traits to be preceeded by a whitespace. I *think* the only ramification is that non-quoted labels (which we haven't adjudicated fully yet) wouldn't be allowed to have a '.' prefix. So |.asdf would not be allowed as an element name (it's an anonymous element with $traits=[asdf]), but (we'll get to it with labels) -- `|'.asdf'` would still be fine for an element with the name '.asdf'."

## Epistemic status

Provisional, pending a history search (Working notes).

## Explanation

```udon
|el .a .b :x 1
|.asdf
|'.asdf'
```
```tree
root
  |el
    :$traits a
    :$traits b
    :x 1
  |
    :$traits asdf
  |'.asdf'
```

## Working notes

- **To do (Joseph, 2026-10-12): launch a search of the history for any other reasoning about spaces before traits.** On hold until the topic comes up again (Joseph, same day: "Let's hold on the history-search until we get to that again"). Known so far:
  - mainline dropped the spaced form on 2026-07-15, in the fresh-eyes batch recorded as Joseph's rulings: "Spaced-trait identity form dropped: identity is contiguous except the trailing space-separated suffix; `.trait` after a space is prose" (`spec/msc/CHANGELOG.md`; `spec/CORE.md`: "`|p .gitignore is a file` has no traits; ruled 2026-07-15, dropping the former spaced-trait form `|name[key]? .trait`"). Its reason was tied to the spaced suffix, which lite retired ([[decision:suffixes-lose-special-status]]);
  - 2011 allowed it (`syntax2.udon`: `|namespace:type [id-or-name] .flag .other-flag`);
  - pre-design 77 Q2.
- **Scope, the coordinator's reading (not confirmed):** a spaced trait may come only right after the name, a key or another trait, before the first attribute or value. In `|el :x 1 .y` the `.y` is part of `x`'s text.
- **Cost:** an element line whose text starts with `.word` gets a trait: `|p .gitignore is a file` gives the trait `gitignore` and `$main ‹is a file›`. Writing it as text needs `\.gitignore`, so `.` would join the sameline escape set ([[rule:value-line-escapes]]).
- The same holds on a fence's opening line: ```` ```sh .exact ```` ([[rule:fence-opener-line]]).
- Not discussed: spaces before a key (`|el [k]`).
