---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [element, attribute]
per: []
depends: [def:tree, def:root, def:text, def:embed, def:element-name, def:attribute-name, def:key, def:trait, rule:main-is-attribute, rule:sameline-element-is-child, rule:top-level-attributes]
consequences: []
---

# element · attribute

*An «element» is what `|name` makes: an optional «element-name», «attribute»s in written order, and children in written order. An «attribute» is what `:name value` makes: an «attribute-name» and a value, on the «element» (or the «root-node») it belongs to.*

## Terms

- **element:** a «node» ([[def:tree]]) with an optional «element-name», an ordered list of «attribute»s, and an ordered list of children: «element»s, «text»s from prose, «comment»s and «fence»s.
- **attribute:** an «attribute-name» and a value, belonging to an «element» or, at the top level, to the «root-node» ([[rule:top-level-attributes]]), and kept in written order. The «key», the «trait»s and the element's sameline text are the attributes `$key`, `$traits` and `$main`.

Comments and fences are defined in [[def:comment]] and [[def:fence]].

## Invariants

- Sameline text is the `$main` «attribute», never a text child ([[rule:main-is-attribute]]).
- An «element» written later on an element's line is a child ([[rule:sameline-element-is-child]]).

## Examples

```udon
|user[jw].admin :role editor
  Prefers short reviews.
```

An «element» whose «element-name» is `user`, with three «attribute»s in written order (`$key`, `$traits`, `role`) and one child, a «text».

## Avoid

**For «element»:**

- **"node"** for what `|name` makes. Used by Joseph (2011 `udon-c/docs/DECIDED.md`: "node-name", "anonymous node", "'ROOT' NODE"; 2026-10-08: "node or attribute started lines", "weird node name"; 2026-10-09: "the node-name") and by agents (the earlier draft of this file, "node" for `|name` throughout). Ruled 2026-10-09: «node» is the generic word for any item in the «tree» or another graph ([[def:tree]]), and «element» is the specific one.
- **"tag"** for an element. Joseph, 2011 `DECIDED.md`: "Markdown-like languages easily implemented with tags, for example, named '==='"; 2026-07-08 (`history.jsonl` L15363): "your |spine tag -- could you change that to be a group tag as well". SDLang calls its whole node a "tag"; in HTML a tag is the `<p>` delimiter, not the element.
- **"structural unit"**: 0.10.0 `GLOSSARY.md`'s gloss ("the structural unit"), not a term.
- **"embedded element"** for `|{…}`: 0.9's word, which 0.10.0 retired for "inline element". Lite calls `|{…}` an «inline-element», and an «embed» as a piece of a «text» ([[def:embed]]); see Working notes.

**For «attribute»:**

- **"label"** for the attribute. Lite's cards and outline before 2026-10-09 ("A bare `|name` where a label still waits for its value becomes that value", "What a label written more than once gives"; the slugs `rule-waiting-label`, `rule-label-after-empty-label`, `rule-element-after-waiting-label` and `rule-repeated-labels`, renamed 2026-10-09), and an agent's "the label that owns the line" (2026-09-30), which Joseph flagged as ambiguous. Joseph uses it as shorthand too: 2026-10-08 "a label with no value", ":label-under-open-attribute"; 2026-10-09 "top-level :labels", in the same message as ":attributes that come after prose". Ruled 2026-10-09: «attribute». "Label" is now his word for the spelling rules names share ([[def:label]]).
- **"assignment"**: 0.10.0 (`GLOSSARY.md`, "Attribute / Assignment"; MODEL §3), for one written occurrence of an attribute. Never used in lite.
- **"key-value pair"**, **"key"** for the whole attribute: 0.9.1 `GLOSSARY.md` ("Assignment — one key-value pair"), and the habit every JSON/YAML/TOML-trained reader brings. «key» is `[…]` ([[def:key]]).
- **"labeled edge"**, **"edge"**: 0.9.1 and 0.10.0 CORE §6.1 ("Labeled edges"). A description of the model, not a name.
- **"property"**: KDL's and JSON Schema's word for a named value on a node.
- **"flag attribute"**, **"flag key"**: a retired concept (an attribute whose name ends in `?` defaulted to `true`; retired by K12, 2026-08-08/09).
- **"grim attribute"** (2011 `DECIDED.md`, an attribute whose value is a node, written `:|`) and **"structured attribute"** (Joseph, 2026-07-15): older names for an attribute holding an element. Lite has no separate kind for it ([[rule:element-values]]).

