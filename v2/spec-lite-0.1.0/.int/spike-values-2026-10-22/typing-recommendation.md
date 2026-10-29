# How lite's values get their types: my recommendation

*For Joseph, 2026-10-29, from the session's agent (Opus 5.5), writing as one of lite's target users: an agent that reads and writes it without highlighting. This is one design, stated whole, then its nuances and its costs. The sections after it go decision by decision: what I recommend, the options I set aside and why, and the full pros and cons. The evidence behind it (three explorations, two audits, an eight-agent trial) is in `ADJUDICATION-GUIDE.md` beside this file.*

*Two terms, used the same way throughout. **What the parser keeps** is always the characters exactly as written. **The value** is what anything using the parsed file gets when it asks for it: a config loader, a converter to JSON, an editor tool.*

---

## The recommendation

```udon
|server[web] :host localhost :port 8080 :debug false :owner null :mask 0xFF
|part :version "1.10" :zip 01234 :weight 3.2 kg
|sample :mass(kg) 3.2 :temp(°C) 21.5 :taken(datetime) 2026-10-01T14:30Z
|ev :on date(2026-10-01) :lasts duration(90 min) :when date(27-03-05 :format YY-MM-DD :pivot 1950)
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me\`
|p "Hello," she said; see |{date 2026-10-01} for the date.
|h3 date(format)
```

What each line gives:

- **`server`:** `host` is the text "localhost"; `port` the number 8080; `debug` false; `owner` null; `mask` the number 255.
- **`part`:** `version` is the string "1.10" (quoted, so it stays text); `zip` is the text "01234" (a leading zero is never a number); `weight` is the text "3.2 kg", which a schema that knows `weight` can read as a quantity.
- **`sample`:** `mass` is 3.2 in kilograms; `temp` 21.5 in °C; `taken` an instant. The parentheses on the name say what the value is.
- **`ev`:** `on` is the date 2026-10-01; `lasts` a duration of 90 minutes; `when` the date 2027-03-05, read with the format and century it states.
- **`meta`:** a list of a date, a quantity, the number 42 and the text "hello".
- **`rule`:** `pattern` is a regular expression and `path` a path, each exactly as written between the backticks; no escapes.
- **`p`:** `$main` is the text `"Hello," she said; see …`, quote marks included, with an inline `date` element in it.
- **`h3`:** `$main` is the text `date(format)`, a heading.

**The whole design, as eight rules:**

1. **A bare value is read** if it's `null`, `true`, `false`, or a number (JSON's way of writing numbers, plus `0x`/`0o`/`0b` and `_` between digits). Anything else bare is text. Keys and prose are never read.
2. **A quoted value counts only if it stands alone**; then it's a string. Followed by more text, the whole thing is text, quotes included.
3. **A name followed by parentheses, standing alone in an attribute value**, is a value in that notation: `date(…)`. It means exactly what the inline element `|{date …}` means; the parentheses hold what that element's line would. Not recognized in an element's own text (`$main`) or in prose, where `|{…}` does the job.
4. **Parentheses on an attribute's name** say what its value is: `:on(date) 2026-10-01` means `:on date(2026-10-01)`, and `:mass(kg) 3.2` means `:mass qty(3.2 kg)`.
5. **Backticks standing alone** are verbatim text; a name in front says what it is: ``re`…` ``.
6. **`<…>` is not a value.** It stays reserved.
7. **No trailing colon on attribute names.** `:host: localhost` is an error that suggests `:host localhost`.
8. **What a later UDON may change:** it may give meaning to a named value (rules 3–5) that lite kept for a reader; it may never give new meaning to anything lite left as text.

---

## Nuances

