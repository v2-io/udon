# Audit of `ADJUDICATION-GUIDE.md` (Fable 5.1, 2026-10-28)

*For the coordinator who wrote the guide, and for Joseph. I read the guide, `BRIEF.md`, `adjudication.md`, `coordinator-final-thoughts.md`, `CTQ-FACTORS.md`, and every page in `a/`, `b/` and `c/` (all fork pages included, about 13,000 lines). I then checked the guide's claims against the primaries it cites: the cards (`rule-leftover-values`, `rule-unquoted-run-is-one-value` and its context file, `rule-text-value-end`, `rule-fence-default-handler`, `obj-reserve-dont-ignore`, `rule-adjacent-quoted-strings`, `rule-nil-spelling`, `rule-reserved-spellings`, `rule-value-line-escapes`, `rule-nested-attributes`, `rule-element-after-attribute-with-no-value`, `def-attribute-name`, `adr/forward-compat-aspiration`), the labels lean (`.int/labels-ascii-and-positions-2026-10-20.md`), the verbatim record (lines 1476–1600 and 1751–1883), `types-ideation-2026-10-22.md`, `TODO-MSC.md`, `HANDOFF-2026-10-22.md`, and `~/.claude/history.jsonl` lines 22354 and 22934. I re-ran the three scripted checks the guide reports as measured (a's `f1_check.py`, c's `classify_stream.py` and `wire_model.py`); all three reproduce.*

*Labels: **checked** means I read it in the primary named; **judgment** means mine. Where I say a design is "in the files", the path is given so you can read it rather than take my word.*

**The short of it.** The guide is accurate on most of what it carries; the spikes' measured facts and Joseph's quotes are rendered correctly, and I found no fabricated claim. What needs attention is in three groups: (1) a handful of attributions put more firmly than the sources (D2's "sank in all three", D2(d) "rejected", D5 "b invented it", D13's keys), (2) options and findings that didn't surface at all, two of which I think change how Joseph should read the picture (the `elem` zero-grammar baseline demoted to a "smaller item"; the sigil `~name` never adjudicated against `name(…)`), and (3) two framing points: D1 may be a definition to make rather than a law to adjudicate, and Joseph's stated ask was CTQ *weights* adjudicating designs, which the guide drops almost entirely.

---

## 1. Framing

### 1.1 D1 may dissolve into a definition, and two cards already lean that way

The guide poses D1 as "is adding a reading later a change?", with (c) killing every notation design. Both a's angle fork and c's reader model reached a sharper formulation that the guide folds under (b) without naming it: **what node kind does lite give a carried body?** If lite's tree holds `date(…)` as its own kind (carried, unread: a's "raw, never a string", c's `unread{name, body}`, b's `unresolved(name, items)`), then a later reader attaching meaning adds nothing to the raw tree, and the question is answered by the definition of the node rather than by a law about change.

Two primaries support reading it that way (checked):

- `obj-reserve-dont-ignore` clause 1 reserves spellings "that a future full version gives meaning to, **and that lite does not define**". A notation value lite *defines* (as a carried, named, unread node) is outside clause 1 by its wording. c's `raw` design says this in so many words: "B2: pass, by definition rather than reservation" (`c/notations/raw/design.md` §8).
- `adr/forward-compat-aspiration` already accepts that full UDON reshapes what lite carries: Joseph, 2026-10-08, "Opaque spans for example now will be their own branch in the AST later, among other things." So a later reading of a carried body is inside the aspiration's scope, not a breach of it.

What this does to the guide: D1's three options become (a) faces may grow / (b) faces closed, and the "names" half is settled by the node definition. The condition a's angle fork attached ("provided lite's tree marks the body as unread (raw), never as text or string", `a/forks/angle/functions-and-the-no-go.md`) is the load-bearing sentence and should be in D1's text, since it constrains D6.1 and D7: if a constructor body were held as a plain «text», a later reading *would* change its kind.

