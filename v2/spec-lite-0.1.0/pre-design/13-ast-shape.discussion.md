# 13 — The shape of the lite tree: history and discussion

**Written by:** Claude (Opus 5.5), history agent for question 13, 2026-09-29. I did not see any lean file for this question.

**What this is:** the history of the six sub-questions in [`13-ast-shape.md`](13-ast-shape.md), oldest first, from mainline UDON (2011 originals, the Dec 2025–Jul 2026 libudon/udon repos) and v2 (Jul 20 → Sep 29 2026). Every entry says who said it and how the date is known. Joseph's words are quoted verbatim (typos kept). Agent text is labeled as agent text. Nothing here is binding. Joseph's statements have no special standing over agent pushback, and older entries have none over newer ones.

**Tags.** Each entry is tagged with the sub-questions it bears on:
**[Q1]** root node and its metadata · **[Q2]** `[key]`/`.traits`/`$main` as attributes or fields · **[Q3]** `$main` vs first text · **[Q4]** stacking · **[Q5]** text in the tree (runs, lines, blank lines) · **[Q6]** comments · **[AST]** the wire-vs-tree framing, which Joseph settled for lite on 2026-09-29.

## Method

- **Joseph's typed prompts:** read directly from every `~/.claude*/history.jsonl` (current file plus all dated backups). I kept every entry whose project path contains `udon` (3,065 prompts, Dec 2025–Sep 2026), filtered them by keyword, then read the hits in full. Only the typed `display` text is quoted; pasted content is marked as pasted. **Times are local Mountain time**, converted from the history timestamps. A sibling's earlier dump (`scratchpad/joseph-clean.txt`) has the same v2-era messages in **UTC**, 6 hours later; I cross-checked against it.
- **memorata-search** (the index is scoped to the udon transcript dirs and repos). I used only the classes `human-user`, `agent-to-human`, `agent-to-human-flanking`, and `document`. I did not open any raw `.jsonl` transcript, and nothing was blocked. Queries: "udon AST shape tree root node document"; "AST document node types element text comment root"; "document implied root node wrapper, top-level children of root"; "AST vs wire event stream tree what the parser produces"; "$main element line text attribute first line"; "repeated attribute labels stack list default read"; "text nodes merged runs blank lines paragraphs in the tree"; "comments kept in the tree as nodes"; "key traits id class element fields in the AST"; "parsed AST comments leaf nodes inline versus block metadata reversible"; "sameline and block produce the same tree, metadata records original form"; "stacking is a list, :x 1 reads as 1 or [1], $main stacks the same way, always-list accessor". memorata strips line breaks, so no UDON layout is quoted from it. (`--joseph` combined with date filters returns nothing; a sibling reported the same.)
- **Files read** (dates from git unless noted): `~/src/_older/udon` (2011 Ruby parser) and `~/src/_older/udon-c` (`docs/DECIDED.md`, `lib/udon.h`, `lib/udon.c`); `_archive/analysis.md`, `_archive/implementation-phase-2.md`, `_archive/DECIDED.bak.md`; `design/udon-ast.md`; `spec/CORE.md` (Host Views, Attributes, Stacking, Event Encoding, Prose, Comments, Overview); `spec/msc/CHANGELOG.md` (0.8.0-alpha.1 and the three 2026-07-19 batches); `spec/TODO-TEXT-WIRE.md`; `core/TODO-PARSER.md`; `core/udon-core/src/tree.rs` (current version and the 2026-01-02 original); v2 `DECISIONS.md`; `spec-0.09.01/MODEL.md`; `spec-0.10.00/{MODEL,CORE §6.7/§6.10/§7.4/§8,SEMANTICS}.md`; `spec-0.10.01/{MODEL,DELTAS}.md`; `JOSEPH-FOR-0.10.01-FIX.md`; `udon-needs/pipeline-discussion.md`; `.archived/first-pass/greenfield-3a/*` feedback and DECISIONS; `.archived/second-pass/ADM.md`; `references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` §6; `theory/to-integrate/primary/{underlying-logical-model,sameline-value-space-couplings-2026-08-08,sameline-value-space-2026-08-08.fork-notes}.md`; `theory/to-integrate/lexical-forms-redux.md`; `INBOX-REQUESTS.md`.
- **Not read whole:** the full 0.10.0 CORE, the needs monograph, most of the `.archived/` session vault, and the 2011 `.attic` scratch files. There were no udon chat prompts between 2026-01-15 and 2026-07-07; the repos were idle.

---

## History (chronological)

### 2011–2012: the originals

**2011-08-06 (git, `_older/udon/ruby/udon/lib/udon/udon_children.rb`): Joseph's 2011 Ruby parser.** `[Q6][Q2][Q4]`
A comment is a `Children::Comment`, one of an element's children. An element carries `:name, :id, :unaries, :attributes`, with attributes held in a hash (`@attributes = ... || {}`). This is built code, so it is evidence, not intent. What bears here: comments were child nodes from the start; `id` was a dedicated field; attributes were a map, so a repeated name would overwrite.

**2011-12-14/15 (git, `_older/udon-c/docs/DECIDED.md`, commit message "Got stuck w/ attributes and realized I had to revisit…"): Joseph's C-era notes.** `[Q1][Q2][Q4]`
> ```
> ## "ROOT" NODE
> * Implied
> * ID is file path if applicable
> * name is basename of path if applicable
> * several :\_\_ attributes for metadata- file access time, etc.
> * stuff isn't, by convention, output during conversions
> ```
> `:{attribute ...}    # Inserted complex attribute, affecting the parent or root node`
> ```
> ## ROOT NODE
> * No way (from document) to set classes? - use :class-name true instead?
> * No way to set id from source file? use :id (the id) instead?
> ```
> `* In parser, ID and classes become attributes? - implying they get overwritten w/ warning when`
> `* "online" mode? that is, "issue" children of the root note as they become finalized and flush all on explicit EOF`

This is the earliest statement on Q1, and it is close to the 2026-09-29 settlement: an implied root, file-derived identity (id = path, name = basename), metadata as a separate `:__` attribute family, and metadata left out of conversions by convention. Document-level attributes attach to "the parent or root node". The note also already wonders whether id/classes should become attributes (Q2), with overwrite-and-warn as the assumed duplicate behavior (Q4). The streaming idea ("issue children of the root as they become finalized") shows the root was never meant to block streaming.

