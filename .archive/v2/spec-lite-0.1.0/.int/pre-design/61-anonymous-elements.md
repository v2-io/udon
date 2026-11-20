# 61 — Anonymous elements: which spellings open one, and what the tree says for "no name"

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

An element may have no name: `|[k]`, `|.trait`, `|{}`, and (0.10.0) `|?`. Lite has to say (1) which spellings open a nameless element, (2) how the tree represents "no name," and (3) whether there is a spelling for a nameless element with nothing else on it.

```udon
|[jw] :role admin
|.group
  |a
  |b
|[]
|?
|{} and text
```

## Where it has come up (chronological)

- **2011 (`_older/udon-c/docs/DECIDED.md`)**: *"If a '|' (or grim) is followed directly by an id, class, attribute key, or another pipe (node beginning), it is a normal node with a null/anonymous name. (used for 'implied' nodes, like divs.)"* *"'|[]' would be an anonymous node with no id or classes - if you want to give it immediate simple data, you could do this also: '|| some data' (probably the more clear alternative)."* The 2011 notes also let `|` + space mean "simple value" (text), which is where the current pipe-space-is-text rule came from.
- **Joseph, 2025-12-24**: *"The final open question is anonymous elements: ` | <- nothing touching it` as well as this: ` |---|:---...` — I propose we very specifically say that a pipe followed by whitespace, dash, or another pipe … all get preserved as-is. This ensures no collisions with markdown tables."*
- **Joseph, 2026-07-13**: *"We should add to the spec a little part about anonymous elements (that they are allowed), and add that we are experimenting with parser-level mixin behavior."* (Mixins attach to trait-only anonymous elements, `|.some-trait :…`; they are a host experiment, not core — S13.)
- **Joseph, 2026-07-29**: *"what about anonymous elements? (which are technically allowed already in udon — just a nameless `|[something]` we don't allow for `|` by itself though — but we do allow `|[]` or `|[]?` etc."*
- **Type-algebra spike (2026-07-29, `theory/to-integrate/primary/type-algebra.md` §9)**: the name behaves like a designated field that is absent when anonymous; a nameless element with *nothing* designated (a "pure group") has no spelling, because bare `|` is text to protect Markdown tables; `|[]` is not that element, since it carries `$key nil` (R16), and "`$key`-absent and `$key = nil` are different."
- **0.10.0 §5.5**: `|[k]`, `|.trait`, `|.trait :adapter pg`, `|?` are nameless elements; "the core attaches no meaning to namelessness." §3: `|` opens an element when followed by `XID_Start`, `[`, `.`, `'`, `{`, or a suffix character.

## Sub-questions for lite

1. **Tree representation.** Name absent, name `nil`, or name `""`? (Does `|''` — an empty quoted name — exist, and is it the same?)
2. **`|?` and the suffix characters.** If [06](06-suffix-characters.md) makes `? ! * +` ordinary name characters, `|?` becomes an element *named* `?`, and the guard list changes. If suffixes are reserved in lite, `|?` is reserved.
3. **`|[]`**: an anonymous element with `$key nil` (R16), or with no key?
4. **A bare nameless element.** Leave unspellable (the Markdown-table protection wins), or give it a spelling (the 2011 `||`; a bare `|` at end of line, which the type-algebra spike priced as not touching `| ` tables)?
5. **`|{}`** is an empty anonymous inline element (R19). Is `|{ em x}` (space after the brace) an anonymous inline element whose text is `"em x"`? Joseph 2025-12-27: *"`|{  element[...].abc.def ...}` I suppose we should allow this but maybe issue a warning..."*

## Interactions

- [06](06-suffix-characters.md), [08](08-pipes-and-markdown-tables.md), [13](13-ast-shape.md) Q2.
