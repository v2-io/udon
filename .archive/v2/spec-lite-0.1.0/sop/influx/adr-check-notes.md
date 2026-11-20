# Second look at the 37 process decisions in `sop/adr/`

*Written 2026-09-30 (late evening Mountain time; 2026-10-01 ~00:50Z) by a fresh Opus 5.5 agent at the coordinator's request, for Joseph and the coordinator. The records have not been edited. I'm the same model as their author, with a separate context, so this is a second reading, not an independent lineage.*

## What I read, and how

- All 37 records in full, `adr/TEMPLATE.md`, `sop/main.outline.md`, both `kinds.yaml` files, `sop/influx/jaw-proposal-and-feedback.md` in full, and the SOP records that cite the delegated decisions (`conv-references`, `conv-purpose-layer`, `conv-working-notes`, `conv-record-cadence`, `conv-column-notation`, `conv-fixtures`, `def-decision`, `def-record-fields`).
- **Mechanical checks** (scripts, results below):
  - every Quote in every record against jaw §1;
  - jaw §1 against Joseph's typed turns in the session transcript (`~/.claude/projects/-Users-josephwecker-v2-src-aat-refactored/073f016a-….jsonl`);
  - section-by-section conformance to the template;
  - `per:` back-citations for every decision;
  - the claim in `sop-decisions-follow-template` that no outcome was edited. I regenerated the original 22 records from the coordinator's own generator script (`scratchpad/genadr.py`) into a scratch directory and diffed them against today's files.
- **Semantic checks:**
  - whether each Quote supports the specific Outcome. Many quotes are answers to numbered questions ("3. sure", "5. yes"), so I read the questions they answered in the transcript;
  - whether each delegated decision contradicts or narrows anything Joseph said anywhere, including his messages typed directly into the fork's thread (`…/subagents/agent-a709e77019230eca0.jsonl`).
- **Timing.** The records haven't changed since about 00:35Z. While I worked, other files kept changing: both `kinds.yaml` files (00:36–00:37Z), `conv-references` (00:38Z) and `adr/TEMPLATE.md` (00:42Z), probably the fork carrying out the ten decisions. Statements below about whether a "What changes" item was carried out describe the tree at about 00:45Z.
- **Files I left in the coordinator's scratchpad:** `convo.txt`, `joseph-turns.txt`, `qcheck.py`, and `adrcheck/`. My scratchpad turned out to be the same directory as the coordinator's. Nothing of the coordinator's was overwritten.

## The short version

- **The verbatim layer is clean.** Every Quote in all 37 records appears in jaw §1, and §1 matches Joseph's typed words in the transcript. The 22 originally generated records' Context, Drivers, Assumptions, Options and Outcome are unchanged by the reformat, apart from whitespace. That makes "outcomes were not edited" true for those 22. I did not regenerate the other four earlier records (written separately), so for them the claim is unchecked.
- **The delegated records need the most attention, but not for overreach.** When Joseph delegated, the coordinator's lean for each item was in front of him (the 23:23Z message), and all ten outcomes match those leans or follow closely from them. The problem is narrower. Three of them change something Joseph had already ruled on or agreed to, and present the change as not being one:
  - **force-levels** retires a level Joseph had agreed to keep;
  - **typed-reference-fields** carves an exception to "[[kind:slug]] everywhere";
  - **permanent-notes-in-body** makes "open work only" binding, a restriction Joseph was asked about and didn't adopt.

  None of the three has a `supersedes` entry. Two of them say in their own body that they aren't a reversal.
- **One steward record says more than its quote does** (`flags-on-docless-rows`). One under-claims its authority (`fixtures-are-records`). One "correction" calls an earlier rendering "not Joseph's words" when his words do support it (`our-side-is-example`).
- **The kind of check needs adjusting.** See the next section.

## Is this the right check?

Partly. The template defines the second look as "check the Outcome against the Quote". For these records:

