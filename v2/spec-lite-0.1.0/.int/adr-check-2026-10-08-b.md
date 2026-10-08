# Second reading of the 2026-10-08 records, batch b (commit `96852bd`)

*Written by the same independent second reader as `.int/adr-check-2026-10-08.md`, 2026-10-08, for the lite coordinator. I haven't edited any record.*

## What I read

- **The diff.** `git show 96852bd`, in full: four new records, the `TEMPLATE.md` footnote, and the amendments to `decision-authority`, `reserved-is-an-error`, `opaque-spans`, `inline-comments-in-prose`, the four fence records, `node-valued-attributes-in`, `references-in` and `sameline-element-is-child`.
- **The primary.** The two new Joseph messages in `.int/STEWARD-VERBATIM.md`. I checked both against session transcript `293bb1ee` (20:56:57Z and 21:19:05Z), and they match exactly.
- **The agent text in between.** I read it in the transcript (20:58Z, 21:02Z, 21:03Z, 21:07Z, 21:20Z), because the verbatim file summarizes all of it in one paragraph.
- **Pre-design files.** 05, 63, 75 and 79 Q4.

Each finding is marked **Fix**, **Ask** or **Tighten**, with the same meanings as last time.

Overall this batch is in much better shape than the first. The hedges are kept under the Quotes, inferences are marked, and the open asks are honestly scoped. Most of what follows concerns provenance, one Context that is wrong, and the footnote's home.

---

## Cross-cutting

### 1. The verbatim file's summary of the agent text before "Right-- nested attributes…" leaves out what Joseph was shown — Tighten, and it changes two records

The summary covers the 21:02Z and 21:03Z messages, but not the 20:58Z message. Two things in that message matter:

- **The agent restated Joseph's errors message as a list**, and the list included **"an unclosed fence"** and **"an unclosed quoted string or list"**. The agent also gave its reading of "tabs in block mode": indentation, plus between items on a structure line such as `:a 1⇥:b 2`, with tabs inside text, strings and fence bodies left as content. Joseph's next message questioned only one item on that list, the `:label`-under-attribute warning. He never contested the rest.
- **The agent proposed escape rules.** It put options A, B and C and leaned toward **C for quoted strings *and* every opaque span** (JSON escapes, any unknown `\X` kept as written), with **raw single quotes**. Joseph's Ruby message opens "Not sure I saw this question".

Consequences:

- **errors-stop-parsing** says an unclosed fence is an error only as "the agent reads this". It's stronger than that: it was explicitly in the restated list Joseph saw, and he queried a different item. The same goes for unclosed lists, which the working note calls "not named". They weren't named by him, but they were in the restatement. That is assent by non-objection, no more. Record it as that rather than as a bare inference.
- **opaque-spans** should record that the agent proposed changing the spans' escape rule to C at 20:58Z. Joseph's 21:19Z message then groups "typed values, keys, and embeds" under "our 'general matching + escaping'", which is different from strings. That reaffirms the any-`\X` rule in his own words, unprompted. It's stronger than the "I'm OK with your lean" the record currently rests that part on, and it settles the 20:58Z proposal for spans.
- **quoted-strings-like-ruby:** see below.

### 2. Where "Decided for this version" lives, and which version — Tighten / Ask

- **Home.** The footnote went into `TEMPLATE.md`'s "About this template (delete this section when copying)" section. That file is explicitly not a record and is excluded from link resolution. Yet the footnote now governs what `accepted` means for every lite decision, and it carries Joseph's quote. It is itself a decision of his about the corpus. A small decision record, with `decided-by: steward` and his quote, would be a sturdier home: records could cite it as `[[decision:…]]`, and it would sit beside `decision-authority`. The template could then point to it.
- **Version.** Joseph wrote "decided for **lite-1.0**" and "keeping it simple with **lite 1.0**". The footnote says "this version of lite", and the directory is `spec-lite-0.1.0`. He may mean "this first lite", or he may be thinking of a 1.0 release beyond 0.1.0. Quote his "lite-1.0" in the footnote. If the difference ever matters, for example if 0.1.x decisions are expected to carry into a 1.0, ask him.
- **Scope extension, made explicitly.** His answer was to the agent's question about three calls ("them"). The footnote applies it to every accepted lite decision. "No difference from the spec's perspective" is a general statement, so I think the extension is right. The footnote should just say that it generalizes his answer about three records.

