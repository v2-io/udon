---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [$main]
per: [representational-options]
depends: [rule:main-is-attribute, rule:leftover-values, def:stacking]
consequences: []
---

# $main

*`$main` is the attribute an element's own line gives the material left over after its name, key, traits and attributes. It is an attribute in the «tree», never a text child, and it stacks like any other.*

## Terms

- **$main:** the designated attribute holding the «value»s written on an element's own line that no other attribute takes ([[rule:leftover-values]], [[rule:main-is-attribute]]). It holds one «value» per occurrence and stacks ([[def:stacking]]): `|q "hello," she said` gives `$main` a «string» and then a «text».
  - *Avoid:*
    - **"inner text"** of the last element on the line (Joseph, 2025-12-24, before `$main`).
    - **"first child"** (Joseph, 2026-08-08: "this prose is the first child"), and the retired lite record `main-material-is-first-children`, which made sameline material the element's first children marked `same_line`. In lite's raw tree it is never a child; presenting it as one is a reading option ([[def:reading-option]]).
    - **"sameline decompress"**, **"element tail"**: pre-0.10.0 names, retired in 0.10.0's glossary in favour of `$main`.
    - **"same-line value"**, **"same-line typed value (`$main`)"**: the 2026-09-29 lite lexicon's entry names.
    - **"$main prose"** (Joseph, 2026-10-08) and **"sameline prose"**: `$main` holds «value»s, not prose ([[def:prose]]).
    - **"main text"** (Joseph, 2026-08-08: "having the main text as a scalar") and **"$main text"** (Joseph, 2026-10-08): `$main` may hold a «string», a number, a list or an element as well as a «text».
    - **"content"** for it: in the 0.9 line, sameline text was content; 0.10.0's SEMANTICS made "`$main` vs block text: not equivalent".

## Working notes

- **Joseph's own term; the inventory lists it as settled.** The open points are scope, not the word: whether `$main` applies inside `|{…}` ("we still haven't discussed $main applying everywhere, braces included", 2026-10-09; [[rule:inline-element-value-end]]), and what a consumer sees by default.

- **Joseph's words:**
  > same-line free text that is associated with an element is syntax-sugar for another special attribute:
  >
  > — Joseph, 2026-08-08T19:03Z (`history.jsonl` 18833), proposing `:'$main'`

  > As for :'$main' -- I'm sold. The costs are for the event-wire only and the AST builder can easily just decide or be configured to drop it into the first child slot instead with maybe a flag saying 'first_is_main: false' or something.
  >
  > — Joseph, 2026-08-08T19:31Z (`history.jsonl` 18835)

  > … While I ended up swinging back to being in favor of / reconciled with $main as long as the AST interactions can make it transparently effectively the first child if/when expected -- it grew on me for other reasons-- [mostly] the fact that in practice, text on the same line as the node it's associated with has a different semantic meaning than children text. From a data structure perspective it often tends to be more like the "name" or heading or something-- not the same semantic space as indented child text.
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

- **Readings of his usage (flagged):** He says "$main" both for the attribute and for the material ("$main text", "$main prose", "$main values"). The cards say "`$main` values". Nothing hangs on it, but "$main prose" is the one use that conflicts with [[def:prose]] as drafted.

- **Register and affordances.**
  - `$main` is a spelling (an attribute name a writer could type: `:'$main' …`), so it's written in backticks in the cards. As a term it would be «$main». The `$` marks it as designated, which slice A owns (`$key`, `$traits`).
  - "main" suggests "the most important thing about the element", which fits his "more like the "name" or heading". It could also suggest "the main content", which is what the block below is. An HTML-minded reader will expect `$main` to be the element's content; it's only part of it, and only by a reading option.
  - Without highlighting, `$main` in prose reads as a shell variable. That's mostly harmless.

- **Precedents:** XML-to-JSON conventions reserve a key for an element's text: xml2js's default `charkey` is `_` and `attrkey` is `$` (checked 2026-10-09, the xml2js README); BadgerFish uses `$` for text (from memory, not checked). In none of them is the element's text an attribute; in all of them it's a reserved key beside the attributes, which is what `$main` is.

- **No candidates are listed**, since the term isn't contested. My only note (the vocabulary agent for values and text, Opus 5.5; an opinion): the cards should stop calling `$main` material "sameline text" where it may be a «string» or a number, and say "`$main` «value»s".

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Settled (his). Only the cards' wording: say "`$main` values", not "sameline text", since `$main` may hold a string, a number, a list or an element. Whether `$main` applies inside braces waits on embeds, as he said.
