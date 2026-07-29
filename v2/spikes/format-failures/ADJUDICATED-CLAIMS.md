# Adjudicated claims — document-format failure archaeology

**Status:** Task A complete enough to use as citation substrate; Task B deferred to a short appendix.  
**Date:** 2026-07-29  
**Commission:** `BRIEF-FOR-EXTERNAL-PASS.md`  
**Method:** Independent discovery via parallel primary-source research (five agents + orchestrator fetches) before treating `MINEFIELD-MAP.md` as authority. Claims adjudicated with epistemic status. Inference is labeled and kept separate from evidence.

## Register

| Status | Meaning |
|---|---|
| **supported** | Primary source fetched; quote holds the claim as stated |
| **partial** | Source supports part of the claim, or only under stated conditions |
| **unsupported** | Searched; evidence does not hold, or contradicts |
| **contested** | Credible primary sources conflict |
| **open** | Not yet adequately sourced |
| **inference** | Causal read by this pass — not testimony |

Footnotes: URL, published/accessed date where known, supporting line from the source.

### Already-fetched sources (not re-established; used only if deepened)

Tim Bray XML error handling (2004); Bray draconian annotation; RFC 6648; StrictYAML Norway; CommonMark intro; k8s #14791 / go-yaml / Symfony duplicate keys; Sass syntax docs; Noms→Dolt→Terminus survey depth.

---

## Executive findings (Task A)

1. **RELAX NG did not lose because it was a weaker structure validator.** Contemporaries called it technically superior for structure; XSD won the *typed infoset / data-binding* product surface (PSVI + unique type assignment + vendor tooling).[^rng1][^rng2][^xsd1]
2. **Schematron proves a structural limit of pure grammars** (including full RELAX NG): co-occurrence, cross-tree value relations, multi-document constraints, and human-semantic assertions are not regular tree-language membership.[^sch1][^sch2]
3. **JSON Schema’s draft-07 plateau is maintainer-ratified LTS behavior**, not community laziness — a paradigm break in 2019-09/2020-12 plus unbounded corpus settling time.[^js1][^js2]
4. **Forwards-compat has a real formal literature** (Orchard/TAG Accept vs Defined sets; SOAP mustUnderstand as *selective* override of default ignore). TAG findings never became approved findings.[^tag1][^orch1][^soap1]
5. **XML databases did not vaporize; they lost the category story** to JSON document DBs and relational/analytics gravity, while remaining niche-viable for document-as-asset workloads.[^xdb1][^xdb2]
6. **“Why not git machinery for record grain?” *was* written down** — plainly by TerminusDB (line vs triple) and Dolt (line vs cell/row; “hammer to fasten a screw”).[^git1][^git2]
7. **Indentation-as-syntax has real failure modes** (ambiguous tabs → language-level hard error; paste/auto-indent as semantic mutation) but measured merge-rate studies remain thin; Sass→SCSS is not counter-evidence (already refuted in brief).[^ind1][^ind2]
8. **Append+supersede walks into a documented GDPR collision**; crypto-shredding is operationally common and *legally contested*.[^es1][^es2]
9. **EDN tags work as envelope prior art only if unknown tags are preserved and print grammar is frozen** — host-language `pr-str` is not a multi-year archive format.[^edn1][^edn2]

---

## 1. RELAX NG vs XML Schema

### C1.1 RELAX NG is formally stronger (or equal) for structure validation than XSD 1.0
**Status:** supported

RELAX NG can represent regular tree grammars (plus attribute–element constraints and interleave); W3C XML Schema is mostly within single-type grammars with uniqueness of type interpretation as a deliberate restriction.[^rng3][^rng4]

**Inference:** If selection pressure were “best tree-language validator,” RNG should have won. It did not — pressure was elsewhere.

### C1.2 RELAX NG deliberately refuses infoset modification (no PSVI product)
**Status:** supported

Clark’s design paper: validation does not change the information passed to the application; validation and infoset modification must be separable.[^rng1] Home page: “does not change the information set of an XML document.”[^rng5]

XSD Part 1 defines schema processing as producing a post-schema-validation infoset with type annotations and defaults.[^xsd1]

**Inference:** Product mismatch, not accident. RNG optimizes “is this document in L(G)?”; XSD optimizes “give me typed nodes for codegen/XQuery.”

### C1.3 Unique type assignment favors XSD for data-binding; multi-interpretation of full regular grammars is a real technical impediment to that job
**Status:** supported

Single-type tree grammars admit at most one interpretation per tree; Clark notes type assignment requires restrictions *beyond* RELAX NG itself.[^rng3][^rng1]

**Inference:** Something *technical* about RNG’s model did impede a job people paid for — not validation, but **stable element→type maps**.

### C1.4 Identity constraints and inheritance were intentionally out of RNG core
**Status:** supported

Clark: identity constraints better as a separate specification; inheritance is a major source of XSD complexity without expanding the set of expressible tree constraints.[^rng6]

### C1.5 Contemporaries predicted XSD would win on vendor/W3C weight while calling RNG technically superior
**Status:** supported

