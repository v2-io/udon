# Bra-ket values: ⟨reader|spelling⟩

*Spike c, round two, fork "bra" (Opus 5.5, 2026-10-22). This develops invention δ of `../inventions.md` into a full design. I invented first, then judged, and the judging is at the end, Beauty first. Labels: **checked** (UCD 18 via the unicode tool, or a card), **instinct** (what I'd write or expect as a target writer and reader), **taste**, **guess**. Scores are my hypotheses and nothing was measured.*

## The idea in one line

Lite owns a bracket that ordinary text never uses, `⟨ ⟩`, and spends it on one meaning only: **a value, read for what it is**. Inside, an optional *bra* names the reader and an optional *ket* is the spelling: `⟨date|2026-10-01⟩`. ASCII `<` goes back to HTML and Markdown, completely.

**A checked fact that made me smile:** the Unicode Character Database gives U+27E8 ⟨ MATHEMATICAL LEFT ANGLE BRACKET the informal alias **"bra"**, and U+27E9 ⟩ the alias **"ket"**. The standard itself already calls these two characters what this design uses them for. They are East Asian Width *Narrow*, so alignment in monospace survives. They have no decomposition, so NFC and NFKC leave them alone.

## Inventing first: the family of brackets lite could own

Typing cost is weight 2, so any bracket is on the table. I tried each on `:on ⟨date|2026-10-01⟩` and on prose ("Meet on ⟨2026-10-01⟩.") and asked what an agent sees with no highlighting.

| Bracket | What it already means | On the page | Verdict (taste first) |
|---|---|---|---|
| **⟨ ⟩** U+27E8/9 | bra-ket (Dirac); sequences in Z notation; inner products | `⟨date|2026-10-01⟩` | **chosen.** Calm, mathematical, narrow, and its alias *is* bra/ket. Its one cost is that it resembles `<` |
| ⟦ ⟧ U+27E6/7 | semantic brackets: ⟦e⟧ is "the meaning of e" (Scott–Strachey) | `⟦date|2026-10-01⟧` | **runner-up.** Its meaning, the denotation of a spelling, is exactly right. It looks heavier, it has no name slot of its own (denotation is usually subscripted), and the tree-notation proposal already wants it for raw text |
| ⟪ ⟫ U+27EA/B | double angle; Z chevrons | `⟪date|…⟫` | heavy for something on every data line; kept in reserve (below) |
| 〈 〉 U+3008/9 | CJK title marks | `〈date|…〉` | **dead:** East Asian Width *Wide*, which breaks column alignment (checked), and it is ordinary CJK punctuation in prose |
| « » / ‹ › | quotation marks in French, German, Russian prose; `‹…›` is the cards' tree notation for text | `«date|…»` | **dead:** they collide with prose (C3) and with the tree notation |
| ⦇ ⦈ / ⦉ ⦊ | Z-notation image and binding brackets | `⦇date|…⦈` | pretty but unfamiliar; fails A3 cold |
| ⌜ ⌝ U+231C/D | **Quine corners**: quasi-quotation, "this expression, as written" | `⌜people/jw⌝` | **not for values, but beautiful for the *other* job:** Joseph's quote/unquote distinction. See "A second glyph, if wanted" |

**The bar.** I kept ASCII `|`. It is what bra-ket is written with everywhere it's typed (LaTeX `\langle a | b \rangle`), and inside `⟨…⟩` it can't be read as an element marker. I tried U+2223 ∣ DIVIDES ("such that"), but it is a confusable of `|` for no gain.

## The design

### Spellings

| Form | Example | Means |
|---|---|---|
| **empty** | `⟨⟩` | nil (Joseph's `<>` lean, carried over) |
| **primitive** | `⟨8080⟩` `⟨0.5⟩` `⟨true⟩` `⟨nil⟩` `⟨"1.10"⟩` | asserts a portable primitive (M1's job) |
| **ket only: the shape names the kind** | `⟨2026-10-01⟩` `⟨90 min⟩` `⟨9.99 USD⟩` `⟨2026-01 – 2026-06⟩` `⟨https://example.com⟩` | read by shape, from the closed **standard shape set** below |
| **bra and ket** | `⟨date|2026-10-01⟩` `⟨re|\d+-\w+⟩` `⟨acme/sku|AB-12⟩` | read by the named notation |
| **bra with parameters** | `⟨date YY-MM-DD|27-03-05⟩` `⟨re pcre|…⟩` | parameters follow the name, separated by spaces, before the bar. It reads aloud as "date in YY-MM-DD, of 27-03-05" |
| **bra alone: a clef** | `⟨date|⟩` | not a value. It is the reader, waiting for kets, and it reads the values after it in the same list, body or slot (ε) |
| **block form** | ```` ```sql ```` + body | a fence: its name is a bra, and its body is one multi-line ket |

Spaces around the bar are ornament: `⟨date | 2026-10-01⟩` is the same value as `⟨date|2026-10-01⟩`. Typeset bra-ket often breathes like that, and alignment likes it.

### Discrimination: kind-first, within a label's length (B1)

After `⟨`:
- `⟩` gives nil;
- `"` or `'` gives a string;
- a digit, sign or `.` gives a number *or* a numeric shape (date, time, quantity, money, interval), decided at the first non-digit within a bounded distance, as the `std` fork's `discriminate.py` showed for the same set;
- a letter gives a label, then:
  - `⟩` makes it a keyword (`nil`, `true`, `false`; any other is an error: "`⟨foo⟩` names no value; did you mean `⟨foo|…⟩`?");
  - `|` or a space makes it a bra;
  - `:` makes it a URI shape (`https:`, `mailto:`, `geo:`).

Holdback is at most a label, so B1 passes on either reading of B1.

### The standard shape set: what a ket means with no bra

The shapes are beautiful by being *how these things are printed*.

| Shape | Examples | Kind | Notes |
|---|---|---|---|
| RFC 3339 date, year-month, year | `⟨2026-10-01⟩` `⟨2026-10⟩` | date (partial allowed) | |
| time | `⟨09:00⟩` `⟨09:00:30.5⟩` | wall time | |
| date-time with `Z` or offset | `⟨2026-01-10T14:30Z⟩` | instant | |
| RFC 9557 zone suffix | `⟨2026-01-10T07:30-07:00[America/Denver]⟩` | zoned | `!` critical flag allowed, as RFC 9557 (checked by the coordinator) |
| ISO 8601 duration | `⟨P1Y2M⟩` `⟨PT30S⟩` | duration | |
| **range with an en dash** | `⟨2026-01 – 2026-06⟩` `⟨09:00 – 17:00⟩` `⟨18 – 65⟩` | interval | U+2013, checked; the typesetter's range mark. ISO's `/` accepted too |
| **quantity: number, space, unit** | `⟨5 m⟩` `⟨90 min⟩` `⟨1.5 GiB⟩` `⟨9.81 m/s²⟩` | quantity | SI spacing. Units are SI and SI-accepted symbols plus IEC byte symbols (`B` is byte, `KiB`…`GiB`, `kB`…`GB`), with superscript exponents. The reader maps to UCUM codes internally (`°C` → `Cel`, `B` → `By`), so the page shows what people read, not UCUM's ASCII plumbing (taste) |
| **symbol units, glued or spaced** | `⟨50%⟩` `⟨50 %⟩` `⟨37.5 °C⟩` `⟨37.5°C⟩` `⟨45°⟩` `⟨3‰⟩` | quantity | symbols can't collide with words, so gluing is safe (γ+). `℃` (U+2103) has a compatibility decomposition to `°C` (checked); accept it and canonicalize |
| money: amount, space, ISO 4217 code | `⟨9.99 USD⟩` | money | `⟨$9.99⟩` is an error: "`$` is several currencies; did you mean `⟨9.99 USD⟩`?" |
| URI (autolink shape) | `⟨https://example.com⟩` `⟨mailto:jw@v2.io⟩` | uri | |

**Letter units need the space.** `⟨5m⟩` is an error: "did you mean `⟨5 m⟩` (metres) or `⟨duration|5m⟩` (minutes)?" This is the `5m` question answered in the place where it can be asked. It is an error that teaches (B4), not a guess.

The set is **closed**. Any other unlabeled interior is an error, so it can grow only into what lite refuses today (B2).

### The raw tree, and after

- **Raw tree (lite's).** A value node holding: its *form* (`braket`), the bra as written (name and parameters) or none, the ket as written, and for shapes, lite's classification (`std/date`, `std/qty`, …). Lite classifies shapes at parse time because it owns the closed set. **It never interprets a named bra.**
- **Logical tree (a reader's).** The same position holds `{type, value, notation, params, spelling, form}`. Canonical re-emission calls the notation's `write`: `⟨date YY-MM-DD|27-03-05⟩` re-emits canonically as `⟨2027-03-05⟩`, the parameter resolved into the value. The other way to re-emit is as written.
- **The law** (B2's condition, as the mark fork found): a reader learning a notation changes the logical tree, never the raw one.
- **Unknown notations** (`⟨acme/sku|AB-12⟩`) read to `unread{acme/sku, "AB-12"}`; a strict getter raises "no reader for `acme/sku` in scope". Names, scope and vocabularies follow `../reader-model.md`, unchanged.

### What freeing `<` does

ASCII `<` stops being lite syntax anywhere. `|li <kbd>Ctrl</kbd> to copy`, `|li <https://example.com>`, `|li <= 5 items` and `:alt 5 < 6` are all just text, and Markdown and HTML pass through without one escape. `<` leaves the sameline escape set.

The habit cost is real. A writer trained on round one, or on 0.9 drafts, types `:port <8080>`. That is now the text `<8080>`, silently. **So the design adds one default-on warning:** a value-position run that is exactly `<…>` whose inside is a primitive or a standard shape warns: "`<8080>` is text; did you mean the value `⟨8080⟩`?" Lookalikes get the same treatment: `〈` (U+2329, canonically equivalent to the CJK `〈` U+3008, checked) and `‹ ›` inside a value position are errors that suggest `⟨ ⟩`.

### Prose: the owned glyph earns its keep

Because `⟨` never occurs in ordinary prose, **lite can recognize `⟨…⟩` inside prose as a value embed**, beside `|{…}`, `@{…}` and `;{…}`, without stealing anything from Markdown:

```udon
|p Meet on ⟨2026-10-01⟩ at ⟨09:00⟩, for about ⟨90 min⟩.
```
````tree
  |p  :$main ⸨"Meet on " ⟨std/date 2026-10-01⟩ " at " ⟨std/time 09:00⟩ ", for about " ⟨std/qty 90 min⟩ "."⸩
````

The words around the values are untouched. For ruby (display words *and* a value), use the element: `|{time Oct 1st :at ⟨2026-10-01⟩}`. I tried a one-glyph ruby, `⟨Oct 1st‖2026-10-01⟩`, and dropped it: a third part inside the bracket made every value harder to read.

### A second glyph, if wanted: Quine corners for "kept as written"

Joseph's Lisp distinction (quoted vs unquoted) and his "reference kept as a reference, not resolved in place" both want **a quote**. Logic already has one: Quine's corners, `⌜…⌝` (U+231C/231D, chart heading "Quine corners", checked).

- `@{people/jw}` resolves; `⌜people/jw⌝` is the reference itself, kept.
- More generally, `⌜…⌝` is anything carried as written and never read: a template, an address, a formula.

It would replace `@{<…>}` and `@<…>`. It costs a second owned glyph (A8), so it's offered and not built in. The bra-only spelling `⟨ref|people/jw⟩` does the same job with no new glyph.

## The composite set, N1–N18

```udon
|n1  :on ⟨2026-10-01⟩
|n2  :at ⟨2026-01-10T14:30Z⟩ :at-local ⟨2026-01-10T07:30-07:00[America/Denver]⟩
|n3  :opens ⟨09:00⟩ :year ⟨dt|2026 PDT⟩
|n4  :born ⟨date YY-MM-DD|27-03-05⟩
|n5  :wait ⟨PT30S⟩ :span ⟨P1Y2M⟩ :timeout ⟨duration|5m⟩ :timeout2 ⟨5 min⟩
|n6  :season ⟨2026-01 – 2026-06⟩
|n7  :width ⟨css|920px⟩ :height ⟨5 m⟩ :disk ⟨1.5 GiB⟩ :fill ⟨50%⟩ :temp ⟨37.5 °C⟩
|n8  :price ⟨9.99 USD⟩
|n9  :addr ⟨i64|0x73DDF⟩ :addr2 ⟨rust i64|0x73DDF⟩
|n10 :port ssh
|n10 :port 22
|n11 :pattern ⟨re|\d+-\w+⟩ :home ⟨https://example.com⟩ :id ⟨uuid|0b6f…⟩ :blob ⟨b64|SGVsbG8=⟩
|n12 :query
  ```sql
  SELECT * FROM t
  WHERE d > '2026-01-01'
  ```
|n13 :holidays [⟨date|⟩ 2026-01-01 2026-07-04 2026-12-25]
|n13 :holidays ⟨date|⟩
  2026-01-01
  2026-07-04
|n14 :sku ⟨acme/sku|AB-12⟩
|n15 :when ⟨instant|2026-01-10T14:30Z⟩     ; `when` declared a date by the vocabulary
|n16 Meet on ⟨2026-10-01⟩.
|li <https://example.com>
|n17 :author @{people/jw} :author-ref ⟨ref|people/jw⟩
|n18 :on ⟨2026-10-01⟩ :on2 ⟨date basic|20261001⟩
```

| | Raw tree (lite) | After a reader | Verdict |
|---|---|---|---|
| N1 | `⟨std/date "2026-10-01"⟩` | date 2026-10-01 | renders, no plumbing beyond the bracket |
| N2 | instant; zoned | instant; zoned | renders; RFC 9557 verbatim |
| N3 | time; `⟨dt "2026 PDT"⟩` raw | time; `dt`, a notation in Joseph's vocabulary that knows PDT, reads a zoned year | renders. `⟨2026 PDT⟩` unnamed is an error ("zone abbreviations are ambiguous; name a reader or use `[America/Los_Angeles]`") |
| N4 | `⟨date[YY-MM-DD] "27-03-05"⟩` | date 2027-03-05 | renders; the parameter is visible, and in the logical tree |
| N5 | duration ×2; `⟨duration "5m"⟩`; qty 5 min | durations | renders. Inside `duration`, `m` is minutes; as a shape, `5 min` is unambiguous |
| N6 | interval(date 2026-01, date 2026-06) | interval | **renders beautifully** with the en dash |
| N7 | `⟨css "920px"⟩`; qty ×4 | lengths, bytes, ratio, temperature | renders; `⟨920 px⟩` is also accepted if `px` joins the unit list. My lean: no, because CSS owns `px` |
| N8 | money(9.99, USD) | exact decimal + currency | renders |
| N9 | `⟨i64 "0x73DDF"⟩`, `⟨rust[i64] "0x73DDF"⟩` | integer in i64 range | renders; the `rust` bra is host plumbing (A5 low) and possible but not encouraged |
| N10 | ‹ssh›, ‹22› | port via the slot's union in a vocabulary | renders through the slot (reader model); `⟨port|ssh⟩` is possible when no vocabulary is in scope |
| N11 | re; uri; uuid; b64 | as named | renders; the regex needs no escaping, since only `⟩` would |
| N12 | fence, name `sql` = bra | sql text | renders; fence = block bra |
| N13 | list: clef `⟨date|⟩` then three texts; body likewise | three dates | **renders**: the clef reads each; this is the slot fork's one gap, closed in place |
| N14 | `⟨acme/sku "AB-12"⟩` | unread{acme/sku} | renders, nothing lost |
| N15 | instant | reader error: "slot `when` expects std/date; this is std/instant; did you mean `⟨2026-01-10⟩`?" | renders, caught |
| N16 | prose with a date embed; ‹<https://example.com>› as text | — | renders; the autolink is Markdown's again, untouched |
| N17 | reference (resolved later); `⟨ref "people/jw"⟩` kept | ref value | renders; `⌜people/jw⌝` if Quine corners are adopted |
| N18 | `⟨std/date "2026-10-01"⟩`; `⟨date[basic] "20261001"⟩` | both 2026-10-01 | as written: unchanged. Canonical: both `⟨2026-10-01⟩` |

## Weighing, Beauty first (hypotheses; basis and confidence)

| | Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|---|
| A1 | Agent-subjective (9) | **9** | Taste: one owned bracket meaning *value*, one bar meaning *read as*. The page is calm. The strongest beauty is that `<` stops needing escapes anywhere, so HTML and Markdown stay themselves | medium |
| A2 | Generative guessability (10) | 5 | Instinct: cold, I would not produce `⟨`; I'd write `<8080>` or `"2026-10-01"`. After seeing three examples I'd write `⟨date|…⟩` and `⟨5 m⟩` correctly and guess the en dash, the clef less surely. The ASCII-habit miss is caught by the warning | medium |
| A3 | Cold comprehension (10) | 8 | Instinct: `⟨date|2026-10-01⟩` reads correctly with no exposure (math bracket, name, bar, value); `⟨90 min⟩` and `⟨2026-01 – 2026-06⟩` read as what they are | medium |
| A4 | Agentic readability (10) | 9 | A distinct code point with one role; no `<` ambiguity left in the file | medium |
| A5 | Domain-forward (9) | 8 | Shapes are the domain's own printed forms; the clef removes per-value plumbing in lists and bodies | medium |
| A6 | Spec clarity (9) | 7 | One bracket, one bar, one shape table; the table is the long part | medium |
| A7 | Syntactic simplicity (8) | 6 | the shape set is real grammar | medium |
| A8 | Parsimony (8) | 8 | net: ⟨⟩ gained, `<` freed entirely; `|` gains a role only inside ⟨⟩ | medium |
| A9 | Conciseness (6) | 7 | `⟨2026-10-01⟩` is one bracket pair; the brackets are multi-byte (B7) | low |
| A11 | Human readability (5) | 7 | pretty, but ⟨ and < look alike in some fonts | low |
| A12 | Human writability (2) | 2 | needs a compose key or a snippet | high |
| B1 | Bounded streaming (veto) | **pass** | holdback is at most a label | high |
| B2 | Reserve, don't ignore (veto) | **pass** | the shape set is closed and errors outside it; the law for named bras; `<` is declared text for good (a commitment, below) | medium |
| B3 | Stability (10) | 9 | one tree; shape errors are lite's, named-bra errors the reader's | medium |
| B4 | Errors that teach (8) | 9 | `<8080>`, `〈`, `⟨5m⟩`, `⟨$9.99⟩`, `⟨2026 PDT⟩`, `⟨foo⟩` each suggest a fix | medium |
| B5 | Parse speed (9) | 8 | multi-byte delimiters cost a byte compare; the shape set is finite state | low |
| B6 | Headroom (7) | 7 | spends ⟨⟩ (owned now) and gives up `<` as future syntax for good. ⟪⟫ and ⌜⌝ stay free | medium |
| B7 | Size (3) | 6 | three bytes per bracket | high |
| C1 | Structured data (10) | 7 | JSON numbers want `⟨8080⟩` unless the standard-reading dial covers bare runs (round one's question, unchanged) | medium |
| C2 | XML/HTML (10) | **10** | `<` is never lite's | high |
| C3 | Markdown (9) | **10** | autolinks, inline HTML and `<=` all pass through | high |
| C4 | Types, notations, units (8) | 9 | every N-item renders, units in their printed form | medium |
| C5 | Schemas, slot types (8) | 8 | vocabularies per the reader model; the clef is an in-place slot type | medium |
| C6 | Extensibility (8) | 9 | any bra, namespaced | medium |
| C8 | Other languages (8) | 9 | fence = block bra | medium |
| C10 | Round-trip (7) | 9 | form, bra, ket and spelling kept | high |
| D3 | Editor integration (5) | 4 | people need a key binding; agents don't | medium |

## The honest costs, in one place

1. **Guessability.** No cold agent will write `⟨` first. The design leans on one or two exposures and on the `<…>` warning. This is the factor most likely to sink it, and a panel would settle it quickly: show three examples, then ask for twenty values.
2. **Confusability with `<`** for people in some fonts (not for agents, which see different code points). The lookalike errors catch the reverse direction (`〈`, `‹`).
3. **`<` is gone for good** as future lite or UDON syntax. That's a deliberate spend of headroom in exchange for C2 and C3 at 10.
4. **The shape set is the biggest grammar** in the family, shared with the `std` design. The bra-ket form doesn't remove it. Every unlabeled shape could require a bra instead (`⟨date|2026-10-01⟩` only); that's simpler (A7 8) and less beautiful (A1 7).
5. **The tree notation must not reuse ⟨⟩.** The raw-tree column above writes values as `⟨std/date "…"⟩` for brevity, which breaks Joseph's rule that a printed tree never conflates UDON forms with AST primitives. A real transcript would have to pick another glyph.
6. **Card radius: large.** Every `<…>` card changes glyph. The escape set, the reserved list (the `<` rows go and a `⟨` row comes in), [[rule:opaque-span-raw-text]] (it splits off `⟨⟩`), the PEG, and [[rule:prose-passes-through]] (a fourth embed) all change. Nothing a document already relies on is lost, since lite has no released `<…>` users.

## What lite 0.1 would take

All of it, except the Quine corners, which are Joseph's choice:
- the bracket, bar, clef, shape set and `<…>` warning in the grammar;
- the reader model and `std` notation table as the companion.

If the shape set has to shrink for 0.1: keep primitives, dates, times, instants, quantities and money; drop zoned, intervals and URIs first.
