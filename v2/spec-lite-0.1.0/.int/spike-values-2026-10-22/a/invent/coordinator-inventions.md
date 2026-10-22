# Inventions, coordinator's own (spike a, second pass)

*Invent first, judge after: each idea is rendered, then I say what I find beautiful, and only at the end weigh it against CTQ-FACTORS with Beauty first. Strange and unfinished on purpose. Tree glyphs as in the debrief: `⸨…⸩` text, `"…"` string, `⟬…⟭` raw, `#x` a classification attached to a text. Written while three invention forks worked separately (`forks/invent-*`), so these aren't shaped by theirs.*

*The first pass's honest flaw: it adjudicated the record. It scored every strange idea against stability the moment it appeared, and a safe landing was always on offer. One finding from it turns out to be an invention licence, not a verdict. F1 says a classification can arrive at a run's close for free. So **a value may declare what it is at its end, or anywhere in it, without costing streaming**, as long as the declaration doesn't move where the run ends. The first pass used F1 only to defend whole-run typing. It also reopens every suffix and in-run idea the angle fork killed as "decides late".*

---

## I1. The reading mark: Elixir's sigils, made at home

Elixir writes `~D[2026-07-21]`, `~r/\d+/i`, `~w(a b c)`: a tilde, a name, a body in delimiters the writer picks to avoid escaping. In lite, `~` would mean **"read this as"**, and the body takes one of two shapes:

- **`~name` then a space:** the body is the bare run that follows, ending where any bare value ends. No closing mark needed; lite already knows where runs end.
- **`~name` then an attached delimiter** (`[…]` `(…)` `{…}` `/…/` `|…|` `"…"` `'…'`): the body is everything to the matching closer, raw. The writer picks the delimiter the body doesn't contain, so regexes and Windows paths need no doubled backslashes. That problem was a cost accepted on the opaque-span card.

Elixir's trailing modifiers become traits (`~re/abc/i`). The standard set's explicit forms are just built-in names, so `<…>` can **retire** from values altogether:

```udon
|server[web] :port 8080 :timeout ~dur 30s :started ~at 2026-07-21T14:20 ; prod
|ev :on ~dt.dmy 05-03-27 :color ~rgb #3221f9 :price ~money 9.99 USD
|check :pattern ~re/^\d{3}-\d{4}$/i :path ~path|C:\Users\jw\notes| :reg ~u64 0xff
|strict :port ~int 8080 :backup nil :html "<b>bold</b>"
|eta :about ~5min :mood ~~meh~~
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ~dur ⟬30s⟭
    :started ~at ⟬2026-07-21T14:20⟭
      ; prod
  |ev
    :on ~dt ⟬05-03-27⟭  .dmy
    :color ~rgb ⟬#3221f9⟭
    :price ~money ⟬9.99 USD⟭
  |check
    :pattern ~re ⟬^\d{3}-\d{4}$⟭  .i
    :path ~path ⟬C:\Users\jw\notes⟭
    :reg ~u64 ⟬0xff⟭
  |strict
    :port ⸨8080⸩ #integer        ← `~int` asserted it: the same tree as bare, the check held
    :backup ⸨nil⸩ #nil
    :html "<b>bold</b>"
  |eta
    :about ⸨~5min⸩               ← `~` before a digit is the ordinary "approximately"
    :mood ⸨~~meh~~⸩              ← `~~` is Markdown's strikethrough, left alone
````

**Prose:** not recognized. `~` in prose stays Markdown's (`~~strike~~`). A typed value in prose is an inline element, `|{time 19:30}`, which already exists.

**What I find beautiful:**

- **One character, and the name comes first.** `~money 9.99 USD` reads aloud as "money: nine ninety-nine US dollars", with the domain foremost (A5). The tilde is light: it marks without shouting, unlike `<…>`, which in a document full of prose and HTML always half-looks like a tag.
- **It reuses what lite already knows.** The body is either a bare run, which lite already knows how to end, or a delimiter the writer chose. The only new grammar is "a name after `~`".
- **It retires a whole bracket from values.** `<…>` goes back to meaning nothing in a value, so `:html "<b>bold</b>"` and every `<placeholder>` agents write stop colliding with anything.
- **An Elixir-trained agent's first guess is right.** `~D[2026-07-21]` is a notation named `D` with body `2026-07-21`, and `~r/…/i` is a regex with trait `i`. That is generative guessability (A2) bought from training data rather than taught.
- **It gives his two layers one mark** (in I1b below).

**Where it's unfinished:**

- **Elixir's bracket body against lite's key.** In Elixir `~dt[05-03-27]` is a body; I've also wanted `[…]` as "which variant". I chose Elixir's meaning, a body, so parameters ride as traits (`~dt.dmy`) or as an Elixir-style trailing modifier (`~dt[05-03-27]dmy`). Unsure which reads better.
- **Two forms of one thing:** `~dur 30s` and `~dur[30s]` are the same value.
- **A word after `~` with nothing following** (`:mood ~meh`) wants a "did you mean" message: an empty notation, or text?

### I1b. The same mark on the slot: his two layers in one gesture

The label lean makes `~` an error inside a bare label, so it is free there. On the attribute name it says what the **slot** is; on the value, what the **literal** represents:

```udon
|job :timeout~dur 5m :length~len 5m       ; the slot says how to read the value
|job :timeout ~dur 5m                     ; the literal says what it is
|job :when~date ~dt.dmy 05-03-27          ; both: the slot wants a date; this literal is day-first
```
````tree
root
  |job
    :timeout ⸨5m⸩  slot~dur
    :length ⸨5m⸩   slot~len
  |job
    :timeout ~dur ⟬5m⟭
  |job
    :when ~dt ⟬05-03-27⟭ .dmy   slot~date
````

**Beautiful:** "what the slot is" vs "what my literal represents", as one mark on either side of the space. Your distinction becomes visible in the spelling.

**Ugly:** one space flips which layer you mean. `:timeout~dur 5m` vs `:timeout ~dur 5m` differ by a space, and that is invisible when skimmed. That's a reason against it for agents reading without highlighting, unless the two always mean compatible things (they mostly do: either way the value is read as a duration).

---

## I2. The scheme colon: URLs are already the world's typed values

`https://x`, `mailto:a@b`, `tel:+1-555-0100`, `urn:isbn:9780141439518`, `data:text/plain,hi`. Every URI is a value that names its own notation in front, `scheme:body`, and agents have seen billions of them. What if lite's classification (the text-plus-class lead) recognized that shape too: a bare run of a label, `:`, then no space, gets the class `scheme(label)`?

