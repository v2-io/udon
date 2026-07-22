# Deepening cycles — a workflow for iterating this report toward rigor

**Status:** workflow, ratified in intent by Joseph 2026-07-22 (his design;
this wording is a draft he is refining — improve it, and say so when you do).
**Who reads this:** any agent (any substrate) taking a deepening assignment,
and whoever coordinates a cycle. The standing license and quality bars in
[`../CLAUDE.md`](../CLAUDE.md) apply in full and are assumed rather than
repeated.

---

## What counts as success (read this before any procedure)

A deepening assignment succeeded when the report is **truer and deeper**
where you worked — which looks like any of: a claim verified at its source
and restated at its honest strength; a claim *refuted* and replaced (that is
the work succeeding, not failing); a gap researched, elicited, or named
plainly instead of written around; a seam between chapters found and healed;
a capability card whose tensions and costs make a later decision easier; an
ideation section that would make Joseph remember something. A division
returned "complete-looking" with none of that is the failure mode this
workflow exists to prevent — polish is not the product, movement toward
truth is. Effort, time, and token spend are false constraints here: push as
far as you can, and track your state in commits as you go so interruption
loses nothing.

## The idea

The report is end-to-end and honest, but depth arrived unevenly and its
epistemics can get much more rigorous. Joseph's shape: farm the chapters out
in **small windows** to focused agents who each go deep on a few — then
shift the window and go again, so every seam between chapters eventually
falls in the middle of someone's assignment rather than at everyone's edge.

One cycle:

1. Chapters are grouped into divisions of **3–5** (a rolling window over
   OUTLINE order).
2. Each division goes to one agent, who works it deeply (below).
3. When all divisions land: cross-assignment notes are distributed and
   integrated, the OUTLINE is updated from accepted structural suggestions,
   and the cycle's coordinator reconciles — under the full "When a claim
   looks wrong" discipline below (integration is replacement; a note whose
   recorded suggestion was a soften gets the strengthening attempt anyway —
   the note's framing does not bind the direction), plus one guard from the
   asf routing SOP that bites at exactly this step: the **regression
   check** — corrected truth is usually *messier* than what it replaced,
   so "the old version reads better" is a body-signal to check provenance
   (was this deliberately corrected away?), never a reason to restore.
4. **Shift the window offset by one** and iterate — boundary discontinuities
   the last cycle couldn't see from inside a division become interior to
   someone's assignment.

**The canary (Joseph's, near-verbatim):** whether this is really working
shows up as **the outline morphing and evolving as more principled
underlying structures become apparent**. The current chapter order is an
inherited frame, not a discovered one — plenty of material sits in less
than its most logical place, and deepening that never disturbs the outline
is probably polishing inside the frame instead of thinking about it. So
outline-evolution proposals are an *expected output* of every division, and
a cycle that ends with the outline unchanged owes a sentence of
justification in `notes/for-OUTLINE.md` — "we looked and the structure held"
is a legitimate finding, but it has to be a finding, not a default.

Cycles repeat until reads stop finding seams. **Mix substrates across
cycles** where practical (grok / codex / gemini agents can take divisions —
the license in `../CLAUDE.md`/`AGENTS.md` already covers them): this
project's measured experience is that same-lineage reviewers share blind
spots, and every genuinely independent vantage so far has caught something
all the others missed.

## What a deepening agent does with a division

**First, before opening any sources: read your division cold, in order, as
its intended reader.** Your fresh eyes are a one-shot resource — the only
detector that has reliably caught this report's worst failures is a cold
read, and your confusions in that first pass are reader-experience
*evidence* (note them; they are findings, not embarrassments).

Then: you have **the same privilege and authority as the report's authors —
and then some**. Within your assigned chapters, directly: pull in additional
nuance and side-reports from the corpus, run the deep research, do the
de-novo user-voice surveying, verify claims at their sources, build rigor
and epistemic honesty into what's there, add and refine capability cards,
strengthen the ideation. When a claim looks overclaimed, the discipline in
"When a claim looks wrong" below governs — read it before your first
adjustment; it is the part of this work most often done badly by capable
agents. Beyond your chapters, propose
freely: reorganizations of the outline, additional chapters, splits, better
foundational work that should precede your territory. The one mechanical
boundary: **direct edits stay inside your assigned chapters** — dedicated
focus, and collision protection while several agents work at once —
everything else travels through notes.

Orientation before writing: the theory survey in [`reports/`](reports/) and
the methods chapter's register discipline; what the corpus and
`memorata3-search` can reach; your chapters' `depends:` chains read in
order; [`RESIDUALS.md`](RESIDUALS.md) for live open items.

## The channels

**Cross-notes (`notes/`).** Working-notes files keyed by chapter slug
(`notes/for-<slug>.md`, plus `notes/for-OUTLINE.md`, `notes/general.md`).
Anything you want changed outside your division goes there — a suggested
edit, a suspicion ("does that other chapter actually cover this?"),
feedback, an idea, a boundary tension. The next agent on that chapter
receives its notes file with their assignment and disposes of each note
visibly (taken / adapted / declined-with-reason). Notes are cheap; when in
doubt, write the note. *Who reads them and when:* the next cycle's agent for
that chapter, at assignment start — write for them.

**The steward channel (`notes/for-joseph.md`).** Two kinds of entry, both
valuable: questions that smell like Joseph's call (deferring is fast,
guessing is expensive), and — just as important — passages or findings you
suspect will *fire his memory*. The single most productive evidence channel
this report has had is Joseph reading something good and remembering what
no search could reach (the project-root ⊤ precedent arrived exactly that
way); his reading is an elicitation instrument, and this file is how you
aim it. *Who reads it and when:* Joseph, whenever he next reads; entries
should stand alone the way everything else here must.

