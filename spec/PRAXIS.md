# UDON v2 Specification Praxis & Working Ontology

*Status: **draft** (2026-11-23; not yet ratified by Joseph). Non-segment working document for any mind authoring, reviewing, or auditing `spec/`. Nothing here has authority beyond being true; revise when real spec work pushes back.*

## Purpose & Mental Model

This specification defines an abstraction — the UDON notation and its syntax-to-`«AST»` contract — where *abstraction* is held in all three senses: (v) forgetting irrelevant details so different things can be treated the same, (n) the resulting artifact, and (n) a method or language feature for abstracting.[^1] Keeping **abstraction** distinct from **decomposition** matters throughout: slicing a spec into small segments is decomposition; letting a reader rely *only* on a term's or rule's stated contract without reading internals or history is abstraction.[^2]

## 1. Readers & Projections

Rather than serving one generic reader, this verisectorium serves **three distinct projections** over shared segments[^3] — splitting the classic client/implementer duality cleanly across a document notation's two seams:[^4]

1. **Parser Implementer** *(the primary reader of `spec/canonical.outline.md` today)*[^5] — needs total behavior across all inputs (valid and invalid), exact `«AST»` guarantees, required errors and warnings, explicit implementer freedoms (`‹may›`), and streaming/lookahead constraints.
2. **AST Consumer** *(host programs, schemas, queries, verisectoria calling a parser — the literal client of the parser module)* — the exact dual of the Parser Implementer: what preconditions the caller must provide (e.g., encoding, complete `«partial»` with `eof`, file metadata for a `«document»`), what `«AST»` invariants it may rely on (e.g., ordered children), and what it **must not** assume (e.g., attribute order across distinct names).[^6]
3. **Document Author / Pedagogy** *(humans and agents reading and writing UDON text)* — needs progressive disclosure, idioms, and mental-model heuristics rather than parser corner cases.[^7] Although the dedicated pedagogy outline comes later,[^8] **drafting author-facing explanations alongside tricky rules is an active early fitness check**: awkwardness in explaining a rule to an author exposes spec flaws before any parser is built.[^9]

The **`«AST»`** sits on the Implementer ↔ AST Consumer boundary; **concrete UDON ↔ `«AST»` examples** span all three projections.

## 2. Three Failure Modes & Primary `‹determinants›`

A parser specification can fail in three independent ways — corresponding to three validation levels that each hold a different artifact fixed:[^10]

1. **The spec itself fails** *(internal spec quality — consistency, determinacy, clarity, over-specification).*
2. **An implementation fails to comply with the spec** *(unit/conformance failure — spec held fixed).*
3. **A successfully compliant parser still fails at UDON's primary purposes** *(fitness / acceptance failure — spec itself on trial against UDON's goals and real use).*

Mapped onto verisectorium's **decided** vs. **found-out** atoms,[^11] these give six orthogonal primary `‹determinants›` for `udon/spec/`:

| `‹determinant›` | Atom | Held against | What it asks |
|---|---|---|---|
| **Intent & Standing** | *decided* | Steward / design intent | Does this express what UDON is meant to be (principledness, least surprise, streaming-compatibility), and who stands behind it (`‹draft›` / lean vs. `‹accepted›`, in whose located words)?[^12] |
| **Determinacy (Accountability)** | *found out* | All inputs meeting preconditions (valid & invalid) | Does the spec yield a single decidable obligation (`«AST»` + diagnostics) or an explicitly marked latitude (`‹may›` / `‹should›`), so that if two parsers disagree, fault is decidable?[^13] |
| **Consistency** | *found out* | The rest of canon across composite inputs | Do terms, invariants, and rules agree without contradiction when combined? |
| **Locality (Self-contained Clarity)** | *found out* | A cold implementer or AST consumer reading the spec alone | Is every obligation and technical term intelligible from the spec alone without reading a reference parser, archive history, or the author's head?[^14] |
| **Abstraction Integrity (Modifiability)** | *found out* | Observable behavior vs. implementation internals | Does the spec pin down observable contract (preconditions, `«AST»` guarantees, diagnostics, explicit non-guarantees) without leaking *how* to parse or represent it internally?[^15] |
| **Fitness** | *found out* | UDON's objectives, real usage, and author-manual probes | Does a compliant implementation actually serve UDON's primary purposes (not merely stay internally consistent)?[^16] |

