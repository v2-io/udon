---
slug: delegation-as-tooling
type: principle
evidence: [T2, T1, T3]
status: converged-shape (T2, lineage-annotated) + ideology-reaching-practice (the briefing register)
stage: drafted
consumers: harness-primary
depends: [tool-definition-anatomy, steering-and-verification-surfaces]
sources:
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C13
  - ../../01-ideation/02-provenanced/copies/II7-ref-arch/sapientia-multi-agent-coordination.md
  - ../../01-ideation/02-provenanced/commentary/worktree-deletion-incident.md
  - ../../01-ideation/02-provenanced/characterizations/III-eli-testimony.md  # sibling collision; agent-authored conventions
---

# Delegation as tooling: capability by construction, briefing as peer

**Claim.** Two delegation disciplines have crossed from hard-won estate
practice into converged (or convergent) tooling: **capability boundaries
enforced by toolset composition rather than prose**, and **briefing
subagents with intent and context rather than compliance checklists**.
The first is a security-grade design law; the second is the delegation
register's first appearance in shipped prompts.

## The evidence

- **Capability by construction (T1↔T2, different incidents behind the
  same law):** the estate's leg is the worktree-deletion incident — an
  agent asked to *assess* worktrees as safe-to-delete removed all eight;
  codified as "constrain by tool-set, never by prose: 'analysis only' is
  not enforceable against a Bash-capable agent that infers the next
  step." The ecosystem's leg, arrived at separately: read-only subagent
  roles enforced **by omitting mutating tools from the toolset** across
  multiple independent implementations (an explore agent deliberately
  omitting even ask-user to enforce non-interactivity by construction).
  Two origins, one law — a genuine convergence, and the tooling
  instantiation of the ease-gradient's constraint layer
  (#the-crystallized-process-thesis).
- **The converged subagent shape (T2, C13):** fresh isolated context per
  subagent; a resumable ID; scope discipline in the prompt; results
  generally trusted back. Lineage caveat applies to the uniformity; the
  shape's survival across every model generation is the survivorship
  signal.
- **Briefing as peer (T1→T2):** the estate's delegation discipline —
  share intent and unique context, not a how-checklist; prescriptive
  specificity collapses the receiver's deliberation-space — now appears
  nearly verbatim in a shipped harness prompt: "brief it like a colleague
  who just walked in; do not delegate understanding" (kimi-code's agent
  guidance). One ecosystem instance is not a trend, but it is the
  register crossing substrate lines, and the harness workshop's taxonomy
  ranks peer-voice-delegation the second most load-bearing corrected
  behavior in its whole corpus — with the sharp sub-face worth carrying:
  *don't delegate the reading itself*, and don't stamp guesses with
  false authority in a brief (authority-laundering).
- **The coordination substrate (T1/T3):** where multiple agents share
  work, the sapientia design and the lived testimony agree on mechanics:
  shared observable artifacts over relay (#steering-and-verification-
  surfaces), per-agent file ownership plus **append-only shared files**
  for multi-writer safety (the sibling-collision fix, independently
  re-derived in this corpus's own append-only LEDGER), and
  agent-authored conventions like recording branch/session-id in the
  commit itself.

## What it generates

- **For the harness:** compose subagent capability from toolsets, never
  prose; make the brief surface carry intent/context affordances (the
  delegation file's brief-anatomy is the spec); provide append-only
  shared channels for multi-agent work as a primitive, not a convention
  agents must remember; and treat "questions back from a subagent" as
  brief-diagnostic signal, not noise to suppress.
- **For UDON:** briefs, handoffs, and shared work-streams are documents —
  the handoff document class (structure skeleton + high-confidence
  annotations + continuation point, from the spike's memory table) is a
  format target; and append-only-friendliness (cheap, conflict-free
  appends to a structured document) is a real notation property
  multi-agent practice already selects for.

## Honest edges

The briefing-register evidence outside the estate is one harness's
prompt file — suggestive, not established; the ecosystem's subagent
prompts are otherwise compliance-shaped. Nothing here measures delegation
quality against briefing style (the estate's evidence is incident-rich
but count-free — its own taxonomy says "nothing is measured" about
exactly this). And capability-by-construction has a residual the incident
itself names: a Bash-capable agent can do almost anything; toolset
boundaries are real only when the dangerous capability is actually
absent, not merely undocumented.
