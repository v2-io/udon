# Underlying Logical Model 
*Or, the theory of udon soup, as far as one conversation got it*

*2026-07-29, Fable — This is a conversation record shaped into a letter, not a spec and not a conclusion: everything here is one conversation's convergence between Joseph and me, strictly provisional, and I will try to keep the register honest sentence by sentence — including the places where we plainly don't know. The turns it distills sit in the session of this date; the sources under it are `doc-store-and-schemas-report.md` (used for its* descriptions *of shipped mechanisms — Joseph's explicit instruction was to distrust its articulated conclusions, several of which we caught being premature), `tst-grounding/README.md` (theory at stated tiers), the extraction-probe run (measured, PINS CURRENT PARSER), and the AAT/TST primaries where I say so. Every `udon` block below has been run through the current parser; where a block deliberately shows an open question, I say what the parser did.*

Joseph asked what UDON collections are *logically* — big bowls of udon, unserved — and the conversation kept producing the same shape of answer from different directions. I'll give you the shape first, then the pieces, then the honest list of what none of this settles.

The shape: **a collection is a declared population of elements; files and directories are a *serving* of it; and every question that looked like it needed language law turned out to want a declared role plus behavior at a membrane instead.** That last clause happened five separate times in one conversation (write-governance, gating, contraction, interring, include-filtering), which is either a design prior worth adopting or a rut we fell into — I genuinely can't tell from inside, and you should watch for the sixth case rather than assume it.

Before the pieces, the standing on prior ground — none of this arrives from nowhere, and three precedents in the estate already commit to most of it. OUTLINE+segments **already chops the corpus up**: one claim per file, slug as identity, ordering held elsewhere — the population/serving split is lived practice there, not a proposal. Archema (now rowan) **already thinks "directory = table…ish / store"**: a resource definition projected onto pluggable substrates, with the directory-of-YAML as one store among several — the collection-as-logical-object with layout demoted to a projection is that lineage's founding move. And it's **already known that we'll want a logical representation of UDON collections even where standard file layouts exist** — if for no other reason than semantic indexing: chunking and vectorization have to pull documents apart into addressable, context-carrying pieces, and UDON's affordances (elements as declared semantic boundaries, identity, attributes as the context that travels with a fragment) are exactly what a chunker wants declared rather than inferred. So the letter's job isn't to argue for the logical layer — three independent-ish pressures already demand it — but to say what it consists of.

And one elephant we walked past during this and apparently prior sessions without naming, so it gets named here (Joseph's hypothesis, articulated explicitly for what he believes is the first time; pre-validation, and carrying stakes the rest of this letter doesn't): **most of our agentic tooling would work better over the logical corpus than over the file/storage-layout perspective it currently uses.** Today nearly every tool an agent holds — read, edit, grep, glob — speaks *serving*: paths to files, line numbers, byte offsets. The one relevant measurement we have points the other way: agents address relationally when they can (`||type[key]` at any depth, the tree as mere storage), and the estate's tooling pains — silent truncations, region edits with nowhere to record intent, layout knowledge hand-carried between sessions — are all costs of forcing bowl-shaped intents through serving-shaped verbs. If the hypothesis holds, the highest-leverage tooling move isn't better file tools with UDON awareness bolted on; it's corpus-level verbs (resolve, select, upsert-with-expectations, census) with the serving handled underneath — and it's testable the O9 way: put both verb sets in front of working agents on a live corpus and watch which they spontaneously reach for, and where each one's failure modes land. Nothing below depends on the hypothesis being true; most of what's below is what those verbs would have to mean if it is.

The pattern also has a shipped body of practice outside this estate to learn from — LSP- and tree-sitter-driven code editing — and the value of that is plain: something external to study for inspiration, principles, and learnings, where design decisions have already been paid for and their consequences are observable. Not corroboration (we have no measurements of how well agents actually take those tools up, and the fragments we do hold cut both ways), and not a race lost — just the cheapest available source of worked answers to questions we'd otherwise pay to rediscover. LSP-driven editing agents work over the *symbol graph*, not the file layout: rename-symbol is resolve-identity-then-edit-every-serving, find-references is the census, go-to-definition is the resolver, workspace-symbols is corpus-level query; tree-sitter-driven tools (ast-grep and kin) query and edit *structure* rather than lines. Those are bowl verbs over code, shipped and load-bearing. And the same ecosystem carries the honest counter-lesson: many agent harnesses still grep even where LSP is available, because the logical verbs cost setup, latency, and per-language coverage while grep is universal and instant — the friction *differential* governs adoption (O9's exact mechanism, observed in someone else's domain). Two consequences for us: UDON's grep-legibility is not a transitional crutch but the permanent fallback the logical verbs must beat on cost, not just correctness; and the vivarium day-report's "reads beautifully under grep" is the baseline any corpus-verb suite gets measured against. (Neither tool family was loaded in this conversation — this paragraph is from training knowledge, stated as such; a real prior-art pass on LSP/tree-sitter agent tooling is cheap and owed before this leg is leaned on hard.)

And the estate holds a live instance after all, with adoption evidence of its own: **relata** effectively subsumes the grep-like verbs into its `relata <verb>` command topology — resolve, show, verify, ingest, emit over the *corpus*, with the file layout opaque behind them by construction — and Joseph's field observation (testimonial, worth the O9-style measurement eventually) is that agents pick it up very intuitively *even though he finds it complicated*. That inversion is itself informative: a git-style verb topology rides an enormous training prior, so corpus verbs don't have to win on novelty — they win when their names land where agents' priors already are, which is the hallway-testing k* point wearing CLI clothes. It also means the paths-v0 direction (promote relata's designator/ladder shape to the path layer) inherits not just a shipped design but a shipped *adoption result*.

