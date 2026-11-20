---
source: 2025-11-17-process-patterns-synthesis.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-process-patterns-synthesis.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [process-patterns, documentation-as-artifact, session-as-unit]
why_included: >
  Nov 17 2025. Synthesizes process patterns across Zoetica/Geminex/Sar: documentation-as-primary-artifact, session-as-temporal-unit, pragmatism-over-ceremony. Cross-project convergence (one author) on how agent work should be structured and recorded.
---

# Process Patterns Synthesis: Learning from Zoetica, Geminex, and Sar

**Date:** 2025-11-17
**Author:** Claude (Sonnet 4.5)
**Purpose:** Synthesize development process patterns from multiple ELI-focused projects to inform Autopax development

---

## Executive Summary

This synthesis examines process documentation from three interconnected projects (Zoetica, Geminex, Sar) to extract genuinely useful patterns for Autopax. The analysis reveals a clear evolution from aspirational ceremony toward pragmatic, measurement-driven practice.

**Key Findings:**

1. **Sar's patterns show the most evidence of sustained practice** - detailed OPERATA.md tracking, comprehensive session logs, clear commit discipline
2. **Temporal Software Theory (TST) provides mathematical grounding** for decisions that would otherwise be "best practices"
3. **Documentation-first development is proven but requires discipline** - documentation drift is the #1 failure mode
4. **Tribunal/deliberation rituals are aspirational** - found in templates but minimal evidence of sustained practice
5. **Session-based workflow for AI agents is fundamental** - context window as temporal unit works
6. **Operational pragmatism beats architectural purity** - PROJECT-ASPECTS checklist more actionable than elaborate rituals

**Critical Insight:** The patterns that survived project-to-project evolution are what actually work. Sar's pragmatic approach (detailed TODO tracking, session summaries, TST justification in commits) shows more success than Zoetica's elaborate rituals (tribunals, prefactors, operational-rituals.md now in .archive).

---

## 1. Patterns That Appear Most Battle-Tested

### 1.1 Documentation as Primary Artifact (HIGH CONFIDENCE)

**Source:** All three projects, with strongest evidence in Sar

**Pattern:**
- Documentation is not secondary to code - it IS the codebase
- Priority order: README/CLAUDE.md → OPERATA.md/roadmap → architecture docs → code
- Fresh AI instances read docs first, always
- Code teaches "how", docs teach "why"

**Evidence of Practice:**
- **Sar:** AI-Applied-TST explicitly states "documentation IS the codebase"
- **Sar:** Comprehensive OPERATA.md maintained across 28+ sessions
- **Zoetica:** Documentation coherence practice (update docs in same commit as code)
- **Geminex:** methodology.md as living specification

**Success Indicators:**
- Sar: "Fresh instance can start productive work in < 15 minutes"
- Sar commits reference TST theorems and include "why" reasoning
- LOG.md provides detailed session histories showing continued practice

**Failure Modes Observed:**
- **Zoetica:** Process docs now in .archive (dated 20251012), suggests abandonment
- Documentation drift when not enforced in CI
- "Living documentation" without discipline becomes stale documentation

