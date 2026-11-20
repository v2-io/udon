# I1: the reading comes after the value — `0xff<u64>`, `5<min>`, `2026-07-21<date>`

*Invention fork `invent-beyond`, spike a, 2026-10-22. Invented first, judged after. Sources it was made from: Japanese ruby (furigana) and the Aozora Bunko plain-text ruby `｜漢字《かんじ》`, where a small reading rides beside the base text; physics' quantity calculus, Q = {Q}·[Q], a number and then its unit; linguistic glossing, where the gloss follows the form; chemistry's state symbols, `H₂O(l)`. The ASCII spelling it lands on is the same as F#'s units of measure (`1.0<cm>`), which I noticed only after drawing it. Trees: `⸨…⸩` a «text», `"…"` a «string», `#integer` the parser's classification (Cc, from the classification fork), `as u64` an author's reading. Illustrative glyphs, not a transcript proposal.*

## The idea

People write the thing first and its qualifier after, almost everywhere a notation is built for reading:

| Notation | Written |
|---|---|
| a unit | `5 min`, `920 px`, `9.99 USD` |
| a gloss | form, then its gloss |
| ruby | base text, then its reading, set small |
| a state symbol | `NaCl(aq)` |
| a footnote mark | after the word |
| a mathematician's ascription | `x : ℝ` |

Programming notations mostly put it first: casts, sigils, KDL's `(u8)123`, EDN's `#inst "…"`, our own `<dt: …>`. They do that for the parser, so it knows what it's reading before it reads it. F1 (spike a's streaming finding) says lite's parser doesn't need that: a bare run's extent never depends on what it spells, and its classification can arrive at its close.

So put the author's reading exactly where the parser's classification already lands: **at the run's close, attached.**

```udon
|reg :mask 0xff<u64>
|job :timeout 5<min> :length 5<m>
|ev :on 2026-07-21<date> :at 10:12<time>
```
````tree
root
  |reg
    :mask ⸨0xff⸩ as u64
  |job
    :timeout ⸨5⸩ #integer as min
    :length ⸨5⸩ #integer as m
  |ev
    :on ⸨2026-07-21⸩ as date
    :at ⸨10:12⸩ as time
````

The value is still its spelling, so identity by spelling holds. The reading is an attachment that changes no arity, the same shape as the parser's `#integer`. **The tree has one place for "how to read this", and the parser and the author both write into it.**

## The rule, as a card might say it (a draft, not a proposal yet)

1. **Where a reading attaches.** At the end of a bare run, `<` with no space before it, then a «label» (letter first), optional `[key]`s and `.trait`s, then `>`, then the run's end. That is the run's **reading**. The run's text is everything before the `<`.
2. **The guard.** A run that begins with a letter never takes a reading: `Vec<u8>` and `Option<String>` stay text. *Words are read by their slot; numerals and symbols can say how they're read.* (Natural language does the same: numeral classifiers and units attach to numbers, not to words.)
3. **Readings lite checks.** A reading that names a standard-set class (`integer`, `decimal`, `boolean`, `nil`) is an assertion. If the text doesn't spell it, that's an error that suggests the fix. Any other reading is carried unread, for whatever reads that name.
4. **`<>` alone is nil:** nothing, read as nothing.

