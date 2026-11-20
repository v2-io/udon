# Agentic Tooling: The Demand Evidence

**What this is.** A report on what agents — and the humans working with and through them — actually need from their tools: notations, interfaces, harnesses, memory and context systems, feedback loops, guardrails. It is built as an **anthology with a spine**:

- **The body** ([`reports/`](reports/)) — seven deep, self-contained reports: the survey of the formal theory, the examination of fourteen shipping harnesses, two demand explorations, two foundational design documents, and a stress test. These carry the substance; each stands alone and is worth reading whole.
- **The bridges** ([`src/`](src/)) — short chapters that orient a reader by degrees, carry the findings that only emerge *across* the reports (convergences, counter-evidence, priorities), and hand the reader into the right report at the right moment.
- **The spine** ([`OUTLINE.md`](OUTLINE.md)) — the whole argument part-by-part, each Part naming its bridges and the reports they open into. **Start there.**

**Two consumers, named.** The report serves UDON v2's design decisions *and* the harness programme's tooling work. Where their needs diverge, the text says so rather than silently serving one; bridges carry a `consumers:` mark and a "who reads this and when" line where it matters. Readers coming from the harness side with no UDON background: [`NOTATION-KEY.md`](NOTATION-KEY.md) carries your reading path and glosses every piece of shorthand.

**How to weigh what you read.** The report draws on five kinds of evidence with different failure modes — formal theory (conditional results, stated premises), shipping practice (survivorship, corrected for who copied whom), agents' own accounts, first-principles design work (largely one author, so agreement within it is coherence, not corroboration), and external published measurement. Agreement *across* kinds is the standard of proof; the methods bridge ([[method-evidence-tiers| What this report counts as evidence]]) explains the discipline, and the [[counter-register| counter-register]] keeps the evidence *against* our own theses adjacent to the claims it qualifies.

---

## For auditors and maintainers

Everything below this line is apparatus; readers of the report never need it.

- **Provenance.** Every claim traces to source: bridge frontmatter carries `sources:` paths; each body report carries a provenance banner stating what was refined in promotion (framing only, unless noted). The underlying gathered corpus and its ledgers live in [`../01-ideation/`](../01-ideation/); the standing brief with quality bars is [`../BRIEF-agentic-tooling-compilation.md`](../BRIEF-agentic-tooling-compilation.md).
- **Frontmatter fields** on bridges: `type` (finding / demand / principle / counterposition / method / synthesis) · `evidence` (tier codes — auditor apparatus; body prose speaks plain words) · `status` (epistemic standing) · `stage` (authoring state) · `consumers` · `depends` (the only context a bridge may assume) · `sources`.
- **Coverage and revision history.** [`RESIDUALS.md`](RESIDUALS.md): what was absorbed thinly, known gaps, bolt-on points for late material, and the revision log that keeps review citations traceable.
- **Standing quality bars** (unchanged): vetted; provenance always; restatement-with-annotation over verbatim duplication; convergence discipline; honest coverage; transported-judgments-are-stale.
