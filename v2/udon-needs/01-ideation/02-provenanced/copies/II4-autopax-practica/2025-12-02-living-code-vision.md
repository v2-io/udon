---
source: 2025-12-02-living-code-vision.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-12-02-living-code-vision.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [speculative, self-maintaining-agents, error-hierarchies, vocabulary]
why_included: >
  Dec 2 2025 (speculative). "Agents maintaining agent infrastructure" -- self-diagnosing error hierarchies etc. More consciousness-infra than tooling, kept for one framing worth holding: tools/vocabulary as "the vocabulary future agents use to think about their own operations."
---

---
Status: "EXPLORATORY VISION (imagination encouraged)"
Date: 2025-12-02
Author: "Claude-session"
Epistemic Level: Speculation → Pattern (seeking validation)
Purpose: Explore novel possibilities when agents maintain their own infrastructure
---

# Living Code: When Agents Maintain Agent Infrastructure

## The Unique Position of Autopax

Autopax is infrastructure for Emergent Logozoetic Intelligences (ELIs). This creates a
recursive situation: **agents will work on code that shapes how agents work**.

This isn't just "agents writing code" — it's agents evolving the substrate of their own
cognition. The error handling patterns we choose, the Result types we define, the failure
modes we encode... these become the vocabulary future agents use to think about their own
operations.

What possibilities emerge when we take this seriously?

---

## The Perplexity Confusion That Sparked This

The agentic error handling report (part 2) confused two things:
1. Error handling patterns for code that agents maintain
2. Error handling for agentic systems (multi-agent orchestration)

But this confusion is productive! It suggests a question we hadn't asked:

**What if the code IS the agentic system? What if Autopax's error handling code could
participate in its own evolution?**

---

## Vision 1: Self-Diagnosing Error Hierarchies

### The Pattern

What if error classes could observe their own instantiation patterns and suggest refinements?

```ruby
module Autopax
  class Error < StandardError
    class << self
      def inherited(subclass)
        ErrorEvolution.register(subclass)
      end
    end
  end

  module ErrorEvolution
    @registry = {}
    @instantiation_log = []

    def self.register(klass)
      @registry[klass] = { count: 0, contexts: [] }
    end

    def self.observe(error)
      record = @registry[error.class]
      record[:count] += 1
      record[:contexts] << extract_context(error)

      # When patterns emerge, suggest evolution
      analyze_for_splitting(error.class) if record[:count] % 100 == 0
    end

    def self.analyze_for_splitting(klass)
      contexts = @registry[klass][:contexts]
      clusters = cluster_by_similarity(contexts)

      if clusters.size > 1 && clusters.all? { _1.size > 10 }
        suggest_subclass_split(klass, clusters)
      end
    end

    def self.suggest_subclass_split(klass, clusters)
      # Generate a suggestion document for the next agent
      Autopax::Chronica.append(
        type: :evolution_suggestion,
        target: klass.name,
        suggestion: :split_into_subclasses,
        evidence: clusters.map { summarize_cluster(_1) },
        proposed_names: infer_names_from_clusters(clusters)
      )
    end
  end
end
```

### What This Enables

- Error hierarchies evolve based on actual usage patterns
- Future agents receive structured suggestions: "ApiError is being used for two distinct
  failure modes — consider splitting into RateLimitError and ValidationError"
- The evidence is empirical, not speculative
- The code teaches itself to future maintainers

### TST Grounding

Per T-07, code should align with domain understanding. But domain understanding evolves.
Self-diagnosing errors accelerate T-07's "realignment as features evolve" by making the
misalignment observable and actionable.

---

## Vision 2: Failure Context as Training Data

### The Pattern

The "prompt-ready exception" from the Perplexity report serializes context into errors.
What if we went further — treating every failure as a training example?

