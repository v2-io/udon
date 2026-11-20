# What the value trial found (2026-10-28)

*For Joseph, from the coordinator (Opus 5.5) of session `01Hgdj3fobqBFEmAFmJi6Zup`, after reading all eight reports whole. Eight agents: Haiku, Sonnet, Opus and Fable, each once from `BASICS.md` alone ("fresh") and once after reading the lite spec ("primed"). Each answered `COLD.md` (write eight values untaught; read nine lines) before opening `OPTIONS.md`, then wrote made-up UDON under each option in contexts of its choosing.*

*Read it as eight instincts, not a measurement: eight agents of one vendor's model families, one run each. The two Haikus are the thinnest evidence (you said so going in). And the arms were leakier than designed: every fresh agent had the udon repo's README auto-loaded (0.9-era examples, including `; bare date is a string`), and the primed agents met your leans in the cards' working notes. Where that plausibly moved an answer, it's said below.*

*The reports: `report-haiku-fresh.md`, `report-haiku-primed.md`, `report-sonnet-fresh.md`, `report-sonnet-primed.md`, `report-opus-fresh.md`, `trial-opus-primed.md`, `report-fable-fresh.md`, `report-fable-primed.md`. Three were saved by me from the agents' returned messages because the harness refuses subagent files named `report-*`; two of those agents declined a renamed file on principle.*

---

## What they wrote untaught (COLD)

**Units: every agent put the unit inside the value.** All eight put it there: seven wrote `|sample :mass 3.2 kg :temp(erature) 21.5 °C`, and Fable primed wrote it glued, `:mass 3.2kg :temp 21.5°C`. Not one reached for `.kg`, `(kg)`, `qty(…)` or a sigil. Several named the unit-in-the-name habit (`:mass_kg 3.2`, `:mass-unit kg`) as a competing instinct and rejected it. Two primed agents (Opus, Fable) said that to make it checkable they'd reach for `:mass <3.2 kg>`.

**Null: every fresh agent wrote `null`.** Haiku, Sonnet, Opus and Fable, untaught: `:owner null`. The primed agents wrote `nil` because the cards say so, and Sonnet primed said it would have written `null` otherwise. Under every option on the sheet, that's the text "null".

**Quoted defensively.** Five of eight quoted `:version "1.10" :zip "01234"` on reflex (the Norway problem). Opus fresh wrote both bare and then wanted to quote them. Fable primed wrote both bare on purpose, as "the single best argument for the lean" (bare is text), then noticed in Part 2 that the sheet's standard reading turns `1.10` into 1.1 through the view: "the lean's best example only half-survives".

**The quoted sentence.** Most avoided writing `|p "Hello," she said.` on one line and put the sentence on its own indented line as prose, because they couldn't tell whether a leading quote opens a value. Reading that line, the fresh agents expected one text with its quotes (55–65%); the primed ones expected the cards' current tree, a string then a text (80–85%), and called it a trap.

**The link.** Six used the framed backslash shown in BASICS. Two (Sonnet and Haiku, both primed) wrote `|a :href "https://example.com" Click here`, and two more (Sonnet fresh, Fable primed) said it's what they or an HTML-trained agent would write first. **Under the stand-alone rule that is a silent miss:** the quoted URL isn't standing alone, so `href` becomes the text `"https://example.com" Click here`, quotes included. This is the trial's most important new finding about D4.

**Backslash text.** Mostly single quotes for the regex and the Windows path; Opus fresh wrote both unquoted on purpose. Nobody guessed backticks.

**Reading the trial's own lines** (confidence ranges across agents):

| Line | What they expected |
|---|---|
| `\|sample :mass.kg 3.2` | a unit, 40–70%; every agent also offered "a name `mass.kg`" or "a path" |
| `\|config :server.port 8080` | a nested path or a dotted name, 50–65%. **Five agents noticed, unprompted, that they'd read the same dot as a unit in one line and a path in the other** |
| `\|sample :mass(kg) 3.2` | a unit annotation, 30–80% (primed lower: "parens aren't label characters") |
| `\|ev :on date(2026-10-01)` | a typed date, 50–85% fresh; text, 70–75% primed ("lite evaluates nothing") |
| `\|ev :on ~date 2026-10-01` | a type tag, 40–70%; three volunteered that `~` reads as "approximately" |
| `\|h3 date(format)` | plain heading text, 60–95%, every agent. Several: "I'd be alarmed if it fired here" |
| `\|server :host: localhost` | 20–50% on any reading: a name `host:`, a YAML slip, or a block opener; most wanted a diagnostic |
| `\|li printf(x) prints x` | plain text, 60–95% |

---

## The four questions