---

## The new records

### errors-stop-parsing

- **OK:** `supported` on "My current lean", and the Quote is whole and exact. "#3 into #1" is explained correctly, and the warnings list is marked as the agent's reading.
- **Tighten:** "right now" (in "any *error* right now is a failure / stop") is the same kind of hedge as last batch's "for now". It's in the Quote and the word line, but not in the Outcome's opening sentence.
- **Tighten (provenance):** the unclosed fence and lists (cross-cutting 1). `<…>` in the unclosed list isn't in his "|,;,@" either. It's covered by "something missing a closing delimiter", so mark it the same way as the fence.
- **Fix: the note this record caused in `reserved-is-an-error` claims too much.** That record left open "whether the error is as drastic as in normal udon or streaming", for example "whether a parser may report more than the first one". The new working note there says errors-stop-parsing answers it. It answers *no tree*, but "stop/halt" doesn't settle whether a parser may keep scanning to report more errors while producing no tree, which compilers routinely do. Narrow the note to say no tree is decided, and that reporting more than one error is still open.
- **Gap for the inventory:** 0.10.0's top-level `:label` warning (12's table; file 04) is in neither list. That's fine for now, but it belongs on the inventory's to-decide list.

### nested-attributes-reserved

- **OK:** `steward` on "should be". The Driver is correctly marked as the agent's reading; the argument was the agent's 21:02Z "an error commits lite to nothing, so the grouping idea stays open". The scope note (directly under, versus anywhere in the body, as in K8) is a good catch.
- **Tighten:** "nested attributes **right now** should be a reserved construction". "Right now" is missing from the Outcome. Its Positive Consequence (a future sugar can give it meaning) already shows the intent, so the hedge matters less here than elsewhere.
- **Tighten (substance):** the Negative Consequence says a value body starting with `:word` text "must be escaped or quoted". Whether a line-start `\` escape exists in lite is still open (82), so cite 82 rather than presume it.

### quoted-strings-like-ruby

- **Fix: the Context is wrong about provenance.** "Joseph raised it unprompted while answering other questions" isn't accurate. The agent had asked about escapes at 20:58Z, with options A/B/C and its lean C plus raw single quotes. The verbatim file itself lists "escapes in strings and spans" as "still pending from before". Joseph answered with "Not sure I saw this question", meaning he gave his own answer without (perhaps) having read the proposal. That matters, because his answer differs from the agent's lean on two points:
  1. Single quotes take `\'`, so they aren't raw.
  2. Spans keep their own rule, rather than switching to C.
- **Fix: Considered Options don't match what was put.** The options listed are 0.10.0, the spans' rule, and Ruby. The options actually on the table were the agent's A, B and C plus "single quotes raw", and then Joseph's Ruby. Ruby was his own fourth option. A later reader can't see from this record that Ruby's silent drop of an unknown escape is *option A's* behavior, which the agent had argued against. That is exactly the still-open ask.
- **Fix: a reason attributed to him.** Driver 1 says strings "should behave like a string syntax everyone already knows (Ruby's) … (Joseph, under the Quote)". He gave no reason. "Everyone already knows" is the agent's gloss. Say "None stated", and keep "agents already know the rules" as a consequence.
- **Tighten:** his word was "**essentially** just like ruby strings". The title says "follow Ruby" and the Outcome says "behave like Ruby strings". "Essentially" is what licenses the `#{…}` exception in the working notes, so put it back in the Outcome. `\\` in single quotes is Ruby's rule but not in his words; his example shows only `\'`. Mark it as following from "just like ruby".
- **Tighten (consequence):** with raw newlines an error and `'…'` taking no `\n`, a single-quoted string can't hold a newline at all. That's worth a Negative Consequence line. The coordinator's 21:20Z idea, that a trailing `\` at end of line is an error, isn't in the record either way. Add it as an open note, since it was put to Joseph.
- **OK:** the reading of `|'something "hey"\'' weird node name` (element `something "hey"'`, then `$main` "weird node name") is right under Ruby single-quote rules. The working note on "arrays … keys" is a careful catch. It's genuinely new content from him, implying that `[…]` lists and `[key]` take the matched-plus-`\X` rule, so it should stay visible as open.

