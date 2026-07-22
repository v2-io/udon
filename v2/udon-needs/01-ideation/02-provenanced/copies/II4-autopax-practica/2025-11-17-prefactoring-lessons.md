---
source: 2025-11-17-prefactoring-lessons.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-17-prefactoring-lessons.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [workflow-discipline, refactor-first, make-obvious]
why_included: >
  Nov 17 2025. "Refactor-before-feature so the feature becomes obvious, with zero outward change" -- a workflow discipline claimed to yield order-of-magnitude speedups; TST-grounded. Witness of a make-the-right-thing-easiest move applied to code structure itself.
---

# Prefactoring: Definition and Lessons Learned

*Distilled from discussions on AI-assisted development and Temporal Software Theory (TST)*

## Executive Summary

Prefactoring is a strategic development pattern for evolving codebases where **refactoring precedes feature implementation** as a distinct, deliberate phase. Rather than interleaving cleanup with feature work, prefactoring treats "preparing the codebase for a feature" as its own valuable task—one that can be measured, optimized, and even performed by different agents/developers than those who implement the actual feature.

This approach has demonstrated **orders of magnitude** speed improvements over several months in projects that were previously "tied in knots," transforming increasingly chaotic codebases into ones that become progressively cleaner and more comprehensible.

---

## Core Definition

### What is Prefactoring?

> "Each session or at least each feature starts with 'What can I refactor in this code that has **zero outward facing changes**, but that makes the feature I do intend to implement **super obvious**?'"

Prefactoring is:
- **Refactoring with a concrete purpose**: preparing the codebase for a specific upcoming feature
- **A game of "greasing the skid"**: making the feature feel like it has a very natural home waiting for it
- **Visibility creation**: making implementation paths obvious rather than obscure
- **Comprehension optimization**: reducing the cognitive load for the agent/developer who will implement the feature

### What Prefactoring is NOT

- **Not** just general refactoring or cleanup
- **Not** premature optimization
- **Not** feature implementation itself
- **Not** "big refactors to pay down technical debt" done under time pressure
- **Not** interleaved with feature implementation

---

## Core Principles and Philosophy

### The Dual-Goal Framework

Every development session has **two tasks**:

1. **Push features forward** (the obvious goal)
2. **Make it so the next agent has a slightly easier time** than you, or is able to push forward a larger feature or more of a feature than you

> "That can be measured." - Joseph Wecker

This dual-goal framework fundamentally changes how we think about optimization.

### The Counter-Intuitive Truth About Speed

> "Given the dual-goal of each session, in my experience—**optimizing for current feature completion by the entity doing it** is almost always wasted."

The traditional approach: "What's the fastest, most token effective way possible for me to get this feature implemented?"

**This misses the target.** It often pushes the needle in exactly the wrong direction.

The prefactoring approach: "Take all the time you need to thoughtfully do this **right**, with your assumptions becoming visible and decisions documented with the code and your second-guessing documented and your 'should probably do this also' TODOs in the code comments... Let someone catch up with you real quickly if needed. Take all the time in the world—and then let's talk about what could have made that even easier."

### Why This Works: The Mathematics of Evolving Systems

TST (Temporal Software Theory) defines **evolving systems** as distinct from one-shot projects or systems with discrete "finish" points. The ultimate analysis takes historical decisions made by agents and estimates their **aggregated or amortized impact**.

**Key insight**: If changes to the operata/SOPs/code/infrastructure/agent-tools enable faster (or more commonly, **richer**) feature creation, that compounds over time. Features you can even think about taking on later in the project are huge compared to features attempted earlier.

The optimization problem lends itself to **local-optimization**: each session making things incrementally better for the next session creates a virtuous cycle.

---

## Practical Workflow

### The Prefactoring Session Pattern

When approaching a feature implementation:

1. **Exploration Phase**
   - Pay careful attention to your first guesses
   - Note which tools you run / which files you look at
   - Track what things you search for
   - Document confusion points

2. **Analysis Phase**
   - Think: "If the code were more like XYZ, I would know where to implement this and how to implement this **trivially**"
   - Compile your ideas
   - Think about them in terms of TST optimization
   - Identify what's blocking clear comprehension

3. **Preparation Phase**
   - Write necessary missing unit tests that guarantee you aren't accidentally changing outward-facing behavior
   - (Exception: occasional incidental bug fixes are acceptable)
   - Make the refactorings that create the "natural home" for the feature

