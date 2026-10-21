---
kind: rule
awaiting-second: true
awaiting-decision: true
needs-work: false
layer: value
strength: provisional
context: rule-unquoted-run-is-one-value.context.md
per: []
depends: [def:text, def:string, def:delimited-string, rule:text-value-end, rule:embeds-in-text, rule:framed-backslash-frame, rule:space-before-text-end]
consequences: [rule:leftover-values, rule:attribute-with-no-value-takes-next-value, rule:backslash-empty-text, rule:value-line-escapes, def:value, def:typed-value]
---

# An unquoted run is one value

*When a value is expected and the material has no delimiter of its own, the value is the whole unquoted run up to the next start, the framed backslash or the end of the line; it is typed by spelling only when the entire run spells a number, `true`, `false` or `nil`, and otherwise it is a «text».*

## Statement

1. On an element's or attribute's line, where a value is expected and the material does not begin with a delimiter (`"`, `'`, `<`, `[`) or a start, the value MUST be the unquoted run: every character up to the first of a space followed by a start, a framed ` \ `, or the end of the line. An embed inside the run is a piece of it and never ends it.
2. The run MUST be read as one value. It is a number, `true`, `false` or `nil` only when the whole run spells one; otherwise it is a «text».
3. Since the run reaches the next start, the attribute (or `$main`) that took it has nothing further on that line.

## Grounds

Joseph's restatement, 2026-10-21, of a proposal made the same day; written up for an impact review before any decision. See the [context](rule-unquoted-run-is-one-value.context.md) file. Serves [[prin:simplest-grammar-without-surprise]]: one sentence covers every line below, and typing a run's *first word* (what the cards implied) is what made `:title 1984 is a novel` give `title` the number 1984.

## Implications

- `:count 7` is a number; `:count 7 apples` is the text `7 apples`; `:count 7apples` is a text, not an error.
- `:title 1984 is a novel` is one text, which is what its writer meant. To give an attribute a number and the element the rest, end the run: `:count 7 \ apples` (`count` 7, `$main ‹apples›`).
- `|el :c 1 z` and `:c 1 z` on its own line give the same tree (`c ‹1 z›`), so "pretend each sameline part is on its own line" holds for values as it does for elements.
- A run that *starts* with a start character is not a run (it is that construct); a run never contains ` |name`, ` :name`, ` ; `, a fence opener or ` \ ` unescaped.

## Explanation

*(Teaching; adds nothing to the Statement. Trees in the cards' current notation.)*

```udon
|book :title War and Peace :year 1869
|book :title 1984 is a novel
|item :count 7 apples :price 9.99 USD
|el :alpha true story
|el :c 1 z
|el :c 1 \ z
|q "hello," she said
```
````tree
root
  |book
    :title ‹War and Peace›
    :year 1869
  |book
    :title ‹1984 is a novel›
  |item
    :count ‹7 apples›
    :price ‹9.99 USD›
  |el
    :alpha ‹true story›
  |el
    :c ‹1 z›
  |el
    :c 1
    :$main ‹z›
  |q
    :$main "hello,"
    :$main ‹she said›
````

## Working notes

- **Joseph, 2026-10-21, after the impact review: a branch to explore, "not an adjudication, decision, or even a lean yet".** The lookahead budget: "Originally the idea was that udon could stream / parse a document with no more than ~4 character lookahead (and between 0-1 lookahead for the vast majority of udon)." This rule needs the whole run to type it. First-character commitment errors on units ("in notation there are units all the time-- 920px 920MB"). His third option, **always text except typed**: bare material is text; `<…>` is the explicit typing, and inside it "only allow bare nil, booleans, numeric in all their complexity (see the older udon numeric syntax) (now we *can* commit/error) and an explicit text delimiter"; `<uint32|0x992BC>` is "error- reserved for now". His examples: `|p :held <nil>`, `|q :hold <901.2>`, `|r :some 9 - 13>2? yes?.... ; finally ended the text...`, `|s :more-text <"this is \n\t\t something … required \" or ' even though inside the <> in order to be explicitly typed">`. Open in his statement: whether a bare run that exactly spells `nil`, `true`, `false` or a number is still typed, or only inside `<…>`. Compare the three options on the same lines (in the verbatim record, 2026-10-21).
- **Gotcha (Joseph, 2026-10-21, expected behavior):** `:width 7 ;{px}` is a text, `:height 7 ; px` a number; see [[rule:inline-comments]].
- **Trimming (Joseph, 2026-10-21):** a bare value is trimmed on both sides; trailing whitespace of any kind is ornament unless kept with ` \ ` or the value is quoted ([[rule:space-before-text-end]]).
- **`$main` after a framed backslash (Joseph, 2026-10-21):** `|el asdf \ ghijk` is `$main` stacked, `['asdf', 'ghijk']`. That answers §1.2 of the impact review for `$main`; the attribute-line case (`:x one \ two`) is still the residue.
- **The pipeline he named (2026-10-21):** "udon -> stream/wire -> full-ast -> logical-ast -> API", the logical AST "collapsing equivalences", e.g. `(value (type-delimited (string (raw 'asdf'))))` reducing to `(value (string (raw 'asdf')))`. Bears on [[decision:representational-options]] and [[def:tree]].
- **The residue this rule does not decide:** a value that ends itself (a «delimited-string», `<…>`, a list, an element) followed by more bare material on the same line (`:a "x" y`, `:a [1 2] y`, `:a <x> y`). Joseph's lean (2026-10-21): the attribute closes after its first value, so `y` is `$main` on an element's line; on an attribute's own line [[rule:leftover-values]] stacks it. Not decided here.
- **What this changes elsewhere, if adopted:** [[rule:leftover-values]]'s "a further value on the line" can only follow a self-ending value; the `rule:bare-typing` gap's boundary is "the whole run"; [[rule:value-line-escapes]] loses one of its reasons (escaping a leading digit), keeping the others (`\:`, `\|`, `\@`, `\!`, `\;`, `` \` ``); the de novo audit's probes 4.1 and 4.2 (`.int/peg-audit-2026-10-21.md`) dissolve; the PEG's `number <- NUMBER &BOUND` becomes `NUMBER &text-end`.
- **Open with it:** a run inside `|{…}` (the interior is undesigned); a run inside a key (`[1 z]`: a text, by the same sentence?); whether `:a 1  z` (two spaces) is still one run (yes by [[rule:space-before-text-end]]'s logic: the spaces are inside, since the next thing continues the text).
