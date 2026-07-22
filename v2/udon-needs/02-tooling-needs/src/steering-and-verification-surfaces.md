---
slug: steering-and-verification-surfaces
type: demand
evidence: [T2, T5, T1, T3]
status: convergent demand; thinnest-covered part of the gathering (named skew — fund against it)
stage: drafted
consumers: both
depends: [counter-register, tool-definition-anatomy]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C12, C15, Part D.2
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # finding 6
  - ../../01-ideation/02-provenanced/copies/II7-ref-arch/sapientia-multi-agent-coordination.md  # read (head)
  - ../../01-ideation/02-provenanced/copies/harness-workshop/ai-cli-tools-source-assessment.md  # §6
---

# What the human on the other side needs

**Claim.** The human steering and verifying agent work is a first-class
tool consumer (the BRIEF's explicit widening), and the evidence — thin as
this slice of the gathering is — converges on three needs: **structured
decision surfaces** (not free-text interrogation), **explicit trust
boundaries** (currently a live disagreement), and above all
**verification surfaces matched to the fail-plausible reality**, because
the one failure class nothing mechanical catches is the one only a human
using the product notices.

## The evidence

- **Verification is the load-bearing need (T5):** the production runtime
  study — ~70% of silent failures were caught by *a human observing the
  product as a user*, and ~none by 4,286 tests ex-ante ("audits are
  regression engines, not prediction engines"); the distinctive
  fail-plausible mode turns internal errors into confident, coherent
  false output (an HTTP error log synthesized into a fabricated
  analysis). Medium confidence (single system), echoed contemporaneously
  — and it inverts the usual priority: the human surface is not the
  fallback after automation, it is the *only* catch for the failure
  class automation creates.
- **Observability as architecture (T1, Sept 2025):** the sapientia
  coordination design made human steering a filesystem property —
  observable markdown work streams, a shared todo.md attention anchor,
  "Joseph can `tail -f` these files to watch agents think in real-time"
  and intervene *by editing their documents*. The named failure it
  solved is still current: the mediated pattern ("main instance becomes
  mediator/translator… telephone game") that hides subagent work from
  the human. Steering-by-shared-artifact beats steering-by-relay.
- **Structured decision surfaces (T2):** the converged ask-user shape
  (1–4 questions, 2–4 options, "(Recommended)", always an Other escape) —
  lineage-corrected as one influential design adopted everywhere, i.e.
  survivorship: structured choice presentation beat free-text asking
  wherever it landed. Its complement is dry-run/propose-before-apply
  (#progressive-disclosure-read-path's `propose` returning diff +
  validation + side-effects + confidence) — the human-reviewable preview
  as a first-class product.
- **Trust boundaries are unsettled (T2, live disagreement):** AGENTS.md
  as authoritative instruction (the ecosystem consensus) vs untrusted
  reference data with injection-precedence rules (kimi-code's dissent,
  #counter-register row 6). Security-relevant and unresolved; a harness
  must *choose* and say so.
- **The bootstrapping datum (census §6):** the tools are increasingly
  built *by* agents (bot fleets filing/reviewing/merging PRs; agent-
  written spec folders preceding implementation) — so the human-
  verification surface is becoming review-of-agent-work all the way
  down, which raises the stakes on diff legibility, provenance, and
  the fail-plausible catch rather than lowering them.

## What it generates

- **For the harness:** fund the human surface as the fail-plausible
  control: propose/dry-run previews everywhere mutation exists;
  work-in-observable-artifacts over relay reporting; explicit
  instruction-trust policy; and agent-work diffs designed for human
  reading (structural diffs, provenance). The BRIEF's human-side demand
  list (authoring ergonomics, review bottlenecks, trust-and-verification)
  is the extraction target the gathering under-sampled — treat absence
  as missing data, not low demand.
- **For UDON:** the human is the second reader of every agent-facing
  design in this report: skeletons, structural diffs, and provenance
  annotations are dual-consumer surfaces by construction ("crystal clear
  even without syntax highlighting" is the human-side clause of the
  original thesis). Steering-by-editing-shared-documents — the tail -f
  pattern — is a *document-format* use case: the human edits the same
  artifact the agent reads, which is the whole two-audience bet.

## Honest edges

This is the report's thinnest evidentiary base and the OUTLINE says so:
Part VII rests on one external case study (medium confidence), one
Sept-2025 design, survivorship-grade T2 shapes, and a census aside. The
gathering's own residual ledger expects late-arriving core pieces here.
What's *absent* outright: any human-subject evidence (review-time
measurements, steering-error rates) — everything is builder-side
reasoning about the human, not observation of one.
