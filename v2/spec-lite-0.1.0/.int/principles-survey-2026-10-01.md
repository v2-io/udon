# Principles survey for spec-lite-0.1.0's purpose layer

*Written 2026-10-01 by a Claude (Opus 5.5) survey agent for the udon-team agent drafting `obj/`. Locating only, not distillation. Each candidate gives the verbatim passages that state or imply it, where they live, who said it and when. My own glosses are marked **Gloss** and are only pointers. Nothing here is decided.*

## How to read this

**Speaker tags** (the brief asked for this distinction):

| Tag | Meaning |
|---|---|
| **[J]** | Joseph's own typed words. Almost all come from `~/.claude/history.jsonl`, cited as `history.jsonl:NNNNN`. I checked: none of the 25 `~/.claude.bak.*/history.jsonl` backups holds a udon-related turn of Joseph's that is missing from the current file. |
| **[J-file]** | A file Joseph wrote or committed in his own voice, with no matching typed turn (e.g. `INBOX-REQUESTS.md`). |
| **[J-2011]** | Joseph's 2011 originals in `~/src/_older/udon/` and `~/src/_older/udon-c/` (git author Joseph Wecker). The udon `CLAUDE.md` and README still point at `~/src/_ref/udon*`; that path no longer exists. |
| **[A←J]** | An agent's wording of a Joseph ruling: the `v2/DECISIONS.md` K-rows, CTQ tables, and so on. `DECISIONS.md:159` says outright that these rows are "interpretation, not ratified text". |
| **[A]** | Agent text: analyses, specs, reports, and testimony. |
| **[S]** | Spec text. Every spec in this estate was drafted by agents from rulings, so [S] is a kind of [A]. I flag it separately because specs read as law. |
| **[E]** | Text by an ELI in the cohort. |

**One author.** Nearly all of this estate traces back to Joseph. Where several passages agree, I mark them **(restatement)**. That agreement shows the corpus is consistent with itself; it does not count as independent support. The only legs I found that are actually independent are the measured probes and the external literature, and I flag both.

**Placement.** Each candidate carries one of these labels:

- `lite-obj`: a property lite must have.
- `lite-prin`: a tie-breaker.
- `future`: belongs in the `obj.future/` pile.
- `non`: a non-goal.
- `tension`: unresolved.

These labels are my guesses. Use them to navigate, not as a verdict.

---

## 0. Map

| # | Candidate | Pile (guess) | Strongest primary |
|---|---|---|---|
| 1 | What lite is for: a small, predictable, now-usable data/document layout | lite-obj | INBOX-REQUESTS [J-file]; `history.jsonl:21299`, `:21336` [J] |
| 2 | Reserve, don't ignore: Joseph's own wording, and the warn→error drift | lite-obj (exists) | `history.jsonl:21336` [J]; INBOX [J-file] |
| 3 | Scannable without syntax highlighting, for agents first | lite-obj / CTQ? | `history.jsonl:5457`, `:5571`, `:5572` [J]; 2011 objectives |
| 4 | Markdown passes through: prose is the unmarked case | lite-obj | `history.jsonl:5527`, `:6959`; 2011 `description.udon` [J-2011]; measured |
| 5 | Type comes from syntax, never content-sniffing; bare set frozen | lite-obj | `history.jsonl:6418` [J]; RATIONALE [S] |
| 6 | Keep everything; severity defined by loss | lite-obj / tension | `history.jsonl:16387`, `:16612` [J]; L0 [A←J] |
| 7 | Repetition stacks; nothing is silently lost to duplicates | lite-obj | `history.jsonl:15815`, `:18909` [J]; YAML stress test (measured) |
| 8 | Least surprise, weighted by how often the case occurs | lite-prin | `history.jsonl:18890`, `:16904`, `:16347` [J] |
| 9 | Simpler grammar / fewer rules (extends existing `prin`) | lite-prin (exists) | `history.jsonl:21299`, `:19091`, `:20783` [J] |
| 10 | One rule everywhere: no per-context special grammar | lite-prin | `history.jsonl:18920`, `:21321` [J] |
| 11 | Don't limit an important use-case to guard an unimportant failure | lite-prin | `history.jsonl:18886`, `:17922` [J] |
| 12 | Indentation is the tree (columns are syntax) | lite-obj | 2011 DECIDED [J-2011]; G1 [S] |
| 13 | First-line greppability / head-line density | lite-prin or obj | `history.jsonl:17684` (O6) [J]; vivarium testimony [A] |
| 14 | Round-trip layers: content < +meta < +ornament | lite-obj (partly decided) | `history.jsonl:21322`, `:17001` [J] |
| 15 | Implied root, carrying file metadata | lite (decided) | `history.jsonl:21299`, `:18732` [J]; 2011 DECIDED |
| 16 | Streaming / bounded lookahead | tension (lite is AST-centric) | `history.jsonl:6003`, `:15840`, `:6466` [J] |
| 17 | Decisions flow demand→grammar; the past is not an authority | process prin | O17/O18a [J]; `history.jsonl:16604` [J] |
| 18 | Time-to-comprehension (source for the `conv-purpose-layer` example) | fitness candidate | `history.jsonl:17700` [J]; TST |
| 19 | Errors teach; a refusal names its class | future (tooling), partly lite | `history.jsonl:5613` [J]; principles atoms [A] |
| 20 | Version / dialect marking | future / tension | `history.jsonl:7909`, `:15379` [J]; `file-naming.md` |
| 21–29 | Future pile (schema-guarded mutation, paths, dialects, etc.) | future | §2 |
| N1–N8 | Non-goals | non | §3 |

---

## 1. Candidates for lite itself

### 1. What lite is for: a small, predictable layout usable now, aware of its own limits

- **[J-file]** `v2/INBOX-REQUESTS.md:3-22`. Dated 2026-08-30 in the file; committed by Joseph on 2026-09-21. Not typed into any session, but it is in his voice:
  > Basically, with 0.10.01, a set of tiny, dependency free "simplified udon" parsers written in the host languages: … Basically it would be regex or very simple recursive descent on fragment with a very simplified AST built. It would need to warn when there are constructs (like references or directives or unknown data types etc.) that it encounters that it won't parse.
  >
  > The actual subset that they all (or each independently) will "parse" is up for debate, as long as the result is small enough that it's convenient to just pop in place for simple udon usage for now, dependency free, (e.g., for udon used as a simple predictable data layout / xml equivalent / yaml-or-json alternative), and aware of what it (or each one) can't do.
- **[J]** `history.jsonl:21336`, 2026-09-30 10:02, project `aat-refactored`. This is Joseph describing lite to another team:
  > Essentially over in udon right now we are working on v2/spec-lite-0.1.0/ -- a new spec for "core" udon -- the non-dynamic subset that excludes all generators and references (! and @ constructs, among other things). It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future.
- **[J]** `history.jsonl:21299`, 2026-09-29 18:18:
  > This "lite" is very, very similar to the actual mainline udon that we are replacing here in v2-- and which already has a lightning fast recursive descent declarative grammar definition-- there have been a handful of agents that have built tiny bespoke python parsers that got thrown away because they couldn't reliably follow the changes and the nuance very easily compared to the descent grammar.