- **For the steward records, the mechanical half is already done.** The coordinator's generator refused any quote it couldn't find character for character, and my re-check found nothing it missed. What a second reader adds is the semantic half: does the Quote actually commit Joseph to the Outcome's specifics?
- **That half can't be done from jaw §1 alone.** §1 keeps Joseph's answers ("3. sure", "5. yes", "i can sustain your lean") without the questions they answer, which exist only in chat. I checked every mapping against the transcript, and every one is right. Still, the records' meaning depends on a file in `~/.claude/projects/` that nothing in the corpus points to. **Suggestion:** carry each answered question into jaw §1 next to its answer.
- **Some of Joseph's binding words aren't in §1 at all.** They are in messages he typed into the fork's thread:
  - 16:19Z: "decisions include reasoning and assumptions, since those have ended up being critical", and "allowances for working-notes everywhere";
  - 18:16Z: objectives, non-objectives and critical objectives, with "req for requirement or critical requirement";
  - 18:23Z: "I agree with the three refinements".

  `conv-decisions.md` and `conv-purpose-layer.md` say these words are recorded in `proposed-verisectorium.md`. I couldn't find them there. The force-levels problem below shows up only if you read that thread, so a second look checked against §1 alone would have passed it.
- **For delegated records, the defined check is empty.** Their Quote is the delegation itself, which can't confirm or refute any particular outcome. What these records need from a second reader:
  1. Is the decision within the delegation (which "those" it covers)?
  2. Does it contradict, narrow or reverse anything Joseph said, anywhere?
  3. Were the options fairly put, including a stronger one?
  4. Is the reasoning stated?

  I'd suggest `conv-record-flags` (or the template) say that `awaiting-second` on a delegated decision clears on that check, not on Outcome-against-Quote.
- **The template's provenance tags don't fit an agent decider.** "Recorded" means stated by a decider at the time. When the decider is the coordinator, its own assumptions written at decision time are recorded by that definition. Yet three delegated records mark them "inferred, unconfirmed", and seven leave Assumptions empty. Likewise, `wording: rendering` is arguably wrong for an Outcome written by its own decider; under the template's definition it is `verbatim`. Neither is a big error, but the template should say how these fields work when an agent decides. Ratification is already a separate field (`awaiting-decision`).

## The eleven delegated records

### Scope of the delegation (`setup-delegated-to-coordinator`)

- **The Quote is verbatim (transcript 00:32Z), and `decided-by: steward` is right.**
- **"The rest of those" is checkable but not stated.** In context it means the seven open items in the coordinator's 23:23Z message, plus aligning the 26 records with the revised template. The ten records cover those eight. They also cover the fork's earlier #4 and #5 (`no-computed-columns-yet`, `typed-reference-fields`), which had been provisional leans Joseph never answered; that is a fair reading of "those". Context says only "several setup decisions remained open". Listing the eight, plus #4 and #5, would let a reader check scope without the transcript.
- **Small points:**
  - `informed: [Joseph (steward)]` lists the decider as informed;
  - the Pros and Cons heading is present but empty;
  - the Quote is attributed to "the coordinator session" although it is now in jaw §1.11.

### force-levels: the most serious finding

- **The Context misreads Joseph's framing.** It says his framing "had three levels: objective, non-objective, and a critical level he suggested calling 'req'". His words (fork thread, 18:16:54Z) were: "objective (which we should propose could also be **req for requirement or critical requirement**) … distinguish between objectives, non-objectives, and critical-objectives". That framing names "requirement" and "critical requirement" separately. It doesn't map critical to "req".
- **Joseph agreed to the four levels this record retires.** The fork replied (18:18:05Z) with three refinements, the second being `force: non | desired | required | critical`. Joseph answered (18:23:21Z): "Excellent-- I agree with the three refinements." Later, in jaw §1.9 item 3, he said "yes" to adopting the model. Its force field in `proposed-verisectorium.md` (lines 42, 80 and 154) has all four values. `conv-purpose-layer.md` itself says "He agreed to three refinements: … force as a field".
- **The delegation was made on the same incomplete picture.** The coordinator's lean #4 (23:23Z) said "Your original was objective / non-objective / critical, with 'req' as the name for critical. The fork then split required and critical." It doesn't mention that he agreed to the split.
- **What I'd want before ratification:**
  - the record states what it changes: `supersedes` can't point at a record, because the model's adoption has none, so at least name the agreement in Context;
  - it puts Joseph's 18:16Z and 18:23Z words in a kept file;
  - it lets him choose with both readings in front of him.
