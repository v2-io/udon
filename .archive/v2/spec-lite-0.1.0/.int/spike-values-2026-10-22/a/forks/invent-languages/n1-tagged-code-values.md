# N1: tagged code values, the Elixir sigil made beautiful

*Invention fork of spike a, 2026-10-22. Invented first, judged after. Trees: `⸨…⸩` a «text», `"…"` a «string», `⟬…⟭` raw carried content, `#integer` a classification attached to a text (spike a's lead, "Cc"); `code NAME` is a placeholder for the new node. All illustrative.*

## Where it comes from, and what it became

Elixir writes a date as `~D[2026-07-21]`, a regex as `~r/^\d+$/i`, and a word list as `~w(a b c)`. Three things in that are good:

- a value names how it is to be read;
- the body is raw, so a regex needs no doubled backslashes;
- modifiers trail the body.

Three are not:

- the tilde is noise;
- the names are one cryptic letter;
- there are eight delimiters to pick from, each picked only to dodge an escape.

JavaScript's tagged templates (`` sql`select …` ``) and Markdown's code spans (`` `make all` ``) each found half of a better answer. A label touching a backtick names the reader, and backticks mean "verbatim" to every agent that has read Markdown. Markdown's own rule ("N backticks open, the next run of exactly N closes") replaces Elixir's delimiter menu.

**The invention: a label touching a run of backticks is a value whose body is carried verbatim, for whatever reads that label.**

```udon
:when date`2026-07-21`
:pattern re.i`^\d{3}-\d{4}$`
:reg u64`0xff`
:snippet js``let s = `x`;``
```

It is the fence, at the size of a value. A fence is "N ≥ 3 backticks, a language name, a verbatim body, N backticks". This is "a name, N backticks, a verbatim body, N backticks". The traits Elixir put after the body as modifiers (`~r/…/i`) go on the name, where lite traits already say what kind of thing something is (`re.i`). A head can carry a key for parameters, read by the element-head rules: `` dt[DD-MM-YY]`05-03-27` ``.

## The rule, as a card might state it (sketch)

1. In a value position (an attribute's value, a list item, a key), a bare «label», optionally followed by `[key]`s and `.trait`s, **touching** a run of N backticks, opens a **code value** named by that label. Its body is every character up to the next run of exactly N backticks on the same line. Markdown's one rule applies: if the body both starts and ends with a space, one space is stripped from each end.
2. The body is raw: no escapes. A body that holds a backtick uses a longer run.
3. Lite carries the name, key, traits and body, and reads nothing. A handler for the name may (as with fences, [[rule:fence-default-handler]]).
4. An unclosed run on the line is an error: "lite doesn't support a newline in a code value".
5. A backtick that isn't touched by a label at a value's start is text, as it is in prose, so Markdown inline code in `$main` text stays Markdown.

**The decision point:**
- It is reached at the first backtick, after a label token: the same bound as every element name.
- Until then the run is a bare run whose characters already streamed.

## Rendered on the composite set (under Cc for bare values)

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup nil
|part :zip "01234" :version v`1.10` :commit "1234567" :id "1e10"
|book :title 1984 :year 1949
|book :title 1984 is a novel :year 1949
|decision :date date`2026-07-21` :at time`10:12` :window dur`60s` :stamp datetime`2026-07-21T14:20`
|box :width 920px :margin 1.5em :opacity 50%
|job :timeout dur`5m` :length len`5m`
|svc :port ssh
|reg :value u64`0xff`
|ev :on dt[DD-MM-YY]`05-03-27`
|words :w "nil" :none nil :empty ""
|p :xml:lang en
  See |{a :href /x the docs}.
|raw :html html`<b>bold</b> & <i>it</i>`
|nums :ints [1 2 3] :tags [a b c]
|step[3]
|misc :color color`#3221f9` :price money`9.99 USD` :at geo`40.71 -74.00`
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
    :zip "01234"
    :version code v ⟬1.10⟭
    :commit "1234567"
    :id "1e10"
  |book
    :title ⸨1984⸩ #integer
    :year ⸨1949⸩ #integer
  |book
    :title ⸨1984 is a novel⸩
    :year ⸨1949⸩ #integer
  |decision
    :date code date ⟬2026-07-21⟭
    :at code time ⟬10:12⟭
    :window code dur ⟬60s⟭
    :stamp code datetime ⟬2026-07-21T14:20⟭
  |box
    :width ⸨920px⸩
    :margin ⸨1.5em⸩
    :opacity ⸨50%⸩
  |job
    :timeout code dur ⟬5m⟭
    :length code len ⟬5m⟭
  |svc
    :port ⸨ssh⸩
  |reg
    :value code u64 ⟬0xff⟭
  |ev
    :on code dt
      :$key ⸨DD-MM-YY⸩
      ⟬05-03-27⟭
  |words
    :w "nil"
    :none ⸨nil⸩ #nil
    :empty ""
  |p
    :xml:lang ⸨en⸩
    ⸨See |{a …}.⸩
  |raw
    :html code html ⟬<b>bold</b> & <i>it</i>⟭
  |nums
    :ints [⸨1⸩ #integer ⸨2⸩ #integer ⸨3⸩ #integer]
    :tags [⸨a⸩ ⸨b⸩ ⸨c⸩]
  |step
    :$key ⸨3⸩ #integer
  |misc
    :color code color ⟬#3221f9⟭
    :price code money ⟬9.99 USD⟭
    :at code geo ⟬40.71 -74.00⟭
````

**K14, insisting on a number.** `` num`8080` `` names a reader that will refuse `8O80`, but lite itself can't, because lite reads nothing. If lite should catch the typo, keep `<8080>` as a closed assertion beside this; that is the angle fork's ANG-3, and the two compose. Or let lite's own default handler know the standard set's names (`` num`…` ``, `` int`…` ``) and error. *Not sure which I like; see below.*

**The composite lines:**

```udon
|server[web] :port 8080 :timeout dur`30s` :started datetime`2026-07-21T14:20` ; prod
|p Chapter 3: The Return
  Run `make all` first, then see |{a :href /x the docs} ;{checked 10-21}.
|cfg :tags [1 two date`2026-07-21` geo`40.71 -74.00`]
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout code dur ⟬30s⟭
    :started code datetime ⟬2026-07-21T14:20⟭
      ; prod
  |p
    :$main ⸨Chapter 3: The Return⸩
    ⸨Run `make all` first, then see |{a …} ;{checked 10-21}.⸩     ← prose: the Markdown code span is untouched
  |cfg
    :tags [⸨1⸩ #integer ⸨two⸩ code date ⟬2026-07-21⟭ code geo ⟬40.71 -74.00⟭]
````

The `geo` body has a space inside, and the list still has four items, because a code value ends itself.

## What I find beautiful in it, and why

- **One idea at two sizes.** Lite already has "a name, then verbatim content in backticks" for blocks. Seeing `` sh`ls -la` `` beside a ```` ```sh ```` fence, a reader needs nothing new: same characters, same meaning, smaller. That is the "small set of special characters, chosen well" in its strongest form, since it adds no character at all.
- **The backtick already means what it does here.** Every agent I can imagine reads `` `…` `` as "verbatim, don't interpret me". The tag says who *will* interpret it. JavaScript tagged templates read exactly so; I've never met one I misread.
- **No escapes, ever.** `` re`^\d+$` `` is the regex as it is written everywhere else. The opaque-span card's accepted cost ("regexes and Windows paths double their backslashes") disappears.
- **The domain word leads.** `` date`…` ``, `` money`…` ``, `` geo`…` `` read like spoken English: "date: 2026-07-21". The plumbing is two light ticks.
- **Elixir's modifiers find a home that means something.** `re.i` reads as "an `re`, of the `i` kind", which is what a trait is.
- **`<…>` is freed.** Nothing here needs it, so a later UDON gets the whole bracket pair back: for references, templating, or whatever it turns out to be.

## What makes me unsure (judged after)

- **Backticks are light on the page.** In an unhighlighted 120-column line, `` dur`30s` `` is quieter than `<dur: 30s>`. That's beauty to me, but it is a readability cost to someone scanning fast.
- **The asymmetry with fences.** A fence puts the name *after* the backticks (```` ```sh ````); this puts it *before*. I chose "before", because an untagged `` `make all` `` can't tell a tag from content (`make` as a name or as a word?). A single-line fence form, `` `date 2026-07-21` ``, would mirror fences exactly but make every plain code span ambiguous. I'd like Joseph's eye on whether the asymmetry reads as a flaw or as "tagged templates are their own thing".
- **Abbreviation pressure.** `dur`, `dt`, `len`, `u64`: names want to be short when they sit inline. A shared vocabulary of names is the real work, and it isn't lite's.
- **Plumbing where a slot type would do.** `` :timeout dur`5m` `` says twice what `:timeout 5m` plus a schema says once. It is for documents with no schema, which is exactly where Joseph wants marks only to disambiguate.
- **`date`… touching a backtick inside ordinary text.** For example `:note use`make`` (a typo for `use `make``). Rare, and it parses as a code value named `use`. That is a silent miss, but I can't produce a plausible case where it bites.