- **Ancestors of the subset idea:**
  - **[J]** `history.jsonl:7832`, 2026-01-13:
    > - udon-xml -- limited to forms that can be expressed in XML naturally-- e.g., no complex elements as an attribute's value … Can anything that is represented in sameline form and inline form be implemented in pure block-like form? Or are there intrinsic differences in the underlying structure. And, if there are, *should* there be?
  - **[A]** (Dec-2025 agent usability testimony) `test/usability/enablement-synthesis.md:109-110`:
    > Practitioners will use ~20% of features 80% of the time. Which 20%? A "UDON-Simple" subset might aid adoption.

    The review picks this up in `_archive/REVIEW-JULY-2026.md` concern 3, which says the answer is "not feature removal but a small, blessed core profile".
  - **[J-2011]** `_older/udon-c/docs/NOTES.md:1-3`. The 2011 C implementation's own first scope:
    > * inline comments / * no string interpolation / embedded udon / * |kind[what] attributes

    Lines 34-37 give the same node shape lite now uses: `node: * meta-info * attributes * children`.
- **Gloss:**
  - INBOX says "warn" and "aware of what it can't do"; the 09-29 and 09-30 turns say "disallow" and "the parser errors". See #2.
  - The `udon-xml` flavor ("no complex elements as an attribute's value") pulls against node-valued attributes, which is pre-design question 64.
  - The tiny dependency-free per-host parsers in INBOX are not the same thing as the descent-only route in 21299. The descent route superseded them.

### 2. Reserve, don't ignore: Joseph's own wording, and a drift to watch

The existing `obj/obj-reserve-dont-ignore.md` notes that clause 1's wording is the agent's, accepted by Joseph. The passages below are **his own** statements of the same contract, plus material bearing on the open terms.

- **[J]** `history.jsonl:21336`: "It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future." This is the contract in Joseph's words, one day after the agent's version.
- **[J]** `history.jsonl:21298`/`21299`: "I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly." This one is already quoted in the obj record.
- **[J]** `history.jsonl:16876`, 2026-07-19, on unspecified behavior:
  > Please make sure any fixtures that are descriptive of technically undefined behavior get allowed to be part of the gate but that they *don't* frame themselves as prescriptive. … the last thing we want is for purposefully unspecified behavior to nevertheless calcify into the grammar.
- **Formal prior art for the contract [A, external literature, measured/evidenced]:** `v2/theory/to-integrate/primary/format-failures/ADJUDICATED-CLAIMS.md` §3 (lines 122-159, 2026-07-29):
  > C3.1 … Orchard: Accept Text Set is a superset of Defined; the gap is extensibility; "Must Ignore Unknowns" is a substitution mapping Accept→Defined; without it, "catch fire and die if unknown" blocks forward compatibility.

  > C3.5 … **Inference:** Version labels without an Accept-set gap at the changed layer are forks, not minor versions.

  The same file, §8 (EDN), says user tags must be prefixed and unprefixed ones are reserved.

  `MINEFIELD-MAP.md` §3.11 (lines ~167-178 of the file): "'Keep everything and warn' needs a substitution table". Must-ignore has two knobs: **disposition** (remove / preserve / forward) and **scope** (Must Accept All vs Container).
- **Gloss: three tensions here, not settled by anything I found.**
  - **Warn vs. error vs. loss-severity.** INBOX (08-30) says the tiny parsers "warn". 21336 (09-30) says "the parser errors". The ledger row **L0** `[A←J]` (`DECISIONS.md:110`) says: "**Error = loss only.** If every author-visible byte is kept as structure or Text, severity is **Warning**". A refusal that keeps the bytes (the README contract) would be a Warning under L0, so Joseph's "errors" collides with L0 unless "reserved" is a third kind of verdict. This bears on what "accepts" means in clause 1.
  - **The direction of compatibility.** Orchard's calculus is about *old readers meeting new text*. Lite deliberately chooses "catch fire" for its own readers, so a lite parser refuses newer full-UDON documents. The guarantee runs the other way: full readers stay correct on lite text. That is a fine choice, but it is the opposite of must-ignore, and it may be worth stating as such.
  - **"Reserved" is a word Joseph once warned off.** **[J]** `history.jsonl:15844` (2026-07-11): "'the non-reserved ones' -- I would be careful about calling them reserved instead of specially-designated ones or something..." That was about `$` keys. The 0.9.1 rationale heading reads "Designated, not reserved". Lite now uses "reserved" for future syntax, which is a different sense. A lexicon entry may want to fence the two apart.

### 3. Scannable without syntax highlighting, with agents as the primary reader

- **[J]** `history.jsonl:5457`, 2025-12-22: "I don't know about you, but I love the fact that the udon seems so readable to me even without syntax highlighting". `:5458`: "it is so easy for me to comprehend even without syntax highlighting-- which is a cruch whose absense really downgrades the comprehension for me usually.."
- **[J]** `history.jsonl:5571`, 2025-12-24:
  > The other biggest objection I have is this: "UDON is optimized for human authoring—that's overhead when humans aren't involved." That is not true. It is optimized for agents and AI. The fact that it happens to be very comprehensible for humans as well is a fortunate unintended consequence.
- **[J]** `history.jsonl:5572`, 2025-12-24:
  > The perfect example is the fact that it needs to be clearly and quickly scannable *without* syntax highlighting-- because right now agents don't have syntax highlighting for the normal read workflow. The fact that a human also says "Oh, it's quite clear even before syntax highlighting" is a nice additional benefit :-)
