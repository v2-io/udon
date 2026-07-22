---
source: witness lines — Part I §5 (Live consumers) rows not landed as copies/excerpts
gathered: 2026-07-21
status: commentary — witness lines (artifact existence/shape is the evidence); each verified on disk
paths:
  - /Users/josephwecker-v2/src/udon (CONSUMERS registry + scan tool)
  - /Users/josephwecker-v2/src/archema-io/** (vivarium, asf, umbrella)
  - /Users/josephwecker-v2/src/autopax/**
source_commit: udon@3d8e5b9 · vivarium@e5b022e · asf@089d2af · archema-io@1b98ad4 · autopax@033af13
categories: [live-consumer, witness, need-classes, dry-wells, agentic-tooling]
why_included: |
  The §5 rows whose signal is their existence or shape rather than their body — captured as witness
  lines so coverage is legible without carrying every consumer verbatim. Copies/excerpts for the
  high-signal live documents landed in ../copies/I5-live-consumers/ and ../copies/extracts/; this
  file is the remainder plus the section's distilled need-class checklist and its dry wells. Written
  for both audiences: UDON v2 (what the notation must serve) and the harness programme (what a tool
  presenting itself to an agent must carry).
---

# §5 Live consumers — witness lines

*Each line: what the artifact **witnesses** about real agent/human tool demand. Verified on disk 2026-07-21. Copies/excerpts for the load-bearing live documents are in `../copies/I5-live-consumers/` (ordinum parser, program TODO, PROCESS-MAP head, terrestris-ordinum head, LEXICON head, autopax taxonomy head, tabularium README) and `../copies/extracts/` (CONSUMERS.md whole, PROCESS head, DECISIONS head — all three source_commit-pinned this pass).*

## 5a. Registry & scan mechanics

- **`bin/find-consumers`** (udon@3d8e5b9) — the re-scan tool behind CONSUMERS.md. Witnesses that live-consumer discovery is a *maintained, periodic* concern (differential scan: every doc parsed with both the `core-v0.8.0` parser and current, event streams diffed) — i.e. the project treats "who breaks when the spec moves" as a first-class release gate, not an afterthought. Not re-run this cycle; CONSUMERS.md's 2026-07-16 scan is the live-doc authority. (The tool itself is mechanics, not demand text — witness, not copy.)

## 5c. Consumer-host process / loaders / program demand

- **`vivarium/FORMAT.md`** (vivarium@e5b022e, 260L) — cross-document path schemes into LEXICON/DECISIONS; §§5–6 bind *every* file including working docs. Witnesses the demand for stable, greppable cross-references between UDON documents and the governance cost of drift ("the one time that exemption was taken, the result was a document that used a term the dictionary had retired four days earlier"). Adjacent governance doc — witness, not copy.
- **`vivarium/doc/plan/regula-conformance-design.md`** (vivarium@e5b022e) — the spec for the coming `*.regula.udon` conformance profiles (world-level: which slots at what minimum rigor, which absences permitted, epistemological posture; each pins an `ordinum@version`). Witnesses a *future* UDON consumer class where the document IS a machine-checked conformance contract — and it is the source of the maturity ladder (NotStarted/Specified/Claimed/Kept) that `ordinum.rs` enforces (§4c). High-value as the design-of-record behind the ordinum parser copy; witnessed here rather than copied because it is a plan doc, not yet a live `.udon`.
- **`vivarium/tabularium/terrestris.ordinum.udon`** — landed as an excerpt (head) in `../copies/I5-live-consumers/consumer-vivarium-terrestris-ordinum-head.udon`; noted here for §5 completeness (it is both a live `.udon` doc and the input to the ordinum parser).
- **`vivarium/doc/toolchain.md`, `doc/ARCHITECTURE.md`, `ASSUMPTIONS.md`, `CLAUDE.md`** (vivarium@e5b022e) — the agent-operating-surface documents (ARCHITECTURE.md is at `doc/`, not repo root as the row's mixed path list implied). Witness the *human+agent steering surface* around a UDON-consuming project: how an agent is told to parse/validate/edit the law-data, what it may assume. Toolchain/CLAUDE carry the "validate with `stdin_parse` until a CLI exists" posture that tabularium/README states crisply. Witness set — orientation texture, not demand text per file.
- **`vivarium/core-segment-candidates-2026-07-14.md`, `feedback-from-asf.md`** (vivarium@e5b022e) — meta tooling-lift and cross-member feedback, still open. Witness that the tooling gap is actively discussed, not settled. Low priority; witness only.
- **`asf/msc/meta-process-review-2026-07-07/` tree, esp. `09-tooling-automation-capability-utilization-{findings,reflection}.md`** (asf@089d2af, findings 99L) — **high-signal, flagged for synthesis.** Headline finding, verbatim: the project has *"out-invented the harness at the cognitive layer and under-used it at the mechanical layer — and those are the same fact."* Its crown-jewel emergent method (de-novo "agentic reading" audit, a 703-line SOP, 22 audit dirs on disk) *"runs entirely by hand: no scaffolder, no enforcement, no state,"* atop a near-empty automation surface (zero git hooks, zero project subagents, one MCP, a graveyard of dead `act`-era permissions). This is a **cross-tier convergence candidate** for the harness programme: lived testimony (a real project) that the highest-leverage tool work is *carrying processes the team already runs manually* — not new features. Adjacent to the harness-invivo characterizations; surfaced here as a divergence-worth-flagging rather than re-characterized. **Recommend phase-2 pull the findings doc into a harness-facing characterization.**
- **`asf/msc/meta-process-review-2026-07-07/SESSION-LOG-2026-07-14.md`** (asf@089d2af) — the session that produced/used the process map; carries the memory-consolidation-for-launch-from-root proposal named in archema-io/TODO. Witness/provenance for PROCESS-MAP-v0.udon; low priority.
- **`asf/msc/markdown-first-pipeline.md`, `build-markdown-design.md`, `FORMAT.md`, `LEXICON.md`** (asf@089d2af, pipeline 331L) — the **Markdown-first competitor to UDON**, and honest contrast material: asf's own long-form monograph pipeline is *markdown*, not UDON (single canonical markdown-first path → PDF + `.md`, landed 2026-05-12). Witnesses the boundary UDON does NOT yet cross — asf is the estate's largest structured-authoring project and it chose markdown for prose monographs while vivarium chose UDON for law-data. The split (prose-heavy → markdown; structured law-data → UDON) is itself the demand signal about where each format earns its place, and squares with the README's "Markdown → UDON is slightly larger" note. Contrast material — witness, not copy.
- **`archema-io/CHARTER-DRAFT.md`, `charter/concept-matrix.md`** (archema-io@1b98ad4) — cross-repo format-candidate framing; concept-matrix is the cross-member concept map that archema-io/TODO item 3 wants made derivable from custodian fields. Witnesses UDON/archterm as candidate substrate for program-wide concept tracking. Low priority; witness only.
- **`autopax/TAXONOMY.md`** (autopax@033af13) — the **Markdown twin** of `taxonomy.udon` (excerpted in copies). Same content, two formats — a ready-made contrast pair for the format-comparison story. Witness/contrast; the `.udon` side is the copy.
- **`autopax/docs/ADR/`** (autopax@033af13, dir exists) — candidate ADR-as-UDON class + schema history (esp. 008 yaml/schemas, 010 MD-parse, 002b signum, 012–013 instrumenta). Witnesses a *watchlist* future consumer class (ADRs), consistent with CONSUMERS.md's candidate-future-classes list. Low priority; not yet live `.udon`.
- **`autopax/sessions/2025-01-16-yaml-and-schemas-exploration.md`** (autopax@033af13) — session texture behind the ADRs; witnesses the yaml→schema→(udon-candidate) deliberation that motivates the ADR-as-UDON watchlist. Low priority; witness only.

## 5d. Scenario-corpus mirrors of live genres

- **`test/scenarios/corpus/*.udon`** (udon@3d8e5b9, 7 files present: `archema.concept-matrix.udon`, `asf-processes.process-map.udon`, `operata-live.workspace.udon`, `operata.domain.udon`, `terrestris.ordinum.udon`, `vivarium.decision-log.udon`, `vivarium.lexicon.udon`) — in-repo CORE-0.9 renderings that **mirror** the live originals in §5b/§5c. Witnesses what the team *believed* agents would do with each genre (a belief/expectation artifact distinct from the live document) — and gives a clean before/after pair against the real consumers (e.g. `terrestris.ordinum.udon` here vs the live vivarium one excerpted in copies). Cross-ref §2 (day-in-the-life scenarios) — same files, different lens. Full [COPY] belongs to whoever owns §2; witnessed here for the live-genre-mirror relationship. Note these are 0.9 idioms, so they double as the cleanest available spec-current samples of each genre.

## Need classes distilled from §5 (checklist, from `sources-live-consumers.md` — carried forward)

Held while reading the live consumers above; each is corroborated by at least one real document this section touched (source in parens):

1. **Safe-subset + lint/fmt CLI** — every vivarium consumer taping over the CLI's absence with `cargo run --example stdin_parse` "until a udon-cli lints it" (tabularium/README; PROCESS.udon `udon-safe-subset`). The single most-repeated live demand in this section.
2. **schema = root-type = filename-designator** — `ls *.ordinum.udon`; the file self-describes and tools filter by root element type (tabularium/README; terrestris ordinum; file-naming convention).
3. **`[key]` identity density for greppable first lines** — external docs cite "LEXICON §5"; `|term[slug]` / `|process[slug]` / `|promise[slug]` as the citation anchor (LEXICON; PROCESS-MAP; ordinum).
4. **date attrs today as unvalidated strings awaiting the temporal dialect** — `:since 2026-07-04`, `:created`, `:updated` carried as bare strings; archema-io/TODO item 4 flags the YAML-era `notation:` escaping breakage as the same class of "field needs validation" problem (LEXICON; DECISIONS; taxonomy).
5. **append-friendly docs (no forced single-root wrapper) + concurrent append** — the largest append-only concurrent log in the wild (DECISIONS.decision-log.udon); demand for column-0 top-level blocks and safe concurrent appends.
6. **real library parsing for runtime instead of hand parsers** — the ordinum.rs delete-me-when- libudon-lands marker is the sharpest instance; archema-io/TODO's "Rust on udon-core" decision is the program-level commitment to it.
7. **raw dialects (`!:md:`, `!:sh:`) embedded in structured docs** — "Markdown tables live in `!:md:` blocks (a bare table row would parse as an element)" (LEXICON), and the process map's embedded tables; demand for clean escape hatches into foreign notations, including the documented footgun when they collide with UDON structure.

## Dry wells (checked, not fruitful — carried forward so they aren't re-discovered)

- **`~/src/operata`** — no live `*.udon` files; the name appears only in `design/examples/operata*.udon` (an in-repo genre seed, §4), not as a live consumer. (Confirmed via prior sweep; consistent with TARGET-FILES §5 dry-well note.)
- **`ops/`** — no hits in the capped live-consumer search pass (per TARGET-FILES §5).
- **`vivarium/doc/ARCHITECTURE.md`** — the row listed it at repo root; it is actually at `doc/` (resolved, not a true dry well — noted so the path discrepancy isn't re-chased).

## Blocked / unresolved

- None blocked. Every §5 target either landed (copy/excerpt), witnessed (above), or was a known dry well. The one path discrepancy (ARCHITECTURE.md location) is resolved above.

## Note for phase-2 synthesizers

The strongest live-consumer signal is **not** any single document — it is the *cross-tier pair*: `terrestris.ordinum.udon` (a live `.udon` law-data artifact) and `ordinum.rs` (a shipping consumer that hand-parses it and explicitly marks itself for deletion when a real UDON library lands). Theory (schema-as-data, verifiability-of-the-past via `include_str!` compile-in) meets shipped practice (a throwaway parser paying the cost of the missing library) in one place. That, plus archema-io/TODO's program-level "Rust on udon-core … agentic udon tooling within days," is the demand-side case for `udon-core` as a real embeddable library — and it names the minimum accessor surface a first release must cover (`|element[slug]`, `:field value`, `.class` stacking, `|child` predicates, absence-as- signal). The asf 09-tooling finding ("out-invented the harness at the cognitive layer, under-used it at the mechanical layer") is the parallel signal for the *harness* consumer and deserves its own pull.
