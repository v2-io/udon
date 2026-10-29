# Lite values: the decisions, laid out for adjudication

*For Joseph. Written 2026-10-28 by the agent of the session after the spikes (Opus 5.5). It is built from the spikes' own files: the three READMEs, the three debriefs, the four `final-thoughts.md`, b's stand-alone page, the two composite sets, a's and c's invention pages, c's round-two synthesis, and your messages in the verbatim record. I did not read every fork page; two auditors are asked to go deeper, and their findings are added at the end. This page replaces `adjudication.md` as the entry point. That file was written before the inventive round, and several of its "dead" verdicts were revived afterwards, so read it only as history.*

*Nothing here is decided. Scores in the spikes are one agent's hypothesis each, on scales that differ by fork; I quote rankings, not totals. Every spike is the same model, so where they agree, that is shared priors as much as confirmation.*

**Tree glyphs on this page** (illustrative only, not a proposal for the transcript): `⸨…⸩` a «text»; `"…"` a «string»; `⟬…⟭` content carried verbatim; `~int` a face attached to a text (see D2); `(.kg)` a reading on an attribute occurrence; `⇒` what a reader would make of it.

---

## The picture in one screen

**Where all three ended up (after their final cross-reading).** One example, in the composition most of the final-thoughts point toward, with the spellings still under dispute marked:

