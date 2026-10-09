---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [text, piece, run]
per: []
depends: [def:string, def:embed, rule:embeds-in-text, rule:inline-comments, rule:main-is-attribute, rule:missing-value, rule:opaque-span-raw-text]
consequences: [def:reading-option, def:node, def:value, def:prose, rule:blank-line-whitespace-in-text, rule:key-holds-a-value, rule:list-items-whitespace-separated]
---

# text · piece · run

*A «text» is an ordered sequence of «piece»s: «run»s of characters and «embed»s. It is what unquoted material on an element's or attribute's line becomes, and what prose becomes.*

## Terms

- **text:** an ordered sequence of zero or more «piece»s. A «text» can be an attribute's value (including `$main`) or, from prose, a child of an element.
  - *Avoid:*
    - **"flow"**, **"flow value"** (0.9.1), **"text value"** (0.10.0; still the slug of `rule:text-value-end`): agent-made names for the same thing. Joseph never used "flow".
    - **"blob"**, **"text blob"**: the 0.9 era's name, Joseph's own in July 2026 ("text blob at end of sameline", "the inner text-blob", "text blobs / text literals"), retired by 0.9.1's glossary. Joseph, 2026-07-20T01:11Z: "hah, and blob didn't even make it into the jargon-- meaning it's being used in the gloss but never defined and never in a header" (`history.jsonl` 16948).
    - **"text literal"** (Joseph, 2026-07-19): a literal is a spelling, and a «text» can come from many lines of prose.
    - **"Raw", "Freeform", "Content"**: the names Joseph listed for this thing when he asked for "a vocab normalization" (2026-07-19, quoted below).
    - **"prose"** for the value. 0.9.1's primer: "Prose is a first-class node kind". In lite, prose is where text comes *from* ([[def:prose]]).
    - **"string"** for a «text». See [[def:string]].
    - **"scalar"**: Joseph's "sameline text is a scalar" (2026-08-08). A «text» with embeds isn't one piece.
    - **"inner text"**, **"inner-content"**, **"content"** (Joseph, Dec 2025, for an element's text before `$main`; 0.10.0 `content` for all children).
    - **"text node"** (the DOM's word; Joseph's "a text AST node", 2026-10-09). It's harmless when a «text» is a child, but `$main`'s «text» is a value, not a node.
    - **"Text event"** (the 0.9 wire): one event per line or segment, not one «text».
- **piece:** one part of a «text»: a «run» or an «embed».
  - *Avoid:*
    - **"segment"** (0.9.1/0.10.0: "Segment — one piece of flow").
    - **"chunk"**: Joseph's word for an embed ("a distinct chunk of distinct text as if it were a word", 2026-10-09) and for the parts ("series of text chunks", 2026-07-19). But "chunk" is UDON's established word for a piece of *streamed input* (descent's multi-chunk parsing; 0.10.1 "chunk boundaries are never end of input") and for RAG chunking (the README's "Self-Chunking for RAG/Embeddings").
    - **"part"**, **"inner part"**: Joseph's own (2026-07-19 "the text being two parts"; 2026-10-09 "an empty comment as its only inner part"). Not wrong, just not yet a term.
    - **"item"** (0.10.0's `Item = Value | Node | Comment`).
    - **"text values/embeds"** for the parts (Joseph, 2026-07-19: "an array of text values/embeds").
- **run:** a stretch of characters in a «text», between «embed»s or at either end.
  - *Avoid:*
    - **"text run"** in the 0.9 senses: "complete text run" (`spec/TODO-TEXT-WIRE.md`, a whole block of text) and the 2026-09-29 lexicon's "a text run" (a whole unquoted value). Those are a «text», not a «run».
    - **"string"** for a run (Joseph, 2026-10-08: "text has any number of pieces some of which are not strings", reading the runs as strings). See [[def:string]].
    - **"sameline run"**: Joseph's phrase for the stretch of a line after an element or attribute marker (2026-10-08, the tab rule). A different thing, with the same word.

## Invariants

- Text on an element's own line is the element's `$main` attribute, never a text child ([[rule:main-is-attribute]]).
- A «text» with no pieces is empty: `:a \` gives an empty «text» ([[rule:missing-value]]).
- Spaces between «embed»s are «run»s: `|nav |{a} |{a}` gives `$main` the pieces `a`, `" "`, `a`.
- A «text» and a «string» are different «value»s even when the «text» has one «run» and no «embed»s ([[def:string]]).

## Examples

```udon
|p See |{a :href /docs \ the docs} and @{faq}. ;{todo}
|el :n ;{}
```
```tree
root
  |p
    :$main ‹See |{a :href ‹/docs› ‹the docs›} and @{faq}. ;{todo}›
  |el
    :n ‹;{}›
```

`p`'s `$main` is one «text» of six «piece»s: the «run» `See `, an inline element, the «run» ` and `, a reference, the «run» `. `, and an inline comment.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from. «embed» moved to [[def:embed]] on 2026-10-09.

- **Joseph on "piece":** "It looks like the lexicon in place already has some poor things in it... "element" + "root-*node*"?, "piece"? etc. etc. etc. -- I haven't looked at any or been asked about any of those things so I shouldn't really comment on them yet" (2026-10-09, `.int/STEWARD-VERBATIM.md`).

- **His own words for the same things, in order:**
  > A vocab normalization, for example, across Raw and Feeform and Content and other names for "series of text chunks that's expected to eventually resolve to text after embeds etc. are all processed by dialects" would be warranted, in my opinion. Not a steer per se, but saw some of those terms popping up and it made me realize that even in the spec it could be a lot more clear if there was a better more clear noun and distinctions...
  >
  > — Joseph, 2026-07-19T23:21Z (`history.jsonl` 16923; "Feeform" is his spelling of Freeform)

  > In the following, more nuanced examples, the [""] are optional, but bring home the point that embeds are part of text blobs / text literals (if no spaces)
  > but the more nuanced: `|el :v1 !{{the-value}} a b c` -> v1's value: [[""], [emb-interp "the-value"], [" a b c"]]
  >
  > — Joseph, 2026-07-19T22:06Z (`history.jsonl` 16907)

  > [1234, "and here is\n  a bunch of prose...\n", "so what do we do?"] (the text being two parts is just an example-- illustrating that we don't guarantee how many pieces it comes in on the wire as in the event parser)
  >
  > — Joseph, 2026-08-08T03:53Z (`history.jsonl` 18796)

  > … which is probably the difference between text and a string-- text has any number of pieces some of which are not strings). Under this understanding, the above should give   nav $main  text[embedded_node(a...),' ',embedded_node(a...)] or something.
  >
  > — Joseph, 2026-10-08 (`.int/STEWARD-VERBATIM.md`)

  > I'm fine with `:n ;{}` yielding a text AST node with an empty comment as its only inner part.
  >
  > — Joseph, 2026-10-09 (`.int/STEWARD-VERBATIM.md`)

- **Readings of his usage (readings, not his statements):**
  - His 2026-07-19 definition, "series of text chunks that's expected to eventually resolve to text", is the closest he has come to defining «text». Note that it uses "text" twice, in two senses: the sequence, and what it resolves to once embeds are processed. Lite's «text» is the first sense. The second (the characters you'd get by rendering it) has no name in the cards. A consumer will want one ("the text's plain characters", DOM's `textContent`).
  - He has said "pieces" four times in this sense (2026-07-19 "text pieces", 2026-08-08 "how many pieces", 2026-10-08 "any number of pieces", and indirectly "inner part"). It's his natural word in prose. On 2026-10-09 he flagged "piece" with a question mark as possibly poor *as a defined term*. One reading: the word is fine in gloss but too generic to define. Another: he didn't recognize it as his. A third: a name for the parts isn't needed at all. Unresolved.
  - He has never used "run" for this, that I found (searches of `history.jsonl` for "text run", "runs of", "character run").
  - In his 2026-07-19 bracket notation the empty runs (`[""]`) are "optional": the parts were a wire-level detail to him then. Whether lite's tree has empty «run»s isn't stated; the cards' `‹;{}›` has none.

- **Other agents' leans:** the 0.9.1 and 0.10.0 suites (agents) chose "flow" and "segment", and "text run" for the plain part. The 2026-10-09 def (an agent) chose "piece" and "run", "from Joseph's words" (the inventory).

- **Precedents for the parts:**
  - **DOM / XML:** no word for "a part of mixed content". An element's children are Text nodes and Element nodes; XML 1.0 calls the whole "mixed content" (character data interspersed with child elements). The DOM's `normalize()` merges "contiguous Text nodes", which is what a «run» is.
  - **CommonMark / Pandoc:** the parts of a paragraph are *inlines*. Pandoc's `Para [Inline]`, with `Str`, `Space`, `Emph`, `Link`… CommonMark has a "textual content" inline. A precedent for "inline" as the word for every piece, plain or not; it collides with lite's "inline element".
  - **Ruby (Prism parser, from memory):** an interpolated string is an `InterpolatedStringNode` with `parts`: `StringNode`s and `EmbeddedStatementsNode`s. "parts" and "embedded" both.
  - **Python `ast`:** an f-string is `JoinedStr(values=[Constant, FormattedValue, …])`. PEP 701 tokenizes the plain stretches as `FSTRING_MIDDLE`.
  - **JavaScript (ESTree):** a template literal has `quasis` (the plain stretches) and `expressions`, interleaved.
  - **"run" elsewhere:** in word processing and typography (OOXML `<w:r>`, Core Text's `CTRun`, DirectWrite glyph runs) a *run* is a maximal stretch of characters that share formatting. Close to lite's meaning (a maximal stretch with no embed), and well established.
  - **"chunk" elsewhere:** storage and transport granularity (lazy text chunks, HTTP chunked encoding, PNG chunks, RAG chunks). It suggests an arbitrary split, which is what a «run» isn't.

- **Questions of meaning and affordance:**
  - Is a «run» *maximal*? "a stretch of characters" allows two adjacent runs; Joseph's 2026-08-08 wire remark ("we don't guarantee how many pieces it comes in on the wire") says that the wire didn't guarantee maximality. A tree spec probably should: the definition could say "a maximal stretch", as the DOM's normalized form does.
  - "run" is also a verb all over the cards ("unquoted text runs until a block form", `rule:text-value-end`), and a noun elsewhere ("a run of N ≥ 3 backticks", `rule:fence-opens-with-backticks`; Joseph's "sameline run"). Without highlighting, "the run ends" is ambiguous between a «run» and the unquoted value.
  - "piece" invites the reader to ask "of what?". "part" and "inline" have the same problem; "segment" answers it but carries 0.10.0's baggage.
  - Do the parts need a defined name at all? Every rule card that says «piece» could say "part of a «text»" or "in a «text»". "Spaces between «embed»s are part of the «text»" says what `rule:space-between-embeds` needs. The terms earn their keep only if a rule must talk about a «run» as a unit (maximality; empty runs; a «text» whose only piece is an «embed», in [[def:reading-option]]).

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** keep «text», with the 2026-07-19 second sense named as a distinct thing if consumers need it. For the parts, I lean toward defining only «embed» and saying "the characters between «embed»s" in plain words, dropping «piece» and «run» as terms. If a name for the plain stretch proves necessary, "run" has the best outside precedent (a maximal stretch with uniform properties), but its verb use in the cards is a real hazard. I'd keep "chunk" out because of streaming.

- Whether a «text» whose only piece is one «embed» may be read as that embed is a reading option, not this definition ([[def:reading-option]]).
- The tree notation writes a «text» as `‹…›` and a «string» as `"…"`. The SOP store chose `«…»` over `‹…›` for terms because single guillemets "are easily confused with `<…>` typed values in monospace" ([[sop/conv:term-delimiters]]). The same hazard applies to the notation's `‹…›`.
- Trees use the notation of `.int/ast-notation-proposal-a.md`, provisionally.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Keep «text».
- **Parts:** he flagged "piece" as possibly poor *as a defined term*, and "run" isn't his. I lean: no defined term for the parts. Write "a «text» is a sequence of characters and «embed»s", and state once that adjacent characters form one stretch (maximality), so trees don't vary. "Piece" and "part" stay plain English, which is how he uses them. If a rule later has to speak of the plain stretch as a unit, "run" has the best outside precedent; its verb use in the cards is the cost.
- **His second sense of "text"** (what a «text» renders to once embeds are processed) needs no term in lite, since lite never processes embeds.
