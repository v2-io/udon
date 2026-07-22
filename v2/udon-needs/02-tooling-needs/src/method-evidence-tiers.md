---
slug: method-evidence-tiers
type: method
evidence: [T1, T2, T3, T4, T5]
register: decided        # this chapter states the report's conventions; a method is chosen, not measured
strength: —             # decided chapters take no strength rung (see "The three axes")
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

**Genre is not strength — they are different axes, and this report keeps
three of them apart.** The table above classifies *provenance* — whose
account a piece of evidence is, and how it characteristically fails. It
says nothing about how strong any particular claim is. A claim from a
"weak" genre can be exact (the duplicate-key result in the stress test is
a *measurement*: detection rate zero); a claim from the formal theory can
be exploratory. Confusing the two is the specific error this section
exists to prevent: reading a formal-theory citation as automatically
strong, or a single-agent account as automatically weak. Provenance and
strength vary independently, so they are tracked independently.

**The three axes, named.** Every claim in this report sits at one point on
each of three orthogonal axes, and the prose is written so a reader can
place it on all three without decoding apparatus:

1. **Genre** — *where the evidence came from and how it fails* (the T1–T5
   table above). Bookkeeping; provenance; a "library category," not an
   epistemology.
2. **Register** — *what kind of claim this is as a speech act*: derived /
   evidenced / decided / proposed (defined just below). This is about the
   epistemic *act*, not its confidence — a decision and a derivation are
   different kinds of thing before either is strong or weak.
