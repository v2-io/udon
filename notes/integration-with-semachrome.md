# Integration with Semachrome

*Exploratory notes on syntax highlighting infrastructure*

---

## The Name

"Semachrome" — semantic + chrome (color). A resurrection and evolution of the
autocolors project (~2011), now in the context of Tree-sitter, modern editors,
and UDON itself as both a target language and a potential definition format.

---

## Two Parsers, Two Purposes

**libudon** (Rust, streaming)
- Purpose: Data extraction, runtime processing
- Output: Events, DOM, structured values
- Optimized for: Speed, streaming, zero-copy
- WASM target: Browser data processing

**tree-sitter-udon** (generated C)
- Purpose: Editor integration, syntax highlighting
- Output: Concrete syntax tree with node types
- Optimized for: Incremental re-parsing, error recovery, structural queries
- WASM target: Browser-based editors (Monaco, CodeMirror 6)

These serve different needs. libudon answers "what does this UDON mean?"
Tree-sitter answers "what is the syntactic structure for highlighting/navigation?"

They share SPEC.md as ground truth but are independent implementations.

---

## The Autocolors Philosophy (Revisited)

From the 2011 work, key principles that still hold:

1. **Plumbing vs. Discriminators** — Not all tokens are equal. Punctuation and
   delimiters (plumbing) should recede. Names and unique identifiers
   (discriminators) should stand out.

2. **Perceptual Color Space** — Work in CIELAB, not RGB. Equal numeric distance
   should mean equal perceived difference.

3. **Hierarchical Inheritance** — Child tokens should be visibly related to
   parents. A string delimiter should be a dimmer variant of the string color,
   not a completely different hue.

4. **Warm Color Scarcity** — Reds, oranges, pinks draw attention
   disproportionately. Reserve them for rare/important tokens (errors,
   warnings, key semantic markers).

5. **Token Frequency Awareness** — Common tokens should be calmer. Rare tokens
   can be louder.

---

## Inner-Part Coloring

A key insight from the autocolors notes: humans read words by attending to
first/last characters, processing middles holistically.

For syntax:
```
:symbol_name     →  ':' dimmer than 'symbol_name'
"string value"   →  '"' dimmer than 'string value'
@decorator       →  '@' dimmer than 'decorator'
```

The delimiter is already positionally distinct. Dimming it lets the content
(the unique, distinguishing part) stand out.

**Aesthetic bonus**: When the delimiter is a dimmer shade of the *same hue
family* as the content, it creates visual cohesion:
- Strings: green content, dark-green quotes
- Symbols: lavender content, gray-lavender colon
- Instance vars: coral content, dark-coral @

Tree-sitter can support this if grammars expose delimiter vs. content as
separate nodes. The tree-sitter-udon grammar attempts this where possible.

---

## Colorscheme Definition in UDON

What if colorschemes were defined in UDON itself?

```udon
|colorscheme[forest-dark]
  :background #1a1a18
  :foreground #e0e0d8

  |token.plumbing
    :fg.lightness --
    :fg.chroma -

    |punctuation.delimiter
      :fg.hue <'        ; slight variation from parent

    |punctuation.bracket
      :fg.hue <

  |token.discriminator
    :fg.hue 6           ; base hue index from palette
    :fg.lightness +

    |type
      :fg.hue <'
      :style bold

    |property
      :fg.hue <''       ; more variation

  |token.string
    :fg.hue 3           ; green family

    |string.delimiter
      :fg.hue <
      :fg.lightness --  ; inner-part dimming

    |string.content
      :fg.hue <
```

The relative notation (`<`, `<'`, `++`, `--`) expresses relationships rather
than absolute values. A generator could:
1. Take a base palette (hue positions, lightness range)
2. Walk the tree, resolving relative values
3. Output concrete colors for each token

---

## Generation Targets

From a UDON colorscheme definition, generate:

| Target | Format | Notes |
|--------|--------|-------|
| Tree-sitter | highlights.scm + theme | Neovim, Helix, Zed |
| VS Code | .tmTheme or JSON theme | TextMate scopes |
| Vim | .vim colorscheme | highlight groups |
| Emacs | -theme.el | face definitions |
| CSS | .css | For web-based rendering |
| ANSI | Terminal codes | For CLI tools |

Each target has different granularity. TextMate has 500+ scopes; Vim has ~50
highlight groups. The generator would need to collapse the hierarchy
appropriately for each target.

---

## Language-Specific Considerations

Even with the same token class, frequency varies by language:

| Token Type | Ruby | Python | TypeScript |
|------------|------|--------|------------|
| Symbols (`:foo`) | Very high | N/A | N/A |
| Decorators (`@`) | Rare | Very high | Medium |
| Type annotations | Rare | Medium | Very high |

A theme optimized for Python will feel wrong in Ruby.

Possible approaches:
1. **Language-specific themes** — Ruby-forest, Python-forest, etc.
2. **Frequency-weighted generation** — Analyze corpus, adjust emphasis
3. **Accept the compromise** — One theme, acknowledge it's not optimal everywhere

---

## The Semachrome Stack (Hypothetical)

```
┌─────────────────────────────────────────────┐
│  Colorscheme Definition (UDON)              │
│  - Token hierarchy with relative colors     │
│  - Palette definitions                      │
│  - Language-specific overrides              │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  Semachrome Generator                       │
│  - Resolve relative values                  │
│  - Apply perceptual color math (CIELAB)     │
│  - Collapse hierarchy for target            │
└─────────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ .scm    │ │ .tmTheme│ │ .vim    │
   │ + theme │ │         │ │         │
   └─────────┘ └─────────┘ └─────────┘
        │           │           │
        ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ Neovim  │ │ VS Code │ │ Vim     │
   │ Helix   │ │ Sublime │ │         │
   │ Zed     │ │ TextMate│ │         │
   └─────────┘ └─────────┘ └─────────┘
```

---

## UDON as First-Class Target

UDON syntax highlighting is the proof-of-concept:
1. tree-sitter-udon grammar with semantic node types
2. highlights.scm mapping nodes to token classes
3. Semachrome theme applied to those classes

If it works well for UDON, extend to other languages via their Tree-sitter
grammars.

---

## Open Questions

**Grammar granularity**: How much should tree-sitter grammars expose? If a
grammar doesn't distinguish string delimiters from string content, inner-part
coloring is impossible. Do we fork/patch grammars? Advocate upstream?

**Theme portability**: Can one UDON colorscheme definition reasonably generate
good output for all targets? Or do we need target-specific tuning?

**Dynamic emphasis**: The autocolors notes mention intent-driven emphasis
(understanding vs. debugging vs. searching). Is this practical? Would require
editor integration beyond static themes.

**Randomized generation**: Original autocolors generated random-but-constrained
palettes. Is this still valuable? Or do hand-tuned palettes win?

**Performance**: CIELAB color math is more expensive than RGB. Does it matter
at generation time? At render time?

---

## Next Steps (Not Prescriptive)

Possible directions, in no particular order:

- Sketch the UDON colorscheme format more concretely
- Build a minimal generator (UDON → one target, e.g., Neovim)
- Experiment with inner-part coloring in tree-sitter-udon
- Port original autocolors palette generation to modern code
- Survey existing Tree-sitter grammars for delimiter/content granularity
- Try frequency analysis on real codebases

---

## Related

- `~/src/autopax/docs/exp/2025-12-20-autocolors-philosophy.md` — Original autocolors distillation
- `tree-sitter-udon/` — Grammar spike in this repo
- `tree-sitter-udon/queries/highlights.scm` — Current highlight mappings