Also worth stating under D1: **choosing (b) removes one of a's two reasons for D2(a) over D2(d).** a's classification fork scored Cc above B partly on growth ("Cc can grow, B can't", B6 8 vs 5, `a/forks/classification/dp1-where-the-class-lives.md`). If faces are closed for good, that leg is gone, and the Cc-vs-B difference reduces to identity-by-spelling and the `|h1 1984` tree. The guide treats D1 and D2 as independent in that direction; they aren't.

### 1.2 The fence precedent is weaker than "lite already answers it once"

The guide (D1 Facts) says a fence named `sh` carries its body for whatever handler later reads `sh`, "checked against the card". Checked: `rule-fence-default-handler`'s Statement is about the *opening line* (keys, `.exact`, a comment; anything else an error). The body-carried-unread part is `rule-fence-body-not-scanned`. And the card's own working notes say what a handler *is* in lite's spec is open ("who supplies one, how a parser picks it by the fence's name"). So the precedent is: lite already carries a named body unread. Whether a later handler *reading* it counts as a change is exactly as open for fences as for `date(…)`; the fence card shares D1's question rather than answering it. That still supports the definitional reading in 1.1, but "Lite already answers it once" overstates.

### 1.3 Joseph asked for CTQ weights; the guide quotes rankings and drops the factors' weights

Verbatim 1779–1781: "sorry, what's the point?" then "I'm not really interested in fact checking casual conversations … I'm interested in the CTQ weights adjudicating various design proposals." The guide's decision to quote rankings rather than totals is defensible (the scales differ by fork), but it goes further and mostly drops the *factors* too: D2, D4 and D8 carry a few numbers, and most sections name factors by letter without weight. A one-line "what decides it, with weights" per decision would answer his stated ask without pretending the totals are comparable. For example, D5 is decided by A2/A3 (10, 10) and A5 (9) against A8 (8) and C2 (10, if XSL-FO names count); D8(a) vs (c) by A6/A7 (9, 8) against A1/A4 (9, 10) and C4 (8). The spikes already did this work (b/60 §3, c/notations/synthesis.md, a/forks/angle/scores.md); the guide can lift it.

### 1.4 The "picture in one screen" shows only the schema-less case

Every spike said, in its own words, that per-value readings are for documents with no vocabulary, and that with a vocabulary the values go bare (a's S0 "with a dialect in hand, no value in the document needs a mark"; b's layers "the vocabulary, then the default reading"; c's slot "renders with zero plumbing per value: the design's strongest case"). The guide's composition line `|part :mass.kg 3.2 :mass.lb 7.1` is the schema-less spelling shown as if it were the default. Joseph's A5 note as it stands ("conventions … carry what would otherwise be declared on each value") makes the vocabulary case the default. The CTQ question at the end of the guide is about exactly this, so the picture should show both lines, with and without a vocabulary, so he can judge the A5 question on examples rather than on the proposed wording.

### 1.5 `elem` is the zero-grammar baseline, not a smaller item

The guide puts "is a date a leaf or a node" in D13 ("smaller items"). In the files it is the one design all three spikes kept alive to the end and scored as the cheapest grammar: a's W1 ("alive, worth his attention"), b's NB (runner-up, "if Joseph weighs 'one construct' above typo errors, NB wins"), c's `elem` (A7 10, A8 10, B6 10, "the right design if grammar size matters more than CTQ says"; and c's `args` fork: "If Joseph judges that nesting and parameters don't need lexed arguments, the honest move is `elem`, not a weakened N-args", `c/notations/args/design.md`). Its two costs are real and in the guide (silent typos; the sameline trap). But every other notation design's grammar cost should be read against it, and D6/D7/D8 don't mention it. I'd promote it to a D8 row, "(e) no value bracket at all: notations are elements", with the three spikes' scores, so Joseph sees what each unit of grammar buys over zero.

---

## 2. Per decision: misrenderings, firmness, missing nuances

### D2 (standard reading)

