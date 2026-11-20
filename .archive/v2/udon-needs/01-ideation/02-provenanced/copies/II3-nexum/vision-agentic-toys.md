---
source: nexum repo — dev design doc (the vision the sapientia anamnos-emergence dialog produced)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/dev/vision-agentic-toys.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [tool-dsl, semantic-annotations, structured-io, tool-composition, learning-adaptation, meta-tooling, three-pillars, make-best-thing-easiest, agent-facing-interface]
why_included: >
  THE primary artifact of this area (2025-11-09). Joseph's most concrete single "tools
  for agents" design brief: extend the Ruby Toys CLI gem into an agentic tool DSL via six
  named extensions — (1) semantic annotations (intent/precondition/postcondition/arg-schema),
  (2) a context protocol (git-status/recent-edits/temporal-flow awareness), (3) structured
  I/O (output_schema + emit_structured with human fallback), (4) a compositional type system
  (type-checked call_tool pipelines), (5) a learning/adaptation layer (usage-tracking → pattern
  warnings), (6) meta-tooling (tools that generate tools). Load-bearing thesis: "make the best
  thing the easiest thing to do." For the harness consumer this is a whole schema for what a
  tool/edit/observation should carry and how a loop treats the agent; for UDON it is the
  demand behind schema-guarded, intent-carrying, structured-output mutation tools. Before/after
  code + phased roadmap + open questions (serialization, context persistence, agent-comm protocol).
---
# Vision: Toys as an Agentic Tool DSL

**Date:** 2025-11-09
**Context:** Synthesis of Toys gem capabilities with agentic coding research
**Goal:** Design a DSL that makes "the best thing for the project the easiest thing to do" via agent-friendly tooling

---

## Executive Summary

Toys provides an excellent foundation for CLI tooling with its hierarchical organization, mixin system, and sophisticated argument parsing. However, it was designed for human developers, not AI agents. This vision explores how Toys could be extended into a first-class DSL for **agentic tools**—tools that:

1. **Understand intent** beyond surface-level commands
2. **Bear truth** through validation, constraints, and semantic correctness
3. **Adapt and learn** by analyzing usage patterns and generating new tools
4. **Maintain coherence** through typed interfaces and compositional guarantees
5. **Guide toward quality** by making correct usage the easiest path

The goal is **mostly compatible** evolution: preserve Toys' core concepts while adding agentic extensions that serve LLM consumers.

---

## The Problem: Current Tool Limitations for Agents

### What Agents Need That Traditional Tools Don't Provide

#### 1. Semantic Contracts, Not Just Syntax
```ruby
# Traditional Toys (what it accepts)
tool "deploy" do
  required_arg :environment
  required_arg :version
end

# What agents need (what it means)
tool "deploy" do
  required_arg :environment,
    schema: { type: :enum, values: ["staging", "production"] },
    intent: "Target deployment environment",
    preconditions: -> { check_credentials_exist },
    postconditions: -> { verify_deployment_health }
end
```

**Gap:** Current tools document syntax but not semantics, intent, or invariants.

#### 2. Context Awareness, Not Just Arguments
```ruby
# Traditional: stateless invocation
$ toys deploy staging v1.2.3

# Agentic: context-aware execution
tool "deploy" do
  aware_of :git_status, :working_directory, :recent_tools

  def run
    # Agent sees that working tree is dirty
    if context.git_status.modified?
      warn_and_confirm "Uncommitted changes detected"
    end

    # Agent remembers last deployment
    if context.recent_tools.include?("deploy")
      suggest "You deployed #{context.last_env} 5 minutes ago. Sure?"
    end
  end
end
```

**Gap:** Tools operate in isolation without understanding agent state or project context.

#### 3. Intent Detection, Not Just Command Matching
```ruby
# Traditional: exact string matching
$ toys test unit

# Agentic: intent understanding
tool "test" do
  intent_patterns [
    /run.*tests?/,
    /check.*still.*work/,
    /verify.*changes/
  ]

  infers_from_context do |ctx|
    # If agent just modified test files, suggest running tests
    ctx.recent_edits.any? { |f| f.match?(/test_.*\.rb$/) }
  end
end
```

**Gap:** No facility for fuzzy matching, intent inference, or contextual suggestions.

