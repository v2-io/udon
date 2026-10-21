# Impact review: [[rule:unquoted-run-is-one-value]] against the store (2026-10-21)

*Reviewer: a fresh Opus 5.5 agent, launched by the coordinator of session `014uHM6yNW767ksMmVtWt7Sn` at Joseph's request: "write it up as a card and have a fresh agent look for any inconsistencies between that rule and everything else including verbatim statements and leans etc.-- in order for us to know what the impact radius is." For Joseph and the coordinator. I edited no card. What I read, and what I didn't, is at the end. Trees use the cards' current notation (`‹…›` a «text», `"…"` a «string»).*

## The short version

The rule fits most of what is decided, and some of the record supports it directly. The places it touches fall into four groups:

1. **Three conflicts inside the card's own Statement**, each with a decided card:
   - an empty run would make `:a` an empty text, where [[rule:missing-value]] makes it an error;
   - clause 3 ("nothing further on that line") collides with stacking after a framed ` \ `;
   - "the same value rules" would carry the run's end (a start) into keys.

   Each needs a sentence, not a redesign (§1).
2. **Two open questions the card settles without saying so.**
   - **Bare `hello` is a «text», not a string.** That is the open value-model question. Joseph's 2026-10-20 sketch, the AST sketch and the last handoff all lean the other way.
   - **The word "run".** Joseph objected to it by name on 2026-10-21, and [[def:text]] defines «run» as something that never holds an embed (§2).
3. **Tensions with his earlier words**, for him to weigh rather than for an agent to resolve:
   - his 2026-10-09 picture of escapes, in which a leading digit commits the kind;
   - a 2026-07-15 remark about "unlimited lookahead";
   - his 2025-12-31 line contrasting UDON with YAML's "value-peeking";
   - his 2026-10-09 "the element's own line is typed: to discuss" (§3).
4. **New edge behavior the rule creates.**
   - Because the whole run decides the kind, an invisible trailing tab or no-break space can turn `8080` into a «text».
   - So can an inline comment written into the value (§4).

The edit radius, if the rule is adopted, is about a dozen cards plus the PEG (§5). §6 has five composite examples for Joseph.

---

## 0. Where it is consistent, and what supports it

I checked these and found no conflict. I list them so the radius is visible from both sides.

- **Where a run ends** is [[rule:text-value-end]]'s list: ` |name`, ` :name`, a fence after a space, a framed ` ; `, a framed ` \ `, end of line, and the reserved starts from its working notes. It ends nowhere new.
- **The cards that rest on that list still draw the same trees:**
  - [[rule:space-before-text-end]]: `:c one  two \ more` gives `‹one  two›`;
  - [[rule:framed-backslash-frame]]: `|nav :aria-label Site |a :href / \ Home`;
  - [[rule:embeds-in-text]] and [[rule:space-between-embeds]];
  - [[rule:element-after-attribute-with-no-value]] and [[rule:sameline-element-is-child]];
  - [[rule:fence-anywhere-structure]];
  - [[rule:reserved-spellings]]: `:by @alice` is the reserved error, and `:by me @alice` ends the run at ` @alice`.
- **[[rule:nil-spelling]]**: "`nil` standing alone as a value" is now precisely "the whole run is `nil`". Under the rule, `:a null pointer` gets no warning, since `nil pointer` wouldn't be nil either.
- **The tab rule.** Joseph's tab rule exempts "the $main text or final attribute's value" ([[rule:column-shifting-whitespace-error]]), and a run is exactly that.
- **[[obj:represent-structured-data]]**: `:port 8080` is still an integer.
- **The record supports the "whole run" boundary in several places:**
  - Joseph, 2026-08-08: "attributes are assumed to be a typed scalar until proven otherwise, whereas element body parts are assumed to be prose unless proven otherwise" ([[def:prose]] working notes). The rule reads as a precise version of "until proven otherwise".
  - Pre-design 72 records a 2026-07-15 ruling, via the 0.9 CHANGELOG, so secondary: "no keyword carve-out (`:alpha true story` → `"true story"`) — a keyword is typed only when it stands alone". It also records 0.10.0's "a committed token that goes wrong mid-way (`12ab`) falls through … to an ordinary text token". Its edge table marks both `true story` and `12ab` as text, "settled".
  - Pre-design 73 already had this as its option C for the element's line: "text, except when the whole rest of the line is exactly one typed token" (`|n 3 apples` → text).
  - [[prin:simplest-grammar-without-surprise]] quotes him, 2026-08-09: "emoticons in the $main attribute text and forgetting to escape … so unlikely compared to how often we'll want multiple attributes on the same line". That favors runs ending at starts, which the rule keeps.

