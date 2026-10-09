---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [root-node]
per: [ast-centric]
depends: [def:document, def:tree]
consequences: [rule:one-root-node, rule:top-level-items-are-root-children, rule:root-never-spelled, rule:root-meta, rule:top-level-attributes, rule:top-level-columns, rule:top-level-text-left-edge, def:meta]
---

# root-node

*Every «tree» has one «root-node»: the «node» at its top, which no spelling in the «document» opens, closes or names. The «document»'s top-level items are its children, and its top-level attribute lines are its attributes.*

## Terms

- **root-node** (the name is provisional; Joseph flagged it on 2026-10-09 as looking poor): the one «node» at the top of every «tree». It is implied: no spelling in the «document» opens, closes or names it. The «document»'s top-level items are its children, in order ([[rule:top-level-items-are-root-children]]); its top-level attribute lines are its «attribute»s ([[rule:top-level-attributes]]); a parser may attach «meta» to it ([[rule:root-meta]]); it counts as column −1 ([[rule:top-level-columns]]).
  - *Distinct from* the addressing theory's root-scope ([[references/def:scope]]), a scope with no enclosing scope. Lite defines no addressing, so how the two relate is not lite's to state.

## Examples

`|document` at the top is an ordinary child, not the root:

![[dat/implied-root.yaml#root_is_never_spelled]]

The root has attributes when the document writes top-level attribute lines (from [[rule:top-level-attributes]]):

```udon
:title My Notes
|section
```
```tree
root
  :title ‹My Notes›
  |section
```

## Avoid

- **"root-node", hyphenated, as the term name.** Today's term. Joseph, 2026-10-09: "It looks like the lexicon in place already has some poor things in it...  "element" + "root-*node*"?, "piece"? etc." He hasn't said what is poor about it (readings below).
- **"root element" and "document element"** for lite's root. In XML and the DOM these name the outermost *spelled* element (`documentElement`). In lite, a top-level `|document` is exactly what an XML reader would call the root element, and it is *not* the root: that confusion is why [[rule:root-never-spelled]] and the counter fixture `root_is_never_spelled` exist. Joseph himself wrote "a pseudo root element" and "that root element" (2026-08-07), so the phrase has his precedent too.
- **"document node", "`Document`", a `document` top line.** XDM 3.1's name for the kind XPath 1.0 called the root node; the DOM's `Document`; 0.9.1/0.10.0 `MODEL.md`'s `Document`; the mainline Rust tree's `NodeKind::Document`; the pre-design tree notation, which prints the root as `document` (still in `dat/implied-root.yaml`). In lite «document» is the source ([[def:document]]), so "document node" would merge the two again.
- **"`$DOCUMENT`", "pseudo-element", "pseudo root element", "pseudo-root".** Joseph's August 2026 sketch: "having a document always be an internally designated pseude-element `|'$DOCUMENT'[unique-file-path][content-hash] ; and some file attributes, mtime, permissions, etc.`" (2026-08-07T05:06Z, `history.jsonl:18725`), and the paths sketch built on it (`references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` §6). `$DOCUMENT` is a designated-attribute-style spelling; lite has no spelling for the root at all.
- **"document root", "root level", "root-level", "document-level", "at document root".** Mainline `spec/CORE.md` ("An attribute at the **document root** … is **undefined**"), 0.9.1's L1 ("Root-level attribute … document-level text"), the 2026-01 comment table's "Document root" row. Joseph, 2026-01-02: ""Document root" has no meaning in UDON (that I can think of)." That was about the top level parsing differently from an element's interior, which lite's root now rules out by construction. For the position, the cards say "top level" / "top-level item" (directly under the root); that phrase is not defined anywhere yet.
- **"implicit root wrapper"** (`design/udon-ast.md`, 2026-01-14: "No implicit root wrapper"), **"phantom owner"** (L1's rationale, 2026-07-21), **"forest"**: the rootless model's vocabulary.
- **"ROOT" / `UDON_ROOT`** (the 2011–12 C parser's node type), **"`:__` attributes"** (2011 `udon-c/docs/DECIDED.md`, for root metadata).
- **"root-scope"** for the root node. Joseph, 2026-09-30T02:17Z (`history.jsonl:21327`): "(are you *sure* root-scope is the same as the root node?)". A separate concept in the addressing theory.
- **"line root"** (0.10.0 `GLOSSARY.md`: "the owner of post-value material on a line"; Joseph 2026-08-09: ""Every line has a root" -- but not just one, right?"). Unrelated.
- **"root decisions", "root questions"**: this effort's own process vocabulary (2026-10-08: "see what cluster 2 does to this "root decisions" list"). Same corpus, unrelated sense; worth avoiding in spec text near the root cards.
- **"frontmatter"** for the root's attributes. Top-level attribute lines may come anywhere (after content with a warning), so "frontmatter" promises a position they don't have.

## Working notes

- **Not reviewed with Joseph.** The term came to this card from [[def:document]] on 2026-10-09.

### Joseph's words, in date order

- 2011-12-14 (`~/src/_older/udon-c/docs/DECIDED.md`, his own notes): "## "ROOT" NODE / * Implied / * ID is file path if applicable / * name is basename of path if applicable / * several :__ attributes for metadata- file access time, etc. / * stuff isn't, by convention, output during conversions". Under UNDECIDED: "No way (from document) to set classes? - use :class-name true instead? / No way to set id from source file? use :id (the id) instead?" (line breaks shown as ` / `).
- 2026-01-02T18:56Z (`history.jsonl:6837`): "There should be zero distinction between "document root" level and being children of an element or attribute. "Document root" has no meaning in UDON (that I can think of)."
- 2026-07-18T19:28Z (`history.jsonl:16654`): "Mark root level :x as undefined in the spec right now."
- 2026-08-07T05:06Z (`history.jsonl:18725`): the `$DOCUMENT` pseudo-element (quoted under Avoid).
- 2026-08-07T17:29Z (`history.jsonl:18732`): "having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question … (just depends on what you decide to do with that root element)."
- 2026-09-29 (`.int/STEWARD-VERBATIM.md`): "the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."
- 2026-09-30T01:01Z (`history.jsonl:21310`): "the decisions *have* gotten more principled and useful (e.g., doc root)."
- 2026-10-09 (`.int/STEWARD-VERBATIM.md`): "top-level :labels--- this can now be ruled an emphatic "allowed" -- mostly because it was one of the main advantages of adopting the implicit root node … :attributes that come after prose or node children would give the usual warning."; "implicit-root at -1 indent"; "since implicit-root is -1, if a later node dedents further than anything has ever before-- it gets the usual unaligned dedent warning".
- 2026-10-09: ""element" + "root-*node*"?"

His names for it, then: "ROOT" node (2011), pseudo-element / pseudo root element / root element (August 2026), implied root node (2026-09-29), doc root (09-30), implicit root node / implicit-root (10-09). "Implied" and "implicit" both appear.

### Readings of his usage (mine; flagged, not resolved)

Why "root-node" might look poor to him. He hasn't said; these are guesses, and he may mean something else:

1. **The root behaves like an element.** It has attributes and children, and he applies element rules to it: "the usual warning" for an attribute after content, "the usual unaligned dedent warning", a column (−1) like a parent's. In August he called it a "pseudo root element". Calling it a "node" while everything else of that shape is an «element» says it is a different kind of thing.
2. **"node" used to mean element in his speech** ("node-name", "node or attribute started lines"), so "root-node" may have read as "root element" in the old sense, beside a lexicon that now says «element».
3. **The hyphen** makes it look like a coined compound rather than "the root" plus the generic word.

Under the 2026-10-09 ruling ("'node' can be used to talk about AST or other graph nodes generically"), "root node" is literally correct: the root is a node of the AST. So if (1) is the objection, it is about the kind of thing the root is, not the word "node".

### The question under the name

**Is the root an «element» (one with no name and no spelling), or a kind of node of its own?** A name like "root element" answers yes; "root node" leans no; "root" stays neutral. What hangs on it:

- whether element rules apply to it by default (late-attribute warning, column, `$key`/`$traits`) or only where a card says so;
- whether a top-level `:'$key' x` gives the root an identity (2011's "use :id (the id) instead?"; the 2025-12-23 analysis: "Use regular attributes"), and whether a parser-supplied path identity stacks with it (his 2011 "ID is file path"; August's `[unique-file-path][content-hash]`);
- whether the root has a name (2011: "name is basename of path");
- whether it can ever be anything but the top (it can't be a value or a child).

### Other agents' leans

- 2025-12-28, the libudon agent (answering his "How do block comments and prose dedentation work -- they are not in elements either"): "there's just an implicit parent at column -∞".
- January 2026 and July 2026 (`design/udon-ast.md`; greenfields; 0.9.1/0.10.0): no root at all ("forest"). Grok's reason, never answered on the record: "Implicit root changes Host APIs and duplicate-key scope narratives." Fable called the forest "the best single decision in the suite" (2026-07-20).
- AST-notation proposal A (2026-10-09): prints the root as `root`. Proposal B: no root line ("The root is implied in the source, so it is implied in the transcript too").

### Precedents

- **XPath 1.0 §5.1:** "The root node is the root of the tree. A root node does not occur except as the root of the tree. The element node for the document element is a child of the root node." Its other children are comments and processing instructions outside the document element. That is lite's shape exactly, except that XPath's root has no attributes.
- **XDM 3.1** separates the position from the kind: "The term “root node” is merely a designator, based on position, for one of the nodes in the tree without implying what kind of a node it is. In the XPath 1.0 datamodel the root node was a kind of node." The kind XPath 1.0 called the root node became the "document node", and "A tree whose root node is a Document Node is referred to as a document." Unlike the Infoset, a document node may have more than one element child, as lite's root may. This is the closest precedent for the question under the name: "root" says where it is; what kind of node it is is a separate fact.
- **XML Infoset:** the "document information item" has [children], [document element], [base URI], [character encoding scheme]: facts about the source carried on the top item, like lite's root «meta».
- **DOM:** `Document` (the top node) vs `documentElement` (the outermost element).
- **unist / mdast / hast:** the top node's type is `root`; glossary: "The root of a node is itself, if without parent, or the root of its parent."
- **CommonMark (cmark):** a `document` node. **tree-sitter:** each grammar names its own top node (`source_file`, `program`, `document`). **ESTree:** `Program` (with `sourceType`); **Babel:** `File` wrapping `Program`; **Python `ast`:** `Module`; **Roslyn:** `CompilationUnitSyntax`, with the file path on the `SyntaxTree`, not the node.
- **Pandoc:** `Pandoc Meta [Block]`: the top holds authored document metadata (`Meta`, from YAML frontmatter) beside the blocks. Close to lite's root holding top-level attributes.

### Questions about meaning, register and affordance

- **"root" in this corpus is crowded:** root-scope, line root, "root decisions", project root (`¤`), filesystem root. As a defined "term" it would be delimited, but in prose an unmarked "root" will be read whichever way the reader last met it.
- **"implied" vs "implicit".** He uses both. "Implied" says the document implies it; "implicit" says it isn't written. Either works as the adjective; one should be picked so it isn't read as two things.
- **What will an agent with no highlighting assume?** "root element" → an element you could write (the XML habit). "root node" → the top of the AST, maybe not an element. "document node" → that the node *is* the document. "root" alone → the top, nothing more.

### Candidates

| Name | For | Against |
|---|---|---|
| "root" | Short; proposal A's `root` line; mdast/hast; his "doc root", "implicit-root"; says nothing about element-or-not | Crowded word in this corpus |
| «root-node» / "root node" (now) | Literal under the node ruling; XPath 1.0's term | Flagged by him; leans "not an element" |
| "implied root" / "implicit root" | Says what is special about it; his phrasing on 09-29 and 10-09 | An adjective doing a noun's work; "implied" vs "implicit" |
| "root element" | Says it behaves like an element, his August "pseudo root element" | XML's meaning is the spelled top element, the exact confusion the counter fixture guards |
| "document node" | XDM's term | «document» is the source in lite |

### My own opinion (the drafter's, Opus 5.5; not a lean of Joseph's)

- I'd ask the element-or-not question first, as a rule card, with examples (`:'$key' x` at the top; an attribute after top-level content; a filename). The name should follow the answer rather than settle it.
- For the name, I lean **"root"**, with "implied" as the adjective in prose. It holds up whichever way the question goes: "the root is an element with no name and no spelling" reads naturally, and so does "the root is a node of its own kind". "Root element" would make the spec's most important counter fixture harder to explain.

### Cards a rename would touch (left unedited)

- The term «root-node» appears in 9 files (32 uses): the `rule-one-root-node`, `rule-root-*` and `rule-top-level-*` cards, [[def:node]] ("on the «element» (or the «root-node») it belongs to"), [[def:anomaly]], `obj/obj-markdown-text-passes-through.md`, `main.outline.md`.
- Card slugs with "root-node": `rule-one-root-node`.
- [[rule:one-root-node]], [[rule:root-meta]]: `depends: [def:document]` → `def:root`.
- `dat/implied-root.yaml`: the `document` top line in its trees (old notation).
