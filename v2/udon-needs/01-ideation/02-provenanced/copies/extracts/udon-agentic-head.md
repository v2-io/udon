---
source: live design/udon-agentic.md (head only — full file ~1200 lines)
gathered: 2026-07-21
status: gathered partial extract — full file remains at design/udon-agentic.md
paths:
  - design/udon-agentic.md
categories:
  - agent-tools
  - glance-focus
  - propose-apply
  - wishlist
why_included: |
  Tool-suite WHAT (glance→focus, propose→apply). Full file is large and partly pre-0.9 examples; head captures the suite shape. Prefer agentic-ux-principles for WHY when they disagree.
---

> **Why gathered:** Tool-suite WHAT (glance→focus, propose→apply). Full file is large and partly pre-0.9 examples; head captures the suite shape. Prefer agentic-ux-principles for WHY when they disagree.

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
