# UDON Glossary

**Normative.** The source of truth for every formal term in this suite. A
capitalized or bolded formal noun not defined here is not a defined term.
Each entry names the owning section; the sentence here is the authoritative
short form. Retired synonyms at the end MUST NOT be used in new spec text,
tooling messages, or documentation.

---

## Structure

- **Element** — the structural unit: optional name + ordered attributes +
  ordered content. Nothing else; identity, traits, and suffixes are sugar
  over designated attributes. (CORE §5; MODEL §3.)
- **Anonymous element** — an element with no name (`|[k]`, `|.trait`, `|?`).
- **Attribute** — a labeled edge from its element: a key plus one value per
  assignment. The key names what the value is *to the element*; same-key
  assignments stack in source order. (CORE §6; MODEL §3.)
- **Assignment** — one key-value pair in an element's ordered attribute
  sequence. (MODEL §3.)
- **Child** — a node in an element's content sequence; names what it *is*;
  positional, heterogeneous. (CORE §6.1.)
- **Content** — the ordered node sequence belonging to an element,
  following all its attributes. (MODEL §3.)
- **Content phase** — the state an element enters once any content exists;
  its attribute window is closed. (CORE §6.9.)
- **Designated attribute** — an ordinary attribute whose `$`-key is a sugar
  target (`$key`, `$traits`, `$?`, `$!`, `$*`, `$+`, `$partial-key`).
  Designated, not reserved. (CORE §5.3.)
- **Identity** — the `[key]` sugar; desugars to `$key`; unique per element
  name at the Document layer. (CORE §5.3.)
- **Trait** — the `.name` sugar; classification, plural, ordered; desugars
  to stacked `$traits`. (CORE §5.3.)
- **Flag suffix** — trailing `?` `!` `*` `+` on element identity, desugared
  to a designated boolean attribute; suffixes stack. (CORE §5.4.)
- **Node** — any unit that can appear in content: element, text, comment,
  verbatim, directive, interpolation, reference, blank line. (MODEL §2.)
- **Node value** — an attribute value that *is* a node (block-form element,
  block verbatim, or fence), no wrapper. (CORE §6.8.)
- **Reference** — `@…`: an inert selector `(name?, key?, traits)` naming an
  element defined elsewhere; recognition core, resolution consumer.
  (CORE §12.2.)
- **Document** — a complete input: top-level nodes + anomalies + result.
  (MODEL §1.)

## Positions and recognition

- **Structure Position** — the state in which markers are recognized: line
  start at a structural column, or along the Line Scan. Canonical name
  (ruled N-pos; "open position" is an allowed alias in prose, once).
  (CORE §2.2.)
