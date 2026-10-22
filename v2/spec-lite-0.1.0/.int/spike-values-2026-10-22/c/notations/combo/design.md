# Combo: the value bracket that reads like a printed page

*Spike c, round two, the `combo` fork (Opus 5.5, 2026-10-22). It develops the combined design from `../inventions.md`: γ (typeset interiors: the value's shape names its kind), α (`scheme:body`, so URIs and autolinks are values), ε (a bodiless `<name>` is a clef), and ζ (Markdown links carry typed values in prose). Invent first, judge after: §1–§7 are the design, made as beautiful as I could make it; §9 weighs it, Beauty first. It borrows from the five careful designs next door (`../std`, `../raw`, `../slot`, `../elem`, `../args`) and says where. Labels: **checked**, **instinct** (what I'd write or expect, as a target writer and reader), **guess**, **taste**.*

## The whole design in five lines

```udon
|event :on <2026-10-01> :at <2026-01-10T14:30Z[America/Denver]> :lasts <90 min> :fee <9.99 USD>
|box :width <css:920px> :height <5 m> :fill <50%> :temp <37.5 °C>
|season :span <2026-01 – 2026-06> :holidays <date> [2026-01-01 2026-07-04 2026-12-25]
|ok :pattern <re:\d+-\w+> :home <https://example.com> :owner @<people/jw>
|p Meet on [Oct 1st](date:2026-10-01) at the usual place.
```

One sentence holds it: **`<…>` is a value, written the way the domain prints it; if the domain has no printed shape for it, you give it a name (`name:`); and a name alone, `<date>`, is a clef that tells you how to read what follows.**

## 1. Inside the bracket: the shape names the kind (γ)

**What I find beautiful:** a document of values reads like a spec sheet, a timetable or an invoice. Every spelling below is one a typesetter, a standards body or an engineer already prints. Nothing is lite's invention except the brackets around them.

| Shape | Kind | Spelling | Borrowed from |
|---|---|---|---|
| empty | nil | `<>` (and `<nil>`) | Joseph's lean |
| `true`, `false` | boolean | `<true>` | core fork |
| a number | number | the strict standard notation (`../../branches/core/spelling.md`) | core fork |
| quotes | string | `<"…">` | delimited-string rules |
| `YYYY-MM-DD`, `YYYY-MM`, `YYYY-Www`? | date | `<2026-10-01>`, `<2026-10>` | RFC 3339 / ISO 8601 |
| `HH:MM[:SS[.f]]` | time | `<09:00>` | RFC 3339 `partial-time` |
| date `T` time [`Z` / offset] [`[Zone]`] | date-time: local, instant, zoned | `<2026-01-10T14:30Z>`, `<2026-01-10T07:30-07:00[America/Denver]>` | RFC 3339, RFC 9557 (checked) |
| `P…` | duration | `<PT30S>`, `<P1Y2M>` | ISO 8601 |
| number, space, unit | quantity | `<5 m>`, `<90 min>`, `<1.5 GiB>`, `<37.5 °C>` | SI brochure spacing; units as printed (§5) |
| number glued to a **symbol** unit | quantity | `<50%>`, `<45°>`, `<37.5°C>`, `<3′ 4″>` | typography; see the symbol rule below |
| amount and currency | money | `<9.99 USD>`, `<€12>`, `<£5.50>` | ISO 4217 code; unambiguous currency symbols |
| x **en dash** y | range | `<2026-01 – 2026-06>`, `<18 – 25 °C>`, `<09:00 – 17:30>` | the typographer's range mark |
| `start/end` | interval (ISO alternative) | `<2026-01/2026-06>`, `<2026-01-10T09:00/PT1H>` | ISO 8601 |

**The symbol rule** (a principle, not a list; taste plus instinct). A *letter* unit must be spaced from its number (`5 m`, `90 min`), because letters glued to digits are words as often as units (`1st`, `4K`, `1080p`, `401k`). A *symbol* unit may be glued (`50%`, `45°`, `°C`, `′ ″`, `‰`, `€`, `£`), because no word is spelled that way, so gluing it costs nothing. **SI says to space even `%`.** Both spellings are accepted (`<50 %>` and `<50%>` are the same value), and the canonical spelling keeps whichever was written.