3. **Strength** — *how defeasible the claim is*, on a single graded ladder
   borrowed from the formal theory's own status vocabulary, extended with
   two rungs this report needs for empirical and imaginative claims:

   | Strength rung | What it means here |
   |---|---|
   | **exact** | A measurement or a closed-form result; defeasible only if someone finds a mistake (detection rate zero; a theorem's algebra). "Exact" already carries that humility — do not pay for it twice by down-tiering. |
   | **conditional** | A theorem-grade result that holds *under named premises* that travel with every use (the κ×A bias law; the persistence threshold). As strong as exact *given* its premises; the premises are the whole caveat. |
   | **robust-qualitative** | A direction or ordering that holds across many cases and would survive most reasonable perturbations, without a precise magnitude (structure reduces observation ambiguity; sharp refusals teach). |
   | **measured** | An empirical number with its measurement conditions attached — carrying the caveats the source stated (single-repo, one model family, benchmark-era, N=…). Strong *at* its conditions, silent beyond them. |
   | **heuristic** | A working rule that earns its keep in practice but has no proof and known exceptions (most shipped-harness conventions read as heuristics with survivorship behind them). |
   | **hypothesis** | A prediction not yet tested — every *proposed*-register claim lands here by construction. |
   | **discussion-grade** | Reasoning offered to frame or provoke, explicitly not load-bearing; honest about being a starting point. |

   The ladder is not a ranking to climb — a claim is at the rung its
   support actually reaches, and "measured" is not "better than"
   "conditional," they answer different questions. Where a claim's strength
   is load-bearing the prose *says the rung in words* ("measured, single
   repo"; "conditional on the drift assumption"; "a hypothesis this report
   generates"); the frontmatter carries it as machinery (below) so an
   auditor can sort by it.

**How the three axes interact (the part that was conflated).** Strength is
not a fourth register and register is not a strength grade — they cross.
Only the two *truth-apt* registers take a strength rung: a **derived** claim
is exact / conditional / robust-qualitative / discussion-grade depending on
how tight its reasoning is; an **evidenced** claim is measured /
robust-qualitative / heuristic depending on what the observation supports. A
**decided** claim takes *no* strength rung at all — a decision is not
strong-or-weak, it is a different kind of object (a choice, legitimate on
its own terms; asking "how confident are we that we chose X?" is a category
error — the question is only "did we choose it," and the answer is yes). A
**proposed** claim is *hypothesis* by definition — that is what proposing
means — so its register already fixes its rung, which is why proposed
content needs no separate strength tag, only its unmistakable imaginative
voice. So the machinery reduces to: genre and register on every claim;
strength on the derived and evidenced ones; the other two registers self-tag
their rung.

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
- **Proposed** — an idea, generated here. This report is not only an
  organization of what exists; each chapter is chartered to *think* — to
  notice what its principles make conceivable that nobody has yet said.
  Such passages are voiced unmistakably as imagination ("one could…",
  "nothing yet built does…"), they open possibility space without closing
  any of it, and they decide nothing — the design work downstream owns
  all of that, with fuller context than this page has. **Proposed content
  is marked visibly**, in each chapter's "What this opens (ideas, not
  designs)" section, as **capability cards** — callout blocks of the form
  `> [!capability] <name>` carrying, as a strong default: what it is,
  the principles that apply, the **hypothesized impact on the agent** —
  stated in the formal theory's rigorously defined vocabulary wherever
  that vocabulary is the precise fit (observation ambiguity, update
  gain, tempo and the persistence condition, channel quality,
  reinjection strength, law-teaching density, comprehension time under
  turnover, credit-assignment observability, the context
  description-length budget… the theory survey in Appendix-grade depth
  lives in [the theory report](../reports/theory-of-agentic-tooling.md)),
  because that vocabulary precisely names every aspect of an agent's
  fitness — human agents included. Two disciplines keep the field
  honest: name the *specific* quantity and the direction and mechanism
  ("drives observation ambiguity toward zero on parse outcomes" beats
  "improves observation quality"), and stay in the hypothesized voice —
  the theory supplies the precise language for a prediction; the
  prediction remains a prediction. Then: what the capability stands in
  tension with, and its potential downsides. The last two
  fields are the point: cards that name their own costs are what lets
  the later priority stages weigh capabilities *against one another*
  instead of inheriting a verdict. A card whose territory genuinely
  lacks one of the fields says so rather than manufacturing content —
  the register discipline applies inside cards too. (Chapters written
  before this convention landed carry their ideas as ✦-marked bullets —
  same register, older dress; a retrofit is mapped in the coverage
  notes. And that this report had to *invent* a typographic convention
  to mark a claim's register is itself a small demand datum for the
  notation work: registers-on-content is exactly what a
  structure-and-prose format could carry natively.)

**The frontmatter machinery (what an auditor can sort by).** Each chapter's
frontmatter carries the three axes as fields, so the report is
machine-auditable without any of this apparatus surfacing in the reading
experience:

- `evidence:` — the **genres** present in the chapter (`[T1…T5]`). Provenance
  only; never read as a strength grade.
- `register:` — the chapter's dominant **speech-act kind(s)**
  (`derived` / `evidenced` / `decided` / `proposed`), where one dominates;
  mixed chapters say so.
- `strength:` — the **headline claim's rung** on the ladder above, for
  chapters whose headline claim is truth-apt (derived or evidenced). A
  `decided` or purely `proposed` chapter omits it (nothing to grade), and
  in-body claims that diverge from the headline carry their rung in prose.

This replaces the older overloaded `status:` string, which mixed genre-count
("4-tier"), strength ("theorem-grade-conditional"), and maturity
("ratified-practice") into one field and so could not be sorted on any single
axis. Chapters migrated in the current deepening cycle carry the split fields;
the rest carry the convention forward as their window comes up (the change is
a schema exemplar landed here plus a carry-forward note, not a silent
whole-report rewrite). `stage:` continues to carry draft maturity, which is a
fourth and wholly separate thing from all three axes.

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

One further fact about evidence, learned while writing this report:
**readable, principled analysis is itself an elicitation channel.** When a
chapter lays its territory out from first principles, readers remember
things no search would have surfaced — shipped precedents, old rationales,
buried counter-examples that were latent until good analysis fired the
recall. (The addressing chapter's project-root anchor arrived exactly this
way: the owner had forgotten a shipped precedent entirely until the
principled treatment made it vivid again.) So late-arriving evidence is
not a gathering failure; it is the analysis working, and this report is
built to absorb it additively.

**Who reads this and when:** both consumers, first — any downstream use of
this report's claims should apply these weights rather than re-deriving or
ignoring them.