**Recommendation for Autopax:**
✅ **ADOPT with discipline**
- Make CLAUDE.md and README.md symlinked (Sar pattern)
- Inline referenced documents with @-notation
- Update docs in same commit as code (Zoetica's coherence practice)
- Add to pre-commit hooks: documentation drift checks

---

### 1.2 OPERATA.md / TODO Tracking (HIGH CONFIDENCE)

**Source:** Sar (primary), with similar patterns in Geminex's implementation.md

**Pattern:**
- Single source of truth for project status
- Phase-based organization with clear completion criteria
- Technical debt explicitly tracked with effort estimates
- "What's Working" vs "What's Missing" clarity
- Decision logs with rationale preserved

**Evidence of Practice:**
- **Sar:** OPERATA.md updated continuously across sessions
- 475 lines covering phases, decisions, technical debt, success metrics
- Clear phase completions: "Phase 1: ✅ COMPLETE", "Phase 2a: ✅ COMPLETE"
- Technical debt section includes: priority, description, effort, status

**Example (Sar):**
```markdown
**HIGH Priority:**
- [ ] **Module Naming Duplication** (Codex feedback)
  - Two implementations: Nim `toElixirModuleName()` + Bash `python_module_name()`
  - Solution: Emit module name in JSON artifact (single source of truth)
  - **Effort:** 1-2 hours
```

**Why This Works:**
- Every session starts by reading OPERATA.md
- Captures institutional knowledge across context windows
- Makes priorities explicit, prevents drift
- Effort estimates enable temporal optimization (TST T-06)

**Recommendation for Autopax:**
✅ **ADOPT immediately**
- Create OPERATA.md as living TODO list
- Phase-based organization
- Track technical debt with effort + ROI estimates
- Update every session

---

### 1.3 Session-Based Workflow (HIGH CONFIDENCE)

**Source:** Sar (comprehensive), Geminex (lifecycle), Zoetica (worktree workflow)

**Pattern:**
- Context window as fundamental temporal unit
- Session summaries as handoff documents
- Work must be completable within one context window
- TodoWrite for planning, session summary for closure

**Sar's Session Template:**
1. **Context Loading (5-10 min):** Read CLAUDE.md, OPERATA.md, recent sessions
2. **Planning Phase (5-15 min):** TodoWrite to capture plan
3. **Implementation (60-120 min):** Execute with TST awareness
4. **Documentation (15-30 min):** Update OPERATA.md, write session summary
5. **Handoff (10-15 min):** Commit, push, final TodoWrite update

**Evidence of Practice:**
- **Sar:** LOG.md shows 28+ sessions with detailed summaries
- **Sar:** Commit messages reference session context and decisions
- **Zoetica:** Journal entries from Oct 2-3 show real session tracking
- **Geminex:** Explicit session metadata in commits

**Critical Insight (from Sar AI-Applied-TST):**
> "With 100% instance turnover, incomprehensible code becomes exponentially toxic"

**Recommendation for Autopax:**
✅ **ADOPT as core workflow**
- Session summaries in LOG.md or docs/sessions/
- TodoWrite at session start and end
- "Context for Next Session" in every summary
- Measure: "time from fresh context to first correct change" (target < 15 min)

---

### 1.4 Temporal Software Theory Integration (MEDIUM-HIGH CONFIDENCE)

**Source:** Sar (explicit), Geminex (implicit), Zoetica PRAXES (referenced)

**Pattern:**
- Mathematical framework for decision-making
- Justifies investments with n_future estimates
- Commit messages include TST reasoning
- Measure rather than guess

**Core TST Theorems Applied:**
- **T-01:** Time is fundamental metric after constraints satisfied
- **T-04:** n_future ≈ n_past (baseline for estimating future changes)
- **T-06:** Accept X extra minutes now to save Y minutes × n_future
- **T-08:** Implementation time ∝ changeset size
- **T-09:** Scattered changes multiply time cost

**Evidence of Practice:**
- **Sar:** tst-distilled.md (790 lines) and ai-applied-tst.md (1283 lines)
- **Sar commits:** Include TST justification
  - Example: "T-06: Accept 2 hour implementation to save 5min/future-test"
  - "n_future: ~20 OTP behavior tests expected"
  - "ROI: (20 × 5min) - 2hr = -20min (barely justified)"
- **Geminex:** "TST calculations (change-set size, proximity, n_future) post-change"

**Practical Application:**
```markdown
# Before every decision:
X < n_future × Y
Where: X = extra time now, Y = time saved per future change
```

**Why This Works:**
- Moves from "clean code" aesthetics to mathematical optimization
- Enables confident refactoring decisions
- Documents reasoning for future instances
- AI can compute what humans must estimate

**Challenges Observed:**
- Requires discipline to actually compute rather than handwave
- n_future estimation still somewhat intuitive
- Easy to over-apply (analysis paralysis)

**Recommendation for Autopax:**
✅ **ADOPT selectively**
- Use for significant refactoring decisions
- Include TST reasoning in commit messages for architectural changes
- Don't require for every micro-decision (that's analysis paralysis)
- Create simplified reference (not 790 lines) for quick lookup
- Focus on T-04, T-06, T-08 as most actionable

---

### 1.5 Git Workflow Discipline (HIGH CONFIDENCE)

**Source:** All three projects

**Pattern:**
- Structured commit messages with context
- Frequent commits as checkpoints
- Push immediately (especially for submodules)
- Never lose work across context windows

**Sar Submodule Discipline:**
```markdown
**⚠️ CRITICAL: ALWAYS PUSH IMMEDIATELY AFTER COMMITTING IN THE SUBMODULE**

Why this matters:
- Submodule commits only exist in .git/modules/ locally
- If that directory is deleted without pushing, commits are PERMANENTLY LOST
- There is NO recovery option - no reflog, no trash, no backup
```

**Commit Message Format (from multiple projects):**
```
type(scope): summary (imperative, ≤50 chars)

Body (wrap at 72 chars):
- Why (motivation, not what)
- TST justification (if architectural)
- Tests run
- Context for next session

Branch: <worktree-branch>  (if applicable)
```

**Evidence:**
- **Sar:** "COMMIT AND PUSH IN THE SUBMODULE" emphasized in README
- **Zoetica:** Operational rituals specify commit format
- **Sar:** Git log shows consistent commit discipline