**2012-01 (git, `_older/udon-c/lib/udon.h`, `udon.c`): the C parser as built.** `[Q1][Q2][Q4]`
`UdonNode { node_type: UDON_ROOT | UDON_BLANK | NORMAL; children; name; id; classes; attributes: UdonDict }`. `UdonParseState.source_origin` is commented "Filename, etc. Optional." Attributes go in through `udon_dict_add_or_update`, which replaces the old value for the same name. So in 2012 the root was a real node, id/classes were dedicated fields, and a repeated attribute meant last-wins. (`UDON_BLANK` is the node type for an empty line or EOF inside the node routine. It is not clearly a "blank line node" in the later sense.)

### Dec 2025 – Jan 2026: the revival (udon + libudon)

**2025-12-23 (git, `_archive/analysis.md`): agent analysis of the 2011 DECIDED items.** `[Q1][Q2]`
Under "### 8. ID/Class on Root Node": "**Decision:** Use regular attributes … `:id the-id` and `:class foo bar` as attributes work fine … No special syntax needed for root." The agent took the root node for granted and answered only how to give it an id or class.

**2025-12-24 09:12 (history): Joseph.** `[Q1]` (incidental)
> "Pure prose-- markdown *is* a subset of udon-- except frontmatter can now be anywhere."

This bears on Q1 only as a signal that document-level metadata need not sit at the top.

**2025-12-24 21:36 (history): Joseph, giving the agent cases for its unit tests.** `[Q3]`
> "|first |second Some prose
>   This prose is a child of |first, sibling of |second.
> |first |second |third  Inner text for |third
>                This prose is inner text within |second, after |third is closed"

Element-line text is called "inner text" of the last element on the line. This is the pre-`$main` model. The example mostly illustrates nesting.

**2025-12-25 10:57 → 11:20 (history): Joseph.** `[AST]`
> "can you confirm whether or not we are offering both an event-stream based interface as well as a fully-parsed tree interface?"
> "We were offering an event-stream for stream parsing … critical for agentic use in the real-world … the decision was made to *also* expose a second mechanism that was like Nokogiri … batched everything up in rust and there was only one handle handed over to Ruby that would essentially link to the entire tree"
> "We have the worst of three worlds: all parsing upfront, all ruby object creation overhead upfront, and no tree to traverse-- just a simulated event stream."

From the start, both a stream and a tree were intended.

**2025-12-25 13:10 (history): Joseph, on automatic dedent.** `[Q5][Q3]`
> "|section **The great indent**
>   This content is all inner-content of |section,
>   and will continue to be innter-content of |section
>   until the parser detects a dedent.
> …
> The default parsing behavior should be to automatically *dedent the prose.*
> So you would get out:
> ..., "**The great indent**\nThis content is all inner-content of |section,\nand will continue to be ...\nuntil...\n\n",..."

The expected output is **one merged text run** that begins with the element-line text and continues through the block text, with `\n` inside it and a trailing blank carried as `\n\n`. That is the opposite of today's `$main` split (Q3) and matches option B for text runs (Q5). The example was mainly about dedentation.

**2025-12-25 18:45 (history): Joseph.** `[AST]`
> "TREE BUILDING MODEL?????? … Am I being obtuse or is it much better to do a principled and lightning-fast event-emission model (especially since that's what the API is) and use it internally to build a tree when that API is called instead … How does that even stream?????????"

**2025-12-25 (git, `_archive/implementation-phase-2.md`): agent plan.** `[Q1]`
The planned arena tree begins `[0]: Root { children: [1, 5, 9] }`, and the planned API has `doc.root`.

**2025-12-28 14:25 (history): Joseph.** `[Q1]`
> "You understand that dedentation check is relative to the parent, and that nothing is hardcoded for literal column 0, right? There is no "root-level directives".  Tests shouldn't assume udon starts at column 0 or anything."

**2025-12-30 12:11 (history): Joseph's plan.** `[AST]`
> "11. second API built on event stream: full parse + lazy AST"

**2025-12-31 08:30 (history): Joseph.** `[Q3]`
> "The truth is, sameline prose is treated a little differently than block prose, even-- sameline prose doesn't set the indent-column position (only the first block-level line of prose does that), so, domain-language-wise and semantically it won't be a problem really to say that sameline prose also allows ';' comments at the end unlike block-level prose."

This is the first recorded difference between element-line text and block text. At this point it was lexical (indent column, comments), not structural.

**2026-01-02 11:47 / 11:56 (history): Joseph.** `[Q1][Q6]`
> "Why does that trigger a comment at document root?  Is that part of the spec?"
> "There should be zero distinction between "document root" level and being children of an element or attribute. "Document root" has no meaning in UDON (that I can think of).
> Can you let me know everywhere else the spec mentions document root?"

The context is **grammar behavior**: a comment was handled differently at top level. He is saying the top level must parse exactly like an element's interior. He was not ruling on whether the tree has a root node. Both readings have since been cited, so the context matters.

**2026-01-02 21:20 (history): Joseph.** `[AST]`
> "Next task with libudon: expose a second API, layered over the "sax-like" one we already have, that does a full parse and presents the AST."

**2026-01-02 22:18 (git a6d23e7 "Add Tree API for DOM-like document navigation"): agent-built `tree.rs`.** `[Q1][Q2]`
`NodeKind::Document` ("Root document container") plus `doc.root().children()`. `Element { name, id: Option, classes: Vec, attrs, embedded }`. The first built tree had **a root node** and **dedicated id/classes fields**.

**2026-01-13 19:15–19:38 (memorata, agent-to-human-flanking, udon session c8003469): agent equivalence tests.** `[Q3][Q5]`
The agent reported that `|el :attr val text` and its block form produce **identical events** (sameline text = block text, pre-`$main`). It also found that embedded `|{…}` cannot be written in block form and asked whether "prose content IS a distinct node type that contains a sequence of text+inline elements."

**2026-01-13 19:53 (history): Joseph.** `[Q5][Q6][Q3]`
> "Right... that's where the decision changes how we potentially use the events to build an AST/DOM. In which case, I like your idea that we have the simplified tree but with potential metadata (including the comments we end up getting from the events) that specifies what *was* originally inline vs. block etc. This would allow for linting and fully-reversible translation without cluttering up the "dig" / path syntax or conceptual mental model"

The agent's summary right after (19:54, memorata) reads: "`|p this |{em that} more` and the block form produce the same tree … Source Metadata (parallel, optional): span, form: Embedded | Block | Sameline, attached_comments". What bears here: a **simple core tree plus a metadata side layer** for form and round-trip. The "(including the comments …)" parenthetical is ambiguous about whether comments live in that metadata; the next entry settles it the other way.

