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

**Claim.** UDON's public thesis that its documents "self-chunk" for
retrieval — element boundaries as *intentional* chunk boundaries,
encoded by the author, no sliding windows or sentence heuristics — is
**plausible, supported by adjacent evidence, and unmeasured for UDON
itself**. The honest status is claim-or-kill, and the experiment is
cheap.

## The adjacent evidence

- **The pre-test, one substrate over.** A 2025 retrieval experiment on
  *code* found parsing-based chunking beat naive splitting — "80% of
  the value for 20% of the effort" — and its companion concept work
  specifies what a *rich* chunk wants beyond its raw text: surrounding
  context, inferred types, extracted documentation, who-calls-whom
  (its projected further gain from that enrichment is an estimate, and
  is marked as one). The mapping onto UDON's public pitch is direct —
  elements as discrete semantic units, attributes as property
  assertions — and the enrichment list maps onto things an assembled
  UDON document already knows: the path down to a chunk, references in
  and out, declared types.
- **A shipped miniature.** The markdown-compiling system from the
  [[machine-first-documents| machine-first chapter]] is
  structure-as-chunking working in production for one narrow document
  class: section headers *are* the boundaries, metadata *is* typed.
- **The design work's own honesty about it:** "Nobody has measured it…
  If true, recognition/assembly products should preserve enough
  structure for chunk emission without re-indent archaeology. If
  false, kill the claim cleanly."

## The experiment (specified so anyone can run it)

Corpora that already exist: UDON's worked examples, the process maps
already written in it, this project's own tracking documents.
Conditions: (a) element-boundary chunks, enriched with their path and
attributes; (b) heuristic paragraph/size chunks; (c) fixed-token
windows. Measure retrieval quality on question sets drawn from real
agent tasks (a December 2025 usability study left ready-made task
briefs). Report whichever way it comes out — a negative result kills a
public claim cheaply now instead of expensively after tooling is built
on it.

## What it generates

- **For UDON — the one core-side requirement, either way:** element
  extents must stay recoverable from the assembled document. That is
  the *only* thing the language owes this thesis; everything else is
  harness and evaluation work. Do not let an unmeasured claim pull
  chunking machinery into the language itself.
- **For the harness:** if the experiment confirms, structured chunk
  emission becomes a memory-pipeline primitive — the
  [[persistence-is-imported| persistence chapter]]'s externalization
  with retrieval built in. If it disconfirms, the enrichment findings
  still stand: *metadata-carrying* chunks beat bare text regardless of
  where the boundaries fall.

## What this opens (ideas, not designs)

One idea makes the experiment worth running regardless of the headline
number: if chunks are element-bounded, then **a retrieval hit is an
address** — the chunk's identity is a path into the live document, not
an offset into a dead snapshot. Retrieval that returns addresses closes
a loop nothing currently closes: find it, then *act on it* — query
straight into guarded edit — with the found material still attached to
its living context instead of orphaned in an index.

## Honest edges

This chapter exists mostly to prevent one specific failure: the public
claim (aspirational) being cited downstream as though the adjacent
evidence (different substrate, partly estimated) had verified it. It
hasn't. The [[counter-register| counter-register]]'s row on this (row
8) is this chapter's summary and travels with any citation of the
thesis.
