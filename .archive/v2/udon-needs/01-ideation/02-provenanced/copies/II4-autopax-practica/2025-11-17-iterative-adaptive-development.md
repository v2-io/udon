---
source: 2025-11-17-iterative-adaptive-development.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-iterative-adaptive-development.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [epistemic-qualification, feedback-loops]
why_included: >
  Nov 17 2025. Epistemic qualification of knowledge states; three feedback loops (inner/medium/project). Witness of the feedback-loop granularity a trustworthy agent workflow needs.
---

# Iterative, Agile, and Adaptive Development
*Initial thoughts on compressed note #1*

## Core Principle
"Highly iterative, agile, and adaptive-- just enough preplanning but not too much-- and all well-qualified."

This speaks to finding the sweet spot between chaos and rigidity. The key insight is **epistemic qualification** - being clear about what we know vs what we're hypothesizing.

## Distinguishing Between Knowledge States

### 1. Exploration/Hypothesis
- "I wonder if..." / "It might be that..."
- Marked clearly in code comments and commits
- Permission to be wrong
- Low commitment, high learning

### 2. Deliberation
- "We're considering..." / "Trade-offs include..."
- Active decision-making process
- Multiple options on the table
- Evidence gathering phase

### 3. Current Decisions
- "We've decided..." / "The approach is..."
- Documented in ADRs or decision logs
- Has rationale and context
- Can be revisited with new evidence

### 4. Conventions/Rules/SOPs
- "Always do X" / "Never do Y"
- Proven patterns with track record
- Encoded in tooling where possible
- Violations should be exceptional and documented

## Feedback Cycle Optimization

### Inner-Loop (Seconds to Minutes)
- Tool usage efficiency
- Command completion
- Error recovery
- File navigation
- **Optimization:** Minimize friction, maximize flow state

### Medium-Loop (Within Session)
The session arc:
1. **Onboard** - Load context, understand state
2. **Meta** - Plan approach, identify prefactoring needs
3. **Dev** - Execute the work
4. **Reflect** - What worked? What was hard?
5. **Cleanup** - Leave campground better than found

**Postfactoring** - After implementation, what would have made this easier?

### Project-Loop (Sprint-like)
- Learnings aggregation
- Decision reviews
- Pattern extraction
- Task force formation for persistent issues
- **Key:** Actually closing the loop, not just collecting insights

## Implementation for Autopax

### Tooling Support
```ruby
# .toys.rb
tool 'dev session-start' do
  # Log session start
  # Show current hypothesis/decisions
  # Load relevant context
end

tool 'dev session-end' do
  # Capture learnings
  # Update OPERATA.md
  # Commit with session summary
end
```

### Documentation Patterns
```markdown
<!-- In code comments -->
# HYPOTHESIS: This might improve performance
# DELIBERATING: Considering cache vs. recompute
# DECIDED: Using cache (see ADR-007)
# CONVENTION: Always validate before caching
```

### The "Just Enough" Principle
- Plan enough to have direction
- Not so much that you're attached to wrong ideas
- Qualify confidence levels
- Adjust based on feedback rapidly

## Why This Matters

Traditional software development often operates in one of two modes:
1. **Cowboy coding** - No planning, pure exploration
2. **Waterfall** - Excessive planning, rigid execution

AI-assisted development needs a third way:
- **High iteration speed** (multiple cycles per session)
- **Explicit uncertainty** (agents shouldn't fake confidence)
- **Rapid feedback integration** (learn and adjust quickly)
- **Layered decision-making** (hypotheses → decisions → conventions)

The key is making the iterative nature **explicit and tooled** rather than implicit and chaotic.