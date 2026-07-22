---
source: 2025-12-20-autocolors-philosophy.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-12-20-autocolors-philosophy.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [autocolors, highlighting, perceptual-uniformity, fast-comprehension]
why_included: >
  Dec 20 2025. Joseph's ~14-yr-old autocolors color-theory distilled: balance + interestingness + information-conveyed, perceptual uniformity, emphasis/de-emphasis for fast comprehension. Directly relevant -- UDON ships an autocolors engine and a highlighting story; this is the demand statement behind it.
---

# Autocolors: Syntax Highlighting Color Theory (circa 2011)

*Distilled from Joseph Wecker's autocolors project (~14 years old)*

---

## Core Philosophy

**Goal:** Maximizing **balance** + **interestingness** + **information conveyed**.

| Principle | Definition |
|-----------|------------|
| **Balanced** | Via principles of visual composition |
| **Interesting** | Via uniqueness & primal resonance (color-schemes attuned to human experiences) |
| **Elucidative** | Via correctly applied emphasis and de-emphasis for fast comprehension |

This stands in contrast to most syntax themes which optimize primarily for "looks nice"
without considering information density or perceptual uniformity.

---

## Fitness Criteria (Per Token Group)

Each token's color should optimize for:

1. **Similarity to parent** — child tokens should be recognizably related to their parent category
2. **Difference from siblings** — tokens at the same level should be distinguishable
3. **Contrast with background** — must be readable, but degree varies by semantic importance
4. **Coherence with common neighbors** — colors that frequently appear adjacent should harmonize

---

## CIELAB Color Space

Autocolors works in **CIELAB (L\*a\*b\*)** rather than RGB or HSL because:

- **Perceptually uniform**: Equal numeric distances correspond to equal perceived differences
- **Separates lightness from chroma**: Can adjust brightness without shifting hue
- **Device-independent**: Colors look consistent across different displays

The implementation converts between RGB ↔ XYZ ↔ LAB using standard matrices and gamma correction.

### Key Color Properties

```
L* (Lightness): 0 = black, 100 = white
a* (Green-Red axis): negative = green, positive = red
b* (Blue-Yellow axis): negative = blue, positive = yellow
Chroma: sqrt(a² + b²) — colorfulness/saturation
Hue: atan2(a, b) — position on color wheel (0-1 in "turns")
```

### Distance Function

Color difference emphasizes lightness over chroma (matching human perception):

```ruby
def -(c)
  Math.sqrt((cl*2.5 - c.cl*2.5)**2 + (ca - c.ca)**2 + (cb - c.cb)**2)
end
```

The 2.5× multiplier on lightness reflects that humans are more sensitive to
brightness differences than hue differences.

---

## Hue Distribution System

Autocolors defines 15 perceptually-spaced hue positions around the color wheel:

| Index | Hue Value | Color Name |
|-------|-----------|------------|
| 0 | 0.00 | Blue |
| 1 | 0.15 | Cyan |
| 2 | 0.225 | Teal |
| 3 | 0.33 | Green |
| 4 | 0.40 | Forest Green |
| 5 | 0.45 | Puke Green |
| 6 | 0.50 | Yellow |
| 7 | 0.565 | Orange |
| 8 | 0.625 | Orange-Red |
| 9 | 0.6575 | Red |
| 10 | 0.75 | Magenta |
| 11 | 0.825 | Fuchsia |
| 12 | 0.8875 | Pink |
| 13 | 0.925 | Violet |
| 14 | 0.95 | Indigo |