- **"`:debug false` … This is what sank (c) in all three spikes."** Misattributed. The four-language run is b's alone (`b/10` §2). a killed the open view on B3/C7 generically ("two consumers disagree"). c's Cv fork *chose* strings-by-default for the converter with `:debug false` as text ("A writer who wants a JSON number writes `<8080>`", `c/branches/Cv/branch.md` Cv.2), and c's Σ branch leaned "text by default in the API, `std` by default in generic converters". c's final narrowed the open bit to "which face a converter picks" but did not use the boolean argument. Say: "b's argument; a and c reached 'the default has to be fixed' on stability grounds; c's Cv fork leaned the text face for converters."
- **"(d) the face *is* the kind ('B') | rejected by a and c on `|h1 1984`, keys."** Too firm. a ranks B second, alive (7.48 vs 8.20), and its own final-thoughts §3 says its first-round kills were "judgment applied before the idea had grown". c's B fork made B* *survive* on memory-bounded B1, called the typed `$main` "odd but harmless", and would not exempt it. c's final folds B into the allomorph (a face in the tree), which is (a), not a rejection of (d). Nobody chose (d); nobody killed it. The one honest difference left between (a) and (d) is identity by spelling (`[3]` vs `[3.0]`), which the guide has.
- **Keys and lists (also D13).** "Under D2 they get faces by the same rule (`|step[3]`, `:tags [1 2]`)" is a's position. b explicitly said the opposite: "A key gets **no** default reading. A key is an identity, compared by spelling … A typed key is written as a literal (`|step[<1>]`)" (`b/50` §4; also `b/10` §7). c's Cv: keys hold texts. Present it as open, with b's reason (a key identifies, it isn't arithmetic).
- **The set.** "The set is JSON's: no leading zeros, no `0x`, no `_`, no `+`" is a's and b's. c's core fork argued *for* `0x`/`0o`/`0b`, single `_` between digits, and `+` as core ("earns its grammar: E9-style masks and addresses"; `c/branches/core/spelling.md`; its classifier fuzz admits hex, which I re-ran). c's final conceded "the classification set is JSON's", so the convergence is real, but the hex question has a residue the guide should carry: b put hex and underscores inside `<…>` as the "rich set", and under D8(a) `<…>` retires. Where `0xFF` goes is then open: b's K writes `int(0xFF)`; a says a slot or notation. One line in D13.
- **Fixtures.** The guide credits (a) with "makes the face visible in fixtures". b leaned the other way on purpose: "only the raw tree is shown and the reading is a function the spec defines … (A6: one tree per fixture)" (`b/10` §7). Both are available under (a); it's a transcript choice, not a merit of (a) over (b).
- **The card's Grounds.** `rule-unquoted-run-is-one-value` (checked) gives as its ground: "A streaming parser knows every value's kind from its first character, so nothing has to be held back to type it." The spikes' measurement contradicts that ground for the existing parser. Whichever way D2 goes, the card's Grounds need rewriting; worth listing under "Cards touched".

### D3 (B1's wording)

- **Missing fact that bears on Joseph's own worry.** b's fork S (checked in the file, not re-run): the pushdown parser today has **no line cap**; only the older recursive wrapper caps at 4 KB. So the DoS exposure Joseph described for `4938…p` exists today for every bare text run, independent of typing. The fork's conclusion: the real streaming decision is "emit content in fragments, or cap the line", and it is orthogonal to D2. The guide's D3 says streaming "doesn't decide this" but not that the hazard is already present and unaddressed. That's the kind of fact that changes a decision's urgency.
- **c's B fork's precise break point** is collapsed. The fork found that B is bounded in *bytes* with a kind-at-close wire, and unbounded only in *characters scanned before the kind is known*, because of whitespace (`1984` vs `1984 is a novel`, alignment spaces). Its conclusion: "It is a one-word difference in B1, and B lives or dies on it" (memory vs characters). The guide's "What still holds back" has the mechanism; the one-word framing is what Joseph would need to rule on, and c's allomorph (W1) is the move that makes the strict wording hold anyway (kind = text at the first character; the face is an attachment). The guide should say that the allomorph was *designed to pass B1 as currently worded*, so the rewording is optional under D2(a).
- b's proposed rewording had a fourth sentence the guide drops: "Whether content itself is emitted in fragments or held to its line end is a wire choice, measured as the longest holdback (today: one line)." That sentence is the measurable half.

