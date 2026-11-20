# Inventions: notation values, invented first and judged after

*Spike b, third round, 2026-10-22, after Joseph's note: "not a single mention of "what if we used elixir-like sigils, but made more beautiful?" … just trying to figure out what's already been thought about and safely make some safe-sounding conclusions." Page 50 was the cold half; this is the warm one. §1 invents and renders with no scores. §2 says what I find beautiful. §3 judges, Beauty first. §4 is the system the inventions add up to.*

*Shared content for every rendering: a date; a zoned datetime; a duration; masses in kg; a width in px; a regex; a rational with a complex numerator; a user notation (a SKU); a list of dates; a table of samples.*

## 1. Inventions

### I1. Sigils made beautiful: the label wears the reading (`:mass.kg 3.2`)

An Elixir sigil (`~D[2019-10-31]`) is beautiful for three reasons: you know at the first character that a typed literal starts; the payload sits in a delimiter you chose, so it never needs escaping; and modifiers ride after it (`~r/x/i`). What's not beautiful: the tilde means "approximately" in prose, the one-letter name is cryptic, and the value carries plumbing that belongs to the field.

So move the sigil off the value and onto the **label**. Lite already has a mark meaning "what kind of thing this is", the trait `.`: `|user.admin` is a user of kind admin. Let the same mark mean the same thing on an attribute name. `:mass.kg 3.2` is a mass, of kind kilograms. The value stays bare, pure domain data. The kind is known **before** the value's first character, which is Joseph's "decide sooner and piecewise" in its strongest form.

```udon
|event :on.date 2026-10-01 :start.datetime 2026-10-01T14:30-06:00[America/Denver] :lasts.duration 3mo 5d
|part :mass.kg 3.2 :width.px 920 :price.decimal 83.23 :sku.acme/sku AB-12-rev3
|rule :pattern.re `\d+(\.\d+)?` :path `C:\Users\me`
|cal :holidays.date [2026-11-26 2026-12-25]
|cfg :port.u16 8080 :timeout.ms 500
```
````tree
root
  |event
    :on (.date) ‹2026-10-01›                         ⇒ Date 2026-10-01
    :start (.datetime) ‹2026-10-01T14:30-06:00[America/Denver]›
                                                      ⇒ ZonedDateTime
    :lasts (.duration) ‹3mo 5d›                       ⇒ Duration 3 months 5 days
  |part
    :mass (.kg) ‹3.2›                                 ⇒ Quantity 3.2 kg
    :width (.px) ‹920›                                ⇒ Quantity 920 px
    :price (.decimal) ‹83.23›                         ⇒ Decimal 83.23, exact
    :sku (.acme/sku) ‹AB-12-rev3›                     ⇒ unresolved acme/sku; the tree is complete
  |rule
    :pattern (.re) raw "\d+(\.\d+)?"                  ⇒ Regex
    :path raw "C:\Users\me"
  |cal
    :holidays (.date) [‹2026-11-26› ‹2026-12-25›]     ⇒ [Date, Date]   (the trait reads each item)
  |cfg
    :port (.u16) ‹8080›                               ⇒ 8080, range-checked 0–65535
    :timeout (.ms) ‹500›                              ⇒ Quantity 500 ms
````

*(Tree notation: `(.kg)` is the occurrence's trait. It belongs to this occurrence of `mass`, not to the attribute's name, so `:mass.kg 3` and `:mass.lb 7` stack as two masses.)*

Where it came from. Every agent, me included, already names fields `timeout_ms`, `size_px`, `created_at_utc`: the unit and kind live in the field name, because that's where a reader looks. I1 makes that habit **mean** something instead of being a naming convention nobody checks. [instinct, strong]

Facts it rests on:
- [checked] The coordinator's label lean makes `.` inside an attribute name an **error** now, "until there's a reason", so this spelling is already held open for exactly this kind of use (`.int/labels-ascii-and-positions-2026-10-20.md` line 26).
- [inferred] The trait must be attached: `:a .5` stays the value `.5`, never a trait. Spaced traits ([[rule:traits-may-follow-spaces]], provisional) apply to elements only.

### I2. The backtick means verbatim, in a block and inline (`` `C:\Users\me` ``)