**2026-01-13 20:15 / 20:19 / 20:33 (history): Joseph, on blank lines.** `[Q5]`
> "I think Text "" is a very clean way to show it. What is *not* necessarily clear from the SPEC that we can make a choice on is what do do with any of the spaces on that blank line. I'm perfectly ok with having the whole thing collapse to `Text ""` no matter how many spaces. I'm also OK preserving the spaces there and letting the AST/DOM builder decide what to do based on further context."

Joseph then sketched `BlankLine` events, and wrote:

> "This is correct I believe. There's no way at this point for the parser to know what the intent is coming up-- whether a is effectively closed and is onto siblings or more children of a. Having the blank-line tied to what's immediately above it as a child keeps both options open. Making it a peer of |a would preclude something like this:
> |a some text
>
>   finishing the text"

This is the origin of the BlankLine event, and of placing a blank line with the node above it (the later S9 "placement" question). The interpretation is left to "the AST/DOM builder."

**2026-01-13 22:05 → 22:10 (memorata agent, then history): comments as nodes.** `[Q6]`
The agent set out the tension: "Comments as nodes (symmetry argument) … Comments as metadata (cleaner tree argument) … Hybrid possibility: comments are nodes in the raw parse, but the 'clean' view filters them to metadata." Joseph replied:
> "Excellent, ok. If someone wants to traverse the tree ignoring them, no problem, because in practice comments are only ever leaf nodes."

Resolved as **comments are nodes (leaves)**, with skipping them left to the consumer.

**2026-01-13 22:28 → 2026-01-14 08:26 (history; git e8b82f7 "Add three advancements … our desired AST"): `parsed-ast.md`, which became `design/udon-ast.md`.** `[Q1][Q2][Q5][Q6]`
Agent-drafted, with Joseph reviewing it that morning. Relevant content:
- "A document is a list of nodes: `Document = [Node]`. **No implicit root wrapper.** This enables: **Streaming**: Append nodes as they complete · **Fragments**: Same type as full documents (useful for includes/templates) · **Multi-root**: Valid UDON can have multiple top-level elements."
- `Element: name, key, traits: [String], attrs: [Attribute] # ordered, keyed by name, children`
- Text: "`|p Hello !{{name}}, welcome to |{em UDON}!` Produces children: `[Text, Interpolation, Text, Element, Text]`", so text pieces are siblings of inline elements.
- "Comment: A tier of voice, not noise to be stripped … Comments are first-class nodes … always **leaf nodes**."
- "Source Metadata … parallel metadata layer … form: :block | :sameline | :embedded; original_whitespace; attr_order … Comment attachment (which node a comment relates to)."
- "Equivalence: Different syntactic forms produce the same tree … The only differences are: 1. Whitespace in text content … Consumers decide whitespace normalization policy."

This is the one clear statement **for** a rootless forest in mainline, and it came four days after the built tree had a root node. The reasons given are streaming, fragments, and multi-root.

**2026-01-14 06:54 / 07:07 (history): Joseph, on key and traits.** `[Q2]`
> "I like how your AST nodes have id and class attributes separated out already instead of having to go through attributes, but I wonder if we should present different names for them to emphasize that they are more than just "shorthand to help you write html in udon"."
> "In this light I like "key" (with an alias of 'id' and 'identity') over identity for the "published" name, keeping "traits" (with an alias to 'class' and 'classes') for the other. Want to add all of this (for now) to the parsed-ast doc?"

In January, Joseph liked **dedicated fields** (option B) in the AST, while also saying the evening before (2026-01-13 21:25) that "[ ] and .class syntax are syntactical sugar for :id the-thing-between-brackets and :class [the-things-after-dots]." Sugar in the syntax and fields in the tree were held together without apparent tension.

**2026-01-14 07:56 (history): Joseph.** `[Q2][Q4]`
> "would you add some concrete API for bidirectionality in the AST as well as separate "views"/projections that would include mixins, element+key tuples, maybe just key lookup, and so forth?"

This is where "views" over the AST first appear.

### Jul 2026: the reboot (mainline 0.8/0.9)

**2026-07-08 13:40 (history): Joseph's Critical-to-Quality list.** `[AST]`
> "IN solid event, streaming-ast, and one-shot ast"

**2026-07-11 18:25 (history): Joseph.** `[Q2]`
> "For the record, before the agent returns, I would be perfectly happy with '$key' and '$traits' as the main default sugar and removing the id/class reservation as aliases (or the other way around). And I love the idea that the parser gets to choose how to expose (or even qualify) normal attributes vs '$' special attributes... (calling them traits vs attributes etc. for example)"

**2026-07-11 18:48 / 19:01 (history): Joseph.** `[Q4]`
> "- attribute value stacking (my vote: required standard behavior, order guaranteed to be preserved [of the values assigned to the same attribute, :'$trait' style])"
> "What we actually need to do is always allow stacking as we've noted and list-typed *any attribute/trait* as we've essentially created now--- but the *SCHEMA* is where we need to allow for attribute typing and disallowing (for example) array-valued $key etc."

