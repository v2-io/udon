# Review A — the agentic-tooling monograph (de-novo, independent)

*Reviewer: an independent Opus 4.8 pass, 2026-07-22. Not primed by the sibling review or by the coordinating session's own read. Method: read the charter docs (README, OUTLINE, RESIDUALS, BRIEF) and the tier framework (method-evidence-tiers, CONVERGENCES + its lineage addendum, tier2-invivo-digest, external-landscape, the ASF dossier through §4.2), then read all ~15 drafted segments and opened the cited primaries at the points the segments rely on them. Findings ordered by severity; each carries a directly-checkable cite.*

Bottom line up front: the tier discipline is, overall, unusually well held — lineage correction is applied correctly and *sharply* in the two segments where it matters most (edit-representation-landscape, tool-definition-anatomy), the counter-register is a genuine first-class defense rather than a footnote graveyard, and RESIDUALS is candid about the report's own skews. The T4 theory is faithfully represented against the dossier, verbatim quotes included. The findings below are therefore mostly *sharpening* a strong draft — with one real tier-inflation defect on the report's self-described strongest demand, and a cluster of excellence-gaps where the underlying material supports a more vivid, more teaching version than what landed.

---

## Finding 1 — HIGH — schema-guarded-mutation mis-tiers the yaml-spike as T3, inflating a 4-tier convergence into "5-tier / every tier"

**Where:** `src/schema-guarded-mutation.md` (frontmatter `evidence: [T1,T2,T3,T4,T5]`; status "cross-tier-convergent (the report's strongest demand)"; body §"The demand, tier by tier" — the row labeled **"T3 (lived): the yaml-spike adversarial re-test"**). Propagates to `src/priorities-and-spike-agenda.md` §"demand ranking" item 1 ("**5-tier convergence**, measured cost of absence (16% unaided recovery)").

**What I found.** The yaml-spike is an **autopax** artifact — Joseph's Dec-2025 empirical stress test of YAML+yq. The gathering's own commentary explicitly tiers it **Tier-2 (shipped practice, adversarially stress-tested)**, and names the genuine triangulation in that section as **T2(yaml-spike) ↔ T1(rowan/autopax DSL design ideology)** — *not* T3. The report's own T3 definition (`method-evidence-tiers.md`) is "Lived agent testimony (ELI first-person accounts of tools failing/serving them)." The yaml-spike is neither ELI nor first-person; it is a single-author (Joseph) measured experiment. Labeling it "T3 (lived)" is wrong against both the corpus's classification and the report's own tier definition.

The consequence is not cosmetic. With the yaml-spike correctly at T2, the segment has **no genuine T3 (lived-testimony) anchor at all**, so "every tier independently asks for it" and the "5-tier convergence" headline in the priorities ranking are overstated by one tier. The author-independent support that actually survives is T2-shipped-ecosystem (near-misses: qwen post-edit scan, yq, obsidian-linter) + T5 (MCP fault taxonomy: schema-serialization mismatch dominates). That is still a strong, defensible demand — but it is a **4-tier** claim (T1 design ↔ T2 empirical ↔ T4 theory ↔ T5 external), with T1 and T4 sharing an author, and it should say so. This is the exact single-author "coherence-not-corroboration" trap the BRIEF warns about, surfacing on the one demand the report ranks #1.

**Cites (checkable):**
- `01-ideation/02-provenanced/commentary/III-schema-witness.md` L41–46: "The yaml-spike (**Tier-2 shipped practice**, adversarially stress-tested) *independently generates* the requirements list that rowan's DSL (design ideology) merely asserts … This is the genuine cross-tier triangulation in the section."
- `01-ideation/02-provenanced/LEDGER.md` L281–286: all six yaml-spike copies sourced from `~/src/autopax/docs/tactical/2025-12-03-operata-yaml-spike*/`.
- `01-ideation/02-provenanced/syntheses/CONVERGENCES.md` L69 (singleton) and L54 (cluster 9): "**autopax** yaml-spike."
- Report's own T3 definition: `02-tooling-needs/src/method-evidence-tiers.md` L23.

