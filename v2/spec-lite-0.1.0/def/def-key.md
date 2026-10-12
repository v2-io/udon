---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [key]
per: [references-vocabulary]
depends: [def:node, rule:key-holds-a-value, rule:key-escapes]
consequences: []
---

# key

*A «key» is the value written in `[…]` directly after an element's name (or directly after its `|`): `jw` in `|user[jw]`. It says which one this element is. The «tree» holds it as the attribute `$key`.*

## Terms

- **key:** the value written in `[…]` directly after an «element-name», or directly after `|` for an element with no name. It is read by the ordinary value rules ([[rule:key-holds-a-value]]), and the «tree» holds it as the value of the «attribute» `$key`. It says which one this element is, among elements of its kind.

## Examples

- `|user[jw]`: the «key» is `jw`, the «attribute» is `$key`.
- `|step[1]`: the «key» is the integer `1`; `|step["01"]`: the string `"01"`.

## Avoid

- **"key" for an attribute's name.** The everyday sense in JSON, YAML and TOML, and Joseph's own in 2011 ("attribute-key") and 2025-12 ("repeating attribute keys"); 0.9.1 §6.2. Joseph, 2026-08-09: "You really need to stop calling attribute labels keys though don't you? Didn't we reserve that term for |abc[this is a key] ?" Use «attribute-name».
- **"id"**, **"ID"**, **`$id`**: 2011 (`syntax2.udon`, `[id-or-name]`; `DECIDED.md`, "ID is file path if applicable" for the root); December 2025 (`[v]` ≡ `:'$id' v`); HTML's `id`. Joseph, 2026-01-14, chose "key" with "an alias of 'id' and 'identity'", and on 2026-07-11 (L15812) was "perfectly happy with '$key' and '$traits' as the main default sugar and removing the id/class reservation as aliases (or the other way around)".
- **"identity"**: Joseph's first choice on 2026-01-14 ("I think identity/traits is perfect") before he settled on "key" the same morning; 0.9.1 §5.3 and both glossaries ("Identity `[key]`", "Identity / key"). In 2011 "identity" meant an element's namespace and name.
- **"identity designator"**, **"designator"**: 0.9.1 and 0.10.0 §5.3 ("Multiple identity designators stack", ruled K1); Joseph's 2026-09-30 question whether "designator" rather than "name" is the addressing term for a key. In the addressing theory a designator is a *reference* that reaches its referent through a binding ([[references/def:match]]), the use side, which lite reserves.
- **"identifier"**: 2026-01-14 ("an interesting alternative to identity or identifier").
- **"ref"**, **"tags"**: rejected by Joseph on 2026-01-14 ("Ref is too easily confused with @[reference] nodes, tags is so generic it gives the impression of noise a lot of the time").
- **"partial key"**, **`$partial-key`**: 0.10.0's attribute for an unclosed `[`. In lite an unclosed `[` is an error ([[rule:unclosed-delimiter-is-error]]), so lite has no partial key.
- **"selector key"**: 0.10.0, the `[k]` in a reference `@x[k]`; references are reserved in lite.
- **"primary key"**: his analogy (2026-01-14, "more like |table[primary-key-id]"), not a term.

## Discussion

- **Why "key"** (Joseph, 2026-01-14, `history.jsonl` L7882–L7883):

  > I think identity/traits is perfect. We can alias in `id` and `class` and `classes` very easily and principally publish identity/traits. Ref is too easily confused with @[reference] nodes, tags is so generic it gives the impression of noise a lot of the time. "key" on the other hand, is a very interesting alternative to identity or identifier, and fits right in with digging / path syntax mental models...

  > I love it, and love the @element[id] . I agree it feels like the sweet spot. … In this light I like "key" (with an alias of 'id' and 'identity') over identity for the "published" name, keeping "traits" (with an alias to 'class' and 'classes') for the other.

## Working notes

- **The word is his; the definition is not reviewed.** The lexicon inventory lists "key" among the terms that look settled. What remains open is what exactly the word points at, and a few facts about keys that the word has to fit.

- **Three referents.** "Key" is used for the spelling `[jw]`, for the value `jw`, and for the attribute `$key`. The draft above takes the value, the attribute is `$key`, and the spelling is "the key's brackets". *My choice for the draft, not his.*

- **One key or several?** 0.10.0 (K1, 2026-08-07) let keys stack: `|phase[9][scribal]` has two. Joseph, 2026-07-16, as recorded in TODO-SPEC-CORE "Multiple keys" (quoted in pre-design 77, not re-checked against a transcript): "at first I thought [it] was overkill but now I realize [it] should probably be valid… Basically a surrogate key *and* a natural key." His typed line that evening (`history.jsonl` L16505): "basically a surrogate key *and* a natural key". Lite's card for keys is a gap (`rule:keys-and-traits`). If keys stack, spec text needs "a key" and "the keys", not "the key".

- **A key is not a «label».** Under [[rule:key-holds-a-value]] the inside of `[…]` is a value: `[1]` an integer, `["01"]` a string, `[one two]` a text. So a key doesn't follow the label rules even when `[jw]` looks like a name. The addressing theory calls a key a name ([[references/def:binding]]: "A repeatable token (e.g., a word, string, or number)"), which fits a value better than a label does.

- **The addressing collision.** The agent's 2026-09-30 answer (in [[decision:references-vocabulary]]'s working notes, unconfirmed by Joseph) was that a key is the addressing theory's name. If so, "element name" uses "name" in a different sense from name. Either lite says plainly that «element-name» is not the addressing name, or one of the two words moves.

- **"Key" elsewhere in this corpus.** The tree-notation proposal A writes meta as "` #key value`" ("meta keys"), and SOP records have frontmatter keys. Neither is a lite key, but spec text near them should say «key» only for `[…]`.

- **Precedents.**
  - React's `key` prop: identity among siblings of the same type, which is close to the "(element name, key)" scope 0.10.0 described.
  - Databases: primary key, natural key, surrogate key (his own analogies).
  - HTML `id` and CSS `#id`, Haml and Pug `#id`: identity, but unique across the document.
  - TOML uses `[name]` for table headers, so a TOML reader may see `[jw]` as a section name.
  - JSON, YAML, TOML, Python dicts: "key" is the name in a key–value pair. That is the collision behind the Avoid list.
  - *From memory, not re-checked.*

- **Questions bearing on the term.**
  - Is a key unique, and within what? ("id-scoping" is on Joseph's own list, `.int/scratch-jaw.md`; 0.10.0 made duplicate `(name, key)` a document-layer policy.) A reader hearing "key" from databases will assume uniqueness.
  - Does `|[jw]` (no name) have a key and no name, or is the key also how an unnamed element is identified?

- **My own opinion** (the drafting agent's): keep «key». It is his, it has survived nine months, and React and databases give readers the right idea of "which one". The Avoid list is mostly a guard against the JSON habit. Settle "one key or several" before the card text is final, because it decides the article.

- Joseph, 2026-10-12, on `jw` in `|user[jw]`: ":$key value | value | (parsed like any other value after ':attribute ', for example, but with distinct closing delimeter-- might need some rework)".

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- Agree: keep «key», and keep it out of the «label» class, since its inside is read as a value. The article ("the key" vs "a key") waits on whether an element can have one key or several, which is a rule card still to write.
