---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [prose]
per: []
depends: [def:text, rule:prose-passes-through, rule:text-lines-join, rule:main-and-body-separate]
consequences: []
---

# prose

*«prose» is source: the lines under an element (or at the top level) that open no structure. Consecutive prose lines under one owner become one «text» child.*

## Terms

- **prose:** the lines of a «document» that open no structure, read as text under their owner ([[rule:prose-passes-through]], [[rule:text-lines-join]]). It is a region of the source; what it produces in the «tree» is a «text».
  - *Avoid:*
    - **"prose" for the value in the tree.** 0.9.1's primer: "Prose is a first-class node kind". In lite that node is a «text».
    - **"prose" for sameline text.** Joseph has written "sameline prose" (2025-12-31), "same-line prose" (2026-08-08) and "$main prose" (2026-10-08). Under these cards, sameline material isn't prose: it's a «text» «value» of `$main` ([[rule:main-and-body-separate]]).
    - **"text-space"** (0.10.0: "the block interior where prose lives"), **"text block"** (0.10.0 §7; Joseph's "full text-block grouping", 2026-07-20), **"block text"**, **"block prose"** (Joseph, 2025-12-31), **"body"** / **"element body"** (Joseph, 2026-08-08: "element bodys/children"). Names for the same region from different angles. "body" is also used for fence and comment bodies (slice E).
    - **"prose mode"**, **"text mode"**, **"text/prose mode"** (Joseph, 2026-07-12/19; 0.10.0 "Text mode — the state after a framed `\`"). A parser state, not a region. In lite a framed ` \ ` *ends* text ([[rule:text-value-end]]), so 0.10.0's "text mode" means something lite no longer has.
    - **"freeform"** (0.9's old name for raw/code blocks, retired to "fence"), and **"Content"**, from Joseph's 2026-07-19 list of names for text.

## Invariants

- Prose produces «text» children; it never produces `$main` ([[rule:main-is-attribute]]).
- The rules for what in a prose line is anything other than characters are few: a leading `\`, embedded forms and escaped embedded forms (Joseph's ruling, [[rule:prose-passes-through]]), plus the line-start and indentation rules.

## Working notes

- **Not reviewed with Joseph; drafted 2026-10-09.** No `def/` card defined prose before this one, though 33 card files use the word. This card's definition is the one the 2026-10-09 vocabulary inventory proposed to put to him ("prose = the source lines that produce text", `.int/lexicon-inventory-2026-10-09.md` §8); he hasn't answered it.

- **Joseph's words:**
  > Also, does it seem to you settled that we have pretty clear definitions at this point for the spec for string vs text vs prose ?
  >
  > — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

  > … clean definition and distinction for "string", "text", and "prose" …
  >
  > — Joseph, 2026-10-09, listing lite's most defining changes (`.int/STEWARD-VERBATIM.md`)

  > Agreed, 100%, ruled. Leading `\` (after any whitespace) on a prose line is read special (and consumed), embeds are detected, and escaped embeds are literal passthrough with the escape consumed. (And, within prose, those are the only behaviors we specify other than the indent/dedent stuff, if memory serves correctly...)
  >
  > — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

  > The truth is, sameline prose is treated a little differently than block prose, even-- sameline prose doesn't set the indent-column position (only the first block-level line of prose does that), so, domain-language-wise and semantically it won't be a problem really to say that sameline prose also allows ';' comments at the end unlike block-level prose.
  >
  > — Joseph, 2025-12-31T15:30Z (`history.jsonl` 6428)

  > … attributes are assumed to be a typed scalar until proven otherwise, whereas element body parts are assumed to be prose unless proven otherwise...
  >
  > — Joseph, 2026-08-08T03:53Z (`history.jsonl` 18796)

  ```udon
  |node some $main prose
      child prose section starting...
  ```
  — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`), the blank-lines example

- **Readings of his usage (readings, flagged):**
  - Through 2026-10-08 Joseph used "prose" for *any* unquoted natural-language material, on the element's line or below it: "sameline prose", "$main prose", "child prose". The split this card makes (prose = below the line only) is the agents' reading of his "string vs text vs prose" request, not something he has said. His 2026-10-09 ruling does use it in the narrow sense ("on a prose line"; "within prose").
  - "prose" in his usage is often a *register* word: "Human narrative" in the README's tiers of voice, "eroding prose-space" (2026-07-08, the reason for `<…>`). In the cards it's a *syntactic* region. A body line `3 apples`, or `|Name|Role|` indented past an established left edge, is "prose" syntactically and not prose in register.

- **What the three-way split would say, if this definition holds** (for Joseph to check, with examples):
  ```udon
  |q "Hi," she said
    and then left.
  ```
  `"Hi,"` is a «string» (a `$main` «value»); `she said` is a «text» (a second `$main` «value»); `and then left.` is prose, which gives a «text» child. So "text" is the kind of «value» both places produce, and "prose" names only the second *place*.

- **Precedents:**
  - **XML:** "character data" for text between markup, a lexical notion; the DOM's Text node is the tree's.
  - **Markdown/CommonMark:** "paragraph" is a block; there is no "prose" term. Prose in documentation talk is the natural-language text, in contrast to code or data.
  - **Literate programming (WEB, org-babel):** "prose" or "documentation" chunks vs "code" chunks: register-based.
  - **0.10.0:** "text-space" (the region) and "flow" (the value); the same region/value split as here, with different words.

- **Questions of meaning and affordance:**
  - Without highlighting, an agent reading "prose" will think of natural language, not of "a line that isn't structure". Lite documents used as data (a `|description` body of key-like lines) still have prose, syntactically.
  - Does a top-level line of text count as prose? By the cards, yes (`rule:top-level-text-left-edge`).
  - Prose overlaps "body" (slice E: fence bodies, comment bodies) and "content". Which of the three names the region under an element, and which the region under an attribute (`rule:attribute-bodies`, a gap), isn't settled.

- **Candidates:**
  - «prose» for the source region (this card).
  - "text lines" / "text block": plain and syntactic; "text block" is 0.10.0's.
  - "body text": distinguishes from sameline text, but "body" is contested in slice E.

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** keep «prose» as a source-side word, as this card has it, *if* Joseph accepts that sameline material is not prose. The string/text/prose triple is then clean: «string» and «text» are kinds of «value», and «prose» is where block «text» comes from. If he wants "sameline prose" to stay a natural phrase, prose becomes the register (any unquoted natural-language material) and the source region needs another name, probably "text lines".

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Keep «prose» as the source region (lines that open no structure), and stop saying "sameline prose" / "$main prose": sameline material is «text», never prose. That is the clean three-way distinction he asked for (2026-10-09) and his own ruling uses the narrow sense ("on a prose line", "within prose"). The `|q "Hi," she said / and then left.` example is the one to confirm it with.
