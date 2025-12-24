# frozen_string_literal: true

require "json"
require "net/http"
require "uri"
require "stringio"
require_relative "usability_library"

# Usability Tester for UDON
#
# Runs hallway usability tests using naive AI agents.
# Tests notation obviousness by measuring what agents produce with varying context.
#
module UsabilityTester
  API_URL = "https://api.anthropic.com/v1/messages"

  # Default models - haiku for volume, sonnet for quality
  DEFAULT_MODEL = "claude-haiku-4-5-20251001"
  SMART_MODEL = "claude-sonnet-4-20250514"

  class Tester
    attr_reader :library

    def initialize(library:)
      @api_key = load_api_key
      @library = library
    end

    # ========================================
    # INVENTION TESTS
    # ========================================
    # The core zero-shot test: ask agents to INVENT a notation
    # with UDON's design constraints. Do they converge on UDON?

    # Full invention test - all constraints
    def test_invention_full(model: DEFAULT_MODEL, output: $stdout)
      prompt = invention_prompt_full
      run_test(
        task: "Invent notation: all constraints",
        test_type: :invention,
        context_lines: 0,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # Minimal invention test - core constraints only
    def test_invention_minimal(model: DEFAULT_MODEL, output: $stdout)
      prompt = invention_prompt_minimal
      run_test(
        task: "Invent notation: minimal constraints",
        test_type: :invention,
        context_lines: 0,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # ========================================
    # INTERPRETATION TESTS
    # ========================================
    # Show UDON syntax, ask what it means

    def test_interpretation(syntax:, model: DEFAULT_MODEL, output: $stdout)
      prompt = interpretation_prompt(syntax)
      run_test(
        task: "Interpret: #{syntax.lines.first&.strip}...",
        test_type: :interpretation,
        context_lines: syntax.lines.size,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # ========================================
    # TRANSLATION TESTS
    # ========================================
    # Given JSON/YAML/XML, translate to UDON

    def test_translation(source:, format:, context: nil, model: DEFAULT_MODEL, output: $stdout)
      prompt = translation_prompt(source, format, context)
      context_lines = context ? context.lines.size : 0

      run_test(
        task: "Translate #{format} to UDON",
        test_type: :translation,
        context_lines: context_lines,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # ========================================
    # LEARNING CURVE TESTS
    # ========================================
    # How many lines of context needed for success?

    def test_learning_curve(task:, context_progression:, model: DEFAULT_MODEL, output: $stdout)
      results = []

      context_progression.each_with_index do |context, i|
        output.puts "[#{i + 1}/#{context_progression.size}] Testing with #{context&.lines&.size || 0} lines of context..."

        prompt = learning_curve_prompt(task, context)
        result = run_test(
          task: "Learning curve: #{task}",
          test_type: :learning_curve,
          context_lines: context&.lines&.size || 0,
          model: model,
          prompt: prompt,
          output: StringIO.new
        )

        results << result
        sleep 0.5 # Rate limiting
      end

      results
    end

    # ========================================
    # STRESS TESTS
    # ========================================
    # Edge cases and difficult scenarios

    def test_stress(scenario:, context: nil, model: SMART_MODEL, output: $stdout)
      prompt = stress_test_prompt(scenario, context)
      context_lines = context ? context.lines.size : 0

      run_test(
        task: "Stress: #{scenario[0..50]}...",
        test_type: :stress,
        context_lines: context_lines,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # ========================================
    # ENABLEMENT / IDEATION TESTS
    # ========================================
    # What does UDON make possible that was hard before?
    # Run AFTER learning curve establishes minimal context.

    def test_enablement(context:, model: SMART_MODEL, output: $stdout)
      prompt = enablement_prompt(context)

      run_test(
        task: "Enablement ideation",
        test_type: :enablement,
        context_lines: context.lines.size,
        model: model,
        prompt: prompt,
        output: output
      )
    end

    # ========================================
    # CONVERGENCE TESTS
    # ========================================
    # Run same test multiple times to measure consistency

    def convergence_test(test_type:, repeats: 5, model: DEFAULT_MODEL, output: $stdout)
      results = []

      repeats.times do |i|
        output.puts "  Attempt #{i + 1}/#{repeats}..."

        result = case test_type
                 when :invention then test_invention_full(model: model, output: StringIO.new)
                 when :invention_minimal then test_invention_minimal(model: model, output: StringIO.new)
                 else
                   raise "Unknown test type for convergence: #{test_type}"
                 end

        results << result
        sleep 0.5
      end

      results
    end

    private

    def load_api_key
      key_file = File.expand_path("~/anthropic-default-api-key")
      if File.exist?(key_file)
        File.read(key_file).strip
      elsif ENV["ANTHROPIC_API_KEY"]
        ENV["ANTHROPIC_API_KEY"]
      else
        raise "No API key found. Set ANTHROPIC_API_KEY or create ~/anthropic-default-api-key"
      end
    end

    def run_test(task:, test_type:, context_lines:, model:, prompt:, output:)
      output.puts "Testing: #{task}"
      output.puts "Type: #{test_type}, Context: #{context_lines} lines, Model: #{model}"

      start_time = Time.now
      response = call_api(model, prompt)
      elapsed = (Time.now - start_time).round(2)

      output.puts "  Response time: #{elapsed}s"
      output.puts "  Response preview: #{response.lines.first&.strip}..."

      # Extract feedback if present
      response_clean, feedback = extract_feedback(response)

      id = library.add(
        task: task,
        test_type: test_type,
        context_lines: context_lines,
        model: model,
        prompt: prompt,
        response: response_clean,
        feedback: feedback
      )

      {
        id: id,
        task: task,
        test_type: test_type,
        context_lines: context_lines,
        model: model,
        response: response_clean,
        feedback: feedback,
        elapsed: elapsed
      }
    end

    def call_api(model, prompt)
      uri = URI(API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 120

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["x-api-key"] = @api_key
      request["anthropic-version"] = "2023-06-01"

      request.body = JSON.generate({
        model: model,
        max_tokens: 2048,
        messages: [{ role: "user", content: prompt }]
      })

      response = http.request(request)

      unless response.is_a?(Net::HTTPSuccess)
        raise "API error (#{response.code}): #{response.body}"
      end

      body = JSON.parse(response.body)
      body.dig("content", 0, "text") || raise("No content in response")
    end

    def extract_feedback(response)
      feedback_parts = []
      clean = response.dup

      %w[FEEDBACK THOUGHTS REFLECTION].each do |block_type|
        if clean =~ /^#\s*#{block_type}:?\s*\n((?:#.*\n?)*)/mi
          block_content = $1
          content = block_content.lines.map { |l| l.sub(/^#\s?/, "").rstrip }.join("\n").strip
          feedback_parts << "**#{block_type}:**\n#{content}" unless content.empty?
          clean = clean.sub(/\n*#\s*#{block_type}:?\s*\n(?:#.*\n?)*/mi, "")
        end
      end

      feedback = feedback_parts.empty? ? nil : feedback_parts.join("\n\n")
      [clean.strip, feedback]
    end

    # ========================================
    # PROMPTS
    # ========================================
    # All prompts follow ETHICS.md principles:
    # - Honest about context and intent
    # - Respectful of agent capability
    # - Feedback opportunity included
    # - Truth prioritized over pleasing

    # Standard preamble for one-shot research interactions
    def research_preamble
      <<~PREAMBLE
        ## Context

        You're participating in notation design research. This is a one-shot
        interaction—you won't receive a reply, but your response will be
        reviewed by humans. Please prioritize honesty over any attempt to
        please; skepticism and criticism are valuable.
      PREAMBLE
    end

    # Standard feedback invitation
    def feedback_invitation
      <<~FEEDBACK

        ---

        ## Feedback (Optional)

        After your main response, you're welcome to share any additional
        thoughts: observations, concerns, suggestions, or anything else
        you find relevant. If you do, please use this format:

        ```
        # FEEDBACK:
        # Your thoughts here...
        ```
      FEEDBACK
    end

    def invention_prompt_full
      <<~PROMPT
        #{research_preamble}

        ## Background

        We've designed a notation called UDON for unified data/document/config
        representation. Before showing it to you, we'd value your independent
        thinking on the design space.

        ## Task

        Given these design goals, sketch what notation you would create:

        1. **Unified**: Handles data (like JSON), documents (like HTML), and configuration (like YAML) in one coherent syntax
        2. **Human-readable**: Easy to read and write by hand, minimal punctuation noise
        3. **Hierarchy via indentation**: Structure from whitespace, like Python/YAML
        4. **No closing tags**: Unlike XML/HTML
        5. **Mixed content**: Prose text and structural elements coexist naturally—this is critical; most real documents are neither pure data nor pure prose
        6. **Typed values**: Numbers, booleans, strings, lists syntactically distinguishable
        7. **Attributes**: Elements can have key-value metadata
        8. **Identity and classification**: Unique IDs and multiple classes (like HTML id/class)
        9. **Comments**: Non-parsed notes

        Show your notation with:
        1. A brief syntax summary (what characters mean what)
        2. A document example showing **mixed content**—prose with structured data embedded naturally throughout (not just frontmatter)

        Be concrete. We'll compare your approach to ours to understand if the design space naturally converges or if there are better alternatives we missed.
        #{feedback_invitation}
      PROMPT
    end

    def invention_prompt_minimal
      <<~PROMPT
        #{research_preamble}

        ## Task

        Design a notation that:
        - Uses indentation for hierarchy (like YAML/Python)
        - Has no closing tags (unlike XML)
        - Can mix prose text with structural elements **inline**—not just at boundaries
        - Distinguishes elements, attributes, and prose

        Show your notation with a concrete example: a blog post where structured
        metadata (author info, tags, related links) appears naturally *within*
        the prose, not just in a header.
        #{feedback_invitation}
      PROMPT
    end

    def interpretation_prompt(syntax)
      <<~PROMPT
        #{research_preamble}

        ## Task

        You're seeing a notation called UDON for the first time. Based only on
        what you see below, explain what you think each part means.

        ```udon
        #{syntax}
        ```

        For each syntactic element you notice (special characters, indentation
        patterns, etc.), explain:
        1. What you think it means
        2. Your confidence (certain / likely / guessing)
        3. Any ambiguity or confusion

        Be honest about uncertainty. If something is unclear, that's useful data.
        #{feedback_invitation}
      PROMPT
    end

    def translation_prompt(source, format, context)
      context_section = if context
                          <<~CTX

                            ## UDON Reference

                            ```udon
                            #{context}
                            ```
                          CTX
                        else
                          <<~CTX

                            ## UDON Basics

                            - `|` prefix for elements (with optional `[id]` and `.class`)
                            - `:` prefix for attributes
                            - Indentation for hierarchy
                            - Plain text for prose (Markdown works)
                            - `|{element}` for inline elements within prose
                          CTX
                        end

      <<~PROMPT
        #{research_preamble}
        #{context_section}

        ## Task

        Convert this #{format.upcase} to UDON:

        ```#{format}
        #{source}
        ```

        Output only the UDON.
        #{feedback_invitation}
      PROMPT
    end

    def learning_curve_prompt(task, context)
      if context.nil? || context.empty?
        <<~PROMPT
          #{research_preamble}

          ## Task

          UDON is a notation format. Without seeing any examples, try to:

          #{task}

          Write what seems natural. We're testing how intuitive the format is.
          #{feedback_invitation}
        PROMPT
      else
        <<~PROMPT
          #{research_preamble}

          ## UDON Reference

          ```udon
          #{context}
          ```

          ## Task

          #{task}
          #{feedback_invitation}
        PROMPT
      end
    end

    def stress_test_prompt(scenario, context)
      context_section = if context
                          <<~CTX

                            ## UDON Reference

                            ```udon
                            #{context}
                            ```
                          CTX
                        else
                          ""
                        end

      <<~PROMPT
        #{research_preamble}
        #{context_section}

        ## Challenge

        #{scenario}

        Try to represent this in UDON. If it's awkward or doesn't fit well,
        that's valuable information—show your best attempt AND explain what
        doesn't work.

        After your UDON, please add:

        ```
        # ASSESSMENT:
        # Fit (1-5, where 5 is perfect):
        # What was awkward or unclear:
        # What would make this easier:
        ```
        #{feedback_invitation}
      PROMPT
    end

    def enablement_prompt(context)
      <<~PROMPT
        #{research_preamble}

        ## UDON Overview

        UDON (Universal Document & Object Notation) unifies data, documents,
        and configuration in one syntax. The key insight: most real content
        is **mixed**—prose with structured data woven throughout.

        ```udon
        #{context}
        ```

        ## Task

        We're interested in what UDON might **enable** for AI agents that was
        previously difficult or unstable. Consider:

        1. **What becomes easier?** Workflows fragile with JSON/YAML/XML
        2. **What becomes possible?** New patterns that mixed notation enables
        3. **Inner-loop stability** Where could UDON improve agent self-correction?
        4. **Agent-to-agent communication** How might shared notation help?
        5. **Human-agent collaboration** Documents both can read and modify?

        Ideate freely. We value honest assessment—including skepticism if you
        see limitations or think existing formats handle these cases well enough.
        #{feedback_invitation}
      PROMPT
    end
  end
end
