# report-haiku-primed

Reader's note, written before OPTIONS.md was opened. Primed variant: I read the lite spec's map and CTQ factors, the value-related cards in `src/` and `def/`, and BASICS.md, then wrote these COLD answers. Cards read: `def/def-value`, `def/def-string`, `def/def-typed-value` (head), `src/rule-element-values`, `rule-unquoted-run-is-one-value`, `rule-strings-like-ruby`, `rule-double-quote-escapes`, `rule-single-quote-escapes`, `rule-nil-spelling`, `rule-key-holds-a-value`, `rule-list-items-whitespace-separated`, `rule-adjacent-quoted-strings`, `rule-no-interpolation`, `rule-reserved-spellings`, `rule-missing-value`, `rule-value-line-escapes` (head). I did not open any other file under `.int/`. A few card working notes quote Joseph's words; I saw those in passing. So these COLD answers are not fully untaught: the cards shaped at least some of them.

## COLD answers (verbatim, as first written)

### 1. Sample: mass 3.2 kg, temperature 21.5 °C

```udon
|sample :mass 3.2 kg :temp 21.5 °C
```

Hesitation: I would want to know whether a unit can be written after a number with a space, or whether the number needs `<…>`. I expect both values to come out as text.

### 2. Event: 1 October 2026, 90 minutes, 14:30 in Denver

```udon
|event :date 2026-10-01 :start 14:30 :duration 90 min :zone America/Denver
```

Hesitation: whether the date and time should be typed. I would expect text, and I would expect a reader to be unsure whether `:duration 90 min` is one value.

### 3. Regex `^\d{3}-\d{4}$` and path `C:\Users\me`

```udon
|rule :pattern '^\d{3}-\d{4}$' :path 'C:\Users\me'
```

Hesitation: I reached for single quotes because backslashes need protecting. I would want a rule saying whether a bare `\` is literal inside an unquoted run. I have not seen one in BASICS.

### 4. Server: localhost, port 8080, debug off, retries 3, owner explicitly nothing

```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner nil
```

Hesitation: whether bare `8080`, `false` and `3` are numbers and booleans or text. I would want to know that before writing the file, because a JSON-trained writer will expect them typed. I would also write `null` by habit and need to know it is wrong.

### 5. Paragraph: "Hello," and then she said

```udon
|p "Hello," she said.
```

Hesitation: whether a quoted string followed by bare text on an element's line is two values, and whether that is a prose sentence or a list of values. I would expect the tree to hold the string and then the text.

### 6. A list of three holiday dates

```udon
|holidays :dates [2026-07-04 2026-11-26 2026-12-25]
```

Hesitation: whether list items are separated by spaces or commas. I wrote spaces. I would expect the dates to be texts.

### 7. Version 1.10 and zip code 01234

```udon
|part :version "1.10" :zip "01234"
```

Hesitation: I quoted both, because a bare `1.10` would be read as a number and a bare `01234` may lose its leading zero. I would want a rule for a bare number that is not a number. I expect a reader to find quoting here natural.

### 8. Link to https://example.com with text "Click here"

```udon
|a :href "https://example.com" Click here
```

Hesitation: an unquoted href would run to the next start, so `:href https://example.com Click here` would swallow the words "Click here" unless I write a framed backslash. I wrote the quoted form for that reason.

## COLD reads (my expectation, and how sure I am)

- `|p "Hello," she said.` : `p` with the string `Hello,` and then text `she said.`. Sure (moderate).
- `|sample :mass.kg 3.2` : an attribute named `mass.kg` with text `3.2`, or a path into a node `mass` with key `kg`. Not sure which. Low.
- `|sample :mass(kg) 3.2` : I read `(kg)` as part of the name or as a unit annotation; I expect a name that is unusual. Low.
- `|ev :on date(2026-10-01)` : the attribute `on` holds the text `date(2026-10-01)`, because there is no evaluation in lite. Moderate.
- `|ev :on ~date 2026-10-01` : I do not know what `~date` means. My guess is that the value is the text `~date 2026-10-01`. Low. I'd expect other agents to read it as a type marker.
- `|h3 date(format)` : `h3` with main text `date(format)`. High.
- `|config :server.port 8080` : an attribute named `server.port` with text `8080`, or a nested key. Moderate.
- `|server :host: localhost` : I expect the name to be `host:` (a trailing colon in the name) or an error. Low. I would expect other agents to misread it as a key with a colon.
- `|li printf(x) prints x` : `li` with main text `printf(x) prints x`. High.

