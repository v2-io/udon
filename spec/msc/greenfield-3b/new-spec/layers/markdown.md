# UDON and Markdown — four layers

**Status:** layer boundaries normative; enumerations (subsets, `doc` schema)
still provisional where noted.  
**Law:** Core recognition knows none of this. Prose is opaque Text; `|h1` is
just an Element name.

---

## The law

1. **Core knows none of this.** All four layers sit above recognition.
2. **Each layer has one owner.** Mixing layers without naming them is wrong even
   when output “looks right.”
3. **Fidelity claims MUST name their layer.** “UDON→Markdown” unqualified is
   meaningless.
4. Every renderer/converter states which Layer-1 subset and Layer-2 vocabulary
   version it implements.

---

## Layer 1 — Markdown *inside* UDON prose (pass-through)

UDON Text MAY contain Markdown (`**bold**`, lists, headings, …). Core does not
interpret it. What must be defined is the **named subset** conformant renderers
agree to honor.

- **Owner:** spec (subset naming) + conformance corpus.
- **Open:** exact Djot/CommonMark-inspired subset enumeration.
- **Failure mode:** renderer disagreement; Fence vs Markdown fence collisions.

---

## Layer 2 — Markdown-equivalent UDON Schema (`doc`)

A standard **vocabulary** of Elements — `|h1`, `|blockquote`, `|{em …}`,
`|{a :href …}` — as Schema (blessed names + meanings), not Core syntax.

- **Owner:** Schema layer.
- **Open:** element set, attributes, versioning, coverage (tables, footnotes, …).
- **Failure mode:** vocabulary drift; conversions with no stable target.

---

## Layer 3 — Conversion to/from pure Markdown

`udon2md` / `md2udon` over real ADM trees (not regex).

- UDON→Markdown is lossy for non-`doc` structure; degradation policy required.
- Markdown→UDON can be near-lossless *into* the `doc` Schema.
- **Owner:** tooling.
- **Open:** degradation policy details.

---

## Layer 4 — Rendering

Layer 1–3 outputs → ANSI, HTML, PDF, editor previews, …

- **Owner:** per-target renderers.
- **Failure mode:** each renderer inventing its own Layer-1/2 interpretation.

---

## Non-conflict note (Core-adjacent)

Core Marker Guards are chosen so common Markdown (`|` tables, `![img]`, `#`
headings in prose) is not stolen at Structure Position. That is a Core syntax
property; it is not Layer-1 interpretation.
