---
kind: rule
awaiting-second: true
awaiting-decision: false
needs-work: true
layer: value
strength: lean
context: rule-unquoted-run-is-one-value.context.md
per: [leans-are-working-spec, representational-options]
depends: [def:text, def:string, def:delimited-string, rule:text-value-end, rule:embeds-in-text, rule:framed-backslash-frame, rule:space-before-text-end]
consequences: [rule:leftover-values, rule:attribute-with-no-value-takes-next-value, rule:backslash-empty-text, rule:value-line-escapes, rule:nil-spelling, rule:opaque-span-raw-text, def:value, def:typed-value, def:reading-option]
---

# An unquoted run is one «text»

*When a value is expected and the material has no delimiter of its own, the value is the whole unquoted run up to the next start, the framed backslash or the end of the line, and it is always a «text». Its spelling never gives it another kind: a number, `true`, `false` or `nil` is written in `<…>`. A view may read a run that spells one exactly as that value.*

## Statement

1. On an element's or attribute's line, where a value is expected and the material does not begin with a delimiter (`"`, `'`, `<`, `[`) or a start, the value MUST be the unquoted run: every character up to the first of a space followed by a start, a framed ` \ `, or the end of the line. An embed inside the run is a piece of it and never ends it.
2. The run MUST be one «text», whatever it spells. `8080`, `9.99`, `true` and `nil` written bare are «texts».
3. Since the run reaches the next start, the attribute (or `$main`) that took it has nothing further on that line.

## Grounds

Joseph's lean (2026-10-21); see the [context](rule-unquoted-run-is-one-value.context.md) file. A streaming parser knows every value's kind from its first character, so nothing has to be held back to type it; and a unit (`920px`) is never an error. Revisit as needed.

## Implications

- A number in a bare value is text until something reads it as a number: `:port 8080` is the text `8080`; `:port <8080>` is the number.
- `:size 920px`, `:count 7 apples` and `:title 1984 is a novel` are each one text; nothing on them is an error.
- `|el :c 1 z` and `:c 1 z` on its own line give the same tree (`c ‹1 z›`), so "pretend each sameline part is on its own line" holds for values as it does for elements.
- A run that *starts* with a start character is not a run (it is that construct); a run never contains ` |name`, ` :name`, ` ; `, a fence opener or ` \ ` unescaped.
- **The typed-primitive view** ([[def:reading-option]]): a consumer may read a «text» whose whole content is one run spelling exactly a number, `true`, `false` or `nil` as that value. Under it `:port 8080` reads as 8080; `:width 7 ;{px}` stays text (the inline comment is a piece, so the run is not exactly `7`), while `:height 7 ; px` reads as 7, because the framed comment is not part of the value.

## Explanation

*(Teaching; adds nothing to the Statement. Trees in the cards' current notation.)*

```udon
|book :title War and Peace :year 1869
|book :title 1984 is a novel :year <1949>
|item :count 7 apples :price <9.99> :size 920px
|el :c 1 z
|el :c 1 \ z
|q "hello," she said
```
````tree
root
  |book
    :title ‹War and Peace›
    :year ‹1869›
  |book
    :title ‹1984 is a novel›
    :year 1949
  |item
    :count ‹7 apples›
    :price 9.99
    :size ‹920px›
  |el
    :c ‹1 z›
  |el
    :c ‹1›
    :$main ‹z›
  |q
    :$main "hello,"
    :$main ‹she said›
````
Under the typed-primitive view, the first `:year` reads as 1869 and the last `:c` as 1.

## Working notes

- **Conflicts this lean opens, each to put to Joseph** (his earlier words are the other side of each):
  - [[rule:nil-spelling]]: "make 'nil' the only spelling for nil/null" (2026-10-09). Is the spelling now `<nil>`, with bare `nil` text that the view reads as nil? Does the bare-`null` warning stay, and does it point to `<nil>`?
  - [[rule:missing-value]]: the error message names `nil`, `''` and `\`; `nil` there would read as text unless the view is on.
  - [[rule:opaque-span-raw-text]] and the 2026-09-29 decision to carry `<…>` as raw text (`<2026-10-01>`): his 2026-10-20 option passes anything inside `<…>` that isn't a primitive or a delimited string "through raw"; his 2026-10-21 branch makes `<uint32|0x992BC>` "error- reserved for now". Is `<2026-10-01>` raw text, or an error?
  - Keys and lists read by the same value rules ([[rule:key-holds-a-value]], [[rule:list-items-whitespace-separated]]): `|step[1]` and `:tags [1 2]` then hold texts. Intended?
  - Whether the typed-primitive view is on by default, as the one-embed view is ("an aspiration … defaults to reducing it").
- **What else this changes:** the `rule:bare-typing` gap becomes "what may stand inside `<…>`"; [[rule:value-line-escapes]] loses one reason (escaping a leading digit so it "starts some text instead"); [[def:typed-value]]'s «implicit-typed-value» has no members left among unquoted values; the PEG's `number <- NUMBER &BOUND` leaves the bare-value production.
- **The residue this rule does not decide:** a value that ends itself (a «delimited-string», `<…>`, a list, an element) followed by more bare material on the same line (`:a "x" y`, `:a [1 2] y`, `:a <x> y`). Joseph's lean (2026-10-21): the attribute closes after its first value, so `y` is `$main` on an element's line; on an attribute's own line [[rule:leftover-values]] stacks it. `|el asdf \ ghijk` is `$main` stacked (Joseph, 2026-10-21); `:x one \ two` on an attribute's line is still open.
- **Trimming (Joseph, 2026-10-21):** a bare value is trimmed on both sides; trailing whitespace of any kind is ornament unless kept with ` \ ` or the value is quoted ([[rule:space-before-text-end]]).
- **Open:** whether a bare run with no embed is a «text» or a string of form bare (his 2026-10-20 sketch had `::string.bare`; his words since say "text"); a run inside `|{…}` (the interior is undesigned).