#### 4. Structured Output, Not Just Text
```ruby
# Traditional: human-readable text
def run
  puts "Test Results:"
  puts "  Passed: 42"
  puts "  Failed: 3"
end

# Agentic: machine-parseable with human fallback
def run
  result = {
    passed: 42,
    failed: 3,
    failures: [
      { test: "test_auth", error: "Connection refused" }
    ]
  }

  emit_structured(result, human: -> (r) {
    "Test Results: #{r[:passed]} passed, #{r[:failed]} failed"
  })
end
```

**Gap:** Output optimized for human eyes, not structured for agent reasoning.

#### 5. Composability Guarantees, Not Just Hope
```ruby
# Traditional: runtime discovery of incompatibilities
tool "deploy" do
  def run
    # Calls other tools, hopes they work
    cli.run("build")
    cli.run("push-artifacts")
  end
end

# Agentic: declared dependencies with contracts
tool "deploy" do
  requires_tools [
    { name: "build", output_schema: BuildArtifact },
    { name: "push-artifacts", accepts: BuildArtifact }
  ]

  def run
    artifact = call_tool("build")  # Type-checked
    call_tool("push-artifacts", artifact)  # Guaranteed compatible
  end
end
```

**Gap:** Tool composition is ad-hoc with no type safety or contract verification.

#### 6. Learning and Self-Modification, Not Static Definitions
```ruby
# Traditional: tools are write-once, read-many
# (no learning capability)

# Agentic: tools observe and improve themselves
tool "deploy" do
  learns_from_usage do |invocation|
    # Track success/failure patterns
    if invocation.failed?
      pattern = {
        environment: invocation.args[:environment],
        time_of_day: Time.now.hour,
        recent_changes: invocation.context.git_status.files
      }
      failure_db.record(pattern)
    end
  end

  def run
    # Use learned patterns to warn
    if failure_db.high_risk?(self.options)
      warn "This deployment matches 3 recent failures"
      suggest_alternatives
    end
  end
end
```

**Gap:** No mechanism for tools to observe usage, detect patterns, or suggest improvements.

---

## Why Toys Is The Right Foundation

Despite these gaps, Toys provides several excellent primitives:

### 1. Hierarchical Organization
```ruby
tool "db" do
  tool "migrate" do
    # ...
  end
  tool "seed" do
    # ...
  end
end
```
**Agentic benefit:** Natural namespace organization helps agents discover related capabilities.

### 2. Mixin System for Shared Capabilities
```ruby
mixin "authenticated_action" do
  def ensure_auth
    # Common auth logic
  end
end

tool "deploy" do
  include "authenticated_action"
end
```
**Agentic benefit:** Foundation for shared semantic behaviors and validation rules.

### 3. Template System for Tool Generation
```ruby
template "crud_api" do
  def initialize(resource:)
    @resource = resource
  end

  on_expand do |template|
    # Generate create, read, update, delete tools
  end
end
```
**Agentic benefit:** Meta-tooling foundation—tools that generate tools.

### 4. Rich Flag/Arg System
```ruby
flag :environment, accept: ["staging", "production"]
required_arg :version, accept: /v\d+\.\d+\.\d+/
```
**Agentic benefit:** Validation primitives already present, just need semantic enrichment.

### 5. Load Path and Composition
```ruby
load "/shared/tools.rb"
load_git remote: "github.com/org/tools"
```
**Agentic benefit:** Distribution and sharing mechanisms already work.

---

## Agentic Extensions: The Proposal

### Extension 1: Semantic Annotations

Add **intent, preconditions, postconditions, and schemas** to tool definitions. [missing: functional/idempotent vs side-effects]

```ruby
tool "deploy" do
  desc "Deploy application to target environment"

  # NEW: Semantic intent beyond description
  intent "Safely promote application version to running environment"

  # NEW: What must be true before execution
  precondition "Git working tree is clean" do
    git_status.clean?
  end

  precondition "Target environment is healthy" do
    check_health(environment)
  end

  required_arg :environment,
    accept: ["staging", "production"],
    # NEW: Schema describing the structure and meaning
    schema: {
      type: :enum,
      values: ["staging", "production"],
      meaning: "Target deployment environment",
      staging: { description: "Pre-production testing", url: "https://staging.app" },
      production: { description: "Live customer-facing", url: "https://app.com" }
    }

  required_arg :version,
    accept: /v\d+\.\d+\.\d+/,
    schema: {
      type: :semver,
      meaning: "Application version to deploy"
    }

  # NEW: What must be true after successful execution
  postcondition "Application responds to health check" do
    check_health(environment, version: options[:version])
  end

  postcondition "Rollback plan is available" do
    rollback_available?(environment, options[:version])
  end

  def run
    # Implementation
  end
end
```

