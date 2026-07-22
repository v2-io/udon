---
source: udon umbrella repo — core/ Rust workspace (udon-core) + tools/descent submodule
gathered: 2026-07-21
status: characterization — mechanism map, not a copy; read the cited files at point of use
paths:
  - /Users/josephwecker-v2/src/udon/core/udon-core/src/lib.rs:1-52
  - /Users/josephwecker-v2/src/udon/core/udon-core/src/stream_tree.rs:1-243
  - /Users/josephwecker-v2/src/udon/core/udon-core/src/span.rs:1-55
  - /Users/josephwecker-v2/src/udon/core/udon-core/src/tree.rs:58-560 (NodeKind, Node, ElementView accessor API)
  - /Users/josephwecker-v2/src/udon/core/udon-core/examples/ (stdin_parse, gen_events, tree_parse, highlight, show_formats, simple_parse .rs)
  - /Users/josephwecker-v2/src/udon/tools/descent/README.md:1-40 (+ SYNTAX.md, examples/udon_complete.desc)
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [library-api, host-contract, streaming, edit-spans, tool-definition-anatomy, meta-language, dogfood, supply-side, harness-facing]
why_included: >
  Section 7a is the supply-side register: what a HOST does with UDON parse
  products. It reads as supply-side, but the demand signal is real and
  dual-audience — the shape of this API IS the answer to "what does a
  consuming agent/harness need to be handed after a parse?" Characterized (not
  copied) because the value is the surface's shape, not the plumbing. Directly
  feeds both consumers: UDON v2 (its own product) and the harness programme
  (this is a worked instance of tool-definition anatomy + a resumable
  observation stream).
---

> **Reading note for the harness programme (second consumer).** Everything
> below is a concrete, shipped instance of abstractions the harness thesis
> argues for in the abstract: an *observation stream* an agent can consume
> incrementally, *edit spans* an edit tool can target, *typed/located
> warnings as data* rather than prose, and *ergonomic host views* over a
> lossless wire. Where a row says "for UDON," read it as one application of
> a substrate-independent need.

# 7a — Library / streaming / API surfaces: what hosts get from a parse

The witness question here: **when an agent or a host program finishes (or is
mid-way through) parsing a document, what does it actually need handed back
to it, and in what shape?** The udon-core surface is a worked answer.

## The dual product: one wire, two consumption shapes

`lib.rs` (the public API declaration) exposes exactly two ways to consume a
parse, and the module doc frames them as first-class equals:

1. **Streaming (SAX-like).** `Parser::new(bytes).parse(|event| …)` — a
   callback fires per event; nothing is accumulated. This is the foundation,
   not a feature (the pre-umbrella `libudon/PLAN.md` states this in almost
   those words; see the archaeology characterization). Every higher layer,
   including the tree, is "just another event consumer."
2. **Tree (DOM-like).** `Document::parse(bytes)` → an arena-backed tree you
   walk with `.root().children()`, `.kind()`, etc.

The demand claim embodied here: a tooling substrate should not force the
DOM-vs-SAX choice on its consumers. An agent doing a targeted read wants the
tree; a harness streaming a model's generation wants events. Both come off
the same parser.

## The event wire — the names ARE the contract

`stream_tree.rs`'s `to_owned_event` enumerates the full event vocabulary that
hosts depend on. It is worth having the list itself, because "the event names
are the wire product hosts depend on" (TARGET-FILES §7a, of `parser.rs`):

