# Independent review — Codex

**Review baseline:** Git `bca74bfbb3684c5e72bf707f75c2c0bee21b6a3a`, plus the uncommitted working-tree version present on 2026-07-22. I did not read the other reviews before writing this report. This is a review of the consolidation as a normative suite, not a proposal to resolve its deliberately open questions.

## Findings

### High — Core semantic equivalence contradicts the ruling that float equality is host-defined

**Where.** `SEMANTICS.md` §2, item 3 says float spelling is not normalized beyond “recognized-Float equality,” illustrating `1.0 ≡ 1.00`; it then says bit-exact Float policy is a host profile. That still asserts a core equality relation for Floats, although neither MODEL nor CORE defines a Float representation or comparison.

**Primary-source basis.** The controlling live decision is `v2/DECISIONS.md` **S17**: “Float semantic equality is a **Host profile** (or omit from Core equivalence); not Core bit-law.” It permits no Float rule in core equivalence, or an explicitly named host profile. The present wording silently makes a possible host policy core law while leaving decimal value, IEEE value, NaN, signed zero, overflow, and lexical preservation undefined.

**Suggested disposition.** **Fix before calling SEMANTICS normative.** Remove Float comparison from core semantic equivalence, or require a named host Float-equality profile and say that cross-profile documents have no portable core-equivalence claim. If decimal mathematical equality is intended, obtain a new decision and add fixtures.

### Medium — DELTAS' complete-change promise does not account for the new normative equivalence contract

**Where.** `DELTAS.md` opening contract and its nine-row table; compare `SEMANTICS.md` §§1–3 and `README.md`'s statement that DELTAS contains “exactly” the behavior differences. The suite now gives serializers MUST/MUST NOT requirements, defines core semantic equivalence, permits specified ornamental-blank loss, and normalizes integer bases and `null`/`nil`. The prior 0.9 source specifies text reconstruction and selected desugarings, but no comparable whole-document equivalence/serializer contract.

**Primary-source basis.** `v2/DECISIONS.md` C3 expressly called for a SEMANTICS component, and S17/S9 record open choices affecting its boundary. `spec/msc/CHANGELOG.md` is the 0.9 contract DELTAS claims to compare. This makes SEMANTICS a sensible addition, but not an invisible one: `spec/CORE.md`'s text law is an event reconstruction rule, not a license to declare documents equivalent after a normalization pass.

**Suggested disposition.** **Clarify scope rather than retract SEMANTICS.** Add a DELTAS row such as “newly specified comparison and serializer profile; no source-recognition change,” with the charter cite; or narrow the headline to recognition/source-language behavior. The first option makes the new consumer contract explicit.

### Medium — Unicode identifier version is a cross-implementation lexical fork

**Where.** `CORE.md` §5.2 makes the Unicode version supplying `XID_*` properties a host decision; the same lexical rule controls marker recognition in §3 and attribute keys in §6.2. Yet §1 promises a recognizer maps source according to this specification.

**Primary-source basis.** A source character whose XID property changes across Unicode versions can be a name/key in one host and prose or a different boundary in another, changing the ADM. `defining-udon.md` Part 2 sets absolute ambiguity elimination and same-input conformance as the bar. The legacy `spec/CORE.md` uses the same UAX #31 vocabulary without a version, so this review does **not** recommend silently inventing a version in consolidation.

**Suggested disposition.** **Make the portability limitation explicit or seek a ruling.** Eventually pin a Unicode version and upgrade procedure. Until then require recognizers to report their Unicode data version and state that non-ASCII identifiers are non-portable across different declared versions. This exposes a host-profile boundary instead of leaving an accidental implementation fork.

### Low — The reader on-ramp is excellent, but the promised first screen is at the end of CORE

**Where.** `README.md` recommends CORE Appendix A first; `CORE.md` repeats that it is a “one-screen annotated surface map,” but Appendix A appears after roughly 1,200 lines of normative text.

**Primary-source basis.** This is a pedagogy issue, not a correctness failure. `defining-udon.md` Part 3 requires progressive disclosure. A newcomer following the stated path must first traverse the legal contract. The suite otherwise uses rationale, glossary, and carve-outs especially well.

**Suggested disposition.** **Polish when convenient.** Put a compact linked surface map near the README top, or move the clearly non-normative appendix before §1. Keep one canonical map, but make the stated first reading be the actual first screen.

## Overall assessment

This is a strong consolidation. Its most valuable move is transporting the *reason an issue remains open* in CARVEOUTS, which protects demand-first work from a familiar failure mode. The prose is clearer, terminology is more stable, and the line/flow/ownership explanations teach implementers rather than merely enumerate cases. The two contract-boundary findings matter precisely because consumers will now implement this suite literally; tightening them will make its “single place to learn what UDON is right now” claim trustworthy.
