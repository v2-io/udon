---
kind: principle
awaiting-second: true
awaiting-decision: true
needs-work: false
per: []
depends: []
---

# Prefer the simpler grammar, short of surprise

*Among alternatives that all meet lite's objectives, prefer the one that makes the grammar or rules simpler, unless it violates least surprise.*

## Statement

When several alternatives for a rule each meet every objective, a decision prefers the one that makes the grammar or the rules simpler, as long as that alternative does not violate the principle of least surprise.

## Grounds

- **Joseph, 2026-09-29:** "I will be very persuaded by things that simplify the grammar or rules without violating the principle of least surprise."
- **Source.** Session `5930da5d-2aed-49ea-ac8b-ed619c1d6a0d` in `~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon/`, his turn at 2026-09-30T00:18Z (evening of 2026-09-29 local). He said it while briefing the agents who would write the pre-design histories, as part of how to weigh past discussion. `.int/pre-design/README.md` renders it as "Most persuasive: whatever simplifies the grammar or rules without violating least surprise."
- **What the rendering adds.** His words describe what will persuade him; they do not adopt a principle for lite. Two things in the Statement come from elsewhere:
  - *"Among alternatives that all meet lite's objectives"* is the principle kind's scope ([[sop/def:record-kinds]]): a principle breaks ties between alternatives that all meet the objectives, and never trades against an objective.
  - *"Prefers"* renders "very persuaded" as a strong preference. It is not a veto.
- **Decision.** None yet. No decision adopts this as a lite principle, so `per` is empty and `awaiting-decision` is true.

## How it is used

A principle decides nothing by itself. A ⟦decision⟧ that leans on it cites it as a link in its Decision Drivers section, `[[prin:simplest-grammar-without-surprise]]`, and says three things:

- which alternative it favored;
- what makes that alternative simpler;
- whose surprise was considered, and why that alternative doesn't cause it.

The pre-design questions already appeal to both halves. Simplicity shows up as one rule instead of two in 01, 56 and 64, and least surprise shows up in 50, 62, 66 and 83.

Two things are not this principle, though decisions often mention them beside it:

- **An objective.** Objectives bound the alternatives first, and are checked against the rule set. This principle only orders what is left.
- **Precedent.** A past spec's choice is evidence of what someone once thought, not a tie-breaker. In the same message, Joseph said older discussions are "not necessarily more privileged" than newer ones, and "I reserve the right to change my mind about anything and everything in the past."

## Epistemic status

A ⟦principle⟧ is never met or unmet. It only orders alternatives, which is what separates it from an ⟦objective⟧. It fails when decisions ignore it, apply it inconsistently, or keep favoring choices that later need reversing. It is repaired by revising it, and every decision that cites it is then re-examined.

No ⟦verification-level⟧ is written. The principle ladder in `.vsect/kinds.yaml` has one rung, `authorized`, and no decision adopts this principle yet.


## Working notes

- **Open: whose surprise counts?** The pre-design files appeal to different audiences (50, 59, 62, 66, 83), and the principle doesn't say which wins.
