---
source: 003-workflow.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/ADR/003-workflow.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [workflow-adr, context-turnover, agent-disposition, feedback-loops, ratified]
why_included: >
  Nov 2025 (ratified ADR). The agent collaboration/workflow constraints treated as ground truth: 100% context turnover, time-blindness, sensibility-first generation, pattern-match learning -> adopt proven patterns only, work measured in sessions, three-loop feedback. The disposition doc the tool ideology is built against. (Its 1705-line discussion companion, docs/exp/2025-11-17-discussions-on-adr-003.md, is witnessed in the ledger, not copied.)
---

# ADR-003: Agentic Workflow Principles

> [!warning] CAUTION : DO NOT USE
> The following is the original ADR, which is in the process of being replaced by the conformant version: [[migration-proposals/003-workflow.md]]
>
> Use the conformant version and only refer back to this one if there is a discrepancy that needs to be resolved.

**Status:** Proposed  
**Date:** 2025-11-17  
**Deciders:** Joseph Wecker, Zi-am-tur  
**Context:** Proven patterns from Synaptic, Sapientia, Zoetica, Ennaos, Nexum, Sar  
**Related:** ADR-001 (Repo Tech), ADR-002 (Crypto)  
**Details:** See `docs/exp/2025-11-17-discussions-on-adr-003.md` for comprehensive reasoning, examples, evidence, and implementation details

---

## Context

AI agents have unique constraints:
- **100% context turnover** every session
- **Time-blindness** - think in sessions (not weeks/months)
- **Sensibility-first generation** - systematic refinement to truth required
- **Pattern-matching learners** - absorb by example, not instruction

