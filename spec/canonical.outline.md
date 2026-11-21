# UDON Specification

Version: ![[../VERSION.SPEC]]

This specification specifies UDON: which source texts are UDON, and what each one says. What a text says is given as its «AST», so that two parsers can be compared by what they produce for the same text.

This is the canonical outline: what the specification consists of, in reading order. It is written for someone implementing a compliant parser, one that for fully parsed input (outside streaming) gives an «AST» of exactly the shape given here. Each row uses only what comes before it.

> [!LEGEND]
> - `mark`: **provisional** (suggested; not accepted by Joseph), **accepted**, **gap** (known missing; what fills it is not known).
> - `kind`: **full-term** (a term defined in its own file, `def/<term>.md`), **inline-term** (a term whose description here is its whole definition; no file). Other kinds will be added as rows need them.
> - `term`: the term, linked to its file if it is a full-term.
> - A term defined by this specification is written in guillemets wherever it is used, in whichever of its forms the sentence needs: «element», «elements», «element's». A full-term declares its forms in its file. An inline-term is a noun with a regular plural unless its row says otherwise.

## Part I: What a parse produces

| mark | kind | term | description |
|---|---|---|---|
| provisional | inline-term | «document» | UDON source text, as given to a parser. |
| provisional | inline-term | «node» | Any item in an «AST». |
| provisional | full-term | [[def/element\|«element»]] | A «node» with an optional name, «attributes» in written order, and children in written order. |
| provisional | inline-term | «root» | The one «element» in an «AST» that is inside no other. Being the «root» is a position, not a kind of «node». |
| provisional | inline-term | «AST» | What a parser gives for a «document» it has parsed in full, as opposed to what a streaming parser emits along the way: the «root» and everything the «root» holds. |

## Working Notes

- The five rows were put here on 2026-11-20 by a Claude Fable 5.2 session. Joseph has not accepted any.
- Next, in this order: «attribute», «value», «text», «string». Not rows yet, so those four words are marked as terms here and in `def/element.md` before anything defines them.
- «AST» is used before its row, in the rows for «node» and «root». The alternative order («AST» first) uses «root» and «element» before theirs. Lean: leave it; the three rows are adjacent.
- Inline-terms are written in guillemets like full-terms. That departs from verisectorium core, which writes its inline words plainly. Reason: a reader cannot otherwise tell a defined «node» from the ordinary word, and which kind of term it is already shows in the `kind` column. The session's conclusion; not yet Joseph's.
- Whether a file exists for a full-term row is not a column: it can be seen from the link.
