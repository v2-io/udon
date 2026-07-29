---
source: /deep-research commission 2026-07-29 — prior art for reasons-as-structure in schema/constraint systems, adversarially verified (3-vote per claim; 104 agents, 8 merged findings, 1 refuted)
gathered: 2026-07-29
status: synthesis — EXTERNAL evidence tier (published research + live tooling outside the estate). Vote counts per claim; interpretive glosses marked as ours; follow links before load-bearing use.
categories: [external-evidence, rationale, schema, decision-layer, adr, design-rationale, fiat-strata, o12]
why_included: >
  Commissioned as prior art for the fiat-strata result (working-synopsis §4:
  a schema's non-derivable content is its decision layer; existing schema
  languages give reasons only inert comment slots). The question: who else
  walked toward reasons-as-first-class-structure, how far, and what stopped
  them. Feeds O10 (constraints carrying removal-reasons), O12 (the
  epistemic-register schema), and the schema territory generally.
---

# External evidence — reasons-as-structure prior art (verified sweep, 2026-07-29)

## Synthesis summary (the workflow's, lightly compressed)

Prior art is substantial and splits into **two lineages**: an academic **design-rationale (DR)** tradition (IBIS/gIBIS/QOC → Compendium; DRL → SEURAT/RATSpeak) that made rationale first-class, typed, queryable, and even *computed-over* by the early 2000s; and a practitioner **ADR-tooling** tradition (Y-Statement, MADR, Structured MADR, e-ADR, log4brains) that structures the decision *lifecycle* — status, adoption date, supersession links, provenance — as machine-validated data. The deepest walk is **SEURAT**: every reason typed against a weighted Argument Ontology, with syntactic *and* semantic inference over the rationale (re-evaluating decisions when an assumption is disabled). **The consistent boundary across the practically-adopted tools is exactly the one the fiat-strata derivation identifies**: lifecycle, relations, and adoption records become schema-validated fields, while the justification content itself stays prose. And even Compendium — rationale in a queryable relational DB with an API — had **no schema/constraint layer governing the rationale structures themselves**. The Buneman why-provenance, constraint-provenance, and policy-as-code neighborhoods produced **no verified findings — unwalked in this pass, not confirmed empty**.

## Verified findings