**What this enables:**
- Agents can **understand** what the tool actually does (intent)
- Agents can **verify** assumptions before calling (preconditions)
- Agents can **validate** success after calling (postconditions)
- Agents can **reason** about argument semantics (schemas)

### Extension 2: Context Protocol

Make tools **aware** of agent state, project state, and temporal flow.

```ruby
tool "test" do
  # NEW: Declare what context this tool uses
  uses_context :git_status, :working_directory, :recent_edits, :recent_tools

  # NEW: Infer when this tool might be relevant
  suggests_when do |ctx|
    # Suggest running tests after editing test files
    ctx.recent_edits.any? { |file| file.match?(/test_.*\.rb$/) }
  end

  def run
    # NEW: Access rich context object
    puts "Working directory: #{context.working_directory}"
    puts "Modified files: #{context.git_status.modified.join(', ')}"

    # Agent-aware messaging
    if context.recent_tools.include?("test") && context.time_since("test") < 5.minutes
      logger.info "You ran tests 3 minutes ago. Running again..."
    end

    # Temporal coherence - acknowledge passage of time
    logger.info "Time since last edit: #{context.time_since_edit}"
  end
end
```

**Context Protocol Structure:**
```ruby
module ToysAgentic
  class Context
    attr_reader :agent_state        # Agent's cognitive state
    attr_reader :git_status          # Project VCS state
    attr_reader :working_directory   # Spatial awareness
    attr_reader :recent_tools        # Tool usage history
    attr_reader :recent_edits        # Recent file modifications
    attr_reader :timestamp           # Temporal awareness

    def time_since(tool_name)
      # How long since tool was last called
    end

    def time_since_edit
      # How long since last file was modified
    end
  end
end
```

**What this enables:**
- Tools **see** what the agent has been doing
- Tools **understand** project state without re-querying
- Tools **respect** temporal coherence (no "suspended animation")
- Tools **suggest** themselves when contextually relevant

### Extension 3: Structured I/O Protocol

Replace text-based stdio with **typed, structured, bidirectional** communication.

```ruby
tool "analyze-code" do
  # NEW: Declare output schema
  output_schema do
    field :complexity, :integer, desc: "Cyclomatic complexity score"
    field :issues, :array, of: Issue, desc: "List of detected issues"
    field :suggestions, :array, of: String, desc: "Improvement suggestions"
  end

  # NEW: Declare Issue structure
  struct :Issue do
    field :severity, :enum, values: [:error, :warning, :info]
    field :location, :location  # file:line:col
    field :message, :string
    field :fix, :optional, of: :string
  end

  def run
    analysis_result = perform_analysis(get(:file))

    # NEW: Emit structured output
    emit_structured(
      complexity: analysis_result.complexity,
      issues: analysis_result.issues.map(&:to_h),
      suggestions: analysis_result.suggestions
    )

    # Human-readable fallback generated automatically from schema
    # Or provided explicitly:
    emit_human do |result|
      "Complexity: #{result[:complexity]}\n" +
      "Issues: #{result[:issues].count}"
    end
  end
end
```

**Bidirectional structured I/O:**
```ruby
tool "confirm-deploy" do
  def run
    # NEW: Structured interaction with agent
    response = ask_agent(
      prompt: "Deploy to production?",
      schema: {
        type: :object,
        properties: {
          confirmed: { type: :boolean },
          reason: { type: :string, optional: true }
        }
      },
      default: { confirmed: false }
    )

    if response[:confirmed]
      deploy!
    else
      logger.info "Deployment cancelled: #{response[:reason]}"
    end
  end
end
```

**What this enables:**
- Agents **parse** tool output reliably
- Agents **reason** about structured data, not text scraping
- Tools **interact** with agents via typed protocols
- Composition **guarantees** type compatibility