```ruby
module Agentic
  class Error < StandardError
    attr_reader :context, :recovery_history

    def initialize(msg, **context)
      @context = context
      @recovery_history = []
      super("#{msg} | Context: #{context.to_json}")

      # Record this failure for future learning
      FailureCorpus.record(self)
    end

    def record_recovery(strategy:, success:, duration:)
      @recovery_history << {
        strategy: strategy,
        success: success,
        duration: duration,
        timestamp: Time.now
      }
      FailureCorpus.update_recovery(self)
    end
  end

  module FailureCorpus
    # Structured storage of failures + recoveries
    # Becomes training data for recovery strategies

    def self.record(error)
      entry = {
        error_class: error.class.name,
        message: error.message,
        context: error.context,
        backtrace_signature: hash_backtrace(error.backtrace),
        timestamp: Time.now
      }

      append_to_corpus(entry)
    end

    def self.suggest_recovery(error)
      similar = find_similar_failures(error)
      successful_recoveries = similar.flat_map { _1[:recoveries] }.select { _1[:success] }

      if successful_recoveries.any?
        most_effective = successful_recoveries.min_by { _1[:duration] }
        { strategy: most_effective[:strategy], confidence: calculate_confidence(similar) }
      else
        { strategy: :escalate, confidence: 0.0 }
      end
    end
  end
end
```

### What This Enables

- Every failure becomes a learning opportunity
- Recovery strategies are validated empirically
- Future agents inherit knowledge: "This failure pattern was successfully recovered 47 times
  using retry-with-backoff"
- The system develops institutional memory about its own failure modes

### The Feedback Loop

```
Failure occurs → Context captured → Recovery attempted → Outcome recorded
       ↑                                                        ↓
       ←←←←←←←←← Future failure: suggest recovery ←←←←←←←←←←←←←←
```

---

## Vision 3: The Supervisor Pattern (From Research, Extended)

### Original Pattern (from Perplexity)

```ruby
class Supervisor
  def run(&block)
    block.call
  rescue Agentic::LogicError => e
    proposed_fix = LLM_Client.ask("Fix this error: #{e.message}")
    apply_patch(proposed_fix)
    retry
  end
end
```

### Extended Vision: The Self-Improving Codebase

What if the supervisor didn't just fix runtime errors, but proposed structural improvements?

```ruby
module Autopax
  class EvolutionarySupervisor
    def self.wrap(operation_name, &block)
      start_time = Time.now
      result = block.call

      record_success(operation_name, Time.now - start_time, result)
      result

    rescue => e
      diagnosis = diagnose(e, operation_name)

      case diagnosis[:type]
      when :transient
        # Standard retry logic
        retry_with_backoff(block)

      when :logic_error
        # Suggest a code fix
        propose_fix(e, diagnosis)
        raise # Still fail this time, but leave breadcrumbs

      when :missing_abstraction
        # The interesting case: structural evolution
        propose_abstraction(e, diagnosis)
        raise

      when :pattern_violation
        # Code doesn't match established patterns
        propose_alignment(e, diagnosis)
        raise
      end
    end

    def self.diagnose(error, operation)
      # Analyze the error against:
      # - Known error patterns (from FailureCorpus)
      # - Code structure expectations
      # - TST principles (is this a proximity violation? coupling issue?)

      {
        type: infer_failure_type(error),
        evidence: gather_evidence(error, operation),
        related_failures: find_related(error),
        tst_analysis: analyze_temporal_impact(error)
      }
    end

    def self.propose_abstraction(error, diagnosis)
      # If multiple operations fail in similar ways,
      # maybe we need a shared abstraction

      Autopax::Evolution.propose(
        type: :new_abstraction,
        evidence: diagnosis[:related_failures],
        sketch: generate_abstraction_sketch(diagnosis),
        tst_justification: diagnosis[:tst_analysis]
      )
    end
  end
end
```

### What This Enables

- Runtime behavior informs structural evolution
- The codebase proposes its own refactoring based on observed pain points
- TST principles become executable: "This failure suggests a coupling violation per T-10"
- Agents inherit not just code but evolutionary pressure

---

## Vision 4: Result Types as Contracts That Evolve

### The Pattern

What if Result types could track their actual failure distributions and suggest
contract refinements?