| | Haiku F | Haiku P | Sonnet F | Sonnet P | Opus F | Opus P | Fable F | Fable P |
|---|---|---|---|---|---|---|---|---|
| **Q1** name-side kind | C | C (B close) | C (B for tables) | B | B | B | B | B, as sugar for C |
| **Q2** quoted value alone | B | A | A in attributes, text in `$main` | B (weak, 55/45) | B | A | B (with a position caveat) | A |
| **Q3** notation value | A | A (C fallback) | A (registered names) + C in prose | C | C (A if a reading) | C (A as the same tree) | A, keeping C | C (A as sugar for C) |
| **Q4** trailing colon | A | A | A | A | A | A | A | A |

**Tallies.** Q1: B 5, C 3, A 0. Q2: B 4, A 3, split by position 1 (the fresh agents leaned B, the primed ones A). Q3: A 4, C 4, B 0 (two of the C votes want A defined as a spelling of C). Q4: A 8 of 8.

### Q1: nobody chose the dot

**A (`.kind`): zero of eight.** The reasons converge:
- **The dot already means nesting.** Two agents made the slip *while writing under option A on purpose*: Opus fresh wrote `:tls.cert` and `:db.host` meaning namespaces; Opus primed wrote `:listen.port` meaning a path, and didn't notice until rereading. Sonnet primed: `:db.pool.size 10` and `spring.datasource.url`-style keys. Sonnet primed also found Vue/Alpine attribute names that contain dots (`v-model.trim`, `@click.prevent`).
- **Units don't fit in a label:** `°C`, `m/s`, `µg/mL`, `kg/m³`. The sheet itself wrote `degC` under A.
- **It needs parentheses anyway** for parameters (`.date(YY-MM-DD …)`), so it's two mechanisms.
- Opus primed found the idea lovely as a parallel to element traits, "if A were restricted to *types* and never units", and said the dotted-path habit is what sinks it.

**B (`(kind)`): five.** "How every scientist writes a column header"; holds any unit; never reads as a path. **Its one silent miss, predicted by four agents independently:** `:mass (kg) 3.2`, written with a space as CSV headers are, which becomes the text `(kg) 3.2`. Opus primed wants a warning for it. Also noted: B and Q3-A put the kind inside the parentheses on a name and outside on a value (Haiku fresh, Sonnet fresh, Haiku primed). Fable fresh saw the same pair as a pleasing symmetry instead: `:on(date) 2026-10-01` ≡ `:on date(2026-10-01)`.

**C (nothing on the name): three,** for one mechanism and clean names, mostly with B as the table form.

### Q2: split, and the split follows position

Four leaned B (the text keeps its quote marks), three A (a string), one split by position. The fresh agents leaned B, the primed ones A. The reasons line up with position:
- **In `$main` and prose, everyone wanted the quote marks kept.** `|p "To be, or not to be."` and `|blockquote "…"` losing their marks under A was called "silent and destructive" by five agents.
- **In attribute values, everyone expected quotes to be delimiters.** `:name "8080"` is the string 8080; quoting is the protective move, and under B "being safe depends on which reading the consumer asks for" (Opus primed).
- **So two agents (Sonnet fresh, Fable fresh) proposed the rule follows position:** quotes are characters in `$main` and prose, delimiters in attribute values. Sonnet primed and Opus primed both noted that this breaks one-rule-everywhere for element and attribute lines.
- **Opus fresh's framing:** B is the same "text with readings" model the preamble already uses for numbers, extended to quotes.
- **Fable primed's answer to that:** B doesn't actually rescue `|p "To be…"`, because a consumer applying the standard reading strips the quotes there too, and under B escapes sit unprocessed in the raw tree. It chose A.

### Q3: the constructor and the element; nobody chose the sigil

**The sigil (`~name`): zero of eight, unanimously, for one reason above all:** `~` already means "approximately" in exactly the data contexts kinds appear. Fable fresh wrote `follow-up ~2026-11-15` meaning "around" *before thinking about Q3 at all*. Fable primed couldn't write `[~duration 3mo 5d ~duration 1y]` at all. Opus primed: `~deploy/releases` (a home directory), `~0.4` (a Cargo/npm version range), `~5 min` (about five minutes), `:eta ~two weeks`. And its extent differs between a value and a list item, which the options sheet's own examples showed (`~qty 3.2kg` in the list, `3.2 kg` elsewhere).

