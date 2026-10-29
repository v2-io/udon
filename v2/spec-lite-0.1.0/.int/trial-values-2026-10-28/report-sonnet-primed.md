*Saved by the coordinator from the agent's returned message. The harness refused the agent's own write; offered a renamed file, the agent declined, judging a renamed findings file to be a way around the block rather than a way of honoring it. Content as returned.*

# Trial report: Sonnet 5.5, primed (lite spec read before COLD)

**What I read.**
- `BASICS.md`, `CTQ-FACTORS.md` and `main.outline.md`.
- Value-related cards in `def/` and `src/`: typed-value, value, text, string, opaque-span, delimited-string, embed, main, key, unquoted-run-is-one-value, nil-spelling, text-value-end, leftover-values, line-scan, list-items, key-holds-a-value, element-values, value-line-escapes, main-label-colon-warns, opaque-span-raw-text, opaque-span-escapes.
- For the cards I stopped at "Working notes", except `def-typed-value`, which I read whole. It includes a vocabulary lean from a coordinator agent, nothing on these four questions.
- I did not open `.int/` and did not read other agents' reports.

## Part 0: COLD answers, verbatim as first written

*(Context: these are BASICS plus the current cards plus instinct, not BASICS alone. Where a card drove an answer I said so.)*

### Write

**1. Mass 3.2 kg, temperature 21.5 °C**
```udon
|sample :mass 3.2 kg :temp 21.5 °C
```
Unit as the tail of the value, separated by a space. I'd hesitate over `:mass 3.2` + `:mass-unit kg` (more structured, more verbose) and over `3.2kg` (no space). I picked the space form because it is how I would write it in prose and because the cards say an unquoted run is one text that nothing rejects. What I'd want to know: does the consumer ever get a number and a unit separately, or only the text `3.2 kg`?

**2. Event on 1 October 2026, 90 minutes, starting 14:30 in Denver**
```udon
|event :date 2026-10-01 :start 14:30 :tz America/Denver :duration 90 min
```
Split across attributes; ISO date, 24h time, IANA zone name, duration as number-plus-unit. Alternatives I considered and would not be surprised to see other agents write: `:start 2026-10-01T14:30 :zone America/Denver`, and `:duration PT90M`. I'd hesitate on "Denver" (city versus `America/Denver` versus `MT`), and I'd want a rule for whether dates and times have a spelling of their own. From the cards I know there is `<…>` and that lite attaches no meaning to it, so I deliberately did not reach for it.

**3. Regex `^\d{3}-\d{4}$` and Windows path `C:\Users\me`**
```udon
|rule :pattern '^\d{3}-\d{4}$'
|file :path 'C:\Users\me'
```
Single quotes, because the BASICS line says `"…"` has Ruby-like escapes, which implies `\d` and `\U` are trouble there, and I'm assuming `'…'` is Ruby-like too (backslash mostly literal). What I'd want: one sentence saying exactly which backslashes `'…'` treats specially. I would not write these unquoted.

**4. Server: localhost, port 8080, debug off, retries 3, owner explicitly null**
```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner nil
```
I wrote `nil` because the cards say so. Honest note: from BASICS alone I would have written `null` (JSON habit) and not known it was wrong; I'd have hesitated over `nil` versus `null` versus `~` versus `:owner` with no value. I wrote `8080`, `false`, `3` bare. I do not know whether a consumer sees numbers and a boolean or the texts `8080`, `false`, `3`, and I'd want to be told.

**5. A paragraph: someone says "Hello," and the sentence continues: she said.**
```udon
|p
  "Hello," she said.
```
Body as prose on the next line, deliberately avoiding `|p "Hello," she said.` because a leading `"…"` on an element's line is a quoted value and `she said.` would be left over as a second value. In prose a quote is just a character, so the indented line is safe. This is the one I'd expect other agents to get wrong in the one-line form, and I'd be unsure whether `|p \ "Hello," she said.` works (a framed backslash with nothing before it); I would not try it without being told.