---

## Part 2: the options (written after the COLD answers above were saved)

Contexts: a config file (C), a science data table (T), a notes file with dates in prose (N), and an HTML-ish page (H). "Friction" is what I hesitated over, slipped on, or had to look back to BASICS or the cards for. Examples are made up. I did not read other agents' reports.

### Q1. Saying what a value is, on the attribute's name

**Option A (dot and kind).**

```udon
; C
|pool[api] :size.count 12 :timeout.duration 30s :host localhost
; T
|sample[s17] :mass.kg 3.2 :temp.degC 21.5 :taken.datetime 2026-10-01T14:30Z
; N
|note :on.date 2026-10-01 Met Sam about the pipeline; the lease runs to 2026-12-31.
```

- Beauty and fluency: `:mass.kg` reads as a label with its unit attached, and the value stays bare. Good in the table.
- Friction, serious: in COLD I wrote `|config :server.port 8080`, meaning a nested path, and I also read `:mass.kg` as a path at first. The same dot means two things, and a config writer will reach for nesting. An agent reading `:port.int` would have to decide whether it is a name, a path or a kind.
- Friction: `.count`, `.duration` and `.datetime` are used as if they were a closed vocabulary. Nothing in the spec says who decides them.

**Option B (kind in parentheses, as a column header).**

```udon
; C
|pool[api] :size(count) 12 :timeout(duration) 30s
; T
|sample[s17] :mass(kg) 3.2 :temp(°C) 21.5 :taken(datetime) 2026-10-01T14:30Z
; N
|note :on(date) 2026-10-01 Met Sam about the pipeline.
```

- Beauty: in the science table this is the most pleasant of the three. The kind sits above the value like a column header. I would call it the most beautiful for tables.
- Friction: `:mass(kg)` on a name looks like a call on the name. In the Q3 spelling `date(...)` is a value, so B and Q3-A share the same parentheses for two roles. I hesitated when I saw `:when(date YY-MM-DD pivot 1950)`: spaces inside a name are hard to scan.
- Friction: `(°C)` contains a non-ASCII character in a name, which I would expect other agents to get wrong. The cards say something about label alphabets; I did not check it.

**Option C (kind on the value, when needed).**

```udon
; C
|pool[api] :size 12 :timeout duration(30s)
; T
|sample[s17] :mass qty(3.2 kg) :temp qty(21.5 °C) :taken datetime(2026-10-01T14:30Z)
; N
|note :on date(2026-10-01) Met Sam about the pipeline.
```

- Names stay plain labels, and the kind travels with the value that has it. That matches the card's rule that a typed value gets its type from its spelling. It is the most principled of the three.
- Friction: verbose. The `qty(3.2 kg)` form looks like a function call, and "lite evaluates nothing" makes me expect a computed result. I would expect other agents to read `duration(30s)` as evaluated.
- Friction: whether `qty(3.2 kg)` is one value because the space is inside the parentheses. I read it as one value, but I looked back to be sure.

**What I'd pick for Q1: C.** The reason is structural: a name is the parent's label, and a kind belongs to a value. A and B move the kind into the name, where it can be confused with nesting (A) or with a call (B). I would keep B as the runner-up for tables, where its header look is the most beautiful. Q1-C pairs with Q3-A below. Its only other reading is Q3-C, which would make the values `|{qty 3.2 kg}`.

### Q2. A quoted value that stands alone

**Option A (a string, with the quotes as delimiters).**

```udon
; H
|a :href "https://example.com" Click here
; N
|p "To be, or not to be."
|p She said "fine" and left.
; C
|server :name "8080" :motd "Welcome, friends"
```