- **On substance:** the driver ("each value must be distinguishable by how a breach is treated") is a good one. Neither version supplies a breach treatment that separates `required` from `critical`. Joseph's own "requirement or critical requirement" suggests he saw one, and asking him what it is beats retiring the level.
- **Template gaps:** Assumptions is empty, and Outcome has no "because".
- **Scope:** force values sit between the SOP side's "how the spec store is organized" and lite's content, which is the udon team's ([[decision:our-side-is-example]]). `obj:reserve-dont-ignore`'s force was explicitly left to them. I'd lean towards calling the value set organization, but it's close enough to the line to say so in the record.

### typed-reference-fields

- **It reads as reasonable on the merits.** The coordinator's original argument for `[[kind:slug]]` was about prose, where two kinds can share a slug (20:35Z). That argument doesn't apply to a field that fixes the kind. Joseph's own §1.5 offered "kind in its own column and just [[slug]]", which is the same idea.
- **But it narrows a steward ruling and says it doesn't.** Joseph ruled "[[kind:slug]] everywhere" (§1.6). The record says "This refines [[decision:kind-slug-references]]; it does not reverse it". The ruling's own text says "everywhere". Per `def:supersession`, this is `supersedes: [{adr: kind-slug-references, how: revised, scope: partial}]`. The steward record also has no pointer to its carve-out, so someone reading `kind-slug-references` alone gets the wrong rule. The template and `def-decision`'s conflict protocol ("go back to the decider … do not settle it by weighing one decision against another") call for the supersession to be explicit.
- **It also changes Joseph's own example form.** He wrote `test-fixtures: dat/stub.yaml`, a path. The rule record now has `test-fixtures: [implied-root]`. That's fine, but worth naming.
- **An unaddressed interaction with cross-store-links:** how does a single-kind field cite a decision in another store? Bare slugs have no store qualifier.

### permanent-notes-in-body

