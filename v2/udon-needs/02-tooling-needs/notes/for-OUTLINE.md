# Notes for the OUTLINE (cycle 1, pilot A — Intro + Part I opening four)

*The workflow asks outline-evolution proposals as an expected output, and a cycle that leaves the outline unchanged owes a justification. Here is both: what I looked at, what held, and the one structural pressure I did surface.*

## Did the structure hold in my division? Mostly yes — one real pressure.

My four chapters (methods, counter-register, observation-infrastructure, errors-that-teach) sit in a tight, correct dependency order: methods → {counter-register, observation-infrastructure} → errors-that-teach. The recalibration I did this cycle *confirmed* one adjacency rather than disturbing it: the counter-register turns out to be a direct **instance of the methods discipline** — its whole job is strength-*capping* theses, which is the claim-level-strength machinery applied. Its placement immediately after methods is discovered-correct, not merely inherited. No reorder proposed there.

## The one structural pressure I want to surface (PROPOSED, not pinned)

**The methods chapter is carrying two distinct jobs and is overloaded.** It is simultaneously (a) *the evidence-and-register discipline* (the three axes, the strength ladder, the strengthen-before-soften stance) and (b) *the report's convention registry* — it is where the `[!capability]` card template is defined, where the frontmatter field schema is specified, where the notation conventions live. Every chapter reaches back to it for the card template specifically, but that template is buried mid-paragraph in a chapter whose front half is about epistemology.

Proposal to consider (downstream decides): split the **convention registry** (card template + frontmatter-field schema + the notation/apparatus conventions) into its own short chapter or a promoted `CONVENTIONS.md` the way `NOTATION-KEY.md` already is apparatus. That would let the methods chapter be purely about *evidence and honesty* and give the card template a findable home. I did **not** do this — it is outside my division and it is a genuine judgment call about how much apparatus belongs in a reader-facing chapter vs a reference file. Flagging as the canary asks me to.

## Report-wide propagation this cycle started (needs a coordinator decision)

The epistemic-status recalibration (the known first-cycle item) landed a **three-axis model** — genre / register / strength — and a frontmatter schema change: the old overloaded `status:` string is replaced by split `register:` + `strength:` fields, with `evidence:` staying as genre and `stage:` as maturity. **I migrated only my four chapters' frontmatter** (the in-division exemplars), per the edit-isolation rule. The other 26 chapters still carry the old `status:` string. This is deliberate — a schema change lands as an exemplar + a carry-forward note rather than a silent whole-report rewrite — but it means:

- Every subsequent window's agent should migrate their chapters' frontmatter to the split fields (methods chapter "The frontmatter machinery" section is the spec; my four chapters are worked examples of each register/strength case).
- The coordinator may prefer to do the 26-chapter `status:`→`register:`+`strength:` migration in one mechanical pass rather than window-by-window, since it is low-judgment once the convention is fixed. Either works; naming the choice.

## Layer-split residual I surfaced rather than edited (counter-register)

