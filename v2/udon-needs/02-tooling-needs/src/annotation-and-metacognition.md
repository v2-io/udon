---
slug: annotation-and-metacognition
type: demand
evidence: [T1, T3, T4]          # genre only; see method-evidence-tiers "three axes"
register: evidenced             # the demand recurs across design work, lived testimony, theory; the syntax boundary is a decided-open question; ideation is proposed
strength: robust-qualitative    # a direction that recurs across independent evidence kinds, no magnitude claimed
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

- **For UDON — constraints, and a mechanism that already meets most of
  them:** whatever form annotation eventually takes, the demand says it
  must be (a) *strippable* by a dumb transformation, (b) *queryable* by
  the same path language as content, (c) *provenance-capable* — author,
  time, context-pointer as ordinary data — and (d) *layered*: a stripped
  document remains valid and means the same thing. Two of UDON's existing
  forms already carry pieces of this. Comments are strippable by a dumb
  lexer but are opaque to structural query. More interesting is the
  **designated-attribute** mechanism: UDON reserves a class of attribute
  names by a leading marker (the identity and classification attributes
  are written this way), and it exposes documents through two accessors —
  one that returns *every* attribute and one that returns only the
  *non-*designated ones. That split is, by construction, a
  strippable-**and**-queryable channel: a designated annotation is an
  ordinary attribute, so the same path language that reaches content
  reaches it (b); yet a consumer that reads the non-designated accessor
  never sees it, which is stripping by a dumb, structural rule (a) rather
  than by a text transform. So the two requirements the design must
  satisfy together are not actually in opposition — the shipped accessor
  model demonstrates their coexistence. What remains open is narrower
  (see Honest edges), plus the question of which marker annotations should
  use — the general designator question is on record as undecided. Until a
  decision is
  recorded in the [[DECISIONS.md|design ledger]], conventions carry the
  practice and real use accumulates the evidence — deliberately.
- **For the harness — don't wait for syntax.** The practice is available
  now, and this report itself runs on it: status fields in chapter
  metadata, provenance banners on the body reports, capability-card
  markers — all annotation-as-convention, working today. And the
  congruency requirement binds the harness's history systems regardless
  of notation: annotate records with their production context; keep the
  past verifiable by pointer.

The sharpest evidence for this chapter is the document you are reading.
Producing it, its agent-authors needed to mark every claim with three
kinds of metadata about the claim itself — where its evidence came from,
what kind of assertion it is (derived / evidenced / decided / proposed),
and how defeasible it is — and, having no native carrier, hand-maintained
all three by convention: in running prose ("measured, single repo"), in
typographic marks, and in per-chapter frontmatter fields. That is
register-metadata-on-content being carried by hand because the medium
cannot hold it structurally — precisely the strippable, queryable residue
this chapter specifies. A native attribute form (a block tagged, in
effect, "this is proposed, this is a hypothesis") would carry it queryably
and strip it cleanly for a clean export. This is not a hypothetical use
case; it is first-person end-user testimony from inside the report's own
production, recoverable from this repository's history — the authors kept
wanting exactly the affordance the chapter argues for, and faked it every
time.

## What this opens (ideas, not designs)

> [!capability] Annotations that expire
> **What:** confidence and uncertainty are dated judgments, so an
> annotation could carry a *review-by* horizon — "high confidence, as of
> this commit, re-examine after the schema work" — making staleness of
> *judgments* visible the way a freshness token makes staleness of
> *content* visible.
> **Principles that apply:** provenance and freshness are first-class
> properties, not metadata niceties; a durable record must let a later
> reader tell what has aged.
> **Hypothesized impact:** lowers observation ambiguity A on the question
> "does my past self's confidence still bind me?" — an expiry horizon turns
> a silent, high-A inheritance of stale certainty into an explicit, checkable
> signal, protecting the update-gain of a session that re-reads its own
> record after the world has drifted.
> **In tension with:** most judgments have no natural expiry date, so the
> horizon is often a guess; an expired annotation still has to be *acted
> on* by something, or it is just decoration.
> **Potential downsides:** expiry theater — horizons set by reflex, never
> revisited, giving false assurance that stale judgments were reviewed.