**A (`date(…)`): four.** Most guessable ("CSS taught every agent this shape"), self-delimiting in lists, nests. **Its hazard, raised by every agent:** API documentation. `|h3 date(format)`, `|h3 now()`, `|h3 parse()`, `:onclick toggle()`, `|code main()`. Proposed remedies:
- only registered notation names are recognized; unknown names stay text (Sonnet fresh; Fable fresh's "floor");
- never in `$main`, only attribute values (Sonnet fresh; Opus primed noted that breaks one scan for element and attribute lines);
- make it a *reading* over the text rather than a parse rule, so the raw tree keeps `date(format)` as text and only a consumer that asks sees a date (Opus fresh, Opus primed).

**C (`|{date …}`): four, and the strongest case for it is prose.** It's the only option that can mark a value inside a sentence ("Met Marta on |{date 2026-10-26}"); HTML already does it this way (`<time>`); it adds no syntax. Fable fresh: the recipe written under C "was the most pleasant thing I wrote in this trial". Its costs: heavy in tables and lists; kinds share a namespace with element names; and **a brace-less trap** (Opus primed): `:cert-expires |date 2027-01-15 :renew |duration 30d` is legal lite in which `:renew` silently becomes the `date` element's attribute. Opus primed and Fable primed reached the same resolution separately: if A comes in, make `date(2026-10-01)` *the same tree* as `|{date 2026-10-01}`, one model with two spellings. Fable primed adds that C "is the fence mechanism" (an element whose name selects a handler), and would take A only if unknown notation names are a loud error.

**Backticks for verbatim text: liked by everyone who tried them.** Opus primed called them "the best thing on the sheet": the only lite spelling for a value that ends in a backslash (`` `C:\ProgramData\api\logs\` `` can't be written in single quotes). Open edges they raised: a backtick inside the body; and `|li `ls -l`` standing alone becomes a raw value, so a list item that is just a Markdown code span stops being Markdown (Sonnet primed).

### Q4: everyone chose no colon

Eight of eight chose A. The reasons:
- two spellings for one thing, so mixed files (`:host: x :port 8080`) and `grep ':host '` missing half (Sonnet fresh);
- reading `:host:` cold, most guessed it *meant something*: a name `host:`, a YAML-style block opener, a typo (20–50% confidence on any reading), so tolerating it "invites readers to look for a distinction that isn't there" (Fable fresh);
- it piles up with Q1-B: `:mass(kg): 3.2`;
- it only helps `:name:`, not the commoner YAML slip `|server host: localhost`, which the existing warning already catches (Fable primed: "B fixes a mistake agents don't make, and doesn't fix the one they do"; it proposes extending the warning to `word: value` prose lines under an element);
- it can invite the rest of YAML (`:tls:` with indented `:cert:` below), which lite then refuses.

Fable fresh gave B its fairest hearing: without highlighting, `:title: War and Peace` makes the name/value boundary visible at a glance, "a genuine readability gain" for long values, before choosing A. **Most want `:host:` to warn or error with "did you mean `:host localhost`?"**

---

## Beyond the four questions (raised by several agents)

1. **Declare kinds once.** Five agents said their main friction in data was repeating the kind on every row, not how it was spelled, and four sketched a fix: `|table :cols [t(s) mass(kg) temp(°C)]`, `|samples :mass(kg) :temp(°C) :ph` on the parent, a legend. Opus primed: "without it each option is judged at its noisiest". This is D10 in the guide.
2. **`null`.** Every fresh agent wrote it. [[rule:nil-spelling]] already warns on it (default-on); the trial suggests the warning earns its place, or that `null` should simply be accepted.
3. **Does `$main` get the standard reading?** `|td 1.10`, `|li true`, `|h2 2026`, `|p nil` (Sonnet fresh: "the first thing I'd ask Joseph"). It's D2's open "is prose ever read?".
4. **A standard reading for ISO dates, and for number-with-unit tokens** (both Fables, separately; Fable primed adds `3.2kg`, `220°C`, `90min`: "every context was most beautiful bare and every option made it worse"), by the same argument that gives numbers one: a bare `2026-10-01` can only be a date or a string, and the writer who wants the string quotes it. "Most of the Q1/Q3 load in notes, logs and holiday lists evaporates."
5. **The stand-alone rule's demotion should warn in attribute position** (Sonnet primed): a quoted value, a `name(…)` or a backtick span followed by one more word silently flips to text. Warn on `:href "…" Click here` and `:on date(…) extra`; leave prose silent, where demotion is what the writer means.
6. **`<…>` was missing from Q3.** All four primed agents noticed it (Fable primed reached for it in four of its eight COLD answers): it's the spec's incumbent, commits at its first character with no stand-alone holdback, and was Opus primed's own untaught reach. (It was left out because you lean toward retiring it; I didn't say so in the options, to keep your other lean out.)
7. **Is all typing a reading over text?** Both Opus agents arrived at the same model: the raw tree is texts and elements, and numbers, quotes and notations are named readings over them. Under it, `|h3 now()` is harmless and Q2-B looks right; its cost is that "what this document means" depends on which readings a consumer turns on, which Opus primed called "a real cost for a data notation".

## On the trial's design (their feedback)

- The fresh arm wasn't BASICS-only: launch such agents from outside the udon repo.
- COLD's Read section showed the option spellings while agents wrote; put Read in a second file.
- Q1 and Q3 aren't independent (Q1-C is Q3-A); show them as packages. Q1 mixed units and types in one slot; ask about them separately.
- No many-row table, mixed list, date-in-a-sentence or dotted config key among the Write items: that's where the options differ most.
- The scratchpad is shared between parallel agents (one agent's saved answers were overwritten by another's); give each its own file.
- The options sheet's premises differ from the cards; say so.
- Name output files `trial-*`, never `report-*`.

---