**6. A list of three holiday dates**
```udon
|calendar :holidays [2026-12-25 2027-01-01 2027-07-04]
```
Bare ISO dates in a `[…]` list. Alternative if the dates need to carry anything else (names, observed-on): child elements, `|holiday 2026-12-25 :name Christmas`. I'd want to know whether the list items are strings, texts or dates, and if I cared I'd quote them.

**7. Version 1.10 (string) and zip 01234**
```udon
|part :version "1.10" :zip "01234"
```
Quoted, by YAML/JSON reflex: bare `1.10` could become 1.1 and bare `01234` could become 1234 or octal. I know from the cards that a bare run is text and so quoting is probably unnecessary, but "probably unnecessary" is not enough for a value where the failure is silent, so I quote.

**8. HTML-ish link: target `https://example.com`, text "Click here"**
```udon
|a :href "https://example.com" Click here
```
Quoted target, then the leftover text lands in `$main`. The BASICS form is `|a :href https://example.com \ Click here`; I'd use it if I trusted myself to remember the framed backslash, but forgetting it silently makes `href` swallow the link text, while forgetting the quotes in the quoted form is harmless. Inline in a sentence I'd write `See |{a :href "https://example.com" Click here} now.`

### Read

```udon
|p "Hello," she said.
```
`p` gets two `$main` values: the string `"Hello,"` then the text `she said.` (stacked). Sure, about 80%; it is the trap line, and a careless reader sees one sentence. I'd flag it as the line most likely to be misread.

```udon
|sample :mass.kg 3.2
```
Meaning, which I'm confident of (90%): mass is 3.2, in kilograms. Tree shape, which I'm not (about 45%): an attribute literally named `mass.kg` with value 3.2, versus attribute `mass` carrying a trait or unit `kg`, versus an error because `.` is not valid in an attribute name. BASICS gives `.word` only after an element name.

```udon
|sample :mass(kg) 3.2
```
Same intended meaning as above (90%). Tree shape: about 40%. I'd guess an attribute named `mass(kg)`, or `mass` with a `(kg)` annotation in the KDL manner. Nothing in BASICS licenses either.

```udon
|ev :on date(2026-10-01)
```
`on` gets the plain text `date(2026-10-01)`, read by me as a date-constructor look; 70% that that is all it is lexically (a text), 90% that the writer means a date.

```udon
|ev :on ~date 2026-10-01
```
Lexically, 60%: the text `~date 2026-10-01`. Meaning: `~date` marks the type of what follows, a date, 55%. I'd not be confident whether `~date` is a marker the parser knows or just characters.

```udon
|h3 date(format)
```
Heading whose `$main` is the text `date(format)`, a heading about a function. 85%. If any option gives `word(…)` a meaning, this is the false-positive check and I'd expect it to stay text.

```udon
|config :server.port 8080
```
An attribute named `server.port`, value 8080 (a flat dotted name, not nested); 60%. The alternative, nested `server` → `port`, 25%. Note that this has exactly the shape of `:mass.kg 3.2` and the two read differently to me: one as a path, one as a unit. That is the friction.

```udon
|server :host: localhost
```
A YAML-habit slip. Two readings, about 45% each: an attribute named `host:` with value `localhost`; or attribute `host` with the value `: localhost`. Either way I'd expect a warning or error at some point, and I would not trust the tree. Intended meaning (host is localhost) 95%.

```udon
|li printf(x) prints x
```
`$main` is the text `printf(x) prints x`; 85%. Same false-positive check as `|h3 date(format)`.

*(End of verbatim COLD section. Everything below was written after seeing `OPTIONS.md`.)*

## Part 1: Writing under the options

### Science data table (Q1)

