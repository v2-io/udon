# Trial: Opus 5.5, primed (full lite spec)

*2026-10-28. Written by an Opus 5.5 instance, before reading any other trial file. (Asked for as `report-opus-primed.md`; the harness refused that name, and the coordinator moved it here.)*

## What I read, in what order

1. `main.outline.md`, `CTQ-FACTORS.md`, then cards: all of `def-value`, `def-typed-value`, `def-string`, `def-text`, `def-delimited-string`, `def-reading-option`, `def-label` (whole files, working notes included); `rule-unquoted-run-is-one-value` and its context file, `rule-opaque-span-raw-text`, `rule-nil-spelling`, `rule-missing-value`, `rule-list-items-whitespace-separated`, `rule-key-holds-a-value` (whole); the Statement-through-Discussion parts of `rule-text-value-end`, `rule-line-scan`, `rule-leftover-values`, `rule-attribute-with-no-value-takes-next-value`, `rule-element-values`, `rule-framed-comments`, `rule-value-line-escapes`, `rule-adjacent-quoted-strings`, `rule-space-before-text-end`, `rule-main-is-attribute`, `rule-reserved-spellings`, `rule-main-label-colon-warns`; the headlines of the `obj/` files. I read the rest of the outline's statements but not every card.
2. `BASICS.md`, then `COLD.md` (the whole file, Read section included, before I wrote anything), then my COLD answers, then `OPTIONS.md`.

**On independence.** I did not open anything in `.int/` outside this trial directory. Two things you should know, though:
- **The cards' own working notes carry the value debate.** They contain Joseph's 2026-10-21 lean ("C with the view": bare is text, `<…>` types, a view reads bare primitives), his 2026-10-20 reopening of `<…>`, his 2026-10-22 "`<…>` in all of its forms is still very cheap to change", and coordinator leans on vocabulary. So "primed" here means primed by those leans as well as by the rules. Expect the primed panel to lean toward the current direction more than the BASICS-only panel does.
- A directory listing showed me the *names* of files in `.int/` (`spike-values-2026-10-22/`, `ADJUDICATION-GUIDE.md`, `audit-*.md`, `coordinator-final-thoughts.md`). I saw names only, no content.

**A collision you should fix in the trial setup.** I saved my COLD answers to `<scratchpad>/cold-answers.md` before opening OPTIONS. When I came back, that file held another agent's COLD answers. Its header and items were different; I saw its first line and its last few lines, about `:host:` and `printf(x)`, and then stopped reading. Parallel trial agents in this session seem to share one scratchpad directory. I copied my answers below from my own write call, so they are verbatim. But another agent may have lost *its* copy, or may be quoting mine if it wrote first and read later. If two trial files have identical COLD sections, that is the likely cause.

---

## COLD answers (verbatim, as first written, before OPTIONS)

*Exposure: I had read the full lite spec (def/ and the value-related src/ cards, including their working notes) before writing these. So "untaught" here means "taught the spec, not taught the options". Where the spec changed what I'd otherwise have written, I say so.*

### Write

**1. Sample, 3.2 kg and 21.5 °C**

```udon
|sample :mass 3.2 kg :temperature 21.5 °C
```

What I actually reached for first was the unit next to the number, as a person writes it. I hesitated over `:mass-kg 3.2` (the JSON habit: unit in the name, a bare number as the value). I chose the first because it's what the sample *is*, but I'd want a rule: is `3.2 kg` a quantity anything can check, or just text? From the spec, it's text, which I'm fine with for a lab notes file and not for a data table. If I wanted it checked I'd guess `:mass <3.2 kg>`, and I have no idea whether lite accepts that.

**2. Event: 1 Oct 2026, 90 minutes, 14:30 in Denver**

```udon
|event Planning review
  :start 2026-10-01T14:30 America/Denver
  :duration 90 min
```