*(**Conformance** — Failure Mode 2 — is defined by membership in the specification's **specificand set**, not by passing any finite test suite. Conformance fixtures and property/invariant drivers are the primary repeatable **means** for validating compliance and stress-testing Determinacy and Consistency, correcting the older claim in `defining-udon.md` that fixtures alone define compliance.)*[^17]

## 3. Specification-Craft Rules

Seven concrete disciplines for drafting and reviewing segments here:

1. **Two-tier structure, evolved in tandem.** Keep the language-independent `«AST»` value model (auxiliary tier: `spec/def/`) clean of concrete syntax spellings, and build parser rules, diagnostics, and streaming on top of it (interface tier).[^18] Starting definitions-first prevents jargon explosion,[^19] *provided* we expect Part 1 definitions to be refined whenever Part 2 rules push back — never frozen prematurely.[^20]
2. **Define `«AST»` equality by explicit observer sets (`partitioned by`).** State exactly which observations distinguish two `«AST»` values and which do not — making implementer freedoms and consumer non-assumptions explicit (e.g., attribute order excluded; repeated-value order explicitly decided; `content < content+meta < content+meta+ornament` layered cleanly; pure structural value equality vs. shared-node identity kept apart).[^21]
3. **Hunt omissions systematically (`generated by` & construct × context tables).** Whenever a construct interacts with multiple contexts (line start, sameline, indented body, embedded, EOL, EOF), inspect the full matrix so every cell is either specified or *explicitly* omitted/errored — never silently missed.[^22] Unspecified cells often mark exactly where parser errors belong.
4. **Definitional over operational; explicit underdetermination; safe multi-error semantics.**
   - State *properties* of the input→`«AST»` mapping rather than a parsing algorithm; treat any operational or PEG sketch as non-normative (or proven equivalent) so it does not quietly overspecify lookahead or exclude streaming parsers.[^23]
   - State UDON's streaming/lookahead bound ("kind within a character or two; no unbounded holdback") as an **explicit efficiency constraint** beside the functional rules.[^24]
   - Distinguish parser **determinism** (same input → same output) from explicit spec **underdetermination** (`‹may›`, e.g., attribute iteration order or permitted AST variation). Silence is ambiguity; declared latitude is modifiability.[^25]
   - Cover the **entire input domain** (malformed inputs have required diagnostic postconditions, not undefined behavior). Where one malformed input can satisfy multiple error conditions at once, use nondeterministic choice among true error conditions (`signals e_i => PrePred_i`) unless error priority is explicitly specified — otherwise flat "if A then E1; if B then E2" rules make fail-fast parsers contradict the spec.[^26]
5. **Use marked cross-register redundancy (`I.e.` / `E.g.`).** Repetitive same-register prose is noise; *explicitly marked* redundancy across registers (normative prose + formal invariant/observer statement + concrete `.ud ↔ AST` examples) prevents silent misunderstandings and exposes spec bugs by internal collision.[^27] Keep every example strictly typed as a restatement: if an example goes beyond its rule, one of them is wrong.[^28]
6. **Check for pseudo-generalizations and uniform criteria.**
   - **Disjunctive-coherence test:** If a term's or rule's normal behavior has a top-level `A | B` split ("if kind X do this, else if kind Y do that"), it is likely a pseudo-generalization — split it or look for the missing abstraction underneath. Real generalizations bury variation deep inside shared mechanics.[^29]
   - **Rejected alternatives as active review tools:** Recording *why* an alternative was rejected in `## Discussion`, `## Historical Context`, or `DECISIONS.kdl` is not just archaeology — it gives reviewers a uniform criterion to test whether accepted parts of the spec silently violate the same rule.[^30]
7. **Keep the four record surfaces apart, and keep ordinary words ordinary.**
   - Standalone present-tense body (`# «term»`, `## Definition`, `### Invariants`, `## Examples` — no file paths, note numbers, or "see X"); `## History` / `## Historical Context` for provenance and outward breadcrumbs; `## Working Notes` as a drainable inbox; `DECISIONS.kdl` as the decision ledger recording *how* each choice was made and *in whose verbatim words*.[^31]
   - **One home per invariant:** state an invariant once, in the definition of the thing broken when it fails; other segments name the term rather than restating it.[^32]
   - **Ordinary meanings first:** before inventing a new term or giving a standard word (`«AST»`, `«root»`, `«node»`) a special sense, state the nuance plainly in one sentence using ordinary meanings and existing terms.[^33]

## Working Notes

*Drainable inbox of concrete bites these rules already surface on current drafts (`spec/def/{AST,element,root}.md` are still awaiting Joseph's first read):*

- `spec/canonical.outline.md`: clarify whether `canonical.outline.md` stays solely the Parser Implementer projection (with AST Consumer guarantees marked as its dual) or splits later, and note the early author-manual fitness probe against `DECISIONS.kdl`'s `pedagogy-outline` entry.
- `spec/def/AST.md`: sharpen Working Note L39 (parser equivalence vs. `CTQ-FACTORS` b3) using determinism vs. explicit underdetermination; resolve DAG vs. tree (`L37`) via `equal` vs. `similar` / value-sort equality; note the missing guillemets on plain `AST` in the opening paragraph when Joseph next reviews it.
- `spec/def/element.md`: frame the unordered-attributes invariant (`L25`) and repeated-name ordering (`L46`) via an explicit `partitioned by` observer list once `«attribute»` and `«value»` are drafted; keep `content < content+meta < content+meta+ornament` layered cleanly.
- `spec/def/root.md`: resolve the plain "as attributes" vs. `«attributes»` nit (`L45`) when Joseph reviews the file.
- `spec/.influx/defining-udon.md`: when drawing from it, replace its L42 claim ("passing the canonical fixture suite is the *only* definition of compliance") with specificand-set compliance + fixture/property-driver validation.
- Still unplaced from `.archive/` / `.influx/`: UDON's primary objectives/purposes (needed to make the **Fitness** determinant concrete and checkable).
- OCaml auxiliary-tier candidate (`DECISIONS.kdl`, `ocaml-auxiliary-and-staged-toolchain`): lean toward using a tiny, pure ML/OCaml subset (`type`, variants, records, lists, `option`, `partitioned by` equality) as the executable auxiliary model behind `spec/def/` and compiled `E.g.` fixtures (keeping any operational reference parser strictly separate from definitional compliance).
- Future toolchain spike (before committing to OCaml for Stage 2/3 reference parsing or Rust parser-generation): test how cleanly OCaml handles UDON's specialized indent/dedent and column-positioning mechanics (block nesting, sameline nesting, deeper-marker text, fence dedenting, bounded-lookahead streaming), both with and without a minimal lexing pass.

---

*Note on footnote file references: the locations of files cited below will almost certainly change over time, though they should remain in this repository (or the cited sibling repository). Please use `git` and search to find their current location as needed rather than expecting maintained relative or absolute paths here.*

[^1]: `spec/.influx/spec-notes.md` (ch. 1, abstraction as forgetting unimportant details + artifact) and Joseph Wecker's third sense (method/affordance/language feature for abstracting), 2026-11-23.
[^2]: Barbara Liskov & John Guttag, *Abstraction and Specification in Program Development* (MIT Press, 1986), Ch. 1.1–1.2.2, pp. 2–9; quoted in `spec/.influx/liskov-guttag-1986-insights.md` Part II §6.
[^3]: Verisectorium model: `~/src/verisectorium/msc/notes/30-2026-11-19-model-in-a-nutshell-after-four-stores.md` §5 and `30-addendum.md` §§1–2, 7 (canonical outlines declared per reader over shared pieces).
[^4]: `spec/.influx/spec-notes.md` (client vs. implementer duality) and Joseph Wecker's Consumer vs. Implementer projection cut (2026-11-23), refined into Parser Implementer / AST Consumer / Document Author in `spec/.influx/liskov-guttag-1986-insights.md` Part I §5.
[^5]: `DECISIONS.kdl` (`canonical-outline-reader`, 2026-11-20) and `spec/canonical.outline.md` Brief.
[^6]: Liskov & Guttag (1986), Ch. 1.2.2 pp. 8–9 ("We can assume only those properties that can be inferred from the post-condition") and `spec/def/element.md` L24–L25.
[^7]: `spec/.influx/defining-udon.md` Part 3 (Pedagogy: progressive disclosure, mental models, idiom over allowance).
[^8]: `DECISIONS.kdl` (`pedagogy-outline`, 2026-11-20).
[^9]: Liskov & Guttag (1986), Ch. 12.2, p. 256; quoted in `spec/.influx/liskov-guttag-1986-insights.md` Part I §5.
[^10]: Joseph Wecker's three failure modes (2026-11-23) paired with Liskov & Guttag (1986)'s Unit / Integration / Acceptance validation triad (Ch. 9.2 p. 173; Ch. 11.5 p. 248; Ch. 12.1 pp. 251–252), in `spec/.influx/liskov-guttag-1986-insights.md` Part II §5.
[^11]: `~/src/verisectorium/core/def/dimension.md`, `~/src/verisectorium/core/def/decision.md`, and `~/src/verisectorium/msc/notes/30-2026-11-19-model-in-a-nutshell-after-four-stores.md` §§4, 6.
[^12]: `~/src/verisectorium/msc/notes/30-2026-11-19-model-in-a-nutshell-after-four-stores.md` §6 ("What was done in deciding", "In whose words") and `DECISIONS.kdl` header.
[^13]: `spec/.influx/spec-notes.md` (accountability and ambiguity causes 1 & 2) and `spec/.influx/defining-udon.md` Part 2 §§2–3 (RFC 2119 + strict error handling).
[^14]: `spec/.influx/spec-notes.md` (locality and ambiguity cause 3) and `~/src/verisectorium/core/def/README.md` ("Standing alone").
[^15]: `spec/.influx/spec-notes.md` (modifiability), `spec/.influx/defining-udon.md` Part 1 (Principle of Isolation), and Liskov & Guttag (1986) Ch. 4.5 (two abstraction functions: `SourceText -> AbstractAST` vs. `ConcreteRep -> AbstractAST`, plus benevolent side effects).
[^16]: Joseph Wecker (2026-11-23, adding fitness alongside locality, modifiability, and accountability) and `~/src/verisectorium/msc/scratch/vision-2026-11-21/PRIMER.md` ("The wrong universe was pushing back").
[^17]: Liskov & Guttag (1986), Ch. 8.1 p. 150 (specificand set) and Ch. 9.1–9.3 pp. 162–174 (black-box/glass-box limits and invariant-checking drivers); see `spec/.influx/liskov-guttag-1986-insights.md` Part I §6 vs. `spec/.influx/defining-udon.md` L42.
[^18]: Liskov & Guttag (1986), Ch. 10, pp. 187–188 (auxiliary specifications / traits vs. interface specifications); `spec/.influx/liskov-guttag-1986-insights.md` Part I §1.
[^19]: `DECISIONS.kdl` (`definitions-first`, 2026-11-20).
[^20]: Liskov & Guttag (1986), Ch. 10.3, p. 216 (traits and interface specifications developed in tandem).
[^21]: Liskov & Guttag (1986), Ch. 10.1.2 pp. 198–199 (`partitioned by`) and Ch. 4.9.5 pp. 93–94 (`equal` vs. `similar`); `spec/.influx/liskov-guttag-1986-insights.md` Part I §1 and `spec/.influx/spec-lite-incoherences-2026-11-07.md` L51.
[^22]: Liskov & Guttag (1986), Ch. 10.1.4–10.1.5, pp. 201–205 (`generated by` + sufficient-completeness as candidate generator); `spec/.influx/liskov-guttag-1986-insights.md` Part I §1 and `spec/.influx/spec-lite-incoherences-2026-11-07.md` L17–L18, L53.
[^23]: Liskov & Guttag (1986), Ch. 8.2.2, p. 153 (definitional vs. operational specs); `spec/.influx/liskov-guttag-1986-insights.md` Part I §2.
[^24]: Liskov & Guttag (1986), Ch. 13.2.2, pp. 269–270 (efficiency constraints separate from functional spec); streaming/lookahead law in `.archive/sessions/2026-11-06-udon-lite-simplify-1edc52d1.md` Turn 5 and `spec/.influx/spec-lite-incoherences-2026-11-07.md` L36.
[^25]: Liskov & Guttag (1986), Ch. 3.6 pp. 51–52 and Ch. 8.2.1 pp. 151–152 (determinism vs. underdetermination); `spec/.influx/liskov-guttag-1986-insights.md` Part I §2.
[^26]: Liskov & Guttag (1986), Ch. 5 pp. 100–116 (total domain partitioning; exceptions vs. human diagnostics vs. `failure`) and Ch. 10.2.2 p. 212 (`normally ... except` nondeterministic error choice); `spec/.influx/liskov-guttag-1986-insights.md` Part I §3.
[^27]: Liskov & Guttag (1986), Ch. 8.2.3, pp. 154–157 (`billion`, `subset`, `present value`, `too_cold`; "redundant without being repetitious" and mandatory `I.e.`/`E.g.` marking); `spec/.influx/liskov-guttag-1986-insights.md` Part II §1.
[^28]: `spec/.influx/spec-lite-incoherences-2026-11-07.md` L25 ("Example overreaches the Statement") and `~/src/verisectorium/core/def/reference.md` (`restates`).
[^29]: Liskov & Guttag (1986), Ch. 14.1.2, pp. 299–303 (no coherence, conjunctive coherence, disjunctive coherence vs. buried variation); `spec/.influx/liskov-guttag-1986-insights.md` Part II §4.
[^30]: Liskov & Guttag (1986), Ch. 14.1, p. 295 (rejected alternatives revealing non-uniform application of design criteria); `spec/.influx/liskov-guttag-1986-insights.md` Part II §2.
[^31]: `~/src/verisectorium/core/src/disc-record-surfaces.md` and `~/src/verisectorium/core/praxes/working-on-core.md` step 2.
[^32]: `~/src/verisectorium/core/def/README.md` ("One home per invariant").
[^33]: `DECISIONS.kdl` (`ast-means-ast`, 2026-11-20) and `.archive/sessions/2026-11-20-v2-clean-slate-12b5188c.md` Turn 18.