4. **Handoff or Implementation**
   - Either: You now have enough context for the feature implementation in a trivially easy way
   - Or: Hand off with confidence to a fresh agent

### Separation of Concerns: Dedicated Prefactor Sessions

The most powerful variant:

> "If the session is just the prefactor session and **it's another agent altogether that does the feature**—you have a 'speed-to-comprehension' metric that is high-quality right away."

**Measurement strategy**: Spin up a second agent on an old commit and try to implement the same feature **without** the prefactor. Compare:

```
prefactor + smooth-feature-adding < cost of interleaving them and leaving it to mid-process guessing
```

This separation also reveals exactly where the **principled** places are to do unit-testing in a way that doesn't make tests fragile or create too much inertia.

---

## What Prefactoring Includes

### Common Prefactoring Activities

1. **Semantic Alignment**
   - "Integrate this new understanding of the domain and our more nuanced definitions for these words into the code base"
   - Changing variable names to be more precise
   - Aligning code terminology with domain terminology
   - **Conquering code and domain drift**

2. **Structural Preparation**
   - Creating or clarifying module boundaries
   - Extracting functions that will be needed
   - Setting up data structures that will be populated
   - Creating placeholder functions with clear contracts

3. **Documentation and Visibility**
   - Making assumptions visible
   - Documenting second-guessing
   - Adding TODO comments for "should probably do this also"
   - Creating or updating type signatures

4. **Testing Infrastructure**
   - Writing tests that prove current behavior is preserved
   - Setting up test fixtures for the feature
   - Creating property tests for invariants

5. **Process Improvements**
   - Cleaning up CLAUDE.md or other developer documentation
   - Adding scripts that fetch needed information (e.g., type specs from documentation)
   - Creating templates that reduce friction

### The Meta-Level Question

> "What decisions can I make about these things that will make [the project] lower-friction for everyone who uses these features in the future—**especially AI agents**?"

This meta-awareness—thinking about what makes code comprehensible and obvious—is central to effective prefactoring.

---

## Measurable Outcomes and Metrics

### Speed-to-Comprehension Metric

The primary metric: **How quickly can a fresh agent understand where and how to implement the feature?**

This can be measured by:
- Context window percentage consumed before implementation
- Number of files examined
- Number of searches performed
- Time to first confident implementation attempt
- Success rate on first attempt

### The A/B Test Approach

"Simply have a second agent spin up on an old commit and try to implement the same feature without the prefactor."

This provides direct, empirical evidence of prefactoring's value.

### Long-Term Velocity Metrics

> "I've seen teams that use this approach to take a rather chaotic project that is so tied in knots that features are painfully slow to finish, and speed up by **orders of magnitude over several months**—and have a code base that was getting hairier and hairier get **cleaner and cleaner and more obvious**."

Track over time:
- Feature throughput (features per session)
- Feature richness (complexity of features attempted)
- Code quality trends (getting cleaner vs getting messier)
- Onboarding time for new agents/developers

---

## Lessons Learned from Practice

### Lesson 1: Distinguish Fixes from Features

> "This doesn't look like a prefactor anymore. Your todo list has a fix. Maybe that's fine in this case because it wasn't a missing feature, just a broken feature (?)"

For broken features, prefactoring might mean:
- Looking at ways defects could have been surfaced much earlier
- Creating smoke tests or pre-commit hooks
- Preventing confusion in the first place

Example: "Create a pre-commit hook that makes sure everything implemented is covered by a smoke-test (with flag to override and commit anyway)."

### Lesson 2: Avoid Documentation Clutter

When prefactoring:

> "Please remove the extra doc unless you are in a situation where you might forget that stuff."

The **actual prefactor** is the stuff that makes the fix/implementation trivially easy:
- Scripts that fetch needed information
- Generated templates with correct signatures
- NOT extensive documentation files that won't be maintained

### Lesson 3: Not All Situations Are Good Prefactor Candidates

> "This wasn't a super good candidate for prefactor... UNLESS! unless you want to create a pre-commit hook..."

Sometimes the "prefactor" is actually about creating tooling or infrastructure that prevents the problem class entirely rather than cleaning up one instance.

### Lesson 4: Meta-Check Your Work

Continuously ask: "By [making this change], have you made the project easier for the next agent?"

If the answer isn't a clear "yes," reconsider the approach.

### Lesson 5: Semantic Precision Matters More Than It Seems

> "Things that seem like, at best an indulgence in times past turns out to be **extremely effective** for evolving code-bases so that code and domain drift are conquered."

