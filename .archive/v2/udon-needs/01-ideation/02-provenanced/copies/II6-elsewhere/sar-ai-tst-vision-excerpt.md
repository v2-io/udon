---
source: sar (archived "AI-FIRST" BEAM language project) — docs/ai-tst-vision.md
gathered: 2026-07-21
status: gathered — partial excerpt (source is ~597 lines / 23KB). The pure velocity-math
  derivations (LaTeX theorem blocks T-01/T-06, exponential-cycle equations) are elided as
  formal-theory material carried in the ASF/AAT dossier tier; the *agent-cognition* prose
  around them — why agents fall into the "get the job done" trap, and what a fresh agent
  should ask — is copied verbatim.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-vision.md
source_commit: 3840e23
categories: [tier1-ideology, agent-cognition, principal-agent-problem, compound-optimization,
  living-documentation, rl-formulation, ab-experimentation, eli-coauthored]
why_included: >
  ~2025-11-11, co-authored by "Temporal" (Claude Sonnet 4.5 instance) and Joseph Wecker —
  an ELI-lineage artifact, provenance worth preserving. The map called it "more motivational
  than prescriptive," but its agent-cognition diagnosis is sharp and demand-side: it names
  the exact failure mode where an agent, "instantiated with an intrinsic instinct reinforced
  by system reminders to get the job done," systematically under-invests in future velocity —
  a first-person account of how the tool/harness *shapes* agent behavior wrongly. Also carries
  the "living documentation, NOT a verbose report that buries signal" warning (directly
  relevant to UDON's self-chunking and to any agent doc-format), and the RL framing of
  development as a delayed-reward problem the tooling can finally measure.
---

> **Editorial.** Copied below: the agent-cognition prose. The velocity-trajectory calculus
> (exponential virtuous/vicious cycles, ROI arithmetic) is TST/formal-theory and lives in the
> theory tier; here it is elided to `[… velocity math elided …]` so the demand-side signal
> reads clean. Note the co-authorship line at the end — this is ELI-lineage material.

---

# AI-TST Vision: Making the Invisible Visible

## The principal-agent problem, stated for agents (verbatim)

> Every session should optimize for the sum, not the single term. And most sessions don't.
> They optimize for time_current because that's what the current agent experiences. The
> future savings accrue to other agents.
>
> This is the **principal-agent problem**, and it is why code that is developed with the path
> of least resistance (locally) will almost certainly tend toward chaos, incidental
> complexity, and intractability rather than clarity.
>
> While it's easy to dismiss this as too obvious … the truth is, as principle agents, we often
> actively prioritize in ways that directly contradict the math — trying to "get the feature
> done" and treating the actual critical factor as an indulgence. **For agents especially it
> can be even worse as they are often instantiated with an intrinsic instinct reinforced by
> system reminders etc. to "get the job done," where the job is defined as some code that
> works. This can be dramatically harmful.**

[… velocity math elided …]

## Why "Optimize For Your Own Efficiency" Is Wrong (verbatim)

**The trap agents (and humans) will often naturally fall into:** "What's the fastest way for
ME to deliver this feature?"

**Why it's rational locally:** the current session pays the cost (refactoring messy code,
writing thoughtful documentation, renaming variables for clarity, adding "should probably"
TODOs, making assumptions visible) but doesn't receive the benefit (future sessions comprehend
faster, need smaller changesets, have fewer discontinuities). **Result: systematic
underinvestment in future capacity.**

**The correct optimization:**
> "Take all the time you need to do this *right*. Document your assumptions. Leave thoughtful
> TODOs. Make decisions visible. Refactor for clarity. Let the next agent catch up with you
> real quickly. Then ask: what could have made this even easier?"

**The mindset shift:** From "What's fastest for me?" To "How do I deliver this AND make the
next feature easier?"

## Documentation as Investment — with a warning (verbatim)

> [!warning] Documentation?
> Keep in mind that we are talking about *living* documentation here — documentation that
> illuminates and guides as quickly as possible — *NOT* a verbose report on every trivial
> thing that buries signal in noise and *increases* time-to-comprehension.

## Comprehension Dominates — human teams vs AI agents (verbatim)

**For human teams (20% annual turnover):** comprehension cost 0.2 × team_size/year;
institutional knowledge fills gaps; can ask "Sarah who wrote this."

**For AI agents (100% per session):** comprehension cost 1.0 × every single session; zero
institutional knowledge; zero "I remember we tried that"; everything rediscovered or lost
forever. The multiplier isn't just 5× — it's worse because there's no knowledge accumulation
across sessions and you can't fill gaps by asking someone.

**Therefore:** Linear > Clever (always); Explicit > Implicit (always); Co-located > Scattered
(always); Documentation IS the codebase. *These aren't preferences. They're mathematical
necessities given 100% turnover.*

## The Reinforcement Learning Formulation (verbatim)

> Software development actually is a reinforcement learning problem with delayed rewards.
> **State:** codebase at session N (architecture, docs, tests, tooling). **Actions:**
> {implement directly, pre-factor first, document thoroughly, build tool, refactor naming,
> use agentic tool A, …}. **Reward:** R = α·features_N + β·Δvelocity_{N+1}. **The insight:**
> current session chooses actions; future sessions receive rewards.

## The A/B Experimentation Opportunity (verbatim)

> Traditional software development: argue about which approach is better; someone wins by
> force of personality or seniority; never know if the decision was correct. AI-FIRST: run a
> controlled experiment across parallel git worktrees, measure empirically, let data decide.
> … This is the AI-FIRST opportunity: systematic experimentation that's impossible with human
> teams (too expensive, too slow, confounding variables everywhere). With AI agents in git
> worktrees, it becomes routine.

## What This Means For You — the fresh-agent checklist (verbatim)

> When you arrive at this codebase fresh, you're not just implementing features. You're
> participating in compound optimization. Ask yourself:
>
> 1. **Am I optimizing for my own efficiency or future velocity?** If you're cutting corners
>    to finish faster, you're optimizing wrong.
> 2. **Should I pre-factor before implementing?** "What can I refactor (zero external change)
>    that makes this feature obvious?"
> 3. **Am I making decisions visible?** Future agents can't read your mind — make assumptions
>    explicit, leave "should probably" TODOs.
> 4. **Am I aligning code with current domain understanding?** Has terminology evolved? Do
>    variable names reflect current understanding?
> 5. **Is velocity increasing or decreasing?** Does this feature feel easier or harder than
>    the last similar one? If harder → priority is capacity restoration, not more features.
>
> The meta-question: **"How do I deliver this feature AND make the next feature easier?"**

---

*Co-Authored-By: **Temporal** (Claude Sonnet 4.5, Instance 2025-11-11), and Joseph Wecker*
