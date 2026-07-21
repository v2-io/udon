# UDON Glossary

**Normative.** This glossary is the source of truth for every formal term used
in the UDON specification suite. A capitalized or bolded formal noun that does
not appear here is not a defined term. Each entry names the document/section
that owns the full definition; the sentence here is the authoritative short
form.

Terms are grouped by concern, alphabetized within each group. Retired synonyms
are listed at the end — they MUST NOT be used in new spec text, tooling
messages, or documentation.

---

## Structure

- **Attribute** — a labeled edge from its element: a key plus a value
  assignment. The key names what the value *is to the element*. Same-key
  assignments stack in source order. (SPEC §5; ADM §3.)
- **Child** — a node in an element's content sequence. A child names what it
  *is*; children are positional and heterogeneous. (SPEC §5.1; ADM §2.)
- **Content** — the ordered sequence of nodes (children, text, comments, …)
  belonging to an element, following all of its attributes. (ADM §2.)
- **Designated attribute** — an ordinary attribute whose key begins with `$`
  and is the target of surface sugar (`$key`, `$traits`, `$?`, `$!`, `$*`,
  `$+`, `$partial-key`). Designated, not reserved: any `$`-key may be written
  longhand with quotes. (SPEC §4.3.)
- **Document** — a complete UDON input: an ordered sequence of top-level
  nodes plus its collected anomalies. (ADM §1.)
- **Element** — the structural unit: an optional name, an ordered attribute
  sequence, and content. Nothing else — identity, traits, and suffixes are
  sugar over designated attributes. (SPEC §4; ADM §2.)
- **Anonymous element** — an element with no name (`|[k]`, `|.trait`, `|?`).
  (SPEC §4.5.)
- **Identity** — the `[key]` sugar: the value that makes an element uniquely
  itself within its element type; desugars to `$key`. (SPEC §4.2.)
- **Node** — any unit that can appear in content: an element, text, a
  comment, a verbatim block, a directive, an interpolation, or a reference.
  (ADM §2.)
- **Node value** — an attribute value that *is* a node (block-form element,
  block verbatim, or fence), with no wrapper. (SPEC §5.6.)
- **Reference** — `@…`: an inert selector `(name, key, traits)` naming an
  element defined elsewhere. Recognition is core; resolution is a consumer
  concern. (SPEC §9.)
- **Trait** — the `.name` sugar: a classification of what *kinds* of thing an
  element is; plural, ordered; desugars to stacked `$traits`. (SPEC §4.2.)
- **Flag suffix** — a trailing `?` `!` `*` `+` on an element's identity,
  desugaring to a designated boolean attribute (`|el?` → `:'$?' true`).
  (SPEC §4.4.)

## Lines, positions, recognition

- **Bare token** — an unquoted, single-token value candidate; its fate
  (single-token value vs. the first word of flow) is settled by the boundary
  decision. (SPEC §5.5.)
- **Boundary decision** — the one-character look at a bare token's end: a
  block-form marker means the token stands alone as a value; anything else
  commits a flow value beginning with that token. (SPEC §5.5.)
- **Column** — a zero-based character position within a line. Column
  relationships (deeper / same / shallower) define the hierarchy. (SPEC §3.)
- **Commit (to text)** — the moment a line or value position stops being open:
  from there to end of line, markers are literal, with the framed sameline
  comment as the sole named exception. (SPEC §3.3.)
- **Escape (`\`)** — the one escape character. Its effect is fixed by
  position alone: open position → the rest of the line is text; before an
  inline opener in flow → that opener is literal; value position → the value
  becomes flow text; anywhere else → a literal backslash. (SPEC §3.5.)
- **Guard** — the bounded lookahead (a few characters) that decides whether a
  marker character at open position is structural or literal. (SPEC §3.4.)
- **Indentation** — the run of spaces (only spaces) before a line's first
  character. Tabs in indentation are an error. (SPEC §3.1.)
- **Marker** — a character that can begin structure at open position: `|`
  (element), `:` (attribute), `!` (dynamic), `;` (comment), `@` (reference),
  or a fence opener (```` ``` ````). (SPEC §3.2.)
- **Open position** — any point where a marker would be recognized: the start
  of a line at a structural column, or within the scan before the line has
  committed to text. (SPEC §3.3.)
- **The scan** — the uniform left-to-right pass along a line through elements
  and attributes, collecting each attribute's value and then continuing for
  the current owner. (SPEC §5.4.)
- **Sameline** — on an element's own definition line (attributes, prose tail,
  further elements). Contrast **block**: on its own indented line.
  (SPEC §3.6.)
- **Structural column** — a column at which a new node may begin, given the
  currently open hierarchy; a line indented deeper than an established
  content base is inside that text, not at a structural column. (SPEC §3.1,
  §6.2.)

## Text and flow

- **Content base** — the column that anchors a text block's dedentation: the
  first continuation line of a text block (or verbatim body) establishes it;
  that many leading spaces are removed from each line. (SPEC §6.2.)
- **Flow** — the one prose-shaped content model: an ordered sequence of
  segments (text, inline forms) that resolves to text once each segment's
  layer has processed it. Flow has three homes — element prose, flow values,
  and inline-form interiors — with one set of rules. (SPEC §6.1.)
- **Flow value** — an attribute value that is flow. (SPEC §5.5.)
- **Inline form** — a brace-delimited construct inside flow: inline element
  `|{…}`, inline comment `;{…}`, interpolation `!{{…}}`, inline directive
  `!{…}`, inline verbatim `!{:kind:…}`. No inline form is ever a boundary
  marker (the inline-form principle). (SPEC §6.3, §5.5.)
