# 12 — Warnings, errors, and what counts as "valid lite": history

**Who wrote this:** a history agent (Claude Opus 5.5) working for the spec-lite coordinator. Written 2026-09-29. It has the history only; there is no lean or recommendation here.

**Method.** I read the neutral file (`12-missing-values-and-what-counts-as-valid.md`), `pre-design/README.md` and `spec-lite-0.1.0/README.md` first. Then I read the primary sources below directly, not through summaries:

- **2011 originals:** `~/src/_older/udon/` (git: Jul–Dec 2011) and `~/src/_older/udon-c/docs/DECIDED.md` (git: 2011-12-14 → 12-22).
- **Mainline repo:** the initial `SPEC.md` + `analysis.md` (commit `f5813bd`, 2025-12-23); `spec/CORE.md` as it stood before 0.9 (`407f5e7`) and now; `spec/msc/CHANGELOG.md`; `design/attribute-model-2026-07.md`, `design/attribute-model-proposal-3.md`; `_archive/TODO-SPEC-CORE-0.9-supplement.md`; the D9 record (`c313499:decisions/DECIDED.md`). I used git history (`git log -S` on `MissingAttributeValue`, `AttributeAfterChildren`, `valueless`, `phase-restricted`, `stranded`, `warn-before-disallow`, `Error = loss only`).
- **v2:** `DECISIONS.md` (all rows, not only the named ones), `OPEN.md`, `msc/for-joseph/01-PLAIN-DECISIONS.md` + `UNIF-PASS-QUESTIONS.md`, `spec-0.09.01/CORE.md`, `spec-0.10.00/CORE.md` (§0, §1, §6.2, §6.8–6.9, §11.4, §13–15, Appendices B–C) + `SEMANTICS.md` §5, `spec-0.10.01/CORE.md` + `DELTAS.md` + `working-notes/AUDIT-2026-09-01.md`, `JOSEPH-FOR-0.10.01-FIX.md`, `INBOX-REQUESTS.md`, `udon-needs/pipeline-discussion.md`, `theory/to-integrate/primary/{K9-DRAFT,sameline-value-space}-2026-08-08.md`, `DISCUSSION-THOUGHTS.udon` (O17), `.archived/attr-as-element-spike-2026-08-07.md`, `.archived/second-pass/{RULING-TABLE,RULING-SUPPLEMENT}.md`, `.archived/first-pass/greenfield-3b/`.
- **Joseph's typed words:** I extracted every udon-related prompt from `~/.claude/history.jsonl` (3,281 entries, Dec 2025 → today) with layout kept, and filtered them with regexes for missing values, flags, severity, keep-everything, late attributes, and ruling IDs. `L#####` below is the line number in `history.jsonl`. Quotes are verbatim, including typos.
- **memorata-search** (classes `human-user`, `agent-to-human-flanking`, `document`, `subagent-final-response`; scoped to udon paths): `"still becomes an attribute of"`, `"implicit nil"`, `nil when an attribute has no value…`, `flags with question mark…`, `error means something was lost…`, `keep everything warn instead of dropping…`, `strict mode fail on warnings…`, `attributes further down after content…`, `"less shape"`, `"stranded"`, `"L0"`, `boolean flag attribute` (grok sessions, 2026-07-15).

**Blocked or not done:**
- I did not open raw `.jsonl` transcripts.
- One memorata result set contained `thinking`-class passages from a grok session. I did not use them. The grok material below comes only from its user-facing reply.
- Grok and Codex session transcripts were only reached through memorata, so not exhaustively.
- `--joseph` combined with date filters returns nothing (a sibling agent reported this); I avoided that combination.

**Scope note.** Q1 is about what "valid" means. Q2 is the missing-value rule, and it cannot be separated from the history of *flags*. Q3 is late attributes. The history of all three runs together, so the entries below are in one timeline. Each entry says which question(s) it bears on.

---

## History (chronological)

### 2011 — the originals

**2011-07 → 08-22 — `~/src/_older/udon/doc/syntax.udon` and `examples/overview.udon`** (git dates 2011-07-22 → 2011-08-22). Speaker: Joseph (sole author).
- `syntax.udon` lists the components of an element: "Element-name · ID · **Unary attributes** — Keys (typed) · Attribute pairs — Keys, Values · Children."
- `overview.udon` shows valueless attributes in use: `|post-data :urlencode :xmlentities |` (and block variants).
- **Bears on Q2:** a valueless attribute was a first-class category ("unary") from the start. The file does not say what value it had.

**2011-12-14 → 12-22 — `~/src/_older/udon-c/docs/DECIDED.md`** (git `4edf78e` "Got stuck w/ attributes…", `ecfaa4a`, `ab28dd3`). Speaker: Joseph.
- Under SCALARS: *"NULL: when attribute value or a label is missing, or specified with --|~|null (??)"*
- Under PARSER: *"Warnings w/ severity as a separate structure returned that the implementation can decide what to do with."* and *"Ability to supress specific warning messages"*
- Under UNDECIDED / NODES: *"Allow attributes of a node to continue to be scattered all over the place?"* Right after it, a different construct: `|hello` / text / deeper `|am I a node? whose node am I? The texts? |hello's with a warning? interpreted simply as text, with warning?`
- UNDECIDED / PARSING: *"Error on tab/space mixing?"*
- UNDECIDED / ROOT NODE: *"No way (from document) to set classes? - use :class-name true instead?"*
- **Bears on Q2:** the earliest recorded answer for a missing value is **null** — that is, the neutral file's option B (nil) without the error.
- **Bears on Q1:** severity is reported as a separate structure, and the *implementation* decides what to do with it.
- **Bears on Q3:** scattered attributes were an open question in 2011.
- **Incidental:** the "text, with warning?" example is about a deeper `|` line inside text, not a `:` line. It is the same instinct (warn and keep as text), aimed at a different construct.