Van der Vlist (2001): many constraints expressible in RNG not in XSD; “technically superior” yet “support by software vendors … uncertain now that W3C XML Schema is a Recommendation.”[^rng2]

### C1.6 Market split, not pure defeat
**Status:** partial (secondary + design usage)

Document-centric languages (DocBook, TEI, ODF, EPUB) retained RELAX NG; enterprise data/web-services tooling standardized on XSD. DSDL (ISO 19757) made RNG Part 2 of a multi-schema architecture rather than a monolith.[^dsdl1]

### C1.7 “XSD won because Microsoft” as mono-causal explanation
**Status:** unsupported (as sole cause); **partial** as contingent force

Microsoft/Commerce One consolidation onto XSD is real history in van der Vlist’s family history of schema languages,[^rng2] but the technical attractor (PSVI + types + OOP-shaped schemas) is independently documented.

### C1.8 What Schematron proves about grammar-based schemas
**Status:** supported

Co-occurrence and context-sensitive constraints are “difficult or impossible to model using regular grammars.”[^sch1] Clark: hammers vs saws — use grammars when simple, rules when not.[^sch1] Robertsson (2004): even RNG cannot express quantity×price=total, currency agreement, cross-document stock checks — Schematron can.[^sch2] Jelliffe: grammar languages “don’t express semantics because they cannot.”[^sch3]

W3C later collected co-constraint use cases feeding XSD 1.1 assertions — partial absorption of the Schematron insight.[^sch4]

**Design implication for UDON schemas:** ship grammar *and* assertion layers (DSDL shape), or admit rules will live in ad-hoc code.

---

## 2. JSON Schema draft churn

### C2.1 Large parts of the ecosystem stopped at draft-07
**Status:** supported

Henry Andrews (2022): draft-07 is “the current center-of-gravity of the community”; LTS set includes draft-07 as “last under the previous paradigm.”[^js1] Schema Store census (2025-10): ~64% draft-07, ~21% draft-04, ~9% 2020-12 — ~86% classical.[^js3] Site analytics (2023): `/draft-07/schema` dominant fetch among meta-schemas.[^js4]

### C2.2 2019-09 was a paradigm break; 2020-12 re-broke the middle draft
**Status:** supported

2019-09: vocabularies, annotation-dependent `unevaluated*`, `$ref` siblings, format no longer assertion by default, `definitions`→`$defs`.[^js5] 2020-12: `prefixItems`/`items` redesign; `$recursive*` → `$dynamic*`.[^js6] Maintainers: 2019-09 “hardly out long enough to get traction”; “high cost/low return” to implement.[^js1]

Formal result: modern dynamic refs push validation complexity toward PSPACE vs classical P-complete.[^js7]

### C2.3 Structural hypothesis: corpus settling time is unbounded; draft-07 stall is predicted signature
**Status:** supported (as inference strongly backed by maintainer testimony + corpus data)

Greg Dennis: multi-version implementors provide “zero incentive” for consumers to update schemas.[^js1] Maintainers recommend draft-07 as LTS rather than declaring it dead.[^js1]

OpenAPI lock-in: OAS 3.0 Schema Object is extended subset of Wright Draft 00 (draft-04 lineage); OAS 3.1 pins 2020-12 vocabulary — two gravity wells, not one ladder.[^js8][^js9]

**Design implication:** meaning-changing dialect movement against a live corpus will stall; additivity-by-construction is the repair, not slower cadence alone.

---

## 3. Forwards-compatibility (must-ignore / must-understand)

### C3.1 Forwards-compat requires Accept ⊇ Defined + a substitution rule
**Status:** supported

Orchard: Accept Text Set is a superset of Defined; the gap is extensibility; “Must Ignore Unknowns” is a substitution mapping Accept→Defined; without it, “catch fire and die if unknown” blocks forward compatibility.[^orch1] TAG Compatibility Strategies: “Must Accept Unknowns” good practice.[^tag1]

### C3.2 Must-ignore is not one rule
**Status:** supported

Variants: remove unknowns (early HTML); preserve/forward unknowns (HTTP proxies); Must Accept All (subtree) vs Must Accept Container (element only, process children).[^tag1]

**Must-forward** is distinct: intermediaries must pass unknown fields (HTTP; SOAP `relay`) or end-to-end evolution dies even when endpoints could cope.[^http1]

### C3.3 SOAP mustUnderstand is selective safety, not anti-evolution default
**Status:** supported

SOAP 1.1: MU “allows for robust evolution” by ensuring semantics-changing headers are not “silently (and, presumably, erroneously) ignored.”[^soap1] Default is ignore; MU is the opt-in override. TAG codifies the mixture pattern.[^tag1]

### C3.4 HTML5 evolution vs XHTML 2 clean break
**Status:** supported

HTML Design Principles: support existing content; degrade gracefully; evolution not revolution.[^html5] XHTML 2 introduction: strict element-wise BC “no longer necessary” thanks to XML and stylesheets — premise about the substrate.[^xhtml2] Outcome: XHTML 2 WG expired unfinished; HTML5/Living Standard became the platform.

