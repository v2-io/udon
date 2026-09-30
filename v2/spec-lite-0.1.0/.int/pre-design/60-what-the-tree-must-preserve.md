# 60 — What the lite tree has to preserve: meaning only, or enough to write the source back?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

Lite is specified as the tree it produces. Several of the other pre-design questions ([13](13-ast-shape.md) Q4–Q6, [55](55-which-node-owns-a-blank-line.md), [57](57-line-breaks-in-text.md)) turn on one prior choice: is the lite tree **the meaning** of the document, or must it also carry **enough to reproduce the source** (spacing, which spelling was used, blank lines, comments)? And if the second, is that part of the tree proper or a side layer?

Spelling pairs that mean the same thing but look different:

```udon
|el :x 1 :x 2          |el :x [1 2]            ; stacked vs list (K15)
|el[k]                 |el :$key k             ; sugar vs longhand
|el :a <v>             |el
                         :a
                           <v>                 ; value on the line vs deferred
|a                     |a

  |b                     |b                    ; a blank line between structure
```

## Where it has come up (chronological)

- **Joseph, 2026-01-13**: *"I like your idea that we have the simplified tree but with potential metadata (including the comments we end up getting from the events) that specifies what *was* originally inline vs. block etc. This would allow for linting and fully-reversible translation without cluttering up the 'dig' / path syntax or conceptual mental model."* And: *"We track position (along with line number and column and whether it's sameline or block-level) but have a simplified hash. I like your idea, by the way, of having a parallel or opaque lookup for metadata."*
- **Joseph, 2026-07-19**: *"The resulting eventstream should be able to reverse back to the original without any loss of meaningful data (or ideally, exactly as is). It wouldn't necessarily need to distinguish between `  :attr <val>` and `  :attr\n     <val>`, for example, but it couldn't drop prose newlines, and we want to capture all comments in the stream as well."*
- **Joseph, 2026-07-20**, proposing a definition of ornamentation: *"choices about things that change how the udon looks without changing the AST … except they may be preserved in their own namespace for exact verbatim round-trip. But it can be proven to be ornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result of the first round-trip"* —
  ```text
    original.udon  -> (drop ornamental)       original.ast -> house-style.udon
  house-style.udon -> (drop house ornamental) original.ast -> house-style.udon
  ```
- **K9 (2026-08-08)**: `$main` was introduced partly so that round-trip could tell element-line text from block text "without original position metadata which gets unwieldy."
- **K15 (2026-08-09)**: spelling flavors (stacked vs list, and kin) are ornamentation; the tree builder *may* annotate the flavor so a faithful round-trip can reproduce the spelling; data consumers ignore it.
- **0.10.0 MODEL §6**: "anything a consumer must consult the source to reconstruct is a model hole."

## Alternatives

### A — the lite tree is meaning only; ornamentation is out of scope for lite

A formatter writes a house style; exact source reproduction needs spans or a separate tool.

### B — the lite tree is meaning, plus an optional, specified annotation layer (flavor, blank lines, sameline-vs-block) that a conforming lite parser may produce

The annotation layer's contents are part of lite; data consumers ignore it.

### C — the lite tree must reproduce the source exactly (a concrete syntax tree)

## Sub-questions

- Which of the pairs above are meaning, and which are ornament? (Joseph's 2026-07-19 example treats sameline-vs-deferred attribute values as ornament; K9 treats element-line text vs block text as meaning.)
- Comments: meaning (kept in the tree, [13](13-ast-shape.md) Q6) or ornament?

## Interactions

- [13](13-ast-shape.md), [55](55-which-node-owns-a-blank-line.md), [57](57-line-breaks-in-text.md), [58](58-designated-dollar-attributes.md).