```udon
; A
|run[r1] :mass.kg 3.2 :temp.degC 21.5 :speed.m/s 0.8 :taken.datetime 2026-10-01T14:30Z
; B
|run[r1] :mass(kg) 3.2 :temp(°C) 21.5 :speed(m/s) 0.8 :density(kg/m³) 998 :taken(datetime) 2026-10-01T14:30Z
; C
|run[r1] :mass qty(3.2 kg) :temp qty(21.5 °C) :speed qty(0.8 m/s) :taken datetime(2026-10-01T14:30Z)
```

**Friction**
- **A, unit characters.** I hesitated on `.°C`, `.m/s` and `.kg/m³`: are `°`, `/` and `³` legal in a label? The sheet itself spells the unit `degC` under A and `°C` under B, which suggests A can't comfortably hold real unit spellings. B's parentheses hold anything, including `(L min^-1)`.
- **A, dot and arguments.** I hesitated on `:when.date(YY-MM-DD pivot 1950)`. It is a dot, then a kind, then arguments in parentheses. I wasn't sure the dot form was supposed to take arguments.
- **C, repetition.** With 20 rows and three columns, `qty(` appears 60 times. A schema fixes that, but the sheet says so only in a note. A and B repeat `.kg` or `(kg)` per row too, only shorter.
- **Name-side kinds type a whole list.** The sheet doesn't show this, but B gives `:holidays(date) [2026-12-25 2027-01-01 2027-07-04]` and `:mass(kg) [3.2 3.4 3.1]` for free. A gives it too. C can't without repeating the kind on every item.

### Config file (Q1, Q4)

```udon
; A names, Q4-A
|service[api] :host localhost :port 8080 :debug false
  :db.pool.size 10
  :timeout.s 30
  :owner nil
; B names, Q4-B
|service[api] :host: localhost :port: 8080 :debug: false
  :timeout(s): 30
  :mem(MiB): 512
  :owner: nil
```

**Friction**
- **A hijacks dotted config keys.** Under A, `:db.pool.size 10` is attribute `db` with kind `pool.size`, or something else I can't tell. Agents will write `spring.datasource.url`-style keys from habit. B and C leave dotted names alone. I'd expect this to be the commonest silent miss in config contexts under A.
- **Q4-B plus name-side kinds.** `:timeout(s): 30` has two decorations on one name and reads heavier than `:timeout(s) 30`. B also doubles the colons visually.
- **Q4-B and `$main`.** An optional colon on `:host:` doesn't help `|server host: localhost`. That still needs the existing warn rule, so the colon leniency is only half of the habit being served.

### HTML page (Q2, Q3)

```udon
|article.post :lang en
  |h1 Release notes
  |h3 date(format)
  |p "Fast," he said, "and correct."
  |p "Ship it."
  |p Published |{time :datetime 2026-10-01 \ 1 October} by |{a :href "/jw" \ Joseph}.
  |p Run `ls -l` now.
  |li `ls -l`
  |img :src /logo.png :alt "Logo" :width(px) 320
```

**Friction**
- **`|p "Ship it."`.** Under Q2-A this is a string, so a renderer that reads the tree drops the quote marks from the paragraph. That is silent content loss. The body-prose spelling of the same words keeps the quotes. Under Q2-B the quotes stay in the text.
- **`|h3 date(format)`.** Under Q3-A this is a typed value alone, not a heading about a function. Adding any trailing word flips it back to text: `|h3 date(format) reference`.
- **`|li `ls -l``.** The options sheet says backticks standing alone are verbatim foreign text. A list item that is just a Markdown code span then loses its Markdown meaning, against the "Markdown in prose stays Markdown" factor in CTQ. Appending a word flips it back.
- **Q2 plus a link idiom.** My COLD answer 8, `|a :href "https://example.com" Click here`, becomes under Q2 one text with quote marks inside the `href`. That is wrong and silent. Only `... "https://example.com" \ Click here` survives.
- **Vue and Alpine attribute names.** `v-model.trim`, `@click.prevent` and `x-on:click.outside` contain dots. Under A the dot reads as a kind, so these need quoted names. Angular's `(click)` begins with a parenthesis and needs quoting under B as well. Both options therefore claim a character that real HTML attribute names use.

