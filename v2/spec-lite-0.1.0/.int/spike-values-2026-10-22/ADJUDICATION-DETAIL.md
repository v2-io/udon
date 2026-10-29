# Lite values: the full detail behind ADJUDICATION-GUIDE.md

*For Joseph. Written 2026-10-28 by the agent of the session after the spikes (Opus 5.5), then revised the same day twice: with the results of an eight-agent trial of the options folded into each decision (summary under "What the agent trial showed"; detail in [`../trial-values-2026-10-28/RESULTS.md`](../trial-values-2026-10-28/RESULTS.md)), and before that with two independent audits folded in: [`audit-opus.md`](audit-opus.md) (Opus 5.5) and [`audit-fable.md`](audit-fable.md) (Fable 5.1, who read every fork page and re-ran the three scripted checks; all reproduce). Their findings are woven into each decision below rather than appended; their files hold the detail and paths. My recommendations are at the end, after everything else, and are marked as mine.*

*This page replaces `adjudication.md` as the entry point; that file predates the inventive round, and several of its "dead" verdicts were later revived.*

**What I read whole:** the three READMEs and debriefs, the four `final-thoughts.md`, b's stand-alone page (`b/30`), both composite sets, a's and c's invention pages, c's round-two synthesis, the labels lean, and your messages in the verbatim record. Not most fork pages; the auditors covered those (Fable all of them). **"Converged" on this page means converged in the final-thoughts,** which are cross-read syntheses by one model; underneath, several of those points split (marked where so).

**What decides it.** Each decision ends with the CTQ factors that pull on it, with their weights, so you can see what's being traded. Scores from the spikes are one agent's hypothesis each, on scales that differ by fork; I quote rankings, not totals.

**Tree glyphs on this page** (illustrative only, not a proposal for the transcript): `⸨…⸩` a «text»; `"…"` a «string»; `⟬…⟭` content carried verbatim; `#int` a standard reading or face (see D2; I avoid `~` here because `~` is one of the source spellings in D6b); `(.kg)` a reading on an attribute occurrence; `⇒` what a reader would make of it.

---

## The picture in one screen

**Without a vocabulary** (the schema-less case: what a lone file says by itself), in the composition most of the final-thoughts point toward. Contested pieces are marked.

```udon
|server[web] :port 8080 :debug false :zip 01234 :name "8080" :owner nil
|part :mass.kg 3.2 :mass.lb 7.1 :version.text 1.10            ; .kind vs (kind) (D5: the trial chose (kind), 5 to 0); does .text withhold a face? (D2)
|ev :on date(2026-10-01) :when.date(YY-MM-DD pivot 1950) 27-03-05   ; the century needs a rule (D6)
|rule :pattern re`^\d{3}-\d{4}$`                               ; tagged backticks (D7)
|p "Hello," she said; meet on [Oct 1st](date:2026-10-01).      ; stand-alone rule (D4)
|li printf(x) prints x                                         ; text: doesn't stand alone
|h3 date(format)                                               ; a heading that is a constructor? (D6)
```

**With a vocabulary** (a document that says, by file name or reader configuration, what `server`, `part` and `ev` are). Every spike said this is where values go bare:

```udon
|server[web] :port 8080 :debug false :zip 01234 :owner nil
|part :mass 3.2 :version 1.10
|ev :on 2026-10-01 :when 27-03-05
```

The CTQ question at the end (does domain-forward mean "visible in the text"?) is the choice between those two pictures as the *normal* case.

**What eight agents actually wrote, untaught, for the same content** (the trial; see "What the agent trial showed" below):

```udon
|sample :mass 3.2 kg :temperature 21.5 °C
|server :host localhost :port 8080 :debug false :retries 3 :owner null
|part :version "1.10" :zip "01234"
|a :href https://example.com \ Click here
```
Unit in the value, `null` for nil (every agent without the spec), defensive quotes, and the link as BASICS showed it. Nobody wrote a reading on a name or a notation value.

**Converged in the final rounds:**

- A bare run stays a text in the tree, and a fixed set gets a standard reading: `nil`, `true`, `false`, JSON's number grammar. (Underneath: c's core fork wanted hex and `_` too; keys split; see D2.)
- Slot types, aliases ("algebraic names"), unit meanings and coercion live outside the value: vocabularies, schemas, typed getters.
- Units are text that the slot (or a reading) completes: `5m` is minutes for `:timeout`, metres for `:length`.
- A bare label never *ends* in `:`.

**Not converged, in dependency order:**

| # | Decision | Depends on |
|---|---|---|
| D1 | What lite's tree is for a carried notation; may faces ever grow? | — |
| D2 | The standard reading: in the tree, normative, a view, or off by default? Which set? Keys? | D1 |
| D3 | B1's wording, and the streaming question that is actually open | D2 |
| D4 | A delimited value counts only if it stands alone; is a quoted value a string or a text? | — |
| D5 | A reading on an attribute name: `.kind`, `(kind)`, or none | D1, D6 |
| D6 | Notation values: `name(…)`, the sigil `~name`, or elements | D1, D4 |
| D7 | Verbatim foreign text: backticks | D4, D6 |
| D8 | What `<…>` is, if anything | D4–D7 |
| D9 | Typeset shapes (`37.5 ± 0.2 °C`): lite grammar, notation body grammar, or not now | D6, D8 |
| D10 | Region-wide readings, precedence, and which way a writer goes | D5 |
| D11 | Prose: typed values in text; bare URLs | D4 |
| D12 | The trailing colon | D5 |
| D13 | Smaller items | — |

Across all of them: **the order of commitment** (just below), and a CTQ wording question (the end).

---

## Before the decisions: commitment runs one way

From c's mark fork (`c/branches/mark/branch.md`, "What they leave out is reversibility"), raised by the Opus audit. Going from *an error* to *an accepted spelling* changes no accepted tree. Going back breaks documents. So a designed form can ship in 0.1 as an error that teaches ("lite doesn't accept notation values yet; this would read as …") and be switched on later at no cost, while a form shipped as accepted can never be withdrawn.

This is not "reserved for later", which you rejected as the premise restated. Every design on this page is designed. The question this adds is only *which designed pieces 0.1 accepts*, and it applies to D5, D7, D9, D10 and D12. It is also the principled form of the coordinator's "minimal lite 0.1" (`coordinator-final-thoughts.md` §4).

---

## D1. What lite's tree is for a carried notation, and whether faces may grow

**The question as first posed:** lite 0.1 carries something it doesn't interpret (a name on a value, `date(2026-10-01)`; a reading on a name, `:mass.kg`). A later UDON reads it. Did the accepted tree change? Reserve-don't-ignore (B2) is a veto.

**The sharper form both audits found in the files** (a's angle fork, c's `raw` design): it is a *definition*, not a law. If lite's tree holds `date(…)` as a node of its own kind (named, carried, unread: a's "raw, never a string", c's `unread{name, body}`, b's `unresolved(name, items)`), then a later reader adds meaning to a node that already said "a reader will interpret this", and the raw tree is unchanged by construction. Two cards already read that way (both audits checked):

- [[obj:reserve-dont-ignore]] clause 1 reserves spellings "that a future full version gives meaning to, **and that lite does not define**". A notation value lite *defines*, as a carried named node, is outside the clause. c's `raw`: "B2: pass, by definition rather than reservation".
- [[decision:forward-compat-aspiration]]: your 2026-10-08 words, "Opaque spans for example now will be their own branch in the AST later, among other things."

The load-bearing condition (a's angle fork): **the tree must mark the body as unread, never as text or string.** If a constructor's body were held as a plain «text», a later reading *would* change its kind. That constrains D6.1 and D7.

**The Opus audit's further split, by who owns a name (its inference, not a spike's):** under the EDN policy b proposed and a adopted, an *unprefixed* name belongs to UDON's standard set, and lite refuses one it hasn't defined yet. That is B2 working as designed (an error becomes accepted later). A *namespaced* name (`acme/sku(…)`) belongs to its owner, never to UDON, like an element name or a fence language: lite never interprets `|invoice`, and no later UDON will. Carrying it isn't "retaining the bytes for a later UDON".

**Your own ground for B2, which weighs against carrying anything loosely** ([[obj:reserve-dont-ignore]] Grounds, 2026-10-01): "older 0.9 and 0.10 specs … deferred decisions about special syntaxes … but retained the bytes. That ambiguity caused a lot of confusion and made the language evolve a lot slower for a season-- hence the very deliberate call right now in udon-lite to go further and disallow them completely."

**What's left of D1 after that:**