### column-shifting-whitespace-is-an-error

- **OK:** the Outcome renders his rule closely, and the Driver is his own premise.
- **Ask (sharpen the pending question): his two clauses can conflict.** "Any … in a spot that changes column positions for nodes is an error", "except as part of the `$main` text". But `$main` text can sit *before* a later same-line node:

  ```udon
  |p Intro⇥text |em x      ; the tab is inside $main text, and it shifts |em's column
  ```

  By the exception this is fine; by the principle it's an error. The coordinator's 21:20Z examples don't include this case (they put the tab after `:x 1`, or inside a final value). Its reading ("before a later marker → error") resolves the conflict in favor of the principle, but the question Joseph was asked doesn't show him the conflict. Add this example to the ask.
- **Fix: `closes: ["63"]` claims too much, while `awaiting-decision: true`.** 63's title also asks "is there an indentation unit?" Joseph didn't address that. Its sub-questions include a tab in a text block's stripped indentation, which the record's own open note covers, and root-level lines. Close it partially, or list it in `leaves-open`.
- **Tighten:** the "block mode" open note may be smaller than it looks. His 21:19Z principle (column-changing positions only) gives an answer for tabs *inside* block text: content, unless they're in the indentation that places the line. Only the case that genuinely conflicts needs to go to him. **79 Q4** (CJK and combining characters before a same-line marker) rests on the same premise ("make the true column position ambiguous"). It's correctly left open, and it's worth a line linking it to this premise for whoever decides it.

---

## The amendments

- **fence-closer-is-a-line, fence-nesting-by-length:** the closer-with-text error is now quoted to "I like our rules (recorded) for both of those as well, definitely", and the two cases are shown. That's correct. "the spec says so" renders "It would probably be useful to mention that nuance vs commonmark in the spec itself". That's a suggestion the coordinator adopted, so say "at his suggestion" (the closer record already does).
- **fence-line-comments, Tighten:** it's still `decided-by: delegated` and `awaiting-decision: true`. His "I like our rules (recorded)" is an act on the consequence of this record's "anything else is an error". Under the template ("When the decider acts, `decided-by` becomes `supported` … and `awaiting-decision` becomes `false`"), that part at least has now been acted on. Either update the record, or say why the courtesy flag stays: his words don't touch the ` ; `-allowance itself. Meanwhile errors-stop-parsing lists this error as decided.
- **opaque-spans:** the `;{…}` newline now rests on his words, with his reason (dedent ambiguity) attributed to him. The Outcome's lead-in still reads "Chosen, for `<…>` and `@{…}`, as Joseph's interim convention:" while the title covers `;{…}`. That's harmless, but align them. Add the reaffirmation from cross-cutting 1.
- **inline-comments-in-prose, sameline-element-is-child, references-in, node-valued-attributes-in, fence-body-indentation:** the "decided for this version" lines and `awaiting-decision: false` are consistent with his answer as generalized (cross-cutting 2). node-valued's follow-up kept as open work is right.
- **decision-authority:** the new working note is accurate. One observation for the pending value-set revision: after his "no difference from the spec's perspective", `decided-by` now carries almost nothing for lite's spec records beyond the word line. `steward` versus `supported` there tracks his phrasing ("I think" versus "my current lean"), not anything a reader acts on differently. That may argue for a simpler set, or for dropping `decided-by` from spec records in favor of his word plus the footnote.

## Anything decided and not recorded

Nothing substantive. Every clause of both messages lands in a record or an open note. The one candidate is his grouping of "arrays, typed values, keys, and embeds" under one "general matching + escaping" rule. It's currently a working note in quoted-strings-like-ruby. When the list and key rules are written it will want its own Quote, since it's the first time he has said lists and keys share the spans' rule.

## What I didn't check

- Records unchanged by `96852bd`, beyond their diffs.
- Whether the Ruby escape set listed at 21:20Z is complete (`\c`, `\M-`, and so on). It's pin work and marked as such.
- `main.outline.md` (uncommitted, outside this batch).

I'm available for follow-up questions.
