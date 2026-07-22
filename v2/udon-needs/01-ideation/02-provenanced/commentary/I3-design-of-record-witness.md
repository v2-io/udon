---
source: witness lines — Part I §3 (Design-of-record & lived wishlists, in-repo) extraction
gathered: 2026-07-21
status: commentary — witness lines (artifact existence/shape as evidence) + demand-lines
  mined from TODO lanes whose bulk is syntax-law or parser bookkeeping (never signal);
  NOT authoritative
paths:
  - spec/TODO-SPEC-CORE.md
  - spec/TODO-SPEC-OTHER.md
  - core/TODO-CORE-PARSING.md
  - core/TODO-PARSER.md
  - TODO-META.md
  - TODO-PUBLISHING.md
  - tools/descent/TODO-DESCENT.md
  - design/composite-types.md
  - design/markdown-layers.md
  - design/markup-feature-matrix.md
  - design/semachrome.md
  - design/udon-paths.md
  - design/udon-schema-exploration.md
  - design/README.md
  - design/attribute-model-2026-07.md (+ proposal-2/2-substrate/3/3-substrate)
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [agentic-tooling, human-ux, keep-everything, design-of-record, witness]
why_included: |
  The rows in §3 that resolved as witness lines rather than copies — either because the
  artifact is dominated by syntax-law / parser bookkeeping (with a demand-line or two
  worth mining out), or because it is an explicitly-superseded / pointer-only source
  whose *shape and existence* is the evidence. The copies/excerpts for §3 live in
  copies/I3-design-of-record/; this file carries what the copies would have buried.
---

> **Why this file:** Part I §3 is design-of-record & lived wishlists. Most of it became
> concrete copies (see `copies/I3-design-of-record/`). What remains here is (a) genuine
> demand-of-record lines mined out of TODO lanes whose *bulk* is syntax-law or parser
> residue — the vision says the bookkeeping around a want is not signal, the want is —
> and (b) witness lines for pointer-only / superseded sources where existence-or-shape
> is the evidence. Read alongside the copies, not instead of them.

## Demand-of-record mined from the spec / parser / meta TODO lanes

These lanes are mostly syntax-law (ruled elsewhere) and parser bookkeeping — deliberately
NOT copied. But each carries a design-of-record demand worth surfacing for synthesis:

- **`spec/TODO-SPEC-CORE.md` — "text must be reconstructable from the events alone"**
  (Joseph, 2026-07-19, marked "⚠⚠ P0, THE HIGHEST SHOW-STOPPING PRIORITY IN THE
  PROJECT"): the event wire dropped line terminators, so joining prose required
  source-gap inspection ("zero sense whatsoever"), and the framing — the bug was
  "ENABLED by the fixtures instead of caught by them" — is the crux. Fully captured as a
  copy: `copies/I3-design-of-record/TODO-TEXT-WIRE.md` (the landed design of record). Noted
  here so the SPEC-CORE lane's demand isn't missed.
- **`spec/TODO-SPEC-CORE.md` — surrogate + natural identity** (Joseph, 2026-07-16,
  motivated by vivarium's `terrestris.ordinum.udon` where `|phase[scribal]` also carries
  `:num 9`, "an identity in practice, unreferenceable as one"): the want is
  address-by-either-key (`@phase[9]` ≡ `@phase[scribal]`), rooted in the observation that
  "UUIDs appear in both databases and documents, and nothing cleanly puts uuid in the
  same category as a simple auto-increment key… no one has built the middle." Demand
  signal: notational markup wants relational-grade identity. (The grammar mechanics are
  syntax-law, not copied.)
- **`spec/TODO-SPEC-OTHER.md` — normative-status callouts as an agent-legible layer**
  (ratified 2026-07-19): a fixed callout vocabulary marking each spec block's normative
  status — `IDIOMATIC` (the right way), `AVOID` (foot-gun), `UNDEFINED BEHAVIOR`,
  `CURRENT BEHAVIOR` (present, descriptive, likely-to-change) — "the label word states
  intent more clearly than the prose it replaces," and the CURRENT-BEHAVIOR tag exists
  specifically to keep "current-parser behavior from silently calcifying into grammar."
  Demand signal: machine-legible normative status is itself a tool affordance (both for
  agents reading a spec and for guarding a living spec against calcification).
- **`spec/TODO-SPEC-OTHER.md` — the pragma** ("the in-document declaration binding a
  document to its dialects + schema + expected host-interpreter version… tiny surface,
  future-proofs everything — a source-of-truth substrate must survive its own
  evolution"). Demand signal: a self-describing document format needs versioned
  self-declaration to remain trustworthy across its own evolution.
- **`core/TODO-PARSER.md` — keep-everything at the AST layer / "tree + diagnostics, not
  Result<Tree,Err>"**: the demand is a parser API that (a) keeps the built tree even on
  error, (b) surfaces warnings (currently "never collected… a caller can't see them at
  all"), and (c) reports a completeness verdict separately — "the rust-analyzer/rowan
  tree + diagnostics shape rather than `Result<Tree, Err>`." Demand signal: an
  agent/tool-facing parser must never throw away partial understanding on error.
- **`core/TODO-CORE-PARSING.md` — keep-everything violation, loud-failure principle**: a
  `|{…}`-led block-prose line "silently swallows following same-column structure… **no
  warning**, a keep-everything violation (structure lost)." Same principle as the
  text-wire defect: silent re-parenting is the enemy; the format must fail loudly. (The
  lane also carries the PAUSED attribute-value wire DERATIFICATION banner — a project-state
  fact matching the session pivot, not itself demand.)
- **`TODO-META.md` — the artifact-ecosystem / density-gradient thinking** (Joseph,
  2026-07-18): the demand is a DERIVED family of projections from one authoritative
  source — "literate fusion" (spec prose + descent grammar + compliance fixtures extracted
  from ONE UDON-shaped source, so spec↔grammar↔fixture changes are atomic) — with two
  sharp insights for the both-consumers question: (1) the density gradient
  [cheat-sheets < learning < fixtures < spec < grammar] pays off ONLY if the artifacts
  are derived, not hand-maintained ("the scatter problem ×N" otherwise); (2)
  "**pedagogy is audience-relative** — fixtures and grammar are genuinely *pedagogical
  for agents* where a human would find them dense." Demand signal: agent-facing and
  human-facing documentation are different projections of one source, and density ≠
  authority ≠ audience.
- **`TODO-PUBLISHING.md`** — release/crates.io/README bookkeeping only; no demand
  content. Dry.
- **`tools/descent/TODO-DESCENT.md`** — grammar-generator wishlist (state-templates,
  name-derivation, parser-manifest drift-guard). The *lived* version of these wants —
  the tool's author describing where descent fought back — is captured as a copy:
  `copies/I3-design-of-record/descent-experience-2026-07.md`. The TODO lane itself is
  generator bookkeeping. (Note: the standalone `~/src/descent/TODO.md`, 28 KB, is the
  independent descent repo's tracker and "may drift from the submodule pin" — a separate
  repo's bookkeeping; its demand overlap is already captured by descent-experience.)

## Witness lines — pointer-only / superseded / syntax-law sources

- **`design/composite-types.md`** — direction (not ratified) for nested `<…>` typed
  constructors (`<r: <i: 3 -7> 0d83.23>` = Rational(Complex(3,-7), 83.23)). Witness:
  the demand is composable typed literals with NO operator precedence ("UDON is
  operator-free… a composite value is *lexed*, not computed") — a design stance, but
  the content is type-system syntax-law, ruled elsewhere. Existence noted; not copied.
- **`design/markdown-layers.md`** — promoted to `spec/MARKDOWN.md`. Witness: names the
  four things never to conflate (markdown-inside-prose / the doc-vocabulary schema /
  udon2md·md2udon conversion / rendering-to-targets) and, within them, the real TOOLING
  wants: `udon2md`/`md2udon` with a defined degradation policy for non-doc structure, a
  named `doc` schema vocabulary, per-target renderers (ANSI/HTML/Obsidian). The taxonomy
  is spec-law; the conversion/rendering tools are the demand. Witnessed, not copied.
- **`design/markup-feature-matrix.md`** — a 26-language lightweight-markup comparison
  (Dec-2025). Witness: UDON's design explicitly weighed itself against 26 alternatives,
  and — notably for this compilation — treats **"LLM Fluency"** (how readily a model
  generates correct syntax from training) as a FIRST-CLASS design axis, a column across
  every format. Demand signal: agent-writability is a measured design criterion, not an
  afterthought. The table itself is competitive facts about *other* formats (evergreen
  reference), so it is witnessed, not copied.
- **`design/semachrome.md`** — Dec-2025 highlighting/theme-generation exploration,
  largely superseded (the autocolors engine landed for real; the "two parsers, two
  purposes" framing is undercut now that highlighting renders from parser events+spans).
  Witness: the surviving demand is multi-target theme generation (.tmTheme/vim/emacs/
  CSS/ANSI) and colorscheme-definition-in-UDON — human-side coloring, mostly captured by
  the copied `TODO-HUMAN-UX.md` + the autocolors work it references. Witnessed.
- **`design/udon-paths.md`** — explicitly STALE, "input material, not a design of record"
  (Joseph: "old and stale… zero need to care at all about what it says"). Witness: its
  surviving-on-merit ideas (paths reuse UDON's own prefixes; traits AND-filter;
  `at`=exactly-one-or-error / `all`=explicitly-plural — the fail-on-ambiguity contract
  the edit tool needs) are already carried by the copied adjudication packet, which
  supersedes it as the paths source. Witnessed; not copied (per its own banner).
- **`design/udon-schema-exploration.md`** — pointer-only (Jan-2026, 13 numbered "Puzzle
  Pieces"; "a workspace, not a conclusion"). Witness: it holds the SINGLE-SOURCE-OF-TRUTH
  vision in its clearest early form — "**UDON documents are the single source of truth
  from which everything else flows**": schema/resource/instance data all UDON, and SQL
  DDL / JSON Schema / Ruby classes / API definitions / validation all *derive* from the
  schema. Self-describing, self-validating, declarative. Superseded in specifics by
  schema-workbench + schema-notes (both captured), but the vision statement is the
  witness. Its closing brief to a successor: "Find the minimal coherent core. Let the
  elegant unification emerge rather than forcing it."
- **`design/README.md`** — orientation banner for the whole `design/` tree. Witness: the
  tree is "ahead-of-spec exploration (partly superseded)… rich in genuinely good future
  directions… the ideas outlive their now-stale details," with NO process keeping it in
  sync with CORE — and `agentic-ux-principles.md` is the standing exception, "the design
  of record for the tooling pipeline's UX" that governs where other sketches disagree.
  Reading guide for every §3 design-file, not a source itself.
- **`design/attribute-model-*`** (2026-07 + proposal-2/2-substrate/3/3-substrate) — the
  §3 row's "lower for demand, listed so it isn't rediscovered as a miss." Witness: these
  are supply-side attribute-model design, mostly ratified into CORE 0.9. Confirmed
  present on disk (5 files); syntax-law, not agentic-tooling demand. Checked, not copied
  — logged so a later sweep doesn't re-flag them as unreached.