```udon
|server[web] :port 8080 :debug false :zip 01234 :name "8080" :owner nil
|part :mass.kg 3.2 :mass.lb 7.1 :version.text 1.10            ; .kind or (kind)? (D5)
|ev :on date(2026-10-01) :when.date(YY-MM-DD) 27-03-05         ; constructor (D6); reading with parameters (D5)
|rule :pattern re`^\d{3}-\d{4}$`                               ; tagged backticks (D7)
|p "Hello," she said; meet on [Oct 1st](date:2026-10-01).      ; stand-alone rule (D4); a typed value in prose (D11)
|li printf(x) prints x                                         ; not a constructor: doesn't stand alone
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩~int
    :debug ⸨false⸩~bool
    :zip ⸨01234⸩                    ← no face: a leading zero isn't a JSON number
    :name "8080"
    :owner ⸨nil⸩~nil
  |part
    :mass (.kg) ⸨3.2⸩               ⇒ 3.2 kg
    :mass (.lb) ⸨7.1⸩               ⇒ 7.1 lb (two occurrences, two readings)
    :version (.text) ⸨1.10⸩         ⇒ the text 1.10, face withheld
  |ev
    :on date(⸨2026-10-01⸩)          ⇒ a date
    :when (.date(⸨YY-MM-DD⸩)) ⸨27-03-05⸩   ⇒ 2027-03-05
  |rule
    :pattern re ⟬^\d{3}-\d{4}$⟭
  |p
    :$main ⸨"Hello," she said; meet on [Oct 1st](date:2026-10-01).⸩
  |li
    :$main ⸨printf(x) prints x⸩
````

**Converged (all three, final rounds):**

- A bare run stays a text in the tree. A fixed set of spellings gets a standard reading: `nil`, `true`, `false`, and JSON's number grammar. Streaming doesn't decide this (measured; see D3).
- Slot types, aliases ("algebraic names": `port = u16 | standard-port`), unit meanings and coercion live outside the value: in vocabularies, schemas and typed getters. No slot-type syntax in the value.
- Units are text that the slot (or a reading) completes. `5m` is minutes for `:timeout` and metres for `:length`.
- A bare label never *ends* in `:` (today's labels lean allows it, so `:host: localhost` names an attribute `host:`).

**Not converged, and the order to take it in:**

| # | Decision | Depends on |
|---|---|---|
| D1 | Is adding a reading later a change? | nothing; everything else depends on it |
| D2 | The standard reading: in the tree, normative, or a view? Which face does a converter pick? | D1 |
| D3 | B1's wording: may a value's classification arrive at its close? | D2 |
| D4 | A delimited value counts only if it stands alone (reverses a decided example) | — |
| D5 | A reading on a name: `.kind`, `(kind)`, or neither | D1, D4 |
| D6 | Constructor values `name(…)`: their body, unknown names, when bodies are checked | D1, D4, D5 |
| D7 | Verbatim foreign text: backticks | D4 |
| D8 | What `<…>` is, if anything, in lite | D5–D7 |
| D9 | Typeset shapes (`<90 min>`, `<2026-01 – 06>`): lite grammar, notation-body grammar, or neither | D6, D8 |
| D10 | Region-wide readings: `$sig`, legends, clefs | D5 |
| D11 | Prose: typed values in text; bare URLs | D4 |
| D12 | The trailing colon on attribute names | D5 |
| D13 | Smaller items: is a date a leaf or a node; `nan`/`inf`; keys and lists | — |

A CTQ question sits across several of these: c's proposal to make domain-forward (A5) mean "visible in the text itself" (end of page).

---

## D1. Is adding a reading later a change?

**The question.** Lite 0.1 carries something it doesn't interpret: a name on a value (`date(2026-10-01)`, `:mass.kg`), or a fence body. A later UDON reads it and attaches meaning. Did the accepted tree change? Reserve-don't-ignore (B2) is a veto, so the answer decides whether every notation design here is legal.

```udon
|ev :at 2026-07-21 :on date(2026-07-21) :pattern re`\d+`
```
````tree
lite 0.1:   :at ⸨2026-07-21⸩         :on date(⸨2026-07-21⸩)            :pattern re ⟬\d+⟭
later:      :at ⸨2026-07-21⸩ ~date?  :on date(⸨2026-07-21⸩) ⇒ a Date   :pattern re ⟬\d+⟭ ⇒ a Regex
````

**The options.**

- **(a) Never a change** (spike a's first framing): any later version may add faces and readings anywhere.
- **(b) Names may be read later; faces never grow** (spike c's final sentence, which the coordinator put first): *a later version may read what lite marked as named, and may never give a new face to what lite marked as text.* So `:on date(…)` may become a Date later; bare `:at 2026-07-21` stays a text forever (no `~date` face added).
- **(c) Any addition is a change**: lite 0.1 has no notation values at all, the face set is fixed now, and every widening is its own later decision.

**Facts.**
- Lite already answers it once, for fences: a fence named `sh` carries its body for whatever handler later reads `sh` ([[rule:fence-default-handler]]). Under (c) that would be a breach too. (Spike a found this; checked against the card.)
- Your 2026-10-08 downgrade of "same tree" to an aspiration covers forward reading, and "«meta» is free to evolve beyond lite" ([[obj:reserve-dont-ignore]] clause 2). Readings are not meta in any card yet.

**Pros and cons.**
- (b) keeps bare text stable forever (B3 stability, 10), gives notations exactly one path (A6 spec clarity), and matches the fence precedent. Its cost: nothing bare can ever become a date by spelling alone, even if a later UDON wants that; a later typed date must be written with a name. Most of the spikes' work suggests that's a feature (the old line's temporal surprises).
- (a) is maximally open (B6 headroom) but makes "no face" mean "not classified *yet*", which every converter has to treat as unstable.
- (c) is the most conservative and kills every notation design in this page; it is the "reserved for later" landing you rejected as the premise restated.

**Cards touched.** [[obj:reserve-dont-ignore]] (a third clause or a rewording), [[decision:forward-compat-aspiration]], [[def:reserved]].

---

## D2. The standard reading of bare values

**The question.** All three agree a bare run is a text and that `nil`, `true`, `false` and JSON numbers get a standard reading. They differ on *where that reading lives*, and that is your 2026-10-21 lean ("C with the view") being revisited.

```udon
|server :port 8080 :debug false :zip 01234 :version 1.10 :id 1e10 :title 1984 :name "8080"
```

**The options.**

| | Tree | `:debug false` with no schema | From |
|---|---|---|---|
| **(a) attached face** | `⸨8080⸩~int`, `⸨false⸩~bool`; the text is kept, the face is an attachment like a comment or meta (changes no arity) | false | spike a ("text + class", 8.20 vs B 7.48 in its scoring); spike c's "allomorph" (Raku's `IntStr`) |
| **(b) normative default reading** | all texts; the spec says every reader applies the JSON-grammar reading unless told otherwise | false | spike b |
| **(c) the view, default open** (your lean as carded) | all texts; a consumer may apply the view | depends on the consumer | the card today |
| **(d) the face *is* the kind** ("B") | `8080` an integer node, `1984` an integer | false | rejected by a and c on `|h1 1984`, keys |

(a) and (b) give the same answers to every consumer; they differ in whether the tree records the face (a) or the spec prescribes a read (b). Spike c's final word folds them: the face is in the tree, and the *only* open choice is which face a generic converter (to JSON) uses by default: the primitive face (c's lean, JSON's convention) or the text face (c's Cv fork).

**Facts.**
- `:debug false` read as the text `"false"` is truthy in Python, JavaScript, Ruby and Elixir (spike b ran it in four languages). This is what sank (c) in all three spikes: two consumers disagree on `:enabled true`, which is YAML's competing-schemas failure.
- The set is JSON's: no leading zeros, no `0x`, no `_`, no `+`, no `.5`. So `01234` gets no face (the zip keeps its zero), and every classified number copies byte for byte into JSON (spike a).
- **The hazard no spelling rule fixes:** `:version 1.10` and `:id 1e10` get a number face. Remedies offered: quotes, a vocabulary, or withholding the face with a reading (`:version.text 1.10`, `1.10⟪version⟫`).
- **Your gotcha survives in every option:** `:width 7 ;{px}` has an inline comment piece, so no face; `:height 7 ; px` gets `~int` (the framed comment isn't part of the value).
- **Host limits:** converting a huge digit run to a host number is the real resource limit (jackson caps at 1000 digits; CPython at 4300, CVE-2020-10735). It belongs in the host mapping guide under every option (spike a; numbers quoted from the fork, not re-checked by me).

**Pros and cons (CTQ).** (a)/(b) win on B3 stability (one answer everywhere), C1 structured data (JSON round-trips), A2/A3 (what agents expect: `false` is false). (a) additionally makes the face visible in fixtures and gives typed getters something to check against (`int(:port)` on `3x` raises without touching the tree: your strict-getter idea applied to kind). (c) wins only on A7 simplicity of the grammar, and loses B3.

**Nuances.**
- Is prose ever faced? The forks read "never" (`|p 42` under a `|p` heading is a text child; `$main` is an attribute value, so `|h1 1984` *would* get a face under (a)). Unstated in the cards.
- Keys and lists under the same rule: `|step[3]` gets `⸨3⸩~int`; `|step[3]` and `|step[3.0]` are different keys (identity by spelling), which avoids needing a numeric-equality rule.
- nil: [[rule:nil-spelling]] stands as written (`nil` faced, `null` text with a warning). The open question on that card ("is the spelling now `<nil>`?") dissolves under (a)/(b).

**Cards touched.** [[rule:unquoted-run-is-one-value]] (Statement 2 and the view), [[def:reading-option]] (the typed-primitive view leaves it, or becomes the converter default), [[def:typed-value]] (implicit typed values reappear as faces), [[rule:nil-spelling]], [[rule:missing-value]] (their open questions close), the `rule:bare-typing` gap (becomes "the face grammar").

---

## D3. B1's wording

**The question.** CTQ B1 says "every construct's kind is known within a few characters". Under D2(a), a bare run is known at its first character (it's a run), and its face arrives at its close. Does "kind" include the face?

**Facts (measured).** Spike c fed the 0.9 pushdown parser a 1 MB text, a 1 MB digit run, a 1 MB quoted string and a 1 MB prose line: 0 bytes emitted before each terminator. Spike b's fork did the same in 1 KB chunks. Spike a's check: a streaming classifier agrees with the post-hoc view on 400,000 fuzzed runs, emitting from the first character. So the objection that moved you from whole-run typing to "C with the view" (`4938…2412124p`) doesn't separate them: the old parser already held every value to its end, and a classifier needs constant state.

**What still holds back.** Telling `1984` from `1984 is a novel` means reading past the space (across any alignment spaces). Under D2(a) that's fine: the run is text from the first character, and only the face waits.

**The proposed rewording** (spike b's fork):

> **Bounded streaming.** Where a construct ends and what contains it are known within a few characters. A parser never needs to hold an unbounded stretch of input to decide them. A classification of a finished span may be reported after the span.

**Nuance.** The same question recurs for D4 (the stand-alone decision is made at the closer plus one character) and D6 (a constructor is decided at the end of its name). Spike a asks whether labels need a maximum length (say 64) so these are provably bounded; it costs nothing anyone writes.

**Cards touched.** `CTQ-FACTORS.md` B1's footnote.

---

## D4. A delimited value counts only if it stands alone

**The question** (spike b's page 30; adopted by a and c in their final thoughts). Today a value that starts with `"`, `'`, `<` or `[` commits there, and the rest of the line stacks. That loses things writers mean:

```udon
|p "Hello," she said.
|li [Docs](https://x.org) for more
|li <kbd>Ctrl</kbd> to copy
|el :a "x" y
|el :a "x" \ y
```
````tree
TODAY (the cards):
  |p   :$main "Hello,"   :$main ⸨she said.⸩           ← the quote marks are gone
  |li  :$main [⸨Docs⸩]   :$main ⸨(https://x.org) for more⸩   ← the link is gone
  |li  :$main <kbd>      :$main ⸨Ctrl</kbd> to copy⸩
  |el  :a "x"            :$main ⸨y⸩   (your 2026-10-21 lean on the residue)
  |el  :a "x"            :$main ⸨y⸩

STAND-ALONE RULE:
  |p   :$main ⸨"Hello," she said.⸩
  |li  :$main ⸨[Docs](https://x.org) for more⸩
  |li  :$main ⸨<kbd>Ctrl</kbd> to copy⸩
  |el  :a ⸨"x" y⸩
  |el  :a "x"            :$main ⸨y⸩
````

**The rule.** A value is exactly one delimited form followed by the end of the value (a space and a start, a framed ` \ `, or the end of the line), or it is a run, and the delimiters are content.

**Spike c's stronger form, which the coordinator called the most important structural result:** *every sameline value is a run, and a closed form standing alone, or a run spelling a primitive, gives it a face.* One rule for extent (the run), plus a short list of things that give a run a face. It absorbs D2, D4 and D6: `"x"` alone gets a string face, `8080` an int face, `date(…)` a constructor face, and `"x" y` gets none.

**Facts.**
- No re-scan is needed (b): the delimited form is scanned by its own rules, so `:a "a :b c" d` keeps ` :b` inert and gives `⸨"a :b c" d⸩`.
- Escapes stay compatible with the proposed value-line escape set (`\"` is a quote either way).
- `|li '90s music, mostly` is still an unclosed-string error (no closer on the line); b keeps that, with a "did you mean `\'90s`?".
- Streaming: decided at the closer plus one character, on the same line.

**Pros and cons.** b's scoring: guessability and cold comprehension 5→8, XML/HTML 5→9, Markdown 4→9, simplicity 8→7 (one more check). The cost: a writer who meant a string then a stacked text on one line writes ` \ ` between them, the spelling already ruled for stacking (`|el asdf \ ghijk`).

**What it reverses.** [[rule:leftover-values]] is decided, and its own example is `|q "hello," she said` as two `$main` values. That example inverts, and its Statement narrows to values separated by ` \ ` or a start. Also: your 2026-10-21 lean on the residue after a self-ending value; [[rule:adjacent-quoted-strings]] (`"x""y"` becomes one run, not two strings with a warning: worth its own look); [[def:main]] and [[def:prose]] examples.

---

## D5. A reading on an attribute name

**The question.** Where a slot needs to say what its value is, in the text, how is that spelled? This is your "what the slot is" made visible per occurrence, and the one idea all three final-thoughts adopted (b invented it; you called it "*definitely* along the creative lines" and "mass, then kg inside it" an affordance).

```udon
|part :mass.kg 3.2 :mass.lb 7.1 :width.px 920 :version.text 1.10
|ev :on.date 2026-10-01 :when.date(YY-MM-DD) 27-03-05 :span.daterange 2026-01–06
|sample :mass(kg) 3.2 :temp(°C) 21.5 :born(date YY-MM-DD) 27-03-05
```

**The options.**
- **(a) `.kind`**, with parameters in parentheses (`.date(YY-MM-DD)`). Spikes a and b. Mirrors `|user.admin` (a trait says what kind of thing).
- **(b) `(kind)`**, the scientific column header, "Mass (kg)". Spike c's taste and the coordinator's lean ("one spelling, `name(…)`, at every scope").
- **(c) `:` (`:when:dt`).** Dead in all three: `:xml:lang` and `:xlink:href` read silently wrong.
- **(d) `<kind>` after the name (`:when<date>`).** c's `slot` design; free headroom today because it's an error.
- **(e) None:** readings live only in vocabularies. Kept by all as a layer, rejected as the whole answer because an agent reading the file sees no unit (c's §6).

**Facts.**
- The labels lean (a coordinator's lean of 2026-10-20, not decided) makes `.` an error in a bare *attribute* name and `(`/`)` errors in every bare label. So both spellings widen an error and change no accepted tree.
- In lite, attributes can't nest (reserved), so a `.` after an attribute name can only mean its kind, never a sub-key.
- The reading belongs to the *occurrence*, not the slot: `:mass.kg 3 :mass.lb 7` stack as two masses. This is how b answered a's first-round objection that `:port.u16 8080 :port 443` gives one slot two types.
- Your note: dots in attribute names are already a pain on the API side (`.Attributes["dispatch.status.arrival"]`).

**A finding of mine, which none of the spikes raised: `(…)` swaps roles between names and values.** With constructors (D6) also in play, the coordinator's "one spelling at every scope" puts these side by side:

```udon
|samples :$sig [mass(kg) temp(°C)]
|meta :values [qty(3.2 kg) date(2026-10-01) 42]
```
In the first list, the part outside the parentheses is the *slot* and the part inside is the *kind*. In the second, the part outside is the *kind* and the part inside is the *body*. Same shape, opposite roles, and inside a list only the enclosing attribute says which. Under (a) the shapes differ visibly: `[mass.kg temp.degC]` against `[qty(3.2 kg) date(2026-10-01)]`. (a)'s own residue: if constructor names could ever be dotted (`geo.point(…)`), they'd collide with dotted readings; EDN's `/` for namespaces (`acme/sku(…)`; `/` is already allowed inside labels by the labels lean) avoids it.

**A nuance against (a):** unit symbols don't fit label characters. `°`, `%`, `²`, `µ`, `Ω` aren't identifier characters, so `:temp.°C` and `:fill.%` aren't bare labels; b fell back to `degC` and `pct`, which c criticized (you took typing cost off the table, and `°C` is what everyone reads). Under (b), `:temp(°C)` holds anything inside the parentheses. Under (a), the parameter form covers it: `:temp.unit(°C)`, or the reading's own character set could be wider than a label's. This is the strongest argument for (b) on the page.

**Pros and cons.** Both put the kind before the value (good for a streaming JSON writer deciding whether to write `"`), both keep values bare and aligned (A5, visual beauty), both are guessable from habits agents already have (`timeout_ms`, `size_px`; "Mass (kg)"). (a) reads like UDON's own trait; to TOML-trained eyes it may read as a nested key (you called that an affordance). (b) reads like science and spreadsheets and holds parameters with spaces.

**Cards touched.** [[def:attribute-name]], [[def:label]] (characters), [[def:trait]] (if `.` on attributes is "the same mark"), the `rule:repeated-attributes` gap (readings per occurrence).

---

## D6. Constructor values: `name(…)`

**The question.** Your canary. A value that is a label immediately followed by `(`, standing alone, is a notation value. What is its body, what happens to unknown names, and when is the body checked?

```udon
|ev :on date(2026-10-01) :lasts duration(3mo 5d) :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|math :z rational(complex(3 -7) 2)
|li printf(x) prints x
|li Upload the file(s) here
|x :call printf(x)
```
````tree
root
  |ev
    :on date(⸨2026-10-01⸩)                       ⇒ Date
    :lasts duration(⸨3mo⸩ ⸨5d⸩)                  ⇒ 3 months 5 days
    :span interval(date(⸨2026-01⸩) date(⸨2026-06⸩))
  |meta
    :values [date(⸨2026-10-01⸩) qty(⸨3.2⸩ ⸨kg⸩) ⸨42⸩~int ⸨hello⸩]
  |math
    :z rational(complex(⸨3⸩~int ⸨-7⸩~int) ⸨2⸩~int)
  |li  :$main ⸨printf(x) prints x⸩               ← not alone: text
  |li  :$main ⸨Upload the file(s) here⸩
  |x   ✗ error: `printf` is not a lite notation; for the text, write "printf(x)"
````

**Facts.** Your observation: prose almost never puts `(` directly after a letter or digit. The exceptions are code (`printf(x)`, `f(x)`) and the optional plural (`file(s)`), and the stand-alone rule (D4) leaves both safe in running text. The one remaining collision is a whole value that is exactly a call to an unknown name: an error that teaches, not a silent misread. Spike c found `date(…)` first and then demoted it to parameter syntax inside `<…>` because of `printf(x)`; b's stand-alone rule removed that objection.

**Decision points inside D6.**

1. **The body: list items or verbatim?**
   - *Items* (b, a): read by lite's own list rules, so a parser that knows no notation still builds the whole tree and shows nesting (EDN's principle). A regex with spaces or unbalanced parentheses can't be a body; it goes in backticks (D7). Then parentheses mean "structured" and backticks mean "verbatim" everywhere, fences included.
   - *Verbatim to the matching `)`* (c): kind to regexes (`re(\d+(\.\d+)?)` needs no escapes, since matched parentheses nest); nesting is then the notation's business.
2. **Unknown names.** b and a: an unprefixed name not in the standard set is an error with "did you mean"; a namespaced name (`acme/sku(…)`) is carried for whatever reads it (EDN's rule). b warns against c's resolution of short names through vocabularies in scope: loading a vocabulary that defines its own `date` changes what existing documents mean, which is YAML's competing-schemas failure moved to names; and a user's unprefixed `colour(…)` today squats on a name a later standard set may want (B6).
3. **When is a body checked** (b's question none answered): `date(2026-13-45)` an error at parse time (the parser carries each standard notation's grammar; one verdict in every parser, B3, B4) or only when read (the parser stays small; an accepted document can hold a bad date). b's lean: standard notations checked at parse time, namespaced ones at read time.
4. **Are readings equal across positions?** `:mass.kg 3.2`, `:mass qty(3.2 kg)`, and `:mass 3.2` under a signature saying kg: the same logical value? If yes, a tool can hoist repeated readings into a signature safely; if any reader distinguishes them, it can't (b).

**Pros and cons.** Guessability is the highest of any notation found (every agent writes `rgb(…)`, `url(…)` without thinking: c scored it 9); no new bracket; nesting reads as mathematics. Costs: a label of unbounded length before the `(` (D3's label-length question); every standard name in the set becomes, in effect, reserved in value position.

**Cards touched.** New cards (constructor values; the standard notation set), [[rule:unquoted-run-is-one-value]], [[rule:value-line-escapes]] (`(` after a label in value position), [[def:value]].

---

## D7. Verbatim foreign text: backticks

```udon
|cmd :run `rm -rf ./build` :match ``a`b``
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me`
|li `npm install` first
```
````tree
root
  |cmd
    :run ⟬rm -rf ./build⟭
    :match ⟬a`b⟭
  |rule
    :pattern re ⟬^\d{3}-\d{4}$⟭
    :path ⟬C:\Users\me⟭
  |li
    :$main ⸨`npm install` first⸩                ← not alone: Markdown code span stays text
````

**The idea.** One or two backticks, standing alone as a value, are an inline verbatim value; three or more is the fence that already exists (b). A label touching the backticks names the body's notation, a fence at value size (a's languages fork). Backticks already mean "verbatim" to every agent.

**Facts.** Today `:path 'C:\Users\me'` already works (single quotes keep backslashes). What backticks add is a body with *no* escapes at all and a name for its notation. The fence opener is a text terminator ([[rule:text-value-end]]: a space followed by three or more backticks), so one-or-two-backtick values must not trip it.

**Pros and cons.** Kills the backslash-doubling cost [[rule:opaque-span-escapes]] accepted for `<re:\\d+>` (C8, B4). Another delimiter (A8 parsimony). Spike a notes the trailing-reading spelling (`⟪…⟫`) can't carry a regex with a space; backticks can.

**Cards touched.** [[rule:text-value-end]], [[rule:value-line-escapes]] (`` \` ``), [[rule:fence-opens-with-backticks]] (the size boundary), [[rule:unclosed-delimiter-is-error]].

---

## D8. What `<…>` is, if anything

You reopened it wholesale ("still very cheap to change"). The spikes moved through four answers:

| | What `<…>` is | Example | Status in the final round |
|---|---|---|---|
| **(a) Retired from values** | nothing in values; back to full UDON whole; `<` free for HTML and Markdown in text | `|li <kbd>Ctrl</kbd> to copy` is plain text | a's final, b's final (K), the coordinator's lean |
| **(b) Closed when unlabeled, open when labeled** | `<8080>` asserts a standard value or errors; `<>` is nil; `<date: 2026-10-01>` carries a notation | `<920px>` → "did you mean `920px` bare, or `<px: 920>`?" | a's first round (ANG-4c, 1250 of 1660); superseded by a itself |
| **(c) The typeset value bracket** | the value written as the domain prints it, read by shape; `<scheme:body>` names a notation; a bodiless `<date>` is a clef | `<90 min>`, `<9.99 USD>`, `<2026-01 – 06>`, `<css:920px>`, `<https://example.com>` | c's round-two design; c's final keeps it beside constructors |
| **(d) Carried raw** (the card today) | any interior carried as text | | dead in all three: fails the B2 veto (can't refuse `<920px>`) and can't hold a number once bare runs are text |

**Facts and consequences.**
- Under (a), your `<>`-is-nil lean needs a new home or simply goes (bare `nil` carries nil). `@{<…>}` ("reference kept, not resolved") needs its own spelling: c proposes `@<people/jw>` (kept) beside `@{x}` (resolved); b proposes `ref(people/jw)` / `<ref: …>`.
- Under (c), ASCII `<` collides with HTML and autolinks only where a tag is the *whole* value (thanks to D4); `|li <https://example.com>` becomes a URI value, which is what CommonMark means by it. c's alternative bracket `⟨…⟩` (Unicode's informal aliases for U+27E8/9 are "bra" and "ket", checked by c) frees `<` entirely but no agent writes it unprompted.
- [[rule:opaque-span-raw-text]], [[rule:opaque-span-escapes]], [[rule:newline-in-opaque-span-is-error]], [[rule:matched-pairs-need-no-escape]] and [[def:opaque-span]] all group `<…>` with `@{…}` and `;{…}`. Under (a), the group shrinks to the two embeds, and [[def:typed-value]]'s explicit/implicit split mostly dissolves (so do several of the definitions' open questions).

**Pros and cons.** (a): parsimony (A8), headroom (B6), HTML and Markdown in text (C2, C3), spec clarity; but every notation value then needs a name (`date(2026-10-01)` rather than `<2026-10-01>`). (c): the most beautiful values on the page by c's judgment and arguably the most domain-forward; the largest grammar in lite (c's own scores: clarity ~6, simplicity ~4).

---

## D9. Typeset shapes: where printed quantities live

**The question.** c's typeset values (`<37.5 ± 0.2 °C>`, `<1920 × 1080 px>`, `<2026-01 – 06>` with the end elided, money with ISO codes, the symbol rule: letter units spaced, symbol units may glue, so `<5m>` asks "metres `<5 m>` or minutes `<5 min>`?") are the most daring values the spikes produced. Where should they live?

- **(a) In lite's grammar**, recognized by shape (c's lean: "carry it all"; if it must shrink, cut size pairs and `× 10ⁿ` first, never dates, quantities, durations or dash ranges).
- **(b) In the body grammar of standard notations** (b's and the coordinator's lean): `qty(37.5 ± 0.2 °C)`, `range(2026-01 – 06)`. Lite's parser needn't know any of it; the beauty is kept and the grammar cost moves to the notation.
- **(c) Not in 0.1.**

**Facts.** c checked UCUM's codes (`Cel`, `GiBy`, no number-unit syntax) and RFC 9557's `[Zone]` suffix; it reports NIST's SI spacing rules without re-checking them. No other data notation carries uncertainty (`±`).

**Nuance.** Elision (`<2026-01 – 06>`, `[<date> 2026-01-01 07-04 12-25]`) reads beautifully, but a reader without the notation sees `07-04` as text.

---

## D10. Region-wide readings: signature, legend, clef

```udon
|samples :$sig [mass.kg temp.degC taken.datetime]
  |sample :mass 3.2 :temp 21.5 :taken 2026-10-01T14:30Z
  |sample :mass 2.9 :temp 22.0 :mass.lb 6.6          ; an occurrence's own reading overrides (the accidental)

:$legend |server :port u16 :timeout duration         ; every |server, wherever it is
|server[web] :port 8080 :timeout 30s
```

- **`$sig`** (b): a container says once how its descendants' values read; scoped by position.
- **Legend** (a): says how every element of a kind reads, document-wide; scoped by element name.
- **Clef** (c): a bodiless `<date>` before values in a list or body. c conceded it to b's form in its final thoughts.

**Facts and open edges.** Precedence between a signature and a legend is unanswered (b). Hand-written `$` names must be allowed (`$` first is in the labels lean). c's caution: *action at a distance*. An agent editing row 400 of a signed table must look up row 1 to know what `3.2` means, which is YAML-anchor-shaped and costs agent readability (A4) and agent tooling (D1); c suggests a signature is for tables you'd print with a header row, not for scoping a whole document. b's matching idea: a formatter that *hoists* repeated `:mass.kg` into one `$sig` (needs D6.4's "readings are equal across positions").

---

## D11. Prose and text

```udon
|p Meet on [Oct 1st](date:2026-10-01); the review is due |{time Oct 15 :datetime date(2026-10-15)}.
|a :href https://example.com Click here
```

- **A typed value in prose as a Markdown link** (c): `[Oct 1st](date:2026-10-01)` already pairs human words with a machine value, and lite passes it through untouched. b called it the loveliest single idea of the three spikes. It costs lite nothing; it's a convention for readers.
- **An inline element** (`|{time …}`) works today under every option.
- **The bare URL hazard** (c found it): under the bare-run lean, `href` above is ⸨https://example.com Click here⸩, silently. a asks whether a run starting `scheme://` should end at its first space, which gives exactly `<a href="…">Click here</a>`. It's one shape-dependent exception to "a bare run is one value", the kind of exception that sank first-character typing for numbers; URLs differ in never meeting a word without a space. Open.

---

## D12. The trailing colon on attribute names

Your light lean (2026-10-22): `:attr: hi` means `:attr hi`, the colon ornamental, "or even making it compulsory", pending this discussion.

- All three: **a bare label never ends in `:`** (today's labels lean lets it, so `:host:` is an attribute named `host:`). No XML name ends in `:`, so it costs nothing.
- Then: optional ornament (your lean; c gives it your meaning now), none, or compulsory (pruned by a and c: changes every attribute on every card, matches no common notation).
- If ornament: the `$main` colon warning's fix becomes one inserted character (`|server :host: localhost`).
- b coupled the colon to its hinged literal `<date: …>`; under D8(a) that coupling goes.
- c's mark fork leaned to reserving it first (reserving then accepting breaks nothing; accepting then reversing breaks documents).

---

## D13. Smaller items

- **Is a date a leaf of the tree or a node?** (a) `date(2026-07-21)` / `:on.date 2026-07-21` (a leaf) vs `|{date 2026-07-21}` (a node, no new grammar: c's `elem` design, b's runner-up). Elements as notation values have one silent trap: `|{dtae …}` is just an element; and `:timeout |dur 30s :port 8080` gives `port` to the `dur` element ([[rule:element-after-attribute-with-no-value]]).
- **`nan`, `inf`, `-inf`**: c's core fork and c lean to allowing them somewhere explicit (`<nan>` in c's bracket); JSON has none.
- **Keys and lists**: under D2 they get faces by the same rule (`|step[3]`, `:tags [1 2]`).
- **`-0xFF`, `+1`, `.5`**: text under the JSON grammar.

---

## A CTQ question, raised by spike c and endorsed by the coordinator

Agents, the principal readers, read the source text, not a tree through a vocabulary-aware library. A unit declared in a vocabulary is invisible to them; `:mass.kg` isn't. The coordinator had written A5 domain-forward as "conventions … carry what would otherwise be declared on each value", which leans toward invisible meaning. Proposed rewording of A5's note: *the domain's model is visible in the text itself, in the domain's own words; conventions and vocabularies check what the text says rather than replace it.* Self-description (A10) stays low, since the target was always declaration plumbing, not the domain's words.

---

## What was measured, and what was only judged

- **Measured:** the 0.9 parser's holdback (c, b's fork); a constant-state classifier against a regex on 200,000 random spellings (c's B fork, re-run by c) and against the view on 400,000 runs (a); `"false"` truthy in four languages (b).
- **Checked against sources by the spikes:** RFC 8259, Namespaces in XML, RFC 9557, YAML 1.2.2 (b); UCUM codes, Unicode's bra/ket aliases (c).
- **Judged only:** every CTQ score; every claim about what agents would guess (`:timeout.ms`, `date(…)`, the en dash, `⟨…⟩`). These are the cheapest things to measure, and none has been.

---

## Audits

*(Added after the two audits; see below.)*

## My recommendations

*(Added after the audits.)*

---

*Sources: `.int/spike-values-2026-10-22/{a,b,c}/` and the four final-thoughts; `.int/types-ideation-2026-10-22.md`; `.int/STEWARD-VERBATIM.md` from "OK, I'm convinced" to the end; `CTQ-FACTORS.md`; the cards named. Session of 2026-10-28.*
