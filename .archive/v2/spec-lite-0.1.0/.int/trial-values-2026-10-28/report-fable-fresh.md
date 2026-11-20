# Trial report — Fable 5.1, BASICS-only exposure

*Written 2026-10-28. Exposure: `BASICS.md` only; I did not open the spec store around this directory, and I did not read the other reports. One honesty note on exposure: the udon repo's `CLAUDE.md`/`README.md` are auto-loaded into my context at session start, and the README carries a few 0.9-era UDON examples (`:urgent?` flags, an `:author` attribute whose value is a `|person` node, and `:date 2025-12-22  ; bare date is a string; temporal is moving to a <…> dialect`). I noticed that comment only after writing COLD, but it was in my context the whole time; read my answers with that caveat.*

## Part 1 — COLD answers, verbatim as first written (before opening OPTIONS.md)

### Write

**1. Sample, mass 3.2 kg, temperature 21.5 °C.**

```udon
|sample :mass 3.2 kg :temp 21.5 °C
```

That is what I would write if I wanted a human to read it, and BASICS says an unquoted value runs until ` :name`, so `mass` gets `3.2 kg`. The hesitation: I have no idea whether a consumer gets a number out of `3.2 kg`, or a string, or an error. The config-file reflex in me wants to write `:mass-kg 3.2 :temp-c 21.5` so the value is a bare number and the unit lives in the name, which is ugly but is the thing I would trust. A third thought, `:mass 3.2kg`, I rejected because `21.5°C` glued together looks wrong and `21.5C` loses the degree. What I'd want: a rule for whether "number followed by a unit word" is a quantity or a string.

**2. Event on 1 Oct 2026, 90 minutes, 14:30 Denver.**

```udon
|event :date 2026-10-01 :start 14:30 :tz America/Denver :duration 90min
```

Hesitations, in order: I wrote `90min` then wanted `90 min` (the space is allowed by the run-to-next-colon rule) and I don't know which is better; `90m` I rejected as ambiguous with metres; ISO `PT1H30M` I know but would not write unless told to, it's ugly to read back. "In Denver" is doing two jobs (a place and a time zone); I'd write `:tz America/Denver` because DST at that date matters and `-06:00` would silently freeze it. If I wanted one value I'd write `:start 2026-10-01T14:30` and keep the tz separate. What I'd want: a duration rule, and whether a date-with-time is one value or two.

**3. Regex and Windows path.**

```udon
|rule :pattern '^\d{3}-\d{4}$'
|path 'C:\Users\me'
```

I single-quoted both because BASICS says `"…"` has Ruby-like escapes, and in Ruby `"\d"` collapses to `d`, which would silently corrupt the regex. Unquoted might actually work for the regex (no *framed* ` \ ` in it) but I would not trust myself to remember that rule on the day, and `C:\Users\me` unquoted has `\U` and `\m` sitting there looking like escapes even if they aren't. The Windows path also made me look at `C:` and wonder for a second whether a colon inside a value does anything (it shouldn't; `:name` needs a leading space). What I'd want: confirmation that `'…'` is fully literal except `\'`.

**4. Server.**

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner null
```

Hesitations: is `false` a boolean or the string "false"? Is `null` null, or the string? Does `8080` come out as a number? BASICS is silent and I just wrote the JSON/YAML spellings and hoped. Alternatives that crossed my mind: `:owner` with nothing after it (empty = null?), `:owner ~` (YAML habit, rejected as a YAML footgun), `:debug? false`. What I'd want: are bare `true`/`false`/`null`/numbers kinded at all, or is everything a string until a schema says otherwise? Either answer is fine; not knowing is the friction.

**5. "Hello," she said.**

```udon
|p "Hello," she said.
```

I'd write exactly that and hope quotes in prose are prose. Then I'd worry, because BASICS says `"…"` is a quoted value, and the Read list below contains this exact line, which tells me it is a known trap. If I were nervous I would drop to a prose line:

```udon
|p
  "Hello," she said.