- **Its origin.** "Working notes hold only open/forward work" comes from the fork's convention. The coordinator put exactly that rule to Joseph (22:59:12Z: "…holding only forward work (open threads, doubts, leads), never history. Is that a standing rule you want recorded?"). His answer (§1.11) set the presence-and-frozen policy and said nothing about content. So the content restriction was asked about and not adopted. This record now makes it standing, under delegation.
- **It contains its own tell.** "This answers working-notes-and-frozen's reopen condition without reopening it." Whether or not the reopen condition fired, the restriction belongs to this record, not to Joseph's.
- **The citation drift has already started.** `conv-record-cadence.md` line 16 cites [[decision:working-notes-and-frozen]] (Joseph's) for "holds open work only", which is this delegated record's rule. A delegated restriction is riding on a steward citation.
- **There is prior art it didn't consider.** ASF's Gate 4 "Notes disposition" (`~/src/arch/asf/FORMAT.md` lines 276–286) lets Working Notes carry anything during development and requires each note to be resolved (moved to the body, deferred, or promoted) at the transition to `candidate`. ASF's CLAUDE.md (line 177) explicitly allows regression-guard and dead-end lines in Working Notes. Applied here, that becomes "disposition at freeze": no restriction on content, and a disposition required before a record can be frozen. It keeps Joseph's rule exactly as he gave it and needs no exceptions, which is this record's own goal. It's at least an option the record should list. The chosen form (permanent material in body sections) is what ASF's "Resolved" outcome does at the gate anyway, so the two may differ only in *when*.
- **Template gaps:** Assumptions is empty.

### no-computed-columns-yet

- **It reverses What-changes and consequences in steward records without saying so:**
  - `column-notation` What changes: "Outline headers in both stores gain ※ / ∂ markers";
  - `outline-always-true` and `doc-state-conforms` give "checked / computed by hand until a linter exists" as the interim.

  The coordinator wrote those lines, not Joseph, so this is consistency, not authority. Still, the earlier records now say something no longer true.
- **Its assumption is under-claimed.** "A linter will exist (inferred, unconfirmed)": Joseph said the reflections need "a bin/ script to lint and/or update" (§1.1), and created `bin/` for "bespoke processing scripts" (fork thread, 18:23Z). That makes it recorded. The same mislabel is in `outline-always-true`.
- **A stronger option wasn't considered: write the linter.** A ※ column is a frontmatter read, and the frontmatter is tiny. A first `bin/` script that fills ※ columns and `∂(doc-state)` would make the columns true, rather than hiding them until something makes them true. "No columns" is the softened form of "the outline must always be true". Joseph's §1.9 item 8 ("fixing the outline so that they have the right columns") and §1.1 ("status … we probably want to have in the tables") point the stronger way. I'd add it as an option and as the reopen trigger's natural next step.
- Its Context's question-89 drift claim checks out against the fork's report (23:02Z).

### links-to-unwritten-records

- **It's sound, with an unnamed tension.** It makes an outline row a resolution target, but outlines are views ("outline = view is a working theory", §1.8). The kinds map is meant to define the corpus, and resolution is otherwise files only ("we've pretty much just landed on addressing having files as a referent", §1.6).
- **It's underspecified when a store has several views:** which outline rows count?
- **Suggested Reopen when:** "outline = view is abandoned, or two views of one store disagree about a row".
- **It interacts with templates-are-not-records:** see that record.
- **Template gaps:** Assumptions is empty.

### templates-are-not-records

- **It's fine as a decision, with one interaction.** Its Outcome says "An outline may still list a template as a `template` row". If templates never resolve, a `[[decision:TEMPLATE]]` link in that row resolves under links-to-unwritten-records to the outline row itself, reported as "unwritten". That's false: the file exists. Template rows probably need path links, and one of the two records should say so.
- **The rejected option's con is weak.** "Separate directory: bad, because directories carry no meaning": with explicit `find` globs, a file outside `adr/` never answers, so moving it would have worked. The real reason to keep it in `adr/` is the Pro already given: writers look for it there.
- **TEMPLATE.md's open point** now records the exclusion, updated at 00:42Z.

### cross-store-links

- **It's reasonable.** The Working note's convention for `references` (`def/<slug>.ud`) is wrong: the files are `def/def-<slug>.ud`. Both kinds files now say so correctly; the record's note is stale.
- **Two open edges:**
  - I found no rule that slugs exclude `/`, which the "Good, because" relies on;
  - the `.ud` files have no YAML frontmatter, so the "frontmatter kind matches" check can't apply to them.

### decider-per-store

- **It's sound.** It answers who `awaiting-decision` waits on for the udon team: "Joseph unless the team declares otherwise". The SOP side sets this, in the udon team's own kinds file, as an `accepted` decision. Given our-side-is-example, I'd mark that part as proposed to the udon team.
- **Template gaps:** Negative Consequences is empty.

### fixture-file-shape

- **It's fine.** Two small inconsistencies:
  - the root `kinds.yaml` fixture `requires` comment still says "the shape is undecided";
  - `requires` omits `notes`, which the decided shape includes.

  Per-case `per` (kept by the example, `conv-fixtures` line 38) isn't part of the decided shape, and that's honestly noted in `conv-fixtures`.
- **Template gaps:** Assumptions is empty.

### sop-decisions-follow-template

- **Verified for the 22 generated records:** the reformat changed no Context, Drivers, Assumptions, Options or Outcome. The four earlier records written separately weren't checked.
- **One carry-over:** "affects content moves into What changes" brought along the defect the template revision gave as its reason for dropping `affects`. `row-type`, `outline-always-true`, `outline-is-current-truth` and `open-questions-in-working-notes` now say "Records resting on this: `main-outline`, `conv-outline`". That is a view, not a record, in filename forms that don't resolve. The `per:` back-citations, which I counted, are complete without these lines. Deleting them loses nothing.
- **This record implicitly adopts the template revision itself.** That revision was made by a helper, to lite's file (the udon team's), with no decision of its own. Worth saying so in Context.

