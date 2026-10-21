---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: false
layer: tree
per: []
depends: [rule:text-value-end]
consequences: []
---

# Spaces before the end of a text are not content

*Spaces between text and whatever ends it are frame, not part of the text.*

## Statement

Spaces that come after a text's last character and before whatever ends the text MUST NOT be part of the text.

## Grounds

- Joseph, 2026-10-09, confirming that `:a x :b 1` gives `a` the text `x`: "correct-- from a scanning perspective, as text components accumulate, whitespace is considered ornamental but turns into content if the next thing continues as part of the text. If the next thing instead stops the text (including '\'), it was just delimiter+ornamental."

## Epistemic status

Decided for this version.

## Explanation

```udon
|el :a x   :b 1
|el :c one  two \ more
```
````tree
root
  |el
    :a ‹x›
    :b 1
  |el
    :c ‹one  two›
    :$main ‹more›
````
The two spaces inside `one  two` are content, because `two` continues the text. The spaces before ` :b` and ` \` are not, because what follows ends the text.

## Working notes

- **Joseph, 2026-10-21, on trailing and boundary whitespace of any kind:** "trailing whitespace and term boundary whitespace needs ' \\ ' or to be delimited in \"...\" in the first place or else it counts as ornamentation-- otherwise we have problems all over the spec"; "bare \"text\" values (or whatever they're named) will always be trimmed on both sides, except where an explicit \"finished with text\" backslash keeps the ending ws." Two things to reconcile: (1) this card and [[rule:whitespace-after-last-marker]] disagree about a trailing TAB or U+00A0 (content there, ornament here); his 2026-10-21 words make every kind of trailing whitespace ornament. (2) "the backslash keeps the ending ws" sits against his 2026-10-09 words this card rests on ("If the next thing instead stops the text (including '\\'), it was just delimiter+ornamental"): is `:a x   \\` the text `x` or `x   `? To ask with that example.
- Joseph's words are the rule's scanning form: hold spaces aside as they come; they become content when the text continues and fall away when it stops.
- Its own rule, not a derivation: 0.10.0 says nothing about spaces before a terminator (pre-design 80 searched and found nothing), so Joseph's answer is new law.
