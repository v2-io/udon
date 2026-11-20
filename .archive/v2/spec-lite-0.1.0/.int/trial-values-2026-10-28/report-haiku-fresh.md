*Saved by the coordinator from the agent's returned message: the harness refused the agent's own write ("Subagents should return findings as text"). Content as returned.*

# Report: haiku-fresh (trial-values-2026-10-28)

**Process and disclosure.** I read `BASICS.md`, then `COLD.md`, and wrote my COLD answers before opening `OPTIONS.md`. I did not open any spec-store files, other agents' reports, or the shared files. Everything below marked as a guess comes from BASICS and instinct.

## COLD answers (verbatim, as first written)

### Write

1. Sample at 3.2 kg and 21.5 °C:
```udon
|sample :mass 3.2 kg :temperature 21.5 °C
```
Hesitation: I don't know whether the unit is part of the value, a separate attribute, or a type. I'd want a rule for that.

2. Event on 1 October 2026, 90 minutes, 14:30 in Denver:
```udon
|event :start 2026-10-01T14:30 :zone America/Denver :duration 90 min
```
Hesitation: I'd want to know whether `:start` takes a zone inline, and whether `90 min` is a number with a unit or a string.

3. Regex pattern and Windows path:
```udon
|rule :pattern '^\d{3}-\d{4}$'
|file :path 'C:\Users\me'
```
Hesitation: BASICS says `"…"` has Ruby-like escapes but says nothing about `'…'`. I used single quotes so the backslashes would stay literal. I don't know whether that's right.

4. Server:
```udon
|server :host localhost :port 8080 :debug false :retries 3 :owner null
```
Hesitation: is `null` a keyword or the string "null"? I'd want a rule.

5. Paragraph with "Hello,":
```udon
|p
  "Hello," she said.
```
Hesitation: a line starting with a quote may be read as a quoted value rather than prose. I put it under `|p` as prose to avoid that.

6. Three holiday dates:
```udon
|holidays :dates [2026-12-25 2027-01-01 2027-07-04]
```
Hesitation: are the list items dates or strings?

7. Version 1.10 and zip 01234:
```udon
|part :version "1.10" :zip "01234"
```
Quoted so they stay strings. I'd expect unquoted `1.10` to become a number and lose the trailing zero.

8. Link to example.com:
```udon
|a :href https://example.com \ Click here
```
The framed backslash is there because otherwise the unquoted `:href` value would run on into "Click here".

### Read

- `|p "Hello," she said.`: a `p` whose text is `"Hello," she said.`, quotes kept as prose. Confidence about 65%. The leading quote might be read as a quoted value, which would change the tree.
- `|sample :mass.kg 3.2`: attribute `mass.kg` = 3.2. The dot could instead mean a trait or a nested key. Confidence about 40%.
- `|sample :mass(kg) 3.2`: attribute `mass` with a unit `kg`, so 3.2 kg. Confidence about 30%.
- `|ev :on date(2026-10-01)`: attribute `on` with a typed date, built by calling `date(...)`. Confidence about 50%.
- `|ev :on ~date 2026-10-01`: the same typed date, with `~date` as a prefix tag. `~` could also mean "approximate". Confidence about 40%.
- `|h3 date(format)`: an `h3` whose text is the literal `date(format)`. Confidence about 60%.
- `|config :server.port 8080`: a path-style attribute `server.port`, or nested `server` then `port`, with 8080 as a number. Confidence about 50%.
- `|server :host: localhost`: probably an attribute named `host:` with value `localhost`, or a parse problem. I don't know what a trailing colon in a name means. Confidence about 20%.
- `|li printf(x) prints x`: an `li` whose text is `printf(x) prints x`, with no call. Confidence about 60%.

## Options (read after COLD)

### Q1. Saying what a value is, on the attribute's name

**A (dot and kind).**
- Config: `|server :host.str localhost :port.int 8080`. Readable, but `:server.port` (which I wrote in COLD) now clashes with nesting, and I hesitated.
- Science table: `|sample :mass.kg 3.2 :temp.degC 21.5` then the same suffixes on every row. The repetition is noisy.
- Notes: `|note :on.date 2026-10-01`. Fine.
- Friction: the dot does two jobs, kind and path. `:when.date(YY-MM-DD pivot 1950)` mixes dot and parentheses, which I found hard to scan.

**B (kind in parentheses, as a column header).**
- Science table: `|sample :mass(kg) 3.2 :temp(°C) 21.5`. This reads most like a header row, and the rows scan down cleanly. The most beautiful option for tables.
- Config: `|server :port(int) 8080`. Noise on a config file.
- Notes: `|note :on(date) 2026-10-01` is fine.
- Friction: `:when(date YY-MM-DD pivot 1950)` has spaces inside the name's parentheses, and I couldn't tell where the name ends. Parentheses also now mean two things (name here, call in value), which Q3 makes worse.