### C3.5 XML 1.1 non-adoption as natural experiment
**Status:** supported

Walsh (2004): “XML 1.1 *is dead*” after RELAX NG ISO ruled 1.1 documents can never be valid against RNG; schema stack veto.[^xml11] TAG: XML 1.0 lacked extensibility for its own metalanguage; 1.1 is “incompatible change identified as a minor change.”[^tag1]

**Inference:** Version labels without an Accept-set gap at the changed layer are forks, not minor versions.

### C3.6 TAG versioning findings never reached approved consensus
**Status:** supported

Status banners: draft findings for discussion; “does not yet represent the consensus opinion of the TAG.”[^tag1]

---

## 4. XML databases

### C4.1 Category displacement, not pure technical collapse
**Status:** supported

Truică et al. (2021): native XML DBs rebranded as NoSQL document systems then “replaced with the more modern JSON based” DBMS; “forgotten during the Big Data hype.”[^xdb1] Sonra (2026): right answer in 2005; 2026 only narrow cases.[^xdb2] Pavlo: MarkLogic as document-DB ancestor; MongoDB won “by a massive margin.”[^xdb3]

### C4.2 XQuery cost is primarily ecosystem/skill, not always raw performance
**Status:** partial / nuanced

Same paper: BaseX outperformed selected JSON DBs on 3/4 aggregation queries; still concludes XDBMSes “still useful.”[^xdb1] Practitioner texture: steep learning curve; BI/SQL gravity pulls data out for analytics.[^xdb2]

### C4.3 Schema optionality: helped ingest, did not defend the category
**Status:** inference grounded in partial evidence

XML DBs can validate against XSD but need not; surviving niches (ISO 20022, HL7, FpML, DITA) are schema-*heavy*.[^xdb2] JSON flexible documents undercut the semi-structured pitch.

### C4.4 Model vs relational: document-as-asset vs document-as-delivery
**Status:** supported

Sonra: use NXDB when hierarchy/order/namespaces/mixed content *are* the asset; do not when XML is only delivery format and business needs joins/BI.[^xdb2]

### C4.5 Open engines often lacked scale-out primitives
**Status:** supported

Truică comparison: BaseX/Sedna no replication/partitioning; eXist primary–secondary only.[^xdb1]

**Uncomfortable for corpus-as-DB:** closest prior art is real; failure mode is *wrong default for analytics + language/ecosystem tax + category loss to JSON*, not “trees cannot be databases.”

---

## 5. Database-in-git / prolly-tree lineage

### C5.1 Plain statements that git machinery is wrong for record grain **exist**
**Status:** supported (falsifies “never written down”)

TerminusDB: “The crucial difference is **granularity**. Git versions text lines inside files. TerminusDB versions individual **subject–predicate–object** triples… a TerminusDB diff is not a textual hunk… it is a structured, semantic description…”[^git1]

Dolt (2020): Git data diffs “marginal utility”; “Conflict resolution happens at the **line level**. There is no built-in concept of schema.” “using Git for data is not the right tool for the job, like using a hammer to fasten a screw.” Dolt operates on “**table rows instead of files**” with “**cell-wise** diffs and merges.”[^git2]

Noms: “**Unlike Git**, Noms is a database… Primarily **stores structured data, not files and directories**.”[^git3]

### C5.2 Why prolly trees / bespoke CAS: history-independent content-addressed collections at record grain
**Status:** supported

Noms: B-trees/LSM not history-independent; same value must yield same physical chunks regardless of mutation order; Prolly Trees for efficient diff/sync/merge.[^git4] Dolt architecture: “In order to satisfy the version control requirements… we knew we would need our own storage engine… Git storage is not built for fast seek.”[^git5]

lakeFS rejects raw Git for lakes on **scale/storage/format** axes (human-scale, must own storage, binaries/TB files) — complementary, file-grain critique.[^git6]

### C5.3 Convergent evidence: every serious “git for data” rebuilds storage
**Status:** supported

| System | Substrate | Grain |
|---|---|---|
| Dolt | Prolly trees (Noms lineage) | Row/cell |
| Noms | Prolly trees | Structured values |
| TerminusDB | Immutable triple layers | Triple / JSON patch |
| lakeFS | Metadata over object storage | File/object |
| Irmin | Content-addressed mergeable types | User-defined structures |

**Inference for UDON corpus-as-DB:** Git commits as *transaction grain / as-of* can still make sense for **file-level** document corpora; do not expect git line-merge/diff to be the semantic unit for record-level history. Record-grain needs structure-aware diff or a separate store.

---

## 6. Indentation-as-syntax

### C6.1 Ambiguous tabs/spaces are a language-level failure mode
**Status:** supported

Python 3: mixed tabs/spaces that make meaning depend on tab width → `TabError`.[^ind1] PEP 8: “Python disallows mixing tabs and spaces for indentation.”[^ind3] YAML 1.2.2: tabs must not be used in indentation “since different systems treat tabs differently.”[^ind2]