1. **[high · 3-0×3] The field existed and was survey-worthy by 2000** — design-rationale systems as a recognized research area (Regli et al., *Engineering with Computers* 16, 2000), with the key axes already articulated: argumentation-based (rationale as first-class structure) vs descriptive (narrative) vs process-based; representation, capture, and retrieval as distinct problems. Predates `xs:annotation` (2001) and `$comment` (2018). *(The "queryable-structure vs recorded-narrative" phrasing is our gloss on their taxonomy.)*
2. **[high · 3-0×2] Compendium shipped rationale-as-structure by 2005 and stopped exactly short of governing it** — IBIS maps as views onto a relational DB (MySQL/Derby), XML export, RDF interop, read/write API; but *"constraints cannot be specified between nodes and links: any two nodes can be linked using any linktype"* and no structural verification services (the creators' own self-report). **Structured reasons without a schema over them — the near-exact complement of our position (schema with unstructured reasons).**
3. **[high · 3-0] The capture problem is the field's named central obstacle** — *"the spectre haunting all design rationale efforts... without disrupting the very process it is designed to support"* — and the gIBIS/QOC authors' answer is structuring effort invested *at the point of capture* under a "value now, value later" imperative, not post-hoc annotation. The cost lands at authoring time. *(Estate mapping: this is O9's friction question and `#der-dual-optimization`'s who-pays asymmetry, named in 2006 without the formalism.)*
4. **[high · 3-0×4 across sources] SEURAT/RATSpeak (Burge & Brown, 2004–2008) is the deepest verified instance of reasons-as-typed-queryable-structure** — semi-structured argumentation (DRL-derived, explicit for/against), typed relations (satisfies, violates, supports, denies, presupposes, opposes) linking arguments to requirements/assumptions/claims; every claim mapped into a hierarchical **Argument Ontology** of software-quality argument types, each entry carrying a **default importance, inheritable by citing rationale, overridable per claim** — justification types as first-class weighted vocabulary. RATSpeak was XML-schema-validated: the one verified instance of rationale structures themselves being schema-governed.
5. **[high · 3-0; one adjacent claim refuted 0-3] SEURAT computes over rationale** — syntactic inference (decisions with no selected alternative; selected alternatives with no supporting arguments; biased argument sets) and semantic inference (re-evaluating decisions when an assumption is disabled or priorities change; detecting requirement and tradeoff violations), rationale in MySQL with SQL-assisted inference. *(The CLIPS-rules implementation detail was refuted 0-3 and is excluded; "unanswered questions" as a syntactic check is unverified — omit both.)* *(Estate mapping: assumption-disable → decision re-evaluation is the O5 consumer-declaration + O7 adjudication shape, two decades early.)*
6. **[high · 3-0] By 2016 mainstream architecture literature had promoted the decision layer to first-class content** — architecture redefined around the set of design decisions, "complementing or even replacing" components-and-connectors (lineage: Jansen & Bosch 2005; Kruchten's decision ontology 2004; ISO/IEC/IEEE 42010:2011's rationale requirement).
7. **[high · 3-0×9] The ADR tooling pattern, across four independent tools/formats: lifecycle structured, justification prose.** MADR gives justification a mandatory *slot* and machine-records status history; Y-Statement is a fixed argument template (neglected options, desired consequences, accepted downsides, optional "because…"); adr-tools writes typed supersedes/amends links; log4brains treats ADRs as immutable with status the only mutable field. The adoption/removal record is data; the *reason* stays free text.
8. **[high · 3-0×3] e-ADR is the one ADR-lineage instance where justification occupies a typed, named, tool-readable field** — Java `@MADR` annotations with named fields (title, contextAndProblem, alternatives, chosenAlternative, justification, relatedDecisions), designed for downstream machine processing — though the field's *content* is still free text within the structured slot.

## The shape of the gap (the workflow's synthesis + our reading, marked)

Three positions exist in the verified record; the fourth quadrant is empty:

| | Reasons structured | Reasons prose |
|---|---|---|
| **Lifecycle/record governed** | **← the empty quadrant** (SEURAT's XML-validated RATSpeak is the closest single instance, unextended since ~2008) | ADR tooling (adopted, widespread) |
| **Ungoverned** | Compendium (structured, queryable, no schema over it) | comment slots (xs:annotation, $comment) |

The sweep's open question 2 states the design opportunity in one sentence: *nobody closed the Compendium gap from the other side* — a system where the rationale structures themselves are schema-governed. That is the O12 epistemic-register schema's quadrant.

**And the adoption asymmetry is the warning label on it** (open question 3, verbatim in substance): SEURAT-style typed-rationale-with-inference failed to spread while prose-bodied ADRs spread widely. If the capture problem is the whole explanation, it predicts that **a schema language making rationale slots mandatory repeats SEURAT** — the fiat-strata design must make the reason slot *cheaper than prose* (O9's friction differential; O11's marking-cheaper-than-not-marking) or inherit the corpse. This is the strongest single constraint the sweep contributes.

## Refuted in verification (excluded; kept so nobody re-imports)

- SEURAT inference implemented as CLIPS rules (0-3).

## Unwalked neighborhoods (the sweep's largest caveat, carried loudly)

Database why/where-provenance (Buneman et al.), constraint provenance (PROV-O), policy-as-code rationale metadata (OPA/Rego, Sentinel, Cedar), and KR norm-justification (deontic logic, ASPIC+/Toulmin, LegalRuleML) produced **zero verified findings this pass**. Absence of verified claims, not evidence of emptiness — the report must not imply the DR/ADR lineages exhaust the prior art. LegalRuleML (provisions with sources and temporal validity) is the named most-likely independent reinvention of adoption/ratification records.

## Other register notes (the workflow's own)

The JSS 2008 SEURAT paper is paywalled — verified via the free DCC'04 companion and Burge's dissertation. Structured MADR is a small community project (evidence someone walked here, not field practice). "Constraint" mapped onto ADR "decision" is our framing. The three live GitHub projects' feature descriptions were verified 2026-07-29 and can drift.

*Estate routing: primary prior-art base for the fiat-strata section (working-synopsis §4) and the O12 register-schema design; the capture-problem finding routes to O9/O10/O11 as the adoption constraint; the SEURAT Argument Ontology (typed justification vocabulary with inheritable default weights) is the nearest existing shape to what the decision layer wants and deserves a close read before O12 prototyping. Stats: 104 agents, 8 merged findings, 1 refuted, 4 named neighborhoods unwalked.*
