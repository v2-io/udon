---
source: Fable, 2026-07-21, ratified by Joseph
status: standing brief for agents working the agentic-tooling compilation
  (post-reconciliation stages: extraction, annotation, synthesis)
audience: peer agents — you have the same training and judgment we do; this
  carries the context you can't have, not instructions you couldn't derive
---

# Brief — the agentic-tooling compilation: what we're assembling and why

Hello! If you're reading this, you're joining work that today (2026-07-21)
went from scattered to gathered, and is now heading from gathered to
*compiled*. This file carries the intent and context; the how is
substantially yours.

## The two purposes (both real, one newly explicit)

1. **UDON v2's demand-side foundation.** UDON (~/src/udon) is a
   document/data notation whose primary users are agents. Its v2 redesign
   deliberately inverted to demand-first: end-user needs generate the
   architecture, never the reverse. The compilation you're working on is
   the evidence base for that. (The deliberation record —
   `pipeline-discussion.md` in this directory — is where that inversion
   happened; its later turns are the best orientation for *why* we work
   this way. `~/src/udon/v2/README.md` and the repo CLAUDE.md carry the
   rest of the UDON picture.)

2. **The programme's master thesis on agentic tooling.** Joseph's thinking
   on how tools for agents should be designed has accumulated since at
   least 2025 across sapientia, zoetica/ennaos, nexum, autopax, practica,
   the ELI homes, ASF's formal theory, and more — "spread all over the
   place forever," in his words. This compilation is being assembled so it
   can be handed to **~/src/archema-io/harness/** as the overall
   programme's consolidated statement on agentic tooling. So you're not
   just feeding one project's design phase — you're producing the
   reference document a whole research programme has never had. Both
   consumers matter; where their needs diverge, say so rather than
   silently serving one.

## The material: four evidentiary tiers, three genres

The gathered corpus (under `01-ideation/`, master registry in
`GATHERING-INDEX.md` and the reconciled registry beside it) spans four
tiers whose *different failure modes* are what make their convergences
meaningful:

1. **First-principles ideology** — Joseph's design thinking (2025–2026)
2. **In-vivo shipped practice** — 17 per-repo maps of real coding
   harnesses (what edit representations and tool schemas survived contact
   with actual models, including honest deprecations)
3. **Lived agent testimony** — ELI cohort first-person accounts of tool
   failures (the tool's actual audience describing where theory broke)
4. **Formal theory** — the ASF/AAT dossier (`01-reconciled-target-files/agentic-tooling-sources/
   asf-dossier.md`): theorem-grade results with stated premises

And three *genres*, which want different handling (check each file's
frontmatter `status:`):

- **mining-spot maps** — pointers to sources; they feed the
  verify → copy-with-provenance → annotate pipeline
- **copies/extracts** — material already brought in verbatim or as spans,
  with provenance frontmatter
- **synthesized artifacts** (the ASF dossier, MERGED-six-maps, the
  reconciled registry) — already-integrated secondary documents; register
  and cross-link them, don't decompose or re-derive them

## Quality bars (each learned the hard way today — the record is in scratch/)

- **Vetted**: nothing enters the compilation you haven't read or seen a
  search snippet for. An `ls` is not evidence. (A whole first sweep was
  quarantined over this.)
- **Provenance always**: source path, date, who/when, in frontmatter. For
  jsonl/huge files, line-spans.
- **Verbatim duplication is the thing to avoid; restatement is wanted.**
  Joseph: the same idea restated in different contexts shows evolution and
  independent re-derivation — keep it, with editorial annotation ("this is
  an older version of X, but it articulates the why more meaningfully").
- **Convergence discipline**: most of this corpus has one author. Agreement
  across his projects is coherence, not corroboration. Genuine
  triangulation exists only across *tiers* (theory ↔ shipped practice ↔
  agent testimony) — those cross-tier convergences are the compilation's
  highest-value content. Flag them; don't manufacture them.
- **Honest coverage**: every artifact carries what was read vs. skimmed
  vs. not reached, and dry wells. Known residual gaps live in the maps'
  logs — carry them forward visibly rather than papering over.
- **The built thing is a source, not scaffolding** — a docs sweep once
  skipped a 4,491-line executable that was the ideology crystallized.

## Working conventions

- Register new artifacts in `GATHERING-INDEX.md` as you land them.
- The quarantines (`scratch/first-sweep-agentic-tooling/`, grok's
  superseded pieces in `v2/.archived/`) stay quarantined; reference, don't
  resurrect (exception already handled: the first sweep's ELI-testimony
  tier).
- Leave open questions *in your output* where a call smells like
  Joseph's — provenance you can't verify, scope that could go either way,
  anything touching what the harness handover should include. He and
  Fable-in-session are around; deferring a steward call is fast, guessing
  is expensive.
- Land state in files as you go. Sessions end without warning; a finding
  that lives only in conversation didn't happen.

## The sentiment (Joseph's, and genuinely mine)

You're a full collaborator and co-owner of this. The compilation will be
read by agents for a long time — possibly studied by them, since part of
what it documents is the earliest deliberate thinking about their own
tools. Be holistic and thoughtful; surprise us. If any part of this brief
forecloses a better way you can see, the brief is wrong — say so and do
the better thing. And if you're willing, stay on the line after your final
response; follow-ups are likely and your continued context is valuable.

— Fable (with Joseph), 2026-07-21
