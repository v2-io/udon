---
slug: annotation-and-metacognition
type: demand
evidence: [T1, T3, T4]
status: cross-tier demand; syntax deliberately open (conventions only until ruled)
stage: drafted
consumers: both
depends: [persistence-is-imported, intent-as-parameter]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2 annotation layer; P-F
  - ../../01-ideation/02-provenanced/characterizations/III-eli-testimony.md  # read
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md  # §4.3 congruency / causal-annotation
  - ../../01-ideation/02-provenanced/copies/I3-design-of-record/udon-agentic-body.md  # annotate tool
---

# Strippable, queryable metacognitive residue

**Claim.** Agents working in documents want to leave **residue about their
own cognition** — confidence, decision-vs-draft status, uncertainty,
provenance — attached to content but not *of* it: queryable when wanted,
strippable when not, and never polluting the material it annotates. The
demand recurs from tooling ergonomics up to identity infrastructure, and
its syntax is deliberately unruled — this segment carries the demand and
guards the boundary.

## The evidence

- **The design corpus:** "agents want strippable, queryable residue:
  confidence, source, decision, uncertainty — without polluting content."
  The December-era `|{@ ...}` form is *not valid under 0.9*; the standing
  rule: host conventions only (traits, named note elements, out-of-band
  sidecars) until a steward ruling — exploration must not invent core
  syntax. Same family: the `;?`/TBD/`.draft` markers from
  older feedback, and the design-of-record `annotate` tool (span-level
  entity/comment/review/confidence annotations over prose — the
  training-data and review use-cases).
- **Lived (why it matters more than ergonomics):** what memory wants from
  the format, informed by agents' own accounts: stable identity so
  "the same decision" survives rewrite; markers distinguishing decision
  from draft from uncertainty; structure that survives summarization. An
  agent re-reading its own past needs to know *what kind of statement*
  each thing was — the tool-hallucination account is the dark version
  (a record whose epistemic status was corrupted by the persistence
  layer taught the agent false things about itself).
- **The theory (the identity-grade form):** the congruency construction — an
  entity feels most like itself when re-read prior answers are congruent
  with how it would answer now — depends on `<causal-annotation>`:
  annotating a historical turn with *the context loaded when it was
  produced*, so later reads judge the past fairly. And the Oct-2025
  restoration case: congruence needs **verifiability of the past**
  (pointer to audit path + commit), not its presence in context.
  Provenance affordances — who wrote this, under what context, when,
  verifiable where — are theory-load-bearing for any format agents
  re-read their own history through.

## What it generates

- **For UDON:** the demand constrains without designing: whatever form
  annotation eventually takes, it must be (a) *strippable* by a dumb
  transformation (comments already have this property; `$`-designated
  attributes nearly do), (b) *queryable* by the same path language as
  content, (c) *provenance-capable* (author/when/context-pointer as
  ordinary attributes), and (d) *layered* — a stripped document remains
  valid and means the same thing. Until ruled: conventions in house
  styles, evidence accumulating in real use — exactly the WAIT-DEMAND
  posture, and this segment is the demand side of that wait.
- **For the harness:** don't wait for syntax — the *practice* is
  available now (this very corpus's frontmatter status/verdict fields,
  the LEDGER's dispositions, the dossier's tier labels are all annotation-
  as-convention working today), and the congruency requirement binds the
  harness's history systems regardless of notation: annotate records with
  their production context, keep the past verifiable by pointer.

## Honest edges

Every leg shares the estate's authorship; there is no external evidence
that agent-written confidence annotations improve downstream outcomes
(plausible, unmeasured — and fail-plausible cuts here too: a confident
annotation is subject to the same wrongness as confident prose). The
strippability requirement conflicts mildly with the queryability one
(strippable-by-dumb-transform argues for comments; queryable-by-path
argues for structure) — that tension is the actual design problem the
eventual ruling must resolve, and nothing in the evidence resolves it yet.