- **Line Scan** — the left-to-right pass along an element-rooted line
  through elements and attributes, collecting each attribute's value and
  continuing for the current owner. Canonical name (ruled N-scan; "the
  scan" allowed once). (CORE §6.4.)
- **Marker** — a character that can begin structure at Structure Position:
  `|` `:` `!` `;` `@` or a fence opener. (CORE §2.2.)
- **Guard** — the bounded lookahead confirming a marker; failure means the
  character is literal. (CORE §3.)
- **Commit (to prose)** — the moment Structure Position ends for a line:
  from there markers are literal, except the framed sameline comment.
  (CORE §2.2.)
- **Escape `\`** — the one escape; meaning fixed by position alone.
  (CORE §4.)
- **Bare token** — an unquoted single-token value candidate; its fate is
  settled at the bare-token boundary. (CORE §6.4.)
- **Bare-token boundary** — the one-character decision at a bare token's
  end: a guard-confirmed block-form marker finishes it as a value; anything
  else commits a flow value. (CORE §6.4.)
- **Inline-brace principle** — no inline brace form is ever a boundary
  marker or mode exit; inline forms commit/continue text mode and fire as
  segments. (CORE §6.4.)
- **Column / base column** — leading-space count; the column of an item's
  introducing marker, driving the Nesting Rule. (CORE §2, §2.1.)
- **Nesting Rule** — `pop while new_column <= stack_top.base_column`, then
  push. (CORE §2.1.)
- **Sameline / block** — on the element's definition line vs on its own
  indented line. (CORE §6.1.)
- **Content base** — the column anchoring a text block's dedentation, set
  by its first indented line. (CORE §7.2.)
- **Raw base** — the content-base analogue for a block verbatim body: its
  first content line's column. (CORE §10.1.)

## Text and flow

- **Flow** — the one prose-shaped content model: ordered segments resolving
  to text once each segment's layer processes it. Three homes, one rule
  set: element prose, flow values, inline-form interiors. (CORE §7.1.)
- **Flow value** — an attribute value that is flow. (CORE §6.4–6.5.)
- **Segment** — one piece of flow: text run, inline element,
  interpolation, inline directive, inline verbatim (inline comments
  contribute no segment text). (MODEL §4.)
- **Inline form** — a brace-delimited construct inside flow: `|{…}`,
  `;{…}`, `!{{…}}`, `!{…}`, `!{:kind:…}`. (CORE §7.3.)
- **Inline element** — the `|{…}` form; bracket mode inside. (CORE §5.6.)
- **Text** — literal character data including its line terminators; the
  only channel that carries text. (MODEL §6.)
- **The text law** — document text reconstructs by pure in-order
  concatenation of text; no fabricated joins, no source consultation.
  (MODEL §6.)
- **Blank line** — a whitespace-only line not protruding past the content
  base; contributes `"\n"`; interior = text, edges = ornamentation.
  (CORE §7.4.)
- **Ornamentation** — UDON-level decoration (edge blanks, trimmed final
  terminators) that is not text content. (CORE §7.4.)

## Values and types

- **Syntactic typing** — type from written syntax, never sniffing.
  (CORE §11.1.)
- **Bare scalar set** — the closed, frozen set recognized bare: string,
  integer, float, boolean, nil, list. The envelope is *recognized* bare but
  is not a core scalar — it is the hand-off to dialects. (CORE §11.1.)
- **Envelope** — `<…>` in value position; depth-counted to the matching
  `>`; multi-line; the visible core/dialect boundary. (CORE §11.6.)
- **Label ladder** — `<content>` / `<type:content>` /
  `<dialect:type:content>`. (CORE §11.6.)
- **Dialect** — a named layer giving meaning/typing to envelope contents
  (e.g. `temporal@1`). Types, never constrains. (CORE §1.1.)
- **Schema** — the layer saying what is allowed or required; constraint
  lives only here. (CORE §1.1.)
- **Flag key** — a key with terminal `?`: presence/boolean semantics; bare
  presence = true; only a lone keyword is an explicit value. (CORE §6.2.)
- **Stacking** — repeated same-key assignments accumulate, ordered;
  last-wins does not exist. (CORE §6.7.)
- **Warned extension** — post-finished-value material kept as a further
  assignment under the key, with a Warning. (CORE §6.7.)
- **List** — `[…]`: space-delimited items, each typed by the full value
  rules; no flow inside. (CORE §11.5.)
- **Nil** — explicit no-value (`null` ≡ `nil`); distinct from absent and
  from false. (CORE §11.4.)
- **Interpolation** — `!{{expr}}`, carried unparsed for the host.
  (CORE §9.)
- **`$partial-key`** — the designated attribute an *unclosed* identity or
  selector key desugars to; fail-safe non-identity. (CORE §5.3.)

## Extents, verbatim, dynamics

- **Geometric extent** — closed by geometry: EOL, dedent, or end of input.
  (CORE §13.1.)
- **Delimited extent** — closed only by a matching printed end-sequence.
  (CORE §13.1.)
- **Verbatim** — content never parsed as UDON: one family (block
  `!:label:`, fence, inline `!{:label:…}`) around an opaque body.
  (CORE §10.)
- **Fence** — the ``` form: byte-exact, no dedent, opener tail is the info
  label. (CORE §10.3.)
- **Label** — a verbatim form's optional tag, passed to the host
  uninterpreted. (CORE §10.)
- **Directive** — `!name …` at Structure Position; any name; body parsed as
  UDON; meaning is a dialect's. (CORE §9.)
- **Incomplete-input** — the document result when a delimited extent was
  open at true end of input. (CORE §13.3; MODEL §1.)

## Anomalies and layers

- **Anomaly** — a Warning or Error attached to recognition. (MODEL §7.)
- **Warning** — everything kept, possibly not as intended. (CORE §14.1.)
- **Error** — something lost, or a required value genuinely absent;
  non-halting. (CORE §14.1.)
- **Keep-Everything** — wherever a coherent keep exists, keep and warn
  rather than drop. (CORE §14.2.)
- **Consumer** — any layer above recognition: document builder, schema
  validator, host application. (CORE §1.1.)
- **Host** — the embedding environment supplying projection, dialects,
  dynamics evaluation, resolution. (CORE §1.1.)
- **Document layer** — the consumer assembling/judging a whole tree
  (duplicate policy, uniqueness) as opposed to streaming recognition.
  (CORE §12.3.)
- **Menu vs knob** — core fixes an option space and default; consumers pick
  within it, never outside it. (CORE §1.1.)
- **Projection** — host turning a validated string into a native value.
- **View** — a recommended accessor shape over the attribute substrate.
  (MODEL §3.2.)

---

## Retired terms

| Retired | Use instead |
|---|---|
| blob, text blob | **flow**, **flow value** |
| freeform | **fence** (form) / **verbatim** (family) |
| raw (as a free noun) | **verbatim** (block form: "block verbatim") |
| embedded (element) | **inline element** |
| head position, open position | **Structure Position** (alias "open position" once in prose) |
| the scan (as formal term) | **Line Scan** |
| positional (extent) | **geometric extent** |
| segment-ingest, warn-and-stack | **warned extension** |
| multi-segment value | stacked assignments |
| sameline decompress | element tail (plain description) |
| wire, event (in this suite's contract) | *(absent by design — see README)* |
