# Agentic UDON Tools

**Tools designed for how agents actually think about documents.**

This document specifies a suite of tools for AI agents to inspect, understand,
and modify UDON documents. The design philosophy: **agents express intent, tools
handle mechanics.**

---

## Design Principles

### 1. No Mechanical Burden

Agents should never think about:
- Indentation or whitespace
- Escaping or quoting
- Line numbers for insertion
- Format preservation details

They think about structure, relationships, and content. The tools handle the rest.

### 2. Context Efficiency

Agents have limited context windows. Every tool is designed to:
- Return exactly what's needed, no more
- Provide progressive disclosure (glance → focus → full)
- Maintain state across calls to avoid re-reading
- Summarize intelligently when full content would be wasteful

### 3. Confidence Before Action

Agents make mistakes when uncertain. Tools provide:
- Preview before modification (`propose` before `apply`)
- Validation against schema
- Impact analysis (what else would be affected)
- Undo/revert capabilities

### 4. Relationship Awareness

Documents aren't flat—they have references, inheritance, patterns. Tools expose:
- What references what (bidirectional)
- Inherited attributes from ancestors
- Patterns and conventions in the document
- Anomalies and inconsistencies

---

## Tool Definitions

### glance

Minimal-context structural overview. Use FIRST before any file work.

```udon
|tool[glance]
  |purpose
    Quick structural overview without reading entire file.
    Returns enough to decide: dig deeper? which section? ignore?
    Optimized for minimal context usage.

  |when-to-use
    - First contact with an unfamiliar file
    - Deciding whether a file is relevant
    - Getting bearings in a large document
    - Finding where something probably lives

  |parameters
    |file :required
      Path to UDON file
    |max-depth :default 3
      How deep to show element tree
    |include-traits :default true
      Summarize .class usage
    |include-references :default true
      Show reference map
    |include-anomalies :default true
      Flag potential issues
    |skeleton :default true
      Include path skeleton (copy-pasteable paths)

  |returns
    |skeleton
      Navigable path map. Every line is a valid, copy-pasteable path.
      Shows element structure, keys, multiplicities, attr names.
    |traits
      What .classes appear and how often. Indicates conventions.
    |size
      Element count, attribute count, prose blocks, total lines.
    |references
      What references what. Bidirectional. Grouped by target.
    |anomalies
      Schema violations, orphan references, unusual patterns.

  |example
    |input
      glance ./config.udon

    |output
      |skeleton (52 lines, 4 elements, 31 attrs)
        |config
        ├─ :name :debug :environment              # attrs
        ├─ |database[primary].postgres.required   # 15 lines
        │  ├─ :adapter :host :port :pool :ssl
        │  └─ .credentials
        │     └─ :username :password
        ├─ |database[replica].postgres            # 12 lines
        │  └─ :adapter :host :port :pool
        ├─ .cache[redis].cached                   # 8 lines
        │  └─ :host :port :ttl
        └─ .features
           └─ :enabled-flags :rate-limits

      |traits
        .postgres (2), .required (1), .cached (1)

      |references
        @database[primary]
          ← |cache[redis]:fallback
          ← |app:db
        @cache[redis]
          ← |app:cache

      |anomalies
        |database[replica] missing :ssl (present in [primary])
        @logging[debug] referenced but not defined
```

---

### focus

Retrieve a specific subtree with smart context.

