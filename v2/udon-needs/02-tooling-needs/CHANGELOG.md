# CHANGELOG — the tooling report

The history layer for this monograph. **Chapter bodies state present truth
only** — how a claim evolved, what it replaced, when and why it changed
belongs here (with the git log as the fine-grained record), or in the
chapter's `## Working Notes` while still unresolved. A body never narrates
its own revision history; a reader of the report should encounter the work
as it now is, not a memoir of how it got here — except where the evolution
is itself part of the tooling narrative (an assumption's archaeology, an
abandonment that explains a landscape) and is told as *content*, in domain
voice.

Format: date · scope (chapter/report/OUTLINE) · what changed, present-tense
description of the delta · why (one line; link a spike/note if one exists).
Append-only.

---

- 2026-07-22 · report · Created during deepening cycle one, as the
  destination for revision commentary purged from chapter bodies per the
  integration-is-replacement discipline (see DEEPENING-CYCLES "The layer
  split"). Prior history: the git log back through `584befb` (the report's
  seeding) and RESIDUALS §revision-log.

- 2026-07-22 · method-evidence-tiers (deepening cycle 1, pilot A) · Adds the
  claim-level **strength** axis (exact / conditional / robust-qualitative /
  measured / heuristic / hypothesis / discussion-grade) as a first-class third
  axis alongside genre and register; strength applies only to the truth-apt
  registers (decided takes no rung, proposed is hypothesis by construction).
  Frontmatter machinery: split `register:` + `strength:` fields replace the
  earlier single `status:` string, which blended genre-count, strength, and
  maturity into one unsortable label. · Why: the first-cycle recalibration —
  the evidence tiers are provenance genres, not epistemology; the strength
  model was previously named as "queued" and is now landed. Report-wide
  frontmatter migration carried forward in notes/for-OUTLINE.md.

- 2026-07-22 · method-evidence-tiers (pilot A) · Register section retitled and
  corrected from "Three registers" to four (derived/evidenced/decided/proposed);
  ✦-retrofit revision-memoir removed from the capability-card paragraph. · Why:
  pre-existing count defect exposed by the three-axes edit; layer-split purge.

- 2026-07-22 · counter-register (pilot A) · Weight column now leads each of the
  11 rows with its claim-level strength rung. · Why: a counter-row caps a
  thesis's strength, so strength is the shared currency that makes the
  methods↔counter-register seam load-bearing rather than decorative.

- 2026-07-22 · tools-are-observation-infrastructure (pilot A) · The "A is the
  one knob anyone gets" claim is strengthened (not softened) by naming the
  W₁/W₂ wrapping constructions precisely: they buy a provable separation
  *certificate*, not a material behavioral bias reduction, so A remains the
  only knob that moves bias rather than certifying it. · Why:
  strengthen-before-softening on an apparent overclaim, verified at the
  asf-dossier source (disc-w1-structural-bound-boundary).

- 2026-07-22 · errors-that-teach (pilot A) · The five ✦-bullet ideation items
  become `[!capability]` cards (what / principles / hypothesized impact in named
  theory quantities / in-tension-with / downsides), written from first-person
  end-user friction. · Why: the RESIDUALS ✦→card retrofit item, applied to this
  chapter with impact-field enrichment.

- 2026-07-22 · method-evidence-tiers (pilot A, epistemology step 1; trio-ratified
  774f022) · Rewritten whole to the ratified epistemology system: three axes
  (support-kind with per-kind repairs / strength / register) + two locks
  (convergent, keyed on failure-mode independence; transmission, as cross-volume
  reference + verification events) + the append-only verification-event log
  (gates are re-runnable checks, not a promotion ladder). T1–T5 genre codes
  retired to an auditor's historical mapping note. Notation exemplar baked in
  (`[[stem| #tag]]` segment refs; no backticked slugs). · Why: completes Joseph's
  "tiers are library categories, not epistemology" recalibration; the schema's
  home. Reasoning record: notes/epistemology-{pilot-A,SYNTHESIS}.md.

