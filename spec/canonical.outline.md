# Universal Document Object Notation («Udon») Specification

## Using This Document

**Version**: ![[../VERSION.SPEC]]

**Brief**: Canonical ‹verisectorium› outline of the specification for «Udon's» syntax and terminology for parser compliance: how source text ‹must›/‹should›/‹may› be interpreted by a compliant parser, the general static (for non-streaming complete documents[^1]) «AST» that is produced, and the errors and warnings that are emitted.

> [!NOTE] Defined terms
> A term defined by this specification is written in guillemets wherever it is used, in whichever of its forms the sentence needs (e.g., «element», «elements», «Element's», «στοιχείο|element» and so forth, all refer to the same base «element» term and definition).
>
> Meta-terms such as those from the ‹Verisectorium› this project uses or the ‹ontology› «Udon» defines for this ‹verisectorium-instance› , that are essentially part of the standard-operating-procedures and methodologies for working on this project are delimited as you see with single-guillemets.[^2]

> [!NOTE] Legend for Tables
> - **‹Mark›**: one of-
>    - ‹draft› (suggested; **NOT** considered canonical or active yet)
>    - ‹accepted› (current decided and canonical or official for this version)
>    - ‹gap› (one or more segments/rows known to be missing; what fills it is not known)
> - **‹Segment Kind›**: one of-
>    - ‹definition› (a term defined in its own file, `def/<term>.md`)
>    - ‹inline·def› (a term whose ‹Description› here is its whole official definition; no file)
>    - (Other kinds will be added as rows need them)
> - **‹Segment / Term›**:  The segment name or the (primary form of a) term (‹definition›) being defined.
> - **‹Description›**: For ‹definition› segments, it is a word-for-word copy of the ‹preamble› main definition of the term. For ‹inline·def› it *is* the full official definition.

## Part 1: udon-core

*The structure itself: the «AST's» types and what each part means, with every shorthand already taken away. This part defines the «AST». It has almost no UDON source in it; examples of written UDON begin in Part 2 and are mostly in Part 3.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | «Udon» | Universal Document Object Notation (UDON). An indentation-sensitive prose/markdown-first structured textual notation tuned to agentic and logocentric affordances. |
| ‹draft› | ‹definition› | [[def/AST\|«AST»]] | The "Abstract Syntax Tree" resulting from a «partial» being parsed by a compliant parser, shown in this spec in an implementation-language agnostic notation. It is a directed acyclical graph generally with recursive and self-similar features. As a recursive structure, a branch of the AST can be considered an AST on its own. A «partial» is parsed into any number of root «nodes» (root in the tree sense); a «document's» «AST» has a single root «node», the «root». |
| ‹draft› | ‹inline·def› | (AST) «node» | A vertex or point in an «AST». That is, a node in the mathematical sense, where an «AST» is a graph object/topology. Edges connect nodes. |
| ‹draft› | ‹inline·def› | (AST) «item» | Any «node» except an «attribute». An «element's» children are «items», and so are an «attribute's» «values». |
| ‹draft› | ‹definition› | [[def/element\|«element»]] (item) | A «node» with at most one «element-kind», any number of unordered «attributes», and zero or more ordered 'child' «nodes». [jaw: how does xml or kdl define it? I haven't looked at or commented on the def file yet]|
| ‹draft› | ‹inline·def› | «element-kind» | What an «element» is: the word for the sort of thing it is, when it has one. It does not say which one it is. |
| ‹draft› | ‹definition› | [[def/attribute\|«attribute»]] (node) | A «node» with exactly one «attribute-name» and one or more ordered «values». Its «attribute-name» is its parent's word for those «values», and a parent has at most one «attribute» of each «attribute-name». |
| ‹draft› | ‹inline·def› | «value» | An «item» directly under an «attribute». |
| ‹draft› | ‹inline·def› | «attribute-name» | The name an «attribute» has. It is the parent's word for the «attribute's» «values»: what they are to the parent, and not what any of them is in itself. |
| ‹gap› | - | - | What a «partial» parses into, as a type of its own with its children and its «attributes»; «text»; the other kinds of «item». |

## Part 2: udon-kernel

*A strict subset of UDON, with no shorthand, that every UDON text can be transformed into. It is how this specification writes an «AST» down, with annotation for meta and ornament. The designated «attribute-names» `$key`, `$traits` and `$main`, and `$root`, are given here.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹definition› | [[def/root\|«root»]] (element) | An implicit «element» with the `$root` «element-kind» (i.e., a `|$root ...` «element») that is the only «node» with no parent in an «AST» generated from a full «document» containing metadata about the «document's» file (actual or asserted) as attributes, as the sole parent of the content «partial's» «AST». |
| ‹gap› | - | - | The kernel form itself; `$key`, `$traits` and `$main`; how meta and ornament are annotated. |

## Part 3: udon-syntax

*The whole language as it is written: what a writer may write, and the kernel text each form stands for. Keys, traits, stacking, text on an «element's» own line, and the errors and warnings are here. Most of this specification's UDON examples are in this part.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | (Udon) «partial» | «Udon» source text considered complete, such as the contents of a file or string, as given to a parser with an `eof` signal (explicit or implicit) at the end. |
| ‹draft› | ‹inline·def› | (Udon) «fragment» | Ostensibly «Udon» source text that may or may not be a complete «partial» yet (minus the `eof`) such as a chunk arriving in a streaming context. Udon is designed to allow fixed-buffer continuous incremental delivery, but this spec is focused currently on "complete" «partials» and their well-defined behavior.  *(see [^1])* |
| ‹draft› | ‹inline·def› | (Udon) «document» | A «partial» contained in a file (either implicitly or explicitly asserted) whose `eof` indicates the end of the file, which therefore has a «root» element defined as the sole parent for the content's «partial» . *(see «root» for details)* |
| ‹gap› | - | - | Everything else. |

## Part 4: udon-schema

*What a body of UDON can be required to contain: which kinds of «element» there are, the «attributes» and children each may have, how many, and of what type. Placed fourth provisionally; it moves earlier if Part 2 or Part 3 turns out to depend on it.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Part 5: udon-usage

*For those who write and read UDON, people and agents alike. What UDON is for; the idioms; the use cases; the pitfalls; and the examples, fixtures and generators that show them. This is meaning above what a parser enforces: what a writer may count on a reader to understand.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Part 6: udon-dev

*The parser's contract, from both sides: what an implementation must provide, and what a program calling it may assume. The interface to the «AST» (for instance asking for exactly one of an «attribute's» «values», or for all of them), conformance and how it is checked, streaming and «fragments», and performance.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Working Notes
*(And footnotes)*
- Note that in all of Part 1 there is no mention yet of objectives and goals and affordances it strives for etc. etc.  That stuff may or may not end up being part of this spec or a separate but related pedagogy (or even historical / narrative) outline...  In any case, this spec for now is primarily focused on a strict almost-executable spec.
- The six parts are Joseph's, 2026-11-24 (his words are in `DECISIONS.kdl`, `spec-outline-in-six-parts`). The names are his first pass. The one-paragraph descriptions of Parts 4, 5 and 6 are a Claude Fable 5.2 session's, written at his invitation, and he has not read them.
- Every row was moved as it stood. Three things in Part 1 no longer sit where their own text says: the «element» definition still gives `$key`, `$traits` and `$main`, which belong to Part 2; «AST» and «root» still speak of a «partial's» root «nodes»; and the definitions do not yet have the shape Joseph is exploring, in which an «attribute» has «attributes» of its own and a «value» is simply a child.
- "partial" is now wanted for two things: the source text (its row in Part 3) and the type that text parses into (the gap row in Part 1).

---

[^1]: ... currently. The spec will likely evolve to determine aspects of the online/streaming/wire protocol nuance and partial «ASTs» / variations applicable for continuous parsing.
[^2]: We'll probably define them at some point and/or put a legend in here, but no point in doing that before we have any SOPs written and before Verisectorium is settled-- the single-guillemets will help us distinguish them as meta-special in the spec for now regardless.

