# Wild pass: notation values from places the spike hadn't looked

*Spike c, round two, the "wild" fork (Opus 5.5, 2026-10-22). Invent first, judge after. Each idea is taken from somewhere and then changed into something fitted to lite, a notation agents read and write without highlighting. It is rendered on the five lines from `../inventions.md`, I say what is beautiful in it, and only then do I weigh it against CTQ-FACTORS with Beauty first. Three are developed further and rendered on N1–N18. Labels: **checked** (here, the Unicode code points, via the UCD 18 tool), **guess**, **taste**. Where a design leaves a part to an existing one, it says so; the default base is `combo` (γ+α+ε from `../inventions.md`): `<…>` read by shape, `scheme:body`, and a bodiless `<name>` as a clef.*

The five lines again, as intents:
1. an event on 2026-10-01, at 2026-01-10T14:30Z held in America/Denver, lasting 90 minutes;
2. a box 920px wide, 5 m tall, 50% full, at 37.5 °C, costing 9.99 USD;
3. a season spanning 2026-01 to 2026-06, with holidays 2026-01-01, 2026-07-04 and 2026-12-25;
4. a pattern `\d+-\w+` and a home page https://example.com;
5. prose, "Meet on Oct 1st", machine-readable as 2026-10-01.

---

## W1. Allomorphs (from Raku's `IntStr`)

**Where it comes from.** In Raku, `<42>` is an *allomorph*: a value that is both the string "42" and the integer 42, and whoever uses it picks a face. Raku invented this for exactly our problem: command-line arguments and word lists that might be numbers.

**Changed for lite.** A bare run that spells a standard primitive is an **allomorph** in the tree. Its **kind is text**, known at its first character as the lean says, and the parser adds a second face, `int`, `float`, `bool` or `nil`, at the run's close, the way a framed comment attaches at the end of a line without changing anything's arity. Nothing gets re-kinded.

```udon
|box :width 920px :height 5 :fill 0.5 :count 3 :version 1.10 :on true
```
````tree
  |box  :width ‹920px›   :height ‹5›~int   :fill ‹0.5›~float   :count ‹3›~int   :version ‹1.10›~float   :on ‹true›~bool
````
(`~face` is my transcript mark for the second face, not a proposal for a spelling.) On the five lines W1 changes nothing except bare primitives, so the units and dates there are whatever the base design does.

**Beautiful, to me:** it tells the truth. Is `1.10` a version or a float? Both, until a reader decides. B made the tree pick, C made the reader pick, and the dial argued about defaults. The allomorph says: **don't pick in the tree; record both faces; the slot (or the converter) picks.**

**What it does to B1 (a finding, reasoned):** the kind is text from the first character, so even the strict wording of B1 ("before its kind is known") holds. The primitive face is an attachment announced at the close, and holding it costs a few states. That dissolves the B fork's "one-word difference in B1" without rewording B1. A kind-first JSON writer that wants the numeric face still has to hold the undecided prefix. But that is now visibly *the converter's choice of face*, not lite's.

## W2. Elision (from LilyPond's relative mode and the typographer's "1914–18")

**Where it comes from.** In LilyPond's `\relative`, each note is written relative to the one before, so you write only what changed. Typographers write ranges the same way: "1914–18", "pp. 112–19", "9:00–11:30", "Jan 1, Jul 4, Dec 25 2026". People never write the repeated year.

**Changed for lite.** Inside a run of values that share a reading (a clef'd list, a clef'd attribute body, or the two ends of a range), **a value may leave out the leading components it shares with the value before it**. The raw tree keeps the spelling exactly; the reading fills in the rest. **The fill is never a guess:** an end that comes out before its start is an error that suggests the fix.

```udon
|event :on <2026-10-01> :at <2026-01-10T14:30Z[America/Denver]> :lasts <14:30 – 16:00>
|box :width <css:920px> :height <5 m> :fill <50 %> :temp <37.5 °C> :price <9.99 USD>
|season :span <2026-01 – 06> :holidays [<date> 2026-01-01 07-04 12-25]
|ok :pattern <re:\d+-\w+> :home <https://example.com>
|p Meet on [Oct 1st](date:2026-10-01).
```
````tree
  |event   :lasts (range "14:30" "16:00")            → read: 90 min, held as 14:30–16:00
  |season  :span (range "2026-01" "06")              → read: 2026-01 … 2026-06
           :holidays [clef(date) ‹2026-01-01› ‹07-04› ‹12-25›]   → read: 2026-01-01, 2026-07-04, 2026-12-25
