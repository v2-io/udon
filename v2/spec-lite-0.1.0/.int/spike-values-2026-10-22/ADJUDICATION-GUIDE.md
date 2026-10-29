# Lite values: what you need to decide

*For Joseph, 2026-10-28. Written to be read in order, from the top.*

## What this is

Lite has to decide how a value written in a file comes to mean something: is the value of `:port 8080` the number 8080 or the text "8080"? How does a writer say "this is a date" or "this is in kilograms"? And what is `<…>` for, if anything?

Three agents explored this on 2026-10-22, each with helpers, and each proposed a design. Today, two more agents checked that work, and eight agents (two each of Haiku, Sonnet, Opus and Fable) tried the leading options by writing made-up UDON and saying what felt natural and what tripped them up.

This file turns all of that into **nine decisions**, in an order where each one only needs the ones before it. Each decision gives:

- the question, in plain words, with an example;
- the options, each with what it does to the example;
- what the agents found (the three explorers, the two checkers, and the eight in the trial);
- my recommendation, as one of lite's target users.

Nothing here is decided, and no spec card has been changed. Where the evidence came from, and everything left out to keep this readable, is in [`ADJUDICATION-DETAIL.md`](ADJUDICATION-DETAIL.md) and in the trial's [`RESULTS.md`](../trial-values-2026-10-28/RESULTS.md).

**How the examples read.** Each example is a line of UDON, followed by what it gives, in plain words. Two things can differ, and the examples keep them apart:

- **what the parser keeps:** always the characters exactly as written;
- **the value:** what anything using the parsed file gets when it asks (a config loader, a converter to JSON, an editor tool).

```udon
|server :host localhost
```
→ the parser keeps `localhost` as written; the value is the text "localhost".

(That one is the same under every option on this page. Examples that depend on a decision say so.)

## What everyone already agrees on

These came out the same in all three explorations, and nothing in the checks or the trial argued against them. They're the ground the decisions stand on.

1. **Lite never interprets a value's meaning beyond a small built-in set.** What a port is, what unit a mass is in, what an alias means: all of that belongs to schemas and to the tools using the file, not to lite's grammar.
2. **Units are written in the value, as text, and whatever knows the attribute gives them meaning.** `:timeout 5m` is five minutes and `:length 5m` is five metres; lite keeps `5m` as written. (In the trial, every agent wrote units this way untaught: `:mass 3.2 kg`.)
3. **A name never ends in `:`.** An agent's draft on which characters names may contain (2026-10-20, not yet discussed with you) allows `:` inside a name, so that `xml:lang` works, but as drafted it also allows `:` at the end, which would make `:host: localhost` an attribute named `host:`. All three explorers said a name should never end in `:`. That fits either answer to decision 7: with your optional colon it's consumed and the name is `host`; with no colon allowed, `:host:` is an error.

---

## Decision 1: do bare values get types?

**The question.** A value written without quotes, `:port 8080` or `:debug false`: is its value the number 8080 and the boolean false, or the text "8080" and the text "false"? (Either way the parser keeps the characters as written.)

Your lean of 2026-10-21 ("C with the view"): the value is always text, and anything using the file *may* choose to treat `8080` as a number.

**What the agents found.** If treating it as a number is each tool's choice, two tools disagree about the same file, and the dangerous case is booleans:

```udon
|server :debug false
```
→ a tool that didn't choose to gets the text "false", which counts as *true* in Python, JavaScript, Ruby and Elixir (one explorer ran it in all four).

All three explorers, and both checkers, concluded the value has to be the same for every tool. The streaming worry that moved you to "C with the view" (`4938…2p`) turned out not to separate the options: recognizing whether a run spells a number takes a tiny fixed amount of memory, whichever way this goes.

**The options.**

| | What the parser keeps | The value of `:debug false`, with no schema |
|---|---|---|
| **A** | the characters; the spec says the value of `nil`, `true`, `false` or a number is that value | false |
| **B** | the characters, plus the type, recorded by the parser beside them | false |
| **C** (your lean as written) | the characters; whether the value is a number is each tool's choice | depends on the tool |
| **D** | the characters; the value is text unless a tool asks for a number | the text "false" |

A and B give every tool the same value; they differ only in whether the spec states it (A) or the parser records it (B). C and D don't.

**Three smaller questions that come with it:**