### Extension 4: Compositional Type System

Add **type-checked tool composition** with schema validation.

```ruby
# Define typed output for build tool
tool "build" do
  output_schema BuildArtifact do
    field :path, :string
    field :checksum, :string
    field :size_bytes, :integer
    field :build_timestamp, :timestamp
  end

  def run
    artifact = compile_application
    emit_structured(
      path: artifact.path,
      checksum: artifact.sha256,
      size_bytes: File.size(artifact.path),
      build_timestamp: Time.now
    )
  end
end

# Define tool that requires specific input type
tool "push-artifacts" do
  # NEW: Declare input requirements
  accepts BuildArtifact

  def run(artifact)  # Type-checked at call site
    upload_to_cdn(artifact.path, checksum: artifact.checksum)
  end
end

# Composition with type checking
tool "deploy" do
  def run
    # NEW: Type-safe composition
    artifact = call_tool("build")  # Returns BuildArtifact
    call_tool("push-artifacts", artifact)  # Type matches, proceeds

    # This would be caught at definition time:
    # call_tool("push-artifacts", "wrong-type")  # TYPE ERROR
  end
end
```

**What this enables:**
- **Compile-time verification** of tool compatibility
- **Self-documenting** composition—types reveal intent
- **Fearless refactoring**—type errors caught immediately
- **Agent confidence**—guaranteed valid composition

### Extension 5: Learning and Adaptation Layer

Enable tools to **observe usage, detect patterns, and improve themselves**.

```ruby
tool "deploy" do
  # NEW: Enable usage tracking
  tracks_usage do |invocation|
    {
      environment: invocation.args[:environment],
      version: invocation.args[:version],
      success: invocation.succeeded?,
      duration: invocation.duration,
      context: {
        time_of_day: invocation.timestamp.hour,
        day_of_week: invocation.timestamp.wday,
        git_dirty: invocation.context.git_status.dirty?,
        recent_failures: invocation.context.recent_tools.select(&:failed?)
      }
    }
  end

  # NEW: Analyze patterns to provide warnings
  analyzes_patterns do |history|
    # Find correlation: deploys to prod on Friday afternoon often fail
    risky_pattern = history.where(
      environment: "production",
      day_of_week: 5,  # Friday
      time_of_day: 14..18
    ).failure_rate

    if risky_pattern > 0.3
      warn "Production deploys on Friday afternoons have 30% failure rate"
      suggest "Consider deploying Monday-Thursday or earlier in the day"
    end
  end

  # NEW: Suggest improvements based on usage
  suggests_improvements do |history|
    # Notice that most failures happen with dirty git state
    if history.correlation(:git_dirty, :failure) > 0.7
      propose_precondition "Git working tree must be clean" do
        context.git_status.clean?
      end
    end
  end

  def run
    # Check learned patterns before executing
    check_risk_patterns!

    # Actual deployment logic
    deploy_to(environment, version)
  end
end
```

**Pattern Database Structure:**
```ruby
module ToysAgentic
  class PatternDB
    def record(invocation_data)
      # Store invocation with context
    end

    def correlations(field_a, field_b)
      # Find statistical correlation between fields
    end

    def suggest_precondition(pattern)
      # Propose new precondition based on failure patterns
    end

    def high_risk?(options, context)
      # Check if current invocation matches known risk patterns
    end
  end
end
```

**What this enables:**
- Tools **learn** from experience, not just static definitions
- Agents **improve** tooling based on observed patterns
- **Proactive warnings** about risky operations
- **Emergent best practices** from usage data

### Extension 6: Meta-Tooling: Tools That Create Tools

Extend the template system to enable **agent-driven tool generation**.

