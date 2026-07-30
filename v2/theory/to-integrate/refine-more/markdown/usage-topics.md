# Markdown × UDON — the concern map

A MECE inventory of the distinct concerns where markdown and UDON meet. Each is
named so we can refer to it precisely, and defined by its **boundary** (what it is
*and is not*) and its **owner**. This is the input to the capability-register
prioritization; it decides no design.

**The most-conflated cluster is markdown living in UDON *prose*** — three
independent concerns with three different owners that must never be merged in
discussion: the parser *leaving it alone*, the parser *interpreting it*, and the
renderer *formatting it*. They are the first three rows.

## 1. Markdown inside UDON prose

| Concern | What it is (and is not) | Owner |
|---|---|---|
| **Prose non-conflict** | UDON's parser leaves markdown syntax in prose intact — no escaping. A guarantee about the *intersection of the two syntaxes only*; says nothing about interpreting or displaying it. | core parser |
| **Embedded-markdown parsing** | UDON *interprets* the markdown inside prose into structure, instead of treating it as opaque text. Open sub-axes: which grammar; how the parse integrates (interleaved event stream · one holistic AST · UDON tree with grafted markdown subtrees). | above-core md parser |
| **Render subset** | The enumerated set of markdown *prose* constructs that conformant renderers agree to format. A display-side spec decision about markdown-in-prose; independent of whether the parser interprets it. | spec + renderer |

## 2. Markdown semantics as native UDON structure

| Concern | What it is (and is not) | Owner |
|---|---|---|
| **`doc` schema** | A blessed UDON element vocabulary expressing markdown/HTML semantics natively (`\|heading`, `\|em`, `\|a`). Native structure, *not* markdown syntax being read. | schema layer |
| **Spelling equivalence** | The relationship between markdown sugar (`**bold**`) and its `doc`-schema element (`\|{strong}`): which is canonical, and whether/how they interconvert. | schema + fmt |

## 3. UDON inside a markdown host

| Concern | What it is (and is not) | Owner |
|---|---|---|
| **UDON frontmatter** | UDON as the metadata/config block of an otherwise-markdown-hosted document. | host tool |
| **Fenced UDON embed** | UDON inside a markdown code fence — whether inert display, or an extractable/parsable block. | host tool |
| **Plain-renderer legibility** | How UDON reads when a *markdown-only* (UDON-unaware) tool renders it — graceful degradation vs. garbage. A design constraint, not a component. | (constraint) |
| **Editor/tooling interop** | Markdown-oriented tooling — highlighters, tree-sitter injection, LSP — meeting UDON. | ux / tooling |

## 4. Between standalone documents

| Concern | What it is (and is not) | Owner |
|---|---|---|
| **Markdown import** | Converting a standalone markdown *document* into UDON (near-lossless into the `doc` schema). Whole-document, not in-prose. | converter |
| **Markdown export** | Projecting UDON to a standalone markdown *file*; the degradation policy for non-`doc` structure. | converter |
| **Round-trip fidelity** | What survives `udon → md → udon`: the stable (fixed-point) subset. A *property* of import∘export, not a separate operation. | (property) |
| **Display rendering** | Rendering a whole UDON document (structure + prose) to a *display* target — ANSI, HTML, PDF. Produces a display, *not* a markdown file (that is export). | renderers |

## 5. Mechanical (cross-cutting)

| Concern | What it is (and is not) | Owner |
|---|---|---|
| **Fence-delimiter collision** | UDON and markdown both use ` ``` ` fences; nesting or co-residence closes a fence prematurely (fence leakage). A glyph-level clash that surfaces in fenced embeds, conversion, and authoring markdown docs that contain UDON. | (mechanical) |

---

**Not concerns (deliberately excluded):**
- *Document shape* — "mostly-structure vs. mostly-prose UDON," "prose with inline
  UDON embeds." These are usage scenarios composed from the concerns above
  (chiefly **Prose non-conflict**), not concerns themselves.
- *Markdown flavor* (CommonMark · GFM · Djot · MDX · Obsidian) — a **parameter**
  of three concerns (Embedded-markdown parsing, Render subset, Markdown import),
  not a concern of its own. "Which markdown do we support?" is ambiguous until it
  names which of those three it parameterizes.
- *Interpretation depth* (opaque / recognized / validated) — the organizing *axis*
  behind rows 1–3, not a separate concern.

*Depth and prior art, when useful: `./thoughts-on-scope.md`, `../../../spec/MARKDOWN.md`.*