- Fluency: this is the JSON-like reading I expected. I wrote `"8080"` and `"1.10"` as strings in COLD for exactly this reason. Quoted means string, and I did not have to think about it.
- Friction: option A says the fact that a value was quoted is kept as metadata. The card for strings says that which quote was used is not part of the value. Those two statements conflict, or at least the metadata needs a home. I would drop the metadata unless someone needs it for round-trip fidelity (C10).
- Friction: in the notes example the quotes inside the text are text, which is right, but I looked back to be sure a quote mid-line does not start a string.

**Option B (text that keeps its quote marks).**

```udon
|p "To be, or not to be."
|el :name "8080"
```

- Beauty: none for me. B makes the quotes content, so `:name "8080"` holds the characters `"8080"` with quotes. A writer who wants a string has to write something else, which is a trap.
- Friction: I hesitated over whether the quoted sentence in the notes example would keep its quotes, and what the tree would show. Both readings are plausible, and an agent could reasonably pick either.
- B's one virtue is that it is closer to prose: the quotes show. For a notes file that could matter, but it is a text feature, and text already keeps quotes.

**What I'd pick for Q2: A.** It is what a writer from JSON expects, the quotes disappear into the kind, and the string is still a value rather than a text. I would drop the metadata.

### Q3. A value that names its own notation

**Option A (parentheses).**

```udon
; C
|job :every duration(15min) :starts date(2026-10-01)
; T
|event[e1] :on date(2026-10-01) :lasts duration(90min) :span interval(date(2026-01) date(2026-06))
; N
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
```

- Fluency: the most readable of the three for data and config. `interval(date(...) date(...))` nests cleanly and reads at a glance.
- The "value must stand alone" rule is a good boundary, and `printf(x) prints x` stays text, as the option says. I checked that in the prose example and it held.
- Friction, the biggest: the form looks like a function call, and "lite evaluates nothing". I expect other agents to write `date(2026-10-01)` mid-prose and be surprised that it is text. I would also expect them to read `duration(15min)` as an evaluated quantity.
- Friction: in the list `[date(...) qty(3.2 kg) 42 hello]` I could not tell from the spec whether a space inside parentheses splits a list item. The list rule says whitespace-separated and says nothing about parentheses. I resolved it by reading `qty(3.2 kg)` as one item, with low confidence.

**Option B (a tilde and a name, then the value).**

```udon
|event[e1] :on ~date 2026-10-01 :lasts ~duration 90min :span ~interval 2026-01/2026-06
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]
```

- Beauty: this is compact and I like `~interval 2026-01/2026-06`. The tilde reads to me as approximate, which is a misreading I would expect other agents to make.
- Friction, serious: where the value ends. An unquoted run runs to the end of the line or to a start. So `:on ~date 2026-10-01 Met Sam` would make the date's value include "Met Sam". Only the sigil form has this problem, and the parenthesis form does not.
- Friction: `~` is a new special character. CTQ A8 (parsimony) and B6 (headroom) both weigh against it, and I cannot tell from the cards whether full UDON wants `~` for something. I did not check.

**Option C (an inline element; no new syntax).**

```udon
|event[e1] :on |{date 2026-10-01} :lasts |{duration 90min} :span |{interval |{date 2026-01} |{date 2026-06}}
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]
```

- Fit: this is the one that needs nothing new. The cards already allow an attribute's value to be an element, and an inline element inside text is already part of lite.
- Friction: verbose, with nested braces that agents will count badly. The `|{...}` form also says "element", which is a different thing from "kind".
- Clarity: the end of each value is always clear, which the sigil form lacks.

**What I'd pick for Q3: A**, with C as the fallback if the team decides that call-shaped forms are misleading. The readability and the clean boundary win for me. The cost is the evaluation look, which I would address with a line in the spec.

### Q4. Attribute names, with or without a trailing colon

**Option A (no colon).**

```udon
|server[web] :host localhost :port 8080 :debug false
  :owner nil
```

