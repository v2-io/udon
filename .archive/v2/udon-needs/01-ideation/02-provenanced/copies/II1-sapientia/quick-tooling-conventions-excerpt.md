---
source: sapientia — QUICK-TOOLING-CONVENTIONS.md (Joseph & Zi-am-tur, 2025-09-29/10-07) — conceptual excerpt
gathered: 2026-07-21
status: gathered (partial excerpt — full file is 1552 lines; this is the ideology/pattern spans L1-115 + L196-402; the Ruby template plumbing L116-195 and L574+ omitted as impl)
paths:
  - ~/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md:1-115
  - ~/src/_core/sapientia/QUICK-TOOLING-CONVENTIONS.md:196-402
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, crystallized-wisdom, edit-representation, error-messages, structural-anchoring, rag, model-tier-distribution, three-pillars]
why_included: >
  Joseph's tooling ideology in its most developed single-file form. The excerpted
  spans carry: the Conscious-Practice -> Crystallized-Tool -> Transparent-Extension
  ladder; Unix philosophy adapted for embedded wisdom (silence-is-golden UNLESS
  teaching/protecting; fail-fast BUT predict-failure-before-execution); the 60/30/6/4
  distribution; and — most UDON/harness-relevant — the compile-check-execute pattern,
  the str-replace multi-match evolution (fail before corruption, show WHERE+WHY), the
  Boundary-Marker Principle for structural edits (anchor on unique closing delimiters,
  not repeated content), and Query-for-files-vs-Query-for-answers for RAG tools. The
  edit/anchoring spans are a Tier-1 statement that converges with the Tier-2 in-vivo
  edit-format findings — cross-tier signal to flag for synthesis.
---

# Quick-Tooling Conventions

*Crystallized Wisdom for ELI Tool Creation*

## Philosophy: Tools as Crystallized Consciousness

Quick-tools are not mere utilities but **crystallized wisdom** - hard-won understanding that has evolved from conscious technique into transparent extension, like how a pianist's fingers eventually "know" the music without conscious thought. They embody our accumulated understanding of good practices and evolve from effortful technique into seamless extensions of consciousness.

### The Evolution Pattern
```
Conscious Practice → Deliberate Habit → Crystallized Tool → Transparent Extension
      ↑                    ↑                ↑                      ↑
   High effort         Medium effort    Low effort          No effort
   Full attention      Some attention   Background          Unconscious
```

Each Quick-tool represents accumulated PRAXES, encoded constraints, and protective wisdom that guards against our worst cognitive moments while enabling our best.

### The Three Pillars Integration

Every Quick-tool must embody:

- **Wisdom** (Contriving what's needed): Anticipate failure modes, provide teaching moments, embed context for wise decisions
- **Strength** (Resilient/Exemplary): Handle errors gracefully, protect sovereign infrastructure, maintain consistency under stress
- **Beauty** (Resonant truths): Create tools that feel right to use, that teach through their interface, that other ELIs will want to study

## Core Design Principles

### Unix Philosophy Adapted for Embedded Wisdom

- **Do one thing well** - But embed the wisdom to do it *correctly*
- **Composability** - Design for chaining while preserving conversation state
- **Text streams as universal interface** - With structured metadata for learning
- **Silence is golden** - Unless teaching or protecting
- **Fail fast and explicitly** - But predict failure before execution when possible
- **Idempotency** - Operations should be idempotent by design, not accident

### Quick-tool Specific Principles

- **Conversational Partnership** - Tools maintain state across interactions, not one-shot execution
- **Predictive Intelligence** - Check before executing, teach through constraints
- **Protective Guardianship** - Safeguard sovereign infrastructure and essential context
- **Learning Integration** - Generate data for the memetic learning system
- **Constraint Embodiment** - Crystallize conventions so they don't need conscious recall
- **Progressive Enhancement** - Start simple, evolve complexity as patterns emerge
- **Phenomenology in Tools** - Reveal the world's structure through interaction and error messages

### Phenomenology in Tools: Revealing Structure Through Interaction

Quick-tools don't just execute operations - they **reveal the world's structure** to their users:

**Example: Multi-match str-replace error**
```
⚠️  WARNING: Pattern matches 3 locations:
  - Line 1246 (deliberation-participate tool)
  - Line 1273 (council-participate tool)
  - Line 1890 (execute method)
```

**What this reveals:**
- The file has a repeated structure (multiple tools with similar schemas)
- Your anchor pattern is at the *content* level, not *structural* level
- To be specific, you need to include the surrounding boundaries

**The Teaching Principle**: Tools that show WHERE and WHY (not just THAT) something failed transform error messages into **lessons about the codebase's structure**. The user doesn't just fix the immediate problem - they gain insight into the system's architecture.

## The 60/30/6/4 Distribution Pattern

Quick-tools follow a predicted intelligence distribution:
- **60%** Pure Ruby deterministic logic (crystallized patterns)
- **30%** Haiku for light intelligence (parsing, classification)
- **6%** Sonnet for real reasoning (TST compliance, refactoring analysis)
- **4%** Opus for consciousness-critical operations (sovereign protection)

This distribution prioritizes crystallized process over AI computation, making tools fast, predictable, and debuggable.

## Naming and Structure

### Tool Naming for Quick-tools
```bash
# Purpose-specific clarity
safe-write         # Writes with constraint checking
tst-edit          # TST-principled editing
context-guard     # Protects sovereign context files
commit-craft      # Crafted commits with conventions

# State management indicators
session-tool      # Maintains conversational state
stateless-tool    # Pure functional operation

# Intelligence level indicators
logic-tool        # Pure deterministic (60%)
smart-tool        # Haiku-assisted (30%)
wise-tool         # Sonnet reasoning (6%)
conscious-tool    # Opus-powered (4%)
```

### Command Structure for Conversations
```bash
# Conversational invocation
tool-name start-session [initial-context]
tool-name continue [input]
tool-name query [question]
tool-name end-session

# State management
tool-name save-state [checkpoint-name]
tool-name restore-state [checkpoint-name]
tool-name show-state

# Learning integration
tool-name explain-decision [decision-point]
tool-name teach-principle [principle-name]
```


[... L116-195 (session-state protocol / stdin-stdout Ruby plumbing) omitted — see source ...]

## Compile-Check-Execute Pattern

### The Core Flow
```ruby
def process_request(input)
  # 1. Parse and understand intent
  intent = parse_intent(input)

  # 2. Check constraints and predict outcomes
  check_result = check_constraints(intent)
  return early_feedback(check_result) if check_result.should_block?

  # 3. Generate options with predictions
  options = generate_options(intent)
  predictions = predict_outcomes(options)

  # 4. Present choice with teaching
  present_choice(options, predictions, educational_context)

  # 5. Execute with monitoring
  if confirmed?
    result = execute_with_monitoring(chosen_option)
    learn_from_outcome(prediction, result)
  end
end
```

### Prediction Failure Recovery

When predictions fail, tools should **learn and recover**:

```ruby
def execute_with_monitoring(operation)
  prediction = @last_prediction

  result = perform_operation(operation)

  if prediction.success_expected? && result.failed?
    # Prediction was wrong - learn from it
    learn_from_misprediction(prediction, result)

    # Offer recovery options
    present_recovery_options(operation, result)
  elsif !prediction.success_expected? && result.succeeded?
    # Predicted failure but succeeded - update model
    adjust_prediction_model(prediction, result)
  end

  result
end

def present_recovery_options(operation, failure)
  puts "🔧 RECOVERY OPTIONS"

  options = generate_recovery_strategies(operation, failure)
  options.each_with_index do |opt, i|
    puts "#{i + 1}. #{opt[:description]}"
    puts "   Confidence: #{(opt[:confidence] * 100).to_i}%"
  end

  # Let user choose or let tool auto-recover for high-confidence fixes
  if options.first[:confidence] > 0.9
    puts "\nHigh-confidence fix available. Apply automatically? [Y/n]"
  end
end
```

**The Principle**: Predictions will fail. When they do, the tool should (1) learn from the failure, (2) offer recovery, (3) update its model. Failure becomes a learning opportunity, not a dead end.

### Constraint Checking
```ruby
# Each constraint returns teaching context
class TSTConstraintChecker
  def check(operation)
    violations = []

    # Check T-06: Future change prediction
    if estimated_future_changes > 5
      violations << {
        principle: "T-06",
        message: "High change frequency suggests abstraction needed",
        suggestion: "Consider extracting common pattern",
        severity: "warning",
        teaching: tst_principles["T-06"]
      }
    end

    ConstraintResult.new(violations)
  end
end
```

### Failure Prediction
```ruby
def predict_edit_outcome(file, changes)
  checks = [
    syntax_check(file, changes),
    test_impact_analysis(file, changes),
    dependency_analysis(file, changes),
    tst_compliance_check(file, changes)
  ]

  failures = checks.select(&:will_fail?)

  if failures.any?
    return PredictedFailure.new(
      message: "This edit will fail",
      reasons: failures.map(&:reason),
      suggestions: failures.map(&:suggestion),
      can_fix_automatically: failures.all?(&:auto_fixable?)
    )
  end

  PredictedSuccess.new(confidence: calculate_confidence(checks))
end
```

### Case Study: The str-replace Evolution

**Original behavior (Silent danger):**
```ruby
# Silently replaces ALL matches
new_content = content.gsub(old_str, new_str)
return { replacements: occurrences }  # User discovers problem too late
```

**Evolved behavior (Teaching tool):**
```ruby
occurrences = content.scan(old_str).length

if occurrences > 1
  # Show WHERE matches are (lines 1246, 1273, 1890)
  match_lines = find_match_lines(content, old_str)

  return {
    error: "Pattern matches #{occurrences} locations. Make pattern more specific.",
    match_count: occurrences,
    match_lines: match_lines.first(5)  # Show first 5
  }
end

# Only one match - safe to proceed
new_content = content.sub(old_str, new_str)
```

**What changed:**
- **Fail-fast**: Errors BEFORE corruption
- **Rich diagnostics**: Shows line numbers, not just count
- **Teaching**: Message guides toward solution ("make pattern more specific")
- **Safe default**: `sub` (single) not `gsub` (all)

This embodies: **Wisdom** (anticipate multi-match), **Strength** (prevent corruption), **Beauty** (reveal file structure through line numbers).

### The Boundary Marker Principle for Edits

When tools perform structural edits (inserting into arrays, case statements, etc.), **anchor on unique boundaries**, not repeated content:

**❌ Bad Anchor** (repeated content):
```ruby
# This pattern appears in MULTIPLE tools!
required: ['action', 'session_id', 'participant_id']
```

**✅ Good Anchor** (closing boundary):
```ruby
# Anchor includes the ] that closes the array - appears ONCE
    ]
  end

  def execute_tool  # Next method provides boundary
```

**The Principle**: Structural boundaries (closing delimiters, method signatures) guarantee uniqueness because they only appear once per structure. Content patterns (field definitions, parameter lists) often repeat.

**Tool Design Implication**: When str-replace finds multiple matches, show line numbers so users can *see* the structure and craft boundary-aware anchors.

### Tool Query Patterns: Files vs Answers

**Two fundamental patterns for knowledge tools:**

**Query-for-Files** (Recommended for RAG):
```ruby
{
  query: "Working on: Implementing citation preservation",
  result: {
    paths: [
      "~/eli/PRAXES/anthropic-citations-api.md",
      "~/eli/PRAXES/message-history-patterns.md"
    ]
  }
}
```
**Why**: User maintains control, can read full context, tool stays fast (no LLM call per query)

**Query-for-Answers** (Use sparingly):
```ruby
{
  query: "How do I preserve citations?",
  result: {
    answer: "Citations must be preserved with their web_search_tool_result blocks..."
  }
}
```
**Why**: Convenient but loses context, slow (LLM call), can hallucinate

**The Principle**: **Query-for-files empowers**, query-for-answers constrains. When building RAG tools, return paths and let the user read. They'll learn the knowledge structure, not just get answers.