- **Lite knows a small set of notation names, and checks them.** In 0.1: `date`, `time`, `datetime`, `duration`, `qty`, `int`. `date(2026-13-45)` is an error. An unknown name (`dtae(…)`, `colour(…)`) in an attribute value is an error that suggests a fix; a name with a prefix (`acme/sku(AB-12)`) belongs to whoever defined it, and lite keeps it for them unread.
- **Inside the parentheses is an inline element's line:** text first, then attributes. So `date(27-03-05 :format YY-MM-DD :pivot 1950)` is the inline element `|{date 27-03-05 :format YY-MM-DD :pivot 1950}`. Nesting works the same way: `interval(date(2026-01) date(2026-06))`.
- **A two-digit year must say its century** (`:pivot`); otherwise it's an error, so a document can't change meaning as the years pass.
- **Units are whatever is written.** Lite doesn't know what `kg` or `°C` means; `qty(3.2 kg)` keeps "3.2" and "kg" for a reader. Only `qty`'s shape is checked: a number, then a unit.
- **The parser keeps the characters of everything,** so `0xFF`, `1_000`, `"1.10"` and `"Hello,"` are all recoverable exactly; a tool that rewrites the file changes nothing it didn't touch.
- **Three new warnings, all on by default:**
  - a quoted value, `name(…)` or backticks followed by more text in an *attribute* value (`:href "https://example.com" Click here`), suggesting ` \ `;
  - a space between an attribute's name and its parentheses (`:mass (kg) 3.2`, which is the text "(kg) 3.2");
  - a value starting `https://` (or another scheme) that contains a space (`:href https://example.com Click here`), suggesting ` \ `.
- **`null`, not `nil`** (your call, 2026-10-29, reversing the 2026-10-09 choice): it's what JSON, YAML, HCL, CUE and CBOR write, and what every trial agent wrote untaught. A bare `nil` is text, with a warning (on by default) suggesting `null`.

---

## Downsides

**What it changes elsewhere in lite.**
- Reverses the example on the decided leftover-values card: `|q "hello," she said` becomes one text.
- Under rule 2, `"x""y"` is one run of text, not two strings with a warning; that card changes.
- Rewrites the bare-value card: its Statement 2 (a bare run is always text) and its typed-primitive view become rule 1.
- Takes `<…>` out of the opaque-span family: those rules then cover only `@{…}` and `;{…}`, and the definitions of typed values (explicit and implicit) mostly go.
- Makes `(` after an attribute's name, and after a name in an attribute value, meaningful.
- Makes element lines and attribute lines differ in one place: `name(…)` is recognized in attribute values, not in `$main`. Lite's rule so far has been one way of reading both.
- Adds a list of notation names to the spec, which grows by version.

**Against JSON.**
- `:version 1.10` is the number 1.1; a version must be quoted. Agents mostly do that already (five of eight in the trial).
- `0xFF` goes to JSON as 255: the value survives, the spelling doesn't.
- `$main` is read like any value, so `|td 1.10` has the value 1.1 and `|h1 1984` the value 1984. A renderer uses the characters and is unaffected; a converter to JSON is not.

**Against Markdown.**
- A list item that is only a code span (`|li `ls -l``) stands alone, so it becomes verbatim text, not a Markdown code span. Its characters are kept, so a renderer can restore the backticks.
- A paragraph that is only a quotation (`|p "To be, or not to be."`) has the string as its value, without the marks. The parser keeps the marks; a renderer that reads the value instead of the characters loses them. Written as prose on the next line, the marks are text.

**Against what agents write untaught (the trial).**
- They write units in the value (`:mass 3.2 kg`). That stays text, which is right, but nothing checks it unless a schema reads it.
- They quote versions out of habit (harmless). (They also write `null`, which is now the spelling.)
- Some write `:href "https://…" Click here`, which is why the first new warning exists.
- None of them reached for `date(…)`, parentheses on a name, or backticks. These have to be learned; the trial suggests they're easy to like once seen.

---

## Decision by decision

### 1. Bare values

**Recommendation.** A bare value's characters are kept, and its value is `null`, `true`, `false` or a number when it spells one, by JSON's rules plus `0x`/`0o`/`0b` and `_` between digits; otherwise text. This is part of the spec, the same for every tool. Keys stay text. Prose is never read; `$main`, being a value, is.

**Options set aside.**
- *Always text, reading optional per tool* (your 10-21 lean): two tools disagree about the same file, and `:debug false` is the text "false", which counts as true in Python, JavaScript, Ruby and Elixir.
- *Text unless a tool asks for a number:* the same problem, worse by default.
- *The parser records the type beside the characters:* gives the same values, but the parser then records something it inferred, not just what was written.
- *Typing by the first character* (a digit makes it a number): `920px` becomes an error, and `1984 is a novel` splits.
- *The old line's whole set* (dates, rationals, durations bare): each extra spelling is a new way to misread something; the old surprises lived there.
- *Dates read bare* (two trial agents asked): dates are where the old line surprised you most; `date(…)` says it.

