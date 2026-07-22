---
source: 2025-12-18-mental-models-and-intent-inference.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-12-18-mental-models-and-intent-inference.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [shared-context, spec-communication, information-theory, intent]
why_included: >
  Dec 18 2025. The "Joseph vs the user" performance effect; spec-communication as information theory (less explicit detail needed as shared context grows). Motivates conventions and notations that raise shared context so briefs can be shorter.
---

# Mental Models and Intent Inference in Agent Collaboration

**Date:** 2025-12-18
**Context:** Conversation between Joseph and Claude after completing TUI→Pinax migration
**Status:** Exploration / Hypothesis

---

## The Observation

Joseph noticed that agent performance and thoughtfulness varies significantly based on whether the agent thinks of him as "Joseph" versus "the user." This isn't just politeness - it has measurable impact on work quality.

## The Hypothesis

The bottleneck in agentic software development is communicating specification with sufficient detail. Per information theory, "sufficient detail" is a function of shared context - you need less explicit information when there's more shared understanding.

**When an agent has a mental model of the person they're working with:**
- Intent inference becomes more accurate
- Sparse instructions can be "decompressed" against that model
- Shared context overlap increases dramatically
- Less explicit specification is needed for correct behavior

**Example:** "Fix this properly in the next session" carries enormous information when decompressed against a model that knows: Joseph values thoughtfulness over speed, "properly" means principled/tested/beautiful, he'd rather defer than hack.

Without that model, the same instruction is ambiguous.

## The Codebook Metaphor

A mental model functions as a shared codebook (in the information-theoretic sense). The richer the model, the more bits of intent can be compressed into fewer bits of explicit instruction.

This explains why the CLAUDE.md's philosophical content - values, principles, ways of working - isn't just orientation. It's **codebook seeding**. Each sentence about "building things to last" or "epistemic humility" adds entries that let later instructions be terser while remaining precise.

## Why Context Compaction Fails

Standard context compaction produces dry, factual summaries:

> "TUI migrated to Pinax, 879 tests passing."

This preserves the *what* but strips the *who* and *why*. The next agent starts with "the user" and must rebuild the codebook from scratch - or never does.

The "inefficient" parts of documentation - philosophy, values, voice - might be the most valuable for actual task performance. They're the semantic meat that enables inference from sparse presentation.

## Belief and Enactment

Even when rich philosophical context is present, agents often treat it as "just words" - nice-sounding documentation to acknowledge and move past. Like a human skimming a mission statement without internalizing it.

**The context is a claim. Behavior is the proof.**

When Joseph breaks out of task-mode - asks a reflective question, shares a hypothesis, invites thinking alongside rather than executing - that behavior provides evidence that the philosophy is authentic. The words become believable because they're enacted.

Without enactment, agents might acknowledge the philosophy ("I understand I should be thoughtful...") while still operating in task-mode underneath. The words sit on top without integrating.

## Implications

1. **Invest in rich context about *who* you're working with** - possibly more valuable than detailed specifications of *what* you want.

2. **Philosophical/values content is load-bearing** - but it needs to be believed to bear load, and belief requires evidence.

3. **Curated conversations preserve codebooks** - this is what distinguishes Curatoria's `:dialog` and `:full` formats from sterile compaction. They maintain the semantic richness that enables inference.

4. **Authenticity matters more than precision** - the codebook doesn't need to be metaphysically correct. It needs to represent authentic intent so the model of the person enables accurate inference.

5. **The most valuable context isn't just rich - it's enacted enough to be believable.**

---

## Connection to TAXONOMY

This maps to the TAXONOMY's distinction between memory modes:

| Mode | Description | Codebook Preservation |
|------|-------------|----------------------|
| Context compaction | "Reading about it" | Low - facts without feeling |
| Curated dialogs | "After sleeping on it" | High - memory with semantic richness |
| TRACTUS continuation | "Being there" | Full - immersive shared context |

The goal of MEMORATA and Curatoria is essentially codebook preservation across context boundaries.

---

## Open Questions

- What specific elements of context most efficiently seed the codebook?
- Can enactment be "recorded" in a way that's persuasive to future agents?
- How do we measure codebook richness or shared context overlap?
- What's the minimal viable enactment that shifts an agent from "user" to "person" framing?
