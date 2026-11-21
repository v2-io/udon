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

## Part 1: Foundation Terms & Components
| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | «Udon» | Universal Document Object Notation (UDON). An indentation-sensitive prose/markdown-first structured textual notation tuned to agentic and logocentric affordances. |
| ‹draft› | ‹inline·def› | (Udon) «partial» | «Udon» source text considered complete, such as the contents of a file or string, as given to a parser with an `eof` signal (explicit or implicit) at the end. |
| ‹draft› | ‹inline·def› | (Udon) «fragment» | Ostensibly «Udon» source text that may or may not be a complete «partial» yet (minus the `eof`) such as a chunk arriving in a streaming context. Udon is designed to allow fixed-buffer continuous incremental delivery, but this spec is focused currently on "complete" «partials» and their well-defined behavior.  *(see [^1])* |
| ‹draft› | ‹inline·def› | (Udon) «document» | A «partial» contained in a file (either implicitly or explicitly asserted) whose `eof` indicates the end of the file, which therefore has a «root» element defined as the sole parent for the content's «partial» . *(see «root» for details)* |
| ‹draft› | ‹definition› | [[def/AST\|«AST»]] | The "Abstract Syntax Tree" resulting from a «partial» being parsed by a compliant parser, shown in this spec in an implementation-language agnostic notation. It is a directed acyclical graph generally with recursive and self-similar features. As a recursive structure, a branch of the AST can be considered an AST on its own. A «partial» is parsed into any number of root «nodes» (root in the tree sense); a «document's» «AST» has a single root «node», the «root». |
| ‹draft› | ‹inline·def› | (AST) «node» | A vertex or point in an «AST». That is, a node in the mathematical sense, where an «AST» is a graph object/topology. Edges connect nodes. |
| ‹draft› | ‹definition› | [[def/element\|«element»]] (node) | A «node» with at most one «element-name», any number of unordered «attributes», and zero or more ordered 'child' «nodes». [jaw: how does xml or kdl define it? I haven't looked at or commented on the def file yet]|
| ‹draft› | ‹inline·def› | «element-name» | The name an «element» has, when it has one. It says what the «element» is, where an «attribute's» name says what something is to the «element» that has it. |
| ‹draft› | ‹definition› | [[def/root\|«root»]] (element) | An implicit «element» with the name `$root` that is the only «node» with no parent in an «AST» generated from a full «document» containing metadata about the «document's» file (actual or asserted) as attributes, as the sole parent of the content «partial's» «AST». |
| ‹gap› | - | - | **All the rest**. For "Part 1", probably at least "attributes", "value", "children", and "text"... |

## Working Notes
*(And footnotes)*
- Note that in all of Part 1 there is no mention yet of objectives and goals and affordances it strives for etc. etc.  That stuff may or may not end up being part of this spec or a separate but related pedagogy (or even historical / narrative) outline...  In any case, this spec for now is primarily focused on a strict almost-executable spec.

---

[^1]: ... currently. The spec will likely evolve to determine aspects of the online/streaming/wire protocol nuance and partial «ASTs» / variations applicable for continuous parsing.
[^2]: We'll probably define them at some point and/or put a legend in here, but no point in doing that before we have any SOPs written and before Verisectorium is settled-- the single-guillemets will help us distinguish them as meta-special in the spec for now regardless.