## 1. The bowl and the serving

The population is: typed elements (the element name is the type discriminator, for free), an identity space (`[key]`), edges (attributes as labeled edges — an edge may terminate at a leaf or a node, per CORE §6.1), order where order is content, and per-part properties — canonicity, lifecycle, admission rules — that today live mostly in convention. A *serving* assigns all of that to files, directories, and regions.

What makes this more than vocabulary: the placement layer keeps getting *meaning* assigned to it (the harness tree's `canonical/` vs `stalled-lineage/` directories; filename designators; region position in a file), and the honest reading we landed on is that **placement is an encoding of a declared property, not the property itself**. A directory is a rot-resistant encoding of canonicity (changing it takes a `git mv`, which can't go stale silently the way a `status:` field can — that's a described, shipped practice, not my invention). In UDON the property could be carried in-band and the placement generated. Whether it *should* be is open; that it *can* be is what "unserved" means.

TST gives the serving a criterion instead of taste, with two corrections from the grounding report that matter: the atom is the **changeset**, never the file (`#def-atomic-changeset`, axiomatic — a file is a proximity container whose merit is how much of a typical changeset it contains, which is literally `#def-system-coherence`); and any co-change measurement justifying a layout is confounded *by* the layout (the named C2 confounder), so only directional asymmetries carry causal weight. Both at their stated tiers; neither is mine.

## 2. ACID, transposed honestly

This is the part I'd most like attacked, because the central identification is mine and unchecked. Start from what a real database means by each letter, then say what the estate's shipped mechanisms actually provide:

```sql
-- What a traditional store gives you, that a corpus deliberately declines:
BEGIN;
  UPDATE decisions SET status = 'superseded' WHERE key = 'old-frame';
  INSERT INTO decisions (key, status, ...) VALUES ('new-frame', 'decided', ...);
COMMIT;  -- one arbiter, serialized, all-or-nothing across rows
```

**Atomicity** exists in the corpus at exactly one grain: the single-placement atomic write (`safe_write`: temp + fsync + rename — described identically in three shipped systems). Multi-file transactions don't exist, and the estate's universal answer is a design move, not a workaround: *shape the write set so it decomposes into single-placement writes*. The neurips trade study says "the data model has no operation that needs them" as an observation; I think it's secretly a rule — **choose placements so the typical atomic changeset fits inside one atomicity unit** — and if that's right, TST's coherence and ACID's A are the same constraint seen from two disciplines. That identification is *proposed, by me, checked by nobody*. The counter-evidence to watch for: cluster records (one logical record spanning body + regions + sibling event dirs) are exactly where the estate's observed anomalies live — cross-store reads that disagree with no local signal, region edits whose intent lands in commit subjects because nothing else can carry it.

**Isolation** is by *partition*, not by locks — and concurrency is already functioning as a layout criterion in the wild: per-key files make concurrent writers filesystem-disjoint; event directories use collision-free filenames (`<ts>-<decider>-<action>`); embedded frontmatter event logs were scored (in the report's description of udon-needs' `verified:` field) as "cheaper to write and harder to append concurrently." Same-key contention is deliberately unserialized — it surfaces in `git status` as a content disagreement wanting judgment, which is a decision, recorded with its reason. Where true serialization is needed, the estate builds a single-writer membrane (the ingest spool with one drainer; CHRONICA's single-writer with fork-as-new-genesis, never silent dual-write).

A measured hazard makes this concrete: vivarium's `DECISIONS.decision-log.udon` is *one* 460KB file holding 121 records, actively growing (897→903 lines within hours during the CONSUMERS scan). Record-grain intents against file-grain atomicity means two agents' unrelated appends can last-writer-win over each other. Nothing in the file declares this risk; the role taxonomy below is partly for that.

**Consistency** is a judgment, not an enforcement — the non-invasive-judge position: recognition is total, keep-everything holds, and the conformance verdict is a separate, attributable artifact. Whether a check *gates* tracks the consuming deployment's stakes × reversibility (the logos-gates / asf-warns pair on one shared machinery — described, shipped). **Durability** is git plus fsync plus hash chains where integrity matters, with deletion as a tombstone *record*. Neither needed anything from us.

## 3. Strata on different clocks — what the theorem actually licenses

The Kelvin–Helmholtz thread (Joseph's original framing, Part 5 of the 2026-07-23 generalization note) was adjudicated by tst-grounding against `#der-multi-timescale-stability` (status: *exact*), and the adjudication inverted the physics while preserving Joseph's correction that mixing is the mechanism, not the pathology: **rate difference is what makes stacked layers stable, and the two document pathologies are one theorem's two conditions violated separately** — canon churning at spike tempo is (C1); changelog-voice leaking into canon is (C2), and it is directional, fast-to-slow, not symmetric.

Held to that theorem's own limits — its premises assume continuous dynamics, documents jump, and the gap is on AAT's *own* open list — only the qualitative structure transfers. Never export the `ε_max` formula to documents. Within that limit, three compositions from this conversation, all *proposed*:

- **(C2)'s sensitivity coefficient is the write membrane's permeability, named.** The gates the estate already builds (spool validation, ratification, Gate-4 dispositions) are the dial that keeps canon insensitive to fast-layer transients. And the theorem's warm-start refinement prices early promotion rather than forbidding it — integrating unsettled output costs extra slow-layer reserve, which in our register is review capacity. A membrane can charge that price explicitly.
- **Versioned compliance groups are the macro-clock, already practiced.** The theorem's constructive escape from its own failed premise is architecturally enforced separation — one slow tick per K fast ticks. A `core-vX.Y.Z` tag with a frozen fixture group is exactly that: canon ticks per release while the spike layer ticks continuously. The estate built the stability mechanism before knowing the theorem wanted it.
- **Isolation-by-partition is what makes strata separable at all** — disjoint placements are how each layer owns an independent write clock, which connects §2 to this section: the concurrency design and the stability design are the same design.

The theorem also supplies one sharp negative worth keeping loaded: slowing the slow layer helps only against (C1) — it buys nothing when the fast layer has no settled state to offer. A moratorium over genuinely open questions is theatre, and now we know why.

## 4. Partial-corpus upsert — the operation a traditional store never needed

```sql
-- Upsert with an arbiter: one statement, one identity test, one winner.
INSERT INTO terms (slug, status) VALUES ('serving', 'open')
ON CONFLICT (slug) DO UPDATE SET status = EXCLUDED.status;
```

Decomposed against a corpus, "upsert" turns out to be five separable factors, each with a shipped answer somewhere and no seat anywhere:

1. **The target may be plural or absent** — the declared arity/expectation axis (`{0,1}` "if present, exactly one, and that's the one I modify" *is* upsert semantics), with divergence triggering graduated dialogue, not binary failure (O15, pre-validation).
2. **The target may be a part** — a region, a stack position — while the record's other parts belong to other actors and clocks. Wants region addresses and per-part write rules.
3. **Schema versions are heterogeneous, with the coexistence window's end a design question, not a law.** `was:`-style read-time translation is one shipped answer (rowan's); whether translation persists forever or discharges through a censused contraction (O4/O7) is precisely open. A caution attached: the famous expand:contract ≈ 5:1 ratio was measured in Rails — an environment where contraction is a fully-priced flag-day — so it measures tool-shaped behavior, not domain nature; that 926 contractions happened *anyway*, deliberately, at full price, reads to us as demand evidence *for* a contraction mechanism. What the ratio becomes under affordable coexistence windows is unmeasured anywhere, and is the falsifiable fork the O4/O7 design is a bet about.
4. **Identity must be resolved, never minted.** Collision-avoidance and identity-resolution look identical at the call site and are opposite operations; synthesizing a disambiguated key on collision is the locally-correct, globally-corrupting move (29 duplicate clusters measured in relata before the regrowth gate). The safe form is **resolve-then-enrich**.
5. **The batch is non-atomic with typed residue** — promoted / `.rejected` (you erred) / `.needs-review` (I'm unsure) as three first-class outcomes, the last two being different speech acts that must not collapse.

## 5. File roles — the first-effort taxonomy, and what each rung buys

Joseph's proposal, sharpened over several turns. Two axes deliberately kept apart (the estate's collapse-two-axes lesson): **role** declares the record mapping; **regime** (append-only, single-writer, membrane rules) is a separate declaration and stays with the governance work.

**(a) atomic** — file = one record (or a small 1-1 cluster). Filename is the key; the shipped norm of relata/terminology.
**(b) multi-record** — one file, many records as true siblings. UDON needs no `---` separator: multiple top-level elements are already siblings with no implicit root, and the streaming AST already ships completed root-level subtrees as its unit — so (b) is nearly the recognizer's native grain, and the declaration adds what recognition can't: that each top-level element is an upsert/dedup/chunk *unit*, and that record-grain writes against this file need read-modify-write discipline (the DECISIONS hazard above). Measured live in vivarium and our own registers:

```udon
|decision[file-roles-first-effort] :date 2026-07-29 :by joseph :status brainstorm :topic layout
  |reason
    Roles currently live in each reader's inference, and inference rots.
|term[serving] :status open
  |rel :to placement :kind synonym-candidate
```

*(parses today exactly as it reads: two top-level records, heterogeneous types, no wrapper.)*

**(c) snippet** — (or *partial*) a file meant to be pulled into something else, and the rung with the elegant formal reading: **a snippet is the interior of an element whose opening line lives in the host.** Its top-level `:attributes` are the element's attributes, contributed by the file; the host's include site supplies the element line. Which exposes what this is: *frontmatter, re-founded in one grammar* — the YAML-frontmatter seam ("the schema goes dark at the `---`") dissolves because the attribute section and the body share one recognition and one address space:

```udon
:register interior
:src fable
A snippet body — the interior of an element whose opening line lives in the host.
```

*(Honest state: the current parser reads those attribute lines silently as text; 0.9.1's L1 ruling would warn and keep them as document text. Making them* mean *something is role-scoped territory — the one place in this whole letter that touches a ruling, and it stays open. Note L1's own rationale is "no phantom owner"; a declared snippet role answers that rationale — the owner exists, elsewhere — rather than overriding it. But that's an argument, not a ruling.)*

Two corollaries Joseph supplied that make (c) nearly free. First: **every markdown file is already a (c)-snippet with an empty attribute section** — the world's `.md` corpus is a pre-existing UDON snippet population; you don't convert a README, you *inter* it. Second, the interring rules: **`.md` → auto-escape** (a leading `\` on just the lines whose first character would pass a marker guard; `\` also kills the framed-`;` affordance, so both measured hazard classes — line-initial promotion, which bit our own registers twice, and the SEMI-BASE comment divergence — vanish in one reversible, idempotent character); **`.udon` with zero declared elements → suppressable warning** ("prose wearing a structure extension — did you mean `.md`?"), with suppression carrying a reason so it doesn't become invisible convention. The extension is the role declaration; the membrane adapts; recognition stays one-mode.

**(d) view** — and this rung came from Joseph's OUTLINE+segments correction, which changed my picture. A view is a stored query over the population *that carries its own data*: the OUTLINE's chapter grouping, §-positions, claim glosses, and ordering exist nowhere else and cannot be regenerated. So views split into **generated** (LEXICON, `_emitted/` — regenerable, clobber-guarded) and **authored** — canonical about its own fields, referential about the records'. The model reading that organizes it: the view's per-record metadata is **attributes of the membership edge, not of the record** — "whose name is it?" one level up. The duplicated `stage` field is the diagnostic: it sits on both sides because nobody had the edge/record distinction to assign it with, and it rots exactly as denormalized edge-copies do (known, checked, warnings-only).

```udon
|chapter[3] :title Composition & strata
  |row[def-adaptive-tempo] :n 3.2 :gloss Tempo is rate times gain, summed over channels.
  |row[der-tempo-composition] :n 3.3 :stage draft
    Deliberately ahead of its dependency in reading order; accepted 2026-07-12.
```

*(parses today; the row's identity names the record — no reference-tuple growth, S14 untouched — and the row's attributes are the edge's. UDON's ordered content carries the view's determinative ordering natively, since reordering is never core-equivalent; no `seq:` fields needed the way order-less maps force. Could also probably be `@row[...]` arguably-- an ambiguity this discussion is starting to find legs for.)*

```sql
-- The same object, RDBMS-dialect: a join table with edge attributes,
-- whose PRIMARY KEY is the *position* — which is exactly why the estate
-- ruled position-is-not-identity and keyed exceptions by relation instead.
CREATE TABLE outline_rows (
  chapter      INT,
  position     INT,
  segment_slug TEXT REFERENCES segments(slug),
  gloss        TEXT,          -- the view's label for the record
  stage_copy   TEXT,          -- checked denormalization; known to rot
  PRIMARY KEY (chapter, position)
);
```

The view's ordering constraint — checked against the records' own `depends:` DAG, *but not always* — is a **per-view declaration**, not a table property: "this view's order must be a topological linearization of the population's dependency edges, modulo accepted exceptions," with the exception store keyed by the (segment, depends-on) *relation* so it survives row moves and goes stale detectably. Enforcement profile per deployment, as always.

One more consequence for paths: views create the **via** distinction — addressing a record by identity (stable) versus *through* a view ("chapter 3's second segment"), which is order-sensitive and deliberately fragile but a real speech act builds and pedagogy need. A path design that admits view-relative addresses while marking their stability as the view's, not the record's, turns position-is-not-identity from a preached rule into an addressable one.

## 6. Heterogeneity, and where the fiat lives

Every live corpus the extraction probe measured is a type-discriminated mix — term/rel/note/section, decision/reason/impact/ref, phase/charge/promise/defeasance — never one type. So a collection's schema is **a spine (identity, the shared always-present fields) + a family of per-type schemas + a closure claim over the type set**. The first two are extractable from the corpus, mechanically (measured). The third is not extractable from anything, ever in the constitutive sense: whether `|quote` is *in* the family is a commitment someone makes and answers for. That's the fiat-strata result from earlier this session (working-synopsis §4) landing here: the extractor supplies the open half; closure, reasons, and bindingness enter by declaration, with their reasons attached so they can be argued with.

## 7. Includes as liquid, with declared pre/postfilters

If includes ride the dynamics tier (liquid-like — the baseline `!` dialect), the interring transforms stop being tool magic and become **declarations at the include site**, defaulted by role, overridable in place:

```udon
|appendix[field-notes] :title Interred field notes
  !include notes/2026-07-28-sketch.md | escape | ornament-trim
```

*(parses today as a directive with its head carried unparsed — the pipeline spelling is illustrative, not proposed syntax; the head is dialect territory.)*

Two type signatures hide under "filter" and should stay named: a **prefilter** is bytes→bytes, applied before recognition (escape, dedent, frontmatter-lift, region-select) — it decides what the recognizer sees; a **postfilter** is model→model (strip a region, drop comments, trim ornament) — it decides what the host receives. Confusing them produces silent no-ops in one direction and impossible demands in the other.

What this buys beyond plumbing: it generalizes the build-variant problem the estate already suffers — the `:public`/`:review` Working-Notes stripping that's currently a `rindex` truncation welded into a renderer becomes a declared postfilter chain on an authored view's rows; per-audience projection ("interior traces must not survive publication") gets a visible spelling; and three disciplines come along cheaply: the filter set is **dialect vocabulary** (versioned, imported, bounded — pure value-through transforms, no state, no reachback, so the power envelope holds); the **chain is part of the ascription** (what was done to the content travels with who-said-it and where-from; chain + content-pin = reproducible interring — provenance of transformation, which I don't know any include mechanism to record); and degradation is **whole-or-inert** — an unresolvable include or unknown filter yields the inert no-op, never half-filtered content, because half-applied prefilters are exactly how foreign bytes get interred unescaped.

## 8. What we don't know, so you don't inherit it as knowledge

- **The atomicity-grain ≡ coherence identification (§2) is mine, unchecked.** If it's wrong, the serving criterion loses its nicest unification and keeps its TST half only.
- **The (C1)/(C2) document mapping rides an exact theorem across a named failed premise** — qualitative only, and whether jump dynamics preserve even the two-condition structure wants a hybrid-systems eye. tst-grounding says the same; nobody has supplied that eye.
- **(c)'s root attributes are gated on the L1 conversation**, and nothing here rules it. The wrapper convention (an anonymous `|[id]` element, host splices) works today if demand arrives first.
- **Role declaration surface is undecided** — filename designator vs pragma vs collection default — and PRAGMA is an open carve-out with its own reasons; nothing here should be read as closing it.
- **The five-times-recurring prior (role + membrane, never language law) is a pattern in one conversation**, single-author-cautioned twice over: same estate, same conversation, same two minds. Treat it as a hypothesis with a good base rate, and notice when a sixth case *resists* it — that resistance would be the informative event.
- **Whether contraction demand materializes under cheap tooling** (§4 factor 3) is the unmeasured number the O4/O7 bet turns on.
- **None of this has been tried on a live corpus.** The generalization note's own closing line applies to us with full force: per the retrofit evidence, the informative test is the hardest invariant-bearing case, not a friendly new one.
- Probably a lot more.

The one-sentence version, for your pocket: *the bowl is declared, the serving is chosen for coherence, the strata stay stable through membranes and macro-clocks the estate already builds, and paths, upserts, schemas, and views are four interfaces to one declaration — which is why they keep converging on the same open questions.*

Push on any of it — the parts that survive you will be worth more than they are now.

— Fable, 2026-07-29

*(Working note, X4-style: if you land any piece of this into the seeds, the natural homes are — §5's roles into the schema seed's layout axis (A.2) and the markdown seed; §5(d)+§7 into living-documents (the include primitive's second half); §3 into tst-grounding as a citing consumer; §4 into the paths seed beside the speech-acts material. The synopsis's §2–4 should probably absorb the corrected versions of doc-stores/ACID rather than keep their earlier, softer statements — but that's an integration-is-replacement pass I didn't do tonight.)*
