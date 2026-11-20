# Trial report: values in UDON Lite (Fable 5.1, primed)

*2026-10-28. One of six trial reports. "Primed" means I read the lite spec store before COLD: `main.outline.md`, `CTQ-FACTORS.md`, every `def/` card, every `src/` rule card (Parts III and IV whole, including working notes; Parts II and V through their Discussion sections, working notes trimmed), `obj/`, and the `adr/` headers. I did not open anything else in `.int/` (no spike, audit, guide or verbatim record), so the independence the brief asked for is intact apart from the spec itself. I answered COLD before opening OPTIONS; the COLD section below is verbatim from the file I wrote at that point.*

*A fact about the priming that matters for reading my COLD answers: the spec I read routes every non-text kind through `<…>` (the 2026-10-21 lean). The options sheet does not offer `<…>` at all, gives bare numbers, booleans and `nil` a standard reading, and makes a quote count only when it stands alone. So several of my COLD answers reach for a spelling that is not under trial. I've left them as written.*

---

## Part 1. COLD answers, verbatim

## COLD answers (written before opening OPTIONS.md; spec-primed, BASICS read)

### Write

**1. Sample, mass 3.2 kg, temperature 21.5 °C.**

What I'd naturally write first:

```udon
|sample :mass 3.2kg :temp 21.5°C
```

Hesitation, immediately: under the spec as I read it, both values are texts (`3.2kg`, `21.5°C`), which is fine for passing along but not what a science reader wants. If I wanted the number to be a number I'd reach for `<…>`, and then I don't know what to put with the unit:

```udon
|sample :mass <3.2 kg> :temp <21.5 °C>
```

That is "someone else decides what this is", which is what `<…>` means in lite, and it reads well to me. The rule I'd want: a way for a unit to ride on a number without the number ceasing to be a number. Things I would *not* naturally write: `:mass.kg 3.2` (a dot in an attribute name reads to me as a name, not a unit), `:mass-kg 3.2` (fine as data, but the unit is now part of the field name, which schemas hate).

**2. Event on 2026-10-01, 90 minutes, 14:30 in Denver.**

```udon
|event :on <2026-10-01> :at <14:30> :tz America/Denver :duration <90m>
```