**Pros.** The same value for every tool (stability). `:debug false` is false, as agents expect. Lite to JSON copies numbers exactly. `0xFF` and `1_000` work as you asked for in July, and no word is spelled that way, so nothing is misread. The characters are always kept.

**Cons.** `:version 1.10` is 1.1 unless quoted. A Ruby- or Go-trained writer's `nil` is text (with a warning). Keys and values differ (`|step[3]` is text, `:step 3` a number). `$main` values get read too (`|td 1.10`).

### 2. Quoted values

**Recommendation.** A quoted (or bracketed) value counts as one only if nothing else follows it in that value. Standing alone, a quoted value is the string inside the quotes. A warning when, in an attribute value, a quoted value is followed by more text.

**Options set aside.**
- *Today's rule* (a quote commits, the rest stacks): `|p "Hello," she said.` loses its quote marks and splits; a Markdown link at the start of a list item becomes a list.
- *Standing alone, it's text with its quote marks:* keeps a paragraph's marks, but `:name "8080"` then has quote marks in it, and quoting stops protecting a value; the protective quote is the one every agent reached for.
- *Quotes are characters in `$main`, delimiters in attributes* (two trial agents' idea): fits what every agent expected, but makes element lines and attribute lines read quotes differently, in the commonest construct there is.
- *A quoted value followed by text is an error:* errs on the most ordinary sentence anyone writes.

**Pros.** Sentences and links at the start of a line survive. `:c "1" z` and `:c 1 z` now behave alike. Quoting protects a value, as in JSON. The warning catches the HTML-trained `:href "…" Click here`.

**Cons.** Reverses a decided example. `|p "To be, or not to be."` has the string as its value, without the marks (the characters keep them). `"x""y"` changes meaning. Whether a quote counts is decided at its closing quote plus one character, so the decision waits to the end of the quoted value.

### 3. Notation values: `name(…)`

**Recommendation.** In an attribute value (including list items), a name immediately followed by parentheses, standing alone, is a notation value, with exactly the meaning of the inline element `|{name …}`: the parentheses hold that element's line. Lite knows a small set of names and checks their bodies; unknown names are errors that suggest a fix; prefixed names (`acme/sku(…)`) are kept unread. In `$main` and prose, `name(…)` is text; `|{…}` marks values there.

**Options set aside.**
- *A tilde and a name* (`~date 2026-10-01`): `~` means "approximately" exactly where dates and quantities appear, and home directories and version ranges besides; its extent changes between a value and a list item. No trial agent chose it.
- *Only inline elements* (`|{date 2026-10-01}`): no new syntax, and the only form that works in prose, which is why it stays. As the only form, it's heavy in lists and tables, and drops braces into a trap (`:due |date 2026-10-30 :renew |duration 30d` gives `renew` to the date).
- *`<date: 2026-10-01>`:* needs `<…>`, which rule 6 retires; the parentheses do the same with no new bracket.
- *`name(…)` recognized everywhere, `$main` included:* every trial agent read `|h3 date(format)` as a heading; API documentation is full of them.
- *Body kept verbatim to the closing parenthesis:* kind to regular expressions, but nesting is then the notation's business, and backticks already give verbatim text.
- *Unknown names quietly carried:* `dtae(…)` would pass unnoticed.

**Pros.** The most guessable form found (every agent knows `url(…)` and `rgb(…)`). Self-delimiting in lists; nests. One idea with two spellings: the short one for values, `|{…}` for prose. Parameters come free as the element's attributes. Unknown names fail loudly.

**Cons.** A list of names in the spec. Element lines and attribute lines differ here. An agent writing `|li qty(1.5 cup) flour` gets text (it doesn't stand alone), with no warning in `$main`. Parse-time checking of bodies costs speed. `)` inside a body must be matched or escaped.

### 4. Kinds on attribute names: `:mass(kg) 3.2`

**Recommendation.** Parentheses straight after an attribute's name say what its value is. `:on(date) 2026-10-01` means `:on date(2026-10-01)`. `:mass(kg) 3.2` means `:mass qty(3.2 kg)`: anything in the parentheses that isn't a known notation name is a unit. A warning for a space before the parenthesis.

**Options set aside.**
- *A dot* (`:mass.kg 3.2`): agents read the dot as nesting (two made the mistake while writing that way on purpose; five read `:mass.kg` as a unit and `:server.port` as a path); units like `°C` and `%` would have to become name characters. No trial agent chose it.
- *Nothing on the name* (kinds only on values): noisy in tables, where every row repeats `qty(…)`.
- *A colon* (`:when:dt`): `:xml:lang` reads wrongly.

**Pros.** Reads like a column header; holds any unit or parameter; never looks like a path. Five of eight trial agents chose it. It's the same idea as rule 3 on the other side of the value. It's the spelling a "say it once per table" design would reuse.

**Cons.** A notation name and a unit share one slot, so a misspelled notation (`:on(dtae)`) is silently a unit; a warning for a unit within a letter or two of a notation name would help. `:mass (kg) 3.2` with a space is silently text (hence the warning). Every row still repeats it until "say it once per table" exists, which five agents asked for and which I'd design next.

### 5. Backticks

**Recommendation.** One or two backticks standing alone are verbatim text, with no escapes; a name immediately in front (``re`…` ``) makes it a value in that notation, kept exactly. Three or more is the fence that already exists.

**Options set aside.** *Single quotes only* (today): can't end in a backslash, and backslashes must be watched. *Verbatim bodies in `name(…)`:* rule 3's parentheses hold structure; keeping verbatim in backticks means one meaning per bracket.

**Pros.** Regular expressions and paths exactly as written. Everyone in the trial who tried them liked them. Backticks already mean "verbatim" to every agent, and to Markdown.

**Cons.** Nobody reached for them untaught. A backtick inside the text needs a longer run of backticks, as in Markdown. A list item that is only a code span becomes verbatim text, not Markdown (its characters kept).

### 6. `<…>`

**Recommendation.** Not a value in lite. It stays reserved, so full UDON is free to give it a meaning.

**Options set aside.** *Holding any text unread* (today's card): can't refuse `<920px>`, and with numbers read bare it has nothing left to do. *Holding a checked standard value or a named notation:* rules 1, 3 and 5 already do every job it would. *Printed quantities by shape* (`<90 min>`, `<9.99 USD>`): beautiful, but the largest grammar anyone proposed; they can live inside `qty(…)` instead.

**Pros.** Frees `<` for HTML and Markdown in text. One fewer bracket. Your strong lean.

**Cons.** `<>` as null has no home (bare `null` covers it). Two spec-primed trial agents reached for `<3.2 kg>` to make a value checkable; they'll need `qty(3.2 kg)`.

### 7. The trailing colon

**Recommendation.** No trailing colon. `:host: localhost` is an error: "did you mean `:host localhost`?". A colon inside a name (`xml:lang`) is unaffected. (Your lean is the opposite, and you said you're persuadable; this is the one decision that's mostly about how it looks, and your eye should decide it.)

**Options set aside.** *An optional colon, dropped by the parser* (your lean): two spellings for one thing; agents reading it cold took it to mean something different (a name ending in `:`, or a YAML-style opener); it stacks with rule 4 (`:mass(kg): 3.2`). *A required colon:* changes every attribute everywhere.

**Pros.** One spelling. The error catches the YAML habit and says what to write. All eight trial agents chose it.

**Cons.** Gives up what one agent called the colon's real gain: without highlighting, `:title: War and Peace` shows at a glance where the name ends.

### 8. What a later UDON may change

**Recommendation.** A later version may give meaning to what lite kept as a named value (rules 3–5, prefixed names, fences); it may never give new meaning to what lite left as text. Lite's set of readable bare spellings (rule 1) is therefore final, and bodies of known notations are checked from 0.1.

**Options set aside.** *Anything may gain meaning later:* every document with a bare date would change meaning the day dates are read. *Nothing may:* every notation design above would have to wait.

**Pros.** No lite document changes meaning when full UDON arrives, which is why lite refuses things at all. Notations have one path forward, the same one fences already have.

**Cons.** Decision 1's set can never grow; bare ISO dates, if ever wanted, must be in 0.1.

### 9. Smaller things

- **Long lines:** a parser may limit line length, with an error that says it's a limit, or pass long text along in pieces. Say both are allowed.
- **Printed quantities** (`37.5 ± 0.2 °C`, `2026-01 – 06`): inside `qty(…)` and a range notation, later than 0.1, not in lite's own grammar.
- **Typed values in prose:** `|{date …}` (rule 3), or a Markdown link (`[Oct 1st](date:2026-10-01)`), which lite passes through untouched.