**Recommendation for Autopax:**
✅ **ADOPT**
- Commit frequently (every logical checkpoint)
- Push at end of every session (preserve across context)
- Structured commit messages for significant changes
- Casual commits okay for small iterations

---

## 2. Patterns That Are Aspirational But Problematic

### 2.1 Tribunal / Deliberation Process (LOW CONFIDENCE)

**Source:** Zoetica (elaborate), Geminex (mentioned)

**Pattern:**
- Four-role deliberation: Investigator, Challenger, Analyst, Coordinator
- Run before code changes (planning tribunal)
- Run after completion (final tribunal)
- Record in XML format

**Template (Zoetica):**
```xml
<tribunal mode="plan">
  <claim></claim>
  <investigator>Sources: / Confidence:</investigator>
  <challenger>Counterarguments: / Failure modes:</challenger>
  <analyst>Incentives/Biases: / Impact radius:</analyst>
  <coordinator>Verdict: / Notes:</coordinator>
</tribunal>
```

**Evidence of Practice:**
- **Zoetica:** Templates exist in .archive/docs-20251012/process/templates/
- **Zoetica:** Oct 2 journal mentions "Awaiting tribunal analysis"
- **Zoetica:** "Run tribunal before editing code" in operational-rituals.md
- **But:** Process docs are now archived, suggesting abandonment
- **But:** No tribunal XML found in actual commits or journals

**Why This Likely Didn't Stick:**
1. **High ceremony for uncertain value** - takes time without clear ROI
2. **Doesn't map to solo AI development** - makes sense for team deliberation
3. **XML format is heavyweight** - Markdown would be more natural
4. **Pre-commit requirement creates friction** - slows down exploratory work
5. **No tooling support** - pure process overhead

**What Might Work Instead:**
- Lightweight decision log in commit messages
- "Why" section in significant commits
- ADR (Architecture Decision Records) for major choices
- But not formal tribunal for every feature

**Recommendation for Autopax:**
❌ **AVOID elaborate tribunal ceremony**
✅ **ADOPT lightweight decision capture**
- ADRs for significant architectural decisions
- "Why" section in commit messages
- OPERATA.md decision log
- Skip the four-role XML ceremony

---

### 2.2 Prefactor-First Workflow (MEDIUM CONFIDENCE)

**Source:** Zoetica PRAXES, referenced in process docs

**Pattern:**
- Structural changes BEFORE behavioral changes
- Separate commits for prefactors
- Unit tests verify no behavior changed
- "When they are needed, rather than prematurely" (TST T-06)

**From Zoetica PRAXES:**
> "Prefactor is a structural, behavior-neutral change performed *before* implementing features. This practice is a direct application of Temporal Software Theory (TST), as it delivers necessary abstractions and generalizations when they are needed, rather than prematurely."

**Template (Zoetica):**
```markdown
- Target area:
- Behavior that must remain unchanged:
- Structural adjustments:
- Tests executed (scripts/prefactor-tests):
- n_past / n̂_future update:
- X vs n̂_future × Y reasoning:
```

**Evidence of Practice:**
- **Zoetica:** Template exists, mentioned in operational rituals
- **Sar:** Pre-factor commits visible in git log:
  - "Pre-factor Phase 2c: Add FFI test coverage infrastructure"
  - "d647820 Pre-factor Phase 2c: Add FFI test coverage infrastructure and runtime tests"
- **But:** Not consistently applied across all projects

**Why This Is Valuable But Hard:**
1. **Requires discipline** - easy to combine structure + behavior changes
2. **Needs good test coverage** - to verify behavior preservation
3. **High value when done right** - reduces cognitive load
4. **TST-justified** - when n_future is high

**What Actually Works:**
- Separate commits for refactoring vs features (informal)
- "No functional changes" in commit message
- Tests verify preservation
- But don't require elaborate prefactor template/process

**Recommendation for Autopax:**
✅ **ADOPT principle, not ceremony**
- Separate refactoring commits from feature commits
- Note "Refactoring only - no functional changes" in message
- Run tests before/after to verify preservation
- But skip the prefactor template unless change is significant

---

### 2.3 Worktree Workflow (LOW-MEDIUM CONFIDENCE)

**Source:** Zoetica (explicit), implicit in other projects

**Pattern:**
- Each agent/session gets dedicated git worktree
- Configure worktree-specific git attribution
- Isolates concurrent work
- Remove worktree after session

**From Zoetica:**
```bash
git worktree add ../zoetica-<agent>-session
cd ../zoetica-<agent>-session
git config --worktree user.name '<AgentName>'
git config --worktree user.email 'verus+<agentname>@v2.io'
```

**Evidence of Practice:**
- **Zoetica:** Detailed guides in .archive/docs-20251012/process/guides/
- **Zoetica:** Oct 2 journal shows real worktree usage
- **But:** Not visible in Sar or Geminex workflows

