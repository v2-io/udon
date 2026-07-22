---
source: UDON repo — test/usability/ (the L-tier rows of Part I §1: contrast tracks, scoring libs, harness, embedding mining aids)
gathered: 2026-07-21
status: gathered — witness lines (existence/shape is the evidence; no copy warranted)
paths:
  - test/usability/run
  - test/usability/lib/test_definitions.rb
  - test/usability/lib/validated_tests.rb
  - test/usability/results/udon-validated-*.yaml
  - test/usability/results/udon-invention-*.yaml
  - test/usability/results/udon-learning_curve-*.yaml
  - test/usability/results/udon-interpretation-*.yaml
  - test/usability/analyze_embeddings.rb
  - test/usability/embed_sentences.rb
  - test/usability/analyze_chunks.rb
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [experiment-provenance, contrast-track, comprehension-not-use-catalog, mining-aid, harness-shape]
why_included: >
  Coverage completeness for §1's lower band — these rows are context and method,
  not demand-catalog. Recorded as witness lines so the tree's shape is legible
  and nobody re-discovers them as a miss. The one substantive signal here is the
  harness DESIGN itself ("hallway usability testing at scale… naive AI agents to
  measure syntax obviousness") — a reusable method for eliciting agent testimony,
  relevant to the harness consumer.
---

# Witness lines — test/usability/ lower band

## The harness as method (`test/usability/run`)
- The runner's own self-description is the finding: *"Hallway usability testing
  at scale for the UDON notation. Uses naive AI agents to measure syntax
  obviousness."* Its subcommand menu **names the experiment's whole theory of
  what to learn from agents about a notation**: `invention` (can agents invent
  UDON unprompted?), `interpret` (what do agents think UDON means?), `translate`
  (can they convert to it?), `learning-curve` (how much context is needed?),
  `stress` (where does it break?), `converge` (do independent agents converge?).
  This is a transferable agent-tooling evaluation pattern, not just UDON's.

## Contrast tracks — comprehension/onboarding, NOT a use-catalog
- `udon-invention-*` (6 files, `Invent notation: all constraints`) — agents
  designing their own mixed-content notation blind; their re-derivation of
  UDON's central tensions is the signal (mined in
  `../copies/I1-usability/agent-feedback-excerpts.md`), not a use-case list.
- `udon-learning_curve-*` (7 files) — one task ("Write a blog post with title,
  author, date, and two paragraphs") authored under a **progressively richer
  context ladder** (`test_definitions.rb` CONTEXT / CONTEXT_PROGRESSION: bare
  legend → cheatsheet → comprehensive) to measure minimum context for obviousness.
- `udon-interpretation-*` (1 file) — comprehension probe: given
  `|p This has |{em emphasis} and |{a :href /foo a link} inline`, what does the
  agent think it means. Reading-direction, mirror of the authoring tracks.
- Treat all three as **contrast/comprehension evidence**, explicitly not a
  demand catalog (per the target-file caution).

## Scoring libs (feature-expectation grading)
- `validated_tests.rb` + `udon-validated-*.yaml` (37 files) — same five authoring
  genres as realistic_tests (yaml_frontmatter / experiment_report / yaml_config /
  conversation_log / recipe) but with an `:expected` feature list scored 10 pts
  each. Method/plumbing; the genre briefs themselves are already copied in
  `../copies/I1-usability/authoring-task-defs.md`.
- `test_definitions.rb` — the learning-curve context ladder + stress/translate
  task defs; its CONTEXT legends are terse cheat-sheets of UDON's own mental
  model (`| = element, : = attribute, ; = comment, |{} = inline, [id] identity,
  .class stackable, indentation = hierarchy, plain text = prose`) — a compact
  witness of how the team taught the notation to a cold agent.

## Mining aids (embedding re-clustering) — CAUTION, artifacts absent
- `analyze_embeddings.rb`, `embed_sentences.rb`, `analyze_chunks.rb` build a
  SQLite store (`response_embeddings` / `sentence_embeddings` tables, created
  fresh with `DROP TABLE IF EXISTS`) to re-cluster the enablement responses.
- **Verified 2026-07-21:** no `*.db` / `*.sqlite` / `embeddings*` artifact exists
  under `test/usability/` on disk (repo HEAD `3d8e5b9c`). The scripts regenerate
  from scratch, so re-clustering the corpus is *possible* but not *pre-computed*
  — confirms the `MERGED §13.5` "embedding DB unconfirmed / possibly gone" gap.
  If a phase-2 pass wants embedding-based diversity clustering over the raw
  bodies, the tooling is here but must be re-run (needs the embedding API the
  scripts call).
