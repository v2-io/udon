# Audit of ADJUDICATION-GUIDE.md (Opus 5.5, 2026-10-28)

*For the guide's author and for Joseph. I read the guide against the spike sources and the cards it cites. Labels: **checked** means I read it at the place named (file, card, `history.jsonl` line, or UCD 18); **inferred** means my reasoning, not something a spike wrote; **taste** means my preference. I edited nothing and committed nothing.*

**What I read whole:** the guide; `BRIEF.md`; `adjudication.md`; `coordinator-final-thoughts.md`; `CTQ-FACTORS.md`; every README, debrief and final-thoughts in a, b and c; a's `synthesis.md`, `notes.md`, `instincts.md`, `composite-set.md`, `invent/README.md`, `invent/coordinator-inventions.md`, and the fork pages `angle/functions-and-the-no-go.md`, `angle/README.md`, `classification/dp1`, `dp3`, `dp8`, `slots/dp10`, `research-internal/README.md`, and the READMEs of `invent-languages` (with `weighing.md`), `invent-typography`, `invent-beyond` and `wildcard`; b's pages `00`, `10`, `20`, `30`, `40`, `50`, `60` and the first half of `fork-S-streaming.md`; c's `00-frame.md`, `composite-examples.md`, the branches `Cv`, `D0`, `Sigma`, `B`, `core/branch`, `core/kinds-and-test`, `core/spelling`, `core/units`, `core/keywords`, `mark/branch`, `mark/m1`, `mark/m3`, `mark/d7`, `mark/glyphs`, and `notations/00-round-two`, `synthesis`, `reader-model`, `inventions`, `wild/design`. I also checked the cards `rule-leftover-values`, `rule-single-quote-escapes`, `rule-nested-attributes`, `rule-fence-default-handler`, `obj-reserve-dont-ignore`, the labels lean (`.int/labels-ascii-and-positions-2026-10-20.md`), the end of `STEWARD-VERBATIM.md`, and `history.jsonl` lines 16173 and 22354.

**What I only skimmed or didn't read:** c's `args`, `std`, `slot` and `elem` designs (I read their rules, verdicts and near-miss tables only); c's `raw`, `combo`, `bra`, `core/renderings`, `mark/m2`, `checks/`; b's `fork-P` and `fork-R`; a's `ang-4c`, `other-branches`, `dp2`, `dp6`, `dp7`, `dp9`, `w1`–`w4`, `n1`, `n2-n6`, the `i*` invention pages, and `research-external`. A finding could hide there, especially in c's `combo` and `std` and in b's `fork-P`.

The findings are in rough order of how much they would change a decision.

---

## 1. Findings that change what Joseph would be deciding

### 1.1 The page's centerpiece date example claims more than the sources agree on

The guide's first example and D5 both show:

```udon
|ev :when.date(YY-MM-DD) 27-03-05
```
````tree
:when (.date(⸨YY-MM-DD⸩)) ⸨27-03-05⸩   ⇒ 2027-03-05
````

`YY` doesn't say which century. Spike b is explicit that a two-digit year needs a pivot, or "a document's meaning changes with the clock, as REBOL's two-digit years do", which fails B3 (b/40, b/50 "Two-digit years and format parameters"; fork R checked REBOL). b's own final design writes `:on.date(YY-MM-DD pivot 1950) 27-03-05`. Spike a's final-thoughts says "the parameter fixes the century", and c's `reader-model.md` says something similar ("YY fixes a century"). So two spikes assert 2027 with no pivot, and one argues that is unstable. The guide shows a's form with no sign that it is contested. Since this line is the one a's final-thoughts calls "the most beautiful single line any of the three spikes produced", I'd show the pivot (or b's objection) right beside it.

### 1.2 Do the items inside a constructor get faces? The guide does it both ways

In D6's tree, `rational(complex(⸨3⸩~int ⸨-7⸩~int) ⸨2⸩~int)` gives the items faces, while `qty(⸨3.2⸩ ⸨kg⸩)` in the same tree doesn't give `3.2` one. The sources disagree:

- a's final-thoughts gives items the class (`complex(⸨3⸩#integer …)`).
- b's page 50, rule 3, says: "The items get no default reading. The notation is their slot, and only it reads them." b's K trees agree (`call int [‹0xFF›]`, `literal complex [‹3› ‹-7›]`).

This is a real decision, and it belongs in D6:

```udon
|m :z rational(1 3) :mask int(0xFF) :n qty(1e10 kg)
```

- **Items faced (a):** `1` and `3` carry `~int`. `0xFF` gets no face (it isn't JSON), and `1e10` gets `~float`. A generic converter that meets an unknown notation still finds typed items. But the notation and the face may disagree about what an item is.
- **Items unfaced (b):** every item is a plain text. The notation is the only thing that reads them, which is more consistent with "the notation is the item's slot". A reader that doesn't know the notation sees only texts.

### 1.3 Can a reading on the name withhold a face that the tree carries?

The first example shows `:version (.text) ⸨1.10⸩ ⇒ the text 1.10, face withheld`. Under D2(a), though, the face is in the tree, attached by every parser. A face can only be withheld if the parser *interprets the reading name* `text`, and that is a reading lite has started evaluating. The sources split:

- a: "`:version ⸨1.10⸩ .text` ← the reading replaces the primitive face" (a's final-thoughts §2).
- c: the face stays and the reading sits beside it: `:mass ‹3.2›~float (kg)` (c's final-thoughts §3).

So D2(a) and D5 are coupled in a way the guide doesn't show. Either (i) the tree keeps `~float` and the reading overrides it at read time, so the tree holds a face the writer explicitly refused; or (ii) lite's parser knows a closed set of readings that suppress faces (at least `text`). With D2(b), a normative reading and no face in the tree, the problem doesn't arise. That counts for (b) over (a), and the guide doesn't count it.

### 1.4 c's unified rule and b's stand-alone rule give different trees for quoted values, and the opening example shows b's

The guide calls c's sentence ("every sameline value is a run, and a closed form standing alone … gives it a face") the most important structural result, and says it "absorbs D2, D4 and D6". But its opening tree draws `:name "8080"` as a string, which is b's form. The two forms differ:

```udon
|p "To be, or not to be."
|el :name "8080" :q "a\"b"
```

- **b (δ3):** `$main` is the string `To be, or not to be.`, with the quote marks as delimiters and the form kept in «meta». Any consumer that reads the value rather than its form (a JSON export, a text reading, an agent's getter) loses the quotation marks from a whole-line quotation. That is the same "speech without its quotes" loss δ3 was invented to fix, now in the whole-line case.
- **c (run with a face):** the text is `"To be, or not to be."` with its quotes, plus a string face. Nothing is lost. But the text of `:q` is then either the raw spelling `"a\"b"`, escapes unprocessed, or something else. And D2's open question ("which face does a generic converter pick?") now applies to every quoted value too. If the default is the text face (c's Cv lean, which predates the unified rule), `:name "8080"` would export to JSON as `"\"8080\""` (inferred; no spike worked this combination).

So D4 hides a decision: is a quoted value a string, or a text with a string face? I'd add it to D4 with this example.

### 1.5 Constructors and backticks reach headings and list items, and standard names collide silently

D6 treats the one remaining collision as "a whole value that is exactly a call to an unknown name: an error that teaches", with `printf` as the example. But `$main` is an attribute value, so any element whose whole sameline text is `name(…)` becomes a constructor. In API documentation that is common:

```udon
|h3 parse()
|h3 date(format)
|li int(x) truncates
|td SUM(A1:A9)
```

- `parse()` and `SUM(…)` are errors that teach (loud). The cost is a C2/C3 tax on API docs and spreadsheets, larger than the guide's "almost never" suggests.
- `|h3 date(format)` is worse. `date` is a standard name, so the heading becomes a date value with the body `format`. Under D6.3's read-time option that heading is **silently** a carried bad date in the tree. Under parse-time checking it is an error on a perfectly ordinary heading. The same goes for any code identifier that matches a standard name (`int`, `re`, `time`, `range`, `url`).
- Backticks do the same. b's page 60 already notes it: a `$main` that is one whole code span (`|li `npm install``, `|h3 `parse()``) becomes a raw value, with its form kept so a Markdown renderer can restore it.

This is D2's "is prose ever faced?" question extended to constructors and backticks. I'd put it in D6, perhaps with the option of exempting `$main` from constructor recognition, and its cost (`|li date(2026-10-01)` would then be text).

### 1.6 Keys are not converged

D2 says "`|step[3]` gets `⸨3⸩~int`", and D13 says keys "get faces by the same rule". **b disagrees explicitly:** "Keys: designed. A key gets **no** default reading. A key is an identity, compared by spelling" (b/50 §4; b/10 §7; b's README branch map: "keys | no default reading; identity by spelling"). c's Cv fork also leaves keys as texts, while c's B fork types them. Only a classifies keys. This should be listed as open, with b's reason.

### 1.7 D2 is missing a live option, and (c) is drawn more weakly than its own advocate drew it

The table offers (a) attached face, (b) normative reading, (c) "the view, default open", and (d) B. **Missing is "bare is text, and a generic converter emits strings unless asked to classify"**, which c's Cv fork proposed and c's README lists as "**survives**". Its own scores (`c/branches/Cv/branch.md`): A6 9, A7 9, B3 9 (it argues one tree holds, with differing readings living outside the tree), B5 9 ("bare runs are never classified"), C2 8 ("XML attribute values are all strings, typed by the schema: Cv is XML's model"), C10 9, and no `1.10` or `01234` trap anywhere. Its costs are C1 5 and A2 5.

The guide says `:debug false` "is what sank (c) in all three spikes" and that "(c) wins only on A7 simplicity". The first holds for a's and b's spikes and for c's final-thoughts, but not for c's round one. The second understates the option: the factors where it wins are B5, A6, C2 and the zero-trap property, and A7. `:debug false` is still probably decisive. But Joseph reverted to C on 10-21 for reasons of his own, and he should see the strongest version of it. c's Σ page usefully lays the whole dial out as four settings: faces in the tree (B), std as converters' default (Σ), std opt-in (Cv), and no std at all (D0).

### 1.8 "The hazard no spelling rule fixes" has more remedies than the guide lists

D2 offers quotes, a vocabulary, or a reading for `:version 1.10` and `:id 1e10`. The spikes found others:

- **No float faces at all** (c's core fork, "floats-in-view (ii)", marked "alive, Joseph's call"): integers, `true`, `false` and `nil` get faces, and floats don't. This removes both `1.10` and `1e10` as hazards. The cost is that `:ratio 0.5` is a text to a schema-less reader. It is a spelling rule, so "no spelling rule fixes it" is too strong.
- **No exponent faces** (a's dp3, "G-e"): this fixes `1e10`, and also `12e4567`, which is a valid JSON number that overflows binary64 to infinity.
- **Copy the original token** into JSON (a's dp3, "G-copy").
- **A default-off lint** for decimals that end in `0` (a's dp3).

### 1.9 The face set's boundary: what JSON-only drops, against Joseph's own recorded wants

The guide states the JSON number grammar as converged. All three final-thoughts do land there, but c's core fork recommended "JSON's set + TOML-style integer spellings, strict" (`0x`, `0o`, `0b`, `_` between digits, `+`), using a different test: no *lossy* silent miss (`c/branches/core/kinds-and-test.md`). b's test was "lossless in every host", which excludes `0xFF` and `1_000`. The two tests give different sets, and the guide shows neither.

Joseph's own words, **checked** at `history.jsonl` L16173 (2026-07-14): "0x 0o 0d 0b *definitely* help as literal qualifiers, as does '_' agnostic digit separators, as does scientific notation shorthands-- all work to allow the udon reflect the literal value without the agent/user needing to translate it from a natural representation". Under the converged set, bare `0xFF` and `1_000_000` are texts. The guide doesn't say that, and doesn't say where they go now (b's K: `int(0xFF)`). D13's line "`-0xFF`, `+1`, `.5`: text under the JSON grammar" covers the edge cases but not the cases he actually named.

### 1.10 D5's `.kind`: who invented it, the objection still unanswered, and what it needs from D6.2

- **"b invented it" isn't quite right.** All three had it in round one. a's wildcard W2 killed `:port.u16` on stacking, and a's slots fork scored `:name.type` 6.0. c's mark fork kept `:when.date` alive (M3) but scored its generative guessability 5 for a **silent** miss: a TOML- or Spring-trained writer's `|config :server.port 8080` meaning `{server: {port: 8080}}` (`c/branches/mark/m3-attribute-traits.md`). b's contribution was the per-occurrence reframing, which answers a's objection. **c's objection was never answered by a spike.** Joseph's "affordance" remark answers it for `:mass.kg`, where the nested reading and the kind reading coincide. He added his own caveat: "other contexts where the vocabulary was more foreign and random might cause a different inference" (verbatim, line 1835).
- **Whether the miss is silent depends on D6.2's name policy, carried over to readings.** b's page 60 makes every unprefixed reading name a registry lookup: "Unknown unprefixed kinds are errors with 'did you mean'; namespaced kinds (`.acme/sku`) are carried". It also says "The registry is now load-bearing for errors: every unprefixed attribute trait must be in it. That is a spec appendix that grows by version", and that includes unit codes. Under that policy `:server.port` is an error that teaches, unless `port` is registered. Under c's resolution through vocabularies in scope, it may be silent. D5 should carry D6.2's question explicitly, along with its cost: a registry of reading and unit names in lite's spec.
- **"Mirrors `|user.admin`" overstates the symmetry.** b pushed this and found the limit (b/60 "Limits found by pushing it"): element traits must stay free words, because a registered kind on an element would let "a user's own trait named `date` type their text by accident". So `.` would mean a free word on elements and a registered kind (or an error) on attributes.
- **The framing "your 'what the slot is' made visible per occurrence"** inverts b's finding. b/20 §1: "a slot type, to be one, has to be stated once and range over occurrences". A reading on one occurrence is a claim about the literal, "accidental, written on the staff" in b's K table. The slot-type side is the signature or vocabulary.

### 1.11 "Attributes can't nest, so `.` can only mean its kind" treats reserved as never

D5's facts repeat a coordinator claim from the verbatim record (line 1838). [[rule:nested-attributes]] makes nested attributes an error because they are **reserved**: "Keep the construction free for later use" (its Drivers). 0.10.0 had an open grouping sugar (ATTR-GROUP). Dotted-path nesting is the obvious later meaning for `:server.port`. Two spikes kept `.` an error on purpose:

- c's slot design, so that `:server.port 8080` gives "attributes don't nest by dots; write `:server` with `:port` on the lines below";
- a's dp10 R6, which lists `:name<…>`, `:name(…)` and `:name[…]` as spellings to keep as errors for a later in-document declaration.

So both D5 spellings spend B6 headroom that was being held: `.` spends the nesting sugar and its error that teaches, and `(…)` spends R6's slot. They may be worth spending. But the guide's line "widen an error and change no accepted tree" is only the B2 half of the account, not the B6 half.

### 1.12 The `(…)` role-swap finding is stronger than stated: under D6's rules the signature doesn't parse

The guide's own finding is that `[mass(kg) temp(°C)]` and `[qty(3.2 kg) date(…)]` swap roles. Under D4 and D6 as the guide states them, each item in `:$sig [mass(kg) temp(°C)]` stands alone in a list, so it **is** a constructor value named `mass`. Under D6.2 an unknown unprefixed name is an error. So the coordinator's one-spelling signature is a parse error, unless `$sig`'s items are exempted from constructor recognition, which would be an exception keyed to an attribute's name. b's `[mass.kg temp.degC]` has no such problem: those are plain runs.

### 1.13 D1 leaves out Joseph's own reason for B2, and may partly dissolve under D6.2

**Checked** in [[obj:reserve-dont-ignore]], Grounds: "older 0.9 and 0.10 specs in udon (not lite) also deferred decisions about special syntaxes … but retained the bytes. That ambiguity caused a lot of confusion and made the language evolve a lot slower for a season-- hence the very deliberate call right now in udon-lite to go further and disallow them completely" (2026-10-01). That is the strongest consideration against D1(a) and (b), and it is in his words. It belongs in D1's facts, next to the fence precedent.

**A reframe, inferred (no spike wrote this):** split carried names by *who defines them*.

- Under the EDN policy b proposed and a adopted, an unprefixed name belongs to UDON, and lite refuses it until UDON defines it. That is B2 working as designed: an error becomes an accepted value later, and no accepted tree changes.
- A namespaced name (`acme/sku(…)`) belongs to its owner, never to UDON. Element names and fence languages work the same way: lite never interprets `|invoice` or a fence named `sh`, and no later UDON will. Carrying such a value isn't "retaining the bytes for a later UDON".

If that holds, D1 shrinks to two questions: can faces grow (c's sentence), and can body checks tighten later (below). That is smaller than "everything else depends on it".

**Two interactions the guide doesn't show:**

- **D1 × D6.3.** If standard bodies are checked only at read time in 0.1, then adding parse-time checks later turns accepted documents (`date(2026-13-45)`) into errors. That is a change in the B2 sense, so D6.3 is effectively decided by D1.
- **D1 × D2.** a's dp1 gave two reasons for (a) over (d): identity by spelling, and "Cc can grow, B can't". D1(b) ("faces never grow") gives up the second, so under D1(b), (a) over (d) rests on identity by spelling alone.

### 1.14 The reversibility asymmetry is missing, and it isn't "defer"

c's mark fork (`mark/branch.md`, "What they leave out is reversibility") and its d7 page argue an order of commitment rather than a deferral. Going from an error to an accepted spelling changes no tree. Going back breaks documents. On that ground the mark fork recommended shipping 0.1 with the designed forms as *errors that teach*, and enabling them when wanted. Joseph rejected "reserved for later" as a substitute for *designing*. This is different: every design here is complete, and the only question is which designed pieces 0.1 accepts. It bears on D5, D7, D9 and D12 (c's T4 for the colon is this argument). I'd give it a paragraph, because it is the principled form of the coordinator's own "minimal lite 0.1" (coordinator §4), which the guide doesn't carry either.

---

## 2. Misrenderings and attributions

- **`@<people/jw>` is Joseph's own spelling, not c's proposal.** **Checked**, `history.jsonl` L22354 (2026-10-11): "@{ref} is an immediate dereference. @<ref> is a reference, as a value in udon, which also serves as an inline mention." c's raw design and synthesis credit him with the idea ("reference kept as a reference"), but the guide's wording makes the spelling c's. It also survives D8(a), because `@<` is not a value-initial `<`.
- **D8(a)'s row lists a's final as "retired".** a's final is softer: "`<…>` becomes free for c's typeset shapes if Joseph wants them, or it can be given back to full UDON", and its recommendation includes "c's typeset `<…>` shapes, if Joseph wants printed quantities in 0.1".
- **D8(c)'s examples include `<css:920px>`.** c's final-thoughts §8 drops named `<scheme:…>` values for constructors: "keep `<scheme:…>` only for URIs".
- **D5's unit-symbol argument:** `µ` (U+00B5, category Ll) and `Ω` (U+03A9, category Lu) **are** letters (**checked**, UCD 18), so they fit any XID-based label. The argument holds for `°`, `%`, `²` and `/`. One related trap: MICRO SIGN U+00B5 and GREEK SMALL LETTER MU U+03BC look identical and fold together only under NFKC, so with the labels lean's byte equality, `:len.µm` and `:len.μm` are different readings.
- **D3's "spike a asks whether labels need a maximum length (say 64)".** c's `std` design already spelled a 64-character cap on notation names, and caps on fractions and zone names as well.
- **D7 shows only the tagged spelling `` re`…` ``.** a's final-thoughts puts the reading on the name instead: ``:pattern.re `^\d{3}-\d{4}$` ``. Both should appear.
- **D6.1 says a regex with spaces "can't be a body; it goes in backticks".** Under an items body it *can* be written, and goes wrong silently. c's args prototype found exactly this: "`<re a  b>`: two text arguments; the double space is ornament … **silent** when the notation joins its arguments. The one silent miss this design has" (`c/notations/args/design.md`, near-miss table). The miss is only caught if the notation's signature refuses more than one item.
- **D11: "costs lite nothing".** True of lite. But any Markdown renderer turns `[Oct 1st](date:2026-10-01)` into `<a href="date:2026-10-01">`, which is a dead or blocked link for a human reader of the rendered page. C3 (Markdown stays Markdown) cuts both ways here. D11 also leaves out c's `<{2026-10-15}>` value embed in prose, which c's own mark fork said must stay reserved: a contradiction inside c worth a line.

---

## 3. Options and dead branches whose reasons deserve to be seen

- **Sigils.** Joseph's creativity note asked for exactly this, by name ("elixir-like sigils, but made more beautiful"), and the guide never shows the family or why it lost:
  - a's I1, `:timeout ~dur 30s` and `~re/…/i`, which a's coordinator called "the strongest thing I've seen in either pass" when it wrote it;
  - c's mark fork kept `~name[…]` on file as "the only candidate that removes [the `<` collision] without a new cost elsewhere";
  - b framed `.kind` as "the sigil idea, made beautiful by moving it off the value".

  That lineage is short to show and answers his prompt directly. Related: the guide's tree glyph `~int` reuses the very character a proposed as source syntax (`~int 8080`), and Joseph reads trees by eye. Another mark (such as `⁝int`, or a's `#integer`) would avoid the confusion.
- **The things a reader needs that sit next to D10:**
  - b's precedence among readings: occurrence, then signature, then vocabulary, then the default;
  - the slot-against-literal conflict: a literal's reading is *checked* against the slot, not coerced. c's reader-model and b/50 agree, with the example `<instant …>` in a `date` slot;
  - b's question "which way does a writer go?". With four or five places a reading can sit, a serializer or formatter needs a canonical choice ("write the least plumbing that reads back identically"), or round trips aren't stable (B3, C10).

  The guide carries only the precedence between signature and legend, and hoisting.
- **Streaming, the part that is actually open.** b's fork S: the 0.9 pushdown parser holds *every* long value whole and has no cap; only the recursive wrapper caps a line, at 4 KB. "The real streaming question is whether the wire emits content in fragments or caps the line", and that is independent of typing. D3 reads "the parser already held every value" as clearing the options. It also means B1, as Joseph meant it ("buffer essentially unlimited amount"), isn't met by any lite construct today. That is its own decision.
- **B5 parse speed never appears**, although Joseph weights it 9 and wrote the longest footnote in the CTQ list for it. Face classification is nearly free (a's DFA), but parse-time body checks (b's D6.3 lean, which carries each standard notation's grammar, calendar validation included) and c's typeset grammar inside the bracket both cost throughput. That should be weighed in D6.3 and D9.
- **D7: carrying a body unread costs B4.** a's languages fork names this as tagged code values' "real loss": "a mistyped insisted-on number is caught only by a reader". It is the same parse-or-read question as D6.3, and the same answer should apply to both.
- **D6.2:** c's wild page W7 (content-addressed notation names: a lockfile pins `date` to the hash of its definition) answers b's objection that resolving names through scope lets one document mean two things. It should sit next to b's critique.
- **Durations disagree on `m`.** c's `std/duration` reads `5m` as minutes; b's registry makes a lone `m` an error ("`mo` or `min`?"). This matters if `duration` is a standard name.
- **Smaller dead ends worth a line each:**
  - a's trailing `0xff<u64>` (invent-beyond I1: "words never take one, so `Vec<u8>` stays text"), killed in effect by D4 plus D8(a);
  - a's element trait as a clef, `|server.inet :port ssh` (languages N4), and b's σ4 `|server.v2`, as a fourth region-wide reading for D10;
  - c's padded delimiters `<#re:a>b#>` (W4), which backticks of length *n* now cover.

---

## 4. Framing

- **The picture in one screen primes the reader.** It shows the composition with D5 and D6 marked as disputed, but not the contested items above: the pivot (1.1), face-withholding by `.text` (1.3), the quoted-value form (1.4), keys (1.6). Joseph will take the picture as the baseline. Either mark those items too, or keep the picture to what really converged.
- **What it is built from.** The guide rests mostly on final-thoughts files, which are cross-read syntheses written by one model, and by its own note that means shared priors. The first-round branch pages are where the dead branches and their reasons live, and where most of section 3 came from. The guide's honesty note says it didn't read the fork pages. I'd add that the converged list means "converged in the final-thoughts", which is weaker than converged in the work: the face set (1.9), keys (1.6) and Cv (1.7) all show disagreement underneath it.
- **D1 first, "everything else depends on it".** If 1.13's split by owner holds, D1 is narrower, and D6.2 (who owns a name) comes first. That's my inference, and Joseph may see it otherwise.

## 5. Smaller

- The "measured" list leaves out c's args prototype (`nargs.py`; every raw tree on its page is the prototype's output), c's `std/discriminate.py` model of where each interior's class is decided, and a's `gloss.py` (caret columns). b also checked RFC 8259, Namespaces in XML, RFC 9557 and YAML 1.2.2. c's mark fork read KDL, EDN, Elixir, REBOL and CommonMark itself, and c marks those readings "re-checked by no one".
- D2's "spike c's final word folds them". c's final also makes faces closed for good, which rules out a's argument that classes can be added later (see 1.13).
- D12: c's d7 page also notes that the trailing colon "invites the colon-*less* `host: localhost`", which [[rule:main-label-colon-warns]] already catches. That is a small point for the ornament.

## On the brief

The brief left the audit open, and that was what let most of section 1 surface: none of it was on any list I had. One thing that would have saved time is a line saying which files the guide had read *whole*. I spent a while confirming that the D2 table came from the debriefs rather than from Cv's own page. Nothing else to add. I'm staying on the line for follow-ups.