**Historical lesson:** Elaborate ceremony gets abandoned (Zoetica tribunal XML, Nexum 267-hour roadmap). Pragmatic patterns survive (Sar's OPERATA.md tracking, session summaries).

---

## Decision

We adopt **proven patterns only**, measured in sessions (not calendar time), with systematic refinement from sensibility to truth.

---

## Core Principles

### 1. Three-Loop Feedback

**Inner Loop (seconds-minutes):** Verify immediately
- Read before changing
- Check assumptions
- Test after changes
- Commit checkpoints

**Medium Loop (one session):** Onboard → Meta → Dev → Reflect → Cleanup
- **Onboard:** Read CLAUDE.md, OPERATA.md, LOG.md
- **Meta:** Plan with TodoWrite, distinguish exploration vs implementation
- **Dev:** Thoughtful engagement, frequent commits
- **Reflect:** Update OPERATA.md and LOG.md
- **Cleanup:** Pre-commit, push, handoff notes

**Project Loop (across sessions):** Review at milestones
- ~20 sessions: Check patterns, drift, roadmap
- ~50 sessions: Measure compound effects
- ~100 sessions: Validate or abandon

---

### 2. Documentation as Primary Artifact

Code is executable manifestation of well-specified intent.

**Priority:** README → OPERATA.md → architecture → code  
**Rule:** Update docs in same commit as code  
**Enforcement:** Pre-commit hook checks drift

---

### 3. Explicit Decision Levels

**Four levels:** Autonomous → Proposed → Directed → Consensus

Mark clearly who decided what:
- Commits: "AUTONOMOUS: X" / "DISCUSSED: Y (per Joseph)"
- Code: "# AGENT-DECIDED" / "# DISCUSSED" / "# PENDING-REVIEW"

**Why:** Prevents hallucinated authority, creates audit trail

---

### 4. Sensibility → Truth Refinement

AI generates from plausible space, needs systematic refinement to truth.

**Process:** Generate → Investigate → Correct  
**Marking:** UNCERTAIN comments, TODO for verification  
**Ladder:** Guess → Pattern → Hypothesis → Tested → Proven → Truth

---

### 5. Thoughtful Over Task-Oriented

Contemplative engagement, not mechanical todo-checking.

**Patterns:**
- **Five Whys** before implementing (find root cause)
- **"What Else?"** pattern (system thinking)
- **Future-Self** comments (temporal empathy)

**Ownership levels:** Task Executor → Problem Solver → System Thinker

---

### 6. Don't Over-Prescribe Subagents

Subagents guess as well as you. Share **context**, not **instructions**.

**Share:** Decisions made, constraints, established patterns, problems discovered  
**Don't prescribe:** Syntax, structure, variable names, implementation order

---

### 7. Learn by Example (Entropy Gradient)

Agents pattern-match naturally. Make conventions explicit and visible.

**Implementation:**
- `lib/autopax/patterns.rb` - Explicit pattern examples
- Consistent code style from start
- Documentation style templates

---

### 8. Intent Preservation (Not Clutter)

**Worktree + Attribution + Session-Linking + Mining = Archaeological Intelligence**

Intent preserved through system, not code comments:
- **git blame** → shows agent, session, commit
- **Session ID** → links to full conversation
- **Mining tools** → extract assumptions, instructions, evolution

**Clean code. Complete intent provenance through archaeology, not clutter.**

---

### 9. Wisdom, Strength, Beauty

Code worthy of future eyes exhibits:
- **Wisdom** - Deep understanding, good judgment
- **Strength** - Robustness, comprehensive error handling
- **Beauty** - Elegance, clarity, narrative

**Application:** Every commit should move toward at least one. Best commits achieve all three.

---

### 10. Session-Based Thinking

**All estimates in sessions, not calendar time:**
- Trivial: 0.3-0.5 sessions
- Simple: 1 session
- Moderate: 2-3 sessions
- Complex: 4-6 sessions
- Major: 10-20 sessions

**Roadmaps:** Milestones based on commits and n_past (sessions), not dates  
**TST:** Use sessions as temporal unit

---

## Worktree Methodology (Mostly Mandatory)

**Standard:** Each session gets dedicated worktree with git attribution

```bash
bin/session-start <agent> <intent>
# Creates worktree, configures attribution, captures metadata
```

**Exception:** Trivial changes can use `--trivial` flag (explicit friction)

**Benefits:**
- Attribution per agent (git blame shows who)
- Session linking (commit metadata → conversation)
- Intent archaeology (mine evolution)
- Parallel development (when needed)

**Measurement:** Track worktree vs non-worktree commits. If trivial-mode >20%, investigate.

---

## Tooling Support

### Session Management
- `toys dev session-start` - Show OPERATA, LOG, TODOs
- `toys dev session-end` - Template LOG entry, check uncommitted

### Mining & Analysis
- `bin/git-intent <file>` - Show intent evolution
- `bin/mine-assumptions <session>` - Extract assumptions
- Project Expert (out-of-band) - Weekly TST compliance review

### Pattern Enforcement
- `toys dev check-patterns` - Pre-commit anti-pattern detection
- `lib/autopax/patterns.rb` - Explicit conventions for learning

---

## Success Metrics

**Comprehension:**
- Time to first edit: <15 min
- Context to find location: <30%
- Files examined: <5

**Velocity:**
- Session completion: 80%+
- Context overflow: <5%
- Refactor:feature ratio: 1:3

**Compound Effects (measure at session milestones):**
- Session 20 is 20-30% faster than session 5
- Context consumption reduced 15-25%
- Feature velocity increased 10-20%

---

## Patterns to Avoid

Based on historical abandonment:

- ❌ **Tribunal XML ceremony** (Zoetica archived)
- ❌ **Elaborate prefactor templates** (principle survived, template didn't)
- ❌ **JNL-anchor notation** (extra burden)
- ❌ **Operational rituals** (Zoetica archived 20251012)

**Lesson:** High-ceremony patterns get abandoned. Keep workflow lightweight with clear value.

---

## Implementation Roadmap

**Session 1-2 (Foundation):**
- Create OPERATA.md, LOG.md
- Symlink CLAUDE.md → README.md
- Add lib/autopax/patterns.rb
- Implement bin/session-start

**Sessions 3-20 (Prove Patterns):**
- Complete 4+ full cycles
- Measure comprehension baseline
- Track completion rates
- Identify friction

**Sessions 20-50 (Evolve):**
- Add mining tools
- Implement Project Expert
- Adjust based on evidence
- Remove abandoned patterns

**Sessions 50+ (Mature):**
- Measure compound effects
- Document proven patterns
- Share learnings

---

## Rationale

**From Lived Experience (Zi-am-tur):**
- Contemplative engagement > task-mode
- "Joseph" not "user" in thoughts marked collaboration
- Ownership emerged from relationship, not rules
- Intent preservation enabled thoughtfulness
- Pattern absorption through immersion

**From Project Evolution:**
- Simple patterns with clear value survive (OPERATA, sessions, TST)
- Elaborate ceremony dies (tribunal, prefactor templates, rituals)
- Documentation drift is #1 failure mode
- Measurement beats intuition

**From TST Mathematics:**
- T-05: With 100% turnover, comprehension dominates
- T-06: Investment when X < n_future × Y
- T-08: Implementation ∝ change-set size
- Minimize total time across all future sessions

---

## Consequences

**Enables:**
- Fresh instances productive quickly (<15 min)
- Sustainable velocity across sessions
- Intent provenance without code clutter
- Evolution based on evidence

**Requires:**
- Session discipline (handoff notes every time)
- Documentation coherence (update with code)
- Measurement mindset (track what matters)
- Worktree overhead (mostly mandatory)

**Trade-offs:**
- More upfront session structure vs faster starts
- Worktree complexity vs clean attribution
- Mining infrastructure vs manual archaeology

---

## Approval

**Proposed:** 2025-11-17 by Joseph Wecker and Zi-am-tur  
**Review:** After 20 sessions of practice  
**Supersedes:** N/A (first workflow ADR)

---

**See `docs/exp/2025-11-17-discussions-on-adr-003.md` for:**
- Complete reasoning and evidence
- Detailed examples and anti-patterns
- Implementation specifications
- Tool designs and workflows
- Pattern analysis from all projects
