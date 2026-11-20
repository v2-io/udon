---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [trait]
per: []
depends: [def:node, def:label]
consequences: []
---

# trait

*A «trait» is a «label» written after a `.` directly following an element's name or key: `admin` in `|user[jw].admin`. It says what kind of thing the element is. An element may have several, in written order, and the «tree» holds each as the attribute `$traits`. A trait is a name, never «text».*

## Terms

- **trait:** a «label» written after a `.` that directly follows an «element-name», a «key», or another «trait» (`|user.admin.active`, `|[jw].admin`). It classifies the element: what kind of thing it is. An «element» may have any number, kept in written order, and the «tree» holds each as a value of the «attribute» `$traits`. A trait is a name, not «text» or a «string».

## Examples

- `|user[jw].admin.active`: two «trait»s, `admin` and `active`.
- `|p .gitignore is a file`: under the provisional [[rule:traits-may-follow-spaces]] (2026-10-12), the trait `gitignore` and `$main ‹is a file›`. 0.9.1 §5.3 read it as text ("a `.trait` after a space is not identity").

## Avoid

- **"class"**, **"classes"**, **"class-name"**, **`$class`**: 2011 (`DECIDED.md`, "node-name, class-name, attribute-key"), December 2025 (`.class1.class2` == `:'$class' [class1 class2]`), HTML's `class`. Joseph, 2026-01-14: "keeping "traits" (with an alias to 'class' and 'classes')"; 2026-07-12: "(we don't have "classes" anymore)".
- **"flag"**, **"unary attribute"**: 2011 `syntax2.udon` (`.flag .other-flag`, "unary attributes (classes)", read as `flag=>true`).
- **"tag"**, **"tags"**: rejected by Joseph on 2026-01-14 ("tags is so generic it gives the impression of noise a lot of the time").
- **"trait label"**: Joseph, 2026-07-15 ("freed up '?!*+' etc. in trait labels"). Under his 2026-10-09 sense a trait *is* a label, so "trait label" says nothing extra.
- **"kind"**: 0.9.1 and 0.10.0's gloss ("what *kinds* of thing it is"). Fine as a gloss; not a second name. "Kind" has also been the verbatim tag's name (0.10.0) and is the SOP's frontmatter field, so it is not free.
- **"label"** in the property-graph sense (Neo4j `(n:Person)`), which is exactly a trait's role. In lite "label" is spelling ([[def:label]]).
- **"mixin"**: 0.10.0 §12.4's host experiment on trait-only anonymous elements (`|.defaults`). A use, not a name.

## Discussion

- **Why "trait"** (Joseph, 2026-01-14, `history.jsonl` L7881–L7883): he wanted names that said these were "more than just "shorthand to help you write html in udon"", chose "identity/traits", then "key" for the first, "keeping "traits" (with an alias to 'class' and 'classes') for the other."
- **A trait is a name** (Joseph, 2026-10-09, asked whether a trait could be text): "this question makes zero sense for anyone who is even vaguely familiar with udon."

## Working notes

- **The word is his; the definition is not reviewed.**

- **"Trait" or "trait name"?** His 2026-10-09 list has "a trait-name" beside "the node-name" and "the attribute-name". An element and an attribute have a name plus other parts; a trait is nothing but its name. So "trait name" may be the same thing as "trait", and one term may be enough. *My reading;* the alternative is that he wants the three "X-name"s parallel in spec text. Worth asking with `|user.admin`: "is `admin` the trait, or the trait's name?"

- **What type is a trait in the «tree»?** Not «text» (above). The tree-notation proposal A printed `:$traits ‹main›`, a text, which [[rule:tree-transcript]] records as wrong. If «label» is only about spelling, the tree still needs a type for `$traits`'s values: a «string»? A name type? This bears on [[def:label]]'s invariant and on C's value cards.

- **Always a list?** Joseph has asked twice that `$traits` be a list even with one member (2026-01-14, L7880, "the class (or $class) attribute always contains an Array, which may have only one item"; 2026-07-11, L15844, "whether the specially-designated $traits is *always* an array/list even if there was only one given"). 0.10.0 instead made each trait its own `$traits` assignment, "never one list". Pre-design 58 Q1. The answer changes whether the tree says "the traits" (one value) or "a trait" (many values).

- **Characters.** 0.10.0 traits allowed `? ! * +` (Joseph, 2026-07-12: "just add *!?+ to allowed identifier characters that get interpreted as the trait value"); quoted traits `.'ns.kind'`. Whether lite keeps either is pre-design 76/06 and [[def:label]]'s one-rule-or-family question.

- **Precedents.**
  - HTML `class` and DOM `classList`; CSS class selectors; Haml and Pug `.class` literals; Pandoc's `{.class}` attributes. Same spelling, same role: classification, several per element.
  - CommonMark puts a fence's language into `class="language-…"` when rendering HTML, so a fence's tag becomes a class there ([[def:fence-tag]]).
  - Property graphs: node labels.
  - Programming languages (Rust, Scala, PHP): a trait is a set of behaviours a type implements. *From memory.*

- **What the word invites.** A programmer reads "trait" as "a capability or interface the thing implements", not "a category it belongs to". Lite attaches no meaning to traits, so the programmer's reading over-promises. 0.10.0's mixin experiment leaned into that reading. The register cost seems small, since HTML's `class` gives the right picture and readers meet `.name` first; *my reading.*

- **My own opinion** (the drafting agent's): keep «trait», and ask whether "trait name" is needed at all.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Keep «trait». "Trait name" adds nothing once traits are ruled to be names (2026-10-09): a trait *is* its label. Its character set follows [[def:label]]'s one-rule-or-family answer.
