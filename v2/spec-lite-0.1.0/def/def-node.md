---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [element, attribute, comment, fence]
per: []
depends: [def:document, def:text, rule:embeds-in-text, rule:fence-body-dedent, rule:inline-comments, rule:main-is-attribute, rule:same-line-element-is-child]
consequences: []
---

# element · attribute · comment · fence

*The nodes a «tree» holds under its «root-node»: «element»s, which carry «attribute»s and children, «comment»s, and «fence»s; text from prose is a «text» child.*

## Terms

- **element:** a node with an optional name, an ordered list of «attribute»s, and an ordered list of children: «element»s, «text»s from prose, «comment»s and «fence»s.
- **attribute:** an attribute-name and a value on an «element», kept in written order. `[key]`, `.trait` and the element's same-line text are the attributes `$key`, `$traits` and `$main`.
- **comment:** a node carrying a comment's text. A `;{…}` comment inside a «text» is a «piece» of it instead ([[def:text]]).
- **fence:** a node carrying a label and a body that lite never scans.

## Invariants

- Same-line text is the `$main` «attribute», never a text child ([[rule:main-is-attribute]]).
- An «element» written later on an element's line is a child ([[rule:same-line-element-is-child]]).
- Comments are in the «tree» (Joseph, 2026-10-09: "Don't forget comments show up in the AST").

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **Ruled by Joseph, 2026-10-09:** «element» (not "node") for `|name`, keeping "node" for AST or graph nodes generally: "I've gone back and forth on node and element but prefer element so 'node' can be used to talk about AST or other graph nodes generically". And «attribute» (not "label"): "I hope it makes sense in the semantic picture why "attributes" is correct-- describing their function and as shorthand for their behavior and usage." "Label" is his word for the lexical rules all identifying names share ("the node-name, the attribute-name, a trait-name, etc.--- all "labels" lexically").
- Still open in this file: whether a comment and a fence are «element»-like nodes or something else; the word "node" in this file's own title and in «root-node».

- **Joseph's words** (2026-10-09, `.int/STEWARD-VERBATIM.md`):
  > … so "children", yes-- if they are nodes nested in a parent node. *text children* -- never due to how it complicates everything. While I ended up swinging back to being in favor of / reconciled with $main as long as the AST interactions can make it transparently effectively the first child if/when expected -- it grew on me for other reasons-- [mostly] the fact that in practice, text on the same line as the node it's associated with has a different semantic meaning than children text.

  > Don't forget comments show up in the AST--

- Where a framed ` ; ` comment on an element's or attribute's line sits in the «tree» is open.
- What a repeated label gives a consumer is the gap card `rule:repeated-labels`.
- Traits are names (Joseph, 2026-10-09, on asking whether they could be text: "this question makes zero sense for anyone who is even vaguely familiar with udon").
