# Invention fork: typography (spike a, 2026-10-22)

*Answering the coordinator's note ("invent first, judge after"). These ideas are taken from typesetting, Unicode's brackets and marks, and annotation conventions, and pushed toward what they'd be if made beautiful for lite. Each is rendered on [composite-set.md](../../composite-set.md) with trees, then I say what I find beautiful and why, and only then weigh it against CTQ-FACTORS, Beauty first. Glyph facts (widths, chart headings, emoji presentation) were checked in the UCD (Unicode 18); everything else is invention and taste, marked as such. No estate document is used as evidence.*

## The inventions

| | Invention | Glyphs | State | Page |
|---|---|---|---|---|
| **I1** | **Readings**: ruby for values. A value is a base plus an optional reading, written after it; the parser's classification is the implicit reading | `⟪…⟫` | **my favorite; alive** | [i1-readings.md](i1-readings.md) |
| I2 | **Meaning brackets**: `<…>`'s jobs moved to Scott brackets, so `<` stops colliding with HTML and placeholders | `⟦…⟧` | alive, the prefix alternative to I1 | [i2-i6-others.md](i2-i6-others.md) |
| I3 | **Quine corners** for mention vs use: a reference held, not resolved | `⌜…⌝` | alive, small; mostly full UDON | same |
| I4 | **Typeset numerals**: `22⁄7`, `6.02×10²³`, `ff₁₆`, `1920×1080` | `⁄ × ₁₆` | dead as a set; one move kept: no `e` exponents, `×10ⁿ` instead | same |
| I5 | **Glyph sigils**: `📅2026-07-21`, `⏳5m` vs `📏5m` | emoji | dead (open vocabulary, width); kept as a teaching error | same |
| I6 | **Narrow no-break space** as SI's unit binder, `5 m` | U+202F | dead (invisible); kept as a principle | same |

## What I came away with

1. **Readings (I1) unify three things the spike treated separately:**
   - the parser's classification;
   - the writer's notation;
   - the missing dimension of a unit (`5m⟪duration⟫` against `5m⟪length⟫`).

   All three are "how to read this base", and they live in one place in the tree. Text-plus-class already put the classification after the run; readings let the writer put a notation in the same place. That makes the suffix cheap, where the angle fork found it costly, because nothing about the base is decided late. A reading on an attribute name reads every value of that occurrence. That is a key signature, with a value's own reading as the accidental.
2. **`<…>` could be given back entirely.** Under I1:
   - asserting is `8080⟪integer⟫`, checked because lite owns that class;
   - a notation is `2026-07-21⟪date⟫`;
   - nil is bare `nil`.

   Under I2 its jobs move to `⟦…⟧`. Either way, `<` stops fighting the strongest prior agents have for it.
3. **Typeset shapes are identifier-safe.** No id contains `⁄`, `×` or `₁₆`. A classifier gets *safer* by accepting printed forms and dropping ASCII ones that ids share (`1e10`).
4. **A principle the dead ones taught:** every mark must be a visibly different shape in plain text. U+202F fails it. `«` and `⟪` sit near the line, so an error should suggest one for the other.

## Weighed (my hypotheses, Beauty first)

| | A1 beauty | A5 domain-forward | A2 guess (zero exposure) | A4 readability | B6 headroom | Verdict |
|---|---|---|---|---|---|---|
| I1 readings | 9 | 9 | 5 | 7 | 9 | lead |
| I2 meaning brackets | 8 | 7 | 4 | 8 | 8 | strong second (prefix) |
| I3 Quine corners | 8 | — | 3 | 7 | 8 | small, for references |
| I4 typeset numerals | 8 | 8 | 3 | 6 (width) | 7 | keep `×10ⁿ` only |
| I5 glyph sigils | split | 9 | 6 | 4 (width, VS16) | 5 | dead |
| I6 U+202F | 7 | 8 | 1 | 1 | 9 | dead |

## Open, and for the parent

- **Two judgments that aren't mine to make:**
  - whether a reading that names a class lite owns is *checked* (I lean yes);
  - whether readings may sit on attribute names (the key signature), given the slots fork's finding that per-occurrence slot types are annotations. A reading is honest about being one, so I think the finding doesn't apply.
- **Tree notation:** if lite takes `⟦⟧` (I2) or `⟪⟫` (I1), the tree notation can't use them. Joseph had listed `⟦ ⟧` for the tree.
- **The column-width gap** (ambiguous-width characters before a sameline element) matters to any branch that admits non-ASCII marks before a `|`. It isn't specific to these inventions.

No commits.