> [!capability] A starter vocabulary already proven in use
> **What:** producing this report required exactly four content registers —
> derived, evidenced, decided, proposed — marked by hand for lack of a
> native form. That is a real, used, four-value enumeration any annotation
> experiment could adopt on day one and measure against — not a proposed
> design, an existing lived need looking for a carrier.
> **Principles that apply:** convention earns its way to ratification by
> accumulated use, not by fiat; the demand for a feature is strongest when
> the author had to fake it.
> **Hypothesized impact:** that a rigor-seeking document had to *invent* a
> typographic convention to mark a claim's register is itself a demand
> datum — registers-on-content is exactly what a structure-and-prose format
> could carry natively, removing the ambiguity A that hand-marking leaves
> wherever the marks are inconsistent.
> **In tension with:** four values may be too few (where does a *measured*
> claim's strength go?) or too many for a first experiment; a fixed
> vocabulary risks ossifying before use teaches the right set.
> **Potential downsides:** a starter vocabulary adopted as if final freezes
> a guess; the point is to measure it, not enshrine it.

> [!capability] A congruency reader
> **What:** given annotations that record each statement's production
> context, a re-reading tool could show a past statement *with* the context
> that produced it and flag where the current self would now answer
> differently — drift between selves made specific instead of felt. The
> identity infrastructure's deepest requirement, rendered as a buildable
> utility.
> **Principles that apply:** an entity's continuity is carried through
> externalized, re-readable state, not through unbroken context; what
> congruence needs is *verifiability of the past* — a pointer to the audit
> trail and the exact version — not the past's bulk presence.
> **Hypothesized impact:** strengthens the reinjection channel that is the
> only cross-session persistence there is — a successor judging its own
> congruence with a forebear reads that forebear's context by pointer rather
> than re-loading it, keeping the comparison cheap (low description-length
> cost) and honest (the past is verified, not reconstructed from vibes).
> **In tension with:** it needs the causal-annotation substrate to exist
> first (this is downstream of the whole demand); production-context capture
> is itself a cost on every recorded turn.
> **Potential downsides:** a congruency reader that mis-attributes context
> manufactures a false sense of drift — or false comfort of stability —
> exactly where the stakes are identity.

> [!capability] Annotation profiles as views
> **What:** strippable-and-queryable generalizes to *renderable-per-consumer* —
> the reviewer's view shows confidence marks and open doubts, the export
> shows clean prose, the training pipeline sees entity spans. One document,
> several honest presentations; the strip operation grown into a view
> system.
> **Principles that apply:** a document is a multi-consumer artifact
> (the report's own two-consumer structure is the instance); the same
> source of truth should project without forking into divergent copies.
> **Hypothesized impact:** collapses the maintenance ambiguity of keeping
> parallel documents consistent — one source, checked projections — which
> for an agent estate means the review residue, the clean deliverable, and
> the training corpus never drift apart, and each consumer's channel carries
> exactly its signal and no more (lower A per consumer).
> **In tension with:** a view system needs the per-region sink model the
> [templates chapter](templates-and-dynamics-demand.md) also reaches for —
> shared machinery, shared open questions; projections can silently
> contradict on facts they share unless a consistency check binds them.
> **Potential downsides:** more projections, more surfaces to get wrong; a
> "clean export" view that strips a load-bearing caveat is a honest-looking
> lie.

## Honest edges

Every leg here shares the research programme's authorship; there is no
external evidence that agent-written confidence annotations improve
downstream outcomes (plausible, unmeasured — and the
counter-register's plausible-wrongness row cuts here too: a confident
annotation can be exactly as wrong as confident prose).

The design question that remains is sharper than "can strippability and
queryability coexist" — the designated-attribute accessor split above
answers *that* one yes. It is: what does *stripped* have to mean? Two
readings pull apart. **View-level exclusion** — the annotation stays in
the serialized text but the content-facing accessor omits it — satisfies
the "a stripped document means the same thing" bar cleanly, because the
material the reader consumes is unchanged; it is what the accessor model
gives for free. **Text-level erasure** — the annotation physically
absent from the bytes, the way a stripped comment is — is a stronger
property, needed when the annotation must not appear in an exported
artifact at all (a clean hand-off, a training corpus with the review
residue removed). A designated attribute is view-strippable by
construction but not text-strippable without a serializer pass; a comment
is text-strippable but not queryable. Whether one form can be both, or
whether annotation wants *two* forms for two strip-meanings, is the real
open problem — narrower and more tractable than a strippable-vs-queryable
impasse, and the eventual decision should be made against these two
concrete strip-semantics rather than the coarse tension.
