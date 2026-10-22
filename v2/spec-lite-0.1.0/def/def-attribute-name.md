---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [attribute-name]
per: []
depends: [def:node, def:label, def:quoted-name]
consequences: []
---

# attribute-name

*An «attribute-name» is the «label» written directly after an attribute's `:`, bare or in quotes: `role` in `:role editor`. It names what the value is to the element that holds it.*

## Terms

- **attribute-name:** the «label» written directly after an attribute's `:`, bare (`:role`) or quoted (`:'weird name'`, [[def:quoted-name]]). It is the parent's word for the value: `my author`, `my timeout`, not what the value is in itself. The designated attributes' names (`$key`, `$traits`, `$main`) are attribute names.

## Examples

- `|user :role editor`: the «attribute-name» is `role`.
- `|user[jw]`: an «attribute» whose «attribute-name» is `$key` and whose value is `jw`. The «key» is `jw`, not `$key` ([[def:key]]).

## Avoid

- **"label"**: 0.10.0 §6.2 and `GLOSSARY.md` (agents, 2026-08-09: "An assignment's name-side is its **label**"); lite's cards until 2026-10-09; Joseph's "attribute labels" (2026-07-15, 2026-08-09) and "attribute-label" (2026-08-09). Now his word for the spelling rules every name shares ([[def:label]]): an attribute name *is* a label, but "label" is not its name.
- **"key"**, **"attribute key"**: Joseph's own in 2011 (`udon-c/docs/DECIDED.md`, "attribute-key"; `udon/examples/overview.udon`, "Colons not allowed in key except as first character unless key is quoted") and 2025-12-26 ("repeating attribute keys"); 0.9.1 CORE §6.2 ("Keys and flag keys") and `GLOSSARY.md`; the default in JSON, YAML and TOML, so the word every agent reaches for first. Joseph, 2026-08-09 (`history.jsonl` L18898): "You really need to stop calling attribute labels keys though don't you? Didn't we reserve that term for |abc[this is a key] ?" «key» is `[…]`.
- **"name-side"**: 0.10.0 `GLOSSARY.md`. Not a term.
- **"attribute identity"**, **"attribute identifier"**: Joseph, 2026-07-15 ("attribute identifiers without needing quotes") and 2026-08-09 ("attribute identities get [identifiers] that are a lot more expressive"). "Identity" has meant the key.
- **"flag key"**, **"flag label"**: names ending in `?` with presence semantics, retired by K12 (2026-08-08/09).
- **"property name"**, **"property key"**: KDL, JSON Schema.
- **"$-key"**: 0.9.1 and 0.10.0 §5.3 ("Designated, not reserved. Any `$`-key is legal"), for the designated names. 0.10.0 kept this wording although its own glossary reserved "key" for `[…]`. Say "designated attribute name" if the class needs a name.

## Working notes

- **A trailing `:` on attribute names** (Joseph's light lean, 2026-10-22, "pending a separate discussion on types and the type system"): `:attr: hi` means `:attr hi`, the trailing `:` ornamental, "or even making it compulsary". To settle with it: whether `:` may also stand inside a bare label (`xlink:href`), since a trailing `:` must then always be the ornament and never part of the name; whether the slot after the trailing `:` is where a type could later go (`:port:u16 8080`).
- **Not reviewed with Joseph as a term,** but the phrase is his. On 2026-10-09 he listed "the node-name, the attribute-name, a trait-name" as the things that are labels; the same day the coordinator's wording sweep wrote "attribute name" throughout the cards. *Reading:* this looks settled by his own usage. It's worth one confirming question rather than a full one.

- **His other uses** (`history.jsonl`): 2026-01-01 (L6561) "proper element and attribute names"; 2026-07-12 (L15814) "I want to also leave '$*' as perfectly reasonable attribute names"; 2026-07-13 (L16047) "a special-attribute-name delimiter" (the single quote).

- **Meaning, in his words.** 2026-07-15 (L16325, "this isn't a decision... this is still pondering"): "They are labeled, where the label is the parent's perspective, not the child's perspective. That label is conserved in the sense that the parent just has one of each, and its values accumulate". This is the "whose name is it?" test (0.9.1/0.10.0 §6.1: an attribute name says what the value is *to the element*; a child's name says what it *is*). The Terms entry carries it.

- **Precedents.**
  - XML and HTML: "attribute name" (`Attribute ::= Name Eq AttValue`); DOM `Attr.name`.
  - JSON (RFC 8259): an object member's "name" ("A name is a string"). YAML, TOML: "key". KDL: a property's "key".
  - Ruby's lexer: `role:` is a `label` token (see [[def:label]]); OCaml and SML: record field "labels".
  - *From memory, not re-checked against those specs today, except Ruby.*

- **Questions bearing on the term.**
  - **When are two attribute names the same?** It matters for repeated attributes (`rule:repeated-attributes`, a gap). Quoted and bare: Joseph, 2026-07-16 (L16391): "I actually think that :'ready?' and :ready? staying exactly semantically equivalent is the right call." Case, and Unicode normalization, are open (pre-design 76).
  - **Hand-written designated names:** is `|el :$key jw` the same tree as `|el[jw]`? Is `$` a bare label character in lite? (pre-design 58 Q2.)
  - **Register:** the pull toward "key" is the standing hazard. Agents trained on JSON and YAML will say "key" for this without noticing, and lite also has a «key». The Avoid entry exists mostly to catch that.

- **My own opinion** (the drafting agent's): «attribute-name». It is his phrase, it pairs with «element-name», and XML readers expect it.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: «attribute-name». It is his phrase ("the attribute-name", 2026-10-09) and pairs with «element-name». The one thing to watch is the cards' habit of saying "the attribute" when they mean only its name; that is a sweep, not a question.
