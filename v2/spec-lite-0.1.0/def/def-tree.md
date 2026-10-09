---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [tree, raw-tree, node]
per: [ast-centric, representational-options]
depends: [def:document]
consequences: [def:root, def:meta, def:reading-option, def:transcript, def:node, def:anomaly, rule:tree-transcript]
---

# tree · raw-tree · node

*What lite specifies is the «tree» an accepted «document» parses to. The «raw-tree» is that «tree» exactly as the rules give it, before any «reading-option». A «node» is any item in a «tree».*

## Terms

All three names are provisional. Joseph's own word for the first two is "AST" ("raw AST"); see Working notes.

- **tree:** what parsing an accepted «document» produces, and what lite specifies ([[decision:ast-centric]]). It has exactly one «root-node» ([[def:root]]), and every other «node» sits beneath it.
- **raw-tree:** the «tree» exactly as lite's rules produce it, before any «reading-option» is applied ([[decision:representational-options]]). Fixtures show the «raw-tree».
- **node:** any item in a «tree», in the generic sense (Joseph, 2026-10-09, ruled: "'node' can be used to talk about AST or other graph nodes generically"). The «root-node», «element»s, «text»s, «comment»s and «fence»s are nodes. Whether an «attribute», a value, or a «piece» of a «text» is a «node» is open.

## Invariants

- One accepted «document», one «tree». A rejected «document» has no «tree» ([[def:anomaly]]).
- A «reading-option» never changes the «raw-tree»; it changes only what a consumer is shown.

## Examples

The «raw-tree» for one line, and the same line through one «reading-option» (notation: `.int/ast-notation-proposal-a.md`):

```udon
|el :author @{people/jw}
```
```tree
root
  |el
    :author ‹@{people/jw}›          ← raw-tree: a text whose one piece is a reference
```
```text
read, one-embed option on:
    :author @{people/jw}           ← what a consumer using that option sees
```

## Avoid

**For the tree:**

