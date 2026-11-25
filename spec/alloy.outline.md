# Universal Document Object Notation («Udon») Specification — Alloy Shadow Outline

> [!NOTE] Experimental shadow spec (2026-11-24, ‹draft›)
> This is a parallel shadow outline alongside `spec/canonical.outline.md` exploring **Alloy 6** as the embedded formal notation for «Udon's» structural model (`spec/alloy-def/`). Nothing in `spec/canonical.outline.md` or `spec/def/` was modified.
>
> **How the Alloy blocks work:** Each definition file owns its own `sig`s, `fact`s, `check`s, and `E.g.` `run` examples (following `PRAXIS.md` Rule 7: *one home per invariant*), rather than packing all types into `AST.md`. Fences are tagged by role:
> - ```` ```alloy ```` — normative model (`sig`, `fact`, `fun`, `pred`)
> - ```` ```alloy check ```` — consistency `check` assertions and non-vacuity `run` guards
> - ```` ```alloy eg ```` — concrete `E.g.` witness `run`s proving every prose example is admitted by the model
> - ```` ```alloy alt ```` — exploratory alternative sketches (excluded from the main check run)
>
> Run `ruby spec/alloy-def/verify.rb` to assemble all blocks in outline order and execute every `check` and `run` under Alloy 6.

## Using This Document

**Version**: ![[../VERSION.SPEC]]

**Brief**: Alloy-backed shadow outline of «Udon's» syntax and terminology for parser compliance: the static «AST» structure and invariants (Part 1), the kernel form and «root» (Part 2), and the remaining parts as they are drafted.

> [!NOTE] Legend
> Double guillemets (`«term»`, `«elements»`) mark terms defined by this specification. Single guillemets (`‹draft›`, `‹definition›`, `‹inline·def›`, `‹must›`, `‹may›`) mark meta-terms.

## Part 1: udon-core

*The structure itself: the «AST's» topology, sorts, and invariants, with every shorthand already taken away. Each definition below contributes its own Alloy `sig`s and `fact`s to one shared model.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | «Udon» | Universal Document Object Notation (UDON). An indentation-sensitive prose/markdown-first structured textual notation tuned to agentic and logocentric affordances. |
| ‹draft› | ‹definition› | [[alloy-def/AST\|«AST»]] | The Abstract Syntax Tree resulting from a «partial» being parsed by a compliant parser: an acyclic, single-parent tree topology over «nodes» where any branch is itself an «AST». |
| ‹draft› | ‹inline·def› | (AST) «node» | A vertex in an «AST» (`abstract sig Node`). Every «node» is either an «item» or an «attribute». |
| ‹draft› | ‹inline·def› | (AST) «item» | Any «node» except an «attribute» (`abstract sig Item extends Node`). An «element's» children, a «partial's» top-level children, and an «attribute's» «values» are all «items». |
| ‹draft› | ‹definition› | [[alloy-def/partial\|«partial»]] (AST) | The parsed result of a complete «Udon» «partial»: zero or more unordered top-level «attributes» (at most one per «attribute-name») and zero or more ordered top-level child «items». |
| ‹draft› | ‹definition› | [[alloy-def/element\|«element»]] (item) | An «item» with at most one «element-kind», any number of unordered «attributes» (at most one per «attribute-name»), and zero or more ordered child «items». |
| ‹draft› | ‹inline·def› | «element-kind» | What an «element» is: the word for the sort of thing it is, when it has one (`sig Kind`). It does not say which one it is. |
| ‹draft› | ‹definition› | [[alloy-def/attribute\|«attribute»]] (node) | A «node» with exactly one «attribute-name», zero or more unordered sub-«attributes» (at most one per «attribute-name»), and zero or more ordered child «items» (its «values»). A parent has at most one «attribute» of each «attribute-name». |
| ‹draft› | ‹inline·def› | «value» | A child «item» directly under an «attribute» (`Attribute.children`). |
| ‹draft› | ‹inline·def› | «attribute-name» | The name an «attribute» has (`abstract sig Name`, partitioned into `UserName` and `MetaName`). It is the parent's word for the «attribute's» «values». |
| ‹draft› | ‹inline·def› | «text» | Provisional «item» sort (`sig Text extends Item`), awaiting its own definition. |
| ‹gap› | - | - | Other kinds of «item» (fences, comments, directives) and the full `«text»` definition. |

## Part 2: udon-kernel

*A strict subset of UDON, with no shorthand, that every UDON text can be transformed into. The designated «attribute-names» `$key`, `$traits`, `$main`, and the `$root` «element-kind» live here.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹definition› | [[alloy-def/root\|«root»]] (element) | An implicit «element» with the `$root` «element-kind» (`Root extends Element`) that has no parent and is the sole top-level «node» of a «document's» «AST», holding file metadata «attributes» (`MetaName`) merged with the content «partial's» «attributes» and child «items». |
| ‹gap› | - | - | The kernel text syntax itself; `$key`, `$traits`, `$main`; meta and ornament annotation layers. |

## Part 3: udon-syntax

*The whole language as it is written: what a writer may write, and the kernel text each form stands for.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | (source) «partial» | «Udon» source text considered complete, as given to a parser with an `eof` signal. *(Shares a name with the Part 1 parsed «partial»; tracked in Working Notes.)* |
| ‹draft› | ‹inline·def› | (Udon) «fragment» | «Udon» source text that may not yet be a complete «partial» (minus `eof`), such as a streaming chunk. |
| ‹draft› | ‹inline·def› | (Udon) «document» | A «partial» contained in a file (actual or asserted) whose `eof` ends the file, wrapping the parsed «partial» inside a «root» (`sig Document`). |
| ‹gap› | - | - | Everything else. |

## Part 4: udon-schema

*What a body of UDON can be required to contain: which kinds of «element» there are, the «attributes» and children each may have, how many, and of what type.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Part 5: udon-usage

*For those who write and read UDON, people and agents alike: purposes, idioms, pitfalls, and examples.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Part 6: udon-dev

*The parser's contract from both sides: API guarantees, conformance, streaming, and performance.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Working Notes

- **Why `alloy-def/partial.md` was added here:** Per Joseph's note in `spec/def/AST.md` L80–81, `type ast = node list` left top-level attribute uniqueness and orderlessness unenforced, and "AST" shouldn't be redefined to mean "a partial's parsed result." Separating `AST.md` (graph/tree topology) from `partial.md` (`Partial`'s top-level `attributes` + `children`) gave every invariant one clean home.
- **Name collision still open:** "partial" is used for both the source text (Part 3) and the parsed top-level structure (Part 1). Keeping `Partial` as the Part 1 Alloy `sig` for now until Joseph picks whether to split the English term.
- **What Alloy surfaced immediately while drafting:** Wrapping a `Partial` inside a `Document`'s `Root` forced an exact statement of whether a wrapped `Partial`'s top-level nodes are parentless or owned by `Root` (resolved cleanly in `partial.md` + `root.md`), and forced `UserName` vs. `MetaName` disjointness into an explicit `sig` split so Alloy could prove `$`-metadata never collides with content attributes.
