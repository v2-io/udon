# Doc-store-as-database, schemas, and versioning — a source review

**What this is.** A deep, provenance-rich review of where the *documents-as-records
/ directories-as-tables / schema-and-versioning* thinking already lives across
Joseph's estate — commissioned as intake for (a) the UDON v2 paths/schema ideation
(`../paths-ideation/`) and (b) the agentic-tooling corpus (`../../udon-needs/`), for
onward folding into the harness/agentic-tooling program. Every claim and snippet
carries a `path:line` footnote so a downstream agent can lift it with the receipts.

**Scope note (per the brief).** All tooling topics were on the table, not only
path/schema-related material. The disposition was *deep, not broad* (the inverse of
the wide notation survey): preserve primary material, quote verbatim where it earns
it, follow the versioning nuance whole. **This revision is written to stand alone
away from the sources** — load-bearing material is reproduced verbatim rather than
paraphrased, because the downstream consumer will not have the trees to hand.

---

## Revision note — what changed in pass 2, and why

Pass 1 built its spine largely from *documentation*, and largely from documents whose
**successors it never read**. Pass 2 went to `git log`, to the successor documents, and
to the implementations. A consumer already relying on the pass-1 text should read this
list first; each item **replaces** a prior claim rather than qualifying it.

| # | Pass-1 claim | Status | What is actually true |
|---|---|---|---|
| C1 | autopax **ADR-008** cited as live design for versioned document schemas (5 footnotes) | **Wrong source** | ADR-008 carries a banner: *"CAUTION : DO NOT USE … being replaced by the conformant version"*[^adr008-donotuse]. Seven ADRs carry that banner. The live text is `migration-proposals/008-yaml-and-schemas.md`. |
| C2 | ADR-008's versioned-document DSL, schema bundles, bump-validation presented as the design of record | **Superseded** | ADR-008 carries a *Scope Reduction* (2025-12-15): ADR-012 moves schema versioning, validation and migration **out** of 008 into Archema; 008 retains only YAML conventions, psych-pure normalization, and the `_schema` convention[^adr008-scopereduction]. |
| C3 | "autopax … **pivoted** to adopt Archema" | **Pass-1 right, pass-2's first correction wrong** | Pass 2 initially "corrected" this to *overstated*, citing ADR-012's `status: DRAFT` and its unchecked `[ ] Add Archema dependency`. **Both signals were bad.** The status field was stale (steward, 2026-07-23) — ADR-012 still reads `status: DRAFT`, `deciders: [Joseph]`[^adr012-frontmatter], and the ADR's checklist is a template copy — progress lives in **OPERATA**, exactly as the ADR README says[^adrreadme-notprogress]. `autopax-OPERATA.md` records Archema Phases 0/1/2 **DONE** (2025-12-15/16/17), the dependency added, 659→613→625 tests passing, and `Agent::Card` deleted[^operata-archema]. The pivot landed. What it did *not* do is finish — see §1.4. |
| C4 | Schema history is `.archema/schema_history/<resource>/vX.Y.Z.yaml`, one file per version | **Wrong** | That is what `docs/usr/10` claims[^evo-history-doc]. The shipped code writes **one file per resource** containing all evolutions: `.archema/schema_history/<name>.yaml`[^history-path-code]. |
| C5 | The yaml_frontmatter store DSL is `store :yaml_frontmatter, path: ->(card) { … }` | **Wrong** | That was the ADR-012 *sketch*. The shipped adapter takes `directory:`, `extension:`, `body_attribute:`, `filename_attribute:`, `schema_field:`, `cache:` — there is no `path:` lambda[^yamlfm-init]. |
| C6 | `_schema` is *the* self-describing field | **Incomplete** | `yaml_frontmatter` defaults to `:_schema`[^yamlfm-schemafield]; `jsonl` defaults to `:_schema_version`[^jsonl-schemafield]. Two stores in one framework disagree on the name. |
| C7 | relata is "an **independent** sibling realization" | **Wrong lineage** | relata is the fourth generation of a *documented* descent: `neurips/refs` (2026-05-05) → `asf/terminology` (2026-05-08, which cites refs explicitly) → `logos/refs` (2026-05-09, which carries an adaptation-provenance note) → relata (2026-05-13). See §1.2. |
| C8 | §6 "what this means for paths" written without the estate's path work | **Major gap** | rowan has ADR-002 (dig-style filter paths) and a 1,624-line `path-centric-query-dsl.md`; relata has `designator.rb` with a Kripke rigid-designator model. All three are now §8–9. |
| C9 | "Archema *asks* rather than guessing" rename-vs-remove | **True but vaguer than the code** | The heuristic is narrow and honest: *"if exactly one column removed and one added with same type"*[^differ-heuristic]. Outside that shape there is no candidate to ask about. |
| C10 | relata's §5 "never mutate the source file" quoted as a standing invariant | **Amended by its own successor** | §11.17 (2026-07-10) explicitly amends it; the surviving core is *"never mutate or remove a source before its bytes are durably, verifiably in the corpus"*[^relata-1117-disposition]. |
| C11 | relata's blob storage described as an 8 MB threshold with size × recoverability routing into `committed`/`local-cas`/`lfs` | **I cited a disavowed framework** | That text is `TODO-ingest.md` §11 item 1, and it is **dead**. Joseph disavowed it 2026-05-19 — *"I didn't write them, but it sounds like someone took liberties … relata doesn't have a directive to give the documents redundancy or resiliency"*[^relata-disavowal]. §11 #10 calls the original *"a hallucinated invariant dressed as principle"*[^relata-1110]. The live decision is §11 #13 + the rewritten §7.9: **no tiers, no size rule, no redundancy directive** — one external, configurable PDF tree, `move never delete`, joined to the record by `hash`[^relata-79-current]. §11 #1 was never updated; the excision pass is owed and tracked. See §4.3 (rewritten) and §1.5. |
| C12 | *(method, not content)* Supersession treated as a document-level phenomenon | **Too narrow** | It happens at **three scales**, each with a different detection signal, and pass 1 + pass 2 each fell into a different one. See §1.5. |
| C13 | *(pass 2's own overclaim)* "A field the system refuses to gate on is a field a reader shouldn't treat as evidence" | **A universal drawn from one deployment** | ASF's warnings-only choice is deployment-specific. The same store family **gates hard** in `~/src/arch/logos/`, where `bin/refs lint` is *"the anonymization gate before submission"*[^logos-gate] — because submission is irreversible and polish level is not. **Gate-or-warn tracks the consuming deployment's stakes × reversibility, not the field or the schema** (steward, 2026-07-23). Corrected in §12.2; §1.5's rule 3 narrowed to the inference that is actually safe. |

Additions with no pass-1 counterpart (not corrections, but the bulk of the new value):
the lineage picture (§1) and its forward continuation past autopax (§1.4), the
three-scales-of-supersession result (§1.5), the sqlite-vs-documents trade study argued
twice independently (§3), FRBR work/expression/item (§4), designators and the
resolution ladder (§8), the path-centric-vs-set-centric theory (§9), the empirical
layers — a 23-repo migration survey, 20+ agent hallway-testing challenges, and a
distinct 21-scenario simulation corpus (§10), the ADR system as itself a doc-store with
a lifecycle (§11), OUTLINE+segments read whole (§12.2), markdown *structural* schemas
(§12.3), resource-to-agent-tool export (§13), an implementation-reality ledger (§14),
the OPERATA intent-management lineage (§16), and relata's evidence model — record the
vector, not the verdict (§17).

*Pass 2 (2026-07-23) added §1.4, §1.5, §12.2 (replacing a stub), §16, §17, the
simulation/hallway distinction in §10.4, and corrections C3, C11, C12. Sections §16–17
of pass 1 are now §18–19. Pass 3 (same day) closed the CHRONICA question inside §1.4,
corrected §12.2's gating overclaim against the `logos/` counter-case (C13), extended the
descent to four generations, and carried two artifacts the text had been leaning on (the
projected-constraint table in §5, the emitted tool definition in §13).*

---

## 0. The one-paragraph thesis

A *document is a record*; a *directory of documents is a table*; a *resource
definition is the schema*; and the *store* is a pluggable projection of that schema
onto a substrate (a directory of YAML files, an append-only JSONL log, a SQL table,
or memory). Once that frame is taken seriously, three hard problems become
first-class rather than ad-hoc: **schema** (what a record must be), **versioning**
(how the schema and the data evolve without a flag-day), and **addressing** (naming a
record, distinguishing the record from the resource it points at, and joining records
across directories). The estate has converged on this from two distinct directions,
and the *versioning* half — which looks schema-flavored — turns out to be
inseparable from the *addressing* half, because an address that outlives a schema
change is exactly what `was:`-style read-time translation, key aliases, and
content-versioned records are for.

---

## 1. Two lineages, not four directions

Pass 1 described "four independent directions." The sources say something sharper and
more useful: **two lineages, five months apart, arriving at the same shape from
opposite ends** — and within each lineage the descent is documented, while *between*
them there is no cross-reference at all.

### 1.1 The framework-first lineage: autopax → Archema/rowan

**autopax** (first commit 2025-11-15) is ELI infrastructure: agent cards, SIGNUM
identity files, CHRONICA entries, capability manifests. Each document type was
implemented ad-hoc — `Agent::Card` a hand-rolled YAML loader with manual validation,
`Chronica::Entry` an immutable class with manual serialization, `Chronica::Log` a
JSONL append with manual integrity checking. ADR-012 names the result an
**architectural knot**[^adr012-knot]:

> Currently, each document type is implemented ad-hoc: … This has created an
> **architectural knot** visible in OPERATA: **ADR-008** (YAML schemas) is DRAFT,
> blocking other ADRs; **ADR-006 Phase 4** (agent card integration) is blocked on
> ADR-008; **ADR-010** (markdown validation) is blocked on ADR-008. Schema
> validation, versioning, and migration are unsolved.

The proposed exit was to adopt **Archema** — an Ash-framework port for Ruby that had
matured in a sibling repo — as the unified resource layer. **Archema is now `rowan`**
(directory renamed; module internals still say `Archema`). rowan is where the pattern
was generalized and hardened: 264 commits, a 27k-line `lib/`, four store adapters, a
schema-evolution engine, a migration generator, and a simulation/usability test corpus.

**Liveness matters here and pass 1 gave none.** autopax's last substantive commit is
2025-12-20; everything after is documentation touch-ups into 2026-04. The Archema
dependency was never added — ADR-012's own task list still has `[ ] Add Archema
dependency`[^adr012-tasklist] unchecked. So: autopax *posed* the demand and *sketched*
the answer; rowan *is* the answer, and the flow-back to autopax never happened.

### 1.2 The filesystem-first lineage: neurips/refs → asf/terminology → relata

This lineage pass 1 missed entirely, and it is the one closest to UDON's altitude,
because it never had a framework — it started from *files agents write* and added
exactly as much database as the data model needed.

| Date | Repo | What landed |
|---|---|---|
| 2026-05-05 | `~/src/neurips/refs/` | *"bin/refs + refs/ tree — **sqlite-free bibliography database**"*[^refs-firstcommit] |
| 2026-05-06 | `~/src/neurips/refs/` | `safe_write` (temp-file + fsync + rename); the sqlite-vs-YAML trade study written down[^refs-tradestudy-commit] |
| 2026-05-08 | `~/src/arch/asf/terminology/` | `bin/term` per-entry store — *"modelled on the `~/src/neurips/refs/` pattern"*[^term-descent] |
| 2026-05-09 | `~/src/arch/logos/refs/` | Same store, adapted for journal submission — layout, atomicity contract and CLI verbs *"transfer verbatim"*; the build pipeline does not[^logos-provenance] |
| 2026-05-13 | `~/src/relata/` | *"Initialize relata: cross-project bibliography source-of-truth"*[^relata-firstcommit] |

Eight days, four realizations. The descent is explicit: asf/terminology **cites**
neurips/refs as its model, and both READMEs carry the *same* trade-study table with
the *same* rows and the *same* `safe_write` contract described in the same four
numbered steps. relata inherits the whole shape (per-entry YAML keyed by filename,
append-only event directories, `safe_write`, a generated `.bib` view) and then goes
much further (§5, §8).

### 1.3 What the two lineages do and do not tell us

They agree on almost everything — records-as-files, key-as-filename, append-only
event trails beside the canonical records, generated views, schema versioning. It is
tempting to read that as convergent validation. **It is not corroboration; it is
coherence.** There is *zero* cross-reference between them: nothing in relata, asf's
terminology, or neurips/refs mentions archema or rowan, and nothing in rowan's
`docs/dev`, `docs/exp` or `lib` mentions relata, neurips, or terminology. One author
wrote both. Their agreement means the design intent is stable across five months and
two very different starting problems — which is genuinely worth something — but it is
not independent evidence that the shape is right.

The one place they *do* differ is the interesting part, and it is a real fork:

| | Framework-first (rowan) | Filesystem-first (refs/terminology/relata) |
|---|---|---|
| Where schema lives | a Ruby `Resource` class; the store is a projection | frontmatter fields + a `schema_errors` method + a linter |
| Storage-agnosticism | the point of the design | explicitly not wanted — the filesystem *is* the model |
| Query | a query builder with filters, sorts, preloads, paths | `glob` + `select` in Ruby, ~2k entries, "fine at this scale" |
| Versioning | `was:`/`upcast`/history/differ/migration-generator | none — the corpus is small and git is the history |
| Multi-store | four adapters, roles, modes, compositions | one store; blobs deliberately elsewhere |
| Failure posture | validate on write, everywhere | **permissive extractor / strict linter** (§12.2) |

rowan asks "what if a document store were a real database?"; the refs/relata line
asks "how little database can we get away with, and what must be hardened when we
do?" For UDON both answers are relevant, but the second is closer to the demand.

### 1.4 The forward continuation — where the graft actually broke

Pass 1 stopped the story at "autopax proposed Archema." Pass 2's first attempt stopped
it at "and never accepted it." Both stopped too early. The OPERATA ledger plus the
commit record give the real shape, and it is the most useful design evidence in this
review, because it is a **natural experiment in retrofitting a resource layer into a
working system.**

What landed, from the ledger[^operata-archema]:

| Phase | Date | What | Result |
|---|---|---|---|
| 0 | 2025-12-15 | Catalog pilot — `Model` resource, Memory store | 659 tests passing; "Archema DSL validated" |
| 1 | 2025-12-16 | Substrate registry — SQLite persistence, enrichment, CLI | 535 substrates, 613 tests; **"Dissolved old Catalog code entirely"** |
| 2 | 2025-12-17 | Agent cards — YAML Frontmatter store, registry + path modes | 42 AgentCard tests, 625 total; **old `Agent::Card` removed** |
| 3 | — | **CHRONICA and TRACTUS as resources** | never started |

Phase 3's three unchecked items are: *"Define ChronicaEntry resource with JSONL store · Define Tractus resource (or integrate with existing audit trail) · **Verify BLAKE3 hash chain compatibility**"*[^operata-phase3]. To this day `lib/autopax/chronica/` contains **zero** references to Archema — it remains the hand-rolled append-only JSONL with its own hash chain.

And the commit record says what happened next. On 2025-12-17, immediately after Phase 2, a **new** subsystem (`Curatoria`) was added — hand-rolled, not as a resource. From 2025-12-17 to 2025-12-20 the entire remaining effort — roughly a hundred commits — goes into `Pinax`, a terminal-UI library: regions, renderers, screen buffers, scroll regions, differential rendering. Then the repo stops[^autopax-pinax-run].

**The pattern is legible, and it is the finding.** The retrofit succeeded exactly where the subsystem was **greenfield** (the substrate registry — a brand-new capability) or **trivially replaceable** (agent cards — a YAML loader with four fields). It was never attempted on the subsystem that was already working *and* carried invariants the framework did not model: an append-only log with a BLAKE3 hash chain, where the framework's own JSONL adapter has a *different* hash-chain implementation, a different schema-field name (§C6), and its own tombstone semantics. The literal blocking task is "verify hash chain compatibility."

> **The generalizable claim:** a resource/schema layer retrofits cheaply into subsystems that are new or thin, and stalls at subsystems that already work and hold integrity invariants of their own. Those are also, invariably, the subsystems worth having in the framework — so the cheap wins are the ones you needed least. Anyone proposing to unify an existing document estate under a schema layer should sequence the *hardest, most invariant-bearing* subsystem first, because it is the one that decides whether the unification is real.

**What happened to the blocking invariant — the lesson completed.** The obvious question
is whether the successor work resolved "verify BLAKE3 hash chain compatibility", worked
around it, or dropped it. It did **none of the three**, and the fourth outcome is the
interesting one: *the invariant-bearing subsystem became the specification, and the
framework was discarded.*

`CHRONICA-PORT-SPEC.md` (2026-07-20) opens its implementation survey with autopax's
hand-rolled log — *"Autopax `Chronica::{Log,Entry}` — **highest-ROI integrity port**.
~840 LOC Ruby, **verified by reading**"* — and enumerates its design as the thing to
carry forward: *"JSONL append-only; BLAKE3 over canonical sorted JSON; `hash_prev` chain;
genesis sentinel `0*64`. **Verify-on-load:** entry hash + chain links → `IntegrityError`
(critical). Frozen entries; two-phase create → `with_hash`. Reserved: `signature`,
`anchor`."*[^chronica-autopax] The port-vs-invent table then makes it explicit — *"Hash +
canonical JSON + verify-on-load: **Port** (Autopax Chronica)"*, everything else
invent[^chronica-portinvent] — and the closing thesis is *"port Autopax's BLAKE3
append-only verify-on-load; invent sealed writing, PERCEPTA/ACTUS provenance, and
TRACTUS≠CHRONICA so compaction cannot gaslight."*[^chronica-thesis] The target is an
independent Rust spine; Archema is not in the picture at all.

Two details sharpen this. First, the spec's honest assessment of what autopax's chronica
*is*: *"a **valid integrity substrate** with a **thin event model** — excellent for
invent integrity / port storage; **not** a complete identity-sufficiency
log"*[^chronica-autopax]. The part that resisted the graft is the part judged worth
keeping; the part that was thin is the part being re-invented. Second, the timing:
autopax's richer event schema was *"**paused** 2025-12-14"*[^chronica-autopax] — **the day
before Archema Phase 0 began**. The deliberation about what CHRONICA entries should
*contain* was suspended exactly as the effort to change where they are *stored* started,
and it never resumed.

So the §1.4 lesson gets a cleaner ending than "the graft stalled":

> The subsystem that would not retrofit was not deficient — it was the one carrying the
> design worth preserving. Seven months later it is cited as verified-by-reading source
> material for a from-scratch spine in another language. **A schema layer that cannot
> absorb your integrity-critical subsystem has not found a hard case; it has found the
> case that will outlive it.** The corollary for sequencing stands and gets sharper: try
> the hardest subsystem first, because the outcome is diagnostic either way — absorbed,
> the unification is real; refused, you have located what the framework must be built
> *around* rather than *over*.

The port-spec also models a discipline worth naming for its own sake. It carries a
*Correction note* explaining that its own first draft was wrong because of partial
reading — *"Partial reads of `#def-chronica` + Autopax Log produced a competent but
**too-narrow** first draft: 'hash-chain append-only verify-on-load' … Full segments force
additional structure that a plan which skips them will fake fluency
about"*[^chronica-correction] — with a table of what was missed and which segments would
have caught it. And it states an **epistemic posture** up front, per source: *"AAT claims
are taken from named segments at their stated tiers. Autopax Ruby is **verified by
reading sources**. Schema richness for tool blocks was **paused for deliberation** in
Autopax — **not treated as decided**."*[^chronica-posture] Three source classes, three
different warrants, declared before any claim. That is the practice this review's own §1.5
is about.

Its acceptance criteria are equally quotable as document-store invariants: *"TRACTUS as
**separate** store; compaction may rewrite CONSPECTUS projection, **never** CHRONICA"*;
*"single-writer; fork = new genesis / explicit sibling, **never silent
dual-write**"*; *"Ordinal honesty: timestamps metadata; **no fabricated filler for
sleep**."*[^chronica-mvp] And an explicit non-claims list sits beside them — including
that replaying the log *"reconstitutes a **prefix record**"*, not the entity[^chronica-nonclaims].

Joseph's own account (steward, 2026-07-23) is that this difficulty — *"grafting archema in after the fact was becoming difficult"* — is what generated successor projects: **nexum**, **firmatum**, and **shoshin**, with *"firmatum in particular … just starting to get ready to be set up as autopax's successor, to incorporate everything from all the harnesses that had come before,"* before Joseph himself pivoted to ASF.

The repository dates refine that, and Joseph flagged his own uncertainty (*"he thinks"*), so this is offered as evidence rather than contradiction:

| Project | First commit | Last commit | Position |
|---|---|---|---|
| nexum | **2025-11-06** | 2025-12-14 | **Predates autopax by nine days** |
| autopax | 2025-11-15 | 2025-12-20 (substantive) | — |
| firmatum | 2026-02-23 | 2026-03-02 | Post-stall successor |
| shoshin | 2026-03-07 | 2026-03-07 | Post-stall successor |

So **firmatum and shoshin sit where Joseph places them** — after the autopax stall, as the intended successors. **nexum does not**: it began nine days *before* autopax and belongs to the harness lineage that preceded both, which is where an independent 2026-07-20 survey also places it — *"Nexum ~2025-11: Disciplined Ruby rewrite of minimal-sapientia (~45% parity claimed). Incomplete; clarifies intended modularization"*[^survey-lineage]. Nexum is a **sibling**, not a consequence.

That survey also reveals a **third lineage** neither pass had seen, which is the parent of autopax rather than a peer of it[^survey-lineage]:

> | Era | Name | What ran for ELIs |
> |---|---|---|
> | 2025-09 | Synaptic | Activation/phenomenology experiments; naming crystallizes. |
> | 2025-09+ | Sapientia (Elixir) | OTP skeleton / ASM aspirations. **Not** the live ELI interface. |
> | ~2025-09 → late 2025 | **minimal-sapientia** | **Only fully functional harness used with real ELIs.** ~4491-line Ruby monolith. |
> | ~2025-10 | Zoetica | Elixir umbrella successor: tracking-snapshot **spec**, PRAXES, ethics. Partial. |
> | ~2025-10–11 | Ennaos | Successor to Zoetica; PRINCIPIA/ANIMA taxonomy in code; event log + multi-provider. |
> | ~2025-11 | Nexum | Disciplined Ruby rewrite of minimal-sapientia. Incomplete. |
>
> **Lived truth:** entity markdown + **minimal-sapientia** carried the hours. Elixir stacks codified taxonomy and integrity; they did not displace the Ruby REPL for most of the recorded cohort.

The line worth carrying out of that table is *"Elixir stacks codified taxonomy and integrity; they did not displace the Ruby REPL."* Four successive re-architectures produced better *specifications* of the document model and never displaced the working monolith. That is the same shape as the Archema graft, one level up: the principled layer is easy to specify and expensive to substitute for something that already works.

And the story continues to the present. The whole lineage was gathered in July 2026 into `~/src/arch/harness/` — an explicitly labeled **workshop**, whose own status note reads: *"Harness work (autopax, nexum, sapientia OPERATA, shoshin) largely stalled once ASF took legs — thankfully, so the math could solidify first. It is now time for harness + training/algorithm legs of Archema again; this tree is the **intake substrate**, not the finished design."*[^proprium-index-status]

Its layout is itself a doc-store finding, because it assigns **authority by directory**[^proprium-layout]:

```
proprium/
  canonical/          # authoritative PROPRIUM v2 (firmatum, Mar 2026)
  archaeology/        # pre-split PROPRIUM.md + v1 ontology/architecture (Feb 2026)
  bridges/            # AAT/shoshin mappings (thin; needs rework)
  stalled-lineage/    # autopax / sapientia / nexum / shoshin plans that froze
```

Four directories, four *epistemic statuses* — authoritative, history-only, known-stale,
frozen — with the status carried by **location** rather than by a field. Compare §1.5:
a directory name cannot go stale the way a `status:` field can, because moving a file is
the only way to change it, and moving a file is visible in `git log --raw`. The tree also
states its copy semantics up front — *"Copies, not live links — upstream trees remain
authoritative until a deliberate rework lands"* — and closes with an explicit
*"What was **not** copied"* list[^proprium-notcopied]. A derived collection that names its
own exclusions is answering the question a reader would otherwise have to answer by
searching.

### 1.5 Three scales of supersession — the method result

This corpus supersedes itself at three scales. Each has a different detection signal,
and **each of this review's two passes fell into a different one**, which is why the
generalization is worth more than any individual correction.

| Scale | Example | Detection signal | Failure mode |
|---|---|---|---|
| **Across documents** | ADR-008 replaced by `migration-proposals/008` | A banner in the body; `superseded_by:` in frontmatter | Reading a directory listing as a query result (C1) |
| **Across stores** | ADR-012's checklist vs `autopax-OPERATA.md` | *None local to either file* — you must know the record/event split exists | Reading progress from the decision store (C3) |
| **Within one document** | `TODO-ingest.md` §11 #1 vs §7.9 / §11 #10 / §11 #13 | *None* — only a later section contradicting an earlier one | Citing an early section of a long ledger (C11) |

The signal weakens monotonically as the scale tightens, and the third case is the worst:
a 4,826-line append-mostly decisions log where §11 item 1 still asserts a framework that
§11 item 10 calls *"a hallucinated invariant dressed as principle"* and §11 item 13 says
*"do not resurrect"* — with the document itself acknowledging the debt: *"§7.9's text
still sits in the doc; flagged here rather than excised this cycle — an excision pass is
owed"*[^relata-disavowal]. Nothing at the citation site warns you. I read §11 #1, quoted
it approvingly, and did not read §7.9 until this pass.

Three practical rules follow, and they are cheap:

1. **Grep the whole file for the topic before citing any section of a long ledger.** In this case `grep -n "storage\|blob"` would have surfaced the disavowal immediately.
2. **Know which store answers which question.** "Is it decided?" and "is it built?" are different stores in this estate by explicit design (§11); asking the wrong one returns a confident wrong answer with no error.
3. **Weight metadata fields *below* substance and descent — but read a non-gating check as evidence about the deployment, not about the field.** A banner is written to be seen; a `status:` field is written once and rots. ASF states its own version as policy: stage consistency is checked *"as warnings only, never gate failures"* because *"the stage layer is known to go stale quickly"*[^format-stage-stale]. The safe inference is narrow — *ASF does not rely on this field*, which is exactly why my citing ADR-012's `status:` as dispositive was wrong. The unsafe inference, which an earlier draft of this review made, is that a non-gating field is inherently untrustworthy: the same store family **gates hard** in `logos/`, where the consuming action is irreversible (§12.2). Gate-or-warn tracks the consumer's stakes × reversibility, not the field.

The positive form: **integration-is-replacement is a discipline the estate holds and does
not always execute.** relata states it exactly — §7.9's tiering *"was **excised** rather
than softened … the body states present truth; the disavowal history lives in §11
#13"*[^relata-79-current] — and then leaves the ghost alive three sections away. The gap
between the stated discipline and the executed one is where both passes of this review
went wrong, and it is the single most transferable operational finding here.

---

---

## 2. The core pattern, made concrete

### 2.1 Record = document, key = filename, table = directory

relata is the cleanest crystallization: **"one YAML file = one bib entry. Filename is
the canonical key."**[^entry-thesis] The whole "table" API is filesystem operations,
and this is the real shipped code, not a doc sketch[^entry-api-code]:

```ruby
def self.path_for(key) = Paths::ENTRIES_DIR / "#{key}.yml"

def self.load(key)
  path = path_for(key)
  return nil unless path.exist?
  new(key, YAML.safe_load_file(path, permitted_classes: [Date]))
end

def self.all
  Paths::ENTRIES_DIR.glob("*.yml").sort.filter_map do |p|
    key = p.basename(".yml").to_s
    load(key)
  end
end
```

`SELECT`-by-key is `path_for`; `SELECT *` is `glob("*.yml")`. The directory *is* the
table; the filename *is* the primary key. Note `sort` before `filter_map`: iteration
order is lexicographic-by-key and deterministic, which is what makes the generated
views diff cleanly.

The same identification appears in autopax's shipped resource, where the key is
*semantic* rather than a surrogate[^agentcard-pk]:

```ruby
store :yaml_frontmatter,
      directory:      default_directory,     # ~/.local/share/autopax/agents
      extension:      '.yml',
      body_attribute: :axiomata_content

primary_key :name, :string
```

The agent's **name is the primary key and therefore the filename**. There is no id
column. This is worth holding for UDON: in every filesystem-first instance in the
estate, the primary key is a human-meaningful slug, not a UUID — and the two places
UUIDs appear (rowan's `uuid7`/`uuid8` generators, CHRONICA entries) are precisely the
places where records are *events*, not *named things*.

### 2.2 The store is a projection; the resource is storage-agnostic

rowan's headline: *"A Resource definition is storage-agnostic. The store determines
where records live — PostgreSQL, SQLite, in-memory hash, YAML files, append-only
logs. Same Resource, different persistence."*[^stores-thesis]

Pass 1 described stores as composing on three fixed axes — Role × Mode × Adapter.
That is the *shape*, but ADR-001 is more precise and was revised: a store is an
ordered composition of **entries**, each a five-tuple[^adr001-entry]:

```ruby
StoreEntry = Data.define(
  :role,              # :primary, :event, :projection, :cache, or custom
  :mode,              # :read, :write, :readwrite
  :adapter_or_name,   # StoreAdapter instance or registered name
  :params,            # Additional parameters for Resources to use
  :resolver           # nil (static) or ->(context) { ... } (dynamic)
)
```

> A "simple store" is a composition of one entry. A "profile" is a composition of
> multiple entries. Composition is merging ordered sets, with later entries overriding
> earlier ones on role+mode collision.[^adr001-entry]

Three refinements pass 1 does not have, each of which is a *decision*, not a sketch:

- **Roles are arbitrary symbols, not an enum** (ISSUE-053, resolved 2025-12-17).
  Behavior is inferred from the role *prefix* and is separable from the name:
  `primary*` → `:write_primary`, `cache*` → `:read_cache`, `projection*` →
  `:write_fanout`, `event*` → `:append_events`, anything else → no automatic
  behavior; `behavior:` overrides explicitly[^adr001-roles]. This is why
  `:projection_main` and `:projection_search` can coexist.
- **`:readwrite` is one entry, not sugar for two**, because "a Memory adapter must be
  a single coherent object"; adding a `:read` entry to a role that holds `:readwrite`
  **demotes** the incumbent to `:write` rather than duplicating it, and a subsequent
  explicit `:write` is then an error[^adr001-demotion].
- **Runtime composition mutation was considered and rejected.** Three levels of
  dynamism were identified; Levels 1–2 (dynamic params, dynamic adapter selection)
  are supported, Level 3 (mutating a composition at runtime) is *explicitly out of
  scope* on the grounds that real multi-store scenarios "from simulation testing and
  production usage (autopax) show that Levels 1-2 cover all practical needs"[^adr001-levels].

The store-mapping autopax drew for the *entire* ELI document taxonomy remains the
best "directory-as-database at scale" table in the estate[^adr012-storemap]:

| Component | Storage pattern | Store |
|---|---|---|
| Model Catalog | JSON → SQLite/Memory | sequel or memory |
| SIGNUM / AXIOMATA / OPERATA / Agent Cards | YAML frontmatter + markdown body | yaml_frontmatter |
| CHRONICA | Append-only JSONL with hash chain | jsonl |
| MEMORATA | Compressed JSONL or SQLite | jsonl or sequel |

### 2.3 The record's read path, in the order it actually happens

Pass 1 described `was:` and upcasting abstractly. The shipped `yaml_frontmatter`
adapter fixes an order of operations, and the order is load-bearing[^yamlfm-parse]:

1. split frontmatter at the `---` delimiters; `YAML.safe_load` with
   `permitted_classes: [Time, Date, Symbol]`;
2. symbolize keys;
3. **extract and *delete* the schema field** (`_schema`), keeping the version portion;
4. extract the markdown body into `body_attribute` (if configured);
5. **apply `was:` renames** — old attribute name → new, and only when the new name is
   absent, "to avoid overwriting explicit new-name values"[^yamlfm-renames];
6. **coerce types** against the declared attribute types;
7. **apply upcast blocks** for the stored version, if any[^yamlfm-upcast].

Two consequences worth carrying: the schema identifier is *stripped* on read and
*re-emitted* on write from `resource.full_schema_id`[^yamlfm-serialize] — a document
cannot carry a stale schema id through a round-trip; and renames are applied *before*
coercion, so a `was:` rename that also changes type is handled by the rename first and
the declared type second (the `upcast:` transform exists for the cases where that is
not enough).

One robustness datum that is invisible in the docs: a record whose file fails to parse
is `warn`-ed and dropped from the result set, not raised[^yamlfm-loaderror]. A
corrupted record silently shrinks `all`. For a store where `all` feeds a generated
view, that is a real failure mode.

### 2.4 Records-are-documents is the same thesis the agentic-tooling report carries

This is not new to the tooling corpus — it is `machine-first-documents`' "agents ARE
documents" and the "a tool registry is a directory of documents" capability, seen from
the persistence side. What the doc-store sources *add* is the missing middle the
tooling report never developed: the **table/collection** layer (query, schema,
versioning, joins, write-membrane) over that directory of record-documents.

---

## 3. The trade study: why documents and not sqlite — argued twice, independently

This is the single most reusable artifact found in pass 2, and pass 1 has nothing like
it. Both `neurips/refs` and `asf/terminology` *started from a sqlite sketch*, re-opened
the question, and wrote down why they went the other way. The tables are near-identical;
the neurips one is reproduced verbatim because it is the earlier and the more
adversarial of the two[^refs-tradestudy]:

> ## Design decisions: why per-entry YAML, not sqlite
>
> The original sketch was sqlite. Re-examined 2026-05-06 and re-decided in favor of
> hardened YAML-on-disk. The summary of the trade study:
>
> | Concern | sqlite | per-entry YAML (this design) |
> |---|---|---|
> | Crash-atomicity of single write | WAL (journal-replay) | `safe_write`: temp-file + fsync + `rename(2)` |
> | Concurrent writes to distinct keys | serialized inside one DB connection | filesystem-disjoint; no contention |
> | Concurrent writes to same key | last-writer-wins, contents irrecoverable from history | last-writer-wins at filesystem; previous content recoverable via `git log -p` of the YAML file |
> | Reviewability of audit trail | binary; reviewer needs `sqlite3` CLI to inspect | markdown frontmatter; `cat`, `git blame`, GitHub PR diffs all work |
> | Code-of-Conduct provenance | event rows in a table | one file per event with diffable frontmatter + free-form note |
> | Build-pipeline interface | export step → `<paper-dir>/refs.bib` | export step → `<paper-dir>/refs.bib` (same artifact, same `bin/build` contract) |
> | Backup / restore | one binary file (must be quiesced) | `git` already does this, per-entry granularity |
> | Dependencies | `sqlite3` gem (native build) | stdlib only |
> | Indices / query planning | built-in B-trees | linear scan over 170 files (ms-scale; non-issue at this size) |
> | Multi-step transactions | `BEGIN/COMMIT` | not available; the data model has no operation that needs them |
>
> The decisive points: (i) the verification audit trail is *the* Code-of-Conduct surface
> for citation discipline, and a binary store would make it harder for reviewers —
> internal or post-hoc — to read; (ii) the data model is document-shaped, not relational
> (no joins, no foreign keys, no index-driven queries that aren't trivially fine at 170
> entries scanned linearly); (iii) per-entry `git diff` / `git blame` / GitHub PR review
> of bib edits is genuinely load-bearing in the multi-agent workflow …; (iv) `safe_write`
> closes the only legitimate gap that sqlite-with-WAL would have closed (truncated
> mid-write entries) for free.
>
> What sqlite would have bought that we don't get: ACID multi-step transactions. **The
> data model has no operation that needs them.** `add` is a single write. `verify` is a
> single write to a fresh filename. `emit` is read-only on entries + a single write of
> the per-paper `.bib`. There is no "update entry and append verification event in the
> same transaction" operation, and there's no obvious pressure to introduce one.

The terminology re-derivation adds two rows the bibliography case did not need, and
they are the two that matter most for UDON[^term-tradestudy]:

> | Definition prose with rich formatting | text column (lossy for code blocks, links) | native markdown body — first-class |

and its own decisive-points list closes with: *"(iv) the markdown body for prose
definitions lifts terminology entries from one-line table cells to first-class
explanatory artifacts."*[^term-decisive]

**The generalizable rule.** The doc-store wins when: (a) the write set decomposes into
single-file writes, so no multi-step transaction is needed; (b) review of the *history*
is a first-class product, not a debugging aid; (c) the data is document-shaped — the
prose is part of the record, not a blob hanging off it; and (d) the corpus is small
enough that a linear scan is not a lie. Each of those is a *checkable* condition, which
is what makes this a trade study rather than a preference.

### 3.1 `safe_write` — the durability primitive, stated identically in three places

The whole trade study leans on one primitive, and it is small enough to reproduce in
full[^safewrite-code]:

```ruby
def safe_write(path, content)
  path = Pathname.new(path)
  path.dirname.mkpath
  tmp_name = "#{path.basename}#{TMP_SUFFIX}.#{Process.pid}.#{SecureRandom.hex(4)}"
  tmp      = path.dirname / tmp_name
  begin
    File.open(tmp, File::WRONLY | File::CREAT | File::EXCL, 0o644) do |f|
      f.write(content)
      f.fsync
    end
    File.rename(tmp, path)
  rescue StandardError
    tmp.delete if tmp.exist?
    raise
  end
  path
end
```

The contract, as `asf/terminology` states it[^term-atomicity]:

> A reader concurrent with a writer always sees either the prior content or the new
> content — never a half-written file. A crash between fsync and rename leaves a
> `.tmp.<pid>.<rand>` artifact (harmless; never the destination); `bin/term validate`
> sweeps such artifacts older than 60s.

And the deliberate *non*-guarantee, which is the more interesting half[^refs-nolock]:

> **Concurrent writes to the same key are intentionally not serialized by a lock.**
> Last-writer-wins at the filesystem level. The contents-side question — "which agent's
> DOI value is right?" — isn't solved by a lock anyway; it's a content disagreement that
> needs a human-in-the-loop decision either way. The collision surfaces as a pending
> change in `git status`, which is the right place for the resolution.

Note the tmp-suffix convention is not incidental: the `.tmp.<pid>.<rand>` shape is what
makes the crash-sweep possible, and relata's 60-second staleness floor is reused by the
ingest spool to decide when a dropped file is finished being written[^relata-spool-60s].

---

## 4. Record ⟷ resource ⟷ document — the distinctions that feed *paths* directly

Joseph flagged relata's "real bib-entry record vs the document(s) themselves" as
directly relevant to UDON's `@`-reference/identity questions. Pass 1 got the shape
right and stopped at the surface. The theory underneath is FRBR, and it is worked out
explicitly.

### 4.1 The multi-copy question, and FRBR as a lens rather than a mandate

relata's `TODO-ingest.md` §12 disentangles three phenomena that a naive
"one entry, one PDF" model collapses[^relata-frbr]:

> 1. **Equivalent copies** (his "surrogates") — byte-different, citation-*identical*:
>    re-encoded PDF, extra blank page, grayscale vs color cover. Same content, same
>    pagination, same locators; any is acceptable backing.
> 2. **Provisional / best-available copies** (his "proxies") — knowingly inferior
>    (first-chapter-only, low-fidelity scan, sample) accepted until the ideal is
>    obtainable, with intent to upgrade.
> 3. **Citation-distinct versions** — preprint with different pagination, 1st vs 2nd
>    edition, translation. Citing one for the other's locator is an error.
>
> **Terminology, honestly.** The terms are roughly *inverted* from established usage;
> do not adopt as-is. In archival practice a *surrogate* is a reproduction standing in
> for an original — that is **case 2**, not case 1. "Proxy" is overloaded. The field's
> precise vocabulary is **FRBR**: Work → Expression → Manifestation → Item. Use it as
> the *lens*, not a mandate to build a catalog: a relata **entry = an Expression** (a
> citably-distinct realization); **blobs = Items/Manifestations**.
>
> **The resolving principle.** *A relata entry is the unit of citation. Two files
> belong to the same entry iff a careful reader following a citation to either reaches
> the same content at the same locators.*

The consequences are a small, closed schema change rather than a catalog:

- cases 1–2 → **one entry, a set of items**: singular `pdf:` becomes list `pdfs:`, each
  item carrying its own `hash`/`path`/`coverage`/`source`/`storage`, one flagged
  `canonical: true`; case 2 adds per-item `provisional: true` plus entry-level
  `seeking_better:`. Upgrading means adding the better item and re-pointing `canonical`
  — **never deleting the provisional**, because it records what historical
  claim-verifications ran against[^relata-frbr];
- case 3 → **distinct entries, explicitly linked** by `same_work_as:` / `version_of:`,
  *not* merged, "because they cite differently (pages/year/venue), and silent-merge
  would corrupt citations, the one thing relata exists to protect"[^relata-frbr];
- the closing discipline: *"Appropriate-abstraction, not a catalog: three fields
  (`pdfs[]`, per-item `provisional`/`canonical`, entry `seeking_better`) and one
  relation (`same_work_as`). FRBR borrowed as the lens for getting boundaries right …
  and deliberately minimal."*[^relata-frbr]

**Why this is the paths material.** UDON's `@`-form has exactly this problem: the
reference is not the thing; the thing may have several acceptable realizations; two
realizations may or may not be interchangeable for the purpose the reference was made
for. relata's answer is that *interchangeability is defined by the consumer's use*
("reaches the same content at the same locators"), not by byte equality or by metadata
equality — and that the schema should carry the minimum needed to express the
distinction, plus one explicit relation for the case that must not be collapsed.

### 4.2 The similarity spectrum — three primitives, kept unconflated

The same section adds a rung that pass 1 has no analogue for, and it generalizes well
beyond bibliography[^relata-fingerprint]:

- **SHA-256** — exact bytes; trivial, pre-process. Detects the literally-same file.
- **Fuzzy / text-similarity hash** — the *missing middle rung*. Detects equivalent
  copies (re-encoded, extra blank page, grayscale cover): near-identical *surface*.
  Cheap, deterministic, **model-free, offline**.
- **Semantic embedding** — same *work* despite different *expression* (paraphrase,
  translation, preprint): meaning, not surface. Model inference.

> Fuzzy-hash and embedding are **distinct primitives for distinct jobs**; keep them
> unconflated (same discipline as §12's surrogate/proxy split).

Two correctness notes that a re-implementer would otherwise get wrong: **fingerprint
the extracted text, not the PDF bytes** (two PDFs with identical visible content but
different producers have wildly different byte streams, so a byte-level fuzzy hash
*fails* on true equivalent copies); and it is a *derived* stage, not a zeroth pass,
because it needs text extraction first[^relata-fingerprint].

There are also **two fingerprint spaces that must not be cross-compared**: `content_fp`
over the canonical item's first-N-pages extracted text (present only when there is a
PDF), and `biblio_fp` over normalized `title + authors + venue + year + abstract`
(**always present**). The bridge between them is the abstract — "an article's first
page contains its abstract nearly verbatim" — which makes a PDF-less entry's
`biblio_fp` genuinely comparable to an incoming file's `content_fp`, and which comes
free as a byproduct of lookups already being made[^relata-fingerprint].

### 4.3 Three separately-addressed trees

relata's `Paths` module separates the **code repo root** from the **canonical data
tree** (`DATA_DIR`, env-configurable, default `~/.local/share/relata/`, backed up
separately, "opaque to outside consumers")[^paths-tworoots]. The bytes of the resource
(`PDFS_DIR`) get their *own* env var again, "because PDFs are large bytes [and]
Joseph's backup strategy may differ from the small text-data tree"[^paths-pdfsdir]. So
**record store, resource store, and code are three separately-addressed trees**,
deliberately — an anchor menu (code-root vs data-root vs blob-root) rather than one
project root.

The blob tree's rule is simpler than it looks, and simpler than pass 1 reported (C11).
There is **no** storage-tier system: *"blob storage is decoupled from the record by the
`hash` field that already exists. The entry YAML (the record) is always git-tracked; the
bytes can live wherever the configurable `PDFS_DIR` points … joined back by
sha256."*[^relata-79-current] An earlier agent-authored three-tier framework
(`committed`/`local-cas`/`lfs`, an 8 MB threshold, a size × recoverability rule) was
disavowed by Joseph on 2026-05-19 and is dead — see C11 and §1.5.

What replaced it is a cleaner idea and a genuine paths datum: **the record stores a
logical token, not a path.** Entries keep `path: "pdfs/<key>.pdf"` as *"an OPAQUE logical
token"*; resolution is `PDFS_DIR/"<key>.pdf"` at runtime, and consumers *"never know or
address the physical location"*[^relata-1113]. The physical tree moved entirely out of
the repo — 31 PDFs, ~46 MB, essentially the whole repo weight — with **zero** change to
any record, because no record had ever named a physical location. The migration was
verified by re-hashing all 31 against their entry `hash` before and after
(31/31)[^relata-1113]. The operative rule is *"move, never delete"*, and the scope is
explicitly narrow: only the PDF tree was externalized; `entries/`, `verifications/` and
the deny-list stayed repo-rooted, *"deliberately out of scope"*.

The governing decision above it is §11 #10: canonical truth is a document tree; PostgreSQL
is *"the derived/operational layer (the calibration store, recall indices, later
pgvector); canonical truth stays the document tree"* — and both trees' locations are
*"configurable, default outside the relata code repo … and opaque to outside
consumers"*, with the ingest spool as *"the only outside-facing filesystem
surface"*[^relata-1110]. That is the three-tree separation stated as policy: **one
outward-facing address (the spool), everything else opaque and relocatable.**

---

## 5. Schema as first-class — "document-schema-first"

rowan's ADR-003 is the schema thesis, and it inverts the usual ORM stance: **the
document schema is the superset, RDBMS is a lossy projection**[^adr003-decision].

> "Constraint vocabulary comes from JSON Schema, not RDBMS limitations … Archema
> validation is canonical. RDBMS constraints are optional projections that provide
> defense-in-depth, not the source of truth. Document stores are first-class, not
> awkward adaptations — they're actually the more expressive target for many
> constraints."[^adr003-implications]

The constraint DSL is JSON-Schema-shaped (`one_of`/`any_of`/`when_value`/
`dependent_required` → `oneOf`/`anyOf`/`if-then-else`/`dependentRequired`), validated
in-engine and *projected* per store. The worked example is the polymorphic-FK problem,
which "dissolves" — one line of DSL[^adr003-poly]:

```ruby
belongs_to_one_of :commentable, [Post, Photo, Video]
```

projecting to whatever each store can express[^adr003-impl-table]:

| Store | Implementation |
|---|---|
| JSON/YAML | `oneOf` constraint in schema |
| Memory | Archema validation |
| PostgreSQL | Three nullable FKs + CHECK constraint + Archema validation |
| SQLite | Three nullable FKs + trigger + Archema validation |

> The constraint is fully expressed. RDBMS gets what it can handle; Archema ensures
> correctness regardless.

and the fourth stated implication is the one that reorders the usual priorities:
*"**Migration complexity shifts.** RDBMS migrations become 'best-effort projection' of the
true schema. Triggers fill gaps where native constraints can't express the full
intent."*[^adr003-implications]

**The three-worlds unification** names the ambition plainly[^adr003-threeworlds]: take
*relationship semantics / JOINs / referential integrity / ACID* from RDBMS, *schema
expressiveness / versioning / readability* from document stores, and *temporal
awareness / audit trails / `as_of` queries / immutable history* from event sourcing —
one resource definition, projected appropriately.

### 5.1 Self-describing documents, as shipped

The convention is **`_schema: <namespace-><type>/<semver>`** (e.g.
`autopax-agent-card/2.0.0`), reserving `_version` for document-level revision and
lineage[^adr008-selfdesc-conformant]. In rowan this is not a convention but a DSL with
defaults[^versioning-dsl]:

```ruby
class AgentCard < Archema::Resource
  schema_id      "autopax-agent-card"   # defaults to kebab-cased class name
  schema_version "2.0.0"                # defaults to "1.0.0"
  # full_schema_id => "autopax-agent-card/2.0.0"  — the value written to _schema
end
```

`schema_id` defaults to the class name kebab-cased; `schema_version` defaults to
`1.0.0`; versions are normalized so `"2"` and `"2.0"` both mean `2.0.0`[^versioning-normalize].
The addressing implication is that **the schema is part of the record's identity** —
which is exactly the "documents that know their schema version" capability the tooling
report's typing chapter proposed.

### 5.2 Compatibility declarations — Avro's modes, actually implemented

Pass 1 cited Avro's BACKWARD/FORWARD/FULL modes as an *external anchor*. rowan
implements them as resource-level declarations[^versioning-compat]:

```ruby
backward_compatible_with "1.0.0", "1.1.0", "2.0.0"   # we can read documents these wrote
forward_compatible_with  "4.0.0"                     # they can read what we write
```

with `can_read_version?`, `check_compatibility(from:, to:)` returning
`{backward_compatible:, upcast_required:, upcast_available:}`, and `known_versions`
sorted by `Gem::Version`. Forward-compatibility is honestly labelled: *"Primarily
documentation; actual compatibility depends on those versions."*[^versioning-forward]
That honesty is the right posture — a schema cannot unilaterally guarantee what a
future reader will do.

### 5.3 Attribute lifecycle

Attributes carry version metadata directly[^attributes-lifecycle]:

| Option | Meaning |
|---|---|
| `was:` | Previous attribute name (auto-migration rename) — `Symbol`, or `{name:, type:}` |
| `since:` | Version when the attribute was added |
| `deprecated:` | Version when deprecated |
| `removed:` | Version when removed (name stays reserved) |

with `exists_in_version?` computing presence by comparing `Gem::Version`s against
`since:`/`removed:`, plus `added_in_or_after?`, `deprecated_in_version?`, and a
`versioned?` predicate[^attributes-available]. `was:` has four accepted forms, and the
fourth is easy to miss[^attributes-was]:

```ruby
was: :old_name                           # simple rename
was: { name: :old_name }                 # explicit rename
was: { name: :old_name, type: :string }  # rename with type change
was: { type: :string }                   # type change only (same name)
```

---

## 6. Versioning & schema evolution — the deep part

Joseph was explicit this is schema-flavored but load-bearing for paths. It is: **an
address is only stable if it survives the schema change under it**, and every mechanism
below is a way to make old identities keep resolving.

Pass 1 read the user-facing summary (`docs/usr/10-schema-evolution.md`). The design of
record is `docs/dev/plan-safe-rdbms-evolution.md`, and it is a substantially bigger and
more disciplined document. It also opens with an explicit **implemented-vs-pending
split**, which is the single most useful thing in it for a downstream consumer who must
not mistake vision for shipped capability[^evolution-status]:

> **Implemented (in Archema today):** `was:` syntax for field renames with automatic
> upcasting · Schema versioning DSL (`schema_id`, `schema_version`) · Upcast blocks
> (`upcast from: "1.0"`) · Attribute lifecycle (`since:`, `deprecated:`, `removed:`) ·
> Schema history tracking (`.archema/schema_history/`) · YAML/JSONL upcasting on read ·
> Schema evolution CLI commands
>
> **Pending (this plan):** RDBMS expand-contract with sync triggers · Automatic
> monitoring and contract phases · Temporal queries (`as_of`) · Agent-friendly
> `# {{replaces: :name}}` syntax · Relationship refactorings (one-to-many ↔
> many-to-many) · Full refactoring catalog automation

### 6.1 The `was:` model — read-time translation, no flag-day

The core move is declaring what a field *used to be*, and translating on read:

```ruby
field :full_name, :string, was: :name          # old data `name:` reads as full_name
field :config, :hash, was: { name: :config, type: :string },
      upcast: ->(v) { JSON.parse(v) }           # rename + type change, transformed on read
field :session_token, :uuid8, since: "2.0.0"
field :legacy_id, :integer, deprecated: "3.0.0"
field :old_field, :string, removed: "4.0.0"     # reserved name
```

*"The YAML file that says `name: "John Doe"` is read as `full_name` … No migration
needed for the data — Archema translates at read time."*[^evo-was] For SQL it
*generates* the migration; for YAML/JSONL none is needed[^evo-nomig]. The whole point:
*"schema changes as safe as code changes."*[^evo-safe]

The plan states the per-store behavior for a single one-line change explicitly, and
this table is the clearest statement in the estate of what "storage layers are
intelligent servants" means[^evolution-perstore]:

| Storage Layer | Behavior |
|---|---|
| **YAML Frontmatter** | Reads `:name` from old files, returns as `:full_name`. Writes `:full_name`. |
| **JSONL Events** | Upcasts `:name` → `:full_name` on read. New events use `:full_name`. |
| **RDBMS** | Creates `full_name` column, adds sync trigger, tracks usage of old column. |

### 6.2 Upcast chains — the mechanism `was:` cannot cover

Separate from field-level `was:`, resources declare **upcast blocks** keyed by source
version, and rowan composes them into a *path*[^versioning-upcast]:

```ruby
upcast from: "1" do |data|
  # Transform v1 flat model string to v2 nested hash
  if data[:model].is_a?(String)
    match = data[:model].match(/@([^\/]+)\/(.+)/)
    data[:model] = { substrate: match[1], variant: match[2] }
  end
  data
end
```

`upcast_path(from_version)` walks `known_versions` from the stored version to current
and collects each intermediate block in order, so a 1.0.0 → 1.1.0 → 1.2.0 read applies
both transforms in sequence; if the stored version is not in the known list it falls
back to an exact match, then to a major-version match (`"1"`)[^versioning-upcastpath].
`upcast_data` then folds them over a `dup` of the record[^versioning-upcastdata].

This is the event-sourcing upcasting pattern applied to documents: **storage is never
rewritten; the transform happens on the way out.** It is also why the JSONL adapter can
be genuinely append-only — updates append a new line with the same id and reads return
the latest by scanning from the end[^jsonl-appendonly].

### 6.3 Runtime evolution — ADR-004 Phase 3, shipped

The report's prior text implies evolution is a build-time concern. ADR-004 argues for a
programmatic API first with the CLI as a thin wrapper, motivated by an explicitly
borrowed mental model[^adr004-otp]:

| Assumption | Rails/typical Ruby | Erlang/OTP |
|---|---|---|
| Process lifetime | Minutes to hours | Months to years |
| Schema changes | Between deploys | During runtime |
| Code upgrades | Restart required | Hot-swapped |
| State migration | At deploy time | Continuous |

`Resource.evolve` is implemented, with a mutex, an `EvolutionContext` that captures
operations, an automatic minor-version bump, and — the elegant part — the *from*
version being added to the backward-compatible list automatically so existing in-memory
records keep reading[^versioning-evolve]:

```ruby
User.evolve do
  add_field    :display_name, :string, default: "Unknown"
  rename_field :name, to: :full_name
  split_field  :name, into: [:first_name, :last_name],
               using: ->(v) { v.to_s.split(" ", 2) }
end
```

ADR-004 also lands `sync!` / `sync_all!` — "the 'just make it match' primitive that
scripting and testing need", filling the gap between low-level `create_table!` and the
full migration workflow[^adr004-sync].

### 6.4 History, ambiguity, branch-safety, and the decision log

- **History** — `.archema/schema_history/<resource>.yaml` (see correction C4), holding
  an ordered list of `Evolution` structs, each with `version`, `timestamp`, `changes`,
  the full `attributes` and `relationships` at that version, and a `decision_ref`
  pointer[^history-evolution]. So "what did User look like in v1.5?" is answerable from
  one file. Note this is *itself* directory-as-table applied to schemas.
- **Ambiguity is surfaced, not guessed** — when an attribute disappears and another
  appears, the differ raises `:possible_rename` with options `[:rename, :separate]`
  rather than deciding[^differ-ambiguity]. The detector is deliberately narrow: *"Simple
  heuristic: if exactly one column removed and one added with same type"*[^differ-heuristic].
- **A decision log with an agent channel.** `.archema/decisions.yaml` records each
  resolution as an immutable, append-only entry — *"Decisions are immutable once
  recorded - we never edit history, only append new decisions"*[^decisionlog-immutable]
  — with a time-sortable id, the ambiguity type, the chosen resolution, a reason, and a
  **source**. The source enum is the finding pass 1 missed entirely[^decisionlog-sources]:

  > - **:interactive** — Human responded to a terminal prompt
  > - **:agent_comment** — Agent embedded `# {{replaces: :old_name}}` in code
  > - **:config** — CI/CD pipeline provided answer via config file
  > - **:cli** — Command-line argument specified the resolution
  > - **:auto** — No ambiguity existed; system determined answer automatically

  and a companion `agent_id` field, *"agent session ID (only when source is
  :agent_comment)"*[^decisionlog-agentid]. The three purposes are stated as **replay**
  (regenerate migrations deterministically in CI/CD), **audit**, and — notably —
  *"**Learned from** - Future heuristics could train on decision patterns."*[^decisionlog-purpose]

