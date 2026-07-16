# TODO-META — the tracking system itself

Cross-cutting meta work: the compliance-versioning keystone, the tracking
structure, and dogfood milestones. Not a valve — items that need Joseph carry
`*(discuss w/ Joseph)*` inline.

## Open

- [ ] **[P0] Compliance-versioning residuals.** The spine is live: semver'd
      CORE (`spec/CORE-VERSION`) + per-version fixture groups + the
      `version_declarations_agree` test; model and history live in
      `spec/msc/CHANGELOG.md` and `core/fixtures/README.md`. Remaining:
      - **Unified compliance gate** — event-level fixtures by default (the
        easiest place to reason about/fix the descent grammar); AST-level
        only where a core-syntax property is genuinely easier to assert
        there (none exist yet).
      - **CI drift-check** — the in-repo test covers CORE-VERSION /
        CORE_COMPLIANCE / ACTIVE_GROUP; the CI-level assertion that the
        `CORE.md` header and `CHANGELOG.md` top entry match
        `spec/CORE-VERSION` is still open.
      - **v0.9 group densification** continues before any `core-v0.9.0` tag
        (EOF/`Unclosed*` behaviors, `legacy-pre-0.8/` mining — esp.
        indentation edge cases, prose-dedentation depth, element-name
        charset torture — and edge/combination coverage); operational
        detail in `core/fixtures/README.md`.
- [ ] **[later] Literate fusion — the fused ground truth (CTQ-E).** Spec
      prose, descent grammar, and compliance fixtures extracted from ONE
      source — which, since `.desc` is already UDON-shaped, can itself be a
      UDON document — so spec↔grammar↔fixture changes are atomic in a single
      commit. Upgraded from aspiration to IN by Joseph (2026-07-08) after
      reconciling five divergent opinions by hand (spec prose, grammar,
      generated parser, fixtures, live probes) cost a review cycle for one
      fence question. Pilot on a single feature first (fences was the
      proposed pilot); gated on grammar congealment. Test blocks can drop to
      `!:rust:` doctests where the fixture DSL falls short (Joseph).
      *(routed from the archived review/reboot plan, 2026-07-16)*
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
