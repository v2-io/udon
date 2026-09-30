# 83 — Lists: the `[…]` rules, and how lite writes a sequence of records

## The question

Two related things:

1. **Inside `[…]`:** what separates items (spaces only? commas?), can an item be several words, can lists nest, and what are `[]` and `[ ]`?
2. **Sequences of records** — JSON's `[{…}, {…}]` or YAML's `- name: a` list. `[…]` holds values, not elements with attributes. How does lite write a list of records, and is there one expected way?

## Why lite must decide

JSON and YAML users will write lists on the first day. Commas are the reflex from JSON; a list that silently keeps the commas (`"a,"`) is a surprise. And without one agreed shape for "a list of records," every converter and every author invents its own.

## What the texts say, in date order

- **2011, `udon-c/docs/DECIDED.md`:** future scalars "Simple-list", "Simple-tuple"; shielded `( … )` values "can be interpreted as simple potentially nested tuples or lists". **`udon/examples/overview.udon`:** "The ` | text` form for text allows you to create lists like: `|list` / `| one` / `| two` / `| three` _and_ like this: `|list | one | two | three` automatic awesome looking lists!" (In 2011 `| ` — pipe then space — began a text item; today `| ` is plain text, file 08.)
- **2025-12-22, Joseph** (memorata, `history.jsonl:5405`): "One thing that Udon seems to be missing is a clean syntax for lists. Maybe it doesn't need one?"
- **Dec 2025, 0.7-draft** (`_archive/SPEC.md` §Lists): "Space-delimited within brackets"; `["hello world" foo bar]`; `:empty []`; "Each element typed independently by the same rules."
- **Jan 2026 converter** (`~/src/_older/udon-ruby/bin/json2udon`): arrays of scalars → `:k [a b c]`; arrays of objects → `|k` with one `|_item` child per object; nested objects → child elements named by the key. (`_item` starts with `_`, which today's name rule does not allow — file 76.)
- **2026-07-18 rulings** (CHANGELOG): `[ ]` (closed, whitespace only) is an empty list, not `[nil]`; list items may be references and interpolations (full value rules).
- **2026-07-29, Joseph** (`theory/to-integrate/refine-more/thoughts-on-multiline-array.md`), sketching a multi-line bracket with elements and text inside, then: "A cleaner option is to simply lean into the stacking we already do and simply allow an attribute to have multiple children and call it an array" (see file 74).
- **0.10.0 §11.5:** items space-delimited, each typed by the full value rules (numbers, strings, `<…>` boxes, nested lists, inline elements); "No multi-word unquoted text inside a list — a bare item is one token"; "A quoted item's closing quote ends it: `["x"y]` and `["x""y]` are two items each."
- **0.10.0 §6.7 / K15:** `:x 1 :x 2` and `:x [1 2]` read the same through the default view, and differ once a third value stacks (file 13 Q4).
- **Nothing found** about commas in lists in any spec version (searched: memorata "udon commas in lists array syntax"; grep of 0.7, 0.9, 0.9.1, 0.10.0 CORE for "comma").

## Alternatives — inside `[…]`

### A — spaces only; commas are part of items (0.10.0 as written)

```udon
|el :xs [1, 2, 3] :ys [a b c]
```
```text
document
└ element el
    xs ["1," "2," 3]            ; "1," is not a number, so it is text
    ys ["a" "b" "c"]
```

### B — commas and spaces both separate

```text
    xs [1 2 3]
```

### C — a comma directly after an item is reserved in lite (error, bytes kept), keeping B open for later

### Smaller edges

```udon
|el :a [] :b [ ] :c [[1 2] [3]] :d [one two words] :e [x]y
```

`[]` vs `[ ]` (0.10.0 rules only the closed-whitespace case); nested lists; `[one two words]` is three items; `[x]y` (text right after the closing bracket).

## Alternatives — a sequence of records

```json
{"people": [{"name": "Ann", "age": 30}, {"name": "Bo", "age": 4}]}
```

### A — repeated child elements (the element name says what each item is)

```udon
|people
  |person :name Ann :age 30
  |person :name Bo :age 4
```

### B — nameless child elements

```udon
|people
  |{:name Ann :age 30}          ; or |[1] … / |.item … — whatever nameless form lite has (file 77)
  |{:name Bo :age 4}
```

### C — stacked element values on one attribute (file 74, alternative D)

```udon
|doc
  :people
    |person :name Ann :age 30
    |person :name Bo :age 4
```
```text
document
└ element doc
    people [element person (name "Ann", age 30), element person (name "Bo", age 4)]
```

### D — a list of inline elements

```udon
|doc :people [|{person :name Ann :age 30} |{person :name Bo :age 4}]
```

### E — lite names no preferred shape; any of the above

## Interactions

- [05](05-values-across-lines.md): lists across lines.
- [13](13-ast-shape.md) Q4: stacked values vs a list in the tree.
- [74](74-attribute-values-on-following-lines.md): values under an attribute.
- [77](77-identity-keys-and-traits.md): nameless elements.
- [86](86-mapping-to-json-xml-yaml.md): how each shape maps back to JSON.
