# Proposal: spec-lite-0.1.0 as a small verisectorium

*For Joseph. First written 2026-09-30 by an Opus 5.5 fork of the aat-refactored coordinator. Revised the same day after his changes:*

*Moved to `sop/influx/` on 2026-09-30 at Joseph's direction. Backticked paths in this file are relative to the `spec-lite-0.1.0/` root; the links are relative to this file.*

- *everything is Markdown for now;*
- *decisions carry reasoning and assumptions, one ADR file each (`adr/`);*
- *working notes on every record;*
- *`fixtures/` → `dat/`, `influx/` → `.int/`;*
- *an SOP store (`sop/`) whose `sop/def/` defines this corpus's own apparatus;*
- *a purpose layer (`obj/`) for objectives (with `force`), principles, and possibly fitness;*
- *`bin/` for bespoke processing scripts that will inform vsect.*

***Register: proposed.** Nothing here is adopted or frozen. The skeleton is [`main.outline.md`](../../main.outline.md), the decision template is [`adr/TEMPLATE.md`](../../adr/TEMPLATE.md), and the apparatus vocabulary is in [`sop/def/`](../../sop/def/). The first-pass copies are in `.old/vsect-init/`.*

## The shape in one paragraph

Lite is mostly **chosen**, not derived: which spelling means what is a decision, and no amount of checking makes it true. So every normative record rests on two kinds of warrant:

- **Decision warrant:** who decided, on what reasoning and assumptions, against which alternatives, and what would reopen it. This lives in one ADR per decision under `adr/`, which keeps Joseph's verbatim words apart from anyone's rendering of them.
- **Check warrant:** the truth-apt properties of the rules. Every input gives exactly one tree; the rules don't contradict each other; the rule set keeps the reserve-don't-ignore promise; a real parser agrees with the fixtures.

Rules are written with RFC 2119 language and cite the decisions they rest on. Derived properties are separate records that a counterexample can break. The fixtures in `dat/` are the operational definition of the tree, and teaching prose describes the rules without adding to them. Topic lives in the outline; kinds only say how each record is judged.

## Why decisions and provenance weigh more here than in AAT

In AAT, "who said it" is irrelevant to whether a theorem holds. In a language spec, most normative content has no truth of the matter: `|a |b` could mean either thing, and what settles it is what lite is *for*, which is Joseph's call. Three things that were noise in AAT carry weight here:

- **Accountability:** who decided, and how firmly (the seven-value decided-by vocabulary).
- **Wording:** Joseph's text versus an agent's rendering of it. v2's own `DECISIONS.md` warns about this for the K-rows: *"Joseph never ratified any row below as written … the K-labels and row prose are the coordinating agent's good-faith interpretation."* Its conflict protocol ("when you said 'xyz' — were you also implying 'abc'?") is carried into the ADR template.
- **Reasoning and assumptions:** a decision can only be reopened on the grounds that were written down at the time. The cleanest reopen trigger is an assumption that stops holding, and that only works if the assumption was recorded.

The truth-apt part does not disappear; it moves to properties (determinacy, forward-stability, equivalences), to consistency between rules, and to agreement between the fixtures in `dat/` and a parser. At that seam RC1's substitution law applies: *a decision never makes a property true*. "Joseph ruled that `<…>` ends at the matching `>`" does not establish that the rule is one-pass or unambiguous. A property record has to do that.

## Kinds