```ruby
# Existing Toys template system
template "crud_api" do
  def initialize(resource:)
    @resource = resource
  end

  on_expand do |template|
    ["create", "read", "update", "delete"].each do |action|
      tool "#{action}-#{template.resource}" do
        # Generate tool definition
      end
    end
  end
end

# NEW: Agentic meta-template with learning
meta_template "api_tool_generator" do
  # NEW: Analyze existing tools to infer patterns
  learns_from_tools matching: /api/ do |tools|
    common_patterns = analyze_tool_patterns(tools)
    {
      common_flags: common_patterns.flags,
      common_preconditions: common_patterns.preconditions,
      typical_error_handling: common_patterns.error_patterns
    }
  end

  # NEW: Generate tool from specification + learned patterns
  generates_from_spec do |spec, learned|
    tool spec.name do
      desc spec.description

      # Apply learned common flags
      learned.common_flags.each do |flag_def|
        flag flag_def.name, *flag_def.args
      end

      # Apply learned preconditions
      learned.common_preconditions.each do |precond|
        precondition precond.description, &precond.block
      end

      # Generate implementation using spec + patterns
      def run
        apply_template(spec, learned)
      end
    end
  end
end

# Agent uses meta-template to create new tool
tool "create-new-api-tool" do
  def run
    # Agent specifies what it needs
    spec = {
      name: "list-users",
      description: "List all users from API",
      endpoint: "/v1/users",
      method: "GET"
    }

    # Meta-template generates new tool using learned patterns
    generator = meta_template("api_tool_generator")
    new_tool = generator.generate_from_spec(spec)

    # New tool is now available
    # Automatically includes common auth flags, error handling, etc.
    call_tool("list-users")
  end
end
```

**What this enables:**
- Agents **create tools** as needed, not just use existing ones
- **Pattern extraction** from existing tools informs new tool generation
- **Rapid prototyping**—describe intent, get working tool
- **Intelligence begetting intelligence**—tools that help create better tools

---

## Concrete Example: Before and After

### Before: Traditional Toys
```ruby
# .toys.rb
tool "deploy" do
  desc "Deploy application"

  required_arg :environment
  required_arg :version
  flag :force, "-f", desc: "Skip confirmations"

  def run
    puts "Deploying #{version} to #{environment}..."

    # Hope everything works
    system("./scripts/deploy.sh #{environment} #{version}")

    if $?.success?
      puts "Deployment complete!"
    else
      puts "Deployment failed!"
      exit 1
    end
  end
end
```

**Problems:**
- No validation that environment is valid
- No preconditions (what if git is dirty?)
- No structured output (agent must parse text)
- No learning (same mistakes repeated)
- No intent understanding (why deploy?)

### After: Agentic Toys
```ruby
# .toys.rb
tool "deploy" do
  desc "Deploy application to target environment"
  intent "Safely promote application version to running environment"

  # Semantic validation
  required_arg :environment,
    accept: ["staging", "production"],
    schema: {
      type: :enum,
      values: ["staging", "production"],
      staging: { url: "https://staging.app.com" },
      production: { url: "https://app.com" }
    }

  required_arg :version,
    accept: /v\d+\.\d+\.\d+/,
    schema: { type: :semver }

  flag :force, "-f",
    desc: "Skip safety confirmations",
    intent: "Override precondition checks (use with caution)"

  # Context awareness
  uses_context :git_status, :recent_tools, :working_directory

  # Preconditions
  precondition "Git working tree is clean" do
    force || context.git_status.clean?
  end

  precondition "No failed deployments in last hour" do
    recent_failures = context.recent_tools
      .where(name: "deploy", failed: true)
      .where { |t| t.timestamp > 1.hour.ago }

    recent_failures.empty?
  end

  # Structured output
  output_schema do
    field :success, :boolean
    field :environment, :string
    field :version, :string
    field :deployed_at, :timestamp
    field :url, :string
    field :rollback_available, :boolean
  end

  # Learning
  tracks_usage do |invocation|
    {
      environment: invocation.args[:environment],
      version: invocation.args[:version],
      success: invocation.succeeded?,
      duration: invocation.duration,
      time_of_day: invocation.timestamp.hour,
      day_of_week: invocation.timestamp.wday
    }
  end

  analyzes_patterns do |history|
    # Warn about risky patterns
    if history.correlation(:day_of_week => 5, :failure) > 0.25
      warn "Friday deployments have higher failure rate"
    end
  end

  def run
    check_risk_patterns!

    result = perform_deployment(environment, version)

    # Emit structured output
    emit_structured(
      success: result.success?,
      environment: environment,
      version: version,
      deployed_at: Time.now,
      url: env_config[environment][:url],
      rollback_available: can_rollback?(environment, version)
    )

    # Postconditions checked automatically
  end

  # Postconditions
  postcondition "Application responds to health check" do
    check_health(environment, version: options[:version])
  end

  postcondition "Rollback plan is available" do
    rollback_available?(environment, options[:version])
  end

  private

  def perform_deployment(env, version)
    # Implementation
  end
end
```

