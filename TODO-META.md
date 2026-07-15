# TODO-META — the tracking system itself

Cross-cutting meta work: the compliance-versioning keystone, the tracking
structure, and dogfood milestones. Not a valve — items that need Joseph carry
`*(discuss w/ Joseph)*` inline.

## Open

- [ ] **[P0] Semantic spec-versioning + per-version compliance-fixture groups —
      principled.** *Versioning spine established 2026-07-14:* `spec/CHANGELOG.md`
      (Keep-a-Changelog + SemVer); `CORE.md` is now **0.8.0-rc.1**; the model is
      CommonMark's — the spec is the versioned contract and impls declare which
      version they pass. **Remaining:**
      - Build the **0.8.0 compliance-fixture group** — retire the old fixtures,
        encode the new spec exhaustively, segregate temporal/dialect cases (seed
        from `core/PLAN.md` "Test-first worklist").
      - Stand up the **unified compliance gate** — event-level fixtures by default
        (easiest place to reason about/fix the descent grammar), AST-level only
        where a core-syntax property is genuinely easier to assert there.
      - `udon-core` declares *targeting core-v0.8.0* (a `CORE_COMPLIANCE` marker) →
        gate RED until green; finalize + tag `core-v0.8.0` when a parser passes.
      - **Wire the drift-check**: CI asserts the `CORE.md` header and
        `CHANGELOG.md` top entry match the operable source `spec/CORE-VERSION`.
      Once this exists, `TODO-CORE-PARSING` and `TODO-PARSER` hold only residuals
      and decompositions, not the spec-behavior worklist.
- [ ] **[later] Dogfood:** once this version is all the way through core and the
      parser is compliant, rewrite these TODO files as UDON.