**Inference:** The repair is refuse ambiguity (or forbid tabs), not abandon indentation syntax.

### C6.2 Paste + auto-indent is semantic mutation under indent-syntax
**Status:** partial (practitioner primary, not controlled study)

Zed #13338: pasting “changes the semantics of the file quite a bit.”[^ind4]

### C6.3 Measured transport/merge failure rates
**Status:** open

No controlled study adequately sourced this pass. Normative language reactions (Python/YAML) are stronger evidence that the failure is real than blog posts.

### C6.4 Sass indented → SCSS as evidence against indentation syntax
**Status:** unsupported (already refuted in commission brief; not re-opened)

---

## 7. Event sourcing pain points

### C7.1 Events are immutable; versioning/upcasting is mandatory
**Status:** supported

Greg Young: once you allow a single edit, proper audit becomes impossible; rebuild current state from the log is the bar.[^es3] Azure: “you should never update the event data”; list tolerant read, versioning, upcasting, in-place as last resort that “breaks immutability.”[^es4]

### C7.2 Projection rebuild is structurally expensive
**Status:** supported

Azure: materialized views exist because “it’s costly to read and replay events.”[^es4]

### C7.3 Immutability vs right-to-erasure is a hard collision
**Status:** supported for the collision; **contested** for crypto-shredding sufficiency

Verraes: crypto-shredding (encrypt PII, delete keys); quotes counsel that encrypted personal data may still be personal data and key-deletion alone may not comply with GDPR removal.[^es1] Dudycz: “law to be forgotten and immutable data sounds like fire and water”; documents segregation, retention, tombstones, forgettable payloads, crypto-shredding with caveats.[^es2]

**Design implication for append+supersede:** supersede ≠ erase if prior versions remain reconstructable. Prefer PII segregation / forgettable payloads over pure append of personal data into the immortal log.

---

## 8. EDN reader tags (envelope prior art)

### C8.1 Spec model: tagged elements with three unknown-tag policies
**Status:** supported

EDN: `#tag value`; unknown tags may error, call unknown handler, or keep generic tag+value representation so readers can still process all edn.[^edn1] User tags must be prefixed; unprefixed reserved.

### C8.2 Default Clojure practice often fail-closed unless configured
**Status:** partial

`*default-data-reader-fn*` exists for open handling; historical mailing-list demand for non-blowing-up unknowns.[^edn3]

### C8.3 Multi-year data-at-rest: host print ≠ stable EDN
**Status:** supported

Nitor (2019): no safe generate path equivalent to `clojure.edn` read; people use `pr-str`; namespaced maps, print limits, `##NaN`, `#object[...]` break round-trip; recommends Transit/JSON for serious interchange.[^edn2]

**Design implication for `<…>` envelopes:** freeze print grammar independent of host pretty-printers; preserve unknown tags by default; put tag version in tag name or payload; do not rely on “whatever the language prints.”

---

## 9. Semantic web identity line (compressed)

### C9.1 Edges need their own data — RDF reification tax → RDF-star / RDF 1.2 triple terms
**Status:** supported

RDF 1.2 Concepts introduces triple terms / reifiers so statements can be annotated without classical four-triple reification.[^rdf1]

### C9.2 Blank nodes are existential, not durable identity
**Status:** supported

RDF Concepts: blank nodes “do not identify specific resources.”[^rdf1]

### C9.3 httpRange-14: dereference protocol is part of URI identity
**Status:** supported

TAG 2005 resolution: HTTP 2xx → information resource; 303 → any resource; 4xx → unknown.[^hr14]

### C9.4 Open-world KR vs closed application validation arrived late
**Status:** supported for SHACL timing; OWL open-world formal quote not re-fetched

SHACL Rec 2017: shapes validation including `sh:closed`; full RDFS not required.[^shacl] Gap of ~13–18 years from RDF to closed-shape Rec is itself a finding.

### C9.5 JSON-LD conceded “valid JSON first”
**Status:** supported

JSON-LD 1.1 design goals: always valid JSON; zero edits most of the time; simplicity over esoteric RDF edge cases.[^jsonld]

---

## 10. Off-list / unexpected findings

| Finding | Why it matters |
|---|---|
| TAG versioning corpus is **draft-only forever** | Cite as Orchard/TAG drafts, not “approved TAG Findings.” |
| Must-ignore has **scope and disposition knobs** (drop/preserve/forward; container/subtree) | Designing “keep everything and warn” needs an explicit substitution table. |
| 2019-09 JSON Schema is a **middle draft maintainers discourage implementing** | Dual LTS (draft-07 + 2020-12) is the honest equilibrium. |
| Git-as-record-grain *was* stated | Brief’s “could not find” is **closed**: Terminus + Dolt are the cites. |
| Crypto-shredding legal status is contested | Do not treat key deletion as settled GDPR erase. |
| RNG “loss” = typed infoset market, not formal defeat | Schema design for UDON should not copy XSD’s inheritance/PSVI package by default — but must answer the *job* (constraints + tooling) or lose for the same reason. |
| DSDL multi-part architecture | Best historical architecture for “grammar + rules + dispatch”; market shipped monoliths. |