Hesitations: whether `<14:30>` is better than bare `14:30` (bare is a text; I can't tell if a later type system will read the bare one). Whether duration wants ISO `<PT90M>` (correct, ugly) or `<90m>` (readable, invented) or `:duration-minutes 90`. Whether "in Denver" wants to be folded into the start: `:start <2026-10-01T14:30 America/Denver>` or `<2026-10-01T14:30-06:00>`. I'd want to know whether `<…>` has a type-label convention (`<date:2026-10-01>`? `<date 2026-10-01>`?) because I don't want to invent one that a later version contradicts; absent one, I'd leave it unlabelled since ISO dates self-announce.

**3. Regex `^\d{3}-\d{4}$` and Windows path `C:\Users\me`.**

```udon
|rule :pattern '^\d{3}-\d{4}$' :path 'C:\Users\me'
```

Confident. Single quotes, no escapes needed beyond `\'` and `\\`. I would never put a regex in `"…"` or in `<…>` under lite's escape rules (both double the backslashes).

**4. Server.**

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner nil
```

This is what I'd write and what I'd want to keep writing. Hesitation: under the current lean, `8080`, `false`, `3`, `nil` are all texts in the raw tree and only a view reads them as number/boolean/nil; the `nil` card still says bare `nil` is nil. I don't know which wins today. If forced to make them "really" typed I'd write `:port <8080> :debug <false> :retries <3> :owner <nil>`, and I'd resent it a little on every line: it's config, and `<nil>` for "explicitly nothing" is a lot of punctuation for the most common sentinel in config files.

**5. Paragraph: "Hello," she said.**

What I'd naturally write, and what I believe is wrong under the spec:

```udon
|p "Hello," she said.
```

Under the rules I read, that gives `$main` a string `"Hello,"` and then a text `she said.` (two stacked values), not one sentence. So I'd write it as prose instead:

```udon
|p
  "Hello," she said.
```

That's what I'd actually do. The sameline form is a trap I'd expect every agent to walk into at least once, since a quote at the start of a sentence is ordinary English. A rule I'd want: a quote that is *followed by more unquoted text on the same line* should at least warn ("did you mean one text?"), or better, sameline material after an element name should be text until a `:attr` start, quotes included.

**6. Three holiday dates.**

```udon
:holidays [<2026-11-26> <2026-12-25> <2027-01-01>]
```

or, if the dates carry names:

```udon
|holidays
  |holiday[thanksgiving] :on <2026-11-26>
  |holiday[christmas] :on <2026-12-25>
  |holiday[new-year] :on <2027-01-01>
```

Hesitation: `[2026-11-26 2026-12-25 2027-01-01]` (bare texts in a list) reads cleaner and I'd probably write it in a notes file; I'd use `<…>` in data meant to be consumed as dates.

**7. Version 1.10 (string) and zip 01234.**

```udon
|part :version 1.10 :zip 01234
```

Confident under the lean (bare is text, so `1.10` stays `1.10` and `01234` keeps its zero). This is the single best argument for the lean I know of. If I were writing for a reader who might type bare values, I'd quote: `:version "1.10" :zip "01234"`.

**8. HTML-ish link.**

```udon
|a :href https://example.com \ Click here
```

and inside prose:

```udon
|p See |{a :href https://example.com \ Click here} for details.
```

Confident, from BASICS. What I expect other agents to get wrong, often: dropping the ` \ ` (`|a :href https://example.com Click here` gives `href` the text `https://example.com Click here` and the link no text). Quoting the href also works (`:href "https://example.com" Click here`) and is probably what an HTML-trained agent writes first.

### Read

1. `|p "Hello," she said.` — `p` with `$main` stacked: the string `"Hello,"`, then the text `she said.`. Sure that this is what the rules give; equally sure it isn't what the writer meant (one sentence).

2. `|sample :mass.kg 3.2` — an attribute named `mass.kg` (if `.` is a bare-label character) holding the text `3.2`. Fairly sure. Not a trait (traits hang off elements, not attributes) and not a unit.

3. `|sample :mass(kg) 3.2` — an attribute named `mass(kg)` if parentheses are label characters, otherwise an error. Unsure which; I'd guess the parser accepts it as a name. No unit semantics either way.

4. `|ev :on date(2026-10-01)` — `on` holds the text `date(2026-10-01)`. Sure. Nothing in lite reads function-call shapes.

5. `|ev :on ~date 2026-10-01` — `on` holds the text `~date 2026-10-01`. Sure. `~` isn't special on a value line.

6. `|h3 date(format)` — `$main` is the text `date(format)`. Sure.

7. `|config :server.port 8080` — an attribute named `server.port` holding the text `8080` (number under the view). Mostly sure; no nesting implied by the dot.

8. `|server :host: localhost` — least sure. Either an attribute named `host:` holding the text `localhost` (if `:` may sit inside a bare name), or an error on the second colon. I'd guess a name `host:`, with a warning like the `$main` `label:` one. The writer clearly meant `:host localhost`.

9. `|li printf(x) prints x` — `$main` is the text `printf(x) prints x`. Sure.

---

## Part 2. What COLD tells me now that I've seen the options

- Every Read line that the options give a meaning to (`:mass.kg`, `:mass(kg)`, `date(…)`, `~date`, `:host:`) I read as plain names and plain text, with confidence. That's the measurement: untaught (well, spec-taught), none of the four name-side or value-side spellings reads as a kind. A reader has to be told. That isn't a strike against them, but it does mean A3 (cold comprehension) can't be the thing that picks among them; A2 (what gets written) and the silent-miss rate will be.
- `|h3 date(format)` is the line to watch. I read it as text, sure. Under Q3-A it is a notation `date` applied to `format`, because it stands alone. More on that below.
- My Write #5 asked for exactly what Q2's preamble gives: a quote only counts when it stands alone. Good.
- My Write #7 relied on bare values being text. Under the sheet's premise, "ordinary JSON-style numbers get a standard reading", so `:version 1.10` reads as the number 1.1 through the view (the raw tree keeps the text `1.10`, so nothing is lost, but the view loses the zero). `01234` is not a JSON number, so it stays text. Worth knowing: the lean's best example only half-survives the standard reading.

---

## Part 3. Writing under the options

I wrote each context under every option that applied, and kept notes on where I stopped, slipped, or had to look back. I've kept the UDON that shows something; the rest was repetition.

### 3.1 A config file

The baseline, with nothing from Q1 or Q3 and Q4-A:

```udon
; billing-api.config.udon
:name billing-api
:version 2.4.1
:env production

|server[web]
  :host localhost
  :port 8080
  :debug false
  :retries 3
  :owner nil
  :timeout 30s
  :max-body 10MB
  :started 2026-10-01T14:30Z

|database
  :url postgres://db.internal:5432/billing
  :pool 20
  :statement-timeout 5s
  :ssl true

|logging :level info :file /var/log/billing.log
  :rotate 1d
  :keep 7
```

This is the file I want to write and read. `30s`, `10MB`, `1d`, `2026-10-01T14:30Z` are texts and I'm content for them to be, because the consumer of a config file knows its own fields. The options only start to matter when there is no schema and the value has to carry its own kind.

**Q1-A (dot):**

```udon
|server[web]
  :host localhost
  :port 8080
  :timeout.duration 30s
  :max-body.bytes 10MB
  :started.datetime 2026-10-01T14:30Z
```

Friction: I stopped at `:max-body.bytes 10MB`. Is `bytes` the kind, or the unit? `10MB` already says megabytes; `.bytes` is either redundant or a conversion instruction. With `.duration` the word after the dot is a type; with `.kg` (from the sheet) it is a unit. One slot, two vocabularies. I also noticed my hand wanting `.` for something else: `:log4j.rootLogger`, `:server.port`, `:og.title` are all real dotted field names in the wild, and under A every one of them is a kind applied to a shorter name. Under A, `:server.port 8080` is the attribute `server` with kind `port`. I read it cold as a name with a dot, and I think most agents would.

**Q1-B (parens):**

```udon
|server[web]
  :host localhost
  :port 8080
  :timeout(duration) 30s
  :max-body(bytes) 10MB
  :started(datetime) 2026-10-01T14:30Z
```

In config this reads as heavier than it needs to be, but nothing stopped me. Parens are self-delimiting, so `(°C)`, `(%)`, `(date YY-MM-DD pivot 1950)` all work without a second thought, which A can't say. A's dot form grows parentheses the moment it needs a parameter (`.date(YY-MM-DD pivot 1950)`), at which point it is B with an extra dot. I don't see a case where A beats B except in character count.

**Q3-A (parens on the value):**

```udon
|server[web]
  :timeout duration(30s)
  :max-body qty(10 MB)
  :started datetime(2026-10-01T14:30Z)
```

Reads like a constructor. Fine in config, and the kind now travels with the value: if I copy `duration(30s)` into a list or another attribute it still says what it is. On the name (Q1) the kind is a property of the slot and gets left behind when the value moves.

**Q3-B (tilde):**

```udon
|server[web]
  :timeout ~duration 30s
  :max-body ~qty 10 MB
  :started ~datetime 2026-10-01T14:30Z
  :home ~jw/projects
```

I wrote the last line to see what happens, and it is the problem: `~jw` is a name after a tilde, so `:home ~jw/projects` is a notation `jw` with value `/projects`. Home-directory paths are common in config files. `~/x` is safe (no name), `~user/x` is not. Also `~` reads as "approximately" to a lot of writers (`:eta ~5 min`), and `~5` is probably safe only because `5` isn't a name. I'd be nervous every time I typed a tilde.

**Q3-C (inline element):**

```udon
|server[web]
  :timeout |{duration 30s}
  :max-body |{qty 10 MB}
  :started |{datetime 2026-10-01T14:30Z}
```

No new rule; I already knew what every character does. In config it looks like structure where I expected a value, and that is the honest cost: `|{` says "element" to me and I'd rather it said "value". But the block form is equivalent and sometimes reads better:

```udon
|server[web]
  :started |datetime 2026-10-01T14:30Z
```

That is an element-valued attribute, already in the spec. So under C the same meaning has a block spelling and an inline spelling, by rules that exist. That consistency is real.

**Q4-B (optional trailing colon):**

```udon
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
```

I don't see what this buys. It reads as a stutter (`:host:`), and the agent mistake it seems aimed at is not this one. The YAML-trained mistake I expect is:

```udon
|server
  host: localhost
  port: 8080
```

which is prose under `server`, silently, with no warning anywhere (the `label:` warning only covers `$main`). Q4-B does nothing for that. What it does do is make a trailing colon unspellable in a bare name, and it made me stop on an XML-shaped name:

```udon
|svg :xmlns:xlink http://www.w3.org/1999/xlink
|html :xml:lang en
```

Under B, is `xml:lang` the name, or is `xml` the name with the colon ignored and `lang en` the value? I had to stop and I couldn't tell from the sheet. Those names are exactly the XML/HTML objective's territory. A for me, and in its place a default-on warning for a prose block under an element whose lines all look like `word: value`.

### 3.2 A science data table

Soil cores, one row per core. Baseline, bare:

```udon
|dataset[soil-2026-10] :collected 2026-10-01 :site Boulder Creek
  :lat 40.0150 :lon -105.2705
  :instrument Mettler XS205
  |core[c-01] :depth 0-10cm :mass 412.6g :temp 14.2°C :moisture 23.4% :ph 6.8
  |core[c-02] :depth 10-20cm :mass 455.1g :temp 13.1°C :moisture 27.9% :ph 6.6
  |core[c-03] :depth 20-30cm :mass 470.8g :temp 12.4°C :moisture 31.0% :ph 6.5
```

This is what a lab notebook looks like and it is the most beautiful rendering of this content I produced all session. Every unit-bearing value is a text under the sheet's premise, and nothing reads them. Hold that thought for Part 5.

**Q1-A:**

```udon
  |core[c-01] :depth.cm 0-10 :mass.g 412.6 :temp.degC 14.2 :moisture.pct 23.4 :ph 6.8
```

Friction, twice on one line: I wrote `degC` because `°C` after a dot in a name looked wrong to me (is `°` a label character?), and I wrote `pct` because `.%` looked worse. So A pushed me into inventing ASCII unit names, which a reader then has to decode. `:depth.cm 0-10` is a range, not a number, and the kind just has to live with that.

**Q1-B:**

```udon
  |core[c-01] :depth(cm) 0-10 :mass(g) 412.6 :temp(°C) 14.2 :moisture(%) 23.4 :ph 6.8
  |core[c-02] :depth(cm) 10-20 :mass(g) 455.1 :temp(°C) 13.1 :moisture(%) 27.9 :ph 6.6
```

This is exactly how a scientist writes a column header, "Mass (g)", and it reads that way. `(°C)` and `(%)` just work. It is the best of the Q1/Q3 forms for a table. The thing to notice is that UDON rows restate the header on every row, so the "declare once per column" benefit a spreadsheet gets doesn't arrive; each row pays the parens. With a schema the row is the bare baseline again, which the sheet already says.

**Q1-C with Q3-A:**

```udon
  |core[c-01] :depth qty(0-10 cm) :mass qty(412.6 g) :temp qty(14.2 °C) :moisture qty(23.4 %) :ph 6.8
```

Noisiest of the three. `qty(` five times per row. Semantically it is the most honest (the unit belongs to the value, not the slot), and I'd pick it for a single measurement in a notes file. For a table, no.

**Q3-B and Q3-C in a table**, for completeness:

```udon
  |core[c-01] :depth ~qty 0-10 cm :mass ~qty 412.6 g :temp ~qty 14.2 °C
  |core[c-01] :depth |{qty 0-10 cm} :mass |{qty 412.6 g} :temp |{qty 14.2 °C}
```

Both worse than parens here. The tilde form is readable on a line (the run ends at the next `:`), but see the list case below. The inline-element form is the heaviest.

**A date format that doesn't announce itself** (the sheet's `27-03-05` case) is where name-side kinds earn their keep:

```udon
|record :when(date YY-MM-DD pivot 1950) 27-03-05        ; B
|record :when.date(YY-MM-DD pivot 1950) 27-03-05        ; A
|record :when date("YY-MM-DD pivot 1950" 27-03-05)      ; 3A
```

B is the cleanest. 3A's version puts the format before the value and needs quotes for the spaces; I had to look back at the sheet to get the argument order right, which is a bad sign for a form I'd write rarely.

### 3.3 An HTML page

```udon
|html :lang en
  |head
    |meta :charset utf-8
    |title Lab notes
    |link :rel stylesheet :href /style.css
  |body
    |header
      |nav :aria-label Site |a :href / \ Home
    |main
      |h1 Welcome
      |p Published |{time :datetime 2026-10-01 \ October 1, 2026} by |{a :href /about \ me}.
      |p She said "Hello," and left.
      |p "To be, or not to be."
      |img :src /pic.png :alt "A photo of the lab"
      |input :type number :min 0 :max 100 :step 0.5 :value 42
      |button :type submit \ Save
```

**Q2 is the live question here.** The preamble's rule (a quote counts only when alone) makes `|p She said "Hello," and left.` one text with its quotes, which is right, and fixes my COLD trap. Then:

- `|p "To be, or not to be."` stands alone. Under A the paragraph's `$main` is the string `To be, or not to be.` and the quotation marks the author typed are gone from the content (kept as meta). Under B the text keeps its quotes.
- `:alt "A photo of the lab"` stands alone. Under A it is the string, which is what every attribute consumer wants. Under B the raw tree holds `"A photo of the lab"` with the quotes, and a view strips them.

So the same spelling wants A in attribute position and B in `$main`-as-prose position. Neither option can give both, and the sheet (rightly) doesn't offer a position-dependent rule. My lean is **A**, for three reasons. Every agent alive reads `"8080"` as the string 8080; B asks them to unlearn that in the raw tree. Escapes only make sense under A: under B, `:msg "line one\nline two"` holds a literal backslash-n until a view runs, so the raw tree can't be used as-is. And B doesn't rescue the prose case anyway: an HTML renderer applying the standard reading would strip the quotes from `|p "To be…"` too, unless views are made position-aware, which is the same complication A would need. The author who wants a `$main` that is exactly a quoted sentence has two easy outs, prose on the next line or `'"To be, or not to be."'`, and `|title "Quoted Title"` losing its quotes is the kind of thing a default-on warning could name ("quoted value alone in `$main`; did you mean the quotes as content?").

**Q3-C in HTML prose** is where C is strongest and weakest at once:

```udon
|p Met Sam on |{date 2026-10-01} at |{qty 14:30}.
```

It is the only option that marks a value inside prose at all (A and B are value-position forms; in prose they're text). But in an HTML document `|{date 2026-10-01}` is an inline element named `date`, and an HTML renderer that doesn't know `date` is a notation will emit `<date>2026-10-01</date>`. The real HTML spelling is `|{time :datetime 2026-10-01 \ October 1}`. So C makes notation names and element names one namespace, and a dialect has to know which is which. That is a dialect problem, not a lite problem, but it's the thing a reader will trip on.

**Q4-B** in HTML: `:href: /style.css`, `:rel: stylesheet`. No. And the namespaced-name question from 3.1 applies.

### 3.4 A notes file with dates in prose

```udon
:title Lab notebook
:started 2026-09-30

|day[2026-10-01]
  Met Sam at 14:30 about the soil cores. She said "we need three more
  sites by 2026-10-15" and I agreed.
  |todo :due 2026-10-15 :owner sam \ Three more sites
  |todo :due 2026-10-03 \ Calibrate the XS205
  Weight check: 3.2 kg at 21.5 °C, nominal.

|day[2026-10-02]
  Rain. Nothing collected. Next window ~2026-10-04, maybe.
```

Things I noticed:

- `|day[2026-10-01]`: a date in a key. Under 3A, `|day[date(2026-10-01)]`; under 3B, `|day[~date 2026-10-01]`; under 3C, `|day[|{date 2026-10-01}]`. The last is the first thing in this whole exercise I would refuse to write. The parens form is tolerable. Bare is what I'd write.
- `Next window ~2026-10-04` in prose is fine under every option (prose passes through), but if I moved it to a value line, `:next ~2026-10-04` under 3B is a tilde followed by a non-name, so presumably text. I had to think about it, which is the point.
- The dates in prose (`2026-10-15` inside the quoted sentence) can't be marked under A or B at all, and under C only by wrapping them: `by |{date 2026-10-15}`. In a notes file I wouldn't; I'd leave them as text and let a consumer find them.
- `:due 2026-10-15` is a text. For a todo list that is the one value a consumer wants as a date. See Part 5.

### 3.5 Lists and keys, where the three Q3 forms separate

```udon
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]                ; 3A
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]                 ; 3B
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]            ; 3C
|ev :lasts duration(3mo 5d)                                           ; 3A
|ev :lasts ~duration 3mo 5d                                           ; 3B
|meta :spans [~duration 3mo 5d ~duration 1y]                          ; 3B, and here it breaks
```

The last line is the one I couldn't write. List items are whitespace-separated, so `~duration 3mo 5d` in a list is either `~duration 3mo` and then `5d`, or the sigil reaches to the next sigil, or something else; the sheet's own list example avoids the question by writing `~qty 3.2kg` with no space. So the tilde form's extent depends on where it sits: to the next start on a line, to the next space in a list. A form whose extent I have to recompute per context is one I'll get wrong. Parens and braces are self-delimiting and don't have this problem.

Nesting:

```udon
|ev :span interval(date(2026-01) date(2026-06))                      ; 3A
|ev :span ~interval 2026-01/2026-06                                   ; 3B, no nesting, invents a slash
|ev :span |{interval |{date 2026-01} |{date 2026-06}}                 ; 3C
```

3A is the prettiest by a clear margin. 3B can't nest and so had to invent its own interior syntax. 3C nests fine and is the heaviest.

### 3.6 The verbatim backtick

```udon
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me`
|cmd `ls -la`
|p Use `ls -la` to list files.          ; not alone, so text, with its backticks
```

I like this more than I expected. No escapes at all, a tag slot, and Markdown's inline code already trained every agent to read it. The prose line stays text because the backticks don't stand alone. One thing I couldn't answer: a verbatim value that contains a backtick. Markdown's answer is double backticks with a space (``` `` a`b `` ```); the sheet doesn't say.

Noticed in passing: ``re`…` `` is a name directly followed by a delimited span, and `date(…)` is the same shape with a different delimiter. If 3A is adopted, "a name attached to a delimited span" is one rule covering both, which I'd find satisfying.

### 3.7 A vsect-style record (lite's first customer)

```udon
:kind decision
:title Fences nest by backtick count
:status accepted
:decided 2026-10-08
:updated 2026-10-09
:deciders [Joseph]
:leaves-open ["08" "12 Q1"]
```

Q2 again: `["08" "12 Q1"]` wants strings (A). `:decided 2026-10-08` wants to be a date and is a text; under 3A `:decided date(2026-10-08)` on every record is the sort of thing a store would rather declare once. Which it can, with a schema; the sheet says so. This context mostly says "the schema does the work, keep the data bare".

### 3.8 A recipe

```udon
|recipe[focaccia] :serves 8 :prep 20min :rise 2h :bake 25min :oven 220°C
  |ingredient[flour] :qty 500g
  |ingredient[water] :qty 400ml :temp 30°C
  |ingredient[yeast] :qty 7g
  |ingredient[salt] :qty 10g
  |step Mix, rest 30min, then fold 3x at 30min intervals.
```

Every option makes this worse: `:qty(g) 500`, `:qty.g 500`, `:qty qty(500 g)`, `:qty ~qty 500g`, `:qty |{qty 500 g}`. The recipe is the context that most wants the number-with-unit token (`500g`, `20min`, `220°C`) to just be readable as a quantity, the way `8080` is readable as a number. Part 5.

---

## Part 4. The four questions

**Q1 (kind on the name): B over A; and B only as sugar.** A's dot is strictly dominated: it collides with dotted field names agents already write (`server.port`, `og.title`), it made me invent ASCII unit names (`degC`, `pct`) because `°C` and `%` after a dot looked wrong, and it grows parentheses the moment a parameter is needed. B is self-delimiting, reads exactly like a scientific column header, and `(°C)`, `(%)`, `(date YY-MM-DD pivot 1950)` all worked first try. But a kind on the name is a property of the slot, and the unit belongs to the value: copy `3.2` out of `:mass(kg) 3.2` and it is just `3.2`. So if B is adopted I'd want it defined as sugar for the value-side form (`:x(k) v` means `:x k(v)`, or whatever Q3 settles), so the tree has one model and the name-side form is a tabular convenience. On its own I'd pick C (nothing on the name) and let schemas carry column kinds, which is what every data context in Part 3 ended up wanting anyway.

**Q2 (a standalone quoted value): A.** The preamble's "only when alone" rule is the fix I asked for in COLD and I'd keep it regardless. Between A and B: A matches what every agent already believes `"8080"` means, A is the only one under which escapes make sense in the raw tree, and B doesn't actually save the `|p "To be…"` case because a view applying the standard reading strips the quotes there too. The one real cost of A, a quoted sentence alone in `$main` losing its marks, is rare, has two easy spellings, and is a good candidate for a warning.

**Q3 (a value naming its notation): A for beauty, C for principle; B last.**

- B last, without much doubt: its extent changes between a line and a list (I could not write `[~duration 3mo 5d ~duration 1y]`), it can't nest, and `~user/path` in config is a real collision.
- A is the most beautiful in value position, lists and keys, and nests cleanly: `interval(date(2026-01) date(2026-06))` is the best line in this report. It also unifies with the tagged backtick. Its cost is the one I found in COLD: a lone function-call-shaped value is captured silently. `|h3 date(format)`, `|li printf(x)`, `|method parse(input)`, `:cmd ls(1)`, `:fn sin(x)` are all notations under A when they stand alone, and I read every one of them as text before I saw the sheet. How bad this is depends on what lite does with a notation name it doesn't know. If every lone `name(…)` becomes a notation node and "known" is left to consumers, the miss is silent (the worst kind per A2's own footnote). If an unknown name is an error with a "did you mean `\printf(x)`?" suggestion, the miss is loud, but lite has no registry to know names by, since handlers are per-dialect, the same as fences.
- C costs nothing: no new syntax, no new node kind, it nests, it is the only form that works inside prose, it has a block-form twin (`:on |date 2026-10-01`) by existing rules, and it is the same mechanism fences already use (an element whose name selects a handler). What it costs is beauty in data position (`|{` reads as structure, not value), it is unwritable in a key, and in HTML the notation namespace and the element namespace are one.