- **Structural bracket pairs:** `ElementStart/End`, `EmbeddedStart/End`
  (`|{…}`), `DirectiveStart/End`, `ArrayStart/End`, `FreeformStart/End`
  (```` ``` ````), `CommentStart/End`.
- **Content-bearing leaves:** `Name`, `Text`, `Attr`, `StringValue`,
  `BareValue`, `BoolTrue`, `BoolFalse`, `Nil`, `Interpolation`, `Reference`,
  `RawContent`, `Raw`, `Integer`, `Float`, `Rational`, `Complex`.
- **Meta events:** `Warning` (content), `BlankLine` (content — carries "\n";
  the text-wire recast made terminators text, so the document reconstructs by
  *pure in-order concatenation* of text-bearing events), and `Error { code,
  span }`.

Every event carries a `Span` (see below). Typed scalars (`Integer`, `Float`,
`Rational`, `Complex`, `BoolTrue/False`, `Nil`) are emitted as distinct
events, not as `Text` the host must re-lex — i.e. the parse *is* the typing.
(This is the concrete instrument behind the dossier's κ×A "sharp/typed/located
parse outcomes as a bias-reduction tool" — a consumer never has to guess
whether `null` is a value or a string.)

## Spans everywhere — the edit/re-highlight affordance

`span.rs`: `Span { start: u32, end: u32 }` byte offsets on every event, plus a
`Location { line, column, byte_offset }` for error reporting. This is the
substrate for three named products the maps care about: **edit-targeting**
(an edit tool needs to know where a node's bytes are), **incremental
re-highlight** (the wasm highlighting engine), and **diagnostics that point at
source**. `parser_pd.rs` (the pushdown backend, 544 KB generated) and
`stream_tree.rs::StreamingTreeParser` make the stream **resumable at ANY byte
boundary** — feed chunks exactly as they arrive (network, model tokens),
subtrees ship as they close. `TreeStream` ships "one completed root-level node
per shipment … the finest granularity at which 'complete' is meaningful,"
each as an owned `Document<'static>` that outlives its input chunk.

## Host Views — ergonomics over a lossless wire

`tree.rs` `NodeKind::Element` stores `attrs` = EVERY attribute in document
order, *including* the desugared identity attributes (`$key`, `$traits`,
`$?`). The comment is explicit: "The substrate is CORE's wire truth … nothing
is consumed or reordered, so `all_attributes` round-trips." Over that lossless
substrate, `ElementView` offers the **"Host Views (Recommended)"** ergonomic
layer CORE names: `.key()`, `.traits()`, `.has_trait()`, `.has_flag()`,
`.attr(name)`, `.attr_all(name)`, `.attributes()` (derived) vs
`.all_attributes()` (raw), `.is_anonymous()`, `.is_embedded()`, `.name()`,
`.text_content()`, `.all_text()`. The demand principle: **give consumers a
friendly API without ever throwing away the wire** — lossless-first, ergonomic
on top, round-trip preserved. That is a direct answer to the schema-guarded /
"make invalid states unrepresentable" cluster: a host can't accidentally lose
data the friendly view hides, because the raw view is always there.

## Examples = the de-facto CLI / half-built tools

The `examples/*.rs` are, per the map, "de-facto CLI / half-built tools —
`stdin_parse` is what stewards use today." Present: `stdin_parse`,
`gen_events`, `tree_parse`, `highlight`, `show_formats`, `simple_parse`
(+ bench/profile harnesses `bench_tree`, `mem_profile`, `pd_profile`,
`manual_test`, `test_parse`). The demand residue: real users (Joseph's own
stewards, vivarium's `stdin_parse` usage) are running examples as tools
because no shipped CLI exists yet — a concrete unmet-CLI demand, corroborated
independently in the live-consumers section (§5) and the TOOLING-WISHLIST.

## descent — UDON as a meta-language consumer (grammar-as-UDON dogfood)

`core/generator/*.descent.udon` (10 topical units, `00-core` … `90-references`,
+ `temporal-value.desc.setaside`) are the grammar written *in UDON-flavoured
descent* — UDON's own parser is specified in a UDON dialect. `tools/descent`
(the pinned submodule, independent repo) is a recursive-descent parser
*generator* whose philosophy — "the DSL describes *what* to parse; the
generator figures out *how*"; "type-driven emit," "inferred EOF," "true
recursion: the call stack IS the element stack" — is itself agentic-tooling
ideology applied to grammar authoring (make the right thing the easiest thing;
declarative intent over imperative mechanism). This is the corpus's clearest
**dogfood** datapoint: the notation is load-bearing for building the notation,
and descent is a second consumer whose needs (a legible `.desc` grammar, an
in-vivo `<…>` sub-parser question) shaped UDON.

## Agreements / divergences vs the 02 synthesis layer

Consulted `syntheses/CONVERGENCES.md` AFTER forming the above from the source.

- **Agreements (this API instantiates existing clusters):** Cluster 17
  (tool-definition anatomy — the event enum + ElementView is a name/typed-
  schema/host-view triple); Cluster 1 (edit-representation — spans are the
  edit-targeting substrate the "no validity guarantees" gap wants filled);
  Cluster 18 (stream discipline — `show_formats`/`gen_events`/`stdin_parse`
  are the stdout-data / structured-output shape); Cluster 15 (errors that
  teach — `Warning` and `Error{code,span}` are located, structured, non-fatal;
  the stream "recovers and continues, errors don't abort subtree delivery").
- **Divergence worth surfacing:** the CONVERGENCES singleton "yq `match()`
  span primitive … directly relevant to the value-bracket wire redesign"
  treats position-as-first-class-queryable-data as a Tier-2 import to
  aspire to. But udon-core **already ships** byte-span-per-event + a resumable
  stream — the estate has an in-house instance of that primitive, not just an
  external exemplar. Merge-time flag: the value-bracket wire reconception (the
  active 2026-07-19 pivot) is being designed against yq as prior art when a
  home-grown span+event product already exists and should be a co-equal input.
- **Divergence (tier placement):** these files are marked supply-side / §7
  "out of scope" in the six-map merge. Treating them as *pure* supply-side
  under-reads them: an API surface is a demand artifact about its consumers.
  The harness programme (second consumer) needs this register first-class, so
  the seam-transport that pulled §7 back in was correct.