## Discussion

- **Why these two words** (Joseph, 2026-10-09, `.int/STEWARD-VERBATIM.md`):

  > I hope it makes sense in the semantic picture why "attributes" is correct-- describing their function and as shorthand for their behavior and usage. (to pick an initial vocabulary term to define). I've gone back and forth on node and element but prefer element so 'node' can be used to talk about AST or other graph nodes generically...

- **What "attribute" invites a reader to assume.** Most readers meet the word in XML and HTML, where attributes are unordered, unique per element, and hold strings. Lite's attributes are none of these: written order is kept, an attribute name may be written more than once (what that gives is the gap card `rule:repeated-attributes`), and a value may be an element ([[rule:element-values]]). The word is right for what attributes *do* (Joseph's reason above, and his 2026-07-15 test that an attribute is named from the parent's side); a teaching text should say early where lite's differ from XML's.
- **The DOM precedent for node and element.** In the W3C DOM, `Node` is the general interface and `Element`, `Text` and `Comment` are kinds of `Node`, which is the split Joseph ruled.

## Working notes

- **Not reviewed with Joseph,** apart from the two words themselves. Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." The definitions' wording is agent drafting; `.int/lexicon-inventory-2026-10-09.md` lists where each word came from.
- **Is an «attribute» a «node»?** [[def:tree]] leaves it open, and so does this file. 0.9.1 and 0.10.0 model an attribute as an edge, not a node. Joseph, 2026-07-15 (`history.jsonl` L16325, "this isn't a decision... this is still pondering"): "an element automatically has a hash-table available and an array available". Lite's tree notation prints attributes as lines just like children, which can make them look like nodes. The DOM has both answers at once: `Attr` is a kind of `Node`, but an element's attributes are never among its children. Whichever way it goes, the Terms entry here should say it in the same words as [[def:tree]].
- **Is an «inline-element» an «element»?** [[def:embed]] calls `|{…}` an «inline-element», and an «embed» when it sits in a «text». It has an «element-name», attributes and content, so it reads as an «element» written inline, and the word says so. If it is one, this card's Terms should say «element»s are written `|name` or `|{name …}`; if not, the word «inline-element» invites a wrong assumption. Waits on the embeds design, which Joseph has said is not done.
- **The «root-node»:** is it an «element»? It holds attributes (top-level attribute lines) and children, but has no «element-name» and no spelling. Its term is [[def:root]]'s (slice D); if the root is an «element», this card's Terms should say so.
- **The slug.** This file is `def:node`, but «node» is now defined in [[def:tree]]; a reader following `[[def:node]]` to learn what a node is lands here. My recommendation (left to the coordinator, since the links are in files I don't own): rename it `def:element` (it defines «element» and «attribute»). Files linking `def:node` on 2026-10-09: `main.outline.md`; `src/` rule-comments-in-tree, rule-embeds-in-text, rule-fence-body-dedent, rule-inline-comments, rule-main-is-attribute, rule-sameline-element-is-child; `def/` def-comment, def-document, def-element-line, def-fence, def-root, def-text, def-tree, and this slice's own cards.
- Where a framed ` ; ` comment on an element's or attribute's line sits in the «tree» is open.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Words:** «element» and «attribute» are ruled (2026-10-09). Nothing to choose.
- **Slug:** rename this card `def:element`. It no longer defines "node", and a reader who follows `[[def:node]]` to learn what a node is lands on «element». The generic «node» already lives in [[def:tree]]. 14 files link `def:node`; it is a mechanical sweep.
- **Is an «attribute» a node?** I lean yes, and would ask before writing «node» into more cards. Reasons: «meta» wants a position on `:x` (where a warning points); the tree notation already gives each attribute its own line; unist and XDM count attributes as nodes. 0.10.0 said no, but that was an agent's choice he never ruled on.