**2026-07-11 22:18 / 22:27; 2026-07-12 00:37; 2026-07-13 20:23 (history): Joseph, on views.** `[Q2][Q4]`
> "Is the recommendation for the views essentially something like:
>   - These are syntax sugar for these attributes...
>   - We recommend you expose (something like):
>     - bare_attributes (or all_attributes or full_attributes -- [you choose one you like so there *is* a default recommendation for some familiarity when someone switches hosts, but not forced …]
>     - key & traits & attributes (that has them distinct)"
> "I vote $traits ---  one nuance that I forgot about that the implementation needs to decide is whether the specially-designated $traits is *always* an array/list even if there was only one given (makes app-dev a bit more simple)."
> "- [ ] make sure traits as always-array is captured as one of the only parser-special-casing beyond the desugaring..."
> "(we already have it as a parser decision to decide whether or not '$traits' is *always* a list, right?)"

This became CORE's "Host Views (Recommended)" and the 0.8.0-alpha.1 entry (CHANGELOG, 2026-07-14): "**Identity model**: `[key]` desugars to `$key`, `.trait` to `$traits` (with an always-a-list `traits` view)". So Joseph moved Q2 from "fields in the AST" (January) to **attributes in the substrate, fields as a host view**. The one normalization allowed beyond desugaring is `$traits` always being a list.

**2026-07-11 (git 7248eb3) and 2026-07-15 (git ccbe3ec, efdd2a9, 2b9e324): agent-built tree and streaming tree.** `[Q1][Q2][Q5][Q6]`
`tree.rs` keeps `NodeKind::Document` as root. The Element's dedicated `id`/`classes` fields are removed and `attrs` holds every attribute, `$key`/`$traits` included ("the substrate … nothing is consumed or reordered, so `all_attributes` round-trips"). Comment text accumulates into one Comment node. `stream_tree.rs` "push events in, completed root-level subtrees ship as owned `Document`s the moment they close"; `core/TODO-PARSER.md` records "streaming granularity = one root-level subtree per shipment … root blank lines/warnings ship nothing" and "scalar `attr()` = LAST stacked value" as provisional API choices awaiting Joseph. The builder makes **one Text node per Text event** and does not merge them.

**2026-07-14 17:45 (history): Joseph.** `[AST]`
> "Nevertheless, the AST and streaming AST will need spec-version compliance fixtures as well, and some things might be much easier to test at the AST level than comprehensively at the event level anyway..."

**2026-07-15 12:28 (history): Joseph, ruling on block comments.** `[Q6]`
> "It *does* raise the question of how to represent the output in the parser and AST... Do we keep parsing so that the comment is a nested node?  Probably not... comments are expected to be 'ignored' by the parser even if we pass them through-- and commenting out a block specifically because it is causing parsing errors or warnings is a primary usecase...  So basically a very simple "everything is comment-text until there's something new at head-position or dedented from it" seems like the clean right call"

The agent's reply (memorata, agent-to-human): "comment content stays inert text … accumulated into one content string in the tree — no nested nodes." "Ignored" here means **the interior is not interpreted**. It does not mean the comment is dropped from the tree.

**2026-07-15 12:51 (history): Joseph.** `[Q4]`
> "- They are labeled, where the label is the parent's perspective, not the child's perspective.
> - That label is conserved in the sense that the parent just has one of each, and its values accumulate, no matter how they might be interleaved
> …
> In other words (it's pausible to reason that) an element automatically has a hash-table available and an array available"

**2026-07-15 13:25 (history): Joseph (brainstorm, marked as such).** `[Q4]`
> "Basically, we say:  children are an ordered, heterogeneous array from the beginning.
>   a single attribute declaration can only have one value-- but that value can be an element
>   multiple instances of the same attribute essentially turn it into a heterogeneous array (labeled)"

**2026-07-16 02:44 (history): Joseph.** `[Q4]`
> "**WHEN 2 VALUES TRY TO BIND TO AN ATTRIBUTE-- WARN AND STACK THEM BOTH INTO AN ARRAY**"

The warning was later retired (K11, 2026-08-08). The array reading stayed.

**2026-07-18 (CHANGELOG §1.6): ruling.** `[Q1]`
"Root-level attribute → undefined … the parser emits a free-floating `Attr`, but don't rely on it." CORE Attributes carries the same text.

**2026-07-19 13:43 (history): Joseph's S6 blank-line taxonomy** (ruled that day, CHANGELOG second batch). `[Q5]`
> "- blank lines in *non-prose* mode / positional construct detection etc. are (or should be) considered *UDON-level decoration* -- that is, newlines that are for prettying up the things within udon, and not within the inner text-blob. (Maybe call this ornamentation, vs text-literal or something)
>   - blank lines that don't have whitespace extending to the head position but that otherwise trail the text blob are a bit ambiguous …
> … Then in the AST builder we can decide that blank lines that are surrounded by text get turned into extra newlines, while blanklines that are before or after a text starts are discarded as udon ornamentation or some other construct like literal blanklines in the ast for round-trip / reversibility."

**2026-07-19 14:16 / 14:18 (history): Joseph, on discovering the tree had been fabricating joins and dropping newlines.** `[Q5]`
> "so many agents repeat back to me over and over "Don't worry- no data left behind!" while deliberately stripping one of the human-cognition and agent-cognition most important geometric differentiator on text."
> "I also don't understand how the AST work was able to proceed with that information gone. Also cheating and looking at the source?? Or just bad AST being generated and tested?"

The finding (`spec/TODO-TEXT-WIRE.md`, "AST-layer finding"): the agent-built `push_text_chunk` inserted a space between text chunks ("`line1\nline2` → `"line1 line2"`") and dropped BlankLine events outside raw blocks. It was deleted the same day. Text became pure concatenation, and `BlankLine` became a tree node.

**2026-07-19 14:29 / 14:54 / 15:07 (history): Joseph.** `[Q5]`
> "As far as pure return-trip capability as the events arive, I would soften a little bit to either "given the full event stream" or even in some cases only after AST parsing."
> "The very final trailing newline (not just newline*s*) are all potentially underdefined at this point … Generally speaking, we need to know what we're currently doing so that it can be an AST parser decision."
> "; BUT THIS ONE:
> |el :hello? :hi there \
>   |child
> ; the only reason I'd put the backslash at the end like that is because I *do* want the explicit newline."

This became the ruled "final-terminator disposition": a run's final newline inside its last text is ornamental and trimmed by the AST; an explicit trailing `\` is kept.

**2026-07-19 16:20 / 17:18 (history): Joseph.** `[AST][Q6][Q5]`
> "So basically the wire is ambivalent altogether about what belongs to the attribute vs the element. W5 is a good example... something that currently maybe only the AST tries to assemble correctly?"
> "The resulting eventstream should be able to reverse back to the original without any loss of meaningful data (or ideally, exactly as is). It wouldn't necessarily need to distinguish between `  :attr <val>` and `  :attr\n     <val>`, for example, but it couldn't drop prose newlines, and we want to capture all comments in the stream as well."

That day the flat attribute wire was deratified (CORE "Event Encoding", ⚠ banner).

### Jul 20–31, 2026: greenfields, pipeline, needs (v2 begins)

**2026-07-20 (greenfield files; git 2026-07-22): three agent-written specs converge on a forest.** `[Q1]`
The first 3a (Gemini) draft said "The document itself is implicitly a root Element." Grok's review of 3a (`greenfield-3a/feedback-from-grok.md`): "The scrubbed model is a **forest** of top-level items … not an implicit root element. **Implicit root changes Host APIs and duplicate-key scope narratives.** If 3a *intends* a root Element as a greenfield ADM change, it needs a marked decision and reasoning — not a silent glide." 3a revised to "D6 — Document Root is a Forest." Fable's feedback: "D6 … is the best single decision in the suite. Nobody's source text said it out loud." Grok's summary to Joseph, pasted by Joseph 2026-07-20: "Forest document (no phantom root)" is in the "stable under re-derivation" list. The second-pass `ADM.md` records "**Consensus:** forest at top level — no implicit root Element." Note that the greenfield agents were deliberately kept from priors, so "nobody said it" did not account for `udon-ast.md` (Jan 14, forest) or 2011 DECIDED (implied root).

**2026-07-20 11:15 (history): Joseph.** `[AST]`
> "Is this an accurate model of what we're talking about?:
> pushdown-parser(udon chunks -> Raw event stream -> assembled event stream)  -> stepwise (streaming) AST
> RD-parser(udon doc -> Raw event stream -> assembled event stream)           -> oneshot AST"

Fable's answer (`pipeline-discussion.md`): "streaming AST builder (fold that ships each root subtree the moment it closes) · one-shot AST builder (fold that returns one Document)."

**2026-07-20 11:54 (history): Joseph, defining "ornamental".** `[Q5][Q4][Q6]`
> "The things that aren't determinable at construct arrival on the wire include …:
> - ornamental blank line detection (blank lines that are determined to be 'geometric' for making the udon doc legible instead of being part of a text block, even sometimes when adjacent to text blocks …)
> - full text-block grouping (the only one you defined "fold" as an incomplete example)
> - attribute correspondance rules (e.g., value stacking)
> …
> I think we should consider defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they may be preserved in their own namespace for exact verbatim round-trip. But it can be proven to be ornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result of the first round-trip"

Note "full text-block grouping" is on the list of things the tree layer does (Q5). Fable's reply (pipeline-discussion): the criterion is "the formatter-idempotence fixpoint … comments are not ornamental under this definition (dropping them changes the model, since they're nodes)." Grok added: "**ADM** = language-level product contract … **AST** = a concrete host/library encoding of an ADM … Streaming vs one-shot is **assembly scheduling**, not a different meaning model."

**2026-07-21 (DECISIONS.md L1, "Severity & root attr (2026-07-21 panel-lean)", agent panel).** `[Q1]`
"Root-level `:key` (no owning Element): **Warning** + keep as **document-level Text** (including `:`). Not a free-floating Attribute in the ADM. | Attributes are edges of Elements; **no phantom owner**."

**2026-07-22 (git): `spec-0.09.01/MODEL.md` (agent-consolidated 0.9.1, "normative").** `[Q1][Q2][Q4][Q5][Q6]`
- "`content` holds every top-level node in source order. **There is no implicit root element**; multiple top-level elements are true siblings." `Document = { content, anomalies, result }` (D-pack).
- "`attributes` is an **ordered sequence of assignments, not a map** … **Stacking is the model** … no last-wins, no merging, no implicit list-formation … Implementations MUST preserve the distinction."
- Sugar: "`|el[k].a.b?` and … `:'$key' k :'$traits' a …` are **identical** in the model"; CORE: "the model has no parallel fields."
- "`BlankLine` is a recognition-layer node … Interpretation (interior = newline; edges = ornamentation) is the consumer's; a consumer MAY keep literal BlankLine nodes for reversibility."
- Text law: "reconstructs by **pure in-order concatenation** … Adjacent pure Text segments MAY be flattened."
- "Comments are first-class model items — carried, never interpreted … Stripping is a view, not the model default."

**2026-07-23 12:51 (history): Joseph.** `[Q5]`
> "(… "sure, we can have a markdown dialect parser available-- event-level combined udon & markdown events? holistic AST? udon-AST with distinctly different markdown ADR parts connected in?...)))"

