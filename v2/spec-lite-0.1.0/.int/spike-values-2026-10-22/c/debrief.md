# Debrief: how lite's values come to mean what they mean

*To Joseph, from spike c (Opus 5.5, 2026-10-22). Written last, from the branch pages. What is measured is marked "measured"; every score and lean is a hypothesis with its basis on the pages linked. Trees use the cards' notation: `‹…›` a text, `"…"` a string, `8080::int` a value of that kind, `nil` nil.*

## The short of it

1. **There are three places a value's kind can come from**: the slot (known before the value), a start mark like `<` or `"` (known at its first character), or the spelling (known only at its end). Your "*what the slot is* vs *what my literal represents*" is the first of these against the other two. Every design below is a choice of which of the three carries which kinds.
2. **B wasn't killed by streaming in the way we thought.** Measured: the reference parser already holds every value whole until its end, text included. Classifying `8080` takes a few states, never a buffer. Whether B survives depends on what B1 means: *memory held* (B passes) or *characters read before the kind is known* (B fails, on trailing whitespace). That is your call.
3. **Once streaming is set aside, B and your C-with-view are one design with a dial on it.** The tree records the spelling. "The standard set" is a *reading*: a generic slot type I've been calling `std`. The only real question left is where `std` is the default: in the tree (B), in generic converters (my lean), opt-in (the Cv fork's lean), or nowhere.
4. **The view works best as a typed read**: `int(:port)`, which raises on `8080x`. It is your cardinality-by-strict-getter idea applied to kind.
5. **`<…>` can shrink to asserting the portable kinds** in 0.1.0, with every other interior an error. Named notations (`<date:…>`) can come later, safely, only if every UDON reads notations above the tree.
6. **Units are the slot's job.** `5m` is minutes in `:timeout` and metres in `:length`, and nothing literal-side can know which.
7. **The trailing colon collides with the labels lean,** which lets `:` end a bare name. A `:when:dt` type slot collides with `:xml:lang`. Reserving the trailing colon now keeps your ornament open for later.

## 1. Where a kind can come from

```udon
|svc :port 22
|svc :port ssh
|svc :port <22>
```

- From the **slot**: a reader that knows `port` is `u16 | standard-port` gets 22 and `ssh` from two texts, with no mark at all. This is your algebraic name working exactly as the domain thinks.
- From a **mark**: `<22>` is the integer 22 for any reader, schema or none, and the kind is known at the `<`.
- From the **spelling**: `22` looks like a number, but you only know that once the run has ended.

A consumer that has to know the kind *before* the value arrives (a streaming converter to JSON choosing whether to write `"`) can get it only from the slot or a mark. So "concise and kind-first" means the slot, and "no slot and kind-first" means a mark. Your domain-forward factor (A5, 9) says: the slot wherever it can, and a mark only where it can't. Every surviving branch agrees on that for dates, units, ports and other notations. The branches differ only on the handful of portable kinds (numbers, true, false, nil).

## 2. What streaming actually constrains

Your example, `|n :id 4938222…2412124p`, with a megabyte of digits:

| | What gets held | Measured or modeled |
|---|---|---|
| 0.9 reference parser, today, for a 1 MB bare text, a 1 MB digit run, a 1 MB quoted string, a 1 MB prose line | all of it, until the terminator; 0 bytes emitted early | **measured** (`checks/holdback-probe.rs`; `parser_pd.rs` keeps every capture from its mark on) |
| B, kind announced at the value's end | one chunk; the classifier is a few states | modeled (`checks/wire_model.py`). The B fork's constant-state classifier agrees with a regex on 200,000 short random spellings (1–9 characters), fed whole and in chunks, with 0 mismatches; I re-ran it |
| B, kind announced first, no cap | the whole run, while it could still be a number | modeled |
| B, kind announced first, "a bare primitive is at most 64 characters" | at most 65 bytes | modeled |
| a streaming JSON converter after any of these, if it uses the standard reading | the undecided prefix, the same as B kind-first | modeled |

So the holdback you objected to isn't something B adds: today's parser holds text the same way. What B adds is that the *kind* is known at the end. The B fork found the one place B truly can't be bounded:

```udon
|book :title 1984 is a novel
|cfg :port 8080                                   ; then a long run of alignment spaces
```

To tell `1984` from `1984 is a novel`, B has to look past the space. Trailing spaces keep that question open across however many there are. The memory cost is only a count, but the number of characters is unbounded. Committing at the first space would give `:title 1984` plus `$main ‹is a novel›`, the very split B exists to prevent. So, read as "**no unbounded memory**" (your stated reason: buffering, DoS), B passes. Read as CTQ-FACTORS words it now, "**no construct holds an unbounded stretch before its kind is known**", B fails. Note that every option already defers a value's *extent* across the same spaces; only B also defers its kind there.