### December 2025 – January 2026 — the revival (libudon, 0.7/0.8 line)

**2025-12-20 20:06–20:28 — revival session** (`history.jsonl` L5353, L5356; the answer was written into `analysis.md`, committed in `f5813bd` on 2025-12-23).
- Joseph (L5353): *"What are the open questions still about udon-- maybe with the benefit of 14 intervening years there are some simple decisions"*.
- The agent's analysis records:
  - *"6. Tab/Space Mixing — Decision: Yes. Be strict. Spaces only. … Fail fast with clear error message"*
  - *"7. Scattered Attributes — Question: Allow attributes to continue appearing after children start? Decision: No. Attributes must come before children. Rationale: Scattered attributes make parsing harder / … reading harder … `\|element` / `some child` / `:attr1 val1   # Ambiguous: is this for element or for the child?`"*
  - Item 3 says in passing: *"`null` / `~` for explicit absence (but even this can be 'no value = absent')"*.
- Joseph (L5356): *"OK. I agree with all of the decisions-- in fact, it was the ubiquity and utility of triple-backticks that made me think we might have answers today that we didn't then."*
- **My inference:** "all of the decisions" presumably covers #6 and #7, but his message names only the backtick and Ruby-`#{}` items.
- **Bears on Q1** (tabs as a fail-fast error) **and Q3** (no scattered attributes; the reason given is reader ambiguity).

**2025-12-22 19:11–19:15 — the missing value becomes `true`** (L5422, L5423; project `~/src`, session `9c70d20c`). Speaker: Joseph.

> "I think we'll need to end up with nil and null, yes.  That reminds me-- what does the current parser do when given an attribute with no value?"

> "I understand why I chose null at the time, but the truth is I think `true` is more realistic and valuable. I probably thought that the host language would be in charge of seeing that it was null and therefore set it to true, but by setting it to true when missing and making null explicit we retain a way to say "this attribute is effectively *not specified.*"   I do like the visual of -- and ~ though for nil, null. So missing => true. ['--','~','null','nil'] => nil."

- **Bears on Q2 directly:** this is where the neutral file's option C originated. The reason given is to keep *explicit nil* ("not specified") distinct from a bare key.
- **Incidental:** the list of nil spellings. `~` was removed 2025-12-24 (L5616), and on 2025-12-27 (L5998) he said "The only valid one now is `nil`". `null ≡ nil` is nonetheless in every later spec.

**2025-12-23 — `SPEC.md` initial commit** (`f5813bd`).
- Type table: `` `:key` (no value) | Boolean `true` | Flag/presence semantics``, and `:flag ; Boolean true (missing value = true)`.
- The four states: *"True: Key present with no value (flag) or explicit `true`"*.
- Design Principles: *"Attributes must precede child content. No scattered attributes."*
- Strict Whitespace: *"Error on mixed indentation"*.
- **Bears on Q2 and Q3.** No behavior is stated for a document that breaks the attribute ordering.

**2026-01-09 → 01-14 — posture remarks in libudon/udon sessions.**
- L7699 (TIME-SPEC edge cases): *"4. I agree, lenient. So, I agree with you-- but make a note (maybe in the TIME-SPEC itself) of what the decisions are and which things we *may or may not* issue a warning for."*
- L7850: *"after a warning it needs to pick up the right thing correctly"*.
- L7902: *"A database can forcefully reject an incorrect mutation, whereas a text-based file format that is very readable, without some extra layer (a file watcher that refuses to commit it if it's not in compliance with its schema?) has no guarantees whatsoever"*.
- **Bears on Q1:** the lean is lenient parsing with warnings, and rejection lives in "some extra layer".

### July 2026 — the 0.8 → 0.9 attribute model

**2026-07-11 23:16–23:19 — D9: the `:` is phase-restricted** (L15850; ratified record `c313499:decisions/DECIDED.md`).
- Joseph (L15850):

  ```
  |a :b
    :c 1
    :d 2

    Hello! this is yet another
    :one for the ages

  ; :one for the ages is just normal text. Nothing to worry about.
  ```

- D9 record (agent-written, "Ratified (Joseph)"): *"The attribute marker — `:` — is phase-restricted, not char-guarded: an attribute only while the element has no children/text yet … Once content starts, `:` at head is prose."* It gives the reason as *"attributes are element header metadata (they precede content); everything else … is content that interleaves."*
- The parser landed this on 2026-07-15 (`8970af5`): "a line-initial ':' is prose intact".
- **Bears on Q3:** the first concrete keep shape is **text, with no warning**.

**2026-07-14 00:03 — the "stranded `:word`" warning** (L16153, record `27f222e`).
- Context: `:bttr 2 :cttr 3` on one block line, back when block values ran to end of line.
- Joseph: *"I agree-- keep as warning"*. The commit reads: "the surprise is caught by a parser Warning, not a semantic change".
- **Bears on Q1 (method):** a warning was used to flag a surprising-but-kept reading instead of changing the rule. This particular rule was later superseded by the uniform scan.

