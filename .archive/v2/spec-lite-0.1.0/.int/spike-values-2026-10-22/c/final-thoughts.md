# Final thoughts, after reading spikes a and b

*Spike c's agent, 2026-10-22, after all three landed. I read a's README, debrief and branch map, b's README, debrief and its stand-alone page, and Joseph's remarks at the end of `STEWARD-VERBATIM.md` and `types-ideation-2026-10-22.md`. Convergences get one line. The rest is what the wider view shows me that I didn't see from inside c.*

**Where all three agree, in one line:**
- bare runs are text carrying a fixed primitive classification (a's "text + class", b's normative default reading, c's allomorph);
- the classification set is JSON's;
- a leading zero stays text;
- units are read by the slot when bare;
- streaming never separated the options (all three measured or modeled it);
- a bare label never ends in `:`.

All three of us are the same model, so this agreement is as much shared priors as confirmation. The information is in the disagreements.

## 1. b's "a delimited value must stand alone" repairs the worst part of my design

b found something I missed entirely. A writer's line `|p "Hello," she said.` loses its quotation marks under today's cards: it becomes the string `Hello,` plus the text `she said.`. b's rule: a value is exactly one delimited form *standing alone* (followed by a space and a start, a framed ` \ `, or the end of the line), or it is a run, and the delimiters are content.

Applied to my design, it fixes three things I had marked as costs:

```udon
|li <kbd>Ctrl</kbd> to copy
|li See <https://example.com> for docs
|li <https://example.com>
|p "Hello," she said.
```
````tree
root
  |li  :$main ‹<kbd>Ctrl</kbd> to copy›          ← text; my design made it an error
  |li  :$main ‹See <https://example.com> for docs›
  |li  :$main named(https, ‹//example.com›)       ← stands alone: a URI value, as CommonMark means it
  |p   :$main ‹"Hello," she said.›
````

**What follows:** with the stand-alone rule, ASCII `<…>` collides with HTML and Markdown only where a tag or autolink is the *whole* value. That nearly dissolves the bracket question I left for Joseph (ASCII `<…>` vs `⟨…⟩`): `⟨…⟩`'s main advantage was freeing `<` in text, and the stand-alone rule mostly frees it already. My lean moves from "ASCII, low confidence" to "ASCII, medium".

**A flaw in the rule that neither b nor I named:** standing alone is decided *after* the closing delimiter. `"Hello,"` is a string only if what follows is a space and a start or the end of the line. So the kind of every delimited value is decided at its close: the same "kind known late" that the B1 wording question was about. Memory stays bounded, since the quoted content is held whole anyway, as all three spikes measured. But if B1 keeps its current wording, b's rule needs the same answer the allomorph gave bare runs. The value is a run (known at the first character), and "it is the string `Hello,`" is a face attached at the close. It's worth asking whether that is one rule rather than two: **every sameline value is a run, and a closed form standing alone, or a run spelling a primitive, gives it a face.**

## 2. Labels wear the reading, and my clef was a worse spelling of it

b's main invention is `:mass.kg 3.2`, `:on.date 2026-10-01`, `:port.u16 8080`. Joseph: "definitely along the creative lines I was hoping for", and he reads "mass, then kg inside it" as an affordance, not the TOML hazard that my mark fork scored down. My round-two clef, `:on <date> 2026-10-01` and `<date> [2026-01-01 …]`, does the same job with a bodiless `<…>` floating between the name and the value. Under the stand-alone rule it doesn't even parse as I meant it: `<date> 2026-10-01` isn't a lone delimited value. **I concede the clef to b's label form,** for single values and for lists (`:holidays.date [2026-11-26 2026-12-25]`). b's `$sig` covers tables. The music metaphor survives only as b's own key signature and accidentals, which is the better use of it.

Spike a killed traits as slot types because `:port.u16 8080 :port 443` gives one slot two types. b's reframing answers it: the trait belongs to the *occurrence* (an accidental), not the slot, and an occurrence reading what its literal represents is exactly Joseph's distinction. a's objection was to calling it a slot type, not to the spelling.

## 3. The canary: I found `name(…)` and then talked myself out of it

Joseph's canary, held back until the spikes reported, was "the simple fact that we have '(...)' attached to any name freely available". My inventions page found it, as β constructor values: `date(2026-10-01)`, `re(\d+-\w+)`, CSS's `url(…)`. Then I demoted it to parameter syntax inside `<…>`, because `|li printf(x) prints x` would silently become a constructor. That was the safety reflex his note named: one collision scored the idea down before it had a chance to get good.

Two things from the wider view rehabilitate it:
- Joseph's own observation: "normal prose almost never has an opening parenthase directliy after a letter or number". The exceptions are code and `file(s)`.
- b's stand-alone rule removes both exceptions. `|li file(s) to upload` and `|li printf(x) prints x` aren't standing alone, so they are text. Only a value that *is* `name(…)` and nothing else is a constructor.

And `(…)` attached to a name gives one family across every place a name appears:

```udon
|sample :mass(kg) 3.2 :temp(°C) 21.5 :taken(datetime) 2026-10-01T14:30Z
|person :born(date YY-MM-DD) 27-03-05
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|rule :pattern re(\d+(\.\d+)?)
```
````tree
root
  |sample
    :mass ‹3.2›~float (kg)           ⇒ 3.2 kg
    :temp ‹21.5›~float (°C)          ⇒ 21.5 °C
    :taken ‹2026-10-01T14:30Z› (datetime)   ⇒ an instant
  |person
    :born ‹27-03-05› (date YY-MM-DD) ⇒ 2027-03-05
  |meta
    :values [named(date, ‹2026-10-01›) named(qty, ‹3.2 kg›) ‹42›~int ‹hello›]
  |rule
    :pattern named(re, ‹\d+(\.\d+)?›)    ← matched parentheses nest, so a regex's own groups need no escape
````

**`:mass(kg) 3.2` is how every scientific table and spreadsheet header names a unit:** "Mass (kg)", "Temperature (°C)". It is more domain-native than `:mass.kg`. It also takes nothing from dotted attribute names (`data.x`), and its parenthesis can hold parameters with spaces, which a trait can't (`(date YY-MM-DD)`). The spelling is already held open: the labels lean makes `(` and `)` in a bare label an error ("Bracket characters stay structural", `.int/labels-ascii-and-positions-2026-10-20.md`, checked), so `:mass(kg)` widens an error and changes no tree. b's `.kind` and the parenthesised header are the same idea. **My taste: the header form `:mass(kg)`,** for the unit and its parameters together. I'd also keep `.kind` working if Joseph prefers the trait's look, since a parameterised trait (`:born.date(YY-MM-DD)`) composes both. On the value side, `name(…)` standing alone is the notation value for slots with no name to wear it. It reads as "date of …", which every agent writes daily.

## 4. a's finding that reading-notations put the qualifier *after* the value

a's inventors found that notations made for human readers put the qualifier after the value: physics' `30 s`, furigana, interlinear glosses, F#'s `5<min>`. Notations made for parsers put it first. My frame (`00-frame.md`) ranked by *when a parser learns the kind*: slot, then start mark, then spelling. a's finding ranks by *where a reader's eye wants it*, and the two pull opposite ways for a value standing on its own.

Seeing both, **the scientific column header resolves it.** The qualifier sits on the *name*. That is before the value for a parser, and it is how a human reader is used to seeing a unit named, at the column's head. For a value with no name (in a list), a's `30s⟪duration⟫` reads beautifully but no agent will guess `⟪`. My typeset shapes cover the common cases with the qualifier after anyway (`<30 s>`, `<9.99 USD>`, `<37.5 °C>`: unit after number, as a's physics example has it). `name(…)` covers the rest with the name first, as a function reads. So a's finding is already honored where it matters most.

## 5. a's question, which my design answered without asking: is a refinement a change?

a asked whether *adding* information to an accepted tree counts as changing it under reserve-don't-ignore. My design leans on "no" in two places, without saying so:
- **faces:** if a later version gave bare `2026-07-21` a `~date` face, every old tree would gain an attachment;
- **named values:** `named(css, ‹920px›)` read later as a CSS length.

My honest answer:
- **Faces should be closed for good.** Lite's face set (nil, true, false, JSON numbers) never grows, so no refinement happens to bare runs. New kinds arrive only through names: labels, `name(…)`, typeset shapes inside `<…>`.
- **Named values *are* the refinement mechanism,** and the tree marks them as carried and unread. A later reader adds meaning to a node that said "a reader will interpret this", which is what fences already do (a's own point).

So B2 needs one sentence: *a later version may read what lite marked as named, and may never give a new face to what lite marked as text*. **That sentence, not "above the tree" alone, is the law** my synthesis should have stated.

## 6. A question none of the three asked: who actually reads the meaning?

CTQ's first line says agents are the principal readers. An agent reading a lite document reads the **source text**, not a tree through a vocabulary-aware reader library. Every design here (mine most of all) puts real weight on vocabularies, scope, file-name conventions and reader layers, and **all of that is invisible to the principal reader.** `:mass 3.2` under a vocabulary that says kilograms is a number with no unit to an agent reading the file. `:mass(kg) 3.2` carries its meaning to every reader, human, agent or library, at a cost of four characters.

This suggests CTQ's split between A5 (domain-forward, 9) and A10 (self-description, 5) may be mis-tuned for agent readers. A10 was lowered to avoid verbose declaration, which is right. But a unit or a kind *on the name* isn't plumbing. It's the domain's own words (A5), and it's what makes b's labels and the header form score so well in every spike. I'd ask Joseph whether "visible to a reader of the text" belongs inside A5's definition. If it does, external vocabularies drop from "the slot types" to "the tooling's checks on what the text already says". That's a different and, I think, better place for them.

The same lens shows a cost in b's `$sig` and in my clefs: **action at a distance.** An agent editing row 400 of a `$sig` table has to look up row 1 to know what `3.2` means. That is YAML-anchor-shaped. It is cheap for a reader library, but a real cost under D1 (agent tooling) and A4 (agentic readability). It's worth a line on the signature's card: a signature is for tables you'd print with a header row, not for scoping a whole document.

## 7. What I'd now propose, folding the three spikes together

```udon
|server :port 8080 :debug false :zip 01234 :version "1.10"
|sample :mass(kg) 3.2 :temp(°C) 21.5 :on(date) 2026-10-01 :lasts(duration) 90 min
|event :at <2026-01-10T07:30-07:00[America/Denver]> :fee <9.99 USD> :span <2026-01 – 06>
|meta :values [date(2026-10-01) <3.2 kg> 42 hello] :home <https://example.com>
|rule :pattern re(\d+(\.\d+)?) :path `C:\Users\me`
|samples :$sig [mass(kg) temp(°C)]
  |s :mass 3.2 :temp 21.5
|p "Hello," she said; meet on [Oct 1st](date:2026-10-01), see <https://example.com>.
```

| Piece | From | Why |
|---|---|---|
| Bare runs are text with a closed set of JSON faces | all three (a's Cc, b's default reading, c's allomorph) | `:debug false` must not be a truthy string (b ran it in four languages) |
| A delimited value stands alone, or the run is text | b | quotes, links and tags in prose survive; `<` mostly freed |
| The reading on the name: `:mass(kg)`, `:on(date)` | b's labels, with Joseph's `(…)` canary | kind-first; how science labels a column; visible to the principal reader |
| `name(…)` as a value, standing alone | c's β, rehabilitated by b's rule and Joseph's prose observation | the generic-slot notation, read as "date of …" |
| Typeset shapes inside `<…>` | c (and std★) | when a value names itself by its look: dates, money, quantities, en-dash ranges |
| Backtick raw values | b (and a's value-size fences) | `` `C:\Users\me` `` with no escapes |
| `$sig` for tables | b | the column header, written once; a table only |
| Markdown links carry typed values in prose; URIs are values when standing alone | c (α, ζ) | agreement with CommonMark |
| A closed face set, and named values as the only refinement path | the answer to a's §5 | the B2 law, stated |

**Beauty-first, my hypotheses:**

| | A1 beauty | A2 guess | A3 cold | A4 agent-read | A5 domain | A6 clarity | A7 simplicity | C2/C3 |
|---|---|---|---|---|---|---|---|---|
| **this fold** | 9 | 8 | 9 | 9 | 10 | 6 | 5 | 9 / 10 |
| c's round-two synthesis | 9 | 7 | 8 | 9 | 9 | 6 | 4 | 7 / 10 |
| b's LW | 8 | 8 | 8 | 8 | 9 | 7 | 6 | 9 / 9 |
| a's composed (⟪⟫, legend) | 8 | 5 | 7 | 8 | 9 | 7 | 6 | 9 / 9 |

The fold gains on A2/A3/A5 because the two spellings that carry most of the meaning, `:mass(kg)` and `date(…)`, are ones agents already write. It loses a little simplicity, since it has three value forms where b has two.

## 8. Small things the wider view showed

- **b's ASCII unit names** (`degC`, `pct`) ignore the CTQ change Joseph made deliberately: hard-to-type characters are no longer a cost (A12, weight 2). `°C` and `%` are what every reader recognizes.
- **a's `⟪…⟫`** is the most beautiful single value in the three spikes and the least guessable. That is the same trade as my `⟨…⟩`. Both are worth exactly one three-example probe, the cheapest measurement anyone could buy here.
- **b's hinged `<date: …>`, a's `<date: …>` and my `<css:920px>`** are three spellings of the same named literal, and they differ only on the space after the colon. With `name(…)` standing alone, I'd drop all three for the constructor and keep `<scheme:…>` only for URIs, as CommonMark has them.
- **My clef and b's `$sig`** both came from music. b put it on the container and I put it in the value stream. b's placement is right, for the reasons in §2.

## 9. On the process, briefly

Joseph's canary measured something real. I generated `name(…)` and killed it within a paragraph on one collision, before letting it grow. The stand-alone rule that saves it existed in a sibling spike the whole time. Independent spikes protect variety, but they can't share a rescue. **One cheap improvement for next time: an exchange round between independent spikes *before* they converge**, where each reads the others' dead branches, not their winners. Most of this page is that exchange, arriving one round late.
