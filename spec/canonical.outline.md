# Universal Document Object Notation («Udon») Specification

## Using This Document

**Version**: ![[../VERSION.SPEC]]

**Brief**: Canonical ‹verisectorium› outline of the specification for «Udon's» syntax and definitioninology for parser compliance: how source text ‹must›/‹should›/‹may› be interpreted by a compliant parser, the general static (for non-streaming complete documents[^1]) «AST» that is produced, and the errors and warnings that are emitted.

> [!NOTE] Defined definitions
> A definition defined by this specification is written in guillemets wherever it is used, in whichever of its forms the sentence needs (e.g., «element», «elements», «Element's», «στοιχείο|element» and so forth, all refer to the same base «element» definition and definition).
>
> Meta-definitions such as those from the ‹Verisectorium› this project uses or the ‹ontology› «Udon» defines for this ‹verisectorium-instance› , that are essentially part of the standard-operating-procedures and methodologies for working on this project are delimited as you see with single-guillemets.[^2]

> [!NOTE] Legend for Tables
> - **‹Mark›**: one of-
>    - ‹draft› (suggested; **NOT** considered canonical or active yet)
>    - ‹accepted› (current decided and canonical or official for this version)
>    - ‹gap› (one or more segments/rows known to be missing; what fills it is not known)
> - **‹Segment Kind›**: one of-
>    - ‹definition› (a definition defined in its own file, `def/<definition>.md`)
>    - ‹inline·def› (a definition whose ‹Description› here is its whole official definition; no file)
>    - (Other kinds will be added as rows need them)
> - **‹Segment / Term›**:  The segment name or the (primary form of a) term (‹definition›) being defined.
>  - **‹Description›**: For ‹definition› segments, it is a word-for-word copy of the ‹preamble› main definition of the term. For ‹inline·def› it *is* the full official definition.

## Part 1: Foundation Terms & Components
| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | «Udon» | Universal Document Object Notation (UDON). An indentation-sensitive prose/markdown-first structured textual notation tuned to agentic and logocentric affordances. |
| ‹draft› | ‹inline·def› | (Udon) «partial» | «Udon» source text considered complete, such as the contents of a file or string, as given to a parser with an `eof` signal (explicit or implicit) at the end. |
| ‹draft› | ‹inline·def› | (Udon) «fragment» | Ostensibly «Udon» source text that may or may not be a complete «partial» yet (minus the `eof`) such as a chunk arriving in a streaming context. Udon is designed to allow fixed-buffer continuous incremental delivery, but this spec is focused currently on "complete" «partials» and their well-defined behavior.  *(see [^2])* |
| ‹draft› | ‹inline·def› | (Udon) «document» | A «partial» contained in a file (either implicitly or explicitly asserted) whose `eof` indicates the end of the file, which therefore has a «root» element defined as the sole parent for the content's «partial» . *(see «root» for details)* |
| ‹draft› | ‹definition› | «AST» | The "Abstract Syntax Tree" resulting from a «partial» being parsed by a compliant parser, shown in this spec in an implementation-language agnostic notation. It is a directed acyclical graph generally with recursive and self-similar features. As a recursive structure, a branch of the AST can be considered an AST on its own.  |
| ‹draft› | ‹inline·def› | (AST) «node» | A vertex or point in an «AST». That is, a node in the mathematical sense, where an «AST» is a graph object/topology. Edges connect nodes. |
| ‹draft› | ‹definition› | [[def/element\|«element»]] (node) | A «node» with at most one «element-name», any number of unordered «attributes», and zero or more ordered 'child' «nodes». [jaw: how does xml or kdl define it? I haven't looked at or commented on the def file yet]|
| ‹draft› | ‹definition› | «root» (element) | An implicit «element» with the name `$root` that is the only «node» with no parent in an «AST» generated from a full «document» containing metadata about the «document's» file (actual or asserted) as attributes, as the sole parent of the content «partial's» «AST». [jaw: def file needs to specify what metadata attributes it has (must,should,may), the behavior of how the partial's attribute nodes get merged with the root's, and children. also probably the other perspective of a pseudo-element at column position -1, and any AST notation convention we use in particular if not already described in «AST»...] |
| ‹gap› | - | - | **All the rest**. For "Part 1", probably at least "attributes", "value", "children", and "text"... [jaw: This is the right place to describe the gap, not working notes. you can remove this comment when seen] |

## Working Notes
*(And footnotes)*
- Note that in all of Part 1 there is no mention yet of objectives and goals and affordances it strives for etc. etc.  That stuff may or may not end up being part of this spec or a separate but related pedagogy (or even historical / narrative) outline...  In any case, this spec for now is primarily focused on a strict almost-executable spec.
- «AST» is used before its row, in the rows for «node» and «root». The alternative order («AST» first) uses «root» and «element» before theirs. Lean: leave it; the three rows are adjacent.
  - [jaw]: I removed the zero-forward-reference false constraint, so this is a comprehension question now ass it should be rather than a pedanticity question. I've also probably scrambled the order already so that it's different from what you had.
- ‹inline·defs› are written in guillemets like ‹definitions›. That departs from verisectorium core, which writes its inline·def words plainly. Reason: a reader cannot otherwise tell a defined «node» from the ordinary word, and which kind of definition it is already shows in the `kind` column. The session's conclusion; not yet Joseph's.
    - [jaw]: Agreed. I also added single-guillemets for meta-defined special definitions like column values (verisectorium stuff) and special markers like RFC 2119 definitions etc., instead of "semi-defined/semi-special" meanings as the old verisectorium core has them. This comment and its parents can be drained from working notes when you see it and record the ratification and this second decision.

---

[^1]: ... currently. The spec will likely evolve to dedefinitionine aspects of the online/streaming/wire protocol nuance and partial «ASTs» / variations applicable for continuous parsing.
[^2]: We'll probably define them at some point and/or put a legend in here, but no point in doing that before we have any SOPs written and before Verisectorium is settled-- the single-guillemets will help us distinguish them as meta-special in the spec for now regardless.

