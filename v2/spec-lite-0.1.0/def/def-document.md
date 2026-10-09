---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [document]
per: [ast-centric]
depends: []
consequences: [def:tree, def:root, def:meta, def:anomaly, rule:one-root-node, rule:tree-transcript, obj:reserve-dont-ignore]
---

# document

*A «document» is one unit of lite source: what an author writes, and what a parser accepts or rejects. Parsing an accepted «document» gives one «tree».*

## Terms

- **document** (the name has not been reviewed with Joseph): one unit of lite source. It is what an author writes and what a parser accepts, producing one «tree», or rejects with an «error». A «document» is the characters, not anything made from them.

## Invariants

- A «document» and its «tree» are different things, so two «document»s written differently can be compared by their «tree»s. Which pairs have the same «tree» is for the rules to say.
- A «document» is not a «node». The top of its «tree» is the «root-node» ([[def:root]]).

## Examples

- A file `notes.udon` holding the three lines below is one «document». Its «tree» has a «root-node» with an attribute `title` and one child element `section`. Neither the «root-node» nor the attribute is "the document".

  ```udon
  :title My Notes
  |section
    Some text.
  ```

## Avoid

- **"document" for the parse result, or for the node at its top.** That is how most neighbors use the word, which is why a reader will bring it here:
  - DOM: `Document` is a node, the top of the tree; `document.documentElement` is the outermost element.
  - XDM 3.1 (XPath/XQuery data model): "Document Nodes encapsulate XML documents", and "A tree whose root node is a Document Node is referred to as a document."
  - UDON 0.9.1 and 0.10.0 `MODEL.md` §1 and `GLOSSARY.md` (agents, July–August 2026): "**Document** — a complete input: top-level nodes + anomalies + result", i.e. the parse product, written as a record `Document = { content, anomalies, result }`.
  - Joseph's own August 2026 sketch, where the document *is* the top element: "having a document always be an internally designated pseude-element `|'$DOCUMENT'[unique-file-path][content-hash] …`" (2026-08-07T05:06Z, `history.jsonl:18725`).
  - The pre-design tree notation, which prints the top line of every tree as `document` (still in `dat/implied-root.yaml`).
  - The mainline Rust tree, `NodeKind::Document` ("Root document container", `core/udon-core/src/tree.rs`, 2026-01-02).
- **"forest", "`Document = [Node]`", "top-level items", "`TopLevelItem`"** for what a document holds. The rootless model: `design/udon-ast.md` (2026-01-14, "No implicit root wrapper"), the 2026-07-20 greenfield D6 ("Document Root is a Forest"), 0.9.1/0.10.0 `MODEL.md` ("There is no implicit root element"). The implied root ([[rule:one-root-node]]) retired it.
- **"source text"**, for the characters of a document. ECMAScript's term, but it puts «text» (a lite term for something else, [[def:text]]) into the name.
- **"presentation" / "presentation stream"**: YAML 1.2's name for the character stream. Importing it would invite YAML's other layers.
- **"surface" / "surface syntax" / "recognition input"**: 0.10.0 `GLOSSARY.md` ("surface recognition (source text → the ADM plus anomalies)").
- **"file"** as a synonym. Whether a file holds exactly one «document» is open (pre-design 84 Q1), so "file" and «document» should not be used interchangeably until it closes.
- **"document" in the SOP sense**, a record's file ("a row with no document", `sop/src/conv-row-type.md`, `sop/src/conv-doc-state.md`; the outline heading "Example Documents"). A different store with its own meaning; in spec text, write "record" for those.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." `.int/lexicon-inventory-2026-10-09.md` lists where each term came from. Until 2026-10-09 this card also defined «tree», «root-node» and «meta»; they now have their own cards ([[def:tree]], [[def:root]], [[def:meta]]).

### Joseph's words, in date order

- 2025-12-28T21:25Z (`history.jsonl:6050`): "Tests shouldn't assume udon starts at column 0 or anything."
- 2026-01-02T18:56Z (`history.jsonl:6837`): "There should be zero distinction between "document root" level and being children of an element or attribute. "Document root" has no meaning in UDON (that I can think of)."
- 2026-07-19 (`history.jsonl:16863`): "Here's the scenario I see-- original document: … If the inbound document to the parser gets cut off at T in TODO..."
- 2026-07-20T17:15Z (`history.jsonl:17000`): "RD-parser(udon doc -> Raw event stream -> assembled event stream)" … "-> oneshot AST"
- 2026-08-07T05:06Z (`history.jsonl:18725`): "having a document always be an internally designated pseude-element `|'$DOCUMENT'[unique-file-path][content-hash] ; and some file attributes, mtime, permissions, etc.`"
- 2026-08-07T17:29Z (`history.jsonl:18732`): "having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element)."
- 2026-09-29 (`.int/STEWARD-VERBATIM.md`): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."
- 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "(like "same tree" -- which I was honestly reading as the doc->ast->doc->ast identity - ornamentation check)"
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "it also becomes crucial in references and composing multiple udon documents / partials, etc. etc."