---

## 1. Conflicts inside the Statement

### 1.1 An empty run: `:a` alone, and every bare element

Clause 1 says that where a value is expected and the material doesn't begin with a delimiter or a start, the value MUST be the run up to the first end. Read literally, empty material qualifies, because it begins with neither:

```udon
|el :a
|el
```

- **`|el :a`**: clause 1 gives `a` an empty run, so an empty «text». [[rule:missing-value]] (decided, his message wording) makes it an error naming `nil`, `''` and `\`.
- **`|el`**: if `$main` "expects a value" after the head, every bare element gets `:$main ‹›`. The de novo audit found the PEG doing the equivalent (an empty prose child after every element line, finding 12 there).

[[rule:backslash-empty-text]]'s `:a \` is the one empty run the cards want.

*What would fix it:* clause 1 applies only when material is present, and a run ended by a framed ` \ ` before any character is the empty text.

### 1.2 Clause 3 and the framed backslash

Clause 3: "Since the run reaches the next start, the attribute (or `$main`) that took it has nothing further on that line." The premise is false when the run ends at a framed ` \ `, because then more material follows on the line. Three lines show the collision:

```udon
|el
  :x one \ two
|el one \ two
|p \ tail
```

- **[[rule:leftover-values]] (decided).** On an attribute's own line a further value stacks: `x ‹one›`, `x ‹two›`. On an element's line it is another `$main` value: `$main ‹one›`, `$main ‹two›`. [[def:main]]: `$main` "stacks like any other".
- **Clause 3 as written.** Neither attribute (nor `$main`) may take anything further, so `two` and `tail` have no home.
- **Joseph, 2026-10-21**, on the framed backslash: "we've used that in the past to close out a text -- not necessarily a value (although that would follow) -- but not necessarily the whole attribute". In the same message: "it might need to be one of the nuance of sameline attribute values that if they are multiple they need to be in indented children blocks". That suggests a third reading: `:x one \ two` is an error, or `two` must go below.

`|p \ tail` is the de novo audit's open probe 4.3. The card doesn't settle it, and clause 3 makes it worse.

*What would fix it:* clause 3 speaks only of a run ended by a start or the end of the line. What follows a framed ` \ ` is left to the residue question (the card's first working note), and that question is widened to say so. The residue is then two cases, not one: a self-ending value followed by bare material, and anything after a framed ` \ `.

### 1.3 Keys, and lists

- **Keys.** [[rule:key-holds-a-value]] (decided): "The inside of a key … MUST be read by the same value rules as an attribute value." Clause 1 ends a run at "a space followed by a start". Together they would make `|x[a :b c]` open an attribute inside a key. The PEG's `key-text` ends only at `]` or an embed. So keys need their own end, and the card's open note (`[1 z]`) is really "the run rule applies inside a key except its end, which is `]`". [[rule:inline-element-value-end]] already does the analogous thing for `|{…}`: it ends where it would on a line, or at `}`.
- **Lists.** Joseph: "arrays are their own thing completely-- multiple whitespace delimited values" ([[rule:list-items-whitespace-separated]]). So `:tags 7 apples` is `‹7 apples›`, while `:tags [7 apples]` is `[7 ‹apples›]`. That is fine, but clause 1's scope ("On an element's or attribute's line, where a value is expected") doesn't exclude list items. A list sits on the line, and its items are values.

*What would fix it:* the Statement says it governs the value after an attribute and the element's `$main`. Keys apply it with `]` as the end; list items are separated by whitespace.

### 1.4 The same boundary, stated twice in two vocabularies

Clause 1 re-states [[rule:text-value-end]]'s list as "a space followed by a start". «start» has no definition card. It is Joseph's July word ("special starts"), used in the railroad and PEG files, and [[def:marker]] is the card for the same idea. The two statements can drift. Joseph's own 2026-10-21 lookahead, `('|' / ':' / ';' / '@' / '!' / '```') !'{'`, has no right-hand frame on `;`. Read that way, `:a x ;y` ends the run at `;y`, while text-value-end needs a framed ` ; `. The card's Implications do say framed ` ; `, so the intent matches text-value-end. It is the Statement's wording that is open to the other reading.

*Option:* the card cites text-value-end for the extent and keeps only what is new: one value, and typing by the whole run.

---

## 2. Open questions the card settles without saying so

### 2.1 "otherwise it is a «text»": the bare-string question

Clause 2 makes every run that doesn't wholly spell a primitive a «text». That is the value model's open question, and the store has it marked OPEN on both sides:

| Where | Bare `hello` (no embed) |
|---|---|
| Joseph's 2026-10-20 sketch | `:b <hello>::string.bare`; his list of primitives "nil, true, false, numerics, delimited-string, bare-string" |
| `.int/ast-sketch-2026-10-20.rs` | a String with form `Bare` ("follows his sketch") |
| `.int/HANDOFF-2026-10-20.md`, the agents' lean | "Bare `hello` and `"hello"` are both strings, differing only in form"; a «text» only for mixed content |
| the cards, [[def:text]] | a one-piece «text» |
| the PEG and railroad files | "OPEN: … a string of form bare … or a one-piece text" |

Joseph's restatement doesn't decide it: "scan until one of the block-start sequences and then parse that as the value". The «text» is in the agent's precision, and his "OK-- write it up" came after those precisions, so it can be read as accepting them. I can't tell from the record whether he meant to settle the string/text question with it.

The card also writes «text» as a settled term. On 2026-10-20/21 he called that out: "the fact that you're acting as if <<text>> is defined, when it has not been discussed yet". [[def:text]] is `provisional` and not reviewed.

*What would keep the card neutral:* "otherwise it is not typed by its spelling (a bare string or a «text», per the open value-model question)". The question then gets asked once, where it belongs.

### 2.2 "run"

The card's title, slug and Statement are built on "unquoted run", and that run contains embeds ("An embed inside the run is a piece of it"). Three things in the store pull against it:

- **[[def:text]]** defines «run» as "a stretch of characters in a «text», between «embed»s". That run never contains an embed. Its Avoid list names this exact sense: "the 2026-09-29 lexicon's 'a text run' (a whole unquoted value). Those are a «text», not a «run»." It also flags "run" as a verb all over the cards.
- **Joseph, 2026-10-21**: "You are introducing a lot of ambiguous and/or overlapping alternative terms, in fact-- like "run" and no definition of "prose" as we had planned".
- **The same session's response** dropped "run" and renamed the PEG rule `run` to `bare-string`.

So the card reintroduces, as its organizing noun, the word he objected to that day. It does so in a third sense: neither def-text's «run» nor the PEG's bare-string, which excludes embeds. His own word for this stretch is "limited prose" (2026-10-21), or no noun at all ("when expecting a value and there is no explicit delimiter … scan until …").

---

## 3. Tensions with his earlier words

These are for Joseph to weigh. I don't think an agent should resolve any of them by inference.

### 3.1 Does the first character commit the kind?

- **2026-10-09** (his escape answer, now [[rule:value-line-escapes]]'s grounds): escapes are known where they escape "what would otherwise be a type differentiator (number, quote, <, etc.) or what would otherwise be a block beginning (:,|,;) so that it starts some text instead." This treats a leading digit like a leading quote: it decides the kind unless escaped. The PEG reviewer read it that way and leaned "commit on the first character … `7apples` is an error" (`.int/peg-review-2026-10-21.md` §9 Q4).
- **2026-07-15**, excerpted in `.int/principles-survey-2026-10-01.md` §5: "generally our scalars are typed by the initial digit (hence 0x... 0d....)" … "the one here would need potentially unlimited lookahead to know it should be text." The full message (`history.jsonl` L16328) is outside the store, so I can't say what "the one here" was. If it was a rule of this shape, it is a direct objection.
- **The other side, same period:** the 2026-07-15 "no keyword carve-out" ruling, 0.10.0's `12ab` falling through to text, and his 2026-08-08 "typed scalar until proven otherwise" (§0).

The rule keeps first-character commitment for `"`, `'`, `<`, `[` and the starts, and drops it for digits and signs. Whether that split matches his intent is the question. §6 Q1 puts it as examples.