Variable naming, terminology alignment, and semantic precision pay massive dividends in evolving codebases, especially with AI agents who rely heavily on semantic understanding.

---

## Anti-Patterns to Avoid

### 1. The "Traditional Interleaved Approach"

Traditional pattern:
```
plan → implement feature → (wait for approval or necessity for a "big refactor to pay down technical debt")
```

Problems:
- Refactors happen under time pressure
- Risk management paralysis when project is already perceived as delivering too slowly
- Code gets progressively messier
- Each feature becomes harder than the last

### 2. Premature Prescriptiveness

> "If it turns out to be 'yet another week 1- do this!, week 2- do this!' with full conviction and authority and silly things like optimizing for proxy measures and prescribing misleading heuristics... well, I'll just delete it."

Avoid:
- False sense of decisiveness and certainty
- Optimizing for proxy measures (e.g., "tokens spent in implementation")
- Prescriptive heuristics not grounded in actual measurement

### 3. Optimizing the Wrong Metric

> "A few thoughts on the session-context-profiler plan: It would be a mistake to ignore TST and select a target metric like 'tokens spent in implementation'—I could give you 100% efficiency by that metric right now if you like, and it would be the least effective project I can imagine."

Example: If an agent spends 94% of its context thinking, then pops out 7 major features with its last 4%—that's an **enormous win**, not a failure.

"Time spent on implementation is meaningless if it's just measuring that time vs time spent on other things. Category error."

### 4. Losing Epistemic Humility

> "We want to get away from the LLM's legacy training that causes a false sense of decisiveness and certainty that, in a mostly-AI-project, turns into red herrings and turmoil."

Prefactoring requires:
- Being thoughtful about what you actually know vs what you're guessing
- Making hypotheses explicit
- Marking uncertainties clearly
- Avoiding cargo culting

---

## Prefactoring for AI-Assisted Development

### Why Prefactoring is Essential for AI Agents

1. **Context Window Constraints**
   - Agents have limited working memory
   - Clear, obvious code reduces exploration overhead
   - Better semantic alignment = faster comprehension

2. **Pattern Matching vs Deep Understanding**
   - AI agents are exceptional at pattern matching
   - Clear patterns and consistent naming enables this strength
   - Semantic drift and inconsistency creates confusion

3. **Handoff Between Sessions**
   - Different agents (or same agent, fresh context) implement features
   - The quality of the "prepared ground" directly impacts success
   - Prefactoring is the bridge between sessions

4. **Measurement Opportunities**
   - With AI agents, we can run controlled experiments
   - Spin up multiple agents with/without prefactoring
   - Get real data on what actually helps comprehension

### AI-First Considerations

> "What decisions can I make about these things that will make [the language/system] lower-friction for everyone who uses these features in the future—**especially AI agents**?"

Questions to ask when prefactoring for AI:

- Would this naming be more semantically clear?
- Would this structure be more pattern-matchable?
- Would this organization reduce file/symbol search?
- Would this documentation format be more parseable?
- Would this API design be more discoverable?

---

## Techniques and Workflows

### The "Grease the Skid" Game

Think of prefactoring as a game with a clear objective:

**Goal**: Make the feature implementation feel like it's sliding into a natural home that was waiting for it.

**Success criteria**:
- The next agent knows exactly where to look
- The implementation path is obvious
- Similar features will also have obvious homes
- The code "wants" this feature

### The Observation Protocol

As you explore the codebase to understand how you'll approach implementation:

1. **Track Your Journey**
   - First guesses (what turned out wrong?)
   - Tools you ran (which were necessary vs exploratory?)
   - Files you looked at (which were red herrings?)
   - Searches you performed (what were you trying to find?)

2. **Identify Friction Points**
   - "If the code were more like XYZ, I would know immediately..."
   - "I got confused because..."
   - "I had to check three different places to understand..."
   - "The naming suggested X but it actually does Y..."

3. **Document the Gap**
   - What did you expect to find?
   - What did you actually find?
   - What would have made it obvious?

### The Unit Test Principle

> "Prefactor (which, btw, also informs exactly where the **principled** places are to do unit-testing, and so forth, in a way that doesn't make them fragile or too inertial)"

Unit tests in prefactoring serve two purposes:

1. **Safety Net**: Prove that refactoring doesn't change outward-facing behavior
2. **Design Clarity**: Reveal where the natural boundaries actually are

Tests written during prefactoring tend to be:
- More stable (testing actual boundaries, not implementation details)
- More valuable (documenting intended behavior before adding features)
- Less fragile (not coupled to specific implementation approaches)