```udon
|tool[focus]
  |purpose
    Deep look at a specific section. Returns the content PLUS
    surrounding context needed to understand and modify safely.

  |when-to-use
    - After glance identified area of interest
    - Need full detail on a specific element
    - Preparing to modify something
    - Understanding how a section fits into the whole

  |parameters
    |file :required
      Path to UDON file
    |path :required
      Path to focus on. Supports:
        |element|child         ; by name
        |element[key]          ; by key
        @element[key]          ; typed reference
        |element[key]:attr     ; specific attribute
        ..                     ; parent (in session)
        .                      ; current (in session)
    |depth :default all
      How deep into children. 'all' or integer.
    |siblings :default summary
      'none', 'summary', or 'full'
    |context :default true
      Include inherited attrs, references

  |returns
    |breadcrumb
      Path from root with line numbers. Shows where you are.
    |content
      The requested subtree, full detail, with line numbers.
    |siblings
      What else exists at this level. Summary or full.
    |inherited
      Attributes from ancestors that affect this node.
    |references-out
      What this section references (elements, interpolations).
    |references-in
      What points to this section.

  |example
    |input
      focus ./config.udon |database[primary]

    |output
      |breadcrumb
         1  |config
        14    |database[primary]    ; ← you are here

      |content
        14  |database[primary].postgres.required
        15    :host db.example.com
        16    :port 5432
        17    :pool 10
        18    :timeout 30s
        19    |credentials
        20      :username !{{env.DB_USER}}
        21      :password !{{env.DB_PASS}}

      |siblings
        |database[replica] (8 attrs, line 24)
        |cache[redis] (4 attrs, line 35)
        |logging (3 children, line 42)

      |inherited
        (none from ancestors)

      |references-out
        !{{env.DB_USER}} (environment variable)
        !{{env.DB_PASS}} (environment variable)

      |references-in
        @database[primary] referenced by:
          line 42  |cache :fallback
          line 58  |app :db
```

---

### propose

Preview a modification before applying it.

```udon
|tool[propose]
  |purpose
    Show what a modification WOULD look like without doing it.
    Critical for agent confidence. See the result before committing.
    Returns diff, validation, and impact analysis.

  |when-to-use
    - Before any modification
    - When uncertain about exact effect
    - To verify intent matches outcome
    - To check for unintended side effects

  |parameters
    |file :required
      Path to UDON file
    |operation :required
      One of the operation types below
    |schema
      Optional schema file for validation

  |operations
    |insert
      Add new content as child of existing element.
      |at :required
        Path to parent element
      |content :required
        UDON fragment (inline or file path)
      |position :default last
        Where among siblings:
        - 'first'
        - 'last'
        - 'before:path' (before specific sibling)
        - 'after:path' (after specific sibling)

    |update
      Modify existing element or attribute.
      |path :required
        Path to element or attribute
      |set
        New value (for attributes)
      |merge
        Merge attrs/children (for elements)
      |rename
        New name or key

    |delete
      Remove element or attribute.
      |path :required
        Path to target
      |recursive :default true
        Delete children too

    |move
      Relocate a subtree.
      |from :required
        Source path
      |to :required
        Destination parent path
      |position :default last
        Where among new siblings

    |wrap
      Wrap existing content in new element.
      |path :required
        What to wrap
      |with :required
        New parent element

    |unwrap
      Remove element but keep its children.
      |path :required
        Element to unwrap

  |returns
    |diff
      Before/after showing structural changes.
      Line numbers, added (+), removed (-), context.
    |validation
      Schema conformance check if schema provided.
      Warnings about missing required attrs, type mismatches.
    |side-effects
      What else would be affected:
      - References that would break
      - References that would need updating
      - Inherited values that would change
    |confidence
      Tool's confidence in interpreting intent.
      'high', 'medium', 'low' with explanation if not high.

  |example
    |input
      propose ./config.udon
        |insert
          |at |database
          |position after:database[replica]
          |content
            |database[analytics].postgres
              :host analytics.example.com
              :port 5432
              :pool 5

    |output
      |diff
            24    |database[replica] ...
            ...
        +   32    |database[analytics].postgres
        +   33      :host analytics.example.com
        +   34      :port 5432
        +   35      :pool 5
            36    |cache[redis] ...

      |validation
        OK - conforms to .postgres trait requirements
        NOTE: :timeout not specified (optional, default 30s)

      |side-effects
        none - no existing references to @database[analytics]

      |confidence high
        Clear insertion point, valid content structure.
```

---

### apply

Execute a modification.

```udon
|tool[apply]
  |purpose
    Execute a proposed or inline modification.
    Actually writes changes to file.

  |when-to-use
    - After propose confirmed expected result
    - For simple, confident changes
    - Within a session after building up changes

  |parameters
    |file :required
      Path to UDON file
    |proposal
      ID from previous propose call.
      Use this OR operation, not both.
    |operation
      Inline operation (same format as propose).
      Use this OR proposal, not both.
    |validate :default true
      Check against schema before applying
    |backup :default true
      Create backup before modifying
    |dry-run :default false
      Validate and report but don't write

  |returns
    |success
      true/false
    |backup
      Path to backup file (if backup enabled)
    |summary
      Brief description of what changed
    |new-state
      Glance-style overview of modified file
    |errors
      If failed, what went wrong
```