First instinct was ISO 8601 with an IANA zone name, because "in Denver" is a place, not an offset (-06:00 would lose the DST meaning). I nearly wrote `:duration PT90M` and backed off: no agent or person reads PT90M faster than `90 min`. Hesitation: whether `14:30` on a sameline is safe (it is: no space before the `:`). Spec-priming: I know dates were meant to go in `<…>`, and I *didn't* write `<2026-10-01>` because the spec has `<…>` reopened and possibly an error for non-primitive interiors; untaught I'd also not have written it.

**3. Regex `^\d{3}-\d{4}$` and path `C:\Users\me`**

```udon
|rule :pattern '^\d{3}-\d{4}$'
|file :path 'C:\Users\me'
```

Confident. Single quotes because the backslashes are then literal (only `\'` and `\\` escape). Bare would hit the value-line backslash rule (`\d`, `\U` are errors under the proposed set), and double quotes would make `\d` an error. Untaught, I'd have reached for single quotes anyway from Ruby/shell habit.

**4. Server**

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner nil
```

Bare everything. Hesitation on `nil` vs `null`: BASICS doesn't say, and JSON habit says `null`; I wrote `nil` only because the spec told me. Hesitation two: I know from the spec that bare `8080`, `false`, `3`, `nil` are texts (read as primitives only through a view). Writing a config, I didn't want to type `<8080>`, `<false>`, `<3>`, `<nil>`, and I didn't. If the trial is asking what agents write untaught: bare, every time.

**5. "Hello," she said.**

```udon
|p
  "Hello," she said.
```

My first instinct was `|p "Hello," she said.` on one line, then I stopped: a leading `"` on the sameline makes a quoted string, and the rest becomes a second value. Prose under the element keeps the quotes as characters. This is a real trap; I only avoided it because I'd just read the string/text cards.

**6. A list of three holiday dates**

```udon
|holidays :dates [2026-11-26 2026-12-25 2027-01-01]
```