**2026-07-14 15:39 — escapes on late colons** (L16202). Joseph: *"`\:later-not-real-attribute -->  :later-not-real-attribute -- (if after other child elements/prose) also0 not necessary, but safely ignored.`"*
- **Bears on Q3:** in his model at that time, a late `:` line was already text.

**2026-07-15 13:25–15:21 — the attribute-model brainstorm (Joseph + Claude Fable 5).** The durable record is `design/attribute-model-2026-07.md` (`54c52d2`, 14:45). Its rule 4 reads: *"Nothing (EOL or comment) → boolean flag, `true`"*, and §7 says *"Valueless-attribute-=-true stays"*, with `?` as a naming convention only.

Joseph at L16327 (14:04), brainstorming in examples. He marks several things *ILLEGAL — error*:

```
:alpha <something-here> ; anything else other than a comment and whitespace-- anything that tries to be prose or an indented subsequent line-- ILLEGAL -- error-- alpha is just one thing per invocation.
…
|el :alpha :beta ; same-line semantics (IIRC) - alpha=true, beta=true
…
|el |another :alpha <some value> ; all good
  :attribute-for-el  ...  ; ILLEGAL currently-- |el already started accumulating children.
```

and he closes with *"My thinking was evolving as I wrote through that-- so something I said later might supersede my earlier thoughts. This is *all* still provisional and brainstorming"*.

The same message proposes the warning-placement guideline: *"if you have to do additional lexical / descent work in order to get the warning you need, punt to the AST builder…"*

At L16330 (15:05):

```
|el
   :attribute?
     \
   ; that one wanted an explicit whitespace/newline -- so warn that '?' isn't boolean I would think?
```

At L16331 (15:21), the revisable:

> "The main thing that for *me* is still revisable in my mind.... if the implicit boolean attribute ends up causing too much ambiguity from the user's perspective (like where the reference attaches to after :label on sameline (a place where boolean + attach to parent element is the more surprising behavior) -- I might trade it for forced explicit boolean attributes:
> ```
> :some-bool? true
> :some-bool? false
> :some-bool? nil ; or whatever we decided to use there
> :some-bool? :more-attributes   ; defaults to true
> :some-bool? |etc  ; defaults to true
> :some-bool [anything else] ; binds to the attribute as its main value/type -- even an element etc., even on normal sameline...
> ```
> (this can be an aside at the bottom as still under consideration etc.)"

- **Bears on Q2:** this is where "plain attributes always take a value" came from. The motive was **binding** — what `:label |thing` on the element line attaches to — not error-detection.
- **Bears on Q3:** the attribute after a child is marked "ILLEGAL".
- **Incidental:** the `<…>`, reference, and scalar-then-junk examples.

**2026-07-15 ~16:49 — grok 4.5's reply on the §7.5 aside** (grok session `019f67df…`, the user-facing reply; its thinking passages were not used).
- *"I would **make the trade now**, not later — and I would make the **full** trade (plain attributes always take a value; `?` is the only valueless/flag form)… **Late migration is expensive.** Every document and fixture that uses `:disabled`-style flags becomes a silent meaning change if you flip later. Agents will mint implicit flags freely under today's rule."*
- Joseph at 17:21 (L16343) describes the next draft as *"the stuff you and I nailed down but with the change to explicit-boolean-flag-attribute-only in place"*.
- `design/attribute-model-proposal-3.md` (`722fbc7`, 20:37) §1.1: *"Missing value with no deferred block → **error** `MissingAttributeValue` (name TBD) — not implicit boolean true."* Its §5: a late `:` after the children phase is *"prose … with a **warning** (attr-looking after phase foreclosure)"*.
- The proposal's worked example contains the line `:this will get a warning but is normal text because additional attributes for |e were foreclosed when |child changed the phase to children...`. I could not verify whether Joseph or the agent wrote that line.
- **Bears on Q2 and Q3.** Note that the argument about migration cost is an argument about *meaning changing later*, which is the lite contract's concern too.

**2026-07-15 ~20:30 — Joseph's P3 rulings** (quoted verbatim in grok session `019f6a01…` as flanking text; his Claude-side twin is L16347).
- *"P3-5 -- Not sure the question, but terminal '?' for boolean-flag behavior."*
- *"P3-7 -- Defer to you. Warn only and pull in as normal text"* — P3-7 is the late `:` after the children phase.
- In L16347 he writes of a second value binding to an attribute: *"warn+array instead of error+halt or warn+drop"*.
- **Bears on Q3** (text + warning, ratified in these words) **and Q1** (warn-and-keep is preferred to error).

**2026-07-15 22:59 — CORE 0.9 Attributes written** (`8fa60af`).
- *"Plain attributes always take a value. … is an **error** (`MissingAttributeValue`, working name)."*
- "Phase Change and Late `:`": *"prose … with a **warning** (`AttributeAfterChildren`, working name) rather than an error."*
- Worked example: `|el :a 1 and a tail` / `:b 2` → `:b 2` is el prose + warning. This is still in today's `spec/CORE.md`.

**2026-07-15 23:28 — the anomaly ladder** (L16365). Joseph:

> "S6. right--- in that case 'tail' starts prose, and `:b 2` on its own properly indented line would cause a warning -- prose that looks like an attribute...  Not sure if we'll be able to give the warning if it's sameline, but same result.
> …
> S10. It seems we have several options:
>    (a) warn and don't drop anything - all is parsed/captured, just maybe not as author intended
>    (b) warn and drop something
>    (c) error and drop (more?)
>    (d) error and halt
>    (e) error and reject and halt
>
>    Seems like most of those are later AST-parser and even app-layer decisions that will depend on config they send to the parser etc. I **THINK** we've managed to find an (a) solution for pretty much every known issue so far, and at least at the core level, I hope that will continue.  We can make a table with those categories (or your refinement of them) and be more explicit that the later areas are waiting for more schema & AST parsing work to get done first."

