---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [proxy-before-threshold, force-levels-four, force-critical-is-ctq, critical-implies-required]
depends: [def:record-kinds, def:record-fields]
---

# Principle, fitness, objective: the purpose layer

*How the spec store's purpose records work together: one concern can have a principle, a fitness, and an objective. They start mixed and split on demand, and two guards apply to fitness.*

## Statement

- **One concern can have up to three records:**
  - a ⟦principle⟧ gives the direction, e.g. "minimize time to comprehension";
  - a ⟦fitness⟧ says how progress is measured, e.g. seconds for a fresh reader to answer N questions about a lite document;
  - an ⟦objective⟧ with ⟦force⟧ `required` sets the bar to pass (⟦threshold-on⟧ the fitness).

  They are separate records because each can be wrong while the others hold. The principle can be right and the proxy bad; the proxy sound and the threshold too low; the threshold met and the principle no longer wanted.
- **They can start as one segment** with correctly headed sections (*Principle*, *Fitness*, *Objective*). Each part is split into its own record as soon as any of these happens:
  - another record needs to cite one part on its own;
  - modifications start being appended to one part;
  - a finding, revision, or decision lands on one part only.

  Once split, the parts link: the fitness ⟦serves⟧ the principle, and the objective is `threshold-on` the fitness.
- **Two guards apply to fitness:**
  - **Goodhart.** A fitness serves a named principle, and its claim that the proxy tracks the principle stays on record and stays checkable. Meeting the number is never taken as meeting the principle.
  - **Commitment.** "An objective's threshold on a fitness must be set before the measurement it gates. A threshold chosen after seeing the numbers is tuned, not tested (RC1's commitment law)." The threshold objective records when it was set (⟦committed⟧). Every measurement it gates must be dated after that.
- **⟦force⟧ has four levels** ([[decision:force-levels-four]], [[decision:force-critical-is-ctq]]): `non` (an explicit non-goal), `desired` (met if possible), `required` (an intention for this version), and `critical` (critical to quality, CTQ: because of other factors, expected to have an outsized impact on the spec's success or utility). For now a `critical` objective is also `required` ([[decision:critical-implies-required]]). A ⟦requirement⟧ is an objective whose force is `required` or `critical`.
- **⟦force⟧ belongs to the objective-level kinds**: objectives always, and principles and fitness where they carry one. It is a field of its own, separate from the RFC 2119 words in a Statement.
- **Not every objective has a threshold.** One can instead be discharged by a ⟦property⟧ established over the rules, as [[spec/obj:reserve-dont-ignore]] is by the unwritten [[spec/prop:forward-stability]]. The objective ladder in the spec store's kinds file has a `discharge-checked` rung that covers both ways.
- **Fitness is a possible kind, not yet admitted.** It is admitted when the first real fitness record is written.

## How a violation shows

- A fitness with no `serves`.
- A threshold objective with no `committed` date, or with a gated measurement dated before it.
- A mixed segment that is cited by part, or that carries appended modifications to one part.

## Why

Joseph, 2026-09-30, raised objective / principle / fitness as possible higher-level types. He also asked:

- that objectives, non-objectives, and critical objectives be distinguished;
- that a fitness can be tied to a principle and to a threshold objective;
- that mixing within a segment is allowed until one part needs reusing or starts collecting changes.

He agreed to three refinements: a third split trigger, force as a field, and one spelling for requirement. He then quoted the two guards back from an earlier reply. The record of that exchange is in `sop/influx/proposed-verisectorium.md`, "The purpose layer".
- These records live in the spec store (`obj/`), so any records written from the SOP side are `example` or `proposed` rows (see [[dir:scope]]).

## Working notes

- The fork's candidate rule, recorded there as unconfirmed: a threshold waits until there is evidence that the proxy tracks its principle. It fits with the Commitment guard: validate the proxy on cases with known answers, then commit the threshold, then take the measurements it gates.
- **The "time to comprehension" example has no recorded source here.** `sop/influx/proposed-verisectorium.md` says it is recorded in `.int/`, but it isn't. A helper traced it to Joseph's earlier temporal-software-theory work; the citation is still to be carried in.