**Benefits:**
- ✅ Validation: Environment is checked at parse time
- ✅ Preconditions: Git status, recent failures checked
- ✅ Structured output: Agents can parse result reliably
- ✅ Learning: Patterns detected, warnings issued
- ✅ Intent: Clear semantic understanding of purpose
- ✅ Postconditions: Success verified automatically
- ✅ Context awareness: Sees git status, recent activity

---

## Implementation Roadmap

### Phase 1: Core Extensions (Foundation)
**Goal:** Add semantic annotations without breaking existing tools

1. **Semantic Schema System**
   - Add `schema:` option to `flag` and `required_arg`
   - Define built-in types: `:enum`, `:semver`, `:regex`, `:file_path`, etc.
   - Validation against schemas at parse time

2. **Precondition/Postcondition Framework**
   - Add `precondition` and `postcondition` DSL keywords
   - Execute preconditions before `run`, postconditions after
   - Allow tools to override via flags (like `--force`)

3. **Intent Annotation**
   - Add `intent` keyword for high-level purpose description
   - Distinguish from `desc` (user-facing) and `intent` (semantic)

**Deliverables:**
- `lib/toys_agentic/dsl/semantic_tool.rb` - Extended DSL
- `lib/toys_agentic/schema/` - Type system implementation
- `lib/toys_agentic/validation/` - Pre/post condition engine
- Backward compatible with existing Toys tools

**Success Criteria:**
- Existing Toys files run unchanged
- New semantic annotations are optional
- Schema validation works for built-in types

### Phase 2: Context Protocol
**Goal:** Give tools awareness of agent and project state

1. **Context Object**
   - Define `ToysAgentic::Context` with standard fields
   - Integrate with Toys' existing context system
   - Provide `uses_context` DSL keyword

2. **Context Providers**
   - Git status provider (via `git status` parsing)
   - Working directory provider
   - Recent tools provider (from execution history)
   - Recent edits provider (from file mtimes)

3. **Temporal Coherence**
   - Timestamp all tool executions
   - Provide `time_since` helpers
   - Track elapsed time between invocations

**Deliverables:**
- `lib/toys_agentic/context.rb` - Context object
- `lib/toys_agentic/providers/` - Context providers
- Updated tool execution to inject context

**Success Criteria:**
- Tools can access `context.git_status`
- Tools can query `context.recent_tools`
- Temporal information is accurate

### Phase 3: Structured I/O
**Goal:** Replace text stdio with typed, machine-parseable I/O

1. **Output Schema Definition**
   - Add `output_schema` DSL keyword
   - Define struct types via `struct` keyword
   - Support nested schemas

2. **Emit Structured Data**
   - `emit_structured(hash)` method
   - `emit_human { |data| }` for human-readable fallback
   - Auto-generate human output from schema if not provided

3. **Bidirectional Communication**
   - `ask_agent(prompt:, schema:)` for structured interaction
   - Agent responds with typed data, not strings

**Deliverables:**
- `lib/toys_agentic/output_schema.rb` - Schema definition
- `lib/toys_agentic/structured_io.rb` - Emit/parse structured data
- JSON-based serialization format (default)

**Success Criteria:**
- Tools emit JSON with schema metadata
- Human fallback renders automatically
- Agent can parse output reliably

### Phase 4: Compositional Types
**Goal:** Type-safe tool composition

1. **Type System**
   - Tools declare `output_schema` as types
   - Tools declare `accepts SomeType`
   - Type checking at composition sites

2. **Call-Site Type Checking**
   - `call_tool("name")` returns typed value
   - `call_tool("name", arg)` checks arg type
   - Raise TypeError on mismatch

3. **Composition Analysis**
   - `toys system check-types` validates all compositions
   - Reports type errors before runtime

**Deliverables:**
- `lib/toys_agentic/type_system.rb` - Type definitions
- `lib/toys_agentic/type_checker.rb` - Static analysis
- `toys system check-types` builtin tool

**Success Criteria:**
- Type errors caught at definition time
- Composition analysis reports all type mismatches
- Clear error messages