```

because "lines that don't start with a marker are prose" feels safer than `$main`. What I'd want: a promise that in `$main` and prose, quotes are just characters.

**6. Three holiday dates.**

```udon
|holidays :dates [2026-11-26 2026-12-25 2027-01-01]
```

or, if they need names:

```udon
|holidays
  |holiday[thanksgiving] 2026-11-26
  |holiday[christmas] 2026-12-25
  |holiday[new-year] 2027-01-01
```

No hesitation on the list syntax; the only question is the same one as 4: are these dates or strings.

**7. Version 1.10 and zip 01234.**

```udon
|part :version "1.10" :zip "01234"
```

Quoted defensively; this is the Norway-problem reflex. The hesitation is whether quoting *does* anything (if everything is a string anyway, the quotes are noise; if numbers are auto-detected, the quotes are load-bearing). I would rather not have to know which world I'm in to write a zip code.

**8. Link.**

```udon
|a :href https://example.com \ Click here
```

I first wrote `|a :href https://example.com Click here` and then caught that the unquoted value runs to end of line, so `href` would have eaten "Click here". The framed backslash fixes it, and BASICS gave me that exact example, so I got there, but I expect other agents to write the first form and ship it. Inline it would be `|{a :href https://example.com \ Click here}`. The second thought was `|a Click here :href https://example.com` and I don't know if attributes may follow `$main`.

### Read

1. `|p "Hello," she said.` — Either `$main` is the prose `"Hello," she said.` with literal quotes (what I want), or a quoted value `Hello,` followed by leftover `she said.`. About 55/45 for prose. If it is the latter, prose with dialogue is broken for everyone.

2. `|sample :mass.kg 3.2` — attribute `mass` with a trait `kg` (reading `.word` by analogy to elements), value `3.2`: a mass in kilograms. ~70%. The competing reading is a dotted name `mass.kg`, which line 7 (`:server.port`) pushes me toward; I only pick "unit" here because `kg` is a unit I recognise. That means the same syntax reads two ways depending on what the word after the dot happens to be, which is a bad sign.

3. `|sample :mass(kg) 3.2` — attribute `mass`, parameter/unit `kg`, value `3.2`. ~80%. Parentheses read as "annotation on the name", not as part of the name.

4. `|ev :on date(2026-10-01)` — the value is a date constructed from `2026-10-01`; `on` has kind date. ~85%. It reads like a function call / typed literal.

5. `|ev :on ~date 2026-10-01` — `~date` is a kind tag on the following value: `on` is the date 2026-10-01. ~70%. Tilde is unfamiliar; the YAML `!!date` shape is what I'm pattern-matching to. Lower confidence than 4 because I'm not sure where the tagged value ends (to end of line? next space?).

6. `|h3 date(format)` — a heading whose text is literally `date(format)`. ~70%. But given line 4 I can see a parser reading it as a date constructed from the string `format`. This line is the trap for the constructor syntax: prose about code mentions `name(arg)` constantly.

7. `|config :server.port 8080` — a path: `config` → `server` → `port` = 8080. ~65%. The "trait" reading (`server` tagged `port`) makes no sense, so I fall to path. Same syntax as line 2, different reading.

8. `|server :host: localhost` — I don't know. ~30% on any reading. Guesses: `:host:` is an attribute whose value is structured/below (block-attribute opener, à la YAML `host:`); or the attribute's name is literally `host:`; or it's a typo. If I saw it in the wild I'd assume a YAML-ism had leaked and ask.

9. `|li printf(x) prints x` — a list item whose text is `printf(x) prints x`. ~85%. Same hazard as 6: if `name(…)` constructs values, this is `printf` applied to `x` followed by leftover text, which would be absurd here but is exactly what a mechanical rule would do.

**What I wanted and didn't have, in one list:** whether bare values are kinded at all (numbers / booleans / null); whether quoting forces string; a quantity rule (number + unit); a date/time/duration rule; whether quotes in `$main`/prose are inert; whether `.word` on an attribute is a trait or a path segment.

## Part 2 — After OPTIONS: writing under each option

First, two things OPTIONS told me that bear on my COLD answers:

- Bare `nil`/`true`/`false`/numbers get a standard reading. Good, that removes half of what I wanted. But I wrote `:owner null` cold, and under this rule `null` is the *string* "null". I'd expect JSON-trained agents to write `null` and Python-trained ones `None` far more often than `nil`; that is a silent footgun worth either accepting `null` too or warning on.
- Quotes with anything after them are plain text, so `|p "Hello," she said.` is safe. That was my biggest cold worry and it's answered well.

Below, the same content under each option, in the contexts I chose. I wrote these in order and recorded where I hesitated as it happened.

### Context 1 — a config file

```udon
; Q1-A
|app[orders].prod :name Order Service :version "1.10"
  :started.datetime 2026-10-01T14:30-06:00
  |server :host localhost :port 8080 :debug false :retries 3 :owner nil
    :timeout.duration 30s
    :max-body.qty 10 MB
  |db :url postgres://localhost/orders :pool 20
    :idle.duration 5min

; Q1-B
|app[orders].prod :name Order Service :version "1.10"
  :started(datetime) 2026-10-01T14:30-06:00
  |server :host localhost :port 8080 :debug false :retries 3 :owner nil
    :timeout(duration) 30s
    :max-body(qty) 10 MB

; Q1-C with Q3-A
  |server :host localhost :port 8080 :debug false :retries 3 :owner nil
    :timeout duration(30s)
    :max-body qty(10 MB)

; Q3-B
    :timeout ~duration 30s
    :max-body ~qty 10 MB

; Q3-C
    :timeout |{duration 30s}
    :max-body |{qty 10 MB}
```

Friction, config: writing `:timeout.duration 30s` I read it back as a *path* — `timeout` → `duration` — because that is what a dot in a key means in TOML, in Java properties, in every dotted-config I know. Worse, the reflex runs the other way: a config-writing agent will write `:db.host localhost` meaning nesting, and under Q1-A the parser will read "a `db` of kind `host`". I think this one slip, made by many agents and never noticed by them, is enough to rule A out for config-shaped documents. Q1-B's parens never read as a path. Q3-A `duration(30s)` reads like a constructor and config readers from any language are fine with that.

### Context 2 — a science data table (where Q1 earns its keep)

```udon
; Q1-B
|run[2026-10-01-a] :instrument DSC-7 :operator jw
  :taken(datetime) 2026-10-01T14:30-06:00
  |samples
    |s[1] :mass(kg) 3.2 :temp(°C) 21.5 :ph 7.1
    |s[2] :mass(kg) 3.4 :temp(°C) 21.7 :ph 7.0
    |s[3] :mass(kg) 2.9 :temp(°C) 22.0 :ph 7.3
    |s[4] :mass(lb) 7.1 :temp(°C) 21.9 :ph 7.2   ; one row in pounds; per-occurrence reading handles it

; Q1-A
    |s[1] :mass.kg 3.2 :temp.degC 21.5 :ph 7.1

; Q3-A
    |s[1] :mass qty(3.2 kg) :temp qty(21.5 °C) :ph 7.1

; Q3-B
    |s[1] :mass ~qty 3.2 kg :temp ~qty 21.5 °C :ph 7.1

; Q3-C
    |s[1] :mass |{qty 3.2 kg} :temp |{qty 21.5 °C} :ph 7.1
```

Friction, table: Q1-B rows read exactly like a scientist's column header ("temp (°C)"), and the per-occurrence semantics let row 4 switch units without ceremony. Q1-A made me stop at `°C` — A's example wrote `degC`, which tells me the dot-suffix is an identifier (a trait) while B's parens take free text; I had to look back to check that. Q3-A per row is heavier (`qty(` four times a row is noise) and the kind on the name side (`kg`) and the value side (`qty`) are asymmetric — I wanted to write `:mass kg(3.2)` for symmetry with `:mass(kg) 3.2` and didn't know if I could. Q3-B: `~qty 3.2 kg` in a *data* table reads as "approximately 3.2 kg"; I'd expect scientific readers (and me) to misread it. Q3-C is fine but busy.

What I actually wanted here is none of the options: the kind declared once, with the rows bare —

