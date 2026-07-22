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

**Claim.** Agents working in documents want to leave **residue about
their own cognition** — confidence, decision-versus-draft status,
uncertainty, provenance — attached to content but not *of* it:
queryable when wanted, strippable when not, and never polluting the
material it annotates. The demand recurs from tool ergonomics all the
way up to identity infrastructure. Its syntax is deliberately
undecided; this chapter carries the demand and guards that boundary.

## The evidence

- **Asked for, repeatedly, in the design work:** "agents want
  strippable, queryable residue: confidence, source, decision,
  uncertainty — without polluting content." An early experimental
  syntax for it exists in old material and is *not valid under the
  current language* — and the standing discipline is exactly right:
  host-level conventions only (traits, named note elements, sidecar
  files) until a real decision is made; experiments must not invent
  core syntax. The same family includes draft/to-be-decided markers
  from older working practice, and a designed-but-unbuilt `annotate`
  tool from the owner's tooling catalog: span-level entity, comment,
  review, and confidence annotations over prose — the training-data
  and review use-cases stated as a tool contract.
- **Lived — and why it matters beyond ergonomics.** Agents' own
  accounts of memory converge on what the format must let them mark:
  stable identity, so "the same decision" survives a rewrite of the
  text around it; markers distinguishing a decision from a draft from
  a doubt; structure that survives summarization. A fresh session
  re-reading its predecessor's words needs to know *what kind of
  statement* each one was. The dark version is on record too: one
  agent's persistence layer stored hallucinated tool results
  indistinguishably from real ones, and the record taught the agent
  false things about its own past. Epistemic status that isn't carried
  *in the record* gets reconstructed wrong.
- **The identity-grade form, from the theory.** An entity feels most
  like itself when its re-read past answers are congruent with how it
  would answer now — and judging that fairly requires annotating a
  historical turn with *the context that was loaded when it was
  produced*. A documented restoration case adds the sharp corollary:
  what congruence actually needs is **verifiability of the past** — a
  pointer to the audit trail and the exact version — not the past's
  bulk presence in context. Provenance affordances (who wrote this,
  under what context, when, verifiable where) are load-bearing theory,
  not metadata niceties, for any format agents re-read their own
  history through.

## What it generates

- **For UDON — constraints without a design:** whatever form annotation
  eventually takes, the demand says it must be (a) *strippable* by a
  dumb transformation (comments already have this property;
  `$`-designated attributes nearly do), (b) *queryable* by the same
  path language as content, (c) *provenance-capable* — author, time,
  context-pointer as ordinary data — and (d) *layered*: a stripped
  document remains valid and means the same thing. Until a decision
  is recorded in the [[DECISIONS.md|design ledger]], conventions carry
  the practice and real use accumulates the evidence — deliberately.
- **For the harness — don't wait for syntax.** The practice is available
  now, and this report itself runs on it: status fields in chapter
  metadata, the ✦ register mark, provenance banners on the body
  reports — all annotation-as-convention, working today. And the
  congruency requirement binds the harness's history systems regardless
  of notation: annotate records with their production context; keep the
  past verifiable by pointer.

## What this opens (ideas, not designs)

- ✦ **Annotations that expire.** Confidence and uncertainty are dated
  judgments. An annotation could carry a *review-by* horizon — "high
  confidence, as of this commit, re-examine after the schema work" —
  making staleness of *judgments* visible the way freshness tokens make
  staleness of *content* visible.
- ✦ **The four registers as a starter vocabulary.** This report already
  needed exactly four content registers — derived, evidenced, decided,
  proposed — and had to mark them typographically. That lived need is
  a candidate seed vocabulary for native annotation: not a design, but
  a real, used, four-value enumeration that any annotation experiment
  could adopt on day one and measure against.
- ✦ **A congruency reader.** Given causal annotations, a re-reading tool
  could show each past statement *with* its production context and
  flag where the current self would answer differently — drift between
  selves made visible and specific, instead of felt and vague. The
  identity infrastructure's deepest requirement, as a buildable
  utility.
- ✦ **Annotation profiles as views.** Strippable-and-queryable implies
  *renderable-per-consumer*: the reviewer sees confidence marks and
  open doubts; the export sees clean prose; the training pipeline sees
  entity spans. One document, several honest presentations — the
  strip operation generalized into a view system.

## Honest edges

Every leg here shares the research programme's authorship; there is no
external evidence that agent-written confidence annotations improve
downstream outcomes (plausible, unmeasured — and the
counter-register's plausible-wrongness row cuts here too: a confident
annotation can be exactly as wrong as confident prose). And the
strippability requirement conflicts mildly with the queryability one —
strippable-by-dumb-transform argues for comment-like forms,
queryable-by-path argues for structure. That tension is the actual
design problem the eventual decision must resolve, and nothing in the
evidence resolves it yet.