These are **not evenly spaced** because human color perception is non-linear.
The yellow-orange-red region is compressed (we're very sensitive there),
while the blue-cyan region is expanded.

---

## Token Hierarchy and Mapping

The `mapping.udon` file defines a hierarchical token taxonomy with relative color specifications:

```
| token.name              | FC | FGI | FGS | BC | BGI | BGS | STYLES |
| lit.string              | 2  | ++  | ~   | 1  | --- | --  | N      |
| lit.string.heredoc      | <' | <   | <   | <  | <   | <   | N      |
```

### Column Meanings

- **FC/BC**: Foreground/Background Color index (1-9 base hues)
- **FGI/BGI**: Foreground/Background Intensity (++, +, ~, -, --, ---)
- **FGS/BGS**: Foreground/Background Saturation
- **STYLES**: N=None, B=Bold, I=Italic, U=Underline, X=Strikethrough

### Relative Notation

- `<` = inherit from parent
- `<'` = inherit but with slight variation (new derivative color)
- `<''` = inherit with more variation
- `+`, `++`, `+++` = increase intensity/saturation
- `-`, `--`, `---` = decrease intensity/saturation
- `~` = neutral/default

This allows child tokens to be **related but distinct** from their parents.

---

## Semantic Token Categories

### Plumbing vs. Content

A key insight: not all tokens are equally important.

**Plumbing** (de-emphasize):
- Punctuation and delimiters
- Imports/requires (too general to be informative)
- Syntactic disambiguation symbols

**Discriminators** (emphasize):
- Unique names that distinguish this code
- Semantic markers that affect meaning

### Highlight Group Types

1. **Plumbing** — symbols for syntactic disambiguation, low information value
2. **Syntactic discriminators** — meaningful syntax markers
3. **Control-flow** — domination hierarchy, reachability, branch probability
4. **Data-flow** — assignment, dereferencing, data transfer
5. **Descriptive/Attributive** — adjectives like `static`, `private`
6. **Discriminators** (by origin):
   - Built-in vs. external library vs. internal module
   - Defined in file vs. defined just above vs. recursive reference
7. **Intrinsic/Symbolic** — ALL_CAPS already stands out without color

---

## Visual Weight and Composition

Drawing from classical composition theory:

### What Makes Colors "Heavier"

**By hue (most to least weight):**
1. Red
2. Blue
3. Green
4. Orange
5. Yellow

*But: warm mixes (red/orange/yellow) usually heavier than cool mixes (blue/green)*

**By property:**
- Dark heavier than light
- Saturated heavier than unsaturated
- Larger heavier than smaller
- Isolated heavier than grouped
- High contrast heavier than low contrast
- Textured heavier than plain

### Balance Principles

- Every high-contrast item must be balanced by larger spaces of lower contrast
- Small amount of high color balances larger area of dull color
- Small complicated shape can balance large simple shape
- Object further from center balances larger object closer to center

---

## Light vs. Dark Theme Inversion

The system generates both light and dark variants from the same palette:

```
+----------+---------------------+-------------------+
| name     | light-scheme        | dark-scheme       |
+----------+---------------------+-------------------+
| light-3  | background          |                   |
| light-2  | background-emph     |                   |
| light-1  | content-minor       | content-emph      |
| light-0  |                     | content           |
| dark--0  | content             |                   |
| dark--1  | content-emph        | content-minor     |
| dark--2  |                     | background-emph   |
| dark--3  |                     | background        |
```

Intensity indices are inverted, not just swapped. Content that is "minor" in
light themes needs different treatment than "minor" in dark themes.

---

## Random Generation with Constraints

Autocolors generates random but constrained color schemes:

### Global Parameters (randomly varied per scheme)

- **Contrast** (0.75 - 1.0): spreads or contracts intensity values
- **Chromacity** (0.0 - 1.0): overall colorfulness
- **Colorfulness** (0.3 - 1.0): how many distinct hues appear

### Derivative Colors

When a child token needs to vary from its parent:

```ruby
def new_color(base_idx, diff_level, depth)
  # direction: randomly clockwise or counter-clockwise
  # maxdiff: based on colorfulness and number of base colors
  # cdiff: smaller for deeper nesting, larger for more tick marks
end
```

Each prime mark (`'`) in the mapping increases the hue offset from the parent,
creating a family of related but distinct colors.

---

## Cross-Editor Token Mapping

Autocolors maintains mappings across multiple systems:

| Autocolors | Vim | TextMate | Pygments | Emacs |
|------------|-----|----------|----------|-------|
| lit.string | String | string | s | string-face |
| lit.string.heredoc | - | string.unquoted | sh | - |
| name.function | Function | entity | nf | function-name-face |
| keyword | Keyword | keyword | k | keyword-face |

The TextMate scope system is the most granular (500+ distinct scopes observed
in the wild), while Vim is the most coarse.

---

## Lessons and Unfinished Work

From the TODO.md and NOTES.md:

### Solved Problems

- Set initial colors with same chromacity and distributed hue
- Fixed highlight color coherence
- Created sample documents with "common" token densities for testing

### Unsolved Problems

- Translation to 256-color and 16-color terminals loses too much distinction
- Deep syntax elements get colors too close together
- Constraint system (ensuring certain groups stay far apart) never fully implemented

### Future Ideas

- **Frequency-weighted emphasis**: tokens that appear more often should be less prominent
- **Context-aware coloring**: emphasis changes based on activity (understanding vs. debugging)
- **Familiarity adaptation**: new code vs. code you've seen many times
- **Static analysis integration**: lint warnings, type inference, reachability

---

## Additional Perceptual Findings (Post-Autocolors)

*Insights discovered after the original autocolors work, circa 2011-2025*

### Evolutionary Color Salience

Certain colors "pop" disproportionately even when balanced contrast-wise:

- **Warm colors** (reds, bright pinks, oranges) draw attention automatically
- **Hypothesis**: evolutionary pressure from detecting ripe fruit, blood, danger
- **Implication**: warm colors should be reserved for semantically important/rare tokens
- Cool colors (blues, greens, teals) can carry more frequent tokens without overwhelming

This explains why many themes feel "busy" — they assign warm colors to frequent tokens
like operators or punctuation, causing constant visual interruption.

### The Gray-Color Interaction Problem

Most color theory poorly addresses how grays interact with chromatic colors:

- Grays are not "neutral" in context — they take on perceived temperature from neighbors
- Gray text next to warm-colored text appears cooler, and vice versa
- The same gray can look blue-ish or yellow-ish depending on surrounding hues
- **Practical**: test gray-colored tokens (operators, punctuation) against multiple
  chromatic neighbors, not in isolation

### Language-Idiomatic Token Frequency

Even within the same "token class," frequency varies wildly by language idiom:

| Token Type | Ruby | Python | TypeScript |
|------------|------|--------|------------|
| Symbols (`:foo`) | Very high | N/A | N/A |
| Decorators (`@`) | Rare | Very high | Medium |
| Type annotations | Rare | Medium | Very high |
| String interpolation | High | High | Very high |

A theme optimized for Python (where `@decorator` is common) will feel wrong in Ruby
(where `@instance_var` is common but `:symbol` is more frequent).

**Implication**: the same semantic class may need different visual weight in different
language contexts. A "universal" theme is always a compromise.

### Intent-Driven Emphasis

The ideal emphasis varies by what the reader is trying to do:

| Activity | Emphasize | De-emphasize |
|----------|-----------|--------------|
| **Understanding structure** | Classes, functions, control flow | Literals, details |
| **Finding a string** | String literals, interpolation | Everything else |
| **Debugging flow** | Control flow, exceptions, returns | Declarations |
| **Understanding types** | Type annotations, class names | Implementation |
| **Reading unfamiliar code** | Comments, documentation | Code details |

No single static theme can optimize for all activities. This suggests:
- Themes should lean toward "understanding structure" as default
- Future: dynamic emphasis based on cursor location or explicit mode

### Inner-Part Coloring (First/Last Character Salience)

Humans (especially English readers) process words by attending heavily to:
- **First character** — initial recognition
- **Last character** — completion/confirmation
- **Middle characters** — processed more holistically/quickly

For syntax highlighting, this means:

```
:symbol_name     →  ':' should be dimmer than 'symbol_name'
@instance_var    →  '@' should be dimmer than 'instance_var'
"string value"   →  '"' should be dimmer than 'string value'
#{interpolation} →  '#{' and '}' should be dimmer than content
```

**Why this works:**
- The delimiter/sigil is already positionally distinct (always first/around)
- Its role is structural, not informational
- Dimming it lets the *content* (the unique, distinguishing part) stand out

**Aesthetic bonus:** When the delimiter is a dimmer shade of the *same hue family*
as the content, it creates visual cohesion while maintaining the information hierarchy.
For example:
- Symbols: lavender content with gray-lavender `:`
- Strings: green content with dark-green `"`
- Instance vars: coral content with dark-coral `@`

### Evolved Theme Observations

Some highly-evolved colorschemes (developed over years for specific languages) handle
these issues well:

- **One Dark / Atom** — good warm/cool balance for JavaScript/TypeScript
- **Dracula** — consistent delimiter dimming, works across many languages
- **Gruvbox** — strong gray-color interaction handling
- **Monokai** — optimized for Python's token frequency distribution

These themes succeed not through color theory alone but through **years of refinement
against real code in their target languages**.

---

## Implications for Autopax Theme

### From Original Autocolors

1. **Work in perceptual space** — think about perceived differences, not RGB values
2. **Hierarchy matters** — child tokens should relate to parents visibly
3. **Plumbing fades** — punctuation, operators, delimiters should recede
4. **Discriminators pop** — unique names, class definitions, key values stand out
5. **Balance warm and cool** — don't let warm colors dominate (they naturally do)
6. **Every token distinct** — with enough hue/lightness/saturation space, no sharing needed
7. **Test with real code** — token frequency matters; rare tokens can be loud

### From Post-Autocolors Insights

8. **Reserve warm for rare** — pink/red/orange only for exceptions, decorators, warnings
9. **Ruby-optimize symbol handling** — symbols are very frequent; must be cool and calm
10. **Inner-part dimming** — sigils (`:`, `@`, `"`) should be dimmer than their content
11. **Same-hue dimming** — delimiter in dim variant of content's hue (not just gray)
12. **Test grays contextually** — gray changes appearance based on chromatic neighbors
13. **Structure-first default** — optimize for understanding code structure as primary use case

### Actionable for Current Theme

**Immediate:**
- [ ] Split string delimiters (`"`, `'`) from string content — delimiters use `green_dark`
- [ ] Consider splitting symbol colon (`:`) from symbol name — Rouge may not support this
- [ ] Verify warm colors only appear on rare tokens (decorators, exceptions)
- [ ] Test theme against Ruby, Python, and TypeScript samples

**Future:**
- [ ] Language-specific theme variants (Ruby-optimized, Python-optimized, etc.)
- [ ] Intent-mode switching (reading vs. debugging vs. searching)
- [ ] Dynamic emphasis based on cursor/focus location

---

## References

- [CIELAB Color Space](http://en.wikipedia.org/wiki/Lab_color_space)
- [sRGB Color Space](http://en.wikipedia.org/wiki/SRGB_color_space)
- [Composition Principles](http://www.etsimo.uniovi.es/hypgraph/design/composition/)
- [Visual Balance](http://www.vanseodesign.com/web-design/visual-balance/)