**Suggested disposition.** Relabel the row **T2 (empirical, adversarial)**; move status to "4-tier cross-tier-convergent" (or "T1↔T2↔T4↔T5"); add an Honest-edge noting the absence of a genuine lived-testimony (T3) anchor for this specific demand (or supply one if ELI schema/validation testimony exists — I did not find it cited). Fix the "5-tier convergence" cell in priorities item 1 to match. The demand survives this correction easily; the point is to not spend inflated tier currency on the flagship.

---

## Finding 2 — MEDIUM — edit-representation-landscape: the "2–3× success swing" and the ">30% lower cost" both firm up sources that are looser/more-caveated than the segment states

**Where:** `src/edit-representation-landscape.md` — Claim para ("format choice swings success **2–3×**") and §"External corroboration" (bullet 1: "structure-aware diffs **match/beat whole-file at >30% lower cost**").

**What I found.**  
(a) **The "2–3×" figure** is not grounded in any primary I could open at the point of use. It is inherited verbatim from `CONVERGENCES.md` cluster 1 ("edit-format choice swings success 2–3× (aider)"), which itself gives no primary cite. The one place with actual numbers, `external-landscape-2026-07.md` finding 2, reports a *different* comparison and a *larger* swing (MinUniDiff 14.07% vs FullCode 57.07% pass@1 — ~4×, and that is line-diff-vs-whole-file on a 7B model, not "format choice" generally). So the segment asserts a specific multiplier as fact whose provenance is a summary line, and the nearest real measurement doesn't match it.

(b) **The ">30% lower cost" clause** conflates two separate external findings and drops a caveat the source flagged. `external-landscape` finding 2 states them distinctly: "structure-aware diffs **close the gap** (FuncDiff 70.88 vs 69.38 on EditEval)" — with the explicit caveat "**FuncDiff margin is thin (1.5pt, single cell)**" — *and separately* "adaptive format selection (AdaEdit) cuts latency/cost **>30%** on long code at accuracy parity." The segment merges these into "structure-aware diffs match/beat whole-file at >30% lower cost," attributing AdaEdit's cost figure to structure-aware diffs and silently dropping the thin-margin caveat. This is a small instance of exactly the genre's named characteristic failure (synthesis firming up a carefully-caveated source).

**Cites:** `01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md` finding 2 (L28–36) for both the numbers and the "FuncDiff margin is thin (1.5pt, single cell)" caveat; `CONVERGENCES.md` L46 for the un-sourced "2–3×."

**Suggested disposition.** Either source the "2–3×" to a real aider leaderboard figure or replace with the concrete external number + its 7B caveat (the segment already carries the "fine-tuned-7B-era" caveat once, so this is a small edit). Split the ">30% lower cost" clause back into its two findings and restore the "thin 1.5pt margin, single cell" caveat on FuncDiff. Net effect is a *sharper* claim, not a weaker one.

---

## Finding 3 — MEDIUM (structural) — the "long pole" (Part IV, Addressing) is placed *after* the thing it holds up (Part III, Mutation), inverting the dependency order

**Where:** `OUTLINE.md` part ordering — Part III (Mutation) precedes Part IV (Addressing). But `src/schema-guarded-mutation.md` (the Part III flagship) lists `depends: [edit-representation-landscape, errors-that-teach]` and its body repeatedly rests on `#addressing-is-the-long-pole` ("stable structural addressing," "it pulls paths, schema, spans, and round-trip all at once — which is *why* it's the long-pole customer"); and `addressing-is-the-long-pole.md` is titled and argued as the substrate *"almost every agentic affordance in this report bottoms out on."*

**What I found.** The report's own thesis is that addressing is the long pole that mutation (and query, and error-as-menu, and skeletons) all consume — yet a reader meets the full mutation demand before meeting the addressing substrate it depends on. This is a *defensible* choice (you can motivate the headline demand first, then reveal the substrate it needs), and Part III is explicitly the "largest and strongest demand cluster," so leading with it has rhetorical logic. But it is worth a deliberate call rather than an inherited one: for a document meant to *teach the domain*, an argument that "everything bottoms out on addressing" reads with more force if addressing is established as the floor *before* the cluster that stands on it, or if Part III opens by forward-declaring the dependency explicitly. Right now the dependency is only visible if you read the frontmatter `depends` fields.

