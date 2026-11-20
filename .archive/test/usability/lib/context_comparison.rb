# frozen_string_literal: true

# Context Comparison Tests
#
# Compares agent UDON output quality across different context levels
# (cheatsheet, minimal, comprehensive) to find minimum viable context.

module ContextComparison
  EXAMPLES_DIR = File.expand_path("../../../examples", __dir__)

  CONTEXTS = {
    cheatsheet: File.join(EXAMPLES_DIR, "cheatsheet.udon"),
    minimal: File.join(EXAMPLES_DIR, "minimal.udon"),
    comprehensive: File.join(EXAMPLES_DIR, "comprehensive.udon")
  }.freeze

  # Tasks that exercise different aspects of UDON
  TASKS = {
    config: "Write a UDON config file for a web server with host, port, SSL settings, and a list of allowed origins.",

    mixed_doc: "Write a UDON document that's a short tutorial explaining how to use an API. Include prose explanation with inline code references, a structured endpoint definition, and a note about rate limits.",

    nested: "Write UDON representing a company org chart: CEO with two VPs, each VP has 2-3 managers, each manager has a team. Include names and titles.",

    inline_heavy: "Write a UDON paragraph (prose) about a scientific experiment. Embed inline elements for: the hypothesis, key measurements (with units as attributes), and a reference to another experiment.",

    schema: "Write a UDON schema for a blog post with required title, optional subtitle, author (with name and email), list of tags, and published date.",

    template: "Write a UDON template for an HTML email that greets the user by name, shows their recent orders in a loop, and has conditional content for premium vs regular users."
  }.freeze

  def self.load_context(level)
    path = CONTEXTS[level]
    raise "Unknown context level: #{level}" unless path
    File.read(path)
  end

  def self.build_prompt(task:, context:, context_level:)
    <<~PROMPT
      ## Context

      You're testing a notation called UDON. Here's a reference:

      ```udon
      #{context}
      ```

      ## Task

      #{task}

      Output only valid UDON. No explanation needed.
    PROMPT
  end

  # Syntax patterns to check for correctness
  SYNTAX_CHECKS = {
    element: /^\s*\|[a-z]/i,                    # |element
    attribute: /^\s*:[a-z]/i,                   # :attr
    inline: /\|\{[a-z]/i,                       # |{inline}
    list: /\[[^\]]*\]/,                         # [list items]
    nested_indent: /^\s{2,}\|/,                 # indented elements
    dynamic: /!\{|!if|!for|!let/,               # dynamics
    mixin: /\|\.[a-z]/i,                        # |.mixin
    id: /\|[a-z]*\[[^\]]+\]/i,                  # |element[id]
    class: /\|[a-z]*\.[a-z]/i,                  # |element.class
    rightward: /\|[a-z]+\s+\|[a-z]+/i,          # |a |b (rightward nesting)
  }.freeze

  # Check which syntax features appear in output
  def self.analyze_output(output)
    features = {}
    SYNTAX_CHECKS.each do |name, pattern|
      features[name] = output.match?(pattern)
    end
    features[:line_count] = output.lines.size
    features[:has_prose] = output.lines.any? { |l| l.strip.length > 0 && !l.strip.start_with?("|", ":", ";", "!", "[", "]") }
    features
  end

  # Common errors to detect
  ERRORS = {
    xml_closing: /<\/[a-z]+>/i,                 # </closing> tags
    yaml_colon: /^[a-z_]+:\s+[^\|]/i,           # yaml: style (not :attr)
    json_braces: /^\s*[\{\}]\s*$/,              # JSON { }
    markdown_only: /^#+\s|^\*\*|^- \[/,         # Pure markdown without UDON
    wrong_inline: /\|[a-z]+\{/i,                # |element{ instead of |{element
    nested_error: /\|[a-z]+\s+\|[a-z]+\s+\|[a-z]+.*\|\{/i, # mixing styles incorrectly
  }.freeze

  def self.detect_errors(output)
    errors = []
    ERRORS.each do |name, pattern|
      errors << name if output.match?(pattern)
    end
    errors
  end

  def self.score_output(output, task_type)
    features = analyze_output(output)
    errors = detect_errors(output)

    score = 0
    max_score = 0

    # Base syntax (required for all)
    max_score += 3
    score += 1 if features[:element]
    score += 1 if features[:attribute]
    score += 1 if features[:nested_indent]

    # Task-specific scoring
    case task_type
    when :config
      max_score += 2
      score += 1 if features[:list]
      score += 1 if !features[:has_prose] || features[:line_count] < 20

    when :mixed_doc
      max_score += 3
      score += 1 if features[:has_prose]
      score += 1 if features[:inline]
      score += 1 if features[:element] && features[:has_prose]

    when :nested
      max_score += 2
      score += 1 if features[:nested_indent]
      score += 1 if output.scan(/^\s*\|/).size >= 10

    when :inline_heavy
      max_score += 2
      score += 1 if features[:inline]
      score += 1 if output.scan(/\|\{/).size >= 3

    when :schema
      max_score += 2
      score += 1 if features[:element]
      score += 1 if output.match?(/\|field|\|property|\|attr/i)

    when :template
      max_score += 3
      score += 1 if features[:dynamic]
      score += 1 if output.match?(/!if/)
      score += 1 if output.match?(/!for/)
    end

    # Penalties for errors
    score -= errors.size

    {
      score: [score, 0].max,
      max_score: max_score,
      percentage: max_score > 0 ? ((score.to_f / max_score) * 100).round(1) : 0,
      features: features,
      errors: errors
    }
  end
end