This bears on Q5 option C (paragraph nodes). Joseph places Markdown structure in a separate dialect layer, outside the core tree.

**2026-07-29 04:40 (history): Joseph.** `[Q1]`
> "clearly distinguish between files that are (a) atomic (meant to be a single record in a table effectively, or a few with 1-1 mappings), (b) multi-document (ala yaml …, or like jsonl), (c) snippet -- something that's meant to be pulled into something else-- could, for example, have :attributes at the topmost level before normal children in the document...."

Fable's letter from the same session (`theory/to-integrate/primary/underlying-logical-model.md`, 2026-07-29/30): "(b) multi-record … multiple top-level elements are already siblings with no implicit root, and the streaming AST already ships completed root-level subtrees as its unit … (c) snippet … **a snippet is the interior of an element whose opening line lives in the host.** Its top-level `:attributes` are the element's attributes … *frontmatter, re-founded in one grammar* … Note L1's own rationale is 'no phantom owner'; a declared snippet role answers that rationale — the owner exists, elsewhere."

**2026-07-29 13:02 (history): Joseph.** `[Q4]`
> "with a nuanced understanding of attribute stacking as it exists now and the attributes == ordered-stacking-hash vs children is an ordered array freeforall"

**2026-07-29 15:50 (history): Joseph.** `[Q4]`
> "A cleaner option is to simply lean into the stacking we already do and simply allow an attribute to have multiple children and call it an array without warning about it like we currently do. It's a regulator that no one asked for but that I put in there when I was afraid the format was getting too loose and was prone to exploding. But that doesn't seem to scare me anymore in this case."

### Aug 2026: `$DOCUMENT`, the K-rulings, 0.10.0

**2026-08-06 23:06 (history): Joseph, sharing his notebook notes.** `[Q1]`
> "the other thing that I think might close things completely is having a document always be an internally designated pseude-element `|'$DOCUMENT'[unique-file-path][content-hash] ; and some file attributes, mtime, permissions, etc.`
> That allows us to do all sorts of "file-system-layout aware" vs "logical-only-ignore-all-document-boundaries"... or something..."

**2026-08-07 11:29 (history): Joseph.** `[Q1]`
> "OH-- that reminds me, before I forget again if it's not already in the write-up (haven't gotten to the DOCUMENT part yet) -- having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element)."

The agent's write-up (`references/.archive/second-theory-iteration-2026-08-08/hypothetical-sketch.md` §6): "Every document implicitly is (or can be addressed as) an element whose designators are its path and its content hash, carrying file attributes as ordinary attributes … **Root attributes get their owner.** The 'no phantom owner' rationale behind warn-on-root-`:key` is answered: `$DOCUMENT` is the owner. Frontmatter dissolves into `$DOCUMENT`'s attributes; a snippet is *the interior of a `$DOCUMENT`*." This is Joseph's own earlier form of the 2026-09-29 settlement. Here the metadata (path, hash, mtime) sits on the root **as designators and ordinary attributes**, in the same family as authored ones (Q1's sub-question). Neither this sketch nor any later file says whether parser-supplied and authored root attributes are kept apart.

**2026-08-07 21:27 (history): Joseph, sketching attribute content.** `[Q6][Q4]`
> "|element :attribute one
>   :another some prose
>     |zee-ozzer-element ...
>     and here is some more
>     ; (and, depending on the parser tooling, this comment might be preserved as a child as well...)"

**2026-08-07 21:53 (history): Joseph.** `[Q4]`
> "I don't think we need a Warning for stacked values at all."

