# Proposal: spec-lite-0.1.0 as a small verisectorium

*For Joseph. Written 2026-09-30 by an Opus 5.5 fork of the aat-refactored coordinator, after reading RC1 whole, the references def store, 0.10.0/0.10.1 structure, and about 15 of the ~70 influx files (listed at the end). **Register: proposed.** Nothing here is adopted, and nothing is frozen. The skeleton is [`spec.outline.md`](spec.outline.md). Samples: two def entries, one objective, one principle, one rule, one fixture file, and a seed `DECISIONS.md`. All are uncommitted.*

*Revised the same day at Joseph's direction: everything is Markdown for now (lite isn't nailed down); decisions carry reasoning and assumptions; every kind has working notes.*

## The shape in one paragraph

Lite is mostly **chosen**, not derived: which spelling means what is a decision, and no amount of checking makes it true. So each normative record here rests on two kinds of warrant:

- **Decision warrant:** who decided, on what grounds, against which alternatives, and what would reopen it. This lives in a `DECISIONS.md` ledger that keeps Joseph's verbatim words apart from anyone's interpretation of them.
- **Check warrant:** the truth-apt properties of the rules. Every input gives exactly one tree. The rules don't contradict each other. The rule set keeps the reserve-don't-ignore promise. A real parser agrees with the fixtures.

Rules carry RFC 2119 language and cite the decisions they rest on. Derived properties are separate records that a counterexample can break. Fixtures are the operational definition of the tree, and teaching prose describes rules without ever adding to them. Topic lives in the outline, and the kinds only say how each record is judged.

## Why decisions and provenance weigh more here than in AAT

In AAT, "who said it" is irrelevant to whether a theorem holds. In a language spec, most normative content has no truth of the matter: `|a |b` could mean either thing, and what settles it is what lite is *for*, which is Joseph's call. That makes three things load-bearing that were noise in AAT:

- **Accountability.** Was this decided, by whom, and how firmly? Uses the seven-value decided-by vocabulary.
- **Wording.** Is this Joseph's text, or an agent's rendering of it? v2's own `DECISIONS.md` warns about exactly this for the K-rows: *"Joseph never ratified any row below as written … the K-labels and row prose are the coordinating agent's good-faith interpretation."* Its conflict protocol, "when you said 'xyz' — were you also implying 'abc'?", is carried into the ledger here.
- **Grounds and reopen conditions.** A spelling decided for the XML use case should reopen if that use case changes.

The truth-apt part does not disappear; it moves. It lives in properties (determinacy, forward-stability, equivalences), consistency between rules, and fixture agreement with a parser. RC1's substitution law applies at the seam: *a decision never makes a property true*. "Joseph ruled that `<…>` ends at the matching `>`" does not establish that the rule is one-pass or unambiguous; a property record does.

## Kinds

