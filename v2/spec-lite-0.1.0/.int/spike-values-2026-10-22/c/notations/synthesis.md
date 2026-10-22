# Round two, weighed: notation values for lite 0.1

*Spike c, the spike agent's synthesis over eight notation designs, written after all eight landed:*
- *five careful ones, each pushed to its strongest form: `raw`, `args`, `std` (revised to `std★` after the creativity note), `slot`, `elem`;*
- *my inventions page;*
- *three inventive forks: `combo`, `bra`, `wild`.*

*Scores are hypotheses. Beauty comes first, as CTQ ranks it.*

## What I'd put in lite 0.1, as one design

**The value bracket reads like a printed page.** It holds a value written the way the domain prints it. When the domain has no printed shape, the writer names the notation. A name alone is a clef for what follows. A bare primitive is text that also carries its other face.

```udon
|event :on <2026-10-01> :at <2026-01-10T07:30-07:00[America/Denver]> :lasts <90 min> :fee <9.99 USD>
|box :width <css:920px> :height <5 m> :fill <50%> :temp <37.5 ± 0.2 °C> :size <1920 × 1080 px>
|season :span <2026-01 – 06> :holidays <date> [2026-01-01 07-04 12-25]
|ok :pattern <re:\d+-\w+> :home <https://example.com> :owner @<people/jw> :port 8080
|p Meet on [Oct 1st](date:2026-10-01); the review is due <{2026-10-15}>.
```