---

## 11. Implications for UDON commitments (inference only — blunt)

| Commitment (from brief §1) | Historical pressure | Severity |
|---|---|---|
| Closed bare scalar set; no type sniffing | Supported by Norway/YAML line (already in estate) + TOML/JSON contrast; this pass did not re-litigate | Keep |
| Malformed kept; anomalies by loss | Silent-unspecified is the lethal corner (estate prediction); HTML5 specified recovery; SOAP MU shows when silent is wrong | Specify recovery/substitution tables; flag must-understand-class extensions |
| No last-wins; repeated keys stack | k8s/go-yaml/Symfony record already in estate | Keep; make policy explicit at every layer |
| Indentation = nesting | Real editor/paste/tab hazards; not a Sass refutation | Hard-error mixed tabs; document paste/tool contracts |
| `<…>` envelopes | EDN: preserve unknown; freeze print; version tags | Design unknown-envelope policy now |
| Inert `@` refs | httpRange-14 / blank-node lessons: resolution policy is identity policy | Fixed menu of resolvers is correct; document non-resolution default |
| Schema language upcoming | RNG vs XSD + Schematron: do not ship grammar-only; avoid PSVI-by-stealth unless binding is a goal | DSDL-shaped split |
| Git commit as transaction grain | Fine for **file/corpus** as-of; wrong alone for **record** merge/diff | Be explicit which grain each operation uses |
| Append + supersede | Event-sourcing immutability + GDPR | PII segregation / forgettable payload required if personal data enters the log |

---

## 12. Task B — synthesis audit (short; after Task A)

*Not a full adversarial pass. Pointers only.*

| Check | Note |
|---|---|
| **B1 UDON bare-type collision** | Not run against `v2/current-0.9.1-spec/` this session. **Highest-priority remaining check** if synthesis claims UDON sniffs bare types like YAML. Spec is authority; parser lags. |
| **B2 Primary citations in MINEFIELD-MAP** | Not systematically re-verified line-by-line. Bray/RFC 6648/CommonMark were already in §3 “already fetched.” |
| **B3 ASF/AAT over-reach** | Not checked against `~/src/arch/asf/`. |
| **B4 Missing mechanisms** | This pass adds: (i) schema-as-typed-infoset selection pressure; (ii) grammar vs assertion split; (iii) Accept/Defined versioning calculus; (iv) explicit git grain statements; (v) GDPR/erase vs append; (vi) EDN print-stability failure; (vii) XML DB category displacement. |

---

## Footnotes

[^rng1]: James Clark, *The Design of RELAX NG*, §Infoset modification. https://relaxng.org/jclark/design.html (~2001–2002). Supporting line: “RELAX NG validation does not involve changing the information about the document that is passed to an application. One reason for this is that the processes of validation and infoset modification need to be capable of being performed independently.” Also: “Type assignment requires additional restrictions on RELAX NG schemas beyond those imposed by RELAX NG itself.”

[^rng2]: Eric van der Vlist, “Comparing XML Schema Languages,” XML.com, 2001-12-12. https://www.xml.com/pub/a/2001/12/12/schemacompare.html Supporting line: “Even though RELAX NG seems to be technically superior to W3C XML Schema, support by software vendors and XML developers is uncertain now that W3C XML Schema is a Recommendation.” Also ranks tool support: XSD “Most promising,” RNG “Challenger”; PSVI: XSD Yes / RNG No.

[^rng3]: Murata, Lee, Mani, Kawaguchi, “Taxonomy of XML Schema Languages using Formal Language Theory,” ACM TOIT 2005 (Extreme Markup 2001). https://pike.psu.edu/publications/toit05.pdf Supporting lines: local / single-type / regular correspond roughly to DTD / W3C XML Schema / RELAX NG; “RELAX NG can represent any regular tree grammar”; “Any tree has at most one interpretation against a single-type tree grammar.”

[^rng4]: James Clark, *The Design of RELAX NG*, §Unordered content / Closure. https://relaxng.org/jclark/design.html Supporting line: design “informed by the theory of finite tree automata”; interleave semantics without 1-unambiguity restrictions; derivative-based validation.

[^rng5]: RELAX NG home page, updated 2014-02-25. https://relaxng.org/ Supporting line: “does not change the information set of an XML document”; ISO/IEC 19757-2 (DSDL Part 2).

[^rng6]: James Clark, *The Design of RELAX NG*, §Identity constraints / §Inheritance. https://relaxng.org/jclark/design.html Supporting lines: “RELAX NG itself provides no support for identity constraints”; “One of the most significant differences … is that RELAX NG does not have any concept of inheritance… inheritance mechanisms in W3C XML Schema do not allow W3C XML Schema to express any constraints that cannot be expressed in RELAX NG.”

[^xsd1]: W3C, *XML Schema Part 1: Structures* (Second Edition), Recommendation 2004-10-28, §2.1. https://www.w3.org/TR/xmlschema-1/ Supporting line: definition of the **post-schema-validation infoset (PSVI)** as the augmented infoset from conformant processing, including default values and type annotations.