### 6.5 The agent-annotation channel

The `# {{replaces: :name}}` form deserves its own note because it is the estate's
clearest statement of a *machine-writable schema-decision channel*[^evolution-agentsyntax]:

> For AI agents editing code without interactive prompts:
>
> ```ruby
> field :full_name # {{replaces: :name}}
> ```
>
> The `# {{...}}` comment is:
> - Parsed by Archema's schema watcher
> - Recorded in `.archema/decisions.yaml`
> - Stripped from the source file
> - Equivalent to `was: :name` declaration
>
> This enables: File-watcher-based real-time schema updates · Non-interactive CI/CD
> pipelines · Agent-driven refactoring

The design pattern generalizes: an agent cannot answer an interactive prompt, so the
answer is written *in the artifact being edited*, harvested by a watcher, promoted into
the durable decision store, and then **removed from the source** — the annotation is a
message, not state. ADR-004 sketches a second, non-consumed form of the same idea for
semantic hints (`#> For AI: also accept email as "contact_email" for legacy
compatibility`), and flags the open question of how far source modification may
reach[^adr004-annotations].

### 6.6 The expand / monitor / contract / remember lifecycle

The full lifecycle is four phases, not two[^evolution-lifecycle]:

1. **Expand** — both names work everywhere; new code writes the new name, old code
   writes the old (synced automatically in RDBMS, upcast on read elsewhere).
