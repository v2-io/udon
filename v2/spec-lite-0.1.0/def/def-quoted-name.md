---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [quoted-name]
per: []
depends: [def:label, def:string, rule:quoted-element-and-attribute-names, rule:strings-like-ruby]
consequences: []
---

# quoted-name

*A «quoted-name» is a «label» written in quotes, so it can hold characters a bare name can't: `|'weird name'`, `:"data[1]"`. It is read by the string rules. The quotes are spelling: a quoted name is the same name as the bare spelling of the same characters.*

## Terms

- **quoted-name:** an «element-name» or «attribute-name» written in `'…'` or `"…"`, read by the same rules as a quoted «string» of that quote ([[rule:quoted-element-and-attribute-names]]). It is the same name as an unquoted spelling of the same characters, where one exists.

## Examples

- `|'something "hey"\'' weird node name`: the «element-name» is `something "hey"'`, written as a «quoted-name». The rest of the line is `$main`.
- `:'ready?' true` and `:ready? true` (if `?` is a bare label character) have the same «attribute-name».
- Not a «quoted-name»: `|step["01"]`. That is a «key» whose value is a «string» ([[rule:key-holds-a-value]]); keys are values, not names.

## Avoid

- **"quoted label"**: lite's card `rule-quoted-names-and-labels` (renamed 2026-10-09; "labels" there meant attribute names). Under [[def:label]] every quoted name is a quoted label, so the phrase is true but doesn't say which name.
- **"quoted key"**, **"weird key"**: 0.9.1 §6.2 (`:'weird key'`) and TOML ("quoted keys"), where "key" means attribute name. In lite «key» is `[…]`.
- **"special-attribute-name delimiter"**, **"single-quote identifier delimiting"**: Joseph, 2026-07-13 (`history.jsonl` L16047, L16048), for the single quote around a name.
- **"special constructs for labels"**: Joseph, 2026-10-08, introducing `|'something "hey"\'' weird node name`. A description, not a term.
- **"protected label"**, **"shielded label"**: 2011 `DECIDED.md` ("PROTECTED/SHIELDED: [parentheses]-delimited label or value"; "EXAMPLE: (this is all |(part of a) :single (label))"). The 2011 quoted name used parentheses.
- **"string name"**: would suggest the name is a «string» value in the «tree». A quoted name is a name, whatever its spelling.

## Working notes

- **Not reviewed with Joseph.** Whether lite needs this as a defined term at all is open: "a name written in quotes" may say enough, since the «tree» doesn't distinguish quoted from bare names (if the draft's invariant holds).

- **His words.**
  - 2026-10-08 (`.int/STEWARD-VERBATIM.md`): "I think "..." and '...' should essentially be just like ruby strings (including escape sequences in "" but not in '', and including within the special constructs for labels, e.g. `|'something "hey"\'' weird node name`)". *Reading:* "special constructs for labels" says the quoted form is a way of writing a label, which the draft follows.
  - 2026-07-13 (L16048): "I certainly never questioned the single-quote identifier delimiting and don't see any problem with it still."
  - 2026-07-16 (L16391), on attribute names: "I actually think that :'ready?' and :ready? staying exactly semantically equivalent is the right call." The source of the draft's "same name" sentence, stated for attribute names only.
  - 2026-07-12 (L15814), on `$` names: "This is similar to ruby symbol names or erlang quoted atom names-- basically, because the single-quotes are required for anything other than common constructs, convention and convenience pull away from collisions, not proscription."

- **Agents.** 0.10.0 §5.2: "names containing one take single quotes (`|'weird name'`)": single quotes only. Lite's card now allows `"…"` too, following his 2026-10-08 words. 0.10.0 §5.3 also had quoted traits (`.'ns.kind'`); lite's card names only element and attribute names.

- **Precedents.**
  - **TOML:** "Quoted keys follow the exact same rules as either basic strings or literal strings" (TOML 1.0, Keys; *quoted from memory, not re-fetched*). This is lite's rule almost word for word, with "key" meaning attribute name.
  - **SQL:** "delimited identifier" (`"Order Total"`) beside "regular identifier".
  - **Ruby:** `:"quoted symbol"` and `"quoted label": value` in hashes; **Erlang:** quoted atoms `'hello world'` (his analogy).
  - **KDL:** a node name or property key may be any string, bare or quoted. **JSON:** every member name is a string, always quoted.

- **Questions bearing on the term.**
  - **Quoted traits:** does lite allow `.'ns.kind'`? If so, the Terms entry should include traits.
  - **Sameness:** is `|'a'` the same element name as `|a`, as Joseph said for attribute names? Is `|'a'` the same as `|"a"`? Is the quote kind kept in «meta» for round-tripping?
  - **Empty:** is `|''` an element with an empty name, or with no name (pre-design 61 Q1)?
  - **Content:** may a quoted name, once decoded, contain a newline or control character (`|"a\nb"`)? Open in [[rule:quoted-element-and-attribute-names]].
  - **Does a quoted name follow the label rules?** If a «label» is defined by a character set, a quoted name escapes it. Then "label" means "a name, bare (by the character rules) or quoted (by the string rules)", which is how [[def:label]]'s draft reads.

- **My own opinion** (the drafting agent's): keep the phrase "quoted name" for the spelling, and don't make it a separate tree concept. Its job is to say "this name was written with quotes", and the quotes leave no trace in the tree beyond «meta».
