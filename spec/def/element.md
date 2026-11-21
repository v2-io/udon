```kdl
term "element" pos=noun pl="-s" {
  avoid "node" "«node» is the general word for any vertex of an «AST»; an «element» is one kind of «node»"
  avoid "tag" "in HTML and XML a tag is the delimiter written in the source, not the thing it makes"
  rel has term="attribute" card="{0,N}" note="unordered"
  rel has-child term="node" card="{0,N}" note="ordered"
}
status draft
```

# «element»
A «node» with at most one «element-name», any number of unordered «attributes», and zero or more ordered 'child' «nodes».

## Definition
An «element» has three parts and no others:

- **An «element-name»**, which it may lack. An «element» with none is still an «element».
- **Its «attributes»**: everything the «element» is said to have, each under the «element's» own word for it. They have no order among themselves.
- **Its child «nodes»**: the «nodes» written inside it, kept in written order.

Everything else a writer can put on an «element» is one of its «attributes». What is written as an «element's» key, as its traits, and as the text on its own line are the «attributes» named `$key`, `$traits` and `$main`. They are not further parts of the «element».

### Invariants
- A parser never reorders an «element's» child «nodes».
- Two «elements» that differ only in the order their «attributes» were written are the same «element».

## Discussion
- The definition says what an «element» is in the «AST» and does not say how one is written. How «elements» are written is given by rules, and a rule can change without this definition changing.
- Why the key, the traits and the own-line text are «attributes» and not parts. An «attribute» is a «value» under the «element's» own word for it, and each of these is exactly that: which one the «element» is, what sorts of thing it is, and what it mainly says. Making them parts would give an «element» six parts, three of them optional, each with its own rules for absence and repetition, where «attributes» already have those rules. The shorthand has a long precedent: in HTML, `id` and `class` are attributes, and the `#id.class` shorthand of CSS selectors, Haml and Pug is another way of writing them.
- Why the own-line text is an «attribute» and not a child. `|title Hello` says what the title is; it does not put a first item inside it. Kept as `$main`, it stays one «value» a reader can ask for, apart from whatever is written on the lines below.

## Examples
- A `user` «element» with the «attributes» `$key`, `$traits` and `role`, and one child «node», a «text».
- An «element» with no «element-name», no «attributes» and two child «nodes», both «elements».
- An «element» with an «element-name» and one «attribute», `$main`, and no child «nodes».
- A «document's» «root»: an «element» named `$root`.

## Historical Context
The two words are Joseph's, 2026-10-09: "I hope it makes sense in the semantic picture why "attributes" is correct-- describing their function and as shorthand for their behavior and usage. (to pick an initial vocabulary term to define). I've gone back and forth on node and element but prefer element so 'node' can be used to talk about AST or other graph nodes generically..." (`.archive/v2/spec-lite-0.1.0/.int/STEWARD-VERBATIM.md`).

The opening sentence is Joseph's row in the canonical outline, 2026-11-20. The three parts, and `$key`, `$traits` and `$main` being «attributes», were in spec-lite's card for these terms, `.archive/v2/spec-lite-0.1.0/def/def-node.md`, read whole; the reasons given for them in the Discussion are those of the Claude Fable 5.2 session that wrote this file, and Joseph has not accepted them. That card defined an element as "what `|name` makes"; this definition deliberately does not.

The XML Information Set describes an element the same way, as recalled and not re-read: a name, an ordered list of children, and an unordered set of attributes.

## Working Notes
- For «attribute»: when one name is written more than once on an «element», whether the order of those «values» is kept. Lean: yes; "unordered" is across names.
- For «attribute»: a «partial's» top-level attributes are among its root «nodes» (Joseph, 2026-11-20: "a partial gets parsed into any number of udon root nodes"), so an «attribute» is a «node». How that sits with an «element's» «attributes» being a separate part from its ordered child «nodes» is «attribute's» to say.
- «element-name» is marked as a term and nothing defines it yet.
- Open: may a «document» write the `$` «attributes» directly (`:$key jw` for `[jw]`)? Belongs to a rule. Lean: refused, so each has one spelling.
- Open: which other kinds of «node» may be child «nodes».
- Open: whether an «element» written inline inside a «text» is an «element» by this definition. Waits on how embedded forms are designed.
- The Examples describe «elements» in words because no notation for writing an «AST» has been chosen.
