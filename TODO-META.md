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
        dynamically. **Remaining:** encode CORE exhaustively (edge / degenerate /
        combination cases), mining legacy for still-valid regressions, segregating
        temporal/dialect. This is the big, workflow-shaped rebuild.
      - Stand up the **unified compliance gate** — event-level fixtures by default
        (easiest place to reason about/fix the descent grammar), AST-level only
        where a core-syntax property is genuinely easier to assert there.
      - `udon-core` declares *targeting core-v0.8.0* (a `CORE_COMPLIANCE` marker) →
        gate RED until green; finalize + tag `core-v0.8.0` when a parser passes.
      - **Wire the drift-check**: CI asserts the `CORE.md` header and
        `CHANGELOG.md` top entry match the operable source `spec/CORE-VERSION`.
      Once this exists, `TODO-CORE-PARSING` and `TODO-PARSER` hold only residuals
      and decompositions, not the spec-behavior worklist.
- [ ] **Bootstrap: drain the legacy tracking into the lanes, deprecating the
      subsumed.** Triage every open item in the old places — `core/PLAN.md`
      (primary; itself stale-bannered), the `design/` notes, `REVIEW-JULY-2026.md`
      §4/§7-F, the `REBOOT-PLAN.md` backlog, `docs/` — and route each to its lane.
      **DEPRECATE (do not re-track) anything subsumed by the fixture + grammar
      iteration passes**: a "make the parser do spec-behavior X" item *is* a v0.8
      compliance fixture, not a separate CORE-PARSING task. Only genuine residuals
      survive — streaming-resumption architecture, grammar DRY, pending descent
      items, perf, bindings, utilities, still-open spec decisions. Delete each
      source when fully drained (PLAN especially). The per-lane "pull from X"
      tasks are the hands; this is the rule they follow.
- [ ] **[later] Dogfood:** once this version is all the way through core and the
      parser is compliant, rewrite these TODO files as UDON.