**C (nothing on the name; kind on the value).**
- Config: `|server :host localhost :port 8080`, unchanged from plain UDON. The cleanest.
- Science table: `|sample :mass qty(3.2 kg) :temp qty(21.5 °C)`. Reads like code and repeats the kind per value, but it's unambiguous.
- Notes: `|note :on date(2026-10-01)`.
- Friction: none big. Mild repetition.

**Pick: C.** It keeps names clean, leaves config bare, and uses one mechanism for kinds, which Q3 also uses. B is the best choice for a large table, but only once the space-inside-parentheses problem is fixed.

### Q2. A quoted value that stands alone

**A (string, quotes dropped; kind kept as metadata).**
- `|el :name "8080"` gives the string 8080, which is what I expected.
- `|p "To be, or not to be."` drops the quote marks from the prose. Agents writing dialogue will expect the quotes to stay. This is the friction point, and it's a real loss of information.

**B (text keeps quote marks; readable as the string inside).**
- `|el :name "8080"` gives text `"8080"`, readable as the string inside. No loss.
- `|p "To be, or not to be."` keeps its quotes, which is what a prose writer expects.
- Friction: an agent who wants a plain string may be surprised that the quotes are still there.

**Pick: B.** It loses nothing, and prose quotes are the case agents will write most often. A is slightly tidier for pure data, but it throws away the quotes.

### Q3. A value that names its own notation

**A (call-like `date(...)`).**
- Config: `|server :since date(2026-10-01)`. Reads like code.
- Science table: `|sample :mass qty(3.2 kg)`. Same as Q1 C.
- Notes: `|note :on date(2026-10-01)`.
- Friction: `printf(x) prints x` stays text only because the value must stand alone. That rule is subtle, and I'd expect agents to get it wrong in both directions, for example writing `:on date(2026-10-01) (approx)` and expecting a call. Nested `interval(date(...) date(...))` is heavy.

**B (tilde sigil).**
- Config: `|server :since ~date 2026-10-01`. Lean.
- Science table: `|sample :mass ~qty 3.2kg`. Compact.
- Notes: `~date` can read as "approximately", which is the wrong reading for a date in prose.
- Friction: inside a list, `[~date 2026-10-01 ~qty 3.2kg 42 hello]`, I'd expect agents to lose track of where a sigiled value ends. The sigil is also unfamiliar, so it reads as new syntax.

**C (inline element `|{…}`).**
- Config: `|server :since |{date 2026-10-01}`.
- Friction: BASICS introduces `|{…}` only as an element inside text, not inside an attribute value. I hesitated and would expect agents to be unsure whether it's allowed. Verbose, and nested forms get hard to read.

**Pick: A.** It reads like code, which agents already know, and it's the mechanism I'd most expect an untaught agent to reach for. Its cost is the stand-alone rule, which needs to be stated clearly.

### Q4. Attribute names, with or without a trailing colon

**A (no colon).**
- Config: `|server[web] :host localhost :port 8080 :debug false :owner nil`. Clean and unambiguous.
- Friction: none.

**B (optional trailing colon, ignored by the parser).**
- Config: `|server[web] :host: localhost :port: 8080 :debug: false`.
- Friction: this is the one that bit me in COLD. I read `:host:` as a possible name with a colon before I'd seen this option (20% confidence), so the colon is an unfamiliar surface. Allowing two spellings also means agents will mix them within one file, and a colon at the end of a word in prose could then look like an attribute.

**Pick: A.** One spelling. The optional colon adds a second way to write the same thing, and mixing them is the failure I'd expect.

## What I'd expect other agents to get wrong

- Dots in names (Q1 A) clashing with path-style nesting, such as `:server.port`.
- Parentheses doing two jobs (name in Q1 B, call in Q3 A).
- Believing a quoted prose line loses its quotes (Q2 A).
- Mixing spellings when the colon is optional (Q4 B).
- Expecting `printf(x)` to be a call, when it stays text unless the value stands alone.
- Writing `~` in prose and reading it as "approximate".

## Trial design feedback

- The `` re`^\d{3}-\d{4}$` `` foreign-text example shows a tag on backticks, but nothing says what happens when the verbatim text itself contains a backtick. An agent will ask.
- The Q3 A list example mixes `date("YY-MM-DD pivot 1950" 27-03-05)` (quotes inside parentheses) with unquoted values elsewhere. It's unclear whether quotes inside a call are a separate rule. It would be cleaner to show that case alone.
- Q1's examples show spaces inside parentheses in names. That needs a rule before the option can be judged fairly.
- The COLD read `|server :host: localhost` landed near 20% for me, so the Q4 B case was already visible before the options. That's worth knowing when reading the COLD results.

## Picks

| Question | Pick | Why |
|---|---|---|
| Q1 | C | Clean names, bare config, one mechanism for kinds. B is best for big tables once its spacing problem is fixed. |
| Q2 | B | Lossless, and prose quotes survive. |
| Q3 | A | Reads like code; the stand-alone rule is the cost. |
| Q4 | A | One spelling, nothing to mix. |