- Fluency: this is what I wrote in COLD, and it read cleanly.
- Friction: I hesitated over whether the value of `:time 14:30` could be misread with a colon in a name. A is clear.
- Friction for writers: YAML-trained agents will reach for `:host:` often. That is a real writability cost for A.

**Option B (an optional colon, ignored by the parser).**

```udon
|server[web] :host: localhost :port: 8080 :debug: false
  :owner: nil
```

- Beauty: it looks like YAML, and many writers will find it at home.
- Friction, serious: "ignored by the parser" means the colon is silently dropped. That is a guess, and the CTQ says errors over guesses (B3) and errors that teach (B4). An ignored colon also means two spellings for one thing, so a file can mix them and no reader can tell which the author meant.
- Friction: in the table `:time: 14:30` looks like a name with a colon and a value, and I would expect other agents to misread it.

**What I'd pick for Q4: A.** One spelling is better, and B's silent aliasing breaks the errors-not-guesses factor. The writability gain for YAML-trained agents is real, so I would keep the guessable spelling but make it an error that teaches: "a colon after an attribute name is not part of it; write `:host localhost`." That gets the guessability without the alias.

## Anything else

1. **A fifth option for Q3 that I found in the cards.** The spec already spells explicit typed values as `<…>`, with a type-label inside, for example `<u64:0xff>`, and the cards say lite carries that text without meaning. So a fifth option would be `:on <date:2026-10-01>`, `:lasts <duration:90min>`, `:mass <qty:3.2 kg>`. It uses existing syntax and leaves the reading to a later consumer. I found this in the cards rather than from the options. I did not evaluate it fully, and I would not have seen it without reading the spec first.
2. **A stipulation in OPTIONS that conflicts with the cards.** OPTIONS says that in every option `:port 8080` and `:debug false` "also get a standard reading". The cards say that a bare run is always text, and that a typed-primitive reading is an optional view that might be on or off by default. The trial may be deciding something the cards have left open, so it would help to say so.
3. **Verbatim backticks in Q3** (``re`^\d{3}-\d{4}$` ``) are not in the lite cards that I read, and they are not in BASICS. I could not check whether they are a live option or a separate question, and they cluttered Q3.
4. **Units with spaces.** Across all four questions the awkward case is a number followed by a unit with a space (`3.2 kg`, `21.5 °C`). I hesitated over it in COLD and again under every option. A rule or a convention for units would help more than any of the four options.

## What I'd expect other agents to get wrong

- Read `date(...)` or `qty(...)` as evaluated (Q1-C, Q3-A).
- Read dotted names as nesting (Q1-A, and the COLD line `|config :server.port 8080`).
- Write a bare `1.10` or `01234` and expect a string, or write `"8080"` and expect a number (Q2 and the COLD answers).
- Write `null` by habit (COLD answer 4, and it is the nil rule).
- Write `:host:` out of YAML habit, and not notice that B's colon was dropped (Q4-B).
- Let an unquoted sigil or unquoted run swallow the prose after it (Q3-B).

## Which option felt most beautiful, fluid and useful, and why

- Q1: B for the science table (beauty), C for the structure (principle). Picked C.
- Q2: A. It is the fluent one, and it is what I expected.
- Q3: A. It is the most readable, and its boundary is clean.
- Q4: A. One spelling, and it avoids silent aliasing.

## Feedback on the trial's design

- The request to read the lite spec before COLD makes the COLD answers primed by the cards. I read them, and I wrote COLD answers that depend on what I read (quoting `"1.10"`, avoiding bare `null`). If the trial's measure is untaught guessing, the lite-spec agents' COLD answers are a different measure from BASICS-only agents', and the report should be read that way.
- Q2's metadata point is not in any card. It belongs in the question or in the cards.
- Q3's backtick syntax needs a status line.
- Q4's "ignored by the parser" conflicts with the errors-over-guesses factor. If it is a live option, the trial could say so.
- Whether a number-with-unit can be typed without a space is worth a question of its own.

I did not read anything under `.int/` beyond the trial folder. I did not edit shared files and did not commit. I am happy to stay on the line for follow-ups.
