---
slug: self-chunking-status
type: finding
evidence: [T1, T2-adjacent]
status: unmeasured-claim (UDON-specific) + adjacent positive pre-test; claim-or-kill experiment specified
stage: drafted
consumers: udon-primary
depends: [machine-first-documents]
sources:
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 10
  - ../../01-ideation/02-provenanced/copies/II7-ref-arch/sar3-lsp_chunking_concept.md  # read
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §3, P-H
---

# Self-chunking: pre-tested nearby, unmeasured at home

**Claim.** UDON's public thesis that documents "self-segment for
retrieval" — element boundaries as intentional chunk boundaries, no
sliding windows — is **plausible, supported by adjacent evidence, and
unmeasured for UDON itself**. The honest status is claim-or-kill, and the
experiment is cheap.

## The adjacent evidence

- **sar3 (the pre-test, one substrate over):** parsing-based chunking of
  code beat naive splitting — "80% of the value for 20% of the effort" —
  and the enrichment concept doc specifies what a *rich* chunk wants
  beyond its raw text: cross-file context, inferred types, extracted
  docs, caller/callee usage (its claimed 20–40% retrieval-accuracy gain is
  an estimate, with the measured companion in the sar3 set). The mapping
  to UDON's README table is direct: elements = discrete semantic units,
  attributes = property assertions — and the enrichment list maps to
  breadcrumbs, refs-in/out, and schema type info, all recoverable from
  the assembly product plus paths.
- **The shipped miniature:** the sapientia document parser's whole design
  — `##` headers ARE the segment boundaries, frontmatter IS the typed
  metadata (#machine-first-documents) — is structure-as-chunking working
  in production for one narrow document class.
- **The design corpus's own honesty:** "Nobody has measured it… If true,
  recognition/assembly products should preserve enough structure for
  chunk emission without re-indent archaeology. If false, kill the claim
  cleanly."

## The experiment (specified so anyone can run it)

Corpora that already exist: `design/examples/`, the ASF process maps,
this repo's own tracking documents. Conditions: (a) element-boundary
chunks (with breadcrumb + attribute enrichment), (b) heuristic
paragraph/size chunks, (c) fixed-token windows. Measure retrieval quality
on question sets drawn from real agent tasks (the December usability-test
task briefs are a ready seed). Report *whichever way it comes out* — a
negative result kills a README claim cheaply now instead of expensively
after tooling is built on it.

## What it generates

- **For UDON (the one CORE-side requirement, either way):** element
  extents must stay recoverable from the assembly product — that is
  the *only* thing the core owes this thesis; everything else is harness/
  eval work. Do not let the unmeasured claim pull chunking machinery into
  the language.
- **For the harness:** if the experiment confirms, structured chunk
  emission becomes a memory-pipeline primitive (#persistence-is-imported's
  externalization with retrieval built in); if it disconfirms, the
  enrichment findings still stand — *metadata-carrying* chunks beat bare
  text regardless of where the boundaries fall.

## Honest edges

This segment exists mostly to prevent a specific failure: the README
claim (aspirational) being cited downstream as if the adjacent evidence
(different substrate, partly estimated) had verified it. It hasn't.
Counter-register row 8 is this segment's summary and travels with any
citation of the thesis.