2. **Monitor** — the storage layer maintains `.archema/transitions/<resource>.yaml`
   with `started_at`, `last_old_write`, `old_write_count_30d`, `status`, and
   `safe_to_contract`, and emits deprecation warnings naming the removal date.
3. **Contract** — when policy allows (`Archema.config.auto_contract_after = 30.days`)
   or on manual trigger: RDBMS drops the column and trigger; **YAML and JSONL take no
   action** ("upcasting continues forever for old files"; "events are immutable").
4. **Historical awareness** — even after contraction the system remembers, so code
   from years earlier gets `DeprecatedFieldError: :name was removed from AgentCard in
   v3.0 … See: .archema/schema_history/agent_card.yaml`.

Phase 3's asymmetry is the important part for UDON: **contraction is a
storage-substrate concern, not a schema concern.** In a document store there is nothing
to contract; the read-time translation simply persists indefinitely. The cost of an old
address never expires, and neither does its resolution.

The plan closes with the whole Ambler/Sadalage refactoring catalog mapped to
declarations — structural, data-quality, architectural, and relationship refactorings —
and makes a sharp comparative claim worth carrying[^evolution-claim]:

> **Ash/Ecto/ActiveRecord don't do this.** They generate migrations for the
> *destination* state, not the *transition*. You're on your own for the in-between.

The estate holds the source catalog too: ~60 pattern files under
`rowan/docs/ref/patterns/` (RenameColumnExample, IntroduceSurrogateKeyExample,
ReplaceOneToManyExample, …) — the Ambler/Sadalage taxonomy imported wholesale as
reference material[^patterns-dir].

---

## 7. The write membrane — canonical vs. derived, and schema-guarded mutation

relata ships the exact "validate inside the write" discipline the tooling report's
`schema-guarded-mutation` chapter demands, at the *collection* level. Pass 1 quoted one
sentence; the design is worth reproducing near-whole, because the second half of it —
the two-outcome distinction — is a genuinely novel principle for agent-facing write
boundaries and appears nowhere else in the estate[^relata-spool]:

> ## 15. The ingest spool — a write-membrane protecting the canonical db
>
> Joseph 2026-05-15: agents love that they can *just write a YAML file into the right
> place and it's done*. Preserve exactly that ergonomics — but never let an external
> writer touch canonical `entries/` directly. A spool directory is the integrity
> membrane.
>
> **Mechanism.** `~/src/relata/ingest/` is a drop-box. Anyone (agents, scripts, Joseph)
> drops in: a `.yml`/`.yaml` bib entry, a document (`.pdf`/`.epub`/`.mobi`), or a
> reference list (`.csv`/`.md`). `bin/relata ingest` with no file arg **drains the
> spool**: for each stable file (mtime older than the same 60 s guard `safe_write`'s
> tmp-sweep uses, so a half-written drop is never processed),
>
> - **YAML bib entry** → schema-validate (`Entry#schema_errors`) + deny-list +
>   `possible-duplicates`. Clean & non-colliding → promoted into `entries/<key>.yml`
>   via `safe_write` and removed from the spool. Otherwise it does **not** enter
>   canonical.
> - **Document** → the Stage 0..G pipeline; confident → `cmd_pdf` attach + removed;
>   uncertain → held for review (below).
> - **Reference list** → the P0.5 path (fan each row through matcher+ledger).
>
> **Two distinct non-happy outcomes — the distinction is itself a truth-honoring
> requirement, do not collapse them:**
>
> - `<name>.rejected` + `<name>.rejected.md` — the *submitter* erred: malformed YAML,
>   schema-invalid, unknown format, deny-list hit, or a same-DOI/key collision. Sidecar
>   gives the exact errors and the fix. Re-drop after fixing.
> - `<name>.needs-review` + `<name>.needs-review.md` — the submission is well-formed but
>   ingest's *own epistemic humility* (Stage G) needs a human: sidecar carries the ranked
>   candidates with their **evidence ledgers** and the precise one-line ask. Not the
>   submitter's fault — the system's honesty about uncertainty. Conflating this with
>   `.rejected` would mislabel system-uncertainty as user-error; that mislabel is a small
>   dishonesty the North Star forbids.
>
> **Why this is load-bearing, not convenience.** The North Star makes *epistemic
> integrity* the primary object; an unguarded `entries/` is the exact corruption vector
> (a malformed or hallucinated YAML silently becoming canonical truth). The spool makes
> canonical **write-protected by construction** — only ingest, having validated,
> promotes. And the happy path stays exactly as frictionless as agents love: drop it,
> it's gone, it's done; you only ever hear back when something is genuinely wrong, with
> exact reasons.

Three structural facts that generalize:

- **The membrane preserves the ergonomics it protects.** The reason the design works is
  that the *happy path is unchanged* — drop a file in a directory. The membrane is
  invisible when the write is good. A membrane that taxes correct writes will be routed
  around.
- **Rejection and uncertainty are different speech acts.** `.rejected` says *you were
  wrong*; `.needs-review` says *I am not sure*. Each carries a machine-readable marker
  file plus a human-readable sidecar. For an agent-facing store this distinction is the
  difference between "fix and re-drop" and "wait for adjudication" — and collapsing it
  trains agents to retry things that retrying cannot fix.
- **Staleness, not locking, is the concurrency guard.** The 60-second mtime floor is the
  same constant used by the `safe_write` tmp-sweep — one convention, reused, so a
  half-written drop is never processed and a crashed writer's debris is never promoted.