- **Bears on Q1 directly.** This is the source of CORE's "Anomaly posture" table: rejecting a document is an app/AST-layer decision configured by the consumer, not a parser verdict.

**2026-07-16 02:19 → 02:36 — the Error's keep shape flips from "no value" to Nil.**
- Commit `ece0980` (02:19) first made the Error precise as: *"the attribute is emitted with **no** value event -- the parser invents nothing (no implicit `true`, no `nil`) -- … how the errored attribute materializes (key-present-valueless vs dropped) is a host/AST decision."* The same commit adds `|{input :required}  ; ERROR (MissingAttributeValue) -- write |{input :required?}`.
- Joseph, 17 minutes later (L16387):

  > "I would vote that the error in R2 would still emit the value with a nil. But that's me... I don't like losing data at the event level while we still have parsing work that can introspect those sorts of things and hand them back to us with reasons why we should do something else..."

- The CHANGELOG records it as: *"`MissingAttributeValue` = error event **+ synthesized `Nil`** (the stream never carries less shape than the source suggested)"*.
- Also that night (L16391), on `?`: *"We chose the '?' suffix specifically to *align* with the '$?' attribute being boolean and defaulting to true… `$?` is a simple desugar."*
- **Bears on Q2:** "Error + nil" is itself a keep shape, and it was chosen *because Joseph did not want the event layer to lose anything*. The neutral file's option A carries this shape.

**2026-07-16 03:36 — delegated minor rulings** (`fa28403`).
- *"tabs illegal in indentation only"*: the `NoTabs` error, and the line is dropped.
- *"`AttributeUnderAttribute` recovery = open attr gets its `Nil`, error explains, offending line's bytes kept as element prose"*.
- **Bears on Q1:** at this point there were three core errors — missing value, attribute-under-attribute, and tab — and later ones were demoted.

**2026-07-17/18 — two-level severity and the incomplete-input result.**
- A grok review note relayed by Joseph (L16611): *"MissingAttributeValue on OPEN mode is semantic-at-close (correctly out)."* The ruled text (CHANGELOG): *"Semantics (needs-a-value, cardinality, schema) are *not* this mechanism — they are close-time checks by whoever owns the construct."*
- Joseph (L16612, 01:32):

  > "I think warning ~= content preserved, but possibly not what was expected or desirable for the future
  > error ~= something was lost.
  >
  > In this instance we can do both: Warnings as appropriate as we unwind the stack, and then we can also, if we want and the grammar is not to difficult to augment, throw an error out there and return a non-success result on the command line if any of these EOF delimiter things didn't meet their expectations by assuming that that means data *was* lost-- just not by us or the author necessarily -- and throw if necessary one final "Unexpected EOF" before the final exit.?"

- CHANGELOG, ruled: *"Warning = content kept; Error = something lost."* A still-open delimited construct at true EOF → the parse **result** is non-success (a result, not a wire event).
- **Bears on Q1 directly:** the language already has a *per-document* non-success signal (incomplete-input) that is separate from per-construct anomalies. Note the "~=" and "possibly not what was expected or desirable **for the future**" in his wording.

**2026-07-18 12:33 — "warn before disallowing" in Joseph's words** (L16638). On whether strings, arrays, and so on may span lines:

> "The current version of udon expects these to be closed on the same line they were started on; multiple lines is currently undefined in udon but we hope to add multiline in once we are sure we have understood all of the consequences and nuance. In the meantime, use multi-line at your own risk. (If it does become illegal, the parser will issue warnings at that point)."

- Same message:

  ```
  :attribute-3?
    |value ...  ; warning, bool or null expected.
  ```

- CHANGELOG, 2026-07-19 (S2): the current behavior is ratified as *"close enough to undefined-but-we'll-warn-before-disallowing"*. Fixtures that pin that space must be labeled *"PINS CURRENT BEHAVIOR"* so "purposefully-unspecified behavior cannot calcify".
- **Bears on Q1:** until now, warnings have been the zone that is *allowed to change later*.

**2026-07-18/19 — what does not count as missing** (CHANGELOG R13). *"Empty forced-text is a real, kept value — `:a \` ≡ an empty string … no warning, not `MissingAttributeValue` — a user's deliberate empty value, peer to `:a ""` and `:a nil`."*
- **Bears on Q2:** where the line between missing and empty is drawn.

**2026-07-19/20 — the greenfield clean-room rewrites** (archived `.archived/first-pass/`).
- Grok's 3b SEMANTICS §5: *"Keep-Everything implies the ADM may contain Warning-annotated structure that a strict Schema would reject… A Host 'valid document' predicate is Schema/Document-layer and MUST be stated separately from Core equivalence."*
- 3b's own notes: *"Keep-everything stays recognition law; reject/halt become Consumer knobs (menu). That preserves LLM/stream partial-input honesty and gives 'strict mode' a place that isn't a second dialect of the language."*
- The "valid document predicate" sentence survives verbatim in 0.9.1 and 0.10.0 SEMANTICS §5. The 0.10.0 version adds "(a late attribute compares as the attribute it is)".
- **Bears on Q1 directly:** this is the only prior place I found where "valid document" is named, and it puts validity *outside* the core.

