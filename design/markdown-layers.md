# The Markdown Layers — four things that must never be conflated

> **Promoted to `spec/MARKDOWN.md`** (draft, 2026-07-13). That companion spec is
> the forward home; this note is the working draft it grew from.

*Captured 2026-07-11 from Joseph's framing ("there's going to be a need for
us to lay down the law as far as the distinction between…"). This note IS
the law's first draft; decision 4 (REVIEW §7-F) owns only Layer 1 and needs
to be understood as scoped by this taxonomy.*

UDON touches markdown in four distinct ways. Tools, spec text, and
conversations keep sliding between them; each has different owners,
different conformance requirements, and different failure modes.

## Layer 1 — Markdown *inside* UDON prose

Misc UDON whose prose content contains markdown formatting (`**bold**`,
`` `code` ``, lists, headings). The **parser does not interpret it** —
prose is opaque text. What must be defined: the *named subset* of markdown
that conformant renderers agree to honor (the Djot-inspired enumeration —
decision 4), and the *non-conflict guarantee* (markdown constructs survive
as prose — the CommonMark corpus CTQ, measured by spike S3).

- Owner: spec (subset naming) + conformance corpus.
- Failure mode: renderer disagreement; sigil/markdown collisions (fences —
  decision 8).

## Layer 2 — The markdown-equivalent UDON *schema*

A standard **vocabulary** of elements — `|h1`, `|blockquote`, `|{em …}`,
`|{a :href …}` — that is UDON's structural equivalent of markdown/HTML
semantics. This is not syntax; it's a *schema* (in the
design/udon-schema-exploration.md sense): a blessed element set with
defined meanings, the way HTML is a blessed vocabulary over SGML/XML.

- Needs: a name (working: **the `doc` schema**), an enumerated element
  set with attribute conventions, and a decision about how much of
  markdown's semantic range it covers (tables? footnotes? task lists?).
- Owner: schema layer (Phase 3), NOT the core spec — core syntax neither
  knows nor cares that `|h1` means "heading".
- Failure mode: vocabulary drift across documents; conversions (Layer 3)
  have no stable target.

## Layer 3 — Conversion to/from pure markdown

`udon2md` / `md2udon`: mapping between Layer-2 vocabulary + Layer-1 prose
and standalone markdown documents. Two directions with asymmetric
difficulty: UDON→md is lossy-by-design for non-doc-schema structure
(what happens to `|process[valve] :health broken`? — needs a defined
degradation policy); md→UDON is near-lossless *into* the doc schema.

- Owner: `udon-cli convert` (Phase 2 U9), on the real tree — the archived
  regex sketches in `_archive/udon-ruby/bin/` are explicitly not this.
- Failure mode: silent loss; pretending general UDON round-trips through
  markdown (it cannot; only the doc-schema subset can).

## Layer 4 — Rendering to display targets

Any of the above → **rendered output**: ANSI (terminal), HTML, PDF, the
Obsidian view. Rendering consumes Layer-1 (subset) + Layer-2 (vocabulary)
decisions and adds its own: theme, interactivity, how non-doc elements
display (the skeleton view is one answer: structure as its own
presentation).

- Owner: per-target renderers (`udon-cli render --ansi/--html`, the
  Obsidian plugin, future web components).
- Failure mode: each renderer inventing its own Layer-1/2 interpretations
  because the law wasn't laid down — which is exactly why this note
  exists.

## The law, stated

1. **The core parser knows none of this.** Prose is opaque; `|h1` is just
   an element. Layers 1–4 are all *above* the parse.
2. **Layer 1 is a spec decision** (the named subset); **Layer 2 is a
   schema**; **Layer 3 is tooling over Layers 1+2**; **Layer 4 is
   presentation over all three**. A tool that mixes layers without naming
   them is wrong even if its output looks right.
3. **Conversion fidelity claims must name their layer**: "UDON→markdown"
   without qualification is meaningless; "doc-schema UDON→markdown,
   general UDON→markdown-with-degradation-policy-X" is a claim.
4. Every renderer/converter README states which Layer-1 subset and
   Layer-2 vocabulary version it implements.

## Open sub-decisions this creates

- D4a (existing decision 4): the Layer-1 named subset.
- D4b: the Layer-2 `doc` schema element set + versioning.
- D4c: the UDON→md degradation policy for non-doc structure.
- D4d: which layers the first renderers (ANSI, Obsidian) target — proposed:
  Layer 4 over Layer 1 only at first (render prose subset + show structure
  skeleton-style), Layer 2 awareness later.