---

### session

Stateful document exploration and modification.

```udon
|tool[session]
  |purpose
    Maintain state across multiple operations. Remembers:
    - Current location in document
    - What's expanded/collapsed
    - Uncommitted modifications
    - Navigation history

    Dramatically reduces context usage for multi-step work.

  |when-to-use
    - Extended work on a single document
    - Exploring unfamiliar structure
    - Making multiple related changes
    - When you need undo capability

  |subcommands
    |open
      Start a new session.
      |file :required
      |returns
        Session ID and initial glance.

    |view
      Show current state.
      |session :required
      |returns
        Current location, expanded sections, pending changes.

    |navigate
      Move to a different location.
      |session :required
      |to :required
        Path, '..' for parent, '/' for root
      |returns
        Focused view at new location.

    |expand
      Show more detail at a location.
      |session :required
      |path :default current
      |depth :default 1

    |collapse
      Hide detail at a location.
      |session :required
      |path :default current

    |modify
      Stage a modification (doesn't write yet).
      |session :required
      |operation :required
        Same as propose operations.
      |returns
        Diff preview, validation, change ID.

    |changes
      List pending modifications.
      |session :required
      |returns
        List of staged changes with IDs.

    |revert
      Undo staged modifications.
      |session :required
      |change
        Specific change ID, or 'all'.

    |commit
      Write all staged changes to file.
      |session :required
      |backup :default true
      |returns
        Success, backup location, summary.

    |close
      End session.
      |session :required
      |discard :default false
        If true, discard uncommitted changes.
        If false and uncommitted changes exist, error.

  |example
    ; Open session
    > session open ./config.udon
    session: cfg_a1b2c3
    |config (52 lines, 4 elements)
      |database[primary] ...
      |database[replica] ...
      ...

    ; Navigate to database section
    > session navigate cfg_a1b2c3 |database[primary]
    |breadcrumb: |config > |database[primary]
    |database[primary].postgres
      :host db.example.com
      :port 5432
      ...

    ; Stage a modification
    > session modify cfg_a1b2c3
        |update |database[primary]:pool |set 20
    change: chg_001
    |diff: :pool 10 → :pool 20

    ; Commit
    > session commit cfg_a1b2c3
    success, backup at ./config.udon.bak
```

---

### trace

Follow relationships through the document.

```udon
|tool[trace]
  |purpose
    Understand connections. What uses this? What does this use?
    Critical for impact analysis before modifications.

  |when-to-use
    - Before modifying something that might be referenced
    - Understanding how parts connect
    - Finding all uses of a pattern or element
    - Cross-file dependency analysis

  |parameters
    |files :required
      Single path or list for cross-file tracing
    |from :required
      Starting point: path or @reference
    |direction :default both
      'in' (what references this)
      'out' (what this references)
      'both'
    |depth :default 1
      How many hops to follow
    |include-interpolations :default true
      Include !{{...}} references

  |returns
    |target
      What you're tracing from
    |inbound
      What references this target, with locations
    |outbound
      What this target references, with locations
    |transitive
      If depth > 1, the full reference chain

  |example
    |input
      trace ./config.udon --from @database[primary] --direction in

    |output
      |target @database[primary] (line 14)

      |inbound (3 references)
        line 42  |cache
                   :fallback @database[primary]
        line 58  |app
                   :db @database[primary]
        line 71  |healthcheck
                   :target @database[primary]
```

---

### infer

Suggest content based on patterns and schema.