- **"ADM" / "Abstract Document Model" / "Document Model" / "the model".** `defining-udon.md` §5 (a research report Joseph committed 2026-07-19; it doesn't name its author and reads as model-written: "Define the Abstract Document Model (ADM)"), the July greenfields, and 0.9.1/0.10.0 `MODEL.md` ("**ADM / Abstract Document Model** — the Document Model … one pillar, two names"). Joseph used "ADM" once, in passing: "Since part of the spec would be the ADM -- you are welcome to expand that further as you go" (2026-07-20T05:33Z, `history.jsonl:16981`).
- **"ADR"**, which Joseph wrote three times in July 2026 beside "AST" ("a better or more accurate or descriptive term for "fold" and "result channel" vs ADR vs AST", 2026-07-20T17:54Z, `history.jsonl:17001`; "maybe straight to ADR?", `history.jsonl:17063`; "**ADR** & **Grammars** (plural)", `udon-needs/pipeline-discussion.md` line 321). No record says what the R stands for. In this corpus ADR also means Architecture Decision Record (`adr/`), so it can't be revived.
- **"DOM", "AST/DOM", "DOM-like".** Joseph, January 2026 ("use the events to build an AST/DOM", `history.jsonl:7846`); the mainline commit "Add Tree API for DOM-like document navigation" (2026-01-02). DOM names a W3C API with its own node kinds and mutation model.
- **"parse tree", "CST", "concrete syntax tree", "syntax tree".** Conventionally, a tree that keeps every token. Lite's tree drops layout and keeps meaning plus comments.
- **"forest"** for what a parse produces. The rootless model (greenfield D6, 2026-07-20; 0.9.1/0.10.0 `MODEL.md`); retired by the implied root.
- **"the same tree"** as a standalone phrase. It was the agent wording of the forward promise, downgraded to an aspiration on 2026-10-08, and Joseph read it as something else: "like "same tree" -- which I was honestly reading as the doc->ast->doc->ast identity - ornamentation check".
- **"recognizer output", "recognition"** (0.10.0 `GLOSSARY.md`: "the layer performing surface recognition (source text → the ADM plus anomalies)").
- **"wire", "event stream", "events", "fold", "result channel", "assembled event stream", "oneshot AST", "streaming AST", "stepwise AST".** The mainline pipeline's stages (Joseph, 2026-07-20, `history.jsonl:17000`/`17001`; `core/TODO-PARSER.md`). In lite the wire is "opaque".
- **"AST" for descent's grammar tree.** Joseph has used "AST" for the parser generator's own tree of a grammar file ("at the IR/AST level in descent", 2025-12-30T22:59Z, `history.jsonl:6299`). Lite's parser will be generated with descent, so its implementers will meet both.
- **Unqualified "tree" for other trees in the same corpus:** `tree-sitter-udon` (`ux/`), the ```` ```tree ```` fence label the cards use for transcripts (70 files), "tree notation".

**For the raw tree:**

- **"raw".** In lite cards, "raw text" means the uninterpreted interior of `<…>`, `@{…}` and `;{…}` ([[rule:opaque-span-raw-text]]: "The «tree» holds the text … with no meaning attached"), so "the raw tree holds raw text" reads two ways. 0.10.0 `GLOSSARY.md` retired "raw (as a free noun)" in favour of "verbatim", and has "raw base". Joseph's July "Raw event stream -> assembled event stream" used "raw" for the stage before assembly on the wire. Rust and Python have "raw strings".
- **"substrate"** (0.10.0 `MODEL.md` §3.2 "non-normative shape; normative substrate"; K15's "Substrate: the occurrence sequence"). An agent coinage.
- **`all_attributes` / `all_assignments` view** (mainline `spec/CORE.md` "Host Views (Recommended)"; 0.10.0 `MODEL.md` §3.2). The raw data, but named there as one view among others.
- **"canonical tree".** Collides with the fixture profile ⟦canonical⟧ (`sop/def/def-fixture-profiles.md`).

**For node:**

- **"node" for `|name`.** Ruled «element» on 2026-10-09 ([[def:node]]). Joseph's earlier usage ("node-name", "node or attribute started lines", "nodes nested in a parent node") often meant element.
- **0.10.0's `Node`** (`MODEL.md` §2: "Element | Text | Comment | Verbatim | Directive | Reference | BlankLine"), which excluded attributes and values. Reading "node" as that closed list would answer the open question below by default.
- **"item", "`Item`", "`TopLevelItem`", "information item".** 0.10.0 `MODEL.md` §3 (`Item = Value | Node | Comment`); the greenfield ADM; the XML Infoset.
- **"Node value" / "node-valued attribute"** (0.10.0 `GLOSSARY.md`) for an attribute whose value is an element: the value is an «element» ([[rule:element-values]]).
- **"first-order node"** (Joseph, 2026-01-14, of comments: "I'm not sure if we make comments first-order nodes or haec them part of the metadata?").

## Working notes

- **Not reviewed with Joseph** (except "node" as the generic word, 2026-10-09). «tree» and «raw-tree» were the original drafter's names (agent, 2026-09-29 to 10-09); [[decision:ast-centric]]'s title renders his "AST-centric" as "the tree it produces".

### Joseph's words, in date order

- 2025-12-25T17:57Z (`history.jsonl:5650`): "can you confirm whether or not we are offering both an event-stream based interface as well as a fully-parsed tree interface?"
- 2026-01-14T02:53Z (`history.jsonl:7846`): "Right... that's where the decision changes how we potentially use the events to build an AST/DOM. In which case, I like your idea that we have the simplified tree but with potential metadata (including the comments we end up getting from the events) that specifies what *was* originally inline vs. block etc. This would allow for linting and fully-reversible translation without cluttering up the "dig" / path syntax or conceptual mental model"
- 2026-01-14T05:10Z (`history.jsonl:7873`): "If someone wants to traverse the tree ignoring them, no problem, because in practice comments are only ever leaf nodes."
- 2026-07-14T23:45Z (`history.jsonl:16238`): "the AST and streaming AST will need spec-version compliance fixtures as well, and some things might be much easier to test at the AST level than comprehensively at the event level anyway..."
- 2026-07-20T17:54Z (`history.jsonl:17001`): "I'm trying to determine if there's a better or more accurate or descriptive term for "fold" and "result channel" vs ADR vs AST."
- 2026-09-29 (`.int/STEWARD-VERBATIM.md`): "There used to be a lot of discussion about wire vs ast -- because the core parser is streaming/event of course. Lite can be specified as AST-centric for simplicity."
- 2026-09-30T01:28Z (`history.jsonl:21318`): "if we decide (and I think we will) that the AST should have room for metadata on the nodes … give that AST node meta saying something like `as_main` or `same_line` = true."
- 2026-10-01 (`.int/STEWARD-VERBATIM.md`): "I think we basically halt parsing at that point with all the info and assume an AST only if the udon is compliant."
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "Opaque spans for example now will be their own branch in the AST later"; "The reassembled text from the AST would be: "child prose section starting...\n  \nmore prose...""
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "source -> wire/event (opaque in lite) -> raw AST -> AST modified by representational-options (usually part of traversal instead of predetermined, I would imagine)."
- 2026-10-09: "I'm fine with `:n ;{}` yielding a text AST node with an empty comment as its only inner part."; "comments are preserved in the AST"; "in the AST, no, it would be its own flag"; "AST-only (no event/streaming)"; "I've gone back and forth on node and element but prefer element so 'node' can be used to talk about AST or other graph nodes generically..."

A keyword count over his typed prompts in udon and descent projects (`history.jsonl`, Dec 2025 – Oct 2026): 83 prompts contain "AST" (a few of them about descent's own grammar AST); 23 contain "tree", and of those only the Dec 2025 – Jan 2026 ones refer to the parse result. This is a count, not a reading of each.

### Readings of his usage (mine; flagged, not resolved)

- **His word is "AST".** In lite's own discussions he calls the parse product "the tree" once that I found, in passing ("normally in udon this line would be a *sibling* to |parent-node-- closing |parent-node in the tree first", 2026-10-08), and "the AST" throughout.
- **His layering puts the unqualified "AST" after the options.** In "raw AST -> AST modified by representational-options", plain "AST" names what a consumer sees *after* options, and "raw AST" names what lite specifies. If the spec adopted "AST" for what it specifies, it would invert that sentence. I can't tell whether that sentence was a careful naming or a description in passing ("I guess that means in reality we have…").
- **Text and comments are nodes in his usage** ("a text AST node", "comments are only ever leaf nodes"). "node or attribute started lines" and "indented nodes or attributes" (2026-10-08/09) set nodes beside attributes, which suggests attributes weren't nodes for him. But both phrases predate the ruling, when "node" meant element, so they don't settle it.
- **"Abstract" fits, in the classic sense.** The tree drops indentation, spacing and line layout, and (if lite keeps 0.10.0's rule that `|el[k]` and `|el :$key k` give the same tree) sugar. It keeps comments as nodes (as mdast and hast do) and keeps the text/string distinction. So "AST" isn't a misnomer, though readers from compilers will expect comments to be gone.

### Other agents' leans

- The original drafter of this card and of [[def:reading-option]] (agent): «tree» and «raw-tree».
- Grok (2026-07-20, `udon-needs/pipeline-discussion.md`): "**ADM** = language-level product contract … **AST** = a concrete host/library encoding of an ADM … Streaming vs one-shot is **assembly scheduling**, not a different meaning model." Under that split, what lite specifies would be the ADM, not an AST.
- 0.10.0 (agents): "Document Model (ADM)", with "views" over a "substrate".
- AST-notation proposals A and B (agents, 2026-10-09): "tree" throughout, "transcript"/"notation" for its printed form.

### Precedents

- **AST vs CST.** Roslyn's syntax trees are full-fidelity (every token and all "trivia": whitespace, comments) and round-trip exactly; tree-sitter builds concrete trees with named and anonymous nodes. An AST conventionally keeps meaning and drops layout. Lite sits between: an AST that keeps comments.
- **unist** (the mdast/hast family): "Syntactic units in unist syntax trees are called nodes"; a node has `type`, optional `data` ("information from the ecosystem") and `position`; "Parent" nodes hold children, "Literal" nodes hold a value. Every unit is a node, values included. mdast is "Markdown Abstract Syntax Tree", yet keeps positions and raw HTML.
- **ESTree / Babel:** everything is a `Node` with `type` and `loc`, literals included. **Python `ast`:** `ast.dump`, `Module` at the top.
- **DOM:** `Node` covers Document, Element, Text, Comment, and (as a non-child) Attr. **XDM 3.1:** seven node kinds, attribute nodes and the document node included.
- **YAML 1.2:** three stages: presentation stream → serialization tree → representation graph, with "parse, compose, construct" between them. "Comments are a presentation detail and must not have any effect on the serialization tree or representation graph." Lite keeps comments, so its tree sits closer to YAML's serialization tree than to the representation.
- **XML Infoset:** deliberately an "information set", not a tree API, so implementations can expose it however they like.

### Questions about meaning, register and affordance

- **"AST" vs "tree" for an agent with no highlighting.** «tree» depends on its delimiters to read as a term; bare "tree" is everywhere in this corpus (the ```` ```tree ```` fences, tree-sitter, "subtree"). "AST" is unmistakable and greps cleanly. But it reads as compiler machinery, and lite's audience includes people using UDON as a data notation. "AST" also sets up the descent collision above for the parser's implementers.
- **Does the spec need two names?** The spec specifies one tree. "Raw" exists only to contrast with what «reading-option»s produce. If the post-option thing is named after the option word (a "view", say, [[def:reading-option]]), the specified tree may not need a qualifier. If it is "raw", the spec's own object sounds unfinished, which invites implementers to hand consumers something else by default.
- **Is an attribute a node? A value? A piece?** This decides what can carry «meta» (a position, say: does `:x` have one?), what a path can address later, and whether proposal A's one-line-per-attribute printing implies attributes are nodes. 0.10.0 said no to attributes and values; unist and XDM say yes.
- **Is the root a node of the same kind as an element?** That is [[def:root]]'s question; it decides whether «node» or «element» is the word for the top.

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- I'd name the specified tree **"AST"**: it is his word, by a wide margin, and it is accurate in the classic sense. I'd drop "raw" and name the other side after whatever «reading-option» becomes, so the spec has one tree and one word for presenting it. That inverts his "raw AST -> AST modified by …" sentence, so I'd ask him with an example rather than infer it: for `|el :author @{people/jw}`, which of the two trees above does he call "the AST"?
- I'd answer "is an attribute a node?" before writing «node» into more cards. My guess, from the tree notation's one line per attribute and from «meta» needing positions on attributes, is that it will want to be yes.

### Cards a change here would touch (left unedited)

- [[decision:ast-centric]] (title "the tree it produces") and [[decision:representational-options]] ("raw tree"), if the names change.
- 13 card files use «tree», 3 use «raw-tree» (`grep -rlE '«tree»|«raw-tree»' src def obj adr`); 70 use the ```` ```tree ```` fence label.
- [[def:node]]: its slug is `node`, but since 2026-10-09 it defines «element» and «attribute», and the generic «node» is defined here. A reader following `[[def:node]]` to learn what a node is will land on element. Renaming that card (say `def:element`) is agent A's call.
- [[def:anomaly]] and [[rule:tree-transcript]] depend on `def:document` for «tree»; they now want `def:tree`.