1. **Which spellings get read?** The explorers chose JSON's: `nil`, `true`, `false`, and numbers as JSON writes them (no leading zero, no `0x`, no `_`). So `:zip 01234` stays text, keeping its zero. But you wrote on 2026-07-14 that "0x 0o 0d 0b *definitely* help as literal qualifiers, as does '_' agnostic digit separators". Under JSON's set, `0xFF` and `1_000` are text.
2. **The version-number problem.** The value of `:version 1.10` is the number 1.1. Every remedy needs the writer to quote it (`"1.10"`) or a schema to say it's text. In the trial, five of eight agents quoted versions untaught anyway.
3. **`null`.** Lite's spelling is `nil` (your 2026-10-09 call), and a bare `null` is text with a warning. **In the trial, every agent that hadn't read the spec wrote `:owner null`.** So that warning will fire a lot. Accepting `null` too is the alternative.

**My recommendation: A.** The same value for every tool, and the parser keeps only what was written. B also works, but it makes the parser record types as well. For the set: JSON's, plus `0x`/`0o`/`0b` and `_` between digits, as you wrote in July; no word is spelled that way, so nothing is misread. Keys (`|step[3]`) stay text: a key names something, it isn't a quantity. Keep `nil`, with the warning on `null`.

---

## Decision 2: a quoted value at the start of a line

**The question.** Today, on an element's line, a quoted value takes its quotes as delimiters, and whatever follows it on the line becomes a second value:

```udon
|p "Hello," she said.
```
→ today: `$main` is the string `Hello,`, then a second `$main`, the text `she said.` The quote marks are gone, and the sentence is in two pieces.

The same happens to a Markdown link at the start of a list item (`|li [Docs](https://x.org) for more` becomes a list, then text).

**The proposal** (from one explorer; the other two adopted it): a quoted or bracketed value only counts as one if nothing follows it on the line. Otherwise the whole thing is text, quote marks and all.

```udon
|p "Hello," she said.
|el :a "x" y
|el :a "x" \ y
```
→ `p`'s `$main` is the text `"Hello," she said.`, quotes included.
→ `a` is the text `"x" y`.
→ `a` is the string `x`, and `y` is `$main` (the ` \ ` ends the value, as today).

This reverses a decided example: the card on leftover values shows `|q "hello," she said` as two values.

**The question inside it.** When a quoted value *does* stand alone, is it the string inside the quotes, or text that keeps them?

```udon
|p "To be, or not to be."
|el :name "8080"
```
- **As a string:** `p`'s `$main` is `To be, or not to be.`, and `name` is the string `8080`. Quotes are delimiters, as in JSON.
- **As text keeping its quotes:** `p`'s `$main` is `"To be, or not to be."`, quote marks included.

**What the trial found.** The agents split, and the split followed position: everyone wanted a paragraph's quote marks kept, and everyone wanted `:name "8080"` to be the string 8080 (quoting is how they keep a value from being a number). Two agents suggested exactly that rule: quotes are characters in an element's own text, delimiters in attribute values.

**A new trap the rule creates.** Four of the eight agents wrote, or named as their first instinct, this:

```udon
|a :href "https://example.com" Click here
```
→ under the rule, `href` is the text `"https://example.com" Click here`, quotes included, and the link has no text. Nothing warns.

