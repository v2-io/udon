---
source: sar (archived "AI-FIRST" BEAM language project) — docs/ai-tst-ideas-and-opportunities.md
gathered: 2026-07-21
status: gathered — partial excerpt (source is ~1022 lines / 26KB). The Architectural
  Principles (A-01..A-05), Anti-Patterns (AP-01..AP-04), and the context-window-limit /
  multiplier tables in this file are near-verbatim duplicates of the sibling
  ai-applied-tst excerpt and are NOT re-copied here; only this file's *unique* material
  (the measurement framework, the concrete "Tools to Build", the A/B experiment designs,
  and the honest measurement-challenges section) is captured.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-tst-ideas-and-opportunities.md
source_commit: 3840e23
categories: [tier1-ideology, agent-tooling-design, measurement-framework, developer-eval-harness,
  ab-testing, context-budget, agent-ergonomics, honest-uncertainty]
why_included: >
  ~2025-11-10. The practical companion to ai-applied-tst. Its unique value is a concrete
  catalog of *tools to build for an agent-driven workflow* (velocity tracker, pre-factoring
  detector, coupling analyzer, context-budget estimator, session-outcome analyzer, change-
  pattern templates) and a *measurement framework* for agent development (velocity trajectory,
  TURNS-per-feature, waste %, churn rate, exploration scatter, onboarding cost, knowledge-
  capture success). Directly on-target for the harness programme's "what makes an agent
  loop legible/measurable" question, and it is unusually honest — a whole section admits the
  measurement problems it can't yet solve. That honesty (dry-well-in-the-open) is itself the
  quality the compilation prizes.
---

> **Editorial.** Copied here: the material this file adds *beyond* its sibling. The
> overlapping A-01..A-05 / AP-01..AP-04 / context-window tables are captured once, in
> `sar-ai-applied-tst-excerpt.md`. What follows — measurement framework, tools-to-build,
> A/B experiments, and the "honest about difficulty" challenges — is unique to this file.

---

# AI-TST Ideas & Opportunities (unique material)

## Measurement Framework — what we can measure

**1. Velocity Trajectory (Primary Metric)**
```
velocity(N) = features_delivered (quality-adjusted) / tokens_consumed
Track over rolling window (last 10 sessions): increasing (virtuous) / stable / decreasing (vicious)
If decreasing → Priority is capacity restoration, not more features
```

**2. Feature Throughput (quality-adjusted)** — features per 100k context tokens, weighted by a
quality score (1.0 working+tested+documented+best-practices … down to 0.0 broken).

**3. Waste Percentage** — tokens consumed with zero forward progress / total. Waste =
churning (undo then redo), blocking (gave up, no diagnostic captured), dead ends (failed, no
learning). *Requires LLM analysis to distinguish productive failure from waste.*

**4. TURNS Efficiency** — tool calls per feature delivered. Lower TURNS = better tools,
clearer process; more stable than token counts across model versions. Measured by counting
tool-use blocks in session JSONL. *Unknown: what's a "good" TURNS/feature ratio.*

**5. Knowledge Capture Success** — binary: did the next session successfully continue the
work? Observable via commit messages with reasoning, diagnostics when blocked, docs
reflecting current state, clear continuation TODOs.

**6. Onboarding Cost** — tokens from cold start → first productive tool use. Should decrease
as documentation improves; if it *increases*, docs are accumulating without clarity.

**7. Exploration Scatter** — number of distinct files read before finding the correct entry
point. High scatter → poor architecture or documentation.

**8. Churn Rate** — lines added then deleted in same session / total lines changed
(`git log --numstat`). Some churn is productive; excessive churn suggests confusion.

### What We Don't Know Yet
What constitutes a "feature"? What's the right measurement unit (tokens / TURNS / time)?
How to attribute outcomes across multi-session features? Causation vs correlation
("sessions with early TodoWrite succeed more" — cause or effect?)? How to measure what
*didn't* happen (bugs prevented, dead ends avoided)?

## Tools to Build (concrete agent-workflow tooling designs)

**Priority 1: Velocity Tracker** — `sar-velocity track` reports per-session
features/100k-tokens trajectory (INCREASING/virtuous, growth %); data source is historical
session JSONL + git history; requires an LLM to identify features delivered per session.

**Priority 2: Pre-factoring Opportunity Detector** — `sar-prefactor suggest --feature="…"`
analyzes entry points, detects duplication, suggests a zero-external-change refactor that
would make the feature obvious, with estimated cost/savings and n_future ROI.

**Priority 3: Coupling Analyzer** — `sar-analyze coupling --threshold=0.6` surfaces
high-coupling pairs from git co-occurrence and recommends merge / extract-shared-interface.

**Priority 4: Context Budget Estimator** — `sar-context estimate "Add YAML parsing"` predicts
files/lines/tokens from similar historical features, reports current fill and a completion
probability, and recommends a monitor threshold.

**Priority 5: Session Outcome Analyzer (LLM-powered)** — `sar-analyze session-outcomes
--last=50` classifies historical sessions (High-value / Productive / Partial / Blocked /
Waste) with mean TURNS/feature per class, and mines patterns ("sessions with early TodoWrite
< 10k tokens have 2x higher success rate").

**Priority 6: Change Pattern Templates** — `sar-analyze patterns` mines common change patterns
(e.g. "Add FFI binding, 43 occurrences, mean 156 lines/3 files"); `sar-template generate
ffi-binding --name=…` scaffolds the recurring shape.

## A/B Testing Experiments (agent-eval methodology)

**Framework:** parallel git worktrees, each with a different setup (documentation style,
code organization, tool availability, workflow guidance). Measure features delivered,
tokens/feature, quality scores, TURNS/feature, knowledge capture. Statistical analysis:
t-test on means, α = 0.05, minimum N=10 trials per variant.

- **Experiment 1 — Documentation Density:** verbose (31.5k pre-load) vs TL;DR (22k) vs
  minimal (15k); task held constant; measure onboarding cost, total tokens, quality,
  next-session continuation.
- **Experiment 2 — Pre-factoring Effectiveness:** Agent-1 pre-factors + Agent-2 implements
  vs a single agent implementing directly in messy code; hypothesis Tokens(A1+A2) < Tokens(B).
- **Experiment 3 — TodoWrite Workflow:** upfront vs adaptive vs none.
- **Experiment 4 — Tool Availability:** all tools vs {Read,Edit,Write,Bash} vs
  domain-specific only. *Hypothesis unclear — too many tools might confuse, too few handicap.*

## Measurement Challenges (honest about difficulty)

1. **Feature Attribution** — features span sessions; pro-rate, credit-completer, or track
   in-progress? Unknown which is correct.
2. **Quality Assessment** — score for "works in simple case, fails edge cases"? "no tests but
   looks correct"? thresholds are arbitrary, need calibration.
3. **Value Estimation** — user-assigned vs inferred-from-n_past vs impact-measured; none perfect.
4. **Causation vs Correlation** — only controlled experiments establish it, and even then
   external validity is uncertain (YAML bindings ≠ architecture redesign).
5. **Novelty vs Routine** — measuring tokens/feature without accounting for difficulty wrongly
   concludes novel work is "inefficient." Categorize by feature type; use n_past as difficulty proxy.
6. **Meta-Work Valuation** — this document consumed ~25k tokens; did it produce a "feature"?
   Some valuable work is genuinely hard to quantify.
