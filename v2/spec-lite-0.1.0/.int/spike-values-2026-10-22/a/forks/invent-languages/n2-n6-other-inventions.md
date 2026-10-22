# N2–N6: the other inventions

*Invention fork of spike a, 2026-10-22. Same tree glyphs as [n1](n1-tagged-code-values.md). Each section: where it comes from, what it became, its rendering on the parts of the composite set it changes, what I find beautiful, and then what worries me. The weighing against CTQ-FACTORS is in [weighing.md](weighing.md).*

---

## N2: tagged quotes and named lists (Python's and Julia's prefixes; CSS functional notation)

**From:**
- Python's `r"…"` `b"…"` `f"…"`;
- Julia's `v"1.10"` (a version literal) and `r"…"`;
- Scala's `s"…"`;
- CSS's `rgb(255 0 0)`, `url(…)` and `calc(…)`.

Every agent has seen a word glued to a quote, or to a parenthesized list, meaning "read this as a …".

**Became:** a label touching `"` names a string's reader, and a label touching `[` names a list's reader. The single quote is left out on purpose: `Ender's Game` and `don't` are ordinary bare text, and they would open a string.

```udon
|part :version v"1.10" :pattern re"^\\d+$"
|box :fg rgb[255 0 0] :at geo[40.71 -74.00] :size wh[1920 1080]
|decision :date date"2026-07-21" :span iv[2026-01 2026-06]
|cfg :tags set[a b c]
```
````tree
root
  |part
    :version tagged v "1.10"
    :pattern tagged re "^\d+$"
  |box
    :fg tagged rgb [⸨255⸩ #integer ⸨0⸩ #integer ⸨0⸩ #integer]
    :at tagged geo [⸨40.71⸩ #decimal ⸨-74.00⸩ #decimal]
    :size tagged wh [⸨1920⸩ #integer ⸨1080⸩ #integer]
  |decision
    :date tagged date "2026-07-21"
    :span tagged iv [⸨2026-01⸩ ⸨2026-06⸩]
  |cfg
    :tags tagged set [⸨a⸩ ⸨b⸩ ⸨c⸩]
````

**Beautiful:**
- **Named lists.** `rgb[255 0 0]` and `geo[40.71 -74.00]` give lite composite literals (points, colors, pairs, intervals) with no new grammar: a list, with a name in front. The parts are real values (each number classified), not a raw body some reader re-parses.
- **Familiar.** `v"1.10"` is the most familiar way I know to say "this is a version, not a decimal".

**Worries:**
- **The string body keeps escapes,** so the regex doubles its backslashes again; N1 is better for raw bodies.
- **`date[…]` looks like an element head without its pipe** (`|user[jw]`). One character of difference between a named list and an element value. To me that's either a lovely kinship or a trap; I can't tell yet.
- **The best form may be N1 and N2 together:** backticks for verbatim scalars, a named `[…]` for composites. They share one rule: a label touching a delimiter names its reader.

---

## N3: the type trails the value (F# units of measure, typeset)

**From:** F# writes `1.0<cm>`, `9.81<m/s^2>`. A typeset page writes the quantity first and its unit after. Rust's literal suffixes (`0xffu64`) do the same, without a delimiter.

**Became:** a value may end in `<label>`, naming what it is: the value first, its reading after.

```udon
|box :width 920<px> :margin 1.5<em>
|job :timeout 5<min> :length 5<m>
|reg :value 0xff<u64>
|decision :date 2026-07-21<date> :at 10:12<time>
|cfg :tags [1 two 2026-07-21<date>]
```
````tree
root
  |box
    :width ⸨920⸩ <px>
    :margin ⸨1.5⸩ <em>
  |job
    :timeout ⸨5⸩ <min>
    :length ⸨5⸩ <m>
  |reg
    :value ⸨0xff⸩ <u64>
  |decision
    :date ⸨2026-07-21⸩ <date>
    :at ⸨10:12⸩ <time>
  |cfg
    :tags [⸨1⸩ #integer ⸨two⸩ ⸨2026-07-21⸩ <date>]
````

**Beautiful:**
- **The domain's number is what you see first.** `5<min>` and `5<m>` say exactly the minutes-or-meters thing, on the literal, in the order a physicist writes it.
- **It is F1 made visible.** Spike a found the classification arrives at a run's close; here the author writes the classification at the close.

**Worries:**
- **It goes against Joseph's stated grain.** He wants to "decide and start parsing things sooner" (his reason for `<dt:…>` as a prefix). A handler that streams the body needs its name first.
- **`<…>` after a value reads to me as an HTML tag or a placeholder** before it reads as a unit.
- **It collides with ordinary text** like `x<y>z` in a bare run, which needs a rule about when the trailing angle counts.
- **A run of bare text can carry a class from either end.**

I wouldn't pick it, but it found something true: units want to trail, notations want to lead.

---

## N4: the clef (music's key signature, for slots)

**From:** a clef at the start of a staff changes how every note after it reads, and a key signature does the same until changed. An accidental overrides one note. CSS's cascade is the engineering version; the musical one is prettier and more exact about scope.

**Became:** a convention, with no grammar. A trait on an element may name a vocabulary, and a reader types the element's bare values from it. A tagged value (N1) is the accidental.

```udon
|box.css :width 920px :margin 1.5em :opacity 50%
|job.ops :timeout 5m :retries 3
|survey.si :length 5m
|server.inet :port ssh :addr 10.0.0.1
|job.ops :timeout 5m :cron cron`*/5 * * * *`
```
````tree
root
  |box
    :$traits [css]
    :width ⸨920px⸩          ← the css vocabulary reads a length, 920 px
    :margin ⸨1.5em⸩
    :opacity ⸨50%⸩ 
  |job
    :$traits [ops]
    :timeout ⸨5m⸩           ← ops: timeout is a duration, so 5 minutes
    :retries ⸨3⸩ #integer
  |survey
    :$traits [si]
    :length ⸨5m⸩            ← si: m is the meter
  |server
    :$traits [inet]
    :port ⸨ssh⸩             ← inet: port = u16 | standard-port, so 22
    :addr ⸨10.0.0.1⸩
  |job
    :$traits [ops]
    :timeout ⸨5m⸩
    :cron code cron ⟬*/5 * * * *⟭    ← the accidental
````

**Beautiful:**
- **The plumbing appears once, at the head, as a word about the domain.** `|server.inet` says "this server speaks internet", and every value below reads right with no mark. That is A5 (domain-forward) at its strongest, and it uses a construct whose existing meaning, "what kind of thing this element is", already fits.
- **It answers the slots fork's finding.** A real slot type is declared once per element type, not per value. A trait is a once-per-element mark.
- **Lite needs nothing new.** It is a reading convention a dialect can adopt.

**Worries:**
- **Traits are free names, so `.css` might be a vocabulary or just a class name** (`|div.warning`). The reader has to know which traits are clefs, which brings back the registry problem.
- **It is not lite's to decide,** only lite's not to block.

---

## N5: glyph literals (APL, ALGOL 68, typography)

**From:**
- APL's `⍬` (empty) and `¯5` (high minus);
- ALGOL 68's `⏨` (U+23E8 DECIMAL EXPONENT SYMBOL: `6.02⏨23`);
- typography's `∞`, `°` and `№`;
- Unicode's `¤` (U+00A4 CURRENCY SIGN, made for "a currency, unspecified").

Joseph: human typing matters little now, and "a small set of special characters does [enhance beauty], if chosen well."

**Became:** a few glyphs for values that have no good ASCII spelling.

```udon
|server :backup ∅ :limit ∞ :avogadro 6.02⏨23
|item :price $9.99 :alt €8.50 :generic ¤9.99
```
````tree
root
  |server
    :backup ⸨∅⸩ #nil            ← if ∅ joins the standard set
    :limit ⸨∞⸩ #infinity        ← if ∞ joins it
    :avogadro ⸨6.02⏨23⸩         ← text; a reader may read it
  |item
    :price ⸨$9.99⸩              ← text; a money reader sees a currency sign (Unicode category Sc) leading a number
    :alt ⸨€8.50⸩
    :generic ⸨¤9.99⸩
````

**Beautiful:**
- **`∅` says nothing better than `nil`, `null`, `<>` or `~`.** One glyph, no English word to translate, no collision with the word "nil" in a sentence. Under Cc the bare word `nil` is the text "nil" with a classification. `∅` would be a spelling no one writes by accident, so it could even be classified without a word-collision risk.
- **Currency signs are notation tags already.** `$9.99` and `€8.50` need no name; the glyph is the name. REBOL saw this (`$10`). Unicode gives the class (Sc) for free, so a money reader's recognition rule is one property lookup.

**Worries:**
- **Generative guessability.** Would an agent write `∅` unprompted? No. After one example, I think yes, readily.
- **`∞` raises NaN and the other IEEE edges,** which the host guide would need to cover.
- **`⏨` is charming and no one will use it.**

Taste: I'd offer `∅` as nil's spelling beside `nil` and leave the rest to readers.

---

## N6: the allomorph (Raku), a word and a colonpair

**From:** Raku's quote-words `<…>` produce **allomorphs**: `<42>` is an `IntStr`, a value that is the string "42" *and* the integer 42 at once. Raku's colonpair `:port<8080>` is the pair port ⇒ IntStr(8080). Raku already built spike a's lead design (Cc: text plus a classification), and gave it a name.

**Became:**
- **A word for the spec.** An «allomorph» is a text whose whole spelling is also a member of the standard set. "`:port 8080` holds an allomorph: the text `8080`, which is also the integer 8080." That says identity-by-spelling and the classification in one noun. In linguistics an allomorph is one of a morpheme's forms; the borrowing holds.
- **A spelling, offered and then set aside:** `:tags<a b c>`, Raku's word list hugging the name. It collides with the slots fork's reserved `:port<u16>`, and lite has `[a b c]`. I mention it only because, read cold, `:port<8080>` looks finished and good.

**Beautiful:** a single noun replaces "a text with a normative classification attached", and the noun is honest about what the thing is.

**Worry:** it is a technical word few readers know. "IntStr" is uglier but self-explaining.
