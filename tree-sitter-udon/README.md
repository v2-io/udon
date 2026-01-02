# tree-sitter-udon

Tree-sitter grammar for **UDON** (Universal Document & Object Notation).

## Status

**Work in Progress** - This is an initial spike for syntax highlighting purposes.

This grammar is designed for syntax highlighting, not full structural parsing.
It uses Python-style indent tracking rather than UDON's precise column-based
hierarchy semantics. For structural parsing and data extraction, use
[libudon](https://github.com/josephwecker/libudon).

## Installation

### From Source

```bash
npm install
npx tree-sitter generate
npx tree-sitter test
```

### For Editors

- **Neovim**: Add to nvim-treesitter parsers
- **Helix**: Add grammar to languages.toml
- **Zed**: Create extension with grammar

## Usage

### Highlighting

The `queries/highlights.scm` file maps UDON syntax to standard highlight groups.

Design principles (from autocolors):
- **Plumbing** (punctuation, delimiters) should recede visually
- **Discriminators** (element names, attribute keys) should stand out
- **Inner-part coloring**: delimiters dimmer than content where possible
- **Warm colors** reserved for rare/important tokens

### Language Injection

The `queries/injections.scm` file enables syntax highlighting for embedded
languages in:
- Raw blocks: `!:python:`, `!:sql:`, etc.
- Freeform blocks: ` ```ruby `, etc.

## Grammar Overview

```udon
; Elements with ID, classes, and attributes
|article[main].featured.wide :author "Joseph" :date 2025-01-02

  ; Block attributes
  :tags [udon syntax tree-sitter]

  ; Prose with embedded elements and interpolation
  Welcome to |{em UDON}! Hello, !{{user.name}}.

  ; Nested elements
  |section[intro]
    Introduction content here.

; Dynamics
!if featured
  |badge Featured Article

; Raw code blocks
!:elixir:
  def hello, do: IO.puts("world")

; Comments
; This is a line comment
|element ; trailing comment
```

## Files

```
tree-sitter-udon/
├── grammar.js          # Main grammar definition
├── src/
│   └── scanner.c       # External scanner (indent/dedent, raw blocks)
├── queries/
│   ├── highlights.scm  # Syntax highlighting queries
│   └── injections.scm  # Embedded language injection
├── corpus/             # Test cases
│   ├── elements.txt
│   ├── attributes.txt
│   ├── comments.txt
│   ├── dynamics.txt
│   └── embedded.txt
├── package.json
└── binding.gyp
```

## Known Limitations

1. **Column-based nesting**: UDON's precise inline element nesting (e.g.,
   `|one |two |three` creating hierarchy based on column positions) is
   simplified to Python-style indentation. This is sufficient for highlighting
   but doesn't capture full structural semantics.

2. **Bare string boundaries**: Context-sensitive bare string termination
   (block vs sameline vs embedded) may have edge cases.

3. **Freeform blocks**: The triple-backtick escape needs more testing.

4. **Raw blocks**: Content capture after `!:lang:` needs refinement.

## Related

- [UDON Specification](../FULL-SPEC.md)
- [libudon](https://github.com/josephwecker/libudon) - Rust parser core
- [udon-ruby](https://github.com/josephwecker/udon-ruby) - Ruby gem

## License

MIT