```udon
|tool[infer]
  |purpose
    "What should go here?" Generate suggestions based on:
    - Schema constraints
    - Sibling patterns
    - Trait requirements
    - Document conventions

    Helps agents create content that matches existing style.

  |when-to-use
    - Adding new element similar to existing ones
    - Unsure what attributes are expected
    - Want to match document conventions
    - Schema-guided content creation

  |parameters
    |file :required
    |at :required
      Where you want to add something
    |like
      Optional: "make it like this sibling"
    |schema
      Optional: schema file for requirements
    |element-name
      Optional: what kind of element to create

  |returns
    |suggestion
      Template for new content with:
      - Required attributes (marked)
      - Optional attributes (with defaults)
      - Expected children
      - Inherited traits
    |based-on
      What the suggestion was derived from
    |alternatives
      Other valid patterns if multiple exist

  |example
    |input
      infer ./config.udon --at |database --like database[primary]

    |output
      |suggestion
        Based on |database[primary] and .postgres trait:

        |database[KEY].postgres
          :host :required String
          :port :default 5432 Integer
          :pool :default 5 Integer
          :timeout :optional Duration
          |credentials :optional
            :username String
            :password String

      |based-on
        - Sibling |database[primary] structure
        - Trait .postgres requirements

      |alternatives
        - .mysql trait: uses :socket instead of :host/:port
        - .sqlite trait: uses :path, no credentials
```

---

### validate

Check document against schema or conventions.

```udon
|tool[validate]
  |purpose
    Verify document correctness. Check:
    - Schema conformance
    - Reference integrity
    - Trait requirements
    - Convention violations

  |when-to-use
    - After modifications to verify correctness
    - Before committing changes
    - Auditing existing documents
    - CI/CD validation

  |parameters
    |file :required
    |schema
      Schema file to validate against
    |check-references :default true
      Verify all references resolve
    |check-traits :default true
      Verify trait requirements met
    |strict :default false
      Treat warnings as errors

  |returns
    |valid
      true/false overall status
    |errors
      Issues that must be fixed (with locations)
    |warnings
      Issues that should be reviewed (with locations)
    |summary
      Counts and overall assessment

  |example
    |input
      validate ./config.udon --schema ./app.schema.udon

    |output
      |valid false

      |errors (2)
        line 28: |database[replica]
          missing required attribute :host (from .postgres)
        line 51: @logging[debug]
          referenced but not defined

      |warnings (1)
        line 35: |cache[redis]
          :ttl value '5m' could be Duration (currently String)

      |summary
        2 errors, 1 warning
        87% of elements pass validation
```

---

### search

Find elements matching criteria.

```udon
|tool[search]
  |purpose
    Find elements by name, trait, attribute, or content.
    More semantic than grep—understands structure.

  |when-to-use
    - Finding all elements of a type
    - Finding elements with specific attributes
    - Locating content within large documents
    - Cross-file searches

  |parameters
    |files :required
      Path or glob pattern
    |element
      Element name pattern (supports *)
    |trait
      Elements with this .class
    |has-attr
      Elements with this attribute
    |attr-value
      Attribute value pattern
    |has-key
      Elements with [key]
    |content
      Text content pattern
    |max-results :default 20

  |returns
    |matches
      List of matches with:
      - File path
      - Line number
      - Breadcrumb path
      - Preview snippet
    |count
      Total matches (may exceed max-results)

  |example
    |input
      search ./*.udon --trait .deprecated

    |output
      |matches (3)
        ./config.udon:47
          |config > |features > |old-api.deprecated
          :sunset 2025-06-01

        ./routes.udon:123
          |routes > |admin > |legacy-endpoint.deprecated
          :replacement @endpoint[v2-admin]

        ./schema.udon:89
          |definitions > |old-format.deprecated

      |count 3
```

---

## Path Syntax

See [udon-paths.md](udon-paths.md) for full specification.

**Quick reference:**

| Pattern | Meaning |
|---------|---------|
| `\|element` | Child element by name |
| `\|parent\|child` | Nested navigation |
| `[key]` | Element by key |
| `[0]` | Element by index |
| `.trait` | Filter by trait |
| `:attr` | Attribute access |
| `@type[key]` | Reference resolution |
| `*` | Wildcard (any element) |
| `\|\|` | Recursive descent |

**Key insight:** The path syntax reuses UDON's prefix symbols (`|`, `:`, `.`, `[key]`, `@`),
so paths read like flattened UDON documents. No new syntax to learn.

---

## Output Conventions

Consistent output format across all tools.