## 3. The dial: where the standard reading lives

One line, and what each setting gives:

```udon
|server :name web :port 8080 :tls true :zip 01234 :version 1.10 :note <>
|book :title 1984 :year 1949
```

**The tree under C (your lean), and under my Σ:**
````tree
root
  |server
    :name ‹web›   :port ‹8080›   :tls ‹true›   :zip ‹01234›   :version ‹1.10›   :note nil
  |book
    :title ‹1984›   :year ‹1949›
````

**The tree under B** (spelling kept, nothing converted):
````tree
root
  |server
    :name ‹web›   :port 8080::int   :tls true::bool   :zip ‹01234›   :version 1.10::float   :note nil
  |book
    :title 1984::int   :year 1949::int
````

`:zip 01234` stays text in both, because the strict number spelling (core fork) never reads a leading zero as a number. That is the lossy kind of miss, and the strict spelling refuses it.

**What a reader gets.** Under every setting, `int(:port)` gives 8080, `bool(:tls)` gives true, and `text(:version)` gives `1.10`. The settings differ only for a consumer that brings no slot: the generic converter.

| Setting | JSON from the line above, with no schema | Who gets surprised |
|---|---|---|
| `std` in the tree (B) | `"port": 8080, "tls": true, "version": 1.10, "title": 1984` | the writer who meant `1.10` and `1984` as text, unless they quoted them (JSON's own habit) |
| `std` the converters' default, tree is text (Σ, my lean) | the same JSON; the tree and the API stay text | the same writer, but only at conversion |
| `std` opt-in, converter emits strings (Cv fork's lean) | `"port": "8080", "tls": "true", …` | the writer who meant `8080` as a number, unless they wrote `<8080>` |
| no `std` at all (D0) | strings, and nil can't be written | everyone who wanted a number; dead |

The Cv and Σ leans differ only on that one default. The Cv fork weighs "bare is text" kept true everywhere. I weigh the fact that a converter's whole job is producing JSON, and JSON-trained writers meant `8080` as a number. Neither of us is confident. The B fork's scores put B and the lean close: B wins on data (C1, A2, A9), the lean on mixed content and slot types (C2, C5, A5).

**Your gotcha survives under all of them:**
```udon
|m :width 7 ;{px}
|m :height 7 ; px
```
`int(:height)` gives 7. `int(:width)` raises, because that text holds an embed piece and isn't one run. Under B the tree itself says ‹7 ;{px}› and 7::int.

## 4. The view is a typed read

Your 2026-10-21 cardinality lean: store vectors, and let strict getters raise "without touching the tree". The same move works for kind:

```udon
|server :port 8080 :retries 3x
```
`int(:port)` gives 8080. `int(:retries)` raises: `3x` is not an integer; it is text. The tree is untouched. The rule both share: **the tree records what was written, and the reader brings what it expects.** A "converted second tree" view (push) brings back every trap whenever it's on, and "on by default" would just be B. So the Cv fork dropped it in favor of the typed read.

## 5. What `<…>` holds

The mark fork's finding: a mark does one of two jobs. It either **asserts a portable kind** (lite can check it), or **names a notation** (lite can only carry the body).

**M1, its recommendation for 0.1.0:** `<…>` holds exactly one primitive, committed at its first character.

```udon
|e :port <8080> :ratio <0.5> :on <true> :note <> :empty <"">
```
````tree
root
  |e
    :port 8080::int   :ratio 0.5::float   :on true::bool   :note nil   :empty ""
````
```udon
|e :width <920px>
|e :when <2026-01-10>
```
Each of these is an error, so there is no tree. The first says: `920px` is not a number; did you mean the text `920px`, or `<920>`? The second says: lite has no date notation inside `<…>`; write the date bare and let the slot read it. `<>` is nil with no extra rule: an empty interior names no kind, and nil is the kind with no content. It also gives the missing-value error its fix, "did you mean `:a <>` (nil) or `:a ""`?".

Carrying an *unlabeled* interior raw died on the reserve-don't-ignore veto: a later UDON that reads unlabeled dates would change lite's trees. That is `<2026-01-10>` as raw text, which is your 2026-09-29 option 2 and the provisional card today, so this would reverse it.

**M2, later:** `<date:2026-01-10>` → `lit(date, "2026-01-10")`, the name split at the first `:` and the body carried raw. It is safe only under a law that binds all of UDON: *a notation reads above the tree and never changes the raw tree*. That law keeps `<{…}>` reserved, since it would carry structure. M2 has one silent collision:

```udon
|li <https://example.com>
```
Under M1 that is an error ("escape it: `\<https://…>`"); under M2 it is the notation `https` with the body `//example.com`, silently. A specific warning would catch it. The Elixir-style sigil `~date[2026-01-10]` is kept on file as the one glyph that frees `<` from HTML and autolinks entirely. KDL's `(u16)8080`, EDN's `#inst`, YAML's `!!int`, `name"body"` and suffixes all died (the glyph page has why).

A guess the mark fork offers for you: if `<…>` means "a literal, not UDON", then `@<x>` reads naturally as a reference **kept as a reference, never resolved**: your Lisp-quote distinction, giving `@{<…>}` a principled home: `@{x}` resolves, `@<x>` is kept.

## 6. The core set and units

The core fork's test for a core kind: its meaning is **parameter-free** (the spelling alone says it), it is **host-portable**, it is **collision-light**, and it **earns its grammar**. Through it: nil, true, false, integer, float, delimited string, list. Dates are the first named notation, not core (a zone or calendar is a parameter). Durations, rationals, complex numbers, quantities and money aren't kinds in lite at all. The old line's surprises all sat in the members this test removes.

The strict spelling, in the cases that matter:

```udon
|n :a 01234 :b 0755 :c 1_000_000 :d .5 :e 0xFF :f 1e10 :g NaN :h 12345678901234567890123
```
Under the standard reading: `a` ‹01234› and `b` ‹0755› stay text (leading zero: the lossy miss refused); `c` 1000000; `d` ‹.5› text (write `0.5`); `e` 255 (spelled `0xFF`); `f` a float; `g` ‹NaN› text; `h` an integer whose spelling is kept, with the host guide deciding what a host does past its range.

Units:
```udon
|job :timeout 5m :length 5m :width 920px :rank 1st :res 1080p
```
All texts. The slots `timeout` and `length` read `5m` as 300 seconds and 5 metres. A bare "number plus letters is a quantity" rule died on `1st`, `1080p`, `4K` and `401k`, and still couldn't tell minutes from metres. Lite 0.1.0 needs no unit syntax. A unit-owning notation inside a mark (`<si: 5 m>`) is the later path.

## 7. Naming a slot's kind in the document, and the trailing colon

Your `:when:dt(YY-MM-DD)<27-03-05>` put the notation on the slot. Spelled with `:`, it dies:

```udon
|html :xml:lang en
```
That would read as attribute `xml` with type `lang`, silently, and namespaced XML/SVG names are weight-10 territory (C2). The slot-side spelling that survives is the trait elements already have, given to attributes:

```udon
|holidays
  :dates.date
    2026-01-01
    2026-07-04
|t :born.date.YY-MM-DD 27-03-05
```
It earns its keep where **one declaration covers several values** (an attribute body, a list). On a single value it carries the same information as `<date:…>`. Its hazard: a TOML-trained writer's `:server.port 8080` means nesting, and would silently get attribute `server` with slot kind `port`. `:port<u16> 8080` (generic-type style) avoids that, at the cost of `<` having a second role.

**The trailing colon:** the labels lean (2026-10-20) lets `:` sit inner *and last* in a bare name, so today `:host:` is the attribute named `host:`. Your ornament needs "last" dropped. No XML name ends in `:`, so dropping it costs nothing. The mark fork's lean, and mine: **reserve it now** (`:host: localhost` is an error, "did you mean `:host localhost`?"). Your ornament is then a later widening that changes no tree, while the reverse order would break documents.

## 8. Noticed along the way

```udon
|a :href https://example.com Click here
```
Under the bare-run lean, `href` is ‹https://example.com Click here›. The run reaches the next start, and `Click` isn't one. An HTML-trained writer puts attributes first. This is a cost of the run rule, not of any type design, and it is caught by nothing. (The mark fork's first rendering drew it wrong; corrected.)

## What I'd ask you

1. **B1: memory, or characters until the kind is known?** It decides whether B is still alive.
2. **The dial:** where should the standard reading be the default? In the tree; in converters only; opt-in; or nowhere?
3. **`<…>` in 0.1.0:** only the portable kinds (M1), with `<name:…>` an error for now? And is "notations read above the tree, never change it" a law for all of UDON?
4. **The trailing colon:** reserve it now?
5. Smaller, for the standard notation: does it read floats (and so `1.10` → 1.1 in conversion)? Do `<nan>` and `<inf>` exist? Is `-0xFF` a number?
6. Should a slot's kind ever be written in a lite document (`:dates.date` or `:dates<date>`), or only in a schema?

## About the forking

I launched four forks (full-context agents) at once: `Cv`, `B`, `mark`, `core`. Each one reported that the harness tells a fork not to spawn agents, so forking went **one level deep**, and every fork branched further in its own files. Messages to running forks worked: your two mid-run notes reached all four, and one rendering error was corrected after a fork had reported. Each fork used roughly 260–300k tokens.
