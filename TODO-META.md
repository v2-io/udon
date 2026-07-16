# TODO-META — the tracking system itself

Cross-cutting meta work: the compliance-versioning keystone, the tracking
structure, and dogfood milestones. Not a valve — items that need Joseph carry
`*(discuss w/ Joseph)*` inline.

## Open

- [ ] **[P0] Semantic spec-versioning + per-version compliance-fixture groups —
      principled.** *Versioning spine established 2026-07-14:* `spec/CHANGELOG.md`
      (Keep-a-Changelog + SemVer); `CORE.md` is now **0.8.0-alpha.1** (maturity
      ladder: alpha → beta → rc → final, gate = compliance-passes); the model is
      CommonMark's — the spec is the versioned contract and impls declare which
      version they pass. **Remaining:**
      - Build the **0.8.0 compliance-fixture group** in `core/fixtures/v0.8/`.
        *Bundling done 2026-07-14* — legacy set aside (`core/fixtures/legacy-pre-0.8/`,
        tag `grammar-v0.7`), v0.8 group live, harness rewired to discover it
        dynamically. *First full authoring pass done 2026-07-15:* ~227 cases
        across 15 files, every expectation derived from a complete read of
        `spec/CORE.md` + companions (never traced from the parser). *Gate
        GREEN 2026-07-15*, **0.8.0 finalized + tagged `core-v0.8.0`
        2026-07-15** — first version with a compliant parser; v0.8 group
        frozen. **0.9.0-alpha.1 opened same day** (attribute-model
        reconception): active group `core/fixtures/v0.9/` seeded from v0.8;
        `udon-core` declares targeting via `CORE_COMPLIANCE` in `lib.rs`;
        `version_declarations_agree` (canonical.rs) asserts CORE-VERSION /
        CORE_COMPLIANCE / ACTIVE_GROUP move together. **Remaining (now under
        v0.9):** edit the group to the 0.9 CORE text as it lands; mine
        `legacy-pre-0.8/` for still-valid regression cases not re-derived
        (esp. `indentation_edge_cases`, `prose_dedentation` depth,
        `element_names` charset torture cases); keep densifying
        edge/combination coverage as gaps surface.
      - Stand up the **unified compliance gate** — event-level fixtures by default
        (easiest place to reason about/fix the descent grammar), AST-level only
        where a core-syntax property is genuinely easier to assert there.
      - **Finish the drift-check**: the in-repo test covers
        CORE-VERSION/CORE_COMPLIANCE/ACTIVE_GROUP; CI-level assertion that
        the `CORE.md` header and `CHANGELOG.md` top entry match
        `spec/CORE-VERSION` is still open.
      Once this exists, `TODO-CORE-PARSING` and `TODO-PARSER` hold only residuals
      and decompositions, not the spec-behavior worklist.
- [ ] **Bootstrap: drain the legacy tracking into the lanes, deprecating the
      subsumed.** Triage every open item in the old places — the `design/`
      notes, `REVIEW-JULY-2026.md` §4/§7-F, the `REBOOT-PLAN.md` backlog
      (§4 Phases 1–3 + spike track) — and route each to its lane.
      (`core/PLAN.md` drained and deleted; the Dec-2025 `docs/` brainstorms
      moved into `design/` as AGENT-UX mining sources.)
      **DEPRECATE (do not re-track) anything subsumed by the fixture + grammar
      iteration passes**: a "make the parser do spec-behavior X" item *is* a v0.8
      compliance fixture, not a separate CORE-PARSING task. Only genuine residuals
      survive — streaming-resumption architecture, grammar DRY, pending descent
      items, perf, bindings, utilities, still-open spec decisions. Delete each
      source when fully drained. The per-lane "pull from X"
      tasks are the hands; this is the rule they follow.
- [ ] **[later] Dogfood:** once this version is all the way through core and the
      parser is compliant, rewrite these TODO files as UDON.
- [ ] **[later] Consider UDON for the test fixtures themselves** (today:
      YAML in `core/fixtures/`). The dogfooding appeal is obvious — the
      compliance corpus written in the language it certifies. (Parenthetical
      worth weighing before committing: udon-within-udon means the fixture
      *reader* is itself a parser whose compliance must be tracked
      distinctly from the *target* parser under test — a broken parser
      could misread the very fixtures that would catch it, so the loader
      would need pinning to a known-good parser build or a bootstrap story.
      That may add more complexity than it's worth; decide with eyes open,
      possibly only after `core-v0.8.0` is green and tagged so a trusted
      reader exists.)
