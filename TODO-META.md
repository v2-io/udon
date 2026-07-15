# TODO-META — the tracking system itself

Cross-cutting meta work: the compliance-versioning keystone, the tracking
structure, and dogfood milestones. Not a valve — items that need Joseph carry
`*(discuss w/ Joseph)*` inline.

## Open

- [ ] **[P0] Semantic spec-versioning + per-version compliance-fixture groups —
      principled.** Put semver on `spec/CORE.md`; give every spec version its own
      compliance-fixture group; stand up the **unified compliance gate** that
      proves the parser against a *tagged* CORE version — **event-level fixtures
      by default** (easiest place to reason about and fix the descent grammar),
      AST-level only where a core-syntax property is genuinely easier to assert
      there. This is the foundation: once it exists, `TODO-CORE-PARSING` and
      `TODO-PARSER` hold only residuals and decompositions, not the spec-behavior
      worklist. Seed from `core/PLAN.md`'s "Test-first worklist".
- [ ] **[later] Dogfood:** once this version is all the way through core and the
      parser is compliant, rewrite these TODO files as UDON.