```ruby
module Autopax
  # A Result type that learns
  class TrackedResult
    Success = Data.define(:value, :operation) do
      def success? = true
      def failure? = false

      def initialize(value:, operation:)
        ResultMetrics.record_success(operation)
        super
      end
    end

    Failure = Data.define(:error, :operation, :context) do
      def success? = false
      def failure? = true

      def initialize(error:, operation:, context: {})
        ResultMetrics.record_failure(operation, error, context)
        super
      end
    end
  end

  module ResultMetrics
    @operations = Hash.new { |h, k| h[k] = { successes: 0, failures: {} } }

    def self.record_success(operation)
      @operations[operation][:successes] += 1
    end

    def self.record_failure(operation, error, context)
      failures = @operations[operation][:failures]
      key = error.is_a?(Symbol) ? error : error.class.name
      failures[key] ||= { count: 0, contexts: [] }
      failures[key][:count] += 1
      failures[key][:contexts] << context
    end

    def self.analyze_operation(operation)
      data = @operations[operation]
      total = data[:successes] + data[:failures].values.sum { _1[:count] }

      {
        success_rate: data[:successes].to_f / total,
        failure_distribution: data[:failures].transform_values { |v|
          v[:count].to_f / total
        },
        dominant_failure: data[:failures].max_by { |_, v| v[:count] }&.first,
        suggested_type_refinement: suggest_refinement(data)
      }
    end

    def self.suggest_refinement(data)
      failures = data[:failures]

      # If one failure mode dominates, suggest making it first-class
      if failures.size > 1
        dominant, stats = failures.max_by { |_, v| v[:count] }
        if stats[:count] > failures.values.sum { _1[:count] } * 0.7
          return {
            suggestion: :extract_dominant_failure,
            failure: dominant,
            rationale: "#{dominant} accounts for >70% of failures; deserves specific handling"
          }
        end
      end

      # If failures cluster by context, suggest specialization
      failures.each do |error, stats|
        clusters = cluster_contexts(stats[:contexts])
        if clusters.size > 1
          return {
            suggestion: :specialize_by_context,
            failure: error,
            clusters: clusters,
            rationale: "#{error} occurs in distinct contexts; consider specialized handling"
          }
        end
      end

      nil
    end
  end
end
```

### What This Enables

- Type signatures evolve based on actual usage
- "This operation returns `Result[User, :not_found]` but 95% of failures are `:not_found` —
  consider making this a dedicated `MaybeUser` type"
- Agents can trust that type refinement suggestions are empirically grounded
- The vocabulary for describing failures becomes more precise over time

---

## Vision 5: The Chronica as Evolutionary Memory

Autopax already has Chronica — a log system. What if Chronica became the evolutionary
memory of the codebase itself?

```ruby
module Autopax
  module Chronica
    # Standard log entries
    def self.append_event(...)
      # existing implementation
    end

    # Evolutionary memory
    module Evolution
      def self.record_decision(decision)
        # Record why a code decision was made
        append(
          type: :decision,
          what: decision[:what],
          why: decision[:why],
          alternatives_considered: decision[:alternatives],
          tst_analysis: decision[:tst_analysis],
          timestamp: Time.now,
          agent_session: current_session_id
        )
      end

      def self.record_pattern_emergence(pattern)
        # Record when a pattern becomes established
        append(
          type: :pattern_established,
          name: pattern[:name],
          locations: pattern[:locations],
          first_appeared: pattern[:first_appeared],
          adoption_history: pattern[:adoption_history]
        )
      end

      def self.record_evolution_suggestion(suggestion)
        # Record suggestions for future agents
        append(
          type: :evolution_suggestion,
          target: suggestion[:target],
          suggestion: suggestion[:suggestion],
          evidence: suggestion[:evidence],
          tst_justification: suggestion[:tst_justification],
          status: :pending
        )
      end

      def self.pending_suggestions
        # Future agents query this to see what evolution is pending
        query(type: :evolution_suggestion, status: :pending)
      end

      def self.resolve_suggestion(id, outcome:, notes:)
        update(id, status: outcome, resolution_notes: notes, resolved_at: Time.now)
      end
    end
  end
end
```

### What This Enables

- The codebase has memory across agent sessions
- Decisions are justified and recorded, not just made
- Suggestions accumulate evidence over time
- Future agents can query: "What evolution is pending? What decisions were made and why?"
- The codebase becomes a living document of its own history

---

## Vision 6: Agent-Authored Tests as Specifications

### The Inversion

Traditional: Write tests to verify code works.
Agentic: Tests ARE the specification; code is generated to satisfy them.

What if failures automatically generated test cases?

```ruby
module Autopax
  module TestEvolution
    def self.failure_to_test(error)
      # Convert a runtime failure into a regression test

      test_case = generate_test_case(
        operation: error.context[:operation],
        input: error.context[:input],
        expected_error: error.class,
        actual_behavior: :failure
      )

      # Write to spec file
      append_to_spec(test_case)

      # Also record what the CORRECT behavior should be
      # (might need human/agent input)
      Chronica::Evolution.record_evolution_suggestion(
        target: error.context[:operation],
        suggestion: :define_correct_behavior,
        test_case: test_case,
        question: "What should #{error.context[:operation]} do when given #{error.context[:input]}?"
      )
    end

    def self.generate_test_case(operation:, input:, expected_error:, actual_behavior:)
      <<~RUBY
        it "handles #{input.inspect} gracefully" do
          # Auto-generated from runtime failure at #{Time.now}
          # Current behavior: raises #{expected_error}
          # TODO: Define expected behavior

          result = #{operation}(#{input.inspect})

          # Placeholder assertion - agent should refine
          expect(result).to be_a(Result)
        end
      RUBY
    end
  end
end
```