**2026-08-08 13:01 (history): Joseph's worksheet.** `[Q3][Q6][AST]`
> "|element this prose is the first child ; this saved comment also on the wire usually
> …
> |element :one 1 :two 2 \  And here is the description
>   :status open
>   :foo    bar
>   ; (no problem -- "And here is the description" emitted on the wire as a child after the first two attributes and before the second two-- AST still gathers them separately"

Just before `$main`, element-line text was still "the first child." Attributes and content were gathered separately in the AST even when interleaved on the wire.

**2026-08-08 13:03 (history): Joseph proposes `$main`.** `[Q3][Q2]`
> "same-line free text that is associated with an element is syntax-sugar for another special attribute:
> |element[123]  And here is some sameline text
>   :attr1  <1234>
> === ->
> |element
>   :'$key'  123
>   :'$main' And here is some sameline text
>   :attr1   <1234>"

**2026-08-08 13:31 (history): Joseph.** `[Q3][AST]`
> "As for :'$main' -- I'm sold. The costs are for the event-wire only and the AST builder can easily just decide or be configured to drop it into the first child slot instead with maybe a flag saying 'first_is_main: false' or something.
> It might end up significantly simplifying the mental model for sameline-- because now there's *never* necessarily text body, per se, in sameline..."

This is the most direct statement on Q3. **Where the text goes in the tree was left to the AST builder**, behind a flag. The stated cost was "for the event-wire only." Lite, being AST-centric, has no wire, so that cost argument no longer applies there.

**2026-08-08 13:56 (history): Joseph.** `[Q3]`
> "Oh, I forgot to mention the other main benefit of that-- it allows round-trip transformations from the wire to properly distinguish those "same-line main values" that it couldn't before without original position metadata which gets unweildy....
> Which actually helps give the proper mental model for several other things, including dialog. Because "same-line prose" isn't (or doesn't have to be) *exactly* equivalent to next-line indented first line (inlike the old spec) -- it makes sense that we're saying  "sameline text is a scalar--- if you are just starting the body of text, do it next-line indented, especially if you want to start it with quotes or angled-brackets etc."   -- that sounds perfectly reasonable"

**2026-08-08 (theory/to-integrate/primary, agent pushback before K9 was ruled).** `[Q3][Q2]`
`sameline-value-space-couplings-2026-08-08.md` (spike agent): "**Every sameline inline element stops being a child of its element.** Today `|p some |{em x} text` makes `em` a child of `p` … Under $main, the whole tail is a flow *value* of `$main` … Consumers, paths, and render pipelines that walk `content` for inline structure will find it empty and the structure relocated inside an attribute. The host `first_is_main` re-injection flag mitigates for ASTs, but the *model* answer must be explicit." And S3: "the `first_is_main: false` host flag is a *projection* … a host that re-injects $main as first child and then serializes from the AST has silently performed the exact text-migration §2's new forbidden row prohibits." It also noted that marking inline-ness on an Element node "collides with principle 6, 'sugar is designated attributes'." The fork notes say the same: "the embeds live on the attribute side, re-injected only by the host stitching rule."

**2026-08-08 22:39 (history): Joseph.** `[Q3]`
> "1. Right... it's an attribute on the wire, and depends on the parser parameters to decide how you want it in the AST. Moving on."

**2026-08-08 (DECISIONS K9, agent-written record, "jaw 2026-08-08").** `[Q3][Q2]`
"Sameline is value-space; sameline text is `:'$main'` sugar … Consequences: sameline material is never content (host flag re-injects, `first_is_main`-style) … sameline ≢ vertical for text by design; `$main` is an ordinary attribute w.r.t. the text law (not text material — host stitching)." The DECISIONS header warns that K-rows are "the coordinating agent's good-faith interpretation … not ratified text."

