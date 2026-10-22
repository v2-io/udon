# I1. Readings: ruby for values, `⟪…⟫`

*Invention fork (typography), spike a, 2026-10-22. Invent first, judge after: the rendering and what I find beautiful come before any weighing. Tree glyphs: `⸨…⸩` a «text», `"…"` a «string», `#integer` the parser's own classification, `⟪date⟫` a reading. All illustrative.*

## Where it comes from

In Japanese typesetting, **ruby** (furigana) sets a small gloss beside the base text that says *how to read it*. The base is what is written; the ruby is how it is read. Plain-text Japanese has a convention for this, the Aozora Bunko format: base text followed by `《reading》`.

That is Joseph's fourth distinction exactly: "how it's literally written here" vs "how it's read and what processing is available". It is also what the spike's F1 finding put into the tree without naming it. Under text-plus-class, every bare value is already **a base plus a reading**: the parser attaches the reading (`#integer`) when the run closes. This invention lets the writer state the reading, in the same place in the tree, with a glyph made for it.

`《…》` itself is ruled out: it is double-width, and in Chinese it marks book titles (`《红楼梦》`), so a title value would collide. Its mathematical cousin `⟪…⟫` (U+27EA/B, MATHEMATICAL DOUBLE ANGLE BRACKET, narrow, checked in the UCD) carries the same shape with no prose use I know of.

## The rule, as I'd make it

1. **A reading follows a value directly:** `value⟪name params…⟫`. The base is spelled as it always is; the reading attaches to it and changes no arity.
2. **In a bare run, `⟪` ends the run.** A literal `⟪` inside a run is `\⟪`. The base still streams from its first character; the reading arrives after, exactly where the parser's own classification would. Nothing is held.
3. **If the reading names one of lite's own classes, lite checks it.** `8080⟪integer⟫` is checked; `8O80⟪integer⟫` is an error: "doesn't spell an integer; did you mean `8080`?". Any other name is carried unread for whatever reads that name, as a fence's body is for its handler.
4. **An explicit reading replaces the implicit one,** so a reading can also *withhold* a number: `1.10⟪version⟫` is never classified as a decimal.
5. **The same mark on an attribute name gives a reading to every value of that occurrence:** `:dates⟪date⟫ [2026-07-21 2026-08-01]`. This is the key signature, and a reading on a single value is the accidental. The most specific wins, as in music.

