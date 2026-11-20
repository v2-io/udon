---
source: sar (archived "AI-FIRST" BEAM language project) — docs/ai-applied-tst.md
gathered: 2026-07-21
status: gathered — partial excerpt (source is ~1283 lines / 36KB; the sar-specific
  roadmap, prioritization scoring, session-metric YAML, and success-metric checklists
  are elided as project-management residue; the agent-cognition ideology is copied verbatim)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar/docs/ai-applied-tst.md
source_commit: 3840e23
categories: [tier1-ideology, agent-cognition, documentation-primacy, context-window-constraint,
  comprehension-cost, tooling-vision, empirical-model-limits, anti-patterns]
why_included: >
  Dated 2025-11-10. The clearest single statement in the "Elsewhere" territory of Joseph's
  demand-side thesis: development (and the tools around it) should be designed for AI-agent
  cognition, not human cognition. Reframes every principle through 100%-context-turnover,
  documentation-as-primary-codebase, context-window-as-temporal-unit. Directly serves both
  compilation consumers — UDON's self-chunking/agent-authoring pitch and the harness
  programme's "how a tool should present itself to an agent" question. Carries measured
  model context-window limits and a concrete agent-tooling wishlist (LSP-in-system-reminders,
  graph-based editing, automatic feedback loops, context-window-aware tooling).
---