Sigils let the writer choose a delimiter so the payload never needs escaping. Lite already has the verbatim mark: a fence is three or more backticks, and its body is never scanned. Markdown's inline code span is one or more backticks, with the same no-escape rule: a longer backtick run lets backticks appear inside. Every agent knows both.

So a value **standing alone** (page 30's δ3) in backticks is a **raw string**: no escapes, nothing recognized inside. The opaque-span card's recorded cost, regexes and Windows paths doubling their backslashes (`<re:\\d+>`), disappears. And because it only counts standing alone, Markdown's inline code in text is untouched:

```udon
|li Use `grep -r` to search
|li `npm install` first
|cmd :run `rm -rf ./build` :match ``a`b``
```
````tree
root
  |li
    :$main ‹Use `grep -r` to search›             (a run: Markdown code span kept as written)
  |li
    :$main ‹`npm install` first›                 (not alone: a run)
  |cmd
    :run raw "rm -rf ./build"
    :match raw "a`b"                             (the double-backtick run lets one backtick inside)
````

One rule for the backtick: **verbatim, sized by its run.** [checked] Three or more backticks already open a fence wherever structure can start, an attribute's line included ([[rule:fence-anywhere-structure]]: `:script ```sh` with the body below is the attribute's block raw value). So the inline form takes the runs a fence can't: **one or two backticks, standing alone, is an inline raw value.** Three or more is the block form that already exists. The invention completes a pattern lite half-has.

### I3. A key signature: say it once at the top of the staff

In music, a key signature at the start of a staff changes how every following note reads until it's changed. A scientific table states its units once, in the header. Lite's vocabularies (page 20) are that idea at file scale. Here it is at the scale of one element, spelled with I1's trait:

```udon
|samples :$sig [mass.kg temp.degC taken.datetime]
  |sample :mass 3.2 :temp 21.5 :taken 2026-10-01T14:30Z
  |sample :mass 2.9 :temp 22.0 :taken 2026-10-01T15:10Z
  |sample :mass 3.0 :temp 21.8 :taken 2026-10-01T15:55Z :mass.lb 6.6
```
````tree
root
  |samples
    :$sig [‹mass.kg› ‹temp.degC› ‹taken.datetime›]
    |sample
      :mass ‹3.2›     ⇒ 3.2 kg      (read under the signature)
      :temp ‹21.5›    ⇒ 21.5 °C
      :taken ‹2026-10-01T14:30Z›  ⇒ DateTime UTC
    …
    |sample
      …
      :mass (.lb) ‹6.6›   ⇒ 6.6 lb  (an occurrence's own trait overrides the signature, like an accidental)
````

The data rows are pure numbers. The signature is plain data (a list of texts in a designated attribute), so the tree is the same with or without a reader. An occurrence's own trait overrides it, like an accidental (a sharp or flat written on one note) overriding the key. Scope: everything below the element, until another `$sig` changes it.

### I4. A hinged literal, for slots with no fixed kind: `<date: 2026-10-01>`

Generic and heterogeneous slots (a metadata bag, a mixed list) need the kind on the value. Page 50's NA wrote `<date 2026-10-01>`, which reads cold like an HTML open tag. Add a **hinge**: a colon and a space after the name, so it reads like a label and its value (Joseph's own `<dt: …>`, `<rust:i64: 0x73DDF>`). I tried a bar too (Joseph's `<uint32|0x992BC>`, and Dirac's bra-ket, ⟨a|b⟩; Unicode itself gives U+27E8 the informal alias "bra" [checked]):

```udon
|meta :values [<date: 2026-10-01> <qty: 3.2 kg> <duration: P1W> 42 hello]
|math :z <rational: <complex: 3 -7> 2>
|link :to <ref: people/jw>
|alt  :z <rational|<complex|3 -7> 2>         ; the bra-ket hinge, for comparison
```
````tree
root
  |meta
    :values [literal date [‹2026-10-01›] literal qty [‹3.2› ‹kg›] literal duration [‹P1W›] ‹42› ‹hello›]
                                              ⇒ [Date, Quantity, Duration, 42, ‹hello›]
  |math
    :z literal rational [literal complex [‹3› ‹-7›] ‹2›]
  |link
    :to literal ref [‹people/jw›]
````