A kind is admitted only when it fails differently and is repaired differently from the other kinds (RC1's rule). Each kind's definition is in [`sop/def/def-record-kinds.md`](../../sop/def/def-record-kinds.md).

| Kind | Does | Fails by | Repaired by | Write | Lives in |
|---|---|---|---|---|---|
| **objective** | a property lite must have, decided, with a `force` (`non` · `desired` · `required` · `critical`); a requirement is an objective with `force: required` or `critical` | the rules don't meet it; conflicts with another objective; stops being wanted | fix the rules; Joseph revises it and everything citing it is re-examined | replace | `obj/obj-*` |
| **principle** | a tie-breaker cited when several alternatives all meet the objectives | ignored; inconsistently applied; its choices keep needing reversal | Joseph revises it; decisions citing it are re-examined | replace | `obj/prin-*` |
| **definition** | a term-group, after the `../references/def/` style | ill-defined for some input; used inconsistently; collides with a references term | re-state; fix the uses; cite the references term instead | replace | `def/` (lite's terms) · `sop/def/` (this corpus's apparatus terms) |
| **rule** | normative (MUST/SHOULD/MAY): how bytes become a tree, what is reserved, what is an anomaly | ambiguous (two readings); underdetermined (a case can't be settled); contradicts another rule; breaks an objective | amend the text (with an ADR if the choice changes); add the case that pins it | replace | `src/rule-*` |
| **property** | a derived claim about the rule set (determinacy, forward-stability, one-pass, equivalences) | a counterexample; a broken derivation | narrow it; fix the rule; if it falls, a no-go replaces it | replace | `src/prop-*` |
| **fixture** | one input, the expected tree, the anomalies; its profile says whether it gates | disagrees with the rules; goes stale when a decision flips; a parser disagrees | re-derive from the rule; flip it, citing the ADR; fix whichever side is wrong | replace, flips logged | `dat/rule-*.yaml` |
| **decision** | what was decided, by whom, verbatim where located, the reasoning and assumptions, alternatives, what reopens it | misattributed; an interpretation carried as Joseph's words; silently overturned; an assumption stops holding; a reason reconstructed after the fact | correct the attribution; conflict protocol back to Joseph; a new ADR that supersedes it | append-only; superseded, never edited in place | `adr/<slug>.md` |
| **question** | an open design question with its alternatives | lost; re-asked after being answered; routed to the wrong closer | route to a declared closer; close it into ADRs and rules | replace until closed | `.int/pre-design/` |
| **explanation** | teaching: overview, guides for JSON/YAML and XML/HTML users, common mistakes, rationale | mis-teaches; says more than the rule; goes stale | a reader test; check it against the rule; refresh | replace | `src/expl-*`, or a marked section inside a rule |

**How your candidate list mapped:**

- *objectives/requirements* → objective.
- *guiding principles* → principle. This is the weakest-admitted kind: if principles keep reading like objectives, merge them.
- *lexical rules* and *well-formedness* → both **rule**, because they fail and are repaired the same way. Their difference is a `layer` field (`source` · `element` · `value` · `text` · `reserved` · `anomaly` · `tree`), which the outline shows as Parts.
- *formal semantics* → **definition** (node types as term-groups) plus tree-layer rules; which spellings mean the same is a **property** (`prop-equivalences`).
- *types* → `def-typed-value` plus the value-layer rules.
- *fixtures/examples, valid vs misguided* → **fixture**, with profiles.
- *pedagogy* and *typical-usage* → **explanation**, plus `idiomatic` cases. Typical usage is a view that selects idiomatic cases.

**Considered and not admitted:**

- **lean:** it becomes an ADR at status `proposed`, with Joseph's words verbatim.
- **grammar production:** the formal statement of a rule, kept inside that rule's file.
- **anomaly:** a rule in the anomaly layer, with one extra field saying whether its keep-shape is a forward-stable promise.

**What the kinds rest on, honestly:** RC1's admission rule, the prior spec suites' actual sections, and one mechanical check. The check: every pre-design question number lands in some outline row, except 67 and 70, which are reports rather than questions. It was run by script. Nothing else was sampled.

## The purpose layer (`obj/`)

`obj/` holds the records the rest of the spec is judged against. Decisions cite them in `drivers-cite`; rules cite objectives in `per` or `depends`. The types below are *possible* higher-level types. Each is admitted when a real record needs it, not up front.

- **objective:** a property lite must have, which is met or not. It carries a `force` field:
  - `non`: a **non-objective**, something lite deliberately does not try to do ("lite does not type dates"). A non-objective bounds scope, blocks creep, and records what the reserve-don't-ignore contract costs.
  - `desired`
  - `required`
  - `critical`

  A **requirement** is an objective with `force: required` or `critical`. That is the only spelling. There is no `req` alias, so no reader has to wonder whether the two differ. Force is a field, not a set of kinds: all four levels fail and are repaired the same way, and separate kinds would fuse kind with severity (RC1's fusion tell).
- **principle:** a direction. It is the tie-breaker cited when several alternatives all meet the objectives.
- **fitness** *(possible; not yet admitted)*: a scalar that is optimized rather than met or not met, measured through a concrete proxy. It is admitted when the first real fitness record is written. Candidates already visible in the material:
  - time to comprehension, Joseph's guiding principle (recorded in `.int/`);
  - how often agents write lite wrongly (the census in 67 gives starting material);
  - measures of append-safety (68).

### Why fitness would be its own kind

**It fails differently:**

- **The proxy stops tracking what it stands for.** This is Goodhart's law: once a measure becomes a target, optimizing it can move the number without moving the thing it was meant to indicate.
- **The measure becomes unavailable.**
- **Its era changes.** A value measured under one parser or corpus version does not carry over to the next.

**It is repaired differently:** validate the proxy against cases where the answer is known; re-measure under the new era; replace the proxy.

**It carries a truth-apt claim that objectives and principles don't:** "this measure tracks this principle." That claim can be wrong, and it needs evidence. So a fitness record holds:

- the **measure**: what is computed, from what, and how;
- the principle it **serves** (`serves:`);
- the **proxy-validity claim**: its evidence, and what would show it wrong;
- the **measured values**, each with its era. A value is recorded by a run (the way vsect will compute them), never typed by hand.

### One concern, three records

One concern can need all three:

- a **principle** gives the direction: "minimize time to comprehension";
- a **fitness** says how it is measured, e.g. seconds for a fresh reader to answer N questions about a lite document;
- an **objective** at `force: required` sets the threshold that must be passed (`threshold-on:` the fitness).

They are separate records because each can be wrong while the others hold. The principle can be right and the proxy bad. The proxy can be sound and the threshold too low. The threshold can be met after the principle is no longer wanted.

### Two guards

- **Goodhart.** A fitness serves a named principle, and its proxy-validity claim stays on record and stays checkable. Meeting the number is never taken as meeting the principle. When the measure and the thing it stands for could come apart, the fitness record says how, and what would show it.
- **Commitment.** *"An objective's threshold on a fitness must be set before the measurement it gates. A threshold chosen after seeing the numbers is tuned, not tested (RC1's commitment law)."*
  - To make this checkable from the record, a threshold objective records when its threshold was committed. Every measurement it gates must be dated after that.
  - A threshold changed after the numbers are in is a new decision that supersedes the old one, and it is marked as set post hoc.

### Mixed first, split on demand

A new concern can start as one segment with correctly headed sections (*Principle*, *Fitness*, *Objective*). Each part is split into its own record as soon as any of these happens:

- **reuse:** another record needs to cite one part on its own;
- **appending:** modifications start being appended to one part;
- **one-sided change:** a finding, revision, or decision lands on one part and not the others.

The third trigger catches the case where one part is found wrong while the rest stands, before anyone has started appending. Once split, the parts link to each other: the fitness `serves` the principle, and the objective is `threshold-on` the fitness.

## Two lexicons: `def/` and `sop/def/`

- **`def/`** defines **lite's** terms: `document`, `typed-value`, element, attribute. These are the vocabulary of the language.
- **`sop/def/`** defines **this corpus's apparatus**: record, kind, the fields, decision status and authority, supersession, fixture profiles, closers, the delete-test. These are the vocabulary for working on the language.

They are the same kind (definition) in different stores, which is verisectorium's store triplet: canon, lexicon, and an SOP store that is itself a small verisectorium. They are kept apart for two reasons. The two vocabularies change for different reasons and at different rates. And the apparatus terms are meant to travel: `sop/def/` is written to be lifted into verisectorium, and later into vsect's own vocabulary, once this repo has exercised them.

Where a term already exists in the udon addressing theory (`../references/def/`: binding, dangle, collide) or in verisectorium RC1, `sop/def/` cites it and does not restate it.

## Records and fields

**Everything is Markdown for now**, with YAML frontmatter. Writing lite's own records in udon while lite is undecided would make every open question a parse question in our own files. Moving to udon records is spec-lite 0.1.1's job, once a lite parser exists. To keep that move cheap, field names are bare words, with no `!` and no `@`.

| Field | On | Meaning (defined in `sop/def/def-record-fields.md`) |
|---|---|---|
| `kind` | all | as above |
| `layer` | rule | `source` · `element` · `value` · `text` · `reserved` · `anomaly` · `tree` |
| `state` | all but decisions | process flags (`proposed`, `drafted`, later `checked`, …); resettable, never a ladder |
| `per` | objective, rule, fixture | slugs of the ADRs it rests on |
| `questions` | all | pre-design numbers still open against it |
| `depends` | all | records whose *text* it uses (another rule, a def) |
| `fixtures` | rule | path to its `dat/` file (a pointer, not a count) |
| `narrates` | explanation | the records it describes; any change to one of them marks the explanation stale |
| `force` | objective | `non` · `desired` · `required` · `critical`; a requirement is `required` or `critical` |
| `serves` | fitness | the principle(s) the fitness measures progress toward |
| `threshold-on` | objective | the fitness whose threshold this objective sets |
| `committed` | threshold objective | the date the threshold was set; the measurements it gates must come later |
| `max` | all but decisions | `decided` for objectives, principles, rules, definitions; `exact` or `conditional` for properties |

Decisions carry their own frontmatter, defined in `adr/TEMPLATE.md`: `status`, `decided-by`, `wording`, `grounds-recorded`, `supersedes` / `superseded-by`, `closes`, `leaves-open`, `affects`, `drivers-cite`, and the deciders / consulted / informed trio.

**No hand-set strength field.** A rule's standing is computed from what happened: its ADRs, its `dat/` cases, and whether a parser run agreed. Until vsect exists, nobody types a status word that could lie. An ADR's `status` is the decision's own lifecycle, not a status on the rules that cite it.

**RFC 2119.** Capitalized MUST / SHOULD / MAY appear only in a rule's or objective's Statement section. Explanation prose never uses them, so normative text can be told from teaching by its words alone.

**Cadence of a rule file:**

1. frontmatter;
2. title, and a one-line italic summary;
3. Statement (numbered clauses);
4. Open parts, not decided here;
5. Grounds (ADRs, history pointers);
6. Epistemic status (what is checked, what isn't);
7. optionally, an Explanation section marked as teaching;
8. Working notes.

`src/rule-implied-root.md` is the worked sample.

**Working notes, everywhere.** Every record of every kind ends with a *Working notes* section: rules, objectives, principles, properties, definitions, explanations, each ADR, and the outline. Fixtures carry a `notes:` field per case and a notes comment at the top of each file. The section may be empty, but it is always present, so there is always a sanctioned place for a partial position (a hunch, an unverified lean, "I haven't checked X"). Without one, such a position gets dropped, or pushed into the body as if it were settled. Working notes hold forward work: open threads, cautions, regression guards, dead ends worth not re-walking. What happened and when goes to `CHANGELOG.md`.

## Decisions (`adr/`)

One file per decision, `adr/<slug>.md`, from [`adr/TEMPLATE.md`](../../adr/TEMPLATE.md). That is Joseph's MADR template with the verisectorium fields added; the template's closing section explains each change. In summary:

- **Identity:** the filename is the slug, not a number; a numbered listing can be a generated view.
- **Two axes, not one:** `status` (the lifecycle) and `decided-by` (authority) are separate fields, because they move independently. `accepted` + `supported` is a real, common state.
- **Supersession** is typed and scoped: `revised` / `invalidated` / `alternate`, `whole` / `partial`. Reopening means a new ADR that supersedes the old one; the old one is never edited in place.
- **Required Reasoning and Assumptions.** Each assumption is marked *recorded* or *inferred, unconfirmed*. Where the source records none, the section says so and is never back-filled; `grounds-recorded: reconstructed` marks anything recovered after the fact. Assumptions that could break feed *Reopen when*.
- **Wording:** a Quote subsection holds Joseph's verbatim words, and `wording` says whose words the outcome is in.
- **"What changes in the spec"** names the rules and `dat/` cases the decision moves.
- **Edges:** `closes`, `leaves-open`, `affects`, and `drivers-cite` let vsect follow a decision to its questions, its dependent rules, and its objectives.

Eight decisions from `.int/README.md` ("Decided so far, 2026-09-29") were seeded in the first pass. They are kept in `.old/vsect-init/DECISIONS.md`, all marked as renderings, with Reasoning mostly *not recorded*. Converting them to ADRs is a mechanical step. The gaps in Reasoning are the questions to put to Joseph when each decision is next touched.

## Fixtures (`dat/`)

One YAML file per rule, or per cluster of rules; the field key is at the top of each file. Profiles (defined in `sop/def/def-fixture-profiles.md`):

- **canonical:** normative; gates conformance.
- **idiomatic:** normative, and written to teach. Typical usage lives here.
- **counter:** normative, and shows a misguided or surprising spelling. It adds `expects` (what a reader plausibly thinks it means) beside the actual `tree`. This is where "examples of misguided usage" go; they pair with `expl-common-mistakes`.
- **descriptive:** never gates. It carries `readings`, one tree per open alternative, keyed to the question and option. When the question closes, the matching reading becomes the tree, the case becomes canonical, and the flip cites the ADR.

**Still waiting on questions:**

- **A machine transcript of the tree** (86 option B). It would let parsers in several languages be compared byte for byte, making `dat/` the compliance definition, as 0.10.0 §1 intended. Until then, cases use the pre-design text notation.
- **Recording parser agreement.** Once a parser exists, agreement is recorded against the parser version.

The census in 67 lists six live UDON documents. They are a ready regression corpus of idiomatic input.

## Layout

```text
spec-lite-0.1.0/
  main.outline.md            canon view: rows mirror frontmatter
  sop/influx/proposed-verisectorium.md  this file (its settled parts become sop/src/ segments)
  adr/                       one decision per file; TEMPLATE.md
  def/                       lite's own terms; a LEXICON view generated later
  obj/                       the purpose layer: obj-* prin-* (and fit-* if fitness is admitted)
  src/                       rule-* prop-* expl-*
  dat/                       fixtures (data for the parser harness), one YAML file per rule or cluster
  bin/                       bespoke processing scripts; they inform vsect
  sop/                       the SOP store: how work is done here
    def/                     the apparatus vocabulary (verisectorium terms)
  .int/                       material to integrate: README, reserved, scratch-jaw, pre-design/
  .old/                      set aside; vsect-init/ holds the first-pass samples
```

`dat/` is separate from `src/` because its format and consumer differ: data for a parser harness, not prose for readers. It is not separate because fixtures are a kind. Everything else is organized by topic in the outline.

**From the template, adopt when earned:**

- `CHANGELOG.md`, the history layer; worth creating at the first commit that lands records;
- `PRACTICA.ud`;
- a short `CLAUDE.md` front door once a second session works here.

`.int/README.md` is the front door until then.

## Lifecycle of one question

1. A pre-design file in `.int/pre-design/` poses it neutrally, and a history agent writes its history (both exist).
2. Joseph's leans are recorded verbatim (STEWARD).
3. When he decides, an ADR records the outcome, his words (Quote), the reasoning and assumptions as given, and what reopens it.
4. Rule text is written or amended, citing `per:`. Descriptive cases flip to canonical. Any property touched is re-checked by someone other than the rule's author.
5. The question file leaves `.int/` only when the delete-test passes: every alternative, example, and piece of history is landed in rules, cases, and ADRs, or consciously set down.

## What vsect wants from lite

The pipeline is: spec-lite → lite parser → vsect → aat-refactored; later, spec-lite 0.1.1 is written *in* lite and managed *by* vsect. That makes this corpus lite's first real customer, with opinions. Each is traced to its pre-design question; all are my reading, for you to weigh.

1. **Fences must be robust.** The spec corpus is full of udon examples, including reserved syntax (`!if`, `@{…}`) in cases and explanations. Once the spec is written in lite, those examples can live only in fences, because `!:kind:` is reserved (11) and `<…>` closes at the first `>` (07; audit 2026-09-01). Fence content must never be scanned for reserved syntax, and a fence must be able to hold a fence (11 Q3). This is the most binding requirement I found.
2. **Status has no spelling in lite, which is right.** The RC1 udon spike (`firmatum/verisectorium/theory/influx/segments-model-rc1/lang/rc1-in-udon.ud`) made each status cell a `!` generator. Lite reserves `!`, so under lite, projections live only in vsect's output and never in files. That lands exactly where RC1 wants it: hand-set status is inexpressible. Nothing is lost; the spike's spelling waits for full UDON.
3. **Edges are plain names.** `@record[x]` is reserved, so edges are written like `per: [implied-root]` and vsect resolves them. Upgrading them to `@` later is a migration, and the forward contract guarantees the lite spelling keeps its meaning.
4. **Source spans in the tree** (60, 13, STEWARD "layers of the tree"). vsect's `revise` has to tell which named spans changed. It needs line, column, and span on every node as `meta`, even if round-trip of ornament stays optional. That is a concrete vote for specifying "content + meta" rather than leaving it optional.
5. **Append-safety** (68). ADR logs, event trails, and question logs are appended by agents without reading. vsect wants 68's option A, or at least B.
6. **Duplicate keys surface, never merge** (54). Two records with one slug is a `collide` in the addressing theory's terms; vsect needs both kept and the collision visible.
7. **First-line greppability** (68). `grep '^|decision\['` should find every record with its identity and key attributes on one line (77, 74).
8. **`@` inside ordinary values** (09 Q1). Strings like `parser@0.10.01` and email addresses put `@` mid-token. Lite should say plainly whether that is reserved.
9. **Stacked vs list** (65, 83, K15). vsect doesn't care which spelling wins, only that the tree says whether `:depends a :depends b` and `:depends [a b]` are the same.

## What needs you

- **Adopt, change, or discard this model?** In particular: the nine kinds, plus fitness as a possible tenth; `force` as a field rather than separate kinds; no hand-set strength field; the two lexicons (`def/`, `sop/def/`).
- **The proposed closers** in the outline's Open questions table. Most of 01–13 are marked steward-purpose and most of 50–91 agent-open. That is a routing proposal, not a routing.
- **Lexicon location.** `.int/README.md` says lite's terms go in `lexicon.md`; the layout has `def/`. I followed `def/`, with a generated LEXICON view, as the addressing-theory corpus (`../references/`) does.
- **Converting the eight seeded decisions to ADRs.**
- **Fence requirements** (vsect item 1), as input to 11; **spans in the tree** (item 4), as input to 60 and 13.

## Coverage, honestly

**Read whole:**

- `.int/README.md`, `reserved.md`, `scratch-jaw.md`; `pre-design/README.md`, `STEWARD-2026-09-29.md`, `70-survey-index.md`;
- neutral pre-design files 01, 04, 06, 07, 09, 11, 12, 13, 54, 60, 68, 84, 86, and the top of 67;
- `v2/WHERE-THINGS-STAND-2026-09-27.md`;
- all seven `references/def/*.ud`, plus references' CLAUDE, DECISIONS, PRACTICA, and outline;
- the `spec-0.10.01` README and its fixtures README;
- `v2/theory/FORMAT.md` §3–4 and two of its `src/` segments;
- the K-row provenance note and rows K9–K14 of `v2/DECISIONS.md`;
- in the parent session: all of RC1, the verisectorium template, and the live_docs comparison.

**Read in part:** the headings of `spec-0.10.00/CORE.md` and `spec-0.10.01/CORE.md`, and 0.10.0 §0–1.1; the first case in 0.10.1's fixtures; the headings and method sections of discussion files 01, 09, and 13.

**Not read:** the remaining ~50 pre-design files (titles only, via the survey index), the other discussion files, and `JOSEPH-FOR-0.10.01-FIX.md`. The outline's Statement column for those rows comes from titles and the survey index. That was enough for a skeleton, not for writing their rules.

## Working notes

- **`main.outline.md` Part 0 is not updated for the purpose layer:** there is no `force` column, and no row marks which objectives are non-objectives or requirements. Adding a Force column is the obvious next step once `force` is adopted.
- **Where the two guards come from.** Both are from a reply to Joseph earlier in the 2026-09-30 session, which he quoted back when asking for this section. The Commitment guard is quoted as he gave it; the Goodhart guard is written out here from its one-word heading. This proposal's author (a fork) had first put down a different second rule: "a threshold waits until the proxy has evidence that it tracks its principle." That rule is compatible with the Commitment guard (validate the proxy on known cases, then commit the threshold, then take the measurement it gates), but it is not what was meant, so it stays here as a candidate rather than in the section.
- **Stale pointers:** `main.outline.md`, the `src/` and `def/` samples, and `dat/rule-implied-root.yaml` still say `influx/` and `DECISIONS.md`. The renames and the ADR move are not yet swept through them. The fix is mechanical once the seeded decisions have ADR slugs, since `per:` should point at ADRs that exist.
