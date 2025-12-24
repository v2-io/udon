# frozen_string_literal: true

require "json"
require "yaml"
require "fileutils"
require "time"
require "securerandom"

# Usability Test Library for UDON
#
# Stores and analyzes results from hallway usability tests.
# Each test captures what a naive agent produced when given a task.
#
# IMPORTANT: Results are paid-for artifacts and should be committed to git.
#
module UsabilityLibrary
  class Library
    attr_reader :dir

    def initialize(dir:)
      @dir = dir
      FileUtils.mkdir_p(@dir)
    end

    # Add a test result
    # @param task [String] the task description given to the agent
    # @param test_type [Symbol] :invention, :interpretation, :translation, :learning_curve, :stress
    # @param context_lines [Integer] how many lines of context were provided
    # @param model [String] which model was used
    # @param prompt [String] the full prompt sent
    # @param response [String] the full response received
    # @param success [Boolean, nil] whether it matched expectations (nil if not evaluated)
    # @param notes [String, nil] evaluator notes
    # @param feedback [String, nil] agent's own feedback
    # @return [String] the result ID
    def add(task:, test_type:, context_lines:, model:, prompt:, response:, success: nil, notes: nil, feedback: nil)
      id = "udon-#{test_type}-#{Time.now.strftime('%Y%m%d-%H%M%S')}-#{SecureRandom.hex(4)}"

      result = {
        "id" => id,
        "task" => task,
        "test_type" => test_type.to_s,
        "context_lines" => context_lines,
        "model" => model,
        "prompt" => prompt,
        "response" => response,
        "success" => success,
        "notes" => notes,
        "feedback" => feedback,
        "created_at" => Time.now.utc.iso8601
      }

      File.write(File.join(@dir, "#{id}.yaml"), result.to_yaml)

      # Append feedback to aggregated file if present
      append_feedback(id, task, model, feedback) if feedback

      id
    end

    # List all results with optional filters
    def list(test_type: nil, model: nil, success: nil)
      results = Dir.glob(File.join(@dir, "udon-*.yaml")).map do |f|
        YAML.safe_load(File.read(f), permitted_classes: [Time])
      end

      results = results.select { |r| r["test_type"] == test_type.to_s } if test_type
      results = results.select { |r| r["model"] == model } if model
      results = results.select { |r| r["success"] == success } unless success.nil?

      results.sort_by { |r| r["created_at"] }
    end

    # Get a specific result by ID (or partial match)
    def get(id)
      matches = list.select { |r| r["id"].include?(id) }
      return nil if matches.empty?
      return matches.first if matches.size == 1

      matches # Return all matches for disambiguation
    end

    # Summary statistics
    def summary
      results = list
      by_type = results.group_by { |r| r["test_type"] }

      {
        total_tests: results.size,
        by_type: by_type.transform_values do |type_results|
          evaluated = type_results.reject { |r| r["success"].nil? }
          {
            total: type_results.size,
            evaluated: evaluated.size,
            successes: evaluated.count { |r| r["success"] },
            success_rate: evaluated.empty? ? nil : (evaluated.count { |r| r["success"] }.to_f / evaluated.size * 100).round(1)
          }
        end,
        by_model: results.group_by { |r| r["model"] }.transform_values(&:size),
        context_line_distribution: results.group_by { |r| r["context_lines"] }.transform_values(&:size)
      }
    end

    # Analyze convergence - do agents produce similar outputs?
    # Returns common patterns found across responses
    def convergence_analysis(test_type:)
      results = list(test_type: test_type)
      return { attempts: 0, patterns: {} } if results.empty?

      # Extract structural patterns from responses
      patterns = Hash.new(0)

      results.each do |r|
        response = r["response"]

        # Look for UDON-like patterns
        patterns["uses_pipe_prefix"] += 1 if response.match?(/^\s*\|/m)
        patterns["uses_colon_attrs"] += 1 if response.match?(/:\w+\s/)
        patterns["uses_indentation"] += 1 if response.match?(/^  +\S/m)
        patterns["uses_brackets_id"] += 1 if response.match?(/\[\w+\]/)
        patterns["uses_dot_class"] += 1 if response.match?(/\.\w+/)
        patterns["uses_bang_dynamics"] += 1 if response.match?(/!\{.*\}|^!\w+/m)
        patterns["uses_semicolon_comments"] += 1 if response.match?(/^;/m)

        # Extract what prefix characters they chose for elements
        if response.match?(/^(\S)\w+.*\n\s+/m)
          prefix = $1
          patterns["element_prefix_#{prefix}"] += 1
        end
      end

      {
        attempts: results.size,
        patterns: patterns.sort_by { |_, c| -c }.to_h,
        convergence_score: calculate_convergence_score(patterns, results.size)
      }
    end

    # Get all feedback entries
    def all_feedback
      list.filter_map do |r|
        next unless r["feedback"]

        {
          "id" => r["id"],
          "task" => r["task"],
          "model" => r["model"],
          "feedback" => r["feedback"],
          "created_at" => r["created_at"]
        }
      end
    end

    # Clear all results (use with caution - these are paid artifacts!)
    def clear!
      puts "WARNING: This will delete all paid-for test results."
      print "Type 'yes' to confirm: "
      return unless $stdin.gets&.strip == "yes"

      Dir.glob(File.join(@dir, "udon-*.yaml")).each { |f| File.delete(f) }
      puts "Cleared."
    end

    private

    def calculate_convergence_score(patterns, total)
      return 0 if total.zero?

      # Score based on how many agents used UDON-like patterns
      udon_patterns = %w[uses_pipe_prefix uses_colon_attrs uses_indentation]
      udon_score = udon_patterns.sum { |p| patterns[p] || 0 }
      max_score = udon_patterns.size * total

      (udon_score.to_f / max_score * 100).round(1)
    end

    def append_feedback(id, task, model, feedback)
      feedback_file = File.join(@dir, "AGENT_FEEDBACK.md")

      entry = <<~ENTRY

        ---

        **ID:** #{id}
        **Task:** #{task}
        **Model:** #{model}
        **Time:** #{Time.now.utc.iso8601}

        #{feedback}
      ENTRY

      unless File.exist?(feedback_file)
        header = <<~HEADER
          # Agent Feedback on UDON

          Aggregated feedback from test agents evaluating UDON syntax.
          These insights come from agents asked to interpret or produce UDON.

        HEADER
        File.write(feedback_file, header)
      end

      File.open(feedback_file, "a") { |f| f.write(entry) }
    end
  end
end
