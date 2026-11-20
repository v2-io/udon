# 73 — Is the text on an element's own line typed, like an attribute value, or plain text?

## The question

```udon
|price 42
|quote "hello," she said
|tags [a b]
|when <2026-07-11>
```

Is `42` the number 42 or the text "42"? Are the quotes in `"hello," she said` quote marks the reader sees, or a string delimiter? Does `[a b]` make a list?

## Why lite must decide

The element's own line is where most short content is written (`|li One`, `|title My Notes`, `|a :href /x Home`). The answer changes the tree for any line that happens to begin with a digit, a quote, `[`, or `<` — which ordinary prose often does ("3 apples", `"Quoted," she said`, `[draft] title`). File 13 Q3 asks where this text lives in the tree; this file asks what kind of value it is.

## What the texts say, in date order

- **2011** (`udon/.attic/syntax2.udon`): `|hi there` → element `hi`, children `['there']` — the rest of the line is child text.
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Prose Content, and `SPEC-INDENTS.md` §"Inline Content with Continuation"): the element's-line text is prose; lines below at a chosen indent **continue the same text** — `|later-part This stuff is inner…` followed by `            and, with a slightly different formatting` gives one text run.
- **2026-01-02, Joseph** (`~/.claude/history.jsonl` line 6973, layout as typed) wrote a block form and a one-line form of the same thing, the element-line word `About` in the place of an indented text line:
  ```text
                 |li.menu-item
                   |a :href /about
                     About

  |li.menu-item |a :href /about About
  ```
- **2026-01-13, Joseph** (`history.jsonl` line 7832): "Can anything that is represented in sameline form and inline form be implemented in pure block-like form? Or are there intrinsic differences in the underlying structure. And, if there are, *should* there be?"
- **Jan 2026, `design/udon-ast.md` §Text:** "`|p Some text with 42 in it` — The `42` in prose is text, not an integer. Syntactic typing only applies to attribute values."
- **2026-08-08, K9** (`v2/DECISIONS.md`; record `theory/to-integrate/primary/sameline-value-space-2026-08-08.md`): "All sameline prose is an attribute value — the only question is which attribute" (Joseph: "I like it more and more"). The element's own line is a **typed value position**: `"…"`, `<…>`, `[…]`, numbers become `$main` values and "return the scan", so `|element "here we go!" |child …` chains. "The accepted price (jaw ruled the posture): sameline prose can no longer *begin* with `"`/`<`/`[` innocently." Guidance: "sameline text is a scalar; starting a body of text, go next-line indented." Same record: "`|element <1234>` sameline = $main envelope; block-body `<9292>` = prose (elements' content never types)."
- **K9 dialogue idiom** (same record):
  ```udon
  |element "hello," she said        ; $main stack: "hello," + text «she said»
    "oh, hi," he responded.         ; body prose — quotes literal
  ```
- **0.10.0 §6.10** carries K9 and says sameline text and block text "are therefore different documents by design — reflowing between them is a semantic edit."
- **Fresh-reader probe** (0.10.0 `working-notes/UNIF-PASS-QUESTIONS.md` Q3): a zero-context reader "expected quotes *visible* in `|greeting "hi there," she said`."
- **Old parser (evidence only):** `|el 42` → text `"42"`; `|el "hi," she said` → text with the quote marks kept.

## Alternatives

### A — the element's line is text (0.7, udon-ast)

```udon
|price 42
|quote "hello," she said
|tags [a b]
```
```text
document
├ element price
│   $main "42"
├ element quote
│   $main "\"hello,\" she said"
└ element tags
    $main "[a b]"
```

(Where `$main` lives — attribute or first text child — is file 13 Q3.) Typed values then go in attributes: `|price :amount 42`.

### B — the element's line is a typed value slot (K9, 0.10.0)

```text
document
├ element price
│   $main 42
├ element quote
│   $main "hello,"
│   $main "she said"
└ element tags
    $main ["a" "b"]
```

To keep quotes visible: `|quote \"hello," she said`.

### C — text, except when the whole rest of the line is exactly one typed token

`|price 42` → `$main 42`; `|quote "hello," she said` → text with quotes; `|tags [a b]` → list; `|n 3 apples` → text "3 apples".

```text
document
├ element price
│   $main 42
├ element quote
│   $main "\"hello,\" she said"
└ element tags
    $main ["a" "b"]
```

### D — lite refuses a typed-looking start on the element's line (reserved), so the full language can decide later

```udon
|price 42              ; anomaly: error, reserved — write |price \42 or |price :value 42
|quote "hello," she said
```

## Continuation lines

Under A (0.7), text on the element's line and indented lines below formed one run:

```udon
|p First line of the paragraph
   and its continuation.
```
```text
A (0.7):     element p
               └ text "First line of the paragraph\nand its continuation.\n"
B (0.10.0):  element p
               $main "First line of the paragraph"
               └ text "and its continuation.\n"
```

The 0.7 "choose your continuation column" idiom (`SPEC-INDENTS.md` "Inline Content Freedom": the second line may align under the first word of the text) only makes sense under A.

## Interactions

- [13](13-ast-shape.md) Q3: where the element-line text sits in the tree.
- [01](01-sameline-element-child-or-value.md): under B, `|a |b` is also a value slot question.
- [71](71-how-far-an-unquoted-value-runs.md): whether the text runs to the next marker or to end of line.
- [72](72-which-bare-words-are-numbers-booleans-nil.md): which spellings are typed.
- [10](10-inline-elements-and-inline-comments.md) Q3: `|p See |{em x}` vs `|p |{em x} see`.