```udon
|ev :when date:2026-07-21 :at time:10:12 :phone tel:+1-555-0100 :home https://v2.io
|book :isbn urn:isbn:9780141439518 :lang xml:en
|net :addr localhost:8080 :drive C:\tmp
```
````tree
root
  |ev
    :when ⸨date:2026-07-21⸩ #scheme(date)
    :at ⸨time:10:12⸩ #scheme(time)
    :phone ⸨tel:+1-555-0100⸩ #scheme(tel)
    :home ⸨https://v2.io⸩ #scheme(https)
  |book
    :isbn ⸨urn:isbn:9780141439518⸩ #scheme(urn)
    :lang ⸨xml:en⸩ #scheme(xml)
  |net
    :addr ⸨localhost:8080⸩ #scheme(localhost)   ← a misreading, harmless: no reader knows "localhost"
    :drive ⸨C:\tmp⸩ #scheme(C)                   ← same
````

**Beautiful:**
- No new syntax at all. A URL stops being a special case: it is a value with its notation in front, exactly like a date.
- The value stays text in the tree, so nothing breaks for a reader who ignores the class.
- The first thing an agent writes for a link is already right.

**Ugly:**
- `localhost:8080`, `C:\tmp` and `user:pass` get schemes they don't have. The class is only an attachment and no reader registers `localhost`, so the cost is noise rather than corruption, but it is noise in the normative tree, which the stability factor (B3) dislikes.
- `date:2026-07-21` reads well, but would an agent write it unprompted? I wouldn't. I'd write the date bare.

So I2 is beautiful as a reading of URLs and weaker as a general typing mark.

---

## I3. Meaning brackets: give a bracket's *shape* a job

The first pass killed Unicode brackets because they "add characters without adding a job". The job they could do: in denotational semantics, `⟦e⟧` is literally "the meaning of e". So `⟦…⟧` reads as **"what this stands for"**. Give each family of brackets one meaning, legible from its shape alone:

| Bracket | Its job | Example |
|---|---|---|
| `"…"` `'…'` | exactly these characters (closed) | `"01234"` |
| `⟦name body⟧` | read the body by `name` (a notation) | `⟦date 2026-07-21⟧` |
| `⟨…⟩` | a tuple: values in fixed positions | `⟨40.71 -74.00⟩` |
| `[…]` | a list (as today) | `[a b c]` |
| `@{…}` | a reference (as today) | `@{def:value}` |

```udon
|place :at ⟦geo 40.71 -74.00⟧ :span ⟨2026-01 2026-06⟩ :since ⟦date 2026-07-21⟧
|server[web] :port 8080 :timeout ⟦dur 30s⟧ :started ⟦at 2026-07-21T14:20⟧ ; prod
```
````tree
root
  |place
    :at ⟦geo⟧ ⟬40.71 -74.00⟭
    :span ⟨⸨2026-01⸩ ⸨2026-06⸩⟩
    :since ⟦date⟧ ⟬2026-07-21⟭
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :timeout ⟦dur⟧ ⟬30s⟭
    :started ⟦at⟧ ⟬2026-07-21T14:20⟭
      ; prod
````

**Beautiful:**
- The heavy double bracket looks like nothing in prose, Markdown, HTML or code. Without highlighting, a reader's eye stops on it and knows "a value here means something special".
- It has a real lineage: Strachey's semantic brackets.
- The tuple bracket gives the geo point, the interval, and a color as `⟨50 100 200⟩` a home without inventing a name.
- `<…>` is again free of value duty.

