*Saved by the coordinator from the agent's returned message: the harness refused the agent's own write. The agent's pre-OPTIONS copy of its COLD answers is timestamped 21:04:48 MDT in the session scratchpad (`cold-answers.txt`), before it opened OPTIONS.md. Content as returned.*

# Trial report: Opus (BASICS-only arm)

## What I was exposed to (read this first)

- I read `BASICS.md` and `COLD.md`, wrote the COLD section below, and saved a copy before opening `OPTIONS.md`.
- **Contamination to discount.** My harness auto-loaded the udon umbrella `CLAUDE.md` and `README.md`, as it does for every agent started in the udon repo. The README shows some 0.9-era conventions: `:urgent?` as a flag form, `:date 2025-12-22 ; bare date is a string; temporal is moving to a <…> dialect`, and a mention of `<…>` typing. Where I think it touched an answer, I say so.
- I did not open the spec store, the spec-lite cards, or other reports. The shared scratchpad holds the coordinator's files (`a1.txt`, `def-all.md`, `spikes-final.md`, …), and I didn't read any of them.

## COLD answers (verbatim, as first written, before OPTIONS)

### Write

**1. Sample: mass 3.2 kg, temperature 21.5 °C**

```udon
|sample :mass 3.2 kg :temperature 21.5 °C
```

This was my first instinct and the one I'd actually type. Hesitations:
- I don't know whether `3.2 kg` is a string or a quantity. I'd want a rule that "number, space, unit" is a quantity.
- `°C` is non-ASCII. Plenty of agents would write `21.5 C`, `21.5 degC` or `21.5C`, so I'd want the unit vocabulary to accept at least `°C` and `degC`.
- A competing instinct, from CSV and spreadsheet habits, is `:mass_kg 3.2`, which puts the unit in the name. I'd use it only if I'd been told values must be bare numbers.

**2. Event: 1 October 2026, 90 minutes, starting 14:30 in Denver**

```udon
|event :start 2026-10-01 14:30 America/Denver :duration 90 min
```

Alternative I nearly wrote: `:date 2026-10-01 :start 14:30 :tz America/Denver :duration 90 min`. Hesitations:
- Is a space between date and time OK, or do I need `T`?
- Do I write `America/Denver` (IANA), `Denver`, or `-06:00` (MDT on that date)? I'd want the IANA zone to be legal. The offset alone loses the intent ("Denver time"), and the city alone is ambiguous.
- For duration, `90 min` is what I reach for. `PT90M` feels like serialization rather than writing, and `90m` collides with metres.

**3. Regex `^\d{3}-\d{4}$` and Windows path `C:\Users\me`**

```udon
|rule :pattern ^\d{3}-\d{4}$
|file :path C:\Users\me
```

I wrote both unquoted on purpose. BASICS says `"…"` has Ruby-like escapes, so `"^\d{3}…"` risks `\d` being eaten. Unquoted seemed to be where backslashes are literal, since only a *framed* ` \ ` is special. Hesitations:
- Does `{` mean anything outside `|{`?
- Does `$` mean anything, given `$main` exists?
- Is `C:\` safe, since it has a colon not preceded by a space?

If I were nervous I'd fall back to single quotes (`'C:\Users\me'`), assuming Ruby-like single-quote semantics where only `\\` and `\'` are escapes. I'd want an explicit statement that unquoted values never interpret backslashes except the framed ` \ `.

**4. Server: host localhost, port 8080, debug off, retries 3, owner explicitly null**

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner null
```

Hesitations: are `false` and `null` booleans and null, or the strings "false" and "null"? Given UDON's stated anti-Norway stance, I'd half-expect them to be strings and would want to be told. For null I considered a bare `:owner` with no value, but that could equally mean empty string or a true flag. The README's `:urgent?` (contamination) pulls me toward `:debug?`-style flags for true, but I don't know how to write "explicitly false" that way. `:owner null` is my honest first write; `nil` was a close second.

**5. Paragraph: "Hello," she said.**

```udon
|p "Hello," she said.
```

This is what I'd naturally type, and I expect it to be literal prose with the quotes kept. But BASICS makes `"…"` a quoted value, so I'm not sure the first token won't be eaten as a quoted `$main` with ` she said.` left over. To be safe I'd write it as an indented text child:

```udon
|p
  "Hello," she said.