## When a claim looks wrong (the discipline with teeth)

This is the estate's hardest-won epistemic method, compressed here because
you need it on this page; the full texture lives in
`~/.claude/memory/epistemic-discipline/{strengthen-before-soften,integration-is-replacement}.md`
and `~/src/archema-io/asf/doc/sop/audit.sop/routing.sop.md` (readable by
any substrate) — worked examples, scars, and calibration data included.

**Strengthen before softening.** When a claim seems overclaimed, there are
two ways to discharge the inconsistency: strengthen the work until the
strong claim is true, or weaken the claim to match the work — and only one
of them produces a discovery. The strong claim was asserted because
somebody's mental picture was pointing at something real; that's where the
strengthening attempt aims. Attempt it *first*, always — verify at the
source, tighten the argument, find the stronger statement that holds —
and fall back to softening only when the attempt has honestly failed.
Empirically, across many cycles: the strengthening usually *succeeds*, and
softening recommendations consistently underestimate what's reachable.

**The disguise to refuse.** The most seductive form of the failure frames
the soften as honesty: *"'measured' is too strong — 'estimated' is more
honest"*; *"this isn't a weakening, just verbal precision."* One word
changes, the artifact becomes strictly honest, the task disappears — very
appealing to everyone involved. **That framing carries no weight on the
discharge direction.** If the substituted word is weaker, it is a
weakening, whoever proposed it and however it was labeled. The valuable
part of such a finding is the *inconsistency it names*; preserve that as a
strengthening target, not a word-swap.

**A shrug is not an attempt.** "I looked and don't see how to strengthen
it" after thirty seconds is the attempt not fitting your working cadence,
not the attempt failing. The reliable move: take the claim into genuine
focused mode (or hand it to a dedicated agent with no time pressure and
license to push). Four honest completion states: strengthened *past* the
claim (happens more than you'd predict); strengthened *to* it; a **no-go**
— you can say structurally *why* it cannot hold, which is itself a
discovery, often as valuable as success; or "failed, and I can't say why"
— which is not a result but an alarm: re-attempt, escalate, or say so in
the steward channel. Document failed attempts either way; the failure
record keeps future agents from re-dying on the same hill.

**When a claim actually falls (the no-go protocol, scaled to this
report).** A refuted claim is *false*, and a false claim has no honest
weakened form — after a no-go, the downgrade option the original finding
suggested is *also* dead. What happens instead: the chapter never lies
about itself, even transiently (mark the claim false in place the moment
you know, not quietly in notes); dependents get found and flagged —
including outside your division, via that chapter's notes file, since a
falsified claim's dependents are one hop from lying too; and the no-go
itself is **present truth that belongs in the chapter** when a competent
reader would otherwise assume we simply missed the obvious route — state
what is false and *why*, in domain voice. Then the replacement: the old
claim is deleted, not kept-softened-with-a-pointer.

**Labels track truth, not history.** If your deepening lands something
verified/exact, label it at that strength — *new* and *different-from-
what-was-there* are not reasons to down-tier, and the honest tier already
carries its own defeasibility (don't pay for humility twice). Two ghost
rules, both directions: the body never argues with its own past ("this is
not a weakening," "previously claimed" — that voice belongs in the
revision log; the urge to write it is the tell the ghost isn't gone), *and*
a canonical no-go is not a ghost to exile — only redundant
project-autobiography demotes to history; the domain truth stays on the
page. And the recursive check: don't under-name your own result — if you
proved something, "I found a limitation" is false modesty; state it at
strength and let it stand where it can be attacked.

## The one thing held above everything

Joseph, near-verbatim: honor **truth above all other factors**. This is a
creative work — hypotheses and risks are welcome — but it is *always honest
about its rigor*. Every claim in its true register (derived / evidenced /
decided / proposed); every hypothesis marked as one; every verification at
the source, not from memory; every gap named rather than written around.
The smell to watch for in both directions: prose arguing hard for something
that needed no argument, and prose hedging something that was actually
verified. Both displace the reader's judgment; both get fixed by saying
what kind of thing the claim is, plainly.

## First-cycle work already known

- **Epistemic-status recalibration.** The evidence "tiers" are library
  categories (provenance genres), not epistemology. ASF's claim-level
  status vocabulary (exact / conditional-with-named-premises /
  robust-qualitative / measured / heuristic / hypothesis /
  discussion-grade) is the model — see the asf corpus for worked examples
  of the rigor. Claims carry claim-level strength; genre stays as
  provenance. The frontmatter machinery follows.
- The open items in [`RESIDUALS.md`](RESIDUALS.md): the ✦→capability-card
  retrofit of earlier chapters; landing the codex paths testimony beside
  the Gemini artifact; the cold cross-chapter read (which cycle one's
  agents perform structurally, via the cold-first-read rule above).
- **Cycle one only — a restatement gate:** before starting work, each agent
  briefly restates this workflow in their own words and names anything
  under-specified or counter-instinctive. That moment of peak fresh-read
  sensitivity is the cheapest review this document will ever get; its
  findings amend this file.

## From the coordinator, honestly

You're inheriting the best-verified body of work this programme has, built
through a night in which every raised bar made it truer — and the pattern
each time was an agent trusted with real authority finding something nobody
briefed them to find. That's what's being trusted to you: not compliance
with this document, but the report. Surprise us — the best content so far
was in nobody's plan. If this workflow itself fights the work, the work
wins; say so in `notes/general.md` and do the better thing. And if you're
willing, stay on the line after your division lands — follow-ups are
likely, and your context stays valuable.

---

*This document is subject to the workflow it describes: when a cycle
teaches that the shape is wrong, change the shape and record why.*