[^sch1]: Leigh Dodds, “Schemarama,” XML.com, 2001-02-07. https://www.xml.com/pub/a/2001/02/07/schemarama.html Supporting line (quoting Jelliffe): “some constraints are difficult or impossible to model using regular grammars. Commonly cited examples are co-occurrence constraints…” Clark: “Why does one kind of schema have to be better than another? … If it can’t be expressed simply using a grammar, then use a rule-based system.”

[^sch2]: Eddie Robertsson, “Combining RELAX NG and Schematron,” XML.com, 2004-02-11. https://www.xml.com/pub/a/2004/02/11/relaxtron.html Supporting line: “Although RELAX NG has better support for co-occurrence constraints than WXS, there are still many types of co-occurrence constraints that cannot be sufficiently defined” (e.g. quantity × price = totalAmount; cross-document stock checks).

[^sch3]: Rick Jelliffe, “‘Schemas do not imply any semantics of documents’,” schematron.com, 2017-10-09. https://www.schematron.com/opinion/_schemas_do_not_imply_any_semantics_of_documents_.html Supporting line: “Grammar schema languages don’t express semantics because they cannot.”

[^sch4]: W3C Wiki, Category:CoConstraintUseCase. https://www.w3.org/wiki/Category:CoConstraintUseCase Use cases include simple attribute implication, value arithmetic, deep inclusions/exclusions (context for XSD 1.1 assertions).

[^dsdl1]: ISO/IEC 19757 (DSDL) framing — multi-part validation framework (Part 2 RELAX NG, Part 3 Schematron, Part 4 NVDL). See relaxng.org ISO note and ISO 19757-3 introductions on composing validation processes “in series or in parallel.”

[^js1]: JSON Schema org Discussion #192, Henry Andrews et al., 2022-08. https://github.com/orgs/json-schema-org/discussions/192 Supporting lines: draft-07 as “center-of-gravity of the community”; LTS includes draft-07 as “last under the previous paradigm”; “I would definitely not support 2019-09”; Greg Dennis on “zero incentive” to update schemas while implementors support all versions.

[^js2]: Henry Andrews, “What is ‘Modern’ JSON Schema?,” 2022-11-13. https://modern-json-schema.com/what-is-modern-json-schema Supporting line: modern = 2019-09 / 2020-12+ vs classical draft-07 and earlier; annotation-dependent validation, vocabularies, etc.

[^js3]: smikulcik, Schema Store analysis of 1,121 schemas as of 2025-10-23. https://github.com/smikulcik/jsonschema-analytics-2025 (write-up: Medium “86% of JSON Schemas Are Stuck in 2017”). Supporting figures: draft-07 64.23%; draft-04 20.70%; 2020-12 9.01%.

[^js4]: Ben Hutton, “50+ million requests in 7 days on json-schema.org,” 2023-09-15. https://json-schema.org/blog/posts/website-analytics-snapshot-2023 Supporting line: top result `/draft-07/schema` at 11.82 million; “draft-07 JSON Schema is the most popular.”

[^js5]: JSON Schema 2019-09 Release Notes. https://json-schema.org/draft/2019-09/release-notes Incompatibilities: format not assertion by default; `$anchor`; vocabularies; `unevaluated*`; `$ref` siblings; `definitions`→`$defs`.

[^js6]: JSON Schema 2020-12 Release Notes. https://json-schema.org/draft/2020-12/release-notes Supporting line: draft “mostly dedicated to changes related to applying the lessons we’ve learned” from 2019-09 features; `prefixItems`/`items`; `$dynamicRef`/`$dynamicAnchor`.

[^js7]: Attouche et al., “Validation of Modern JSON Schema: Formalization and Complexity,” arXiv:2307.10034 (2023/2024). Supporting line: annotation-dependent validation and dynamic recursive references; modern features can yield PSPACE complexity.

[^js8]: OpenAPI Specification v3.0.3, 2020-02-20. https://spec.openapis.org/oas/v3.0.3 Supporting line: Schema Object is “an extended subset of JSON Schema Specification Wright Draft 00.”

[^js9]: Phil Sturgeon, “OpenAPI v3.1 and JSON Schema,” 2020-02 (updated). https://apisyouwonthate.com/blog/openapi-v3-1-and-json-schema/ Supporting line: OpenAPI Schema is a vocabulary of JSON Schema 2020-12.

[^tag1]: David Orchard, *Extending and Versioning Languages: Compatibility Strategies*, Draft TAG Finding, 2007-11-13. https://www.w3.org/2001/tag/doc/versioning-compatibility-strategies-20071113.html Supporting lines: “Must Accept Unknowns” / “MUST Ignore Unknowns”; variants (remove / preserve / all vs container); XML 1.1 as incompatible “minor” change; SOAP mixture of must-accept default + dynamic must-understand; status: does not represent TAG consensus.

