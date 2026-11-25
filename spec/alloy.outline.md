# Universal Document Object Notation («Udon») Specification — Alloy Shadow Outline

> [!NOTE] Experimental shadow spec (2026-11-24, ‹draft›)
> A parallel outline beside `spec/canonical.outline.md`, trying **Alloy 6** as the formal notation for «Udon's» structure. Nothing in `spec/canonical.outline.md` or `spec/def/` is changed by it.
>
> **How the Alloy blocks work.** Part 1's whole structure is stated once, in `alloy-def/core.md`. Part 2's «root» adds to it in `alloy-def/root.md` and depends on it; the core does not depend on Part 2. Fences are tagged by what they are for:
> - ```` ```alloy ```` — the model itself (`sig`, `fact`, `fun`)
> - ```` ```alloy check ```` — something that should hold of every instance
> - ```` ```alloy eg ```` — a search showing that a prose example is admitted by the model
> - ```` ```alloy alt ```` — an alternative that was set aside (not run)
>
> Run `ruby spec/alloy-def/verify.rb` to assemble the blocks in outline order and run every check and search under Alloy 6.

## Using This Document

**Version**: ![[../VERSION.SPEC]]

**Brief**: Alloy-backed shadow outline of «Udon's» structure (Part 1) and of the «root» (Part 2); the other parts are as in the canonical outline.

> [!NOTE] Legend
> Double guillemets (`«term»`, `«elements»`) mark terms defined by this specification. Single guillemets (`‹draft›`, `‹model›`, `‹inline·def›`, `‹must›`, `‹may›`) mark meta-terms. A ‹model› is a segment that states a structure as a whole; the terms beside it are ‹inline·def› rows whose ‹Description› is their definition.

## Part 1: udon-core

*The structure itself, with every shorthand taken away. It is stated once, in one segment, and the terms below are defined against it.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹inline·def› | «Udon» | Universal Document Object Notation (UDON). An indentation-sensitive prose/markdown-first structured textual notation tuned to agentic and logocentric affordances. |
| ‹draft› | ‹model› | [[alloy-def/core\|The core structure]] | Everything «Udon» text becomes is made of two sorts of «node». A «simple·node» holds only a value. A «complex·node» can have «attributes», in no order and at most one of each «attribute-name», and children, in order. «Elements» and «attributes» are the two kinds of «complex·node». |
| ‹draft› | ‹inline·def› | «node» | A point in the tree: a «simple·node» or a «complex·node» (`Node`). It has at most one parent, and it is never inside itself. |
| ‹draft› | ‹inline·def› | «simple·node» | A «node» that holds only a value (`SimpleNode`). |
| ‹draft› | ‹inline·def› | «complex·node» | A «node» that can have «attributes» and children (`ComplexNode`). Its «attributes» have no order and it has at most one of each «attribute-name»; its children are in order, and each is an «element» or a «simple·node». |
| ‹draft› | ‹inline·def› | «element» | A «complex·node» with at most one «element-kind» (`Element`). It can be a child. |
| ‹draft› | ‹inline·def› | «element-kind» | What an «element» is: the word for the sort of thing it is, when it has one (`Kind`). It does not say which one it is. |
| ‹draft› | ‹inline·def› | «attribute» | A «complex·node» with exactly one «attribute-name» (`Attribute`). It is never a child: its parent holds it among its «attributes». |
| ‹draft› | ‹inline·def› | «attribute-name» | The name an «attribute» has (`Name`). It is the parent's word for what the «attribute» holds. |
| ‹draft› | ‹inline·def› | «text» | A «simple·node» (`Text`). Provisional, awaiting its own definition. |
| ‹draft› | ‹inline·def› | «partial» | A «complex·node» that has no parent yet. |
| ‹draft› | ‹inline·def› | «AST» | The Abstract Syntax Tree: the tree of «nodes» that a compliant parser gives for a text. The word has its ordinary meaning and is not one of the model's types. |
| ‹gap› | - | - | The other kinds of «simple·node»; the full definition of «text». |

## Part 2: udon-kernel

*A strict subset of UDON, with no shorthand, that every UDON text can be transformed into. The designated «attribute-names» `$key`, `$traits` and `$main`, and the `$root` «element-kind», are given here.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹draft› | ‹definition› | [[alloy-def/root\|«root»]] (element) | The «element» of «element-kind» `$root` that a document's text is read into. It has no parent and needs none, so it is not a «partial». |
| ‹gap› | - | - | The kernel form itself; `$key`, `$traits`, `$main`; what metadata a «root» carries; how meta and ornament are annotated. |

## Part 3: udon-syntax

*The whole language as it is written: what a writer may write, and the kernel text each form stands for.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | Everything, including words for the text itself: text that is complete, text that may not be complete yet (a streaming chunk), and text that is a whole file. The canonical outline calls the first of these a «partial», which Part 1 now uses for a piece of the tree. |

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

*The parser's contract from both sides: what an implementation must provide, what a calling program may assume, conformance, streaming, and performance.*

| Mark | Segment Kind | Segment / Term | Description |
|---|---|---|---|
| ‹gap› | - | - | All of it. |

## Working Notes

- This outline was first written on 2026-11-24 by another agent, with one definition file per term (the commit "Alloy shadow outline and definitions, as the other agent left them" has that version). It was revised the same day by a Claude Fable 5.2 session, at Joseph's invitation, to state the core once and to follow his leans of that day: complex nodes, and neither AST nor «partial» as a type. Joseph has not read the revision.
- "Item" and "value" have no rows. A child is an «element» or a «simple·node»; what an «attribute» holds is its children.
- Two «partials» have no order between them. Where the order of a text's top-level things is kept until they have a parent is for Part 3.