- **[J]** `history.jsonl:5767`, 2025-12-25: "syntax highlighting is exactly the kind of thing that tightens human feedback loops but not yours".
- **[J]** `history.jsonl:17060`, 2026-07-21: "udon is primarily for agents by agents and they are the principle user."
- **Restatements:**
  - **[A]** `design/positioning.md:10-11`, 100-101 (Dec 2025, agent's own voice): "UDON is optimized for agents. The fact that humans also find it clear is a fortunate consequence, not the design goal." … "**Unambiguous without syntax highlighting.** The prefix system creates stable visual anchors."
  - **[S]** root `README.md`: "crystal clear even without syntax highlighting, for humans and AI alike."
- **Spatial reading [J]:**
  - `history.jsonl:20136`, 2026-08-22: "You have spatial awareness-- it's one of the first big experiments I did with LLMs that truly surprised me. It has had a huge influence on the development of Udon".
  - `principles/src/form-agentic-eyes.md` table [A, `decided-by: supported`]: "Joseph's empirical: 'all modern agents LOVE column alignment'".
- **Conflict: who comes first.**
  - **[J-2011]** `_older/udon/doc/objectives.asciidoc:7-12` (2011-07-22) puts beauty and humans at the top: `[Beauty] (visual & conceptual) | Highest`, then `Human readability | 10`, `Learnability | 10`, `Self-description-ability | 10`.
  - **[J]** `history.jsonl:7057` (2026-01-05): "I actually feel udon will be more accessible to humans as well as agents."
  - The README says "for humans and AI alike".
  - 5571 says agents first and humans as a fortunate consequence. These may agree in substance, since comprehension needs are claimed to coincide (positioning.md "Why human-readable follows from agent-readable"). Even so, they rank differently.
- **Counter-evidence (measured).**
  - `v2/udon-needs/02-tooling-needs/src/counter-register.md` row 1 [A]: structured notation improved comprehension (100% vs 60%) but "**failed to reproduce on 1 of 4 model families tested**, and that same family processed the structured form *more slowly*."
  - Joseph's ruling on it, **[J]** `v2/udon-needs/01-ideation/STEWARD-CALLS.md` row 6 (2026-07-21): "cary as important evidence (although IIRC, there were confounding factors) … will probably be a part of an eventual discussion about 'house-style' udon."

### 4. Markdown passes through: prose is the unmarked case

- **[J-2011]** `_older/udon/doc/description.udon:4-6`:
  > |Decision: Begin special block delimiters (| etc.) / So that the vast majority of documents are acceptable udon documents / (passthru). Unlike slim and to some degree yaml.
- **[J]** `history.jsonl:5527`, 2025-12-23: "This problem doesn't make sense to me. Markdown *is* correct UDON: … That is correct UDON from the beginning."
- **[J]** `history.jsonl:5567`, 2025-12-24: "maybe in SPEC we should specify that Udon should generally prefer markdown in prose rather than inline-udon equivalents."
- **[J]** `history.jsonl:5569`: "Pure prose-- markdown *is* a subset of udon-- except frontmatter can now be anywhere."
- **[J]** `history.jsonl:6959`, 2026-01-02: "As you know, markdown is a proper subset of UDON."
- **[J]** `history.jsonl:7904`, 2026-01-14: "easily claims markdown as a subset as any valid markdown is valid udon prose."
- **[J]** `history.jsonl:5594`, 2025-12-24, on pipe-space:
  > I propose we very specifically say that a pipe followed by whitespace, dash, or another pipe, in addition to a pipe preceded with a single-quote, all get preserved as-is. This ensures no collisions with markdown tables.
- **[J]** `history.jsonl:15379`, 2026-07-08, CTQ brainstorm: "INCLUDES Ability to not conflict with the majority of markdown dialects / EXCLUDES (initially) actual parsing of markdown or rather defers it to be a host implementation and/or dialect decision".
- **[J]** `history.jsonl:17396`, 2026-07-23, separating "doesn't conflict" from "parses markdown":
  > when we talk about udon prose being able to be markdown-- most agents ask "yes but *which* markdown format do we support?" -- which to me sounds like a strange question unless there are markdown flavors that have some construct that udon conflicts with sans escaping-- that's a very different thing 'does not conflict' from 'udon-parser will also parse the markdown prose'
- **Measured [A]:** `v2/theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md:20-31` (2026-07-28, all 652 CommonMark examples):
  > No CommonMark construct in the corpus triggers any UDON structure except the fence. … Byte-exact survival: 76.2% at document root, 86.7% embedded in a UDON element. … The pipe-space "preserves markdown tables" claim wants narrowing: it covers `| a | b |`, not `|a|b|`.
- **Against / tension:**
  - **[A]** `format-failures/MINEFIELD-MAP.md` §3.9: "**UDON is a superset of nothing**, so it pays full $H_{\text{req}}$ with every reader". This collides with Joseph's "markdown is a proper subset of UDON" claims. *Gloss:* they may be talking about different layers. MINEFIELD is about the whole notation; Joseph is about prose. It is still worth reconciling.
  - **[A]** `_archive/REVIEW-JULY-2026.md` concern 6 (with Joseph's reflow face, `history.jsonl:15385`): "UDON prose is valid at any indent — it just silently belongs to someone else."

### 5. Type comes from syntax, never from sniffing content; the bare set is frozen

- **[J]** `history.jsonl:6418`, 2025-12-31: "one of the main differentiators for UDON is the fact that it parses values instead of string+value-peeking like yaml has always done..."
- **[J]** `history.jsonl:15379` (CTQ brainstorm): "IN? Mechanism for explicit temporal typing (or explicit typing generally w/ temporal as instance) possibly as part of dialects, as alt. to eroding prose-space & to avoid violating principle of least surprise".
- **[J]** `history.jsonl:16328`, 2026-07-15: "generally our scalars are typed by the initial digit (hence 0x... 0d....)" … "the one here would need potentially unlimited lookahead to know it should be text."
- **[J]** `history.jsonl:18910`, 2026-08-09, using the Norway problem as a lens on a proposal: "I didn't hear *anything* about a Norway-problem that had crept in that we spent yesterday killing."
- **[J]** `history.jsonl:5999`, 2025-12-27: "Null especially might get a little weird if someone is coming from json and isn't expecting it to be a string."
- **Spec / ledger:**
  - **[S]** `spec-0.09.01/RATIONALE.md` "The frozen bare set and the envelope":
    > Every format that recognizes values from bare syntax eventually faces pressure to recognize more … each accretion retypes someone's existing document — YAML's Norway problem is the canon case. UDON freezes bare recognition permanently and gives growth its own visible space (`<…>`). Additivity is structural, not disciplinary
  - **[A←J]** `DECISIONS.md` **R7** (line 38) "Bare dates are strings"; **R21** (line 51) "Bare numeric recognition frozen to **integer + float** only"; **L5** (line 61).
  - **[A]** `JOSEPH-FOR-0.10.01-FIX.md:51`: "Bare typing never grows." This is agent text that Joseph saved; `WHERE-THINGS-STAND` says it was not adopted.
- **Evidence:**
  - **[A]** `udon-needs/02-tooling-needs/src/typing-and-schema-boundary.md`: a production catalog of YAML retypes (`1.0`→float, `01234`→octal, `yes`→bool), with "Agents over-quote defensively".
  - **[A]** `MINEFIELD-MAP.md` M1 and §3.1. §3.1 reports the parser checked against CORE, and quotes Joseph: "*For us you need an explicit `0d` or `0o` for deliberate decimal or octal.*" It leaves reading (A), bare `0755` = decimal 755, against reading (B), bare leading-zero = string, explicitly open. *I could not find that sentence verbatim in `history.jsonl`; it may have been paraphrased by the agent.*
- **Gloss:** this connects directly to #2 and pre-design 66. If lite does *not* type bare values and full UDON does, a lite-accepted `:port 8080` changes tree between lite and full. That would break clause 1 unless "same tree" is scoped. I flag it only as a consequence to check.

### 6. Keep everything; severity is defined by loss

- **[J]** `history.jsonl:16387`, 2026-07-16: "I would vote that the error in R2 would still emit the value with a nil. But that's me... I don't like losing data at the event level while we still have parsing work that can introspect those sorts of things and hand them back to us with reasons why we should do something else..."
- **[J]** `history.jsonl:16612`, 2026-07-18: "I think warning ~= content preserved, but possibly not what was expected or desirable for the future / error ~= something was lost."
- **[J]** `history.jsonl:16882`, 2026-07-19: "so many agents repeat back to me over and over 'Don't worry- no data left behind!' while deliberately stripping one of the human-cognition and agent-cognition most important geometric differentiator on text."
- **[J]** `history.jsonl:16323`, 2026-07-15, on comments: "commenting out a block specifically because it is causing parsing errors or warnings is a primary usecase".
- **[J-2011]** `_older/udon-c/docs/DECIDED.md:110-113`: "## PARSER / * Warnings w/ severity as a separate structure returned that the implementation can decide what to do with. / * Ability to supress specific warning messages".
- **Restatements:**
  - **[A←J]** `DECISIONS.md` **L0** (line 110), **R11** (line 41: "Keep-everything at recognition where coherent; halt/reject is consumer menu").
  - **[S]** 0.10.0 `CORE.md` §0 **G7**.
  - **[A]** `JOSEPH-FOR-0.10.01-FIX.md:145`: "Everything the author typed is in the tree. Warning means kept but check it. Error means a value is genuinely missing."
- **Evidence and refinement [A]:** `MINEFIELD-MAP.md` M2 (line 43): "**The lethal corner is silent-and-unspecified, not strict-or-lenient.** … The repair-relevant axis is *loud versus silent*." §3.3: "Keep-everything can manufacture a Regime III flood … The one-bit fix (root vs derived) is cheap".
- **Against:** **[A]** `defining-udon.md:28-32` (a research-report style document, committed by Joseph 2026-07-19, which udon `CLAUDE.md` calls the standard any spec suite is held to):
  > JSON's massive success is largely due to its ruthless simplicity and strict error handling. … By forcing parsers to fail loudly on invalid input, JSON prevented a fragmented ecosystem of "almost-JSON" flavors.

  RATIONALE answers it: "JSON wins by rejecting; UDON's domain … wins by keeping". The tension is live for lite's reserved-syntax refusal (see #2).

### 7. Repetition stacks; nothing is lost silently to duplicates

- **[J]** `history.jsonl:15815`, 2026-07-11: "attribute value stacking (my vote: required standard behavior, order guaranteed to be preserved [of the values assigned to the same attribute, :'$trait' style])".
- **[J]** `history.jsonl:18909`, 2026-08-09 (his mental model, explicitly *not* a ruling):
  > |e :x 1 / ==>  :x = 1 / |e :x 1 :x 2 / ==>  :x = [1 2] ; (started stacking, now it's a list) … in my mental model, :x == 1,  *not*  :x == [1].  **BUT** This is **NOT** a ruling! … If you say that :x should be [1] for simplicity's sake … I can be persuaded.
- **[J]** `history.jsonl:17922`, 2026-07-29 (see #11): "simply lean into the stacking we already do".
- **Spec:** **[S]** RATIONALE "Stacking, not last-wins": "Last-wins silently destroys data on the happy path, which contradicts keep-everything on the sad path".
- **Measured [A]:** the YAML stress test via `typing-and-schema-boundary.md`: "Duplicate keys silently discard data and are **undetectable at the format layer** | synthetic | exact".
- **Inconsistency [A vs A←J]:**
  - `v2/msc/BEST-WITH-UDON.md` `|capability[duplicate-keys-cannot-silently-lose]` says "In UDON the identical agent bug produces a **warned**, ordered stack".
  - `DECISIONS.md` **K11** (line 176) says "stacking is silent everywhere".
  - vsect's requirement 6 wants the duplicate "visible" (`.int/vsect-requirements-on-lite.md`). That is about duplicate *element* keys (`(name,key)`), which is the separate ledger row **R14** (default **error**).

### 8. Least surprise, and how Joseph weighs it

The existing `prin/simplest-grammar-without-surprise` leaves open "whose surprise counts?" These passages bear on that question directly.

- **[J]** `history.jsonl:18890`, 2026-08-09, which is the closest thing to a stated weighting rule:
  > Almost all my decisions try to reduce to not violating the principle of least surprise the most (so sometimes taking into account estimated or hypothesized frequencies of edge-case occurance etc.-- like 'emoticons in the $main attribute text and forgetting to escape' -- pretty unlikely-- it's mostly a human thing … so unlikely compared to how often we'll want multiple attributes on the same line or subsequent lines). … launch a couple of sonnet agents and ask them what they think the "thing" would parse to if they saw it-- get a fresh beginners mind "principle of least surprise" -- not that it's binding or conclusive, but it is definitely useful thinking!
- **[J]** `history.jsonl:16904`, 2026-07-19: "think in terms of the consumer and user of UDON (which is targeting *you* as a consumer …) and therefore the principle of least surprise and when you need to bring an ambiguity to me … have a recommendation that has a user-centric reasoning".
- **[J]** `history.jsonl:16347`, 2026-07-15: "this new rule is so simple and clear *and* it aligns with principle of least surprise for newcomers to udon at least, so I'm going to bite the bullet".
- **[J]** `history.jsonl:16865`, 2026-07-19: "the thing that would least surprise me as a user is …". `:16334`: "the principle of least surprise only requires a preceeding whitespace".
- **[J]** `history.jsonl:16604`, 2026-07-17: "please give me a user-facing reason, not current pre 1.0 spec pedanticism."
- **[J]** `history.jsonl:16533`, 2026-07-16: "we are very much able to0 A/B test and edetermine 'intuitive' empirically." `:16658` names the rowan "syntax-provers where we had agents guess the syntax for something given some base to see if our solution fit the 'principle of least surprise'".
- **Restatement [A, `decided-by: supported`]:** `principles/src/form-agentic-eyes.md`: "**The governing principle:** minimum surprise from the tool; maximum surprisal per glyph in the look."
- **Gloss:** the audiences named are "you" (agents), "newcomers", "me as a user", and fresh Sonnet probes. The weighting factor is frequency of the case (18890). That means surprise on a *rare* case is acceptable; see #11.

### 9. Simpler grammar, fewer rules (supplements the existing `prin`)

- **[J]** `history.jsonl:19091`, 2026-08-10: "All that simplification and normalization seems to have expanded the total spec by 362 lines. To me that seems to indicate that we've gone a different direction with the spec than I expected..."
- **[J]** `history.jsonl:20783`, 2026-09-01, on 0.10.01: "Ugh, so much jargon and changed terms for such a simple thing, and the one thing that's not obvious is the thing that's broken."
- **[J]** `history.jsonl:20550`, 2026-08-27: "it's the nuance where all would-be axioms and unifications and generlizations and beauty go to die :-)"
- **[J]** `history.jsonl:16212`, 2026-07-14: "Escaping has gone from 2 delimiters each with extra complexity and nuance down to one simple and coherent one."
- **[J]** `history.jsonl:6004`, 2025-12-27: "We should probably also *disallow* |{inline element |next |another ...} just for conceptual simplicity-- and say once you're in bracket mode-- you have to stay in bracket mode until you're all the way out..."
- **[J]** `history.jsonl:5586`: "how to do the other liquid directives inline rather than block in a way that ideally doesn't make the grammar or lexical size expand".
- **[J-2011]** `objectives.asciidoc:13-14`: `Syntactic simplicity | 8`, `Conciseness | 6`.
- **[A]** `_archive/analysis.md:539-543` (Dec-2025 agent analysis): "**Be opinionated and minimal.** Markdown won by being simple and readable, not by being featureful. UDON should do the same—solve the 80% case elegantly, let consumers handle edge cases in their own languages."
- **Theory angle [A]:** `MINEFIELD-MAP.md` M7 (line 53): "a grammar that needs tens of thousands of words to pin down is reporting a fact about *itself*". **Gloss:** this suggests spec length as a fitness proxy for this principle. It fits 19091.

### 10. One rule everywhere: no special grammar per context

- **[J]** `history.jsonl:18920`, 2026-08-09: "I don't know why you would carve out extra grammar for 'kind of almost values' in a place that was specifically meant to encapsulate a value." Rendered as **K16** `[A←J]` (`DECISIONS.md:171`): "Jaw is **NOT ok with any syntax divergence between key interiors and normal attribute values**".
- **[J]** `history.jsonl:21321`, 2026-09-29: "conceptually I am more and more convinced that the feeling that $main was a good idea *is* a truly good idea … All other treatments turns sameline into a whole set of special formatting and turns attribute sameline into a *separate* set of craziness." Already in `STEWARD-2026-09-29.md`.
- **[J]** `history.jsonl:6043`, 2025-12-28: "the whole point was to have indent/dedent behavior stay consistent, same with inline stuff."
- **[J]** `history.jsonl:16866`, 2026-07-19: "*{ should never take someone out of text/prose mode".
- **[A]** `_archive/REVIEW-JULY-2026.md` §3 strength 3: "**The single stack rule** (`pop while col <= base_col`) covers block nesting, inline rightward chains, and column-aligned siblings with one mental model."

### 11. Don't limit an important use-case to guard an unimportant failure

This candidate argues *against* an otherwise-obvious "guard everything" reading of least surprise.

- **[J]** `history.jsonl:18886`, 2026-08-09: "2 seems safer, but it's not. My gut is telling me it's going to be another instance of limiting an important use-case because of an unimportant failure mode." This became **K12** `[A←J]` (`DECISIONS.md:175`).
- **[J]** `history.jsonl:17922`, 2026-07-29: "It's a regulator that no one asked for but that I put in there when I was afraid the format was getting too loose and was prone to exploding. But that doesn't seem to scare me anymore in this case."
- **[J]** `history.jsonl:17897`, 2026-07-29: "There are *ZERO* consumers of the ? syntax … exactly the kind of lexical scope crap that I specifically asked it *not* to worry about because it's the tail wagging the dog."
- **Against [E]:** `principles/influx/the-pattern.md` (Architectus, 2025-10-06): "Make invalid operations impossible to express (where appropriate)". This is the opposite lean. Lite's reserve contract is itself an "inexpressible" move. The two coexist only if "important use-case" is defined.

### 12. Indentation is the tree; columns are the syntax

- **[J-2011]** `_older/udon-c/docs/DECIDED.md:60-71`: "## INLINE / ONE-LINERS / Strictly determined by indent level." with the `|one|two|three` examples.
- **[S]** 0.10.0 `CORE.md` §0 **G1**; **[S]** 0.9.1 PEDAGOGY "Columns are the syntax."
- **[J]** `history.jsonl:5742`, 2025-12-25: "If there is grammar that starts to break this model-- the GRAMMAR HASN'T BEEN DESIGNED RIGHT." This was said about recursive descent with the call stack as the implicit indent stack (`:5797`).
- **Tabs, with versions that conflict:**
  - **[A]** `_archive/analysis.md` (Dec 2025): "Strict spaces only; error on tabs".
  - **[S]** old `spec/CORE.md:1797`: tab in indentation is the `NoTabs` error.
  - **[A←J]** `DECISIONS.md` **L4** (line 88, 2026-07-21): "Tab in indentation: **keep** as text of current owner (best-effort); **Warning** … Rejects live CORE 'line lost.'"
  - **[A, external]** `ADJUDICATED-CLAIMS.md` C6.1: "**Inference:** The repair is refuse ambiguity (or forbid tabs), not abandon indentation syntax."

  This is pre-design question 63.
- **Hazards [A + J]:** REVIEW concern 6 (reflow/paste promotes sigils silently); `ADJUDICATED-CLAIMS.md` C6.2 ("paste + auto-indent is semantic mutation").

### 13. First-line greppability and head-line density

- **[J]** `history.jsonl:17684`, 2026-07-28 (DISCUSSION-THOUGHTS **O6**): "It might also pick up on other things, like early on me telling them to put certain attributes first, and on same-line so that it was easy to grep".
- **[J]** `history.jsonl:17689` (**O8**): "keep primary state/status / easily grepped attributes+values on sameline".
- **[J]** `history.jsonl:15895`, 2026-07-12, on append-safety: "make sure it expects appending of new items so that agents can atomically append things without needing to read the whole thing and without any accidental interleaving."
- **[A testimony]** `udon-needs/01-ideation/02-provenanced/copies/I5-live-consumers/consumer-vivarium-fable-day-report-2026-07-28.md:61-63`: "The head-line density (|decision[slug] :date :by :status :topic) also reads beautifully under grep". Also: "conformance is currently imitation, not validation — every one of us wrote rows by pattern-matching the tail of the file". And: "friction-relief, and by a wider margin than I'd have guessed".
- **Restatements:** BEST-WITH-UDON `|capability[headline-density-under-line-tools]`; vsect requirements 5 and 7.
- **Against [A]:** `design/positioning.md:139-140`: "**Append-only log streams.** When per-line independence matters more than hierarchy, use JSONL or simple `key=value` formats." This collides with the estate's actual use of append-only UDON decision logs (15895; vsect requirement 5).

### 14. Round-trip layers: content < content+meta < content+meta+ornament

Partly decided already (STEWARD 09-29). These are the earlier primaries.

- **[J]** `history.jsonl:21322`, 2026-09-29: "content < content+meta < content+meta+ornament / round-trip only optionally preserves meta".
- **[J]** `history.jsonl:17001`, 2026-07-20, the ornamental fixpoint definition:
  > ornamental as 'choices about things that change how the udon look without changing the AST … But it can be proven to be ornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result of the first round-trip
- **[J]** `history.jsonl:7846`, 2026-01-13: "the simplified tree but with potential metadata … that specifies what *was* originally inline vs. block etc. This would allow for linting and fully-reversible translation without cluttering up the 'dig' / path syntax or conceptual mental model". `:7871`: "We track position (along with line number and column and whether it's sameline or block-level) but have a simplified hash. I like your idea … of having a parallel or opaque lookup for metadata."
- **[J]** `history.jsonl:18916` (→ **K15**): "these, like extra blank lines in non-prose, are issues of 'ornamentation' … the ast assembler can (and should be allowed to) add some metadata / annotation for the 'flavor'".
- **[J]** `history.jsonl:16878`, 2026-07-19: "*WE MAKE NO GUARANTEES AS TO HOW IT MIGHT BE CUT UP*". This was about text event chunking.
- **Prior art [A]:** `udon-needs/02-tooling-needs/src/round-trip-and-span-splice.md`: "byte identity for every span it didn't touch, and model identity for the span it changed". And: "Agents mostly want model-level certainty + local spatial correctness, not global pretty. Humans want fmt."

### 15. Implied root (decided 09-29; earlier primaries and conflicts)

- **[J]** `history.jsonl:18732`, 2026-08-07:
  > having all udon documents with a pseudo root element solves the open "what to do with attributes at top-level" question in the spec, as well as "what's the difference between an udon doc meant to be a partial vs whole-record vs store of records..." etc. (just depends on what you decide to do with that root element).
- **[J-2011]** `_older/udon-c/docs/DECIDED.md:103-108`: "## \"ROOT\" NODE / * Implied / * ID is file path if applicable / * name is basename of path if applicable / * several :\_\_ attributes for metadata- file access time, etc. / * stuff isn't, by convention, output during conversions".
- **[J]** `history.jsonl:17797`, 2026-07-29: file kinds "(a) atomic … (b) multi-document … (c) snippet -- … could, for example, have :attributes at the topmost level before normal children in the document".
- **Conflicts:**
  - **[A]** `design/udon-ast.md` (Jan 2026) has no implicit root, per `70-survey-index.md`.
  - **[A]** `spec-0.09.01/udon-0.9.1-primer.md` §5: "Root | no implicit root; top-level siblings allowed".
  - **[A←J]** `DECISIONS.md` **L1** (line 111): root-level `:key` becomes "**Warning** + keep as **document-level Text**".

  The lite decision supersedes all three. They matter only as sources that will mislead a reader.

### 16. Streaming and bounded lookahead (tension: lite is AST-centric)

- **[J]** `history.jsonl:6003`, 2025-12-27: "we've got a screaming fast state-machine recursive-descent parser right now that benefits a lot from not having to wait like that before knowing what it has in hand..."
- **[J]** `history.jsonl:15840`, 2026-07-11: "descent works well because we rarely have more than 2 or 3 characters of lookahead we need to do-- if it was more than that and multiple levels of backtracking we would have had to go with a PEG".
- **[J]** `history.jsonl:6466`, 2025-12-31: "ensuring that it doesn't prematurely emit a BoolTrue just because of where the chunk boundary happen to be".
- **[S]** 0.10.0 `CORE.md` §2.3: "Every guard resolves within a few characters … new syntax MUST stay inside the bound … a document parses identically whole or byte-at-a-time."
- **[J-2011]** `objectives.asciidoc:43`: `On-line processing | 6`.
- **[A]** `udon-needs/02-tooling-needs/src/streaming-and-partial-documents.md`: "Partial documents are the normal case … A format whose *every prefix* parses to an honest partial state removes the tax at the source."
- **Gloss:** lite's README says "AST-centric". Lite documents must still parse identically under full UDON's streaming parser (#2), and the descent route is a streaming recursive descent. So bounded lookahead may come in as an inherited constraint even though lite does not specify events. It could be `lite-obj` (rules must stay in the bound) or `future`.

### 17. Decisions flow from demand to grammar; the past is not an authority

These are process principles, relevant to how `obj/` records are argued.

- **[J]** `history.jsonl:17899` (**O17**, 2026-07-29): "such decisions I *now* want to be making from the demand and theory and principled side, not from the 'what can we do easily with the grammar before knowing what we actually need.'"
- **[J]** `history.jsonl:17902` (**O18a**): "My whole work has been trying to find out where early decisions weren't as principled as they tried to be and to truthify them, so I get very frustrated when agents continue to assert the past as an authority, no matter how 'accurate' they are."
- **[J]** `history.jsonl:17901` (**O18**): "This is our least expensive time to make a principled *invasive* change to udon."
- **[J]** `history.jsonl:18791` (memory "v2 sweet-spot"): "the way we define something carefully (instead of plausibly as a quick lexical choice that is an explanation of things we've seen instead of principles on which they are built) can have enormous, enormous downstream impact."
- **[J]** `history.jsonl:17225`, 2026-07-22, on fiat dressed as principle: "it took a fiat 'in-scope' decision from me … and tries to turn it into a grounded principle. It's a category error … Just the principles please."
- **[J]** `history.jsonl:16198`, 2026-07-14: "spec/* … should and is the *sole source of truth*. Where the descent grammar and the parser diverge from CORE, you can't assume it's 'settled by the implementation'".
- **[J]** `history.jsonl:15770`, 2026-07-11, which became `design/desc-design-principles.md`: "there are limits where suddenly the per-line lexing of the ruby and it's assumptions were dictating desc syntax more than the principles of descent and parsing comprehensibility were..."
- **Gloss: a tension with lite's implementation route.**
  - Lite's README says "No bespoke lite parser needed. The mainline recursive-descent grammar (descent) is the implementation route", and 21299 says the same.
  - **[A]** `MINEFIELD-MAP.md` M11: "A grammar defined by an implementation has no fixed point."
  - 15770 shows implementation artifacts dictating syntax.

  A lite objective or principle that keeps the spec authoritative over descent (as 16198 does) may be worth stating, since lite's parser will be descent's.

### 18. Time-to-comprehension: a source for the example in `conv-purpose-layer`

`sop/src/conv-purpose-layer.md`'s working notes say the "time to comprehension" example "has no recorded source here" and was traced to TST. These are the sources:

- **[J]** `history.jsonl:17700`, 2026-07-28 23:13:
  > "coherence with current state of domain understanding proportional to future development speed; nouns and names that reflect and teach current state of the domain inversly proportional to time-to-comprehension" is as close to first-principled for me colliquially even though it misstates the current epistemological status.
- **TST [A/J lineage, "old-tst"]:** `~/src/arch/asf/02-tst-core/src/old-tst-software-first-principles.md:403`: "A principled decision minimizes both time-to-comprehension and time-of-implementation for future features." Related lines: 421, 604, 644.
- **[J]** `history.jsonl:5350`, 2025-12-20. The revival was motivated by TST (`~/src/_core/zoetica/docs/refs/temporal-software-theory-distilled.md`, not read): "help me decide if Udon is worth reviving *on its own merits* independent of uptake".
- **A ready instrument for a fitness:** REVIEW §3 records the Dec-2025 usability harness (`test/usability/`) and a measured **89.6%** authoring score over n=37 runs, scored mechanically. It also records Joseph's calibrations: the score is a floor, and the next run should widen to Codex, Gemini, and open models. O8 and O9 (DISCUSSION-THOUGHTS) carry the "fluency subset" and "spontaneous adoption as canary" framing.

### 19. Errors teach; a refusal names its class

This is mostly future (tooling), but it touches lite where lite's "reserved" refusal is specified.

- **[J]** `history.jsonl:5613`, 2025-12-24: "I would like some world-class error and (if there are any) warnings as part of this compiler." `:5652`: "World-class error messages and warnings to guide UDON document creation".
- **[J]** `history.jsonl:16795`, 2026-07-18: "is the event parser … preserving the fact that there were unclosed delimited constructs so it knows … to give a general 'unexpected EOF' error? (if we continue to define error as 'data was likely lost')".
- **[A, `decided`/`supported`]** in `arch/firmatum/principles/src/`:
  - `norm-refusal-names-class.md`: "'Not found,' 'not unique,' and 'resolves to several' are different situations with different repairs."
  - `norm-refusal-offers-next.md`: "Error-as-menu".
  - `norm-success-is-quiet.md`.
- **[A]** `design/agentic-ux-principles.md` P2 and P3: "binary-where-possible verdicts … UDON's existing warning-*code* posture (codes, not ratified strings)".
- **Gloss on `arch/firmatum/principles`:**
  - As Joseph said, these are CLI/tool-centric: stdout-is-data, no-prompts, help-is-law, config precedence.
  - The atoms that transfer to *lite as a spec* are the refusal-class pair, and possibly `form-agentic-eyes` ("minimum surprise from the tool").
  - The rest belong to lite's *tooling* (future).

### 20. Version and dialect marking (pre-design 84 Q3)

- **[J]** `history.jsonl:7909`, 2026-01-14: "Just like document schemas end up really needing a HARD schema-version in order to be useful, I wonder if we need one or two elements or directives for udon documents that say 'This is an archema resource flavored udon.'"
- **[J]** `history.jsonl:15379` (CTQ): "IN (probably) notation for dialects … AND expected host-language / interpreter+version, and as you noted, at least the possibility of core version in case it's ever needed in the future."
- **[J-file]** `design/file-naming.md` (adopted 2026-07-11): `<name>.<schema/type>.udon`. "**Semantics: application-level for now, deliberately.**"
- **[J]** `history.jsonl:17684` (O6): "the 'filename.<namespace>.udon' affordance -- directly stating 'I expect this to be converging onto an orderly and transferable schema at some point soon'".
- **[A]** REVIEW concern 8: "No version/dialect pragma exists yet — a source-of-truth substrate must be able to survive its own evolution."

---

## 2. Candidates for `obj.future/`

Each item gives its lead primary only; the files named hold the rest.

21. **Schema-guarded structural mutation as the customer** for paths, schema, spans, and round-trip.
    - **[J]** `history.jsonl:16472`, 2026-07-16: "I'm far more interested in a principled agentic tool that works like your edit tool but guarantees atomicity and guarantees that whatever you're changing or patching etc. has the right indents and is conformant with that file's spec."
    - **[J]** `:17063` (in the demand list): "a specialized edit tool that makes edits very easy without needing to worry about indent-levels … guaranteeing that no mutation that would cause the document to now violate the schema is accepted."
    - **[A]** `v2/theory/src/obs-mutation-customer.udon` (robust-qualitative); `udon-needs/02-tooling-needs/src/schema-guarded-mutation.md`.
22. **Paths and addressing** (lite has none).
    - **[J]** `:17228`: "paths-- probably one of the most used affordances in all of technology".
    - **[A←J]** **PATH-1** cross-document in scope.
    - `v2/references/def/` is the adopted vocabulary.
23. **Dialects, typed envelopes, temporal.**
    - **[J]** `:17384`: "values with no <...> is a very small core subset, very well defined. Then one or two 'always available' dialects".
    - **[A]** `late-misc-synopsis.md` §5: "**degradation contract** — a dialect declaring what frozen bare primitive it collapses to when unloaded".
    - **[A]** ADJUDICATED C8.3 (EDN): "freeze print grammar … preserve unknown tags by default; put tag version in tag name".
24. **Templates and directives through references.** **[J]** `:20532`: "references themselves … ARE the only thing we need to have everywhere (hence what was 'context object' is now 'referent')".
25. **Schema as a living system (fiat seats, removal-reasons, de-facto extraction).**
    - **[J]** O1, O4–O7, O10 in `DISCUSSION-THOUGHTS.udon`. Example: O10, "constraints that carry their REMOVAL-REASONS".
    - **[A]** `late-misc-synopsis.md` "fiat strata" P1–P4.
26. **Tooling for agents.**
    - glance/skeleton ("you are given the *defacto* schema … in path-syntax form", **[J]** `:7892`)
    - fmt tabled (**[J]** `:16472`)
    - a file-watcher guard (**[J]** `:16497`)
    - an ALSP-like feedback loop (**[J]** `:5767`)
    - **[A]** `design/udon-agentic.md` P1–P4 ("No Mechanical Burden" and others).
27. **Proven agent onboarding (measured).** **[A←J]** REVIEW CTQ-D "Proven agent minimal-onboarding artifacts — *proven* = measured". **[J]** O8 (`history.jsonl:17689`, fluency-subset testing) and O9 (`history.jsonl:17690`, quoted here): "a point when they start saying 'this looks great, but too much friction to get started the right way.'"
28. **Epistemic register / annotation as structure.** **[J]** O11 (`history.jsonl:17705`): "future agents have no good way of knowing what is deliberate vs incidental". **[J]** O12: core schemas including "epistemological labels or agent interior thinking traces that are meant to not survive any translation/publication pipeline".
29. **Self-chunking for retrieval.** README claims it. **[A]** counter-register row 8 notes it is unmeasured, and a "claim-or-kill experiment" is specified in `self-chunking-status.md`.

---

## 3. Non-goal candidates

- **N1. Not Turing-complete; not for algorithms.** **[J-2011]** `objectives.asciidoc:16-17`: `Algorithmic declaration | 3`, `Turing completeness | 0`. **[J]** `:17656`: liquid "might make the extensibility useful without turning into rebol".
- **N2. Not for pure source code, narrow fixed-schema data packets, or binary.** **[J]** `history.jsonl:5571`: "'pure source code including homoiconic ones' … and 'niche or narrowly scoped well-defined data packets' (e.g., csv …) … binary formats". Restated in **[A]** `positioning.md` "When not to use UDON".
- **N3. No markdown *parsing* in core.** **[J]** `:15379` "EXCLUDES (initially) actual parsing of markdown". **[A]** `design/markdown-layers.md` (from Joseph's 07-11 framing): "**The core parser knows none of this.**"
- **N4. No template evaluation in core.** **[A←J]** REVIEW CTQ-A "EX **Template evaluation** as core".
- **N5. No adoption or uptake work.**
  - **[J]** `:5350`: "decide if Udon is worth reviving *on its own merits* independent of uptake".
  - **[J]** `:15379`: "EX any worry about pickup / adoption, assuming the agent-onboarding works".
  - **[J]** `:17808`: "the fact that someone else beat us to implementation … is not the point."
- **N6. No backward compatibility in the pre-lite era.**
  - **[J]** `:5734`: "there is *zero* need for backwards compatibility".
  - **[J]** `:16726`: "no wire compatibility, no ABI, no expectations of anything right now".
  - **[J]** `:18791`: "no backward compatibility (that isn't very easily overcome) -- no public external usage yet".
  - **Gloss:** lite's reserve contract is the estate's *first forward promise*. Once lite documents exist in the corpus, the era in these quotes ends for whatever lite defines. `MINEFIELD-MAP.md` M5 states the mechanism: "corpus has unbounded settling time, so the admissible spec-change rate is effectively zero unless the change is additive by construction". This seems worth naming in the purpose layer, because it is what makes clause 1 expensive to get wrong.
- **N7. No performance work beyond current, with a conflict.**
  - **[A←J]** REVIEW CTQ-C: "EX **Performance work beyond current** … Don't chase."
  - Against that: **[J-2011]** `[Performance] | Very High`, and **[J]** `:5652` "Screaming fast …".
  - INBOX (08-30) wants *tiny dependency-free* parsers, a different axis again.
- **N8. Not a markdown superset in rendering terms.** The "which markdown?" question is a separate layer (**[J]** `:17396`).

---

## 4. Cross-cutting conflicts worth surfacing

1. **Fences vs. `!:kind:` for code.** This one is substantive for lite, because vsect's top requirement is robust fences.
   - The estate's measured, recommended embed form is `!:label:` block verbatim:
     - **[A]** `fence-knot-table.md`: "UDON's ``` fence is exactly three backticks and has no length variation. … It does not fail loudly. … The escape hatch that does work is `!:label:` block verbatim."
     - The **[J]**-named practice candidate in DISCUSSION-THOUGHTS: `prefer-block-verbatim-for-embedded-grammars`.
     - **[S]** 0.9.1 PEDAGOGY: "code blocks | `!:lang:` | fences".
     - **[A]** `design/examples/practices-gotchas.udon`: "Prefer !:lang: for code blocks. Reserve triple-backticks…".
     - **[J]** `history.jsonl:6059`: `!:json:` "would be the preferred way to have json snippets".
   - Lite reserves `!:kind:` and is left with exactly the fence form measured as silently fragile. This is pre-design question 11.
2. **Warn vs. error vs. loss-severity for reserved syntax** (#2).
3. **The interim behavior of `<…>` with no dialect.**
   - **[A←J]** R13 `<>` "interim BareValue+NoDialectsLoaded"; the primer says the full lexical form is carried "with a warning".
   - **[A]** JOSEPH-FOR-FIX §3: "Nobody warns that nobody has yet."
   - **[J]** `:20781`, on 0.10.01: "says it doesn't do things *on purpose* instead of warning that nothing will handle it".
   - Lite's README: "attaching no meaning", which does not say whether it warns. This is pre-design question 07.
4. **Attributes before content vs. late attributes.**
   - **[S]** 0.9.1 §15 #1 and the Dec-2025 design principle "Attributes before children".
   - **[A←J]** **K14** (`DECISIONS.md:173`): "Late attributes: accept + Warn". Joseph's own words at `history.jsonl:18897`: "I realized how useful it could be to have attributes further down after more of the content". This is pre-design question 88.
5. **Implicit root.** See #15.
6. **Tabs.** See #12.
7. **Agents first vs. humans first vs. "beauty highest".** See #3.
8. **Markdown subset vs. "superset of nothing".** See #4.
9. **Stacking warned vs. silent.** See #7.
10. **"Reserved" vs. "designated".** See #2.

## 5. Arguments against otherwise-obvious principles (consolidated)

- **"Structure helps comprehension"**: measured to fail on 1 of 4 model families (counter-register row 1, carried at Joseph's ruling).
- **"Attributes may hold nodes"**:
  - **[A]** counter-register row 2 (Obsidian's deliberate anti-nesting: "properties are meant for small, atomic bits");
  - **[J]** `:7832` udon-xml flavor, "no complex elements as an attribute's value".
- **"Indentation-as-syntax is safe"**: ADJUDICATED C6.1/C6.2 and REVIEW concern 6 (silent reparenting). These are *not* counter-evidence against indentation itself (C6.4: Sass→SCSS refuted).
- **"Strictness wins (the JSON lesson)"**: argued in defining-udon, answered in RATIONALE, and reframed by MINEFIELD M2 as loud vs. silent.
- **"Make invalid states inexpressible"**: Architectus' ease-gradient vs. Joseph's K12 "limiting an important use-case because of an unimportant failure mode."
- **"UDON for append logs"**: positioning.md sends append-only logs to JSONL, but the estate does the opposite (#13).
- **"Must-ignore is the forward-compat default"**: lite chooses refuse (#2). This is principled, but it is the opposite branch.

## 6. Pointers already built, plus side findings

- **Per-question history indexes with Joseph's verbatim words already exist.** `.int/pre-design/*.discussion.md` and `70-survey-index.md` (the latter has a dated, sourced chronology of past adjudications from 2011 on). Reading their "Threads worth noticing" sections would be cheaper than re-locating. I used them only to cross-check.
- **Stale pointers:**
  - udon `CLAUDE.md` / `README.md` "Historical Repositories" names `~/src/_ref/udon/` and `~/src/_ref/udon-c/`. Those are now at `~/src/_older/udon/` and `~/src/_older/udon-c/`. `objectives.asciidoc` is the file that matters most here.
  - `sop/src/conv-purpose-layer.md` working note: the source it lacks is #18 above.
- **The 2011 `objectives.asciidoc` is the only explicit weighted objective list in the estate.** It is a ready-made ancestor for `force`, and its weights can be compared against today's.
  - Beauty: Highest.
  - Performance: Very High.
  - Utility: Very High.
  - Support: High.
  - Example sub-weights: `Self-description-ability 10`, `License liberality 10`, `Standardization 3`.
  - The Dec-2025 `_archive/analysis.md:27-34` already summarized it.

## 7. Coverage note

**Read whole:**

- `.int/README.md`, `obj/*`, `sop/src/conv-purpose-layer.md`, `sop/def/def-record-kinds.md`, `.int/vsect-requirements-on-lite.md`, `.int/reserved.md`, `pre-design/README.md`, `STEWARD-2026-09-29.md`, `scratch-jaw.md`.
- `_older/udon/doc/{objectives.asciidoc, features.asciidoc, compare-to.asciidoc, description.udon}`, `_older/udon-c/docs/{DECIDED.md, NOTES.md}`.
- `defining-udon.md`; `design/{positioning.md, agentic-ux-principles.md, desc-design-principles.md, file-naming.md, markdown-layers.md}`.
- `v2/{DECISIONS.md, README.md, WHERE-THINGS-STAND-2026-09-27.md, JOSEPH-FOR-0.10.01-FIX.md, INBOX-REQUESTS.md}`, `v2/msc/BEST-WITH-UDON.md`.
- `v2/theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon`; `v2/theory/src/` (4 of 6 segments).
- `spec-0.09.01/{RATIONALE.md, PEDAGOGY.md}`.
- `udon-needs/{CLAUDE.md, README.md, 01-ideation/needs-map.md, 01-ideation/STEWARD-CALLS.md}`, `02-tooling-needs/OUTLINE.md`, `02-tooling-needs/src/counter-register.md`.
- The vivarium day-report copy; `firmatum/principles/src/*` (all atoms).
- **Joseph's typed turns:** every udon-related turn of 160+ characters in `history.jsonl` that matched a principle keyword set, which is 569 turns, read in full (Dec 2025 – Sep 30 2026). I also scanned a second set of 373 turns, using a different keyword set, by snippet.

**Read in part:**

- `spec-0.09.01/udon-0.9.1-primer.md` (§§1, 4–8); 0.10.0 `CORE.md` §§0–2.3, 15; 0.9.1 and 0.10.01 `CORE.md` §15/§13; old `spec/CORE.md` Design Principles.
- `_archive/REVIEW-JULY-2026.md` (§§1, 3, 7); `_archive/analysis.md` (head, §539); `_archive/SPEC.md` §Design Principles.
- `design/udon-guarantees.md` (headings and close), `design/udon-agentic.md` (principles); `design/examples/practices-gotchas.udon` (head).
- `format-failures/{ADJUDICATED-CLAIMS.md (§§exec, 3, 6, 8, 10–12), MINEFIELD-MAP.md (§§1, 3)}`; `late-misc-synopsis.md` (§§1, fiat strata, 5–6).
- `markdown/{commonmark-non-conflict-table.md, fence-knot-table.md}` (bottom lines).
- `02-tooling-needs/src/{typing-and-schema-boundary.md, round-trip-and-span-splice.md, streaming-and-partial-documents.md}`; `principles/influx/the-pattern.md` (head).
- `sop/influx/jaw-proposal-and-feedback.md` (grep only; it is SOP-side, not lite principles).
- The pre-design `.discussion.md` files (grep only).

**Searched:**

- memorata-search `--joseph` across harnesses. This turned up almost nothing outside Claude `history.jsonl`. There are no Joseph udon turns before 2025-12-20 except one Codex question; the Grok night session is cited by `70-survey-index.md` but I did not open it.
- memorata on agent testimony, the ease-gradient, and forward-compat; ripgrep for goal/principle headings across the udon repo.

**Not read (unexplored volume):**

- `udon-needs/01-ideation/02-provenanced/**` (~325 files), including `de-novo-testimony/`, I1 `AGENT_FEEDBACK-full.md` (827 lines), and `III-schema`.
- Most `02-tooling-needs/src` chapters and all seven `reports/`.
- `v2/references/` (beyond knowing it is the adopted vocabulary).
- `v2/theory/to-integrate/{lexical-forms-*, unification-matrix, underlying-logical-model, acid-for-corpora, type-algebra, sameline-*}`; `refine-more/doc-store-and-schemas-report.md` (whose §16.4 "ten principles" is the OPERATA set); `design/{udon-ast.md, schema-notes-2026-07.md (§13 non-goals), udon-paths.md}`; `spec/TIME-SPEC.md` Design Principles.
- `test/usability/` results; `_archive/feedback.md`.
- The Sep–Nov 2025 sapientia/ennaos tooling corpus (it is mapped in `agentic-ux-principles.md`'s source index); TST `temporal-software-theory-distilled.md`.
- Grok and Codex session bodies.
