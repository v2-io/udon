---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [typed-value, explicit-typed-value, implicit-typed-value, type-label]
per: [references-vocabulary]
depends: [rule:nil-spelling]
consequences: [rule:key-holds-a-value, rule:list-items-whitespace-separated, rule:opaque-span-raw-text]
---

# typed-value · explicit-typed-value · implicit-typed-value · type-label

*A «typed-value» gets its type from its spelling alone. Spelled `<…>`, it is an «explicit-typed-value», whose text lite carries without attaching meaning. Spelled any other way, it is an «implicit-typed-value».*

## Terms

- **typed-value:** a value that is not a node, and whose type is given by its spelling alone, never by value-sniffing (guessing a type from what the text looks like). Every «typed-value» is either an «explicit-typed-value» or an «implicit-typed-value».
  - *Avoid:* "box", the pre-design files' word for an «explicit-typed-value» before 2026-09-29.
- **explicit-typed-value:** a value spelled `<…>`. Lite finds where it ends and carries its text, and attaches no meaning to the text or to any «type-label» in it.
- **implicit-typed-value:** a «typed-value» not spelled `<…>`, such as an unquoted word, a quoted string, or a list. Lite reads its type from its spelling.
  - *Avoid:* "bare value". The sources use it for two different sets: every value outside `<…>` (0.10's "bare set" includes strings and lists), and unquoted values only.
- **type-label:** the part of an «explicit-typed-value»'s text that its author writes to name what the rest is meant to be, as `u64` in `<u64:0xff>`.
  - *Avoid:* "label" alone, which UDON uses for an attribute's name.

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

- **Since 2026-10-08:** quoted values are «string»s ([[def:string]]) and unquoted material is «text» ([[def:text]]); this record's "implicit-typed-value" (which lists "an unquoted word, a quoted string, or a list") needs reconciling with those two, and `nil` is now the only spelling of nil ([[rule:nil-spelling]]).

- The type-label question (07 Q3) is answered: lite carries the raw text, with no label split ([[rule:opaque-span-raw-text]]).
- **Open questions** bearing on these terms: 66, 72, 07, 89.
- **Bare typing (66, 72): lite takes 0.10.0's frozen bare set** (string, integer, float, boolean, nil, list; `v2/spec-0.10.00/CORE.md` §11). Joseph, 2026-10-08: "Not sure there's a question since that's been pretty stable, but discuss if needed." The agent answered that it's pin work (the frozen set, plus an answer for each edge spelling in 72's table), and Joseph didn't object. Not a new decision: don't reopen it as undecided. The edge spellings are still to pin.