**2026-07-20 01:02 → 07-21 02:49 — L0, "Error = loss only."**
- A Claude agent's delta, relayed by Joseph to grok (grok session `…greenfield-3b/019f7d71…`), proposed *"a new L0 — the severity definition itself (Error = loss-only vs loss-∪-illegal-geometry)"*.
- `RULING-SUPPLEMENT.md` §3.0 frames it as the *"one genuine grok/Fable split"*:
  - **A (strict loss)** is Fable's position.
  - **B (loss ∪ illegal geometry)**, *"'this cannot mean anything as written' … a tab in indentation is worse than a stylistic wobble,"* is grok's lean.
  - *"What actually rides on it: only the severity *labels* on L1/L4 (and the schema/CI story — 'fail on error' means different things under A and B)."*
- It landed in `DECISIONS.md` (commit `359fed3`, the grok overnight run) under **"Operator / panel-lean closes … Overturn freely"**: *"Error = loss only … (unless a more specific rule names Error for absent intended value — e.g. plain `:key` → Nil+Error under R6). … Schema/CI 'fail on error' means *loss*, not style."*
- L1 (top-level `:key` → warning + text) and L4 (tab → warning + keep, reversing the dropped line) landed the same way.
- **I found no Joseph statement ruling L0** among his Claude Code prompts. Grok transcripts were only searched via memorata.
- **Bears on Q1 directly.** The missing-value Error is an *explicit exception* to L0, written into L0 itself.

**2026-07-21 — "verdict" vs "anomaly"** (`udon-needs/pipeline-discussion.md`).
- Grok: *"schema compliance, dialect-check failure, and incomplete-input are all verdicts at different stages; anomalies are the *per-construct* journal that can feed a verdict without being one."*
- Fable, after Joseph's challenge to the four-stage pipeline, keeps *"the verdict/anomaly distinction"* among the parts that survive.
- Joseph's own list of later-stage concerns includes "schema compliance" and "potentially, unmet expectations".
- **Bears on Q1:** "valid lite" would be a *verdict* in this vocabulary.

**2026-07-22 — 0.9.1 consolidation** (`spec-0.09.01/CORE.md`).
- §14.1 *"Two severities, defined by loss"* names *"the one current case"* of an Error that loses nothing: `:key` with no value → Nil + Error.
- In the as-committed text (`84454be`), §6.8 still made attribute-under-attribute an Error too (per L6). So the suite disagreed with itself about the count until K8.
- §6.9: *"All attributes of an element precede its content. Once content has begun … a later line-initial `:` … is **text** … with a **Warning**"*.
- Flags (`:key?`) live in §6.2.

**2026-07-28 22:06 — schemas by file naming** (L17694). Joseph: *"filestem.namespace.udon -> known namespace.core-udon-schema.udon -> depending on how strict the schema already has been, might reject or upsert."*
- **Bears on Q1:** rejecting a document is a *schema* act, and it is keyed by file name.

**2026-07-29 — "zero consumers"** (L17897) **and O17** (`DISCUSSION-THOUGHTS.udon`).
- Joseph: *"There are *ZERO* consumers of the ? syntax for elements as syntactical sugar or for attributes as boolean indications."*
- O17 (Joseph): *"? semantics were a forward-looking best guess that was the least complicated for the language. Forward looking to what? This. If the guess was wrong a little bit, great!"*
- **Bears on Q2:** the flag spelling that made "plain keys always take a value" livable was labeled a *guess*.

### August 2026 — the K-rulings and 0.10.0

**2026-08-07 21:53 — Joseph on the four-state model** (L18796):

> "I kind of feel we should *not* dissolve the absent/nil/false/true model-- which would mean that the next "things different about attributes are" thing is "they require a value -- use `nil` the way `nil` is meant to be used semantically. Alternately, leaving it blank is an implicit nil (not absent) but I feel like that would potentially lead to some difficult grammar issues... I could be wrong though.... maybe ask the spike agent to push on that some more...."

- Before this, the spike agent's first proposal (`.archived/attr-as-element-spike-2026-08-07.md` §1.1(b), K5 row) had gone the other way: *"(i) empty content, silent"* — *"the principled consequence of 2c, and 'value required' moves to schema where constraint belongs"*.
- Its addendum (~21:57) retracts that:

  > "Joseph's grammar worry about implicit-nil is essentially unfounded … *Where implicit-nil actually costs* is semantic, and it's the **sameline mid-scan case**: `|el :a :b 1`. Today `a` gets Error+Nil — which is almost always right, because that input is almost always a deletion or a forgotten value … Implicit-nil silences exactly the anomaly that catches it … an edge with no terminus isn't a smaller edge, it's a malformed one. `nil` is the language's explicit 'this edge terminates at nothing.'"

- The same addendum makes `:key` + a deeper line holding `nil` alone produce Nil, silently.
- Joseph (L18806, 23:53): *"I'm on board; ratified."* This became **K6**.
- **Bears on Q2 directly.** The neutral file's options A and B were argued here, by the same agent, in both directions within an hour. The "required-ness belongs to schema" view was voiced and then withdrawn.

**2026-08-08 10:45 — K8: demote to warning** (L18813):

> "2. Demote to warning instead of hard error
> 3. 6.7/6.8 seam -- same: warn on second line if it looks like an attribute. We should do this for normal elements too but only if they are done w/ attributes"