- 2026-07-22 · errors-that-teach · tools-are-observation-infrastructure ·
  counter-register (pilot A) · Frontmatter migrated to the new schema
  (`support-kind:` / `convergent:` / `verified:` added, `evidence: [T…]` retired)
  as the sweep exemplars; errors-that-teach body now states the convergence
  honestly as three independent kinds + a descent-echo (the lock's worked
  example); observation-infrastructure gains a "what each leg carries" leg-table;
  counter-register recognized as already a leg-table. · Why: epistemology step 1
  (my two leg-tables + exemplar frontmatter). The bulk cross-reference conversion
  to `[[stem| #tag]]` across all 30 chapters is B's step-2 sweep.

- 2026-07-22 · all 30 chapters (pilot A, epistemology step 2 — inherited from
  pilot B after session loss) · Frontmatter migrated to the ratified schema:
  `register:` / `support-kind:` / `strength:` / `convergent:` / `verified:`
  present on every chapter; `evidence: [T…]` and the overloaded `status:` string
  retired. `convergent:` legs assigned under the failure-mode-independence key,
  not by counting evidence codes — the systematic consequence being that the
  design work and the formal theory **share an author** and therefore count as
  one estate leg, which un-arms or reduces several locks (tracking-snapshots'
  "built / designed / theorized" is one leg, not three; progressive-disclosure is
  not armed at all). Three pre-existing unquoted-colon `consumers:` values fixed
  so all frontmatter parses as YAML. · Why: the schema is only worth having if it
  is honest and machine-auditable; both required per-chapter judgment rather than
  a code-to-kind mapping.

- 2026-07-22 · five chapters (pilot A) · `## Working Notes` added to
  progressive-disclosure-read-path, templates-and-dynamics-demand,
  tracking-snapshots-as-perception, the-crystallized-process-thesis,
  edit-representation-landscape · recording the non-obvious leg calls, what would
  change each, and one unrouted principle (descent-correction applies to
  agreement claims but not to absence claims — may belong in the methods
  chapter). · Why: these are judgments a later agent should be able to challenge.

- 2026-07-22 · context-economy · typing-and-schema-boundary ·
  edit-representation-landscape · tools-are-observation-infrastructure (pilot A)
  · Leg-tables added (the R3 census completed), built as **split manifests**:
  one row per extractable claim carrying its support-kind, strength, and the
  evidence-action that would move it — so the coming claim-segmentation can lift
  each row into its own segment. observation-infrastructure's earlier table
  upgraded to the same four-column shape. edit-representation's table states the
  agreement/absence asymmetry that lets its `observational` leg sit at full
  weight. · Why: a leg-table is the split manifest in embryo; building them this
  way costs nothing now and saves the split later.

- 2026-07-22 · four chapters (pilot A) · Duplicate `register:`/`strength:` keys
  removed from annotation-and-metacognition, context-economy,
  templates-and-dynamics-demand, typing-and-schema-boundary — the migration had
  added canonical fields alongside pre-existing ones, and YAML last-wins meant
  the older values were silently overriding. Values agreed in all four cases;
  the richer comments were kept. · Why: a duplicate key in machine-auditable
  frontmatter is a silent-wrong-answer defect, not a cosmetic one.

- 2026-07-22 · report (pilot A, epistemology step 5) · TST-extension memo drafted
  (`notes/TST-extension-memo.md`) — the deliverable's outward face: seven
  proposed additions to TST's evidence vocabulary (support-kind as a separate
  axis; six kinds defined by repair; the convergent lock keyed on failure-mode
  independence; the verification-event log; transmission-without-a-new-status;
  `demand` type + `bridge` file-kind; the cross-volume reference notation), each
  priced for adoption cost, plus what we adopted from ASF unchanged and four open
  questions for its maintainers. Written in the improvement-proposal voice the
  provenance recalibration licenses. · Why: the corpus expects to land inside
  02-TST; its warranted differences are contributions, not local dialect.
