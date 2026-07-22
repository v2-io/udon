---
source: udon repo design/examples/ — genre-seed witness lines (Part I §4)
gathered: 2026-07-21
status: gathered (witness commentary — 1–2 evidence lines per artifact/cluster)
paths:
  - design/examples/minimal.udon
  - design/examples/cheatsheet.udon
  - design/examples/comprehensive.udon
  - design/examples/docbook-fo-table.udon
  - design/examples/docbook-graphics.udon
  - design/examples/mathml-to-latex.udon
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [genre-seed, witness, pedagogy, transform-roundtrip, escape-hatch]
why_included: >
  Witness lines for the §4 genre seeds whose CONTENT is either ruled-elsewhere
  syntax law (the pedagogy trio) or mechanically-converted external material
  (the transform trio) — so their existence and shape is the demand signal, not
  their text. Plus one cross-cutting finding that spans the whole section's
  copies.
---

# Genre seeds (`design/examples/`) — witness lines

Companion to the seven verbatim copies in
`../copies/I4-genre-seeds/` (schema-dsl, ash-like ×3, operata ×2,
practices-gotchas). This file carries the rows whose signal is *that they
exist*, not their contents, plus one finding that the copies collectively
witness.

## Cross-cutting finding — the escape-hatch is the section's loudest demand

Across all five resource/agent-domain seeds (ash-like billing/inventory/support,
archema-operata, operata-intent-graph) the same shape recurs: a **declarative
UDON structure with an inline fenced escape into a real host language**
(`!:ex:` Elixir, `!:rb:` Ruby) placed *exactly* where the declarative layer
runs out — due-date arithmetic, renewal rules, path-scoring heuristics, query
helpers, argument plumbing. The demand this witnesses, stated for both
consumers: **notations meant for agents to author need a clean seam between
declarative config and imperative logic in one document**, so the agent (or
human) never leaves the artifact to express the 10% that isn't declarative.
This concretizes the README's "host for domain-specific languages" claim, and
it is a harness concern independent of UDON: any tool-definition / policy /
workflow format an agent authors will hit the same declarative-until-it-isn't
boundary. Flagging it here because no single copy owns it — it is the
convergence *across* the copies (all one author, so coherence not
corroboration — but a strong, repeatedly re-derived design stance).

Note the agent-native content inside those seeds: `archema-operata.udon` models
`owner-type: one-of [eli human system]`, `claim`/`release` actions for
multi-agent contention, and a `realization` resource carrying
`delta`/`learnings`/`propagate` (work-outcome capture + upward learning
propagation). That is agent coordination + memory substrate expressed as a
document — first-class harness-programme material, not just a UDON syntax demo.

## Pedagogy ladder — `minimal.udon`, `cheatsheet.udon`, `comprehensive.udon`

Three onboarding stimuli built at deliberately different altitudes: a
~54-line single-screen `cheatsheet`, a ~121-line annotated `minimal` reference,
and a ~492-line `comprehensive` "exercises the full specification" exerciser.
Their *content* is syntax demonstration (ruled elsewhere — not extracted); their
*existence as a three-tier set* is the witness: **teaching-surface-at-multiple-
altitudes was a day-one deliverable, not an afterthought.** For agents
specifically this is the same need `ux/TODO-AGENT-UX.md` tracks as
"cheat-sheets" — a harness wants the right-altitude reference for the agent's
current task, and someone already found three altitudes worth maintaining.
(Copies deliberately skipped: copying pure syntax-law here would be the
`udon.vim` mistake — noise as a copy, signal as this line.)

## Transform / round-trip genre — `docbook-fo-table.udon`, `docbook-graphics.udon`, `mathml-to-latex.udon`

Three real XSLT stylesheets (DocBook FO-table, DocBook graphics, MathML→LaTeX)
mechanically converted into UDON — large (725 / 757 / 2,035 lines; the MathML
one is 112 KB). Content is converted third-party XSLT (not authored demand, not
extracted). The witness is the genre's existence: **UDON as a conversion target
for existing XML/XSLT toolchains, exercised on adversarially deep, real-world
nesting.** The inline rightward form (`|template ... |{call-template ...}`)
absorbs deeply-nested markup compactly — these files are the concrete evidence
behind the README's "XML → UDON: 38–76% of original / deep nesting saves most"
size claim. For the harness/interop consumer the demand is round-trip fidelity
with existing markup pipelines; for UDON it is a stress corpus proving the
notation survives contact with hostile real XML. Worth an excerpt later only if
phase-2 needs the density evidence in hand; the whole-file copy is not
warranted (mechanical, external-origin, huge).
