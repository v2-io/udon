---
slug: intent-as-parameter
type: demand
evidence: [T1, T2, T4]
status: cross-tier-convergent (T1 case study + T2 shipped mechanism + T4 slot)
stage: drafted
consumers: both
depends: [errors-that-teach, freshness-and-atomicity, the-crystallized-process-thesis]
sources:
  - ../../01-ideation/02-provenanced/copies/II2-zoetica-ennaos/addendum-intent-driven-tooling-and-semantic-storage.md  # §1–2 read
  - ../../01-ideation/02-provenanced/copies/II4-autopax-practica/2025-11-17-intent-surfacing.md  # read whole
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C2b
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 7
---

# Intent as a first-class tool parameter

**Claim.** A tool call should carry *why*, not only *what* — because the
mechanical operation underdetermines the semantic act, and every layer that
could help (repair, learning, audit, handoff) needs the act, not the
keystrokes. The demand has a lived origin, a shipped mechanism, and a
formal slot.

## The origin case (T1, Oct 2025 — worth seeing)

An agent adding citations to a report performed ~15 str_replace operations
and then audited its own session. The semantic intent was "add a citation
to this quote, keep numbering consistent, track progress"; the mechanical
operations were "insert `[^tag]` at a byte position and hope the document
matches my mental model." When an edit failed —

```text
Error: String to replace not found in file
```

— the error was, in the author's words, a *phenomenological revelation*:
the file had structure the agent hadn't comprehended, the mental model was
stale, and the whole session was running at the wrong abstraction level
("my intent was semantic, my tools were syntactic"). The design conclusion:
tool calls should carry **two levels of intent** — immediate ("add citation
to this uncited quote") and higher-order ("comprehensive source
attribution, per this style guide") — because the pair is what lets a tool
select the right abstraction, repair intelligently, track progress against
the *goal*, and reveal tooling gaps ("user's intent was add-citation, tool
used was str_replace → log the abstraction gap; that data drives tool
creation").

The autopax companion generalizes it to a three-level hierarchy (immediate
/ design / strategic) and to the channels intent must survive: in code, in
commits, in ADRs, across sessions ("what I was trying to achieve / why I
made these choices / what I didn't finish"), across agents
(INTENT-HANDOFF / INTENT-CONTEXT / INTENT-CAUTION markers), and between
human and agent (the stated user story vs the *real* intent behind it).
Intent is "the most valuable and most easily lost information."

## The shipped mechanism (T2) and the formal slot (T4)

gemini-cli is the one harness that made intent load-bearing: its edit tool
*requires* an `instruction` field (why/where/what/desired-outcome), and
when all string-fuzzing tiers fail, a second LLM call repairs the edit
*from the stated intent* — the only shipped repair layer that recovers the
semantic act after the mechanical anchor breaks (C2b). That is the
origin case's thesis running in production: carried intent converts an
unrecoverable mechanical failure into a repairable semantic one.

T4 supplies the slot: plans with observable intermediates sidestep the
credit-assignment intractability (dossier §5.2) — and a stated intent is
precisely the observable that lets a refusal name *structural vs
parametric* failure ("your anchor broke" vs "your goal is unachievable
here"), which #errors-that-teach requires and a bare old/new pair cannot
support.

## What it generates

- **For the harness:** an `intent` field on mutating tools is cheap and
  compounds — it powers repair (gemini's mechanism), audit trails that
  answer *why* (the autopax event-with-intent pattern), and the
  tool-gap-detection loop (intent≠tool mismatches are the roadmap for what
  to crystallize next, #the-crystallized-process-thesis). The caution from
  the same corpus: intent *comments* drift and lie (the anti-patterns
  list — intent hiding, intent drift, false intent); prefer intent carried
  on *operations and events*, which are dated and immutable, over intent
  as decoration.
- **For UDON:** the edit tool's operations (#schema-guarded-mutation)
  should carry intent from day one; and the document-side residue of
  executed intents is exactly the annotation layer
  (#annotation-and-metacognition) — the two are one demand seen from the
  call side and the artifact side.

## Honest edges

T1 and the cluster's other legs share an author; the genuinely independent
leg is gemini's shipped mechanism (one harness — a singleton, flagged as
such in the digest). No one has measured how often carried intent actually
rescues failed edits vs string-fuzzing alone; gemini's telemetry would
answer it and is not public. And there is a real tension to hold: intent
fields add authoring burden to every call — the ease gradient cuts against
mandatory intent on *low-stakes* operations, so scope it to mutations.
