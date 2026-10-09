---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [meta]
per: [forward-compat-aspiration, ast-centric]
depends: [def:tree, def:root]
consequences: [rule:root-meta, rule:fence-dedent-in-meta, rule:line-start-escape, rule:edge-blank-lines, rule:top-level-attributes, rule:tree-transcript]
---

# meta

*«meta» is information a parser attaches to the «node»s of a «tree» beside their content: a filename on the «root-node», a node's position, the indentation a fence body lost. What exactly counts, and what sets it apart from content, is not settled.*

## Terms

- **meta** (provisional; what it covers is open, and `needs-work` is set for that reason): information attached to a «node» of the «tree» that is not part of the node's content. The cards use it today for:
  - a filename the parser attaches to the «root-node» ([[rule:root-meta]], MAY);
  - a node's source position ([[def:document]], until 2026-10-09);
  - the position of a consumed line-start `\` ([[rule:line-start-escape]], MAY);
  - blank lines at a text's edges ([[rule:edge-blank-lines]], MAY);
  - the indentation removed from each fence body line ([[rule:fence-dedent-in-meta]], MUST);
  - in proposal A's notation, `#at`, `#same-line`, `#quote`, `#ticks`, `#strip` (`.int/ast-notation-proposal-a.md` §2).

## Invariants

- A top-level attribute line is content, not «meta», wherever the «tree» puts it ([[rule:top-level-attributes]]).
- Whatever «meta» is, two parsers that agree on a «tree»'s content agree on the «tree» for the purposes of [[obj:reserve-dont-ignore]] (Joseph, 2026-10-08: "I think meta is clearly safe to evolve beyond lite").

*Removed from this card's predecessor: "«meta» is never spelled." Four of the five uses above are spelled in the «document» (see Working notes).*

## Examples

````udon
|bundle
  ```sh
    make
  ```
````

The fence body is `make\n`. That 4 spaces were removed from the line is «meta» ([[rule:fence-dedent-in-meta]]). If the file was `notes.udon`, that filename on the «root-node» is «meta» too. One of these two facts is in the source and the other isn't.

## Avoid

- **"metadata" for authored document metadata**: top-level attributes, "frontmatter", `:title`, `:author`, `:version`. That is the common sense of the word elsewhere: Pandoc's `Meta` (the document's authored metadata, from YAML frontmatter), HTML's `<meta>`, "YAML frontmatter metadata", and Joseph's "flesh out the frontmatter / metadata some more" (2026-07-22T00:25Z, `history.jsonl:17104`, about notes files). He also pushed back on "attributes are for metadata" as a rule: "Doesn't stuff like this: "Use :attr for metadata, not child elements.", kind of defeat the whole purpose?" (2025-12-24T04:47Z, `history.jsonl:5528`, his paste rejoined across a line break). A `:title` line is content.
- **"Source Metadata", "SourceInfo", "parallel metadata layer"** (`design/udon-ast.md`, 2026-01-14).
- **"annotation", "flavor annotation"** (K15, 2026-08-09; 0.10.0 `MODEL.md` §3.2). In 0.10.1 "Annotation" became the name for *comments* (`spec-0.10.01/MODEL.md`: "**Annotation** replaces the Comment kind by rename only"), so it now means two things.
- **"spans", "host spans", "per-byte span maps"** (0.10.0 `MODEL.md` §8) as a synonym. A span is one kind of meta; Joseph asked for "meta" and "spans" to be defined separately (below).
- **"ornament", "ornamentation"** as a synonym. That is Joseph's own word for a different layer (below).
- **"`:__` attributes"** (2011 `udon-c/docs/DECIDED.md`, "for metadata- file access time, etc."). Meta as spelled-looking attributes.
- **"attributes"** for positional data, as Python's `ast` does (`_attributes` = `lineno`, `col_offset`). Collides with «attribute».
- **"trivia"** (Roslyn). Not used here; it would be the analog of ornament, not of meta.
- **"meta" in its other senses in this corpus:** process about process ("TODO-META", "meta-commentary", "meta-question"), the "schema/path/meta team" (Joseph, 2026-07-29). In spec text, delimit «meta».

## Working notes

- **Not reviewed with Joseph.** The term came to this card from [[def:document]] on 2026-10-09.

### Joseph's words, in date order

