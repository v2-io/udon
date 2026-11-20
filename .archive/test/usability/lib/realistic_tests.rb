# frozen_string_literal: true

# Realistic UDON Tests
#
# Less prescriptive tasks, LLM-judged correctness.
# Tests real-world usage patterns, not synthetic feature checklists.

module RealisticTests
  EXAMPLES_DIR = File.expand_path("../../../examples", __dir__)

  CONTEXTS = {
    cheatsheet: File.join(EXAMPLES_DIR, "cheatsheet.udon"),
    minimal: File.join(EXAMPLES_DIR, "minimal.udon"),
    comprehensive: File.join(EXAMPLES_DIR, "comprehensive.udon")
  }.freeze

  # Realistic tasks - no hints, just the reference examples to learn from
  TASKS = {
    yaml_frontmatter: {
      description: "Convert YAML frontmatter + prose to UDON",
      input: <<~DOC,
        ---
        title: API Authentication Guide
        version: 2.1.0
        last_updated: 2025-01-15
        author:
          name: Alice Chen
          email: alice@example.com
        tags: [api, auth, security]
        ---

        ## Getting Started

        All requests require a bearer token. Get one from the `/oauth/token` endpoint.

        The token expires after 1 hour.
      DOC
      prompt: "Convert this to UDON.",
    },

    experiment_report: {
      description: "Structure an experiment description",
      input: <<~TEXT,
        The experiment tested whether caffeine improves reaction time. We gave 50 participants either 200mg caffeine or placebo. Reaction time was measured using a simple button-press task. The caffeine group averaged 245ms (SD=32) compared to 289ms (SD=41) for placebo. The effect was statistically significant (p<0.001). However, 3 participants in the caffeine group reported jitteriness.
      TEXT
      prompt: "Convert this to UDON, marking up the key data points.",
    },

    yaml_config: {
      description: "Convert YAML config with comments to UDON",
      input: <<~YAML,
        database:
          host: db.example.com
          port: 5432
          pool: 10  # increase for production
          ssl: true

        cache:
          host: redis.example.com
          ttl: 3600  # seconds

        features:
          - dark_mode
          - notifications
          - beta_features  # remove before launch
      YAML
      prompt: "Convert this to UDON.",
    },

    conversation_log: {
      description: "Structure a conversation log",
      input: <<~CONV,
        [2025-01-15 14:32:01] User: Can you help me debug this error?
        [2025-01-15 14:32:03] Agent: Of course! What error are you seeing?
        [2025-01-15 14:32:15] User: TypeError: undefined is not a function
        [2025-01-15 14:32:18] Agent: That usually means you're calling something that doesn't exist. Can you share the code?
        [2025-01-15 14:32:45] User: [attached: code.js]
        [2025-01-15 14:33:02] Agent: I see the issue—line 15 calls `data.map()` but data might be undefined. Add a check: `if (data) { data.map(...) }`
        [2025-01-15 14:33:10] User: That fixed it, thanks!
      CONV
      prompt: "Convert this conversation to UDON.",
    },

    recipe: {
      description: "Create a recipe document from scratch",
      prompt: "Write a UDON document for a simple pasta recipe with prep time, cook time, ingredients, and instructions.",
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

  # Judge prompt for evaluating output
  def self.judge_prompt(task_key:, context:, output:)
    task = TASKS[task_key]

    <<~PROMPT
      You're evaluating UDON output quality. Be strict but fair.

      ## UDON Reference (what correct syntax looks like)

      ```udon
      #{context}
      ```

      ## Task Given

      #{task[:description]}
      #{task[:prompt]}

      ## Output to Evaluate

      ```
      #{output}
      ```

      ## Evaluation Criteria

      Rate each 1-5:

      1. **Syntax correctness**: Does it use UDON syntax properly?
         - `|element` for structure, `:attr` for attributes, `|{inline}` for inline
         - NOT `|title "value"` when `:title value` is appropriate
         - Proper indentation for nesting

      2. **Appropriate structure**: Did it choose the right patterns?
         - Attributes for metadata (version, date, author)
         - Elements for containers (sections, items)
         - Inline elements for marking up prose without breaking flow
         - NOT everything as child elements when attributes fit better

      3. **Prose flow**: Does prose still read naturally?
         - Inline elements enhance rather than interrupt
         - Document structure doesn't fragment the narrative

      4. **Task completion**: Did it accomplish what was asked?

      Output JSON only:
      {"syntax": N, "structure": N, "flow": N, "completion": N, "notes": "brief explanation"}
    PROMPT
  end
end