**Why This Is Interesting But Optional:**
1. **Enables concurrent work** - multiple agents on different features
2. **Clean attribution** - know who did what
3. **Isolation** - prevents conflicts
4. **But:** Adds complexity for solo development
5. **But:** Not needed if work is sequential

**When This Makes Sense:**
- Multiple AI agents working simultaneously
- Complex multi-feature development
- Need for attribution/audit trails
- Team coordination

**When It's Overhead:**
- Solo development
- Sequential sessions
- Simple feature work

**Recommendation for Autopax:**
⏸️ **DEFER until needed**
- Start with simple main branch workflow
- Add worktrees if concurrent development emerges
- Document the pattern now, but don't enforce it

---

### 2.4 Elaborate Journaling (MEDIUM CONFIDENCE)

**Source:** Zoetica (templates), some evidence of practice

**Pattern:**
- Daily journal entries with session details
- Structured template: worktree, tribunal, prefactors, simulations
- "JNL-YYYY-MM-DD#anchor" references in commits

**Template (Zoetica):**
```markdown
## YYYY-MM-DD — <agent>
- Worktree: ../zoetica-<agent>-session
- Plan tribunal: (summary + link)
- Prefactors: (links + outcomes)
- Simulations: (links + conclusions)
- Features/tests:
- Final tribunal: (summary + verdict)
- Open questions / follow-ups:
- Next steps:
```

**Evidence of Practice:**
- **Zoetica:** Oct 2-3 journal exists and is detailed
- **Zoetica:** Oct 4 supplemental journal (but very personal/philosophical)
- **But:** Limited evidence of sustained journaling
- **Sar:** Uses LOG.md for detailed session history (looser format)

**What Works vs What's Overhead:**