- 2026-01-14T02:53Z (`history.jsonl:7846`): "I like your idea that we have the simplified tree but with potential metadata (including the comments we end up getting from the events) that specifies what *was* originally inline vs. block etc. This would allow for linting and fully-reversible translation without cluttering up the "dig" / path syntax or conceptual mental model"
- 2026-01-14T05:05Z (`history.jsonl:7871`): "That's a good example of some more metadata (attribute ordering) that shouldn't usually affect the semantic perspective. We track position (along with line number and column and whether it's sameline or block-level) but have a simplified hash. I like your idea, by the way, of having a parallel or opaque lookup for metadata."
- 2026-07-20T17:54Z (`history.jsonl:17001`), defining a neighboring layer: "I think we should consider defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they may be preserved in their own namespace for exact verbatim round-trip."
- 2026-08-07T05:06Z (`history.jsonl:18725`): "`|'$DOCUMENT'[unique-file-path][content-hash] ; and some file attributes, mtime, permissions, etc.`"
- 2026-08-08T19:56Z (`history.jsonl:18837`): "it allows round-trip transformations from the wire to properly distinguish those "same-line main values" that it couldn't before without original position metadata which gets unweildy...."
- 2026-08-09T15:53Z (`history.jsonl:18916`): "these, like extra blank lines in non-prose, are issues of 'ornamentation', in my opinion, but the wire protocol still sees the difference obviously and the ast assembler can (and should be allowed to) add some metadata / annotation for the "flavor" that is indicated over the wire."
- 2026-09-29 (`.int/STEWARD-VERBATIM.md`): "which might also have metadata like filename etc..."
- 2026-09-30T01:28Z (`history.jsonl:21318`): "if we decide (and I think we will) that the AST should have room for metadata on the nodes - and if we define it as everything needed to do roundtrip (with some basic normalization like not worrying about spaces between a node-name and the beginning of an attribute-- stuff that we'll consider "ornamentation") -- then, along with things like "source line" and "source span", my current lean would be, in lite, to have first_is_main implied as true (or default to true) and give that AST node meta saying something like `as_main` or `same_line` = true."
- 2026-09-30T02:01Z (`history.jsonl:21322`): "allow sameline=true metadata still even though it can be implied by (well) the same line, for use in generating udon via AST. … Also, my lean so far on structures is this:" then, on their own lines, "content < content+meta < content+meta+ornament" and "round-trip only optionally preserves meta".
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "1. Depends on your definition of "meta" and "spans" and "opaque spans""; "Under this adjustment I think meta is clearly safe to evolve beyond lite."; on fences, "always ensure that a fenced-block has meta about [its] first line's indent level"; "save indent in meta and all indent-resets if any"; "'-' suffix for verbatim & all dent changes in meta."
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): a line-start `\` "is an escape (and is consumed / not part of the text but probably in meta)"; on edge blank lines, "correct-- layout (== ornamental) -- because we have a lone /\s*\\\s*\n/ to preserve trailing blank lines in prose if the author needs it."

### Readings of his usage (mine; flagged, not resolved)

- **He has used "meta" for at least two different things:** facts from outside the document (filename, path, content hash, mtime, permissions), and facts about how the document was written (position, sameline vs block, fence indentation, a consumed `\`). He has never separated them by name.
- **He keeps ornament apart from meta.** "content < content+meta < content+meta+ornament" puts ornament in a layer beyond meta, and his 07-20 definition of ornamental ("change how the udon looks without changing the AST") is a different test from anything said about meta. Edge blank lines, by his 10-09 answer, are ornament ("layout (== ornamental)"), yet [[rule:edge-blank-lines]] says they may be kept "in «meta»". Either his "meta" includes ornament after all, or that card mixes his layers.
- **"Depends on your definition of "meta"" (10-08)** reads as him noticing the word wasn't pinned down, before this inventory did.
- **On 09-30 meta was "everything needed to do roundtrip".** By that test, quote kind, fence length, and which spelling of a stacked attribute was used would all be meta. Proposal A treats quote kind and fence length as meta, consistent with that.

### Where the cards conflict

1. **"Never spelled."** The predecessor of this card defined «meta» as information "that the «document» does not spell" and said "«meta» is never spelled". Removed indentation, a consumed `\`, edge blank lines, quote kind and positions are all in the document. Only parser-supplied facts (the filename) fit that definition. The invariant has been removed above; the definition it came with needs replacing, not patching.
2. **Normative meta vs meta that may change.** [[rule:fence-dedent-in-meta]] says the removed indentation MUST be kept in «meta». The predecessor card said «meta» "is free to change from one version of lite to the next", and Joseph said "meta is clearly safe to evolve beyond lite". A MUST about something allowed to change between versions needs one of them to give: either some meta is normative and some isn't, or the fence fact is not meta.
3. **Meta vs ornament** (above).

### Four senses that the word has been used for (my sorting, for Joseph to name)

| | What | Examples | Origin |
|---|---|---|---|
| A | Facts from outside the document | filename, path, content hash, mtime | the parser or the environment |
| B | How and where something was written | line and column, span, `same_line`, quote kind, fence length, removed indentation, consumed `\` | derived from the source |
| C | Ornament | edge blank lines, spacing between items | the source; Joseph's separate layer |
| D | Authored metadata | `:title`, `:version`, frontmatter | written by the author: content |

D is content under every proposal so far. The open question is whether «meta» is A, A+B, or A+B+C, and whether B and C need names of their own.

### Other agents' leans

- `design/udon-ast.md` (agent, 2026-01-14): "Source Metadata (parallel, optional): span, form: Embedded | Block | Sameline, attached_comments".
- 0.10.0 (agents): no "meta"; "host spans" and a "flavor annotation" an assembler MAY add.
- This card's predecessor (agent): meta = not spelled, including a source position (which is derived from spelling, so the two clauses disagreed).
- Proposal A (agent, 2026-10-09): meta = anything printed as ` #key value`, shown only when a fixture asks for it; it lists position, `same-line`, quote kind, fence ticks, strip. Its §9: "If the canonical printer can't print something, the raw tree doesn't hold it", which makes "what is meta" checkable.