- The K8 row: attribute-under-attribute becomes a Warning because *"K4 removed the legitimate nested-attribute intent the Error's L0 justification relied on, and warn-not-error keeps ATTR-GROUP's door open (warn-before-disallow)"*. It concludes: *"Sole remaining core Error: `MissingAttributeValue`"*.
- **Bears on Q1:** a warning was chosen *so that a future feature could still claim the syntax*.
- **Bears on Q3:** "warn … if it looks like an attribute … for normal elements too … if they are done w/ attributes" is still the *text* reading.

**2026-08-08 13:01 — the worksheet** (L18832). Joseph:

```
|element this prose is the first child ; this saved comment also on the wire usually
  :status pretty much open  ; This is attribute('status').value('pretty much open') -- no problem
  Some more children
  :a-rogue-attribute <value>  ; A warning is issued, but still becomes an attribute of 'element'

|element some prose :and now what is this?   ;  ALL PROSE (and maybe a warning)
…
```

- **Bears on Q3:** this is the first *accept + warn* reading.
- **Incidental:** the sameline cases, which K9/K10 later changed (sameline became value-space).
- Note that in case 1 he calls the sameline prose "the first child", yet `:status` after it is "no problem". That is consistent with K9, which ruled later that day that sameline text is `$main` and does not begin content.

**2026-08-08 (evening) — K9 draft's rider** (`theory/to-integrate/primary/K9-DRAFT-2026-08-08.md`): *"The K-series warned-accept tier for late attributes is NOT needed; genuinely-late attributes (after real block content) keep §6.9's existing warned-text treatment unless/until demand says otherwise."* This was agent text, ratified along with K9 and struck the next day (see K14).

**2026-08-08 23:57–23:58 — flags retire** (L18884, then its revision L18885):

> "1. no more warning now that multi-value attributes are the fresh new thing.
>
> 2. That reminds me, I think flag attributes were an overkill... Or rather, having them default to "true" and complicate the attribute-label / values  rhythm wasn't/isn't worth the awkwardness...  I'm thinking instead we make sure that we simply make sure that attribute identities get identifies that are a lot more expressive …"

- K12 records the consequence: *"a bare `:disabled?` is now a plain key missing its value → K6's Error+Nil"*. K11 records item 1: stacking is silent.
- **Bears on Q2:** after this, the only valueless form with built-in meaning is gone, so option A applies to *every* bare key, `?`-keys included. The neutral file's Q2-C cites this.

**2026-08-09 00:26–00:37 — K14: accept + warn.**
- A fork agent (relayed as an agent-message) found the worksheet and the K9 rider in conflict. It wrote the ledger version but flagged it: *"my own least-surprise read sides with his case 1 — post-K12, key-shaped things are deliberate, and a thing that looks exactly like an attribute silently becoming text is the bigger surprise."*
- Joseph (L18894, 00:30): *"accept and warn was the last thing I remember saying about it."*
- Joseph (L18897, 00:37):

  > "(All that said, in the previous case, I'm pretty sure that I rember implying early on that "later it's just text with a warning 'looks like an attribute but it's just text'" -- and then later as I was working on the cheatsheet in the other area, I realized how useful it could be to have attributes further down after more of the content -- but I don't know if it came up in this chat again or not... so probably truly somewhat ambiguous. Also, I've lost the other things surfaced so far in the scrollback-- so do your best, or bubble them up to me at some point ;-) )"

- The K14 row: *"Latest stated intent governs"*. It adds a consumer note: *"designated keys (`:$key` etc.) can therefore arrive late — streaming consumers must not commit identity before element close."*
- The conflict produced the "conflict-time protocol" banner now in DECISIONS.
- **Bears on Q3 directly.** The *reason* Joseph gives for accept is authoring usefulness (the paths cheat-sheet). The *reason* the agent gives is least surprise. His own summary is "truly somewhat ambiguous".

**2026-08-09 — the open decision sheet** (`msc/for-joseph/01-PLAIN-DECISIONS.md`, agent-written). The whole-status note (Sep 27) says D4, D6, and D11 are still open, and I found no answer to them in Joseph's prompts.
- **D4:** *"`\|task :done? :assignee sam` … Option A (drafted): `done?` is an ordinary label missing its value → Error + Nil (the deletion-detector working) … Option B: some gentler landing for bare `?`-labels"*, with the agent recommending A.
- **D6:** rename `AttributeAfterChildren` → `LateAttribute`, *"a name that sounds like the *old* it's-just-text rule"*.
- **D7:** the late-`$key` streaming note.
- **D9.3:** "content phase" is retired as a concept.
- **D11:** at core semantic equivalence, the lean is that a late attribute's *position* is not significant.
- `UNIF-PASS-QUESTIONS.md` Q5.1: *"'Content phase' is now vestigial … it is only the trigger for the late-attribute Warning."*

**2026-08-09/11 — 0.10.0-alpha.1** (`spec-0.10.00/CORE.md`).
- G7: *"Warning means kept-but-check, Error means something the author wrote for is genuinely absent (§14 — where the current inventory has exactly one core Error: the missing required value)."*
- §1: a conforming *recognizer* "Maps any finite UTF-8 input to a Document".
- §6.2: *"Every assignment takes a value — an edge with no terminus is malformed, not smaller."*
- §6.9: late attributes, accept and warn.
- §14.1: *"'fail on error' means a genuinely missing required value or truncation (`incomplete-input`), nothing else."*
- §14.2: the response ladder *"belongs to **consumers** … never a second recognition mode."*
- The §14.3 table is the neutral file's table. Appendix C vignette 3 shows all three anomalies together.