### 3.2 The YAML line

[[obj:represent-structured-data]] quotes him, 2025-12-31: "one of the main differentiators for UDON is the fact that it parses values instead of string+value-peeking like yaml has always done..."

Mechanically, the rule is YAML's plain-scalar resolution: scan the unquoted scalar to its end, then type it if the whole of it matches one of a fixed set of patterns. What still separates lite from YAML is the frozen, tiny set (no `yes`/`no`/`on`, no dates, no implicit octal). The store reads his line as being about the set ("what keeps `Norway` from becoming `false`"). If he meant the mechanism, this rule is the thing he was contrasting UDON against. The quote ends in "...", and the rest isn't in the store.

### 3.3 The element's own line

Agent observation (3) on 2026-10-09 listed "the element's own line being typed (`|q "hello," she said`)" among things with no card. Joseph answered: "the element's own line is typed: to discuss." The cards already type it ([[rule:line-scan]], [[rule:leftover-values]], [[def:main]]). The rule extends that. Under it:

- `|price 42` → `$main 42`
- `|h2 1984` → `$main 1984`, a number
- `|td 3.50 USD` → `‹3.50 USD›`
- `|li 3 apples` → `‹3 apples›`

That is coherent, and better than first-word typing for prose. But it still commits on a question he marked open, and it matters for [[obj:represent-xml-html]], where an element's text is always text.