````

**Beautiful, to me:** it writes the way a careful person writes, saying each thing once. A list of dates reads like a calendar margin, not a log file. The en dash with spaces (`2026-01 – 06`) is the typographer's range, and the elided end is how ranges have been printed for centuries. *Domain-forward* at its purest: the redundancy that only the machine needed is gone.

## W3. Typeset relations and sigils (from scientific typography, legal citation and the mathematician's subscript base)

**Where it comes from.** Printed specifications already have a small, unambiguous typography of composite values: `1920 × 1080` (dimensions), `37.5 ± 0.2 °C` (a measurement with uncertainty), `≥ 18` (a bound), `6.022 × 10²³ mol⁻¹` (scientific notation), `FF₁₆` (a base written the mathematician's way), `§ 4.2` and `¶ 3` (legal pinpoints), `№ 42`. Each symbol already says what kind of thing follows or precedes it, and none of them occurs inside an ordinary word.

**Changed for lite.** γ's "the shape names the kind" grows from single values to the **small expressions typography already has**. Inside `<…>`:

| Shape | Example | Reads as | Code points (checked) |
|---|---|---|---|
| number ` × ` number … unit | `<1920 × 1080 px>` | dimensions (a vector quantity) | × U+00D7 |
| number ` ± ` number unit | `<37.5 ± 0.2 °C>` | a measurement with uncertainty | ± U+00B1 |
| `≥` / `≤` / `≈` quantity | `<≥ 18 a>`, `<≈ 5 min>` | a bound, an approximation | U+2265, U+2264, U+2248 |
| number ` × 10` superscript | `<6.022 × 10²³ mol⁻¹>` | a number in scientific form | ² U+00B2, ⁻ U+207B, ¹ U+00B9 |
| digits + subscript base | `<FF₁₆>`, `<1010₂>` | an integer in that base | ₁ U+2081, ₆ U+2086 |
| `§` / `¶` / `№` + a locator | `<§ 4.2>`, `<№ 42>` | a pinpoint / an ordinal number | U+00A7, U+00B6, U+2116 |
| quantity ` – ` quantity | `<5 – 10 min>` | a range (with W2's elision) | – U+2013 |

ASCII `<` and `>` never appear as relations inside the mark, because they'd end it. `≤` and `≥` take their place, and `<5` as text stays text.

```udon
|event :on <2026-10-01> :at <2026-01-10T14:30Z[America/Denver]> :lasts <90 min>
|box :size <920 × 500 px> :height <5 m> :fill <50 %> :temp <37.5 ± 0.2 °C> :price <9.99 USD>
|season :span <2026-01 – 06> :holidays [<date> 2026-01-01 07-04 12-25]
|ok :pattern <re:\d+-\w+> :home <https://example.com> :see <§ 4.2>
|p Meet on [Oct 1st](date:2026-10-01).
```

**Beautiful, to me:** these are the forms engineering drawings, lab reports and statutes have converged on over a long time. An agent reading `<37.5 ± 0.2 °C>` cold knows exactly what it is (A3), and a schema can write `:range <0 – 65535>` or `:age <≥ 18 a>` in the same typography. **The same small typography serves values *and* constraints**, so a vocabulary's slot types read like the values they constrain.

**Unfinished:** superscripts ¹²³ live in Latin-1 and the rest in U+2070–209F (checked: ² and ¹ are in Latin-1 Supplement, ⁻ in Superscripts and Subscripts). A writer has to get the code points right. The near-miss `10^23` should be an error suggesting `10²³`.

## W4. Padded delimiters (from Swift's raw strings `#"…"#`)

**Changed for lite.** A notation body may contain anything on its line, unbalanced brackets included, if the mark is padded with `#`s that the body doesn't contain: `<#re:a>b\d+#>`, `<##…##>`. Today the round-two designs send such bodies to a fence. **Beautiful, to me:** small and exact. It removes the one case where a one-line value had to become three lines. **Taste:** I'd adopt it into whichever base wins. It doesn't compete with anything.

## W5. Prime tags (from Nim's `123'u16`)

`8080'u16`, `90'min`, `2026-10-01'date`, all bare. **It dies on its own example:** `the 90's` becomes 90 of unit `s`. The apostrophe is far too common in prose to be a mark. The idea it carries (a separator that makes a suffix unambiguous) is better served by the mark itself.

## W6. Superscript labels (from footnote markers)

`2026-10-01ᵈᵃᵗᵉ`, `90ᵐⁱⁿ`. A small raised label that reads like a footnote. **It dies:** Unicode has no superscript `q` (and others), tokenizers shred superscript letters, and it reads as decoration. A1 low, A4 low. Kept here only because it was the most typographic of the bad ideas.

## W7. Content-addressed notation names (from Unison)

**Changed for lite.** A vocabulary's lockfile pins each short name to the hash of its definition, so `date` in a document means *that exact reader* forever, and a vocabulary can rename or evolve without changing what old documents mean. The document stays clean: hashes never appear in it. **Beautiful, to me:** the meaning of a document becomes stable over time in the same way its tree already is (B3), with nothing for a writer to see. It doesn't compete with spelling designs; it's a reader-layer property any of them can have.

## W8. Plain-language dates (strange, kept)

`<date: the first Tuesday of October 2026>`, `<duration: an hour and a half>`. A notation that reads a *closed, deterministic* subset of English (absolute descriptions only, never "next Tuesday"). **Beautiful in prose, to me,** and frightening everywhere else. I couldn't make it deterministic enough without making it a grammar nobody would guess. It dies on B3 and A2 as anything but a named, opt-in notation.

## Dead on arrival, one line each

- **TeX/siunitx `\SI{5}{m}`:** backslash is lite's escape, and the form is noise in plain text.
- **APL strands** (a list as juxtaposed values, no brackets): absorbed into W2's clef'd lists, where it works; alone it collides with bare runs.
- **SMILES ring-closure digits** (as a way to cross-link values on one line): I couldn't find a value it improved.

---

## Weighing, Beauty first

*One agent's judgment; A1 is my own sense of beauty, with the reason in the last column.*

| | A1 beauty (9) | A2 guess (10) | A3 cold (10) | A5 domain (9) | A7 simplicity (8) | B3 stability (10) | C1/C4 data, notations (10/8) | B1 / B2 | Why |
|---|---|---|---|---|---|---|---|---|---|
| **W1 allomorph** | 8 | 8 | 8 | 7 | 8 | 9 | 9 / — | pass, **even under B1's strict wording** / pass | tells the truth about `1.10` |
| **W2 elision** | 9 | 7 | 8 | 10 | 6 | 8 | — / 8 | pass / pass (a reading; raw tree untouched) | write it once, like a person |
| **W3 typeset relations** | 9 | 7 | 9 | 9 | 5 | 8 | — / 9 | pass / pass (closed set, grows into errors) | the typography of engineering drawings |
| W4 padded delimiters | 7 | 6 | 8 | 6 | 8 | 10 | — / 7 | pass / pass | exact and small |
| W5 prime tags | 3 | 6 | 4 | 6 | 7 | 4 | — | pass / pass | `the 90's` |
| W6 superscript labels | 4 | 3 | 5 | 6 | 6 | 6 | — | pass / pass | decoration |
| W7 content-addressed names | 7 | — | — | 8 | 9 | 10 | — / 8 | — | meaning stays put over time |
| W8 plain-language dates | 6 | 7 | 9 | 9 | 2 | 3 | — / 6 | pass / pass | lovely and unsafe |

**Kept to develop:** W1, W2 and W3 (below). W4 and W7 are small adoptions any base can take.

---

## Developed: W1 + W2 + W3 on N1–N18

*One design, layered on `combo` (γ+α+ε): `<…>` read by shape, `scheme:body` for named notations, a bodiless `<name>` as a clef. W1 governs bare runs; W2 and W3 extend what the mark's shapes are and how clef'd sequences read. Raw-tree nodes are written `(kind "spelling" …)`; `→` gives the logical reading.*

| # | Spelling | Raw tree → reading | Verdict |
|---|---|---|---|
| N1 | `:on <2026-10-01>` | `(date "2026-10-01")` → 2026-10-01 | renders |
| N2 | `:at <2026-01-10T14:30Z>` · `:at <2026-01-10T07:30-07:00[America/Denver]>` | `(instant …)` · `(zoned …)` | renders; RFC 9557 suffix |
| N3 | `:open <09:00>` · `:when <tz:2026 PDT>` | `(time "09:00")` · `(tz "2026 PDT")` | renders; the abbreviation only through a named notation, since PDT is ambiguous |
| N4 | `:born <date(YY-MM-DD):27-03-05>` | `(date params "YY-MM-DD" "27-03-05")` → 2027-03-05 | renders (parameters as in raw/std) |
| N5 | `:t <30 s>` · `:span <P1Y2M>` · `:wait <5 min>` | quantities and ISO durations | renders; `<5m>` → error "did you mean `<5 min>` (minutes) or `<5 m>` (metres)?" |
| N6 | `:span <2026-01 – 06>` | `(range "2026-01" "06")` → 2026-01 … 2026-06 | renders, elided (W2) |
| N7 | `:w <920 px>` · `:h <5 m>` · `:size <1.5 GiBy>` · `:fill <50 %>` · `:t <37.5 °C>` · `:d <920 × 500 px>` | quantities, dimensions | renders (W3); `<1.5 GB>` → error pointing to `GiBy`/`GBy` |
| N8 | `:price <9.99 USD>` · `:price <$9.99>` | `(money …)` | renders; `$` alone is USD only under a vocabulary that says so, otherwise an error asking for the code |
| N9 | `:addr <rust:i64:0x73DDF>` · `:addr <73DDF₁₆>` | named · `(int "73DDF₁₆")` | renders; the storage type stays a named notation (A5 low, by design) |
| N10 | `:port ssh` · `:port 22` | `‹ssh›` · `‹22›~int` → the slot's union picks the face | renders, zero plumbing; the allomorph hands the `u16` arm a ready integer face |
| N11 | `<re:\d+-\w+>` · `<https://example.com>` · `<uuid:…>` · `<b64:…>` · `<#re:a>b#>` | named; the URL by scheme | renders (W4 for unbalanced bodies) |
| N12 | a fence named `sql` | the block form of a notation | renders (as raw) |
| N13 | `:holidays [<date> 2026-01-01 07-04 12-25]`, and as a body: `:holidays <date>` then lines `2026-01-01`, `07-04`, `12-25` | clef + elided items → three dates | renders (W2); the strongest row |
| N14 | `<acme.sku:AB-12>` | `(acme.sku "AB-12")` → unread | renders; nothing lost |
| N15 | a `date` slot holding `<2026-01-10T14:30Z>` | read as an instant, then the slot check fails: "did you mean `<2026-01-10>`?" | renders as a teaching error |
| N16 | `Meet on [Oct 1st](date:2026-10-01).` · `|li <https://example.com>` | prose text a Markdown reader reads as a dated link · a URL value | renders |
| N17 | `@<people/jw>` (kept) · `|{…}` as the embedded value | — | as in combo/raw; W1–W3 add nothing |
| N18 | `<2026-10-01>` and `<20261001>` | `(date "2026-10-01")` · `20261001` is an integer, so `<date:20261001>` (basic format) is needed | renders; canonical re-emission writes `2026-10-01`, and as-written keeps `20261001` |

**What the three together cost (the honest part):**
- **A grammar inside the mark that is now the largest thing in lite** (A6, A7). W3 adds about seven shapes to γ's set, each a few productions. My guess is that the whole mark interior is about as large as all of lite's line layer. That is where the weight goes.
- **W2's elision is a reading, so a reader without the clef sees `‹07-04›` as text.** That is honest (nothing is lost), but a schema-less reader gets less. Elision outside a clef'd sequence or range is an error.
- **W1 needs the converter's face policy all the same.** It moves the dial from "what is the tree" to "which face does a generic converter pick", which is where it belonged, but it doesn't decide it.

**Where I'd put them for lite 0.1 (taste, with reasons):**
- **W1 as the meaning of bare primitives.** It costs nothing in grammar beyond the primitive classifier every design already has, it keeps the lean's "bare is text", and it satisfies B1 as worded.
- **W2 and W3 as the standard readings shipped with 0.1**, each a closed set that grows only into errors.
- **W4 and W7 adopted outright.**