**The en-dash range.** The range mark that every typeset timetable, price list and date span uses is the en dash, U+2013, with spaces around it when the ends contain spaces or are long (Chicago-style). It reads without being taught. Agents produce it constantly in prose (instinct), and Joseph has taken typing cost off the table. It ranges over any ordered kind: dates, times, numbers and quantities (`<18 – 25 °C>`, unit once at the end like a printed table). The ISO `/` form is accepted too, for temporal values only, because it is what ISO-literate writers will type. A hyphen-minus range (`<2026-01 - 2026-06>`) is an error that teaches: "a range uses the en dash `–`; a hyphen here is ambiguous with a negative number". *Taste:* this is the single most beautiful choice in the design, and I'm least sure agents will produce it unprompted inside brackets. Their A2 for it is guessed, not known.

**Currency symbols.** `€`, `£`, `₹`, `₩` and `₪` each name one currency. `$`, `¥` and `kr` don't (`$` is USD, CAD, AUD, MXN…; `¥` is JPY and CNY). So `<€12>` is 12 EUR, and `<$9.99>` reads only through a vocabulary that says which dollar. Without one, it's a reader error: "`$` names several currencies; did you mean `<9.99 USD>`?". Ambiguity is never silently resolved.

## 2. A name, when the domain has no printed shape (α)

```udon
:width <css:920px>   :pattern <re:\d+-\w+>   :sku <acme:AB-12>   :home <https://example.com>
:id <uuid:0f8fad5b-d9cb-469f-a165-70867728950e>   :addr <rust:i64:0x73DDF>   :born <date(YY-MM-DD):27-03-05>
```