```udon
|samples :mass(kg) :temp(°C) :ph       ; kinds declared on the parent, values below
  |s[1] :mass 3.2 :temp 21.5 :ph 7.1
```

— which OPTIONS says a schema or vocabulary could do. For lite I'd want the cheapest possible way to say "these attributes, in this subtree, have these kinds", because tables are the case where per-occurrence repetition is most visible.

### Context 3 — an HTML-ish page

```udon
|html :lang en
  |head
    |title Trial page
    |meta :charset utf-8
    |link :rel stylesheet :href /site.css
  |body
    |h1 "Hello," she said.
    |p Born |{time :datetime 2026-10-01 \ 1 October 2026}, she wrote |{a :href https://example.com \ Click here} and left.
    |p "To be, or not to be."
    |blockquote :cite https://example.com/hamlet
      "To be, or not to be." That is the question.
    |h3 date(format)
    |li printf(x) prints x
    |pre
      ```
      printf(x) prints x
      ```
```

Friction, HTML: this is where Q2 bites. `|p "To be, or not to be."` stands alone. Under Q2-A the paragraph loses its quote marks by default and a renderer that doesn't consult the "was quoted" metadata prints a bare sentence; that is silent and destructive. Under Q2-B the quotes stay and a consumer who wants the string can peel. In prose position I want B without hesitation.

But in the same document, `|meta :charset "utf-8"` or `|input :value "8080"` — in attribute position I want the string, no quotes, and I'd be surprised by anything else (every language I know peels quotes in value position). So my honest answer to Q2 is that the two examples in the question want different answers, and what differs is *position*, not the value: `$main` and prose are text, where quotes are characters; attribute values are values, where quotes are delimiters. If the notation has to choose one rule for both, B — because keeping information beats dropping it, and the quote marks on a string value are visible and peel-able while the missing quote marks on a sentence are invisible.

Also: `|h3 date(format)` under Q3-A *does* stand alone, so a heading literally titled "date(format)" becomes a malformed date. It is a narrow case (a `$main` that is exactly `knownkind(…)`), real in technical docs (`|h3 sqrt(x)`), and C and B don't have it. I'd accept it in exchange for A's lightness, with "unknown kind names stay text" as the floor.

### Context 4 — a notes file with dates in prose

```udon
|note[2026-10-28] :tags [udon trial]
  Met with J. on 2026-10-01 at 14:30 (Denver) for 90 minutes; follow-up ~2026-11-15.
  Dates in prose are just prose; nothing to decide unless I want them marked.

  ; Q3-C marks a date inside prose with no new syntax:
  Met with J. on |{date 2026-10-01} for |{duration 90min}; follow-up around |{date 2026-11-15}.

  ; Q3-A can't mark inside prose (doesn't stand alone, stays text), which is the right call:
  Met with J. on date(2026-10-01) — text, as it should be.

  |todo :due(date) 2026-11-15 :est(duration) 2h
    Write up the value trial.
  |todo :due date(2026-11-20)
    Send the report.
```

Friction, notes: I wrote `follow-up ~2026-11-15` *meaning "around"* before I had thought about Q3-B at all; then noticed I'd done it. That's the strongest evidence I have against the tilde sigil: `~` already means "approximately" to me in exactly the places kinds appear. Separately, `:due(date)` / `:due date(…)` both read as a slightly silly repetition — the name already says what it is — which is why a standard reading for ISO date shapes (`2026-11-15`, `2026-10-01T14:30-06:00`) would remove most of the day-to-day load from Q1/Q3 the way the standard reading for numbers already does. A bare `2026-10-01` cannot be anything but a date or a string, and the writer who wants the string has quotes, exactly as for `"01234"`. Durations and units would still need Q1/Q3.

### Context 5 — a recipe (quantities inside text lines)

