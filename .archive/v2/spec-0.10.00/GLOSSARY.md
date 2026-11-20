# UDON Glossary

**Normative.** The source of truth for every formal term in this suite. A capitalized or bolded formal noun not defined here is not a defined term. Each entry names the owning section; the sentence here is the authoritative short form. Retired synonyms at the end MUST NOT be used in new spec text, tooling messages, or documentation.

**The three-way name split (0.10.0-alpha.1):** **key** = identity/selector sense only (`[k]`, `$key`, `$partial-key`, `@x[k]`); **label** = an assignment's name-side (`:label value`); **kind** = a verbatim form's tag (`!:kind:`, a fence's info string). The disambiguation exemplar: *`$key` is the identity key, held by an assignment whose label is `$key`.*

---

## Structure

- **Element** — the structural unit: optional name + ordered assignments + ordered content. Nothing else; identity, traits, suffixes, and sameline text are sugar over designated attributes. (CORE §5; MODEL §3.)
- **Anonymous element** — an element with no name (`|[k]`, `|.trait`, `|?`).
- **Attribute / Assignment** — a labeled edge from its element: a **label** plus ordered, heterogeneous **content** (the common case is one value). The label names what the content is *to the element*; same-label assignments stack in source order, silently. (CORE §6; MODEL §3.)
- **Label** — an assignment's name-side: a contiguous non-space run after `:` (bare — expressive character set) or a quoted label. No built-in label semantics. (CORE §6.2.)
- **Child** — a node in an element's content sequence; names what it *is*; positional, heterogeneous. (CORE §6.1.)
- **Content** — the ordered node sequence belonging to an element. Block content follows the (silently-placed) assignments; late assignments are accepted with a Warning. (MODEL §3; CORE §6.9.)
- **Designated attribute** — an ordinary attribute whose `$`-label is a sugar target (`$key`, `$traits`, `$?`, `$!`, `$*`, `$+`, `$main`, `$partial-key`). Designated, not reserved; bare-writable. (CORE §5.3, §6.10.)
- **`$main`** — the designated attribute carrying an element's sameline text/values; sugar, stacked per value, not text material, host-presented. (CORE §6.10.)
- **Identity / key** — the `[key]` sugar; desugars to `$key`, one assignment per bracket. "Key" always means this sense. Duplicate `(name, key)` pairs are a Document-layer *policy* concern (menu, default error — CORE §12.3). (CORE §5.3.)
- **Trait** — the `.name` sugar; classification, plural, ordered; desugars to stacked `$traits`. (CORE §5.3.)
- **Suffix** — trailing `?` `!` `*` `+` on element identity, desugared to a designated attribute with explicit value `true`; suffixes stack. (CORE §5.4.)
- **Node** — any unit that can appear in content: element, text, comment, verbatim, directive, reference, blank line. (MODEL §2.)
- **Node value** — a value that *is* a node (block-form element, block verbatim, fence, or inert directive), no wrapper. (CORE §6.8; MODEL §4.)
- **Reference** — `@…`: an inert selector `(name?, key?, traits)` naming an element defined elsewhere; recognition core, resolution consumer. (CORE §12.2.)
- **Document** — a complete input: top-level nodes + anomalies + result. (MODEL §1.)

## Spaces, positions, recognition

- **Value-space** — every sameline position: all sameline material is an attribute value; the only question is which attribute. No prose category exists there. (CORE §2.2.)
- **Text-space** — the block interior where prose lives; lines that do not open structure are text of their column owner; markers literal within, framed ` ; ` the one carve-out. (CORE §2.2, §7.)
- **Structure Position** — the state in which markers are recognized: line start at a structural column, or along the Line Scan between values. (CORE §2.2.)
- **Line Scan** — the left-to-right pass along a line through elements, assignments, and values. (CORE §6.4.)
- **Marker** — a character that can begin structure at Structure Position: `|` `:` `!` `;` `@` or a fence opener. (CORE §2.2.)
- **Guard** — the bounded lookahead confirming a marker; failure means the character is literal. (CORE §3.)
- **Value terminator** — what ends an unquoted text value: space + guard-confirmed block-form marker, framed `\`, framed ` ; `, end of line, or the context terminator. (CORE §6.4.)
- **Value-expected position** — a value slot where no text has committed; the full value grammar applies there, brace forms self-delimiting as values. Exists wherever a value is expected: value slots, list items, key-bracket interiors, a deferred body's first line. (CORE §6.4.)
- **Line root** — the owner of post-value material on a line: the element (`$main` stack) on element-rooted lines; the label's stack on block attribute lines. (CORE §6.5.)
- **Escape `\`** — the one escape; two operations by frame: framed ` \ ` commits text mode, attached `\X` escapes one character; literal elsewhere. (CORE §4.)
- **Text mode** — the state after a framed `\`: rest of line is text, spaces preserved, dead to markers and comments. (CORE §4.)
- **Column / base column** — leading-space count; the column of an item's introducing marker, driving the Nesting Rule. (CORE §2, §2.1.)
- **Nesting Rule** — `pop while new_column <= stack_top.base_column`, then push. (CORE §2.1.)
- **Sameline / block** — on the element's definition line vs on its own indented line. (CORE §6.1.)
- **Content base** — the column anchoring a text block's dedentation, set by its first indented line. (CORE §7.2.)
- **Raw base** — the content-base analogue for a block verbatim body: its first content line's column. (CORE §10.1.)

## Text and flow

- **Flow** — the one prose-shaped content model: ordered segments resolving to text once each segment's layer processes it. Three homes, one rule set: block text, text values, inline-form interiors. (CORE §7.1.)
- **Text value** — an assignment value that is flow (unquoted text or `\`-forced). (CORE §6.4–6.5.)
- **Segment** — one piece of flow: text run, inline element, interpolation, inline directive, inline verbatim (inline comments contribute no segment text). (MODEL §4.)
- **Inline form** — a brace-delimited construct inside flow: `|{…}`, `;{…}`, `!{{…}}`, `!{…}`, `!{:kind:…}`. (CORE §7.3.)
- **Inline element** — the `|{…}` form; bracket mode inside; a value at value-expected positions, a segment mid-flow. (CORE §5.6, §6.4.)
- **Text** — literal character data including its line terminators; the only channel that carries text. (MODEL §6.)
- **The text law** — document text reconstructs by pure in-order concatenation of text; no fabricated joins, no source consultation. Assignments — `$main` included — are not text material. (MODEL §6.)
- **Blank line** — a whitespace-only line not protruding past the content base; contributes `"\n"`; interior = text, edges = ornamentation. (CORE §7.4.)
- **Ornamentation** — UDON-level decoration (edge blanks, trimmed final terminators) that is not text content. (CORE §7.4.)

## Values and types

- **Syntactic typing** — type from written syntax, never sniffing. (CORE §11.1.)
- **Bare scalar set** — the closed, frozen set recognized bare: string, integer, float, boolean, nil, list. The envelope is *recognized* bare but is not a core scalar — it is the hand-off to dialects. (CORE §11.1.)
- **Envelope** — `<…>` in value position; depth-counted to the matching `>`; multi-line; the visible core/dialect boundary. (CORE §11.6.)
- **Envelope ladder** — `<content>` / `<type:content>` / `<dialect:type:content>`. *(Rename from "label ladder" pending the Q7 steward call — working-notes.)* (CORE §11.6.)
- **Dialect** — a named layer giving meaning/typing to envelope contents (e.g. `temporal@1`). Types, never constrains. (CORE §1.1.)
- **Schema** — the layer saying what is allowed or required; constraint lives only here. (CORE §1.1.)
- **Stacking** — spreading a label's collection across occurrences: each appends its value as one contribution, ordered, silent, interleavable; last-wins does not exist; a bracketed list is one contribution. (CORE §6.7.)
- **List** — `[…]`: space-delimited items, each typed by the full value rules (inline elements included); no multi-word unquoted text inside. (CORE §11.5.)
- **Nil** — explicit no-value (`null` ≡ `nil`); distinct from absent and from false. No implicit nil, no implicit true. (CORE §11.4.)
- **Interpolation** — `!{{expr}}`, carried unparsed for the host. (CORE §9.)
- **`$partial-key`** — the designated attribute an *unclosed* identity or selector key desugars to; fail-safe non-identity. (CORE §5.3.)

## Extents, verbatim, dynamics

- **Geometric extent** — closed by geometry: EOL, dedent, or end of input. (CORE §13.1.)
- **Delimited extent** — closed only by a matching printed end-sequence. (CORE §13.1.)
- **Verbatim** — content never parsed as UDON: one family (block `!:kind:`, fence, inline `!{:kind:…}`) around an opaque body. (CORE §10.)
- **Fence** — the ``` form: byte-exact, no dedent, opener tail is its kind. (CORE §10.3.)
- **Kind** — a verbatim form's optional tag, passed to the host uninterpreted. (CORE §10.)
- **Directive** — `!name …` at Structure Position; any name; body parsed as UDON; inert this version; meaning is a dialect's. (CORE §9.)
- **Incomplete-input** — the document result when a delimited extent was open at true end of input. (CORE §13.3; MODEL §1.)
- **ADM / Abstract Document Model** — the Document Model (MODEL.md); one pillar, two names. Formal synonyms — not a retirement.
- **Recognizer / Recognition** — the conformance target of this suite: the layer performing surface recognition (source text → the ADM plus anomalies), below every Consumer. (CORE §1.)

## Anomalies and layers

- **Anomaly** — a Warning or Error attached to recognition. (MODEL §7.)
- **Warning** — everything kept, possibly not as intended. (CORE §14.1.)
- **Error** — something lost, or a required value genuinely absent; non-halting. The sole core Error is the missing required value. (CORE §14.1.)
- **Keep-Everything** — wherever a coherent keep exists, keep and warn rather than drop. (CORE §14.2.)
- **Consumer** — any layer above recognition: document builder, schema validator, host application. (CORE §1.1.)
- **Host** — the embedding environment supplying projection, dialects, dynamics evaluation, resolution, `$main` presentation. (CORE §1.1.)
- **Document layer** — the consumer assembling/judging a whole tree (duplicate policy, uniqueness) as opposed to streaming recognition. (CORE §12.3.)
- **Menu vs knob** — core fixes an option space and default; consumers pick within it, never outside it. (CORE §1.1.)
- **Projection** — host turning a validated value into a native value.
- **View** — a recommended accessor shape over the assignment substrate. (MODEL §3.2.)

---

## Retired terms

| Retired | Use instead |
|---|---|
| key (attribute name-side) | **label** — "key" is identity/selector only |
| label (verbatim/fence tag) | **kind** |
| flag key, flag semantics | *(retired concept; presence is explicit)* |
| warned extension | *(retired concept; stacking is silent)* |
| content phase | **late attributes** (accepted + warned); the closing-window concept is retired |
| commit (to prose), open→commit | **text-space** rules (CORE §2.2); sameline never commits to prose |
| bare-token boundary | **value terminator** |
| inline-brace principle (as universal) | mid-flow segment rule (value-expected positions self-delimit) |
| blob, text blob | **flow**, **text value** |
| freeform | **fence** (form) / **verbatim** (family) |
| raw (as a free noun) | **verbatim** (block form: "block verbatim") |
| embedded (element) | **inline element** |
| head position, open position | **Structure Position** |
| the scan (as formal term) | **Line Scan** |
| positional (extent) | **geometric extent** |
| segment-ingest, warn-and-stack | *(retired with warned extension)* |
| multi-segment value | stacked assignments |
| sameline decompress, element tail | **`$main`** |
| wire, event (in this suite's contract) | *(absent by design — see README)* |