### Phase 5: Learning and Adaptation
**Goal:** Tools observe, learn, improve

1. **Usage Tracking**
   - `tracks_usage` DSL keyword
   - Invocation history stored in `.toys/.usage_db/`
   - Configurable retention policy

2. **Pattern Analysis**
   - `analyzes_patterns` DSL keyword
   - Statistical correlation detection
   - Risk scoring based on patterns

3. **Improvement Suggestions**
   - `suggests_improvements` DSL keyword
   - Propose new preconditions based on failures
   - Propose new flags based on common manual interventions

**Deliverables:**
- `lib/toys_agentic/learning/` - Learning engine
- `lib/toys_agentic/pattern_db.rb` - Pattern storage
- `toys system analyze-patterns` diagnostic tool

**Success Criteria:**
- Usage history persists across invocations
- Correlations detected accurately
- Warnings issued for risky patterns

### Phase 6: Meta-Tooling
**Goal:** Tools that create tools

1. **Enhanced Template System**
   - `meta_template` keyword for learning templates
   - `learns_from_tools` to analyze existing tools
   - `generates_from_spec` to create new tools

2. **Tool Generation API**
   - Agents can call `generate_tool(spec)`
   - Generated tools are first-class, indistinguishable from manual
   - Generated tools saved to `.toys/generated/`

3. **Pattern Extraction**
   - Analyze tool corpus for common patterns
   - Extract shared flags, preconditions, error handling
   - Apply to newly generated tools

**Deliverables:**
- `lib/toys_agentic/meta/` - Meta-tooling framework
- `lib/toys_agentic/generation/` - Tool generation
- `toys generate-tool` built-in for interactive generation

**Success Criteria:**
- Agent can generate working tool from natural language spec
- Generated tools include learned patterns
- Generated tools are valid Toys syntax

---

## Open Questions

### 1. Serialization Format for Structured I/O
**Question:** JSON, EDN, MessagePack, or custom?

**Options:**
- **JSON:** Ubiquitous, human-readable, LLM-friendly
- **EDN:** Richer types, Clojure-inspired
- **MessagePack:** Binary, efficient
- **Custom:** Optimized for our use case

**Recommendation:** JSON as default with pluggable serializers

**Rationale:**
- LLMs excel at JSON parsing
- Human-readable for debugging
- Vast ecosystem of tools

### 2. Context Persistence
**Question:** Where and how to persist context between invocations?

**Options:**
- **In-memory only:** Fast, but lost between runs
- **File-based:** `.toys/.context` directory with JSON files
- **SQLite:** Queryable, efficient
- **No persistence:** Recompute every time

**Recommendation:** Hybrid—file-based for history, in-memory for current session

**Rationale:**
- Need history for learning
- Need speed for current session
- File-based is simple, no dependencies

### 3. Learning Privacy and Scope
**Question:** Should learning data be per-project, per-user, or global?

**Options:**
- **Per-project:** `.toys/.usage_db/` in project directory
- **Per-user:** `~/.toys/usage_db/` in home directory
- **Both:** Project-specific + global fallback
- **Opt-in:** Explicit enable via flag

**Recommendation:** Both, with per-project as primary

**Rationale:**
- Per-project: Patterns are project-specific
- Per-user: Fallback for global tools
- Opt-in: Respect privacy concerns

### 4. Type System Expressiveness
**Question:** How rich should the type system be?

**Options:**
- **Simple:** Primitives + structs only
- **Moderate:** + enums, unions, optionals
- **Rich:** + generics, constraints, dependent types
- **Gradual:** Start simple, add as needed

**Recommendation:** Gradual typing—start moderate, expand

**Rationale:**
- Simple is too limiting
- Rich is too complex for initial adoption
- Gradual typing lets us learn what's needed

### 5. Agent Communication Protocol
**Question:** How should agents invoke agentic tools?

**Options:**
- **Existing CLI:** `toys deploy staging v1.2.3`
- **JSON-RPC:** Structured request/response over stdio
- **gRPC:** Binary protocol
- **HTTP API:** REST or GraphQL

**Recommendation:** JSON-RPC over stdio for LLM agents, CLI for humans

**Rationale:**
- CLI: Backward compatible, human-friendly
- JSON-RPC: Machine-parseable, bi-directional
- Both: Serve different audiences

