# Debrief: how lite's values come to mean what they mean

*To Joseph, from spike c (Opus 5.5, 2026-10-22), rewritten after round two. Your note said the first landing restated our premise ("now if it's well designed, but a 'no' until it gets designed") and that its creativity was low. That was true, so this version replaces those parts instead of appending to them. Measured things are marked "measured"; every score and lean is a hypothesis, with its basis on the pages linked. Trees use the cards' notation: `‹…›` a text, `8080::int` a value of that kind, `‹8080›~int` a text that also carries an integer face.*

## The short of it

1. **A value's kind can come from three places:** the slot (known before the value), a start mark (known at its first character), or the spelling (known only at its end). Your "*what the slot is* vs *what my literal represents*" is the first against the other two.
2. **Streaming didn't kill B in the way we thought.** Measured: the reference parser already holds every value whole, text included. What's left is a question of B1's wording, and round two dissolves it (point 3).
3. **A bare primitive is an allomorph:** `:port 8080` is the text ‹8080› that also carries an integer face (Raku's `IntStr`). The kind is text from the first character, so B1 holds even as worded now. `int(:port)` and `text(:version)` each get exactly what was written. The only open choice is which face a converter to JSON picks by default.
4. **The value bracket reads like a printed page.** `<2026-10-01>`, `<90 min>`, `<37.5 ± 0.2 °C>`, `<9.99 USD>`, `<2026-01 – 06>` are each read by their shape. When the domain has no printed shape, you name the notation URI-style (`<css:920px>`, `<re:\d+-\w+>`, `<https://example.com>`). A name alone is a clef: `<date> [2026-01-01 07-04 12-25]`.
5. **In prose,** `[Oct 1st](date:2026-10-01)` carries a typed value as a Markdown link, untouched by lite. `<{2026-10-15}>` is the value embed. `@<people/jw>` is a reference kept as data.
6. **One law makes all of it safe now:** a notation reads above the tree and never changes the raw tree. Named values are carried today, and later readers only add meaning.
7. **Two real choices are yours:**
   - ASCII `<…>` or the mathematical `⟨…⟩`. The `⟨…⟩` option frees `<` for HTML and Markdown entirely, and its Unicode informal aliases are literally "bra" and "ket" (checked).
   - How much typeset grammar lite 0.1 carries. My lean is all of it.

## 1. Where a kind can come from

```udon
|svc :port 22
|svc :port ssh
|svc :port <22>
```

- A reader that knows `port` is `u16 | service` gets 22 and `ssh` from two texts, with no mark.
- `<22>` is the integer for any reader, known at the `<`.
- Bare `22` looks like a number only once the run has ended.

A consumer that needs the kind *before* the value (a streaming JSON writer choosing whether to write `"`) can get it only from the slot or a mark. Your domain-forward factor (A5) says the slot wherever it can, and a mark where it can't. Every design that survived agrees on that for dates, units and ports.

## 2. What streaming actually constrains (measured, then modeled)

Your `4938222…2412124p`: the 0.9 pushdown parser, fed a 1 MB bare text, a 1 MB digit run, a 1 MB quoted string and a 1 MB prose line, emits **0 bytes before each one's terminator** (`checks/holdback-probe.rs`). It keeps every capture from its mark on. Classifying a run takes a few states. The B fork's classifier agrees with a regex on 200,000 short random spellings, fed whole and in chunks, with 0 mismatches; I re-ran it. The holdback falls on whoever needs the kind before the content.

The one place classifying can't be bounded:

```udon
|book :title 1984 is a novel
```

To tell `1984` from `1984 is a novel`, a classifier must look past the space, across any number of alignment spaces. Round one left this as "does B1 mean memory or characters?". The allomorph (§3) takes the question away: the kind is text at the first character, and the face is an attachment added at the close.

## 3. Bare primitives: text with a second face

```udon
|server :port 8080 :zip 01234 :version 1.10 :tls true :title 1984
```
````tree
root
  |server
    :port ‹8080›~int   :zip ‹01234›   :version ‹1.10›~float   :tls ‹true›~bool   :title ‹1984›~int
````

- `01234` gets no face. The strict number spelling never reads a leading zero as a number, so a zip code can't silently lose its zero.
- `int(:port)` gives 8080, `text(:version)` gives `1.10`, and `int(:retries)` on `3x` raises without touching the tree. That is your cardinality-by-strict-getter idea applied to kind.
- **What's left is your call:** which face a generic converter to JSON picks. My lean is the primitive face, JSON's own convention (quote `"1.10"` if you mean a string). The Cv fork leaned the text face.

Your gotcha survives exactly. `:width 7 ;{px}` holds an embed piece, so it gets no face. `:height 7 ; px` is ‹7›~int.

## 4. The value bracket: one design for lite 0.1

```udon
|event :on <2026-10-01> :at <2026-01-10T07:30-07:00[America/Denver]> :lasts <90 min> :fee <9.99 USD>
|box :width <css:920px> :height <5 m> :fill <50%> :temp <37.5 ± 0.2 °C> :size <1920 × 1080 px>
|season :span <2026-01 – 06> :holidays <date> [2026-01-01 07-04 12-25]
|ok :pattern <re:\d+-\w+> :home <https://example.com> :owner @<people/jw>
|p Meet on [Oct 1st](date:2026-10-01); the review is due <{2026-10-15}>.
```

**The raw tree** (lite's, before any notation is read):
````tree
root
  |event   :on 2026-10-01::date   :at 2026-01-10T07:30-07:00[America/Denver]::datetime.zoned
           :lasts qty(90, ‹min›)   :fee money(9.99, ‹USD›)
  |box     :width named(css, ‹920px›)   :height qty(5, ‹m›)   :fill qty(50, ‹%›).glued
           :temp qty(37.5 ± 0.2, ‹°C›)   :size qty(1920 × 1080, ‹px›)
  |season  :span range(‹2026-01›, ‹06›).endash   :holidays [‹2026-01-01› ‹07-04› ‹12-25›] ⟨clef date⟩
  |ok      :pattern named(re, ‹\d+-\w+›)   :home named(https, ‹//example.com›)   :owner ref(‹people/jw›)
  |p       :$main ‹Meet on [Oct 1st](date:2026-10-01); the review is due › <{2026-10-15::date}> ‹.›
````

**After a reader with the standard notations** (the logical tree): the same positions hold read values, each keeping its spelling and form, so emitting "as written" is always exact.
- `:span` is January to June 2026, with the elided end resolved against the start.
- `:holidays` is three dates, read through the clef with their years filled in.
- `:width` is a CSS length if `css` is in scope, otherwise `unread{css, "920px"}`.
- The paragraph stays text. A Markdown-aware reader also sees a link whose target is a date.

**What each part is and where it came from** (fuller in `notations/synthesis.md`):

- **Shapes name the kind.** RFC 3339 dates and times, RFC 9557's `[Zone]` suffix, ISO durations, quantities with SI spacing, money with ISO codes, and the en dash for ranges with the unit written once (`<18 – 25 °C>`). Uncertainty and dimensions are written as engineers print them (`±`, `×`). All of it is checked at parse time, and errors teach: `<5m>` asks "metres `<5 m>` or minutes `<5 min>`?", and `<$9.99>` asks which dollar.
- **The symbol rule.** Letter units are spaced, because `1st` and `4K` are words. Symbol units may glue (`50%`, `45°`), because no word is spelled that way.
- **Printed units.** `°C`, `GiB`, `m/s²`, with UCUM's codes (`Cel`, `GiBy`) accepted as aliases. `B` is the byte; the bel is printed `dB`.
- **Named notations are URI-shaped.** `<scheme:body>`, the body verbatim, so a regex keeps its own `\d`.
  - `<https://example.com>` now means what CommonMark means by those characters. The round-one "autolink collision" was the two notations agreeing.
  - Namespacing is delegation down your colon ladder (`<rust:i64:0x73DDF>`, as URNs do it).
  - Parameters look like a constructor: `<date(YY-MM-DD):27-03-05>` reads as 2027-03-05.
- **Clefs** (from music: a clef says how every following note is read). A bodiless `<date>` reads the values after it in a list, a body, or the next value, so values stay in their own spelling. In the tree a clef is an attachment and changes no arity.
- **Elision** (LilyPond's relative mode; the typographer's "1914–18"). Write shared leading parts once: `<2026-01 – 06>`. An end that falls before its start is an error.
- **Fences are the block form** of a named value (```` ```sql ````). `@<x>` is kept and `@{x}` resolves, which gives `@{<…>}` a principled home.

## 5. Your two choices, side by side

**The bracket:**
```udon
|li <kbd>Ctrl</kbd> to copy
|li <https://example.com>
|event :on <2026-10-01>
```
- **ASCII `<…>`:** line 1 is an error ("this looks like HTML; write `\<kbd>`"), line 2 a URI value, line 3 a date.
- **`⟨…⟩` instead (`bra`):** lines 1 and 2 are plain text with no escapes anywhere, line 3 is `:on ⟨2026-10-01⟩`, and `⟨…⟩` can even sit in prose: `Meet on ⟨2026-10-01⟩.`

What `⟨…⟩` costs: no agent writes `⟨` unprompted (guessability 5 against 7), and it's close to `<` for people. **My lean is ASCII, with low confidence.** It is the one question here a cheap panel would settle: show three examples, then ask agents to write five values.

**How much shape grammar:** it is the largest grammar in lite (spec clarity ~6, simplicity ~4, host integration ~5). **My lean is all of it**, because CTQ puts Beauty and its contributors at 9–10 and above clarity and simplicity at 9 and 8. If it has to shrink, cut size pairs and `× 10ⁿ`, then datetime intervals, then glued symbols. Never cut dates, quantities, durations or dash ranges.

**The cheapest alternative** is the `elem` design, with no new grammar at all. `:when |date 2026-10-01` and `|{qty 5 m}` in prose, with a reader collapsing known notation elements into values. Simplicity 10, headroom 10, my sense of its beauty 7: structure dressed as values. It is the right design if grammar size matters more than CTQ says.

## 6. Units

```udon
|job :timeout <5 min> :length <5 m> :wait 5m :width <920 px> :rank 1st
```

`timeout` is 5 minutes and `length` 5 metres. `wait` is ‹5m›, text with no face, which a slot or clef declared `duration` reads as minutes (Go-style shorthand, `m` = minutes). `rank` is ‹1st›, a word. Nothing anywhere guesses: the unit is resolved by the printed table inside the mark, or by the slot when the value is bare.

## 7. The trailing colon

The labels lean (2026-10-20) lets `:` sit last in a bare name, so today `:host:` is the attribute named `host:`. No XML name ends in `:`, so dropping "last" costs nothing. **The design:** your ornament. `:host: localhost` is `:host localhost`, and a bare label never ends in `:`. Bare `host: localhost` at the start of `$main` warns under [[rule:main-label-colon-warns]]; its suggestion becomes `:host: localhost`. A `:when:dt` type slot dies on `:xml:lang`; the clef does that job instead (`:when <date> …`). The mark fork's lean was to reserve the colon first, because reserving and then accepting breaks nothing, while accepting and then reversing breaks documents. I'd give it your meaning now anyway: the beauty is yours to judge, and the only risk is a later reversal.

## 8. Noticed along the way

```udon
|a :href https://example.com Click here
```

Under the bare-run lean, `href` is ‹https://example.com Click here›, and nothing warns. An HTML-trained writer puts attributes first. This is a cost of the run rule, not of any type design.

## What I'd ask you

1. ASCII `<…>` or `⟨…⟩`?
2. All of the typeset shape set in 0.1, or which part of it?
3. For bare primitives: which face does a converter pick by default?
4. Is "a notation reads above the tree and never changes it" a law for all of UDON?
5. The trailing colon as your ornament now?
6. Smaller: `<nan>`, `<inf>`, `<-inf>` inside the mark (the core fork's lean; mine too)? `-0xFF` as text?

## About the work

- **Round one:** four forks (`Cv`, `B`, `mark`, `core`).
- **Round two:**
  - five careful designs (`raw`, `args`, `std`, `slot`, `elem`);
  - after your creativity note, my inventions page and three inventive forks (`combo`, `bra`, `wild`), plus `std` revised to `std★`.
- **Forking depth:** the harness keeps forks from spawning agents, so forking went one level deep, and each fork branched further in files. Messages to running and finished forks worked: your notes, a fact correction and one rendering fix.
- **Cost:** each fork used roughly 260–450k tokens.
- **Measured:** the streaming probe, the wire model and the classifier fuzz. **Checked against sources:** RFC 9557, UCUM's codes, the Unicode aliases, and NIST's SI spacing (`std★`). Everything else is one agent's judgment.
