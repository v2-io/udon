---
kind: principle
state: [drafted]
per: []
depends: []
questions: []
max: decided
---

# Prefer the simpler grammar, short of surprising the reader

*Among alternatives that meet the objectives, the one that simplifies the grammar or rules wins, unless it violates least surprise.*

## Statement

When two or more alternatives for a rule each meet every objective, a decision SHOULD prefer the one that makes the grammar or rules simpler, unless that alternative would surprise a reader who knows the rest of lite.

## How it is used

A principle does not decide anything alone. A decision cites it, and says which alternative it favored and why that alternative does not surprise. Two things are not principles, even though decisions often mention them:

- **An objective.** Objectives are properties the rule set must have and are checked against it.
- **Precedent.** A past spec's choice is evidence of what someone once thought, not a tie-breaker.

## Grounds

Recorded in `../influx/pre-design/README.md` §"How to read the history sections", under the heading "Joseph's words (2026-09-29)", as: *"Most persuasive: whatever simplifies the grammar or rules without violating least surprise."* That section is phrased partly in the third person ("He reserves the right…"), so it is at least partly a rendering. I have not located the verbatim.

## Epistemic status

Principle; `max: decided`. It fails when it is ignored, or when it keeps favoring choices that later need reversing. It is repaired by the steward revising it, and every decision citing it is then re-examined.

## Working notes

- The same README section also has a reading rule: older and newer discussions carry equal weight, and Joseph's past comments have no special status over agents' pushback. That rule is about how to weigh *history*, not how to choose among alternatives. If it is kept, it belongs in the SOP store as praxis, not here as a principle.
- Candidate sibling principles are visible in the influx but not yet stated for lite: "keep everything; severity is loss" (0.10.0 G7) and "typing is syntactic" (G6). They are listed in the outline as `proposed`, not assumed.
