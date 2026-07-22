---
source: 2025-11-17-autonomous-vs-collaborative-decisions.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-autonomous-vs-collaborative-decisions.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [decision-authority, coordination-markers, agent-signals]
why_included: >
  Nov 17 2025. Decision-providence hierarchy (autonomous / inform / consult / approve) with markers agents should emit. Directly relevant to how an agent-facing tool or observation should signal decision authority to the human on the other side.
---

# Autonomous vs. Collaborative Decisions
*Initial thoughts on compressed note #2*

## Core Principle
"Consistently differentiates between autonomous decisions and decisions discussed with Joseph and/or other stakeholders"

This is about **decision providence** - knowing not just what was decided, but who was involved and what level of authority it carries.

## The Decision Hierarchy

### Level 1: Agent Autonomous (Implementation Details)
- Variable naming within established conventions
- Code organization within a module
- Test structure choices
- Refactoring for clarity
- **Marker:** "I've organized this as..." / "I chose to..."

### Level 2: Agent Proposed, Human Reviewed
- Architectural patterns
- New dependencies
- API design choices
- Breaking changes
- **Marker:** "I propose..." / "Shall we..."

### Level 3: Human Directed
- Business logic decisions
- User experience choices
- Security policies
- Performance trade-offs
- **Marker:** "Per Joseph's guidance..." / "As discussed..."

### Level 4: Stakeholder Consensus
- Project direction
- Feature prioritization
- Breaking changes to public APIs
- **Marker:** "The team has decided..." / "Stakeholder agreement..."

## Why This Matters

### For Agents
- Clear boundaries of autonomy
- Confidence in decision-making space
- Reduced hallucination of authority
- Better handoffs between sessions

### For Humans
- Trust in agent decisions within bounds
- Clear escalation points
- Audit trail of decision-making
- No surprises in critical areas

## Implementation Patterns

### In Code Comments
```ruby
# AGENT-DECIDED: Using hash for O(1) lookups
# DISCUSSED: Joseph confirmed this should be case-insensitive
# TEAM-DECIDED: API returns JSON only, not XML
# PENDING-REVIEW: Considering cache invalidation strategy
```

### In Commit Messages
```
feat: Add user authentication

- AUTONOMOUS: Organized into auth/ module
- DISCUSSED: Using JWT over sessions (per Joseph)
- AUTONOMOUS: 24-hour token expiry
- PENDING: Rate limiting strategy
```

### In Documentation
```markdown
## API Design Decisions

### Autonomous Decisions
- RESTful naming conventions
- HTTP status code usage
- Error message format

### Collaborative Decisions
- Authentication method (JWT) - discussed 2024-11-17
- Rate limits (100/hour) - per Joseph's guidance
- Data retention (30 days) - stakeholder requirement
```

## The Authority Gradient

Not all decisions are binary (autonomous vs collaborative). There's a gradient:

1. **Fully Autonomous** - Agent decides and implements
2. **Inform** - Agent decides but notes in log
3. **Consult** - Agent proposes, waits for feedback
4. **Approve** - Agent drafts, human approves
5. **Direct** - Human specifies, agent implements

## Tools and Patterns

### Decision Log Format
```markdown
## 2024-11-17 Session 5

### Autonomous Decisions
- Extracted validation to separate module
- Added comprehensive error messages
- Reorganized test structure

### Collaborative Decisions
- [DISCUSSED] Move to async processing for large files
- [APPROVED] New rate limiting at 100 req/hour
- [PENDING] Consider WebSocket for real-time updates
```

### The AskUserQuestion Pattern
When an agent recognizes they're at a decision boundary:
```
"I'm at a decision point about X.
- Option A: [pros/cons]
- Option B: [pros/cons]

This feels like a Level 2 decision (architectural pattern).
Would you like to weigh in, or should I proceed with my recommendation of Option A?"
```

## Building Trust Through Transparency

The key to successful autonomous development is not maximizing agent autonomy, but rather being **transparent about decision-making levels**. This builds trust:

- Humans know what agents are deciding
- Agents know their boundaries
- Decisions have clear providence
- Changes can be traced to their authority

## Anti-Patterns to Avoid

1. **False Authority** - Agent claiming "best practice" without evidence
2. **Hidden Decisions** - Architectural choices buried in implementation
3. **Retroactive Permission** - "I assumed it was okay to..."
4. **Boundary Creep** - Gradually expanding autonomy without discussion

## For Autopax

Create clear decision boundaries in:
- CONTRIBUTING.md - What agents can decide
- ADR template - Who was involved
- Commit conventions - Decision level markers
- Code review process - What needs human eyes