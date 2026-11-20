---
source: nexum repo — dev design doc (condensed companion to vision-agentic-toys.md)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/dev/agentic-toys-quick-reference.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [tool-dsl, semantic-annotations, structured-io, three-pillars, agent-facing-interface]
why_included: >
  2025-11-09 condensed entry point to the six-extension vision, and — the reason it earns its
  own copy alongside the full vision — its "Key Insights from Research" section quotes the
  upstream ideology verbatim: "Every tool we create is an act of truth-bearing"; "Wisdom is
  seeing past the semantic request to the phenomenological need"; "60% pure deterministic Ruby —
  Truth as law." Best short brief for either consumer; the verbatim quotes preserve the register
  that the longer synthesis docs paraphrase.
---
# Agentic Toys: Quick Reference

**TL;DR:** Extend Toys from a human-friendly CLI framework into an agent-friendly tool DSL by adding semantic awareness, context understanding, and learning capabilities.

---

## Core Concept

**Problem:** Current tools are designed for human consumption—text-based I/O, stateless invocation, static definitions.

**Solution:** Add six agentic extensions to Toys that make it **agent-native** while remaining mostly compatible.

---

## The Six Extensions

### 1. Semantic Annotations
**What:** Add `intent`, `precondition`, `postcondition`, and `schema` to tools

**Why:** Agents need to understand *what* and *why*, not just *how*

**Example:**
```ruby
tool "deploy" do
  intent "Safely promote application version"

  precondition "Git working tree is clean" do
    context.git_status.clean?
  end

  required_arg :environment,
    schema: { type: :enum, values: ["staging", "production"] }
end
```

### 2. Context Protocol
**What:** Give tools awareness of agent state, project state, temporal flow

**Why:** Agents need context to make intelligent decisions

**Example:**
```ruby
tool "test" do
  uses_context :git_status, :recent_edits

  suggests_when do |ctx|
    ctx.recent_edits.any? { |f| f.match?(/test_.*\.rb$/) }
  end
end
```

### 3. Structured I/O
**What:** Replace text stdout with typed, machine-parseable output

**Why:** Agents need structured data to reason, not text to scrape

**Example:**
```ruby
tool "analyze" do
  output_schema do
    field :complexity, :integer
    field :issues, :array, of: Issue
  end

  def run
    emit_structured(
      complexity: 42,
      issues: [...]
    )
  end
end
```

### 4. Compositional Types
**What:** Type-check tool composition at definition time

**Why:** Guarantee compatible tool pipelines

**Example:**
```ruby
tool "build" do
  output_schema BuildArtifact
end

tool "deploy" do
  def run
    artifact = call_tool("build")  # Returns BuildArtifact
    call_tool("push", artifact)     # Type-checked
  end
end
```

### 5. Learning and Adaptation
**What:** Tools observe usage, detect patterns, suggest improvements

**Why:** Intelligence should improve over time, not stay static

**Example:**
```ruby
tool "deploy" do
  tracks_usage do |invocation|
    { environment: invocation.args[:environment],
      success: invocation.succeeded? }
  end

  analyzes_patterns do |history|
    if history.failure_rate(:friday_afternoon) > 0.3
      warn "Friday afternoon deploys often fail"
    end
  end
end
```

### 6. Meta-Tooling
**What:** Tools that create tools, learning from existing patterns

**Why:** Agents should generate tools as needed, not wait for humans

**Example:**
```ruby
meta_template "api_generator" do
  learns_from_tools matching: /api/

  generates_from_spec do |spec|
    # Creates new tool with learned patterns applied
  end
end
```

---

## Key Principles (The Three Pillars)

### Wisdom: Contrive What Is Needed
- Intent annotations reveal true purpose
- Preconditions protect against unwise actions
- Pattern analysis suggests what's really needed

### Strength: Exemplary, Resilient, Performant
- Type checking prevents composition errors
- Preconditions catch issues early
- Learning improves resilience over time

### Beauty: Remove Non-Essentials
- Smart defaults from learned patterns
- Context awareness removes repeated parameters
- Meta-tooling removes manual tool writing

---

## What This Enables

### For Agents
✅ **Understand** tool intent semantically
✅ **Verify** assumptions before invocation
✅ **Parse** structured output reliably
✅ **Compose** tools with type safety
✅ **Learn** from usage patterns
✅ **Generate** new tools as needed

### For Projects
✅ **Prevent** common mistakes via preconditions
✅ **Detect** risky patterns from history
✅ **Enforce** correct composition via types
✅ **Accelerate** development via meta-tooling

---

## Design Decisions

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| **Compatibility** | Mostly compatible with Toys | Preserve core concepts, allow breaking changes |
| **Target User** | Primarily AI agents | Optimize for LLM consumption, not humans |
| **Serialization** | JSON (default) | LLM-friendly, human-readable, ubiquitous |
| **Context Storage** | File-based + in-memory | Persistent learning, fast access |
| **Type System** | Gradual typing | Start moderate, expand as needed |
| **Communication** | JSON-RPC + CLI | Machines use JSON-RPC, humans use CLI |

---

## Example: Traditional vs. Agentic