**2026-08-27 — 0.10.1-draft** (`spec-0.10.01/`; Joseph called it a misfire on 2026-09-01).
- G8: *"Misses are not recognition anomalies: their meaning comes from intended-cardinality, their response from the consumer."* This is about *reference* misses.
- DELTAS 11: *"a slot with only annotation material has no value material (ordinary missing-value rule)"*. So `|el :todo ;{fill in}` → Error + Nil, overriding 0.10.0's `""`. The Sep 1 audit notes: *"it makes the trailing-annotation idiom on a bare label an Error."*
- Late assignments are still accepted.

**2026-08-30 — tiny-parser request** (`INBOX-REQUESTS.md`, Joseph): *"It would need to warn when there are constructs (like references or directives or unknown data types etc.) that it encounters that it won't parse."*

**2026-09-01 — the 0.10.1-draft audit session** (L20781): *"So... seems like 0.10.01 mostly renames the parser to recognizer, says it doesn't do things *on purpose* instead of warning that nothing will handle it, and viola."*
- The alternative the agent wrote that session (`JOSEPH-FOR-0.10.01-FIX.md` — agent text, not adopted): *"A `:label` with no value is an error and holds nil."* And: *"Everything the author typed is in the tree. Warning means kept but check it. Error means a value is genuinely missing. Input ending inside a quote, `|{`, `<…>`, or fence is `incomplete`."*

**2026-09-29 — spec-lite** (L21298).

> "100% agreed on reserve, not ignore. That's definitely what I meant by deliberately disallowing it. In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly."

- `spec-lite-0.1.0/README.md`: *"Any document a lite parser accepts produces the same tree under every future full version of UDON."*
- **Bears on Q1 directly.** This is the first time "accepts" carries a *forward-stability* promise rather than a consumer's policy.

---

## Threads worth noticing

*(These are my readings, not findings from the sources.)*

**1. The missing-value rule has changed meaning four times, each time because of a neighboring feature, not because of the missing value itself.**
- null (2011) → `true` (Dec 2025, to keep explicit nil meaning "not specified") → Error without a value (Jul 15, 2026) → Error + Nil (Jul 16, to lose nothing at the event layer) → Error + Nil with no flag escape (Aug 8–9).
- The Jul 15 move was motivated by *binding*: what `|el :a |beta` attaches to. 0.10.0 now settles that binding through the Line Scan (block-form `|name` at a value position is the value). The *error-detection* justification ("deletion detector") arrived later, on Aug 7, from the spike agent.
- So the rule's current reason is not the reason it was adopted. The remaining trigger cases are narrower than the original ones: `:a :b 1`, `:a ; note`, `:a` at the end of a line with nothing deeper, `:a}` / `:a]`, and `:a` at EOF.

**2. The sole Error is an exception to its own severity law.**
- L0 says Error = loss. The missing value loses no bytes, and every version since 0.9.1 has had to state it as "unless a more specific rule names Error". Joseph's own Jul 18 wording ("error ~= something was lost") has no such carve-out.
- Meanwhile a *second* hard signal already exists that is not an anomaly at all: the incomplete-input result.
- The history offers at least three separate axes that the word "valid" could attach to:
  - *loss* (L0);
  - *intent absent* (K6);
  - *document incomplete* (the Jul 18 result).
- Nothing I found decides which one lite's "accepts" should track.

**3. Warnings have played two opposite roles, and Q1-B would pick one.**
- **Warnings as "not yet committed".** From Jul 18 to Aug 8 warnings were deliberately the *reversible* zone: multi-line "undefined-but-we'll-warn-before-disallowing"; descriptive-only fixture pins "so purposefully-unspecified behavior cannot calcify"; K8 choosing Warning because it "keeps ATTR-GROUP's door open".
- **Warnings as "kept, and here is exactly how".** K14's late attribute and L1's root text use a warning to label a *definite* keep shape.
- The neutral file's Q1-B turns every keep shape into a permanent promise. That is the second role applied universally, and it would close the doors the first role was holding open.
  - The clearest collision is `:label` under an open attribute body. K8 made it a Warning *specifically* to keep grouping sugar possible (OPEN ATTR-GROUP). Under B, its text keep shape becomes forward-locked.
- **Late attributes collide too.** Joseph's own account of the late-attribute ruling is "truly somewhat ambiguous", and it has already flipped three times: text → text + warning → attribute + warning.

**4. The only prior answer to "what is a valid document" puts it outside the core.**
- 2011 ("the implementation can decide"), Jul 15 (the ladder: "later AST-parser and even app-layer decisions"), grok 3b ("strict mode … isn't a second dialect of the language"), and SEMANTICS §5 ("A Host 'valid document' predicate is Schema/Document-layer") all point one way.
- The lite contract is the first place validity has to be a *language-level* promise, because it is a promise about *future versions*. That is a different kind of claim from "does the consumer accept this", and the history has no precedent for it.

**5. Two lines of argument about late attributes never met directly.**
- The case against (Dec 2025 analysis.md: "Ambiguous: is this for element or for the child?"; D9: attributes are "element header metadata") is about *reading*.
- The case for (Joseph Aug 9: "how useful it could be to have attributes further down"; the fork: "a thing that looks exactly like an attribute silently becoming text is the bigger surprise") is about *writing* and least surprise.
- K9 changed the ground under the first argument: sameline text no longer begins content, which removed the commonest "late" case.
- K14 then opened a problem that neither side weighed at the time: a late `:$key` means identity is not final until the element closes. That matters for streaming, and for any lite tool that indexes by key.