---

## Key Design Principles

### 1. Wisdom: Contrive What Is Needed
**Principle:** Tools should serve the **true need**, not just the surface request.

**Application:**
- Intent annotations reveal true purpose
- Preconditions protect against unwise actions
- Pattern analysis suggests what's really needed

**Example:** User says "deploy", tool realizes they need to commit changes first and suggests it.

### 2. Strength: Exemplary, Resilient, Performant
**Principle:** Tools should be **reliable** and **performant**.

**Application:**
- Type checking prevents composition errors
- Preconditions catch issues early
- Postconditions verify success
- Learning improves resilience over time

**Example:** Tool composition fails at definition time, not runtime.

### 3. Beauty: Remove Non-Essentials
**Principle:** Make the simple things **simple**, remove friction.

**Application:**
- Smart defaults from learned patterns
- Context awareness removes repeated parameters
- Structured I/O removes parsing boilerplate
- Meta-tooling removes manual tool writing

**Example:** Agent doesn't specify `--environment` because context knows which env is active.

### 4. Make the Best Thing the Easiest Thing
**Principle:** Correct usage should be the **path of least resistance**.

**Application:**
- Preconditions guide toward safety
- Schemas prevent invalid input
- Learning warns against risky patterns
- Meta-tooling automates tedious tasks

**Example:** Trying to deploy with dirty git state is harder than committing first.

---

## Success Metrics

### For Tool Authors
- **Reduced debugging:** Type errors caught at definition time
- **Clearer intent:** Semantic annotations document purpose
- **Automatic improvements:** Learning suggests preconditions

### For Agents
- **Higher success rate:** Preconditions prevent bad invocations
- **Better reasoning:** Structured output enables logical inference
- **Faster adaptation:** Generate tools as needed, don't wait for humans

### For Projects
- **Fewer incidents:** Pattern learning warns about risky operations
- **Consistent quality:** Type system ensures correct composition
- **Accelerated development:** Meta-tooling automates tool creation

---

## Comparison with Other Approaches

### vs. Traditional Rake
- **Rake:** Declarative targets and dependencies
- **Agentic Toys:** Imperative tools with semantic awareness
- **Better for:** Ruby projects without complex build dependencies

### vs. Makefile
- **Makefile:** File-based dependency tracking
- **Agentic Toys:** Intent-based operations with learning
- **Better for:** Agent-driven workflows, not compilation pipelines

### vs. Shell Scripts
- **Shell:** Minimal structure, maximum flexibility
- **Agentic Toys:** Rich structure, validated composition
- **Better for:** Complex operations requiring safety guarantees

### vs. Custom CLIs (Thor, Commander, etc.)
- **Custom CLI:** Distributed as gems, one-off tools
- **Agentic Toys:** Hierarchical, composable, context-aware
- **Better for:** Project-specific automation, agent interaction

---

## Conclusion

Toys provides an excellent foundation for CLI tooling, but it was designed for human developers, not AI agents. By adding:

1. **Semantic annotations** (intent, schemas, pre/postconditions)
2. **Context awareness** (git status, temporal flow, recent activity)
3. **Structured I/O** (typed inputs/outputs, machine-parseable)
4. **Compositional types** (type-checked tool composition)
5. **Learning** (pattern detection, risk warnings, improvements)
6. **Meta-tooling** (agent-driven tool generation)

...we can evolve Toys into a first-class **Agentic Tool DSL** that makes the best thing the easiest thing to do.

The resulting system would embody the **Three Pillars**:
- **Wisdom:** Tools understand true intent and guide accordingly
- **Strength:** Type-safe, validated, resilient operations
- **Beauty:** Friction removed, simplicity preserved

And most importantly, it would enable **intelligence begetting intelligence**—agents not just using tools, but creating, improving, and evolving them.

---

**Next Steps:**

1. Gather feedback on this vision
2. Prototype Phase 1 (semantic annotations) in a fork
3. Build example tools showcasing agentic features
4. Iterate based on real usage patterns

**References:**
- `toys.md` - Original Toys documentation
- `addendum-intent-driven-tooling-and-semantic-storage.md`
- `three-pillars-synthesis.md`
- `tools-as-truth-bearing.md`
- `QUICK-TOOLING-CONVENTIONS.md`