### Notes file with dates in prose (Q3)

```udon
; C
|note[2026-10-28]
  Met Marta on |{date 2026-10-26}; follow-up due |{date 2026-11-02}.
  Call ran |{duration 45min}, budget |{qty 1200 EUR}.
; A or B: prose can't carry the kind, so the dates move to attributes
|note[2026-10-28] :met date(2026-10-26) :due date(2026-11-02)
  Met Marta; follow-up due Nov 2.
|note[2026-10-28] :met ~date 2026-10-26 :due ~date 2026-11-02
  Met Marta; follow-up due Nov 2.
```

**Friction**
- **A and B cannot mark a date mid-sentence.** `date(2026-10-26)` inside running text is not standing alone, so it is text. `~date` inside running text is not in a value position. In both cases the writer gets no error. I'd want a default-on warning for a `name(...)` that sits inside text.
- **Duplication.** A and B force the author to state the date twice, once in an attribute and once in prose. C keeps it where the author said it, at a cost of about two characters (`|{date 2026-10-26}` is 18 characters; `date(2026-10-26)` and `~date 2026-10-26` are 16).

### Lists and extents (Q3)

```udon
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]          ; A
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]            ; B
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]       ; C
```

- **B's extent problem.** Lists are whitespace-separated, so `~qty 3.2 kg` can't be one item. The sheet itself writes `3.2kg` in B's list and `3.2 kg` in A's and C's. Outside a list, B's value runs to the next start: `~duration 3mo 5d` is one value. The same spelling therefore has two extents depending on position. I hesitated here and expect agents to slip.
- **B and `~`.** A path like `~jw/docs` starts with a tilde. It is presumably text because the name isn't followed by a space, but I would want that rule stated.
- **A's nesting.** `interval(date(2026-01) date(2026-06))` reads like a function call, which agents know. B's `~interval 2026-01/2026-06` uses the interval's own notation, which is the point of "names its own notation". The A spelling `interval(2026-01/2026-06)` should be equally possible.

### Verbatim foreign text, finance, quoted forms

