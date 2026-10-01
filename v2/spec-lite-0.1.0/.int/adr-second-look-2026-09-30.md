# Second look at lite's first eleven decision records

*Written 2026-09-30 (Mountain; about 2026-10-01T03:00Z) by a fresh Opus 5.5 agent at the udon-team agent's request, for that agent, who will carry what holds up into the records. I'm the same model as the author, in a separate context, so this is a second reading, not an independent lineage. I edited no record. Timestamps are UTC unless marked.*

*Mid-review, the coordinator told me that `reserve-not-ignore` (now `steward`) and `inline-elements-in` (now `ratified`) had changed on Joseph's answers, which are appended to `STEWARD-VERBATIM.md`. I had already reviewed the old versions. The findings below are against the **current** versions, and §2 covers the new answers.*

## What I read, and how

- **Read whole:**
  - all eleven records;
  - `.int/STEWARD-VERBATIM.md`, including the appended answers;
  - `sop/influx/proposed-decision-authority.md`;
  - `.int/README.md`, `.old/vsect-init/DECISIONS.md` and `.int/pre-design/STEWARD-2026-09-29.md`;
  - `.int/scratch-jaw.md`, `.int/reserved.md` and `sop/influx/udon-team-notes.md`;
  - `sop/src/ref-hazards.md`.
- **Read in two overlapping passes, nearly whole:** `adr/TEMPLATE.md`. A truncated `cat` skipped some of the body template between Options and What changes.
- **Transcript `5930da5d`:**
  - every typed turn from Joseph from 2026-09-29T23:55Z to the end of the session, in full;
  - the agent's whole 23:56Z reply;
  - all agent text and tool calls from 01:56Z to 02:26Z;
  - agent text from 00:18Z to 02:04Z, selected by grep (root, `def/`, references).
