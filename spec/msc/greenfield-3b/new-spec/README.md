# UDON — greenfield specification suite

**Universal Document & Object Notation**  
Working label: *greenfield-3b rewrite* (clean-room reorganization of the scrubbed 0.9 material).

This directory is primarily a **middle-pillar** language specification: the
legal contract between the notation and anyone who implements or consumes it.
A short **Grammar** companion restates mechanical rules for implementers;
pedagogy is optional and separate.

## How to read this suite

### Fast paths

| If you are… | Read first |
|-------------|------------|
| Building a recognizer / parser | [GRAMMAR.md](GRAMMAR.md) → [CORE.md](CORE.md) for anything GRAMMAR points at |
| Building an AST / Host / round-trip tools | [MODEL.md](MODEL.md) → [SEMANTICS.md](SEMANTICS.md) → [CORE.md](CORE.md) |
| Learning the language as an author | [pedagogy/tour.md](pedagogy/tour.md) → [GLOSSARY.md](GLOSSARY.md) |
| Auditing greenfield deltas | [DECISIONS.md](DECISIONS.md) → [OPEN.md](OPEN.md) |

### Full order (normative spine)

| Order | File | Role |
|------:|------|------|
| 1 | [GLOSSARY.md](GLOSSARY.md) | Canonical vocabulary. Formal nouns live here. |
| 2 | [MODEL.md](MODEL.md) | Abstract Document Model — what a document *is*. |
| 3 | [CORE.md](CORE.md) | Normative language contract (authoritative). |
| 4 | [SEMANTICS.md](SEMANTICS.md) | Equivalence and round-trip. |
| 5 | [dialects/](dialects/) | Meaning of non-core types and dynamics. |
| 6 | [layers/markdown.md](layers/markdown.md) | Markdown relationship (above the parse). |
| — | [GRAMMAR.md](GRAMMAR.md) | *Non-normative* scannable mechanics (CORE wins on conflict). |
| — | [DECISIONS.md](DECISIONS.md) | **[GREENFIELD]** pins and reasoning. |
| — | [OPEN.md](OPEN.md) | Intentionally unfinished items. |
| — | [pedagogy/](pedagogy/) | Non-normative teaching. |
| — | [`../work/`](../work/) | Inventories, cross-checks, revision notes. |

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
- A formal EBNF/PEG grammar (GRAMMAR.md is prose mechanics, not a generator
  input). Geometry and recognition rules are precise enough for a future
  grammar pass.
- The live parser, fixtures outside this clean-room tree, or project TODOs.

## Marker legend

- **Normative** body text is the contract (MODEL, CORE, SEMANTICS, dialects
  where marked).
- *Non-normative* sections are labelled as such (GRAMMAR, pedagogy, rationale).
- **[GREENFIELD]** marks a deliberate choice that either specifies something
  the source left open, renames a concept, or (rarely) adjusts surface
  behavior — always justified in [DECISIONS.md](DECISIONS.md).

## Peer revision

Incorporated feedback from greenfield-3a (Gemini) and reverse-audit lessons:
see [../work/peer-revision.md](../work/peer-revision.md).