## The composite set

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup <>
|part :zip 01234 :version 1.10 :commit 1234567<sha> :id 1e10<id>
|book :title 1984 :year 1949
|book :title 1984 is a novel :year 1949
|box :width 920<px> :margin 1.5<em> :opacity 50%
|svc :port ssh
|clock :now 2026-07-21T14:20<datetime> :window 60<s>
|dt :on 05-03-27<dt[DD-MM-YY]>
|words :w "nil" :none nil :empty ""
|nums :ints [1 2 3] :mix [1 two 2026-07-21<date>]
|step[3]
|insist :port 8080<integer> :typo 8O80<integer>
|misc :color #3221f9<color> :price 9.99<USD> :at 40.71,-74.00<geo> :type Vec<u8>
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :enabled ⸨true⸩ #true
    :weight ⸨0.75⸩ #decimal
    :backup nil
  |part
    :zip ⸨01234⸩
    :version ⸨1.10⸩ #decimal
    :commit ⸨1234567⸩ #integer as sha
    :id ⸨1e10⸩ #decimal as id
  |book
    :title ⸨1984⸩ #integer
    :year ⸨1949⸩ #integer
  |book
    :title ⸨1984 is a novel⸩
    :year ⸨1949⸩ #integer
  |box
    :width ⸨920⸩ #integer as px
    :margin ⸨1.5⸩ #decimal as em
    :opacity ⸨50%⸩
  |svc
    :port ⸨ssh⸩                       ← a word: its slot reads it (`port = u16 | standard-port`)
  |clock
    :now ⸨2026-07-21T14:20⸩ as datetime
    :window ⸨60⸩ #integer as s
  |dt
    :on ⸨05-03-27⸩ as dt
      :$key ⸨DD-MM-YY⸩                ← the key on the reading: which dt
  |words
    :w "nil"
    :none ⸨nil⸩ #nil
    :empty ""
  |nums
    :ints [⸨1⸩ #integer ⸨2⸩ #integer ⸨3⸩ #integer]
    :mix [⸨1⸩ #integer ⸨two⸩ ⸨2026-07-21⸩ as date]
  |step
    :$key ⸨3⸩ #integer
  |insist                                ← error at :typo, so no tree; :port alone would be
    :port ⸨8080⸩ #integer as integer      (the assertion held)
  |misc
    :color ⸨#3221f9⸩ as color
    :price ⸨9.99⸩ #decimal as USD
    :at ⸨40.71,-74.00⸩ as geo
    :type ⸨Vec<u8>⸩                   ← letter-led: no reading, plain text
````

The `:typo` error would read: "`8O80` doesn't spell an integer (the `O` after `8`); did you mean `8080<integer>`?"

**The three composite lines:**

```udon
|server[web] :port 8080 :timeout 30<s> :started 2026-07-21T14:20<datetime> ; prod
|p Chapter 3: The Return
  See |{a :href /x the docs} for more ;{link checked}.
|cfg :tags [1 two 2026-07-21<date>]
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ⸨30⸩ #integer as s
    :started ⸨2026-07-21T14:20⸩ as datetime
      ; prod
  |p
    :$main ⸨Chapter 3: The Return⸩
    ⸨See |{a …} for more ;{link checked}.⸩
  |cfg
    :tags [⸨1⸩ #integer ⸨two⸩ ⸨2026-07-21⸩ as date]
````

## What I find beautiful in it, and why

- **The domain comes first.** You read `5`, then that it's minutes. The plumbing trails, as ruby trails its base; on a fast scan you can skip every `<…>` and still have the data. Under `<dur: 5m>` you read the plumbing first.
- **One place for "how to read this".** The parser's classification and the author's reading land in the same spot on the tree, at the same moment (the run's close). F1 went from a defensive finding to a design principle: a value's reading arrives at its end, whoever supplies it.
- **Joseph's slot-vs-literal distinction gets one mark in two positions.**
  - `:port<u16> 8080`: the *slot* is u16. This is the slots fork's reserved spelling, kept an error in lite until the slot layer exists.
  - `:port 8080<u16>`: *this literal* is u16.

  Same bracket, and the position tells you which of his two questions it answers. I find that the most beautiful thing on this page.
- **Units read as a physicist writes them.** `5<min>` is {Q}[Q], and `5<min>` / `5<m>` puts the minutes-or-meters disambiguation exactly where a reader looks for it. Units stay bare (`5m`) when the slot knows; the reading appears only when the author must say it. That is an accidental in the musical sense (see I3).
- **Lists stop being a problem.** `[1 two 2026-07-21<date>]` has no inner spaces, so no matched-bracket protection is needed inside a list item, unlike `<date: 2026-07-21>`, whose space inside a list item needed the brackets to protect it.
- **The guard is the natural-language rule.** "Numbers and symbols can carry a reading; words can't" is how human notations already behave, and it keeps code in values (`Vec<u8>`, `List<int>`) as plain text.

## Then the weighing (CTQ-FACTORS, Beauty first; hypotheses)

Scored against the parent's lead composition (Cc + `<…>` closed + `<name: body>`), factor by factor, −2…+2. Totals are in [scores.py](scores.py).

| Factor | Δ | Basis |
|---|---|---|
| A1 agent-subjective | +1 | taste, above; medium confidence |
| A2 generative guessability | +1 | units in angle brackets after numbers (F#) and type parameters after names (`List<int>`) are strong priors; `<dur: 5m>`'s colon-space is not. I'd guess `0xff<u64>` after one example. Medium. |
| A3 cold comprehension | +1 | `2026-07-21<date>` reads "a date"; attached-after reads as a type, unlike a free-standing `<date>`, which reads as a placeholder (my strongest prior) |
| A5 domain-forward | +1 | value first |
| A6 spec clarity | +1 | one position for every reading; replaces the prefix notation table |
| A7 syntactic simplicity | 0 | the letter-first guard is an exception (−); dropping the labeled prefix form is a removal (+) |
| B3 stability | −1 | a residual silent case: a non-letter-led run that really ends in `<label>` text (`:expr 2<n>`, `:tag 3<br>`). Rare by my instinct, but silent. |
| B1 bounded streaming | 0 | the `<label>` at a run's end must be held from `<` until `>` and the terminator: token-bounded, like any element name. Same posture as ANG-4c's letter-led interior. Needs Joseph's yes on "token-bounded is bounded". |
| B6 headroom | 0 | spends attached-postfix `<…>` on non-letter runs; frees the prefix labeled form |
| C4 types, notations, units | +1 | units and host types read naturally |
| C2 XML/HTML | 0 | prose untouched; an HTML-ish value is quoted anyway |

**Where it's weak, honestly:** it can't type anything inside prose (prose keeps `<` for HTML and Markdown); I2 or inline elements do that. And a reading on a word (`ssh<port>`) is refused by design, which an author might want; the slot is the answer the guard gives them.

**Unfinished:** whether `8080<integer>` and ANG-4c's prefix `<8080>` both survive (two spellings of assertion), or the prefix form goes entirely, leaving only `<>` for nil. My lean is that the prefix goes: one place for readings.
