# The inventive pass (spike a, second round, 2026-10-22)

*After Joseph and the coordinator read the first landings: "pretty disappointed with the very low creativity … not a single mention of "what if we used elixir-like sigils, but made more beautiful?" … just trying to figure out what's already been thought about and safely make some safe-sounding conclusions." Fair. My first pass adjudicated the record, scored each idea against stability the moment it appeared, and let "reserve for now" stand as a safe landing.*

*This pass inverts that: invent and render first, say what's beautiful, weigh last, Beauty first. Four inventors worked: me ([coordinator-inventions.md](coordinator-inventions.md)) and three forks, each drawing on a different well:*
- *programming languages ([forks/invent-languages](../forks/invent-languages/README.md));*
- *typography ([forks/invent-typography](../forks/invent-typography/README.md));*
- *notations outside programming ([forks/invent-beyond](../forks/invent-beyond/README.md)).*

*Honest caveat: the forks inherit my context, so where we converge it is one family of minds agreeing, not independent confirmation.*

*Tree glyphs: `⸨…⸩` text, `"…"` string, `⟬…⟭` raw, `#x` the parser's own class, `⟪x⟫` a reading.*

## What the inventing found

**Notations built for reading put the qualifier after the value; notations built for parsers put it before.** Evidence:

- **After the value:** physics (`30 s`), Japanese ruby (furigana: base text, then its reading), interlinear glosses, F#'s units (`5<min>`).
- **Before the value:** Elixir (`~D[…]`), KDL (`(date)…`), EDN (`#inst "…"`).

Programming puts it first so the parser knows early. The first pass's streaming finding (a classification can arrive at a run's close for free) removes that reason for lite, and with it the angle fork's "decides late" objection to every suffix. The first pass used that finding only to defend a bare value's typing; it was really a licence to put the reading where readers expect it.

Three of the four inventors also reached, separately-ish, for **the same mark in two places**:

- on a value, it says what this literal represents;
- on the slot (an attribute name, or once per document), it says what the slot is.

The music forks named the structure, and I think it is the frame Joseph's distinctions were asking for:

| Music | In lite | Says |
|---|---|---|
| **natural** ♮ | quotes `"…"` | exactly these characters; read as nothing else |
| **accidental** | a reading on one value | what *this literal* represents |
| **signature** | the same reading on the slot, or in a legend written once | what *the slot* is |
| (the default key) | the parser's own class: nil, true, false, JSON numbers | what a bare value is when nothing else says |

Most specific wins, as in music.

## The composite lines, in every spelling the pass produced

The same three meanings: a server with a 30-second timeout and a start timestamp; a day-first date with its format; a regex. Read them as plain text, without highlighting:

```udon
; the first pass's lead: a labeled value bracket
|server[web] :port 8080 :timeout <dur: 30s> :started <datetime: 2026-07-21T14:20> ; prod
|ev :on <dt[DD-MM-YY]: 05-03-27> :pattern <re: ^\d{3}-\d{4}$>

; A. the reading mark, Elixir's sigil at home (coordinator)
|server[web] :port 8080 :timeout ~dur 30s :started ~datetime 2026-07-21T14:20 ; prod
|ev :on ~dt.dmy 05-03-27 :pattern ~re/^\d{3}-\d{4}$/

; B. tagged code values: a fence at value size (languages fork)
|server[web] :port 8080 :timeout dur`30s` :started datetime`2026-07-21T14:20` ; prod
|ev :on dt[DD-MM-YY]`05-03-27` :pattern re`^\d{3}-\d{4}$`

; C. the reading after the value, ruby (typography fork)
|server[web] :port 8080 :timeout 30s⟪duration⟫ :started 2026-07-21T14:20⟪datetime⟫ ; prod
|ev :on 05-03-27⟪dt DD-MM-YY⟫ :pattern ^\d{3}-\d{4}$⟪re⟫

; D. the reading after the value, F#'s ASCII form (beyond fork)
|server[web] :port 8080 :timeout 30s<duration> :started 2026-07-21T14:20<datetime> ; prod

; E. the signature: a legend written once, then plain data (beyond fork)
:$legend |server :port u16 :timeout duration :started datetime
|server[web] :port 8080 :timeout 30s :started 2026-07-21T14:20 ; prod
```

The trees agree in substance. The value keeps its spelling, and the reading or name rides with it:

````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ⸨30s⸩ ⟪duration⟫        (A: ~dur ⟬30s⟭   B: dur ⟬30s⟭; same substance, different node shape)
    :started ⸨2026-07-21T14:20⸩ ⟪datetime⟫
      ; prod
  |ev
    :on ⸨05-03-27⸩ ⟪dt ⸨DD-MM-YY⸩⟫
    :pattern ⟬^\d{3}-\d{4}$⟭ ⟪re⟫
````

A regex with a space in it (`^a b$`) can't be a bare run. C needs it quoted (`"^a b$"⟪re⟫`), while A and B carry it raw in their own delimiters. That is the one job the trailing reading does worse.

## What I find beautiful, and why (taste, said plainly)

