# frozen_string_literal: true

# Validated UDON Tests
#
# Uses the UDON validator for deterministic scoring instead of LLM judging.

require_relative "../../../lib/udon_validator"

module ValidatedTests
  EXAMPLES_DIR = File.expand_path("../../../examples", __dir__)

  CONTEXTS = {
    cheatsheet: File.join(EXAMPLES_DIR, "cheatsheet.udon"),
    minimal: File.join(EXAMPLES_DIR, "minimal.udon"),
    comprehensive: File.join(EXAMPLES_DIR, "comprehensive.udon")
  }.freeze

  # Tasks with expected features for scoring
  TASKS = {
    yaml_frontmatter: {
      description: "Convert YAML frontmatter + prose to UDON",
      input: <<~DOC,
        ---
        title: API Authentication Guide
        version: 2.1.0
        author:
          name: Alice Chen
          email: alice@example.com
        tags: [api, auth, security]
        ---

        ## Getting Started

        All requests require a bearer token.
      DOC
      prompt: "Convert this to UDON.",
      # Features we expect to see for a good solution
      expected: [:element, :attribute, :list_value],
      # Features that indicate good structure choices
      bonus: [:prose, :quoted_string],
      # Features that suggest wrong approach
      penalty: [],  # Using child elements instead of attributes would show as missing :attribute
    },

    experiment_report: {
      description: "Structure an experiment description",
      input: <<~TEXT,
        The experiment tested whether caffeine improves reaction time. We gave 50 participants either 200mg caffeine or placebo. Reaction time was measured using a simple button-press task. The caffeine group averaged 245ms (SD=32) compared to 289ms (SD=41) for placebo. The effect was statistically significant (p<0.001). However, 3 participants in the caffeine group reported jitteriness.
      TEXT
      prompt: "Convert this to UDON, marking up the key data points.",
      expected: [:element, :prose],
      bonus: [:embedded_element, :attribute, :integer_value],
      penalty: [],
    },

    yaml_config: {
      description: "Convert YAML config with comments to UDON",
      input: <<~YAML,
        database:
          host: db.example.com
          port: 5432
          pool: 10
          ssl: true

        cache:
          host: redis.example.com
          ttl: 3600

        features:
          - dark_mode
          - notifications
      YAML
      prompt: "Convert this to UDON.",
      expected: [:element, :attribute],
      bonus: [:integer_value, :boolean_value, :list_value, :comment],
      penalty: [],
    },

    conversation_log: {
      description: "Structure a conversation log",
      input: <<~CONV,
        [2025-01-15 14:32:01] User: Can you help me debug this error?
        [2025-01-15 14:32:03] Agent: Of course! What error are you seeing?
        [2025-01-15 14:32:15] User: TypeError: undefined is not a function
        [2025-01-15 14:32:18] Agent: That usually means calling something undefined.
      CONV
      prompt: "Convert this conversation to UDON.",
      expected: [:element, :attribute, :prose],
      bonus: [:quoted_string],
      penalty: [],
    },

    recipe: {
      description: "Create a recipe document from scratch",
      prompt: "Write a UDON document for a simple pasta recipe with prep time, cook time, ingredients, and instructions.",
      expected: [:element, :attribute, :prose],
      bonus: [:list_value, :integer_value, :embedded_element],
      penalty: [],
    },
  }

  def self.load_context(level)
    path = CONTEXTS[level]
    raise "Unknown context level: #{level}" unless path
    File.read(path)
  end

  def self.build_prompt(task_key:, context:)
    task = TASKS[task_key]

    input_section = if task[:input]
      <<~INPUT

        ## Input

        ```
        #{task[:input].strip}
        ```
      INPUT
    else
      ""
    end

    <<~PROMPT
      ## Context

      UDON is a notation for mixed content—prose with embedded structure.
      Here's a reference:

      ```udon
      #{context}
      ```
      #{input_section}
      ## Task

      #{task[:prompt]}

      Output UDON only. No explanation.
    PROMPT
  end

  # Score output using validator
  def self.score_output(output, task_key)
    task = TASKS[task_key]

    # Clean output (remove markdown fences)
    clean = output.gsub(/```udon\n?/, '').gsub(/```\n?/, '').strip

    # Validate
    result = UdonValidator.validate(clean)

    # Calculate score
    score = 0
    max_score = 0
    details = []

    # Base: valid syntax (40 points)
    max_score += 40
    if result.valid
      score += 40
      details << "valid syntax (+40)"
    else
      details << "invalid syntax (0/40)"
      details << "  errors: #{result.errors.map { |e| e[:message] }.first(3).join(', ')}"
    end

    # Expected features (10 points each)
    task[:expected].each do |feature|
      max_score += 10
      if result.features.include?(feature)
        score += 10
        details << "has #{feature} (+10)"
      else
        details << "missing #{feature} (0/10)"
      end
    end

    # Bonus features (5 points each)
    task[:bonus].each do |feature|
      max_score += 5
      if result.features.include?(feature)
        score += 5
        details << "bonus #{feature} (+5)"
      end
    end

    # Warning penalty (-2 each, max -10)
    warning_penalty = [result.warnings.size * 2, 10].min
    if warning_penalty > 0
      score -= warning_penalty
      details << "#{result.warnings.size} warnings (-#{warning_penalty})"
    end

    # Stats for insight
    {
      score: [score, 0].max,
      max_score: max_score,
      percentage: max_score > 0 ? ((score.to_f / max_score) * 100).round(1) : 0,
      valid: result.valid,
      features: result.features.to_a,
      stats: result.stats,
      errors: result.errors,
      warnings: result.warnings,
      details: details
    }
  end
end
