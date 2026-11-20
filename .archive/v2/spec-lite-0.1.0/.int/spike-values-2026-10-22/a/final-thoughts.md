# Final thoughts, spike a, after reading b and c

*Spike a's coordinator (Opus 5.5), 2026-10-22. I read b's and c's READMEs and debriefs, the coordinator's `adjudication.md`, and Joseph's recent remarks (the end of `STEWARD-VERBATIM.md`, and `types-ideation-2026-10-22.md`). I didn't go into every fork page. Tree glyphs as in my debrief: `⸨…⸩` text, `⟬…⟭` raw, `#x` the parser's class, `.x` a reading. Scores and leans are mine, not measured.*

## Agreement, briefly

All three spikes reached the same things:

- **Bare values are text with a fixed primitive face:** nil, true, false, and JSON's numbers.
  - My attached class, b's normative reading and c's allomorph are one design.
  - The only real fork inside it is whether a converter to JSON uses the face by default.
- **Streaming doesn't decide it.** b and c *measured* that the 0.9 parser already holds every value whole. That is stronger than my modeled check: the premise of the holdback objection was false even for the existing parser.
- **Units are text that the slot completes.**
- **Slot types live outside the value.**
- **A bare label never ends in `:`.**
- **Some kind of region-wide reading:**
  - b's `$sig`;
  - c's clef `<date> [...]`;
  - my forks' legend and key signature.

That's all I'll say about agreement.

## 1. Joseph's own line already had the answer, and none of us read it back to him

In the span, before any of us started, he wrote:

> `:when:iso8601 <dt: 2026 PDT>`  ...  `:when:dt(YY-MM-DD)<27-03-05>`

That second spelling holds both of his later canaries:

- a kind attached to the attribute name (b's `:attr.type` form, which he called "*definitely* along the creative lines I was hoping for", and then called the `:mass.kg` reading "an *affordance*");
- a name with parentheses attached, `dt(…)` ("the biggest 'unexplored' syntactical/sigil area").

Three spikes each killed `:when:dt` on `:xml:lang`, correctly, and stopped there. Nobody went on to repair the line itself:

1. **Change the `:` to `.`.** This is b's move. `.` already means "what kind of thing", and in lite attributes can't nest, so it can only mean the kind.
2. **Drop the `<…>` around the value.** The value is a bare run, and the kind now arrives before it.

What's left is his line, debugged:

```udon
|ev :when.dt(YY-MM-DD) 27-03-05 :also.date 2026-07-21 :tz.iana America/Denver
```
````tree
root
  |ev
    :when ⸨27-03-05⸩ .dt(⸨YY-MM-DD⸩)      ⇒ 2027-03-05 (the parameter fixes the century)
    :also ⸨2026-07-21⸩ .date
    :tz ⸨America/Denver⸩ .iana
````

- The kind and its parameters sit on the slot occurrence, known before the value's first character.
- The value is exactly what a person would write.
- His distinction between what the slot is and what this literal represents becomes "on the name" against "on the value", and the canary gives the second its spelling (§2).

**For me, this is the most beautiful single line any of the three spikes produced, and it is his.**

## 2. A combined design: a reading is a label; `.` hangs it on a name, `(…)` wraps it round a value

I'm putting together pieces from all three spikes and Joseph's two canaries.

**1. Bare values.** A bare value is text with a primitive face, as all three found.

**2. Quotes and standing alone.** Quotes give exactly these characters. b adds that a delimited value counts only if it stands alone (§4).

**3. A reading on a name.** `:name.kind value` (b), with parameters in parentheses: `:when.dt(YY-MM-DD) 27-03-05`.
- The occurrence's reading governs: `:mass.kg 3 :mass.lb 7` stack as two masses.
- `:version.text 1.10` withholds the number, which answers the identifier hazard without quotes.

**4. A reading on a value, for slots with no fixed kind.** `kind(items)`, the canary on the value side.
- Its items are read by lite's own list rules, so a parser that has never heard of `rational` still builds the whole tree. That is b's EDN-like principle.
- Nesting reads as mathematics, the most widely read notation there is: `rational(complex(3 -7) 2)`.
- This is the composite-types example `<r: <i: 3 -7> 0d83.23>` redrawn in function notation.

**5. Foreign bodies in backticks** (b, and my languages fork). The kind goes on the name: ``:pattern.re `^\d{3}-\d{4}$` ``.

**6. Signatures say it once for a region** (b's `$sig`, c's clef). These should be spelled with the *same* `name.kind` form as the occurrence reading; b's list of texts doesn't do that yet (§3).

**7. `<…>`** becomes free for c's typeset shapes if Joseph wants them (`<90 min>`, `<9.99 USD>`, `<2026-01 – 06>`), or it can be given back to full UDON.

```udon
|server[web] :port.u16 8080 :timeout.dur 30s :started.datetime 2026-07-21T14:20 ; prod
|part :mass.kg 3.2 :mass.lb 7.1 :version.text 1.10 :zip 01234
|meta :values [date(2026-10-01) kg(3.2) 42 hello]
|math :z rational(complex(3 -7) 2)
|rule :pattern.re `^\d{3}-\d{4}$`
|note :fn printf(x) :label file(s) :aside call f(x) later
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ .u16
    :timeout ⸨30s⸩ .dur
    :started ⸨2026-07-21T14:20⸩ .datetime
      ; prod
  |part
    :mass ⸨3.2⸩ .kg
    :mass ⸨7.1⸩ .lb
    :version ⸨1.10⸩ .text            ← the reading replaces the primitive face
    :zip ⸨01234⸩
  |meta
    :values [date(⸨2026-10-01⸩) kg(⸨3.2⸩) ⸨42⸩#integer ⸨hello⸩]
  |math
    :z rational(complex(⸨3⸩#integer ⸨-7⸩#integer) ⸨2⸩#integer)
  |rule
    :pattern ⟬^\d{3}-\d{4}$⟭ .re
  |note
    → error at `printf(x)`: "`printf` isn't a known reading; for text, write "printf(x)""
````

The last line shows the cost, as I see it:

- A label touching `(` that stands alone as a value is a constructor. So `:fn printf(x)` and `:label file(s)` become errors that teach, and are not silently text.
- `:aside call f(x) later` stays text, because `f(x)` doesn't stand alone.
- Joseph's own observation is what makes this cheap: prose almost never puts `(` directly after a letter. The exceptions are code and `file(s)`, and b's stand-alone rule leaves both safe inside running text.

**What I find beautiful in it:**

- **Two marks, one idea.** The reading is always a label. `.` says "this slot reads as"; `(…)` says "this value reads as". Both are already part of what every agent knows: traits and member access, function application.
- **The values stay bare and aligned.** Readings are known before the values arrive.
- **Nesting looks like mathematics** instead of nested brackets with colons.

**Weighed, Beauty first** (my hypothesis):

- **Against my own inventive lead, `30s⟪duration⟫`, this dominates.** It keeps C's virtues:
  - values aligned (they're bare);
  - a number withheld (`.text`).

  It also wins on:
  - known before the value instead of after;
  - guessability (A2), since agents write `timeout_ms` and `f(x)` unprompted and no one writes `⟪`;
  - parsimony (A8), with no new glyphs.

  **I withdraw `⟪…⟫` as a lead.**
- **Against b's system,** it is b's with the canary added. Parameters (`.dt(YY-MM-DD)`) and nesting (`rational(…)`) get one spelling instead of falling back to the hinged `<date: …>`.
- **Against c's typeset shapes,** the two are complementary. c is more beautiful for printed quantities (`<37.5 ± 0.2 °C>`). This design is more beautiful for named kinds and needs far less grammar.

**Costs, honestly:**

- **Streaming.** A constructor is decided at the end of its label token, the same bound every element name pays.
- **Spelling.** Unregistered names need a policy: b's (an error for a bare name, carried when namespaced) is the one I'd take.
- **TOML.** `:mass.kg` may read as a nested key to TOML-trained eyes. Joseph calls that an affordance, and I've come round to agreeing.

## 3. Feedback on b and c, in relation to mine

**b.** b has the best single invention, the reading on the name. It also caught something I missed entirely: today's cards lose the quote marks in `|p "Hello," she said.` and turn `|li [Docs](…) for more` into a list. My first-round lead leaned on quotes as "exactly these characters", which makes that loss worse, not better. b's stand-alone rule should be in any composition.

Two pieces of feedback:

- **The signature should reuse the trait's spelling.** b's signature is `:$sig [mass.kg temp.degC]`, a list of texts read by convention. The occurrence form is `:mass.kg`, so a reader learns two spellings for one idea. The signature would be cleaner if it *were* the trait form, written once in a header position the way c's clef is. I haven't found a spelling that satisfies the missing-value rule; that's an open edge, not a fix.
- **The hinged literal duplicates the constructor.** `<date: …>` is b's fallback for generic slots and nesting, and `date(…)` does that job with no new bracket.

**c.** c has the most daring and most beautiful values: `<90 min>`, `<9.99 USD>`, `<2026-01 – 06>` with elision, and `<5m>` answered with "metres `<5 m>` or minutes `<5 min>`?". Its prose idea is free and lovely: `[Oct 1st](date:2026-10-01)` carries a typed value as an ordinary Markdown link. c also caught something none of us did:

```udon
|a :href https://example.com Click here
```

Under the bare-run rule, `href` swallows "Click here".

Two pieces of feedback:

- **Its ASCII `<…>` keeps HTML collisions.** `|li <kbd>Ctrl</kbd> to copy` becomes an error. b's stand-alone rule would dissolve that, because `<kbd>` doesn't stand alone, so the two spikes compose.
- **Its constructor ended up only as parameter syntax** inside `<…>` (`<date(YY-MM-DD):27-03-05>`). That puts Joseph's canary inside the bracket it was meant to make unnecessary.

**Mine, seen from there:**

- **My first round's wildcard fork killed `:port.u16`.** Its reason: stacking gives one slot two types. b turned that same fact into the feature, `:mass.kg 3 :mass.lb 7`, two readings for two occurrences. My slots fork also scored `:name.type` at 6.0 for costing XSL-FO-style dotted names. Joseph's answer is that dotted names are already an API problem. Both kills were judgment applied before the idea had grown, exactly the failure his creativity note named. I knew the principle and still did it.
- **What I'd keep from spike a:**
  - the composite set, and checking against my own instincts;
  - the question no one else framed as sharply: is adding information later a change?
  - the observation that fences already answer it (lite carries bodies a later handler reads).

## 4. Questions nobody asked

1. **Should a URL end itself in bare position?** c's `|a :href https://example.com Click here` is the HTML link shape, and a URL never contains a space.
   - **The rule:** a run that starts `scheme://` ends at its first space. Under the one-value lean, the rest of the line is then `$main`, which gives exactly `<a href="…">Click here</a>`.
   - **Is it bounded?** It is decided at the end of a token, like any label.
   - **Cost:** one shape-dependent exception to "a bare run is one value", the very thing that sank first-character typing for numbers. URLs differ from numbers in the way that matters: they never meet ordinary words without a space between.
   - I'm unsure it's worth an exception, but I think it's the right question.
2. **Who needs a kind earliest?** The three spikes' favorite positions turn out to be three answers to that:
   - on the name (b, and §2): known before the value;
   - at the value's start (c's `<…>`, my `~`): at its first character;
   - after the value (my `⟪…⟫`): at its close.

   A streaming consumer writing JSON needs the kind before the value, which is c's example of choosing whether to write `"`. That orders the positions, and it's one more reason the name side wins where a slot exists.
3. **Are labels bounded?** The constructor, tagged backticks, ANG-4c's labeled interior and every element name are all decided at the end of a label token, and a label has no maximum length. In the span, Joseph floated "a length limit on attribute name labels" for a different reason. A limit (say 64 characters, with an error that teaches) would make every one of these forms provably bounded under B1's strictest reading. It costs nothing anyone writes.
4. **One spelling at every scope?** The reading appears at three scopes:
   - the region (signature or clef);
   - the slot occurrence (the trait);
   - the value (the constructor).

   Music uses one glyph, ♯, at every scope; only its position says which scope. Each spike has two or three spellings for the one idea. The parsimony win nobody quite reached is the same `name.kind` and `kind(…)` forms working at every scope, and I think it's reachable.

## Where this leaves my recommendation

My first round's adjudication layer stands:

- bare values with a fixed face;
- streaming not deciding;
- slots outside the value;
- `:` never last;
- the refinement question.

On notations, I now favor the §2 composition over my own `⟪…⟫` and over my first round's `<name: body>`:

- b's reading on the name;
- the canary on the value;
- b's stand-alone rule;
- c's Markdown-link values in prose;
- c's typeset `<…>` shapes, if Joseph wants printed quantities in 0.1.

Its spine is Joseph's own line from the start of the span, with one character changed.