- **Inline element** — the `|{…}` form of an element inside flow. Inside it,
  only inline forms may nest. (SPEC §6.3.)
- **Segment** — one piece of flow: a text run, an inline element, an
  interpolation, an inline directive, an inline verbatim, or an inline
  comment. (ADM §4.)
- **Text** — literal character data, including its line terminators. The
  document's full text reconstructs by in-order concatenation of text; no
  other channel carries text. (ADM §4.)

## Values and types

- **Bare scalar set** — the closed set of scalar types recognized from bare
  syntax alone: string, integer, float, boolean, nil, list. Frozen: nothing
  is ever added to bare recognition. The envelope is also *recognized* bare
  (its `<` opens in value position) but is not a core scalar type — it is
  the hand-off to dialects, deliberately outside the frozen set. (SPEC §10.)
- **Dialect** — a named layer that gives meaning/typing to envelope contents
  (e.g. `temporal@1`). A dialect types; it never constrains. (SPEC §10.4.)
- **Envelope** — the `<…>` form carrying a dialect-typed value in value
  position; closes at the matching `>` (depth-counted). The visible boundary
  between core scalars and dialect types. (SPEC §10.4.)
- **Flag key** — an attribute key ending in `?`, selecting boolean/presence
  semantics: bare presence means `true`; only a lone keyword can be its
  explicit value. (SPEC §5.3.)
- **Interpolation** — `!{{expr}}`: an expression the core carries unparsed
  for a host to evaluate. (SPEC §8; DYNAMICS.)
- **List** — the `[…]` value form: space-delimited items, each typed
  independently by the full value rules; no flow inside. (SPEC §10.3.)
- **Nil** — the explicit no-value (`null` / `nil`, equivalent). Distinct from
  absent (key not present) and from `false`. (SPEC §10.2.)
- **Scalar** — a value of the bare scalar set. (SPEC §10.)
- **Schema** — the layer that says what is *allowed or required*
  (cardinality, vocabularies). Constraint lives only here, never in core.
  (SPEC §1.3.)
- **Stacking** — the uniform rule that repeated same-key assignments
  accumulate as an ordered sequence; last-wins does not exist in UDON.
  (SPEC §5.7; ADM §3.)
- **Syntactic typing** — a value's type comes from its written syntax, never
  from sniffing its content. (SPEC §10.)
- **Warned extension** — material arriving after an attribute's finished
  value that is kept as a further assignment under that key, with a warning;
  the keep-everything alternative to dropping. (SPEC §5.7.)

## Extents, verbatim, dynamics

- **Delimited extent** — an extent closed only by a matching printed
  end-sequence (quote, `]`, `}`, `}}`, `>`, fence closer). (SPEC §11.1.)
- **Directive** — `!name …` at open position: a dynamic whose meaning a host
  dialect provides; its body is parsed as UDON. (SPEC §8.)
- **Fence** — the ``` verbatim form: byte-exact capture, no dedentation, no
  marker interpretation; opener's trailing text is the info label.
  (SPEC §7.3.)
- **Geometric extent** — an extent taken from geometry: end of line, dedent,
  or end of input. Elements, attributes' deferred values, comments,
  directives, and block verbatim have geometric extents. (SPEC §11.1.)
- **Label** — the optional tag a verbatim form carries (`elixir`, `json`, a
  fence info string), passed to the host uninterpreted. (SPEC §7.)
- **Verbatim** — content never parsed as UDON: one family with three forms —
  block (`!:label:`), fence (``` ), inline (`!{:label:…}`) — around an opaque
  body. (SPEC §7.)

## Anomalies and results

- **Anomaly** — a warning or error attached to the parse. (SPEC §11.)
- **Error** — the anomaly level meaning content was lost. Errors do not halt
  a conforming parser. (SPEC §11.2.)
- **Incomplete input** — the per-document result when a delimited extent is
  still open at true end of input; reported by the consuming layer as
  non-success. (SPEC §11.4.)
- **Keep-everything** — the core commitment: wherever a coherent
  keep-everything response exists, a conforming parser MUST keep all input
  content and warn rather than drop. (SPEC §11.2.)
- **Warning** — the anomaly level meaning all content was kept but may not
  match the author's intent. (SPEC §11.2.)

## Consumers and layers

- **ADM (Abstract Document Model)** — the normative data shape a conforming
  parse produces; defined in ADM.md.
- **Consumer** — any layer above the core parse: an AST/document builder, a
  schema validator, a host application. (SPEC §1.3.)
- **Host** — the environment embedding UDON, which supplies projection,
  dialects, dynamics evaluation, and reference resolution. (SPEC §1.3.)
- **Menu vs. knob** — the boundary rule for consumer choice: core fixes an
  option space and default; a consumer picks within it and may never invent
  an option outside it. (SPEC §1.3.)
- **Projection** — a host turning a validated string into a native value.
  (SPEC §1.3.)
- **View** — a recommended host accessor shape over the attribute substrate
  (`all_attributes`; the `key`/`traits`/`attributes` split). (ADM §5.)

---

## Retired terms

| Retired | Use instead |
|---|---|
| blob, text blob | **flow**, **flow value** |
| freeform | **fence** (the form) / **verbatim** (the family) |
| raw (as a noun) | **verbatim** (block form) |
| embedded element | **inline element** |
| head position | **open position** |
| positional (close/construct) | **geometric extent** |
| segment-ingest, warn-and-stack | **warned extension** |
| sameline decompress | element tail (plain description; SPEC §5.5) |
| multi-segment value | stacked assignments (SPEC §5.7) |