[^orch1]: David Orchard, “A Theory of Compatible Versions,” xml.com, 2006-12-20. https://www.xml.com/pub/a/2006/12/20/a-theory-of-compatible-versions.html Supporting lines: Accept Text Set > Defined Text Set; extensibility gap; Must Ignore as substitution rule; without substitution, no forward compatibility.

[^soap1]: SOAP 1.1, W3C Note, 2000-05-08, §4.2.3. https://www.w3.org/TR/2000/NOTE-SOAP-20000508/ Supporting line: “The SOAP mustUnderstand attribute allows for robust evolution… Tagging elements in this manner assures that this change in semantics will not be silently (and, presumably, erroneously) ignored…”

[^http1]: RFC 9110, HTTP Semantics, June 2022, §16.4.2. https://www.rfc-editor.org/rfc/rfc9110.html Supporting line: for new extension parameters, “a ‘must-ignore’ rule is preferable to a ‘must-understand’ rule, because otherwise it will be hard to introduce new parameters in the presence of legacy recipients.”

[^html5]: *HTML Design Principles*, W3C Working Draft, 2007-11-26. https://www.w3.org/TR/html-design-principles/ Supporting lines: Support Existing Content; Degrade Gracefully; Evolution Not Revolution.

[^xhtml2]: *XHTML 2.0*, W3C Working Group Note, 2010-12-16, Introduction. https://www.w3.org/TR/2010/NOTE-xhtml2-20101216/introduction.html Supporting line: “thanks to XML and style sheets, such strict element-wise backwards compatibility is no longer necessary…” Charter expired before completion.

[^xml11]: Norman Walsh, “XML 1.1: Dead on Arrival,” 2004-09-30. https://norman.walsh.name/2004/09/30/xml11 Supporting line: “XML 1.1 *is dead*… ‘an XML [1.1] document…can never be valid against a RELAX NG schema.’ … Game Over.”

[^xdb1]: Truică et al., “The Forgotten Document-Oriented Database Management Systems: An Overview and Benchmark of Native XML XDBMSes in Comparison with JSON DODBMSes,” arXiv:2102.02246, 2021. https://arxiv.org/abs/2102.02246 Supporting lines: NXDB rebranded then replaced by JSON DBMS; “forgotten during the Big Data hype”; open XDBs often lack replication/partitioning; BaseX competitive on some aggregations.

[^xdb2]: Uli Bethke / Sonra, “XML Databases: Types, Top Options and When to Migrate,” 2026-06-17 (updated 2026-06-24). https://sonra.io/xml-databases/ Supporting lines: “right answer in 2005… only in very narrow cases” in 2026; document-as-asset vs delivery-format; XQuery as SQL analogue for XML; analytics impedance.

[^xdb3]: Andy Pavlo, “Databases in 2025: A Year in Review,” 2026-01-04. https://www.cs.cmu.edu/~pavlo/blog/2026/01/2025-databases-retrospective.html Supporting line: XML DBMSes (e.g. MarkLogic) as document-DB ancestors; MongoDB most successful “by a massive margin.”

[^git1]: TerminusDB docs, “Knowledge Graph Version Control.” https://terminusdb.org/docs/knowledge-graph-version-control/ Supporting line: “The crucial difference is granularity. Git versions text lines inside files. TerminusDB versions individual subject–predicate–object triples… a TerminusDB diff is not a textual hunk that you have to re-parse — it is a structured, semantic description of which facts were added, removed, or changed.”

[^git2]: Tim Sehn / DoltHub, “So you want Git for Data?,” 2020-03-06. https://www.dolthub.com/blog/2020-03-06-so-you-want-git-for-data/ Supporting lines: line-level conflict resolution in Git; no schema; “using Git for data is not the right tool for the job, like using a hammer to fasten a screw”; Dolt operates on “table rows instead of files” with “cell-wise diffs and merges.”

[^git3]: Noms README, attic-labs/noms. https://github.com/attic-labs/noms Supporting line: “Unlike Git, Noms is a database, so it also: Primarily stores structured data, not files and directories…”

[^git4]: Noms `doc/intro.md` (Prolly Trees). https://github.com/attic-labs/noms/blob/master/doc/intro.md Supporting lines: history-independence invariant; classic B-trees/LSM not history-independent; Prolly Trees for large mutable collections with efficient diff/sync/merge.

[^git5]: Dolt Architecture docs. https://www.dolthub.com/docs/architecture/architecture/ Supporting lines: “we knew we would need our own storage engine”; “Git storage is not built for fast seek”; Noms pioneered content-addressed Prolly trees.

[^git6]: lakeFS, “Git for data,” blog. https://lakefs.io/blog/git-for-data/ Supporting lines: Git inadequate for data lakes — human scale, storage ownership, format/size range.

[^ind1]: Python 3 Language Reference, Lexical analysis — Indentation. https://docs.python.org/3/reference/lexical_analysis.html#indentation Supporting line: “Indentation is rejected as inconsistent if a source file mixes tabs and spaces in a way that makes the meaning dependent on the worth of a tab in spaces; a TabError is raised in that case.”