### D4 (stand-alone)

- **Attribution and firmness.** Fine. One nuance: c offered the one-rule form tentatively ("It's worth asking whether that is one rule rather than two", `c/final-thoughts.md` §1); the "most important structural result" is the coordinator's elevation, which the guide says. Keep both registers visible.
- **Edge the rule as written doesn't name.** b's δ3 text lists the value's end as "a space and a start, a framed ` \ `, or the end of the line". `rule-text-value-end` (checked) also ends a value at a framed ` ; ` and at a space followed by a fence opener. `:a "x" ; note` and `:a "x" ```sh` need to be in the rule's list, or the string is not "standing alone" and silently becomes a run. Small, but it is exactly the kind of edge B3 is about.
- **Dead alternatives whose reasons deserve a line.** b/30 pruned δ2 (`$main` never commits at a delimiter, attributes still do: breaks the sameline sameness Joseph ruled 2026-09-29) and δ4 (the residue is an error: "an error on the thing everyone writes is a guessability failure, not a teaching moment"). δ4 is the "errors over guesses" instinct applied, and Joseph may ask why not; the reason is in the file.
- **c's flaw with the rule** is in the guide ("the stand-alone decision is made at the closer plus one character") but attributed to b's streaming note; c's point was that this is the same kind-known-late as D3, so D4 inherits D3's answer. Fine either way; just link them.

### D5 (reading on the name)

- **"b invented it."** Checked: all three had the spelling in round one. a's wildcard W2 (`:port.u16`, killed on stacking), c's mark fork M3 (`:when.date`, scored A2 5 on the TOML prior), b's σ2 (killed as a *slot* mechanism). b's contribution was to keep it by reframing it as a reading on the *occurrence* (the accidental), which dissolved a's stacking objection. a's final §3 names its own kill as the failure Joseph's creativity note described. The accurate line is "all three found it; a and c killed it on first contact; b kept it by reframing; Joseph endorsed b's". That version is also the better evidence for Joseph about how the spikes worked.
- **Whether the TOML hazard is silent depends on D6.2.** c's mark fork said `|config :server.port 8080` written as nesting is a silent miss because "lite knows no notation names, so it can't warn". Under b's rule (an unprefixed name not in the registry is an error with "did you mean"), it is caught unless `port` is a registered kind. So the hazard the guide lists against (a) is conditional on how unknown names are treated; the two decisions should cross-reference.
- **A C2 cost of `.kind` nobody carried forward.** a's slots fork S2b (checked, `a/forks/slots/dp6-slot-types.md`): XSL-FO's compound properties are dotted attribute names (`keep-with-previous.within-column`, `space-before.optimum`). The labels lean already costs those names their bare spelling (error); `.kind` would turn the error into a silent misread (`keep-with-previous` with reading `within-column`). a scored S2b's C2 at 4 for this. The guide's D5 mentions dotted names only as Joseph's API-side pain. C2 is weight 10.
- **Headroom angle.** Nested attributes are *reserved* (`rule-nested-attributes`, checked), which means full UDON may give them meaning. Spending `.` on attribute names as "kind" forecloses `.` as a sub-key path in full UDON. The guide repeats the ideation note "attributes can't nest, so `.` can only mean its kind" as if settled; the "can't" is a lite reservation, not a design decision about full UDON. One line under B6.
- **(d) `:name<type>`** is credited to c's slot design only. a's slots fork S2c also reached it ("the best inline spelling found here, if inline slot types are wanted at all", scored 7.0, with the "one space from `:x <dt:…>`" hazard), and c's mark fork M3-angle. Three arrivals, not one.

### D6 (constructors)

