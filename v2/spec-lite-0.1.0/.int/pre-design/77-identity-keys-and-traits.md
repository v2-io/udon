# 77 — `[key]` and `.trait` in lite: what they hold, how many, and what they mean

## The question

`|user[jw].admin.active` gives an element a key (`jw`) and two traits. For lite:

- What may go inside `[…]` — a single word, any value (number, quoted string, list), several keys?
- What may a trait be, and when does a `.` after a name stop being a trait?
- Do elements with no name (`|[k]`, `|.t`) exist in lite?
- Does lite check that two elements don't share a name and key?
- Are `[key]` and `.trait` HTML's `id` and `class`?

## Why lite must decide

These are the most used pieces of element syntax after the name, and they are the main difference between a lite tree and a plain XML/JSON tree. Every question above has had more than one answer.

## What the texts say, in date order

- **2011** (`udon/.attic/syntax2.udon`): `|namespace:type [id-or-name] .flag .other-flag` — key and classes could be space-separated, in any order; classes were "unary attributes" (`flag=>true`). `|.awesome[32]` and `|[good-one]` were anonymous elements. `overview.udon`: "ID as curlies instead of squares" was considered.
- **2011 DECIDED.md, root node:** "No way (from document) to set classes? — use :class-name true instead?"
- **Dec 2025, 0.7-draft:** `[id]` → `:'$id'`, "Singular identity; referenceable, unique within scope"; `.class` "multiple allowed, stackable"; a suffix directly on a class (`.class?`) "reserved".
- **Jan 2026, `design/udon-ast.md`:** renamed to **key** and **traits**, with `id`/`class` as accessor aliases; "type-scoped uniqueness: the compound key `(element-name, key)` must be unique — like a database primary key is unique *per table*"; a duplicate `|user[1]` is an ERROR. `_archive/decisions-superseded/identity-syntax-brief.md`: "'id' implies the global uniqueness UDON deliberately doesn't have."
- **Jul 2026, 0.8.0-alpha.1:** "`id`/`class` retired as wire-names." **2026-07-15:** "Spaced-trait identity form dropped: identity is contiguous except the trailing space-separated suffix; `.trait` after a space is prose" (`|p .gitignore is a file`).
- **2026-07-16, TODO-SPEC-CORE "Multiple keys"**, Joseph: "at first I thought [it] was overkill but now I realize [it] should probably be valid… Basically a surrogate key *and* a natural key." Example `|phase[9][scribal]`. Tuple keys already parsed: `|el[[12 'asdf']]` = one key that is a list.
- **2026-08-07/09, K1, K2, K16** (`v2/DECISIONS.md`): several `[…]` stack as several `$key` values; the bracket interior takes "the full value grammar" (`[1]` integer, `["01"]` string, `[one two]` the text "one two", `[[one two]]` a list); Joseph is "NOT ok with any syntax divergence between key interiors and normal attribute values"; block forms (`|name`) inside brackets held out "lightly"; material after a finished value inside a bracket is a further key (`["one" two]` ≡ `["one"][two]`).
- **R16:** empty closed `|el[ ]` → nil key. **R5:** an unclosed `[` gives `$partial-key`, never `$key`.
- **R14 / 0.10.0 §12.3:** duplicate `(name, key)` is a document-layer policy with a menu (`error | allow-if-identical | first-wins | last-wins | keep-all`), default error; the streaming recognizer "cannot and does not check it".
- **0.10.0 §5.3:** traits are identifiers whose characters also include `? ! * +` (`.foo?` is the trait `foo?`); quoted traits `.'ns.kind'`; "Two traits are two `$traits` assignments — never one list"; any `$`-label is legal and the longhand `:$key 3890` means the same as `[3890]`.
- **Converter practice** (`bin/xml2udon`): maps HTML `id` → `[id]` and `class="a b"` → `.a.b`, rewriting non-identifier class characters to `-`.
- **Real consumer** (`design/examples/practices-gotchas.udon`): "IDs are typed values. Quote IDs if the leading zeros or formatting matter."

## Alternatives, per sub-question

### Q1 — what goes inside `[…]`

**A — any single value (0.10.0 minus stacking)**, **B — any value, and several stack (K1/K2/K16)**, **C — one plain token, always a string** (like an HTML id).

```udon
|step[01]
|phase[9][scribal]
|cell[[3 4]]
```
```text
A/B:  element step   $key 1              ; typed: leading zero lost
C:    element step   $key "01"
B:    element phase  $key 9 · $key "scribal"
A/C:  |phase[9][scribal] — error? second bracket is text?
B:    element cell   $key [3 4]
```

### Q2 — traits

```udon
|p.note Text
|p .note Text          ; spaced: trait or text?
|el.bar?               ; trait "bar?" (0.10.0) or trait "bar" + suffix (file 06)?
|btn.btn-primary.is-active
```

**A — 0.10.0:** contiguous only; `.note` after a space is text. **B — 2011:** spaced traits allowed. **C — traits must be plain identifiers** (no `? ! * +`), leaving suffix meaning to file 06.

### Q3 — nameless elements

**A — in lite** (`|[k]`, `|.t`, `|{}`; 2011 onward). **B — reserved in lite** (the mixin reading of `|.defaults` is a host experiment, 0.10.0 §12.4).

### Q4 — duplicate `(name, key)`

**A — lite says nothing** (document-layer policy, 0.10.0). **B — lite reports a duplicate as a warning.** **C — as an error** (`udon-ast.md`, Jan 2026).

```udon
|user[1] :name Alice
|user[1] :name Charlie
```

### Q5 — the tree: are key and traits attributes or their own fields?

This is file 13 Q2; listed here because the HTML `id`/`class` mapping (file 86) depends on it.

## Interactions

- [06](06-suffix-characters.md): suffixes next to keys and traits.
- [05](05-values-across-lines.md): an unclosed `[` at end of line (`$partial-key`).
- [72](72-which-bare-words-are-numbers-booleans-nil.md): typed keys.
- [09](09-reserved-syntax.md): `[@{key}]` and `[!{{id}}]` are reserved forms inside brackets.
- [13](13-ast-shape.md) Q2 and [86](86-mapping-to-json-xml-yaml.md).