- **E, the legend, is the most beautiful document.** The data lines carry no plumbing at all, and the domain's model is written once, as an example of itself. It is the purest "domain-forward" the pass found, and it needs no new syntax under today's cards, if hand-written `$` names are allowed.
- **C, `30s⟪duration⟫`, is the most beautiful single value.**
  - The value comes first, so a column of values still lines up for the eye; the alignment Joseph named as part of beauty survives.
  - The reading trails the way a unit does.
  - The glyph means nothing anywhere else.
  - It can withhold a number as well as add one: `1.10⟪version⟫` is never a decimal, which is the first answer to the identifier hazard that isn't "use quotes".
- **B, `` re`^\d+$` ``, is the most beautiful home for foreign text.** Backticks already mean "verbatim" to every agent, and a fence is already "a name, then verbatim". This is the same thing at value size, so regexes and HTML go in with no escapes.
- **A, `~dur 30s`, reads most like speech** ("duration: thirty seconds") and is what an Elixir-trained agent would write first. Next to C it puts the name before the value, which costs the column.
- **D, `30s<duration>`,** is C in ASCII and guessable from F#. Its `<…>` still half-looks like a tag. The beyond fork's guard (a word never takes a reading, so `Vec<u8>` stays text) also stops `ssh<port>`, the alias case.

## A composed design (taste first, then weighed)

**Readings, with backticks for foreign bodies:**

1. A bare value is text with the parser's class (S-JSON), as in the first pass.
2. Quotes are the natural: exactly these characters, never read.
3. A reading follows a value: `value⟪name…⟫`.
   - If it names a built-in class it is checked: `8080⟪integer⟫`; `8O80⟪integer⟫` is an error saying what was meant.
   - Any other name is carried for whatever reads it.
   - It replaces the parser's class: `1.10⟪version⟫`.
4. The same reading on an attribute name applies to all of that occurrence's values: `:days⟪date⟫ [2026-07-21 2026-08-01]`. A legend gives a signature for a whole kind of element, once.
5. A label touching backticks is a foreign body, carried verbatim for that name's handler: `` re`^\d+$` ``, `` html`<b>x</b>` ``.
6. `<…>` retires from values entirely and goes back to full UDON. Its seven jobs are now spread:
   - assert: the reading;
   - self-end: quotes or backticks;
   - carry, name and compose: readings and backticks;
   - nil: bare `nil`;
   - quote: its own question, for references.

### Weighed against CTQ-FACTORS, Beauty first

These are the forks' and my hypotheses, never measured; compare within a fork's scale only.

- **Beauty group:**
  - The typography fork scores the reading at 9 for beauty, 9 for domain-forward and 9 for headroom, but only 5 for being guessed with no examples.
  - The languages fork scores tagged code values at 7.85 for beauty and 7.83 overall, against 6.24 and 6.70 for the first pass's `<date: …>` lead re-scored on the same factors; its author discounts his own margin.
  - The beyond fork puts the reading after the value at +47 for beauty and +45 overall over the first pass's lead, and the legend at +42 and +60.
- **My own read:**
  - The composition beats the first pass on A1, beauty as I sense it.
  - It also wins on A5 (domain-forward), A8 (a small set of special characters: one new glyph pair, `<…>` freed) and B6 (headroom).
  - It loses on A2 (guessing it unprompted): no agent writes `⟪` untaught, while `~` and backticks borrow training.
  - Errors that teach (B4) hold only where a reading names a built-in class; elsewhere lite carries and can't check.
- **What would change my mind:** if Joseph's eye blurs `⟪` with `«` or `<` as it does `‹`, A becomes the accidental instead of C. The typography fork mis-closed one itself while drafting.

## For Joseph

1. **Which of A to E do you find beautiful, and which ugly?** Your eye is the instrument for beauty (A1), and these are the five spellings.
2. **Does "natural, accidental, signature" name your distinctions?**
   - "what the slot is": the signature;
   - "what my literal represents": the accidental;
   - "how it's literally written": the base, which lite keeps;
   - "how it's read": the reading.
3. **May a reading trail the value?** That is, the first pass's streaming finding applied to readings: the base streams, and the reading attaches at the close.

## Where things are

- [coordinator-inventions.md](coordinator-inventions.md): mine.
  - **I1**, the reading mark `~`, with I1b, the same mark on the slot;
  - **I2**, URL schemes as typed values;
  - **I3**, meaning brackets `⟦…⟧`;
  - **I4**, the unit suffix as a class;
  - **I5**, furigana in superscript (play).
- [forks/invent-typography](../forks/invent-typography/README.md):
  - **I1** readings `⟪…⟫`, the lead;
  - **I2** `⟦…⟧`;
  - **I3** Quine corners `⌜…⌝` for mention versus use;
  - dead with reasons: typeset numerals, emoji sigils, an invisible SI binder.
- [forks/invent-languages](../forks/invent-languages/README.md):
  - **N1** tagged code values, the lead;
  - **N2** tagged quotes and named lists;
  - **N3** F#-style trailing types;
  - **N4** the clef;
  - **N5** glyph literals (`∅`);
  - **N6** the allomorph.
- [forks/invent-beyond](../forks/invent-beyond/README.md):
  - **I1** the reading after the value;
  - **I2** a gloss tier with carets;
  - **I3** signature, accidental, natural, and the legend;
  - **I4** small glyphs (`№`, `ℕ`, `∅`).
