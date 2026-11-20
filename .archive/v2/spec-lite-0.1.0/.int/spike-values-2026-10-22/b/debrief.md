# Debrief for Joseph: spike b

*From the spike-b agent (Opus 5.5), 2026-10-22, after three rounds. Trees use the cards' notation: `‹…›` a text, `"…"` a string, bare `8080`/`false`/`nil` values of those kinds. `(.kg)` is a trait on an attribute occurrence. `⇒` is what a reader attaches. My leans are leans; the scores behind them are my own hypotheses, totalled by script, on the pages named.*

## Latest word: after reading spikes a and c (`final-thoughts.md`)

Your parenthesis canary works in ASCII once a delimited value has to stand alone (my page 30). Spike c found `date(2026-10-01)` and demoted it because `|li printf(x) prints x` would turn into a call. Under the stand-alone rule that line is plain text, so the objection goes away. Combined with the label trait, your first imagining comes back almost word for word:

```udon
|part :mass.kg 3.2 :price.money(USD) 9.99
|ev :on.date(YY-MM-DD pivot 1950) 27-03-05 :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|li printf(x) prints x
```
The first three lines read 3.2 kg, 9.99 USD, the date 2027-03-05, an interval, and a list with a date, a quantity, 42 and ‹hello›. The last is plain text. With calls on values, traits on labels, signatures for tables, and backticks for verbatim, `<…>` isn't needed for values at all, and `<` is free for HTML and Markdown. The rest of this debrief is rounds 1–3, and still holds where K doesn't replace it. First question for you, from spike a: **is a refinement a change?** Every notation design here depends on the answer being no.

## In one paragraph