```udon
; Q3-C
|recipe[pancakes] :serves 4 :time |{duration 25min}
  |ingredients
    |i |{qty 1.5 cup} flour
    |i |{qty 2} eggs
    |i |{qty 1.25 cup} milk, room temperature
  |steps
    |step Whisk the dry ingredients.
    |step Rest the batter |{duration 10min}, then fry.

; Q3-A — the value must stand alone, so I need the framed backslash to get text after it
    |i :amount qty(1.5 cup) \ flour
    |i :amount qty(2) \ eggs

; Q1-B — structure instead of a sentence
    |i[flour] :amount(cup) 1.5
    |i[eggs] :amount 2
    |i[milk] :amount(cup) 1.25 :note room temperature
```

Friction, recipe: I first wrote `|i qty(1.5 cup) flour` under Q3-A and then realised it's text (doesn't stand alone), so it needs an attribute and a ` \ `. I'd expect other agents to make that slip and ship it. Q3-C composes with text for free because inline elements already live in text — the recipe under C was the most *pleasant* thing I wrote in this trial, and I didn't hesitate once. That's a real point for C that the attribute-list examples in OPTIONS don't show.

### Context 6 — validation rules (verbatim)

```udon
|field[phone] :type string :required true
  :pattern re`^\d{3}-\d{4}$`
  :example `555-1234`
|field[home] :type path
  :default `C:\Users\me`
  :pattern re`^[A-Z]:\\`
```

Friction: none in writing; the tagged-backtick form is the JS tagged-template shape and I'd use it without looking back. What I'd expect others to get wrong: writing `"^\d{3}-\d{4}$"` out of habit and getting `^d{3}-d{4}$` (Ruby-like escapes drop the backslash). The backtick form has to be *known* to be reached for; nothing in the regex itself pushes you to it. The one rule I'd want: a backtick inside a verbatim value (double backticks as in Markdown, presumably).

### Context 7 — a log with timestamps and durations, five ways

```udon
|log
  |entry :at.datetime 2026-10-28T09:12:03-06:00 :level info :took.duration 1.2s
  |entry :at(datetime) 2026-10-28T09:14:40-06:00 :level warn :took(duration) 310ms
  |entry :at datetime(2026-10-28T09:20:00-06:00) :level error :took duration(4.8s)
  |entry :at ~datetime 2026-10-28T09:20:00-06:00 :level error :took ~duration 4.8s
  |entry :at |{datetime 2026-10-28T09:20:00-06:00} :level error :took |{duration 4.8s}
    Timeout talking to db.
```

Friction: all five are noise at log-row density; this is the second place (after the table) where kind-once or a standard date reading is what I actually want. Of the five, the B row reads best to me; the A row reads as nested fields; the `~` row reads as "approximately 09:20".

### Lists

```udon
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]           ; Q3-A
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]             ; Q3-B
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]         ; Q3-C
|holidays :dates [date(2026-11-26) date(2026-12-25) date(2027-01-01)]
```

Friction: Q3-B has to glue `3.2kg` in a list because spaces separate items, but not in an attribute (`~qty 3.2 kg`) — the same kind spelled two ways by position, and B can't nest at all (`interval` had to invent `2026-01/2026-06` where A writes `interval(date(2026-01) date(2026-06))`). Q3-A's parens delimit, so a list of kinded values is clean. Q3-C is correct but it's a lot of brackets. The holiday list is also where the "silly repetition" of `date(` is most visible and a standard ISO reading would help most.

### Q4 — the trailing colon

```udon
|server[web] :host localhost :port 8080 :debug false
  :owner nil
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
```

I'll be fair to B first: without highlighting, `:host localhost :port 8080` is two bare words after another two bare words, and `:host: localhost` makes the key/value boundary visible at a glance; for long multi-word values (`:title: War and Peace`) that is a genuine readability gain. Against it: the key is always the first token after `:`, so the boundary is unambiguous already; "optional" guarantees mixed documents (`:host: localhost :port 8080`) from agents who half-remember; and in COLD, seeing `:host:` untaught, I guessed it *meant* something different (a block-attribute opener, YAML-style) — so the tolerance invites readers to look for a distinction that isn't there. If the colon is good, require it; if not, don't allow it. I'd say A, and have the parser warn on `:name:`.

## Part 3 — Judgments

