---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [element-name]
per: [suffixes-lose-special-status, references-vocabulary]
depends: [def:node, def:label, def:quoted-name]
consequences: []
---

# element-name

*An «element-name» is the «label» written directly after an element's `|`, bare or in quotes: `user` in `|user[jw]`. An «element» may have none.*

## Terms

- **element-name:** the «label» written directly after an element's `|`, bare (`|user`) or quoted (`|'weird name'`, [[def:quoted-name]]). It says what the element *is*. An «element» written with no name (`|[jw]`, `|.admin`) has none; how the «tree» shows that is open (pre-design 61).

## Examples

- `|user[jw].admin :role editor`: the «element-name» is `user`.
- `|'something "hey"\'' weird node name`: the «element-name» is `something "hey"'` ([[rule:quoted-element-and-attribute-names]]).
- `|[jw] :role editor`: an «element» with no «element-name».

## Avoid

- **"node-name"**, **"node name"**: Joseph's own, 2011 (`udon-c/docs/DECIDED.md`, "LABEL … APPLIES TO: node-name, class-name, attribute-key") through 2026-10-08 ("weird node name") and 2026-10-09 ("the node-name, the attribute-name, a trait-name"). Retired by consequence of the 2026-10-09 ruling that `|name` makes an «element», not a node (*reading*: he hasn't ruled on the compound itself).
- **"tag"**, **"tag name"**: HTML and DOM (`tagName`), Haml and Pug, and SDLang (where "tag" is the whole node). Joseph, 2026-07-08: "your |spine tag". In HTML a tag is the `<p>` delimiter, so "tag name" brings angle brackets and closing tags along.
- **"type"**, **"element type"**: Joseph's 2011 `.attic/syntax2.udon` (`|namespace:type [id-or-name]`, "# Type: type"); XML 1.0's "element type". In lite "type" belongs to typed values ([[def:typed-value]]).
- **"identity"** for the name: 2011 `syntax2.udon` ("Elements … identity – namespace(s) – name"). From December 2025 to 0.9.1, "identity" meant `[key]` instead.
- **"name"** alone: the addressing theory's name is a token kept by a binding ([[references/def:binding]]), and the agent's 2026-09-30 answer was that a «key» is that name ([[decision:references-vocabulary]], working notes; unconfirmed by Joseph). Say «element-name».
- **"label"** for the element name: correct as a statement about its spelling (an element name *is* a «label»), wrong as a name for the role. "The element's label" reads as the attribute-name sense ([[def:label]]).
- **"kind"**: 0.9.1 and 0.10.0 gloss a trait as "what *kinds* of thing it is"; an element name says what the element is, so the two blur.

## Working notes

- **Not reviewed with Joseph.** The word follows from his «element» ruling but he has not been asked about "element name" itself.

- **His uses** (`history.jsonl`): 2026-01-01 (L6561) "the unicode stuff you need for proper element and attribute names"; 2026-01-14 (L7881) "the inner text being the value with the element name"; 2026-07-08 (L15381) "the element names are genuinely so short that a single col change is enough to get the boundaries confused"; 2026-10-09 "the node-name". *Reading:* when he talks about lines and columns he says "element names"; when he lists the lexical class he says "node-name". The «element» ruling leaves "element name" as the consistent form.

- **Agents' uses.** 0.9.1 and 0.10.0 §5.2 "Names" ("A bare name is a Unicode identifier…"; GLOSSARY: "optional name"). Lite's cards: "element name" ([[rule:quoted-element-and-attribute-names]]; the gap card `rule:element-names`).

- **Precedents.**
  - XML 1.0: the element's "type", spelled with the `Name` production (`STag ::= '<' Name …`). DOM: `Element.tagName` and `Element.localName`; "qualified name" with a namespace prefix.
  - HTML, Haml, Pug, Slim: "tag" or "tag name" (`%div`, `div.note`).
  - KDL: every node has a "name" (a string, bare or quoted). SDLang: a tag has a "name" and an optional "namespace".
  - CSS: an element name in a selector is a "type selector".
  - *From memory, not re-checked against those specs today.*

- **Questions bearing on the term.**
  - **Optional:** how does the «tree» show "no element name": absent, `nil`, or `""`? Is `|''` (an empty quoted name) the same as no name? (pre-design 61 Q1.)
  - **Which characters:** pre-design 76 (XML/HTML names like `svg:rect`, `_private`, `my.widget`), and 06 (whether `? ! * +` become name characters, [[decision:suffixes-lose-special-status]]).
  - **Sameness:** is `|Div` the same element name as `|div`? Is `|'a'` the same as `|a`? (Joseph on the attribute case, 2026-07-16: "I actually think that :'ready?' and :ready? staying exactly semantically equivalent is the right call.")
  - **Namespaces:** 0.10.0 allowed `/` in names "with zero core semantics" (`|acme/widget`). Does lite say whether a namespace is part of the element name or a part of its own (as DOM's prefix and local name)?
  - **A word for the whole `user[jw].admin`?** Lite has no word for an element's name, keys and traits taken together. 0.9.1 said "identity" ("Identity is contiguous with the name", §5.3), pre-design 01's history agent said "the head", and 2011 `syntax2.udon` said "identity" for namespace plus name. "Identity" has also meant the key, and "head" collides with "head position" ([[def:head-position]]) and 0.10.1's reference head. If spec text needs the bundle (for "contiguous", or "`.` after a space is not a trait"), it needs a word. *Noted, not proposed.*
  - **Register:** "element name" reads naturally to anyone who knows XML or HTML, and the role is the same there. The main hazard is the opposite one: readers bringing "tag" in from HTML.

- **My own opinion** (the drafting agent's): «element-name». It follows from his ruling, matches his own phrase for the thing, and is what XML and DOM readers expect. The open questions above are about the thing, not the word.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: «element-name». It follows from his ruling and is what XML/DOM readers expect. Whether a bare `|` with no name is allowed is a rule question for [[def:label]]'s card, not this word.