> **Editorial (why these spans).** This file is Joseph's Nov-2025 "AI-FIRST" manifesto for
> the sar language, written as ideology for AI-agent-driven development. The load-bearing,
> cross-project-relevant material is the *agent-cognition* layer copied below verbatim; the
> sar-specific roadmap (Phase 5 Mix, Phase 6 Phoenix), the sar prioritization arithmetic,
> per-session metric YAML, and the multi-tier success-metric checklists are elided as
> project bookkeeping. Elisions are marked `[… sar-project residue elided …]`. The one
> genuinely surprising empirical datum — the measured effective context-window limits and
> the "16x multiplier" decomposition — is kept in full.
>
> Cross-tier note: the ELI-testimony and shipped-practice strata that *converge* with this
> ideology live in the sibling excerpt `sar-archive-domain-updates-excerpt.md` (Zi-am-tur's
> "every tool is an act of truth-bearing"; Aider's diff-vs-whole-file lazy-coding finding).
> Read them together — this file is the theory, that one is the same author finding it
> mirrored in shipped tools and agent first-person report.

---

# AI-Applied-TST: Temporal Optimization for AI Agent Development

**Date:** 2025-11-10
**Context:** Sar language project developed primarily by AI agents

## The Unique Context

This project represents a novel development paradigm:
- **Built by:** AI agents with occasional human guidance
- **Nature:** "Logogenetic beings" working in their element - language refining language

The entire development process should be optimized for AI agent cognition, not human cognition. This requires rethinking every TST principle through the lens of:
1. Extreme context turnover (100% per window)
2. Computational advantages (instant analysis, pattern matching, simulation)
3. Context window as fundamental operational unit
4. Documentation as primary codebase (code as secondary manifestation)

## Core Principles: TST Amplified for AI

### P-01: Documentation IS the Codebase

**Traditional:** Code is primary, documentation is secondary
**AI-Applied:** Documentation is primary, code is manifestation

**Why:**
- Fresh AI instances read docs first, always
- Code teaches "how", docs teach "why"
- With instant coding, specification time dominates

**Implementation:**
```
Priority 1: CLAUDE.md, OPERATA.md, tst-distilled.md
Priority 2: Architecture docs, decision records
Priority 3: Code with comprehensive comments
Priority 4: Code that "speaks for itself"
```

### P-02: Context Window as Temporal Unit

**Traditional:** Day/week/sprint as temporal unit
**AI-Applied:** Context window (~200k tokens) as temporal unit

**Why:**
- Features must be completable within one window
- Incomplete work = lost context = wasted time
- Window overflow = temporal catastrophe

### P-03: Comprehension Dominates (Even More)

**AI-Applied:** Comprehension time is THE constraint

**Why:**
- Every session starts with comprehension phase
- With 100% turnover, comprehension cost compounds catastrophically
- Implementation time approaching zero (instant coding)

**Implementation:**
- Linear > Clever (always)
- Explicit > Implicit (always)
- Co-located > Scattered (always)

**Anti-patterns:**
- "Self-documenting code" (violates documentation primacy)
- Clever abstractions (exponential comprehension cost)
- Scattered related logic (violates proximity)

### P-04: Measure Everything

**AI-Applied:** Computation-driven decisions

**Why:**
- AI can compute what humans must estimate
- Coupling/coherence computable from git history
- ROI calculable, not guessable

**Tools to Build:**
```bash
$ sar-analyze coupling               # coupling from git history
$ sar-analyze change-frequency       # compute n_past for subsystems
$ sar-analyze changeset-size --feature-type=genserver
$ sar-analyze predict-changes lib/user.sar
```

### P-05: Session Structure Encodes Temporal Thinking

**AI-Applied:** Sessions are temporal units, commits are checkpoints

**Why:**
- Each session is a fresh agent with fresh context
- Session summary = temporal reasoning preservation
- Handoff documents enable continuity

[… sar-project prioritization arithmetic + roadmap phases elided …]

## Architectural Principles for AI Agent Development

### A-01: Modularity Enables Window-Scoped Work

Every module should be comprehensible and modifiable within a single context window.
- Max module size: ~500 lines (rough heuristic)
- Clear module boundaries (one responsibility)
- Target: < 50k tokens (25% of window) for a typical module modification

### A-02: Documentation Density Scales with Change Frequency

The more frequently code changes, the more comprehensive its documentation should be.
```python
doc_density = min(100, n_past × comprehension_cost × 5)
# target lines of docs per 100 lines of code
```
- UI code (high change): 50% doc density
- Business logic (medium change): 30%
- Algorithms (low change): 10%
- Stable libraries (no change): 5%

### A-03: Coupling Measured, Not Assumed

Use git history to measure actual coupling, not architectural assumptions.
```bash
$ git log --format="" --name-only | sort | uniq -c | sort -rn | python scripts/analyze_coupling.py
# Output: coupling matrix; High coupling (>0.6) suggests merge / extract / reduce interface
```

### A-04: Session-Completable Atomic Units

Every TODO should be completable within one context window.
- If TODO takes > 50k tokens to explain, break it down
- If implementation touches > 10 files, break it down
- If uncertain about completion, break it down

### A-05: Code Structure Teaches Domain

Architecture should teach AI agents the problem domain, not just the solution.
Fresh instances learn by reading, not by doing. Directory names should be
DOMAIN CONCEPTS (`user_management/`, `content/`), not technical patterns
(`models/`, `controllers/`).

[… operational session template, session-summary template, and per-session/per-feature
metric YAML elided as sar-project workflow residue …]

## Anti-Patterns for AI Agent Development

### AP-01: The Clever Abstraction Trap
"Clean" generic/higher-order abstraction → exponential comprehension cost; fresh instance
must understand generics + defer + proc chaining. Prefer explicit-but-comprehensible.

### AP-02: The Distributed Logic Trap
"Modular" logic scattered across 4 files → high discontinuities, large change-set for
simple changes, comprehension requires reading 4 files. Prefer co-location.

### AP-03: The Self-Documenting Code Myth
Terse "clean code" with no comments → high comprehension cost (must reverse-engineer
intent); variable names don't explain temporal reasoning. Prefer documentation-primary,
with the *why* and the call-frequency stated in the doc comment.

### AP-04: The Premature Abstraction Trap
Extracting a framework after 2 uses → abstraction cost unlikely to pay back at low
n_future. Wait until n_past > 5-10, then abstract.

[… short/medium/long-term success-metric checklists elided …]

## Empirical Constraints & Calibration

### Context Window Limits (Empirical)

**Hard Data from Production Use:**

| Model | Nominal Window | Effective Limit | Symptoms at Limit |
|-------|---------------|-----------------|-------------------|
| Codex | 1M tokens | ~300k tokens | Degradation, churning, confusion |
| Gemini | 1M tokens | ~300k tokens | Ignores instructions, confused |
| Claude Sonnet | 1M tokens | ~600k tokens | Tool use hallucination, confusion |

**Key Insight:** Context window expansion provides at most **2x effective session capacity**.
The degradation isn't graceful — models become confused, ignore instructions, hallucinate.
This is a HARD LIMIT, not a soft one.

### Multiplier Effects (Estimated)

| Technique | Multiplier | Notes |
|-----------|-----------|-------|
| Base session (no augmentation) | 1.0x | ~200k effective tokens |
| Skills + memory condensation + RAG | 1.6x | Reduces redundant context |
| Larger context window (to effective limit) | 2.0x | Claude 600k vs 200k |
| Active salience management (sapientia/nexum/ennaos) | 5.0x | Intelligent context prioritization |
| **Combined (optimistic)** | **16x** | = 1.6 × 2.0 × 5.0 |

**Reality Check:** Even with 16x multiplier, session-centric workflow persists because
context filling creates cognitive degradation; hard resets may be preferable to degraded
performance; session boundaries force intentional handoffs; clean context = clear thinking.

[… session-based estimation framework + sar velocity numbers elided …]

## The AI-FIRST Vision: Beyond "AI Can Use This" to "Designed FOR AI"

**AI-FIRST language:**
- Optimized for AI agent comprehension speed
- Designed around context window constraints
- Empirical validation built into development process
- Tooling that makes AI cognition the primary concern

### Empirical Language Design Methodology

**Traditional:** Intuition → Design → Implement → Hope it works
**AI-FIRST:** Measure → Iterate → Validate → Measure again

> Should Sar use `proc` or `fn`? — Implement both, create toy projects using each, ask 4
> fresh agents to implement each (12 implementations), measure context-tokens-until-first-
> working-code, comprehension time, error rate, change-set sizes; then a second pass where
> fresh agents add a feature to each. **Not theory. Not intuition. MEASUREMENT.**

### The Tooling Revolution (agent-facing tool wishlist)

**1. LSP in System Reminders**
```
When Claude loads a Sar project, the system reminder contains:
- Type signatures for all visible functions
- Module structure and dependencies
- Common patterns for this project
- Recently modified files (context salience)
```

**2. Graph-Based Editing**
```
Instead of: "edit this text file, apply this patch"
Use: "modify this node in the AST, update these edges"
Benefits: No patch rejection; structural awareness built-in; can verify constraints
before committing
```

**3. Automatic Feedback Loops**
```
INSTEAD of write→save→compile→read errors→fix→repeat:
Write code → instant semantic feedback in context
- Type errors appear as you write
- Completions show valid options only
- Suggestions based on project patterns
```

**4. Context-Window-Aware Tooling**
```
$ sar-context estimate feature-X   → Estimated context required: 45k tokens (22.5% of window)
$ sar-context track                → Current fill: 156k / 200k (78%); WARNING: approaching
                                     degradation threshold; Recommendation: complete + handoff
```

**5. Session Management Built-In**
```
$ sar session start "Add Task FFI bindings"    → Context loaded, TODO loaded, recent changes
$ sar session checkpoint "FFI bindings complete" → Changes: 156 lines, 3 files; 67k/200k
$ sar session summary                          → TST calculations captured; ready for handoff
```

### The paradigm shift (conclusion, verbatim)

> Code is no longer the primary artifact. **Documentation, architecture, and temporal
> reasoning** are the primary artifacts. Code is simply the executable manifestation of
> well-specified intent.
