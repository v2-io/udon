# UDON and Markdown -- the four layers

> **⚠️ In progress -- a draft, unratified by Joseph.** This gives the basic lay of the land: the *layer boundaries* are sound, but the specific enumerations and policies (the Layer-1 subset, the Layer-2 `doc` vocabulary, the conversion and rendering decisions) are provisional and **To Be Specified**.

**A companion spec to CORE.md.** UDON touches Markdown in four distinct ways. Tools, spec text, and conversations keep sliding between them; each has a different owner, different conformance requirements, and different failure modes. This document lays down the distinctions and says which layer owns what.

## The law

1. **The core parser knows none of this.** Prose is opaque text; `|h1` is just an element. All four layers sit *above* the parse -- CORE neither defines nor depends on any of them.
2. **Each layer has one owner:** Layer 1 is a spec decision (a named subset); Layer 2 is a schema; Layer 3 is tooling over Layers 1+2; Layer 4 is presentation over all three. A tool that mixes layers without naming them is wrong even if its output looks right.
3. **Fidelity claims must name their layer.** "UDON->Markdown" unqualified is meaningless; "doc-schema UDON -> Markdown, general UDON -> Markdown with degradation policy X" is a claim.
4. Every renderer / converter states which Layer-1 subset and Layer-2 vocabulary version it implements.

## Layer 1 -- Markdown *inside* UDON prose (passed through)

UDON prose may contain Markdown formatting (`**bold**`, `` `code` ``, lists, headings). **The parser does not interpret it** -- prose is opaque text, and Markdown constructs survive verbatim (the non-conflict guarantee, measured against the CommonMark corpus). What must be defined is the *named subset* of Markdown that conformant renderers agree to honor.

- **Owner:** the spec (subset naming) + a conformance corpus.
- **Open (D4a):** the Layer-1 named subset -- a Djot-inspired enumeration of which Markdown constructs are blessed. *(Not yet enumerated.)*
- **Failure mode:** renderer disagreement; sigil / Markdown collisions (fences).

## Layer 2 -- The Markdown-equivalent UDON *schema* (udon-as-markdown)

A standard **vocabulary** of elements -- `|h1`, `|blockquote`, `|{em ...}`, `|{a :href ...}` -- that is UDON's structural equivalent of Markdown / HTML semantics. This is not syntax; it is a **schema** (a blessed element set with defined meanings, the way HTML is a blessed vocabulary over SGML / XML). Working name: **the `doc` schema**.

- **Owner:** the schema layer, *not* the core spec -- core syntax neither knows nor cares that `|h1` means "heading".
- **Open (D4b):** the `doc` element set, attribute conventions, versioning, and how much of Markdown's range it covers (tables? footnotes? task lists?).
- **Failure mode:** vocabulary drift; conversions (Layer 3) with no stable target.

## Layer 3 -- Conversion to / from pure Markdown

`udon2md` / `md2udon`: mapping between Layer-2 vocabulary + Layer-1 prose and standalone Markdown documents. The two directions differ: UDON->Markdown is lossy-by-design for non-doc structure (a defined degradation policy is needed for things like `|process[valve] :health broken`); Markdown->UDON is near-lossless *into* the `doc` schema.

- **Owner:** `udon-cli convert`, operating on the real parsed tree (not regex).
- **Open (D4c):** the UDON->Markdown degradation policy for non-doc structure.
- **Failure mode:** silent loss; pretending general UDON round-trips through Markdown (only the `doc`-schema subset can).

## Layer 4 -- Rendering to display targets

Any of the above -> rendered output: ANSI (terminal), HTML, PDF, the Obsidian view. Rendering consumes the Layer-1 subset + Layer-2 vocabulary and adds its own concerns: theme, interactivity, and how non-doc elements display (rendering structure as its own presentation is one answer).

- **Owner:** per-target renderers (`udon-cli render --ansi / --html`, the Obsidian plugin, future web components).
- **Open (D4d):** which layers the first renderers target -- proposed: Layer 4 over Layer 1 only at first (render the prose subset + show structure), Layer-2 awareness later.
- **Failure mode:** each renderer inventing its own Layer-1/2 interpretation because the law was not laid down.