A kind is admitted only when it fails differently and is repaired differently from the others (RC1's rule).

| Kind | Does | Fails by | Repaired by | Write | Lives in |
|---|---|---|---|---|---|
| **objective** | a property lite must have, decided (reserve-don't-ignore; XML/JSON alternative; append-safety if adopted) | the rules don't meet it; it conflicts with another objective; it stops being wanted | fix the rules; Joseph revises it, and everything citing it is re-examined | replace | `src/obj-*` |
| **principle** | a tie-breaker cited when several alternatives all meet the objectives | ignored; inconsistently applied; its choices keep needing reversal | Joseph revises it; decisions citing it are re-examined | replace | `src/prin-*` |
| **definition** | a term-group: the lexicon *and* the tree's node types, in the references/def style | ill-defined for some input; used inconsistently; collides with a references/def term | re-state; fix the uses; cite the references term instead | replace | `def/def-*.md` |
| **rule** | normative (MUST/SHOULD/MAY): how bytes become a tree, what is reserved, what is an anomaly, what the tree holds | ambiguous (two readings); underdetermined (a fixture can't be settled); contradicts another rule; breaks an objective | amend the text, with a decision entry if the choice changes; add the fixture that pins it | replace | `src/rule-*` |
| **property** | a derived claim about the rule set (determinacy, forward-stability, one-pass, which spellings are equivalent) | a counterexample; a broken derivation | narrow the claim; fix the rule; a no-go replaces it if it falls | replace | `src/prop-*` |
| **fixture** | one input, the expected tree, and the anomalies; profile says whether it gates | disagrees with the rules; goes stale when a decision flips; a parser disagrees | re-derive from the rule; flip it with a decision citation; fix whichever of parser and text is wrong | replace, flips logged | `fixtures/rule-*.yaml` |
| **decision** | what was decided, verbatim where located, by whom, the reasoning and assumptions behind it, and what reopens it | misattributed; an interpretation carried as Joseph's words; silently overturned; an assumption stops holding; a reason reconstructed after the fact | correct the attribution; go back to Joseph with the conflict protocol; append a superseding entry | append or expressly overturn | `DECISIONS.md` |
| **question** | an open design question with its alternatives | lost; re-asked after being answered; routed to the wrong closer | route to a declared closer; close it into decisions and rules | replace until closed | `influx/pre-design/` (already exists) |
| **explanation** | teaching: overview, guides for JSON/YAML and XML/HTML users, common mistakes, rationale | mis-teaches; says more than the rule; goes stale | a reader test; check it against the rule; refresh | replace | `src/expl-*`, or a marked section inside a rule |

**Suggestion for how your candidate list maps:**

These are suggestions and starting points, not dogma. Please adjust as necessary as you do the actual spec building.

- **objectives/requirements** → *objective*.
- **guiding principles** → *principle*. This is the weakest-admitted kind. If principles keep reading like objectives, merge them.
- **lexical rules** and **well-formedness** → both *rule*. They fail and are repaired the same way, so the difference is a `layer` field (`source` · `element` · `value` · `text` · `reserved` · `anomaly` · `tree`) that the outline shows as Parts, not a kind.
- **formal semantics** splits in two:
  - the tree model goes to *definition* (node types as term-groups, whose invariants read like a model) plus tree-layer *rules*;
  - which spellings mean the same thing goes to *property* (`prop-equivalences`), because an equivalence claim can be refuted.
- **types** → `def-typed-value` plus the value-layer rules.
- **fixtures/examples, valid vs misguided** → *fixture*, with profiles.
- **pedagogy** and **typical-usage** → *explanation*, plus `idiomatic` fixtures. Typical usage is a view that selects idiomatic fixtures, not a separate kind.

**Considered and not admitted:**

- **lean.** Joseph's current leans (the STEWARD file) are decisions at `proposed`, with his words verbatim.
- **grammar production.** A formal grammar fragment is the formal statement *of* a rule, kept in that rule's file. A separate grammar that disagrees with the prose would need a `restates` check and one of the two fixed.
- **anomaly.** An anomaly is a rule (code, trigger, severity, keep-shape) in the anomaly layer, plus one field no other rule has: whether its keep-shape is a forward-stable promise (12 Q1 B makes it one).

**What the kinds rest on, honestly:**

- RC1's admission rule.
- The prior spec suites' actual sections.
- One mechanical check: every pre-design question number lands in some outline row. I ran it with a script. The only two numbers that don't (67 and 70) are reports, not questions.

Nothing else was sampled. The influx history files look like *reports* in RC1's sense (append-only accounts), which the kinds don't need to name while they stay in influx.

## Records and fields

**Everything is Markdown for now**, with YAML frontmatter (decisions are sections in one file). Writing lite's own records in udon while lite is undecided would make every open qu __limen_click(84, 313)
estion a parse question in our own files. Moving records to udon is spec-lite 0.1.1's job, once a lite parser exists. To keep that move cheap, field names are chosen to be spellable in lite: bare words, no `!`, no `@`.

| Field | On | Meaning |
|---|---|---|
| `kind` | all | as above |
| `layer` | rule | `source` · `element` · `value` · `text` · `reserved` · `anomaly` · `tree` |
| `state` | all | process flags (`proposed`, `drafted`, later `checked`, …). Resettable, never a ladder |
| `per` | objective, rule, fixture | keys of the `DECISIONS.md` entries it rests on |
| `questions` | all | pre-design numbers still open against it |
| `depends` | all | records whose *text* it uses (another rule, a def) |
| `fixtures` | rule | path to its fixture file (a pointer, not a count) |
| `narrates` | explanation | the records it describes; any change to one marks the explanation stale |
| `max` | all | `decided` for objectives, principles, rules, and definitions; `exact` or `conditional` for properties |

**Deliberately no hand-set strength field.** A rule's standing is computed from things that happened: its decision entry, its fixtures, and whether a parser run agreed. Until vsect exists, nobody types a status word that could lie. A `DECISIONS.md` entry records what was decided; it is not a status on the rule. [This may need to be added as a manual shorthand in the outline(s); this clause and the field itself, if there is one, are not meant to be taken as  dogma  -- Joseph 9/30]

**RFC 2119.** Capitalized MUST, SHOULD, and MAY appear only in a rule's or objective's *Statement* section. Explanation prose never uses them, so a reader can tell normative text from teaching by its words alone.

**Cadence of a rule file:**

1. frontmatter;
2. title and a one-line italic summary;
3. Statement (numbered clauses);
4. Open parts, not decided here;
5. Grounds (decisions, history pointers);
6. Epistemic status (what is checked, what isn't);
7. an optional Explanation section marked as teaching;
8. Working Notes.

`src/rule-implied-root.md` is the worked sample.

**Working notes, everywhere.** Every record of every kind ends with a *Working notes* section: rules, objectives, principles, properties, definitions, explanations, each decision entry in `DECISIONS.md`, and the outline itself. Fixtures carry a `notes:` field per case, plus a notes comment at the top of each file. The section may be empty, but it is always present, so there is always a sanctioned place for a truthful partial position (a hunch, an unverified lean, "I haven't checked X"). Otherwise that position gets silently dropped or pushed into the body as if it were settled. Working notes hold forward work: open threads, cautions, regression guards, dead ends worth not re-walking. What happened and when goes to `CHANGELOG.md`.

**Reasoning and assumptions in every decision.** Each `DECISIONS.md` entry has required *Reasoning* and *Assumptions* sections. A decision is only as reopenable as its recorded grounds. An assumption that stops holding is the cleanest reopen trigger there is, and it only works if the assumption was written down at the time. Where the source records none, the section says *not recorded*, and never carries a reason reconstructed afterwards. Assumptions an agent infers are marked *inferred, unconfirmed* until Joseph confirms them. In the seed, most Reasoning sections say *not recorded*, because the README recorded little. That emptiness is itself the finding: those are the questions to ask him when each decision is next touched.

## Fixtures

Samples are in `fixtures/rule-implied-root.yaml`; the field key is at the top of that file. Profiles:

- **canonical:** normative; gates conformance.
- **idiomatic:** normative, and written to teach; typical usage lives here.
- **counter:** normative, and shows a misguided or surprising spelling. It adds `expects` (what a reader plausibly thinks it means) beside the actual `tree`. This is where "examples of misguided usage" go, and it pairs with `expl-common-mistakes`.
- **descriptive:** never gates. It carries `readings`, one tree per open alternative, keyed to the question and option. When a question closes, the matching reading is promoted to the tree, the case becomes canonical, and the flip cites the decision.

Two things are still waiting on questions:

- **The tree notation.** Fixtures use the pre-design text notation for now. A machine transcript (86 option B) would let parsers in several languages be compared byte for byte, and would make fixtures the compliance definition, as 0.10.0 §1 intended.
- **The era.** Once a parser exists, a fixture's agreement is recorded against the parser version.

Live documents are a ready regression corpus: the census in 67 lists six real UDON documents that can be run through a lite parser as idiomatic cases.

## Layout

```text
spec-lite-0.1.0/
  spec.outline.md            canon view: rows mirror frontmatter
  proposed-verisectorium.md  this file (retires into the SOP store once decided)
  DECISIONS.md               decision ledger (seed, proposed)
  def/                       term-groups (markdown); LEXICON.md generated from them later
  src/                       obj-* prin-* rule-* prop-* expl-*
  fixtures/                  one YAML file per rule (or per cluster of rules)
  influx/                    unchanged: README, reserved, scratch-jaw, pre-design/
```

`fixtures/` is a separate directory because its format and consumer differ (data for a parser harness, not prose for readers), not because fixtures are a kind. Everything else is organized by topic in the outline.

**From the template, adopt when earned:**

- `CHANGELOG.md` (the history layer; worth creating at the first commit);
- `PRACTICA.ud`;
- a short `CLAUDE.md` front door once a second session works here.

The existing `influx/README.md` is currently the front door and can stay one until then.

## Lifecycle of one question

1. A pre-design file poses it neutrally, and a history agent writes its history (both exist).
2. Joseph's leans are recorded verbatim (STEWARD).
3. When he decides, a `DECISIONS.md` entry records *Quote* (verbatim, when located) separately from *Holds* (the narrowest reading), with *Wording* saying which one *Holds* is in, plus *Reasoning* and *Assumptions* as he gave them.
4. Rule text is written or amended, citing `per:`. Descriptive fixtures flip to canonical. Any property touched is re-checked by someone other than the rule's author.
5. The question file leaves influx only when the delete-test passes: all of its alternatives, examples, and history are landed in rules, fixtures, and decisions, or consciously set down.

## What vsect wants from lite

The pipeline is spec-lite → lite parser → vsect → aat-refactored, and later spec-lite 0.1.1 written *in* lite and managed *by* vsect. That makes this corpus lite's first real customer, and it has opinions. Each is traced to its pre-design question; all are my reading, for you to weigh.

1. **Fences must be robust.** The spec corpus is full of udon examples, including reserved syntax (`!if`, `@{…}`) in fixtures and explanations. Once the spec is written in lite, those examples can only live in fences, because `!:kind:` is reserved (11) and `<…>` closes at the first `>` (07; audit 2026-09-01). Fence content must never be scanned for reserved syntax, and a fence has to be able to hold a fence (11 Q3). This is the most binding requirement I found.
2. **Status has no spelling in lite, which is right.** The RC1 udon spike (`firmatum/verisectorium/theory/influx/segments-model-rc1/lang/rc1-in-udon.ud`) made each status cell a `!` generator. Lite reserves `!`, so under lite, projections live only in vsect's output and never in files. That lands exactly where RC1 wants it: hand-set status is inexpressible. Nothing is lost; the spike's spelling waits for full UDON.
3. **Edges are plain names.** `@record[x]` is reserved, so edges are written `:supports [rule-nesting]` and vsect resolves them (designators by convention). Upgrading them to `@` later is a migration, and the forward contract guarantees the lite spelling keeps meaning what it meant.
4. **Source spans in the tree** (60, 13, STEWARD "layers of the tree"). vsect's `revise` has to tell which named spans changed and rewrite only those. It needs line, column, and span on every node, as `meta`, even if round-trip of ornament stays optional. This is a concrete vote for "content + meta" being specified, not optional.
5. **Append-safety** (68). Decision ledgers, event trails, and question logs are appended by agents without reading. vsect wants 68 option A, or at least B: a well-formed top-level block appended at EOF never changes what came before.
6. **Duplicate keys surface, never merge** (54). Two records with one slug is a collision, the references def store's `collide`. vsect needs both elements kept and the duplicate visible; last-wins would hide exactly the failure it has to report.
7. **First-line greppability** (68). `grep '^|decision\['` should find every record with its identity and key attributes. That argues for keeping `[key]` plus same-line attributes simple and stable (77, 74).
8. **`@` inside ordinary values** (09 Q1). Era keys like `parser@0.10.01` and email-like strings put `@` mid-token. Lite needs to say plainly whether that is reserved. vsect can avoid it (`parser-0.10.01`), but a lite rule that is quiet about it costs every author a guess.
9. **Stacked vs list** (65, 83, K15). `:depends a :depends b` and `:depends [a b]`: vsect doesn't care which, only that the tree says whether they are the same.

## What needs you

- **Adopt, change, or discard this model?** In particular: the nine kinds; no hand-set strength field; `DECISIONS.md` as the decision ledger, with its entries seeded from the README's "Decided so far" (all marked as renderings).
- **The proposed closers** in the outline's Open questions table. I marked most of 01–13 steward-purpose and most of 50–91 agent-open. That is a routing proposal, not a routing.
- **Lexicon location.** The README says lite's terms go in `lexicon.md`. The directory you set up on 09-30 has `def/`. I followed `def/` with a generated LEXICON, like references. If you meant a single `lexicon.md`, the two sample entries fold into it unchanged.
- **Fence requirements** (vsect item 1) as input to 11, and **spans in the tree** (item 4) as input to 60 and 13.

## Coverage, honestly

**Read whole:**

- `influx/README.md`, `reserved.md`, `scratch-jaw.md`;
- `pre-design/README.md`, `STEWARD-2026-09-29.md`, `70-survey-index.md`;
- pre-design neutral files 01, 04, 06, 07, 09, 11, 12, 13, 54, 60, 68, 84, 86, and the top of 67;
- `v2/WHERE-THINGS-STAND-2026-09-27.md`;
- all seven `references/def/*.ud`, plus references' CLAUDE, DECISIONS, PRACTICA, and outline;
- the `spec-0.10.01` README and fixtures README;
- `v2/theory/FORMAT.md` §3–4 and two of its `src/` segments;
- the K-row provenance note and rows K9–K14 of `v2/DECISIONS.md`.

In the parent session: all of RC1, the verisectorium template, and the live_docs comparison.

**Read in part:**

- the section headings of `spec-0.10.00/CORE.md` and `spec-0.10.01/CORE.md`, and 0.10.0 §0–1.1;
- the first case of the 0.10.1 fixtures;
- the headings and method section of discussion files 01, 09, and 13.

**Not read:** the remaining ~50 pre-design files (titles only, via the survey index), every other discussion file, and `JOSEPH-FOR-0.10.01-FIX.md`. The outline's Statement column for those rows comes from their titles and the survey index. That was enough for a skeleton, per your note that the influx did not need reading whole, but not for writing their rules.