**Suggested disposition.** Author's call — either (a) reorder Addressing before Mutation, or (b) keep the order but add one framing sentence at the top of Part III's scope note ("this cluster's demands all consume the addressing substrate of Part IV; we state the demand first because it is the strongest, then the substrate it requires") so the inversion is chosen and signposted, not silent. Low-cost; raises the through-line's clarity.

---

## Finding 4 — MEDIUM (excellence) — the theory tier's most vivid, teaching-rich material is compressed to citations; the flagship should surface more of it

**Where:** `src/tools-are-observation-infrastructure.md`, `src/persistence-is-imported.md`, and the Part I foundations generally; measured against the dossier's actual prose.

**What I found.** The dossier is full of genuinely quotable, teaching-grade phrasings that would make the foundations *land* for a fresh reader — and several were flattened into inventory. Concretely, from material already cited by these segments:
- **Persistence as burn-rate.** The dossier (§2.3, `impl-persistence-and-limits`): *"survival is not a state you achieve once; it is a sustained burn rate"* — and the exact capacity condition (channels must supply C ≥ 𝒯/2 per dimension *or persistence fails regardless of how good the correction function is*). The observation-infrastructure segment states "channel quality gates tempo" abstractly; the burn-rate framing is the visceral version the segment's own source hands it.
- **Confident wrongness as a signature.** Dossier §2.3: *"Confident wrongness is a structural-failure signature, not a tuning failure"* and the zero-mismatch-ambiguity point (bad channels don't just slow comprehension, they *hide miscomprehension*). The segment cites the mechanism (η*→0) but not the line that makes it teach.
- **OR-node-heavy strategy, with the worked numbers.** Dossier §2.5 (`scope-interiority-loop`): 4-step AND-chain at 90%/step = 65% vs 3-option OR at 50%/option = 87.5% — a vivid, concrete argument nowhere surfaced in the drafted spine even though it directly informs how agents should be asked to structure work.
- **The gemini-cli second-LLM edit-repair layer.** `tier2-invivo-digest.md` C2b: one team, after string-fuzzing fails, fires a *whole second LLM call* to semantically repair the edit. That is a striking "how brittle is text-addressing, really? Someone built THIS" story; in edit-representation-landscape it is a subordinate clause ("a second LLM call to repair the edit"). The vividness the corpus earned did not survive.

None of this is a fidelity defect — it is an *aspiration* gap. For "the most-read document of two programmes," the standard the coordinator named ("teach the domain to a fresh reader rather than merely index evidence") is not yet met in Part I, where it matters most, and the material to meet it is already in-hand and already cited.

**Cites:** dossier `asf-dossier.md` §2.3 (L88, "survival is not a state… sustained burn rate"; "Confident wrongness…"), §2.5 (L122, the AND/OR worked numbers); `tier2-invivo-digest.md` C2b (L62–63) for the gemini repair-layer.

**Suggested disposition.** In the Part I segments, promote 2–3 of these from citation to surfaced prose (a sentence each, quoted or paraphrased-with-force). The burn-rate line for persistence, the confident-wrongness line for the observation channel, and the gemini second-LLM story for edit-representation are the three highest-leverage. This is where excellent diverges from adequate, and the cost is a few sentences.

---

## Finding 5 — LOW — persistence-is-imported: tier-label wobble on the compaction evidence

**Where:** `src/persistence-is-imported.md` §"The evidence," second bullet header "**T2/T3 lived**," which then concludes the same evidence is "a genuine  
**Tier-1↔harness** cross-tier convergence."

**What I found.** The header says T2/T3; the conclusion says T1↔harness; the sources are the arch/harness workshop's INTERPRES note (within the *programme*, i.e. not author-independent in the strong sense) plus genuine T3 (Zi-am-tur). The Zi-am-tur anchor *is* a real lived-testimony leg (unlike Finding 1's segment, this one has one), so the convergence is real — but the label is internally inconsistent and the "cross-tier" framing quietly counts the harness workshop as an independent tier when it is within the same programme. Minor, and partly self-flagged, but it reads as imprecision in a document whose whole method is tier precision.

**Suggested disposition.** Pick one consistent labeling: the honest one is "T3 (lived,  
Zi-am-tur) + harness-workshop empirical (within-programme, adversarially verified) + T2 shipped," and drop "Tier-1↔harness" (the INTERPRES note isn't T1 ideology). One-line fix.