If I have to pick one today I pick **C**, because a silent capture of `f(x)` in programming notes is the kind of defect that costs trust, and C's ugliness is honest and local. If the unknown-name question is answered loudly (an error that teaches), **A** becomes my pick, and I'd define `name(…)` as a spelling of the inline element `|{name …}` so the tree stays one model. Either way I'd want C's inline-element reading to be *the* model and any lighter spelling to be sugar for it.

**Q4 (trailing colon): A.** B solves a mistake I don't think agents make (`:host:`), doesn't solve the one they do make (`host: value` lines as prose), and made me stop on `:xml:lang en`. What I'd want instead is a default-on warning for a prose block under an element whose lines all match `word: value`.

---

## Part 5. Anything else

**1. Let self-announcing values read as what they are, bare.** The sheet's premise already reads `8080`, `true`, `nil` as what they spell. The two kinds that came up in every context, and that every option made uglier, are ISO dates/times (`2026-10-01`, `14:30`, `2026-10-01T14:30Z`) and number-with-unit tokens (`3.2kg`, `21.5°C`, `90min`, `10MB`, `23.4%`). Both are as unambiguous by spelling as a number is, and both are what I wrote untaught. If the standard reading covered them, the recipe, the soil table, the config and the notes file all stay in their bare, most beautiful form, and Q1/Q3 notations are needed only where the value genuinely doesn't announce itself (`27-03-05` with a pivot year, a half-open interval, a duration like `3mo 5d`). That shrinks the territory the four questions are fighting over to the cases where any of the forms is acceptable. The cost is the one the spec already accepted for numbers: a bare value is a text in the raw tree and the reading is a view, so nothing is lost. The one trap I'd name: the standard number reading already turns `1.10` into 1.1, so a unit-token reading should be strict about what it accepts (a number immediately followed by letters, `°`, `%`, no space), and a version string like `1.10.3` should not be a candidate.

