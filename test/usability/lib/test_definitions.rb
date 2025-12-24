# frozen_string_literal: true

# Test Definitions for UDON Usability Testing
#
# Defines context snippets, stress scenarios, and translation sources.
# Hypothesis: 80% success rate achievable with <10 lines of context.
#
module TestDefinitions
  # ========================================
  # CONTEXT SNIPPETS FOR LEARNING CURVE
  # ========================================
  # Ordered from minimal to comprehensive.
  # Goal: find the inflection point where success jumps.

  CONTEXT = {
    # Level 0: nothing (zero-shot)
    none: nil,

    # Level 1: just the prefixes (4 lines)
    prefixes_only: <<~UDON,
      |  = element (with optional [id] and .class)
      :  = attribute
      ;  = comment
      Indentation = hierarchy, plain text = prose
    UDON

    # Level 2: minimal data example (6 lines)
    tiny_example: <<~UDON,
      ; UDON: | = element, : = attribute, indentation = hierarchy
      |person
        :name Alice
        :age 30
        |address
          :city Portland
    UDON

    # Level 3: prose + structure basics (10 lines)
    with_prose: <<~UDON,
      ; | = element, : = attribute, plain text = prose (Markdown works)

      |article
        :author Joseph

        This is **prose** that belongs to the article element.
        Markdown formatting works naturally here.

        |section
          Nested elements can also contain prose.
    UDON

    # Level 4: inline elements - the key insight (12 lines)
    with_inline: <<~UDON,
      ; UDON: | = element, : = attribute, |{...} = inline element

      |paragraph
        Regular prose can contain |{em emphasized text} and
        |{a :href /about links} inline without breaking flow.

        Structure and prose coexist:

        |note
          :type warning
          This note has metadata AND prose content.
    UDON

    # Level 5: full mixed content - shows the power (20 lines)
    mixed_content: <<~UDON,
      |article[welcome].featured
        :author Joseph
        :date 2025-12-22

        Welcome to the project. Here's what we're building:

        |objective
          :priority high
          :status active

          A notation that lets **prose and structure coexist** without
          awkward boundaries. Notice how this paragraph belongs to the
          objective element, with its metadata above.

        The key insight is that |{em most documents} aren't pure data
        OR pure prose—they're |{dfn :id mixed-content mixed content}
        where structure appears |{em inline} when needed.

        |requirements
          |req[r1] :must Machine-parseable without ambiguity
          |req[r2] :must Human-readable without tooling
          |req[r3] :should Support Markdown conventions in prose

        That requirements block was structured data, but it lives
        naturally within the document flow.
    UDON

    # Level 6: comprehensive reference (~25 lines)
    comprehensive: <<~UDON
      ; UDON Quick Reference
      ; | = element, : = attribute, ; = comment, |{} = inline element
      ; [id] = unique identity, .class = classification (stackable)
      ; Indentation = hierarchy, plain text = prose (Markdown works)

      |article[welcome].featured.pinned
        :author Joseph
        :date 2025-12-22
        :tags [intro tutorial udon]

        Welcome to **UDON**. This prose belongs to the article.

        The magic: |{em structured data} and prose |{strong coexist}.
        Links work too: see |{a :href #mixed-content mixed content}.

        |section[overview]
          :priority 1

          |definition-list
            |term UDON
            |def Universal Document & Object Notation

          UDON unifies data, documents, and configuration because
          most real content is |{em mixed}—not purely one or the other.

        |code :lang ruby
          # Code blocks preserve content literally
          puts "Hello, world!"
    UDON
  }.freeze

  # Shorthand for testing progression
  # Hypothesis: 80% success achievable by level 4 (with_inline) - under 15 lines
  CONTEXT_PROGRESSION = %i[
    none
    prefixes_only
    tiny_example
    with_prose
    with_inline
    mixed_content
    comprehensive
  ].freeze

  # ========================================
  # TASKS FOR LEARNING CURVE
  # ========================================
  # Various complexity levels to test

  TASKS = {
    simple_config: "Write a database configuration with host, port, and credentials",
    simple_document: "Write a blog post with title, author, date, and two paragraphs",
    nested_structure: "Write a user with an address containing street, city, and zip",
    mixed_content: "Write an article with a heading, prose, a blockquote, and a list",
    with_ids: "Write a navigation menu with three items, each having a unique identifier",
    with_attributes: "Write a form with two input fields, each having name, type, and placeholder"
  }.freeze

  # ========================================
  # TRANSLATION TEST SOURCES
  # ========================================

  TRANSLATIONS = {
    json_simple: {
      format: :json,
      source: <<~JSON
        {
          "name": "Alice",
          "email": "alice@example.com",
          "age": 30,
          "active": true
        }
      JSON
    },

    json_nested: {
      format: :json,
      source: <<~JSON
        {
          "user": {
            "name": "Bob",
            "address": {
              "street": "123 Main St",
              "city": "Portland",
              "zip": "97201"
            },
            "tags": ["developer", "admin"]
          }
        }
      JSON
    },

    yaml_config: {
      format: :yaml,
      source: <<~YAML
        database:
          adapter: postgres
          host: localhost
          port: 5432
          pool: 5

        redis:
          url: redis://localhost:6379
          timeout: 5
      YAML
    },

    html_document: {
      format: :html,
      source: <<~HTML
        <article id="welcome" class="featured">
          <h1>Hello World</h1>
          <p>This is the first paragraph.</p>
          <blockquote>
            <p>A wise quote here.</p>
          </blockquote>
          <ul>
            <li>First item</li>
            <li>Second item</li>
          </ul>
        </article>
      HTML
    },

    xml_data: {
      format: :xml,
      source: <<~XML
        <users>
          <user id="1" role="admin">
            <name>Alice</name>
            <email>alice@example.com</email>
          </user>
          <user id="2" role="member">
            <name>Bob</name>
            <email>bob@example.com</email>
          </user>
        </users>
      XML
    }
  }.freeze

  # ========================================
  # STRESS TEST SCENARIOS
  # ========================================
  # Edge cases to find where UDON is awkward

  STRESS = {
    # Simple things that might be over-complicated by UDON
    too_simple: [
      "Represent a single string value with no structure",
      "Represent a flat list of 5 numbers",
      "Represent a key-value pair (just one)",
      "Represent the boolean value 'true'"
    ],

    # Complex things that might exceed UDON's expressiveness
    too_complex: [
      "Represent a binary tree with arbitrary depth",
      "Represent a graph with cycles (node A points to B, B points to A)",
      "Represent a table with merged cells (colspan/rowspan)",
      "Represent an XML document with namespaces",
      "Represent inline formatting mid-word (like H<sub>2</sub>O)"
    ],

    # Whitespace sensitivity issues
    whitespace: [
      "Represent code that itself uses significant indentation (Python)",
      "Represent a poem where exact spacing matters",
      "Represent data containing leading/trailing whitespace in values",
      "Represent an empty element vs an element with empty string value"
    ],

    # Delimiter/escape challenges
    escaping: [
      "Represent a string containing a literal pipe character |",
      "Represent a string containing a literal colon at the start",
      "Represent prose that starts with a semicolon",
      "Represent a value that looks like UDON syntax: |element :attr val",
      "Represent nested quoted strings"
    ],

    # Mixed content edge cases
    mixed_content: [
      "Represent inline code within prose (like Markdown backticks)",
      "Represent a paragraph with a link in the middle",
      "Represent alternating prose and elements, tightly interleaved",
      "Represent a definition list (term followed by definition)"
    ],

    # Ambiguity scenarios
    ambiguity: [
      "Is '123' a string or an integer? Represent both.",
      "Is 'true' a string or a boolean? Represent both.",
      "How do you distinguish an empty list [] from a list with one empty string?",
      "How do you represent null/nil/nothing?"
    ]
  }.freeze

  # ========================================
  # INTERPRETATION TEST SAMPLES
  # ========================================
  # UDON snippets to show agents and ask "what does this mean?"

  INTERPRETATION_SAMPLES = {
    basic_element: <<~UDON,
      |user
        :name Alice
        :age 30
    UDON

    with_id_and_class: <<~UDON,
      |article[main].featured.pinned
        :author Joseph

        Content here.
    UDON

    inline_elements: <<~UDON,
      |p This has |{em emphasis} and |{a :href /foo a link} inline.
    UDON

    attribute_flags: <<~UDON,
      |input
        :type text
        :required
        :disabled
    UDON

    mixed_prose: <<~UDON,
      |section
        Here is some prose.

        |note Important point here.

        Back to prose.
    UDON

    dynamic_content: <<~UDON,
      |greeting
        Hello, !{user.name | capitalize}!

        !if user.admin
          |admin-panel
        !else
          |user-panel
    UDON

    column_alignment: <<~UDON
      |table |tr |td A1
                 |td A2
             |tr |td B1
                 |td B2
    UDON
  }.freeze
end