**My recommendation: adopt the rule.** A quoted value standing alone is a string (keeping lite's one rule for element lines and attribute lines). And add a warning, on by default, when a quoted value in an *attribute* is followed by more text: "did you mean `:href "https://example.com" \ Click here`?". No warning on an element's own text, where `|p "Hello," she said.` is exactly what the writer meant.

---

## Decision 3: writing what kind of value something is

**The question.** Sometimes a value needs to say what it is in the file itself: a list holding a date, a quantity and a number; or a writer who wants a date checked. How is that written?

**The options**, on the same line:

```udon
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]          ; A: a name with parentheses
|meta :values [~date 2026-10-01 ~qty 3.2kg 42 hello]            ; B: a tilde and a name
|meta :values [|{date 2026-10-01} |{qty 3.2 kg} 42 hello]       ; C: an inline element
```

A was your "canary": a name with parentheses attached. In prose it's safe, because a parenthesis rarely follows a letter there; the exceptions (`printf(x)`, `file(s)`) are safe under decision 2's rule, since they don't stand alone:

```udon
|li printf(x) prints x
```
→ text, because `printf(x)` doesn't stand alone.

**What the trial found.** A: 4 of 8. C: 4 of 8. **B: none.** A tilde already means "approximately" exactly where dates and quantities appear: one agent wrote `follow-up ~2026-11-15` meaning "around" before it had even thought about this question; others found `~deploy/releases` (a home directory) and `~0.4` (a version range).

**The hazard with A: headings and code.** Every one of the eight agents read this as a plain heading:

```udon
|h3 date(format)
|h3 now()
```
But `$main` is a value, so under A these stand alone and become notation values: a date with the body `format`, and a notation `now` (an error, since lite doesn't know it). API documentation is full of headings like these.

**C's strength is prose:** it's the only option that can mark a date inside a sentence (`Met Marta on |{date 2026-10-26}.`), and it adds no new syntax. Its costs: heavy in tables and lists, and a trap without braces (`:due |date 2026-10-30 :renew |duration 30d` gives `renew` to the date).

**An idea two agents reached separately:** make A a short spelling of C. `date(2026-10-01)` in a value means exactly what `|{date 2026-10-01}` means. Then there's one idea with two spellings: the short one for values and lists, the element for prose.

**Two details any choice needs:**
- **A two-digit year must say its century.** `27-03-05` read as `YY-MM-DD` could be 1927 or 2027, and a rule like "the nearest century" gives different answers in different years, so a document's meaning would drift with the clock; one explorer wrote `pivot 1950` into the format for this.
- **Unknown names.** An unknown name (`colour(…)`, a typo like `dtae(…)`) is either an error that suggests a fix, or text.

**My recommendation: A, as a short spelling of C,** recognized in attribute values but not in an element's own text, so `|h3 date(format)` stays a heading. That breaks one rule for element and attribute lines in one place, for a reason those two places really differ: a heading is prose; an attribute value is data. Unknown names in an attribute value are an error that suggests a fix. Two-digit years need a stated century. Not B.

---

## Decision 4: the kind on the attribute's name

**The question.** For data like a table of measurements, the explorers proposed putting the kind on the attribute's name, so the values stay plain:

```udon
|sample :mass.kg 3.2 :temp.degC 21.5            ; A: a dot
|sample :mass(kg) 3.2 :temp(°C) 21.5            ; B: parentheses, as in a column header
|sample :mass qty(3.2 kg) :temp qty(21.5 °C)    ; C: nothing on the name (decision 3 on the value)
```

You called A's reading ("mass, then kg inside it") an affordance.

**What the trial found: B 5, C 3, A none.**
- **The dot already means nesting to agents.** Two agents made the mistake while writing in style A *on purpose*: one wrote `:db.host` and `:tls.cert` meaning "the host inside db", another `:listen.port`. Five noticed, reading cold, that they took the dot in `:mass.kg` as a unit and the dot in `:server.port` as a path.
- **The dot can't hold most units:** `°C`, `%`, `m/s` aren't name characters, which is why the example says `degC`.
- **B reads like a scientist's column header** ("Mass (kg)") and holds any unit. Its likely slip: `:mass (kg) 3.2`, with a space, which silently makes the value `(kg) 3.2`.
- **What agents actually wanted most** (five of eight, unprompted): to say the kind *once* for a whole table, not on every row:

```udon
|samples :mass(kg) :temp(°C)
  |s[1] :mass 3.2 :temp 21.5
  |s[2] :mass 3.4 :temp 21.7
```

**My recommendation: B,** with a warning on the space slip. I'd originally leaned A; the trial changed my mind. And before deciding whether it's in lite 0.1, design "say it once per table", since that's what writers actually want and it would use the same spelling.

---

## Decision 5: verbatim text in backticks

**The question.** Regular expressions and Windows paths are full of backslashes. Today they go in single quotes (`'C:\Users\me'`), where a backslash is literal, except that a single-quoted value can't end in a backslash.

**The proposal:** backticks standing alone are verbatim text, with no escapes; a name in front says what it is.

```udon
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me\`
```
→ `pattern` is a regular expression, written exactly; `path` ends in a backslash, which single quotes can't do.

**What the trial found:** everyone who tried them liked them ("the best thing on the sheet", one said), though nobody reached for them untaught. One cost: a list item that is only a code span (`|li `ls -l``) would stand alone and become a verbatim value, not Markdown.

**My recommendation: adopt.**

---

## Decision 6: what `<…>` is for

**The question.** Today `<…>` holds a value lite carries without reading (`:when <2026-10-01>`). You reopened it on 10-22 and said today that you lean strongly toward retiring it from values.

**With decisions 1, 3 and 5, nothing needs it:** numbers are read bare, kinds are written `date(…)`, verbatim text goes in backticks. Retiring it frees `<` for HTML and Markdown in text (`|li <kbd>Ctrl</kbd> to copy` is just text).

**What changes with it:**
- your lean that `<>` means nil has no home; bare `nil` covers it;
- `@<ref>`, your own spelling (2026-10-11) for "a reference kept as a reference", isn't affected: it starts with `@`.

**What the trial found:** the trial didn't test it (left out, given your lean). The four agents who'd read the spec all noticed it was missing, and two reached for `<3.2 kg>` when they wanted a checked value, but that's the current cards talking as much as instinct. None of the four who hadn't read the spec reached for it.

**My recommendation: retire it from values.** It stays an error in lite 0.1, so full UDON is free to use it later.

---

## Decision 7: the trailing colon

**The question.** Your light lean, which you said you're persuadable on: allow an optional colon after an attribute's name, ignored by the parser.

```udon
|server[web] :host localhost :port 8080
|server[web] :host: localhost :port: 8080
```
Both would mean the same thing.

**What the trial found.** The options were shown neutrally, with your lean kept out of every file the agents could read. **All eight chose no colon.**
- Before seeing the options, agents reading `|server :host: localhost` cold gave any single reading 20–50%. Most thought the colon *meant something*: an attribute named `host:`, or a YAML-style opener for lines below. So an optional colon invites a reader to look for a difference that isn't there.
- Two spellings for one thing means mixed files (`:host: x :port 8080`), and a search for `:host ` misses half.
- It stacks with decision 4: `:mass(kg): 3.2`.
- The fairest case for it, from one agent: without highlighting, `:title: War and Peace` shows at a glance where the name ends, a real gain for long values.

Most agents would rather `:host:` were an error that suggests `:host localhost`.

**My recommendation: no colon, with `:host:` an error that teaches.** This is the one decision here that's mostly about beauty, and the trial measures surprise for agents, not what looks cleaner to you. Your eye should decide it.

---

## Decision 8: what a later UDON may change

**The question.** Lite refuses anything full UDON might later define, so that no lite document changes meaning when full UDON arrives (your first decision about lite). With decisions 1–5, lite now *accepts* a few things it only partly reads. Can a later version add meaning to them?

```udon
|ev :at 2026-07-21 :on date(2026-07-21)
```
- `at` is text. If a later version decided bare dates are dates, every lite document with a date in it would change. Not allowed.
- `on` is a named value that lite keeps for a reader to interpret. A later version reading it as a real date adds nothing that wasn't already marked as "a date, to be read". One explorer's wording: *a later version may read what lite marked as named, and may never give new meaning to what lite left as text.*

Your reason for refusing rather than carrying (2026-10-01): older specs "retained the bytes" of undecided syntax, "That ambiguity caused a lot of confusion and made the language evolve a lot slower". The difference here is that named values are designed now, with a fixed meaning (decision 3's `date(…)` *is* a date), not undecided syntax kept for later.

**Two consequences:**
- **Decision 1's set is final.** If ISO dates are ever to be read bare (two agents in the trial asked for that), it has to be in lite 0.1 or never. My lean is never: dates are where the old line's typing surprised you most.
- **Notation bodies are checked from the start.** `date(2026-13-45)` must be an error in lite 0.1; checking it only later would break documents that had been accepted.

**My recommendation: adopt that sentence as the rule.**

---

## Decision 9: smaller things

- **Long lines.** A value runs to the end of its line, and lines can be any length. A lite parser should either have a line-length limit with an error that says it's a limit, or pass long text along in pieces. *Recommendation:* allow both; say so in the spec.
- **Printed quantities** (`37.5 ± 0.2 °C`, `2026-01 – 06`). One explorer designed these beautifully. *Recommendation:* they belong inside a notation (`qty(37.5 ± 0.2 °C)`), not in lite's own grammar; not in 0.1.
- **A link written without the backslash.** `|a :href https://example.com Click here` gives `href` the whole line, silently. *Recommendation:* a warning when a value that starts `https://` (or another scheme) contains a space, suggesting the ` \ `.
- **Typed values in prose.** `Meet on [Oct 1st](date:2026-10-01).` already works as a Markdown link a reader can interpret, and costs lite nothing. Decision 3's `|{date …}` is the other way.

---

## What I'd do first

1. Decisions 1, 2 and 8 settle what everything else stands on.
2. Then a short design of "say the kind once per table", before decision 4 is placed in 0.1.
3. Then I'd edit the spec cards for whatever you've decided, one decision at a time.

*Written by the session's agent (Opus 5.5). Sources and the full detail: [`ADJUDICATION-DETAIL.md`](ADJUDICATION-DETAIL.md); the trial: [`RESULTS.md`](../trial-values-2026-10-28/RESULTS.md); the checks: [`audit-opus.md`](audit-opus.md), [`audit-fable.md`](audit-fable.md); the explorations: `a/`, `b/`, `c/` in this directory.*