**The raw tree** (lite's; fixtures show this; nothing has been read by any notation):
````tree
root
  |event
    :on    2026-10-01::date
    :at    2026-01-10T07:30-07:00[America/Denver]::datetime.zoned
    :lasts qty(90, ‹min›)
    :fee   money(9.99, ‹USD›)
  |box
    :width named(css, ‹920px›)
    :height qty(5, ‹m›)
    :fill  qty(50, ‹%›).glued
    :temp  qty(37.5 ± 0.2, ‹°C›)
    :size  qty(1920 × 1080, ‹px›)
  |season
    :span      range(‹2026-01›, ‹06›).endash
    :holidays  [‹2026-01-01› ‹07-04› ‹12-25›]   ⟨clef date⟩
  |ok
    :pattern named(re, ‹\d+-\w+›)
    :home    named(https, ‹//example.com›)
    :owner   ref(‹people/jw›)
    :port    ‹8080›~int
  |p
    :$main ‹Meet on [Oct 1st](date:2026-10-01); the review is due › <{2026-10-15::date}> ‹.›
````

**After a `std` reader** (the logical tree): the same positions hold read values, each keeping its spelling and form:
- `:on` the date 2026-10-01, `:at` the zoned instant, `:lasts` 90 minutes, `:fee` 9.99 USD exactly;
- `:width` a CSS length if `css` is in scope, otherwise `unread{css, "920px"}`;
- `:span` January to June 2026, with the elided end resolved against the start;
- `:holidays` three dates, read through the clef with their years filled in;
- `:pattern` a regex, `:home` a URI, `:owner` a kept reference;
- `:port` either the text `8080` or the integer 8080, whichever face the reader asks for;
- the paragraph is text, and a Markdown-aware reader also sees a link whose target is a date.

**The raw tree never changes when a reader learns a notation.** That law, binding on all of UDON, is what lets lite carry named bodies today and still pass the reserve-don't-ignore veto.

## The pieces, where each comes from, and why it's in

| Piece | Spelling | From | Why it's in (Beauty first) |
|---|---|---|---|
| **Typeset shapes** | `<2026-10-01>`, `<09:00>`, `<P1Y2M>`, `<90 min>`, `<37.5 °C>`, `<50%>`, `<9.99 USD>`, `<€12>` | `std★`, `combo` | The page reads like the domain's own: timetable, invoice, spec sheet. No names on the common kinds (A1, A4, A9). Checked at parse time, with errors that teach (B4 9–10). |
| **The symbol rule** | letter units spaced (`<5 m>`), symbol units may glue (`<50%>`, `<45°>`) | `combo`, my inventions | A principle, not a list: letters glued to digits are words (`1st`, `4K`, `401k`); symbols never are. `<5m>` is an error that asks "metres `<5 m>` or minutes `<5 min>`?" |
| **Printed units** | `°C`, `GiB`, `m/s²`, `kΩ`; UCUM codes (`Cel`, `GiBy`) accepted as aliases | `combo`, `bra`, `std★` | What people read. UCUM is the machine table behind it. `B` is the byte; the bel is printed `dB`. |
| **En-dash ranges** | `<2026-01 – 2026-06>`, `<18 – 25 °C>`, `<09:00–17:00>` | `std★`, `combo` | The typographer's range mark, with the unit written once as tables print it. The ISO `/` is also accepted for temporal values. A hyphen range is an error that suggests the dash. |
| **Elision** | `<2026-01 – 06>`, `[<date> 2026-01-01 07-04 12-25]` | `wild` W2 (LilyPond relative mode; "1914–18") | Write it once, like a person. It is a reading over the raw spelling, and an end that falls before its start is an error. |
| **Typeset relations** | `<37.5 ± 0.2 °C>`, `<1920 × 1080 px>`, `<6.022 × 10²³>` | `std★`, `wild` W3 | Uncertainty and dimensions as engineers print them. No other data notation carries uncertainty. |
| **Named notations, URI-shaped** | `<css:920px>`, `<re:\d+-\w+>`, `<date(YY-MM-DD):27-03-05>`, `<rust:i64:0x73DDF>` | `combo` (α), `raw` (verbatim body) | URIs, CommonMark autolinks and named values become one thing, so `<https://…>` means what Markdown means. Namespacing is delegation, the colon ladder (Joseph's `<rust:i64: …>`, and URNs'). Parameters look like a constructor (`date(YY-MM-DD)`). Bodies are verbatim, so a regex keeps its own spelling. |
| **Clefs** | `<date> [2026-01-01 2026-07-04]`; `:each <money>` above a body; `:on <date> 2026-10-01` | my inventions (ε), `combo`, `bra` | Declare the reading once, then just write. In the tree a clef is an attachment, so it changes no arity. It fills the slot design's one gap, a list whose kind must be stated in place. |
| **Fences as the block form** | ```` ```sql ```` … | `raw` | One concept, a value in a named notation, spelled inline or as a block according to its length. |
| **Prose** | `[Oct 1st](date:2026-10-01)`; `<{2026-10-15}>` | my inventions (ζ), `combo`, `raw`, `std` | The Markdown link already pairs human words with a machine value, and passes through untouched. `<{…}>` is the value embed beside `|{` `@{` `;{`. |
| **Kept references** | `@<people/jw>` | `raw`, `combo` | Joseph's "reference kept as a reference, not resolved in place", with a principled home: `@{x}` resolves, `@<x>` is kept. |
| **Bare primitives are allomorphs** | `:port 8080` → ‹8080›~int | `wild` W1 (Raku's `IntStr`) | Tells the truth about `1.10`: text *and* float until a reader picks. The kind is text from the first character, so B1 holds even as currently worded, and the round-one dial becomes "which face does a generic converter pick". |
| **Vocabularies, scope, slot types** | lite documents of definitions; file name, root attribute or reader configuration | `slot`, `reader-model.md` | Algebraic names (`port = u16 | service`) and aliases live here. A slot is a standing clef plus a constraint, and a literal's notation overrides it, checked after reading. |

## The decisions that are genuinely Joseph's, with examples

### 1. The bracket: ASCII `<…>` or `⟨…⟩`

```udon
|li <kbd>Ctrl</kbd> to copy
|li <https://example.com>
|event :on <2026-10-01>
```
```udon
|li <kbd>Ctrl</kbd> to copy
|li <https://example.com>
|event :on ⟨2026-10-01⟩
```

- **ASCII `<…>`** (`combo`): line 1 is an error ("this looks like HTML; write `\<kbd>`"), line 2 is a URI value, line 3 is a date.
- **`⟨…⟩`** (`bra`): lines 1 and 2 are just text with no escapes anywhere, and only line 3 is a value. `bra` checked that the Unicode database's informal aliases for U+27E8/9 are literally "bra" and "ket".

**What `⟨⟩` frees:** every HTML and Markdown collision; `⟨…⟩` can even be recognized in prose (`Meet on ⟨2026-10-01⟩.`). **What it costs:** no agent writes `⟨` unprompted (A2 5 against 7). `⟨` and `<` look alike to people (A11). The tree notation needs another glyph.

**My lean: ASCII `<…>`**, with low confidence. Guessability and cold comprehension are the two weight-10 contributors, and every `<` collision under `combo` is loud, never silent. This is the cheapest question in the spike to measure: three examples, a fresh panel, "write these values". If agents shown `⟨…⟩` three times write it back reliably, `bra` wins on beauty and on HTML.

### 2. What separates a name from its body

```udon
|a :home <https://example.com> :w <css:920px>       ; combo: no space; URIs are values
|a :home <https://example.com> :w <css: 920px>      ; raw: colon-space; a URI here is an error
|a :home ⟨https://example.com⟩ :w ⟨css|920px⟩       ; bra: a bar, the bra-ket
```

`raw` chose colon-space so that a URL can never silently be a notation. `combo` makes the URL *be* a notation, the one Markdown means. **My lean is `combo`'s**, because the collision stops being a collision. `raw`'s concern survives as one specific rule: a scheme the reader doesn't know reads as `unread`, and a strict getter raises.

### 3. Which face a converter picks for bare primitives (round one's dial, now narrower)

```udon
|server :port 8080 :zip 01234 :version 1.10 :tls true
```
The raw tree is the same for every reader: ‹8080›~int, ‹01234› (no face: a leading zero isn't a number), ‹1.10›~float, ‹true›~bool. `int(:port)` gives 8080 and `text(:version)` gives `1.10`, always. The only question left is what a converter to JSON does with no schema. **My lean: the primitive face** (JSON's own convention: quote `"1.10"` if you mean a string). The Cv fork's lean was the text face.

### 4. How much typeset grammar lite 0.1 carries

The shape set is the largest grammar in lite (A6 ~6, A7 ~4, D2 ~5 in every design that has it). **My lean: carry it all**, because CTQ ranks Beauty and its contributors (A1–A5, 9–10) above spec clarity and simplicity (9, 8). If it must shrink, cut in the order the forks agree on: size pairs and `× 10ⁿ`, then datetime intervals, then glued symbol units. Never cut dates, quantities, durations or dash ranges.

## The cheaper designs, and what each would give instead

Every design has a meaning; none is "later".

- **`elem`: no new grammar at all.** `:when |date 2026-10-01`, `|{qty 5 m}` in prose, and a reader collapses known notation elements into values. Simplicity 10, headroom 10, beauty 7 (taste: structure dressed as values). It is the right design if A6/A7 matter more than CTQ says. Its sameline hazard (`:when |date … :until …` gives `until` to the date) is caught only for known notations.
- **`slot`: notation on the name.** `:when<date> 2026-10-01`, with vocabularies typing slots. Domain-forward 9, slot types 10. In my design the clef does the same job without a second role for `<` after a name. `slot`'s vocabularies are the reader companion every design uses.
- **`args`: REBOL dialect.** `<interval <date 2026-01> <date 2026-06>>`, with lite lexing the arguments. Cleanest nesting. Its own author found it one step from `elem` without `elem`'s cheapness.
- **`raw`: verbatim named bodies, fences as the block form.** Absorbed into the design above (the verbatim body, fences, `@<…>`, `<{…}>`).
- **`std` / `std★`: the shape set.** Absorbed, with its SI typography.

## Scores (my hypotheses; Beauty first; full tables on each design page)

| Factor (weight) | **proposal** (combo + W1–W3) | bra | elem | slot | raw |
|---|---|---|---|---|---|
| A1 beauty (9) | 9 | 9 | 7 | 7 | 7 |
| A2 guessability (10) | 7 | 5 | 7 | 7 | 7 |
| A3 cold comprehension (10) | 8 | 8 | 7 | 7 | 9 |
| A4 agentic readability (10) | 9 | 8 | 7 | 8 | 8 |
| A5 domain-forward (9) | 9 | 9 | 7 | 9 | 7 |
| A6 spec clarity (9) | 6 | 6 | 8 | 7 | 8 |
| A7 syntactic simplicity (8) | 4 | 6 | 10 | 6 | 8 |
| A8 parsimony (8) | 8 | 7 | 10 | 7 | 9 |
| B1 / B2 vetoes | pass / pass | pass / pass | pass / pass | pass / pass | pass / pass |
| B4 errors that teach (8) | 9 | 9 | 6 | 7 | 9 |
| B6 headroom (7) | 6 | 6 | 10 | 8 | 6 |
| C2 XML/HTML (10) | 7 | 10 | 8 | 9 | 8 |
| C3 Markdown (9) | 10 | 10 | 8 | 8 | 8 |
| C4 notations and units (8) | 10 | 9 | 9 | 8 | 9 |
| C5 slot types (8) | 8 | 8 | 7 | 10 | 8 |

*(Columns other than the proposal are the forks' self-scores where they gave them. Where a fork gave none, the value is my estimate, read from its page. Confidence is low to medium throughout. Nothing was measured, except the B fork's classifier and my streaming probe from round one.)*

## What I'm least sure of

- **Whether agents write the en dash and the clef unprompted.** These are guesses; the same three-example panel would answer them.
- **Elision (W2)** reads beautifully, but a reader without the clef sees ‹07-04› as text. That's honest, since nothing is lost, but it is less for a schema-less reader.
- **`|li <https://example.com>`** makes `$main` a URI value. Its spelling is kept, so Markdown re-emission is exact, but a consumer wanting text must ask for the spelling.