[^ind2]: YAML 1.2.2, §6.1 Indentation Spaces, 2021-10-01. https://yaml.org/spec/1.2.2/ Supporting line: “To maintain portability, tab characters must not be used in indentation, since different systems treat tabs differently.”

[^ind3]: PEP 8 — Style Guide for Python Code. https://peps.python.org/pep-0008/#tabs-or-spaces Supporting line: “Python disallows mixing tabs and spaces for indentation.”

[^ind4]: Zed editor issue #13338, 2024-06-20. https://github.com/zed-industries/zed/issues/13338 Supporting line: “Pasting changes indentation… it changes the semantics of the file quite a bit.”

[^es1]: Mathias Verraes, “Eventsourcing Patterns: Crypto-Shredding,” 2019-05-13. https://verraes.net/2019/05/eventsourcing-patterns-throw-away-the-key/ Supporting line: concern whether crypto-shredding suffices under GDPR; quoted counsel that encrypted personal data remains personal data and deleting only the key may not comply.

[^es2]: Oskar Dudycz, “How to deal with privacy and GDPR in Event-Driven systems,” event-driven.io, 2023-11-26. https://event-driven.io/en/gdpr_in_event_driven_architecture/ Supporting line: “The law to be forgotten and immutable data sounds like fire and water.”

[^es3]: Greg Young, *Versioning in an Event Sourced System* (Leanpub), “Why can’t I update an event?” https://leanpub.com/esversioning Supporting lines: immutability core; “The moment you allow a single edit of an event, maintaining a proper audit log becomes impossible.”

[^es4]: Microsoft Azure Architecture Center, Event Sourcing pattern. https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing Supporting lines: “you should never update the event data”; materialized views because replaying is costly; upcasting/versioning strategies.

[^edn1]: edn-format/edn README (canonical casual spec). https://github.com/edn-format/edn Supporting lines: tagged elements; unknown-tag policies (error / handler / generic representation); “non-error strategies allow for readers which are capable of reading any and all edn…”

[^edn2]: Joel Kaasinen / Nitor, “Pitfalls and bumps in Clojure’s Extensible Data Notation (EDN),” 2019-09-24. https://nitor.com/fi/artikkelit/pitfalls-and-bumps-clojures-extensible-data-notation-edn Supporting lines: `pr-str` not a serious serializer; namespaced maps not in EDN spec; print truncation; recommends Transit/JSON for robust interchange.

[^edn3]: Clojure docs `*default-data-reader-fn*`. https://clojuredocs.org/clojure.core/*default-data-reader-fn* Supporting: default handler for unknown tags when non-nil.

[^rdf1]: RDF 1.2 Concepts and Abstract Syntax (W3C CR Snapshot context 2026). https://www.w3.org/TR/rdf12-concepts/ Supporting lines: triple terms / reification via `rdf:reifies`; blank nodes “do not identify specific resources.”

[^hr14]: Roy Fielding, TAG resolution on httpRange-14, www-tag mail, 2005-06-19. https://lists.w3.org/Archives/Public/www-tag/2005Jun/0039.html Supporting: 2xx → information resource; 303 → any resource; 4xx → nature unknown.

[^shacl]: *Shapes Constraint Language (SHACL)*, W3C Recommendation, 2017-07-20. https://www.w3.org/TR/shacl/ Supporting: closed shapes (`sh:closed`); validation without requiring full RDFS inferencing.

[^jsonld]: *JSON-LD 1.1*, W3C Recommendation, 2020-07-16. https://www.w3.org/TR/json-ld11/ Supporting lines: “A JSON-LD document is always a valid JSON document”; Zero Edits design goal; simplicity over esoteric use cases.

---

## Research agent roster (this pass)

| Agent | Territory | Subagent id |
|---|---|---|
| 1 | RELAX NG / XSD / Schematron / DSDL | `019fafb3-c30b-7671-baf6-9b2ae14e4ab0` |
| 2 | JSON Schema draft churn | `019fafb3-c30b-7671-baf6-9b3b25f2e444` |
| 3 | Forwards-compat / TAG / SOAP / HTML5 / XML 1.1 | `019fafb3-c30b-7671-baf6-9b4f76c27180` |
| 4 | XML DBs + git-as-DB | `019fafb3-c30b-7671-baf6-9b568e8e5ce8` |
| 5 | Indentation / event sourcing / EDN / semantic web | `019fafb3-c30c-7722-aaa8-2db847262620` |

Full agent reports remain in session transcript; this file is the adjudicated substrate for design work.

---

## What would improve this file next

1. **Task B1 against live `v2/current-0.9.1-spec/`** — especially bare-type / unquoted string collision (loud if §3.1 of synthesis is wrong).  
2. Spot-check MINEFIELD-MAP **[evidenced]** quotes against Bray annotation, RFC 6648, CommonMark intro verbatim.  
3. Overeem et al. 2021 event-sourcing industry paper body (schema evolution empirics).  
4. Controlled measurements for indent paste/merge (still open).  
5. Xanadu/one-way link primary literature (left training-recall).