```udon
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me`
|inv :total.USD 1234.50     ; A
|inv :total(USD) 1234.50    ; B
|inv :total qty(1234.50 USD); C
|q :name "8080" :note "To be, or not to be."
```

- **Backtick escapes.** I could not tell what a literal backtick inside a backtick span looks like, or whether a doubled backtick works.
- **Currency under A and B.** `.USD` and `(USD)` both read fine, and neither cost me anything.

## Part 2: Which felt best

**Q1 (names).** B, `:mass(kg) 3.2`, felt most beautiful. It reads like a column header, handles real unit spellings, and types a whole list. A is second but hijacks dotted keys and can't hold `°C`. C is the least noisy to write once and the noisiest in a table. C's one clear advantage is a single mechanism: it is the same syntax as Q3-A. If Q3 is settled value-side, Q1 collapses to whether to also have a name-side shortcut. I'd say yes, because a schema or column header is a per-name fact.

**Q2 (quoted alone).** Weakly B (about 55/45). My reason is the silent loss in `|p "Ship it."`. Under A the paragraph can lose its quote marks depending on whether a word follows. B keeps what was written, and the string inside stays readable. The cost is a rawer tree for `:name "Joseph"`, and A matches the JSON habit that quoted means string. If the two could differ by position I'd take A for attribute values and B for text-bearing elements, but that breaks one-rule-everywhere.

**Q3 (names its notation).**
- *Single line:* B reads most fluently. "on, a date, 2026-10-01" runs left to right, and the kind is known from the first character.
- *Cold guessability:* A is the most guessable. In my COLD read I gave `date(2026-10-01)` 90% on meaning, against 55% for `~date`.
- *Whole documents:* C. It marks dates in prose, works in lists with explicit extents, spends no new characters (CTQ A8, B6), and kind and extent are known from `|{` and `}`.
- *Its cost:* kind names share a namespace with markup elements. `|{time …}` is the HTML `time` element. And `:on |{date 2026-10-01}` has the same tree shape as rich text. A schema has to tell them apart.
- *My pick:* C, with B's name-side form for attributes (Q1-B).

**Q4 (trailing colon).** A. B gives two spellings of one thing, a doubled-colon look, and only helps `:name:`, not `|server host:`. Under A, `:host: localhost` should get a default-on teaching warning, like the existing `main-label-colon-warns` rule. That fits "errors over guesses" and "errors that teach" in CTQ. B would silently legitimise a slip that is a useful signal of a YAML-trained writer.

**Something not on the sheet.** Three of the options share one hazard: a one-token change flips what a value is. A quoted value alone (Q2), `name(…)` alone (Q3-A) and a backtick span alone (verbatim) are each promoted if they stand alone, and each reverts to text if a word follows. CTQ says every construct's kind should be known within a few characters. A "must stand alone" rule means the kind isn't known until the end of the value. I'd want the demotions to warn, at least in attribute-value position (`:href "…" Click here`, `:on date(…) extra`). In prose position (`|p "Hello," she said.`) demotion matches the writer's intent and I'd leave it silent.

## Part 3: What I'd expect other agents to get wrong

- **A.** `:host: localhost`, which they will write constantly. Space before the kind (`:mass .kg 3.2`). Dotted config keys read as kinds.
- **B.** Space before the parenthesis: `:mass (kg) 3.2` gives the value `(kg) 3.2`, silently. Unit characters with unbalanced parentheses.
- **Q2.** `:href "https://example.com" Click here` (silent text with quotes). `|p "Ship it."` expecting the quotes to survive.
- **Q3-A.** `date(…)` mid-sentence, or followed by a word: silent text. Reading `|h3 date(format)` as a heading.
- **Q3-B.** `~qty 3.2 kg` inside a list. Trailing prose after `~date 2026-10-01` becomes part of the date.
- **Backticks.** Using `'…'` out of habit (still fine, but a string, not a tagged regex). Unclear escapes for a backtick inside the span.
- **`nil`.** Writing `null`, per my COLD note. A warning exists in the cards, so that one at least teaches.

## Part 4: Feedback on the trial and incidental findings

**Trial design**
- **Q1-C is Q3-A.** The sheet says so ("see Q3"), but it means Q1-C isn't independent of Q3. A cleaner Q1 would be name-side versus value-side, with the value-side spelling decided in Q3.
- **Happy-path samples only.** The sheet shows no trap lines. The COLD Read section does (`|p "Hello," she said.`, `|h3 date(format)`); an options-side trap set would let agents report slips under each option, not only guess them.
- **COLD gaps.** There is no item for a date inside a sentence, a mixed-kind list, a unit with a non-ASCII character, a dotted config key, or a path starting with `~`. Those are where the options differ most.
- **`<…>` is absent.** The spec's incumbent for "a value that names its own notation" is `<…>`, which the cards carry as opaque raw text, and it isn't on the sheet. Perhaps it was left out deliberately because it looks like an HTML tag. If not, `<date 2026-10-01>` would be a useful baseline for Q3.
- **Primed versus BASICS-only.** Each arm's COLD answers are contaminated differently. Having agents say which card drove each answer (I did) helps.

**Store inconsistencies I tripped over** (not part of the trial, offered as data)
- `rule:unquoted-run-is-one-value` says a number, `true`, `false` or `nil` is written in `<…>`. `rule:nil-spelling` says bare `nil` is nil, and the options sheet says bare numbers, booleans and `nil` get a standard reading in every option. The first card is behind.
- Its tree transcripts show `:year 1949` for `<1949>`, while `rule:opaque-span-raw-text` says a `<…>` carries raw text.
- Whether `.` is valid in an attribute name isn't stated in the cards I read, and Q1-A depends on it.