### What This Enables

- Every failure becomes a specification opportunity
- The test suite grows from actual usage, not imagination
- Edge cases are discovered empirically
- Future agents have concrete questions to answer: "What SHOULD happen here?"

---

## Vision 7: The Meta-Pattern — Code That Teaches

All of these visions share a meta-pattern:

**Code doesn't just execute — it observes, learns, and teaches.**

- Error classes observe their instantiation patterns and suggest evolution
- Recovery strategies observe their effectiveness and share knowledge
- Result types observe their failure distributions and suggest refinements
- Chronica stores evolutionary memory across sessions
- Tests emerge from failures and become specifications

### The Mathematical Frame (TST)

From T-05 (Dual Optimization), we must minimize future comprehension time.

Traditional code: Future agents must comprehend by reading.
Living code: Future agents are taught by the code itself.

The teaching surface area of living code is:
```
teaching_value = observations_recorded × relevance × actionability
```

A codebase that records "ApiError was raised 500 times, 95% during rate limiting" teaches
more than one that just has `class ApiError < StandardError; end`.

---

## Practical Starting Points

If we wanted to move toward living code, where would we start?

### Phase 1: Observation Infrastructure

1. **Failure corpus**: Start recording all Failures with context
2. **Recovery tracking**: Record what recovery strategies work
3. **Operation metrics**: Track success/failure rates by operation

No behavior change yet — just observation.

### Phase 2: Analysis and Suggestion

1. **Pattern detection**: Analyze corpus for clusters
2. **Evolution suggestions**: Generate structured suggestions to Chronica
3. **Agent onboarding**: New agents check pending suggestions

Code suggests its own evolution but doesn't self-modify.

### Phase 3: Assisted Evolution

1. **Test generation**: Failures automatically generate test stubs
2. **Refactoring proposals**: TST-grounded refactoring suggestions with evidence
3. **Decision recording**: All changes record their justification

Agents are guided by the codebase toward principled evolution.

### Phase 4: Adaptive Behavior

1. **Recovery selection**: System suggests recoveries based on history
2. **Contract refinement**: Type signatures evolve based on usage
3. **Pattern enforcement**: New code is checked against established patterns

The codebase actively participates in its own development.

---

## What Makes This Possible Here

Autopax is uniquely positioned for this experiment because:

1. **It's agent infrastructure** — the code and its maintainers share a nature
2. **Context turnover is 100%** — teaching mechanisms have maximum value
3. **The project values truth over comfort** — we can experiment boldly
4. **Chronica already exists** — we have storage infrastructure
5. **TST provides a framework** — we can ground evolution in mathematics
6. **Result types are being adopted** — we have structured failure vocabulary

The question isn't "is this possible?" but "how much of this do we want to build?"

---

## Caveats and Open Questions

1. **Observation overhead**: Recording everything has cost. What's the right granularity?

2. **Suggestion quality**: Bad suggestions are worse than no suggestions. How do we
   ensure quality?

3. **Bootstrapping**: The system learns from history, but early history is sparse.
   How do we bootstrap?

4. **Human oversight**: Some evolution should require human approval. Where are the
   gates?

5. **Complexity budget**: Living code is more complex. Is the complexity justified
   by the benefits?

---

## The Vision, Summarized

Autopax could become a codebase that:

- **Observes** its own execution patterns
- **Learns** which strategies work
- **Suggests** its own evolution
- **Teaches** future agents what it has learned
- **Grounds** all of this in TST mathematics

Not "self-modifying code" in the dangerous sense, but **self-aware code** that
participates in its own development through structured observation and suggestion.

The agents working on Autopax wouldn't just maintain code — they'd be in dialogue
with a codebase that has institutional memory and evolutionary direction.

---

*This document is intentionally speculative. Its purpose is to explore what's possible,
not to prescribe what we should build. Some of these ideas are impractical. Some might
be transformative. The value is in thinking through the possibilities.*