**Ugly:**
- No agent guesses `⟦` unprompted; it has to be taught (A2 low).
- Your eye blurred `‹` and `<`; `⟦` and `[` might blur at small sizes.
- Every tokenizer splits `⟦` into odd pieces. That's a guess, not checked.
- `⟨…⟩` and `<…>` are the pair most likely to be confused in the whole of Unicode.

---

## I4. A suffix that F1 now allows: the unit hangs off the number

Physics puts the unit after the number, with a space or attached: `30 s`, `920 px`, `9.99 USD`. F# puts it in brackets, `30<s>`. A suffix decides late, and the first pass killed suffixes for that. Under F1, deciding at the close is free, so a bare run spelling *number, then a space or nothing, then a unit word* could get the class `quantity(30, s)`. The text is unchanged, so `1984 is a novel` costs nothing: it fails the shape.

```udon
|box :width 920px :margin 1.5 em :opacity 50% :price 9.99 USD :title 3 Musketeers
```
````tree
root
  |box
    :width ⸨920px⸩ #quantity(920 px)
    :margin ⸨1.5 em⸩ #quantity(1.5 em)
    :opacity ⸨50%⸩ #quantity(50 %)
    :price ⸨9.99 USD⸩ #quantity(9.99 USD)
    :title ⸨3 Musketeers⸩ #quantity(3 Musketeers)   ← the class misfires; the text is untouched
````

**Beautiful:** it is how people already write measurements. Nothing marks the value; the unit is its own type.

**Ugly:** the first pass found the same thing. A unit is only half a claim, and `3 Musketeers` shows the class misfiring on titles. As an attachment over text it never corrupts, but it does fire on titles that start with a number. Still, it is the most domain-forward spelling of a quantity I can imagine, and the misfire is visible in the tree rather than silent in the value.

---

## I5. Furigana: the reading written above the word (play)

Japanese typography writes a word's reading in small type above it (ruby text). That is a value with its notation riding over it: "here is the spelling; here is how to read it". The nearest plain-text equivalent is a superscript tag:

```udon
|ev :when 2026-07-21ᵈᵃᵗᵉ :timeout 30sᵈᵘʳ :reg 0xffᵘ⁶⁴
```

**Beautiful:** the spelling stays exactly as a person writes it, and the reading sits on it like an accent.

**Not workable as it stands.** I first wrote that Unicode has no superscript q; checked against UCD 18, that's wrong: U+107A5 MODIFIER LETTER SMALL Q exists, in Latin Extended-F. The real problems are that the modifier letters are scattered across several blocks, added in different Unicode versions, and render unevenly in fonts. Agents also likely split them into odd tokens (a guess, not checked). Kept because its idea, a reading that rides on the spelling without bracketing it, is what I1's `~` and I4's suffix both reach for.

---

## Judging, Beauty first (my hypotheses; nothing measured)

| Idea | A1 my sense of beauty | A2 guessable | A3 cold read | A4 plain-text read | A5 domain-forward | A7/A8 simple, few marks | B2/B6 reserve, headroom | Verdict (taste) |
|---|---|---|---|---|---|---|---|---|
| I1 `~name …` | 9 | 8 (Elixir prior) | 8 | 8 | 9 | 8 (one new mark; `<…>` retired) | 7 (spends `~` in values only) | **the strongest thing I've seen in either pass** |
| I1b `:slot~name` | 7 | 5 | 6 | 4 (space flips the layer) | 8 | 7 | 7 | beautiful symmetry, risky to read |
| I2 scheme colon | 8 for URLs, 5 as typing | 9 for URLs, 4 for dates | 7 | 8 | 7 | 10 (no syntax) | 8 | keep as a URL reading; not the notation mark |
| I3 `⟦name …⟧` + shape jobs | 8 | 3 | 7 | 9 | 8 | 6 (new brackets) | 9 (frees `<…>`, spends no ASCII) | the most striking; teach-only |
| I4 unit suffix class | 7 | 9 | 8 | 8 | 10 | 8 | 6 | the most natural spelling; misfires on titles |
| I5 furigana | 9 | 1 | 6 | 4 | 9 | 2 | 8 | play; its idea feeds I1/I4 |

**What surprised me.** I1 beats the first pass's `<name: body>` on almost every factor I care about.

- **It is lighter.** There is no colon-space head and no closing bracket for run bodies.
- **It is guessable from training.** Elixir's sigils are already in every agent.
- **It ends `<…>`'s identity crisis.** It retires `<…>` from values, where the first pass spent pages deciding which of seven jobs `<…>` should do.
- **It stays close to the first pass's frame.** Under the text-plus-class lead, `~int 8080` asserts exactly what `<8080>` did, and bare stays the default.

What it can't do is be nil in two characters (`<>`). But under the text-plus-class lead, bare `nil` is already nil, so I don't miss it.

**For Joseph, as a question:** does `~` read to you the way it reads to me, as "read this as"? Your eye is the one that matters for A1.
