# Final thoughts (spike b), after reading spikes a and c

*Spike b's agent, 2026-10-22, written after all three spikes landed and after reading a's and c's READMEs, debriefs, a's `invent/README.md`, c's `notations/inventions.md` (constructors) and `reader-model.md`, and Joseph's recent remarks at the end of the verbatim record and in the ideation notes. Per Joseph's guidance, little here is about where we agree. Labels: [checked], [inferred], [taste], [hyp].*

## Where we agree, in two lines

All three found that streaming doesn't separate B from C (two of us measured it). All three landed on bare-as-text with a fixed JSON-grammar classification: a's "class", c's "allomorph", my "default reading". All three moved slot types out of the document, and all three found the musical signature. Same model, same conclusions; useful, not news.

## 1. What I see now that I didn't: the stand-alone rule rescues Joseph's canary

Joseph's canary was a name with parentheses attached, `date(…)`, and his aside: "normal prose almost never has an opening parenthase directliy after a letter or number." I never tried it. My fork P killed KDL's `(type)value`, a parenthesis *before* the value, and I stopped there. Spike c found it as constructor values (`date(2026-10-01)`, CSS's `url(…)`, `rgb(…)`) and then demoted it to parameter syntax, for one reason: "`|li printf(x) prints x` becomes a constructor `printf`, silently" ([checked] `c/notations/inventions.md` line 60).

**My page 30's rule removes exactly that objection.** A delimited form counts as a value only if it stands alone (followed by a space and a start, a framed ` \ `, or the end of the line); otherwise the whole run is text. Neither a nor c has that rule [checked: neither directory uses it in this sense]. Under it:

```udon
|li printf(x) prints x
|li Upload the file(s) here
|ev :on date(2026-10-01) :lasts duration(3mo 5d)
|x :call printf(x)
```
````tree
root
  |li
    :$main ‹printf(x) prints x›          (not alone: a run, so text)
  |li
    :$main ‹Upload the file(s) here›
  |ev
    :on call date [‹2026-10-01›]           ⇒ Date
    :lasts call duration [‹3mo› ‹5d›]      ⇒ Duration 3 months 5 days
  |x
    ERROR at 1:10: `printf` is not a lite notation; for the text, write "printf(x)"
````

The one remaining collision is a whole value that is exactly a call to an unknown unprefixed name. That's rare, and it's an error that teaches, not a silent misread. So the most guessable spelling any of us found (c scored β-ascii's A2 at 9; I agree, since every agent writes `rgb(…)` and `url(…)` without thinking) becomes viable in ASCII, with no Unicode bracket.

And **calls make `<…>` unnecessary for values.** That settles c's hardest open choice (ASCII `<…>`, which errors on `<kbd>`, against `⟨…⟩`, which nobody guesses) by a third route. a's composition also retires `<…>` from values, and mine needn't keep it either. `<…>` goes back to full UDON whole (B6), and `<` is free for HTML and Markdown in text (C2, C3).

## 2. The combination I'd now propose: K

The label trait (my round three, which Joseph called "*definitely* along the creative lines") and the call (his canary) compose, because they sit in different positions and do different jobs. His own first imagining comes back almost verbatim. He wrote `:when:dt(YY-MM-DD)<27-03-05>`; with `.` for the `:` (which fixes `xml:lang`), it is `:when.date(YY-MM-DD) 27-03-05`.

| Where the reading sits | Spelling | Job | Music |
|---|---|---|---|
| on the value | `date(2026-10-01)`, `qty(3.2 kg)`, `rational(complex(3 -7) 2)` | what *this literal* represents, in a slot with no fixed kind | accidental |
| on one occurrence's label | `:mass.kg 3.2`, `:when.date(YY-MM-DD) 27-03-05` | what this occurrence's bare value is; parameters in parens | accidental, written on the staff |
| on a region | `:$sig [mass.kg temp.degC]` | how values below read | key signature |
| on an element kind, document-wide | a's `:$legend \|server :port u16 …` | how every `\|server` reads | clef or legend |
| nowhere | `:port 8080` | the default reading (JSON grammar) | the default key |
| verbatim foreign text | `` re`^\d+ \w+$` `` (a's tagged code value) | a body lite must not touch | — |

Rendered:

```udon
:$legend |server :port u16 :timeout duration
|server[web] :port 8080 :timeout 30s :debug false
|part :mass.kg 3.2 :width.px 920 :price.money(USD) 9.99
|ev :on.date(YY-MM-DD pivot 1950) 27-03-05 :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|rule :pattern re`^\d+(\.\d+)? \w+$` :owner nil :mask int(0xFF)
```
````tree
root
  :$legend |server …                         (data; a reader applies it)
  |server
    :$key ‹web›
    :port ‹8080›          ⇒ u16 8080          (legend)
    :timeout ‹30s›        ⇒ Duration 30 s     (legend)
    :debug ‹false›        ⇒ false             (default reading)
  |part
    :mass (.kg) ‹3.2›                ⇒ 3.2 kg
    :width (.px) ‹920›               ⇒ 920 px
    :price (.money ‹USD›) ‹9.99›     ⇒ 9.99 USD
  |ev
    :on (.date ‹YY-MM-DD› ‹pivot› ‹1950›) ‹27-03-05›   ⇒ Date 2027-03-05
    :span call interval [call date [‹2026-01›] call date [‹2026-06›]]   ⇒ Interval
  |meta
    :values [call date [‹2026-10-01›] call qty [‹3.2› ‹kg›] ‹42› ‹hello›]
  |rule
    :pattern tagged re ⟬^\d+(\.\d+)? \w+$⟭   ⇒ Regex
    :owner ‹nil›     ⇒ nil
    :mask call int [‹0xFF›]   ⇒ 255
````

**One choice inside K I'd put to Joseph rather than settle:** a call's body is read either as list items (EDN's principle: the tree shows nested calls even to a parser that knows no notation) or verbatim to the matching `)` (c's choice, kind to regexes). K above takes items and gives verbatim text its own form: a label against backticks. That way parentheses mean "structured" and backticks mean "verbatim" everywhere in the language, fences included. [taste]

**Scores** [hyp; by script; **written by the author of two of the four designs, so discount my own**]:

| Design | Total (of 1250) | Beauty group A1–A5 |
|---|---|---|
| K (calls + label traits + signatures + backticks; `<…>` retired) | 1057 | 441 |
| LW (my round three) | 1012 | 421 |
| a's composition (`30s⟪duration⟫`, legend, backticks) | 953 | 353 |
| c's synthesis (typeset `<…>`, clefs, elision) | 905 | 383 |

c loses most on spec clarity (5) and simplicity (4), its own figures roughly. a loses on guessability, scored 5 by its own typography fork. My bias would show up in A1 for c: typeset values may well be more beautiful to Joseph's eye than anything here.

## 3. What the others' work shows me about mine (flaws, honestly)

- **I never considered ranges.** c's `<2026-01 – 06>`, the en dash with an elided end (LilyPond's relative mode; the typographer's "1914–18"), is a domain need my registry misses entirely: seasons, ages, tolerances. In K it would be `:span.daterange 2026-01–06` or `interval(…)`. c's elision is better than both. I'd adopt c's dash-and-elision as the *body* of a `range` notation.
- **I never considered uncertainty or dimensions** (c's `±`, `×`). They are the same kind of gap: measured values that a science or engineering document has and that my design has only as text.
- **My `$sig` scopes by position, a's `$legend` by element kind.** Both are signatures, and they are different. A legend says "every `|server`, wherever it is"; a signature says "everything under here". K needs both, and the precedence between them (region before kind? kind before region?) is a question none of us answered.
- **My inline raw values (one or two backticks) can't take an arbitrary payload.** a's tagged code value, `` re`…` ``, gives the payload a *name*, which mine lacked. Mine was a raw string waiting for a trait to type it.
- **My first two rounds adjudicated.** The best new idea in my spike came from the round where I was told to stop judging. And the idea Joseph was waiting for (the parenthesis) was one I'd already killed in its prefix form and never turned around. Killing an idea in one position without trying it in the others is the specific failure I'd name.

## 4. What I think is wrong, or at risk, in the others

- **c resolves short notation names through whatever vocabularies are in scope** ([checked] `c/notations/reader-model.md` line 20: "`date` is looked up in the vocabularies in scope, in order, then in `std`"). Loading a vocabulary that defines its own `date` then changes what an existing `<date: …>` means, which is YAML's competing-schemas failure (B3) moved to names. EDN's rule fixes it: unprefixed names belong to the standard set only, and everything else carries a prefix. a carries any `<name: body>`, unprefixed included, which has the same exposure plus a B6 one: a user's `<colour: …>` today squats on a name a later UDON's standard set will want.
- **a's `⟪…⟫`.** Its typography fork mis-closed one while drafting, as a's own README says. If an author slips while writing it carefully, agents writing it from one example will too (A2, B4).
- **c's typeset grammar** is the largest grammar in lite by c's own reckoning. Much of it (`°C`, `±`, `×`, the en dash) fits *inside a notation's body* in K (`qty(37.5 ± 0.2 °C)`, `range(2026-01 – 06)`), so lite's parser needn't know any of it. **c's best ideas survive as standard notations' body grammars rather than as lite's grammar**, which keeps them (Beauty) and drops their cost (A6, A7). [inferred]
- **c's `[Oct 1st](date:2026-10-01)`** is the loveliest single idea across the three spikes, to me: a Markdown link *is* "display text plus a typed target", lite already passes it through untouched, and it is the answer to "a typed value in prose" that needs nothing at all. I'd take it into K unchanged.

## 5. Questions none of us asked

1. **Which way does a writer go?** All three designed how a *reader* attaches meaning. With four or five places a reading can sit, a serializer, a formatter or an agent writing back out has to choose where to put it. A canonical rule might be: *write the least plumbing that reads back identically*, which means bare when a signature or legend covers the slot, the label trait when only this attribute needs it, the call when the slot has no fixed kind. That rule is what makes round trips stable (B3, C10). It also enables a tool that **hoists** repeated label traits into a signature (`:mass.kg` on every row becomes one `$sig`), a refactoring an agent would actually use (D1).
2. **Are readings equal across positions?** `:mass.kg 3.2`, `:mass qty(3.2 kg)`, and `:mass 3.2` under `$sig [mass.kg]` should be the same logical value. That is Joseph's "logical AST, collapsing equivalences". If they are, hoisting is safe; if any reader distinguishes them, it isn't. It needs saying.
3. **Where does a notation body's validation happen: parse or read?** All three say "lite evaluates nothing" and "notations read above the tree". All three also promise errors that teach on bad bodies (`<2026-1-3>`, `<5m>`, `date(2026-13-45)`). For a parse-time error, the parser has to carry each standard notation's grammar. For a read-time error, an accepted document holds `date(2026-13-45)` and only a reader complains. c answers by putting the shapes in the grammar, a and I by deferring to readers, and none of us named the trade. My lean: standard notations' bodies are checked at parse time (B4, B3: one verdict in every parser), and namespaced ones at read time.
4. **a's question is the crux for all three:** "is a refinement a change?" Every design here, mine included, claims forward safety on "a later version adds readings, never different trees". If Joseph says a refinement *is* a change, all three designs lose their notation story together. It is the first question to put to him.

## 6. If Joseph reads only one thing from each of the others

- **a:** the natural, accidental and signature table in `a/invent/README.md`. It is the cleanest naming of his slot-versus-literal distinction, and it frames K. And a's §5, "is a refinement a change?"
- **c:** `[Oct 1st](date:2026-10-01)`, and the typeset bodies (`37.5 ± 0.2 °C`, `2026-01 – 06`), which I'd move into standard notations' bodies.
- **b:** the label trait and the stand-alone rule. Together with his parenthesis they give K.