```udon
|output-conventions
  |line-numbers
    Always included. Right-aligned, consistent width.
    Enables agents to correlate across calls.

  |breadcrumbs
    Show path from root to current location.
    Include line numbers at each level.

  |content-markers
    +   added line
    -   removed line
    ~   modified line
    ... collapsed content
    ←   reference indicator

  |summaries
    Element counts, attribute counts, line ranges.
    Always in parentheses after element name.

  |confidence-indicators
    When tool is uncertain, explicit confidence level.
    'high', 'medium', 'low' with explanation.
```

---

## Error Handling

How tools report problems.

```udon
|error-handling
  |categories
    |not-found
      Path doesn't resolve. Suggestions for similar paths.
    |ambiguous
      Multiple matches. List options to choose from.
    |invalid-operation
      Operation doesn't make sense. Explain why.
    |schema-violation
      Would violate schema. Show what's wrong.
    |reference-broken
      Would break references. Show what would break.

  |format
    |error
      :category not-found
      :message Path |database.credentials not found
      :location ./config.udon
      :suggestions
        - |database[primary].credentials (line 19)
        - |database[replica].credentials (line 31)
```

---

## Additional Tools (Inspired by Domain Use Cases)

### annotate

Add inline metadata to existing prose without changing structure.

```udon
|tool[annotate]
  |purpose
    Mark spans within prose with structured metadata. Essential for:
    - Training data annotation (entities, intents)
    - Document review (comments, approvals)
    - Provenance tracking (who wrote what)

  |when-to-use
    - Adding entity labels to conversation transcripts
    - Marking confidence levels on claims
    - Attaching review comments to specific passages
    - Building training datasets from existing documents

  |parameters
    |file :required
    |path :required
      Path to element containing prose
    |span :required
      Character range [start, end] or text to match
    |annotation :required
      |entity :type :value :confidence
      |intent :name :confidence
      |comment :author :text
      |review :status :reviewer
      |confidence :level :reasoning

  |example
    |input
      annotate ./conversation.udon |turn[3]
        :span "order ORD-98765"
        :annotation
          |entity :type order_id :value ORD-98765 :confidence 0.95

    |output
      |before
        Hi, I wanted to check on order ORD-98765?

      |after
        Hi, I wanted to check on |{entity :type order_id :value ORD-98765
          :confidence 0.95 order ORD-98765}?
```

---

### extract

Pull structured data from mixed content documents.

```udon
|tool[extract]
  |purpose
    Query and export structured data embedded in documents.
    For compliance audits, training pipelines, analytics.

  |when-to-use
    - Exporting all metrics from a model card
    - Pulling entity annotations for ML training
    - Generating compliance reports from documentation
    - Aggregating data across multiple documents

  |parameters
    |files :required
    |query :required
      What to extract:
      - By element type: "all |entity"
      - By trait: "all .metric"
      - By attribute: "where :confidence > 0.8"
      - By path: "|results|segment-results|*"
    |format :default udon
      Output format: 'udon', 'json', 'csv', 'jsonl'
    |include-context :default false
      Include breadcrumb path for each result

  |example
    |input
      extract ./experiment.udon
        :query "all |metric where :type = relative-lift"
        :format json
        :include-context true

    |output
      [
        {
          "path": "|results|segment-results[mobile-users]",
          "line": 156,
          "value": 0.247,
          "type": "relative-lift",
          "context": "Mobile users showed a 24.7% lift"
        },
        ...
      ]
```

---

### diff

Semantic diff between documents or versions.

```udon
|tool[diff]
  |purpose
    Structural diff, not line diff. Understands:
    - Element additions/removals
    - Attribute changes
    - Moved subtrees (not just delete+add)
    - Prose changes within structure

  |when-to-use
    - Reviewing document changes before commit
    - Understanding what changed in a schema
    - Auditing configuration drift
    - Comparing experiment versions

  |parameters
    |before :required
      File path, git ref, or session snapshot
    |after :required
      File path, git ref, or 'current'
    |scope
      Limit diff to specific path
    |ignore
      Paths to exclude from diff
    |semantic :default true
      Group related changes (move vs delete+add)

  |returns
    |summary
      High-level: X elements added, Y modified, Z removed
    |changes
      List of changes with:
      - Type: added, removed, modified, moved, renamed
      - Path
      - Before/after values
      - Impact analysis (what references this?)

  |example
    |input
      diff ./config.udon --before HEAD~1 --after current

    |output
      |summary
        2 elements modified, 1 attribute added

      |changes
        |modified |database[primary]:pool
          :before 10
          :after 20
          :impact Referenced by @database[primary] in 3 places

        |modified |cache[redis]:ttl
          :before 3600
          :after 7200

        |added |database[primary]:max-connections
          :value 100
```

