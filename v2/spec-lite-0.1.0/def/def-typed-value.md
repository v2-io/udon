---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
strength: provisional
terms: [typed-value, explicit-typed-value, implicit-typed-value, type-label]
per: [references-vocabulary, term-typed-value]
depends: [rule:nil-spelling, def:text, def:string, rule:opaque-span-raw-text]
consequences: [def:value, def:opaque-span, rule:key-holds-a-value, rule:list-items-whitespace-separated, rule:opaque-span-raw-text]
---

# typed-value · explicit-typed-value · implicit-typed-value · type-label

*A «typed-value» gets its type from its spelling alone. Spelled `<…>`, it is an «explicit-typed-value», whose text lite carries without attaching meaning. Spelled any other way, it is an «implicit-typed-value».*

## Terms

- **typed-value:** a value that is not a node, and whose type is given by its spelling alone, never by value-sniffing (guessing a type from what the text looks like). Every «typed-value» is either an «explicit-typed-value» or an «implicit-typed-value».
  - *Avoid:*
    - **"typed value" in any of its other live senses** without saying which: any «value» at all (Joseph's 2026-09-30 lexicon edit), or `<…>` only (his 2026-10-08 usage). See the working notes and [[def:value]].
    - **"value"** as the general word, per Joseph (2026-09-30): "an ambiguous term we're not using".
    - **"typed literal"** (the agent's 2026-09-30 recommendation, which he declined; also his own 2025-12-24 "attribute values are *typed literals / scalars*").
    - **"scalar"**, **"typed scalar"**, **"bare scalar"** (0.9.1's "bare scalar set"; Joseph, 2026-08-07/08). A list is a «typed-value» here and isn't a scalar anywhere else.
    - **"self-announcing value"** (0.10.1).
- **explicit-typed-value:** a value spelled `<…>`. Lite finds where it ends and carries its text, and attaches no meaning to the text or to any «type-label» in it.
  - *Avoid:* **"box"** and **"untyped box"** (the 2026-09-01 FIX text, then lite's pre-design files until 2026-09-29, where 07 settled it as an "untyped box"), **"envelope"**, **"explicit-typing envelope"** (0.9–0.10.0, from 2026-07-11), **"capture"**, **"value capture"** (0.10.1), **"dialect-typed value"** (0.9.1 primer), **"explicit typing annotation"** (Joseph, 2026-07-11, for the idea before `<…>` was chosen), **"typed delimited value"** (Joseph, 2026-10-08).
- **implicit-typed-value:** a «typed-value» not spelled `<…>`, such as an unquoted word, a «delimited-string», or a list. Lite reads its type from its spelling.
  - *Avoid:* "bare value". The sources use it for two different sets: every value outside `<…>` (0.10's "bare set" includes strings and lists), and unquoted values only. Also **"single-word string"** (the 2026-09-29 lexicon's member of this set): in lite an unquoted word is a «text» ([[def:text]]).
- **type-label:** the part of an «explicit-typed-value»'s text that its author writes to name what the rest is meant to be, as `u64` in `<u64:0xff>`. *(Provisional name; it collides with "label", see below.)*
  - *Avoid:*
    - **"label"** alone, which Joseph uses for the lexical rules all identifying names share (2026-10-09). Also **"label ladder"** (0.9.1, for `<type:…>` / `<dialect:type:…>`) and the lite agents' **"type label"** / **"type-label"** (2026-09-30 onward), which inherit the collision.
    - **"envelope ladder"** (0.10.0's rename of "label ladder", made because "label" had come to mean an attribute's name; never ruled).
    - **"kind"** (0.10.0: a verbatim form's or fence's tag; 0.10.1's `<kind: body>`), **"vocab"** (0.10.1 `<vocab:kind: body>`), **"dialect"** (the S-ET spike's `<dialect:type:…>`): names for one level of a multi-level prefix, each tied to a design lite doesn't have.
    - **"tag"** (the FIX text: "carried as its text plus its tag"). In a notation built for XML/HTML, and for a construct spelled `<…>`, "tag" reads as an HTML tag.
    - **"info string"**: CommonMark's name for a fence's tag (slice E, fences), not this.

## The tag in `<u64:0xff>`: what lite does with it

Nothing: lite carries `u64:0xff` as the «explicit-typed-value»'s text and doesn't split it ([[rule:opaque-span-raw-text]]). So lite's «tree» has no node or field for a «type-label». The term exists only to talk *about* what authors write and what a later version may parse.

## Invariants

- Lite attaches no meaning to an «explicit-typed-value». Its text stays text, including text that looks like a date, a time, or a duration.
- No «typed-value» is typed by what its text looks like. `2026-09-29` unquoted is not a date in lite, and `<2026-09-29>` is not one either.

## Examples

- In `:when <2026-09-29>`, the value is an «explicit-typed-value» whose text is `2026-09-29`. Lite does not know it is a date.
- In `:size <u64:0xff>`, the author wrote `u64` as a «type-label». Lite attaches no meaning to it or to `0xff`.
- In `:name web :port "8080"`, both values are «implicit-typed-value»s, and both are strings.

## Discussion

- **"By spelling, never by value-sniffing" is used here as common ground, not as a decided principle.** It is 0.10.0's G6, not yet re-decided for lite. No alternative in 66 or 72 types by content, so the definition holds whichever is chosen. If lite ever adopted content-based typing, these terms would need restating, not just the principle.


*Carried 2026-10-09 from the decision record `adr/explicit-typed-value-in.md`, retired when cards became the decisions (Joseph, 2026-10-09: "sounds good"); git keeps the record. Recorded there as `supported`, 2026-09-29.*

**Context.** Dates, times and durations were deliberately removed from bare value parsing, on the idea that they would be the first `<…>` types, with the spelling for a namespace or type left undecided. So lite had to say what, if anything, it does with `<…>`. The agent offered three options.

**Options considered.**

* 1: reserve `<` entirely; lite gets no dates.
* 2: carry `<…>` as an untyped box: lite parses where it ends and hands over the raw text, with no meaning attached (chosen).
* 3: option 2, plus a fixed list of recognized contents in unlabelled boxes (ISO dates, times, datetimes, durations).

**Drivers.**

* Forward safety: `<…>` "always meant 'someone else decides what this is'" (**inferred, unconfirmed** as Joseph's: the agent's argument for option 2, 2026-09-29T23:56Z).
* No spelling for type or namespace labels is decided yet (Joseph, in the Context's first sentence, from his 23:55Z message).

**Assumptions.**

* Carrying the raw text, with no meaning attached, is forward-stable: a later version can give it meaning without changing the tree lite produced. (**inferred, unconfirmed**: it holds only if the tree records the raw text in a form a later split into label and body doesn't change; see 07 Q3)

**How firm.** "2" is the agent's option 2, quoted in the same file. The rendering written into `.int/README.md` afterwards says lite "carries its text and optional type label"; that phrase comes from the agent's own later paraphrase (2026-09-30T02:08Z, recommending "typed literal"), not from option 2, whose words say only "hands over the raw text". This record holds to option 2, and leaves the label question open (07 Q3). (Since answered: the tree holds raw text, with no label split; [[rule:opaque-span-raw-text]].) `supported` is the default for an assent nobody asked about at the time ([[decision:decision-authority]]).

**Costs accepted.**

* A lite consumer gets dates only as text.

**Reopen when.**

* Need arises for a quick subset of core types (Joseph expects 0.1.1), or implementation reaches the anticipated reattachment of the temporal parser. Either changes lite's tree for some `<…>` values, so it needs its own decision then.
* A label spelling is decided for full UDON, and lite needs to split it out.

**Joseph's words not already quoted on this card.**

> w/ dates-- let's go with 2 for now. When we get to implementation we might go ahead and reattach the temporal parser already built.
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

> Correct, I decided option 2 for now, but specifically decided we would stay open to doing a quick subset of core types potentially, depending on need (I kind of suspect that will be a 0.1.1 feature or something).
>
> — Joseph, 2026-10-01 (`.int/STEWARD-VERBATIM.md`), confirming the record

## Working notes

- **Mostly dissolved (2026-10-29):** `<…>` is ordinary text (Joseph: not reserved, "such as html or xml"), so «explicit-typed-value» and «type-label» name nothing in lite. Whether «typed-value» survives at all waits on the bare-values decision (`.int/spike-values-2026-10-22/typing-recommendation.md`, rule 1).

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.

- **Since 2026-10-08:** quoted values are «string»s ([[def:string]]) and unquoted material is «text» ([[def:text]]); this record's "implicit-typed-value" (which lists "an unquoted word, a quoted string, or a list") needs reconciling with those two, and `nil` is now the only spelling of nil ([[rule:nil-spelling]]).

- The type-label question (07 Q3) is answered: lite carries the raw text, with no label split ([[rule:opaque-span-raw-text]]).
- **Open questions** bearing on these terms: 66, 72, 07, 89.
- **Bare typing (66, 72): lite takes 0.10.0's frozen bare set** (string, integer, float, boolean, nil, list; `v2/spec-0.10.00/CORE.md` §11). Joseph, 2026-10-08: "Not sure there's a question since that's been pretty stable, but discuss if needed." The agent answered that it's pin work (the frozen set, plus an answer for each edge spelling in 72's table), and Joseph didn't object. Not a new decision: don't reopen it as undecided. The edge spellings are still to pin.

### Vocabulary notes (added 2026-10-09, for Joseph's review of these terms)

- **"typed value" has three live senses in the record**, and the cards use a fourth:
  1. **Any value.** Joseph's own edit of the 2026-09-29 lexicon renamed its "**value**" entry to "**typed value** — what an attribute or same-line slot holds: an implicit typed value, an explicit typed value, a quoted string, a text run, or (open: 64) an element." (Session `5930da5d…jsonl`: the agent's Write at line 1700, the Read after his edit at line 1812.) His message: "I fixed "value" which is an ambiguous term we're not using -> typed value like I suggested, to emphasize and clarify it vs the general term, since all values have types in udon." (2026-09-30T02:21Z, `history.jsonl` 21329.)
  2. **`<…>` only.** "what about 'typed-value' instead of box?" (2026-09-30T02:07Z), where "box" was `<…>`; "typed delimited values (<...>)", "the opaque delimited spans (typed values and references)", and "different than our "general matching + escaping" for arrays, typed values, keys, and embeds" (all 2026-10-08). This is how he has used the bare phrase most recently. *(A reading of his usage.)*
  3. **Values on an element's line, explicit or implicit.** His scratch list (`.int/scratch-jaw.md`): "typed values as children, explicit `|el <42>`" and "typed values as children, implicit `|el 42`". Here explicit/implicit is `<42>` vs `42`: the pair the card's two sub-terms come from.
  4. **The cards' sense:** a non-node value typed by spelling (this card).

  Senses 1 and 4 disagree on whether a «text» and an element are «typed-value»s; senses 2 and 4 disagree on whether a number is one. "typed value" can't be settled until he says which he means. The question is also [[def:value]]'s.

- **Is a «text» a «typed-value», and if so is it implicit?** Under sense 1, yes (the lexicon listed "a text run"). Under this card's definition, an unquoted word is listed as an implicit typed value, yet since 2026-10-08 `:a hello` gives a «text», and a «text» with embeds isn't typed "by its spelling" in any useful sense. Likewise, a «string» is in the frozen bare set but is now a separate term ([[def:string]]). The «implicit-typed-value» definition needs one of: (a) text and string are both implicit typed values (the set is then "everything not `<…>` and not an element"); (b) the implicit set is numbers, booleans, `nil` and lists only, and «string» and «text» stand beside it; (c) drop "implicit" and name the frozen set directly.

- **"implicit" invites the wrong reading.** To a reader, "implicitly typed" means the type was *inferred*, which is exactly the value-sniffing this card says lite never does. The type of `42` is explicit in its spelling (digits), just not *declared*. YAML's word for this is "resolved" (tag resolution of plain scalars); JSON's is no word at all (numbers are a kind of value). "Implicit" was Joseph's own choice (the scratch list), so this is an affordance note, not a correction.

- **Precedents for the `<u64:0xff>` construct and its tag:**
  - **KDL v2 "type annotation":** `(u8)123`, "a set of `(` and `)` with a single String in it" (§3.8), with reserved annotation names including `i8`…`i128`, `u8`…`u128`, `f32`, `f64`, `date-time`, `date`, `time`, `duration`, `uuid`, `url`, `regex`, `base64`. Checked against kdl.dev/spec 2026-10-09. The closest precedent in shape and purpose, and it calls the tag an *annotation*.
  - **EDN tagged elements:** `#inst "1985-04-12T23:20:50.52Z"`; the `#inst` is a *tag*, and a reader keeps unknown tags as tag + value.
  - **YAML tags:** `!!int 3`, `!local x`. **CBOR tags.**
  - **RDF typed literal:** a lexical form plus a *datatype* IRI (`"3"^^xsd:int`). The agent's 2026-09-30 source for "typed literal".
  - **Rust literal suffixes:** `0xffu64`, the type written inside the literal's spelling; called a *suffix*. C++ user-defined literals: *ud-suffix*.
  - **CommonMark:** a fence's *info string*.

- **Joseph's own words for the tag, in order:** "<u64i|0xf902>" (2026-07-11, a pipe, not a colon); "type or dialect+type prefix for more and more specificity" (2026-07-11); "<core:temporal:timespan 3m5d> which can probably be reduced to <temporal:timespan ...> or <timespan ...>" (2026-07-22, a space, not a colon); "<namespaced/type: val>" (2026-07-21); "with spelling for namespace or type undecided" (2026-09-29). He has called its parts "type", "dialect", "namespace" and the whole a "prefix". He hasn't named it as one thing. *(The spellings are from `.int/pre-design/07-untyped-angle-box.discussion.md`, thread 3, which counts seven.)*

- **Candidates for the tag:** "type annotation" (KDL; says what it does, doesn't say "label"); "type tag" (EDN/YAML/CBOR; but "tag" reads as HTML); "type prefix" (Joseph's "prefix"; says where it sits); "type name"; or **no term in lite**, since lite never parses it: write "the text `u64:0xff`" and leave naming to the version that splits it.

- **My own lean (the vocabulary agent for values and text, Opus 5.5; an opinion):** for the tag, no defined term in lite 0.1.0, because the «tree» has no such part; when one is needed, "type annotation", which has the best precedent and avoids both "label" and "tag". For «typed-value», I can't lean until Joseph says which sense he meant; if asked: «typed-value» as the umbrella for every «value» that isn't an element, made up of «string», «text», «explicit-typed-value» and the frozen set of numbers, booleans, `nil` and lists (option (b)), with the frozen set renamed to something that doesn't suggest inference. That keeps each name tied to what it is.

### Coordinator's lean (Opus 5.5, 2026-10-09; my opinion for Joseph, not a lean of his)

- **Waits on his sense of "typed value"** ([[def:value]]). My lean if asked: «value» is the general word; «explicit-typed-value» names `<…>`; **drop «implicit-typed-value»**, since the other kinds each have their own name (string, text, number, boolean, nil, list) and "implicit" suggests inference, the very thing lite rules out. The umbrella «typed-value» then isn't needed.
- **«type-label»: no term in lite.** Lite's tree has no such part, and "label" is now lexical. When a later version splits it out, "type annotation" (KDL) is the precedent I'd offer.