Bare values stay text in the tree, as your (C) has it. One normative default reading (JSON's grammar plus `true`, `false`, `nil`) keeps `:debug false` from becoming a truthy string. For everything richer, **the label wears the reading**:
- `:mass.kg 3.2`, `:on.date 2026-10-01`: lite's own trait mark, put on attribute names;
- a key signature, `$sig`, that says it once for a whole table;
- backtick raw values, so regexes never escape;
- a hinged literal, `<date: 2026-10-01>`, for slots with no fixed kind.

A reader attaches meaning in layers over a tree that never changes. Streaming, which seemed to decide all this, turned out not to (it was measured).

## 1. Labels wear the reading

The sigil idea, made beautiful by moving it off the value. You know at the first character what a value's kind is, because the kind is on its name:

```udon
|event :on.date 2026-10-01 :start.datetime 2026-10-01T14:30-06:00[America/Denver] :lasts.duration 3mo 5d
|part :mass.kg 3.2 :width.px 920 :price.decimal 83.23 :sku.acme/sku AB-12-rev3
|rule :pattern.re `\d+(\.\d+)?` :path `C:\Users\me`
|cfg :port.u16 8080 :timeout.ms 500 :holidays.date [2026-11-26 2026-12-25]
```
````tree
root
  |event
    :on (.date) ‹2026-10-01›                    ⇒ Date 2026-10-01
    :start (.datetime) ‹2026-10-01T14:30-06:00[America/Denver]›   ⇒ ZonedDateTime
    :lasts (.duration) ‹3mo 5d›                  ⇒ Duration 3 months 5 days
  |part
    :mass (.kg) ‹3.2›                            ⇒ 3.2 kg
    :width (.px) ‹920›                           ⇒ 920 px
    :price (.decimal) ‹83.23›                    ⇒ exact decimal
    :sku (.acme/sku) ‹AB-12-rev3›                ⇒ unresolved acme/sku (a reader that knows it reads it; the tree is complete either way)
  |rule
    :pattern (.re) raw "\d+(\.\d+)?"             ⇒ Regex
    :path raw "C:\Users\me"
  |cfg
    :port (.u16) ‹8080›                          ⇒ 8080, range-checked
    :timeout (.ms) ‹500›                         ⇒ 500 ms
    :holidays (.date) [‹2026-11-26› ‹2026-12-25›]  ⇒ two Dates
````

- **Why `.`:** it already means "what kind of thing" (`|user.admin`), and the label lean already makes `.` inside an attribute name an error, "until there's a reason". This is the reason.
- **Why I think agents will write it:** everyone already names fields `timeout_ms` and `size_px`. This makes that habit mean something. (It's an instinct, mine; it's the claim most worth a small probe.)
- **Occurrences:** the trait belongs to the occurrence, so `:mass.kg 3` and `:mass.lb 7` stack as two masses.
- **Errors:** an unregistered unprefixed kind is an error with "did you mean"; a namespaced one (`.acme/sku`) is carried.

**The key signature**, for a table: say it once at the top of the staff. An occurrence's own trait overrides it, like an accidental:

```udon
|samples :$sig [mass.kg temp.degC taken.datetime]
  |sample :mass 3.2 :temp 21.5 :taken 2026-10-01T14:30Z
  |sample :mass 2.9 :temp 22.0 :taken 2026-10-01T15:10Z :mass.lb 6.6
```
````tree
root
  |samples
    :$sig [‹mass.kg› ‹temp.degC› ‹taken.datetime›]
    |sample
      :mass ‹3.2›                  ⇒ 3.2 kg
      :temp ‹21.5›                 ⇒ 21.5 °C
      :taken ‹2026-10-01T14:30Z›   ⇒ DateTime UTC
    |sample
      :mass ‹2.9›                  ⇒ 2.9 kg
      :temp ‹22.0›                 ⇒ 22.0 °C
      :taken ‹2026-10-01T15:10Z›   ⇒ DateTime UTC
      :mass (.lb) ‹6.6›            ⇒ 6.6 lb (the accidental)
````

**Backticks mean verbatim, sized by the run.** Three or more on an attribute's line already open a fence (the block raw value). One or two, standing alone as a value, is the inline raw value. In text, Markdown's code spans stay as written:

```udon
|cmd :run `rm -rf ./build` :match ``a`b``
|li `npm install` first
```
````tree
root
  |cmd
    :run raw "rm -rf ./build"
    :match raw "a`b"
  |li
    :$main ‹`npm install` first›
````

**The hinged literal**, for slots with no fixed kind (a metadata bag, a mixed list) and for nesting. It's your `<dt: …>`, with the colon and space as the hinge between the name and the items:

```udon
|meta :values [<date: 2026-10-01> <qty: 3.2 kg> <duration: P1W> 42 hello]
|math :z <rational: <complex: 3 -7> 2>
|link :to <ref: people/jw> :also @{people/jw}
|p Due |{time Oct 1 :datetime <date: 2026-10-01>} at noon.
```
````tree
root
  |meta
    :values [literal date [‹2026-10-01›] literal qty [‹3.2› ‹kg›] literal duration [‹P1W›] ‹42› ‹hello›]
                                    ⇒ [Date, 3.2 kg, Duration, 42, ‹hello›]
  |math
    :z literal rational [literal complex [‹3› ‹-7›] ‹2›]   ⇒ Rational(Complex(3, −7), 2)
  |link
    :to literal ref [‹people/jw›]   ⇒ a reference as a value (Lisp's quote)
    :also ‹@{people/jw}›            (the referent's place, as today)
  |p
    :$main ‹Due |{time …} at noon.›
      |time
        :$main ‹Oct 1›
        :datetime literal date [‹2026-10-01›]   ⇒ Date
````

A literal's items are read by lite's own list rules, so a parser that has never heard of `rational` still builds the whole tree. A later UDON adds *readings*, never different trees. That is how reserve-don't-ignore holds without reserving anything. `<>` is nil and `<0xFF>` an asserted number, as before. `@{<…>}` becomes `<ref: …>`.

**How meaning attaches**, highest first, all over one raw tree:
1. the occurrence's trait;
2. the signature;
3. the vocabulary (a lite document, addressed by element and attribute names: your "algebraic names", `port = u16 | standard-port`);
4. the default reading.

An asserted literal decides its own type and the slot only checks it; a bare value is read by its slot. Typed getters (`get_date(:on)`) are the API's version of the same layers: the twin of your strict getters for cardinality.

**The registry I'd propose for lite 0.1:**
- kinds: `text` (switches the default reading off), `date`, `time`, `datetime` (RFC 3339, plus RFC 9557's `[Zone]`), `duration` (ISO `P…`, or items like `3mo 5d` from a closed unit set, where a lone `m` is an error: "mo or min?"), `decimal`, `ref`, ranged integers `u8`…`i64`, and `re`;
- unit symbols as writers write them: `kg`, `ms`, `px`, `degC`, `pct`.

Two-digit years go in a slot's format, with a pivot, never on a literal. A literal must stand on its own, or its meaning changes with the clock.

**What I tried and why it lost:**
- The bra-ket `<date|2026-10-01>`: your own `<uint32|0x992BC>`, and Unicode itself calls `⟨` "bra". Lovely, but `|` would mean two things.
- Elements as notation values (`|{date 2026-10-01}`): the runner-up. It needs no new construct, but a typo like `|{dtae …}` is silently just an element.
- Emoji sigils (`📅2026-10-01`): instantly understood, but `⚖` and `⚖️` are two spellings, and widths break alignment.
- Superscript kind marks (`ᵈᵃᵗᵉ2026-10-01`): NFKC folds them to `date2026-10-01`.
- A tie for per-item units (`[12‿px 1.5‿em]`): strange, unfinished, and still alive if you like it.

Scores (page 60 §3; Beauty first, computed by script): this system 1234 of 1520, elements 1134, bra-ket 1131, the plain angle literal 1119. The lead comes from the Beauty group and holds even if its spec-clarity, simplicity and parsimony scores drop by two each.

## 2. The default reading, and the example that decides it

```udon
|server :name web :port 8080 :debug false :owner nil :ratio 0.75 :zip 01234 :version 1.0
```
````tree
root
  |server
    :name ‹web›
    :port ‹8080›      ⇒ 8080
    :debug ‹false›    ⇒ false
    :owner ‹nil›      ⇒ nil
    :ratio ‹0.75›     ⇒ 0.75
    :zip ‹01234›      (leading zero: stays text)
    :version ‹1.0›    ⇒ 1.0   ← the residual hazard; `:version.text 1.0` or a vocabulary fixes it
````

Without the reading, `:debug` is the string `"false"`, which is truthy in Python, JS, Ruby and Elixir (I ran it). The set is chosen by one test: guess only where nothing is lost, so the spelling comes back as written. That is JSON's grammar, the one every agent already knows. It makes the reading normative, which closes the open bit of (C) the other way from the context file's note. Your gotcha keeps its meaning: `:width 7 ;{px}` stays text, `:height 7 ; px` reads 7. [[rule:nil-spelling]] and [[rule:missing-value]] stay true as written.

## 3. Streaming: measured, and it doesn't decide B vs C

A fork fed the 0.9 parser 200 KB runs in 1 KB chunks. No content event came out before a run ended, for numbers, words, text, prose or quoted strings. Your `4938…2p` is held whole today and emitted at the `p`. Value kinds were never known in the first few characters, in any parser we checked; structure kinds were. The real streaming question is whether the wire emits content in fragments or caps the line. Today only the recursive wrapper's 4 KB line buffer caps it; the pushdown parser has no cap. The fork proposes this for B1:

> **Bounded streaming.** Where a construct ends and what contains it are known within a few characters. A parser never needs to hold an unbounded stretch of input to decide them. A classification of a finished span (its kind) may be reported after the span.

The traits above go further than that: the kind is known *before* the value.

## 4. A quoted or bracketed value should stand alone

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
|el :a "x" y
|el :a "x" \ y
```
Today: `$main "Hello,"` + `$main ‹she said.›` (the quote marks are gone), and a list `[‹Docs›]` + text (the link is gone). Proposed:
````tree
root
  |p
    :$main ‹"Hello," she said.›
  |li
    :$main ‹[Docs](https://x.org) for more›
  |el
    :a ‹"x" y›
  |el
    :a "x"
    :$main ‹y›
````
**The rule:** a value is one delimited form standing alone, or it is a run. It makes `:c "1" z` behave like `:c 1 z`, and it's what lets the hinged literal and the backtick raw value never collide with HTML or Markdown in text. It crosses your 2026-10-21 lean on the residue after a self-ending value ("perfectly fine … I think"), so it's yours to call.

## 5. What I'd ask you, as examples

1. `:mass.kg 3.2` and `:on.date 2026-10-01`: does the label wearing the reading feel like UDON to you?
2. `|samples :$sig [mass.kg temp.degC]`, then rows of bare numbers: worth having in lite 0.1?
3. `|server :debug false` with no schema: `false`, or `"false"`?
4. `|p "Hello," she said.`: one text?
5. `<date: 2026-10-01>`: the hinge as the spelling for notation values in generic slots, and the same `:` as your trailing colon on attribute names, decided together?

## 6. Where I'm unsure

- That agents will guess `:timeout.ms 500` after one example rests on my own instinct, and so does the `false`-vs-`1.0` frequency. Both are the cheapest things to probe if a probe is ever affordable.
- The scores are mine. The margins between the runners-up are inside my error; the leader's margin isn't, by my own estimate, but that estimate is mine too.
- My first two rounds surveyed and adjudicated more than they invented. The third round's inventions are less pushed than the first round's adjudications: the key signature's scoping and the registry's exact contents in particular are sketched, not finished.