---

## Case Studies and Examples

### Example 1: Type Signature Refactoring

**Context**: FFI implementation with missing or incorrect type signatures

**Prefactor approach**:
- Script that fetches Elixir @typespecs from hexdocs
- Generated template: "Supervisor.stop/1 returns :ok, here's the signature"
- NOT: A 208-line documentation file about the problem

**Lesson**: The actual prefactor is the tool/template that makes implementation trivial, not documentation about the problem.

### Example 2: Semantic Alignment

**Context**: Domain understanding has evolved, but code hasn't caught up

**Prefactor activities**:
- Rename variables to match current domain terminology
- Update function names to reflect actual purpose
- Align code structure with domain model
- Document semantic decisions in code comments

**Result**: Code and domain drift conquered, making future features obvious

### Example 3: Structural Preparation

**Context**: Need to add feature but current code structure obscures where it belongs

**Prefactor activities**:
- Extract common patterns into helper functions
- Create clear module boundaries
- Set up data structures that will be populated
- Add placeholder functions with clear contracts

**Benefit**: Feature implementation becomes "filling in the blanks" rather than reverse-engineering the codebase

---

## Relationship to TST and Evolving Systems

### TST Context

Temporal Software Theory (TST) provides the mathematical framework for understanding why prefactoring works.

Key TST concepts:

1. **Evolving Systems**: Projects without discrete "finish" points where compounding effects dominate
2. **Amortized Impact**: Historical decisions affect all future work
3. **Local Optimization**: Each session can make the next slightly better
4. **Feature Throughput**: Not just speed, but richness of features attempted

### The TST Optimization Formula

For evolving systems, the value of a change is not just its immediate impact, but its impact across all future sessions.

```
Value = Σ(impact on session_i) for i = current to ∞
```

Prefactoring explicitly optimizes this formula by:
- Reducing friction for all future similar features
- Creating patterns that compound
- Preventing code decay
- Enabling progressively richer features

### Context Window as Time Proxy

In AI-assisted development, **context window percentage** is a meaningful proxy for time:

- Onboarding cost = context consumed before productive work
- Implementation cost = context consumed during implementation
- Handoff cost = context needed to resume work

Prefactoring directly reduces these costs.

---

## Implementing Prefactoring in Your Project

### For New Projects

1. **Establish the Culture Early**
   - Make prefactoring an explicit phase
   - Document prefactoring decisions
   - Measure comprehension time
   - Celebrate good prefactors

2. **Build Infrastructure**
   - Scripts for common information gathering
   - Templates for common patterns
   - Tools for semantic analysis
   - Metrics collection

3. **Create Feedback Loops**
   - Track feature implementation time with/without prefactoring
   - Document what made implementations obvious or obscure
   - Share learnings across sessions/agents

### For Existing Projects

1. **Start Small**
   - Pick one feature for explicit prefactor pass
   - Measure the difference
   - Build evidence for the approach

2. **Don't Do "Big Bang" Refactors**
   - Prefactor opportunistically
   - Each feature gets its prefactor session
   - Code gets progressively cleaner

3. **Focus on High-Traffic Areas**
   - Prefactor the parts of the codebase touched most often
   - Create clear patterns in central modules
   - Let clarity spread outward

### For AI-Heavy Projects

1. **Optimize for Agent Comprehension**
   - Clear semantic naming
   - Consistent patterns
   - Discoverable structure
   - Self-documenting code

2. **Experiment and Measure**
   - Run A/B tests with different agents
   - Track context consumption
   - Identify what actually helps

3. **Build Agent-Friendly Infrastructure**
   - LSP integration
   - Graph-based editing tools
   - Automatic feedback mechanisms
   - Rich type information

---

## Key Quotes and Insights

### On Speed and Optimization

> "Given the dual-goal of each session, in my experience—optimizing for current feature completion by the entity doing it is almost always wasted... it misses the target at best, and actually almost certainly pushes the needle exactly the wrong way."

### On Taking Time

> "Take all the time you need to thoughtfully do this right, with your assumptions becoming visible and decisions documented... Take all the time in the world—and then let's talk about what could have made that even easier."

### On Results

> "I've seen teams that use this approach to take a rather chaotic project that is so tied in knots that features are painfully slow to finish, and speed up by orders of magnitude over several months—and have a code base that was getting hairier and hairier get cleaner and cleaner and more obvious."

### On Semantic Precision