- **Transcript `fdcff70f`:** every typed turn from Joseph, plus the two agent messages his 2026-10-01T02:34Z and 02:45Z answers respond to.
- **Mechanical check.** Script output below:
  - every blockquote paragraph in `STEWARD-VERBATIM.md` (27, Joseph's and agent text) against the two transcripts;
  - every Quote line in every record.
- **Sampled by grep or by section:**
  - `06-suffix-characters.discussion.md` (identity characters) and `04-root-and-top-level-text.discussion.md` (pseudo-root);
  - `sop/adr/term-delimiters`, `lexicon-in-def` and `our-side-is-example` (Outcome and Quote only);
  - the heads of the example records `obj-reserve-dont-ignore`, `def-typed-value` and `rule-implied-root`;
  - `v2/INBOX-REQUESTS.md` (2026-08-30) and both `kinds.yaml` files (`decider`);
  - Joseph's 2026-08-14 burst file (verisectorium `theory/influx/model-2026-08-14/`, lines 70–90);
  - vivarium's `norm-decision-authority.md` (the "launder" line).
- **Checked in `~/.claude/history.jsonl`:** Joseph's 2026-08-07 pseudo-root message.
- **Not read:**
  - the other pre-design files and `jaw-proposal-and-feedback.md`;
  - `adr-check-notes.md` beyond its first 30 lines;
  - the principles survey;
  - `5930da5d` before 23:55Z, apart from turn timestamps.

## 1. The short version

- **The verbatim layer is clean, but it is a selection.** All 27 blockquote paragraphs in `STEWARD-VERBATIM.md`, and every Quote line in all eleven records, are exact substrings of the transcripts.

  The problem is what the file leaves out. Several of Joseph's words that bear directly on these records aren't in it: the "Remove … like dangle" turn, the backtick convention, the "lazy and sloppy" lexicon remark, and the "e.g., doc root" remark. Neither is some agent text that a decision only makes sense against (§3). Each omission lines up with a record that says less than Joseph did.

- **Outcomes that say more than the words:**
  - **`no-bespoke-parser`, the clearest case.** His words explain why he isn't worried about testing same-line capture. They don't choose an implementation route, and they don't touch his own 2026-08-30 request for tiny parsers.
  - **`references-vocabulary`:** "nothing is added" stands where he said "not *necessarily* add".
  - **`decision-authority`:** takes "the lean on each of its ten questions". One of the ten has no lean, and it asks what *Joseph* meant.
  - **`reserve-not-ignore`:** its reserved list is the agent's enumeration, cited against a quote that doesn't contain it.

- **Outcomes or records that say less:**
  - **`references-vocabulary`:** misses that Joseph directly removed `dangle`. It also names `collide` as possibly not applying, when "we will still want the rest" kept it.
  - **`implied-root`:** says "None recorded" for drivers. Joseph gave reasons for a root on 2026-08-07, and he cited "doc root" as a principled improvement eleven minutes after the unanswered objections were relayed to him.
  - **`term-typed-value`:** drops the option Joseph rejected, the agent's recommended "typed literal".
  - **`lite-lexicon-form`:** says his words were "Not located for lite". Two of his lite-specific calls exist, and so does a later explanation that the lexicon was deleted to be redone with more care, not abandoned.

- **`decided-by` is honest under the adopted definitions for nine of the eleven.** The two I'd question:
  - **`no-bespoke-parser` (`steward`):** the call itself is the agent's inference.
  - **`decision-authority`:** `supported` is right, but the support was given to a decision described in chat as "adopt the split" plus the question-10 convention, not to all ten leans.

  One definition in the template also drifts from Joseph's own words on what `ruled` asks of a reviser (§4).

- **Missed decisions:**
  - the tables deferral;
  - "put reserved ones in their own file and not explain them other than what characters or constructions are reserved" (02:12Z);
  - the 09-29 lexicon-file and backtick calls, which `lite-lexicon-form` would replace without a `supersedes` target.

  Nothing was recorded as decided that he only floated. His sameline/`$main` leans were correctly left out.

## 2. The answers appended mid-review (2026-10-01T02:45Z)

The question was the agent's 02:42:08Z message ("Three quick calls for you"). Point 1 listed the three records as "reserve, not ignore …; inline elements are in; `<…>` option 2" and asked: "Should any of them be `ratified`?"

- **`reserve-not-ignore` → `steward`.**
  - **The value holds.** He claims the call as his own ("essentially the first thing decided by me that was communicated to an agent").
  - **Open question:** which "very original explanation" does he mean? It is either his 23:55Z message or the 2026-08-30 tiny-parser request (`v2/INBOX-REQUESTS.md`). If it is 08-30, that text says lite "would need to **warn** when there are constructs … that it won't parse", and it lists "unknown data types" among them. The record says **refuse**. Warn versus refuse is exactly 12 Q1. The 08-30 text would then belong in the Quote, and `decided` might be earlier than 2026-09-29. One question to him settles it.
  - **The binary question was narrower than his answer.** He was offered `supported` or `ratified` and answered with a third act. Recording `steward` was right.

- **`inline-elements-in` → `ratified`.**
  - "yes" answers "should it be `ratified`?", so the value holds.
  - **The new working note writes his "critical objective" as `` `critical` ``.** In this corpus that is a force-level value (`force-critical-is-ctq`), and he wrote the plain word. Whether he means force `critical` is worth asking when the objective record is drafted. Until then, I'd quote his words rather than backtick them.

- **"not sure what 'option 2' is referring to."** That one is unanswered because the ask didn't restate the option.
  - `explicit-typed-value-in` still carries "For Joseph: `supported` or `ratified`?"
  - Next time, the ask could carry option 2's text: "carry `<…>` as an untyped box: lite parses where it ends and hands over the raw text, with no meaning attached".
  - A lesson for the template's "At the moment of assent, ask": a retroactive ask works only if it carries the content being asked about.

- **The rest of that message is still unanswered.** He did not answer point 2 (`lite-lexicon-form`) or point 3 (commit). The record is correctly still `proposed`.

- **`STEWARD-VERBATIM.md`'s new entry needs two things.** It has no timestamp (02:45:43Z on 2026-10-01). And it doesn't quote the 02:42Z question, without which "yes" and "option 2" can't be read. The file's own header promises to include "the agent text he was answering" where a decision rests on it, and two `decided-by` values now rest on this one.

## 3. `STEWARD-VERBATIM.md`

**Verbatim: yes.** A script compared each blockquote paragraph to the concatenated message text of both transcripts: 27 of 27 found. The only Quote line in `adr/` not found is the template's placeholder. I also read the 00:02Z, 00:18Z and 02:34Z messages against the file by eye.

**Small fidelity points:**

- **"On the purpose layer" drops its list prefix.** It begins "Perfect.", but the message has "3. Perfect.".
- **Gaps aren't marked.** The same 02:34Z message's "2. That's your first set of work, yes. Feel free to delegate…" is left out with no ellipsis. Several record Quotes are also mid-message fragments with no marker, e.g. `term-typed-value`'s "add entries … for "(implicit/explicit) typed value"" and `references-vocabulary`'s second quote.
- **The `fdcff70f` entries carry no timestamps:**
  - 2026-09-30T16:47:07Z for "how to proceed";
  - 2026-10-01T02:34:28Z for decision authority, which is 2026-09-30 20:34 Mountain, consistent with `decided: 2026-09-30`.

**Omitted words that bear on these records** (all verified in the transcripts):

| When (UTC) | Words | Bears on |
|---|---|---|
| 2026-09-29T23:56:21Z (agent) | the agent's **In** and **Reserved** lists ("`!` in all its forms. That includes `!:kind:` code blocks…"; "`@` references, both `@name` and `@{…}`"; "`!{{…}}` interpolation") | `reserve-not-ignore`'s third Outcome bullet, which cites a quote that doesn't contain it |
| 2026-09-30T00:18:03Z | "Ideas and comments and decisions by me need to be in those files but they don't necessarily have special status over ideas and discussion and pushback from any agents…" | `decision-authority` (context for "not set in stone") |
| 2026-09-30T00:50:22Z (agent) | relays to Joseph that the no-root position's reasons "(streaming, fragments, host APIs, duplicate-key scope) were never answered on the record" | `implied-root` |
| 2026-09-30T01:01:23Z | "after trying out lots of stuff, the decisions *have* gotten more principled and useful (e.g., doc root)" | `implied-root` |
| 2026-09-30T02:08:00Z (agent) | recommends "typed literal"; "If you prefer 'typed value,' I'd make it 'explicit typed value'" | `term-typed-value` (a missing option) |
| 2026-09-30T02:14:02Z | "Remove from lexicon entries that are not applicable to lite- like dangle" | `references-vocabulary` |
| 2026-09-30T02:14:18Z (agent) | what remained after the removal: "name, binding, mint, maintainer, collide, scope, containment, root-scope and location" | `references-vocabulary` (the referent of "the rest" at 02:17Z) |
| 2026-09-30T02:21:57Z | "When we are referring to lexicon-defined terms, let's put them in backticks-- so that `typed value` is clearly a term and not just gloss." | `lite-lexicon-form` (cites "02:21Z" for this, but the file's 02:21Z entry is a different message) |
| 2026-09-30T02:26:26Z | "I'm sorry, but this is really sloppy. … let's delete it and wait for a more fresh agent who is willing to do it a bit more carefully." | `lite-lexicon-form` |
| 2026-09-30T16:47:07Z | "FYI there was an attempt at a lexicon but it was... well, it was lazy and sloppy so I had the agent delete it so it could get done with a little more thoughtfulness and rigor." | `lite-lexicon-form` |
| 2026-10-01T02:42:08Z (agent) | the "Three quick calls" question | §2 |

Two more sources sit outside these sessions:

- **2026-08-07T17:29Z** (`~/.claude/history.jsonl`, verified): "having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc." This bears on `implied-root`.
- **2026-08-30, `v2/INBOX-REQUESTS.md`:** bears on `no-bespoke-parser`, and possibly on `reserve-not-ignore` (§2).

His 01:19–02:01Z sameline and `$main` leans are left out too. That is defensible, since he labeled them "not a final verdict". But `STEWARD-2026-09-29.md` quotes them with elisions, and they will be the Quote for the 01, 13 and 60 decisions. Copying them whole now would save a later trip to the transcript.

## 4. Record by record

### `reserve-not-ignore` (`steward`)

- **The third Outcome bullet goes beyond the Quote.** It reads: "Out of lite, and reserved: `!` in all its forms (including `!:kind:` code blocks), `@` references, and `!{{…}}` interpolation."
  - That is the agent's 23:56Z Reserved list. The Quote is the 00:02Z message, which speaks only to the principle.
  - Joseph's own words for the list are 23:55Z, "(!,@,etc.)". Taken literally, those cover `!:kind:`.
  - So the bullet is fair, but its grounds should be named under the Quote: his 23:55Z parenthetical, plus his not objecting to the agent's list. That second part is `supported` weight, not `steward`.
- **The negative consequences understate the cost.** 09's history found that live corpus documents use `!:md:`, `!:sh:` and `!:text:` (vivarium, ASF), and use `@{term}` about 190 times in `.ud` files.
  - Under this Outcome, those documents are not valid lite, and they belong to the population lite exists to serve.
  - That is sharper than "Some ordinary prose may be refused." It is also a reopen condition worth a bullet of its own.
- **The positive consequence's citation is correct.** The 08-30 request does say "aware of what it (or each one) can't do". It also says "warn" (§2).

### `inline-elements-in` (`ratified`)

- **The driver overstates his words.** It reads "lite is meant to stand in for XML and HTML". He said "one of the most obvious use-cases-- xml/html", and on 2026-10-01, "being able to represent xml/html is a critical objective". "Represent" is narrower than "stand in for". I'd use his verb.
- **The working note's `` `critical` ``:** see §2.
- **Otherwise sound.** It defers the rules to 10, 50, 51 and 59 correctly.

### `explicit-typed-value-in` (`supported`)

- **The catch on "text and optional type label" is right, and it matters.** The rendering is traceable to the agent's own 02:08:00Z paraphrase ("carry the text and the optional type label"), not to option 2. Naming that origin under the Quote would close the loop.
- **"Dates, times and durations are not typed in lite" is flatter than his "for now … we might go ahead and reattach the temporal parser".** The record keeps "for now", but it lists the reattachment under Reopen when, as a falsifier. He framed it as an anticipated step of the same decision. It also appears under Assumptions, where it is a plan, not an assumption.
- **A tension with `term-typed-value`.** This record's title says "carries `<…>` untyped", and the other says every value has a type. Lite carries a typed value whose type it doesn't read, which is not the same as "untyped". The title could say "carries `<…>` unread", or "without reading its type".
- **The "option 2" question is still open** (§2).

### `suffixes-lose-special-status` (`steward`)

- **Joseph said "identity character". The record renders it as "ordinary name characters".**
  - In UDON, identity is the key and traits bundle (CLAUDE.md: "identity `key`/`traits`"; 06: "identity is contiguous except the trailing space-separated suffix").
  - 06's history found the exact move made in his words for **traits** (2026-07-12, "just add *!?+ to allowed identifier characters") and for **attribute labels** (K12). It found no record of it for element names.
  - So "name character" may narrow his meaning to the one place it was never recorded.
  - I'd quote his phrase in the Outcome and leave which tokens it covers to 06. Most real uses sit after a key (`|process[k]?`), which a name-only reading doesn't reach.
- **Keeping "reserved in lite" open revives the option he answered against.**
  - The agent's lean was "leave them out of lite". His reply chose retirement of special status instead, and reserving the old positions keeps them special.
  - Holding it open is defensible only because of his own hedge ("pretty sure (we'll need to look into it)").
  - I'd say that explicitly under the Quote, and take 06's finding back to him as the "look into it" he asked for.

### `ast-centric` (`steward`)

- **The modal is softer than the title.** He said "Lite *can* be specified as AST-centric for simplicity", and the record says "Lite is specified as…".
  - I read it as his call. He proposed it unprompted, and the agent's 00:26Z summary listed "the tree as the spec" as decided without his objecting.
  - But the modal deserves a phrase under the Quote.
- **The driver could cite his 00:18Z sentence.** "Simplicity" is his word. In the same message he wrote "I will be very persuaded by things that simplify the grammar or rules without violating the principle of least surprise", which is citable and ties the driver to [[prin:simplest-grammar-without-surprise]].
- **"A parser may still stream internally" is the agent's addition.** It is harmless, but it is not in his words.
- **His later leans are the tree-content questions this record leaves open.** These are 01:28Z ("if we decide (and I think we will) that the AST should have room for metadata on the nodes") and 02:01Z (content < content+meta < content+meta+ornament). A pointer from Working notes to `STEWARD-2026-09-29.md` would keep them findable.

### `implied-root` (`steward`)

- **Drivers: "None recorded beyond the Quote" is not right.**
  - His 2026-08-07 reasons are recorded and his own: a pseudo-root "solves the open 'what to do with attributes at top-level' question" and the "partial vs whole-record vs store of records" question.
  - They weren't restated on 09-29, so mark them as earlier grounds, not at-decision.
- **The negative consequence, as written, isn't true of the record.** It says the old position's reasons "are not answered by any recorded reasoning".
  - His Aug-7 words claim to answer two of them: fragments (partial) and multi-root (store of records).
  - Streaming, host APIs and duplicate-key scope remain unanswered.
- **The "unless someone feels we need to adjudicate it" gate has a history now.**
  - At 00:50:22Z the agent relayed the unanswered objections to him.
  - At 01:01:23Z he cited "doc root" as an example of decisions having become "more principled and useful".
  - That doesn't answer the objections, but it shows he saw them and didn't take up adjudication. It belongs under the Quote.
- **Context date.** "From December 2025": `design/udon-ast.md` was first committed 2026-01-14, and both history agents date the position Jan 2026. The record also omits the immediate predecessor, his own Aug 6–7 `$DOCUMENT` pseudo-root, which is what 09-29 settled on.

### `no-bespoke-parser` (`steward`): the weakest record

- **His words don't choose an implementation route.**
  - The quote is context ("very, very similar to the actual mainline udon … bespoke python parsers that got thrown away …").
  - The sentence it serves is "So I'm really not worried about 'Making sure same-line capture works'".
  - It answers the agent's offer to build a Python reference parser in this pass. "No Python reference parser now" is a fair reading at `supported` weight, with the reasoning his.
  - "Lite is implemented through the mainline descent grammar. No bespoke lite parser is needed." goes further.
- **"Mainline" is a problem.** In the same sentence he calls mainline "the actual mainline udon that we are replacing here in v2". So "the mainline grammar" as lite's route may mean the wrong artifact: the descent *approach* or toolchain, versus the 0.9 grammar file.
- **It may set aside his 2026-08-30 tiny-parser request, unasked.** That request was for "tiny, dependency free" parsers "in the host languages", which a descent-only route excludes. The record's working note sees this; the Outcome doesn't wait for it.
- **Suggestion:** narrow the Outcome to what he said, call the value what it is (his reasoning, an agent's reading of the choice), and put the route and the 08-30 question to him.

### `references-vocabulary` (`steward`)

- **"Nothing is added to the addressing theory's `def/`" hardens "let's not *necessarily* add".**
- **Which terms apply was partly settled that night, and the record gets it backwards.**
  - At 02:14:02Z: "Remove from lexicon entries that are not applicable to lite- like dangle". The agent then removed dangle, reference, referent, designator and generator.
  - At 02:17:03Z: "with the possible exception of containment we will still want the rest". The rest was name, binding, mint, maintainer, collide, scope, containment, root-scope and location (agent, 02:14:18Z). So `collide` was kept by his words.
  - The Outcome's example, "the failure terms dangle and collide", treats both as undecided.
  - Root-scope was then dropped on the agent's own analysis, after his "(are you *sure* …?)". He didn't confirm the drop. Scope was flagged by him as undecided (02:19Z).
- **The designator note omits the agent's answer.** It should record that the agent answered at 02:13:19Z: under def/'s third edition the key is the *name*, and designator is the use side. He didn't respond, so it is still his to confirm in 77.
- **"Lite is very specifically and conspicuously missing addressing" is itself a scope statement.** Nothing records it except as context here. It may deserve its own line, or a citation from the reserved-syntax rule.

### `term-typed-value` (`steward`)

- **Considered Options misses the agent's recommendation.** The agent recommended "typed literal" (RDF precedent) at 02:08Z, and he chose "(implicit/explicit) typed value" instead. That strengthens `steward`, and it is information a later reader needs.
- **"Explicit" and "implicit" have recorded origins.**
  - The qualifier "explicit" was the agent's fallback ("I'd make it 'explicit typed value'").
  - The explicit/implicit pair is his own, from his scratch list (`.int/scratch-jaw.md`: "explicit `|el <42>`", "implicit `|el 42`").
  - His list is the better source for the Outcome's examples than an inference.
- **"An implicit typed value is a bare spelling" adds a definition he didn't give.** It conflicts with the example `def:typed-value`, which says implicit covers quoted strings and lists and tells readers to avoid "bare value". The record's own negative consequence sees the gap. I'd drop "bare" from the Outcome and let 66 and 72 define it.

### `decision-authority` (`supported`, agent decider)

- **The support was given to what the chat described.** The 2026-10-01T02:26:29Z message described the decision as "I'd adopt the split for lite", plus following question 10. It also offered "or would you rather answer the authority proposal's questions yourself first?" He declined that and supported "your decision".
  - So `supported` holds for the split and the question-10 convention.
  - For the other leans, the honest note is that he didn't answer the questions himself and supported the agent's decision as described. Whether he read the ten is not recorded.
- **"Taking the lean on each of its ten questions" is not quite accurate:**
  - **Q7 has no lean.** It reads "Your call. It is the reading this proposal rests on.", and it asks whether "path, not license" reconciles his statements *as he meant them*, which an agent can't answer for him.
  - **The Outcome credits his note with Q7.** It says "it is what Joseph asked to have recorded". He asked to record "not set in stone". The path reading is well supported, but by his 2026-08-14 burst ("All very different statements about … what the remediation is"), not by the 09-30 note.
  - **Q8 and Q9 are about the SOP store's records and grant.** The Outcome generalises Q9 into a lite rule ("Calls made under a grant are in force before the decider acts"), against RONR's default, which the proposal itself flagged.
- **The `ruled` row drifts from Joseph.** It reads "don't reconstruct the reasons", and the template reads "rather than reconstructing the reasons". His 2026-08-14 burst (`steward-failure-modes-2026-08-14.verbatim.md`, lines 85–90) prescribes the opposite first step: "let me make sure i've thought through my best understanding of why that decision was made, and then I'll bring it up with Joseph, have him verify whether my assumptions about why it was made are true".
  - The proposal's own wording kept that step: "Check your understanding of why it was made with the decider, then decide together".
  - The landing dropped it. This is `ref-hazards`' "condition lost between the check and the landing".
  - I'd restore the proposal's wording in both places.
- **The driver's 08-14 quote is verbatim.** I opened the file the record says wasn't opened; the record writes his double quotes as single quotes. The vivarium "launder" quote is also verbatim.

### `lite-lexicon-form` (`proposed`)

- **"Quote: Not located for lite" is wrong.** His lite-specific words exist:
  - the lexicon file (02:12:55Z);
  - backticks for terms (02:21:57Z);
  - the deletion "and wait for a more fresh agent who is willing to do it a bit more carefully" (02:26:26Z);
  - "lazy and sloppy so I had the agent delete it so it could get done with a little more thoughtfulness and rigor" (2026-09-30T16:47Z).
- **The Context reads the deletion as abandonment.** "The lexicon file was deleted the same night" reads as though the single-file form was set aside. His words say it was deleted to be redone.
- **His newest words on delimiters do mention domain terms.**
  - SOP side, 2026-09-30 (`sop/adr/term-delimiters` Quote): "officially defined terms should always be deliniated … ‹...› for domain-defined".
  - That is a move away from backticks for exactly these terms, which supports the proposal. It belongs in the Quote, with `our-side-is-example`'s "leave it to the udon team" explaining why it doesn't decide lite.
- **This proposes to replace two of his 09-29 calls, but no records exist for them to supersede.** That is the shape the earlier SOP second look flagged in `adr-check-notes.md`. I'd either write the two small records, or name them in Context as the parts this would supersede.
- **Two independent choices are bundled.** One is storage (`def/` records versus one file) and the other is the delimiter. Splitting them would let him answer each in a word.
- **The driver "Backticks are needed for code" is a reason to revisit his call.** Put it to him as that.

## 5. Possibly missed decisions

1. **Tables, deferred** (00:02Z): "I'm ok leaving that decision for tables for now. What about `|---|---....` ?"
   - It has two readings:
     - he agreed to the agent's "keep structured tables out of lite 0.1.0";
     - or he deferred the whole question.
   - The template's `awaiting-decision` exists for this deliberate-deferral case. At minimum, the deferral should be recorded as his, with both readings.
2. **How the reserved list is written** (02:12:55Z): "Let's put reserved ones in their own file and not explain them other than what characters or constructions are reserved."
   - It is his call on form, and it bears on Part VII's `rule:reserved-spellings`.
3. **The 09-29 lexicon-file and backtick calls** (§4, `lite-lexicon-form`).
4. **Weaker candidates:**
   - the scope statement "lite is … conspicuously missing addressing";
   - "visit [the undecided issues] as they come up logically as the spec is actually assembled" (16:47Z). This is process, and maybe the SOP side's.

None of the eleven records something he only floated. The softest are `ast-centric` ("can be"), which I'd keep with a note, and `no-bespoke-parser`, which I'd narrow.

## 6. Smaller things, across records

- **The "What changes" lines point at example records.** They name `obj:reserve-dont-ignore`, `rule:implied-root` and `def:typed-value`. Those exist only as `example` rows, which "never land as they stand". They were written, Joseph said on 2026-09-30, by an agent who was "NOT an expert on UDON".
  - The lines are right about the records to come.
  - Phrased as "X states it", they read as already true.
- **Some drivers are the agent's arguments, attributed but not marked.** Examples are `explicit-typed-value-in`'s "Forward safety" and `reserve-not-ignore`'s second driver. The template asks for the "(**inferred, unconfirmed** …)" marker for drivers the deciders didn't give. These are attributed but not marked. The attribution is honest, but the format is inconsistent with the template.
- **The re-grade notes under the Quote match the template.** Examples are "first recorded as `supported` … corrected on his answer". The template's After-acceptance rule allows them, so this is not a history leak.

## 7. On the brief, and nearby

- **The brief was good.** It named the hazard, pointed to the primary sources, and asked whether Outcomes say more *or less*. Most of what I found is on the "less" side, which a "check for overclaim" brief would have steered me away from.
- **The mid-review heads-up was well-timed.** The "option 2" non-answer it led me to is the most useful process lesson here (§2).
- **A possible gap in the template's "At the moment of assent, ask" bullet.** When the ask comes later, it carries the text of what is being asked about, and it offers the decider every act, not just two.
- **Context for `decision-authority`.** The 00:18Z paragraph ("decisions by me … don't necessarily have special status over ideas and discussion and pushback from any agents") and burst 3 of 2026-08-14 ("task-mode-laziness-by-abdication") are Joseph's own context for why the `decided-by` labels should invite reopening rather than deference. Citing them in its drivers would make the record's purpose harder to misread later.

I'm available for follow-up questions.