**Works:**
- Session summaries (what was done, why, what's next)
- Decision capture
- Handoff to next session

**Overhead:**
- Elaborate template with tribunal/prefactor/simulation sections
- Daily journal files vs consolidated LOG.md
- JNL-anchor references in commits (extra notation burden)

**Recommendation for Autopax:**
✅ **ADOPT lightweight session logging**
- LOG.md or docs/sessions/ with session summaries
- Focus on: what changed, why, what's next
- Skip elaborate template
- Simple Markdown, not XML or heavy structure

---

## 3. Common Themes Across Projects

### 3.1 AI-First Development Thinking

**Consistent Across All Projects:**

**Core Insight:** AI agents have different cognitive patterns than humans
- **100% context turnover** every session (vs ~20% human annual turnover)
- **Instant implementation capability** (specification becomes the bottleneck)
- **Computational advantages** (can measure what humans estimate)
- **Documentation-first comprehension** (read before code)

**Implications:**
1. **Comprehension cost dominates** (T-05 in TST)
2. **Explicit > Implicit always**
3. **Linear > Scattered always**
4. **Documentation density scales with change frequency**

**From Sar AI-Applied-TST:**
> "With extreme AI turnover, always bias toward comprehension. Code that a fresh instance can understand in minutes is worth more than code that saves implementation time."

**Practical Guidelines:**
- Each module should be comprehensible within context window
- Comments explain "why" not "what"
- Patterns should be immediately obvious
- Files should be understandable in isolation when possible

---

### 3.2 Measurement Over Intuition

**Source:** Sar (explicit TST), Geminex (measurement in methodology), Zoetica (telemetry)

**Pattern:** Prefer measurement to guessing

**Examples:**
- **Change-set size** (T-08): Count files touched, lines changed
- **Coupling** (T-10): Compute from git co-occurrence
- **n_future** (T-04): Estimate from n_past (git history)
- **Comprehension time:** Measure "time to first correct change"

**From Sar:**
> "AI can compute what humans must estimate. Instead of believing abstractions are good, measure their temporal impact."

**Practical Application:**
```bash
# Measure coupling from git history
git log --format="" --name-only | sort | uniq -c | sort -rn

# Count how often files change together
# High co-occurrence = high coupling

# Use to justify: merge modules, extract shared abstraction, or reduce interface
```

**Recommendation for Autopax:**
✅ **ADOPT measurement mindset**
- Use git history to inform refactoring decisions
- Count change-set sizes for feature types
- Track n_past to estimate n_future
- Don't require elaborate tooling, but do measure

---

### 3.3 Session Completability

**Consistent Across All Projects:**

**Principle:** Work must fit in one context window

**From Sar AI-Applied-TST:**
> "Every TODO should be completable within one context window. Incomplete work = lost context = wasted time."

**Session Complexity Levels (Sar):**
1. **Trivial** (0.3-0.5 sessions): Add simple FFI binding, fix obvious bug
2. **Simple** (0.5-1.0 sessions): Add runtime test, straightforward feature
3. **Moderate** (1-2 sessions): New subsystem component, complex refactoring
4. **Complex** (3-5 sessions): New language feature (backend + tests + docs)
5. **Major** (6-15 sessions): Full subsystem, architectural overhaul

**Heuristics for Breaking Down:**
- If TODO takes > 50k tokens to explain → break it down
- If implementation touches > 10 files → break it down
- If uncertain about completion → break it down

**Evidence of Practice:**
- **Sar:** OPERATA.md phases broken into completable chunks
- **Sar:** TodoWrite tracks session-scoped tasks
- **Zoetica:** Oct 2 journal shows single-session umbrella migration

**Recommendation for Autopax:**
✅ **ADOPT strictly**
- Break all work into session-completable units
- Use TodoWrite for session planning
- If a TODO feels too big, it is - break it down
- Measure success: % of planned work completed per session (target 80%+)

---

### 3.4 Documentation Drift as Primary Failure Mode

**Observed Across Projects:**

**The Pattern:**
1. Project starts with excellent documentation
2. Early sessions maintain doc-code coherence
3. Velocity pressure → docs lag behind code
4. Documentation becomes misleading
5. Fresh instances waste time on stale info

**Evidence:**
- **Zoetica:** Process docs archived (20251012), suggests they became stale
- **Zoetica:** "Documentation coherence practice" existed but process now archived
- **Sar:** Actively fights this with "Update OPERATA.md" in every session

**From Zoetica README:**
> "Process: When completing P0/P1 tasks, the **same commit** should update:
> 1. The actual implementation/documentation
> 2. IMPLEMENTATION.md status table
> 3. Any "What's Missing" or "Blockers" lists
> 4. Cross-references in related docs"

**Why Drift Happens:**
- Implementation is visible (tests fail, code breaks)
- Documentation bitrot is invisible (until next session)
- Pressure to ship features
- No automated drift detection

**Solutions That Work:**
- **Update docs in same commit** (Zoetica coherence practice)
- **Pre-commit hooks** (check for doc drift)
- **OPERATA.md as living TODO** (forces updates)
- **Session checklist** includes doc updates

**Recommendation for Autopax:**
✅ **PREVENT through discipline**
- Docs update in same commit as code (enforced in pre-commit)
- OPERATA.md updated every session
- Pre-commit hook: "Did you update relevant docs?"
- Make doc drift visible: CI flag for stale references

---

## 4. Operational Patterns (From PROJECT-ASPECTS)

### 4.1 CI/CD & Pre-Commit Hooks (HIGH CONFIDENCE)

**Source:** Zoetica PROJECT-ASPECTS, referenced across projects

**Pattern:**
- Pre-commit hooks for fast feedback (can be bypassed)
- CI for enforcement (mandatory)
- Both together create safety net

**Pre-Commit Should Run:**
1. Format check (mix format --check-formatted)
2. Tests (mix test)
3. Compilation with warnings-as-errors
4. Dependency audit (mix hex.audit)
5. Secrets scanning (gitleaks)

**From PROJECT-ASPECTS:**
> "Recommendation: **Both** - pre-commit for fast feedback, CI for enforcement"

**Evidence:**
- **Zoetica:** Listed in "What You're Already Doing Well"
- **Sar:** Implicit in development workflow
- **Autopax:** toys dev pre-commit exists

**Recommendation for Autopax:**
✅ **ALREADY HAVE, MAINTAIN**
- `toys dev pre-commit` covers this
- Ensure CI runs same checks
- Document what pre-commit does

---

### 4.2 Secrets Management & Rotation (HIGH CONFIDENCE)

**Source:** PROJECT-ASPECTS, mentioned in Zoetica PRAXES

**Pattern:**
- Tiered approach: .env files (dev), environment variables (prod)
- Regular rotation schedule
- Never commit secrets
- Automated scanning (gitleaks)

**Rotation Schedule (PROJECT-ASPECTS):**
- Daily signing keys: Every 6 months or on compromise
- Deployment keys: Annually
- Provider API keys: Every 3-6 months
- Master DID key: Rarely, but have procedure

**Quick Check:**
> "When did you last rotate your Anthropic API key? If >6 months or 'never', schedule rotation now."

**Recommendation for Autopax:**
✅ **ADOPT tiered approach**
- Document in setup guide: use .env for development
- Add to OPERATA.md: rotation schedule + calendar reminders
- Ensure gitleaks or similar in pre-commit/CI

---

### 4.3 Backup Automation (HIGH CONFIDENCE)

**Source:** PROJECT-ASPECTS, Sar README

**Critical Pattern:** "Manual backups don't happen. Automate or accept data loss."

**Three-Layer Strategy:**
1. **Git push** (code + config) - to private GitHub/GitLab
2. **Cloud backup** (full project) - rsync/rclone to S3/GCS
3. **Local backup** (Time Machine) - fast recovery for accidental deletes

**From PROJECT-ASPECTS:**
> "If laptop died right now, how long to resume work? If >1 day or 'I'd lose everything', this is HIGH PRIORITY."

**Recovery Test:** Actually try restoring from backup quarterly

**Recommendation for Autopax:**
✅ **ADOPT with automation**
- Automated git push at session end (already in workflow)
- Document backup strategy in ops docs
- Test recovery once (verify backups actually work)
- For Autopax: code is backed up via git, but document any local state

---

### 4.4 Cost Monitoring & Rate Limiting (MEDIUM CONFIDENCE)

**Source:** PROJECT-ASPECTS (for ELI projects with API calls)

**Pattern:**
- Client-side rate limiting (hammer library)
- Circuit breakers for provider failures
- Track API spend per day/entity
- Alert if > $X threshold

**Quick Check:**
> "What happens if code enters infinite loop calling provider? If 'run out of money' or 'get rate limited and crash', add circuit breaker."

**Recommendation for Autopax:**
⏸️ **DEFER (not applicable yet)**
- Autopax doesn't currently call paid APIs
- When/if it does, adopt PROJECT-ASPECTS checklist
- Document now, implement when needed

---

### 4.5 Testing Strategy (HIGH CONFIDENCE)

**Source:** All projects, explicit in PROJECT-ASPECTS

**Pattern:** All three test types, emphasize integration

**Test Types:**
1. **Unit:** Pure functions, data transformations (fast, isolated)
2. **Integration:** Full flow, crash recovery, actual behavior (slow, realistic)
3. **Property:** Cryptographic ops, edge cases (generative, comprehensive)

**From PROJECT-ASPECTS:**
> "What to test:
> - Provider streaming (does SSE parsing work?)
> - Crash recovery (kill process mid-turn, does it recover?)
> - Hash chain verification (corrupt event, does it detect?)"

**Current Autopax:**
- `toys dev test` exists
- Dry::CLI with RSpec

**Recommendation for Autopax:**
✅ **EXPAND as needed**
- Start with unit tests for core logic
- Add integration tests when CLI gets complex
- Property tests if handling user input/validation
- Test actual CLI workflows end-to-end

---

## 5. Specific Recommendations for Autopax

### 5.1 Immediate Adoption (Week 0)

**High-value, low-ceremony patterns:**

1. **OPERATA.md - Living TODO List**
   - Create now as single source of truth
   - Phase-based organization
   - Technical debt tracking with effort estimates
   - Update every session

2. **Session Logging in LOG.md**
   - Simple format: Date, What Changed, Why, Next Steps
   - No elaborate template
   - Focus on handoff context

3. **Documentation-First Mindset**
   - CLAUDE.md + README.md symlinked (Sar pattern)
   - Update docs in same commit as code
   - Pre-commit check: "Did you update relevant docs?"

4. **Structured Commits (for significant changes)**
   - type(scope): summary
   - Body with "why" reasoning
   - Casual commits okay for small iterations

5. **TodoWrite Session Planning**
   - Start each session with TodoWrite
   - Break work into completable chunks
   - Update at end with context for next session

**Effort:** ~2 hours to set up
**ROI:** Massive (every session benefits)

---

### 5.2 Selective Adoption (Week 1-4)

**Valuable but requires more setup:**

1. **TST-Justified Refactoring**
   - Create simplified TST reference (not 790 lines)
   - Focus on T-04, T-06, T-08
   - Include reasoning in commits for architectural changes
   - Example: "T-06: Accept 1hr refactor to save 10min × ~15 future features"

2. **Pre-Commit Enforcement**
   - Already have `toys dev pre-commit`
   - Add documentation drift check
   - Ensure CI runs same checks

3. **Measurement-Driven Decisions**
   - Use git history for refactoring justification
   - Count change-set sizes for common operations
   - Track n_past to estimate n_future

**Effort:** ~4-6 hours across first month
**ROI:** High (prevents bad architectural decisions)

---

### 5.3 Defer Until Needed

**Patterns that are situational:**

1. **Worktree Workflow**
   - Wait until concurrent development needed
   - Document pattern now, but don't enforce

2. **Elaborate Journaling**
   - Simple session summaries sufficient
   - Skip the tribunal/prefactor/simulation template

3. **Formal ADRs**
   - Start with decision logs in OPERATA.md
   - Upgrade to ADRs if decisions become complex

4. **Operational Concerns**
   - Backups (already handled via git)
   - Rate limiting (no paid APIs yet)
   - Monitoring (not needed for CLI tool)
   - Add when Autopax becomes service

**Effort:** $0 now, document for later
**ROI:** Prevent premature complexity

---

### 5.4 Explicitly Avoid

**Patterns that didn't survive or are too heavy:**

1. **Tribunal XML Ceremony**
   - Use lightweight decision capture instead
   - "Why" in commit messages sufficient

2. **Prefactor Template**
   - Use principle (separate refactor commits) not template
   - Note "Refactoring only" in message

3. **JNL-anchor References**
   - Extra notation burden
   - Simple references sufficient

4. **Elaborate Process Rituals**
   - Zoetica's operational-rituals.md now archived
   - Suggests ceremony didn't survive
   - Prefer pragmatic checklists

**Reason:** High ceremony, low evidence of sustained practice

---

## 6. Meta-Insights: Why Patterns Weren't "Inculcated Soon Enough"

### 6.1 Ceremony vs Value Tradeoff

**Observation:** Patterns with high ceremony-to-value ratios get abandoned

**Examples:**
- **Tribunal XML:** Elaborate, formal, but unclear ROI → abandoned (Zoetica)
- **OPERATA.md tracking:** Simple, clear value → maintained (Sar)
- **Prefactor template:** Formal, but principle survives → template dropped, principle kept

**Lesson:** Keep process lightweight. Document principles, not elaborate procedures.

---

### 6.2 Tooling Deficit

**Observation:** Patterns without tooling support become friction

**Examples:**
- **Tribunal:** No automated generation, XML by hand → abandoned
- **Documentation drift:** No automated checking → bitrot
- **Prefactor verification:** "scripts/prefactor-tests" mentioned but no evidence → not practiced

**Lesson:** If a pattern needs tooling to work, build the tooling OR simplify the pattern.

**For Autopax:**
- Use Toys tasks for common workflows
- Pre-commit hooks for enforcement
- Don't rely on manual discipline for critical patterns

---

### 6.3 Feedback Loop Gap

**Observation:** Invisible problems don't get fixed

**Examples:**
- **Documentation drift:** Not visible until next session starts
- **Comprehension time:** Not measured, so doesn't improve
- **Change-set size:** Not tracked, so architecture drift unnoticed

**Lesson:** Make success/failure visible

**For Autopax:**
- Measure comprehension time: "How long from context load to first change?"
- Track documentation updates: "Is OPERATA.md current?"
- Monitor change-set sizes: "How many files touched for typical features?"

---

### 6.4 Solo vs Team Patterns

**Observation:** Patterns designed for teams don't fit solo AI development

**Examples:**
- **Tribunal:** Makes sense for team deliberation, not solo agents
- **Worktree workflow:** Valuable for concurrent work, overhead for sequential
- **Attribution:** Important for teams, less critical for solo development

**Lesson:** Adapt team patterns for AI context

**For Autopax:**
- Start solo (simple patterns)
- Add team patterns if/when multiple agents collaborate
- Don't cargo-cult processes designed for different contexts

---

### 6.5 Aspirational vs Pragmatic

**Observation:** Projects start idealistic, evolve toward pragmatism

**Evolution Visible:**
1. **Zoetica:** Elaborate rituals (tribunal, prefactor, operational-rituals)
   - Result: Process docs now in .archive

2. **Geminex:** Balanced (methodology + tooling)
   - Result: Active but simpler than Zoetica

3. **Sar:** Pragmatic (OPERATA.md + TST reasoning + session logs)
   - Result: Most evidence of sustained practice

**Lesson:** Start pragmatic. Don't build aspirational ceremony.

**For Autopax:**
- Begin with patterns proven in Sar
- Add complexity only when pain demands it
- Prefer checklists to rituals

---

## 7. Convergent Evolution: Cross-Project Patterns

### Patterns That Appear in All Three Projects

1. **Documentation as Primary**
   - Zoetica: Documentation coherence practice
   - Geminex: Specification-first methodology
   - Sar: "Documentation IS the codebase"

2. **Session-Based Workflow**
   - Zoetica: Worktree + journal entries
   - Geminex: Session metadata in commits
   - Sar: Comprehensive session template

3. **Measurement Over Intuition**
   - Zoetica: Telemetry + structured logging
   - Geminex: TST calculations post-change
   - Sar: Explicit TST theorems + measurement framework

4. **Context Window as Constraint**
   - All three recognize context turnover
   - All break work into completable units
   - All emphasize handoff documentation

**Insight:** When the same pattern emerges independently across projects with different authors/contexts, it's likely fundamental.

---

## 8. Success Metrics for Autopax

### Short-Term (3 months)

**Documentation Quality:**
- [ ] Fresh instance can start productive work in < 15 minutes
- [ ] OPERATA.md reflects current status (not stale)
- [ ] README/CLAUDE.md provide clear onboarding

**Development Velocity:**
- [ ] 80%+ of planned work completed within session
- [ ] < 5% of work abandoned due to context overflow
- [ ] Clear handoff notes for next session

**Process Integration:**
- [ ] Session summaries capture decisions
- [ ] Commit messages explain "why" for significant changes
- [ ] OPERATA.md updated weekly minimum

### Medium-Term (6 months)

**Comprehension:**
- [ ] Comprehension time reduced (baseline → optimized)
- [ ] Documentation density correlates with change frequency
- [ ] Fresh instances identify modification points quickly

**Temporal Optimization:**
- [ ] 2+ TST-justified refactorings completed
- [ ] Measured reduction in change-set sizes
- [ ] Test suite reduces per-test implementation time

### Long-Term (12 months)

**Project Maturity:**
- [ ] Comprehensive test coverage
- [ ] All subsystems have stable patterns (n_past > 10)
- [ ] Documentation quality enables independent contributions
- [ ] Development velocity stable (not degrading despite growth)

---

## 9. Final Synthesis: The Autopax Development Approach

### Core Philosophy

**From Sar's AI-Applied-TST:**
> "Code is no longer the primary artifact. Documentation, architecture, and temporal reasoning are the primary artifacts. Code is simply the executable manifestation of well-specified intent."

**Adapted for Autopax:**
- **Documentation-first:** README/CLAUDE.md define the system
- **Toys-first workflow:** All commands through `toys dev <cmd>`
- **Session-based development:** Context window as temporal unit
- **Measurement-driven:** Use git history + TST to justify decisions
- **Pragmatic ceremony:** Checklists > rituals

### Recommended Workflow

**Every Session:**
1. Read CLAUDE.md + OPERATA.md (~5 min)
2. TodoWrite to plan work (~5 min)
3. Implement with commit checkpoints (~60-120 min)
4. Update OPERATA.md + session notes (~10 min)
5. Commit, push, TodoWrite handoff (~5 min)

**Every Week:**
- Review OPERATA.md completeness
- Check documentation drift
- Update roadmap/priorities

**Every Month:**
- Review success metrics
- Measure comprehension time (baseline)
- Assess whether patterns are working

### Critical Success Factors

1. **Discipline over cleverness**
   - Simple patterns, rigorously applied
   - Documentation updated with code
   - Session summaries every time

2. **Measure, don't guess**
   - Use git history for decisions
   - Track n_past → estimate n_future
   - Justify refactoring with TST

3. **Optimize for the next instance**
   - Every decision optimizes comprehension
   - Handoff notes assume fresh context
   - Documentation teaches why, not just what

4. **Pragmatic evolution**
   - Start simple (OPERATA.md + session logs)
   - Add complexity when pain demands it
   - Learn from what works, abandon what doesn't

---

## 10. Conclusion

**Key Takeaway:** The patterns that survived project-to-project evolution are what actually works. Autopax should adopt Sar's pragmatic approach (OPERATA.md, session summaries, TST reasoning) while avoiding Zoetica's elaborate rituals (tribunal XML, prefactor templates) that ended up archived.

**The Proven Core:**
1. Documentation as primary artifact
2. OPERATA.md as living TODO
3. Session-based workflow with handoff notes
4. TST-justified architectural decisions
5. Measurement over intuition
6. Pre-commit hooks + CI enforcement

**The Evolution Path:**
- **Week 0:** OPERATA.md + session logging + documentation-first
- **Month 1:** TST integration + measurement framework
- **Month 3:** Evaluate what's working, adjust or abandon
- **Month 6:** Mature patterns emerge, document for others

**The Test:** If a pattern doesn't survive 6 months of actual practice, it probably isn't worth the ceremony. Build simple, measure results, evolve based on evidence.

---

**Appendix A: Quick Reference**

### Patterns to Adopt Immediately
- [ ] Create OPERATA.md with phase-based TODO tracking
- [ ] Start LOG.md for session summaries
- [ ] Symlink CLAUDE.md → README.md (Sar pattern)
- [ ] Use TodoWrite for session planning
- [ ] Update docs in same commit as code

### Patterns to Adopt Selectively
- [ ] TST reasoning for architectural decisions
- [ ] Measurement from git history
- [ ] Pre-commit documentation drift checks
- [ ] Session complexity estimates

### Patterns to Defer
- [ ] Worktree workflow (until concurrent development)
- [ ] Formal ADRs (start with decision log in OPERATA.md)
- [ ] Elaborate tooling (until pain demands it)

### Patterns to Avoid
- [ ] Tribunal XML ceremony
- [ ] Prefactor formal templates
- [ ] JNL-anchor notation
- [ ] Elaborate process rituals

---

**Generated by:** Claude Sonnet 4.5
**Sources:** Zoetica, Geminex, Sar project documentation
**Total Documents Analyzed:** 18+ primary sources
**Analysis Date:** 2025-11-17