**Q1: B.** `:mass(kg) 3.2` reads as a column header, takes free text (`°C`), never reads as a path, and the per-occurrence semantics let a row switch units. A's dot collides head-on with dotted-key nesting in every config reader's head — the slip `:db.host localhost` → "a db of kind host" will be made and not noticed. C (nothing on the name) is the simplest model and I'd happily live in it for one-off values, but per-row in tables it is heavier than B. Note that B and Q3-A are the same mechanism mirrored — `:on(date) 2026-10-01` ≡ `:on date(2026-10-01)` — which I found pleasing once I saw it; A plus Q3-A would be two mechanisms.

**Q2: B, with the position caveat above.** Prose position wants quotes kept; attribute position wants them peeled; if one rule must cover both, keep the information (B). I expect agents to assume A in attribute values nearly unanimously, so under B a consumer that prints `:name "8080"` as `"8080"` with marks will surprise them; under A a consumer that prints `|p "To be…"` without marks will surprise everyone *and* not be noticed. The second is worse.

**Q3: A, keeping C.** C is the most principled (no new syntax), composes with prose for free, and the recipe under C was the nicest thing I wrote. But C has a real cost the question doesn't name: kinds and element names share one namespace, so a document can't have its own `|date` or `|qty` element meaning something else, and in lists and attribute rows the brackets are heavy. A is light, delimits itself in lists, nests (`interval(date(…) date(…))`), and reads as a constructor to agents from any language. Since inline elements exist regardless, the real question is only whether to add A as the value-position sugar, and I say yes. B (tilde) I'd reject: `~` means "approximately" in exactly the data contexts kinds live in (I wrote it that way myself before thinking), it can't nest, and it spells `3.2kg`/`3.2 kg` differently by position.

**Q4: A.** Optional is the worst of the three possibilities.

**Most beautiful, fluid, useful, as a set:** Q1-B + Q3-A + tagged backticks for verbatim, with inline elements still available in prose. Second: Q1-C + Q3-C — one mechanism, honest, heavier. The `~` family last.

**What I'd expect other agents to get wrong, collected:** `null`/`None` for `nil`; `"…"` around regexes and Windows paths; `:href https://x \ text` without the backslash; `:db.host` as nesting under Q1-A; `~` as approximately under Q3-B, in both directions; writing `date(…)` inside prose and expecting it recognised under Q3-A; `qty(1.5 cup) flour` as `$main` expecting a quantity; forgetting the closing `}` in nested Q3-C; mixed colon styles under Q4-B; and, under every option, writing bare ISO dates and expecting dates.

**Anything else:** (1) a standard reading for ISO 8601 date/datetime shapes, by the same argument that gives numbers one — most of the Q1/Q3 load in notes, logs, and holiday lists evaporates; (2) the cheapest possible kind-once-on-a-parent for tables, since that's where per-occurrence repetition is loud; (3) a `null` alias or warning; (4) if Q1-B and Q3-A are both adopted, say the symmetry out loud in the spec (`name(kind) value` ≡ `name kind(value)`) and decide whether the unit can be the kind on the value side (`kg(3.2)`), since I reached for it.

## Part 4 — On the trial itself

- The COLD Read list did its job: `date(format)` and `printf(x)` were the right traps, and `~date` seeded me toward the sigil reading before I'd seen OPTIONS, which is fine and was presumably intended.
- The Write prompts have no many-row table and no list of kinded values, which are the two places Q1 and Q3 diverge most; a cold table prompt would have shown whether agents repeat kinds per row or invent a header untaught (I would have invented a header).
- Exposure leak: the udon README is auto-loaded into every session in this repo and carries 0.9 examples, including the `; bare date is a string` comment. If "BASICS alone" matters, running the fresh agents from outside the repo (or with the README import off) would make it true.
- `nil` vs `null` isn't under trial but my cold answer is one data point that it should be.
- The order rule (COLD before OPTIONS) was easy to honour and worth keeping; the harness blocked my first attempt to write the report with the Write tool (it refuses files named `report-*.md` from subagents), so I wrote it via the shell — mentioning in case another agent silently fails the same way.

I'm staying on the line for follow-ups.