### Readings of his usage (mine; flagged, not resolved)

- **Since September his usage is the source sense, consistently.** "the document being parsed", "udon doc -> … -> AST", "doc->ast->doc->ast", "composing multiple udon documents". The «tree» is what a document *becomes*; the root is something a document *has*.
- **In August the document was the root.** "having a document always be an … pseudo-element `|'$DOCUMENT'…`" makes the document and its top node one thing, with the file's path and content hash as the node's identity. The next day's message says documents *have* "a pseudo root element". So within two days both senses appear. I can't tell whether the September wording replaced the August one or just phrased it differently.
- **"partials" (2026-10-09) and "a partial vs whole-record vs store of records" (2026-08-07)** read as kinds of document, not as something other than documents. That suggests «document» doesn't imply "complete" or "standalone", unlike 0.10.0's "a complete input".

### Other agents' leans

- 0.9.1 and 0.10.0 (agents, July–August 2026): Document = the parse product (content + anomalies + result).
- The original drafter of this card (agent, 2026-09-29 to 10-09): the source, "because that is how the rest of the spec store uses the word": [[obj:reserve-dont-ignore]] ("a «document» a lite parser accepts"), `prop:forward-stability`, and pre-design 84's "documents per file".
- AST-notation proposal A (agent, 2026-10-09): prints the top line as `root`, not `document`, "because a «document» is the source".

### Precedents

- **XML 1.0:** a "document" is the text ("A data object is an XML document if it is well-formed"); the outermost element is the "document element" or "root element". The source sense, with the top element named after it.
- **DOM:** `Document` is the top *node*; the source is not modeled. **XDM 3.1:** "document node". **XML Infoset:** "document information item", the one item every other item is reached from, carrying [base URI] and [character encoding scheme]. All three use "document" for the top node.
- **YAML 1.2:** a *stream* holds a series of *documents*, each its own tree. "Document" is a unit of source, and a file can hold several. That is the shape pre-design 84 Q1 asks about.
- **HTML:** a whole document vs a fragment, where fragment parsing takes a context element. That is the same idea as Fable's 2026-07-29 "a snippet is the interior of an element whose opening line lives in the host" (`theory/to-integrate/primary/underlying-logical-model.md`).
- **JSON (RFC 8259):** "JSON text". **ECMAScript:** "source text", parsed against a goal (Script or Module).

### Questions about meaning, register and affordance

- **What does a host API call the parse result?** DOM-trained readers and agents expect `document` to be an object they traverse (`doc.root`, `doc.children`). The 0.10.0 MODEL named its result `Document`. If the spec's «document» is the source, a lite parser whose result type is `Document` contradicts the spec in its first line. A parser is about to be written, so this is when the API name gets chosen.
- **Does «document» mean one file?** Pre-design 84 Q1 is open. YAML's precedent is several documents per stream.
- **Is a snippet or partial a «document»?** Joseph's "composing multiple udon documents / partials" reads as yes.
- **"source"** stays plain English here: the characters of a «document». The cards use it ("the source never spells"). I don't think it needs a definition of its own. The word that does a lot of work beside it is "spelling" / "spelled" (how a «document» writes something), which no card defines yet. In working notes and SOP records, "source" also means where a quote came from ("Sources:"), a second, harmless sense.

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- I'd keep «document» for the source. His September and October usage is consistent with it, and naming the top node "root" (or similar, [[def:root]]) and the result «tree»/AST ([[def:tree]]) removes the reasons the word has meant the top node elsewhere.
- I'd settle the API name for the parse result at the same time, so `Document` doesn't become the result type by default.

### Cards a change here would touch (left unedited)

- `dat/implied-root.yaml` prints `document` as the top line of each tree: under this card that names the source, not the root.
- [[rule:one-root-node]] and [[rule:root-meta]] list `def:document` in `depends:` for the root; that now lives in [[def:root]].
- [[def:anomaly]] and [[def:node]] depend on `def:document`, probably for «tree» ([[def:tree]]).
- [[rule:top-level-attributes]] cites [[def:document]] for "meta is never spelled"; that is now [[def:meta]], where the claim is contested.
- `main.outline.md` Part I: the `def:document` row's statement, and new rows for [[def:tree]], [[def:root]], [[def:meta]], [[def:transcript]].