### Precedents

- **unist:** two separate fields: `position` ("The `position` field must not be present if a node is _generated_") and `data` ("The `data` field represents information from the ecosystem"). That is close to the B / A split, and it also answers the case the agent raised in `.int/pre-design/STEWARD-2026-09-29.md` ("trees built by programs have no positions"): a generated node has no position.
- **ESTree:** `loc = { source, start, end }` and `range`; `loc.source` is the filename, so ESTree puts A and B in one place.
- **Roslyn:** the file path lives on the `SyntaxTree` (A), positions on every node (B), whitespace and comments as "trivia" attached to tokens (C, plus comments).
- **Python `ast`:** each node class separates `_fields` (content) from `_attributes` (`lineno`, `col_offset`, …: B).
- **XML Infoset:** [base URI] and [character encoding scheme] are properties of the document information item (A), with no separate name for them.
- **Pandoc / HTML `<meta>` / YAML frontmatter:** "meta" means D.

### Questions about meaning, register and affordance

- Ask him with the fence example above: are "this came from `notes.udon`" and "these 4 spaces were removed" the same kind of fact?
- Is an edge blank line «meta», ornament, or both?
- Does a tree a program builds (no source) have «meta»? (unist: no position; his 09-30 lean: a `same_line` flag still allowed, "for use in generating udon via AST".)
- Which «meta» do fixtures compare? Proposal A compares only the keys a case names.
- **Register:** "meta" alone reads as a prefix ("meta-commentary", "TODO-META"), and to a web reader as `<meta>`, i.e. authored metadata. "metadata" reads as D first. As a «» term it works; undelimited it will be misread.

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- The test that fits his layering is functional, not by origin: **«meta» is what a consumer can ignore and still read the same content.** By that test A and B are meta, D is not, and C is his separate "ornament" layer.
- I'd bring in "ornament" as a defined term, since it is his word with his own definition, and the cards already need it ([[rule:edge-blank-lines]]).
- I'd decide whether A and B need separate names once rules need to talk about them separately. [[rule:fence-dedent-in-meta]]'s MUST is the first sign that they do: a B fact with a guarantee, beside A facts (a filename) that are free to vary.

### Cards a change here would touch (left unedited)

- [[rule:edge-blank-lines]] ("MAY be kept in «meta»"): meta vs ornament.
- [[rule:fence-dedent-in-meta]] (MUST) vs the "free to change" clause.
- [[rule:top-level-attributes]], working notes: "meta is never spelled ([[def:document]])".
- [[rule:root-meta]], [[rule:line-start-escape]], [[rule:blank-line-sets-no-indent]] (working notes), [[rule:tree-transcript]] (`#` meta keys): all use «meta» and would want `def:meta` in `depends:`.
- [[decision:forward-compat-aspiration]] and [[decision:representational-options]] (working notes) mention meta and `same_line`.