**2. The spec's own `<…>` with a space.** Primed as I am, I kept reaching for `<date 2026-10-01>`, `<qty 3.2 kg>`, `<interval <date 2026-01> <date 2026-06>>`. It is self-delimiting, it already nests by the matched-pairs rule, angle brackets already mean "typed" in UDON, and `<` is never accidental at the start of a value. I understand the trial deliberately set it aside, and I'm not neutral about it, so I'll only say: among everything I wrote, `interval(date(2026-01) date(2026-06))` and `<interval <date 2026-01> <date 2026-06>>` were the two lines I found beautiful, and C's `|{interval |{date 2026-01} |{date 2026-06}}` was the one I found correct.

**3. The warning Q4-B is standing in for.** A prose block directly under an element whose every line looks like `word: value` is almost certainly a YAML habit, and lite swallows it silently. That's a bigger loss than anything Q4 decides.

**4. Tagged backticks and 3A are one rule.** "A name attached directly to a delimited span is a notation applied to the span's content": ``re`…` `` and `date(…)`. If 3A survives, state it that way.

---

## Part 6. What I'd expect other agents to get wrong

- Dropping the framed ` \ ` before link text (`|a :href /x Click here`), in every option. The most common slip I predict, by a distance.
- Writing `host: localhost` lines under an element and getting silent prose.
- Under Q1-A: writing dotted names from other systems (`server.port`, `log.level.root`) and having them read as kinds. Under Q1-B the same with names that carry parens, much rarer.
- Under Q3-A: a lone `f(x)`-shaped value or `$main` becoming a notation (`|h3 date(format)`, `|method parse(input)`). I'd also expect agents who *know* 3A to write `date (2026-10-01)` with a space, or `Date(2026-10-01)`, and get text.
- Under Q3-B: `~user/path`; and in lists, not knowing where a tilde value ends. I'd also expect `~ date` with a space.
- Under Q3-C: not thinking of `|{date …}` as a value at all, and in HTML, expecting it to render as a tag (which it would, absent a dialect).
- Under Q2-A: `|p "Hello world"` silently losing its quotes; under Q2-B: `:alt "x"` keeping them and breaking a JSON round-trip until the view runs.
- Under Q4-B: `:xml:lang`, `:xlink:href`, `:og:title`.
- Backticks: a value containing a backtick, and single-quoted strings that end in a backslash (`'C:\'`), which the spec already names.