or, if they have names (what I'd actually want in a real file):

```udon
|holidays
  |day 2026-11-26 Thanksgiving
  |day 2026-12-25 Christmas
  |day 2027-01-01 New Year's Day
```

In the second form I hesitated over `$main` holding `2026-11-26 Thanksgiving` as one text: the date and name run together. I'd probably write `|day[2026-11-26] Thanksgiving` (the date as the key). That felt good.

**7. Version 1.10 (a string) and zip 01234**

```udon
|part :version "1.10" :zip "01234"
```

Quoted, from YAML scars, immediately. I know the spec makes bare `1.10` a text anyway, but the typed-primitive view would read `1.10` as 1.1 and maybe `01234` as 1234, so quoting is the only spelling that's safe under every reading. I'd expect most agents to quote these too.

**8. HTML-ish link**

```udon
|a :href https://example.com \ Click here
```

Confident (BASICS shows exactly this). `https:` doesn't start an attribute because there's no space before the colon. Inline in a paragraph: `See |{a :href https://example.com \ Click here}.`

### Read

- `|p "Hello," she said.` — `p` with `$main` stacked twice: the string `"Hello,"` then the text `she said.`. ~85% sure from the spec. An untaught reader would expect one text with the quotes in it; that's the meaning the author almost certainly wanted. A warning would be welcome here.
- `|sample :mass.kg 3.2` — Probably intended "mass, in kg, is 3.2". As lite parses it: I'd guess an attribute named `mass.kg` (one name, the dot a name character) with the text `3.2`. ~40% sure it's even legal; traits are an element thing, and I don't know if `.` is allowed in an attribute name. If `.kg` were an attribute trait, that would be a lovely way to say the unit, but I've seen no rule for it.
- `|sample :mass(kg) 3.2` — Intended the same as above. As lite: either an attribute named `mass(kg)` or an error (parens not label characters). ~30%. Reads naturally to a human (column-header style), which is exactly why I'd expect writers to produce it.
- `|ev :on date(2026-10-01)` — Intended: a typed date, constructor-style. As lite: the text `date(2026-10-01)`. ~75% it's just text. Looks like code, which is the risk: a reader will believe something parsed it as a date.
- `|ev :on ~date 2026-10-01` — Intended: a type marker `~date` applied to the value. As lite: text `~date 2026-10-01`, unless `~` is reserved somewhere I haven't seen. ~60%. I'd be surprised to learn `~` means anything.
- `|h3 date(format)` — A heading whose text is `date(format)` (documentation of a function). ~95%. This is the line that makes `name(…)` dangerous as a type syntax in any value position that can also be prose-ish.
- `|config :server.port 8080` — Intended: nested `server` → `port` = 8080 (TOML dotted keys). As lite: one attribute named `server.port` with the text `8080` (8080 under the view). ~50% on the name being legal; ~10% that lite would nest it.
- `|server :host: localhost` — Intended: `host` = `localhost` (YAML habit). As lite: I'd expect an error or warning saying "did you mean `:host localhost`?" ~60% something complains; if it doesn't, the attribute name is `host:`, which is a silent miss.
- `|li printf(x) prints x` — `li` with `$main` text `printf(x) prints x`. ~95%.

*(End of verbatim COLD answers.)*

**Looking back at COLD after seeing the options**, three things stand out:
- Untaught, I annotated nothing. Every value went in bare, and the attribute name did the work (`:mass 3.2 kg`, `:start …`, `:duration 90 min`). Kind annotation was never my first move, not even for the event.
- The one place I *did* reach for a typing form, I reached for `<3.2 kg>`. Q3 doesn't offer `<…>`, even though it is lite's existing construct for exactly this. More on that under *Anything else*.
- My COLD hesitations correspond to OPTIONS questions: `"Hello," she said` is Q2, `:mass-kg` against the unit in the value is Q1, `nil`/`null` is the preamble, and `:host:` is Q4. The trial is aimed at the right places.

---

## Writing under the options

I wrote the same content across options in six contexts: a service config, a science data table, an HTML page (including API docs), a notes file with dates in prose, a recipe, and a package manifest. Friction notes sit right under each block, where I hit them. The question-by-question synthesis comes after.

### 1. A service config

**Q1-A (dot on the name)**

```udon
|service[api] :image registry.local/api:2.4 :replicas 3
  :listen.port 8080
  :timeout.duration 30s
  :max-body.bytes 512MB
  :cert-expires.date 2027-01-15
  :owner nil
```

- **Friction, and a real miss.** I wrote `:listen.port` meaning a nested path, "listen → port", out of TOML habit, *while writing under option A*. Under A it means "the attribute `listen`, whose value is a `port`". I didn't notice until I reread it. That is the exact silent miss COLD's `:config :server.port` probes, and I made it myself with the option in front of me.
- **Hesitation:** is `.bytes 512MB` right, or `:max-body.MB 512`? A uses one slot for two different things, a *unit* (`.kg`) and a *type* (`.date`, `.duration`), and I had to pick which one this was. I had to look back at the examples to decide.

**Q1-B (parens on the name)**

```udon
|service[api] :image registry.local/api:2.4 :replicas 3
  :port 8080
  :timeout(duration) 30s
  :max-body(bytes) 512MB
  :cert-expires(date) 2027-01-15
```

- Smoother; nothing in it reads like a path. But in a config, `(duration) 30s` felt like plumbing: `30s` already says what it is, and a config has a schema in mind. Honestly I'd write `:timeout 30s` and leave it at that. All the options allow that.

**Q3-A (name with parentheses on the value)**

```udon
|service[api]
  :timeout duration(30s)
  :cert-expires date(2027-01-15)
  :max-body size(512MB)
  :route re`^/api/v\d+/`
  :log-dir `C:\ProgramData\api\logs\`
```

- Easiest of all to write: it's CSS functional notation (`url(…)`, `rgb(…)`, `calc(…)`), which every agent has written thousands of times. I made up `size` without hesitating, so the vocabulary felt open.
- The backtick verbatim form is the best thing on the sheet for this context. `` `C:\ProgramData\api\logs\` `` ends in a backslash, which **cannot be written in single quotes** (`'…\'` is the `\'` escape) without doubling it. Backticks have no escapes, so it just works. And ``re`…` `` reads like a JS tagged template.

**Q3-B (sigil)**

```udon
|service[api]
  :timeout ~duration 30s
  :cert-expires ~date 2027-01-15
  :warmup ~5 min            ; meant "about 5 minutes"
  :home ~deploy/releases    ; meant the deploy user's home
```

- **Friction:** both of the last two lines are things I would genuinely write in a config or notes, and under B both collide with the sigil. `~5` is probably safe if a name can't start with a digit. `~deploy/releases` is not safe: it is the sigil `deploy` applied to `/releases`. And `:eta ~two weeks` would be the kind `two` applied to `weeks`. `~` means "approximately" in agent and human prose far more often than it means anything else, and it is the home-directory prefix in paths.
- `~date 2027-01-15` also reads to me, faintly, as "approximately a date". I never stopped feeling that.

**Q3-C (inline element)**

```udon
|service[api]
  :timeout |{duration 30s}
  :cert-expires |{date 2027-01-15}
```

- Heavier to type and to scan. But writing it I knew exactly what the tree would be (an element named `date` whose `$main` is `2027-01-15`), with no new rule to remember.
- **A trap I nearly fell into:** `:cert-expires |date 2027-01-15 :renew |duration 30d`. Without braces this is still legal lite (an element value, [[rule:element-values]]), but the block-form `|date` takes `:renew` as *its own* attribute. A silent nesting miss. Agents will drop the braces at the end of a line, where it works, and then add a second attribute after it.

**Q2 in the config**

```udon
|part :version "1.10" :zip "01234" :name "8080"
```

- Under **Q2-A** this is exactly what I meant: three strings, quotes as protection. That's why I quoted them in COLD.
- Under **Q2-B** the tree holds `"1.10"` with its quote marks, "also readable as the string inside". A config loader that reads text, rather than asking for the string reading, gets a version with literal quote marks in it. Quoting is the move agents make *to be safe*. Under B, being safe depends on which reading the consumer asks for.

**Q4 in the config**

```udon
; A
|server[web] :host localhost :port 8080 :debug false
  :owner nil
; B
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
```

- B looks like YAML that has had a `:` glued on the front. Reading it, I counted colons. And it made me want YAML's *other* behaviors next (`:tls:` followed by indented `:cert: …` as a nested map). Nested attributes are reserved in lite, so tolerating the colon invites an expectation that the next construct then refuses.

### 2. A science data table

**Q1-B**

```udon
|run[2026-10-01-a] :instrument Mettler XS205 :operator jw
  |s[S-001] :mass(kg) 3.2   :temp(°C) 21.5 :rh(%) 41 :taken(datetime) 2026-10-01T14:30Z
  |s[S-002] :mass(kg) 3.4   :temp(°C) 21.7 :rh(%) 40 :taken(datetime) 2026-10-01T14:45Z
  |s[S-003] :mass(kg) 3.19  :temp(°C) 21.6 :rh(%) 41 :taken(datetime) 2026-10-01T15:00Z
  |s[S-004] :mass(kg) 3.2 ± 0.05 :temp(°C) 21.5 :rh(%) 42 :taken(datetime) 2026-10-01T15:15Z
  |s[S-005] :velocity(m/s) 0.82 :accel(m/s²) 9.79 :conc(µg/mL) 12.5
```

- **This is where B shines.** Scientists write column headers as "mass (kg)", and the parens hold any unit symbol: `°C`, `%`, `m/s²`, `µg/mL`. Writing it felt like writing a table header.
- **Friction 1:** I repeated the kinds on every row. That's plumbing per fact (CTQ A5). In a real file I'd want to say it once, on the parent or in a schema. Every option leaves that to a schema, but in a lite file with no schema the repetition is the whole cost. I'd have liked something like `|run :columns mass(kg) temp(°C)`, and I'd want that to *be* the schema, not a fourth thing.
- **Friction 2: the space.** The natural CSV header is `mass (kg)` *with a space*. An agent converting a CSV will write `:mass (kg) 3.2`, which under B is the attribute `mass` with the text `(kg) 3.2`. That parses without complaint to a different tree, which is the worst kind of miss (CTQ A2 weighs silent misses most). I expect this to be the most common B error, and it's worth a warning ("a value starting with `(` right after an attribute name; did you mean `:mass(kg)`?").
- `3.2 ± 0.05`: an uncertainty is just text after the kind, which is fine. I didn't hesitate.

**Q1-A**

```udon
  |s[S-001] :mass.kg 3.2 :temp.degC 21.5 :rh.pct 41 :taken.datetime 2026-10-01T14:30Z
  |s[S-005] :velocity.m/s 0.82 :conc.ug/mL 12.5
```

- **Friction:** I had to transliterate every unit into something name-shaped (`degC`, `pct`, `ug/mL`), and `m/s` in a name is either illegal or a path separator waiting to happen. A puts units inside the label character set, and units don't live there. The sheet itself had to borrow B's parens for parameters (`:when.date(YY-MM-DD pivot 1950)`), which tells me A can't carry parameters on its own.
- What I *did* like: on elements, `.trait` says what kind of thing the element is. A dot on an attribute saying what kind of thing the value is would be the same idea in the same spelling. If A were restricted to *types* (`.date`, `.duration`) and never units, that parallel would be really beautiful. It is the dotted-path habit that sinks it, not the idea.

**Q3-A / C on a table**

```udon
  |s[S-001] :mass qty(3.2 kg) :temp qty(21.5 °C) :taken datetime(2026-10-01T14:30Z)
  |s[S-001] :mass |{qty 3.2 kg} :temp |{qty 21.5 °C} :taken |{datetime 2026-10-01T14:30Z}
```

- Honest for heterogeneous data, where one row's mass is in lb. For a uniform table, the unit on every value reads as noise, and the columns no longer line up.

### 3. An HTML page, with an API reference section

```udon
|article.release-notes
  |h1 Release 2.4
  |p Shipped |{time :datetime 2026-10-01 October 1}, about three weeks late.
  |blockquote "Ship it when it's right, not when it's Tuesday."
  |p See |{a :href https://example.com/changelog \ the full changelog}.

  |section[api]
    |h2 API changes
    |h3 date(format)
    |p Formats the date using |{code format}; see |{a :href #now \ now()}.
    |h3 now()
    |p Returns the current time.
```

- **Q3-C is already how HTML does it.** HTML's answer to "this value is a date" is `<time datetime="2026-10-01">October 1</time>`, an element. `|{time :datetime 2026-10-01 October 1}` is C, and it works *inside prose*, which A and B can't do (more under context 4).
- **Q3-A's silent miss is right here.** `|h3 date(format)` and `|h3 now()` each stand alone, so under A they become notation values, `date` applied to `format` and `now` applied to nothing. API reference pages are full of headings exactly like these. If A's rule is a parse rule, every one of them changes kind silently. If A is a *view* that a consumer asks for (as the typed-primitive reading is), then the raw tree keeps them as text and only a consumer that asked for notations sees `date(format)` as one. That distinction decides whether A is safe for me, and the sheet doesn't say which it is.
- **Q2 here:** `|blockquote "Ship it when it's right, not when it's Tuesday."` Under Q2-A the quote marks are delimiters, so the rendered blockquote loses them. They are kept "as metadata", so a careful renderer can put them back, but a naive one won't. Under Q2-B they're kept. This is the one context where B is right and A is wrong. I'd write it as prose on the line below to be safe either way, which is what I did in COLD.

### 4. A notes file, dates in prose

```udon
|log
  |entry[2026-10-01] Planning call with Sam
    Agreed on the 3 week plan; first check-in |{date 2026-10-08}, review |{date 2026-10-22}.
    Budget is ~$12k (was $9k). Sam is out 2026-10-12 to 2026-10-16.
    ; todo: confirm the room
  |entry[2026-10-08] Check-in
    Slipped ~2 days. New review date(2026-10-24)?  ~date 2026-10-24
```

- **Only C works in prose.** `|{date 2026-10-08}` inside a sentence is an embed, a construct lite already has. `date(2026-10-24)` and `~date 2026-10-24` in prose are just characters, as they must be: if prose recognized them, `printf(x)` and "~2 days" would break in every paragraph. So A and B are notations for value positions only, while C is one notation everywhere (`prin-one-rule-everywhere`). For a notes file, where you want "find every date I mentioned", that settles it for me.
- I wrote the bare `2026-10-12 to 2026-10-16` without annotating, and I'd do so most of the time. The embed is for the dates I want a machine to find.
- `|entry[2026-10-01]`: a date as the key felt very natural. Under Q3-A it would be `|entry[date(2026-10-01)]`, which is fine. Under C, `|entry[|{date 2026-10-01}]` is ugly, and embeds in keys aren't decided anyway.

### 5. A recipe

```udon
|recipe Brown-butter cookies :serves 24
  :oven(°F) 350
  :bake(min) 9–11
  |ingredient[flour] :qty 2¼ cups
  |ingredient[butter] :qty 1 cup \ browned and cooled
  |ingredient[salt] :qty ½ tsp
  |step Bake until the edges are golden, ~10 min.
```

- Q1-B again reads like a cookbook (`Oven (°F)`). `:bake(min) 9–11` holds a range, and nothing complains, which is correct for lite.
- Under Q3-B, `~10 min.` in prose is safe (prose isn't scanned), but `:rest ~10 min` as a value is not, if `~` followed by a digit is ever a sigil. Recipes are full of tildes.
- I didn't want to annotate `2¼ cups` at all; `qty(2¼ cups)` felt like a lab notebook, not a recipe. The domain-forward spelling (CTQ A5) here is no annotation.

### 6. A package manifest

```udon
|package[udon-core] :version "0.9.0-alpha.2" :license MIT :edition 2021
  |dep[serde] :version ^1.0.190 :features [derive]
  |dep[memchr] :version >=2.5, <3
  |dep[log] :version ~0.4
  :released(date) 2026-07-19
  :repository https://github.com/v2-io/udon
```

- `~0.4` is Cargo's and npm's tilde requirement. Under Q3-B it's safe only if a sigil name can't start with a digit. `~latest` (which I've seen in dist-tags) would be a sigil. Manifests make `~` a real-world collision, not a hypothetical one.
- `>=2.5, <3`: the `<3` sits inside a bare run, so it isn't an explicit typed value. I checked myself here and had to look back at the rule for where `<` is a start (only at the beginning of a value). An agent less recently primed would hesitate too.
- `:version "0.9.0-alpha.2"`: quoted from habit, though bare would be text. Under Q2-A that's a string, as meant.

---

## Per question: friction, predicted mistakes, and what felt best

### Q1: kind on the attribute name

| | Felt | Where it hurt | What I expect agents to get wrong |
|---|---|---|---|
| **A** `:mass.kg` | Conceptually lovely as a parallel to element traits | Units don't fit in label characters (`°C`, `m/s`, `µg/mL`); one slot for units *and* types; parameters need parens anyway | Dotted paths (`:server.port`, `:listen.port`) read as kinds. I did this myself while writing under A. |
| **B** `:mass(kg)` | Most natural for tables and anything with units | Repetition per row (shared with A) | `:mass (kg) 3.2` with a space, which silently becomes text |
| **C** (on the value) | Right for heterogeneous values | Noisy and unaligned in tables | (see Q3) |

**My pick: B.** It's how people already write headers, its interior can hold any unit or parameter, and its most likely mistake has an obvious warning. I'd use it rarely outside data tables. If a lite file could declare kinds once per column (or per element name), I'd use that before any per-occurrence kind.

### Q2: a quoted value standing alone

The premise first: `|p "Hello," she said.` as one text with its quote marks is **right**, and it fixes the COLD trap I flagged (the current cards make it two `$main` values). I'd want this regardless of A or B.

- **A (string):** what every agent expects in data. `"8080"`, `"1.10"` and `"01234"` are quoted *to protect them*, and A protects them. Its cost is the standalone quotation in prose (`|blockquote "…"`), which loses its marks unless the renderer consults metadata.
- **B (text keeping marks, readable as the string):** more faithful as a raw tree, and it would dissolve the string/text split Joseph worried about ("I do worry about 'string' being its own distinct type from 'text'"). But escapes make the "text" ugly. `:a "say \"hi\""` as text either keeps the backslashes (so a renderer shows them) or resolves them (so it isn't what was written). And the safe-quoting move then depends on the consumer asking for the right reading.

**My pick: A.** It's the reading I'd guess untaught, and the one that makes the protective quote work. For the prose quotation, the remedy is prose below the element. I'd also want a warning when a standalone quoted `$main` sits on an element whose name suggests prose, but I don't know how lite would know that, so I'd leave it out.

One consequence to check: under the "stands alone" premise, `:tags "a" "b"` and `|el "x" "y"` become one text each (`"a" "b"`), where the cards made them two values. I think writers who wrote two quoted things side by side usually meant two values. That's rare enough not to matter much, but it is a change in the cards' adjacent-strings rule.

### Q3: a value that names its own notation

- **A `date(…)`** is the most fluid and the most guessable once seen once: CSS taught every agent this shape. Its costs are the API-doc headings (`|h3 now()`) and its "stands alone" rule (see the streaming note below). It needs a new node kind in the tree (name + raw body).
- **B `~date …`** is the one I'd drop. `~` already means "approximately", "home directory" and "tilde requirement" in text agents write daily, so a sigil on it misfires in config, notes, recipes and manifests. Its extent also differs between a line and a list. The sheet itself writes `~qty 3.2kg` (no space) in the list and `qty 3.2 kg` elsewhere, because in a list the item ends at the space. That's a mistake waiting to happen, made visible by the sheet's own author.
- **C `|{date …}`** adds no syntax, no node kind and no rule. It works in prose, values, lists and (eventually) keys, and HTML already does it this way (`<time>`). It costs braces and pipes on dense lines, plus the brace-less trap from context 1.

**My pick, holding both honestly: C as the one notation that works everywhere, with A as the strongest candidate for a compact sameline spelling.** If A comes in, I'd want it as *the same tree as C*: `date(2026-10-01)` ≡ `|{date 2026-10-01}`. Then there's one model with two spellings rather than two models. I'd also want it as a parse rule only on attribute values, never `$main`, so headings stay text. But that breaks "one scan for element lines and attribute lines" ([[rule:line-scan]]), and I don't see how to have both. If it has to be one or the other, C. I trust it more, and its verbosity falls where annotation is rare anyway.

**The backtick verbatim form** (listed "in every option") deserves to be its own question, because I liked it more than anything else on the sheet. It is the only lite spelling for a value that ends in a backslash, it means "literal" exactly as backticks do in Markdown prose (so value and prose agree), and the tag form ``re`…` `` is self-explanatory. Edges to settle: a backtick inside (Markdown's double-backtick answer, with three becoming a fence opener after a space); whether ``tag`…` `` is Q3-A's notation with a different bracket (I think it is, and that's a reason to unify them).

### Q4: trailing colon on attribute names

**My pick: A, plus a teaching error for `:host:`.** "Did you mean `:host localhost`?", in the same family as the `$main` `label:` warning. B gives every attribute two spellings (CTQ A7). It spends the `name:` shape, which XML namespaces (`:xlink:href`, `:xml:lang`) and any future nested-attribute syntax might want (B6). And it invites the rest of YAML, which lite then refuses. My COLD expectation was that `:host:` would be an error or warning; I'd make it an error, since reserve-don't-ignore suggests error over silent acceptance, with the fix in the message.

---

## Anything else

1. **`<…>` is missing from Q3, and it was my own untaught instinct.** In COLD #1 the only typing form I reached for was `:mass <3.2 kg>`. Lite already has `<…>` as the explicit-typed value. It commits at its first character (no "stands alone" holdback), it can't collide with `printf(x)` or `~5 min`, and its headroom is already spent. `<date 2026-10-01>` even reads like what C means, an element-ish thing named `date` with content. I don't know why it's not on the sheet. Joseph has reopened `<…>` wholesale, so maybe it's being redesigned, but agents who've read the spec will compare everything against it. For the record, on the same content:

   ```udon
   |ev :on <date 2026-10-01> :lasts <duration 90 min> :span <interval 2026-01/2026-06>
   |sample :mass <qty 3.2 kg> :temp <qty 21.5 °C>
   |meta :values [<date 2026-10-01> <qty 3.2 kg> 42 hello]
   ```

   Weighed against A, it is a touch heavier and noticeably more "markup". Weighed against C, it is lighter but doesn't work in prose, where `<…>` is HTML. I'd still put it in the comparison.

2. **Streaming (CTQ B1).** Q2's "a quoted value counts only if nothing else follows" and Q3-A's "the value must stand alone" both mean the parser doesn't know the value's kind until the closing `"`/`)` *plus* a look past any spaces. That's bounded by the line, but lines aren't bounded. It's the same shape as the `4938…2p` objection Joseph raised against typing whole runs. It's fine if the event wire can emit the characters first and the kind at the end, as the old parser did with bare values. I flag it because the options don't mention it, not as a verdict. B, C and `<…>` commit at their first character.

3. **Views vs tree rules.** The sheet's preamble already makes bare primitives a *standard reading* over text. Q2-B is the same move for quotes, and Q3-A could be the same move for notations (`date(…)` stays text; a reading recognizes it). Taken together, that's a coherent design: the raw tree is texts and elements, and every typing is a named reading. It's worth asking whether that's the design, because it changes my answers. Under it, the `|h3 now()` hazard disappears and Q2-B looks better. The cost is that "what does this document mean" then depends on which readings the consumer turned on. That's a real cost for a data notation, and it's why I still chose Q2-A.

4. **Declare once.** In every data-shaped context my main cost was repetition, not the spelling. Whatever wins Q1 or Q3, a way to say "this attribute, under this element, is a `date`" once per file would remove most of the annotations I wrote. All the options say "a schema could"; I'd want the smallest in-document form of that to be part of how these options are judged, because without it each option is judged at its noisiest.

---

## On the trial's design

- **The shared-scratchpad collision** (top of this file). Worth a per-agent filename in the brief, or a note that scratchpads are shared.
- **COLD's Read section shows the option spellings** (`:mass.kg`, `:mass(kg)`, `date(…)`, `~date`, `:host:`). I read the whole file before writing, as most agents will, so my Write answers could have been primed by them. I don't think they were (I annotated nothing), but I can't rule it out. Splitting Read into its own file, opened after Write is saved, would make the Write answers cleaner evidence.
- **OPTIONS' premises differ from the current cards**: quoted-plus-more becomes one text (the cards give two values), and bare primitives get a standard reading (the cards' view, default undecided). That's fine for a trial. But a primed agent spends a moment working out whether the sheet is proposing changes or describing the current spec. One line saying "these premises are assumed for the trial and may differ from the cards" would save that.
- **The backtick verbatim form is new syntax presented as background.** It's attractive enough that it may pull answers toward whichever Q3 option it seems to pair with (for me, A). It may deserve its own row.
- **Q1's options mix units and types in one slot** (`.kg` beside `.date`). An agent's preference might be different for each, as mine was for A. Splitting them, or asking for each separately, would sharpen the signal.
- **The harness refuses filenames containing "report"** for subagent writes. Future briefs could name the file `trial-*.md` from the start.
- What worked: the same content across options made the frictions visible quickly, especially in the sheet's own examples (the `3.2kg`/`3.2 kg` inconsistency in Q3-B, and the parens borrowed into Q1-A).

I'm on the line for follow-ups.
