# Fork P: the literal-side notation (D4), explored as play

*Fork P of spike b, 2026-10-22. **Evidence note (amended after Joseph's relayed correction):** every claim on this page about how often a spelling occurs in text (parenthetical starts, `<placeholder>`s, hashtags before quotes, `<kbd>` at a value start) is **my own writing instinct**, as an agent that writes such text, not a count from the corpus, which was written by fiat and is no evidence of how anyone writes. Precedents (Python, Rust, Scala, Elixir, KDL, REBOL, EDN, the old line) appear only as evidence under a named CTQ factor, mostly A2's priors; none is a reason in itself. Labels: **[checked]** = verified against a file, a tool or a spec; **[memory]** = from training, not re-checked today; **[inferred]** = my reasoning; **[taste]** = my preference. Scores are my hypotheses, not measurements (there is no panel budget). CTQ-FACTORS is the yardstick; precedent appears only as evidence about a factor.*

**Tree notation used on this page (illustrative only, not a proposal):** `‹…›` a text; `"…"` a string; `8080:int`, `0.75:float`, `true`, `nil` the primitives; `{dt "2026-01-10"}` a literal carried as tag plus raw payload with no meaning attached; `ERROR` no tree.

## 1. Finding first: "the literal side" is four jobs, not one

Every design for a literal mark serves some subset of four jobs. Most of the disagreement between spellings comes down to which jobs each one serves.

| Job | What it does | Today's spelling | Needed how often |
|---|---|---|---|
| **J1** force a primitive kind | "this `8080` is a number", `<nil>`, `<>` | `<8080>`, `<nil>`, `<>` | **Depends entirely on D1** (below) |
| **J2** name a notation | "this is a date written ISO-style" | `<dt:2026-01-10>` (proposed) | wherever no slot type says it |
| **J3** construct a composite | rational of complexes, a point, an interval | `<r: <i: 3 -7> 0d83.23>` (`design/composite-types.md`) | rare; Joseph's July direction |
| **J4** keep something as itself (Lisp quote) | a reference kept as a reference | `@{<people/jw>}` | rare; Joseph: "already a little unprincipled" |

**[inferred] How often J1 is needed depends on D1, not on D4.**
- If a bare run is always text and no view applies by default (C, view off), then every number, boolean and nil in JSON-like data needs J1. E1 below shows six marks in one line.
- If default resolution applies (C with the view on by default, or a normative default resolution), J1 almost never fires. Its job shrinks to the rare override, and to `<>`.
- With the view on, the footguns come back in the view: `:version 1.0` reads as 1.0. The only way to avoid them is the view off, which costs J1 marks everywhere.

So D4 can't be settled before D1. **The literal-side mark carries the cost of whichever D1 answer is chosen.**

**[inferred] J4 is a different kind of thing.** "Don't resolve this" is Lisp's quote. It fits the parent frame's observation 3: delimited means the literal decides. Wherever J4 ends up, it probably shouldn't share a bracket with J1–J3, which say "this is a value of kind K"; J4 says "this is not to be evaluated". The `@{<…>}` use feels unprincipled because a value bracket is being borrowed for a quote job. I'm noting this for the synthesis and not pushing it further here.

## 2. The branches

Each branch renders the core of the composite set (E1, E2, E4, E6, E8, E10, E11, E12) with **bare treated as text** (the cards' current lean), so that J1's cost shows. §4 then shows what changes when default resolution applies.

### P0. No literal side at all

```udon
|server :name web :port 8080 :debug true :ratio 0.75 :owner nil :tags [a b]
|release :version "1.0" :zip "01234" :sha "1e10a3f"
|event :on 2026-01-10 :lasts 3m5d
|li <kbd>Ctrl</kbd> to copy
|z :c ???                                   ; E11 has no spelling
```

- **Only works with default resolution** (D1 normative or view on): `8080` and `true` resolve, and `"1.0"` must be quoted to stay text. With bare as plain text and no view, lite simply has no numbers, which fails C1 (weight 10). So P0 is really a D1 answer that makes D4 empty.
- E4: dates are text until a slot type reads them. E11 can't be written. E12 needs another mechanism. `<>` disappears; nil is the bare `nil` resolved.
- Collisions: none from D4 (`<` at value start becomes ordinary text). `"Hello," she said` still splits, because `"` is still a delimiter (that's D2, not D4).
- **Alive**, conditional on D1. It is the highest-scoring branch on simplicity and headroom, and the lowest on C4.

### P1. `<…>` with a label prefix and a strict interior (the current direction)

```udon
|server :name web :port <8080> :debug <true> :ratio <0.75> :owner <> :tags [a b]
|release :version 1.0 :zip 01234 :sha 1e10a3f
|event :on <dt:2026-01-10> :at <dt:2026-01-10T14:30-07:00> :lasts <dur:3m5d>
|li <kbd>Ctrl</kbd> to copy
|li <https://example.org> has more
|z :c <r: <i: 3 -7> 0d83.23>
```

- **Interior grammar** (Joseph's 2026-10-21 C plus the label idea), deciding at `<` and then at one more character:
  - `<>` nil;
  - `<` + digit/sign/`.` a number, an error on mismatch;
  - `<"` or `<'` a string;
  - `<` + letter a keyword (`nil`, `true`, `false`) or a label up to `:`. Deciding between the two is keyword-vs-identifier at the token's end (see B1 below).
- **E6, `<kbd>`:** a strict interior makes it an **error** (`kbd` is neither a keyword nor `label:`). The miss is caught, not silent. Under the card's raw-carry reading (P1′, below) it would be silent.
- **E6, Markdown autolink [checked: CommonMark autolinks are `<` + scheme of 2–32 characters + `:` + … + `>`; memory of the spec, consistent with the rule as I know it]:** `<https://example.org>` has *exactly* the label-prefix shape, with label `https` and payload `//example.org`. It reads as a literal in the `https` notation, which is silent if `https` is ever a known notation and an error otherwise. This is either a collision or a harmony: a URI *is* a typed literal whose notation is its scheme. **[taste]** If `<…>` stays, I'd make the coincidence deliberate: an unknown `<scheme:…>` is carried as a literal tagged with its scheme, and the autolink reads correctly as a URI value.
- **Placeholder convention:** my instinct as a writer of example configs is to write `:token <your-api-token>`; I'd expect other agents to do the same. A strict interior makes that an error, which is good for the stated reason, and it teaches.
- **B1:** passes. `<` commits at the first character. Keyword-vs-label needs the label's end, but nothing outside the token is held.
- **B6 headroom:** spends value-initial `<` and an interior grammar; full UDON's `<…>` would be the same thing, so it spends little beyond what it uses.
- **Alive.** It serves all four jobs (J4 awkwardly) and costs on C2/C3 and cold guessability.

### P1′. `<…>` carrying its interior raw (the current card)

`|li <kbd>Ctrl</kbd> to copy` gives `$main {raw "kbd"}`, `$main ‹Ctrl</kbd> to copy›`: a **silent** misparse of inline HTML at the start of a value. `:token <your-api-token>` silently becomes a typed literal. **Dies:** under A2/A3 silent misses weigh more, and a strict interior fixes both at no cost to anything else.

### P2. KDL-style prefix `(type)value`

```udon
|server :port (u16)8080 :ratio (f64)0.75
|event :on (date)"2026-01-10" :lasts (dur)3m5d
|z :c (r)[(i)[3 -7] 0d83.23]
|li (Optional) set the flag first
|li (c)2026 Acme Corp
```

- KDL v2 annotates any value, a string included **[checked: card `def-typed-value` working notes, KDL spec §3.8, by an earlier agent on 2026-10-09; any-value from memory]**. It cleanly separates the notation from the payload's delimiters.
- **Prose collision:** a parenthetical start is something I write often at the start of a text (`(see below)`, `(a)`, `(Optional)`); my instinct, not a count. A guard of "no space between `)` and the value" saves most of them, but not `(c)2026`, which reads as the type `c` on 2026, silently.
- **B6:** CTQ's own footnote names this exact case: "A branch that makes `( … )` its type mark has spent a bracket pair that dynamics, references or directives might have wanted."
- **Dies:** prose collision plus a headroom cost, which the CTQ itself predicts.

### P3. Suffix marks (`8080u16`, `920px`, Rust's `0xffu64`)

- **As a forcing mark, it dies.** A suffix can't commit a value's kind from its spelling without making bare runs typed by spelling. `1e10a3f`, `1234e56` and `512MB` would each be typed or not by their tail. This is B, with B's footguns (E2), not a mark. Joseph's stated inclination also points the other way: prefixes decide "sooner and piecewise".
- **As a notation for units, it survives, but on the other side of the ledger.** `920px`, `3.2kg` and `512MB` read best bare. A slot type `length` whose notation accepts number+unit reads them, and the literal side needn't be involved. **[inferred] Units belong to bare spellings plus slot notations (D7), not to the literal mark.** Every literal-side unit spelling I tried reads worse than the bare form: `<920px>`, `<q:920 px>`, `~q[920 px]`, `q"920 px"`.

### P4. Elixir-style sigils `~d[…]`

```udon
|server :port ~n[8080] :debug ~b[true] :owner ~[] :tags [a b]
|event :on ~D[2026-01-10] :lasts ~P[3m5d]
|z :c ~r[~i[3 -7] 0d83.23]
|li ~5 minutes to go
```

- A2 evidence: the shape is in code models' priors from Elixir (`~D[2019-10-31]`, `~r/…/`, `~w[…]`; multi-letter uppercase sigils since about 1.15 **[memory]**); which letter means what is not, and as a writer I would not guess `~P` for a duration.
- **Collisions:** `~5 minutes`: `~` + digit isn't a sigil, so it's text. Markdown `~~strike~~` is `~~`, not `~` + letter, so it's text. `~D[` at the start of a value in prose: I can't think of a real case. E6 is untouched (`<` is free).
- **B1:** a fixed three-character head (`~`, letter, opener) with single-letter sigils; with multi-letter sigils the label is bounded, as in P1.
- **The weak spot is J1:** `~n[8080]` and `~b[true]` are ugly and unguessable. Sigils suit J2/J3 and nothing else. Cold comprehension of `~D`, `~P` is poor unless the names are spelled out (`~date[…]`), at which point it's P1 with different brackets.
- **Alive but weak:** a plausible J2/J3 notation if J1 is handled elsewhere.

### P5. Unicode angle brackets `⟨…⟩` (U+27E8/U+27E9)

```udon
|server :name web :port ⟨8080⟩ :debug ⟨true⟩ :ratio ⟨0.75⟩ :owner ⟨⟩ :tags [a b]
|event :on ⟨dt 2026-01-10⟩ :lasts ⟨dur 3m5d⟩
|li <kbd>Ctrl</kbd> to copy                 ; ordinary text now
|li <https://example.org> has more          ; ordinary text: Markdown keeps its autolink
|z :c ⟨r ⟨i 3 -7⟩ 0d83.23⟩
```

- **[checked, UCD 18]** U+27E8/U+27E9 MATHEMATICAL LEFT/RIGHT ANGLE BRACKET: East Asian Width Narrow (single-width), no decomposition, so NFC leaves them alone.
- **[checked] It has three lookalike families:**
  - U+3008/U+3009 CJK angle brackets (Wide);
  - U+2329/U+232A, deprecated, which **canonically decompose to U+3008/U+3009**, so NFC turns one lookalike into another;
  - U+2039/U+203A `‹ ›` single guillemets, which the store's tree notation already uses for «text» in 77 files.
  - A parser would accept only U+27E8 and warn "did you mean ⟨…⟩?" on the others.
  - **The `‹…›` clash matters:** a transcript printing `‹8080›` (a text) beside source holding `⟨8080⟩` (a typed literal) is the conflation of UDON form and tree primitive that Joseph has forbidden. One of the two would have to move.
- **What it buys:** the REBOL homage keeps its shape, and value-initial ASCII `<` goes back to being text. E6's `<kbd>`, Markdown autolinks, placeholders and `<5 ms` are all untouched. The label can be separated by a space (`⟨dt 2026-01-10⟩`), because nothing else uses the bracket; to me that reads more like a domain phrase than `dt:` does (A1, A5; taste).
- **What it costs:**
  - A2: a cold agent won't produce `⟨`. With exposure it will copy it, but it may write `<8080>`, which is now silently *text*. A default-on warning on a value-initial ASCII `<…>` whose interior is a valid typed interior ("did you mean `⟨8080⟩`?") turns that silent miss into a caught one.
  - Human typing (A12, weight 2).
  - Tokenization: I can't check how BPE vocabularies split U+27E8; possibly two or three tokens. **[unverified guess]**
- **Alive.** The best E6 behaviour of any branch that keeps a bracket.

### P6. REBOL-style lexical richness (kinds from bare spellings)

REBOL types `$100` money, `10:30` time, `1-Jan-2000` date, `jw@x.com` email, `http://x` URL, `%file` file and `<tag>` tag, all from bare spelling **[memory]**.

- In lite this is D3 maximalism with no marks: `:ratio 3:2` becomes a time (3:02), `:id 1-2-3` a date, `:price $5` money.
- Every one is E2's footgun again: as a reader I would not expect `:ratio 3:2` to be a time, so the misses are silent (A2, A3), and the trees vary with spelling details a writer doesn't attend to (B3). Host equivalence fails (money, email and file have no near-lossless host type; C1, D2). The old line's temporal behaviour (`old-numeric-typing.md` §5: `9:30` a Time, `1-01` a Date) illustrates the same mechanism; it isn't the reason.
- **Dies as a default** on stability (B3) and on the misses being silent (A2, A3).
- **Survives as a vocabulary:** each REBOL form is a fine *slot notation* (`email`, `url`, `money`) that a slot type names (D5).

### P7. EDN-style tag before a value: `#inst "…"`

- `|li #urgent "fix the build" today` reads as a tagged string, silently. A hashtag followed by a quote is something I'd plausibly write in a task list (my instinct).
- `#` at the start of a value also collides with colour literals (E10 `#ff0000`, which needs no space) and is where Markdown headings start.
- **Dies:** a silent prose collision in a common shape.

### P8. Attached tags: a label directly before a delimiter (`dt"…"`, and `r[…]` for constructors)

```udon
|server :name web :port 8080 :debug true :owner nil :tags [a b]   ; J1 via default resolution (D1)
|release :version "1.0" :zip "01234"
|event :on dt"2026-01-10" :at dt"2026-01-10T14:30 America/Denver" :lasts dur"3m5d"
|li <kbd>Ctrl</kbd> to copy                    ; ordinary text
|z :c r[i[3 -7] 0d83.23]
|g :at point[3 4] :tint rgb[255 0 0]
```

- **Rule:** a label written directly against a delimited value (`"…"`, `'…'`, `[…]`) names that value's notation. The tree carries `{tag, payload}` raw, as `<…>` is carried today.
- **A2 evidence (guessability), not a reason in itself:**
  - [memory] the label-against-a-quote shape is in agents' training priors from many languages: Python `r"…"`, `b"…"`, `f"…"`; Rust `b"…"`; C++ `u8"…"`; JavaScript tagged templates; and, closest in meaning, Scala's custom interpolators (`json"…"`).
  - My own instinct: having seen one `dt"…"` I would write `date"2026-01-10"` or `dur"3m5d"` for unseen kinds without being told. That's the A2 profile Joseph described ("having seen a few idiomatic and normal things with just a few rarer notational things, it correctly or nearly correctly guesses a lot more").
- **Parsimony:** spends no new bracket pair, only "label directly against a delimiter at the start of a value". Payloads with spaces are fine (`dt"2026-01-10 14:30"`), read by the string rules already carded (A6, A7: no new interior grammar).
- **J1 isn't served,** so it needs D1's default resolution, or `<>`/`nil` from elsewhere. J3 is served by tagged lists. J4 isn't served.
- **[inferred] The B1 catch, a real differentiator:** `:a dt"x" more` and `:a dt"x more` diverge at the `"`. Whether `dt` is a tag decides where the value ends (`more` becomes `$main` versus part of the run), so that's a decision about *shape*, made a label's length into the value. Labels are unbounded, so strictly this needs a **bound on tag length** (CommonMark bounds URI schemes at 32 for a similar reason) to pass B1. P1, P4 and P5 commit at their first character and need no such bound. It's a cliff in the grammar, of the same kind as Joseph's own length-limit idea for suffix colons, and a cost under A7.
- **Visual collision:** in a value, `point[3 4]` looks like an element head with a key (`|point[3 4]`). A cold reader may take it for one (A3 cost). Tagged strings don't have this problem.
- **Collisions in text:** `|li 12" monitor`. If labels can't begin with a digit, it's text; if they can, it's an unclosed-string error (caught). `|p He said"hi"` doesn't start a value.
- **Alive, and the strongest** if D1 gives default resolution.

### P9. A hybrid: attached tags for notations plus `⟨⟩` (or `<>`) only for J1/nil

Only worth having if D1 keeps bare runs as text with the view off, so that J1 is common. Then `⟨8080⟩` and `⟨⟩` force kinds, and `dt"…"` names notations. Two mechanisms for two jobs: parsimony and spec clarity pay for it, and agents have to learn which job takes which mark. **[taste]** If J1 is common I'd rather have one bracket (P5) doing J1–J3 than two mechanisms. **Kept as a fallback, not scored.**

### Smaller ideas, recorded and dropped

- **Tagged bare with a colon (`dt:2026-01-10`):** collides with `xml:lang`-style labels, times (`10:30`) and URIs. Dead on arrival.
- **A type as an attribute trait (`:port.int 8080`):** reuses lite's existing `.trait` mark rather than `:`, so it avoids the `xml:lang` collision that `:port:u16` has. But it's slot-side and per occurrence, which is plumbing (A5), so it belongs to D5. Passed to the parent.
- **Guillemets `«…»`:** quotation marks in French, German and Russian prose. Dead.
- **`⟦…⟧`:** used for stacked lists in the store's tree notation (45 files: a fact about the transcript's glyphs, not about how anyone writes). It conflates with the transcript, so dead.

## 3. Scores (hypotheses)

Only the factors D4 moves are scored; the others are equal across branches. The scale is 0–10; confidence is L/M/H. The weighted mean is over the scored factors only (total weight 114) and doesn't count the rest of CTQ. P0 and P8 assume D1 gives default resolution; P1, P4 and P5 assume bare is text (view off), so that J1's cost is counted.

| Factor (weight) | P0 none | P1 `<…>` strict | P4 sigil | P5 `⟨…⟩` | P8 attached tag |
|---|---|---|---|---|---|
| A1 agent-subjective beauty (9) | 8 M | 7 L | 6 L | 8 L | 7 L |
| A2 generative guessability (10) | 8 M | 6 M | 6 L | 5 M | 8 M |
| A3 cold comprehension (10) | 6 M | 7 M | 6 M | 7 L | 8 M |
| A4 agentic readability (10) | 8 M | 8 M | 8 M | 7 L | 8 M |
| A6 spec clarity (9) | 9 M | 7 M | 7 M | 7 M | 8 M |
| A7 syntactic simplicity (8) | 9 H | 6 M | 7 M | 6 M | 8 M |
| A8 parsimony (8) | 10 H | 8 M | 7 M | 7 M | 9 M |
| A9 conciseness (6) | 9 H | 8 M | 8 M | 8 M | 7 M |
| A12 human writability (2) | 10 H | 9 H | 8 H | 3 H | 9 H |
| B4 errors that teach (8) | 6 L | 8 M | 8 M | 7 M | 8 M |
| B6 headroom (7) | 10 M | 6 M | 6 L | 8 M | 8 M |
| C2 XML/HTML (10) | 8 M | 5 M | 9 M | 9 M | 8 M |
| C3 Markdown stays Markdown (9) | 8 M | 5 M | 8 M | 9 M | 8 M |
| C4 types, notations, units (8) | 3 M | 8 M | 7 M | 8 M | 7 M |
| **Weighted mean** | **7.8** | **6.8** | **7.2** | **7.3** | **7.9** |
| B1 veto | pass | pass | pass | pass | pass **only with a tag-length bound** |

**Basis for the scores that decide the ranking:**
- **C2 and C3 for P1:** value-initial `<` collides with inline HTML, Markdown autolinks and placeholders. A strict interior makes those errors rather than silent, which is why the score isn't lower.
- **A2 for P5:** no prior exists for `⟨`, and the ASCII substitute is silent unless warned.
- **A2 and A3 for P8:** string-prefix priors across many languages; a tag sitting against its payload reads as "a date written as a string".
- **C4 for P0:** E4 and E11 can't be written in a document without a schema.

**How sure am I?** The spread between the top three (7.3–7.9) is inside my error bars. The ranking I'd defend is coarser:
- P1′, P2, P6 and P7 die, each for a reason that doesn't depend on the scores (a silent prose collision, or a cost the CTQ itself names).
- **Under default resolution:** P8 or P0, because J1 has gone away.
- **Under bare-is-text with the view off:** P5 or P1, because J1 is everywhere and a first-character commitment is cheapest for it.

## 4. What this hands the synthesis

1. **D4 is downstream of D1.** Decide whether default resolution applies (on by default or normative), and the literal-side question narrows to two branches: {P0, P8} if it does, {P5, P1} if it doesn't.
2. **Value-initial ASCII `<` is a hazard in a prose-carrying notation.** It hits inline HTML (`<kbd>`), Markdown autolinks (`<https://…>`, which coincide exactly with the label-prefix shape) and the `<placeholder>` convention. A strict interior turns the silent cases into errors (P1). Moving the bracket (P5) or dropping it (P8, P0) removes them.
3. **Units read best bare,** with a slot notation (D7). No literal-side unit spelling I tried beats `920px`.
4. **Attached tags (`dt"…"`) are the best-precedented spelling for J2** in agents' priors, at the price of a tag-length bound for B1.
5. **J4 (keep as itself) is Lisp's quote,** a different job from J1–J3. Borrowing `<…>` for it inside `@{…}` is why that use feels unprincipled.
6. **`⟨⟩` and the transcript's `‹›` can't both stay** if P5 is chosen.
7. **Collisions that sit in D2 rather than D4,** noted in passing: `"Hello," she said` splits under every branch, because `"` delimits at the start of a value, and `|li [Docs](https://x) for more` starts with a list `[Docs]`. Both are Markdown/prose-at-value-start hazards of the same family as `<kbd>`, and they belong to whoever takes D2 or the `$main` question.