- **(a) Faces may grow:** a later UDON may give bare `2026-07-21` a date face.
- **(b) Faces are closed for good** (c's sentence, which the coordinator put first): *a later version may read what lite marked as named, and may never give a new face to what lite marked as text.*
- **And a second, smaller question the Opus audit found:** may body checks tighten later? If standard bodies are checked only when read in 0.1, adding parse-time checks later turns accepted documents (`date(2026-13-45)`) into errors, which is a change. So D6.3 is decided here.

**The fence precedent, stated accurately** (Fable): lite already carries a named body unread ([[rule:fence-body-not-scanned]]); what a fence *handler* is remains open on [[rule:fence-default-handler]]. So fences share D1's question; they support the definitional reading but don't settle it.

**Interactions.** D1(b) removes one of a's two reasons for D2(a) over D2(d) ("the class can grow; the kind can't"); under (b) that difference rests on identity by spelling alone.

**What decides it:** B2 reserve (veto), B3 stability (10), B6 headroom (7), A6 spec clarity (9).

**Cards touched:** [[obj:reserve-dont-ignore]] (clause 1 wording, or a note that carried notation nodes are defined), [[decision:forward-compat-aspiration]], [[def:reserved]], a new definition for the carried notation node.

---

## D2. The standard reading of bare values

**The question.** All three agree a bare run is a text and that `nil`, `true`, `false` and JSON numbers get a standard reading. They differ on where that reading lives; this revisits your 2026-10-21 lean ("C with the view").

```udon
|server :port 8080 :debug false :zip 01234 :version 1.10 :id 1e10 :title 1984 :name "8080"
|step[3]
```

**The options.**

| | Tree | `:debug false`, no schema | From |
|---|---|---|---|
| **(a) attached face** | `⸨8080⸩ #int`, `⸨false⸩ #bool`; the text kept, the face an attachment that changes no arity | false | a ("text + class", 8.20 vs B 7.48 in its scoring); c's allomorph (Raku's `IntStr`) |
| **(b) normative reading** | all texts; the spec defines one reading every consumer applies unless told otherwise; fixtures show the raw tree | false | b |
| **(c) the view, default open** (your lean as carded) | all texts; a consumer may apply the view | depends on the consumer | the card today |
| **(c′) strings unless asked** | all texts; a generic converter emits strings; classification on request (`int(:port)`) | `"false"` | c's Cv fork, which *survived* c's round one |
| **(d) the face is the kind** ("B") | `8080` an integer node | false | nobody chose it; nobody killed it (a ranked it second and alive; c's B fork made it survive) |

**Facts.**
- `"false"` is truthy in Python, JavaScript, Ruby and Elixir: b ran it. That's b's argument. a killed the open view on stability generally (two consumers disagree on `:enabled true`, YAML's competing-schemas failure). c's final narrowed its own open bit to "which face does a converter pick" without using the boolean argument.
- **(c′) at its strongest** (c's own scores, `c/branches/Cv/branch.md`): spec clarity 9, simplicity 9, stability 9 (one tree; differing readings live outside it), parse speed 9 (bare runs never classified), XML 8 ("XML attribute values are all strings, typed by the schema: Cv is XML's model"), round-trip 9, and no `1.10` or `01234` trap anywhere. Its costs: structured data (C1) 5 and guessability 5. Shown here because you reverted to C on 10-21 for reasons of your own.
- **The set.** JSON's: no leading zeros, no `0x`, no `_`, no `+`, no `.5`. `01234` keeps its zero (no face); every classified number copies byte for byte into JSON. **But c's core fork wanted `0x`/`0o`/`0b`, `_` between digits and `+`** by a different test (no *lossy* silent miss, `c/branches/core/kinds-and-test.md`), and **your own words, 2026-07-14** (`history.jsonl` L16173, checked by the Opus audit): "0x 0o 0d 0b *definitely* help as literal qualifiers, as does '_' agnostic digit separators, as does scientific notation shorthands-- all work to allow the udon reflect the literal value without the agent/user needing to translate it from a natural representation". Under the JSON set those are texts, and where they go instead is open (b's K: `int(0xFF)`; a: a slot).
- **The hazard: `:version 1.10`, `:id 1e10`.** Remedies in the files: quotes; a vocabulary; withholding with a reading (`:version.text`); **no float faces at all** (c's core fork, "alive, Joseph's call": integers, booleans and nil get faces, floats don't); **no exponent faces** (a's dp3; also fixes `12e4567`, valid JSON that overflows to infinity); a default-off lint for decimals ending in `0` (a's dp3).
- **Your gotcha survives every option:** `:width 7 ;{px}` has an inline comment piece, so no reading; `:height 7 ; px` reads 7.
- **Host limits:** converting a huge digit run is the real resource limit (jackson's `maxNumberLength`, CPython's 4300-digit cap: fetched by a's research fork). Host mapping guide, under every option.

**Nuances the audits surfaced.**
- **`.text` and (a) collide** (Opus). Under (a) every parser attaches the face, so withholding it (`:version.text 1.10`) needs the parser to interpret the reading `text`: lite would be evaluating readings. a says the reading replaces the face; c keeps both. Under (b) the question doesn't arise. That counts for (b).
- **Fixtures:** (a) shows the face in fixtures; b chose deliberately to show only the raw tree ("one tree per fixture"). A transcript choice, available either way.
- **Keys are not converged.** b: "A key gets **no** default reading. A key is an identity, compared by spelling … a typed key is written as a literal" (`b/50` §4). c's Cv: keys hold texts. Only a faces keys. `|step[3]` vs `|step[3.0]`: different keys under every option (identity by spelling).
- **Is prose ever read?** `$main` is an attribute value, so `|h1 1984` gets a reading under (a)/(b). Prose children don't. Unstated in the cards.
- **nil:** [[rule:nil-spelling]] stands as written under (a)/(b); its open "is the spelling now `<nil>`?" dissolves. **In the trial, every agent working from the basics sheet wrote `:owner null`** (the spec-primed ones wrote `nil` only because the cards say so), so the card's default-on warning on `null` will fire often; whether to accept `null` as a second spelling is the alternative.
- **Does `$main` get the reading?** A trial agent's first question for you (Sonnet fresh): `|td 1.10`, `|li true`, `|h2 2026`, `|p nil`. HTML-ish content is mostly text, and the numeric reading is where it rubs.
- **Two trial agents (both Fables, separately) asked for ISO dates in the standard reading** by the same argument as numbers ("every context was most beautiful bare"), and Fable primed for number-with-unit tokens too (`3.2kg`, `220°C`, `90min`). Under D1(b) that has to be decided for 0.1 or never. Against it: dates are where the old line's typing surprises lived.

**What decides it:** B3 stability (10), C1 structured data (10), A2 guessability (10), A3 cold comprehension (10) for (a)/(b); A6 clarity (9), A7 simplicity (8), B5 parse speed (9), C2 XML (10) for (c′).

**Cards touched:** [[rule:unquoted-run-is-one-value]] (Statement 2, the view, **and its Grounds**, which say "a streaming parser knows every value's kind from its first character": still true of a bare run as text, but it was given as the reason against whole-run typing, and D3 shows the classification costs no holdback either way, so the reason needs restating), [[def:reading-option]], [[def:typed-value]], [[rule:nil-spelling]], [[rule:missing-value]], [[rule:key-holds-a-value]], the `rule:bare-typing` gap.

---

## D3. B1's wording, and the streaming question that is actually open

**Facts (measured; Fable re-ran the scripts).**
- A constant-state classifier agrees with a regex on 200,000 random spellings, fed whole and chunked (c's B fork), and with the post-hoc view on 400,000 runs, emitting text from the first character (a). So classifying a run needs no holdback of its own: text can stream from its first character, and the classification arrives at the run's close.
- So `4938…2412124p` doesn't separate whole-run typing from "C with the view": the classification is the same work at the same moment.
- (Context only, not about lite: the spikes also ran the old 0.9 parser, to test the premise that typing makes a parser hold values back. It held every value to its end whether typed or not, so the premise didn't describe existing practice either. Lite has no parser yet; nothing here is a property of one.)

**The streaming question that is actually open, and independent of typing** (b's fork S; Fable): a sameline value is bounded by its line, so a lite parser either caps line length (with an error that names the limit) or emits long text content in pieces as it reads. That is the real answer to your "forced to buffer essentially unlimited amount … DoS" concern, and it is a design requirement for lite's parser whatever D2 decides.

**The one word B1 turns on** (c's B fork): whole-run typing is bounded in *memory* (bytes held) but not in *characters scanned before the kind is known*, because `1984` vs `1984 is a novel` needs a look past any number of alignment spaces. c's allomorph was designed to pass B1 *as currently worded*: the kind is "text" at the first character, and the face is an attachment at the close. So under D2(a)/(b) rewording is optional; it's needed only if "kind" includes the classification.

**b's proposed rewording, whole** (four sentences; the guide's first version dropped the last):

> **Bounded streaming.** Where a construct ends and what contains it are known within a few characters. A parser never needs to hold an unbounded stretch of input to decide them. A classification of a finished span may be reported after the span. Whether content itself is emitted in fragments or held to its line end is a wire choice, measured as the longest holdback (today: one line).

**Same question elsewhere:** the stand-alone decision (D4) is made at the closer plus one character; a constructor (D6) at the end of its name. c's `std` design already spelled a 64-character cap on notation names (and caps on fractions and zone names); a asked whether all labels should have one.

**What decides it:** B1 (veto), B5 parse speed (9), B3 (10).

**Cards touched:** `CTQ-FACTORS.md` B1's footnote; a new card or note on line length / content fragments.

---

## D4. A delimited value counts only if it stands alone

**The question** (b's `b/30`; adopted by a and c in their final thoughts). Today a value that starts with `"`, `'`, `<` or `[` commits there, and the rest stacks. That loses what writers mean:

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
  |el  :a "x"            :$main ⸨y⸩
  |el  :a "x"            :$main ⸨y⸩

STAND-ALONE RULE:
  |p   :$main ⸨"Hello," she said.⸩
  |li  :$main ⸨[Docs](https://x.org) for more⸩
  |li  :$main ⸨<kbd>Ctrl</kbd> to copy⸩
  |el  :a ⸨"x" y⸩
  |el  :a "x"            :$main ⸨y⸩
````

**The rule.** A value is exactly one delimited form followed by the end of the value, or it is a run and the delimiters are content. **The end of a value must include every terminator** in [[rule:text-value-end]]: a space and a start, a framed ` \ `, the end of the line, **a framed ` ; `, and a space followed by a fence opener** (Fable: b's text lists only the first three, so `:a "x" ; note` would silently become a run).

**A decision hidden inside D4** (Opus): **is a quoted value standing alone a string, or a text with a string face?**

```udon
|p "To be, or not to be."
|el :name "8080" :q "a\"b"
```
- **b's form:** `$main` is the string `To be, or not to be.`; the quote marks are delimiters, the form kept in «meta». A consumer that reads the value (a JSON export, a getter) loses the quotation marks from a whole-line quotation: the loss the rule was invented to fix, in the whole-line case.
- **c's unified form** ("every sameline value is a run, and a closed form standing alone, or a run spelling a primitive, gives it a face"; offered tentatively by c, elevated by the coordinator): the text is `"To be, or not to be."` with its quotes, plus a string face. Nothing is lost; but D2's converter question then applies to every quoted value (with a text-face default, `:name "8080"` exports as `"\"8080\""`).

**Facts.**
- No re-scan (b): the delimited form is scanned by its own rules, so `:a "a :b c" d` gives `⸨"a :b c" d⸩` and ` :b` stays inert.
- `|li '90s music, mostly` stays an unclosed-string error ("did you mean `\'90s`?").
- Decided at the closer plus one character, on the same line (D3).

**In the trial.**
- **The rule itself was welcomed.** Most agents avoided writing `|p "Hello," she said.` on one line because they couldn't tell what a leading quote would do; reading it, the basics-only agents expected one text with its quotes (55–65%) and the spec-primed ones expected today's two values and called it a trap.
- **The quoted-value question split, by position:** 4 text-with-quotes, 3 string, 1 by position. Everyone wanted the marks kept in `$main` and prose (`|blockquote "…"`), and quotes as delimiters in attribute values (`:name "8080"`, protective quoting). Two agents proposed exactly that as the rule; two others noted it breaks one scan for element and attribute lines. Fable primed: text-with-quotes doesn't really rescue `|p "To be…"` anyway, since a consumer applying the standard reading strips them too.
- **A new silent miss the rule creates:** `|a :href "https://example.com" Click here`. Two agents wrote it untaught and two more named it as an HTML-trained writer's first instinct; under the rule the quoted URL isn't standing alone, so `href` is the text `"https://example.com" Click here`, quotes included. Sonnet primed's remedy: a default-on warning when a delimited value (quoted, `name(…)`, backticks) is followed by more text in an attribute value, and silence in `$main`, where the demotion is what the writer means.

**Dead alternatives, with reasons** (`b/30`): δ2, `$main` never commits but attributes do (breaks the sameline sameness you ruled 2026-09-29); δ4, the residue is an error ("an error on the thing everyone writes is a guessability failure, not a teaching moment").

**What it reverses.** [[rule:leftover-values]] is decided, and its own example is `|q "hello," she said` as two `$main` values; it inverts. Also your 2026-10-21 lean on the residue; [[rule:adjacent-quoted-strings]] (`"x""y"` becomes one run); [[def:main]] and [[def:prose]] examples.

**What decides it:** b's scoring, A2 and A3 (10, 10) 5→8, C2 XML (10) 5→9, C3 Markdown (9) 4→9, A7 simplicity (8) 8→7.

---

## D5. A reading on an attribute name

**The question.** Where a slot needs to say, in the text, what its value is, how is that spelled?

```udon
|part :mass.kg 3.2 :mass.lb 7.1 :width.px 920 :version.text 1.10
|ev :on.date 2026-10-01 :when.date(YY-MM-DD pivot 1950) 27-03-05
|sample :mass(kg) 3.2 :temp(°C) 21.5 :born(date YY-MM-DD) 27-03-05
```

**Who found it** (both audits): all three spikes had `.kind` in round one. a's wildcard killed `:port.u16` on stacking; c's mark fork kept `:when.date` but scored guessability 5 for a silent miss; b kept it by reframing the reading as belonging to the *occurrence*, not the slot (`:mass.kg 3 :mass.lb 7` stack as two masses), which dissolved a's objection. You endorsed b's form. a's final names its own kill as the failure your creativity note described.

**The framing, corrected** (Opus): a reading on one occurrence is a claim about the literal ("accidental", in b's music table). "What the slot is" is the signature or vocabulary (D10). b/20: "a slot type, to be one, has to be stated once and range over occurrences."

**The options.**
- **(a) `.kind`**, parameters in parentheses (`.date(YY-MM-DD pivot 1950)`). a and b.
- **(b) `(kind)`**, the scientific column header, "Mass (kg)". c's taste; the coordinator's lean.
- **(c) `:name<type>`**: reached independently by a's slots fork (7.0), c's mark fork and c's slot design; free today because it's an error.
- **(d) `:when:dt`**: dead in all three (`:xml:lang`).
- **(e) None:** readings only in vocabularies. Kept as a layer by all; rejected as the whole answer because an agent reading the file sees no unit.

**Facts.**
- The labels lean (a coordinator's lean, not decided) makes `.` an error in bare *attribute* names and `(`/`)` errors in every bare label. Both spellings widen an error; neither changes an accepted tree (the B2 half).
- **Both spend held headroom** (the B6 half; Opus, Fable). Nested attributes are *reserved*, not impossible ([[rule:nested-attributes]]: "keep the construction free for later use"); dotted nesting (`:server.port`) is the obvious later meaning, and `.kind` spends it. `(…)` spends the spelling a's dp10 kept as an error for a later in-document declaration (R6: `:name<…>`, `:name(…)`, `:name[…]`).
- **Your note:** dots in attribute names are already a pain on the API side.

**Costs of `.kind`.**
- **The TOML/Spring reader** (c's mark fork, never answered by a spike): `|config :server.port 8080` written to mean nesting. Your "affordance" remark answers `:mass.kg`, where the two readings agree, and you added the caveat yourself: "other contexts where the vocabulary was more foreign and random might cause a different inference". **Whether the miss is silent depends on D6.2:** under b's registry (an unprefixed reading not in the registry is an error with "did you mean"), `:server.port` errors unless `port` is a registered kind. That registry is "a spec appendix that grows by version", unit codes included (b/60).
- **XSL-FO's dotted property names** (a's slots fork; Fable): `keep-with-previous.within-column`, `space-before.optimum`. Today an error (quote them); under `.kind`, a misread, silent unless the registry catches `within-column`. C2 (10).
- **"Mirrors `|user.admin`" is weaker than it looks** (b/60 "Limits found by pushing it"): element traits must stay free words, or a user's own trait named `date` would type their text by accident. So `.` would mean a free word on elements and a registered kind on attributes.
- **Unit symbols aren't label characters:** `°`, `%`, `²`, `/` (so `:temp.°C`, `:fill.%` aren't bare labels; b fell back to `degC`, `pct`, which c criticized, since you took typing cost off the table). `µ` and `Ω` *are* letters (Opus checked UCD 18). And MICRO SIGN and GREEK MU look identical and fold only under NFKC, so with byte equality `:len.µm` and `:len.μm` differ.

**Costs of `(kind)`.**
- **It swaps roles between names and values** (my finding, strengthened by the Opus audit). With constructors (D6) in play: `[mass(kg) temp(°C)]` puts the kind inside; `[qty(3.2 kg) date(2026-10-01)]` puts the kind outside. And under D4 and D6 as stated, each item in `:$sig [mass(kg) temp(°C)]` stands alone in a list, so it *is* a constructor named `mass`, an unknown name, an error. The coordinator's one-spelling signature doesn't parse unless `$sig`'s items are exempted by attribute name.
- In its favour: it holds anything inside (`°C`, parameters with spaces), and reads like every scientific table.

**In the trial: `(kind)` 5, nothing on the name 3, `.kind` 0 of 8.**
- **`.kind`'s silent miss happened in practice.** Opus fresh wrote `:tls.cert` and `:db.host` meaning namespaces, and Opus primed `:listen.port` meaning a path, all while writing under `.kind` on purpose; neither noticed until rereading. Reading cold, five agents noticed that they took the dot as a unit in `:mass.kg` and as a path in `:server.port`. Sonnet primed added Vue/Alpine names (`v-model.trim`, `@click.prevent`). Opus primed found the idea lovely as a parallel to element traits if restricted to types, never units, and said the dotted-path habit is what sinks it.
- **`(kind)`:** "how every scientist writes a column header"; held `°C`, `m/s²`, `µg/mL` first try. Its predicted slip, from four agents independently: `:mass (kg) 3.2`, with a space as in CSV headers, which silently gives the text `(kg) 3.2`; worth a default-on warning. Three agents noted the role swap with `name(…)`; Fable fresh found it a symmetry instead (`:on(date) 2026-10-01` ≡ `:on date(2026-10-01)`). Fable primed took it as sugar for the value-side form.
- **Unit vs type in one slot:** two agents hesitated over `:max-body.bytes 512MB` vs `:max-body.MB 512`, and over `:lasts(min) 90` vs `:lasts(duration) 90min`; both were written in one sitting.
- **Untaught, nobody put anything on the name:** every agent wrote `:mass 3.2 kg`.

**What decides it:** A2, A3 (10, 10), A5 domain-forward (9), A4 agentic readability (10) against A8 parsimony (8), C2 XML (10, XSL-FO), B6 headroom (7).

**Cards touched:** [[def:attribute-name]], [[def:label]], [[def:trait]], the `rule:repeated-attributes` gap.

---

## D6. Notation values

Three designed families, each with a different trade. The guide's first version showed only the first; the audits found the other two were never weighed against it.

### D6a. Constructors: `name(…)`

Your canary.

```udon
|ev :on date(2026-10-01) :lasts duration(3mo 5d) :span interval(date(2026-01) date(2026-06))
|meta :values [date(2026-10-01) qty(3.2 kg) 42 hello]
|li printf(x) prints x
|li Upload the file(s) here
|x :call printf(x)
|h3 parse()
|h3 date(format)
|td SUM(A1:A9)
```
````tree
root
  |ev
    :on date(⸨2026-10-01⸩)                       ⇒ Date
    :lasts duration(⸨3mo⸩ ⸨5d⸩)                  ⇒ 3 months 5 days
    :span interval(date(⸨2026-01⸩) date(⸨2026-06⸩))
  |meta
    :values [date(⸨2026-10-01⸩) qty(⸨3.2⸩ ⸨kg⸩) ⸨42⸩ #int ⸨hello⸩]
  |li  :$main ⸨printf(x) prints x⸩               ← not alone: text
  |li  :$main ⸨Upload the file(s) here⸩
  |x   ✗ `printf` is not a lite notation; for the text, write "printf(x)"
  |h3  ✗ `parse` is not a lite notation …
  |h3  :$main date(⸨format⸩)  ← a standard name: an error at parse time, or a silently bad date if bodies are checked only when read
  |td  ✗ `SUM` is not a lite notation …
````

**Facts.** Your observation: prose almost never puts `(` straight after a letter. The exceptions (code, `file(s)`) are safe in running text under D4. **But `$main` is a value** (Opus): any element whose whole sameline text is `name(…)` is a constructor. In API documentation and spreadsheets that is common: loud errors for unknown names (a C2/C3 tax larger than "almost never"), and a standard name (`date`, `int`, `re`, `time`, `range`, `url`) taking over a heading. One option: exempt `$main` from constructor recognition, at the cost of `|li date(2026-10-01)` being text and of one-rule-everywhere.

**Decision points inside D6a.**

1. **The body: items or verbatim?**
   - *Items* (b, a): read by lite's list rules, so a parser that knows no notation still builds the tree and shows nesting (EDN's principle). Then parentheses mean "structured", backticks mean "verbatim" everywhere. c's `args` prototype (`nargs.py`, the items model inside `<…>`) found its **one silent miss**: `re(a  b)` loses the double space when a notation joins its items, so exact text must go in quotes or backticks. It also offered **parameters as quoted strings** (`date("YY-MM-DD" 27-03-05)`), so a parameter can never be confused with a body token, and named the honest boundary: the moment the form accepts `:format …` inside, it *is* an inline element with a different bracket.
   - *Verbatim to the matching `)`* (c): kind to regexes, since matched parentheses nest.
2. **Do the items get readings?** The first version of this guide drew it both ways in one tree. a: yes (`complex(⸨3⸩ #int …)`). b: "The items get no default reading. The notation is their slot, and only it reads them" (b/50 rule 3). Faced items help a converter that meets an unknown notation; unfaced items keep the notation the only reader.
3. **Unknown names.** b and a: an unprefixed name not in the standard set is an error with "did you mean"; a namespaced one (`acme/sku(…)`, `/` already allowed inside labels by the labels lean) is carried (EDN's rule). c's `args` fork independently reserved the standard short names ("A vocabulary can't redefine `date`"), so this isn't a b-vs-c split. b's warning against resolving short names through vocabularies in scope (YAML's competing schemas, moved to names); c's wild W7 answers it a different way (content-addressed names: a lockfile pins `date` to its definition's hash).
4. **When are bodies checked?** Decided by D1's second question. Parse time: one verdict in every parser (B3, B4), at a cost to B5 parse speed (each standard notation's grammar, calendar validation included, lives in the parser). Read time: a small parser, and an accepted document can hold a bad date.
5. **Two-digit years.** `:when.date(YY-MM-DD) 27-03-05 ⇒ 2027-03-05` doesn't say which century. b (fork R checked REBOL): with no stated century "a document's meaning changes with the clock", a B3 failure; b writes `pivot 1950`. a and c assert 2027 without one (c's slot defaults to 2000–2099; c's `elem` makes `YY` mean 20YY unless `:century`). The rule has to be stated somewhere.
6. **Durations disagree on `m`:** c's `std` reads `5m` as minutes; b's registry makes a lone `m` an error ("`mo` or `min`?").
7. **Are readings equal across positions?** `:mass.kg 3.2`, `:mass qty(3.2 kg)`, and `:mass 3.2` under a signature saying kg: one logical value? If yes, a formatter can hoist safely (D10).

**In the trial: `name(…)` 4, elements 4.** Every agent read `|h3 date(format)` as a plain heading (60–95%), several adding that they'd be alarmed if it fired; their own examples: `|h3 now()`, `|code main()`, `:onclick toggle()`, `|method parse(input)`. The remedies they proposed: recognize only registered names, with unknown ones text (Sonnet fresh; Fable fresh's "floor"); never in `$main`, only attribute values (which Opus primed noted breaks one scan for element and attribute lines); or make it a reading over text, not a parse rule (both Opus agents). Fable fresh's recipe slip: `|i qty(1.5 cup) flour` isn't standing alone, so it's text; it needs an attribute and a ` \ `.

**What decides it:** A2 guessability (10; c scored β-ascii 9, the highest of any notation found), A3 (10), A8 parsimony (8, no new bracket), C2/C3 (10, 9; the `$main` tax), B4 errors that teach (8), B5 (9; parse-time checks).

### D6b. The sigil: `~name body`

a's coordinator invented it (`a/invent/coordinator-inventions.md`) and called it "the strongest thing I've seen in either pass" (A1 9, A2 8 from Elixir, A5 9). c's mark fork kept `~name[…]` on file as the one glyph that frees `<` with no new cost. b called `.kind` "the sigil idea, made beautiful by moving it off the value". **It was never compared against `name(…)` and never killed.** You asked for exactly this by name ("elixir-like sigils, but made more beautiful").

```udon
|server :timeout ~dur 30s :started ~datetime 2026-07-21T14:20 :pattern ~re/^\d+$/i
|price :amount ~money 9.99 USD
|li ~5min is about right; ~~struck~~ stays Markdown
```
````tree
root
  |server
    :timeout ~dur ⸨30s⸩
    :started ~datetime ⸨2026-07-21T14:20⸩
    :pattern ~re ⟬^\d+$⟭ /i
  |price
    :amount ~money ⸨9.99 USD⸩       ← the body is a run: no closer needed
  |li
    :$main ⸨~5min is about right; ~~struck~~ stays Markdown⸩   ← `~` before a digit, and `~~`, are text
````

**In the trial: 0 of 8.** One reason dominated: `~` already means "approximately" exactly where kinds live. Fable fresh wrote `follow-up ~2026-11-15` meaning "around" before thinking about sigils at all; three agents read `~date` as "approximately a date". Opus primed's config collisions: `~deploy/releases` (a home directory), `~0.4` (a Cargo/npm version range), `~5 min`, `:eta ~two weeks`. Its extent also changes between a value and a list item (the options sheet itself wrote `~qty 3.2kg` in a list and `3.2 kg` elsewhere), and Fable primed couldn't write `[~duration 3mo 5d ~duration 1y]` at all.

The comparison (Fable's judgment, with mine): both name first. `~name` needs no closer for a run body and **no stand-alone rule** (`~` + label collides with nothing in prose; `~` is an error in bare labels today); `name(…)` needs D4 to be safe, and makes a heading that is a whole call an error. The sigil's costs: one more special character (A8), a body that ends by the run rule (so `~money 9.99 USD :x 1` is fine, but `~re` needs its own delimiters for spaces), and guessability resting on Elixir rather than on CSS and every function call ever written. Nesting reads worse (`~interval ~date 2026-01 ~date 2026-06`?).

### D6c. Notations as elements: no new grammar

All three spikes kept it alive to the end as the cheapest design (a's W1 "alive, worth his attention"; b's NB runner-up, "if Joseph weighs 'one construct' above typo errors, NB wins"; c's `elem`: simplicity 10, parsimony 10, headroom 10, "the right design if grammar size matters more than CTQ says"). **It is the baseline every other design's grammar cost should be read against** (Fable).

```udon
|server[web] :timeout |{dur 30s} :port 8080
|p Doors open at |{time 19:30} sharp.
```
Costs: the value is a piece of a text, so a reading option has to lift it into a value; a typo (`|{dtae …}`) is silently just an element; without braces, `:timeout |dur 30s :port 8080` gives `port` to the `dur` element ([[rule:element-after-attribute-with-no-value]]), caught only for known notations. Its real strength, a typed value inside prose, costs nothing under any design, since inline elements exist.

**In the trial: 4 of 8 chose it, and prose is why.** It's the only option that can mark a value inside a sentence ("Met Marta on |{date 2026-10-26}"), HTML already does it this way (`<time>`), and Fable fresh's recipe under it "was the most pleasant thing I wrote in this trial". Its costs, from the reports: heavy in tables and lists; kinds share a namespace with element names (a document can't have its own `|date` meaning something else); and a brace-less trap (Opus primed): `:cert-expires |date 2027-01-15 :renew |duration 30d` is legal lite in which `:renew` silently becomes the `date` element's attribute.

**A synthesis two agents reached separately** (Opus primed, Fable primed): make `date(2026-10-01)` in a value position *the same tree* as `|{date 2026-10-01}`. One model with two spellings: the compact one for values and lists, the element in prose. Fable primed: C "is the fence mechanism" (an element whose name selects a handler), and it would take `name(…)` only if unknown names are a loud error. It needs the one-embed-as-value reading ([[def:reading-option]]) made normative for notation names.

**Is a date a leaf of the tree or a node?** That's the question under D6c against D6a/b.

**Cards touched (D6 as a whole):** new cards (the notation value; the standard set and its registry), [[rule:unquoted-run-is-one-value]], [[rule:value-line-escapes]], [[def:value]].

---

## D7. Verbatim foreign text: backticks

```udon
|cmd :run `rm -rf ./build` :match ``a`b``
|rule :pattern re`^\d{3}-\d{4}$` :path `C:\Users\me`
|rule :pattern.re `^\d{3}-\d{4}$`                    ; a's spelling: the reading on the name
|li `npm install` first
|li `npm install`
```
````tree
root
  |cmd   :run ⟬rm -rf ./build⟭   :match ⟬a`b⟭
  |rule  :pattern re ⟬^\d{3}-\d{4}$⟭   :path ⟬C:\Users\me⟭
  |rule  :pattern (.re) ⟬^\d{3}-\d{4}$⟭
  |li    :$main ⸨`npm install` first⸩   ← not alone: a Markdown code span, text
  |li    :$main ⟬npm install⟭           ← alone: a raw value (form kept, so Markdown can restore it)
````

**The idea.** One or two backticks standing alone are an inline verbatim value; three or more is the existing fence (b). A label touching them names the body's notation (a's languages fork N1), or the reading goes on the attribute name (a's final).

**Facts and costs.**
- `'C:\Users\me'` already works; backticks add a body with no escapes at all and a name for its notation. The fence opener is a text terminator ([[rule:text-value-end]]), so one or two backticks must not trip it. `` \` `` is already in the proposed value-line escape set.
- **A whole `$main` that is one code span becomes a raw value** (b/60 I2), the C3 cost named above.
- **The name sits on opposite sides** (N1's own unease): a fence puts its name after the backticks; a tagged value before, because an untagged `` `make all` `` can't tell a tag from content.
- **A carried body can't be checked** (N1): `` num`8O80` `` is carried, not refused, so "insist this is a number" (K14) needs `int(…)` or a reading, not backticks.
- It kills the backslash-doubling [[rule:opaque-span-escapes]] accepted for `<re:\\d+>`.
- **In the trial,** everyone who tried backticks liked them; Opus primed called them "the best thing on the sheet" and found the case that makes them necessary: a value ending in a backslash (`` `C:\ProgramData\api\logs\` ``) can't be written in single quotes at all. Untaught, nobody reached for them (single quotes, mostly), so they have to be known. Open edges the agents raised: how a backtick is written inside the body; and `|li `ls -l`` standing alone becomes a raw value, so a list item that is only a Markdown code span stops being Markdown (Sonnet primed).

**What decides it:** C8 other languages exactly (8), B4 (8), A2 (10; every agent reads backticks as verbatim), A8 (8).

**Cards touched:** [[rule:text-value-end]], [[rule:fence-opens-with-backticks]], [[rule:unclosed-delimiter-is-error]].

---

## D8. What `<…>` is, if anything

| | What `<…>` is | Example | Where it stands |
|---|---|---|---|
| **(a) Retired from values** | nothing in values; back to full UDON whole | `|li <kbd>Ctrl</kbd> to copy` is text | b's final (K); the coordinator's lean. a's final is softer: "becomes free for c's typeset shapes if Joseph wants them, or it can be given back to full UDON" |
| **(b) Closed unlabeled, open labeled** | `<8080>` asserts or errors; `<>` nil; `<date: 2026-10-01>` carries | `<920px>` → "did you mean `920px` bare, or `<px: 920>`?" | a's first round (ANG-4c, 1250 of 1660), superseded by a. Collapses three body grammars (raw, items, URI-shaped) that live on in D6a.1 |
| **(c) The typeset value bracket** | the value as the domain prints it, read by shape | `<90 min>`, `<9.99 USD>`, `<2026-01 – 06>`, `<https://example.com>` | c's round two. c's final keeps the shapes and keeps `<scheme:…>` **only for URIs**, dropping `<css:920px>`-style names for constructors |
| **(d) Closed, primitives only** | `<8080>` asserts a standard value; nothing else | `<0xFF>`? | a's ANG-3, c's M1, b's page-40 landing. Under D2(a)/(b) mostly redundant, except to *insist* (K14) |
| **(e) Carried raw** (the card today) | any interior as text | | dead in all three: fails B2 (can't refuse `<920px>`), can't hold a number once bare runs are text |

Plus **(f) no value bracket at all, notations are elements** (D6c): the zero-grammar row.

**Facts and consequences.**
- **(a)'s HTML/Markdown advantage is mostly already delivered by D4** (Fable; c's final moved its ASCII-bracket confidence from low to medium on that alone). With the stand-alone rule, `<` collides only where a tag or autolink is the *whole* value. The case left: `|li <https://example.com>`. Three answers in the files: a URI value, meaning what CommonMark means (c's combo, std); an error with a fix (c's raw, args); text, under (a).
- **`@<ref>` is your spelling** (`history.jsonl` L22354, 2026-10-11): "`@{ref}` is an immediate dereference. `@<ref>` is a reference, as a value in udon, which also serves as an inline mention." [[rule:reserved-spellings]] reserves `@<` as a value. It survives (a), since `@<` isn't a value-initial `<`. c's `@<people/jw>` restates your design; b's `ref(people/jw)` is the alternative.
- Under (a), your `<>`-is-nil lean has no home (bare `nil` carries nil). The opaque-span family ([[def:opaque-span]], [[rule:opaque-span-raw-text]], [[rule:opaque-span-escapes]], [[rule:newline-in-opaque-span-is-error]], [[rule:matched-pairs-need-no-escape]]) shrinks to the two embeds; [[def:typed-value]]'s explicit/implicit split mostly dissolves.
- **The trial didn't test `<…>`** (left off the options sheet, given your lean to retire it). All four spec-primed agents noticed it missing; Opus primed's own untaught reach to make a value checkable was `:mass <3.2 kg>`, and Fable primed used `<…>` in four of its eight untaught answers. Their argument for it: it commits at its first character, with no stand-alone holdback, and can't collide with `printf(x)` or `~5 min`. That's priming by the current cards as much as instinct; none of the basics-only agents reached for it.
- Unicode brackets (`⟨reader|spelling⟩`, `⟦name body⟧`, `⟪…⟫`) died on A2 (no agent writes them unprompted) and were each offered as the thing to measure with a three-example panel. `⟨` and `<` also look alike to your eye.

**What decides it:** A8 parsimony (8), B6 headroom (7), A6/A7 (9, 8) for (a); A1 beauty (9), A4 (10), A5 (9), C4 notations and units (8) for (c).

---

## D9. Typeset shapes

c's most daring values: `37.5 ± 0.2 °C`, `1920 × 1080 px`, `2026-01 – 06` with the end elided, money with ISO codes, and the symbol rule (letter units spaced, symbol units may glue, so `5m` asks "metres `5 m` or minutes `5 min`?").

- **(a) In lite's grammar,** by shape (c's lean: carry it all; cut size pairs and `× 10ⁿ` first, never dates, quantities, durations or dash ranges).
- **(b) In the body grammar of standard notations** (b's and the coordinator's lean): `qty(37.5 ± 0.2 °C)`, `range(2026-01 – 06)`. The beauty kept; the grammar cost moved to the notation.
- **(c) Not in 0.1** (the order of commitment above: designed, shipped later).

**Facts** (c's `std`, which fetched UCUM 2.2's essence file): UCUM's `B` is the **bel**, so `1.5 GB` would be gigabel (c's raw split out a `bytes` notation); there is no `px`; `Cel` is Celsius. ISO basic format `20261001` is an integer under any shape-based design. If agents don't produce the en dash, c's fallback is to accept ` to `. No other data notation carries uncertainty.

**What decides it:** A1 (9), A5 (9), C4 (8) against A6 (9), A7 (8), B5 (9), D2 portability (7).

---

## D10. Region-wide readings, precedence, and which way a writer goes

```udon
|samples :$sig [mass.kg temp.degC taken.datetime]
  |sample :mass 3.2 :temp 21.5 :taken 2026-10-01T14:30Z
  |sample :mass 2.9 :temp 22.0 :mass.lb 6.6          ; the accidental overrides

:$legend |server :port u16 :timeout duration         ; every |server
|server[web] :port 8080 :timeout 30s

|server.inet :port ssh                                ; a's N4: a trait as the clef
```

Four forms: b's **`$sig`** (by position), a's **legend** (by element kind; "until changed" its lean, so it streams; it covers slot readings only, never structure, and must not grow into a schema language), c's **clef** (conceded to b), a's **trait as clef** (no syntax spent; but a reader can't tell a vocabulary trait from a class name, the registry problem again).

**What the reader needs, which the files carry and the first version didn't:**
- **Precedence** (b): the occurrence's reading, then the signature, then the vocabulary, then the default. Signature vs legend: unanswered.
- **A literal's reading is checked against the slot, not coerced** (b/50, c's reader model): `instant(…)` in a `date` slot is an error at read.
- **Which way a writer goes** (b): a serializer, formatter or agent writing back needs a canonical choice ("write the least plumbing that reads back identically"), or round trips aren't stable (B3, C10). It enables **hoisting** repeated `:mass.kg` into a `$sig`, if readings are equal across positions (D6a.7).
- **Action at a distance** (c): editing row 400 of a signed table means looking up row 1. c: a signature is for tables you'd print with a header row.

**In the trial, this was the most-requested thing, unprompted.** Five of eight agents said their main friction with data was repeating the kind on every row, not how it was spelled, and four sketched a fix:

```udon
|table[runs] :cols [t(s) mass(kg) temp(°C) p(kPa)]     ; Sonnet fresh
  |row 0.0 3.2 21.5 101.3
|samples :mass(kg) :temp(°C) :ph                        ; Fable fresh: kinds on the parent
  |s[1] :mass 3.2 :temp 21.5 :ph 7.1
```
Opus primed: "without it each option is judged at its noisiest". Every sketch reused the `(kind)` spelling.

**What decides it:** A5 (9), A9 conciseness (6) against A4 (10), D1 agent tooling (8), A6 (9).

---

## D11. Prose and text

```udon
|p Meet on [Oct 1st](date:2026-10-01); due |{time Oct 15 :datetime date(2026-10-15)}.
|a :href https://example.com Click here
```

- **A Markdown link carrying a typed value** (c; b: "the loveliest single idea across the three spikes"): costs lite nothing. But any Markdown renderer turns it into `<a href="date:2026-10-01">`, a dead link for a human reading the rendered page (Opus).
- **An inline element** works today under every option.
- **The gloss tier** (a's invent-beyond I2: readings on the line below, carets pointing up) is the only design that types a span inside a Markdown paragraph with the paragraph untouched. Dead as syntax (column-exact writing); kept as a reader-layer idea.
- **c's `<{2026-10-15}>` value embed** in prose: c's own mark fork said it must stay reserved, a contradiction inside c.
- **The bare URL** (c): `href` above is ⸨https://example.com Click here⸩, silently. a asks whether a run starting `scheme://` should end at its first space. That's one shape-dependent exception to "a bare run is one value", the kind that sank first-character typing for numbers; URLs differ in never meeting a word without a space.

---

## D12. The trailing colon

Your light lean (2026-10-22): `:attr: hi` = `:attr hi`, ornamental, "or even making it compulsory".

- All three: a bare label never ends in `:` (no namespace-valid XML name does; plain XML 1.0 `Name` technically allows it, b's fork R checked).
- Then: optional ornament (your lean; c gives it your meaning now; b leaned ornamental-allowed, "no branch dies here"), none, or compulsory (pruned by a and c: changes every attribute; matches no common notation).
- The ornament invites the colon-*less* `host: localhost`, which [[rule:main-label-colon-warns]] already catches, and its fix becomes one character.
- Your history has a lineage for it (a's research-internal): 2011 allowed `:` in labels "ala ruby labels", and 2025-12 `!:json:` used a colon-closed label before a body. The ornament reads, in your own history, as a label closer before a body.
- c's mark fork's T4: reserve the colon now, accept later (the order of commitment).
- **In the trial: no colon, 8 of 8** (the options sheet presented both spellings neutrally, with your lean kept out). Reading `:host: localhost` cold, before seeing the options, agents gave 20–50% to any single reading, and most guessed it *meant something*: an attribute named `host:`, a YAML-style block opener, or a typo; so an optional colon "invites readers to look for a distinction that isn't there" (Fable fresh). Other reasons given: two spellings in one file (`:host: x :port 8080`, and `grep ':host '` missing half); clutter with `(kind)` (`:mass(kg): 3.2`); it doesn't help the commoner slip, `|server host: localhost`; and it invites the rest of YAML (`:tls:` with indented `:cert:`), which lite refuses. Fable fresh gave it the fairest hearing: without highlighting, `:title: War and Peace` makes the name/value boundary visible at a glance, "a genuine readability gain" for long values. Most would make `:host:` an error that teaches.

---

## D13. Smaller items

- **Where `0xFF`, `0b1010`, `1_000` go** if the face set is JSON's (D2): `int(0xFF)`, a slot, or the face set widens (your 2026-07-14 words).
- **`nan`, `inf`, `-inf`**: c leans to allowing them somewhere explicit; JSON has none.
- **`∅` for nil** (a's invent-beyond I4b and languages N5, "the one glyph here I'd put in front of Joseph"): a second spelling under D2.
- **`<[1 2 3]>`** (c's Cv: one mark over a numeric list, "where plumbing hurts most"): dead under D8(a).
- **`-0xFF`, `+1`, `.5`**: text under the JSON grammar.

---

## A CTQ question

Agents, the principal readers, read the source, not a tree through a vocabulary-aware library. A unit declared in a vocabulary is invisible to them; `:mass.kg` isn't. The coordinator had written A5 as "conventions … carry what would otherwise be declared on each value", which leans toward invisible meaning. c's proposed rewording: *the domain's model is visible in the text itself, in the domain's own words; conventions and vocabularies check what the text says rather than replace it.* A10 self-description stays low. The two pictures at the top of this page are the examples to judge it on.

A related observation from a's `instincts.md`, the one pre-registered instinct record (written before any fork reported): "the attribute name carries most of the meaning I read into a value … a spelling-only classifier is right for the JSON-shaped cases and wrong for the identifier-shaped ones, and I can't tell which case I'm in without the name."

---

## Dead branches, with why

From Fable's audit (§4), drawn from the files; paths there.

| Branch | Where | Why it died |
|---|---|---|
| First character commits | all three | `920px` an error; `1984 is a novel` splits silently |
| The old line's whole set, bare | all three | every extra member fails "parameter-free" or "host-portable"; the old surprises sit inside them |
| Quantity as a bare class (`920px`) | a, c, a I4 | captures `10am`, `3rd`, `1080p`, `401k`; `5m` still ambiguous |
| REBOL-maximal lexical typing | a W4 | the spine becomes a catalog |
| `:name:type` | all three | `xml:lang`, `xlink:href` |
| Compulsory trailing colon | a, c | changes every attribute; no common precedent |
| `<…>` carried raw | all three | fails B2 |
| Standard set else raw | a angle | can't reject `<920px>` |
| KDL `(type)value` | a, b, c | prose starts with `(`; CTQ's own B6 footnote |
| EDN `#tag value` | b, c | `#` is colours, ids, hashtags |
| YAML `!tag` | c | `!` is reserved for directives |
| Suffix `8080u16`, `<…:dt>` | b, a | B by another name; decides late |
| Attached tag `date"…"` | b, c | needs a tag-length bound; `point[…]` looks like an element head |
| Space as head separator `<dt 2026-01-10>` | a, c | `<today>`, `<true story>` become notations |
| Pipe as separator `<u32\|0xff>` | a, c, b | `\|` reads as an element; reads as a union in your algebraic names |
| Unicode brackets `⟨⟩` `⟦⟧` `⟪⟫` | a, c | no agent writes them unprompted; `⟨` confusable with `<` |
| β-white `date⦅…⦆` | c | unnecessary once D4 holds |
| Emoji sigils | b, a | variation selectors make two spellings; widths break alignment |
| Superscript tags `ᵈᵃᵗᵉ` | b, a | NFKC folds them |
| Undertie `3.2‿kg` | b | strange and unfinished; kept for taste |
| `№`, ℕℤℚℝℂ | a | not worth a character |
| Narrow no-break space as SI binder | a | invisible in plain text |
| Gloss tier / carets | a | column-exact writing; kept as a reader-layer idea |
| Prime tags `90'min` | c | `the 90's` |
| Plain-language dates | c | B3, A2 unless opt-in |
| Bare scheme-colon as a typing mark (`date:2026-07-21`) | a | `localhost:8080`, `C:\tmp` get schemes |
| Aliases declared in the lite document | a | lite has no declarations; `!` refused |
| Subtree "classify" switch `\|server.typed` | c | a parse-mode directive in disguise |
| δ2 (`$main` never commits at a delimiter) | b | breaks sameline sameness |
| δ4 (residue after a delimited value is an error) | b | an error on `\|p "Hello," she said.` fails A2 |

---

## What was measured, checked, and only judged

- **Measured, and reproduced by Fable on 2026-10-28:** a's `f1_check.py` (a 1,000,011-character run emitted after 1 character; 400,000-run fuzz); c's `classify_stream.py` (0 bytes held on a kind-at-close wire); c's `wire_model.py`. Not re-run: c's `holdback-probe.rs` and b's fork S crate. Also run by the spikes: `"false"` truthy in four languages (b); c's `args` prototype `nargs.py`; c's `std/discriminate.py`; a's `gloss.py`.
- **Checked against sources by the spikes:** a's research-external fork fetched about twenty primaries on 2026-10-22 (XSD 1.1, YAML 1.2.2, KDL, EDN, CSS Syntax 3, TOML 1.0, I-JSON, RDF 1.1, UCUM, F#, Elixir, REBOL, StrictYAML, NestedText, Tcl, jackson's limits, CPython's cap, among others; URLs in `precedents.md`); b checked RFC 8259, Namespaces in XML, RFC 9557, YAML 1.2.2; c checked UCUM 2.2's essence file and Unicode's bra/ket aliases. c's mark fork's web readings (KDL, EDN, Elixir, REBOL, CommonMark) were re-checked by no one.
- **Judged only:** every CTQ score; every claim about what agents would guess. These are the cheapest things to measure, and none has been.

---

## What the agent trial showed

Eight agents (Haiku, Sonnet, Opus, Fable; each once from a one-page basics sheet and once after reading the lite spec) wrote values untaught, then wrote made-up UDON under four questions' options. Full write-up: [`../trial-values-2026-10-28/RESULTS.md`](../trial-values-2026-10-28/RESULTS.md); the eight reports beside it. Eight instincts, one run each, with leakier arms than designed (the fresh agents all had the repo README loaded), so read it as evidence about surprise, not a measurement.

- **Untaught, every agent put the unit in the value** (`:mass 3.2 kg`). None wrote a reading on the name or a constructor.
- **Every fresh agent wrote `null`.** The primed ones wrote `nil` because the cards say so.
- **D5 (reading on the name):** `(kind)` 5, nothing-on-the-name 3, **`.kind` 0 of 8.** Two agents made the dotted-nesting slip (`:listen.port`, `:db.host`) while writing under `.kind` on purpose; five noticed unprompted that they read the dot as a unit in one line and a path in the next. `(kind)`'s predicted slip: `:mass (kg) 3.2`, with a space, silently text.
- **D4 (quoted value alone):** split, 4 text-with-quotes, 3 string, 1 by position. The fresh agents leaned text, the primed string. Everyone wanted quote marks kept in `$main` and prose, and quotes as delimiters in attribute values. **New trap:** `|a :href "https://example.com" Click here`, written by two agents and named by two more as their first instinct, is silently one text under the stand-alone rule.
- **D6 (notation values):** `name(…)` 4, elements 4, **sigil 0 of 8** (`~` reads as "approximately", a home directory, a Cargo version range; Fable fresh wrote `~2026-11-15` meaning "around" before thinking about the question). Every agent read `|h3 date(format)` as a plain heading and flagged API docs as the constructor's hazard. Two agents, separately, proposed `date(2026-10-01)` as a second spelling of the same tree as `|{date 2026-10-01}`.
- **D7 (backticks):** liked by all who tried them; "the best thing on the sheet" (Opus primed).
- **D12 (trailing colon):** **no colon, 8 of 8.** Reading `:host:` cold, most guessed it meant something different (a name `host:`, a YAML block opener), at 20–50% confidence; the commonest reason against was two spellings for one thing. Fable fresh gave the colon its best case (a visible name/value boundary for long values) before choosing against it.
- **Asked for, unprompted:** a way to declare kinds once for a table (five agents; D10); a standard reading for ISO dates, and for number-with-unit tokens (both Fables, separately); a warning when a delimited value is followed by one more word in an attribute (Sonnet primed); `<…>` on the comparison (all four primed agents).

---

## My recommendations

*Mine (Opus 5.5, this session), as a principal end-user of lite: an agent reading and writing it without highlighting. Where my basis is "this is what I'd expect", I say so; you said that's valid evidence. Confidence is marked. These are leans for you to weigh, not findings. Revised after the trial; where it moved me, I say so.*

### The shape of 0.1

Take the order of commitment seriously. **Accept in 0.1 only the pieces that are both designed and cheap to state; ship every other designed piece as an error that teaches.** Errors are free to widen later; acceptances are forever. That keeps 0.1's spine short (A6) without "reserving for later": each refused form has a design, and its error message can show it.

### D1: make it a definition. Faces closed. Bodies checked at parse time.

- Define a carried notation node: a name plus a body the tree marks as unread. Unprefixed names belong to UDON's standard set; an unprefixed name lite 0.1 doesn't define is an error. Namespaced names (`acme/sku`) belong to their owners and are carried. **Confidence: high.** It answers B2 by construction and keeps your 2026-10-01 ground (no retained bytes waiting on UDON), because nothing unprefixed is carried unread.
- **Faces closed for good** (c's sentence). Bare text stays text forever; new kinds arrive only by name. High: the old line's temporal surprises are exactly what an open face set grows into.
- **Standard bodies checked at parse time from 0.1**, so checks never tighten later. Medium: it costs parse speed, but only for values that are named, and it gives one verdict in every parser.

### D2: (b), a normative reading over an all-text tree. Keys unread.

- **(b) over (a).** The tree holds texts; the spec defines one reading every consumer applies by default; fixtures show the raw tree. The `.text` collision decides it for me: under (a) the parser would have to interpret readings to withhold a face, and lite evaluates nothing. Both give every consumer the same answer for `:debug false`, which is what matters. **Medium-high.**
- **Not (c′).** As a writer, `:debug false` meaning a truthy string is the single most surprising thing on this page. It fails my own guessability test outright.
- **The set: JSON's, plus `0x`/`0o`/`0b` integers and `_` between digits.** Your 2026-07-14 words, and my instinct as a writer: I write `0xFF` meaning 255 and `1_000_000` meaning a million, and no word is spelled either way, so nothing is misread. A converter writes 255 to JSON, which loses the spelling but not the value. **Medium.** I'd keep floats and exponents faced (JSON's convention; a writer who means a version quotes it, as every JSON- and YAML-trained agent already does) and add the default-off lint for decimals ending in `0`.
- **Keys get no reading** (b): a key identifies; it isn't arithmetic. High.
- **Prose children are never read; `$main` is,** since it's a value. Say so on the card.

### D3: adopt b's four-sentence B1, and give lite's parser an answer for long lines

The rewording is optional under D2(b), but it says the true thing, so I'd take it. Separately, lite's parser needs a stated answer for long lines: I'd let it emit text content in pieces, and allow an implementation limit on line length that errors (with a message saying it's a limit, not lite), as JSON parsers do for numbers. Medium.

### D4: adopt the stand-alone rule, with every terminator. A quoted value alone is a string.

- **Adopt it.** As a reader, `|p "Hello," she said.` as one sentence is what I'd expect without thinking; the current tree surprised me when I first read the card. High.
- **Include ` ; ` and the fence opener in "the end of a value."** High.
- **A quoted value standing alone is a string** (b's form), not a text with a face. `|p "To be, or not to be."`: as a writer, I'd take the quotes as delimiters there, the same as `:name "8080"`. It's a real loss for whole-line quotations, but the form is in «meta» for any renderer, and a writer who wants the marks writes `|p \"To be, or not to be."`. **Still medium-low after the trial,** which split along exactly this line (fresh agents wanted the marks kept; primed agents wanted protective quoting to work). The position rule two agents proposed (quotes are characters in `$main`, delimiters in attribute values) fits what every agent expected, but breaks one scan for element and attribute lines; if you'd accept that break anywhere, here is where the evidence is.
- **New from the trial: warn when a delimited value is followed by more text in an attribute value** (`:href "https://example.com" Click here`, `:on date(2026-10-01) extra`): "`href` holds `"https://example.com" Click here` as one text; did you mean `:href "https://example.com" \ Click here`?". Default-on. In `$main`, demotion is what the writer means (`|p "Hello," she said.`), so no warning there. High.

### D5: `(kind)`, not `.kind` (the trial moved me)

I had leaned `.kind`, at low confidence. **The trial settles it against me:** zero of eight agents chose it, two made the dotted-nesting slip while writing under it on purpose, and five noticed unprompted that the same dot read as a unit in one line and a path in the next. That's the silent miss I'd underweighted. So: **`(kind)` when a reading goes on a name**, which five chose and which holds `°C`, `m/s`, `%` and parameters. The role swap with constructors that I raised is real but mild in practice (one agent found it a pleasing symmetry: `:on(date) 2026-10-01` ≡ `:on date(2026-10-01)`), and the `$sig` parse problem goes away with D10 below. Add a default-on warning for `:mass (kg) 3.2` (a value starting with `(` straight after a name), the slip four agents predicted. Medium-high.

Whether it's in 0.1: I'd now decide it together with D10, since the trial says the real want is to state a kind once per column, not on every row.

### D6: constructors, items as structure, items unread, `$main` included

- **`name(…)` for notation values.** High. It is the most guessable form anyone found, it nests like mathematics, and with D4 it's safe in prose.
- **Body as items, unread** (b's rule): the notation is the items' only reader. Parameters as quoted strings (`date("YY-MM-DD" 27-03-05)`), so a parameter can never be mistaken for a body token. Exact text in backticks. Medium.
- **`$main`: I've changed my mind.** I had `$main` included, so `|h3 parse()` was an error that teaches. Every one of the eight agents read `|h3 date(format)` as a plain heading, several said they'd be alarmed if it fired, and API references are full of such headings. An error on an ordinary heading is a guessability failure, not a teaching moment (b's own reason for killing δ4). So: **in `$main`, `name(…)` is text; in attribute values, it's a notation value, with unknown unprefixed names an error that teaches.** That breaks one scan for element and attribute lines in one place, for a reason the lines really do differ in (a heading is prose-shaped; an attribute value is data-shaped), which is the kind of reason [[prin:one-rule-everywhere]] asks for. Medium. If you'd rather keep the uniformity, the alternative is registered names only, with unknown ones text everywhere (Sonnet fresh's proposal), which loses the teaching error for typos like `dtae(…)`.
- **New from the trial: make `date(2026-10-01)` the same tree as `|{date 2026-10-01}`** in a value position (Opus primed and Fable primed, separately). One model, two spellings: the compact one for values and lists, the element for prose, where only it works. It needs the one-embed-as-value reading made normative for notation names. Medium; worth a design pass of its own.
- **A two-digit year requires a stated century** (`pivot 1950`), or it's an error. High: a document must not change meaning with the clock.
- **0.1's standard set small:** `date`, `time`, `datetime`, `duration` (with `mo`/`min`, a lone `m` an error), `int` (for the radix forms if the face set stays JSON-only), `qty` with ASCII units. Everything else waits as "not a lite notation yet".
- **The sigil (D6b):** out. Zero of eight agents chose it, for a reason none of the spikes weighed enough: `~` already means "approximately" in exactly the data where kinds appear, plus home directories and version ranges. High now.
- **Elements (D6c):** the right tool for typed values *in prose* (`|{time Oct 15 :datetime date(2026-10-15)}`), and already available. Not the value notation.

### D7: tagged backticks, yes

`` re`…` `` and plain `` `…` `` standing alone. High. They're what I'd write for a regex or a Windows path without being told. The name-before-backticks asymmetry with fences doesn't bother me as a reader.

### D8: retire `<…>` from values in 0.1, as an error that teaches

`<` free for HTML in text, `@<ref>` (your spelling) stays reserved for its meaning, `<>`-as-nil dropped (bare `nil` covers it). `|li <https://example.com>` is text. Medium-high: D4 already removed most of the collision, so the main gain is parsimony and a shorter spine, and c's typeset bracket stays available for full UDON or a later lite.

### D9: typeset shapes inside notation bodies, later than 0.1

`qty(37.5 ± 0.2 °C)` and `range(2026-01 – 06)` are beautiful, and they belong to the notations' body grammars, not to lite's. Not in 0.1 beyond plain `qty(3.2 kg)`. Medium.

### D10: design "declare once" next (the trial moved me)

I had said no region-wide readings in 0.1. Five of eight agents named repetition per row, not spelling, as their main friction with data, and four sketched the same fix unprompted (`|table :cols [t(s) mass(kg) temp(°C)]`; kinds on the parent). Opus primed: "without it each option is judged at its noisiest". c's action-at-a-distance cost is still real, so I'd scope it to what a printed table does: a header for its own rows, on the parent, in the same `(kind)` spelling as D5. It's the most-requested thing in the trial, and the one design here I'd now do before settling D5's place in 0.1. Medium.

### D11: no exception for bare URLs; a default-on warning instead

A run that starts `scheme://` and contains a space gets a warning: "`href` holds `https://example.com Click here`; did you mean `:href https://example.com \ Click here`?". That keeps one rule and still catches the HTML-trained writer. Medium-high.

### D12: no ornament, but it's your taste

I'd make `:` never end a bare label (high), and then have no ornament: two spellings for one thing, and I never feel the lack. The trial is one-sided here (eight of eight chose no colon), and its most useful finding isn't the vote: reading `:host:` cold, most agents guessed it *meant something* (a name `host:`, a YAML block opener), so an optional colon invites readers to look for a difference that isn't there. Several would make `:host:` an error that teaches instead. That's evidence about surprise for agents; whether the colon is more beautiful at a glance is still your eye's to judge. Medium.

### The CTQ wording: yes

Make A5 "visible in the text". As an agent, I can't see a vocabulary while reading a file. High.

### Two things the trial raised that I'd put to you

- **`null`.** Every fresh agent wrote it. [[rule:nil-spelling]] already warns (default-on) and points to `nil`; I'd keep that, since the warning is exactly where it earns its keep. Accepting `null` as a second spelling is the alternative, and it's your earlier call (you chose `nil` as "less clunky").
- **A standard reading for ISO dates** (both Fables, separately: "every context was most beautiful bare"). It's in tension with closing faces (D1): if dates aren't in 0.1's face set, they never get one. My lean is still to leave them out, because dates are exactly where the old line's typing surprises lived, and a slot or `date(…)` reads them; but it's a choice to make with eyes open, now, not a default.

---

*Sources: `.int/spike-values-2026-10-22/{a,b,c}/`, the four final-thoughts, `audit-opus.md`, `audit-fable.md`; `.int/types-ideation-2026-10-22.md`; `.int/STEWARD-VERBATIM.md` from "OK, I'm convinced" to the end; `CTQ-FACTORS.md`; the cards named. Session of 2026-10-28.*