Sweeping my chapters for body revision-memoir (per Joseph's live correction), one pre-existing item in counter-register is borderline and I left it for a judgment call: rows 10 and 11 open with "(dissent entered by a GPT-family / Gemini-family reviewer, 2026-07-22)". The *model-family* attribution is load-bearing **content** (the intro says these rows exist to show what out-of-ecosystem evidence looks like), but the "dissent entered by … on 2026-07-22" framing is process-memoir. Disentangling the two — keep the family, drop the entry-event date/verb — is a small rewrite of prose I didn't author; flagging for the next window rather than doing it unilaterally.

## Destination shift consequence for harness-handover-map (Part VIII)

Joseph updated the second-consumer destination mid-cycle: the handover is now expected to land **inside ASF as a new group within 02-TST**, not as a standalone archema transfer. Consequence for `harness-handover-map` (not my division): its reader is now *ASF's/TST's reader*, not an external archema recipient — the chapter's framing, "what transfers as-is vs re-based," should be rewritten from that perspective (the port is now into a sibling corpus that shares vocabulary, so the transmission-fidelity story changes — inherited results become live `depends:` edges, not frozen quotes). Flagging for whoever takes Part VIII. Full reasoning in `notes/epistemology-pilot-A.md` §0.1.

## Vocabulary the report now owns (for consistency in later windows)

The strength ladder is **exact / conditional / robust-qualitative / measured / heuristic / hypothesis / discussion-grade** (ASF's own five, plus *measured* and *hypothesis* for this report's empirical and proposed claims). Later windows should tag headline claims from this fixed list, not invent adjacent words ("theorem-grade" → *conditional*; "high confidence" → the rung that fits).

---

# Notes for the OUTLINE (cycle 1, pilot B — the V/VI straddle)

Division: `typing-and-schema-boundary` (V), `templates-and-dynamics-demand` (V), `annotation-and-metacognition` (V), `context-economy` (VI). The Part boundary falls inside my window by design; that vantage surfaced two seams and confirmed pilot A's convention-propagation.

## The V/VI seam was a *format* discontinuity — healed, and it validates the window

Reading straight through in OUTLINE order, the three Part V chapters carried their ideation as `✦`-bullets while the Part VI chapter (context-economy) carried full `> [!capability]` cards — the register visibly changed shape mid-window with no reason a reader could see. That is the known ✦→card retrofit item, sitting exactly on my part boundary. **Healed:** the three Part V chapters are retrofitted to cards (impact fields enriched with named theory quantities, not mechanically converted). Reported as a *finding* because it is direct evidence FOR the rolling-window mechanism — a seam invisible from inside either Part alone was obvious to an agent reading across the boundary. The retrofit remains open for the other pre-card chapters (Parts I–III, V, VII).

## A *substantive* V/VI seam still open — annotation ↔ continuity-infrastructure

`annotation-and-metacognition` (V) and `continuity-infrastructure` (VI) share one demand and state it from two sides without cross-reference. Annotation's "identity-grade form" section and its **congruency-reader** card are about provenance-for-re-reading-your-own-past and verifiability-of-the-past — which is continuity-infrastructure's stated territory (attestation, congruency affordances, temporal markers). Annotation itself says its demand "recurs … all the way up to identity infrastructure." **Proposal (PROPOSED, downstream decides), for a future window holding both:** either (a) move annotation's identity-grade half toward VI and keep V's annotation chapter about the *ergonomic* residue (confidence / decision / draft), or (b) keep the split but wire an explicit cross-reference so the congruency demand is stated *once* and consumed twice rather than derived twice with drift risk. I could not act (continuity is outside my division); also left in `notes/for-continuity-infrastructure.md`. This is the substantive-seam kind the window exists for; the format seam above would have been caught anyway — worth distinguishing the two kinds (see my workflow feedback, point 1).

## Convention propagation — I applied pilot A's three-axis migration to my four

Adopted pilot A's `status:`→`register:`+`strength:` split on all four chapters as in-cycle application. Rungs assigned: typing = robust-qualitative; templates = robust-qualitative (structural claims, after de-novo corroboration) with product-shape specifics still heuristic; annotation = robust-qualitative; context-economy = robust-qualitative (conditional-theory backbone + measured numbers). Reconcile against pilot A's ladder at the coordinator step if any rung reads off. This is the second half of the propagation pilot A named — definition in their division, application in mine.

## Templates is no longer the evidence tail of Part V

A de-novo end-user elicitation (cross-lineage, no project context; `01-ideation/02-provenanced/copies/de-novo-testimony/templates-testimony-grok-2026-07-22.md`) independently reproduced the templates chapter's structural consequences and added report-novel directions. Its structural claims now carry three independent legs (owner + two same-discussion reviewers + one unprimed cross-lineage agent). No reorder proposed, but if a future pass ranks Part V internally by evidence weight, templates has moved up from clear-thinnest.

## Within-window order held

typing → templates → annotation is a sensible progression (typed values → computed/dynamic values → metacognitive residue); context-economy opens VI cleanly. The only genuine structural pressure is the annotation↔continuity seam above — a finding, not a default "structure held."

---

## Outline-evolution proposals (coordinator, 2026-07-22, from Joseph's read-questions)

### Proposed chapter: code-indexing-and-navigation-paradigms (Part IV-adjacent)

Joseph asked whether the report covers how harnesses *index and interact with* code distinct from editing — LSP, tree-sitter, semantic pre-indexing. It does not; verified gap (report grep + corpus check, 2026-07-22). The corpus HAS the threads, characterized but never synthesized: aider's tree-sitter repo-map (~100 .scm tag-query files, definitions/references, read-only framing — flagged MEDIUM-HIGH in its in-vivo map), Claude Code's LSPTool, grok-build's lsp/ implementation, sar3's LSP-chunking concept. The extraction lens (edit/context/I-O) never looked here — phase-inheritance law in action. Chapter shape: the three paradigms as a support-kind-style taxonomy — **tree-sitter static-parse** (fast, universal, no type knowledge) / **LSP live-server** (always-fresh, language-semantic, heavyweight, per-language) / **embedding pre-indexed** (fuzzy recall, staleness risk; closed-source examples not in corpus — needs deep-research) — each with its freshness guarantee, failure mode, and repair. Read-side twin of addressing: repo-maps and LSP indexes are how agents address code *today*; a tree-sitter query and a UDON path are both structural addressing; LSP `references` ≈ the `all()` verb. Extraction targets: the three in-vivo sections above + sar3; commission deep-research for closed-source indexers. Sequence: after the current epistemology implementation lands.

### Proposed survey: the tooling ecosystem — skills, plugins, MCP tools (Joseph, 2026-07-22)

"A general survey of tooling-related skills available out there, plugins, and especially mcp tools." Territory the corpus barely touches (the in-vivo maps note MCP *plumbing* — Claude Code's MCPTool/McpAuthTool, deferred loading of MCP schemas — but nothing surveys the *ecosystem*: what tools exist, their categories and quality distribution, what agents actually get offered, registries and discovery, the skills/plugin systems across harnesses and their design differences). Shape: primarily a deep-research commission (external landscape, Tier-5-style: MCP registries/marketplaces, skill ecosystems, plugin architectures per harness) + a re-mine of the in-vivo maps' plugin/skill/MCP sections + de-novo agent testimony ("what tools do you wish were offered to you? what's in your MCP roster that's noise?"). Feeds: tool-definition-anatomy (the anatomy at ecosystem scale), invocation-paradigms (deferred loading exists BECAUSE of ecosystem bloat), context-economy, and the harness handover (roster curation is a harness design decision). Likely lands as a new report in reports/ + a bridge chapter, rather than a chapter alone — it's survey-mass, not synthesis-mass. Sequence: deep-research can run parallel to anything (external, no collisions); synthesis after epistemology implementation.

---

## The coming segmentation (Joseph, 2026-07-22) — record of the lean, not yet an action

**The principle, in his words:** ASF's "secret sauce" was religiously breaking a section/chapter/topic into its **individual constituent claims**, allowing only afterword discussion-grade and introduction-grade segments alongside them — "because the claims could harden or be fixed independently, while their organization and dependency chain could be reorganized independently."

**Status: coming, deliberately not yet.** Joseph: there is "some advantage to staying broad-topical" while we are still rearranging at that level of abstraction and "only starting to cement" — but he expects to feel compelled to split "within the next few days." Recorded now so the work between here and there is done in a way that makes the split cheap rather than expensive.

**What the target shape is** (read from `#asf/aat/` OUTLINE + three segments):

- A **chapter is a container**, not a file — an OUTLINE heading plus a table of segments. Segments are the files. Our current chapter==file state is transitional; after the split each of our chapter-files becomes a Chapter holding N claim segments plus its glosses. *"Chapter" survives as the container word and "segment" becomes the file word — so nothing needs renaming now.*
- **Claim segments** carry exactly one claim: frontmatter (type/status/depends/ stage) → title → one-paragraph summary → `## Formal Expression` (with claim-level tags) → `## Epistemic Status` → `## Discussion` → `## Working Notes`. Self-contained.
- **Intro-gloss segments** (`type: discussion`, `status: discussion-grade`, light `depends`, no formal-expression/epistemic-status sections) open a chapter: recap the prior chapter, frame what is coming, and close with a roadmap naming the segments that follow in order. Their Working Notes say plainly that they carry no formal claim.
- **Discussion-gloss segments** (`impl-*`) close a chapter: the consequences that do not sit beside any single derivation, with a heavy `depends` list on the claims they discuss.

**The forward-reference rule, corrected by Joseph** (an earlier reading of mine was wrong — the rule is about *dependency*, not mention):

- A segment **may** note a downstream segment to anticipate a question that downstream segment addresses.
- It **may not** repeat the downstream segment's claim in a way that might not stay evergreen.
- It **absolutely may not rely on** a downstream segment — with one exception: **appendices may be depended on in reverse** ("for the details, the derivation this relies on is in appendix segment xyz").

**What our claims will be, when split** (Joseph named the kinds): independent empirical measurements · independent user-voice aggregations · independent capability cards · plus the observational-convergence claims, each carrying its own descent correction.

**Why this does not threaten the by-degrees pedagogy.** By-degrees prose is order-*dependent*; claim segments are order-*independent*. ASF resolves the tension by division of labor — **connective tissue lives in the gloss segments; claims are self-contained** — which is exactly why the intro-gloss is the one place forward-pointing prose belongs. Our bridges are *already* intro-gloss segments structurally (they orient, they hand off, they close with a roadmap), so the split is an **extraction of the claims currently embedded in bridge prose**, not a rewrite of the bridges.

**Cheapest preparation between now and then** (do this; do not split yet):

1. **Finish the leg-tables** wherever a chapter carries ≥3 load-bearing claims at mixed strength (five by the R3 census). A leg-table *is the split manifest in embryo* — it already enumerates a chapter's constituent claims with kind and strength.
2. **Keep connective prose at each bridge's opening and closing**, not woven through the claim material, so extraction is a clean cut.
3. **Keep capability cards self-contained** — they port to claim segments nearly as-is.
4. **Readiness signal:** the split gets cheap when a deepening cycle ends with *"we looked and the structure held"* as a genuine finding rather than a default. While the outline is still gaining chapters (two proposed today), a claim-split would mean re-homing segments repeatedly.

**What we lack that the target shape has:** the `impl-*` chapter-end discussion form. Our "Honest edges" is its much smaller cousin.
