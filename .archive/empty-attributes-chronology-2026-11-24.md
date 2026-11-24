# Empty, missing, nil, flag: how the "attribute with nothing in it" question has gone

*Written 2026-11-24 by a history agent (Claude Opus 5.5) for Joseph and the v2 spec session, to read before discussing whether an «attribute» may hold zero «values» (`spec/def/attribute.md`, open note). It is history only, with no recommendation. Where I add a reading of my own it is marked **(my reading)**.*

**How to tell the evidence apart.** Each entry is tagged:

- **J**: Joseph's own typed words, quoted exactly (from `~/.claude/history.jsonl`, the spec-lite `STEWARD-VERBATIM.md` record, or his 2011 files). Dates are Mountain time; `L#####` is the line in `history.jsonl`.
- **S**: what a spec text or ruling ledger said. Much of it is agent drafting that he ratified with a short reply, and the 0.9.x and 0.10.x suites were, in his words, "never self-consistent, complete, actionable, or implemented, or even really adjudicated".
- **A**: agent analysis or proposals, adopted or not.

A large part of the 2011 → September 2026 span was already dug by an earlier history agent, in `v2/spec-lite-0.1.0/.int/pre-design/12-missing-values-and-what-counts-as-valid.discussion.md` (2026-09-29). I re-checked its main Joseph quotes against `history.jsonl` and they match. That file is the deeper record for that period; this one adds the 2026-08-07 "empty content" fork in detail, the October spec-lite turns, and November.

---

## The short version

It was never one question. At least five separate things have been argued, usually one at a time, each prompted by a neighbouring feature:

| # | The thing | What it looks like | Where it ended up (last word) |
|---|---|---|---|
| 1 | **Missing**: an attribute written with no value at all | `\|el :a` · `\|el :a :b 1` | spec-lite: an error whose message names `nil`, `''`, `\` (J, 2026-10-09) |
| 2 | **Flag / unary / presence**: the name alone *means* something | `:debug` = true · `:ready?` | flags retired (J, 2026-08-08, "K12") |
| 3 | **Nil**: an explicit "nothing" value, and how to spell it | `:a nil` · `null` · `~` · `--` · `<>` | `nil` only (J, 2026-10-09), `null` reopened (J, 2026-10-29), not decided |
| 4 | **Empty value**: a value that is there but empty | `:a ""` · `:a ''` · `:a \` · `:a ;{}` · `:a []` | all kept as real values, distinct from each other and from nil |
| 5 | **Zero values**: the attribute exists but holds an empty list of values | (no spelling of its own so far) | "empty attribute content never legitimately exists" (S/A, K6, 2026-08-07, J: "I'm on board; ratified") |

Row 5 is the question the new draft raises, and it has come up in this exact form once before, on 2026-08-07, when the attribute model was last turned into "a name plus an ordered list of contents". That episode is the closest precedent and is told in full below.

Two things recur through the whole history:

- **The reason for refusing a bare `:a` kept changing** while the rule stayed: what `:a |thing` binds to (July 2026), then catching deleted values (August), then keeping nested attributes reserved (October).
- **Joseph has twice reached for a distinct "no value" state and twice settled on something else**: in December 2025 (bare key = true so that `nil` can mean "explicitly unset") and on 2026-10-09 ("an explicit 'no-value' that is distinct from those in the AST ... with a default read-time option to treat it as null", replaced within the same conversation by an error).

---

## Chronology

### 2011 — "unary attributes" and NULL-on-missing

**J, 2011-07/08, `~/src/_older/udon/doc/syntax.udon`.** The components of an element are listed as name, ID, **"Unary attributes — Keys (typed)"**, **"Attribute pairs — Keys, Values"**, children. A key with no value was its own category, not a pair with a value missing.

**J, `~/src/_older/udon/examples/overview.udon`:**

```udon
|post-data :urlencode :xmlentities |
  blah blah blah