## The composite set

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup nil
|part :zip 01234 :version 1.10⟪version⟫ :commit 1234567⟪sha⟫ :id 1e10⟪id⟫
|book :title 1984 :year 1949
|book :title 1984 is a novel :year 1949
|decision :date 2026-07-21⟪date⟫ :at 10:12⟪time⟫ :window 60s⟪duration⟫ :stamp 2026-07-21T14:20⟪datetime⟫
|box :width 920px⟪length⟫ :margin 1.5em⟪length⟫ :opacity 50%
|job :timeout 5m⟪duration⟫ :length 5m⟪length⟫
|svc :port ssh⟪port⟫
|reg :value 0xff⟪u64⟫
|ev :on 05-03-27⟪dt DD-MM-YY⟫
|words :w "nil" :none nil :empty ""
|nums :ints [1 2 3] :tags [a b c] :days⟪date⟫ [2026-07-21 2026-08-01]
|step[3]
|insist :port 8080⟪integer⟫
|misc :color 3221f9⟪rgb⟫ :price 9.99⟪USD⟫ :at 40.71,-74.00⟪geo⟫
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :enabled ⸨true⸩ #true
    :weight ⸨0.75⸩ #decimal
    :backup ⸨nil⸩ #nil
  |part
    :zip ⸨01234⸩
    :version ⸨1.10⸩ ⟪version⟫          ← the reading withholds the decimal
    :commit ⸨1234567⸩ ⟪sha⟫
    :id ⸨1e10⸩ ⟪id⟫
  |book
    :title ⸨1984⸩ #integer              ← still the identifier hazard, unless written 1984⟪title⟫ or "1984"
    :year ⸨1949⸩ #integer
  |book
    :title ⸨1984 is a novel⸩
    :year ⸨1949⸩ #integer
  |decision
    :date ⸨2026-07-21⸩ ⟪date⟫
    :at ⸨10:12⸩ ⟪time⟫
    :window ⸨60s⸩ ⟪duration⟫
    :stamp ⸨2026-07-21T14:20⸩ ⟪datetime⟫
  |box
    :width ⸨920px⸩ ⟪length⟫
    :margin ⸨1.5em⸩ ⟪length⟫
    :opacity ⸨50%⸩
  |job
    :timeout ⸨5m⸩ ⟪duration⟫           ← the unit's half-claim, completed in the document
    :length ⸨5m⸩ ⟪length⟫
  |svc
    :port ⸨ssh⸩ ⟪port⟫
  |reg
    :value ⸨0xff⸩ ⟪u64⟫
  |ev
    :on ⸨05-03-27⸩ ⟪dt ⸨DD-MM-YY⸩⟫
  |words
    :w "nil"
    :none ⸨nil⸩ #nil
    :empty ""
  |nums
    :ints [⸨1⸩ #integer ⸨2⸩ #integer ⸨3⸩ #integer]
    :tags [⸨a⸩ ⸨b⸩ ⸨c⸩]
    :days [⸨2026-07-21⸩ ⸨2026-08-01⸩] ⟪date⟫   ← one reading for the occurrence, given to each value
  |step
    :$key ⸨3⸩ #integer
  |insist
    :port ⸨8080⸩ ⟪integer⟫ ✓          ← a class lite owns, checked
  |misc
    :color ⸨3221f9⸩ ⟪rgb⟫
    :price ⸨9.99⸩ ⟪USD⟫
    :at ⸨40.71,-74.00⸩ ⟪geo⟫
````

(Drafting this tree I closed one text with `⟫` instead of `⸩` without noticing: these brackets are close kin. See "What frightens me".)

**The composite lines:**

```udon
|server[web] :port 8080 :timeout 30s⟪duration⟫ :started 2026-07-21T14:20⟪datetime⟫ ; prod
|p Chapter 3: The Return
  Doors open at |{time 19:30} ;{local time} sharp.
|cfg :tags [1 two 2026-10-22⟪date⟫]
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ⸨30s⸩ ⟪duration⟫
    :started ⸨2026-07-21T14:20⸩ ⟪datetime⟫
      ; prod
  |p
    :$main ⸨Chapter 3: The Return⸩
    ⸨Doors open at |{time ⸨19:30⸩} ;{local time} sharp.⸩
  |cfg
    :tags [⸨1⸩ #integer ⸨two⸩ ⸨2026-10-22⸩ ⟪date⟫]
````

**Prose keeps no readings.** In prose there is no telling which preceding word a reading would gloss (is it `19:30` or `at 19:30`?), so readings stay out of prose and an inline element does the job there. This keeps "Markdown in prose stays Markdown" untouched.

## What I find beautiful, and why

- **The datum comes first.** `2026-07-21⟪date⟫` reads the way a typeset quantity does: the value stands, and the gloss trails it, smaller in weight. In `<date: 2026-07-21>`, the plumbing leads and the domain follows. Of all the inventions, this one leans hardest toward "the domain's model shows, not the plumbing".
- **One idea where there were three.** The parser's classification, the writer's notation, and the unit's missing dimension are all *a reading of a base*. They live in the same place in the tree, written with the same glyph or computed into it. `5m⟪duration⟫` is where I felt it click: the reading is exactly the half of the unit the literal couldn't say.
- **The key signature and the accidental.** One mark: on a name it reads every value of the occurrence, on a value it reads that value. Lists of dates stop repeating themselves.
- **It frees `<…>` completely.** Asserting is `⟪integer⟫`, carrying is `⟪date⟫`, nil is bare `nil`. `<…>` can go back to full UDON with none of its seven jobs, or keep only `<>`. As headroom, this is the cleanest outcome any branch reached.
- **The suffix is cheap here, where it wasn't before.** The angle fork killed suffix labels because they "decide late". Under text-plus-class, nothing is decided late: the base is a text whatever follows, and a reading is a trailer, like the classification. The finding that made B and the view equal also makes suffix annotation free.
- **The glyph is quiet.** `⟪ ⟫` is narrow, symmetric and unlike anything else in lite, so it reads as "aside", not as structure.

## What frightens me

- **`⟪` vs `«` vs `<<`.** In some monospace fonts `⟪` looks like `«`, and I mis-closed a bracket while drafting the tree above. A writer who types `«date»` should get a warning: "did you mean `⟪date⟫`?".
- **No agent will invent it unprompted.** It costs generative guessability from zero exposure. My guess is that after one example agents copy it reliably: it's a single distinctive token pair, and the meaning is visible in the name inside it.
- **Readings can sprawl.** A writer may gloss everything (`web⟪hostname⟫`). That is A10 self-description creeping back, which Joseph weighted low on purpose. The defense is the key signature, and a schema that makes readings unnecessary.
- **The `1984` title stays a hazard** unless a reading or quotes are written. Readings don't fix the default; they give the writer a cheap, domain-named way to correct it.

## Weighed against CTQ-FACTORS (after the fact; my hypotheses)

| Factor | Score | Basis |
|---|---|---|
| A1 agent-subjective | 9 | my strongest beauty response of the inventions, for the reasons above |
| A2 generative guessability | 5 | invisible from zero exposure; probably strong after one example |
| A3 cold comprehension | 8 | the name inside says what it is; reads as an annotation |
| A4 agentic readability | 7 | distinctive glyph; the `«`/`⟪` confusion is the risk |
| A5 domain-forward | 9 | datum first, gloss after; key signatures remove repetition |
| A6 spec clarity | 8 | one concept: every value is a base and an optional reading |
| A7 syntactic simplicity | 8 | one new terminator in bare runs, one attachment |
| A8 parsimony | 8 | one pair spends no ASCII; `<…>` can be returned |
| B1 bounded streaming | pass | the base streams; the reading is a trailer bounded by its `⟫` |
| B2 reserve, don't ignore | pass | if carrying a named reading is like carrying a fence body (the spike's §5 question) |
| B6 headroom | 9 | frees `<…>` entirely |
| C4 types, notations, units | 9 | every K item renders, including `5m` both ways and `dt DD-MM-YY` |
| C10 round-trip | 9 | the base is never touched |
