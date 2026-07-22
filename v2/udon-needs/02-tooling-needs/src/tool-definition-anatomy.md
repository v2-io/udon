---
slug: tool-definition-anatomy
type: finding
evidence: [T2, T1, T4]
status: lineage-corrected-survivorship (shapes) + cross-tier (description-as-teaching)
stage: drafted
consumers: harness-primary
depends: [errors-that-teach, method-evidence-tiers]
sources:
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 17; clusters on ask-user/todo
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C12, C13, C14, C15
  - ../../01-ideation/02-provenanced/syntheses/tier2-lineage.md
---

# Tool-definition anatomy and the converged micro-tools

**Claim.** The shipped ecosystem agrees on what a tool *is* to an agent:
**name + JSON-schema parameters + a description that is a teaching surface**
(the description carries law and usage wisdom, not just signature), with
longer guidance split into a separate file. Around that anatomy, a small set
of micro-tools recurs with near-verbatim rules. Lineage correction applies
hard here: most of the uniformity is convention-adoption of one or two
influential designs — reported as survivorship (nothing displaced them), not
as independent votes.

## The converged shapes (T2, lineage-annotated)

- **Ask-user:** 1–4 questions × 2–4 options, "(Recommended)" first, always
  an "Other" escape. Probable single-origin design, verbatim-copied.
  Survivorship reading: a structured clarification affordance beat
  free-text asking everywhere it landed — and T5's
  fabricated-missing-parameters finding (#structured-output-two-mechanisms)
  supplies the *reason* such an affordance is load-bearing.
- **Todo/task-list:** the most uniform micro-convention in the corpus
  (near word-for-word rules: one `in_progress` at a time; mark complete
  only after verification; never done with red tests) — i.e., most-copied.
  Its function under T4 light: an externalized strategy artifact with
  observable intermediates — credit assignment made bookkeeping
  (dossier §5.2) — which is likely *why* it survives contact with every
  model generation. The same theory supplies a plan-*shape* lesson worth
  carrying next to it: under uncertainty, deep AND-chains are
  mathematically doomed while wide OR-structure survives — the dossier's
  worked numbers: a 4-step chain at 90% per step succeeds 65% of the time;
  three independent 50% options succeed 87.5%. A plan artifact that makes
  it easy to write parallel fallbacks and awkward to write long dependent
  chains is quietly load-bearing.
- **Subagent/delegation tool:** fresh isolated context, resumable ID,
  scope-discipline framing, and — notable, repeated across independent
  implementations — **read-only roles enforced by tool-omission, not
  prose**. That last is a genuine design law the estate learned separately
  from its own incident (an agent asked to *assess* worktrees as
  safe-to-delete removed all eight; the codified rule: constrain by
  tool-set, never by prose — provenanced at
  `01-ideation/02-provenanced/commentary/worktree-deletion-incident.md`) —
  a Tier-1↔Tier-2 convergence with different incidents behind it.
  (#delegation-as-tooling carries the briefing-discipline half.)
- **Instruction files (AGENTS.md):** directory-scoped, nearest-wins — with
  a live, unresolved disagreement: one harness treats AGENTS.md as
  *untrusted data* with injection-precedence rules while the rest treat it
  as authoritative instruction (#counter-register).
- **Description-as-teaching-surface** (T1 autopax anatomy + INSTRUMENTA,
  T2 throughout): the description field is where the tool teaches its law
  *before* first refusal — the ex-ante complement of #errors-that-teach.

## What it generates

- **For the harness:** adopt the anatomy and the micro-tool shapes as the
  empirical floor (they are what current models are trained against —
  deviating has a real familiarity cost, which is survivorship's practical
  content); enforce capability boundaries by toolset composition; treat
  descriptions and refusals as the two halves of one teaching channel.
- **For UDON:** tool definitions, guidance files, and todo/plan artifacts
  are exactly the document class UDON targets (structure + prose + schema);
  the minimax-cli reverse-export singleton (CLI → its own tool schemas)
  sketches the generative direction: tool contracts authored once in a
  richer notation, projected to per-vendor JSON-schema dialects.

## Honest edges

Vote-counts here are the most lineage-inflated in the corpus — this segment
deliberately makes no "N teams independently needed X" claim. And the
anatomy is JSON-schema-shaped because the vendors' APIs are; whether that
shape is *right* (vs merely installed) is untested — the BFCL/omission
findings suggest the description/grounding layer, not the schema syntax, is
where reliability lives.