---

### timeline

View evolution of documents with temporal data.

```udon
|tool[timeline]
  |purpose
    Visualize state evolution in documents that track changes over time.
    Perfect for experiments, dialogues, workflows.

  |when-to-use
    - Reviewing A/B test progression (hypothesis → results → decision)
    - Analyzing dialogue state evolution turn-by-turn
    - Tracking workflow stage transitions
    - Understanding how a document evolved

  |parameters
    |file :required
    |path
      Focus on specific subtree
    |key
      Field that represents time/sequence:
      - :timestamp, :turn, :date, :version, etc.
    |show
      What to display at each point:
      - 'summary' (default)
      - 'full'
      - 'delta' (changes only)

  |example
    |input
      timeline ./experiment.udon --key :date --show delta

    |output
      |timeline
        2025-01-15  |experiment[checkout-button]
                      :status → running
                      :traffic-allocation 0.5

        2025-01-22  |results added
                      |variant-result[control] :sessions 15230
                      |variant-result[treatment] :sessions 15180

        2025-01-29  |results updated
                      :sessions +8220 (control), +8200 (treatment)
                    |segment-results added
                      Mobile: +24.7% lift (p=0.008)

        2025-02-01  :status → completed
                    |decision :outcome approved-with-modifications
                    |rollout-plan added
```

---

### template

Instantiate templates with context data.

```udon
|tool[template]
  |purpose
    Generate content from templates. Useful for:
    - Response generation in dialogue systems
    - Creating new elements from patterns
    - Scaffolding documents from schemas

  |when-to-use
    - Generating dialogue responses with slot filling
    - Creating new config sections from templates
    - Scaffolding documentation from schemas
    - Batch-generating test cases

  |parameters
    |template :required
      Path to template, or inline template
    |context :required
      Data to fill template with
    |validate :default true
      Check output against schema if available

  |example
    |input
      template ./responses.udon.order-status
        :context
          |order
            :id ORD-98765
            :status shipped
            :ship_date 2025-12-20
            :arrival_date 2025-12-24

    |output
      Your order ORD-98765 shipped on December 20th
      and should arrive in 4 days.
```

---

### audit

Generate compliance/audit reports from documents.

```udon
|tool[audit]
  |purpose
    Extract audit-relevant information. For compliance, governance,
    transparency requirements.

  |when-to-use
    - Generating model cards for ML transparency
    - SBOM generation for supply chain
    - Decision audit trails
    - Regulatory compliance reporting

  |parameters
    |file :required
    |report-type :required
      'model-card', 'sbom', 'decision-log', 'change-history', 'custom'
    |schema
      Custom report schema
    |format :default udon
      Output format

  |example
    |input
      audit ./model.udon --report-type model-card

    |output
      |model-card
        |overview
          :name sentiment-classifier-v2
          :task sentiment-analysis
          :performance
            :f1 0.89
            :known-biases [age linguistic]

        |training-data
          :source twitter-sentiment-2024
          :size 50000
          :date-range 2024-01-01 to 2024-12-31

        |limitations
          - AAVE text: 71% accuracy (vs 89% overall)
          - Sarcasm detection: 58% accuracy

        |intended-use
          Customer feedback analysis (non-critical)

        |prohibited-use
          Mental health screening, employment decisions
```

---

## Future Directions

Potential enhancements to explore.

```udon
|future
  |cross-file-operations
    Refactoring across multiple files.
    Extract common elements to shared file.
    Update references automatically.

  |interactive-mode
    TUI for real-time exploration.
    Vim-like navigation.
    Live preview of modifications.

  |ai-context-protocol
    Direct integration with agent context.
    Tools automatically summarize to fit context window.
    Progressive loading as agent requests detail.

  |version-control-integration
    Semantic diff for git.
    Merge conflict resolution aware of structure.
    Blame at element level, not line level.

  |schema-inference
    Generate schema from existing documents.
    Learn patterns across corpus.
    Suggest schema refinements.
```
