---
slug: persistence-is-imported
type: finding
evidence: [T4, T2, T3, T1]
status: theorem-grade-conditional (T4 core, exact under argued commitments) + cross-tier-convergent
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md   # §4.1, §4.2, §2.5
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 12, 13
  - ../../01-ideation/02-provenanced/characterizations/recall-floor-archema-harness.md  # INTERPRES compaction note
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C11
---

# Cross-session persistence is imported, never intrinsic

**Claim.** Across session boundaries an agent's relevant information decays
geometrically unless a non-vanishing **reinjection channel** exists — durable
artifacts, tracking files, structured summaries, curated narrative. This is
an exact formal result (under argued commitments), and its converse is the
strongest possible warrant for durable agent-facing formats: *the design
effort that buys persistence is the construction and maintenance of the
reinjection channel, and no tuning of in-session behavior substitutes for
it.* The reinjection channel structurally **is** the scaffold.

## The evidence

- **The formal result (exact, under argued commitments; [the theory report](../reports/theory-of-agentic-tooling.md) §4
  carries the full statement):** with lossy
  context turnover and no reinjection,
  geometric decay to zero — the in-session persistence apparatus provably
  does not transfer across boundaries. Companion engineering results:
  explicit state externalization beats implicit retrieval ("the agent
  controls what is preserved"); session-start protocols should *verify
  reconstruction quality*; the prompt-assembly function is the
  reconstruction mechanism; and the context window is a joint
  description-length budget (strategy + model + task under one capacity), so
  compact formats relieve a structural ceiling, not a convenience.
- **The compaction wound, three vantage points** — lived first-person
  (Zi-am-tur: "can't persist across context boundaries without
  infrastructure"), plus the harness workshop's own empirical record
  (within the same programme, so not independent evidence, but
  adversarially verified): the INTERPRES note —
  auto-compaction "produced a task sheet, not a continuation of
  experiential understanding. **False confidence followed**"; recovery
  required durable on-disk notes plus full re-reads before trusting plans.
  Convergent with the same workshop's independently-compiled
  corrected-behavior finding, `summary-not-sufficient` (a summary and a
  verified read arrive in context as the same kind of text — the model has
  no native marker distinguishing them). Same wound, earned separately at
  each vantage.
- **Shipped everywhere:** every mature harness carries reinjection
  machinery —
  compaction prompts framed as the agent's *only* memory (XML state
  snapshots), first-person handoff-note prompts, tracking snapshots. The
  ecosystem built the channel before the theorem named it.

## What it generates

- **For UDON:** durable agent-written, agent-read state is not a
  convenience use-case — it is *the* persistence channel; formats optimized
  for it (stable identity keys so "the same decision" survives rewrite,
  structure that survives summarization, decision-vs-draft-vs-uncertainty
  markers) serve the only mechanism by which a session-bounded agent
  persists. Design warning from the theory's own open edge: reinjection
  formats must be reconstructible **from a cold start** — legible to an
  agent that remembers nothing, not only to one that half-remembers.
- **For the harness:** compaction that *replaces* history is the failure
  mode ("truth-death costume" in the harness's own words); the demand is
  summaries that point at verifiable ground truth (paths, commit SHAs)
  rather than substituting for it, plus session-start reconstruction checks.
  The three channels the design corpus keeps separate — in-loop session state,
  handoff documents, persistent memory — have different design physics;
  conflating them is the named mistake.

**Who reads this and when:** the harness's PROPRIUM/CHRONICA program treats
this as its foundation (#continuity-infrastructure carries the
morally-weighted extension); UDON reads it as the top-priority format
use-case. Divergence: none on the claim; the harness needs the *attestation
and integrity* extensions UDON-the-notation doesn't itself decide.