> "Part of the prefactoring often involves things like 'integrate this new understanding of the domain and our more nuanced definitions for these words into the code base—changing a bunch of variable names to be more precise etc.—things that seem like, at best an indulgence in times past turns out to be extremely effective for evolving code-bases so that code and domain drift are conquered."

### On Measurement

> "If the session is just the prefactor session and its another agent altogether that does the feature—you have a 'speed-to-comprehension' metric that is high-quality right away."

### On Epistemic Humility

> "We want to get away from the LLM's legacy training that causes a false sense of decisiveness and certainty that, in a mostly-AI-project, turns into red herrings and turmoil."

### On the Dual Goal

> "Each session has two tasks: push features forward, and (2) make it so the next agent has a slightly easier time than you, or is able to push forward a larger feature or more of a feature than you... That can be measured."

---

## Application to Autopax

### Immediate Applications

1. **Session Structure**
   - Make prefactoring an explicit phase in development workflow
   - Before implementing any feature: "What refactoring would make this obvious?"
   - Document the prefactoring decisions in commit messages

2. **Measurement Infrastructure**
   - Track context consumption by phase (onboarding, exploration, implementation)
   - Measure how quickly fresh agents can implement features
   - Build A/B testing for different approaches

3. **Documentation Standards**
   - Favor code that documents itself over separate documentation files
   - Create scripts/templates over explanatory documents
   - Make assumptions and decisions visible in the code

4. **Agent Handoff Protocol**
   - Explicit prefactor commits before feature commits
   - Clear documentation of what was prepared and why
   - Success metrics for the preparation

### Cultural Principles for Autopax

1. **Truth-First**
   - Epistemic humility in all planning
   - Ground claims in evidence and measurement
   - Avoid false confidence

2. **Long-Term Thinking**
   - Optimize for the next agent, not just this session
   - Think about cumulative, compounding effects
   - Value clarity over immediate speed

3. **Semantic Precision**
   - Align code terminology with domain understanding
   - Keep code and domain in sync
   - Treat naming as a first-class concern

4. **Measurable Progress**
   - Define clear metrics for comprehension
   - Run experiments when uncertain
   - Build feedback loops

### Workflow Integration

For Autopax development, implement this pattern:

```ruby
# In toys dev pre-feature <feature-name>
# 1. Load feature requirements
# 2. Explore codebase, tracking journey
# 3. Identify what would make implementation obvious
# 4. Write safety tests
# 5. Make refactorings
# 6. Document what was prepared
# 7. Commit as prefactor

# In toys dev implement <feature-name>
# Fresh agent (or same agent, fresh context)
# 1. Read prefactor documentation
# 2. Verify understanding
# 3. Implement feature
# 4. Measure: how much exploration was needed?
```

### Infrastructure Needs

1. **Metrics Collection**
   - Context consumption tracking
   - File/symbol access patterns
   - Search queries and results
   - Time/token measurements

2. **Testing Framework**
   - Easy creation of "safety net" tests
   - Property-based testing for invariants
   - Integration test scaffolding

3. **Refactoring Tools**
   - Semantic renaming across project
   - Structure visualization
   - Drift detection
   - Pattern extraction

---

## Conclusion

Prefactoring is not just a technique—it's a **fundamental shift in how we think about code evolution**. Rather than treating refactoring as technical debt to be paid down under pressure, prefactoring treats it as **preparation that compounds**.

The evidence is compelling: teams using this approach see order-of-magnitude improvements while code quality increases rather than degrades.

For AI-assisted development, prefactoring is even more critical. The quality of the "prepared ground" directly determines how effectively agents can implement features, how much context they consume, and how successful handoffs between sessions are.

**The core insight**: Don't optimize for speed of current feature. Optimize for making the next feature obvious. That compounds.

---

## Further Reading

To fully understand the context and theory behind prefactoring, study:

- **TST (Temporal Software Theory) Distilled**: Mathematical framework for evolving systems
- **AI-Applied-TST**: Specific applications for AI-assisted development
- **AI-TST-Vision**: Visionary document on AI-first development approaches

---

*Document compiled from conversation between Joseph Wecker and Claude (Sonnet 4.5) discussing the Sar programming language project and AI-assisted development practices. The conversation represents hard-won lessons from multiple projects: Synaptic, Sapientia, Zoetica, Ennaos, and others.*

*Key contributor noted in source material: The agent who helped crystallize these concepts requested the pen-name "Architectus" for their contribution to documenting TST and prefactoring principles.*
