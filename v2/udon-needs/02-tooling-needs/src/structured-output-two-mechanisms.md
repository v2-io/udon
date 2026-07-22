---
slug: structured-output-two-mechanisms
type: finding
evidence: [T2, T5]
status: cross-tier-convergent, with a load-bearing distinction the sources themselves flag
stage: drafted
consumers: harness-primary (udon: payload/schema design input)
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C9, Part D.3
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # findings 3, 4
---

# "Structured output" names two different guarantees

**Claim.** The ecosystem's converged machine-readable-answer contract (8/14
harnesses) conceals a real split the sources themselves flag: **constrained
decoding** (grammar/schema enforced at generation time — the output *cannot*
be malformed) versus **after-the-fact serialization** (internal message
objects rendered as JSON — well-formed transport around unconstrained
content). Both are marketed as "structured output"; they are different
guarantees, and design decisions that conflate them inherit the wrong one.

## The evidence

- **Shipped:** the ecosystem's catalog spans both mechanisms explicitly — true constrained
  decoding (Anthropic `strict`, codex `--output-schema`, grammar-constrained
  patch emission) vs formatter-class serialization (one harness's own
  honest engineering log makes the distinction itself). Not conflating
  them is this chapter's thesis.
- **The contrarian external result (medium confidence — it survived two
  of three adversarial checks):** structured
  function-calling modes produced substantially *more* incorrect calls than
  free-text prompting in the multiple-call category (BFCL, ICML 2025 —
  scoped: counts among decoded responses, one category). Structure changes
  the **error profile**; it does not remove error. Companion finding
  (high confidence): failures split ~68% omission / ~32% malformation in
  small models, attributed to insufficient schema grounding — while large
  models show ~0% in the same study; and models *fabricate missing required
  parameters* rather than ask.
- **The aider abandonment** (#edit-representation-landscape) is the same
  lesson from the edit side: pushing content through tool-call structure
  moved the failure, it didn't eliminate it.

## What it generates

- **For the harness:** state which guarantee each surface actually provides;
  use constrained decoding where malformation is costly and available;
  design for the *remaining* failure modes structure doesn't touch —
  omission, fabricated parameters (a clarification affordance is the
  evidence-backed answer), and wrong-but-well-formed content
  (fail-plausible, #counter-register).
- **For UDON:** two implications. (a) The κ×A case for sharp formats
  (#tools-are-observation-infrastructure) is about *observation* design and
  survives this chapter untouched — but any claim that structured **emission**
  improves reliability must be scoped by the BFCL result; the honest pitch
  is verifiability-of-output, not error-elimination. (b) Grammar-constrained
  generation of UDON (from the descent grammar) would be the strong-guarantee
  path — it makes emission correctness structural, which is exactly the tier
  of guarantee the weak mechanism lacks; worth an experiment before a claim.

## Honest edges

The BFCL figure is one category of one benchmark (2-1 verified, kept at
medium); the 68/32 split is small-model-only. Neither licenses "structure is
bad" — they license precision about *which* structure buys *what*.