## The steward and ratified records

### Where the Outcome goes beyond the Quote

- **`flags-on-docless-rows` (`steward`).**
  - Joseph's quoted words are a question: "isn't this already answered by my prior comments? — / ∅ Are you talking about a non ※ / ∂ column?" His prior comments define `—` as "not applicable" and `∅` as "applicable for that kind, but missing".
  - The Outcome puts `—` on every row with no document. For a `landed` row whose doc-state is `missing` (known canon, not yet drafted), the flags are applicable to its kind and missing, so his own definition gives `∅`. `conv-column-notation` limits the rule to gap rows and undrafted proposed rows, which is narrower than the record.
  - I'd call this `ratified`: the coordinator's reading, which Joseph didn't object to (22:10Z → 22:23Z). I'd also raise the landed-but-missing row with him.
  - "A pending decision lives in its ADR or pre-design question" is stale: questions now live in working notes ([[decision:open-questions-in-working-notes]]).
- **`our-side-is-example`.**
  - The correction note says the original What-changes line ("all rows `example`") "was the coordinator's rendering, not Joseph's words". His quoted words include "so that row-type indicates them as examples etc." So the original line had textual support, and the change to `proposed` for rows with no document is a judgment, possibly a good one.
  - I'd reword the note so it doesn't claim to repair a misattribution, and let Joseph pick.
  - Considered Options and Reopen when are empty. The template asks for "only one option was on the table" and "None recorded".

### Where the record under-claims

- **`fixtures-are-records` (`supported`).** Joseph said it directly: "It's a kind of record that is used for mechanisms outside of the outline..." (§1.6, last line). He then objected to the agents' attempt to make fixtures non-records (§1.7 item 10). Both are stronger quotes than the kinds-map passage used, and together they support `steward` for the core claim, that fixtures are records which no outline need list. The agent-added parts (named case ids, parked hash propagation) could be noted as such. Also, `deciders: [Joseph (steward)]` together with `decided-by: supported` ("an agent made the call") disagree with each other.
- **`outline-always-true`.** Its assumption "a linter … will exist" is marked inferred, but it is in the quoted §1.1 passage ("needs a bin/ script to lint and/or update").

### Quote placement and stale notes

- **Fifteen records attribute their Quote to "the aat-refactored coordinator session"**, though the words are now in jaw §1.11: four steward records (`working-notes-and-frozen`, `outline-is-current-truth`, `sop-kind-convention`, `open-questions-in-working-notes`) and all eleven delegated records, which carry the delegation quote.
- **The four steward records still have a working note saying the quote is "not yet in" the jaw document**, which is no longer true.
- **`outline-is-current-truth`** joins two separate messages in reverse order under one attribution (§1.11 has "in an outline?…" first). Harmless, but a quote block should keep the order or mark the join.

### "What changes" not carried out (as of ~00:45Z)

- **`landed-not-integrated`:** `proposed-verisectorium.md` line 245 still uses "landed" for an influx outcome.
- **`directories-organizational`:** `proposed-verisectorium.md`'s "Lives in" column (line 40) is unchanged.
- **`force-levels`:** `proposed-verisectorium.md` still lists four levels (lines 42, 80, 154). This is influx, so arguably fine, but the record names the SOP files only.

