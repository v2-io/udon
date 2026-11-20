# 86 — Does lite define how its trees map to JSON, XML and YAML (and back)?

## The question

Lite is meant as an alternative to XML/HTML, YAML and JSON. Does the lite spec say how a lite tree corresponds to those formats — or leave that to tools? And separately: since lite is specified as a tree, does it need one standard written form of that tree (for example as JSON) so that test cases and parsers in different languages can be compared?

```udon
|user[jw].admin :name "Ann Lee" :tags [a b]
  Hello there.
  |email ann@x.io
```

## Why lite must decide

Converters are the first thing anyone builds (three already exist as sketches), and each one has made its own choices. Several lite features have no direct counterpart: elements vs attributes, text mixed with elements, stacked values, typed keys, element-valued attributes, comments. If lite says nothing, each converter becomes a de-facto definition. And an AST-centric spec with fixtures in three languages needs some shared way to write down the expected tree.

## What the texts say, in date order

- **2025-12-22, Joseph** (memorata, `history.jsonl:5455`): "Here's a big question I have — one that is perhaps already answered in terms of XML — but I'm wondering what the canonical 'json representation' of a complex (not overly complex, but with some basic elements with ids and attributes and children) udon document should look like. The inverse, UDON's representation of typical JSON, shouldn't be difficult at all (although we can maybe start there for round-trip…?)"
- **Jan 2026 converters** (`~/src/_older/udon-ruby/bin/json2udon`; `bin/xml2udon` in this repo): JSON objects → child elements named by the key; arrays of objects → `|k` with `|_item` children; scalar arrays → `:k [a b]`; multi-line strings → text lines under an element. XML `id` → `[key]`, `class` → `.traits`; values unquoted unless they contain spaces or markers (so `100` becomes a number); whitespace collapsed unless `--preserve-whitespace`. `TODO-UTILS.md` calls the old scripts "regex sketches — reference only".
- **2026-01-13, Joseph** (memorata, `history.jsonl:7831`): "udon-xml — limited to forms that can be expressed in XML naturally — e.g., no complex elements as an attribute's value."
- **Jan 2026, `design/udon-ast.md`:** `key` also readable as `id`/`identity`, `traits` as `class`/`classes`. **0.8.0-alpha.1:** "`id`/`class` retired as wire-names."
- **2026-07-19, `TOOLING-WISHLIST.md`:** "AST ⇄ JSON round-trip. `udon to-json` / `udon from-json` over the tree … JSON is lossy for some UDON distinctions (stacked `:x 1 :x 2` vs `:x [1 2]` …), so the tool must pick `all_attributes` semantics and document the projection."
- **0.10.0 §1.1:** "Projection (validated string → native value)" belongs to the host; §11.5 "hosts projecting lists to native arrays need a policy for structured items."
- **Dec 2025 YAML stress test** (`udon-needs/02-tooling-needs/reports/yaml-stress-test.md`): duplicate keys were YAML's one silent, unrecoverable corruption — the reason stacking (never last-wins) matters when mapping into formats with maps.

## Two different mappings

(Both examples are illustrations of the two kinds, not proposals; the tree one borrows 0.10.0's shape, which file 13 leaves open.)

### The tree written as JSON (a transcript of the lite tree; nothing lost)

```json
{"root": {"children": [
  {"element": "user",
   "attributes": [["$key","jw"], ["$traits","admin"], ["name","Ann Lee"], ["tags",["a","b"]]],
   "children": [{"text": "Hello there.\n"},
                {"element": "email", "attributes": [["$main","ann@x.io"]], "children": []}]}]}}
```

### The document as data (what a JSON user expects; some things must be dropped or folded)

```json
{"user": {"id": "jw", "class": ["admin"], "name": "Ann Lee", "tags": ["a","b"],
          "text": "Hello there.\n", "email": "ann@x.io"}}
```

## Alternatives

### A — lite defines neither; both are tool matters

### B — lite defines the tree-as-JSON transcript only (normative), so fixtures and parsers can be compared byte-for-byte

### C — B, plus informative (non-binding) guidance for data mappings to JSON, YAML and XML

### D — B, plus normative data mappings (one blessed JSON/XML/YAML form each, with the losses stated)

### E — lite restricts itself to what maps cleanly (the "udon-xml" idea): e.g. no element-valued attributes, no stacked values, no mixed text-and-elements outside prose — reserved in lite

## Questions any data mapping must answer

| Lite feature | XML | JSON / YAML |
|---|---|---|
| `[key]`, `.traits` | `id`, `class`? | fields? |
| typed values (`100`, `true`) | all strings | typed |
| stacked `:x 1 :x 2` | not allowed (one attribute per name) | array? last wins? |
| element-valued attribute | no counterpart | nested object |
| text mixed with elements | mixed content | ? |
| repeated child names | fine | array under the name? |
| comments | `<!-- -->` | dropped |
| element-line text (`$main`) | first text node? | a field? |
| order of attributes | not significant | objects unordered |

## Interactions

- [13](13-ast-shape.md): the tree shape these map from.
- [72](72-which-bare-words-are-numbers-booleans-nil.md), [74](74-attribute-values-on-following-lines.md), [77](77-identity-keys-and-traits.md), [83](83-lists-and-sequences.md): the features in the table.
- [85](85-canonical-writing-form.md): converters are generators.