```

`:urlencode` and `:xmlentities` are unary: the name is the whole statement (like HTML's `disabled`). The file doesn't say what value, if any, they carry.

**J, 2011-12, `~/src/_older/udon-c/docs/DECIDED.md`:** *"NULL: when attribute value or a label is missing, or specified with --|~|null (??)"*.

So the founding answer to "missing" was **null**, with three explicit spellings, and separately a **unary** category. **(my reading)** These two sit a little oddly together: if a unary key's value is NULL, then "unary attribute" and "attribute whose value is null" are the same thing in the data, and the distinction in `syntax.udon` is only in the writing.

### 2025-12-22/23 — missing becomes `true`, so nil can mean "unset"

**J, 2025-12-22 (L5422, L5423):**

> "I think we'll need to end up with nil and null, yes.  That reminds me-- what does the current parser do when given an attribute with no value?"

> "I understand why I chose null at the time, but the truth is I think `true` is more realistic and valuable. I probably thought that the host language would be in charge of seeing that it was null and therefore set it to true, but by setting it to true when missing and making null explicit we retain a way to say "this attribute is effectively *not specified.*"   I do like the visual of -- and ~ though for nil, null. So missing => true. ['--','~','null','nil'] => nil."

**S, `SPEC.md`, first commit of the revival (`f5813bd`, 2025-12-23):**

```udon
|config
  :debug              ; debug = true (flag present)
  :verbose false      ; verbose = false (explicit)
  :deprecated null    ; deprecated = nil (explicitly unset)
  ; timeout is absent (key doesn't exist)
```

> - **Absent**: Key not present at all
> - **Nil**: Key present, value explicitly "no value"
> - **False**: Key present, value is boolean false
> - **True**: Key present with no value (flag) or explicit `true`

This is the **four-state model** (absent / nil / false / true) that is cited for the next eleven months. Note what nil means in it: *present, and explicitly unset*. That is already an option-like distinction: absent and "present with nothing" are different.

**J, spellings:** 2025-12-24, "we need to remove the `~` as a nil indicator -- so only `nil` and `null` recognized now" (L5616); 2025-12-27, "The spec needs to remove ~ and null as nil variants. The only valid one now is `nil`" (L5998). (The earlier agent found `null ≡ nil` back in every later spec anyway.)

### 2026-07-15/16 — "plain attributes always take a value"; `?` becomes the only flag

**J, 2026-07-15 14:04 (L16327)**, brainstorming, under the old rule:

```udon
|el :alpha :beta ; same-line semantics (IIRC) - alpha=true, beta=true
|el
  :alpha ; true
  :beta ; true
```

**J, 2026-07-15 15:21 (L16331)**, the thing he called revisable:

> "if the implicit boolean attribute ends up causing too much ambiguity from the user's perspective (like where the reference attaches to after :label on sameline (a place where boolean + attach to parent element is the more surprising behavior) -- I might trade it for forced explicit boolean attributes:
> ```
> :some-bool? true
> :some-bool? false
> :some-bool? nil ; or whatever we decided to use there
> :some-bool? :more-attributes   ; defaults to true
> :some-bool? |etc  ; defaults to true
> :some-bool [anything else] ; binds to the attribute as its main value/type -- even an element etc., even on normal sameline...
> ```"

The motive is **binding**: in `|el :a |thing`, does `|thing` belong to `a` or to `el`? If a bare `:a` can be a complete boolean, `|thing` is ambiguous. Making `:a` always want a value settles it, and `?` keeps a way to write a flag.

**A (grok 4.5), same evening:** "make the trade now ... the **full** trade (plain attributes always take a value; `?` is the only valueless/flag form) ... Late migration is expensive."

**S, CORE 0.9 (`8fa60af`, 2026-07-15 22:59):** "Plain attributes always take a value. ... is an **error** (`MissingAttributeValue`, working name)." Example from the next commit: `|{input :required}  ; ERROR (MissingAttributeValue) -- write |{input :required?}`.

**J, 2026-07-16 02:36 (L16387)**, on what the error leaves in the stream (it had been drafted as "no value event, the parser invents nothing"):

> "I would vote that the error in R2 would still emit the value with a nil. But that's me... I don't like losing data at the event level while we still have parsing work that can introspect those sorts of things and hand them back to us with reasons why we should do something else..."

So from here, `:a` bare = **Error + Nil**. **(my reading)** This is the moment an "empty" attribute was given a placeholder value rather than being allowed to be empty: the reason was that the stream should not carry less shape than the source suggested.

**J, 2026-07-18 12:33 (L16638)**, a flag with a non-boolean body:

```udon
|element
  :attribute-1
    |value ...
  :attribute-3?
    |value ...  ; warning, bool or null expected.
```

### 2026-07-18/19 — the empty *values*, one by one

These are rulings in the 0.9 ledger (`.archive/spec/msc/CHANGELOG.md`), S with Joseph's assent:

| Written | Ruled to be | Note |
|---|---|---|
| `:a \` | the empty string; no warning; "not `MissingAttributeValue`" | "a user's deliberate empty value, peer to `:a ""` and `:a nil`" |
| `\|el :n ;{}` | `\|el :n ""`, an empty string | from Joseph's own examples; inline comments "reduce to more text" |
| `:x [ ]` | the empty array, "0 items, not `[nil]`" | |
| `\|el[ ]`, `@[ ]`, `< >` | nil (single-value slots) | |
| `<>` (closed, empty) | kept as the text `<>` for now | J: "current behavior is fine for now due to no dialects"; `< >`→nil deferred to "dialect era" |

**(my reading)** By 2026-07-19 the "empty value" family (row 4 of the table above) is fully separate from "missing": the author wrote *something*, so it isn't missing. The line drawn is "did the author write a value token", not "is the value empty".

### 2026-07-29 — the `?` flag called a guess

**J, 2026-07-29 (L17897):** "There are *ZERO* consumers of the ? syntax for elements as syntactical sugar or for attributes as boolean indications." And in O17 (`DISCUSSION-THOUGHTS.udon`, quoted by the earlier agent): "? semantics were a forward-looking best guess that was the least complicated for the language."

### 2026-08-07 — the precedent: attribute = name + ordered contents, and "may the contents be empty?"

This is the episode that matches the current draft most closely.

**A, the spike** (`.archive/v2/.archived/attr-as-element-spike-2026-08-07.md`), proposing that an attribute be "an element minus name, identity, traits":

```
Assignment = { key, content: [Item] }
Item = Scalar | Reference | Interpolation | Node
```

"'One value' becomes the common case of a one-item content list, exactly as an element with one child is unremarkable." It then asked:

> **b. Does `MissingAttributeValue` (Error) survive?** If attributes have children-plural "even if empty," a bare plain `:key` is an empty attribute, peer to an empty `|el` — no Error, no Nil. ... (i) is the principled consequence of 2c, and "value required" moves to schema where constraint belongs. But it **dissolves the four-state model**: Nil then means only *explicit* `:key nil`, and "key present, no value" becomes a fifth state (Empty) ...

Its proposed ruling K5: "Plain `:key` with no material = empty content, no Error; four-state table rewritten (**Absent / Empty / Nil-explicit / False / True**); 'required' is schema's." It also noted that this would leave the language with possibly zero core errors.

**J, 2026-08-07 21:53 (L18796):**

> "I kind of feel we should *not* dissolve the absent/nil/false/true model-- which would mean that the next "things different about attributes are" thing is "they require a value -- use `nil` the way `nil` is meant to be used semantically. Alternately, leaving it blank is an implicit nil (not absent) but I feel like that would potentially lead to some difficult grammar issues... I could be wrong though.... maybe ask the spike agent to push on that some more...."

**A, the spike's addendum, same night**, retracting half of its own K5:

- On grammar: implicit nil costs nothing; the parser already waits one line to tell `:key`⏎(dedent) from `:key`⏎(deeper body).
- On meaning: "the **sameline mid-scan case**: `|el :a :b 1`. Today `a` gets Error+Nil — which is almost always right, because that input is almost always a deletion or a forgotten value (`:a x :b 1` minus the `x`). Implicit-nil silences exactly the anomaly that catches it".
- On principle: "an element is a *node* — a thing that exists, contentful or not; an attribute is an *edge* — and an edge with no terminus isn't a smaller edge, it's a malformed one. `nil` is the language's explicit 'this edge terminates at nothing.'"
- The law it proposed: "**Absent** = no assignment with that key. **Nil** = an assignment whose content is `[Nil]` — written `:key nil`, or produced by the Error path. **Empty content `[]` never legitimately exists**; the bare-`:key` Error case is represented as `[Nil]` + Error ... so no consumer ever meets a third empty-vs-nil state."

**J, 2026-08-07 23:53 (L18806):** "I'm on board; ratified." This became **K6** in `v2/DECISIONS.md`: "Explicit `nil`; the four-state model stays; R6's Error survives ... empty attribute content never legitimately exists."

Worth noting for the present discussion:

- The "Empty" state was proposed by an agent, and withdrawn by the same agent within the hour. Joseph's own stated reason for keeping the four states was a **grammar worry**, which the agent then said was unfounded; the agent's replacement reasons (deletion detection, edge-vs-node) are what K6 rests on.
- Joseph's own message offered **"leaving it blank is an implicit nil (not absent)"** as the alternative, not "empty". He did not, in anything I found, argue for a zero-values attribute himself.
- The node/edge argument depends on attributes being edges. The current draft makes an «attribute» a «node» ("Why it is a «node». It is a point in the tree with something above it and things below it"). **(my reading)** That moves the ground under the agent's strongest argument for K6, the same way the spike said 2c had moved the ground under the four-state model.

### 2026-08-08 — flags retire (K12)

**J, 2026-08-08 23:58 (L18885):**

> "2. That reminds me, I think flag attributes were an overkill... Or rather, having them default to "true" and complicate the attribute-label / values  rhythm wasn't/isn't worth the awkwardness...  I'm thinking instead we make sure that we simply make sure that attribute identities get identifies that are a lot more expressive than some other identifiers-- e.g., allow them to have (in any position, without quotes):  `*` `$` `#` `!` `?` ..."

K12's consequence (S): "a bare `:disabled?` is now a plain key missing its value → K6's Error+Nil". After this no valueless form has a built-in meaning. A question drafted the next day, whether bare `?`-names should get "some gentler landing" (D4), was not answered in anything the earlier agent found (I didn't search for it separately).

**(my reading)** The July rule "plain attributes always take a value" was adopted *with* the `?` escape. K12 removed the escape without revisiting the rule.

### 2026-08-09 — the collection reading (K15): `:x []` is one value, not zero

**S, K15, with Joseph's verbatim on ornamentation:** "a label names a collection of contributions; one contribution reads as the value itself, several read as the list of them in order, nesting preserved (`:x 1 :x 2 :x [3 4]` → `[1 2 [3 4]]`); flattening is the app's; always-list is an accessor, not the default."

**(my reading)** Under K15 an empty list written as a value (`:x []`) is a one-value attribute whose value is an empty list. It is not an attribute with zero values. So "empty list" and "zero values" have been different things since at least August, even though both could be described as "an empty list".

**J, 2026-08-09 (L18910, as quoted in spec-lite `def-stacking.md`):** "Stacking behavior has always been *turns what was just a simple scalar into a list of scalars*. :$key was "the-key", not :$key = ["the-key"] unless there was a second key declared."

### 2026-08-09/11 — 0.10.0 states it (S)

`spec-0.10.00/CORE.md` §6.2: "**Every assignment takes a value** — an edge with no terminus is malformed, not smaller. A `:label` with no value material ... is an **Error**; the assignment still stands with value **Nil**". §11.4: "Attributes require a value; there is no implicit nil and no implicit true". This error is "the one current case" of an Error that loses no bytes, an exception written into the severity law itself (the earlier agent's Thread 2).

### 2026-10-09 — spec-lite: Joseph reopens it, and three readings of `:a \`

**J, 2026-10-09 09:24 (L22026),** asked whether `:n ;{}` is an empty text or a missing value: "I'm fine with `:n ;{}` yielding a text AST node with an empty comment as its only inner part."

**J, 2026-10-09 10:17 (L22032):**

> "1. If you'll recall, the primary reason for erroring on missing values was not because they shouldn't be representable -- (equivalent to null/nil or an explicit 'no-value' that is distinct from those in the AST if we would prefer, with a default read-time option to treat it as null) but because we have reserved nested attribute-labels as a potential construct. So I actually lean `:a \` is a perfectly reasonable way to stand in for `:a ''`/`:a ""`, OR as a rule to stand for "explicitly no value specified" which reads by default to be equivalent to null (or nil? I forget which one we landed on in prior iterations)."

This is the clearest statement in the record of the option-type idea: missing values *should be representable*, possibly as their own AST state distinct from nil, with a read-time default that collapses it to nil.

**A, reply (summarized in `STEWARD-VERBATIM.md`):** the record gives other reasons (July 15 binding; August 7 deletion detector), not nested attributes; `:a \` already falls out of "a framed `\` ends the text" as an empty text.

**J, 2026-10-09 10:39 (L22033):**

> "1. Consider it a new argument then :-)
>    I agree fully, except the `:a :b 1` should error not as a deletion detector (although it serves that purpose) but due to nested attributes being reserved, and `:a` by itself should be an error something along the lines of "implicit missing value for attribute is not supported / reserved -- explicitly use nil, '' for blank string, or \ (for empty text)..."
>
> Also, let's go ahead and make 'nil' the only spelling for nil/null. I like null better semantically, but nil is less clunky lexically :-).  Now the deterministic typing just got a even tighter."

What spec-lite then recorded (S, `v2/spec-lite-0.1.0/src/`):

```udon
|el :d            ; error: implicit missing value; write nil, '' or \
|el :a :b 1       ; error: nested attributes are reserved
|el :a \ :b ''    ; a gets an empty «text», b an empty string
|el :a nil        ; a is nil
|el :b null       ; text "null", with a warning pointing to nil (from 2026-10-21)
```

Note the message's wording, "not supported / **reserved**": a bare `:a` was made an error so that a meaning could be given later, not because it can have none. And three distinct empties now coexist by name in one message: nil, the empty string `''`, and the empty «text» `\`.

### 2026-10-21/22 — `<>` as nil, then not

**J, 2026-10-21 (L22832)**, exploring "always text except typed":

```udon
|p :held <nil>
|q :hold <901.2>
```

with "This isn't an adjudication, decision, or even a lean yet-- this is a branch to explore".

**J, 2026-10-22 08:58 (L22932):**

> "A new feature, before I forget:   `<>` completely empty, == `<nil>` (if that becomes the rule, or == `nil`-value if that is retained). Distinct from "",<"">,'',<''> -> all empty strings, and `<false>` (or currently `false`), obviously."

**J, 2026-10-22 09:19 (L22933):** "<> == <nil> (or nil) is my lean, orthogonal to the `nil` vs `<nil>` issue still being discussed".

**J, 2026-10-29 12:40 (L23317):** "(let the other agent know that we're not going to be reserving '<>' after all, fwiw)", then, asked whether that meant `<…>` becomes ordinary text: "Yes, that's what I meant. (such as html or xml)". **(my inference)** This withdraws `<>` as nil along with the rest of `<…>`, though he didn't say so about `<>` specifically. The 2026-11-07 incoherence notes (`spec/.influx/spec-lite-incoherences-2026-11-07.md`) list the two leans as unreconciled.

### 2026-10-29 — `nil` or `null`, reopened

**J (L23313):** "So you do think we should do `nil` instead of `null`?" The agent's recommendation was `null` (every fresh agent in the value trial wrote `null` untaught; text data formats with a null spell it `null`). **J (L23314):** "I'll always be comfortable changing something by fiat to fit my own preferences -- please go ahead and switch it to null if that's a bit more honest to a cold read by you". He then said (L23326) he had not ruled, and the card edits were reverted. The agent's list in that exchange noted that "Rust, OCaml and Haskell use option types" rather than a null. Status: `nil` is the recorded ruling, `null` the agent's recommendation, his call open.

### 2026-11-24 — the v2 draft

The draft «attribute» (`spec/def/attribute.md`) gives an attribute "one or more ordered «values»", with the invariant "An «attribute» has at least one «value»" and an open note: "whether an «attribute» may hold no «values» at all. Written here as never". Joseph, today: "attributes -> attribute-names, one of each at most, with ordered values", and on always-a-sequence, "from a functional programming perspective, it's definitely nicer to think in terms of "it's just a linked list, always"."

---

## Things worth having in view for the discussion

All of this section is **(my reading)**.

**1. The five rows map onto an option type cleanly, and the history has visited each slot.** Taking "what does the parent have under name `k`?" as the question:

| Case | Written | As an option over the values list |
|---|---|---|
| absent | (no `:k`) | `None` |
| zero values | `:k` bare, if it were allowed | `Some []` |
| nil | `:k nil` | `Some [Nil]` |
| empty list | `:k []` | `Some [List []]` |
| empty text / string | `:k \` · `:k ""` | `Some [Text ""]` · `Some [String ""]` |

December 2025 had `None` / `Some [Nil]` / `Some [True]` (bare key). July–October 2026 forbade writing `Some []` and turned it into `Some [Nil]` + error. The 2026-08-07 "Empty" state and Joseph's 2026-10-09 "explicit 'no-value' ... with a default read-time option to treat it as null" are both proposals to let `Some []` exist; the first was withdrawn by its agent, the second replaced by Joseph in the same conversation.

**2. The draft's own model already leans on the "never empty" invariant.** In `spec/def/attribute.md`'s auxiliary model, "For any other k, `attr_values e k = []`": an absent name answers with the empty list. That is unambiguous only because an attribute can't have zero values. If zero values became allowed, `attr_values` could no longer tell absent from empty, and would want to return `value list option` (or a separate `has_attr`). Whichever way the question goes, that line is where the choice shows up in the model.

**3. The reasons given for "never empty" have mostly been about the surface syntax, not the tree.** Binding (`:a |thing`), deletion detection (`:a :b 1`), and nested-attribute reservation are all reasons not to *read* a bare `:a` as complete. None of them says the tree can't hold an attribute with zero values; they say that *this spelling* shouldn't produce one by accident. The one tree-level argument, "an edge with no terminus is malformed", was made for an edge, and the draft now calls an attribute a node. So one way the history divides the question: (a) may the tree hold `Some []`; (b) if so, what spelling produces it (`:a` bare is reserved; spec-lite's message reserved it explicitly).

**4. "Empty list" and "zero values" have been distinct since August (K15) and should not be merged by the words.** `:x []` is one value, an empty list. Today's "it's just a linked list, always" makes it easy to say "an attribute whose list is empty" and mean either.

**5. Flags are the one place a zero-value attribute had a use.** The 2011 unary attributes (`:urlencode`) and the 2025 `:debug` were exactly "the name is the whole statement". They were retired for awkwardness in the "attribute-label / values rhythm" (K12), not because presence-only attributes were unwanted. If `Some []` exists, a presence-only attribute is what it would most naturally be used for, so the K12 reasons are worth re-reading against it.

---

## What I read, sampled, and didn't

**Read whole:** `v2/spec-lite-0.1.0/.int/pre-design/12-missing-values-and-what-counts-as-valid.discussion.md` (the earlier history, whose sources I did not all re-open), its neutral file `12-…md`, and `89-empty-and-degenerate-forms.md`; spec-lite cards `rule-missing-value`, `rule-backslash-empty-text`, `rule-attribute-after-attribute-with-no-value`, `rule-attribute-with-no-value-takes-next-value`, `rule-element-after-attribute-with-no-value`, `rule-nil-spelling`, `def-stacking`; the v2 draft `spec/def/attribute.md`.

**Read in part:** `STEWARD-VERBATIM.md` (by grep for empty/nil/null/flag/`<>`, then about 300 lines around the hits: 2026-10-08/09, 10-21/22, 10-29); `attr-as-element-spike-2026-08-07.md` (§1, §1.1, §1.2, §6 and addendum A; not §2–5 or addendum B); `v2/DECISIONS.md` rows K2, K5, K6, K12, K14, K15; `.archive/spec/msc/CHANGELOG.md` around the 2026-07-16/18/19 rulings; `spec-0.10.00/CORE.md` and `spec-0.09.01/CORE.md` by grep; the first `SPEC.md` (`f5813bd`) by grep plus its "Absent vs Nil vs False" section; the 2011 `DECIDED.md`, `syntax.udon` and `overview.udon` excerpts; `spec/.influx/spec-lite-incoherences-2026-11-07.md` by grep.

**`history.jsonl`:** filtered all udon-project prompts since 2026-10-09 for empty/nil/null/option/`<>` and read the hits; checked sixteen earlier prompts directly against the earlier agent's quotes (L5422–L18885).

**Not reached:** memorata-search; grok, Gemini and Codex transcripts (the earlier agent reached grok only through memorata); `v2/theory/`, `v2/udon-needs/`; the 0.10.1 draft beyond a grep; `spike-values-2026-10-22/` and `trial-values-2026-10-28/` beyond a grep for option/missing (nothing found); `types-ideation-2026-10-22.md` beyond the same grep. The earlier agent's file lists more sources for the pre-October period.