**The rule:** an interior that begins with a **scheme** (RFC 3986's scheme characters: a letter, then letters, digits, `+`, `-`, `.`), optional `(params)`, then `:`, is a **named value**. The scheme is the notation; the rest, up to the matching `>`, is its body, verbatim. An optional single space after the colon is ornament: `<css: 920px>` and `<css:920px>` are the same.

**Why this is the beautiful version of naming (taste, then reasons):**
- **URIs, autolinks and named values become one thing.** `<https://example.com>` is the notation `https` with the body `//example.com`. That is exactly what CommonMark means by the same characters (an autolink is `<` scheme `:` …, checked by the mark fork in CommonMark 0.31.2 §6.5). The "silent autolink collision" from round one dissolves: what Markdown means and what lite means agree. `<mailto:jw@example.com>`, `<tel:+18015550100>`, `<geo:40.7,-74.0>` and `<urn:isbn:0451450523>` all work the same way, for free, through registered schemes.
- **The colon ladder is Joseph's own namespacing, and URNs'.** He wrote `<core:temporal:timespan 3m5d>`, `<dialect:type:…>` and `<rust:i64: 0x73DDF>`. URNs are built the same way: `urn:isbn:…`, where `urn` delegates to the `isbn` namespace, which owns the rest. So **namespacing is delegation**: lite splits at the *first* colon, and the notation named there owns everything after it, including any further `x:` it wants to read as a sub-notation. `<rust:i64:0x73DDF>` is the notation `rust`, whose reader takes `i64:0x73DDF`. `<temporal:timespan:3m5d>` is `temporal` delegating to its `timespan`. No separate namespace syntax, and none to learn.
- **Global uniqueness without a registry:** a private notation can use a reverse-DNS scheme, `<io.v2.acme:AB-12>` (the shape RFC 8252 recommends for private-use URI schemes; from memory). A vocabulary in scope can alias the short `acme` to it.
- **Parameters look like a constructor** (borrowed from β): `<date(YY-MM-DD):27-03-05>`, `<re(pcre):…>`, `<css(print):12pt>`. Joseph's own `dt(YY-MM-DD)`. A parameter that changes meaning (`YY` fixes a century) is kept in the logical value, so canonical re-emission can drop it only by resolving it: `<2027-03-05>`.

**The body is verbatim** (borrowed from `raw`): no escapes, so a regex or a Windows path is written in its own spelling (`<re:\d+-\w+>`, `<path:C:\Users\jw>`). `<` and `>` nest as matched pairs. A body with an unmatched `>`, or more than one line, goes in a fence (§4), and the error says so.

## 3. A name alone is a clef (ε)

```udon
|season :holidays <date> [2026-01-01 2026-07-04 2026-12-25]
|prices :each <money>
  9.99 USD
  12.50 USD
  €8
|event :on <date> 2026-10-01 :at <time> 09:00
|log <date(DD.MM.YYYY)>
  01.10.2026  launch
  15.10.2026  review
```

**The rule:** an interior that is a scheme (with optional params) and nothing else, `<date>`, is a **clef**, not a value. It says how to read the values after it:
- the rest of a list (`[<date> a b c]`, or a clef just before the list);
- every line of an attribute's or element's body under the line it ends;
- the single next value on the line (`:on <date> 2026-10-01`).

A later clef replaces it, as in music. A clef reads only values that have no mark of their own: `<date> [2026-01-01 <2026-01-10T09:00Z>]` reads the first item as a date and leaves the second marked.

**What I find beautiful:** the values stay exactly as the domain writes them, in columns, unmarked. One quiet sign at the front tells you how to read them. It is the most domain-forward move in the design (A5), and it gives `<date>` the meaning a reader already expects. In usage docs and man pages, `<date>` is the placeholder for "a date goes here" (instinct; the mark fork named that prior as a risk for `<…>` literals, and here the same prior helps). It also fills the slot design's one real gap, a heterogeneous or untyped list that needs its kind stated in place.

**What it is in the tree: an attachment, not a value.** Joseph (2026-10-20): attachments "never change cardinality". `:on <date> 2026-10-01` is one value, the text ‹2026-10-01›, with the clef `date` attached. A reader reads the value through the clef. Nothing about arity changes, and a reader that ignores clefs still sees the text.

**Keywords stay keywords:** `<true>`, `<false>` and `<nil>` are values, never clefs. So `true`, `false` and `nil` can't be notation names, a reservation that costs nothing.

**HTML stays loud** (the args fork's two errors, adopted):
- a clef must be followed by a space, the end of the line, or `[`. `|li <kbd>Ctrl</kbd> to copy` has text glued to the `>`, so it is an error: "this looks like HTML; write `\<kbd>` for text".
- `|li <br>`, a clef with nothing to read, is an error that says the same.

No HTML shape is ever silently a value.

## 4. The block form is a fence; prose has two forms

- **A multi-line value is a fence named by its scheme:** ```` ```sql ````, ```` ```re(pcre) ````. The fence is the block spelling of a named value (from `raw`). A **clef plus a body** is the block spelling of *many one-line values*, so the two never compete: one long value gets a fence, many short ones get a clef.
- **In prose, a Markdown link with a notation URI carries a typed value with its human words** (ζ):

  ```udon
  |p Meet on [Oct 1st](date:2026-10-01) at the usual place.
  ```

  Lite parses none of it. The text passes through as Markdown (C3) byte for byte, and a Markdown-aware reader sees a link whose target is a date. It is ruby text for machines, written the way people already write a linked phrase. *What I find beautiful:* the human words and the machine value sit side by side, and neither is subordinate.
- **`<{…}>` is the value embed,** for a typed value inside text with no display words: `|li Due <{2026-10-01}>, owner @{people/jw}`. Its interior is any interior from §1–§2. This is Joseph's "embedded value", given the meaning `std` and `raw` also gave it. Embeds are `X{…}` (`|{` `@{` `;{`), so `<{` is the natural fourth.
- **`@<…>` is a reference kept as a value,** short for `<ref:…>` (`raw`'s reading, Joseph's "reference kept as a reference, not resolved in place"). `@{people/jw}` resolves in place as a piece of text; `@<people/jw>` is data. One rule, no `@{<…>}`.

## 5. Units, as printed

**The unit table is the printed one, not UCUM's codes:**
- SI symbols with prefixes (`m`, `km`, `s`, `ms`, `min`, `h`, `d`, `kg`, `°C`, `K`, `Pa`, `Hz`, `W`, `V`);
- IEC 80000-13 for information (`B`, `kB`, `MB`, `GB`, `KiB`, `MiB`, `GiB`, `bit`);
- `%`, `‰`, `°`, `′`, `″`.

UCUM's case-sensitive codes are accepted as **aliases**, because they are what clinical and scientific systems emit: `Cel` = `°C`, `By` = `B`, `GiBy` = `GiB`, `mo`, `a`.

**Why printed over UCUM** (taste plus one checked fact). UCUM is machine-unambiguous, but it reads as code: `1.5 GiBy`, `37.5 Cel`. It also makes `B` the bel (the `raw` fork's trap, from memory). The printed table is what every reader has seen a million times, and its one real ambiguity (`B` byte or bel) is settled in favour of the byte; the bel is written `<3 dB>`, decibel, as it is printed. A quantity keeps its unit spelling. The reader resolves the unit in its table and checks its dimension, so the table can grow without changing any tree (B2/B3; `std` makes the same split).

**`5m` is resolved by who reads it, never by the spelling:**
- `<5 m>` is five metres. The unit is printed, spaced, SI.
- `<5 min>` is five minutes; `<PT5M>` is five minutes as a calendar-free ISO duration.
- `<5m>`, glued with a letter, is an error that teaches: "a letter unit is spaced: `<5 m>` (metres) or `<5 min>` (minutes)".
- A bare `5m` in a slot whose clef or vocabulary says `duration` is five minutes. That clef owns the Go-style shorthand (`30s`, `5m`, `1h30m`), with `m` as minutes.

Units are the slot's or the clef's to interpret when the value is bare, and the printed table's when it is marked. **Nothing anywhere guesses.**

## 6. How a reader attaches meaning; the trees before and after

Following `../reader-model.md`, with three choices made concretely:
- **Names are schemes;** short names resolve through the vocabularies in scope, then `std`. IANA-registered URI schemes resolve to `std/uri` unless a vocabulary says otherwise.
- **A document comes under a vocabulary** by reader configuration, its file name, or a root attribute written before the first child; the most specific wins (reader model).
- **The raw tree never changes when a reader learns a notation.** That is what makes carrying a named body pass B2. The law binds all of UDON.

````tree
root                                                           ← raw (lite; fixtures show this)
  |event
    :on    2026-10-01::date.angle
    :at    2026-01-10T14:30Z[America/Denver]::datetime.zoned.angle
    :lasts qty(90::number, ‹min›::unit).angle
    :fee   money(9.99::number, ‹USD›::currency).angle
  |box
    :width named(css, ‹920px›).angle
    :fill  qty(50, ‹%›).angle.glued
  |season
    :span      range(2026-01::date, 2026-06::date).angle.endash
    :holidays  [‹2026-01-01› ‹2026-07-04› ‹2026-12-25›]   ⟨clef date⟩
  |ok
    :pattern named(re, ‹\d+-\w+›).angle
    :home    named(https, ‹//example.com›).angle
    :owner   ref(‹people/jw›).at-angle
````

The **logical tree** (a `std` reader) holds `{type, value, notation, spelling, form, clef?}` at each position. `:holidays` becomes three dates, each still remembering it was bare and read through a clef. `:home` becomes a URI. `:width` becomes a CSS length if `css` is in scope, and otherwise `unread{css, "920px"}`.

**Canonical re-emission** uses each notation's `write`. It keeps the form unless asked to normalize: an en dash stays an en dash, a glued `50%` stays glued, and a clef stays a clef. "Normalize" means the ISO and SI defaults: `/` for temporal intervals, a spaced `%`, `T` and `Z` upper-case.

## 7. Slot and literal; algebraic names

- A vocabulary's slot type is a **standing clef plus a constraint**. A clef in the document is a **local** slot type. A literal's own shape or name **overrides** either one for that value, and is then checked against the slot's constraint, as in `reader-model.md` (N15 below).
- **Algebraic names are vocabulary unions:** `port` = `u16 | service`, where `service` is an enumeration (`smtp ssh http …`). In a declared `port` slot, bare `ssh` and `22` both read. With no vocabulary, the document can state it locally with a clef, `:port <port> ssh`, if `port` is in scope, or `:port <22>`.

## 8. The composite set, N1–N18

```udon
|n1  :on <2026-10-01>
|n2  :at <2026-01-10T14:30Z> :held <2026-01-10T07:30-07:00[America/Denver]>
|n3  :opens <09:00> :era <dt:2026 PDT>
|n4  :born <date(YY-MM-DD):27-03-05>
|n5  :a <PT30S> :b <P1Y2M> :c <5 min>
|n6  :span <2026-01 – 2026-06>
|n7  :width <css:920px> :len <5 m> :disk <1.5 GiB> :share <50%> :temp <37.5 °C>
|n8  :price <9.99 USD>
|n9  :addr <0x73DDF> :raw <rust:i64:0x73DDF>
|svc :port ssh
|svc :port <22>
|n11 :pat <re:\d+-\w+> :home <https://example.com> :id <uuid:0f8fad5b-d9cb-469f-a165-70867728950e> :blob <b64:SGVsbG8=>
|n12 :query
  ```sql
  SELECT id FROM t
  WHERE day = '2026-10-01'
  ```
|n13 :holidays <date> [2026-01-01 2026-07-04]
|n13 :holidays <date>
  2026-01-01
  2026-07-04
|n14 :sku <acme:AB-12>
|n15 :when <9.99 USD>
|p   Meet on [Oct 1st](date:2026-10-01); due <{2026-10-15}>.
|li  <https://example.com>
|n17 :owner @<people/jw> :note see @{people/jw}
|n18 :a <2026-10-01> :b <date(basic):20261001>
```

| | Raw tree | Logical (`std`) | Verdict |
|---|---|---|---|
| N1 | `2026-10-01::date` | the date | renders, with no name; validated in every parser |
| N2 | instant; zoned | the same instant, zone kept | renders, RFC 9557's own spelling |
| N3 | `09:00::time`; `named(dt, ‹2026 PDT›)` | time; `dt` unread unless a vocabulary maps PDT | `09:00` renders. **`2026 PDT` can only be named**: `PDT` is ambiguous, so a `dt` notation that knows which PDT is needed. `std` refuses it with "did you mean `<2026[America/Los_Angeles]>`?" (`raw`'s year-precision zoned extension, adopted). |
| N4 | `named(date, params ‹YY-MM-DD›, ‹27-03-05›)` | 2027-03-05 | renders, with the parameter where Joseph put it |
| N5 | durations; `qty(5, min)` | PT30S, P1Y2M, 5 minutes | renders; the letter unit is spaced |
| N6 | `range(2026-01, 2026-06)` with the en dash | interval of two months | renders, **typeset** |
| N7 | named css; four quantities | 920px; 5 m; 1.5 GiB; 50 %; 37.5 °C | renders; `GiB` as printed |
| N8 | `money(9.99, USD)` | exact | renders |
| N9 | `0x73DDF::int`; `named(rust, ‹i64:0x73DDF›)` | 474591; the second via `rust` if in scope | renders; the domain-range spelling stays recommended (A5) |
| N10 | ‹ssh›; `22::int` | through the `port` union in a declared slot | renders with no plumbing when declared; with no vocabulary, `<port> ssh` needs `port` in scope |
| N11 | named re, https, uuid, b64 | regex (verbatim body), URI, UUID, bytes | renders. **The autolink-shaped URL is just a value** |
| N12 | fence `sql` | the sql notation's reading, or text | renders |
| N13 | texts with clef `date`, in a list and in a body | dates | renders, **unmarked values** |
| N14 | `named(acme, ‹AB-12›)` | `unread{acme, "AB-12"}` without the vocabulary | renders; nothing guessed |
| N15 | `money(9.99, USD)` in a date slot | reader error: "slot `when` expects a date; this is money" | caught at read time |
| N16 | text with a Markdown link; text with a value piece | the link target read as a date; the piece as a date | renders both: display-plus-value, and value-only |
| N16b | `named(https, ‹//example.com›)` | a URI | **the autolink means what Markdown means** |
| N17 | `ref(people/jw)`; a text with a reference piece | kept; resolved | renders |
| N18 | `2026-10-01::date`; `named(date, params basic, ‹20261001›)` | the same date | as written: both as written. Canonical: `<2026-10-01>` twice. **Bare-in-the-mark `<20261001>` is the integer**, so basic format needs its parameter; caught by a date slot |

**Composite lines, the design mixed with other rules:**

```udon
|event :on <date> 2026-10-01 ; tentative
|li Due <{2026-10-15}> ;{or sooner} for [the launch](date:2026-10-01)
|price :range <9 – 12 USD> :note <"$9.99 in the US"> \ and more
|li <kbd>Ctrl</kbd> to copy
```

- **Line 1:** the clef applies to the value; the framed comment attaches to the attribute; nothing changes arity.
- **Line 2:** in text, the value piece, the inline comment piece and a Markdown link all coexist as pieces and passthrough.
- **Line 3:** a money range with the currency once, as printed; a quoted string inside the mark; the framed backslash ends the run, so `and more` is `$main`.
- **Line 4:** an error. "`<kbd>` followed by text looks like HTML; write `\<kbd>`."

## 9. Weighing, Beauty first

*My hypotheses against CTQ-FACTORS. The comparison columns use the careful designs' own self-scores where they gave them; the rest are my estimates, marked ~.*

| Factor (weight) | **combo** | std | raw | slot | elem | Basis for combo |
|---|---|---|---|---|---|---|
| **A1 beauty (9)** | **9** | 8 | 7 | ~7 | ~7 | reads like a printed page; three borrowed literacies (typography, URIs, Markdown) and a music metaphor that is literally true. Taste |
| A2 guessability (10) | 7 | 7 | ~6 | 7 | 7 | dates, URLs and `9.99 USD` are written unprompted; the en dash and the clef must be seen once (guess) |
| A3 cold comprehension (10) | 8 | 8 | ~7 | ~7 | ~7 | `<date> [2026-01-01 …]` reads cold, thanks to the placeholder prior; `<css:920px>` reads cold |
| A4 agentic readability (10) | 9 | 8 | ~7 | ~8 | ~7 | values look like their domain; clefs remove per-value noise in columns |
| A5 domain-forward (9) | 9 | 7 | ~6 | 9 | ~7 | the clef keeps values bare; typeset values carry no names |
| A6 spec clarity (9) | 6 | 5 | ~7 | 7 | ~8 | one sentence of spine, but the typeset table is a real grammar (std's cost, plus the range and the clef) |
| A7 syntactic simplicity (8) | 4 | 4 | ~6 | ~6 | 10 | the largest grammar, the same as std's plus about two rules |
| A8 parsimony (8) | 9 | 8 | ~8 | ~7 | 10 | still one bracket; `:` and `(` inside it have one job each; the en dash is the only new character, and it has one role |
| A9 conciseness (6) | 9 | 8 | ~6 | ~8 | ~6 | |
| B1 bounded streaming (veto) | **pass** | pass | pass | pass | pass | std's discriminator holds (most classes by the 5th character); a scheme is capped at 64; a clef is decided at its `>` |
| B2 reserve (veto) | **pass** | pass | pass | pass | pass | unlabeled space = set ∪ errors; named bodies under the above-tree law; clefs attach and never change a value's raw tree |
| B3 stability (10) | 8 | 8 | ~8 | 9 | ~8 | units and zones validated only for shape, as std does |
| B4 errors that teach (8) | 9 | 10 | ~8 | ~7 | ~6 | parse-time checks; `<5m>`, the hyphen range, `<kbd>Ctrl`, `<$9.99>` each say what was meant |
| B5 parse speed (9) | 8 | 8 | ~9 | ~9 | ~9 | |
| B6 headroom (7) | 6 | 6 | ~7 | ~8 | 10 | spends the unlabeled interior, `<{`, `@<`, and bodiless names (as clefs) |
| C1 structured data (10) | 9 | 9 | ~7 | 7 | ~7 | |
| C2 XML/HTML (10) | 7 | 7 | ~7 | 9 | ~8 | every tag shape at a value start errors loudly; never silent |
| C3 Markdown (9) | 10 | 9 | ~6 | ~8 | ~8 | autolinks mean what Markdown means; links carry typed values; prose untouched |
| C4 types, notations, units (8) | 9 | 9 | 9 | ~8 | 9 | |
| C5 schemas, slot types (8) | 8 | 6 | ~7 | 10 | ~7 | the clef is an in-document slot type; vocabularies compose |
| C6 extensibility (8) | 9 | 7 | ~9 | ~8 | ~8 | any scheme, delegation, reverse-DNS |
| C10 round-trip (7) | 9 | 9 | 9 | ~9 | ~9 | glued vs spaced, en dash vs `/`, all kept |
| D2 host integration (7) | 5 | 5 | ~7 | ~7 | ~8 | every parser validates dates (std's cost) |

**Reading the table honestly.** Combo is std's grammar cost plus about two rules. In exchange it scores highest on beauty (A1), Markdown (C3) and domain-forward among the literal designs (A5). It ties `slot` on A5 without needing a vocabulary. `elem` remains the cheapest grammar by far (A6, A7, B6), and nothing here takes that from it. **The real trade is A6/A7/D2 (the size of what every parser must know) against A1/A4/C3/A5 (how the page reads).** CTQ ranks Beauty highest, and its contributors A2–A5 are weighted 9–10, while A6 and A7 are 9 and 8. On those weights I'd put combo first. My confidence is low to medium, and two parts are unmeasured guesses: whether agents produce the en dash inside brackets unprompted, and whether they reach for `<date>` as a clef.

## 10. What I'm not sure works yet

- **The en dash's discoverability (A2).** If agents write `<2026-01 - 2026-06>`, the error teaches. But if most of them write it that way, the design is charging the typographer's taste to every writer. Fallback inside the same design: accept ` to ` as well? I'd rather not (it's a word), but it's the honest alternative.
- **Glued symbol units bare, outside the mark** (`:fill 50%` read as a quantity by the standard reading, Σ). Beautiful, and principled by the symbol rule. Left as a standard *reading*, not grammar, because grammar would make it B again.
- **A clef before a single value on the line** (`:on <date> 2026-10-01`) duplicates `<2026-10-01>`. It earns its keep only for notations with no shape of their own (`:port <port> ssh`) and for parameters (`<date(DD.MM.YYYY)> 01.10.2026`). Possibly it should be allowed only before lists and bodies. Taste says keep it, because type ascription reads naturally.
- **`<https://…>` as a value in sameline text** (`|li <https://example.com>`) makes `$main` a URI, not text. Markdown re-emission of `$main` gives back the same characters (the spelling is kept), so nothing is lost. But a consumer that wants `$main` as text has to ask for the spelling.

## 11. For lite 0.1

**All of it, as one design.** The spine is one sentence (top of page). The grammar is std's set, plus schemes, clefs, the en-dash range and `<{…}>`. The reader companion is `reader-model.md` plus the `std` table with printed units. If the grammar has to shrink, the order I'd cut in is: ISO `/` intervals (keep the en dash), then `HH:MM` times, then glued symbol units. The order I'd defend to the end: the clef, the scheme form, and dates.

**Card radius** (proposals; no cards edited), on top of std's (which this shares):
- a card for clefs (attachment semantics; scope over list, body and next value);
- the range card (en dash; the ISO `/` alternative);
- the symbol-unit rule;
- [[rule:opaque-span-escapes]] → named bodies are verbatim (from `raw`);
- [[obj:markdown-text-passes-through]] gains a line: autolinks in value position are values, and Markdown links with notation URIs are typed for readers.

About 20 records, most of them new rather than changed.
