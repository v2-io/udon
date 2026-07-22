---
slug: method-evidence-tiers
type: method
evidence: [T1, T2, T3, T4, T5]
status: ratified-practice
stage: drafted
consumers: both
sources:
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md
  - ../../01-ideation/02-provenanced/syntheses/tier2-lineage.md
  - ../../BRIEF-agentic-tooling-compilation.md
apparatus-note: >
  Segment metadata throughout this report tags evidence kinds T1–T5 per the
  table below. Body prose describes evidence in plain words; the codes are
  bookkeeping for auditors, not reader vocabulary.
---

# What this report counts as evidence

Every claim here stands on one or more of five kinds of evidence. They fail
in different ways — which is exactly what makes their agreement meaningful:

| Metadata tag | The evidence | It fails as evidence by being… |
|---|---|---|
| T1 | First-principles design work on agent tooling (Joseph Wecker, 2025–26, across a family of related systems) | aspirational; possibly never tested |
| T2 | What real coding harnesses and CLIs actually ship (fourteen systems examined at source level, plus adjacent prior art) | survivorship; **copying mistaken for agreement** |
| T3 | First-person accounts from agents of tools failing or serving them | anecdotal; few voices |
| T4 | Formal theory (ASF/AAT): theorem-grade results with named premises | abstract; conditional on those premises |
| T5 | External published research (2026 sweep, adversarially verified) | outside-view; benchmark-era caveats |

**Three registers, kept distinct.** Besides where a claim's support comes
from, every claim here is exactly one of three kinds, and the prose is
written so you can tell which without apparatus:

- **Derived** — it follows from common knowledge or stated premises, and
  the reasoning is on the page.
- **Evidenced** — observation, measurement, or testimony supports it,
  cited where it stands.
- **Decided** — someone chose: a scope call, a convention, a project
  ruling. Decisions are legitimate — design runs on them — but they are
  never dressed up as derivations. Where the project's owner made a call,
  the text says so plainly (usually with a link to the
  [[DECISIONS.md|design ledger]]) rather than manufacturing an argument
  that arrives where the decision already stood; and where a decision
  merely confirmed something obvious, the text says *that*.

If a passage seems to argue hard for something that needed no argument,
treat it as a defect in this report and flag it.

**The discipline this report holds itself to:**

1. **Agreement across kinds of evidence is the unit of proof.** Most of the
   design work, and much else here, has one author; agreement between his
   own projects is coherence, not corroboration. A claim gets full
   confidence only when at least two evidence kinds with *independent*
   failure modes support it.
2. **Shipped-practice counts are corrected for descent — and survivorship
   still carries positive design weight.** Much of the uniformity across
   shipping harnesses is inheritance from one or two influential designs,
   not independent invention: the patch-envelope format traces to a single
   published origin with zero independent arrivals; the ubiquitous
   exact-replace edit tool and the todo-list shape are convention-adoption
   of one design. Where this report says something "converged," it has
   checked which kind of convergence it was. Uniformity-by-descent is weak
   evidence that agents *need* a thing but strong evidence that it is what
   current models are trained against — for anyone choosing harness
   defaults, a real design input rather than a deflated count. Two patterns
   survive the correction as genuinely independent arrivals — the graduated
   fuzzy-match ladder and the headless I/O contract — and carry full
   weight.
3. **A claim's status is limited by its weakest *necessary* premise** — not
   by the mere presence of a weaker supporting source (that would punish
   honest inclusion of thin evidence), and not laundered upward by a strong
   source that supports only part of the claim. Each chapter says which
   part of its claim each kind of evidence actually carries. And the
   characteristic failure of synthesis writing — firming up caveats the
   sources stated carefully — is named here so it can be checked: where a
   source said "conditional," "single-repo," or "2024-era numbers," the
   chapter says so too.
4. **Counter-evidence rides adjacent to the claims it qualifies**
   (the [counter-evidence chapter](counter-register.md)), never in a footnote graveyard.
5. **Theory results are conditional theorems, not vibes** — and the
   conditions travel with every use (the bias bound's named sub-scopes; the
   deliberation threshold's drift assumption).

**Who reads this and when:** both consumers, first — any downstream use of
this report's claims should apply these weights rather than re-deriving or
ignoring them.
