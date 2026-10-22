# Invention fork `invent-beyond` (spike a): values, from notations outside programming

*2026-10-22, after Joseph's note on low creativity: invent first, judge after. Drawn from music, chemistry, mathematics, physics and units, linguistics and glossing, Japanese typography, statistics, cartography. Each idea was made into something for lite, rendered on [`../../composite-set.md`](../../composite-set.md) with trees, and said why it's beautiful to me, before being weighed against CTQ-FACTORS with Beauty first. Joseph's two earlier notes hold: the estate's documents are ideation, not evidence; the factors are the compass. Scores are my hypotheses, as deltas against the parent's lead composition (`python3 -I scores.py`). Every caret column in I2 came from [gloss.py](gloss.py).*

## The inventions

| | Idea | Made from | Beauty (A) Δ | All Δ | State |
|---|---|---|---|---|---|
| [I1](i1-reading-after-the-value.md) | **The reading comes after the value**: `0xff<u64>`, `5<min>`, `2026-07-21<date>`, `8080<integer>` asserting; words never take one (`Vec<u8>` stays text) | ruby/furigana, quantity calculus {Q}[Q], glossing, chemistry's `(aq)` | +47 | +45 | **alive: the one I'd bring first** |
| [I2](i2-gloss-tier.md) | **A gloss tier**: readings on the line below, carets pointing up; in prose, `^~~~~ time` types a span with the prose untouched | interlinear glossing, standoff annotation, compiler carets | −24 | −21 | alive as a reader-layer idea; costly as syntax |
| [I3](i3-signature-accidental-natural.md) | **Signature, accidental, natural**: a *legend* (an exemplar element whose values are reading names), I1 for one-off readings, quotes for "just these characters" | key signatures and ♮; map legends | +42 | +60 | **alive, and needs no new syntax** |
| [I4a](i4-small-glyphs.md) | `№01234`: a numeral that's a name | Stevens' levels of measurement | +5.5 | +5.5 | the insight lives, the glyph doesn't |
| [I4b](i4-small-glyphs.md) | `ℕ8080`, `ℝ0.75`, `ℚ1/3`, `ℂ3+4i` as assertions; `∅` as nil | blackboard bold, the empty set | −9 (∅ alone +15) | −1 (∅ +15) | **∅ alive**; the letters are taste |
| [died](i4-small-glyphs.md#died-with-the-reason) | corner annotations, ✓/✗ booleans, superscript tags, HGVS prefix-dot, linguists' level brackets | chemistry, ballots, typography, genetics, linguistics | — | — | dead, with findings |

## What the inventive pass found that the survey didn't

1. **Human notations built for reading put the qualifier after the value; programming notations put it before, for the parser.**
   - *After:* units, ruby, glosses, state symbols, footnote marks, ascription `x : ℝ`, `9.99 USD`.
   - *Before:* casts, sigils, KDL `(u8)`, EDN `#inst`, `<dt: …>`.
   - *Exceptions, to be honest:* accidentals precede the note; `$` and `№` precede the number; and *region-level* declarations (key signatures, legends) come first.

   F1 removed the parser's reason for "before". So I1 puts the author's reading at the run's close, **exactly where the parser's classification already arrives**: one place in the tree for "how to read this", written by either.
2. **One mark, two positions, Joseph's two questions.**
   - `:port<u16> 8080`: *what the slot is*, the slots fork's reserved spelling.
   - `:port 8080<u16>`: *what my literal represents*.
3. **The identifier hazard is a level-of-measurement problem** (nominal vs ratio). That's why only the slot can decide it, and why a legend entry (`:zip postal-code`) settles it once per document.
4. **A schema can be an example of the data.** I3's legend teaches the way a map legend does: one sample of each kind, its values replaced by what they are. Lite carries it with today's cards, reading nothing.
5. **Plain text has one dimension; a gloss line is its second.** Chemistry's corner annotations died on that, and the gloss tier is what's left of them.
6. **Identity by spelling is measurement honesty, not only identifier safety.** `1.10` keeps three significant figures (Joseph, 07-14, history.jsonl L16172–3: "tracking significant figures … will be crucial").

## How the inventions compose (my taste)

I1 + I3 + ∅. Values bare as people write them. A legend, once, for kinds that need reading. A trailing `<reading>` for the rare one-off. Quotes for "exactly these characters". `∅` (or `<>`) for nil. Prefix `<…>` would then have no job left except perhaps `<>`.

The I1 + I3 composite line:

```udon
:$legend |server :port u16 :timeout duration :started datetime
|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 :mask 0xff<u64> :backup ∅ ; prod
```

## Open, for whoever picks this up

- whether "token-bounded" holding (I1's `<label>` at a run's end) counts as bounded for B1;
- whether a hand-written `$legend` is allowed;
- a vocabulary for reading names (unions, lists);
- column width for Ambiguous-width characters (I2).