---

## Finding 6 — LOW — tool-definition-anatomy's T1 anchor for read-only-by-omission is from CLAUDE.md/AGENTIC-DELEGATION, not a provenanced 01-ideation artifact

**Where:** `src/tool-definition-anatomy.md` §"converged shapes" → Subagent bullet: "a genuine design law the estate learned separately (the **2026-05-02 worktree deletion**: constrain by tool-set, never by prose) — a Tier-1↔Tier-2 convergence."

**What I found.** The 2026-05-02 worktree-deletion incident is real, but it lives in `~/src/arch/AGENTIC-DELEGATION.md` (the delegation discipline file) and the project CLAUDE.md incident ledger — not in a provenanced `01-ideation` artifact with a LEDGER row. The segment cites it as a T1 leg of a T1↔T2 convergence. Per the BRIEF's "provenance always" and "every claim traces back through provenanced artifacts," this particular T1 anchor is un-provenanced within the compilation's own chain. The underlying T2 evidence (qwen Explore agent, kilocode orchestrator/explore, gemini investigator all enforce read-only by tool-omission — `tier2-invivo-digest.md` C13) is solid and carries the point on its own; the T1↔T2 "convergence" framing is what leans on the un-provenanced incident.

**Suggested disposition.** Either give the worktree incident a provenanced artifact/ LEDGER line (it's a legitimate T1 witness), or downgrade the framing to "the T2 convergence, which the estate's own delegation discipline independently arrived at (AGENTIC-DELEGATION.md)" — keeping the cross-reference honest about being an estate-doc pointer, not a compiled-corpus tier leg.

---

## Things that are working (so the coordinator doesn't "fix" them)

- **The counter-register is genuinely first-class and should be protected.** Row 5 turns fail-plausible back on the report's *own strongest theory claim* ("also qualifies #tools-are-observation-infrastructure's A≈0 story — validity ≠ truth"). That is the opposite of counter-evidence-absorbed; it is the discipline the BRIEF asked for, done well. `src/counter-register.md` L29.
- **Lineage correction is applied correctly where it counts.** edit-representation and tool-definition-anatomy both explicitly refuse the "N teams converged" move for str-replace/apply_patch/todo/ask-user and report them as survivorship-of-one-design, matching `tier2-lineage.md`. The two genuine survivors (fuzzy-ladder, headless contract) are the only ones carried at full weight. I found **no** un-corrected vote-count masquerading as independent convergence *except* the Finding-1 tier relabel (which is a tier error, not a lineage-count error).
- **RESIDUALS is honest on spot-check.** Its "no Tier-2 coverage of multi-file atomic transactions" matches edit-representation and freshness-and-atomicity (hashline is multi-*site-single-file*, correctly not counted as multi-file). Its candor about T1 under-representation and T3-via-characterization matches what I found in the segments.
- **The two consumers are not silently collapsed.** Every drafted segment I read carries an explicit "who reads this and when" / divergence line (schema-guarded-mutation names the plain-markdown-era divergence; persistence names the attestation/integrity divergence; errors-that-teach honestly says "no divergence" where there isn't one). The one segment whose whole job is the port (harness-handover-map) is correctly left `planned`, to be written last against the drafted whole.
- **The OUTLINE thesis paragraph teaches.** "Tools are an agent's observation channels and its action semantics at once … their quality is existential, not ergonomic," then converting to a properties list, is a real through-line, honestly labeled provisional.

---

## Coverage note (honest edges of this review)

I read all ~15 drafted segments and opened primaries for the load-bearing figures (yaml-spike tier/provenance, the external edit-format numbers, the C7/C8/C9/C16 digest counts, the dossier §2.1–2.4 theory quotes). I read the dossier through §4.2 (it is 330 lines; I did not need §5+ for the drafted spine, which cites at most §4.x). I did **not** independently re-verify the external T5 arXiv sources against the papers themselves — I took external-landscape's own adversarial-vote annotations at face value and checked only that the *segments* represent external-landscape faithfully (Finding 2 is the one place they don't). The `planned`/stub segments I assessed only at the OUTLINE- row + RESIDUALS level (their claims + sources are stated but, per the report's own contract, not yet synthesis-grade — I did not audit them as content, which is correct per the drafted-vs-stubbed line).