The colon hinge reads like a little dictionary entry, `date: 2026-10-01`. The bar is lovelier on paper (it's a hinge in mathematics too), but it gives `|` a second meaning in a notation where `|` already means "element". [taste] **Colon hinge kept; the bar recorded.**

### I5. The tie: a quantity bound with ‿ (`3.2‿kg`)

In music a tie binds two notes into one duration. U+203F UNDERTIE is connector punctuation (category Pc, like `_`) [checked]. `3.2‿kg` is one value of kind quantity, recognized by its spelling: the writer asserted it by typing the tie. This is for the case I1 can't reach: units that vary item by item in a list.

```udon
|layout :gaps [12‿px 1.5‿em 50‿%] :accel 9.81‿m/s2
```
````tree
root
  |layout
    :gaps [qty ‹12‿px› qty ‹1.5‿em› qty ‹50‿%›]
    :accel qty ‹9.81‿m/s2›
````

Strange and unfinished. Nobody will write it cold; with one example, I think an agent would copy it. The joy of it is that the visual metaphor *is* the semantics. [taste]

### I6. Pictographic sigils (`📅2026-10-01`, `⏳3mo`, `⚖3.2kg`)

Instant cold comprehension: an agent seeing `📅2026-10-01` knows it's a date without being taught. **Killed, with reasons** [checked, UCD 18]:
- `⚖` is not `Emoji_Presentation`, so `⚖` and `⚖️` (with variation selector 16) would be two spellings of one sigil (B3).
- `📅` is East Asian Wide while `⚖` is Neutral, which breaks column alignment (A4).
- The register is a toy's.

**The instinct worth keeping:** cold comprehension through a word the reader already knows. That is why the registry's names should be plain words (`date`, `kg`), not codes.

### I7. Superscript kind marks (`ᵈᵃᵗᵉ2026-10-01`), like a footnote or a dynamics marking above the staff

**Killed** [checked]: `ᵈ` (U+1D48) has a `super` compatibility decomposition, so any NFKC-normalizing pipeline turns `ᵈᵃᵗᵉ2026-10-01` into `date2026-10-01`, silently changing the meaning. The general lesson: compatibility characters can't carry syntax.

## 2. What I find beautiful, and why

- **I1** most of all. The value is just the domain's number or word, and the reading sits where a reader's eye goes first, on the field. It turns a habit everyone already has (`timeout_ms`) into meaning. It uses lite's own word for "kind of", the trait, in the same sense everywhere: `|user.admin`, `:mass.kg`. And aligned rows read like a table:

  ```udon
  |part :mass.kg   3.2   :width.px  920
  |part :mass.kg  12.75  :width.px 1440
  ```

- **I3**: the key signature. Data rows with no plumbing at all, and an "accidental" that overrides one value. It is the same object as page 20's vocabulary, but you can see it in the document.
- **I2**: one meaning for the backtick across the whole language. Payloads with backslashes stop costing anything.
- **I4**: the colon hinge, a value that names its own reading when its slot can't.
- **I5**: the tie. A small, delightful, possibly useless thing.

## 3. Judged after: CTQ, Beauty first [hyp, computed by script]

LW is the system that I1–I4 add up to (labels wear the reading). NA and NB are page 50's. BK is I4 with the bar.

| Factor (weight) | **LW** | NA | NB | BK |
|---|---|---|---|---|
| A1 beauty (9) | **9** | 8 | 7 | 8 |
| A2 guessability (10) | **8** | 6 | 6 | 7 |
| A3 cold comprehension (10) | **8** | 6 | 8 | 7 |
| A4 readability (10) | **9** | 8 | 7 | 8 |
| A5 domain-forward (9) | **10** | 7 | 7 | 7 |
| A6 spec clarity (9) | 7 | 7 | 8 | 7 |
| A7 simplicity (8) | 6 | 6 | 8 | 6 |
| A8 parsimony (8) | 8 | 7 | 9 | 6 |
| A9 conciseness (6) | 9 | 7 | 6 | 7 |
| A10 self-description (5) | 8 | 8 | 8 | 8 |
| B3 stability (10) | 8 | 8 | 8 | 8 |
| B4 errors that teach (8) | 8 | 8 | 5 | 8 |
| B6 headroom (7) | 7 | 7 | 8 | 7 |
| C2 XML/HTML (10) | 8 | 7 | 9 | 7 |
| C3 Markdown (9) | 7 | 8 | 8 | 8 |
| C4 types, notations, units (8) | 10 | 9 | 8 | 9 |
| C6 extensibility (8) | 8 | 8 | 8 | 8 |
| C7 tree and API (8) | 8 | 8 | 6 | 8 |
| **weighted (max 1520)** | **1234** | 1119 | 1134 | 1131 |

**Basis for the scores that carry the result:**
- **A1, A2, A3, A5 for LW:** values stay bare and the unit sits in the field name, as the `timeout_ms` habit has it. I'd guess `:timeout.ms 500` after one example, and read it cold.
- **A6, A7 cost:** LW is four parts (attribute traits, the backtick raw value, the signature, the hinged literal). Each one is small.
- **C3 cost:** a whole `$main` that is one inline code span (`|li `npm install``) becomes a raw string, its form kept so a Markdown renderer can restore it.
- **B1:** a trait is known before its value; backticks and the hinge commit at their first character. Bounded throughout.
- **B2:** unknown unprefixed traits and names are errors; namespaced ones are carried.

**This time the total does separate the designs**: LW leads by 100 over the next (NB). The lead comes from the Beauty group (A1–A5), as Joseph's ordering puts first, and it holds even if every LW score in A6–A8 drops by two (1184, still ahead). Totals computed by script; NA's row matches page 50. Confidence moderate. The scores are mine, and the key A2 claim (agents will guess the trait) rests on the `timeout_ms` instinct.

## 4. The system (LW), as a proposal for lite 0.1

1. **Attribute traits name the reading:** `:name.kind value`. The reading applies to a bare or backtick value and to each item of a list. A delimited typed literal is checked against it. Unknown unprefixed kinds are errors with "did you mean"; namespaced kinds (`.acme/sku`) are carried. The kind belongs to the occurrence, and stacking keeps each occurrence's own kind.
2. **The registry** holds kinds (`text`, which switches the default reading off, as in `:version.text 1.0`; `date`, `time`, `datetime`, `duration`, `decimal`, `ref`, `u8`…`u64`/`i8`…`i64` as ranges, `re`) and unit codes. I'd take units from UCUM [recalled], with `px`, `em` and `%` added. Its admission test is page 50's.
3. **`$sig`**, a key signature: a designated attribute whose list of `name.kind` entries sets the reading for descendants until changed.
4. **Backtick raw values**, standing alone, sized by their run.
5. **The hinged literal `<kind: items…>`**, for slots with no fixed kind and for nesting; `<>` is nil, and `<0xFF>` is unchanged from page 10.
6. **The tie** is not in 0.1. It is kept for Joseph's taste.

How the layers stack, highest first: an occurrence's trait (an accidental), then the signature, then the vocabulary, then the default reading. Every layer reads the same raw tree.

**Limits found by pushing it** [inferred]:
- **Element traits stay as they are.** `|article.featured` uses a free word; making a registered kind on an *element* read its `$main` would let a user's own trait named `date` type their text by accident. So the reading rule is for attribute traits only. An element's `$main` takes a kind as `:$main.date …`, or through a hinged literal.
- **Unit names should be the ones writers write.** UCUM, the real standard, spells Celsius `Cel` and the inch `[in_i]` [recalled]. Lite's registry would use the familiar symbols (`kg`, `m`, `s`, `ms`, `px`, `em`, `degC`, `KiB`, `pct`), with `%` not available, because it can't be in a bare label under the label lean.
- **The registry is now load-bearing for errors:** every unprefixed attribute trait must be in it. That is a spec appendix that grows by version. Adding a name later is safe, since it was an error before.
- **The guessability claim rests on one instinct** (the `timeout_ms` habit). It is the claim most worth a small probe if one is ever affordable: give a fresh agent two examples and ask it to write a temperature, a date and a size.

**What changes from earlier pages:**
- Page 20 killed per-occurrence annotation (σ2) as a *slot* mechanism, which still stands. But I wrote off its spelling too fast. With `.` instead of `:`, the `xml:lang` collision is gone, and for units and kinds that differ from one occurrence to the next, the label *is* domain information, not plumbing. σ2 comes back as I1.
- Page 50's NA becomes I4, the hinged form, used only where a trait can't reach.