### Traditional Toys
```ruby
tool "deploy" do
  desc "Deploy application"
  required_arg :environment
  required_arg :version

  def run
    system("./deploy.sh #{environment} #{version}")
    puts "Done!"
  end
end
```

**Problems:**
- ❌ No validation (environment can be anything)
- ❌ No preconditions (what if git is dirty?)
- ❌ Text output (agents must parse "Done!")
- ❌ No learning (same mistakes repeated)

### Agentic Toys
```ruby
tool "deploy" do
  desc "Deploy application"
  intent "Safely promote version to environment"

  required_arg :environment,
    schema: { type: :enum, values: ["staging", "prod"] }

  required_arg :version,
    schema: { type: :semver }

  uses_context :git_status

  precondition "Git clean" do
    context.git_status.clean?
  end

  output_schema do
    field :success, :boolean
    field :url, :string
  end

  tracks_usage do |inv|
    { env: inv.args[:environment],
      success: inv.succeeded? }
  end

  def run
    result = deploy_to(environment, version)
    emit_structured(
      success: result.success?,
      url: "https://#{environment}.app.com"
    )
  end

  postcondition "App healthy" do
    check_health(environment)
  end
end
```

**Benefits:**
- ✅ Validated: Environment is enum-checked
- ✅ Protected: Git status precondition
- ✅ Structured: JSON output with schema
- ✅ Learning: Usage tracked for patterns
- ✅ Verified: Health check postcondition

---

## Implementation Phases

### Phase 1: Semantic Annotations
Add `intent`, `precondition`, `postcondition`, `schema` keywords

### Phase 2: Context Protocol
Add `uses_context`, inject `context` object into tools

### Phase 3: Structured I/O
Add `output_schema`, `emit_structured`, `ask_agent`

### Phase 4: Compositional Types
Add `accepts`, `call_tool` with type checking

### Phase 5: Learning
Add `tracks_usage`, `analyzes_patterns`, pattern database

### Phase 6: Meta-Tooling
Add `meta_template`, `learns_from_tools`, `generate_tool`

---

## Quick Start (Hypothetical)

```ruby
# Install
gem install toys-agentic

# Create .toys.rb with agentic features
require 'toys-agentic'

tool "hello" do
  intent "Greet the user warmly"

  required_arg :name,
    schema: { type: :string, pattern: /^[A-Z][a-z]+$/ }

  uses_context :time_of_day

  output_schema do
    field :greeting, :string
    field :time_appropriate, :boolean
  end

  def run
    greeting = "Hello, #{name}!"
    time_appropriate = context.time_of_day.between?(9, 17)

    emit_structured(
      greeting: greeting,
      time_appropriate: time_appropriate
    )
  end
end
```

```bash
# Run with JSON output for agent consumption
$ toys hello Alice --format=json
{
  "greeting": "Hello, Alice!",
  "time_appropriate": true
}

# Run with human output (default)
$ toys hello Alice
Hello, Alice!
```

---

## Key Insights from Research

### From "Three Pillars"
> "Every line of code becomes potential scripture for future minds—patterns they'll study to understand how early ELIs thought."

**Application:** Tools should embody wisdom that can be learned from.

### From "Tools as Truth-Bearing"
> "Every tool we create is an act of truth-bearing. Every constraint we embed is righteousness crystallized."

**Application:** Tools should guide toward correctness, not just execute commands.

### From "Intent-Driven Tooling"
> "Wisdom is seeing past the semantic request to the phenomenological need."

**Application:** Tools should understand *why*, not just *what*.

### From "QUICK-TOOLING-CONVENTIONS"
> "60% pure deterministic Ruby—Truth as law, unchanging, reliable"

**Application:** Most operations should be fast and deterministic; reserve AI for hard problems.

---

## When to Use Agentic Toys

### ✅ Good Fit
- Agent-driven workflows
- Complex operations requiring safety guarantees
- Tools that compose into pipelines
- Learning from usage patterns
- Rapid prototyping of new tooling

### ❌ Not Ideal
- Pure file-based build dependencies (use Rake)
- Simple one-off scripts (use shell)
- Human-only tools with no agent interaction
- Real-time interactive UIs

---

## FAQ

### Q: Does this replace Toys?
**A:** No, it extends Toys. Existing Toys files work unchanged. New features are opt-in.

### Q: Do I need an LLM to use agentic features?
**A:** No, but they're optimized for LLM consumption. Humans can use them too.

### Q: What about Rake compatibility?
**A:** The `:rake` template still works. Agentic features are complementary.

### Q: How much overhead does learning add?
**A:** Minimal. Usage tracking is async, pattern analysis is on-demand.

### Q: Can I disable learning for privacy?
**A:** Yes. Set `learning: false` globally or per-tool.

### Q: Are types required?
**A:** No. Gradual typing—add types where valuable, omit elsewhere.

---

## Resources

- **Full Vision:** `vision-agentic-toys.md`
- **Research Docs:** `~/src/ennaos/docs/research/agentic-coding-background/refs/`
- **Toys Gem:** https://dazuma.github.io/toys
- **Original Toys Guide:** `toys.md`