**2026-08-09 09:10 → 09:53 (history for Joseph; memorata agent-to-human-flanking for the agent, session 6ce33695): the stacking exchange.** `[Q4]`
- 09:10 Joseph: "What's your opinion on indicating that "stacking" is just a way to spread out a list/array -- i.e., the attribute label can occur interleaved with other things to build its items, so that it isn't treated *too* differently?"
- 09:12 agent: "yes — and it's bigger than a presentation tweak … one concept: an attribute's label names a collection of items, and brackets, stacking, and deferred bodies are three spellings."
- 09:18 Joseph: "BTW-- the equivalence *I* stated earlier should still stand: |el :attr |{a} |{b} should be the same as |el :attr [|{a} |{b}] *until/unless* a second thing were stacked onto :attr in the second example."
- 09:27 Joseph:
  > "|e :x 1
  > ==>  :x = 1
  > |e :x 1 :x 2
  > ==>  :x = [1 2] ; (started stacking, now it's a list)
  > |e :x 1 :x 2 :x [3 4]
  > ==>  :x = [1 2 [3 4]]
  > …
  > So maybe the thing we're unclear about is this:
  > |e :x 1
  > in my mental model, :x == 1,  *not*  :x == [1].  **BUT** This is **NOT** a ruling! This is me trying to understand where our mental models are diverging. If you say that :x should be [1] for simplicity's sake (all attributes are intrinsically lists and the parser/app decides that pulling out just the first value or only value is the special case) -- I can be persuaded."
- 09:28 agent: "**Yes — I'd persuade you toward `[1]` underneath, with `:x == 1` as how it reads.** … in the scalar-until-plural model, what `:x 1` *is* changes retroactively based on text that appears later … the Norway-problem family … It's also already how the designated attributes work (`$traits` is 'always a list' …; `$main` stacks the same way) — so it's unification, not invention."
- 09:33 Joseph:
  > "Well, let's be clear. "$main stacks the same way" - ALL attributes stack the same way-- this isn't unification, it's invention. Stacking behavior has always been *turns what was just a simple scalar into a list of scalars*. :$key was "the-key", not :$key = ["the-key"] unless there was a second key declared.  And I didn't hear *anything* about a Norway-problem that had crept in that we spent yesterday killing. On the wire / event parser there's no way to know when an attribute is done being declared until the entire element is finished. I'm still persuadable, but not by plausible-sounding nonsense."
- 09:34 agent, withdrawing: "The 'unification' claim was false. `$traits`'s 'always a list' is one designated attribute's *ergonomic view* … the wire never asserts a shape at all … the *shape* only exists when someone assembles it … Withdrawn. … Substrate: the occurrence sequence … Default read — your table, verbatim … Always-list is an accessor … available, never the default."
- 09:42 Joseph: "Excellent-- that's what I thought. And it's good. It makes it clear in the source the separation between the last attribute's value and the element's $main, which in the case of html etc. will always be interpreted as the first and sometimes only part of the inner-content." `[Q3]`
- 09:53 Joseph: "BTW, I don't know if either of the specs (or 0.9.1) captures it well yet-- but these, like extra blank lines in non-prose, are issues of 'ornamentation', in my opinion, but the wire protocol still sees the difference obviously and the ast assembler can (and should be allowed to) add some metadata / annotation for the "flavor" that is indicated over the wire."

Recorded as K15 (DECISIONS, "jaw 2026-08-09"), with the row's own caveat that the default read is "presupposed context, inferred-agreed from the session (correct if wrong)." In short: the substrate is the ordered occurrences (option A); the default read is option C; always-list (option B) is an accessor; the spelling difference is ornamental and may be annotated. The only argument for B as the substrate was withdrawn after Joseph rebutted it, and Joseph left the door open ("I can be persuaded").

**2026-08-09 to 08-11 (git): `spec-0.10.00` (agent-authored, 0.9.1 plus the K-rulings).** `[Q2][Q3][Q4][Q5][Q6]`
MODEL: `Element = { name?, assignments: [Assignment], content: [Node] }`, `Assignment = { label, content: [Item] }`, `Item = Value | Node | Comment` ("a comment in a deferred body is kept"). Host views gain "**`main` / `first_is_main`-style knobs** — `$main` presentation is a host parameter: expose as an attribute, or re-inject as the first content slot" and "**The default collection read**." CORE §6.7: "Last-wins does not exist in UDON, and stacking is **silent** everywhere." CORE principle 6: "**Sugar is designated attributes** (`$key`, `$traits`, `$?`…, `$main`), never parallel model fields." SEMANTICS §2 item 10: "**`$main` vs block text: not equivalent.**" §3 forbids a serializer to "move text between the sameline (`$main`) and block positions." §7.4 and §8 carry the blank-line and comment rules. The neutral file's Q2-A, Q3-A and Q4-C are this suite's positions.

**2026-08-27 16:36 (history): Joseph, on the "annotation" framing of comments.** `[Q6]`
> "Yes, precisely. And for me, the other tell that this is the right model for comments in addition to the practical realities is the fact that I see from the diffs of your modifications just now that you had started smuggling in 'aside' and aside mark and and leaving channel fuzzy …  Whereas now, it's done."

The model he endorsed (`theory/to-integrate/lexical-forms-redux.md`, same session): "**Annotation.** Any item — material or deferred — can *have an annotation*: uninterpreted material addressed to the document's maintainers instead of the document's consumer … attachable to any item or standing in a content position. Its interior is carried, never interpreted … It contributes nothing to the document's own assertion." In 16:13–16:28 of the same session he had pushed back against annotations holding arbitrary children ("might be too much (although I'm persuadable even then)"). `spec-0.10.01/MODEL.md` renames Comment to Annotation, "attached-vs-positional both representable as today." 0.10.1 was later called a misfire, but the misfire judgment was about other things (below).

**2026-08-30 (INBOX-REQUESTS.md): Joseph's "Tiny Parser" request.** `[AST]`
"regex or very simple recursive descent on fragment with a very simplified AST built. It would need to warn when there are constructs … that it won't parse … (e.g., for udon used as a simple predictable data layout / xml equivalent / yaml-or-json alternative)." This is lite's precursor.

### Sep 2026

**2026-09-01 19:59 (history): Joseph.** `[AST]`
> "It's not like there's a ton of theory even. I'm going to call 0.10.01 a misfire. … Do you have a clean proposal that you can explain to me in udon -> ast  (to skip the exponentially exploding jargon)?"

The answer, saved as `JOSEPH-FOR-0.10.01-FIX.md` (**agent text**): its trees have no document node; `$key`/`$traits`/`$main` are shown as attribute lines; block text is **one merged node per run** (`├ text "Body text here,\n  indented more.\n"`); a comment is its own node between text nodes (`├ comment "a maintainer note"`); inline pieces are joined with `·` inside a text entry. The tree notation in the neutral file follows this document closely.

**2026-09-29 18:18 (history): Joseph, opening spec-lite.** `[AST][Q1]`
> "There used to be a lot of discussion about wire vs ast -- because the core parser is streaming/event of course. Lite can be specified as AST-centric for simplicity. We can also settle (unless someone feels we need to adjudicate it still) on the document being parsed has an implied root node -- so everything starts as children of that node, which might also have metadata like filename etc..."

---

## Threads worth noticing

*This section is my own reading, not a record.*

1. **Q1 has moved back and forth over the years; it has not simply progressed.** Implied root with file metadata (2011) → a root node in the built C tree (2012) and the built Rust tree (Jan 2 2026) → "no implicit root wrapper" in `udon-ast.md` (Jan 14) → greenfield "forest, no phantom root" consensus (Jul 20), carried into 0.9.1 and 0.10.0 as normative → Joseph's `$DOCUMENT` pseudo-root (Aug 6–7) → implied root (Sep 29). The "no root" arguments were of three different kinds:
   - (a) *grammar*: the top level must parse like an element's interior (Joseph, Jan 2);
   - (b) *streaming and fragments*: the unit of shipment is a top-level subtree, and fragments are documents (`udon-ast.md`);
   - (c) *API and scoping*: "implicit root changes Host APIs and duplicate-key scope narratives" (Grok, Jul 20).

   An implied root that parses like an ordinary parent keeps (a). Streaming can still ship the root's children as they close (the 2011 note already imagined this). The snippet reading ("the interior of an element whose opening line lives in the host," Jul 29) answers the fragment worry. Argument (c) is the only one no later entry takes up.

2. **The metadata on the root has had two different sources, and nobody has said whether they mix.** The 2011 notes put file facts in a separate `:__` attribute family and left them out of conversions. Joseph's `$DOCUMENT` sketch put path and hash in *designators* and mtime/permissions in *ordinary attributes*, the same family as authored ones. Authored top-level `:labels` reached the root only by argument: Joseph's Aug 7 "solves the open 'what to do with attributes at top-level' question" versus the L1 panel's "no phantom owner." A third kind of document-level data is also pending: the D-pack `anomalies` and `result`.

3. **Q2, Q3 and Q4 are the same question in three forms: should the lite tree be the substrate, or a recommended view of it?** Each time, Joseph's recorded position put the *substrate* in attributes (designated `$key`/`$traits`/`$main`, ordered occurrences) and handed the *presentation* to host views. He made this move for keys in July ("the parser gets to choose how to expose"), for `$main` in August ("the AST builder can easily just decide or be configured"), and for stacking on Aug 9 (the default read is a view; always-list is an accessor). Before that move, in January, he liked dedicated fields in the AST. His stated reasons for the attribute substrate were mostly about the wire and round-trip ("The costs are for the event-wire only"; "allows round-trip transformations from the wire … without original position metadata"). Lite is AST-centric and has no wire, so part of that reasoning does not carry over automatically. The round-trip and least-surprise reasons do: the dialogue example, and "sameline text is a scalar."

4. **For Q3, the heaviest cost ever raised was not about text.** The Aug 8 coupling pass found that under `$main`, inline elements written on the element's line (`|p Hello |{em x}`) stop being the element's children and move inside an attribute value. For a lite whose headline use case is XML/HTML (the 2026-09-29 reason `|{…}` is in lite), this is the practical side of Q3. Joseph's Aug 9 remark points the same way: "in the case of html etc. [$main] will always be interpreted as the first and sometimes only part of the inner-content." The Dec 2025 behavior (element-line text and body text in one run) was the other pole.

5. **Q4's semantics have been stable since July 11. What was argued was only the reading.** Order-preserving, silent stacking has held throughout. Last-wins exists only in the 2012 C code, and as the built `tree.rs` scalar accessor `attr()` ("the LAST assignment wins"), which was provisionally chosen by an agent and awaits Joseph ("*(discuss w/ Joseph …)*"). That accessor sits uneasily with 0.10.0's "Last-wins does not exist in UDON."

6. **Q5 has never been ruled at the tree level. Every past ruling protects the bytes, not the node shape.** The text law says pure concatenation reconstructs the text and "adjacent pure Text segments MAY be flattened." The event layer says a Text event "carries **no** guarantee of being a complete text run." The built tree makes one node per event. The Sep 1 proposal showed merged runs. Joseph's own 2025 example showed one merged string. So option A ("one text node per source line") has no record behind it as a ruled shape, and per-event granularity was explicitly declared an accident of the parser. What Joseph has been emphatic about is that newlines and blank lines must survive ("one of the human-cognition and agent-cognition most important geometric differentiator on text"), and that edge blanks are ornamental while interior blanks are text.

7. **Q6: no one on record has proposed dropping comments by default.** The 2011 Ruby children, the Dec 2025 SPEC ("emitted as events, not discarded"), the Jan 13 "only ever leaf nodes", "a tier of voice", 0.9.1 "stripping is a view", Fable's "comments are not ornamental", and Aug 27 "annotation … carried" all point the same way. The only "ignored" (Jul 15) was about not *parsing* comment interiors. What stayed open is *where* a comment sits: as a positional node, attached to an item, inside an attribute's body (0.10.0 `Item`), or on an element's line (Joseph Aug 8: "this saved comment also on the wire usually").

---

## What the neutral file misses

- **Q1: the 2011 precedent and the `$DOCUMENT` sketch.** Both are Joseph's own earlier forms of the settled root. They offer concrete conventions to accept or reject: id = file path, name = basename; `:__`-prefixed metadata left out of conversions by convention; path and content-hash as *designators* with file facts as ordinary attributes. The file's example `document  (meta: filename "notes.udon")` doesn't show whether the root has a name, a key, or designators.
- **Q1: the greenfield argument.** The one argument against a root that was never answered: "implicit root changes Host APIs and duplicate-key scope narratives." Is `(element-type, key)` uniqueness (R14, duplicate-definition policy) scoped to the root, the document, or something else?
- **Q1: where anomalies and completeness live.** The D-pack `Document = { content, anomalies, result }` has no counterpart in the file's root. Are warnings root metadata, a side list, or inline `anomaly:` lines as the notation README suggests?
- **Q1: streaming.** With an implied root, what is the streaming unit? The built `stream_tree.rs` ships top-level subtrees, and "root blank lines/warnings ship nothing". Can root attributes (04-B) arrive after children, as K14 late attributes may?
- **Q2: the view option.** The file offers A or B but not the recorded position: A as substrate, B as a *recommended host view* (`all_attributes` vs `key/traits/attributes`), with `$traits` always a list as the one normalization. For an AST-centric spec, the real question may be which of those two the spec *names* as the tree.
- **Q2: other element fields.** Inline vs block elements (`|{…}` vs `|…`): the built tree has an `embedded: bool`, and 0.10.0 separates InlineElement values from segments. Also how an anonymous element's name is represented (the built tree uses `""`; MODEL uses `Name?`).
- **Q3: the host knob.** The file offers A/B but omits the `first_is_main`-style knob that was actually recorded, and the SEMANTICS rule that a serializer must not move text between the two positions.
- **Q3: inline elements.** The biggest consumer-facing consequence goes unmentioned: inline elements on an element's line leave its children under A.
- **Q3: the old behavior.** The Dec 2025 behavior (one merged run across the element line and the body) is not mentioned.
- **Q4: model vs reading.** Options A/B/C mix the model with the reading. The recorded answer is A as substrate, C as the default read, B as an accessor. There is also the K15 "flavor" annotation (stacked vs bracketed spelling as ornamentation the assembler may record), and the leftover last-wins scalar accessor in built code.
- **Q5: the text law.** Any node shape must still reconstruct text by pure concatenation (0.9.1 MODEL §6). The file doesn't say which of A/B/C preserves that without extra rules.
- **Q5: final newlines.** The ruled final-terminator disposition (explicit trailing `\` kept; in-content final newline ornamental) and the three worked examples are missing.
- **Q5: interruptions.** How a comment or an inline element interrupts a run under B. Option A's "one node per source line" also runs into lines split by inline forms.
- **Q5: blank-line placement.** Whether a blank line before a dedent belongs to the node above (Joseph, Jan 13: "tied to what's immediately above it as a child keeps both options open") or to the parent (S9, deferred). Relatedly, lite needs `blank` nodes at all only if it keeps edge blanks for round-trip.
- **Q5: Markdown.** For option C, Joseph's Jul 23 framing puts Markdown structure in a dialect/ADR layer beside the UDON tree, not inside it.
- **Q6: placement.** Comments on the element line (`|el text ; note`), comments inside an attribute's deferred body (0.10.0: an Item of the assignment), and whether comments are *attached* or *positional* (Aug 27 annotation framing; `udon-ast.md` "Comment attachment" in metadata).
- **Q6: inline comments.** `;{…}` inline comments inside text: are they nodes that split a merged text run (Q5-B), or kept outside the text? What happens to their framing spaces (S18: preserved)?
- **Q1–Q6: spans.** Source positions are not raised anywhere: whether spans or line/column are part of the lite tree or a side layer, as in `udon-ast.md`'s SourceInfo. Joseph's Jan 13 remark put form and round-trip detail in such a layer "without cluttering up the 'dig' / path syntax or conceptual mental model."