### Template conformance (mechanical)

- **No Outcome uses the template's "Chosen: X, because …" form,** except `typed-reference-fields`. None says "no reasoning beyond the drivers" instead. Joseph asked the fork that "decisions include reasoning and assumptions, since those have ended up being critical". Where Drivers or Pros and Cons carry the reasoning, that's arguably met; the template asks for it in the Outcome.
- **Assumptions is empty (template: "Required"; write "None recorded")** on seven of the ten delegated decisions: `force-levels`, `fixture-file-shape`, `templates-are-not-records`, `sop-decisions-follow-template`, `typed-reference-fields`, `links-to-unwritten-records` and `permanent-notes-in-body`. Every steward record has an entry, or the explicit "None recorded".
- **Reopen when is empty** in `main-outline-name`, `our-side-is-example` and `sop-own-vsect-and-decisions` (template: "None recorded").
- **Negative Consequences is empty** in `decider-per-store`, `main-outline-name`, `our-side-is-example` and `sop-own-vsect-and-decisions`.
- **`per:` back-citation:** every decision except the two meta ones (`setup-delegated-to-coordinator`, `sop-decisions-follow-template`) is cited by at least one record's `per:`. `conv-decisions` could cite `sop-decisions-follow-template`.

### Records I found no problem with beyond the mechanical points

`column-notation` (its note on ⚠ being ratified checks out against §1.8 item 5), `doc-state-conforms`, `row-type` (the landed-cites-a-decision process rule checks out against §1.7 item 7), `kind-in-frontmatter`, `kind-slug-references` (except that it lacks a pointer to its carve-out), `kinds-yaml-resolution`, `kind-change-is-dissolution`, `one-record-per-file`, `per-kind-verification-and-status`, `term-delimiters` (§1.9 item 2 answers the delimiter lean), `lexicon-in-def` (item 5 answers the lexicon lean), `no-max-for-lite`, `sop-own-vsect-and-decisions`, `main-outline-name`, `sop-kind-convention` ("3. sure" answers the convention question), `open-questions-in-working-notes`, `order-lint`, and `proxy-before-threshold` (both deferrals are honestly flagged). On these, Outcome against Quote holds, and the authority values agree with the transcript.

## Adjacent things

- **Nothing in `spec-lite-0.1.0/` beyond the pre-existing tree is committed.** `sop/`, `adr/`, `.vsect/`, `obj/`, `def/`, `dat/` and `src/` are all untracked. "This outcome is never edited in place" currently has no audit substrate: I could check it only because the generator script happened to still be in `/private/tmp`. A commit before ratification would make the immutability claim checkable from then on, with the delegated records' state at delegation as the baseline.
- **Carry Joseph's fork-thread words into a kept file:** reasoning and assumptions, working-notes allowances, the purpose layer and force levels, "agree with the three refinements", and the two guards. Two SOP records already cite a home for them that doesn't contain them.
- **The delegation's condition is a standard for the steward to check against.** It reads "If you are looking at everything holistically and thoughfully to be an exemplar…". The records state the condition, but none says how it was met. A line per delegated decision, saying what made it the exemplary choice rather than merely a workable one, would give ratification something to judge.

## On the brief

- **It worked well.** Naming the eleven as the priority without telling me what to look for in them was the right shape. Without it I'd have spread effort evenly, and the delegated records are where the problems are.
- **One addition would have saved time:** a pointer to the fork's thread. The force-levels finding depends on it, and nothing in the corpus says Joseph typed binding words there.
- **I read the coordinator's conversation after reading the records,** to verify the quote mappings. That exposed me to its framing for the second half of the review. The delegated-record findings came from reading Joseph's words, not the coordinator's, but the exposure is worth knowing about.
