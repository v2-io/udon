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
        there (none exist yet). One class already needs a non-event surface:
        the **document-level incomplete-input result** (alpha.2 two-level
        severity) is a *result*, not a wire event, so no event fixture can
        assert it — interior-newline closes are wire-identical to their
        at-EOF twins yet differ in the result. Needs either a fixture field
        (`result: incomplete`) or an AST/driver-layer test (the result API
        itself is `core/TODO-PARSER.md`'s error-reporting item). *(drained
        from the EOF fixture flags, 2026-07-19)*
      - **CI drift-check** — the in-repo test covers CORE-VERSION /
        CORE_COMPLIANCE / ACTIVE_GROUP; the CI-level assertion that the
        `CORE.md` header and `CHANGELOG.md` top entry match
        `spec/CORE-VERSION` is still open.
      - **v0.9 group densification** continues before any `core-v0.9.0` tag
        (EOF/`Unclosed*` behaviors, `legacy-pre-0.8/` mining — esp.
        indentation edge cases, prose-dedentation depth, element-name
        charset torture — and edge/combination coverage); operational
        detail in `core/fixtures/README.md`.
- [ ] **Spec organization & the artifact ecosystem — contract vs. pedagogy**
      (Joseph, 2026-07-18; moved from `spec/TODO-SPEC-CORE.md` — it spans
      spec ↔ grammar ↔ fixtures ↔ learning artifacts, not just CORE.md edits).
      The tension: CORE.md is trying to be both a concise, easy-to-modify
      *contract* and a *tutorial* (worked hierarchy walkthroughs, beginner
      cautions, dedentation examples all sit inside normative text) — part of
      what makes it feel like a stack. One document probably can't fully
      optimize both. Threads:
      - **(2) DRY migration.** Give each construct its canonical names *at its
        own section* — the grammar / event / warning / AST spellings it appears
        under (e.g. `identity-key` / `IdentityKey` / `UnclosedIdentityKey`) — so
        naming lives once, with the construct, and central registries shrink to
        the rule + a derived index. Concrete EOF checklist to place:
        string→`UnclosedStringValue`; `[…]`→`UnclosedArray` (+`ArrayEnd`);
        `|{…}`→`UnclosedEmbedded` (+`EmbeddedEnd`);
        `;{…}`→`UnclosedInlineComment` (+`CommentEnd`);
        `!{{…}}`→`UnclosedInterpolation`; `<…>`→`UnclosedTypeEnvelope`
        (single-line); freeform→`UnterminatedFreeform`; identity
        `[`→`UnclosedIdentityKey` (element's `End` flushes). Pairs with
        descent's name-derivation + parser-manifest items
        (`tools/descent/TODO-DESCENT.md`).
      - **(3) Structural pass → a separable spine.** The cross-cutting pile at
        the top of CORE (Warning codes / Anomaly posture / End of input)
        duplicates per-construct behavior. Aim not merely to reorganize but to
        **separate the normative spine from the pedagogical layer** (rule vs.
        example / why / caution, marked structurally) so a reader — or a tool —
        can lift just the spine. That keeps CORE teaching now, makes any later
        split mechanical, and is the empirical test of "adhoc stack?" (a doc
        whose spine won't lift out cleanly is one). **Start with a grounded
        structural assessment of the live CORE.md** (decide against facts, not
        memory).
      - **The density gradient** (Joseph): [cheat-sheets] < [learning-examples]
        < [learning-version] < [fixtures] < [spec] < [grammar], by
        density/readability. Two refinements: (a) a gradient of
        *hand-maintained* artifacts is the scatter problem ×N — it pays off only
        if they are **derived** from one source (many projections), i.e. the
        Literate-fusion item below; (b) density-order ≠ authority-order (UDON
        makes grammar densest but *spec* authoritative, on purpose), so
        generation **radiates from the authoritative source outward** — machine
        side (grammar/fixtures) and human side (learning/cheat-sheets) both —
        not linearly from the dense end.
      - **Pedagogy is audience-relative** (Joseph): the dense end teaches too —
        fixtures and grammar are genuinely *pedagogical for agents* where a
        human would find them dense. "Teaching" and "low-density" are different
        axes; a projection can be dense AND pedagogical for the right reader.
      - **Direction to weigh — literate weave** (Joseph, "not sure it'd work"):
        instead of separate CORE.md + `core/generator/*.descent.udon`, break the
        grammar up and **weave it into the (better-organized) spec** — a
        literate-programming shape where the density lives in the official spec
        and a rule and its grammar edit sit right next to each other. A specific
        flavor of Literate-fusion; worth prototyping against it.
      Converges with **[later] Literate fusion** (next item) — that is the
      "one source → spec/grammar/fixtures" *machinery*; this is the
      *organization + which-artifacts* question. **Sequencing (my bet):**
      separability-within-one-doc first (cheap, reversible, keeps it teaching),
      let the real seams show under load, then split *with* derivation — not six
      hand-maintained artifacts before we know where they cleave.
      *(discuss w/ Joseph)*
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
