```kdl
term "element" pos=noun pl="-s" {
  avoid "node" "«node» is the general word for any item in an «AST»; an «element» is one kind of «node»"
  avoid "tag" "in HTML and XML a tag is the delimiter written in the source, not the thing it makes"
  rel has term="attribute" card="{0,N}" note="in written order"
  rel has-child term="node" card="{0,N}" note="in written order"
}
status provisional
```

# «element»
A «node» that has an optional name, zero or more «attributes» in the order they were written, and zero or more children in the order they were written.

## Definition
An «element» has three parts and no others:

- **A name**, which it may lack. An «element» with no name is still an «element».
- **Its «attributes»**: everything the «element» is said to have, each under the «element's» own word for it. They are kept in written order.
- **Its children**: the «nodes» written inside it. They are kept in written order. A child may be another «element» or a «text»; the other kinds of «node» a child may be are given where those kinds are defined.

Everything else a writer can put on an «element» is one of its «attributes». What is written as an «element's» key, as its traits, and as the text on its own line are the «attributes» named `$key`, `$traits` and `$main`. They are not further parts of the «element».

The «element» that is inside no other is the «root». It is an «element» like any other: the «attributes» and children written at the top of a «document» are its «attributes» and its children.

### Invariants
- A parser never reorders an «element's» «attributes» or its children.
- An «element's» «attributes» are not among its children, and its children are not among its «attributes».

## Discussion
- The definition says what an «element» is in the «AST» and does not say how one is written. How «elements» are written is given by rules, and a rule can change without this definition changing.
- "Element" is the word for this kind of «node», and "node" is kept for any item in an «AST», so that a sentence can speak of all «nodes» without meaning only «elements».
- Why the key, the traits and the own-line text are «attributes» and not parts. An «attribute» is a «value» under the «element's» own word for it, and each of these is exactly that: which one the «element» is, what sorts of thing it is, and what it mainly says. Making them parts would give an «element» six parts, three of them optional, each with its own rules for absence and repetition, where «attributes» already have those rules. The shorthand has a long precedent: in HTML, `id` and `class` are attributes, and the `#id.class` shorthand of CSS selectors, Haml and Pug is another way of writing them.
- Why the own-line text is an «attribute» and not a child. `|title Hello` says what the title is; it does not put a first item inside it. Kept as `$main`, it stays one «value» a reader can ask for, apart from whatever is written on the lines below.
- Why the «root» is an «element» and not a kind of its own. A «document's» top-level «attributes» need something to belong to, and its top-level items something to be children of; an «element» already is that. With the «root» an «element», every «node» that holds others is one kind, a program walks the whole «AST» with one case, and any «element» taken out of an «AST» is itself the «root» of one.

## Examples
- A `user` «element» with the «attributes» `$key`, `$traits` and `role`, in that order, and one child, a «text».
- An «element» with no name, no «attributes» and two children, both «elements».
- An «element» with a name and one «attribute», `$main`, and no children.
- The «root» of a «document» that begins with two attribute lines and then holds three «elements»: an «element» with no name, those two «attributes», and those three children.

## Historical Context
The two words are Joseph's, 2026-10-09: "I hope it makes sense in the semantic picture why "attributes" is correct-- describing their function and as shorthand for their behavior and usage. (to pick an initial vocabulary term to define). I've gone back and forth on node and element but prefer element so 'node' can be used to talk about AST or other graph nodes generically..." (`.archive/v2/spec-lite-0.1.0/.int/STEWARD-VERBATIM.md`).

The three parts, and `$key`, `$traits` and `$main` being «attributes», were in spec-lite's card for these terms, `.archive/v2/spec-lite-0.1.0/def/def-node.md`, read whole. That card defined an element as "what `|name` makes"; this definition deliberately does not, at the suggestion of the session that had read all of spec-lite's cards ("udon-lite-simplify", 2026-11-20), checked here against four of those cards.

On the «root», Joseph, 2026-10-21 (same record): "I think most of the discussions have revolved around $root (or something like that) being nothing more than an element with some extra metadata attributes and an indentation column (not sure what the term we'll land on) as -1 or something..." The reasons given in the Discussion for the «root», and for `$key`, `$traits` and `$main`, are those of the Claude Fable 5.2 session that wrote this file on 2026-11-20, after Joseph asked it to come to its own conclusion on both; he has not accepted them.

## Working Notes
- Open: may a «document» write the `$` «attributes» directly (`:$key jw` for `[jw]`)? If they are «attributes», either that spelling means the same thing or it is refused. Belongs to a rule, not here. Lean: refused, so each has one spelling.
- Open, Joseph's: is an «attribute» a «node»? This definition is written so that either answer fits. It belongs to «attribute».
- Open: which other kinds of «node» may be children (comments and fences were, in spec-lite). Left to those kinds' own rows.
- Open: whether an «element» written inline inside a «text» is an «element» by this definition. It has the three parts. Waits on how embedded forms are designed.
- Open: what the «root's» name is (none, or a fixed one), and whether facts a parser supplies (a file name) are `$` «attributes» of the «root». Not needed yet.
- «attribute», «value» and «text» are marked as terms here before anything defines them; they are the next rows intended.
- The Examples describe «elements» in words because no notation for writing an «AST» has been chosen.