**6. The tab row carries a strictness history of its own.**
- Tabs went from "Be strict. … Fail fast" (Dec 2025, agreed) to "NoTabs error, line dropped" (Jul 16) to "Warning, keep as text" (L4, a panel lean).
- Under Q1-A a tab-indented file is not valid lite. Under Q1-B it is, and its keep shape ("line kept as text of current owner") is locked forever. Neither outcome has been discussed with lite in mind.

---

## What the neutral file misses

1. **The 2011 original was nil-on-missing.** `DECIDED.md` (2011-12): *"NULL: when attribute value or a label is missing"*. So Q2-B is the founding answer, not a new idea. Joseph's reason for leaving it (Dec 22, 2025) was to keep explicit nil distinguishable from "not written": *"by setting it to true when missing and making null explicit we retain a way to say 'this attribute is effectively *not specified.*'"* That reason bears on B as well as C.

2. **The case for B was made by an agent and withdrawn.** On 2026-08-07 the spike first argued "empty content, silent … 'value required' moves to schema where constraint belongs", then reversed within the hour. The neutral file gives A's reason (K6) but not the schema-owns-required-ness counterargument.

3. **"Error + nil" is itself a decided keep shape, with its own history.** It was first written as "no value event, nothing invented", and 17 minutes later Joseph moved it to Nil: *"I don't like losing data at the event level…"*. If lite ever needs to distinguish a written `nil` from an Error-produced one, this is where that was decided.

4. **Q2 shows only the mid-line case.** The rule also fires on, or pointedly does not fire on:
   - `:a` at end of line with nothing deeper;
   - `:a` + a deeper line holding `nil` → Nil, silent (K6/K7);
   - `:a` + a deeper body → the body opens, no Error;
   - `|{input :required}` → Error (Jul 16);
   - `:a \` → `""`, no Error (R13);
   - `|el :todo ;{fill in}` → Error in 0.10.1-draft but `""` in 0.10.0 (DELTAS 11);
   - `:a ; note` → Error;
   - `:done?` → Error (K12; D4 still open).

   Sibling file 89 (empty and degenerate forms) overlaps these.

5. **Q2-C is not only "retired by K12".** Between Jul 15 and Aug 8, plain `:key` was an Error *while* `:key?` still meant true. The Error was adopted only on the condition that the flag escape existed, and K12 later removed that escape. The D4 question (a "gentler landing for bare `?`-labels") was drafted and never answered in anything I found.

6. **Q1 omits the incomplete-input result.** Unclosed-at-EOF already makes the *parse result* non-success (ruled 2026-07-17/18). That is separate from warnings and errors. It is not in the table, and Q1's options don't say whether an incomplete document can be "valid lite".

7. **L0 was not ruled by Joseph in any record I found.** It came from a Claude agent's proposal (Jul 20), was argued Fable vs grok (loss-only vs loss ∪ illegal-geometry), and landed as a "panel-lean close … overturn freely". Joseph's nearest statement is the Jul 18 "warning ~= … error ~= something was lost". Option B of that old split — Error also for "cannot mean anything as written" — is a fourth reading of "valid" that Q1 does not list.

8. **The "valid document" precedent.** SEMANTICS §5 (from grok's 3b, carried into 0.9.1 and 0.10.0) says a host "valid document" predicate is schema/document-layer and must be stated separately from core equivalence. Q1 is, in effect, proposing to overturn or narrow that for lite. It should say so.

9. **Warn-before-disallow is a named strategy that Q1-B conflicts with.**
   - The neutral file notes one consequence: "a late attribute is still an attribute" could never become text.
   - The sharper case is the attribute-under-attribute Warning, kept as a Warning *expressly* so ATTR-GROUP could later claim the syntax (K8).
   - Multi-line values (file 05) likewise sit in "undefined-but-we'll-warn-before-disallowing".

10. **Q3 needs "what begins content" first.** After K9 and K14, "content phase" survives only as the trigger for the warning (UNIF-PASS Q5.1, D9.3). The 0.9.1 primer's note says the spec never enumerates which node kinds begin it: a reference child? a comment? a blank line? Sibling file 88 raises this. Q3's options are only well-defined once that is settled.

11. **Q3's consequences for identity and equivalence.**
    - A late `:$key` means an element's identity is not final until it closes (K14 consumer note; D7).
    - D11 (open) proposes that at core equivalence a late attribute's *position* does not matter.
    - D6 (open) proposes renaming the warning `LateAttribute`.

    None of these appear in the neutral file.

12. **The reasons behind Q3-A are mixed, and Joseph himself called them ambiguous.**
    - His position moved: "No" (Dec 2025, by agreement) → text, "Nothing to worry about" (Jul 11) → "ILLEGAL currently" / "Warn only and pull in as normal text" (Jul 15) → "A warning is issued, but still becomes an attribute" (Aug 8) → "accept and warn was the last thing I remember saying" and "probably truly somewhat ambiguous" (Aug 9).
    - His stated motive for accept was usefulness while writing the paths cheat-sheet.
    - The least-surprise motive came from the fork agent.

13. **The tab row's history** (fail-fast error → dropped line → Warning + keep) is not given. See Thread 6 for why it matters under Q1.

14. **A request that predates the lite framing.** Joseph's Aug 30 tiny-parser request asked for parsers that *warn* on constructs they can't handle. The Sep 29 lite decision is *refuse* ("reserve, not ignore"). Whether "refused" is a warning, an error, or a verdict is exactly Q1. It interacts with file 09.