### 3.4 Streaming

When a run starts with a digit, a sign or a keyword, a streaming parser can't emit it as a number or as text until the run ends. That can be the end of the line.

- This is buffering, not backtracking: the run has to be scanned to its end anyway.
- Lite is specified as a tree ([[decision:ast-centric]]), so this binds nothing today.
- But pre-design 91 (whether lite keeps 0.10.0's bounded-lookahead law) is open.
- `obj.future/candidates.md` notes that lite documents "must parse identically under full UDON's streaming parser", so this "may come back as a lite constraint".
- The route to a parser is descent ([[decision:no-bespoke-parser]]), about which he said (2026-07-11, survey §16) that it "works well because we rarely have more than 2 or 3 characters of lookahead".

I'd record it as a cost rather than a conflict.

---

## 4. Edge behavior the rule creates

### 4.1 Invisible trailing whitespace changes the kind

When the whole run decides the kind, its last characters matter:

- [[rule:whitespace-after-last-marker]] keeps "a tab or other Unicode whitespace after the last marker on a line" as content.
- [[rule:space-before-text-end]] drops only spaces before an end.
- A no-break space sets no column at the end of a line, so by the agent's reading in [[rule:no-break-space-counts-as-space]] it is plain content.

So:

```udon
|cfg :port 8080⇥
|cfg :on true⍽
```

(`⇥` a tab, `⍽` U+00A0, each the last character of its line) gives `port ‹8080⇥›` and `on ‹true⍽›`: texts, with no warning.

Under first-word typing the number committed before the whitespace. Joseph's own words for the frame cover this case the other way: "whitespace is considered ornamental but turns into content if the next thing continues as part of the text" (2026-10-09). So two decided cards already disagree about a trailing tab, and this rule turns the disagreement into a change of kind.

A CR line ending is the same hazard. Pre-design 72 notes that the old parser turned `true` into `"true\r"`. That is the `rule:source-lines` gap.

### 4.2 An inline comment in the value changes the kind

```udon
|box :width 7 ;{px} :height 7 ; px
```

- **`width`**: `‹7 ;{px}›`, a «text» of a run and a comment. The inline comment is a piece, so the run doesn't spell a number.
- **`height`**: `7`, with a framed comment attached.

This follows from [[rule:embeds-in-text]] and Joseph's 2026-10-20 note that `;{…}` is "for wanting the comment associated with (and even internal to) the value". A writer may still not expect a comment to change a number into text.

### 4.3 What the escape set keeps

The card's note says [[rule:value-line-escapes]] "loses one of its reasons (escaping a leading digit), keeping the others (`\:`, `\|`, `\@`, `\!`, `\;`, `` \` ``)". Two corrections:

- **The digit, `+` and `-` escapes keep a job.** They make a run that wholly spells a number into a «text»: `:title \1984`.
- **`\"`, `\'`, `\[` and `\<` stay too.** A run can't begin with a delimiter, so `:a \"quoted" word` needs one.

`true`, `false` and `nil` have no escape in the proposed set. If «string» and «text» remain different kinds (§2.1), the «text» `true` has no spelling on a line. That is not new with this rule, but the rule makes it the only remaining hole of its kind. That card's example `:count \7 apples` no longer shows anything, since `:count 7 apples` gives the same text.

### 4.4 "Pretend each part is on its own line" still breaks, one step later

The card's Implication says `|el :c 1 z` and `:c 1 z` on its own line "give the same tree … so 'pretend each sameline part is on its own line' holds for values". That holds for runs. With a self-ending value it still fails:

```udon
|el :c "1" z
|el
  :c "1" z
```

- **First line:** `c "1"`, `$main ‹z›` (Joseph's residue lean).
- **Second line:** `c "1"`, `c ‹z›` ([[rule:leftover-values]] stacks on an attribute's own line).
- **Older data point:** his 2026-07-20 example made the attribute-line case an "ERROR because two text values for one attribute" (quoted in pre-design 71). That was under an older model, but it shows the residue on attribute lines has been answered three ways.

The Implication would be accurate as "for unquoted values".

---

## 5. The edit radius if adopted

Cards whose Statement, example or wording would change. The card's `consequences:` lists six of these.

| Card | What changes |
|---|---|
| [[rule:missing-value]] / this card | §1.1: an empty run is not a value |
| [[rule:leftover-values]] | "a further value on the line" now arises only after a self-ending value or a framed ` \ `; reconcile with clause 3 (§1.2) |
| [[def:main]] | `$main` stacking after a framed ` \ ` (§1.2) |
| [[rule:text-value-end]], [[def:text-terminator]] | the extent stated once, cited by the other (§1.4) |
| [[rule:key-holds-a-value]] | the run rule inside a key, ending at `]` (§1.3) |
| [[rule:list-items-whitespace-separated]] | one line saying list items don't follow the run rule (§1.3) |
| [[rule:value-line-escapes]] | reasons and example (§4.3) |
| [[def:text]] | "run" (§2.2); "what unquoted material … becomes" now needs "unless it wholly spells a primitive" |
| [[def:typed-value]] | «implicit-typed-value»'s "an unquoted word" becomes the whole run; the "single-word string" Avoid entry |
| [[rule:whitespace-after-last-marker]], [[rule:space-before-text-end]], [[rule:no-break-space-counts-as-space]] | trailing non-space whitespace (§4.1) |
| [[rule:nil-spelling]] | optional: "where `nil` would be read as nil" can cite the whole-run rule |
| [[def:framed]] | `:a x \` at end of line: is the backslash a framed end (text `x`) or part of the run (`x \`)? The end-of-line question already open there |
| `.int/peg-2026-10-21.md` | `number`, `boolean` and `nil` all take `&text-end` on a line (the card names only `number`); list items keep `&BOUND`; drop the note that `7apples` is an error |
| `TODO-MSC.md` | the `rule:bare-typing` gap's boundary becomes "the whole run"; the multiple-values item gains §1.2's case |
| `.int/peg-audit-2026-10-21.md` probes | 4.1 dissolves; 4.2 dissolves for runs only (§4.4); 4.3 is untouched (§1.2) |

---

## 6. Questions for Joseph, as examples

Each shows two or more readings; the card's reading comes first.

**Q1. Does a leading digit commit the kind (§3.1)?**

```udon
|item :count 7 apples :n 7apples :on true story :port 8080
|h2 1984 again
```

| | The card (whole run) | First character commits, for digits and signs |
|---|---|---|
| `count` | `‹7 apples›` | `7`, then `$main ‹apples›` |
| `n` | `‹7apples›` | an error |
| `on` | `‹true story›` | `‹true story›` (a keyword is typed only alone) |
| `port` | `8080` | `8080` |
| `h2` | `$main ‹1984 again›` | `$main 1984`, `$main ‹again›` |

**Q2. Is trailing whitespace of any kind frame at the end of a line (§4.1)?**

`|cfg :port 8080⇥` gives `port ‹8080⇥›` under the cards as they stand, or `port 8080` if trailing whitespace is frame.

**Q3. What follows a framed ` \ ` (§1.2)?**

```udon
|el
  :x one \ two
|el one \ two
|p \ tail
```

There are three readings:

- **Stacking** ([[rule:leftover-values]]): `x ‹one›` `x ‹two›`; `$main ‹one›` `$main ‹two›`; `$main ‹›` `$main ‹tail›`.
- **Nothing further on the line** (clause 3 as written): `two` and `tail` have no place.
- **Further values go below**: an error on the attribute line.

**Q4. Is a bare run with no embed a string or a «text» (§2.1)?**

```udon
|el :b hello :c 7 apples :d hello |{em x}
```

- **The card:** `b ‹hello›`, `c ‹7 apples›`, `d ‹hello |{em x}›`.
- **The value-model lean** (his 2026-10-20 sketch, the AST sketch, the handoff): `b "hello"` and `c "7 apples"` are strings of form bare, and only `d` is a «text».

**Q5. Should an inline comment change the kind (§4.2)?**

`|box :width 7 ;{px}`: `‹7 ;{px}›` (the card), or `7` with the comment attached?

---

## 7. What I read, and what I didn't

- **Read whole:** the card and its sidecar; `.int/STEWARD-VERBATIM.md`; every rule card in `src/`; `TODO-MSC.md`; the obj and principle cards and `obj.future/candidates.md`; the PEG; the de novo audit; the handoff.
- **Read whole among the def cards:** value, typed-value, text, string, delimited-string, text-terminator, block-form, marker, sameline, main, stacking, prose, reading-option, framed, head-position, embed, key, element-line, characters, root, label.
- **Searched, not read whole:** the other def cards (searched for value and typing terms); `adr/` (searched; I read the cards that carry its decisions); `main.outline.md`.
- **Read in part:** the PEG review (its §1, §2 in part, §4–§10); pre-design 66, 71, 72, 73 and 91 in full, and parts of 01 and 06; the principles survey (§5, §16); `scratch-jaw.md`; `.int/reserved.md`; the railroad and AST-sketch files (searched).
- **Not read:** `sop/`, `.old/`, `dat/` beyond a search, the other `.int` reports and pre-design files, and nothing outside the lite store.
- **One quote I could only half-check:** the 2026-07-15 "unlimited lookahead" remark in §3.1 is an excerpt. Its context is in `history.jsonl`, outside the store.

Treat this list of findings, not its silence, as its content. I'm on the line for follow-ups.