- **The body-as-items model has a worked prototype and a named silent miss that the guide doesn't carry.** c's `args` design (`c/notations/args/design.md`, prototype `nargs.py`, cases in `cases.out.txt`) is the items model inside `<…>`; everything it found transfers to `name(…)` with items. Three things worth Joseph's eye: (i) its one silent miss, `<re a  b>` loses the double space when a notation joins its arguments, so "exact text goes in quotes" is a rule writers must learn; (ii) parameters as quoted-string arguments (`<date "YY-MM-DD" 27-03-05>`), so a parameter can never be confused with a body token; (iii) its three hard lines (value not node; items not a run; no attributes or children inside), with the warning that the moment the form accepts `:format …` it *is* an inline element with a different bracket. That last point is the honest boundary between D6 and `elem`.
- **Within c, the two forks disagreed on short-name resolution.** The guide says b warns against c's scope resolution. c's own `args` fork independently reserved the standard library's short names ("A vocabulary can't redefine `date`"). So the EDN rule has support inside c too; worth saying, since it reads as a b-vs-c split.
- **The century.** The guide's picture reads `:when.date(YY-MM-DD) 27-03-05 ⇒ 2027-03-05` with no pivot stated. b's fork R found (checked against REBOL's docs) that a two-digit year with no stated century changes meaning with the clock, a B3 failure; b's K writes `:on.date(YY-MM-DD pivot 1950)`; c's slot defaults to 2000–2099; c's elem makes `YY` mean 20YY unless `:century`. The rule has to be stated somewhere, and the guide's example should either carry the pivot or footnote it.
- **β-white.** c's inventions offered `date⦅2026-10-01⦆` (U+2985/2986) as the collision-free form before b's rule existed. Dead under D4; one line in the dead table so nobody re-proposes it.

### D7 (backticks)

- Two costs from the files that the guide omits: b's I2 names the C3 cost that a whole `$main` which is one code span (`|li `npm install``) becomes a raw value, its form kept so Markdown can restore it; and N1's asymmetry worry: a fence puts the name *after* the backticks, a tagged value puts it *before*, chosen because an untagged `` `make all` `` can't tell a tag from content (`a/forks/invent-languages/n1-tagged-code-values.md`, "What makes me unsure"). N1 also notes that lite can't check a tagged body (`` num`8O80` `` is carried, not refused), so K14 (insisting on a number) is lost unless something else does it; under D2(a) nothing bare asserts, and `int(…)` as a constructor would.
- The escape `` \` `` is already in the proposed value-line escape set (checked, `rule-value-line-escapes`), so the "Cards touched" note there is a confirmation, not an addition.

### D8 (`<…>`)

- **The C2/C3 pro for (a) is overstated given D4.** c's final §1 (checked): with the stand-alone rule, ASCII `<…>` collides with HTML and Markdown "only where a tag or autolink is the *whole* value", and c moved its bracket lean from "ASCII, low" to "ASCII, medium" on that alone. So (a)'s "HTML and Markdown in text (C2, C3)" advantage over (c) is the whole-value case only. The table's pros should say so, or the reader will weigh a cost D4 already removed.
- **`@<…>` has Joseph's own prior meaning; the guide presents it as c's proposal.** history.jsonl L22354 (2026-10-11, checked): "`@{ref}` is an immediate dereference. `@<ref>` is a reference, as a value in udon, which also serves as an inline mention." `rule-reserved-spellings` reserves `@<` as a value (checked). c's `@<people/jw>` (kept) is his design restated; b's `ref(people/jw)` is the alternative. The guide should say which is his.
- **Three answers to `|li <https://example.com>` standing alone**, which is the one case D4 leaves: c's combo and std make it a URI value ("the autolink means what Markdown means"); c's raw and args make it an error with a fix ("no space after the colon", "write `\<https://…>` or `<url …>`"); b's fork P noted the shape coincides exactly with CommonMark's autolink and leaned to making the coincidence deliberate. Under (a) it is text. Worth a line in D8 or D11, since it is the whole-value case that survives D4.
- **(b) collapses three body grammars that live on in D6.1.** a's ANG-4c (body raw), b's NA/LW (body as list items), c's M2/raw (body verbatim) and c's combo (URI-shaped, no space, verbatim) all fit row (b). Fine to collapse, but say the split is the one D6.1 inherits.
- **(e) closed, primitives only, no notations** (a's ANG-3, c's M1, b's page-40 landing) is missing as a row. Under D1(b) it is the fallback the guide's D1 text names ("the 'reserved for later' landing you rejected"), and under D2(a) it is redundant except for K14 assertion. One row, so the table is complete.
- Alternatives developed in full that the guide mentions only as glyphs: c's `bra` (`⟨reader|spelling⟩`, with the clef as a bodiless bra and Quine corners `⌜…⌝` offered for kept references) and a's I3 `⟦name body⟧`. Both died on A2 (no agent writes them unprompted) and both were offered as the thing to measure with a three-example panel. A line each in the dead table.

### D9 (typeset shapes)

- Fine. Two facts from c's std/raw forks worth carrying because they bite any design that uses UCUM bodies: UCUM's `B` is the **bel**, so `<qty: 1.5 GB>` would be gigabel (c's raw fork split out a `bytes` notation for this; "from memory" for the bel, checked for `By`); and ISO basic-format `<20261001>` is the integer, silently, under any shape-based design (c's std N18).
- c's `combo` fork's "What I'm not sure works yet" names the honest fallback if agents don't produce the en dash: accept ` to `. The guide says only "judged".

### D10 (region-wide readings)

- A fourth form is missing: a's languages fork N4, the trait as clef (`|server.inet :port ssh`), which spends no syntax and declares once per element. Its worry (traits are free names, so a reader can't tell a vocabulary trait from a class name) is the registry problem again. Since the guide's D10 lists three forms, the fourth belongs with them.
- a's legend (I3) left two things open that the guide doesn't carry: whether a legend governs every element of its kind or only those after it ("until changed" is the fork's lean, and it streams), and that a legend covers slot readings only, never structure or cardinality, and must not grow into a schema language.

### D11 (prose)

- a's invent-beyond I2, the gloss tier (readings on the line below, carets pointing up; `^~~~~ time` under a prose span) is absent. It died as syntax (A2 −2, editing cost) and the fork kept its standoff half as "worth keeping in any design that ever types prose" as a reader-layer convention. It is the only design in the three spikes that types a span *inside a Markdown paragraph with the paragraph untouched*; one line as a deferred idea.

### D12 (trailing colon)

- "No XML name ends in `:`" should say "no namespace-valid XML name": b's fork R (checked the quote) found plain XML 1.0 `Name` does allow a final `:`, while Namespaces in XML forbids it (`LocalPart ::= NCName`, non-empty). Pathological, but the guide's absolute is one notch too strong.
- a's research-internal fork found a lineage for the colon that bears on Joseph's taste: 2011 DECIDED.md allowed `:` in labels "ala ruby labels", and 2025-12 `!:json:` used a colon-closed label to introduce a body in another notation. The ornament reads, in his own history, as "a label closer before a body". Worth one line since D12 is "beauty only".

### D13

- `∅` for nil (a's invent-beyond I4b and languages N5, "the one glyph here I'd put in front of Joseph") is absent. Under D2(a) bare `nil` is nil, so it is a second spelling; still, it was offered to him by name twice.
- `<[1 2 3]>` (c's Cv.3b, one mark over a list of primitives) is absent; dead under D8(a), but it was c's answer to "numeric arrays are where plumbing hurts most".

---

## 3. An option never adjudicated: the sigil `~name body`

a's coordinator invented I1, `~dur 30s`, `~re/^\d+$/i`, `~money 9.99 USD` (`a/invent/coordinator-inventions.md`) and called it "the strongest thing I've seen in either pass" (A1 9, A2 8 from the Elixir prior, A5 9). In a's composed design it was the fallback accidental "if Joseph's eye blurs `⟪`". a's final-thoughts then compared the `.kind`/`kind(…)` composition only against `⟪…⟫` and withdrew that; `~` was never compared against `name(…)` and never killed. The guide drops it.

The comparison Joseph would want (judgment): both are name-first; `~name` needs no closer for a run body and no stand-alone rule, because `~` before a digit (`~5min`) and `~~` (Markdown strikethrough) are text and `~`+label collides with nothing in prose; `name(…)` needs D4 to be safe and makes a whole-value call to an unknown name an error. The sigil's cost is one more mark character (A8) and that `~` is an error inside bare labels today (free, checked in the labels lean). Its guessability rests on Elixir rather than CSS. This is a live, un-adjudicated alternative to D6 and should be a row there or in the dead table with "not compared".

---

## 4. Dead branches, with reasons (the brief asked for these; the guide has none)

The brief (`BRIEF.md`): "the branch map (dead branches too, with why they died)". `adjudication.md` had one row for this; the guide has zero. A compact table, drawn from the files:

| Branch | Where | Why it died |
|---|---|---|
| First character commits (A) | all three | `920px` an error; `1984 is a novel` splits silently (Joseph's own reason) |
| The old line's whole set bare (B-old, core-M) | all three | every extra member fails parameter-free or host-portable; the old surprises sit inside them |
| Quantity as a bare class (`920px`) | a dp2, c units U2, a I4 | captures `10am`, `3rd`, `1080p`, `401k`; `5m` still ambiguous |
| REBOL-maximal lexical typing | a W4 | B3, A6: the spine becomes a catalog |
| `:name:type` | all three | `xml:lang`, `xlink:href` (C2) |
| Compulsory trailing colon | a, c | changes every attribute; matches no common notation |
| `<…>` carried raw (the card today) | all three | fails B2; can't refuse `<920px>` |
| Standard set else raw (ANG-2) | a angle | can't reject `<920px>`; every number-grammar edge a raw/number boundary |
| KDL `(type)value` | a, b, c | prose starts with `(`; CTQ's own B6 footnote names it |
| EDN `#tag value` | b P7, c glyphs | `#` is colours, ids, hashtags |
| YAML `!tag` | c glyphs | `!` is reserved for directives |
| Suffix `8080u16`, `<…:dt>` | b P3, a angle | it is B by another name; decides late |
| Attached tag `date"…"` | b P8, c glyphs | needs a tag-length bound for B1; `point[…]` looks like an element head |
| Space as head separator `<dt 2026-01-10>` | a angle, c M2s | `<today>`, `<true story>` become notations |
| Pipe as head separator `<u32\|0xff>` | a angle, c M2p, b I4 | `\|` reads as an element; reads as a union in Joseph's algebraic names |
| Unicode brackets `⟨⟩` `⟦⟧` `⟪⟫` | a angle, c bra, a I2/I3, typography I1 | no agent writes them unprompted (A2); `⟨` confusable with `<` to Joseph's eye; worth a three-example panel |
| β-white `date⦅…⦆` | c inventions | unnecessary once D4 holds |
| Emoji sigils | b I6, a I5 | variation selectors make two spellings; wide glyphs break alignment |
| Superscript tags `ᵈᵃᵗᵉ` | b I7, a I5 | NFKC folds them; holes in the alphabet; tokenize badly |
| Undertie `3.2‿kg` | b I5 | "strange and unfinished"; kept for taste |
| `№`, ℕℤℚℝℂ | a I4 | not worth a character; the insight (nominal vs ratio) survives |
| Narrow no-break space as SI binder | a typography I6 | invisible in plain text |
| Gloss tier / standoff carets | a I2 | column-exact writing (A2 −2); editing cost; kept as a reader-layer idea |
| Prime tags `90'min` | c wild W5 | `the 90's` |
| Plain-language dates | c wild W8 | B3, A2 unless opt-in |
| Scheme-colon as a general typing mark (`date:2026-07-21` bare) | a I2 | `localhost:8080`, `C:\tmp` get schemes; kept only as a URL reading |
| Aliases declared in the lite document | a L1 | lite has no declarations; `!` refused |
| Subtree "classify" switch `\|server.typed` | c Cv.3c | a parse-mode directive in disguise |
| δ2 (`$main` never commits at a delimiter) | b 30 | breaks sameline sameness (Joseph 2026-09-29) |
| δ4 (residue after a delimited value is an error) | b 30 | an error on `\|p "Hello," she said.` fails A2 |

---

## 5. "What was measured" and "checked": omissions

- **a's research-external fork is absent from "Checked against sources".** It fetched, on 2026-10-22, XSD 1.1 Part 2, YAML 1.2.2, KDL, EDN, CSS Syntax 3, TOML 1.0, I-JSON, RDF 1.1, ProtoJSON, CUE, UCUM, F#, Elixir, REBOL, StrictYAML, NestedText, Tcl, PyYAML, the Python-3.10 case, the Excel gene-name renaming, jackson's `maxNumberLength`, CPython's 4300-digit cap, and Tom Lane on SQL typed literals (`a/forks/research-external/precedents.md`, sources listed with URLs). The guide's D2 says the host-limit numbers are "quoted from the fork, not re-checked by me"; the fork's own labels say which were fetched. c's README also says its mark fork's web lookups (KDL §3.8, EDN, Elixir, REBOL, CommonMark) "were re-checked by no one", which the guide could carry.
- **a's `instincts.md` is the one pre-registered instinct record** ("written before any fork reported, so the forks' results can't color them"). Joseph said instincts are the better evidence. It isn't cited anywhere in the guide. Its one finding worth his eye: "the attribute name carries most of the meaning I read into a value … a spelling-only classifier is right for the JSON-shaped cases and wrong for the identifier-shaped ones, and I can't tell which case I'm in without the name."
- **The three scripts reproduce** (re-run 2026-10-28, `python3 -I`): a's `f1_check.py` (battery OK; 400,000 fuzz OK; 1,000,011-character run emitted after 1 character, class at close None / integer without the `p`); c's `classify_stream.py` (0 bytes held on a kind-at-close wire; N+1 on a capped kind-first wire); c's `wire_model.py` (as in `wire_model.out.txt`). I did not rebuild c's `holdback-probe.rs` or b's fork S scratch crate; those claims stand on the files.
- The guide's measured list omits that c's `std` fork fetched UCUM 2.2's `ucum-essence.xml` (revision 2024-06-17) and found no `px`, `Cel` for Celsius, and that `RAD`/`REM` are the only three-upper-case terms (its money exception rests on that).

---

## 6. Smaller corrections to the guide's text

- Intro: "the four `final-thoughts.md`" is right (three spikes plus the coordinator). "b's stand-alone page" is `b/30-delimiter-must-stand-alone.md`.
- D2 table (a): "8.20 vs B 7.48 in its scoring" is correct (`a/forks/classification/dp1-where-the-class-lives.md`).
- D4: "b's scoring: guessability and cold comprehension 5→8, XML/HTML 5→9, Markdown 4→9, simplicity 8→7" is correct (`b/30` §Scores).
- D5: "(`.Attributes["dispatch.status.arrival"]`)" is Joseph's, verbatim 1837, correct.
- D6: "c scored it 9" is β-ascii's A2 and A3 (`c/notations/inventions.md` table), correct.
- D8: "ANG-4c, 1250 of 1660" correct; "c's own scores: clarity ~6, simplicity ~4" correct for the synthesis proposal.
- D12: "pruned by a and c" for compulsory is correct; b said "no branch dies here" and leaned ornamental-allowed, which the guide could add.
- "A CTQ question … A5": correct factor; the coordinator's final thoughts wrote "A4's note" (a slip there, not here).
- The verbatim record's 10-21 words on the residue are "I am perfectly fine with sameline attributes closing after the first value closes I think" (line 1430); the guide's "your 2026-10-21 lean on the residue" is a fair gloss.

---

## 7. What I would put to Joseph first, from this audit (judgment)

1. Decide D1 as a node definition (what kind does lite give a carried body) rather than as a law; then faces-open vs faces-closed is the only thing left in it, and it feeds D2's scoring.
2. Put `elem` (zero grammar) and `~name` (never compared) on the table beside `name(…)` before adjudicating D6/D8; otherwise the grammar cost of every design is being judged without its baseline and without its nearest rival.
3. Show the picture twice, with and without a vocabulary, so the A5 question is judged on examples.
4. The pushdown parser has no line cap today; that fact belongs with D3 whatever D2 decides.

*I'm staying on the line for follow-ups. Nothing in the guide was edited; nothing committed.*
