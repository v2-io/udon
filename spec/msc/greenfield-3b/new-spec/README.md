# UDON — greenfield specification suite

**Universal Document & Object Notation**  
Working label: *greenfield-3b rewrite* (clean-room reorganization of the scrubbed 0.9 material).

This directory is a **middle-pillar** language specification: the legal contract
between the notation and anyone who implements or consumes it. It is not a
parser design document, not a tutorial, and not a grammar for a generator —
though companion notes for those roles may live beside it.

## How to read this suite

| Order | File | Role |
|------:|------|------|
| 1 | [GLOSSARY.md](GLOSSARY.md) | Canonical vocabulary. If a term is capitalized as a formal noun elsewhere, it lives here. |
| 2 | [MODEL.md](MODEL.md) | Abstract Document Model (ADM): what a document *is*, independent of surface spelling. |
| 3 | [CORE.md](CORE.md) | Normative language contract: geometry, markers, elements, attributes, values, extent, anomalies. |
| 4 | [SEMANTICS.md](SEMANTICS.md) | Semantic equivalence and round-trip: when two documents mean the same thing. |
| 5 | [dialects/](dialects/) | What non-core types and dynamics *mean* (syntax recognized in CORE; meaning here). |
| 6 | [layers/markdown.md](layers/markdown.md) | How UDON relates to Markdown (above the parse). |
| — | [DECISIONS.md](DECISIONS.md) | **[GREENFIELD]** choices where the source was open, provisional, or reorganized — read this when something differs from the scrubbed input. |
| — | [OPEN.md](OPEN.md) | Intentionally unfinished items (pragmas, doc schema, formal grammar, …). |
| — | [pedagogy/](pedagogy/) | Non-normative teaching material (optional parallel track). |
| — | [`../work/`](../work/) | Working notes, inventories, synonym audits. |

## Design stance (one paragraph)

UDON is a single notation for data, documents, and configuration. Structure
is indentation- and marker-based; prose is first-class; types come from
syntax, not value sniffing; the core is deliberately small and leaves
projection, constraint, and exotic typing to **Host**, **Schema**, and
**Dialect** layers. Recognition prefers **keep-everything with warnings**
over silent loss; document success/failure policies sit above recognition.

## Requirement language

This suite uses [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119)
keywords (`MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, `MAY`) in uppercase
when normative. Lowercase “must/should/may” in prose is ordinary English
and is not a conformance claim.

## What is *not* here

- Event streams, wire encodings, and emission order (intentionally omitted;
  expected to be redesigned after this contract stabilizes).
- A formal grammar (EBNF/PEG). Geometry and recognition rules are stated
  in prose with enough precision for a future grammar pass.
- The live parser, fixtures outside this clean-room tree, or project TODOs.

## Marker legend

- **Normative** body text is the contract.
- *Non-normative* sections are labelled as such (rationale, examples, pedagogy).
- **[GREENFIELD]** marks a deliberate choice that either specifies something
  the source left open, renames a concept, or (rarely) adjusts surface
  behavior — always justified in [DECISIONS.md](DECISIONS.md).