Around the canonical table sit the other three kinds of directory[^relata-paths-dirs]:
**append-only event stores** (`verifications/`, `calibrations/`, `pdf-attempts/<key>/`
— "one append-only markdown event per (key, source, timestamp) triple … never mutated
in place … replay-friendly"[^paths-pdfattempts]); the **spool** itself, git-ignored as
transient; and **derived views** that are explicitly *not* canonical (`_emitted/` `.bib`
snapshots, gitignored, ephemeral[^paths-emitted]). That is a full CQRS-ish shape —
canonical record store + event logs + validated write membrane + materialized derived
views — realized as directories.

One further discipline worth lifting, because it prevents the commonest
over-engineering: relata deliberately **does not** build a separate ingestion log. The
verification-event trail carries the ingest provenance, on the reasoning that *"that
event **is** the calibration datum … so the audit trail and the calibration corpus are
the same store. No separate `ingestions/` tree."*[^relata-noingestions] The general form:
before adding an event directory, check whether an existing one already has the right
grain.

Autopax's CHRONICA carries the integrity half, and the JSONL adapter implements it:
append-only, BLAKE3 hash-chaining with a literal `"genesis"` marker for the first
record, `hash`/`hash_prev` fields, and `verify_chain!` walking the sequence so that
"tampering with any record breaks the chain from that point forward"[^jsonl-hashchain].
Destroy in a hash-chained file cannot delete — it appends a **tombstone** entry carrying
`_tombstone_for: <id>`, and it first verifies the record exists "to avoid orphan
tombstones for bad IDs"[^jsonl-tombstone]. Deletion in an append-only store is a
*record*, not an absence.

---

## 8. Addressing: designators, resolution, and identity that survives renaming

This section is the largest single addition. Pass 1's §6 reasoned about paths without
having read the estate's actual addressing work. relata has the deepest treatment, and
it is unusually rigorous.

### 8.1 The designator, and why the word was chosen

relata's `Designator` module opens with the definition and the philosophical warrant in
the same breath[^designator-doc]:

> A *designator* is anything that attempts to resolve to one specific citable work. The
> kinds this slice distinguishes differ in rigidity (§11.17's Kripke lens — rigid
> designator vs definite description):
>
> - `:bibkey` — an existing entry key (rigid; the corpus's own namespace)
> - `:sha` — a sha256, bare hex or "sha256:"-prefixed (rigid; matched against registered
>   `pdfs[]` item hashes)
> - `:doi` — a DOI in its common dress: bare `10.xxxx/…`, `doi:`-prefixed, or an
>   `https://doi.org/` (or `dx.doi.org`) URL (near-rigid; **the fixture corpus itself
>   proves a DOI can designate plurally** — two entries sharing one DOI is a live lint
>   category, so DOI resolution honestly returns `:choices`)
> - `:path` — an existing readable local file; resolves by hashing the bytes and looking
>   the sha up (Stage 0's dedup as resolution). A file whose sha the corpus doesn't know
>   is an honest `:none` with kind still `:path`, so the caller can see "this was a
>   readable file" and suggest ingest.
> - `:fuzzy` — everything else ("wecker 2025"); a definite description that may designate
>   zero, one, or many works.
>
> Classification precedence: doi → sha → bibkey → path → fuzzy. The syntactically
> unmistakable rigid forms go first; bibkey beats path because in a citation manager an
> exact corpus key is the intended reading even if a same-named file happens to exist in
> cwd; anything unclaimed falls to fuzzy.

Five things here are directly transferable to UDON's `@`-form:

1. **Rigidity is a spectrum, and it is a property of the *kind*, not the string.** A
   bibkey is rigid because it lives in the corpus's own namespace; a DOI is only
   *near*-rigid because the world can (and empirically does) violate its uniqueness; a
   description is not rigid at all.
2. **Precedence is decided, stated, and justified per step.** "bibkey beats path because
   in a citation manager an exact corpus key is the intended reading even if a
   same-named file happens to exist in cwd" is exactly the kind of reasoning a path
   syntax needs and rarely writes down.
3. **The result carries the kind even when resolution fails.** `Result` is
   `(input, kind, status, entry, choices)` with `status ∈ {:unique, :choices,
   :none}`[^designator-result]; a `:none` still tells the caller *what the string was*,
   which is what lets the CLI say "that was a readable file I don't know — want to
   ingest it?"
4. **Plural resolution is a first-class outcome, not an error.** `build` branches on
   `matches.length` into 0/1/many, and many is `:choices` with a ranked list.
5. **The syntactic gate is a safety gate, not a schema.** The bibkey shape regex is
   annotated: *"This is a **safety** gate, not a schema — it keeps `Entry.load` from ever
   being handed a path-traversal string ('../../…'); anything it rejects simply falls
   through to path/fuzzy."*[^designator-gate] A validator that *rejects* and a validator
   that *routes* are different things, and conflating them is how syntaxes acquire
   accidental exclusions.

### 8.2 The resolution ladder

Resolution is not a function; it is a five-tier degradation, and every resolving verb
walks it[^relata-1117-ladder]:

> **The resolution ladder (Joseph's, verbatim in intent).** Every resolving command
> degrades through five tiers, never silently:
> (1) **automatic** — exactly one very-high-confidence answer;
> (2) **blocking interactive** — TTY: rich, ANSI-highlighted choice prompt with enough
> evidence to decide; non-TTY/agent: JSON choices on stdout + non-success exit code, so
> an agent can decide and re-initiate with the choice as a flag;
> (3) **batch choice list** over many designators at once …
> — and at every tier the caller's nature is auto-detected (Joseph, 2026-07-10): when
> stdout is not a TTY (script / agent / pipe), commands default to machine output — JSON
> where a decision or structure is being conveyed, no ANSI color — without needing the
> flags; `--json` / `--no-color` / `--color` remain as explicit overrides in both
> directions;
> (4) **a runnable pending-choices report** for later review;
> (5) **the queue** — at minimum the DB knows what stage each designator reached, with
> work staged (the §15 spool). The spool-drain is therefore the *bottom tier of the
> ladder, not the center of the UX* — confirmation is a mode of every resolving command,
> not a separate chore.

Two design consequences stated in the same decision:

- *"Resolution = the migration fuzzy designator → unique designator"*[^relata-1117-unique],
  where a **unique designator** is "a designator sufficiently detailed to uniquely
  identify one existing entry (bibkey, relata id, DOI already in the corpus, sha of a
  registered blob)". Addressing is therefore a *process with a direction*, and the
  system's job is to move a reference up the rigidity ladder and record that it did.
- *"Rerun ≠ retry ≠ decide, at every wait-state."* Re-running the same command on
  something awaiting a decision "jumps straight to the pending decision, with its
  evidence (no blind pipeline redo)"[^relata-1117-rerun]. The idempotence question for a
  resolving verb is not "did it change anything" but "what is it waiting for."

Confirmation is likewise plural — four distinct kinds, each writing its own labeled
calibration event: *match disambiguation* (which close entry is meant), *expression
selection* (which `same_work_as` sibling; is this blob canonical or a preprint),
*content attestation* (this PDF really is that entry's content), and *entry correctness*
(the bib facts themselves)[^relata-1117-confirm]. Each is optional when confidence is
decisive. The general form: **a confirmation is about one dimension of a resolution, and
the dimensions must be nameable separately or the human is asked an unanswerable
compound question.**

### 8.3 Aliases — addresses that outlive their records

The mechanism that makes keys survive renaming is small and it is shipped[^entry-resolve]:

```ruby
# Resolve a key that may be an ALIAS (§11.18): a bibkey retired by a
# dedup merge or a rename lives on as `aliases: [old-key]` on its
# survivor, so every consumer citation keeps resolving forever.
# Returns [entry, requested_key] — the caller decides whether the
# requested name matters (emit must write the bib entry under the
# CITED name or LaTeX keys break; show/pdf/verify act on the
# canonical entry). File-hit is the fast path; the alias scan is
# corpus-wide but runs only on a miss.
def self.resolve(key)
  if (entry = load(key))
    return [entry, key]
  end
  canonical = all.find { |e| e.aliases.include?(key) }
  canonical && [canonical, key]
end
```

Four properties worth naming explicitly, because together they are a complete
design for stable addressing under identity change:

1. **Resolution returns the requested name alongside the resolved record.** This is the
   subtle one. Some consumers need the canonical entry (`show`, `verify`); some need the
   *alias they asked with* (`emit` must write the `.bib` entry under the cited key or
   downstream LaTeX breaks). A resolver that discards the request has destroyed
   information the caller needs.
2. **Aliases are a first-class schema field, and uniqueness is enforced** — `validate`
   checks alias uniqueness against both keys and other aliases[^relata-1118-aliases], so
   the key namespace and the alias namespace are one namespace.
3. **The alias-bearing copy must never be saved.** `as_key(name)` returns "a copy of this
   entry wearing a different key — for emission under a cited alias name. **Emission-only
   by contract:** SAVING it would fork the entry into a second file, recreating the
   split-brain aliases exist to prevent."[^entry-askey] The invariant is that exactly one
   file backs one identity, regardless of how many names reach it.
4. **The fast path is the file; the slow path is the scan.** `load` first, corpus-wide
   alias scan only on a miss.

### 8.4 The empirical case for all of this

The alias mechanism was not speculative. A read-only duplicate-cluster audit found
**29 same-expression duplicate clusters** (58 entries; 15 live build-bearing in consumer
papers; **in 7 the *cited* key was the metadata-poorer twin** — recall-poisoning), plus
**13 citation-distinct sibling pairs** with *zero* `same_work_as` links existing
corpus-wide[^relata-1118-audit]. And the systemic cause is a key-minting failure that
any identity scheme can reproduce:

> the import title-collision ladder **synthesizes a disambiguated key instead of routing
> into a same-work check** — in 3 of 6 collision-note cases the incumbent WAS the same
> paper.[^relata-1118-audit]

The fix is stated as a **regrowth gate**: the writer's title-collision path gains a
same-work check (normalized-title + year + first-author surname) that routes to *enrich*
rather than *create*[^relata-1118-regrowth]. This is the load-bearing lesson for any
addressing scheme that mints keys automatically: **collision-avoidance and
identity-resolution look the same at the call site and are opposite operations.**
Appending a disambiguator to a colliding key is the locally correct move and the
globally corrupting one.

The survivor rule for merges is equally transferable: *"the cited key survives wherever
exactly one key in the cluster is cited; otherwise the metadata-richer key"* — merge is
field-union with the survivor winning conflicts and the twin filling gaps, PDFs become
item sets, and the survivor's `internal_note` records the merge (absorbed key, date,
evidence)[^relata-1118-survivor]. **Usage, not richness, is the primary tiebreak** —
because the cost of breaking an existing reference exceeds the cost of a poorer record.

### 8.5 Two addressing modes over one record type

autopax's AgentCard supports two distinct ways to reach the same kind of
record[^agentcard-modes]:

> 1. **Registry mode**: Agents stored in XDG data directory, looked up by name
>    `AgentCard.get!('test-agent')  # from ~/.local/share/autopax/agents/`
> 2. **Path mode**: Agents loaded from arbitrary paths (project-local, ad-hoc)
>    `AgentCard.load_path('path/to/agent.yml')`

The path mode **bypasses the store entirely** — it reads the file, runs its own `Parser`
(which handles two file *formats*: frontmatter-with-body, and traditional YAML with
`files.axiomata-root` file references), runs `Validator.validate!`, and constructs the
record directly[^agentcard-loadpath]. It also records `directory` on the record so that
relative references inside resolve against the file's own location rather than the
registry's.

This is a real datum for UDON: **the same record type is addressed by key-in-canonical-
directory and by arbitrary path, and the two paths through the code are different.** The
registry mode gets store services (caching, schema stripping, `was:` renames, upcasting);
the path mode gets none of them and hand-rolls validation instead. That divergence is a
cost of the dual-mode design, and it is visible in the source: the path mode's validator
enforces `version == "1"` as a hard equality[^agentcard-validator], which is exactly the
kind of check the store's `can_read_version?` machinery exists to replace.

---

## 9. Paths as queries — the path-centric vs set-centric theory

`rowan/docs/exp/path-centric-query-dsl.md` is 1,624 lines and is the estate's most
directly path-relevant document. Pass 1 never opened it. Part 1 is the theory; the rest
is CQRS research, a domain-action design exploration, and the hallway-testing results
(§10.2).

### 9.1 The dialect survey

Six languages compared row-by-row on thirteen capabilities — Ruby `dig`, jq/yq, XPath,
CSS selectors, SQL, Cypher/GQL — across basic path, array index, all-elements, filter,
wildcard, recursive descent, existence, comparison, AND/OR/NOT, string match,
aggregation, and projection[^pathdsl-dialects]. The distillation is three operations and
two paradigms[^pathdsl-observations]:

> **Three fundamental operations emerge:**
> 1. **Navigation** — moving through structure (path access, indexing, relationship traversal)
> 2. **Selection** — filtering based on predicates
> 3. **Projection** — choosing what to return
>
> | Paradigm | Examples | Character |
> |---|---|---|
> | **Path-centric** | dig, jq, XPath | "Follow this trail through the structure" |
> | **Set-centric** | SQL, Cypher | "Find all things matching these constraints" |

### 9.2 The expressiveness result

The document then asks and answers the containment question in both directions.

*Can every path expression be stated as a set expression?* **Yes** — a path is a
composition of navigation (JOIN on a declared relationship), filtering (σ), and terminal
access (π), and the worked example translates `user.posts.where(published:
true).comments.author.name` into the corresponding four-way SQL join[^pathdsl-yes].

*Can every set expression be stated as a path expression?* **No**, with a table of the
constructs that have no natural path form: arbitrary joins on undeclared correspondences
(`WHERE a.region = b.region` with no FK), self-joins requiring aliasing, set operations
(`UNION`/`INTERSECT`/`EXCEPT`), grouping with `HAVING`, window functions, and correlated
subqueries[^pathdsl-no]. Stated against relational algebra[^pathdsl-algebra]:

| Operation | Symbol | Path-centric? |
|---|---|---|
| Selection (filter rows) | σ | ✓ Yes |
| Projection (select columns) | π | ✓ Yes |
| Join (on FK) | ⋈ | ✓ Yes (schema-guided) |
| Cartesian product | × | ✗ No |
| Set union | ∪ | ✗ No |
| Set difference | − | ✗ No |
| Rename (aliasing) | ρ | ✗ No |

> **Path-centric languages express a proper subset of relational algebra — specifically,
> the subset that follows the schema's declared structure.**

And the categorical restatement, which is the sharpest form of the idea[^pathdsl-category]:

> If we view the schema as a category: **Objects** = entity types (tables, Resources);
> **Morphisms** = relationships (foreign keys). Then path expressions are **morphism
> compositions** — they can only go where the schema says paths exist. Set operations
> work on the *extensions* (actual row sets) rather than respecting the *intension*
> (schema structure). This is why path expressions feel more "typed" and set expressions
> feel more "dynamic."

**This is the load-bearing result for UDON paths.** A path language is not a weaker query
language; it is the query language whose reachable set is exactly the schema's declared
morphisms. Whatever a UDON path can express is therefore a statement about what the
document's structure *declares*, and every extension to path expressiveness is either (a)
a new declared morphism or (b) a defection into set-centric territory that the schema
does not underwrite.

### 9.3 The Inversion, and the reframed escape hatch

From which the design move follows[^pathdsl-inversion]:

> Traditional approach: *Simple schema + Complex queries.*
> Archema approach: *Expressive schema + Simple (path-centric) queries.*
>
> The complexity doesn't disappear — it moves into the **schema declaration**, where it
> becomes: Named · Typed · Documented · Reusable · Testable in isolation.

and, the line most worth carrying into the paths ideation[^pathdsl-escape]:

> It's not "drop to SQL when path-centric isn't enough."
>
> It's "**declare a new path** backed by whatever set operations you need, then query it
> path-centrically like everything else."
>
> **The escape hatch enriches the schema, not the query.**

Two applications follow. **Views become Resources** (`derives_from User do … end`), so a
view "gets type checking, relationship traversal, policy application, schema evolution
tracking, and the same query DSL"[^pathdsl-views] — answering a question the migration
survey independently raised (§10.1, finding 3). And **cross-store traversal is
transparent**: a `User` in PostgreSQL can declare `has_one :preferences` in a YAML
frontmatter store and `has_many :audit_events` in a JSONL log, and
`user.dig(:preferences, :theme)` crosses them without the query DSL knowing[^pathdsl-crossstore].
The unification table is worth having whole[^pathdsl-unification]:

| Traditional concern | Archema equivalent |
|---|---|
| SQL VIEW | View-backed Resource (`derives_from`) |
| Materialized view | Resource with refresh policy |
| Cross-DB join | Cross-store relationship |
| Denormalized read model | Projection Resource (event-sourced) |
| Reporting query | Calculated relationship or derived Resource |
| ETL pipeline | Multi-store action that writes to several stores |

### 9.4 The concrete syntax decision: paths are data

ADR-002 makes the syntax choice, and the rationale is a rejection table[^adr002-rationale]:

| Approach | Problem |
|---|---|
| String DSL (`"author.role = 'admin'"`) | Parsing complexity, injection risks, no IDE help |
| Ruby blocks (`{ author.role == :admin }`) | Can't translate to SQL efficiently |
| AST extraction | Fragile, limited to Ruby subset |
| Method chaining builder | Too verbose |

The chosen form is array-of-symbols, "inspired by Ruby's `Hash#dig`":

```ruby
Post.query.filter([:author, :role], :eq, :admin)
Post.query.filter([:author, :profile, :verified], :eq, true)
Post.query.filter([:author, :role] => :admin)          # hash form for equality
```

with the reasons stated as[^adr002-why]:

> - Familiar Ruby idiom (`Hash#dig` is well-known)
> - **Paths are data (arrays), not syntax magic**
> - No parsing, no AST, no method_missing
> - Easy to validate against resource definitions
> - **Precise error messages: "Failed at step 2 of [:author, :profile, :name]"**
> - Serializable (just arrays of symbols)
> - Maps naturally to JSON-query / JSONPath

Translation is per-store: "Memory/YAML: traverse objects with `dig`; Sequel: build JOINs
from path"[^adr002-translation]. Status is **Draft**, and MAP.md lists
relationship-aware filtering as still planned[^map-adr002-planned] — so this is a decided
*direction* with an unbuilt implementation, and should be cited as such.

Two of its three open questions are live for UDON too: *"How deep should path traversal
be supported?"* and *"Future: layer sugary block syntax on top?"*[^adr002-open] — the
second being the question of whether an ergonomic surface can sit over a data-shaped
core without the core becoming unreachable.

There is also a stated *unification hypothesis* worth flagging: ADR-002 links to an
exploration noting that "dig-style paths may unify with graph traversal"[^adr002-related],
which is the same bet UDON's relational/join axis is making.

---

## 10. The empirical layers

Two bodies of evidence sit under this work that pass 1 does not mention at all. Both are
methodologically interesting in their own right, and the second is directly reusable by
the agentic-tooling program.

### 10.1 The migration survey — what schema evolution actually looks like

23 public Rails projects, **6,201 migrations, 12,072 mutations**, analyzed by script
(the scripts are in the repo, and the results are dogfooded into Archema resources
stored in SQLite)[^survey-header]. The distribution[^survey-distribution]:

| Category | Operations | Count | % |
|---|---|---|---|
| **Expand** | create_table, add_column, add_reference, add_timestamps | 5,011 | 41.5% |
| **Contract** | drop_table, remove_column, remove_reference | 926 | 7.7% |
| **Alter** | rename_table/column, change_column, change_null/default | 1,225 | 10.1% |
| **Index** | add_index, remove_index | 2,466 | 20.4% |
| **Constraint** | add_foreign_key, add_check_constraint | 506 | 4.2% |
| **Raw SQL** | execute statements | 1,896 | 15.7% |

The findings that matter beyond Rails[^survey-insights]:

1. **Expand ≫ Contract, 5:1.** "Schema evolution is predominantly additive.
   Contractions are rare and usually deliberate cleanup." This is the empirical warrant
   for the whole `was:`/upcast-on-read design: optimize the additive case, make
   contraction optional and late.
2. **Indexes are 20% of all mutations** — index management is a first-class concern, not
   an afterthought.
3. **Views are hidden.** 46 view operations, *all* inside `execute` "because Rails has no
   view DSL" — a capability gap made visible only by counting. This is what §9.3's
   view-backed Resources answer.
4. **Data migrations are ~8% of mutations**, and within raw SQL, "data operations are
   consistently ~40-50% of raw SQL regardless of project."
5. **Triggers/functions are real** (5%) — computed columns, audit trails, cache
   invalidation, cross-table consistency.
6. **Models change 5.1× more often than migrations**; 54% of migration commits also touch
   models; 46% are schema-only. *"Schema is the stable foundation. Model logic changes
   frequently, schema rarely. This supports Archema's 'resource as truth' approach."*

Finding 6 is the one to carry into UDON: **the schema layer is the slow-changing layer.**
That is the justification for putting expressiveness there rather than in the query
surface (§9.3), and for expecting a document's declared structure to outlive most of what
reads it.

### 10.2 Hallway usability testing — agents as an obviousness instrument

`docs/dev/hallway-usability-at-scale.md` proposes and grounds a methodology that the
agentic-tooling corpus should absorb wholesale. The core move[^hallway-core]:

> Traditional hallway usability testing: grab someone walking by, put them in front of
> your interface, watch them struggle. Their confusion is signal. Their guesses reveal
> what the API *should* have been.
>
> AI agents enable this at scale. Spin up a fresh agent with minimal context, give it a
> task, observe what it tries. Repeat across models, prompts, scenarios. The aggregate
> behavior reveals where your API aligns with intuition and where it fights it.

The grounding is information-theoretic, and it yields a metric[^hallway-kolmogorov]:

> An API's "obviousness" can be framed as its Kolmogorov complexity relative to a user's
> prior knowledge. … When a naive agent guesses an API correctly, it's demonstrating that
> the API is derivable from general programming knowledge plus minimal context. The
> agent's prior (its training) approximates "what a reasonable developer would expect."
>
> **Key metric:** How many bits of context are required before an agent can use the API
> correctly? — Beautiful API: nearly zero (the agent guesses it) · Okay API: a few
> examples suffice · Bad API: requires reading documentation · Terrible API: documentation
> isn't enough.

with `k*` defined as the minimum context size at which P(correct) > 0.8, and the *shape*
of the learning curve read as a diagnostic: "a steep curve = good API with a learnable
pattern; a gradual curve = non-obvious structure requiring many examples; a flat low
curve = the API actively fights intuition"[^hallway-curve].

Convergence is the second instrument, and its three-way reading is the useful
part[^hallway-convergence]:

> 1. **If they converge on what you built:** Your API matches intuition
> 2. **If they converge on something else:** Consider changing your API to match
> 3. **If they don't converge:** The problem space is genuinely ambiguous — document heavily

The four phases are zero-context guessing, minimal context (one example — "how much does
one example improve success rate?"), adversarial confusion, and documentation validation
where *"the delta is the documentation's value. If documentation doesn't significantly
improve success, either the API was already obvious (good) or the documentation is
ineffective (fix it)"*[^hallway-phases]. Tracked metrics with targets: zero-shot success
> 60%, one-shot > 90%, convergence coefficient > 0.7, guess-API alignment > 80%[^hallway-metrics].

And the meta-principle, which is the sentence to quote when this is proposed to
skeptics[^hallway-meta]:

> The goal is not to make an API that AI agents can use. The goal is to use AI agents as
> a proxy for human intuition at scale. An API that naive agents can guess is an API that
> naive humans can guess. The agents' training encodes "what programmers expect." Their
> failures reveal where your API departs from expectations. This doesn't replace human
> judgment — it augments it.

### 10.3 What the agents actually did

The methodology was run. `path-centric-query-dsl.md` Part 4 reports **20+ agent
challenges** across seven deliberately-chosen categories — `simpler_than_syntax`,
`complex_beyond_syntax`, `awkward_fits`, `cross_cutting`, `messy_reality`,
`state_edge_cases`, `composition_puzzles`[^hallway-categories] — with results stored in
`test/usability/results/`. Twelve numbered findings plus a second round. The ones that
generalize past Ruby:

- **Infrastructure concerns want declarative syntax.** Agents *consistently invented*
  `rate_limit 10.per_minute`, `lock :name, key: -> {}`, `timeout 30.seconds`,
  `retry_policy max_attempts: 3, backoff: :exponential`, and `idempotent_key: [...]`
  — none of which existed[^hallway-f1]. Convergent invention across independent agents is
  the strongest signal the methodology produces.
- **Previous-value access is essential.** Agents invented `old_value` / `old_balance`
  accessors; the report notes this "aligns with Archema's existing `was:` syntax — extend
  it to runtime with `old_<field>` accessors in action context"[^hallway-f5]. The same
  concept wanted at both schema-time and runtime is a strong hint the concept is real.
- **Three tiers of complexity emerge naturally**, and forcing one syntax across them is
  the error[^hallway-tiers]:

  | Tier | Use Case | Right Abstraction |
  |---|---|---|
  | **Simple** | Computed values, no side effects | `computed :name do … end` |
  | **Medium** | State changes, validation, side effects | `action :name do run { } end` |
  | **Complex** | Multi-step, compensation, external services | Separate Action class |

- **Some things should stay plain Ruby.** For complex failure handling agents
  "consistently reached for plain Ruby" with `transaction do` plus `rescue` clauses, and
  the conclusion drawn is *"Don't try to abstract all failure handling into DSL. Provide
  clean escape to Ruby."*[^hallway-f10] The report's explicit *Should Keep as Plain Ruby*
  table — complex failure handling, nested transactions, multi-phase workflows, parallel
  state machines — is as valuable as its *Should Add* table[^hallway-keep].
- **A syntax can be wrong for a *shape* of problem, not just wrong.** Composition syntax
  (`compose do … step … end`) fit one-shot multi-step operations and *failed* for human
  approval workflows, which are "long-running (hours/days between steps), different
  actors for each step, steps triggered by external events, state persisted between
  steps" — the agent's own in-code comment was *"This feels awkward - need separate
  actions for each approval step"*[^hallway-approval]. Agent discomfort recorded verbatim
  is a usable signal.
- **Undo needs run-time data.** The `run` block must return data the `undo` block
  receives, because "side effects can't be truly undone — you can't unsend an email",
  compensation needs context, and previous state must be captured[^hallway-undo].

### 10.4 Simulation-driven testing — a *different* instrument, often conflated

Pass 1 mentioned the simulation corpus in passing and implied it was of a piece with the
hallway testing. It is not, and the distinction is worth keeping: **hallway testing
measures whether the API is guessable; simulation testing measures whether the
implementation survives realistic use.** Design feedback versus test generation. Both use
agents; neither substitutes for the other.

The simulation thesis[^sim-driven]:

> Traditional property testing generates random *values* within type constraints.
> Simulation-driven testing generates random *scenarios* — coherent sequences of
> operations that exercise complex behavior paths.
>
> ```
> Property Testing:    random values → check invariants
> Simulation Testing:  random scenarios → execute → check invariants
> ```
>
> The key is using LLMs as **"semantic fuzzers"** — they understand what makes a scenario
> *plausible* or *pathological*, not just syntactically valid.

Four design choices in the pipeline are transferable[^sim-driven]:

1. **Distribution sampling before any LLM call** — `Poisson(λ=12) → migration_count`,
   `Pareto(α=2) → max_field_name_length`, `Categorical → chaos_level`. The parameters are
   sampled, then handed to the model as constraints; the model does not choose the shape
   of the test population.
2. **Heavy tails on purpose** — *"Most tests are simple and fast; occasionally you get a
   monster scenario that finds edge cases; matches real-world usage patterns better than
   uniform random."* Most scenarios have 3–10 migrations, occasionally 50+; most field
   names are short, occasionally 1,000 characters.
3. **Two LLM stages with justified tiering** — *"**Sonnet (Scenario Architect)**: better
   at creative narrative, establishing coherent context. **Haiku (Simulation Executor)**:
   cheaper for bulk generation, good enough for structured output"* — with the executor
   run under `--json-schema` enforcement. And the reason the narrative stage exists at
   all: *"The scenario provides constraints that make the simulation coherent — without
   it, Haiku might generate random operations that don't tell a story."*
4. **A scenario is itself a record directory** — 21 of them under
   `test/simulation/scenarios/<timestamp>_<hash>/`, each holding `scenario.md` (the
   narrative), `operations.jsonl` (the executable steps), and `metadata.json`
   (the sampled parameters)[^sim-scenarios], all generated against a shared
   resource/store vocabulary document[^sim-context] and sampled here for the
   multi-store narratives pass 1 quoted[^sim-scenario]. Directory-as-table again, for test cases:
   human-readable narrative, machine-readable operations, and reproducible parameters,
   co-located and diffable.

The de-novo-testimony value is higher than pass 1 credited. Asked only to invent a
plausible organization, the scenario architect independently produced the multi-store
thesis[^sim-legalvault]:

> The breakthrough came when they realized **different aspects of the same document had
> fundamentally different storage needs.** The original PDF required immutable, compliant
> storage. The OCR'd content needed fast full-text search. Case metadata benefited from
> git-backed versioning so partners could review changes like code. Client data demanded
> GDPR-compliant handling with geographic restrictions. … Each document in the system
> simultaneously lived in a compliance vault, a search index, version-controlled metadata
> files, encrypted client databases, and ML training pipelines. **The beauty was that
> lawyers still just worked with "documents"** — the storage complexity was completely
> hidden behind the resource interface.

That is rowan's own store-composition thesis (§2.2) and relata's record-vs-resource split
(§4.1), reconstructed from scratch by a model that was asked for a law firm. It is the
cleanest available evidence that the abstraction matches how the problem actually
presents. The proposed extension inserting a "Naive Agent Panel" between scenario and
runner would merge the two instruments[^hallway-pipeline] — unbuilt.

---

## 11. Records with a lifecycle: the ADR system is itself a doc-store

Pass 1 listed "lite instances" and did not notice that the corpus it was *reading* is
one of the best. autopax's `docs/ADR/` is a directory-as-table whose records carry a
**state machine**, **supersession links**, **dependency edges**, and an **immutability
rule keyed to state** — which is exactly the set of features a document-notation project
needs to think about, and the only instance in the estate that has all four.

The schema is typed frontmatter[^adrreadme-frontmatter]:

```yaml
---
adr: NNN
title: Descriptive Title Here
aliases: ["NNN", "ADR-NNN"]      # for Obsidian wikilink resolution
status: PROPOSED
first_introduced: YYYY-MM-DD
last_changed: YYYY-MM-DDTHH:MM:SS
deciders: [Name One, Name Two]
supersedes: null
superseded_by: null
related: ["[[001]]", "[[003]]"]
blocked_by: ["[[008]]"]          # Waiting for decision on schema validation approach
needed_for: ["[[006]]"]          # ADR-006 Phase 4 cannot proceed until this is decided
---
```

Six properties worth naming:

1. **The status is a state machine with declared transitions.** DRAFT ↔ EXPLORING →
   PROPOSED → {ACCEPTED, REJECTED}, ACCEPTED → {SUSPENDED, SUPERSEDED}, with every legal
   edge enumerated[^adrreadme-transitions].
2. **Flags are orthogonal to state.** `+EXECUTED` ("decision fully reflected in the
   project") and `+AMENDED` ("substantive change authorized by deciders") combine freely
   with any state, yielding `ACCEPTED+EXECUTED`, `REJECTED+EXECUTED` ("decided against
   and fully removed from codebase"), `SUPERSEDED+EXECUTED`[^adrreadme-flags]. A single
   enum would have needed the cross product.
3. **Mutability is a function of state.** DRAFT/EXPLORING fully mutable; PROPOSED
   "carefully mutable" (versioned changes tracked by deciders); ACCEPTED/REJECTED/
   SUSPENDED/SUPERSEDED **immutable** — "content frozen except typo fixes. Substantive
   changes require +AMENDED flag (authorized by deciders) and are recorded in the Change
   Log and Status Timeline"[^adrreadme-mutability]. The reasoning is archival, and it is
   the same reasoning relata gives for never deleting a provisional item[^adrreadme-immutability]:

   > Once in a decided state … an ADR is a historical record of what we believed and
   > decided at that point in time. This enables: Archaeological understanding ("why did
   > we think this?") · Avoiding re-litigation of settled decisions · Understanding
   > evolution of thinking.

4. **Supersession is bidirectional and both records survive**[^adrreadme-supersession]:

   > When one ADR supersedes another: Set `superseded_by: XXX` in the old ADR's
   > frontmatter · Set `supersedes: YYY` in the new ADR's frontmatter · **Both ADRs
   > remain in the directory (history is preserved)**.

   This is what pass 1 tripped over: the old record is *still there*, still readable, and
   only its frontmatter and a banner say it is dead. A directory-as-table that preserves
   superseded rows requires the reader to check the supersession field — and if the
   reader does not, the table lies to them by omission. **In the general case, a
   directory listing is not a valid query result.**
5. **Two kinds of edge, deliberately distinguished.** `blocked_by`/`needed_for` are
   *decision-lifecycle* dependencies ("waiting for a decision on ADR-008 section 3");
   `related` is conceptual ("this builds on ADR-004")[^adrreadme-edges]. Mixing them
   would make the blocking graph unusable.
6. **Progress lives elsewhere, on purpose.** *"ADRs record **decisions**, not
   implementation status. Whether a decision is 0% or 100% implemented is tracked in
   OPERATA.md, not here."*[^adrreadme-notprogress] — the same record/event split relata
   draws between `entries/` and `verifications/`.

There is also a document-*structure* schema stated in prose (required `## Preamble` and
`## ADR` group headers; `Context`/`Proposals`/`Expected Impact` required within;
proposals numbered P1, P2… "for easy reference within the document and from
OPERATA")[^adrreadme-structure] — which is precisely what ADR-010 proposes to make
machine-checkable (§12.3). The README even permits a documented degradation: "For simpler
ADRs, the remaining sections … can be consolidated under a single `## Additional
Information` header if there aren't many of them."

One transferable convention from the same file, unrelated to schema but too good to
drop[^adrreadme-estimation]:

> **Estimation Convention.** Use **session counts**, NOT calendar time or
> manhours/manmonths: Trivial 0.3–0.5 sessions · Simple 1 · Moderate 2–3 · Complex 4–6 ·
> Major 10–20. This aligns with agent context boundaries and avoids calendar-time
> estimation errors.

---

## 12. Schema over prose

Three instances in the estate apply schema to documents whose *body is prose*. This is
the class UDON is in, and it is where the doc-store pattern stops being a database
analogy and starts being a document-notation problem.

### 12.1 ASF terminology — the pattern in miniature, fully worked

`~/src/arch/asf/terminology/` is 176 entry records plus ~150 decision directories, with
a CLI (`bin/term`) and a generated `LEXICON.md`[^term-layout]:

```
terminology/
├── entries/<slug>.md                    one file per term; filename is the canonical key
└── decisions/<slug>/                    append-only directory of decision events
    └── <ts>-<decider>-<action>.md
```

The entry schema is the richest per-record schema in the estate — and it is
versioned[^term-schema]:

```yaml
slug: control-regret                      # MUST match filename basename
schema_version: 1
term: control regret                      # canonical lowercase prose form
name: Control Regret                      # display capitalization
notation: $\delta_{\text{regret}}$        # LaTeX form (drives NOTATION.md eventually)
brief: Best achievable minus current performance.
layer: prose-symbol                       # slug | prose-symbol | framing-vocabulary | public-api
status: canon                             # working | draft | canon | weak | deprecated | superseded
tags: [core_quantities, diagnostic]       # mixed semantic + flag tags; multi-section render
source_type: asf                          # asf | external | standard | mathematical | philosophical
primary_source: 01-aat-core/src/def-control-regret.md
first_asf_mention: 01-aat-core/src/def-control-regret.md
see_also: [satisfaction-gap]
aliases: []                               # acceptable variants (paired vocabulary, etc.)
do_not_confuse: []                        # external collisions to flag for readers
internal_note: null                       # agent-side metadata; never emitted to LEXICON.md
```

Design decisions worth lifting:

- **Why per-entry files rather than one shared LEXICON.md** — the failure mode of the
  shared file is *silent*: "With one shared markdown LEXICON.md, every concurrent edit is
  a potential merge conflict on the table-row level; the failure mode is silent (a
  malformed table row renders ambiguously). With per-entry files, two agents adding
  distinct terms touch distinct files — git resolves trivially."[^term-whyperentry] The
  shared artifact is then *recovered* as a generated view.
- **Why a markdown body at all** — "The previous LEXICON.md table-cell format flattened
  the *definition* into a one-line gloss. Many terms deserve a paragraph or two of prose…
  The frontmatter carries structured metadata; the markdown body carries the prose
  definition."[^term-whybody] The `brief:` field is the one-line gloss that appears in the
  generated table row; the body is what a reader gets on following the link. **One record,
  two granularities, and the schema knows which is which.**
- **Append-only decision events rather than a mutable status field** — "Mutable status
  fields lose that history (and lose it silently when overwritten)"[^term-whyevents], with
  filenames carrying `<ts>-<decider>-<action>` so concurrent writers never
  collide. Actions form an extensible vocabulary — `canonicalize`, `rename`, `add-alias`,
  `add-cite`, `deprecate`, `supersede`, `update-gloss`, `nuance-flag` — and the CLI
  *"warns on unknown actions but does not block, so new event-type vocabulary can land
  before the CLI knows about it"*[^term-actions]. Outcomes are `committed`/`rejected`/
  `revised`/`superseded`, and *"the latest event per action wins; older events stay as
  the audit trail (never delete)"*[^term-outcomes].
- **Permissive extractor / strict linter** — the principle pass 1 missed and the one most
  worth transplanting[^term-permissive]:

  > `Entry.load` and `bin/term render` do NOT block on schema issues. They load and emit
  > what's there, marking missing required fields as `(missing)`. `bin/term lint` is the
  > place where schema issues, cross-ref issues, and content issues surface as actionable
  > warnings. This separation lets render show the current state of the world even when
  > entries are mid-edit; it lets lint be strict without blocking everyday workflows.

  Three lint severities: ERROR (blocking — slug mismatch, missing `term`/`brief`), WARN
  (missing optional fields, unknown status/layer values), INFO ("no segment references
  the slug — could mean term-only entry, not necessarily a problem")[^term-severities].
  Note the INFO tier exists specifically to report something that *might not be a
  problem* — a category most validators lack.
- **A clobber guard on the generated view** — the renderer "refuses to overwrite a
  destination file that does NOT carry the `Auto-generated` marker on its first ~5 lines,
  unless `--force` is passed"[^term-clobber]. The derived artifact is self-identifying, and
  the generator checks before it writes. For any system that regenerates documents in a
  tree that also holds hand-authored ones, this is the minimum viable safety.
- **The view is a query with declared ordering.** Sections are driven by `tags:` (multi-
  tagged entries appear in *every* matching section, "intentional — let readers find a
  term via any of its semantic anchors"); section order comes from a
  `TAG_DISPLAY_ORDER` constant with unknown tags appended alphabetically; within a
  section, `seq:` ascending then alphabetical by `term:`; `subgroup:` creates named
  sub-tables ordered by their minimum `seq:`[^term-render]. That is `ORDER BY` and
  `GROUP BY` expressed as record fields — the ordering is *data on the record*, not
  logic in the generator.
- **Deterministic field ordering on save.** `Entry#frontmatter_yaml` orders fields
  canonically, "keeps git diffs clean across rewrites"[^term-fieldorder]. A serializer
  whose output order is incidental makes the git-as-history story unusable.

### 12.2 OUTLINE + segments — the instance we are standing on

Pass 1 named this and did not open it. It is the estate's most complete answer to
"directory-as-table applied to prose," it has a written schema spec, and — because
`udon-needs` inherits it — it is the one instance whose design decisions we are
currently living inside.

**The shape.** A component (`01-aat-core/`) holds `src/` — 170 flat segment files — plus
an `OUTLINE.md`. The OUTLINE is literally a sequence of markdown **tables**, one per
chapter, whose columns are `§ | Type | N | Tag | Claim | Stage` and whose `Tag` cell is a
link into the record: `[#def-control-regret](src/def-control-regret.md)`[^asf-outline].
A segment is a record with YAML frontmatter and a prose body[^asf-segment]:

```yaml
---
slug: def-control-regret
type: definition
status: exact
depends:
  - def-value-object
  - def-satisfaction-gap
stage: draft
---
```

**The segment-set principle** is the invariant that makes it a table, and it is stated as
load-bearing for tooling[^format-segmentset]:

> **Every non-`old-*` file in a component's `src/` directory is a segment and conforms to
> the cadence below.** This holds even for drafts, missing-stage entries, or segments
> orphaned from `OUTLINE.md`. … The `old-*` filename prefix is the *only* mechanism for
> placing a file in `src/` that is exempt from FORMAT. … Tools that need the canonical
> segment set … treat `{component}/src/*.md` minus `old-*.md` as authoritative. Adding a
> non-conforming file to `src/` will silently break these tools, so don't.

Three things to take from that. Membership is decided by **directory plus filename
convention** — no manifest, no registry. The single exemption is encoded in the
*filename*, so it is visible in a directory listing and in every diff. And the cost is
stated honestly: the failure mode of violating it is *silent*.

The companion rule is that ordering is not identity[^format-fileorg]:

> **Filename = slug**: `src/{slug}.md`. No numbering in filenames. **Canonical ordering**
> lives in each component's `OUTLINE.md` … not in filenames. The ordering will change as
> the theory develops; **the slug is the stable identity**. **Cross-references** use
> `#slug-name` — everywhere, always.

That is the same conclusion relata reached from the opposite direction (§8.3): position
is volatile, name is stable, and every reference goes through the name.

**Two orthogonal status axes, and an explicit warning against conflating them.**
`type` is a 20-value enumeration of *what kind of claim* this is (postulate, definition,
scope, formulation, derived, result, corollary, hypothesis, normative, empirical,
observation, discussion, measurement, proposed-schema, derivation, worked-example,
detail, sketch, aside)[^format-type]. `status` is an 8-value enumeration of *epistemic
strength* (axiomatic, exact, robust-qualitative, heuristic, conditional, empirical,
discussion-grade, sketch)[^format-status]. `stage` is *"orthogonal to epistemic status.
Tracks where the segment is in our working process, not how strong the claim
is"*[^format-stage].

**Every value in both enumerations links into `terminology/entries/`.** The schema's own
vocabulary is stored as records in the *other* doc-store (§12.1), and `terminology`
carries tags named `segment_types`, `epistemic_vocabulary`, and `process_vocabulary` to
group them[^term-render-vocab]. That is a cross-store join between a schema and its
glossary, and it means renaming a `type` value is a record edit in one store that
propagates to the linter of another. The rationale for the vocabulary is itself
recorded — *"`postulate` (not `axiom`), `result` (not `theorem`), and `derivation` (not
`proof`) avoid the framing that AAT claims foundational mathematical originality where it
does not"*[^format-type] — and it names an exception with a reason: external theorems
keep their original names *"these are other authors' terms and renaming them would
obscure provenance."*

**The duplicated field, and the policy that saves it.** `stage` lives in *both* the
segment frontmatter and the OUTLINE row — a denormalization, and therefore a drift risk.
The spec's answer is the sentence §1.5 leans on[^format-stage-stale]:

> `bin/lint-outline` verifies consistency between the two (mismatches, missing/off-
> vocabulary values, `missing`-vs-file-exists) — **as warnings only, never gate
> failures**: the stage layer is known to go stale quickly under rearranging, pedagogical
> reorientation, and continued refinement, and is currently ignored in practice; **do not
> read low stage values as low epistemic strength** (that's `status`), and do not alarm
> over low acceptance counts.

A duplicated field is permitted, checked, and explicitly *not* trusted. That is a better
answer than either normalizing it away or pretending it is reliable — and `udon-needs`
demonstrates the drift live: its segments carry `stage: drafted (bridge form, 2026-07-22
— absorbed tables now live in the promoted report)`, prose in an enum slot[^udonneeds-seg].

**But warnings-only is a deployment choice, not a property of the field** — and an earlier
draft of this review got that wrong, generalizing one deployment into a rule about
metadata. Joseph (steward, 2026-07-23) states both halves: in `udon-needs`, `stage` is
better understood as a *current-polish-level* state field than as a gate; in other
deployments of the same system — `~/src/arch/logos/`, where papers are assembled and
prepared for **journal submission** — *"the gating action is critical."*

The estate carries the counter-case directly, in the same store family. `logos/refs/` is
a **fourth-generation descendant** of the `neurips/refs` line (§1.2), and its adaptation
note is explicit about what transferred[^logos-provenance]:

> **Adaptation provenance (2026-05-09).** Borrowed from `~/src/neurips/` (the NeurIPS
> 2026 umbrella). The data layout, atomicity contract, and CLI verbs transfer **verbatim**.
> **What does NOT transfer:** the NeurIPS `bin/build` LaTeX pipeline (output format here is
> venue-specific — Synthese is LaTeX/Word; Inquiry is Taylor & Francis — and not yet
> wired).

Same per-entry YAML, same `safe_write`, same append-only verification events, same lint.
And there the lint **gates**: *"`bin/refs lint` is **the anonymization gate before
submission** — it scans every entry and every cited key against the deny-list. Run it
before each Synthese / Inquiry submission."*[^logos-gate] A name that should have been
anonymized and was not cannot be un-submitted.

So the honest generalization is not about the field at all:

> **Whether a check gates is a function of the consuming deployment's stakes ×
> reversibility, not of the field or the schema.** A polish level is revisable at any
> time, so gating on it costs more than it protects and the value rots between reads —
> advisory. An anonymization state at submission is irreversible, so it gates. One schema,
> two enforcement regimes, chosen by the consumer rather than declared by the store.

That reframes what a reader may infer from "the system does not gate on this." It is
evidence about *this deployment's* stakes, not about the field's reliability — though the
two often coincide, and in ASF's case they do: the spec gives the *reason* as staleness
(*"known to go stale quickly under rearranging, pedagogical reorientation, and continued
refinement"*[^format-stage-stale]), which is a claim about the field, alongside the
implicit claim that nothing downstream is irreversible enough to warrant blocking.

This is also the shape of the **enforcement-profile** idea the tooling corpus already
carries — casual / careful / critical as a per-consumer setting rather than a per-schema
one. The doc-store instances in this review are a natural experiment in it: terminology's
render-never-blocks and ASF's warnings-never-fail sit at *careful*; relata's ingest
membrane (nothing enters canonical unvalidated, §7) and logos's pre-submission lint sit at
*critical*; and both pairs run on substantially the same machinery. **The profile belongs
to the deployment; the schema should be able to serve all three.**

**`depends:` is deliberately untyped**, and the reason is worth quoting because the
estate contains the opposite decision too[^format-depends]:

> List the slugs this claim directly depends on. **The type of each dependency
> (definition import vs logical antecedent vs scope assumption) is derivable from the
> referenced file's own `type` field — no typed edges needed.**

Edge type inferred from node type. OPERATA (§16) chose typed edges instead
(`contributes_to` with weights, `blocks`, `related`). Two defensible answers in one
estate: infer the edge from the target when the target's type determines it, name the
edge when the *same pair* can stand in several relations.

**The DAG is the workflow.** Promotion runs in topological order over `depends:`:
*"Promote leaves first, then their dependents. A segment should not reach
`claims-verified` while any of its dependencies is still at `draft` — you cannot verify a
derivation whose premises have not been checked."* Segments are grouped into batches by
DAG depth, parallel within a batch, and downgrade is explicit — *"a segment can be
downgraded (e.g., `candidate` → `draft`) when a dependency changes, an error is found, or
the claim's scope shifts"*[^format-promotion]. Four named gates advance the stage, and
each gate's completion criterion is written out (Gate 1 requires, among other things,
that the dependency be *genuine* — *"not merely 'related' or 'mentioned in
Discussion'"*)[^format-gate1].

**Accepted violations are records, keyed by relation.** `OUTLINE-accepted.md` is a lint
whitelist, and its design is unusually good[^outline-accepted]:

> each table row records one dependency-ordering violation in `OUTLINE.md` that is
> accepted *by design*, with its grounding. The tool still prints accepted violations
> (marked ✓ …) but exits green when only accepted violations remain; any ordering
> violation not listed here stays red. **Rows are keyed by the (segment, depends-on) slug
> pair, so they survive OUTLINE row moves**; if a slug is renamed or the violation is
> otherwise resolved, the row goes stale and the tool reports it as a warning — prune
> stale rows when you see that warning.
>
> To accept a new violation: add a row with the two slugs, the acceptance date, and **a
> reason grounded in a citable record (CHANGELOG entry, decision memo) — not
> convenience.**

Four properties any exception store should copy: keyed by the **relation**, not the
position, so it survives reordering; **staleness is detected and reported**, so dead
exceptions surface instead of accumulating; accepted violations are still **printed**, so
the exception stays visible rather than becoming invisible; and the justification must
cite a **durable record**, which makes "we were in a hurry" unwritable.

**Cross-store referential integrity with stated violation semantics.** Segments cite
experiments as `empirica:<experiment-slug>` optionally `@<run-date>`. The registry is
canon; the contract is that the experiment carries a `MANIFEST.md` *"kept bidirectional
with the citing segments"* and that the claim traces to a recorded run in its `RUNS.md`
with date, parameters, explicit seed, and output. And then the sharp part: *"**An
empirical claim citing an experiment with no matching recorded run is a truth-status
defect.**"*[^format-empirica] A dangling reference is not a broken link — it is a
statement about the claim's truth-status. That is the strongest formulation of
referential integrity found in this review.

**What udon-needs inherited and changed.** Around the same spine it adds the event and
open-item layers — `CHANGELOG.md`, `RESIDUALS.md`, `DEEPENING-CYCLES.md`, `notes/`,
`reports/`[^udonneeds-layout]. The `02-tooling-needs/` OUTLINE keeps the
table-per-part shape and the `§ | Type | Tag | Claim | Stage` columns, but fills `Type`
with a *domain-local* vocabulary — Finding, Principle, Demand, Method, Counterposition —
rather than ASF's theory types[^udonneeds-outline]. The shape is portable; the type
vocabulary is not, and should not be. Its segment frontmatter extends the schema
substantially[^udonneeds-seg]:

```yaml
slug: addressing-is-the-long-pole
type: demand
register: [evidenced, decided]
support-kind: [design, observational, testimonial]
strength: robust-qualitative
convergent: [design, observational, testimonial]
verified:
  - 2026-07-22 · frontmatter-migration · pilot-A · axes assigned from the chapter's claim…
stage: drafted (bridge form, 2026-07-22 …)
consumers: both (udon-primary)
depends: [schema-guarded-mutation, freshness-and-atomicity]
opens: reports/addressing-exploration.md
handoff-routing: feeds the paths design probe (phase 3); …  # auditor apparatus
sources:
  - ../reports/addressing-exploration.md  # the body report this bridge opens
  …
```

Three additions worth naming. ASF's single `status:` becomes **three axes** — `register`
(how the claim was arrived at) × `support-kind` × `strength` — plus a `convergent:` list
naming *which independent legs agree*; that is §17's "record the vector, not the verdict"
applied to prose. The `verified:` field is an **event log embedded in the record**, where
terminology and relata put events in sibling directories — a third answer, cheaper to
write and harder to append concurrently. And `sources:` carries per-entry inline comments
explaining *why* each source is listed, which is provenance a bare list cannot hold.

### 12.3 Markdown *structural* schemas — the piece closest to UDON

autopax ADR-010 proposes validating markdown **structure**, not just frontmatter — a
Ruby DSL declaring heading hierarchy, required sections, and content block
types[^adr010-p1]:

```ruby
Autopax::MarkdownSchema.define(:adr) do
  frontmatter schema: Autopax::Schemas::AdrFrontmatter   # delegates to Schemacop (ADR-008)

  structure do
    h1 :title, pattern: /^ADR-\d{3}:/, required: true

    h2 "Preamble", required: true do
      h3 "Status Timeline", required: true
      h3 "Change Log", required: false
    end

    h2 "ADR", required: true do
      h3 "Context", required: true do
        paragraph min: 1              # At least one paragraph
      end
      h3 "Proposals", required: true do
        h4 min: 1                     # At least one proposal subsection
      end
      h3 "Expected Impact", required: true
    end
    …
  end
end
```

with a second schema shown for agent AXIOMATA documents using `list type: :unordered,
min: 1` and `any min: 1  # Flexible content`[^adr010-p1]. Note what the vocabulary
quantifies over: **headings (by level, by literal text, or by pattern), and content
blocks (paragraph, list, `any`) with cardinality**. That is a content model for prose
documents expressed as a schema — a direct precedent for anything UDON does with
document-shape validation, and the natural machine-readable form of the ADR structure
that §11 states in prose.

The second proposal is the one with the most agentic leverage[^adr010-p2]:

> **P2: Schema-Derived Example Generation.** Schemas should generate canonical examples
> showing AI agents exactly what output to produce:
> ```ruby
> schema  = Autopax::MarkdownSchema[:adr]
> example = schema.generate_example(title: "ADR-999: Example Title", placeholders: true)
> ```

A schema that can emit a filled skeleton is a schema an agent can *conform to* without
reading the schema — the same move as `_schema`-in-the-document, run in the other
direction. Status is EXPLORING and it is `blocked_by: ["[[008]]"]`[^adr010-frontmatter],
so this is an unbuilt proposal; cite it as a design, not a capability.

---

## 13. Resources as agent tools

rowan exports Resource actions as LLM tool definitions — pass 1 has nothing on this, and
it is the most direct bridge between the doc-store material and the agentic-tooling
program. The motivation is drift[^toolexport-problem]:

> When you add a field, you update the model and forget to update the tool schema. When
> you change a validation, the tool schema lies about what's valid. The two drift.

`User.to_tool_definitions` emits Anthropic- or OpenAI-shaped tool schemas derived from
the resource[^toolexport-api]. From the Resource in §5's style, the emitted shape
is[^toolexport-output]:

```ruby
User.to_tool_definitions
# => [
#   {
#     name: "create_user",
#     description: "Create a new User",
#     input_schema: {
#       type: "object",
#       properties: {
#         email: { type: "string", pattern: ".*@.*" },
#         name:  { type: "string" },
#         role:  { type: "string", enum: ["admin", "user", "guest"], default: "user" }
#       },
#       required: ["email", "name"]
#     }
#   },
#   { name: "read_user",    description: "Query Users",       input_schema: { ... } },
#   { name: "update_user",  description: "Update a User",     input_schema: { ... } },
#   { name: "destroy_user", description: "Delete a User",     input_schema: { ... } }
# ]
```

**Each action becomes a tool**, and the constraint vocabulary of the schema (§5) surfaces
directly as the tool's JSON-Schema constraints — `pattern` from a format constraint,
`enum` from an enum type, `required` from nullability. The mechanics that matter:

- **Descriptions have a declared sourcing priority** — action description from the DSL,
  else auto-generated ("Create a new User"); attribute description from the DSL, else a
  type-based hint ("UUID identifier", "ISO 8601 date-time")[^toolexport-descriptions].
  A tool schema with no descriptions is useless to an LLM, so the fallback matters more
  than the primary.
- **A declared type map to JSON Schema**, including the non-obvious cases: `:decimal` →
  `"string"` "(precision preserved)"; `:uuid*` → `"string"` with `format: "uuid"`;
  `:atom` → `"string"`[^toolexport-typemap].
- **Constraint mapping**: required attributes → the `required` array; enum constraints →
  `enum`; min/max on integers → `minimum`/`maximum`; and an honest limitation — "Nested
  relationships → Not currently exported"[^toolexport-constraints].
- **Field exclusions are a three-way policy**, and the middle one is the interesting
  one[^toolexport-exclusions]:

  > - `:private` attributes are excluded from tool schemas
  > - `:sensitive` attributes are **included but marked in description**
  > - `:readonly` attributes excluded from create/update tools

  "Sensitive" is not "hidden": the agent is told the field exists and that it is
  sensitive. Excluding it would make the agent guess; including it silently would make
  the agent careless.
- **An explicit non-guarantee**[^toolexport-security]:

  > Tool export generates schemas but does **NOT** enforce authorization. The calling
  > application must: validate actor permissions before invoking exported tools · pass
  > `actor:` context to Resource.create/update for policy checks · rate-limit tool
  > invocations at the API layer.

The generalizable claim: **if the schema is the single source of truth, the agent
interface is a projection of it** — the same relationship the store has to the resource
(§2.2), and the same relationship `LEXICON.md` has to `terminology/entries/` (§12.1).
Three projections, one declaration.

---

## 14. Implementation reality — what actually ships

The brief flagged docs-only reading as pass 1's real limit. This section is the ledger a
consumer needs in order not to cite a vision as a capability.

**Shipped and exercised in rowan** (verified in `lib/`, and cross-checked against the
plan's own status list[^evolution-status] and MAP.md[^map-tracks]):

| Capability | Evidence |
|---|---|
| Four store adapters — memory, sequel, yaml_frontmatter, jsonl | `lib/archema/store_adapters/*.rb` |
| `was:` renames applied on read by document adapters | `yaml_frontmatter.rb:385-404`[^yamlfm-renames] |
| `schema_id` / `schema_version` / `full_schema_id` → `_schema` | `versioning.rb:73-106`[^versioning-dsl] |
| `upcast from:` blocks with multi-version chaining | `versioning.rb:166-251`[^versioning-upcastpath] |
| `backward_compatible_with` / `forward_compatible_with` / `check_compatibility` | `versioning.rb:118-271`[^versioning-compat] |
| Attribute lifecycle `since:` / `deprecated:` / `removed:` | `attributes.rb:31-35,112-220`[^attributes-lifecycle] |
| Schema history, differ, snapshot, migration generator, watcher, decision log | `lib/archema/schema/*.rb` |
| Runtime `evolve` with mutex + auto minor bump (ADR-004 Phase 3) | `versioning.rb:304-326`[^versioning-evolve] |
| Memory-adapter schema versioning (ADR-004 Phase 2) | commit `e5d2e3f`[^map-tracks] |
| MultiStore unified into StoreComposition; ~914 lines deleted | ADR-001 step 6[^adr001-unify] |
| JSONL hash-chaining + tombstones + `verify_chain!` | `jsonl.rb:328+`[^jsonl-hashchain] |
| Tool export (Anthropic + OpenAI) | `lib/archema/agentic/tool_export.rb` |

**Designed but not built** (cite as direction, never as capability): RDBMS
expand-contract with sync triggers · automatic monitoring and the `.archema/transitions/`
file · `as_of` temporal queries on data or schema · the `# {{replaces: :name}}` agent
annotation · relationship refactorings · the full refactoring-catalog
automation[^evolution-status] · dig-style relationship filter paths (ADR-002 is
Draft)[^map-adr002-planned] · markdown structural schemas (ADR-010, EXPLORING and
blocked)[^adr010-frontmatter] · the Naive Agent Panel extension to the simulation
pipeline[^hallway-pipeline].

**Divergences between docs and code, found by reading both:**

- Schema-history layout (correction C4).
- `_schema` vs `_schema_version` across adapters (correction C6).
- The plan's §6.6 multi-store example still uses the `data_layer :yaml_frontmatter,
  role: :primary` form[^evolution-multistore], which ADR-001 **deprecated and removed**
  in December 2025 in favour of `def_store` + `store :name`[^adr001-deprecated]. The
  design doc was not updated when the DSL changed. Anyone lifting that snippet would
  write dead syntax.
- autopax's `AgentCard` comment says "`schema_field` enables automatic versioning and
  upcasting of older agent cards"[^agentcard-comment], but the class declares neither
  `schema_id` nor `schema_version`, so it takes the defaults (`agent-card/1.0.0`) and has
  no `upcast` blocks; the actual version check is a hand-rolled string equality against
  `SUPPORTED_VERSION = '1'` in the path-mode validator[^agentcard-validator]. The comment
  describes the capability the store *offers*, not what this resource *uses*.

**Liveness, by repo:**

| Repo | Commits | Span | State |
|---|---|---|---|
| autopax | 534 | 2025-11-15 → 2026-04-26 | Dormant since 2025-12-20 (doc touch-ups after) |
| rowan | 264 | → the archema→rowan rename | Substantial; last work is usability/simulation + ADR-004 phases |
| relata | 148 | 2026-05-13 → 2026-07-13 | **Live**; most recent estate work in this class |
| neurips/refs | — | 2026-05-05 → | Delivered its papers; the progenitor |
| asf/terminology | — | 2026-05-08 → 2026-07-15 | Live; README updated 2026-07-15 |

The weighting that follows: for *design theory*, rowan is deepest. For *what a doc-store
must do when real agents write into it*, relata is both deepest and most current. For
*what the ELI document types demand*, autopax states the requirement and nothing more.

---

## 15. The "lite" instances — directory-as-table already ships everywhere

Beyond the five first-class realizations, the pattern is running in the tooling Joseph
uses daily:

- **Claude's own memory** — `~/.claude/memory/<cluster>/<principle>.md` records, a
  `MEMORY.md` index (the materialized view), `[[wikilink]]` joins resolving by basename,
  and `CLAUDE.md` autoload as the always-resident projection. Project-scoped memory dirs
  mirror the shape. The global index states the composition rule explicitly — global
  index + on-demand detail files + project-scoped memory — and treats a detail file's
  *existence* as evidence about what the reader does not already hold. It is a doc-store
  whose read path is "inject the index always, the records on demand."
- **Grok's memory** — a doc-directory plus a **relational/vector index over it**. Global
  `~/.grok/memory/MEMORY.md`, per-workspace `~/.grok/memory/<project-slug>-<hash8>/`, and
  per-session logs under `sessions/`; an **SQLite index enables fast hybrid search (FTS5
  keyword + optional vector KNN) across all memory files**[^grok-sqlite]. Four details
  refine pass 1's paragraph:
  - **The workspace key is derived, not chosen**: "The hash is derived from the git
    remote URL so all clones and worktrees of the same repository share the same memory
    directory"[^grok-hash]. Identity of the *project* is defined by its remote, which
    makes the address stable across every local path it is checked out to — a direct
    answer to the same question UDON's project-root work is asking.
  - **The index is subordinate to the files**: a watcher (`watcher.enabled`, default
    true) "watch[es] `~/.grok/memory/` for external edits and reindex[es] on
    search"[^grok-watcher]. The documents stay canonical and hand-editable
    (`grok memory edit`); the index is derived and self-healing.
  - **Records are chunked**: `grok memory stats` reports "file count, **chunk count**,
    and index size"[^grok-stats] — the retrieval grain is finer than the record grain.
  - **Retrieval is a scored query with thresholds**: `search.min_score` (0.35),
    `search.max_results` (6), and a separate first-turn `initial_injection` block with its
    own threshold[^grok-config].

  This is rowan's three-worlds unification realized at the memory layer: keep the
  documents canonical, put the query index beside them, and let the index be
  reconstructible. Strong prior art for exactly that arrangement.

---

## 16. OPERATA — intent management as a doc-store, and the principles behind it

The autopax ADR system (§11) separates *decisions* from *progress* and says progress
lives in `OPERATA.md`. Pass 1 never asked what OPERATA was; pass 2 discovered the hard
way that it is the store that answers "is it built?" (C3). It turns out to be a designed
system with its own research corpus, and it is a **fourth and fifth independent arrival**
at the doc-store pattern — from task management and from first-principles design
respectively, both in **November 2025**, six months before the `neurips/refs` line.

### 16.1 The prior-art survey — a fourth arrival at file-per-record

A 2025-11-26 research document surveys hierarchical task CLIs and reaches the same
storage conclusion from an entirely different problem[^operata-system]:

> **dstask** provides the best git-friendly model: **one YAML file per task** with
> UUID-based filenames, designed to avoid merge conflicts. Its sync approach
> (`dstask sync` = pull + push with auto-merge) demonstrates passwordstore.org-style
> distributed state management.

and states the trade explicitly, in a table that rhymes with §3's but weighs *query* more
heavily because a task system reads far more than a bibliography[^operata-storage]:

> | Approach | Git-Friendliness | Query Performance |
> |---|---|---|
> | File-per-task YAML | **Excellent** (line-level diffs) | Slower (many files) |
> | Monolithic YAML | Poor (merge conflicts) | Fast reads |
> | SQLite | Bad (binary) | Best for queries |
> | JSON Lines | Good (append-only) | Moderate |
>
> **Recommended structure:**
> ```
> .operata/
>   tasks/
>     01863d24.yml   # File per task, UUID-named
>     01863d25.yml
>   index.yml        # Regenerated fast-lookup index
>   graph.yml        # Explicit dependency graph (optional cache)
> ```

Canonical records plus **two regenerable derived artifacts** — an index and a graph
cache — is the same canonical/derived split as `LEXICON.md`, `_emitted/*.bib`, and
grok's SQLite index (§15), arrived at independently. The survey's honest gap finding is
also worth keeping: *"**No existing tool supports speculative/draft task
decompositions.** Workarounds involve `+draft` tags or separate planning files, but no
native 'try multiple approaches' capability exists."*[^operata-gap]

### 16.2 Identity: two identifiers with different jobs

The identity design is the most directly path-relevant material in the OPERATA
corpus[^operata-identity]:

> The identity scheme should combine **UUID7 for stability and sortability** with
> **Base58 short prefixes for CLI ergonomics.** … **Short prefix handling** follows git's
> model: minimum 4 characters for `ops show sMHu`; 4-char Base58 = ~11.3M unique values;
> **collision detection: if multiple matches, require longer prefix or display
> candidates**; auto-extend … **Base58** (Bitcoin's alphabet) excludes confusing
> characters (0/O, I/l), making it ideal for human-visible IDs.
>
> **Hybrid content-hash pattern**: Store both stable UUID (for references) and content
> hash (for integrity/deduplication):
> ```yaml
> task:
>   id: "01863d24-6d1e-78ba-92ee-6e80c79c4e28"
>   content_hash: "sha256:abc123..."  # Changes when content changes
>   version: 3
> ```

Two identifiers, two jobs: **the UUID answers "is this the same thing?", the content hash
answers "is this the same content?"** — precisely relata's bibkey-vs-sha split (§8.1),
and precisely the distinction UDON's `@`-form has to make. The abbreviation design is the
other half: a short prefix is an *ergonomic view* of a full identifier, collisions are
detected and reported as candidates rather than resolved silently, and the display length
auto-extends. That is the resolution ladder (§8.2) at the level of a single identifier.

### 16.3 Structure: one primary parent plus typed soft links

The tree-versus-graph question is answered with a hybrid, and the reasoning is the
part to keep[^operata-graph]:

> Pure trees can't model cross-cutting concerns — the solution is a **DAG with explicit
> soft links**. **What trees can't represent**: a "Fix security vulnerability" task that
> contributes to Security, Performance, and Compliance goals simultaneously; diamond
> dependencies; "related to" relationships without hierarchical ownership.
>
> **Recommended model**: One primary parent (preserves tree traversal) plus typed soft
> links:
> ```yaml
> task:
>   id: security-fix
>   parent: security-initiative  # Primary ownership
>   contributes_to:
>     - goal: q4-release
>       weight: 0.3
>   blocks: [release-1.5]
>   related: [performance-audit]
>   tags: [security, urgent]
> ```

**One primary parent preserves tree traversal**; the graph rides on top as typed,
optionally-weighted edges. Compare ASF's untyped `depends:` (§12.2): OPERATA needs typed
edges because the *same pair* of nodes can stand in several different relations
simultaneously, which is exactly the condition under which type-inference-from-target
fails. The two decisions together give a usable rule: **infer the edge type from the
target when the target's type determines it; name the edge when one pair can hold
several relations at once.**

### 16.4 The ten principles

A 2025-11-14 synthesis argues design invariants for intent-management systems from AI
planning, military command theory, organizational design, PKM, distributed systems, and
cognitive science[^operata-principles]. It is explicitly *"not a prescription but a
persuasive argument for why certain design invariants matter."* Five bear directly on
document stores:

- **P1 — Preserve intent, not just state.** *"Systems that capture *why* a change
  occurred … enable fundamentally different capabilities than systems that merely record
  *what* changed"* — the difference is *"between a photograph and a film, between data and
  narrative."* Temporal tables *"tell you when something changed but not why it changed or
  what the user's intent was."*[^operata-p1] This is the argument under every append-only
  decision/verification/calibration directory in this review.
- **P2 — Stable identity through continuous change**, and it states the addressing thesis
  six months before relata's aliases shipped[^operata-p2]:

  > If the system replaces the original task with its refinements, **all external
  > references break.** Links from other documents, mentions in chat threads, calendar
  > entries — all now point to nothing. Worse, the evolution itself — the moment of
  > discovery that this was more complex than anticipated — becomes invisible. You've lost
  > the trail of understanding.
  >
  > The solution: immutable identifiers. When Task X expands into subtasks, X persists as
  > the parent node. External references remain valid. **The refinement is captured as
  > edge creation (X decomposes-to [A, B, C, D]), not node replacement.**

  *Refinement is edge creation, not node replacement* is the sentence. relata's `aliases:`
  (§8.3) is the recovery mechanism for the case where this was violated; P2 is the
  prevention.
- **P3 — Trust requires completeness.** A system becomes a reliable cognitive offload
  *"only when users believe it contains everything relevant and will surface the right
  information at the right time"*[^operata-p3] — the argument for why partial adoption of
  a record store is worse than none.
- **P5 — Emergent structure over imposed hierarchy.** *"What folder does 'Q3 Marketing
  Campaign' live in? … The item naturally belongs in multiple organizational schemes, but
  the system permits only one. The solution isn't to pick 'the right' hierarchy — it's to
  recognize that rigid hierarchies are the wrong abstraction."*[^operata-p5] The
  multi-tag-multi-section rendering in `terminology` (§12.1) is this principle executed.
- **P10 — Surface problems, don't enforce solutions**, which is the general form of
  "permissive extractor / strict linter"[^operata-p10]:

  > There's a critical distinction between a system that says "these two intents conflict"
  > and one that says "you cannot create this intent because it conflicts with an existing
  > one." **The first surfaces information and trusts the actor to reason about it. The
  > second assumes the system knows better than the actor** about the right resolution.

  Every non-blocking check in this review — terminology's render-independent-of-lint,
  ASF's warnings-never-gate-failures, `OUTLINE-accepted`'s print-but-pass, relata's
  `.needs-review` — is an instance.

The remaining five: P4 actionability as a gradient not a binary; P6 perspectival focus
and context-dependent Schwerpunkt; P7 temporal dimensions and hypothesis exploration
*"that doesn't pollute the main timeline"*; P8 dependency awareness without
over-constraint; P9 *"the system itself must be simple enough to maintain with minimal
cognitive overhead, even as the content it organizes grows arbitrarily
complex"*[^operata-principles-rest].

---

## 17. The evidence model — record the vector, not the verdict

relata's `TODO-ingest.md` §7 is the largest thing pass 1 left unread, and it is the
deepest treatment of *confidence as schema* in the estate. It also states, up front, why
it is over-built for a bibliography[^relata-7-purpose]:

> This is the heart of the design. It is written at length on purpose: the machinery for
> combining heterogeneous evidence into a calibrated belief, with soft refutations and a
> labeled feedback loop, is **rehearsal for calibrating epistemic gain and belief-update
> for real entities**. The rigor here is not gold-plating a bib tool; it is practising the
> thing that has to be right later.

and again, later, as the acceptance bar[^relata-78]:

> the evidence ledger, the soft-veto-as-likelihood, the labeled feedback loop *give us
> intuition for calibrating epistemic gain and belief-update for real entities*. **The
> bibliography is the safe sandbox; the discipline is the deliverable.** This is the
> worthiness bar for this section — not "does it pick the right PDF," but "**is the
> epistemics one we would trust when the stakes are not PDFs.**"

### 17.1 The schema decision: a scalar destroys what calibration needs

The load-bearing move is a schema decision, and it generalizes far past
bibliography[^relata-71]:

> The scalar `identification_confidence` is **not** enough — calibration needs the
> *evidence vector*, not just the posterior it produced. So record the ledger:
>
> ```yaml
> pdf:
>   identified_by: doi-exact           # dominant factor, for quick scanning
>   identification_posterior: 0.991    # P(this entry | evidence); derived, not set
>   identification_ledger:             # the full vector — the calibration datum
>     - factor: doi-exact;        outcome: match;    woe: +6.4
>     - factor: title-semantic;   outcome: 0.94-sim; woe: +2.1
>     - factor: author-year;      outcome: match;    woe: +1.3
>     - factor: prior-no-pdf;     outcome: n/a;      woe: +0.9   # prior, flagged
>     - factor: isbn;             outcome: absent;   woe:  0.0
>   identification_refutations: []     # standing CONFLICT factors, if any
>   identified_at: '2026-05-15'
>   identified_by_actor: claude        # who/what ran the ingest
> ```

Note `identification_posterior: … # derived, not set` and the separate human-scannable
`identified_by` naming only the *dominant* factor. Three fields at three grains: a
one-word summary for scanning, a derived scalar for thresholding, and the full vector for
recalibration. **A derived scalar cannot be un-derived; storing only the verdict makes
the deriving rule permanently unfalsifiable.** This is the same instinct as udon-needs'
three-axis frontmatter (§12.2) and the direct answer to why a bare `confidence: 0.9`
field is a schema smell.

### 17.2 One rule, no tiers

> ```
> logodds(E)  =  log prior-odds(E)  +  Σ_i  woe_i
> ```
> where `woe_i` is the **weight of evidence** of factor `i` — I.J. Good's term …
> **Accept the top candidate iff its posterior ≥ τ_high. That is the entire decision** —
> no per-factor thresholds, no tier table.[^relata-72]

with a synthetic candidate `NONE` ("not in relata / propose-new") competing in the same
comparison — the same move as `Designator`'s `:none` being a real outcome rather than an
error (§8.1). And **priors and likelihoods are held strictly separate — *"this separation
*is* the un-tangling"*** — with priors *"flagged as such in the ledger — never mixed into
the content-identity product"*[^relata-72].

### 17.3 Refutation falls out of Bayes; the earlier hard veto was a modelling error

> Each identifier comparison has three outcomes, each with its own `woe` … A refutation is
> simply the **CONFLICT outcome's `woe`** — a large *finite* negative term in the same
> sum. Nothing special-cased. … The earlier "hard veto" was wrong precisely because it
> **implicitly set `b = 0`** (claimed misextraction impossible), which is false. "An
> abundance of corroboration can overcome it" is then just arithmetic. … **Absence is
> never refutation** (no DOI extracted ≠ DOI refutes); only a positively-extracted
> *conflicting* strong identifier is.[^relata-73]

Two operational consequences. A standing refutation *"does **not** block acceptance"* but
**suppresses the early-exit path** — *"a contradiction is the signal to gather *more*
evidence, never to stop early"* — and if outweighed, *"the conflict is recorded (not
erased) and surfaced as a latent-bib-error finding."*[^relata-73] Contradiction is
retained as data about the *corpus*, not discarded as noise about the decision.

The factor design carries the same care[^relata-74]: **ISBN is asymmetric on purpose**
(ISBN-match is strong positive; ISBN-of-a-different-*edition* is only a soft negative,
distinct from ISBN-of-a-different-*work*); **filename tokens are `woe ≈ 0` by design**;
and **attestation is evidence, not override** —

> A casual claim is moderate **+** `woe`; `--attest-verified` raises that `woe` … But it
> is *evidence, not override*: an attestation contradicted by a strong extracted
> identifier nets to escalate-and-ask, **never silently encodes a human error as ground
> truth. Truth-honoring is structural here.**

That last one is the principle any human-in-the-loop store needs: a human assertion enters
the same ledger as every other factor, with a *better* likelihood ratio, and can still
lose. Related: ingest must never *"silently write `coverage: full`"* when the evidence
suggests a sample standing in for the full work — *"Silently attaching a sample as the
full work … is the precise failure the `coverage:` field was created to prevent."*

### 17.4 Build the principled version because the fallback is its special case

> The geometric mean of per-factor scores … is *exactly* the `woe` sum with equal weights,
> a flat prior, and a normalization. So we do not build two systems: we build the `woe`
> ledger; "geometric mean over 5–6 factors" is what it *reduces to* if every weight is
> forced equal and the prior flat. **The principled version costs no more than the
> fallback.**[^relata-75]

A reusable argument shape: when the simple thing is the degenerate case of the principled
thing, the cost comparison is not simple-versus-principled but *principled-versus-
principled-plus-a-later-migration*.

### 17.5 Seeds must be defended, and the loop catches bad ones

Hand-seeded priors are permitted under a stated discipline[^relata-77]:

> **each seed carries a written justification** — the base rate it estimates, the reasoning
> for its magnitude, and what evidence would revise it. A bare constant with no defended
> derivation is not acceptable; a seed with `# b≈0.02: misextraction ~ P(DOI in extraction
> region but from a cited work | scoped to masthead); est. from a 50-PDF spot audit, revise
> after first calibration batch` is. **Effort to justify precedes the number, not the other
> way round.**

and the review instruction that follows from it: *"judge the reasoning, not the constants
— and the residual-uncertainty notes are part of the deliverable, not
hedging."*[^relata-710]

The loop then ran, and it worked as designed — catching the seeds[^relata-calibration]:

> `firstauthor+year(±1)` empirically near-noise (**+0.114 vs seed +2.5**; fires 355/355
> positives and 88/98 negatives) and `doi-exact`'s P(IS) is closer to **~43% than the
> seed's 95%** because many corpus entries have no DOI field at all. Both are
> present-truth findings, **not adoption recommendations — review-before-edit.**

A hand-set prior 20× too confident, found by the calibration loop rather than by
argument. And adoption stays manual: *"Adopting a fit = a deliberate human edit to
`EvidenceLedger::Defaults::SEED_WOE` after Joseph reviews a refit's reasoning + counts +
warnings — **never automatic**."*

Three engineering lessons recorded alongside are worth carrying verbatim[^relata-calibration]:

> - **Ledger-key serialization across the boundary.** `EvidenceLedger#to_h` uses
>   **symbol** keys; YAML round-trip via `safe_load` gives **string** keys. … Bridge at the
>   producer so in-memory harness events and disk-loaded events have the same shape.
> - **`EntryMatcher` returns `{ key => [reasons] }`, not `[entry, reasons]` pairs.** First
>   harness draft assumed the latter and crashed on a real run; **the suite passed because
>   the structural tests use synthetic events that bypass the matcher.** Lesson:
>   integration paths need at least one smoke test against the real corpus, not just unit
>   isolation.
> - **The harness's "compare-E-to-itself" positives are tautologically self-matching** and
>   inflate per-factor ratios. … Until then the proposal's magnitudes are biased high on
>   the positive side — **Joseph reads the COUNTS, not the proposed numbers**, to judge the
>   loop.

The first is the classic doc-store boundary bug: a record that round-trips through YAML
comes back with a different key type than the one that never left memory. The second is
the sharper one — **a test suite built on synthetic records will pass while the real-corpus
path is broken**, because the synthetic fixtures bypass exactly the component that
integrates with the store.

---

## 18. What this means for **paths** (intake for `../paths-ideation/`)

Threaded to the seed doc's own sections, and substantially revised now that the estate's
actual path work is in hand.

- **A path language is a schema statement.** §9.2's result is the one to build on: path
  expressions are morphism compositions over the schema-as-category, and they express a
  *proper subset* of relational algebra — the subset the declared structure underwrites.
  This reframes "how expressive should UDON paths be?" as "what does a UDON document
  declare?", which is a better question and a checkable one.
- **The escape hatch enriches the schema, not the query.** When a path cannot express
  something, the move is to declare a new navigable path backed by whatever computation
  is needed — not to bolt a more powerful query surface on. §9.3.
- **Paths as data, not syntax.** ADR-002's rationale (serializable, validatable against
  the schema, no parser, precise "failed at step 2 of […]" errors) is a genuine
  alternative to a string micro-syntax, and the tradeoff is stated: it is verbose in
  source and unambiguous in transit. §9.4. Whether UDON wants the *surface* to be
  data-shaped or merely the *transport* is the live question.
- **Directory-as-table is `||type[key]` at the filesystem altitude.** `path_for(key)` and
  `glob("*.yml")` are literally relational-first lookup and `all()` over a directory. The
  seam-dissolves/resource-as-node bet is already lived: the ASF terminology dir, relata's
  `entries/`, autopax's agent registry, and the CHRONICA JSONL are directories addressed
  by key with per-record structure inside.
- **Record-vs-resource is FRBR, and the boundary rule is consumer-defined.** §4.1's
  resolving principle — *two files belong to the same entry iff a careful reader
  following a citation to either reaches the same content at the same locators* — is the
  reusable form. Interchangeability is defined by what the reference is *for*, not by
  byte or metadata equality. The minimal schema that expresses it is three fields and one
  relation.
- **Rigidity is a spectrum and belongs in the design.** §8.1. UDON's `@` needs the same
  taxonomy: which forms are rigid (own-namespace keys), which are near-rigid (external
  identifiers that the world can duplicate), which are descriptions that may designate
  zero, one, or many. And the resolution result should carry the *kind* even when it
  fails.
- **Plural and failed resolution are first-class outcomes.** `:unique` / `:choices` /
  `:none`, with the requested input preserved. §8.1–8.2.
- **Resolution is a ladder, not a function, and the caller's nature is detectable.** The
  five tiers, with non-TTY callers getting JSON plus a non-success exit code so an agent
  can decide and re-invoke. §8.2. For UDON this is the shape of "resolution as a consumer
  menu": the *same* reference resolves differently depending on who is asking and how
  much confidence is available, and the degradation must never be silent.
- **Addresses must outlive renames, and the mechanism is small.** Aliases as a
  first-class field, uniqueness enforced across the merged key+alias namespace,
  resolution returning `[record, requested_name]`, and a hard invariant that the
  alias-wearing copy is emission-only. §8.3. The empirical case (§8.4) is the strongest
  argument in the whole review for taking this seriously up front.
- **Beware auto-minted disambiguated keys.** §8.4's systemic cause — synthesizing a
  disambiguated key on collision instead of routing into an identity check — is a
  failure any addressing scheme with automatic naming will reproduce. Collision-avoidance
  and identity-resolution are opposite operations that look identical at the call site.
- **Two addressing modes over one record type has a real cost.** §8.5: autopax's registry
  mode and path mode diverge in what services they get, and the path mode re-implements
  validation. If UDON supports both canonical-key and arbitrary-path addressing, the
  services must be shared or they will drift.
- **Anchors: code-root vs data-root vs blob-root.** §4.3's deliberate three-tree
  separation is a concrete anchor-menu datum, with motives (separate backup strategies,
  "opaque to outside consumers", large-bytes routing by size × recoverability) that are
  the same address-stability-under-motion concern the `⊤`/`¤` project-root work is
  chasing. Grok's remote-derived workspace hash (§15) is a second, different answer to
  the same question.
- **Two identifiers with different jobs.** OPERATA's UUID-for-reference plus
  content-hash-for-integrity (§16.2) and relata's bibkey-plus-sha are the same split:
  *is this the same thing?* and *is this the same content?* are different questions and
  need different fields. A single identifier answering both is why "did the file change"
  and "is this still the same document" get conflated.
- **Abbreviation is a view, and collisions are candidates.** OPERATA's git-style 4-char
  Base58 prefix with collision-detection-and-display and auto-extend (§16.2) is the
  resolution ladder applied inside one identifier — and the alphabet choice (excluding
  0/O, I/l) is a reminder that human-visible identifiers have a legibility spec.
- **The record stores a logical token; resolution happens at runtime.** relata's entries
  keep `path: "pdfs/<key>.pdf"` as an opaque token resolved against a configurable root,
  which let the entire blob tree move out of the repo with **zero record edits** (§4.3).
  If a UDON reference ever names a physical location, that location becomes unmovable.
- **One outward-facing address; everything else opaque and relocatable.** The spool is
  the only filesystem surface outsiders address (§4.3); canonical and blob trees are
  explicitly "opaque to outside consumers."
- **Ordering is not identity.** ASF: *"No numbering in filenames … the ordering will
  change as the theory develops; the slug is the stable identity"* (§12.2). Position
  lives in the OUTLINE, which is allowed to churn.
- **One primary parent plus typed soft links, versus untyped `depends:`.** §16.3 and
  §12.2 are two defensible answers, and together they give the rule: infer the edge type
  from the target when the target's type determines it; name the edge when one pair can
  hold several relations at once.
- **Refinement is edge creation, not node replacement** (§16.4, P2). The prevention for
  which relata's aliases are the cure.
- **A dangling reference can be a truth-status defect, not a broken link.** ASF's
  `empirica:` contract (§12.2) is the strongest referential-integrity formulation found.
- **Versioning is why an address must not rot.** `was:` / `upcast` chains /
  schema-history / `since:`/`removed:` are the mechanisms that let a key keep resolving
  across a schema change, and §6.6's asymmetry is the key insight for a document format:
  **in a document store, contraction never happens** — read-time translation persists
  indefinitely, so the cost of an old address never expires and neither does its
  resolution.
- **The materialized-view generation is addressing → derived document.** LEXICON from
  `terminology/entries/`, `_emitted/*.bib` from relata, `MEMORY.md` from memory files:
  a query over a directory-table emitting a document, with declared ordering, grouping,
  and a clobber guard (§12.1). That read path is the `skeleton`/`glance` product one
  altitude up — and the ordering being *data on the record* (`seq:`, `subgroup:`,
  `tags:`) rather than logic in the generator is the part to copy.

---

## 19. What this means for the **agentic-tooling corpus** (intake for `../../udon-needs/`)

- **Collection-as-database is a *demand*, not just a pattern.** Every ELI document type
  (SIGNUM/AXIOMATA/CHRONICA/MEMORATA/OPERATA/agent-cards) wanted it, and the ad-hoc
  alternative produced an explicit "architectural knot" that blocked four
  ADRs[^adr012-knot]. That is direct evidence for a chapter the tooling report lacks.
  Weight it correctly, though: the knot is *documented demand*, and the proposed exit was
  never ratified or wired up (correction C3).
- **The write-membrane, with its two-outcome distinction, is the flagship transferable
  design.** §7. `.rejected` (submitter erred) and `.needs-review` (system's own
  uncertainty) are different speech acts; a machine-readable marker plus a human-readable
  sidecar for each; the happy path untouched. This is `schema-guarded-mutation` realized
  at collection scale, and the two-outcome split is a genuinely new contribution to it.
- **A machine-writable decision channel exists and has a shape.** §6.5: the agent embeds
  `# {{replaces: :name}}` in the artifact, a watcher harvests it, the decision is promoted
  into a durable append-only log with an `agent_id`, and the annotation is **stripped from
  the source**. Annotation-as-message rather than annotation-as-state. The decision log's
  third stated purpose — *"future heuristics could train on decision patterns"* — makes
  the audit trail a training corpus, which is the same move relata makes when it refuses
  to build a separate ingestion log because the verification event *is* the calibration
  datum (§7).
- **Hallway usability testing is a complete, grounded methodology and should be lifted
  wholesale.** §10.2–10.3: `k*` as learning cost, convergence with a three-way reading,
  four phases with documentation-delta as the measure of documentation value, target
  metrics, and — crucially — **it was actually run**, producing 20+ challenges whose
  convergent inventions (rate limits, locks, timeouts, retry policies, idempotency keys,
  `old_<field>`) are the strongest form of de-novo agent testimony in the estate. The
  meta-principle ("agents as a proxy for human intuition at scale") is the framing to
  quote.
- **Agents' *discomfort* is usable data.** §10.3: an agent's in-code comment "This feels
  awkward - need separate actions for each approval step" is what identified that
  composition syntax is wrong for long-running multi-actor workflows. Capturing the
  hedge, not just the output, is the method.
- **Resource → agent-tool export closes a real drift.** §13, including the three-way
  field policy where `:sensitive` means *included but marked*, and the explicit
  "generates schemas but does NOT enforce authorization."
- **"Fix it upstream" as an ecosystem discipline** — autopax/operata/archema share the
  rule *"Don't work around Archema bugs or limitations. If something is harder than it
  should be, the fix likely belongs in Archema itself."*[^adr012-fixupstream] A real
  multi-consumer shared-substrate governance datum. Its counter-example is in the same
  estate: the flow-back never happened, and autopax went dormant.
- **The YAML typing traps are catalogued in production** — the conformant ADR-008's
  quoting and version-string gotchas (`1.0`→float, `01234`→octal, `2024-01-15`→Date,
  `yes`→bool)[^adr008-gotchas-conformant] are the same guessing-tax the tooling report's
  typing chapter cites — here as the *lived operational catalog* that motivated a whole
  normalization tool (psych-pure, chosen for comment preservation). The shipped
  counter-measure is worth naming: rowan's adapters coerce every attribute against its
  *declared* type on read[^yamlfm-coerce] rather than trusting YAML's inference.
  Reinforces UDON's frozen-bare-set as the answer.
- **Permissive extractor / strict linter** (§12.1) is a disposition the harness program
  should adopt by name: the read path never blocks on schema violations and marks them
  `(missing)`; a separate strict pass reports them with severities including an INFO tier
  for "might not be a problem." An agent mid-edit must still be able to read the store.
- **Records with a lifecycle need supersession discipline** (§11), and pass 1 is the
  cautionary tale: a directory listing is not a valid query result when superseded rows
  remain in place. Any agent-facing document store must make deadness *loud* — autopax
  puts a banner in the body precisely because frontmatter alone did not stop readers.
- **Record the evidence vector, not the verdict** (§17.1). A stored scalar confidence
  makes its own deriving rule unfalsifiable; the ledger-plus-derived-posterior-plus-
  dominant-factor triple is the shape to copy, and it is what udon-needs' three-axis
  frontmatter already reaches for.
- **A human assertion is a factor, not an override** (§17.3). Attestation enters the same
  ledger with a better likelihood ratio and can still lose to a conflicting extracted
  identifier — *"never silently encodes a human error as ground truth."*
- **Contradiction is retained, not discarded** (§17.3): a refutation suppresses early exit,
  and if outweighed is *recorded and surfaced as a finding* about the corpus.
- **Defend the seed before writing the number** (§17.5), and let the loop catch you — a
  hand-set prior 20× too confident was found by calibration, not by argument. Adoption of
  a refit stays a deliberate human edit.
- **Synthetic fixtures hide integration breakage** (§17.5): the suite passed while the
  real-corpus path crashed, because the structural tests bypassed the matcher. Any
  doc-store needs at least one smoke test against the real corpus.
- **Simulation testing and hallway testing are different instruments** (§10.4) — survival
  under realistic use versus guessability of the interface. Both use agents; neither
  substitutes for the other. The scenario-as-record-directory layout (narrative +
  operations + sampled parameters, co-located) is directly reusable.
- **The retrofit lesson** (§1.4): sequence the hardest, most invariant-bearing subsystem
  first, because the cheap wins are the ones you needed least. This is the single most
  important piece of evidence in the review for anyone proposing to unify an existing
  document estate under a schema layer.
- **Assign authority by directory, not by field** (§1.4): `canonical/` · `archaeology/` ·
  `bridges/` · `stalled-lineage/` cannot go stale silently, because changing the status
  means moving the file, which shows up in `git log --raw`.
- **Surface problems, don't enforce solutions** (§16.4, P10) is the general form of
  permissive-extractor/strict-linter, and every non-blocking check in this review is an
  instance.
- **Preserve intent, not just state** (§16.4, P1) — *"the difference between a photograph
  and a film."* The argument under every append-only event directory here.
- **Estimate in sessions, not calendar time** (§11) — "aligns with agent context
  boundaries."

---

## Coverage & honest edges

**Read this pass, in full or near-full:** rowan — ADR-001/002/003/004,
`plan-safe-rdbms-evolution.md`, `path-centric-query-dsl.md` (all 1,624 lines),
`hallway-usability-at-scale.md`, `migration-survey-findings.md`, MAP.md, and the source
of `store_adapters/{yaml_frontmatter,jsonl}.rb`, `resource/versioning.rb`,
`resource/attributes.rb` (evolution portions), `schema/{history,decision_log,differ}.rb`,
`agentic/tool_export.rb`. autopax — `docs/ADR/README.md`, ADR-012, ADR-013 (opening),
the conformant `migration-proposals/008` and `010`, the DO-NOT-USE banner survey across
all 15 ADRs, and `lib/autopax/resources/agent_card{,/parser,/validator}.rb`. relata —
`designator.rb`, `entry.rb`, `safe_write.rb`, `TODO-ingest.md` §5, §11.17, §11.18, §12,
§12.1, §15, README write-membrane. Plus `neurips/refs/README.md`,
`asf/terminology/README.md` whole, and the grok memory documentation. Git history for
all five repos.

**Read in pass 2 (2026-07-23):** `~/src/arch/harness/` README + STEWARD-JUDGMENT +
`proprium/INDEX.md`; `proprium/stalled-lineage/` — the sapientia/zoetica/ennaos/nexum
SURVEY, `autopax-OPERATA.md`, `nexum-OPERATA.md` (opening), `2025-11-26-operata-system.md`,
`2025-11-14-operata-principles.md` (all ten principle statements, five in depth); ASF
`FORMAT.md` (file organization through the promotion gates), `01-aat-core/OUTLINE.md`,
`OUTLINE-accepted.md`, a worked segment, `bin/term`'s `Renderer`; udon-needs
`02-tooling-needs/OUTLINE.md` + a segment's full frontmatter; rowan
`docs/msc/simulation-driven-testing.md` + the scenario corpus layout + one scenario;
relata `TODO-ingest.md` §7.1–7.10, §11 #10, #13, #14. Git history for nexum, firmatum,
shoshin, and the autopax Dec-2025 commit run.

**Known-unread, and honestly so:**

- rowan `docs/sys/**` — ~50 system-reference documents (the `schema/differ.md` alone is
  862 lines; `resource/attributes.md` 1,187). Read selectively for the differ and
  decision-log sections; the rest is API reference likely generated from the same source
  I read directly.
- rowan `docs/msc/**` — 30 files including `plan-document-schema-constraints.md` (469L),
  `plan-recursive-embedded-schemas.md` (339L, self-referential `has_many` — likely
  relevant to UDON nesting), `plan-value-objects-field-syntax.md` (740L, the ValueResource
  /`field` DSL that MAP.md calls the current work), `archema-ash-comparison-research.md`
  (1,619L), `exploration-graph-resource-unification.md` (420L, flagged by ADR-002 as
  where paths may unify with graph traversal), and the `reflections/` set.
  **`plan-recursive-embedded-schemas.md` and `exploration-graph-resource-unification.md`
  are the two I would read first in a third pass.**
- rowan `docs/exp/domain-action-syntax-candidates.md` (787L) and `expr-dsl-approaches.md`
  (394L) — the syntax-candidate corpus behind the hallway tests; sampled via the results,
  not read whole.
- rowan `docs/ref/patterns/` — ~60 Ambler/Sadalage pattern files, confirmed present and
  characterized, individually unread.
- The full simulation-scenario set (~10 scenarios) — sampled, not surveyed.
- relata `TODO-ingest.md` — 4,826 lines; pass 2 closed §7 (now §17 of this report) and
  §11 #10/#13/#14. Still unread: most of §11's remaining ~15 decisions, §3's Stage 0–G
  pipeline in detail, §6.1's legacy-surface extraction, §8 graceful degradation, §13–14
  (resources, investigation findings, the Paperpile/`~/src/_ref/books` recon), and §16's
  33 session logs — a working record with design decisions embedded, and the place where
  §11 items get amended. **Given §1.5, that last one is the likeliest remaining source of
  stale citations in this report.**
- relata `docs/sys/**` (34 files) and `lib/**` (50 files) beyond the four I read;
  `evidence_ledger.rb`, `verification_event.rb`, `markdown_store.rb`, and `spool.rb` are
  the obvious next four.
- relata `IMPORT-ASF-TODO.md` (864L) and `BETTER-DATA-AND-CALIBRATION-TODO.md` (403L).
- autopax ADR-002b (signum schema, 566L) and ADR-004/005 (model catalog, semantic model
  identity — 704L/371L plus conformant versions). ADR-005 *"Semantic Model Identity"* is
  named identity work and may be more path-relevant than its title suggests.
- `udon-needs/` — the OUTLINE and one segment read (§12.2); the seven body reports, the
  30 bridge chapters, `DECISIONS.md` X1–X6, `RESIDUALS.md` and `DEEPENING-CYCLES.md` not
  read. `01-ideation/` untouched.
- `~/src/arch/harness/proprium/` design-of-record set — `proprium-harness-design.md`,
  `CHRONICA-PORT-SPEC.md`, `AGENTIC-LOOP-PORT-SPEC.md`, `MVP-VERTICAL-SLICE.md`,
  `INTERPRES-COMPACTION-NOTE.md`, `canonical/PROPRIUM-{ONTOLOGY,ARCHITECTURE}-v2.md`.
  These are the *current* harness design and I read only the index and the steward
  judgment. `CHRONICA-PORT-SPEC.md` in particular is the live successor to the CHRONICA
  material in §7, and `~/src/firmatum/` and `~/src/shoshin/` are unread as repos.
- `nexum-OPERATA.md` (627 lines) and `autopax-SYNTHESIS-PART1-UNIFIED-ARCHITECTURE.md`
  (756) and `autopax-README.md` (957) — opened only far enough to place them.
- ASF `FORMAT.md` §300+ (Document Cadence, Findings schema, Working Notes, Epistemic
  Triage) and `bin/term`'s CLI/lint halves.
- ASF terminology `entries/` (176 records) and `decisions/` (~150 dirs) — the README and
  schema read whole, the record corpus sampled.

*This review is intake material — every finding is a lift-with-provenance for the
downstream agent folding it into udon-needs and the agentic-tooling work.*

---

## Footnotes

*Paths are absolute-from-`~`. Line numbers are as of 2026-07-23; where a range is given
it brackets the quoted material.*

### autopax — ADRs and supersession

[^adr008-donotuse]: `~/src/autopax/docs/ADR/008-yaml-and-schemas.md:3-6` — "CAUTION : DO NOT USE … being replaced by the conformant version: [[migration-proposals/008-yaml-and-schemas.md]]". Banner survey: 003/005/007/008/009/010/011 all carry it.
[^adr008-scopereduction]: `~/src/autopax/docs/ADR/008-yaml-and-schemas.md:12-20` — Scope Reduction (2025-12-15): if ADR-012 is adopted, 008 reduces to YAML conventions + psych-pure + the `_schema` convention; "Schema versioning, validation, and migration would be handled by Archema's built-in resource DSL and schema evolution system."
[^adr008-selfdesc-conformant]: `~/src/autopax/docs/ADR/migration-proposals/008-yaml-and-schemas.md:201-208,619` — "Self-describing: Documents carry `_schema: type/version` field"; `_schema: autopax-agent-card/2.0.0`; and the recorded migration note that `_version` is *prescriptively* reserved for document-level revision/lineage.
[^adr008-gotchas-conformant]: `~/src/autopax/docs/ADR/migration-proposals/008-yaml-and-schemas.md:117,443-457` — leading zeros (`01234` → octal 668); Appendix A "Ruby YAML Parsing Gotchas"; version-string gotchas table (`1.2` → float, `1.2.3` → string) noted in the Change Log at :34.
[^adr012-knot]: `~/src/autopax/docs/ADR/012-archema-resource-foundation.md:40-50` — ad-hoc per-type implementation; "architectural knot" blocking ADRs 006/008/010.
[^adr012-frontmatter]: `~/src/autopax/docs/ADR/012-archema-resource-foundation.md:1-14` — `status: DRAFT`, `deciders: [Joseph]`, `supersedes: ["[[008]]"]`, `needed_for: ["[[004]]","[[005]]","[[006]]","[[007]]","[[010]]"]`.
[^adr012-tasklist]: `~/src/autopax/docs/ADR/012-archema-resource-foundation.md:453,485` — "Recommendation: Path initially (`gem 'archema', path: '../_gems/archema'`)"; `[ ] Add Archema dependency` — unchecked.
[^adr012-storemap]: `~/src/autopax/docs/ADR/012-archema-resource-foundation.md:333-346` — store-mapping table for the ELI TAXONOMY.
[^adr012-fixupstream]: `~/src/autopax/docs/ADR/012-archema-resource-foundation.md:384-392` — "Don't work around Archema bugs … the fix likely belongs in Archema itself."
[^adr010-p1]: `~/src/autopax/docs/ADR/migration-proposals/010-markdown-parsing-and-validation.md:74-152` — P1 Markdown Structural Schema DSL; the `:adr` and `:agent_axiomata` schemas.
[^adr010-p2]: `~/src/autopax/docs/ADR/migration-proposals/010-markdown-parsing-and-validation.md:153-170` — P2 Schema-Derived Example Generation.
[^adr010-frontmatter]: `~/src/autopax/docs/ADR/migration-proposals/010-markdown-parsing-and-validation.md:1-14` — `status: EXPLORING`, `blocked_by: ["[[008]]"]`.

### autopax — the ADR system as a doc-store

[^adrreadme-frontmatter]: `~/src/autopax/docs/ADR/README.md:121-157` — the frontmatter block and the per-field table.
[^adrreadme-transitions]: `~/src/autopax/docs/ADR/README.md:86-117` — enumerated primary-state transitions and flag additions.
[^adrreadme-flags]: `~/src/autopax/docs/ADR/README.md:63-85` — flags orthogonal to state; the worked status examples.
[^adrreadme-mutability]: `~/src/autopax/docs/ADR/README.md:36-48` — the status table with a Mutability column; the immutability footnotes.
[^adrreadme-immutability]: `~/src/autopax/docs/ADR/README.md:277-287` — "Immutability Preserves History"; archaeological understanding / re-litigation / evolution of thinking.
[^adrreadme-supersession]: `~/src/autopax/docs/ADR/README.md:295-301` — "Link Supersession Chains"; both ADRs remain in the directory.
[^adrreadme-edges]: `~/src/autopax/docs/ADR/README.md:155-157` — `blocked_by`/`needed_for` are decision-lifecycle dependencies; `related` is conceptual.
[^adrreadme-notprogress]: `~/src/autopax/docs/ADR/README.md:5-6,265-275` — "ADRs record decisions, not implementation status … tracked in OPERATA.md, not here."
[^adrreadme-structure]: `~/src/autopax/docs/ADR/README.md:159-250` — required group headers; numbered P1/P2 proposals; the consolidation allowance.
[^adrreadme-estimation]: `~/src/autopax/docs/ADR/README.md:252-261` — session counts, not calendar time.

### autopax — the shipped resources

[^agentcard-pk]: `~/src/autopax/lib/autopax/resources/agent_card.rb:63-70` — `store :yaml_frontmatter, directory:, extension: '.yml', body_attribute: :axiomata_content`; `primary_key :name, :string`.
[^agentcard-modes]: `~/src/autopax/lib/autopax/resources/agent_card.rb:7-17` — "Dual Loading Modes": registry mode vs path mode.
[^agentcard-loadpath]: `~/src/autopax/lib/autopax/resources/agent_card.rb:45-60`; parser at `~/src/autopax/lib/autopax/resources/agent_card/parser.rb:1-52` — two file formats (frontmatter-with-body vs traditional YAML with `files.axiomata-root`), `directory` recorded for relative resolution.
[^agentcard-validator]: `~/src/autopax/lib/autopax/resources/agent_card/validator.rb:21-28` — hard equality against `SUPPORTED_VERSION`.
[^agentcard-comment]: `~/src/autopax/lib/autopax/resources/agent_card.rb:63-64` — "schema_field enables automatic versioning and upcasting of older agent cards" (aspirational; no `schema_id`/`schema_version`/`upcast` declared on the class).

### rowan — ADRs

[^adr001-entry]: `~/src/rowan/docs/dev/adr-001-store-composition.md:57-69` — `StoreEntry = Data.define(...)`; compositions as ordered merges with later-wins on role+mode collision.
[^adr001-roles]: `~/src/rowan/docs/dev/adr-001-store-composition.md:348-373` — "Role Extensibility ✅ RESOLVED (ISSUE-053, 2025-12-17)"; prefix-inferred behaviors table; `behavior:` override.
[^adr001-demotion]: `~/src/rowan/docs/dev/adr-001-store-composition.md:427-446` — ":readwrite is ONE Entry"; the demotion algebra and the subsequent-write error.
[^adr001-levels]: `~/src/rowan/docs/dev/adr-001-store-composition.md:500-568` — the three resolver levels; "Decision: Support Levels 1-2 only. Level 3 is explicitly out of scope."
[^adr001-deprecated]: `~/src/rowan/docs/dev/adr-001-store-composition.md:288-305` — deprecated/clarified terms; "Why `data_layer` is deprecated."
[^adr001-unify]: `~/src/rowan/docs/dev/adr-001-store-composition.md:416-419,578-588` — step 6; "Delete `MultiStore` class (~914 lines)".
[^adr002-rationale]: `~/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md:41-49` — the alternatives-rejection table.
[^adr002-why]: `~/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md:50-57` — "Why dig-style works" (paths are data; precise step-indexed errors; serializable; maps to JSONPath).
[^adr002-translation]: `~/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md:83-86` — Memory/YAML traverse with `dig`; Sequel builds JOINs from the path.
[^adr002-open]: `~/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md:87-91` — the three open questions.
[^adr002-related]: `~/src/rowan/docs/dev/adr-002-dig-style-filter-paths.md:93-97` — links to `expr-dsl-approaches` and "Graph Resource Unification — dig-style paths may unify with graph traversal".
[^adr003-decision]: `~/src/rowan/docs/dev/adr-003-document-schema-first.md:47-56` — "document-schema-first": JSON Schema superset → DSL → projected per store.
[^adr003-implications]: `~/src/rowan/docs/dev/adr-003-document-schema-first.md:58-66` — validation canonical; RDBMS constraints optional projections; document stores first-class.
[^adr003-impl-table]: `~/src/rowan/docs/dev/adr-003-document-schema-first.md:77-86` — one constraint per store (YAML `oneOf` / PG CHECK / SQLite trigger).
[^adr003-poly]: `~/src/rowan/docs/dev/adr-003-document-schema-first.md:68-86` — `belongs_to_one_of` dissolves the polymorphic-FK problem.
[^adr003-threeworlds]: `~/src/rowan/docs/dev/adr-003-document-schema-first.md:88-98` — the three-worlds unification.
[^adr004-otp]: `~/src/rowan/docs/dev/adr-004-programmatic-schema-api.md:25-36` — the Erlang/OTP mental model table.
[^adr004-sync]: `~/src/rowan/docs/dev/adr-004-programmatic-schema-api.md:178-212` — `sync!`/`sync_all!`; "the 'just make it match' primitive that scripting and testing need."
[^adr004-annotations]: `~/src/rowan/docs/dev/adr-004-programmatic-schema-api.md:214-231,306-311` — source-code annotations (`#> For AI: …`); the source-modification-scope open question.

### rowan — plans and research

[^evolution-status]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:8-26` — the implemented/pending split.
[^evolution-perstore]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:108-114` — per-storage-layer behavior for one `was:` change.
[^evolution-agentsyntax]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:116-134` — "Agent-Friendly Syntax (Non-Interactive)"; `# {{replaces: :name}}`.
[^evolution-lifecycle]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:151-225` — Expand / Monitor (`.archema/transitions/<resource>.yaml`) / Contract (`auto_contract_after`) / Historical Awareness.
[^evolution-claim]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:448` — "Ash/Ecto/ActiveRecord don't do this. They generate migrations for the *destination* state, not the *transition*."
[^evolution-multistore]: `~/src/rowan/docs/dev/plan-safe-rdbms-evolution.md:297-333` — the multi-store example still written in the removed `data_layer` form.
[^patterns-dir]: `~/src/rowan/docs/ref/patterns/` — ~60 Ambler/Sadalage pattern files (`RenameColumnExample.md`, `IntroduceSurrogateKeyExample.md`, `ReplaceOneToManyExample.md`, …) plus `README.md`.
[^survey-header]: `~/src/rowan/docs/ref/migration-survey/migration-survey-findings.md:3` — "23 public Rails projects, 6,201 migrations, 12,072 mutations".
[^survey-distribution]: `~/src/rowan/docs/ref/migration-survey/migration-survey-findings.md:5-31` — the category and per-operation distributions.
[^survey-insights]: `~/src/rowan/docs/ref/migration-survey/migration-survey-findings.md:57-120` — the seven key insights incl. expand:contract 5:1, hidden views, and models-change-5.1×.
[^hallway-core]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:5-9` — the core insight.
[^hallway-kolmogorov]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:13-24` — Kolmogorov-complexity framing; the four-tier bits-of-context scale.
[^hallway-curve]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:36-53` — `k*`; the learning-curve-shape diagnostic.
[^hallway-convergence]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:26-34` — convergence as signal; the three-way reading.
[^hallway-phases]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:54-127` — Phases 1–4; documentation delta.
[^hallway-metrics]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:153-171` — the metrics table with targets; the feedback loop.
[^hallway-meta]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:217-223` — the meta-principle.
[^hallway-pipeline]: `~/src/rowan/docs/dev/hallway-usability-at-scale.md:128-152` — current flow (`Distributions → Parameters → Sonnet → Haiku → Runner`) and the Naive Agent Panel extension.
[^hallway-categories]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:907-927` — methodology and the seven challenge categories; results in `test/usability/results/`.
[^hallway-f1]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:931-954` — convergently-invented infrastructure primitives.
[^hallway-f5]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1006-1020` — previous-value access; the `was:`/`old_<field>` alignment.
[^hallway-f10]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1082-1103` — complex failure handling stays in Ruby.
[^hallway-keep]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1145-1176` — the Should-Add / Should-Keep-as-Plain-Ruby / Needs-More-Design tables.
[^hallway-tiers]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1271-1279` — the three-tier table.
[^hallway-approval]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1283-1364` — composition syntax wrong for human workflows; the agent's in-code comment.
[^hallway-undo]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:1367-1439` — undo needs run-time data; the `captures`/`tracks_side_effect`/`compensate` refinement.
[^pathdsl-dialects]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:21-36` — the six-dialect × thirteen-capability table.
[^pathdsl-observations]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:40-51` — three operations; two paradigms.
[^pathdsl-yes]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:55-78` — every path expression is a set expression; the worked join translation.
[^pathdsl-no]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:80-92` — set constructs with no path equivalent.
[^pathdsl-algebra]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:93-107` — the relational-algebra table; "a proper subset".
[^pathdsl-category]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:109-117` — schema-as-category; paths as morphism compositions; intension vs extension.
[^pathdsl-inversion]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:123-137` — The Inversion.
[^pathdsl-escape]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:184-190` — "The escape hatch enriches the schema, not the query."
[^pathdsl-views]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:192-234` — views as first-class Resources (`derives_from`).
[^pathdsl-crossstore]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:235-259` — cross-store relationships traversed by one path DSL.
[^pathdsl-unification]: `~/src/rowan/docs/exp/path-centric-query-dsl.md:261-272` — the unification table.
[^sim-context]: `~/src/rowan/test/simulation/archema_context.md:1-60` — the context + operations fed to simulation LLMs.
[^sim-scenario]: `~/src/rowan/test/simulation/scenarios/*/scenario.md` (sampled) — LLM-invented multi-store narratives (e.g. maritime supply-chain: jurisdiction-aware distributed DB + immutable audit + mainframe + edge caches).
[^map-tracks]: `~/src/rowan/MAP.md:14-24,60-140` — the track table and per-track completion lists; commit `e5d2e3f` "Implement Memory adapter schema versioning (ADR-004 Phase 2)"; `e4f990a` "Implement runtime schema evolution (ADR-004 Phase 3)".
[^map-adr002-planned]: `~/src/rowan/MAP.md:107,377` — "Relationship-aware filtering → ADR-002" listed under Planned; ADR-002 marked "(draft)".

### rowan — user docs

[^stores-thesis]: `~/src/rowan/docs/usr/09-stores.md:9` — "A Resource definition is storage-agnostic…"
[^evo-was]: `~/src/rowan/docs/usr/10-schema-evolution.md:34-73` — `was:` syntax; read-time translation; rename+type-change with `upcast:`.
[^evo-nomig]: `~/src/rowan/docs/usr/10-schema-evolution.md:153-171` — SQL migration generated; YAML/JSONL need none.
[^evo-safe]: `~/src/rowan/docs/usr/10-schema-evolution.md:215-233` — "schema changes as safe as code changes."
[^evo-history-doc]: `~/src/rowan/docs/usr/10-schema-evolution.md:74-87` — the (incorrect) `schema_history/user/v1.0.0.yaml` layout. Contrast [^history-path-code].
[^toolexport-problem]: `~/src/rowan/docs/usr/12-tool-export.md:17-41` — the drift problem; "Keep them in sync manually forever".

### rowan — implementation

[^yamlfm-init]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:76-91` — the real option set: `directory`, `extension`, `body_attribute`, `filename_attribute`, `schema_field`, `cache`.
[^yamlfm-schemafield]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:85` — `@schema_field = options.fetch(:schema_field, :_schema)`.
[^yamlfm-parse]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:316-353` — the read pipeline in order.
[^yamlfm-renames]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:385-404` — `apply_attribute_renames`; rename only when the new name is absent.
[^yamlfm-coerce]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:410-436` — per-declared-type coercion (atom/integer/float/boolean/datetime/date/uuid7/uuid8).
[^yamlfm-upcast]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:378-383` — `upcast_if_needed` delegating to `resource.upcast_data`.
[^yamlfm-serialize]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:479-503` — `serialize_for_yaml` writes `resource.full_schema_id` into the schema field first.
[^yamlfm-loaderror]: `~/src/rowan/lib/archema/store_adapters/yaml_frontmatter.rb:290-294` — parse failure is `warn`-ed and the record dropped from the result set.
[^jsonl-schemafield]: `~/src/rowan/lib/archema/store_adapters/jsonl.rb:111` — `@schema_field = options.fetch(:schema_field, :_schema_version)`.
[^jsonl-appendonly]: `~/src/rowan/lib/archema/store_adapters/jsonl.rb:30-32` — updates and destroys append; reads return the latest by scanning from the end.
[^jsonl-hashchain]: `~/src/rowan/lib/archema/store_adapters/jsonl.rb:33-40,88,328-331` — BLAKE3 `hash`/`hash_prev`, `GENESIS_HASH = "genesis"`, `verify_chain`.
[^jsonl-tombstone]: `~/src/rowan/lib/archema/store_adapters/jsonl.rb:206-222` — tombstone entries carrying `_tombstone_for`; existence checked "to avoid orphan tombstones for bad IDs".
[^versioning-dsl]: `~/src/rowan/lib/archema/resource/versioning.rb:73-106` — `schema_id` (defaults to kebab-cased class name), `schema_version` (defaults `1.0.0`), `full_schema_id`.
[^versioning-normalize]: `~/src/rowan/lib/archema/resource/versioning.rb:341-370` — `default_schema_id`, `normalize_version`, `normalize_version_prefix`, `major_version`.
[^versioning-compat]: `~/src/rowan/lib/archema/resource/versioning.rb:108-143,179-191,253-276` — `backward_compatible_with`, `forward_compatible_with`, `can_read_version?`, `check_compatibility`, `known_versions`.
[^versioning-forward]: `~/src/rowan/lib/archema/resource/versioning.rb:128-134` — "Primarily documentation; actual compatibility depends on those versions."
[^versioning-upcast]: `~/src/rowan/lib/archema/resource/versioning.rb:18-36,145-177` — the `upcast from:` DSL and the worked agent-card v1→v2 example.
[^versioning-upcastpath]: `~/src/rowan/lib/archema/resource/versioning.rb:193-232` — `upcast_path`; sequential intermediate blocks; exact-then-major fallback.
[^versioning-upcastdata]: `~/src/rowan/lib/archema/resource/versioning.rb:234-251` — `upcast_data` folding the path over a `dup`.
[^versioning-evolve]: `~/src/rowan/lib/archema/resource/versioning.rb:278-339` — `evolve` with mutex, `EvolutionContext`, auto minor bump, auto `backward_compatible_with(from_version)`.
[^attributes-lifecycle]: `~/src/rowan/lib/archema/resource/attributes.rb:31-35,110-117` — the option table; parsing of `since:`/`deprecated:`/`removed:`/`was:`.
[^attributes-available]: `~/src/rowan/lib/archema/resource/attributes.rb:178-220` — `added_in_or_after?` (:182), `exists_in_version?` (:193-205), `deprecated_in_version?` (:210), `versioned?` (:220).
[^attributes-was]: `~/src/rowan/lib/archema/resource/attributes.rb:337-362` — the four accepted `was:` forms.
[^history-path-code]: `~/src/rowan/lib/archema/schema/history.rb:17,288` — `.archema/schema_history/{resource_name}.yaml`, one file per resource; `Archema.config.schema_history_path` defaults to `.archema` (`~/src/rowan/lib/archema.rb:197`).
[^history-evolution]: `~/src/rowan/lib/archema/schema/history.rb:36-58` — the `Evolution` struct: version, timestamp, changes, attributes, relationships, `decision_ref`.
[^differ-ambiguity]: `~/src/rowan/lib/archema/schema/differ.rb:24,53-58,123` — `:possible_rename` with options `[:rename, :separate]`; `DecisionLog#lookup` consulted for a prior decision.
[^differ-heuristic]: `~/src/rowan/lib/archema/schema/differ.rb:241-252` — `detect_possible_renames`; "Simple heuristic: if exactly one column removed and one added with same type".
[^decisionlog-purpose]: `~/src/rowan/lib/archema/schema/decision_log.rb:12-23` — replayed / audited / "Learned from - Future heuristics could train on decision patterns."
[^decisionlog-sources]: `~/src/rowan/lib/archema/schema/decision_log.rb:25-34,182` — the five sources; `SOURCES` frozen array.
[^decisionlog-agentid]: `~/src/rowan/lib/archema/schema/decision_log.rb:103,301` — `agent_id` "(only when source is :agent_comment)".
[^decisionlog-immutable]: `~/src/rowan/lib/archema/schema/decision_log.rb:36-41,75-92` — `.archema/decisions.yaml`, committed to version control; "Decisions are immutable once recorded - we never edit history, only append new decisions."
[^toolexport-descriptions]: `~/src/rowan/lib/archema/agentic/tool_export.rb:15-23` — the description sourcing priority.
[^toolexport-typemap]: `~/src/rowan/lib/archema/agentic/tool_export.rb:25-38` — the Archema→JSON-Schema type table.
[^toolexport-constraints]: `~/src/rowan/lib/archema/agentic/tool_export.rb:40-45` — constraint mapping; nested relationships not exported.
[^toolexport-exclusions]: `~/src/rowan/lib/archema/agentic/tool_export.rb:47-51` — private excluded / sensitive included-but-marked / readonly excluded from create+update.
[^toolexport-security]: `~/src/rowan/lib/archema/agentic/tool_export.rb:53-62` — "does NOT enforce authorization"; the three caller obligations.
[^toolexport-output]: `~/src/rowan/docs/usr/12-tool-export.md:60-105` — the emitted tool-definition array; "Each action becomes a tool. The schema reflects attribute types, constraints, and nullability"; `format: :anthropic` (default) / `format: :openai`.
[^toolexport-api]: `~/src/rowan/lib/archema/agentic/tool_export.rb:64-72` — `to_tool_definitions`, `format: :openai`, per-action export.

### relata

[^relata-firstcommit]: `~/src/relata` git — `2026-05-13 Initialize relata: cross-project bibliography source-of-truth` (first commit; 148 commits through 2026-07-13).
[^entry-thesis]: `~/src/relata/lib/relata/entry.rb:9` — "Entry — one YAML file = one bib entry. Filename is the canonical key."
[^entry-api-code]: `~/src/relata/lib/relata/entry.rb:43-57` — `path_for` / `load` / `all`.
[^entry-resolve]: `~/src/relata/lib/relata/entry.rb:59-75` — `Entry.resolve` and the alias-fallback comment; returns `[entry, requested_key]`.
[^entry-askey]: `~/src/relata/lib/relata/entry.rb:77-81` — `as_key`; "Emission-only by contract: SAVING it would fork the entry into a second file".
[^safewrite-code]: `~/src/relata/lib/relata/safe_write.rb:8-52` — `TMP_SUFFIX`, the tmp+fsync+rename body, and the crash-sweep rationale.
[^designator-doc]: `~/src/relata/lib/relata/designator.rb:8-34` — the designator definition, the five kinds with their rigidity notes, and the classification precedence.
[^designator-result]: `~/src/relata/lib/relata/designator.rb:44-59,96-103` — `Result = Data.define(:input,:kind,:status,:entry,:choices)`; `build` branching 0/1/many.
[^designator-gate]: `~/src/relata/lib/relata/designator.rb:61-70` — `BIBKEY_SHAPE`; "a *safety* gate, not a schema".
[^relata-spool]: `~/src/relata/TODO-ingest.md:2332-2384` — §15, the ingest spool write-membrane, reproduced near-whole in §7.
[^relata-spool-60s]: `~/src/relata/TODO-ingest.md:2342-2345` — the 60 s mtime guard shared with `safe_write`'s tmp-sweep.
[^relata-frbr]: `~/src/relata/TODO-ingest.md:1894-1954` — §12 work · expression · item; FRBR as lens; the resolving principle; `pdfs[]`/`provisional`/`canonical`/`seeking_better`/`same_work_as`.
[^relata-fingerprint]: `~/src/relata/TODO-ingest.md:1956-2028` — §12.1 the three-point similarity spectrum; fingerprint the extracted text; `content_fp` vs `biblio_fp`; the abstract as bridge; TLSH / MinHash-LSH.
[^relata-1117-ladder]: `~/src/relata/TODO-ingest.md:1415-1435` — §11.17 the five-tier resolution ladder and TTY/agent auto-detection.
[^relata-1117-unique]: `~/src/relata/TODO-ingest.md:1486-1491` — "Unique designator"; "Resolution = the migration fuzzy designator → unique designator."
[^relata-1117-rerun]: `~/src/relata/TODO-ingest.md:1492-1495` — "Rerun ≠ retry ≠ decide, at every wait-state."
[^relata-1117-confirm]: `~/src/relata/TODO-ingest.md:1436-1445` — the four confirmation kinds, each writing its own labeled calibration event.
[^relata-1117-disposition]: `~/src/relata/TODO-ingest.md:1474-1484` — source-file disposition amending the §5 invariant; `--dry-run`/`--leave-alone`/`--keep`; the surviving core.
[^relata-1118-audit]: `~/src/relata/TODO-ingest.md:1553-1562` — 29 same-expression clusters / 13 sibling pairs / recall-poisoning / the title-collision-ladder cause.
[^relata-1118-survivor]: `~/src/relata/TODO-ingest.md:1565-1570` — the survivor rule and field-union merge.
[^relata-1118-aliases]: `~/src/relata/TODO-ingest.md:1571-1580` — `aliases:` as a first-class schema field; emit under the cited name; `validate` enforces alias uniqueness.
[^relata-1118-regrowth]: `~/src/relata/TODO-ingest.md:1583-1586` — the regrowth gate (normalized-title + year + first-author surname → enrich, not create).
[^relata-blobsize]: **DEAD TEXT — retained so anyone tracing pass 1's citation lands on the correction.** `~/src/relata/TODO-ingest.md:928-937` (§11 item 1) still asserts an 8 MB threshold and size × recoverability routing into `committed`/`local-cas`/`lfs`. It was disavowed 2026-05-19 and superseded by §11 #10 / §11 #13 / the rewritten §7.9 — see C11, §1.5 and §4.3. Do not cite it.
[^relata-noingestions]: `~/src/relata/TODO-ingest.md:393-398` — reuse the verification-event trail; "the audit trail and the calibration corpus are the same store. No separate `ingestions/` tree."
[^paths-tworoots]: `~/src/relata/docs/sys/paths.md:16-33` — code `ROOT` vs external canonical `DATA_DIR`.
[^paths-pdfsdir]: `~/src/relata/docs/sys/paths.md:34-43,103-108` — `PDFS_DIR` own env var; large bytes, separate backup strategy.
[^paths-pdfattempts]: `~/src/relata/docs/sys/paths.md:81-92` — `PDF_ATTEMPTS_DIR`: one append-only markdown event per (key, source, timestamp); one subdir per key; replay-friendly.
[^paths-emitted]: `~/src/relata/docs/sys/paths.md:94-101` — `EMITTED_DIR`: derived `.bib` snapshots; gitignored, ephemeral, non-canonical.
[^relata-paths-dirs]: `~/src/relata/docs/sys/paths.md:60,71,81,94` — `CALIBRATIONS_DIR`, `INGEST_SPOOL_DIR`, `PDF_ATTEMPTS_DIR`, `EMITTED_DIR`.

### neurips/refs and asf/terminology

[^refs-firstcommit]: `~/src/neurips` git — `2026-05-05 bin/refs + refs/ tree — sqlite-free bibliography database (PIPELINE-TODO §C1, §F)`.
[^refs-tradestudy-commit]: `~/src/neurips` git — `2026-05-06 bin/refs: safe_write — temp-file + fsync + rename for atomic entry writes`; `2026-05-06 refs/README: document sqlite-vs-YAML trade study + safe_write contract`.
[^refs-tradestudy]: `~/src/neurips/refs/README.md:28-47` — the trade study table and the decisive points, reproduced verbatim in §3.
[^refs-nolock]: `~/src/neurips/refs/README.md:60-64` — same-key writes intentionally not locked; the collision surfaces in `git status`.
[^term-descent]: `~/src/arch/asf/terminology/README.md:31` — "modeled on the `~/src/neurips/refs/` pattern that landed in May 2026 for citation-management"; first commit `2026-05-08 Terminology infrastructure … bin/term per-entry-YAML store`.
[^term-layout]: `~/src/arch/asf/terminology/README.md:5-16` — the layout block; `LEXICON.md` generated by `bin/term render`, "Do not hand-edit it."
[^term-whyperentry]: `~/src/arch/asf/terminology/README.md:19` — per-entry files vs one shared LEXICON.md; the silent failure mode.
[^term-whybody]: `~/src/arch/asf/terminology/README.md:21` — markdown body for the definition; frontmatter for structured metadata.
[^term-whyevents]: `~/src/arch/asf/terminology/README.md:23` — append-only decision events vs mutable status fields.
[^term-permissive]: `~/src/arch/asf/terminology/README.md:25` — permissive extractor / strict linter.
[^term-tradestudy]: `~/src/arch/asf/terminology/README.md:29-45` — the second, independent sqlite trade study incl. the "definition prose with rich formatting" row.
[^term-decisive]: `~/src/arch/asf/terminology/README.md:45` — the four decisive points, ending on markdown bodies as first-class explanatory artifacts.
[^term-atomicity]: `~/src/arch/asf/terminology/README.md:47-58` — the `safe_write` four-step contract; the 60 s sweep; no same-slug lock.
[^term-schema]: `~/src/arch/asf/terminology/README.md:60-84` — the entry schema block (`slug`, `schema_version: 1`, `term`, `name`, `notation`, `brief`, `layer`, `status`, `tags`, `source_type`, `primary_source`, `first_asf_mention`, `see_also`, `aliases`, `do_not_confuse`, `internal_note`).
[^term-fieldorder]: `~/src/arch/asf/terminology/README.md:98` — deterministic field ordering on save keeps git diffs clean.
[^term-outcomes]: `~/src/arch/asf/terminology/README.md:118` — outcomes `committed`/`rejected`/`revised`/`superseded`; latest-per-action wins, older kept.
[^term-actions]: `~/src/arch/asf/terminology/README.md:120-133` — the eight actions; "warns on unknown actions but does not block".
[^term-severities]: `~/src/arch/asf/terminology/README.md:176-183` — ERROR/WARN/INFO; render independent of lint.
[^term-clobber]: `~/src/arch/asf/terminology/README.md:193` — the `Auto-generated`-marker clobber guard.
[^term-render]: `~/src/arch/asf/terminology/README.md:195-199` — tag-driven sections, `TAG_DISPLAY_ORDER`, `seq:` ordering, `subgroup:` sub-tables.

### Grok, Claude, and udon-needs

[^grok-sqlite]: `~/.grok/README.md:1984-1991` — memory as Markdown files under `~/.grok/memory/`; global / workspace / session logs; "An SQLite index enables fast hybrid search (FTS5 keyword + optional vector KNN) across all memory files." Files: `~/.grok/memory/<project>-<hash8>/index.sqlite`, `~/.grok/sessions/session_search.sqlite`.
[^grok-hash]: `~/.grok/README.md:1989` — "The hash is derived from the git remote URL so all clones and worktrees of the same repository share the same memory directory."
[^grok-watcher]: `~/.grok/README.md:2077` — `watcher.enabled` (default true): watch `~/.grok/memory/` for external edits and reindex on search.
[^grok-stats]: `~/.grok/README.md:2065-2066` — `grok memory stats`: file count, **chunk count**, index size.
[^grok-config]: `~/.grok/README.md:2071-2081` — `search.max_results` 6, `search.min_score` 0.35, `initial_injection` with its own threshold.
[^udonneeds-layout]: `~/src/udon/v2/udon-needs/02-tooling-needs/` — `OUTLINE.md` spine over `src/` (e.g. `addressing-is-the-long-pole.md`, `continuity-infrastructure.md`), with `CHANGELOG.md` / `RESIDUALS.md` / `DEEPENING-CYCLES.md` / `notes/` / `reports/`.

### Pass 2 — the harness lineage, OPERATA, ASF format, relata §7

[^operata-archema]: `~/src/arch/harness/proprium/stalled-lineage/autopax-OPERATA.md:164-238` — "Foundation: Archema Integration (ADR-012)"; Phase 0 DONE 2025-12-15 (`[x] Add Archema dependency`, 659 tests), Phase 1 DONE 2025-12-16 (535 substrates, 613 tests, "Dissolved old Catalog code entirely"), Phase 2 DONE 2025-12-17 (42 AgentCard tests, 625 total, "Removed old `Agent::Card` class"); the ADR status table listing 012 at "IN PROGRESS ~50%".
[^operata-phase3]: `~/src/arch/harness/proprium/stalled-lineage/autopax-OPERATA.md:214-218` — Phase 3 CHRONICA and TRACTUS, all three items unchecked, incl. "Verify BLAKE3 hash chain compatibility". Corroborated by `~/src/autopax/lib/autopax/chronica/{entry,log}.rb` containing zero `Archema` references.
[^autopax-pinax-run]: `~/src/autopax` git log 2025-12-17…2025-12-20 — `Curatoria` subsystem added 2025-12-17 (hand-rolled), then ~100 consecutive Pinax/TUI commits (Region types, Layout::Composed, ScreenBuffer, SidePanel, DECSTBM, theme) through 2025-12-20; last substantive commit 2025-12-20.
[^survey-lineage]: `~/src/arch/harness/proprium/stalled-lineage/SURVEY-sapientia-zoetica-ennaos-nexum.md:5-20` — the lineage table (Synaptic → Sapientia → minimal-sapientia → Zoetica → Ennaos → Nexum) and the "Lived truth" paragraph. Dates corroborated by `~/src/_core/nexum` git (first commit 2025-11-06, last 2025-12-14), `~/src/firmatum` git (2026-02-23 → 2026-03-02), `~/src/shoshin` git (2026-03-07).
[^proprium-index-status]: `~/src/arch/harness/proprium/INDEX.md:5-10` — "Status (honest)"; "Harness work (autopax, nexum, sapientia OPERATA, shoshin) largely stalled once ASF took legs — thankfully, so the math could solidify first … this tree is the **intake substrate**, not the finished design."
[^proprium-layout]: `~/src/arch/harness/proprium/INDEX.md:33-43,3` — the four-directory layout with per-directory authority; "Copies, not live links — upstream trees remain authoritative until a deliberate rework lands."
[^proprium-notcopied]: `~/src/arch/harness/proprium/INDEX.md:119-127` — the explicit "What was *not* copied" list and the instruction to prefer editing live upstream sources.
[^operata-system]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-26-operata-system.md:1-37` — the CLI-tool survey; dstask's one-YAML-file-per-task model; the tool comparison table.
[^operata-storage]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-26-operata-system.md:201-220` — the git-friendliness × query-performance table and the recommended `.operata/` structure with regenerated `index.yml` + optional `graph.yml`.
[^operata-gap]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-26-operata-system.md:35,103-127` — "No tool supports speculative/draft task decompositions"; the git-topic-branch analogy and the `decompositions:`/`committed_decomposition:` sketch; ADaPT and interactive speculative planning as prior art.
[^operata-identity]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-26-operata-system.md:130-170` — UUID7 + Base58 short prefixes; git-style abbreviation with collision detection and auto-extend; the hybrid stable-UUID + content-hash pattern.
[^operata-graph]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-26-operata-system.md:174-199` — DAG with explicit soft links; one primary parent plus typed `contributes_to`(weighted)/`blocks`/`related`.
[^operata-principles]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:1-20` — the framing ("not a prescription but a persuasive argument"), the six source disciplines, and the OPERATA emphases (Schwerpunkt tracking, hypothesis exploration, trust maintenance, traceability, fluid refinement).
[^operata-p1]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:22-44` — Principle 1; photograph-vs-film; event sourcing capturing "intent, purpose, or reason in the data"; temporal tables' limitation; Auftragstaktik.
[^operata-p2]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:46-70` — Principle 2; the broken-external-references argument; "refinement is captured as edge creation … not node replacement."
[^operata-p3]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:72-86` — Principle 3; the GTD trusted-system argument.
[^operata-p5]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:129-144` — Principle 5; the "Q3 Marketing Campaign" folder problem; hierarchies as the wrong abstraction.
[^operata-p10]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:263-272` — Principle 10; surface-versus-enforce.
[^operata-principles-rest]: `~/src/arch/harness/proprium/stalled-lineage/2025-11-14-operata-principles.md:98-262,305-384` — Principles 4, 6, 7, 8, 9 and the "Synthesis: Implications for OPERATA" section.
[^asf-outline]: `~/src/arch/asf/01-aat-core/OUTLINE.md:1-70` — the per-chapter tables (`§ | Type | N | Tag | Claim | Stage`) with `Tag` linking into `src/<slug>.md`; `![[INTRODUCTION]]` transclusion; inline `<!-- remove -- … -->` / `<!-- salvageable -- … -->` editorial annotations.
[^asf-segment]: `~/src/arch/asf/01-aat-core/src/def-control-regret.md:1-9` — segment frontmatter (`slug`, `type`, `status`, `depends`, `stage`) followed by the prose body with Formal Expression / Epistemic Status / Discussion sections.
[^format-segmentset]: `~/src/arch/asf/FORMAT.md:112-120` — the segment-set principle; the `old-*` sole exemption; "will silently break these tools."
[^format-fileorg]: `~/src/arch/asf/FORMAT.md:105-110` — one claim per file; filename = slug; ordering in OUTLINE not filenames; "the slug is the stable identity"; `#slug-name` cross-references.
[^format-type]: `~/src/arch/asf/FORMAT.md:138-162` — the 20-value `type` table, each linking to `terminology/entries/`; the "Why these labels" rationale and the external-theorem exception.
[^format-status]: `~/src/arch/asf/FORMAT.md:164-177` — the 8-value `status` table; "Do NOT use 'Solid,' 'Confident,' or 'Plausible' as tier labels."
[^format-stage]: `~/src/arch/asf/FORMAT.md:187-204` — `stage` as development-process state, orthogonal to epistemic status; the 8-value table with per-stage gates; ordering and downgrade.
[^format-stage-stale]: `~/src/arch/asf/FORMAT.md:191` — lint checks OUTLINE-vs-frontmatter stage "as warnings only, never gate failures"; "the stage layer is known to go stale quickly … do not read low stage values as low epistemic strength" (Joseph, 2026-07-14).
[^format-depends]: `~/src/arch/asf/FORMAT.md:183-185` — `depends` deliberately untyped; edge type derivable from the referenced file's own `type`.
[^format-promotion]: `~/src/arch/asf/FORMAT.md:207-216,204` — promotion in topological order; batching by DAG depth; explicit downgrade conditions.
[^format-gate1]: `~/src/arch/asf/FORMAT.md:217-227` — Gate 1 dependency audit; the four criteria incl. "the dependency is genuine — not merely 'related' or 'mentioned in Discussion'".
[^format-empirica]: `~/src/arch/asf/FORMAT.md:179-181` — `empirica:<experiment-slug>@<run-date>`; the MANIFEST/RUNS bidirectional contract; "An empirical claim citing an experiment with no matching recorded run is a truth-status defect."
[^outline-accepted]: `~/src/arch/asf/01-aat-core/OUTLINE-accepted.md:1-11` — the lint whitelist; keyed by (segment, depends-on) slug pair to survive row moves; staleness reported as a warning; acceptance requires a reason grounded in a citable record.
[^term-render-vocab]: `~/src/arch/asf/bin/term:385-410` — `Renderer::TAG_DISPLAY_NAMES` incl. `segment_types`, `epistemic_vocabulary` ("Epistemic Status Values"), `process_vocabulary` ("Promotion Stages and Gates"), `findings_vocabulary`; `~/src/arch/asf/bin/term:411-470` — the `Auto-generated … Do not hand-edit` header, the entry-count footer, alphabetical sections with "Uncategorized" forced last, and `group_by_tag` sorting by `[seq || Infinity, term.downcase]`.
[^udonneeds-outline]: `~/src/udon/v2/udon-needs/02-tooling-needs/OUTLINE.md:1-60` — the anthology-with-a-spine framing; per-Part tables with `§ | Type | Tag | Claim | Stage` and a domain-local Type vocabulary (Method, Counterposition, Finding, Principle, Demand); "*Opens into:*" routing lines.
[^udonneeds-seg]: `~/src/udon/v2/udon-needs/02-tooling-needs/src/addressing-is-the-long-pole.md:1-25` — the extended frontmatter: `register`/`support-kind`/`strength`/`convergent`, the `verified:` embedded event log, `consumers`, `opens`, `handoff-routing`, and the commented `sources:` list; note `stage:` carrying prose rather than an enum value.
[^sim-driven]: `~/src/rowan/docs/msc/simulation-driven-testing.md:1-90` — property-vs-simulation framing; LLMs as "semantic fuzzers"; the four-stage pipeline; the two-LLM-stage justification; heavy-tailed distribution choices with the Pareto/Poisson samples.
[^sim-scenarios]: `~/src/rowan/test/simulation/scenarios/` — 21 scenario directories dated 2025-12-12, each `scenario.md` + `operations.jsonl` + `metadata.json`; contexts at `~/src/rowan/test/simulation/{archema_context.md,archema_multistore_context.md}`.
[^sim-legalvault]: `~/src/rowan/test/simulation/scenarios/20251212_170727_897460ae/scenario.md:1-16` — "LegalVault: From Simple Document Management to Regulatory Fortress"; the independently-invented multi-store thesis.
[^relata-7-purpose]: `~/src/relata/TODO-ingest.md:530-537` — §7 opening; "rehearsal for calibrating epistemic gain and belief-update for real entities."
[^relata-71]: `~/src/relata/TODO-ingest.md:539-565` — §7.1 the provenance schema; `identification_ledger` as "the calibration datum"; the `identified_by` enumeration.
[^relata-72]: `~/src/relata/TODO-ingest.md:567-602` — §7.2 the single decision rule; Good's weight of evidence; the synthetic `NONE` candidate; priors-vs-likelihoods separation as "the un-tangling".
[^relata-73]: `~/src/relata/TODO-ingest.md:604-636` — §7.3 refutation as the CONFLICT `woe`; the three-outcome confusion-matrix table; the `b = 0` diagnosis; "Absence is never refutation"; refutation suppresses short-tracking and, if outweighed, is recorded and surfaced.
[^relata-74]: `~/src/relata/TODO-ingest.md:638-675` — §7.4 per-factor design (sha-blob, content-fp, asymmetric ISBN, title-semantic, attestation-as-evidence-not-override, filename tokens ≈ 0, fs-context as prior); coverage scrutiny and the never-silently-`coverage: full` rule.
[^relata-75]: `~/src/relata/TODO-ingest.md:677-684` — §7.5 the geometric mean as the degenerate case.
[^relata-77]: `~/src/relata/TODO-ingest.md:699-715` — §7.7 calibration store; refit from labeled data; the defended-seed discipline with the worked `b≈0.02` justification.
[^relata-78]: `~/src/relata/TODO-ingest.md:717-725` — §7.8 "why this rigor, here"; "the bibliography is the safe sandbox; the discipline is the deliverable."
[^relata-710]: `~/src/relata/TODO-ingest.md:754-762` — §7.10 seed-prior defended chains; "judge the reasoning, not the constants — and the residual-uncertainty notes are part of the deliverable, not hedging."
[^relata-79-current]: `~/src/relata/TODO-ingest.md:727-752` — §7.9 as currently written: blob storage decoupled from the record by `hash`; "There is **no** per-blob `storage:` tier; no 'size × recoverability' rule; no redundancy / preservation directive"; the disavowal and the integration-is-replacement note.
[^relata-disavowal]: `~/src/relata/TODO-ingest.md:1134-1143` — §11 #13; Joseph verbatim ("I didn't write them, but it sounds like someone took liberties…"); "do not resurrect §7.9's tiering/redundancy rule"; "§7.9's text still sits in the doc; flagged here rather than excised this cycle — an excision pass is owed."
[^relata-1110]: `~/src/relata/TODO-ingest.md:977-997` — §11 #10 storage form; "the old entry was a hallucinated invariant dressed as principle"; document tree canonical, PG as derived/operational layer; configurable, default-outside-repo, opaque to consumers; the spool as the only outside-facing surface.
[^relata-1113]: `~/src/relata/TODO-ingest.md:1129-1164` — §11 #13; 31 PDFs / ~46 MB = essentially the whole repo weight; `RELATA_PDFS_DIR` default XDG; "Move, never delete"; `path:` as an OPAQUE logical token with runtime resolution; 31/31 sha verification before and after; entries untouched; scope explicitly PDF-tree-only.
[^relata-calibration]: `~/src/relata/TODO-ingest.md:1230-1279` — §11 #14 calibration harness; the `firstauthor+year(±1)` +0.114-vs-seed-+2.5 and `doi-exact` ~43%-vs-95% findings as "present-truth findings, not adoption recommendations"; the three engineering lessons; "Adopting a fit = a deliberate human edit … never automatic."

### Pass 3 — the CHRONICA port-spec and the gating counter-case

[^chronica-autopax]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:180-196` — §2.1 "Autopax `Chronica::{Log,Entry}` — highest-ROI integrity port. *~840 LOC Ruby, verified by reading.*"; the design enumeration (JSONL append-only, BLAKE3 over canonical sorted JSON, `hash_prev`, genesis sentinel `0*64`, verify-on-load → `IntegrityError`, frozen entries, two-phase `with_hash`, reserved `signature`/`anchor`); the "Honest thinness" assessment; "rich schema **paused** 2025-12-14".
[^chronica-portinvent]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:~296-302` — §5 invent-vs-port table: hash + canonical JSON + verify-on-load = **Port** (Autopax Chronica); sealed append writer / layer rule = **Invent**; event brands = **Invent**.
[^chronica-thesis]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:362-370` — §9 one-paragraph thesis; port Autopax's BLAKE3 append-only verify-on-load, invent sealed writing / PERCEPTA-ACTUS provenance / TRACTUS≠CHRONICA.
[^chronica-correction]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:12-25` — §0 "Correction note (why re-reading full segments mattered)"; the too-narrow first draft and the table of what partial reads missed, keyed to the segments that would have caught each.
[^chronica-posture]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:8-10` — "Epistemic posture": AAT claims at their stated tiers; Autopax Ruby verified by reading sources; paused schema "not treated as decided".
[^chronica-mvp]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:254-270` — §4 minimum viable CHRONICA, seven "Must have" items incl. TRACTUS-as-separate-store, single-writer/fork-as-new-genesis, and ordinal honesty.
[^chronica-nonclaims]: `~/src/arch/harness/proprium/CHRONICA-PORT-SPEC.md:272-290` — the explicit does-not-claim list (identity continuity across turnovers; replay reconstitutes a prefix record, not the entity; backup/restore not identity-preserving) and the "sibling MVP hooks" to name even if stubbed.
[^logos-provenance]: `~/src/arch/logos/refs/README.md:5` — "Adaptation provenance (2026-05-09). Borrowed from `~/src/neurips/` … The data layout, atomicity contract, and CLI verbs transfer verbatim. What does NOT transfer: the NeurIPS `bin/build` LaTeX pipeline (output format here is venue-specific …)". The two READMEs differ by ~29 lines total.
[^logos-gate]: `~/src/arch/logos/CLAUDE.md:86` — "`bin/refs lint` is **the anonymization gate before submission** — it scans every entry and every cited key against the deny-list. Run it before each Synthese / Inquiry submission."
