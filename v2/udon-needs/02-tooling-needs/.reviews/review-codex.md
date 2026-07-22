# Independent review — Codex

**Review baseline:** Git `bca74bfbb3684c5e72bf707f75c2c0bee21b6a3a`, plus the uncommitted working-tree version present on 2026-07-22. The monograph is actively extending; I assessed drafted material and the outline, and did not score `planned`/stub segments as missing content. I did not read the other reviews before writing this report.

## Findings

### High — Segment provenance paths are systematically one directory short

**Where.** Every `src/*.md` frontmatter uses paths such as `../01-ideation/02-provenanced/...`; examples are `src/method-evidence-tiers.md` lines 8–11, `src/edit-representation-landscape.md` lines 9–13, and `src/headless-io-contract.md` lines 9–12. From `02-tooling-needs/src/`, these resolve to `02-tooling-needs/01-ideation/...`, which does not exist. The actual corpus is `../../01-ideation/...`. `method-evidence-tiers.md` itself uses the correct `../../` spelling in its inline lineage link (line 35), confirming this is not a repository-root convention.

**Primary-source basis.** The README makes provenance load-bearing: a segment’s `sources` are the artifacts it stands on, and readers must re-open primaries at point of reliance. The brief requires every claim to trace to an `01-ideation` artifact. With the source lists non-resolving, the report cannot be audited or handed over reliably even where its prose is accurate. `01-ideation/02-provenanced/syntheses/tier2-lineage.md` §4 also requires phase-2 writers to preserve corrected lineage rather than rely on summaries.

**Suggested disposition.** **Fix globally before downstream citation.** Change all `src`-relative `../01-ideation/` paths to `../../01-ideation/`, then correct other bases individually (for example, pipeline discussion is `../../pipeline-discussion.md`, not inside `01-ideation`). Add a small `sources:` path/link check so a segment move cannot recreate this failure.

### High — Observation-infrastructure asserts an independent T5 leg that it neither cites nor supplies

**Where.** `src/tools-are-observation-infrastructure.md` lines 83–88 says the “load-bearing independence is T4↔T2↔T5, not T1↔T4.” Its frontmatter (lines 4 and 9–12) declares only T4/T2/T1 and lists only the ASF dossier, CONVERGENCES, and Tier-2 digest. Its body has no T5 subsection or external-study citation.

**Primary-source basis.** `src/method-evidence-tiers.md` lines 20–26 defines T5 as external published evidence; lines 30–33 say cross-tier claims must name independent failure modes. This statement upgrades a same-author T1/T4 resonance to a three-leg independent foundation, but no checkable external leg exists. The external landscape has limited findings on structured output/tool failure; it does not generally verify the κ×A, tempo, or persistence claims.

**Suggested disposition.** **Correct now.** Replace `T4↔T2↔T5` with the supported relation (`T4↔T2`, with T1 as same-author design resonance), or add a specific relevant T5 source and confine the assertion to what it verifies. Do not broaden unrelated external results into corroboration of formal persistence theory.

### Medium — “Claims inherit the tier of their weakest source” is an ambiguous and counterproductive rule

**Where.** `src/method-evidence-tiers.md` lines 43–46.

**Primary-source basis.** A claim supported by independent T2 practice and a conditional T4 theorem has a structured argument: its indispensable premises have different strengths and failure modes. Taken literally, this rule either downgrades every cross-tier synthesis to its weakest supporting tier, or rewards writers for omitting honest weak evidence. Both readings conflict with the preceding rule (lines 30–33) that cross-tier convergence is meaningful because failure modes differ. `tier2-lineage.md` §§3–4 supplies the more precise model: lineage can weaken the T2 leg while other independent legs remain intact; it does not make the conclusion become “T2.”

**Suggested disposition.** **Rewrite while retaining the anti-laundering intent.** For example: “Every claim carries the caveats of each indispensable source; its status is limited by its weakest necessary premise, not by the mere presence of a weaker supporting source.” Require segments to label which subclaim each tier supports.

### Medium — A transport convergence is beginning to read like a notation conclusion

**Where.** `src/headless-io-contract.md` lines 51–59. After properly describing NDJSON as the converged streaming transport answer, it says a format whose prefixes parse can “serve the same role natively.”

**Primary-source basis.** `tier2-invivo-digest.md` C16 identifies a CLI I/O contract: clean data/diagnostic channels, structured errors, exit codes, and streaming NDJSON. It does not test whether prefix-parsable document syntax replaces message framing, preserves event boundaries, handles cancellation/retries, or supports multiplexing. The segment’s “unmeasured” caveat is good, but “same role natively” can still be read as a conclusion.

**Suggested disposition.** **Recast as a precise experiment.** Prefix recognition may improve *payload incremental validation*; NDJSON solves *transport framing and per-event delivery*. Neither replaces the other absent a protocol experiment. This is my distinct practitioner dissent: in real tool loops, a valid partial payload is not itself a streaming protocol—callers still need framing, sequence, error, and cancellation semantics.

### Low — The thesis overstates report-wide coverage relative to the deliberately planned work

**Where.** `OUTLINE.md`, “The one-paragraph thesis,” especially “evidence from every tier says the same thing”; compare its stage tables and `RESIDUALS.md` §§1–2.

**Primary-source basis.** Major components that substantiate its broadest phrases are explicitly planned: human steering/verification, continuity, typing/schema boundary, templates/dynamics, machine-first documents, and the harness handover. `README.md` says planned segments must not be cited as if synthesized, while RESIDUALS records the unabsorbed Tier-1 and other territory.

**Suggested disposition.** **Polish, not a blocker.** Call this the “drafted-spine thesis” and name the unsynthesized parts in one short qualifier. Restore a report-wide thesis when those segments land. This lets the coverage honesty already present in RESIDUALS remain visible at the point downstream readers will quote.

## Overall assessment

The drafted spine is unusually thoughtful evidence synthesis. Its best feature is that it refuses to equate a crowded in-repo ecosystem with independent confirmation: lineage correction changes conclusions rather than serving as decorative caveating. The repeated “What it generates” and “Honest edges” sections make the two consumers concrete, and the counter-register is a real safeguard against monograph momentum.

The needed repair is principally operational epistemics, not prose: make provenance paths executable, keep every claimed evidentiary leg present and cited, and describe cross-tier support as a structured argument rather than a weakest-tier label. With that repaired, it can be a trustworthy handover to both UDON and a harness team.