```

The fact that I'd feel the need to do that is itself the friction.

**6. List of three holiday dates**

```udon
|calendar :holidays [2026-11-26 2026-12-25 2027-01-01]
```

Or, when the holidays carry names, children: `|holiday 2026-12-25 :name Christmas`. No hesitation over list syntax, only the usual one over whether `2026-12-25` is a date or a string.

**7. Part: version 1.10 (string), zip 01234**

```udon
|part :version 1.10 :zip 01234
```

First typed unquoted, then I hesitated and wanted to quote both (`:version "1.10" :zip "01234"`) out of YAML-trauma reflex. If unquoted values are strings unless something types them, unquoted is right and the quoting is noise. I'd want BASICS to say that one way or the other.

**8. Link: target https://example.com, text "Click here"**

```udon
|a :href https://example.com \ Click here
```

Inline in prose: `See |{a :href https://example.com \ Click here} for details.` I mirrored the BASICS example. The trap is that without ` \ `, the href swallows "Click here". The alternative `|a Click here :href https://example.com` also seemed plausible, but I wasn't sure `$main` can come before attributes.

### Read

| Line | What I'd expect | Confidence |
|---|---|---|
| `\|p "Hello," she said.` | `p` with `$main` = the literal text `"Hello," she said.`, quotes kept. Competing reading: quoted value `Hello,` as `$main`, and ` she said.` left over or an error. I'd *want* the first. | ~55% |
| `\|sample :mass.kg 3.2` | Attribute `mass` qualified by `kg` (unit, by analogy with `.trait` on elements), value 3.2, meaning "mass is 3.2 kg". Competing: attribute literally named `mass.kg`, or a nested path mass → kg = 3.2. | ~40% |
| `\|sample :mass(kg) 3.2` | Attribute `mass` with unit annotation `kg`, value 3.2. Competing: attribute name literally `mass(kg)` (the spreadsheet-header convention). | ~60% |
| `\|ev :on date(2026-10-01)` | `on` is a date value, built by a constructor-looking `date(…)`. Competing: the string `date(2026-10-01)`. | ~55% |
| `\|ev :on ~date 2026-10-01` | `~date` is a type tag or sigil, so `on` = the date 2026-10-01. Competing: the string `~date 2026-10-01`. Least familiar of the typing forms to me. | ~45% |
| `\|h3 date(format)` | Heading text "date(format)", literal. If `name(…)` were a constructor anywhere, I'd be alarmed if it fired here. | ~75% literal |
| `\|config :server.port 8080` | Nested path: `server` → `port` = 8080. Competing: an attribute literally named `server.port`. This collides with my reading of `:mass.kg` as a unit, and I notice I'd read the dot two different ways depending on whether the suffix looks like a unit. | ~50% |
| `\|server :host: localhost` | Most likely a YAML-ism slip. I'd guess either attribute `host` = `localhost` with the stray colon tolerated, or attribute `host` with value `: localhost`. I'd want a diagnostic, not a silent reading. | ~30% for any single reading |
| `\|li printf(x) prints x` | Literal text "printf(x) prints x". Any reading that treats `printf(x)` as a call would be a bug from my point of view. | ~85% literal |

*(Everything below was written after opening OPTIONS.md.)*

---

## What COLD already shows, set against OPTIONS

- **None of the Q1 options is what I wrote untaught.** I put the unit after the number in the value (`:mass 3.2 kg`). Q1-C is closest in spirit but needs a wrapper. Under every option as written, my untaught `:mass 3.2 kg` would silently be the text "3.2 kg". That's fine for a reading agent, invisible to a machine.
- **I wrote `null`, not `nil`.** Under the preamble's standard readings, my untaught null is the text `"null"`. I'd expect this to be one of the most common silent errors from JSON-steeped agents. The trial says it isn't testing that, but COLD caught it.
- **I wrote `:version 1.10` unquoted.** Under the "ordinary JSON-style numbers" reading it reads as 1.1. Whether that's harmful depends on whether the source text survives under the numeric reading. If readings are layered on text, the original survives; if they replace it, this is the Norway problem returning by the side door. `01234` is safe, since JSON forbids leading zeros.
- **My Read guesses on the trial's own lines:** I read `:mass.kg` as a unit only 40% of the time, and read `:server.port` as nesting. That's the core hazard of Q1-A, measured before I knew it was an option.

## Made-up UDON under each option

I marked friction inline with ` ; ←` comments where it actually happened while writing.

### Q1-A (dot and kind)

```udon
; deploy.conf.udon
|service[api] :image registry.local/api:2.14.1 :replicas 3
  :timeout.duration 30s
  :max-body.bytes 10MiB        ; ← wrote this, then wondered if it should be :max-body.MiB 10
  :started.datetime 2026-10-28T09:00:00-06:00
  :tls.cert /etc/ssl/api.pem   ; ← I meant namespacing. Under A, "cert" is a kind.
  :db.host db.internal         ; ← same slip, again, without noticing until I reread

; science table
|dataset[ice-cores] :collected.date 2026-07-14 :site Summit Station
  |core[g07] :depth.m 112.4 :temp.degC -31.2 :density.g/cm3 0.917 :age.yr 840
  |core[g08] :depth.m 118.0 :temp.degC -31.5 :density.g/cm3 0.919 :age.yr 870

|ev :on.date 2026-10-01 :due.date 2026-11-01 :lasts.min 90
```

`:on.date` and `:due.date` read beautifully as English ("due date"). That's also the trap: people already write `due.date` and `server.port` as *names*, so the dot carries three meanings (kind, nesting, ordinary name). `:density.g/cm3` looks like a path. The parameterized `:when.date(YY-MM-DD pivot 1950)` mixes a dot and parens and is the ugliest form in the sheet.

### Q1-B (kind in parens, as a column header)

```udon
|table[water] :site Lake Dillon :collected(date) 2026-08-12
  |row[s01] :depth(m) 0.5  :temp(°C) 17.8 :DO(mg/L) 8.9 :pH 7.6 :turbidity(NTU) 2.1
  |row[s02] :depth(m) 5.0  :temp(°C) 12.3 :DO(mg/L) 9.4 :pH 7.4 :turbidity(NTU) 1.7
  |row[s03] :depth(m) 10.0 :temp(°C) 8.1  :DO(mg/L) 7.2 :pH 7.1 :turbidity(NTU) 3.0

|invoice :total(USD) 1240.00 :tax(%) 8.25 :issued(date) 2026-10-28
|ev :start(datetime) 2026-10-01T14:30-06:00 :zone America/Denver :lasts(min) 90
|calendar :holidays(date) [2026-11-26 2026-12-25 2027-01-01]   ; ← does (date) apply per item? I assumed yes
|sample :mass (kg) 3.2   ; ← I'd expect agents to write this, with a space as in "Mass (kg)". Silently becomes text "(kg) 3.2".
```

This is the one my hands liked. It's the CSV-header convention every data-literate agent knows, `/`, `%`, `°` and parameters sit naturally inside the parens, and nobody writes `:db(host)` by accident. Friction:
1. Does the kind distribute over a list? I'd want yes, stated.
2. The space-before-paren slip.
3. Unit vs dimension: `:lasts(min) 90` vs `:lasts(duration) 90min` are both legal, and I used both in one sitting. This also applies to A.
4. Tables repeat the kind on every row (also A and C). I wanted to declare columns once.

### Q1-C (kind on the value, via Q3)

```udon
|row[s01] :depth qty(0.5 m) :temp qty(17.8 °C) :DO qty(8.9 mg/L) :pH 7.6 :turbidity qty(2.1 NTU)
|sample :mass |{qty 3.2 kg} :temp |{qty 21.5 °C}
```

Noisy in tables. The virtue is real, though: the value carries its own meaning, so it survives being moved into a list or another attribute. Under A and B, `:readings(°C) [17.8 18.1]` loses the unit the moment an item is pulled out.

### Q2 (a quoted value standing alone)

```udon
|p "Hello," she said.
|p "Goodbye."
|p He closed the door.
|blockquote "The only way to do great work is to love what you do."
  |cite Steve Jobs
|config :name "8080" :port 8080 :zip "01234" :version "1.10"
|msg :text "Line one\nLine two"
|title "Weird Al" Yankovic   ; text, quotes kept
```

Writing the dialogue is what decided this question for me. Under **A**, the three paragraphs come out as `"Hello," she said.` / `Goodbye.` / `He closed the door.`: the second line loses its quotes only because nothing followed them. An author would never notice, and fiction, transcripts and chat logs would be quietly wrong. For config, A is exactly what I want (`"8080"` → the string 8080).

**B** gives both, *if* I take the preamble at its word: a bare value is text with standard readings layered on (`8080` is text, readable as a number). B extends the same model to quotes: `"8080"` is text, readable as the string 8080. Prose reads the text and keeps the quotes; config reads the string. Escapes fit too: the text keeps `\n` raw and the string reading processes it. I started out leaning A for config, and the dialogue flipped me to B. **Lean: B, because it's the same layered model as numbers.** The open cost is that the default accessor (what `get(:name)` returns without a reading asked for) has to be settled, or every consumer guesses.

### Q3 (a value that names its notation)

**A, name with parens:**

```udon
|calendar[us-2026] :closures [date(2026-11-27) date(2026-12-24) date(2026-12-31)]
|ev :on date(2026-10-01) :span interval(date(2026-01) date(2026-06))
|todo :due date(2026-10-30) Send the revised schedule   ; ← not standalone, so silently all text
|note Moved the launch to date(2026-11-09).             ; ← in prose: silently text
; HTML page
|ul
  |li Fixed |{code parse(input)} returning nil.   ; ← $main "parse(input)" stands alone: notation "parse"?
  |li New |{code timeout()} helper.               ; ← notation "timeout", empty?
|button :onclick toggle() \ Show more             ; ← HTML event handler stands alone: notation "toggle"
```

A gives the most beautiful values of any option. `[date(2026-10-01) qty(3.2 kg) 42 hello]` is the best-looking typed list in the sheet. But in the HTML and docs contexts it collides constantly: `|code main()`, `:onclick toggle()`, and the trial's own `|h3 date(format)` all stand alone. The other silent failure is an agent taught A writing `date(…)` in prose or before a trailing `$main` and getting plain text. The collisions are harmless only if a notation is *a reading available on text* rather than *a replacement of text*, the same layered model as Q2-B. Under replacement, A is wrong for documents.

**B, sigil:**

```udon
|ev :on ~date 2026-10-01 :lasts ~duration 3mo 5d
|calendar :closures [~date 2026-11-27 ~date 2026-12-24 ~date 2026-12-31]
|calendar :closures ~date [2026-11-27 2026-12-24]   ; ← my natural write; does it distribute?
|sample :mass ~qty 3.2 kg                          ; ← reads as "approximately 3.2 kg"
|meta :values [~qty 3.2kg 42]                      ; ← in a list the value must be one token, so 3.2kg, not 3.2 kg
```

`~` means "approximately" to every human and most agents, and that's worst exactly in measurements. The extent of the value differs between attributes (rest of value) and lists (one token), and the sheet's own example shows the drift (`qty(3.2 kg)` in A, `3.2kg` in B). It also brushes `~user/` paths. Least beautiful to me.

**C, inline element:**

```udon
|note[2026-10-28] Planning call
  We moved the launch from |{date 2026-11-02} to |{date 2026-11-09},
  since the venue is booked through the 5th. Follow-up due |{date 2026-10-30}.
|ev :start |{datetime 2026-10-01T14:30 :zone America/Denver} :lasts |{duration 90min}
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]
|p Published |{time :datetime 2026-10-28 \ October 28}.   ; HTML's own <time> is already this shape
```

C is the only option that works the same in prose and in values. In the notes context, A and B can't type a date inside a sentence at all, so C would be needed there anyway, and A/B add a second mechanism. It can carry attributes (`:zone`), which my COLD #2 wanted. Nothing collides. The cost is visual weight, especially nested (`|{interval |{date …} |{date …}}`), plus an open question: is `:due |{date 2026-10-30} Send it` a typed value followed by text, or text containing an element?

**Verbatim backticks:** ``re`^\d{3}-\d{4}$` `` and `` `C:\Users\me` `` felt right at once (tagged template literals). They also rescue A's collisions (`` `toggle()` ``), and Markdown-trained agents put code in backticks anyway.

### Q4 (trailing colon on names)

```udon
|svg :xmlns http://www.w3.org/2000/svg :xmlns:xlink http://www.w3.org/1999/xlink :viewBox 0 0 100 100
  |use :xlink:href #icon-star
  |text :xml:lang en Hello
|server[web] :host: localhost :port: 8080 :time: 14:30   ; B: the colons pile up visually
|server[web] :host:localhost                              ; ← B slip: no space, so a name "host:localhost"?
```

I'd never produce `:host:` spontaneously, because the leading colon already marks the name, and a YAML writer writes `host:` with no leading colon. So B forgives a rare slip, at the cost of two spellings, noisier diffs, and murkier XML/SVG namespaced names (`xml:lang`, `xlink:href`). **Strongly A.**

## What I expect other agents to get wrong

1. `null` instead of `nil`, becoming the text "null" (COLD evidence: I did it).
2. `:version 1.10` read as 1.1, if numeric readings replace text.
3. Q1-A: dotted names meant as nesting (`:db.host`, `:tls.cert`, `:server.port`) read as kinds. I did it twice while writing A on purpose.
4. Q1-B: `:mass (kg) 3.2`, with a space, becoming text.
5. Q1-A/B: mixing a unit and a dimension (`(min) 90` vs `(duration) 90min`) in one file.
6. Q2-A: quote-only dialogue paragraphs losing their quote marks, unnoticed.
7. Q3-A: `date(…)` in prose, or before a trailing `$main`, silently staying text; code-shaped text (`main()`, `toggle()`) silently becoming notations.
8. Q3-B: `~` read as "approximately"; `~date [list]` expected to distribute; a space inside a list value.
9. A structural slip I made myself: `|todo :due.date 2026-10-30 Send the revised schedule`, where the value eats the `$main` because I forgot ` \ `. BASICS doesn't say whether `$main` can come before attributes, and I wanted to put it first twice.
10. IXDTF (`2026-10-01T14:30-06:00[America/Denver]`): its bracket suffix will look like a list or key to some readers.

## Leanings, with why

- **Q1: B.** It's the convention data people already use, it fits compound units and parameters, and nobody types it by accident. A reads nicest for dates (`:due.date`) but overloads the dot. C is right only where values travel.
- **Q2: B,** read as "everything is text; quoted text also has a string reading". That's the same principle the preamble already uses for numbers, and it's the only option that gets both dialogue and config right. A is clearer for config alone.
- **Q3: C if notations replace text; A if they're a reading layered on text** (then A's beauty wins and its collisions become harmless). Not B. If kinds go on names (Q1-B), Q3 mostly serves prose and one-off values, which is C's home ground.
- **Q4: A.**
- **The thread underneath:** what made the options clearest was treating every value as text with optional readings. If that's the intended model, saying so in BASICS would settle several hesitations at once (Q2, Q3-A's collisions, `1.10`).

## Things I'd invent

- **Declare kinds once per table:** something like `|table :kinds [depth(m) temp(°C) DO(mg/L)]` so rows can be bare. Every option repeats the kind on every row.
- **Let a vocabulary read "number, space, unit" text as a quantity,** the way numbers are already read. That makes my untaught `:mass 3.2 kg` work without a wrapper and costs nothing to readers.

## Feedback on the trial's design

- **The harness blocked my report file.** Subagents can't write report `.md` files here, so the coordinator has to save this text. My COLD-before-OPTIONS order is evidenced only by the scratchpad timestamp.
- **The shared scratchpad holds the coordinator's materials.** A trial agent could read them.
- **COLD primes some answers.** The Read list (`:host:`, `date(…)`, `~date`) previews the options. That's useful for measuring guesses, but a pure-write COLD item asked before the Read section would be cleaner.
- **The questions interact.** Q1-C depends on Q3, and Q2 depends on whether readings are layered on text. Saying what the underlying value model is (text plus readings, or typed replacement) would make answers comparable across agents.
- **BASICS gaps that affected values:** whether `$main` can come before attributes, and whether unquoted values ever interpret `\`, `{` or `$`.