---

## Part 7. Where I hit friction, in one list

1. Q1-A, `°C` and `%` after a dot: stopped, invented `degC` and `pct`.
2. Q1-A, `:max-body.bytes 10MB`: stopped; is the word after the dot a kind or a unit, and is it redundant with the value's own suffix?
3. Q3-A, `date("YY-MM-DD pivot 1950" 27-03-05)`: looked back at the sheet for argument order.
4. Q3-A, `|h3 date(format)`: read it as text in COLD; it isn't.
5. Q3-B, `[~duration 3mo 5d ~duration 1y]`: could not write it.
6. Q3-B, `:home ~jw/projects`: a collision I'd meet in real config.
7. Q3-C, `|day[|{date 2026-10-01}]`: refused to write it.
8. Q3-C in HTML prose: `|{date …}` is a tag unless a dialect says otherwise.
9. Q2, `|p "To be, or not to be."` vs `:alt "A photo"`: the same spelling wants opposite answers by position.
10. Q4-B, `:xml:lang en`: stopped; couldn't tell what the name is.
11. Backtick verbatim: a value containing a backtick.
12. The sheet's standard number reading turns `:version 1.10` into 1.1 (view only; raw tree keeps the text).

---

## Part 8. Feedback on the trial's design

- The primed/unprimed split is doing real work: my COLD answers reach for `<…>` in four of eight Write items because the spec told me to, and none of the sheet's forms appear in them. If the unprimed reports also avoid every sheet form, that's a finding about all four forms, not about priming.
- The Read list is good and `|h3 date(format)` is its best line. I'd add a few probes the sheet's own notes hide: a lone function-call value with nothing after it (`|li printf(x)`), a namespaced XML attribute (`:xml:lang en`), a tilde path (`:home ~jw/x`), a date in a key (`|day[2026-10-01]`), and a list of two multi-word sigil values.
- Write #7 (`1.10`) is the sharpest probe in the set, and it's worth knowing that the sheet's own premise (JSON numbers get a standard reading) gives it a different answer than the spec's lean does.
- The trial measures A2 (what gets written) and a bit of A1. It doesn't measure A3 after exposure: I'd add a short Read-after-OPTIONS list of unfamiliar lines under each option, so reading accuracy can be scored against writing.
- The preamble's "a quote counts only when alone" rule is presented as background, but it's the single change in the sheet that most altered what I'd write (it dissolves my COLD #5). It might deserve a question of its own, since it also decides `|p "Hello," she said.` versus `|p "Hello"` and someone may want the old behaviour back.
- "In every option a bare value is text, and `nil`, `true`, `false` and ordinary JSON-style numbers also get a standard reading" quietly answers a question the spec I read still has open (whether the typed-primitive view is on by default). Fine for the trial, but worth saying out loud in the report that reads the six side by side.

*I'm staying on the line.*
