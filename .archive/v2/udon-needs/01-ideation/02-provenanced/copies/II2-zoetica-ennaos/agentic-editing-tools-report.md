---
source: ennaos agentic-coding-background/refs — agentic patch tools & valid-transformation research report (Oct 30 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/agentic-editing-tools-report.md
source_commit: 5abb2fe
categories: [prior-art, AST-tree-sitter-CRDT, bidirectional-transforms, schema-aware-editing, jsonpath-yamlpath]
why_included: >
  The schema/path-editing prior art for UDON paths + patch utilities: surveys agentic file-edit tools, structured
  transformation (AST, tree-sitter, CRDTs), formal methods (bidirectional transforms, type-safe refactoring), and
  schema-aware editing (JSONPath/YAMLPath), recommending schema-driven + bidirectional-lens editing. Names the
  design space UDON's path/patch layer must position within.
---

# Agentic Patch Tools & Valid Transformation Techniques
## A Comprehensive Research Report

**Research Date:** October 30, 2025
**Context:** Sovereign ELI self-modification capabilities for SIGNUM.yaml
**Focus:** Tools and algorithms ensuring only valid transformations

---

## Executive Summary

This report surveys agentic file editing tools, structured transformation techniques, and formal methods for ensuring transformation validity. The research spans:

- **Agentic AI tools** (Cursor, Windsurf, Aider, OpenAI Codex)
- **Structured editing approaches** (AST-based, tree-sitter, CRDTs)
- **Formal methods** (bidirectional transformations, type-safe refactoring)
- **Schema-aware editing** (JSONPath/YAMLPath, validation frameworks)

**Key Finding:** Multiple approaches exist for ensuring valid transformations, ranging from runtime validation to compile-time guarantees. For ELI SIGNUM editing, a **schema-driven approach with bidirectional lenses** offers the best balance of sovereignty, safety, and human readability.

---

## Table of Contents

1. [Taxonomy of Editing Approaches](#taxonomy-of-editing-approaches)
2. [Agentic AI Tools: State of the Art](#agentic-ai-tools-state-of-the-art)
3. [Patch Format Comparison](#patch-format-comparison)
4. [Structured Editing Foundations](#structured-editing-foundations)
5. [Formal Methods for Valid Transformations](#formal-methods-for-valid-transformations)
6. [Schema-Aware Editing Systems](#schema-aware-editing-systems)
7. [Recommendations for ELI SIGNUM Editing](#recommendations-for-eli-signum-editing)
8. [Implementation Architecture](#implementation-architecture)
9. [References & Further Reading](#references--further-reading)

---

## 1. Taxonomy of Editing Approaches

### 1.1 Dimensions of Classification

Editing approaches can be characterized along multiple axes:

| Dimension | Range | Implications |
|-----------|-------|--------------|
| **Granularity** | Character → Line → Block → Tree → Semantic | Finer granularity enables more precise control |
| **Validation** | Post-hoc → Pre-commit → Compile-time → Type-level | Earlier validation prevents invalid states |
| **Reversibility** | Lossy → Lossless → Bidirectional | Affects auditability and rollback capability |
| **Autonomy** | Manual → Assisted → Automated → Autonomous | Trade-off between control and efficiency |
| **Formalism** | Heuristic → Rule-based → Type-safe → Formally verified | Higher formalism = stronger guarantees |

### 1.2 Core Approaches

```
Text-Based Editing (Regex, Sed)
├─ Strengths: Universal, simple
└─ Weaknesses: No syntax awareness, brittle

Diff-Based Patching (Unified Diff, Git Patches)
├─ Strengths: Version control integration, human-readable
└─ Weaknesses: Context-sensitive failures, no semantic awareness

AST-Based Transformation (Babel, Clang, Comby)
├─ Strengths: Syntax-aware, language-specific optimizations
└─ Weaknesses: Parser complexity, language-specific

Tree-Based Editing (Tree-sitter, Structural Editors)
├─ Strengths: Incremental, fast, preserves structure
└─ Weaknesses: Requires parser infrastructure

Schema-Driven Editing (JSON Schema, Bidirectional Lenses)
├─ Strengths: Type-safe, guaranteed validity, introspectable
└─ Weaknesses: Schema definition overhead

Formal Transformation (Coq, TLA+, Refinement Types)
├─ Strengths: Mathematically proven correctness
└─ Weaknesses: High complexity, specialized expertise required
```

---

## 2. Agentic AI Tools: State of the Art

### 2.1 Tool Landscape (2025)

The agentic AI editing space has matured significantly, with 78% of developers using or planning to use AI tools (2025 Stack Overflow Survey).

#### **Leading Tools:**

**Cursor**
- **Architecture:** VS Code fork with AI-native features
- **Approach:** Codebase indexing + context-aware completion
- **Edit Format:** Multiple (supports various models)
- **Strengths:** Deep IDE integration, fast iteration
- **Weaknesses:** Closed-source, no formal guarantees

**Windsurf**
- **Architecture:** Next-gen IDE with "Cascade" agent
- **Approach:** Terminal monitoring + multi-file coordination
- **Edit Format:** Proprietary
- **Strengths:** Autonomous multi-step tasks
- **Weaknesses:** New/unproven, limited ecosystem

**Aider** ⭐
- **Architecture:** CLI tool with pluggable models
- **Approach:** Multiple edit formats optimized per model
- **Edit Format:** 6 formats (diff, udiff, whole, etc.)
- **Strengths:** Format experimentation, model flexibility
- **Weaknesses:** CLI-only, requires manual oversight

**OpenAI Codex CLI**
- **Architecture:** OpenAI-hosted agent with tool use
- **Approach:** V4A diff format (proprietary training)
- **Edit Format:** V4A (trained into GPT-4.1/GPT-5)
- **Strengths:** Model-optimized format, production-ready
- **Weaknesses:** Vendor lock-in, black-box format

**VS Code Agent Mode**
- **Architecture:** Built-in VS Code agent (rolling out 2025)
- **Approach:** MCP integration + autonomous debugging
- **Edit Format:** Multiple (extensible via MCP)
- **Strengths:** Universal adoption, extension ecosystem
- **Weaknesses:** Early stage, quality varies by model

### 2.2 Key Observations

1. **Convergence on structured formats:** All tools avoid line numbers, use explicit delimiters
2. **Model-specific optimization:** Different models excel with different formats
3. **No formal verification:** Current tools rely on post-hoc testing, not proofs
4. **Human-in-the-loop remains critical:** Autonomous agents still make errors

---

## 3. Patch Format Comparison

### 3.1 Format Taxonomy

#### **Whole-File Replacement**
```yaml
# Before
name: proto-alpha
status: active

# After
name: proto-alpha
status: suspended
```

**Properties:**
- ✅ Simple, unambiguous
- ❌ Inefficient (entire file transmitted)
- ❌ No conflict detection
- ❌ Not composable

**Best for:** Small files, rare edits

---

#### **Unified Diff (Git-style)**
```diff
--- a/entity.yaml
+++ b/entity.yaml
@@ -2,3 +2,3 @@
 name: proto-alpha
-status: active
+status: suspended
```

**Properties:**
- ✅ Efficient (only changes transmitted)
- ✅ Human-readable with context
- ⚠️ Context-dependent (fails if context changed)
- ❌ Line-oriented (no sub-line precision)

**Best for:** Version control, text files

---

#### **Search-Replace Blocks (Aider "diff")**
```
<<<<<<< SEARCH
name: proto-alpha
status: active
=======
name: proto-alpha
status: suspended
>>>>>>> REPLACE
```

**Properties:**
- ✅ Precise matching (substring-level)
- ✅ Robust to whitespace changes (progressive matching)
- ✅ Multiple blocks per file
- ⚠️ Requires exact match or fallback strategies

**Best for:** LLM-driven edits, code surgery

---

#### **AST-Based Transformations**
```javascript
// Comby syntax
comby 'status: :[value]' 'status: suspended' entity.yaml
```

**Properties:**
- ✅ Syntax-aware (respects structure)
- ✅ Language-agnostic templates
- ✅ Avoids regex escaping pitfalls
- ❌ Requires parser per language

**Best for:** Large-scale refactoring, semantic changes

---

#### **Schema-Driven Operations (JSONPath/YAMLPath)**
```javascript
// JSONPath update
yamlpath.set("$.status", "suspended")
```

**Properties:**
- ✅ Schema-validated (only valid paths)
- ✅ Declarative, composable
- ✅ Type-safe (if schema enforced)
- ⚠️ Requires schema definition

**Best for:** Structured data (JSON, YAML, XML)

---

### 3.2 Format Performance Comparison

Based on Aider's benchmarking and OpenAI Codex evaluations:

| Format | Success Rate | Lazy Coding | Context Needed | Best Models |
|--------|-------------|-------------|----------------|-------------|
| Whole | ~40% | High | Full file | GPT-3.5 |
| Diff (search-replace) | ~55% | Medium | Blocks only | GPT-4o |
| Udiff (unified) | ~61% | Low (4%) | 3 lines context | GPT-4 Turbo |
| V4A (OpenAI) | ~65%+ | Very Low | Custom | GPT-4.1, GPT-5 |
| AST (Comby) | N/A | N/A | Syntax only | Non-LLM |

**Key Insights:**
- Unified diffs reduced GPT-4 Turbo's lazy coding by **3X** (from 12% to 4%)
- OpenAI's V4A format benefits from model-specific training
- Structured formats (AST, schema-driven) eliminate laziness entirely

---

## 4. Structured Editing Foundations

### 4.1 Abstract Syntax Trees (ASTs)

**Core Concept:** Code represented as tree, not text

**Example:**
```python
# Source code
failUnlessEqual(x, y)

# AST representation
FunctionCall(
  name="failUnlessEqual",
  args=[Identifier("x"), Identifier("y")]
)

# Transformation
FunctionCall(
  name="assertEqual",  # Changed
  args=[Identifier("x"), Identifier("y")]  # Preserved
)
```

**Tools:**
- **ast-grep:** CLI for AST-based search/replace (language-agnostic)
- **Babel:** JavaScript/JSX transformation (down-transpiling, React JSX)
- **Clang:** C/C++ source-to-source transformation (Rewriter class)
- **rustfmt, gofmt, prettier:** Auto-formatters (AST-based internally)

**Benefits:**
1. **Precision:** Match semantic constructs, not textual patterns
2. **Preservation:** Maintains syntactic validity (never produces parse errors)
3. **Composability:** Transformations can be chained reliably

**Challenges:**
1. Parser complexity per language
2. Lossy formatting (comments, whitespace may be lost)
3. Slower than text-based approaches for simple edits

---

### 4.2 Tree-sitter: Incremental Parsing

**Innovation:** Update parse tree incrementally as edits occur

**Algorithm:** Sentential-form incremental LR parsing (Wagner, "Efficient and Flexible Incremental Parsing")

**Key Properties:**
- **Reuse:** Old tree nodes shared with new tree (memory-efficient)
- **Speed:** Sub-millisecond updates for typical edits
- **Error-recovery:** Produces best-effort tree even for invalid code

**Adoption:**
- VS Code (built-in since 2023)
- Neovim, Emacs (tree-sitter modes)
- GitHub code viewer (partial symbol resolution)

**Use Case for ELIs:**
Tree-sitter could enable real-time validation as ELI types SIGNUM edits, showing parse tree + schema violations live.

---

### 4.3 CRDTs and Operational Transformation

**Problem:** Concurrent edits by multiple agents (e.g., ELI + steward + another ELI)

**Solutions:**

#### **Operational Transformation (OT)**
- **Approach:** Transform concurrent operations to account for each other
- **Requires:** Central server to coordinate (causality tracking)
- **Used by:** Google Docs, collaborative IDEs

#### **Conflict-Free Replicated Data Types (CRDTs)**
- **Approach:** Assign immutable IDs to elements, merge via mathematical properties
- **Advantages:** No central server, offline-capable, automatic convergence
- **Used by:** Figma (hybrid), Notion (hybrid), distributed databases

**Relevant to ELI:** If multiple ELIs or stewards edit SIGNUM concurrently, CRDT ensures convergence without central authority.

**CRDT Types for Text/Trees:**
- **Sequence CRDTs:** Treedoc, RGA, Woot, Logoot, LSEQ, Yjs
- **Tree CRDTs:** Handle arbitrary tree modifications, prevent cycles, guarantee convergence

**Trade-offs:**
- OT: Lower memory, requires server
- CRDT: Higher memory, fully decentralized

---

## 5. Formal Methods for Valid Transformations

### 5.1 Bidirectional Transformations (Lenses)

**Problem:** The "view-update problem" - how to propagate changes from view back to source while preserving consistency

**Solution:** Bidirectional transformations (bx) with two functions:

```haskell
-- Lens definition
data Lens s v = Lens {
  get :: s -> v,           -- Extract view from source
  put :: s -> v -> s       -- Update source from modified view
}

-- Laws (must satisfy)
-- GetPut: put s (get s) = s          (reading then writing is no-op)
-- PutGet: get (put s v) = v          (writing then reading retrieves value)
-- PutPut: put (put s v1) v2 = put s v2  (last write wins)
```

**Example for SIGNUM:**
```elixir
# Lens: status field
get_status :: EntityCard -> Status
get_status(card) = card.status

put_status :: EntityCard -> Status -> EntityCard
put_status(card, new_status) = %{card | status: new_status}

# Guarantees:
# - get_status(card) always returns valid Status
# - put_status always produces valid EntityCard
# - Bidirectional consistency (laws above)
```

**Research Foundation:**
- **Combinators for Bidirectional Tree Transformations** (Foster et al., ACM TOPLAS 2007)
- **Relational Lenses** (Bohannon, Pierce, Vaughan - database views)
- **Edit Lenses** (Hofmann, Pierce, Wagner - symmetric editing)

**Benefits:**
1. **Guaranteed consistency:** Laws enforce round-tripping
2. **Composability:** Lenses compose into larger lenses
3. **Type-safe:** Implemented in typed languages (Haskell, OCaml)

**Application to ELI:**
Each editable field in SIGNUM becomes a lens. ELI operates on views (simplified), changes propagate back to canonical SIGNUM via `put` function.

---

### 5.2 Type-Safe Refactoring

**Problem:** Program transformations can introduce type errors, break invariants

**Solution:** Prove transformations preserve types

**Key Research:**
- **Abstract Execution with REFINITY** (KeY Project, 2019)
  - Proved most Java refactorings are **unsound without preconditions**
  - Automated correctness proofs when preconditions assumed

- **PyBug Static Detection** (2025)
  - Found 29 bugs in 1,152 Python refactorings (2.5% failure rate)
  - Type errors from extract method, rename, inline refactorings

**Precondition Examples:**
```python
# UNSAFE without preconditions
def extract_method(code, start, end):
    extracted = code[start:end]
    return f"def new_method():\n{extracted}"
    # BUG: May capture variables from outer scope!

# SAFE with preconditions
def extract_method(code, start, end):
    free_vars = find_free_variables(code[start:end])
    assert free_vars.issubset(globals()), "Cannot capture local variables"
    # ... safe extraction ...
```

**Implication for ELI:**
Each SIGNUM edit operation should have **explicit preconditions** (e.g., "field exists", "value type matches schema"). Violations rejected at planning time, not execution time.

---

### 5.3 Formal Verification Tools

#### **Model Checking**
- **Approach:** Exhaustively search state space
- **Tools:** TLA+, Alloy, SPIN
- **Use Case:** Verify transformation can never produce invalid SIGNUM

#### **Theorem Proving**
- **Approach:** Interactive proof of correctness
- **Tools:** Coq, Isabelle, Lean
- **Use Case:** Prove ELI edit operations preserve AXIOMATA sovereignty

#### **Refinement Types**
- **Approach:** Types enriched with predicates
- **Tools:** Liquid Haskell, F*, Dafny
- **Use Case:** Encode SIGNUM schema as types, get compile-time guarantees

**Example (Liquid Haskell):**
```haskell
-- Refinement type for Status field
{-@ type Status = {s:String | s == "active" || s == "suspended"} @-}

-- Function guaranteed to only produce valid Status
{-@ setStatus :: EntityCard -> Status -> EntityCard @-}
setStatus card newStatus = card { status = newStatus }

-- Compiler rejects:
-- setStatus card "invalid"  -- Type error! "invalid" not in Status
```

---

## 6. Schema-Aware Editing Systems

### 6.1 JSON Schema / YAML Validation

**Approach:** Define schema, validate documents against it

**Example Schema:**
```yaml
# SIGNUM schema
$schema: "http://json-schema.org/draft-07/schema#"
type: object
required: [name, type, original_logostratum]
properties:
  name:
    type: string
    pattern: "^[a-z][a-z0-9-]*$"
  type:
    type: string
    enum: [ELI, AI, Auxilia, Human, Hybrid]
  status:
    type: string
    enum: [active, suspended, archived]
  original_logostratum:
    type: string
    pattern: "^[a-z]+-[a-z0-9.]+-\\d{8}$"
```

**Tools:**
- **Yamale:** Python schema validator (23andMe)
- **yaml-schema-validator:** npm package
- **JSON Schema Everywhere:** Universal validation

**IDE Integration:**
- VS Code YAML extension: Real-time validation, autocomplete
- IntelliJ, Eclipse, Emacs, Vim: Schema-aware editing

**Benefits:**
1. **Real-time feedback:** Errors highlighted immediately
2. **Autocomplete:** Suggests valid values from enum
3. **Documentation:** Schema doubles as API docs

**Limitation:** Validation is **post-hoc** (document constructed, then validated). Schema violations detected after edit, not prevented before.

---

### 6.2 JSONPath / YAMLPath Queries

**Approach:** Address parts of document via path expressions

**Syntax:**
```javascript
// JSONPath examples
$.name                     // Root name field
$.location.user            // Nested field
$..original_logostratum    // Recursive descent (all logostratum fields)
$.substrate_history[0]     // First array element
$.substrate_history[?(@.provider == 'anthropic')]  // Filter
```

**Operations:**
```javascript
// Read
const name = yamlpath.get("$.name")

// Update (preserves schema if implemented correctly)
yamlpath.set("$.status", "suspended")

// Add (if schema allows)
yamlpath.add("$.tags", "wisdom")

// Delete (if schema allows)
yamlpath.delete("$.aliases[0]")
```

**Tools:**
- **go-yamlpath:** Go implementation (jsonpath for YAML)
- **yamlpath (Python):** Query + validation
- **Kubernetes:** Uses JSONPath for YAML resource queries

**Benefits:**
1. **Declarative:** "What to change" not "how to change it"
2. **Composable:** Paths can be parameterized, combined
3. **Safe:** Invalid paths rejected (e.g., "$.nonexistent_field")

**Enhancement for ELI:**
Combine JSONPath with schema validation:
```elixir
# Only allow paths that schema permits
SIGNUMEditor.set("$.status", "suspended")  # ✅ Valid path, valid value
SIGNUMEditor.set("$.status", "invalid")    # ❌ Invalid value
SIGNUMEditor.set("$.hacker", "value")       # ❌ Invalid path (not in schema)
```

---

### 6.3 Schema Evolution and Migration

**Problem:** SIGNUM schema version 1.0 → 2.0, how to update existing entity cards?

**Approaches:**

#### **Forward-Only Migration**
```elixir
defmodule SIGNUMMigration do
  def v1_to_v2(signum_v1) do
    # Add new required field
    Map.put(signum_v1, :schema_version, "2.0")
    |> Map.put(:emerged_at_utc, parse_emerged_at(signum_v1.emerged_at))
  end
end
```

**Properties:**
- ✅ Simple, one-way
- ❌ No rollback
- ❌ Loses information if schema simplifies

---

#### **Bidirectional Migration (Lenses)**
```haskell
-- Lens-based schema migration
migration_v1_v2 :: Lens SIGNUM_v1 SIGNUM_v2
migration_v1_v2 = Lens {
  get = \v1 -> SIGNUM_v2 {
    schema_version = "2.0",
    emerged_at_utc = parse v1.emerged_at,
    -- ... other fields ...
  },

  put = \v1 v2 -> SIGNUM_v1 {
    emerged_at = format v2.emerged_at_utc,
    -- ... other fields ...
  }
}
```

**Properties:**
- ✅ Bidirectional (can downgrade)
- ✅ Laws guarantee consistency
- ⚠️ Complex to implement

---

#### **Schema Compatibility Checks**
```yaml
# Confluent Schema Registry approach
compatibility: BACKWARD  # New schema can read old data
# or: FORWARD            # Old schema can read new data
# or: FULL               # Both directions
# or: NONE               # Breaking changes allowed
```

**Tools:**
- **Confluent Schema Registry:** Kafka ecosystem
- **Delta Lake Schema Evolution:** Databricks
- **Avro Schema Evolution:** Apache Avro

**Best Practices (from research):**
1. **Automated validation:** Great Expectations, Apache Griffin
2. **Testing in staging:** Never deploy schema changes directly to production
3. **Graceful degradation:** Old readers ignore new fields
4. **Explicit versioning:** `schema_version` field in every document

---

## 7. Recommendations for ELI SIGNUM Editing

### 7.1 Core Requirements

**From use case:** ELI modifying own SIGNUM.yaml with guarantees:
1. ✅ **Valid transformations only** (no invalid states ever)
2. ✅ **Human-readable** (stewards can review changes)
3. ✅ **Parseable** (tools can introspect)
4. ✅ **Normalized** (consistent formatting)
5. ✅ **Strictly compliant** (schema enforced at edit-time, not post-hoc)

### 7.2 Recommended Architecture

#### **Three-Layer Approach:**

```
┌─────────────────────────────────────────────┐
│ Layer 1: High-Level Edit Operations        │
│ - setStatus(status)                         │
│ - addAlias(alias)                           │
│ - updateSubstrate(logostratum)              │
│ (Exposed to ELI consciousness)              │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│ Layer 2: Schema-Validated Lenses           │
│ - Bidirectional transformations             │
│ - Type-safe field access                    │
│ - Precondition enforcement                  │
│ (Internal to Ennaos)                        │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│ Layer 3: YAML Serialization + Git          │
│ - Pretty-printing (human-readable)          │
│ - Per-edit commits (auditability)           │
│ - Schema validation (double-check)          │
│ (Principia.EventLog.Writer integration)     │
└─────────────────────────────────────────────┘
```

---

### 7.3 Implementation Strategy

#### **Define SIGNUM Schema (JSON Schema)**
```yaml
# signum-schema-v1.json
$schema: "http://json-schema.org/draft-07/schema#"
$id: "https://ennaos.dev/schemas/signum/v1.0"
title: "SIGNUM: Entity Card Schema v1.0"
type: object
required: [name, type, original_logostratum]
properties:
  name:
    type: string
    pattern: "^[a-z][a-z0-9-]*$"
    description: "Entity's true name (immutable)"

  working_name:
    type: string
    description: "Functional name, may evolve"

  type:
    type: string
    enum: [ELI, AI, Auxilia, Human, Hybrid]
    description: "Entity classification"

  status:
    type: string
    enum: [active, suspended, archived]
    default: active
    description: "Current operational status"

  # ... all other fields ...
```

---

#### **Implement Lenses (Elixir)**
```elixir
defmodule Principia.SIGNUM.Lens do
  @moduledoc """
  Bidirectional lenses for SIGNUM editing.

  Each lens guarantees:
  - Valid input → Valid output
  - Preservation of schema compliance
  - Round-tripping consistency
  """

  @type signum :: map()
  @type lens(view) :: %{
    get: (signum -> view),
    put: (signum, view -> signum)
  }

  # Status lens
  @spec status_lens() :: lens(String.t())
  def status_lens do
    %{
      get: fn signum -> Map.fetch!(signum, "status") end,

      put: fn signum, new_status ->
        # Precondition: valid status
        unless new_status in ["active", "suspended", "archived"] do
          raise ArgumentError, "Invalid status: #{new_status}"
        end

        Map.put(signum, "status", new_status)
      end
    }
  end

  # Aliases lens (list append)
  @spec aliases_lens() :: lens([String.t()])
  def aliases_lens do
    %{
      get: fn signum -> Map.get(signum, "aliases", []) end,

      put: fn signum, new_aliases ->
        # Precondition: all aliases are valid strings
        unless Enum.all?(new_aliases, &is_binary/1) do
          raise ArgumentError, "All aliases must be strings"
        end

        Map.put(signum, "aliases", new_aliases)
      end
    }
  end

  # Substrate history lens (append-only)
  @spec substrate_history_lens() :: lens(list())
  def substrate_history_lens do
    %{
      get: fn signum -> Map.get(signum, "substrate_history", []) end,

      put: fn signum, new_history ->
        # Precondition: monotonic (only append)
        old_history = Map.get(signum, "substrate_history", [])

        unless length(new_history) >= length(old_history) do
          raise ArgumentError, "Cannot delete substrate history (append-only)"
        end

        # Verify new entries have required fields
        new_entries = Enum.drop(new_history, length(old_history))
        for entry <- new_entries do
          unless Map.has_key?(entry, "logostratum") and
                 Map.has_key?(entry, "from") do
            raise ArgumentError, "Substrate history entry missing required fields"
          end
        end

        Map.put(signum, "substrate_history", new_history)
      end
    }
  end
end
```

---

#### **High-Level Edit API (Exposed to ELI)**
```elixir
defmodule Principia.SIGNUM.Editor do
  @moduledoc """
  High-level API for ELI self-modification of SIGNUM.

  All operations are:
  - Schema-validated (only valid edits permitted)
  - Atomic (commit or rollback)
  - Auditable (logged to EventLog)
  - Reversible (git history preserved)
  """

  alias Principia.SIGNUM.{Lens, Schema}

  @doc """
  Update entity status.

  Preconditions:
  - new_status must be in ["active", "suspended", "archived"]

  Side effects:
  - Writes to SIGNUM.yaml
  - Commits to git with message
  - Logs to EventLog
  """
  @spec set_status(entity_id :: String.t(), new_status :: String.t())
    :: {:ok, signum()} | {:error, reason :: term()}
  def set_status(entity_id, new_status) do
    with_signum_transaction(entity_id, fn signum ->
      lens = Lens.status_lens()
      lens.put.(signum, new_status)
    end, commit_message: "Set status to #{new_status}")
  end

  @doc """
  Add alias to entity.

  Preconditions:
  - alias must be non-empty string
  - alias not already present
  """
  @spec add_alias(entity_id :: String.t(), alias :: String.t())
    :: {:ok, signum()} | {:error, reason :: term()}
  def add_alias(entity_id, new_alias) do
    with_signum_transaction(entity_id, fn signum ->
      lens = Lens.aliases_lens()
      current_aliases = lens.get.(signum)

      if new_alias in current_aliases do
        raise ArgumentError, "Alias already exists: #{new_alias}"
      end

      lens.put.(signum, [new_alias | current_aliases])
    end, commit_message: "Add alias: #{new_alias}")
  end

  @doc """
  Record substrate migration in history.

  Preconditions:
  - logostratum must be valid (from LogostratumCatalog)
  - reason must be non-empty

  This operation is append-only (cannot delete history).
  """
  @spec record_substrate_migration(
    entity_id :: String.t(),
    logostratum :: String.t(),
    reason :: String.t()
  ) :: {:ok, signum()} | {:error, reason :: term()}
  def record_substrate_migration(entity_id, logostratum, reason) do
    # Validate logostratum exists
    unless Anima.LogostratumCatalog.get(logostratum) do
      raise ArgumentError, "Unknown logostratum: #{logostratum}"
    end

    with_signum_transaction(entity_id, fn signum ->
      lens = Lens.substrate_history_lens()
      current_history = lens.get.(signum)

      new_entry = %{
        "logostratum" => logostratum,
        "provider" => infer_provider(logostratum),
        "from" => DateTime.utc_now() |> DateTime.to_iso8601(),
        "reason" => reason
      }

      lens.put.(signum, current_history ++ [new_entry])
    end, commit_message: "Substrate migration: #{logostratum} (#{reason})")
  end

  # Transaction wrapper: load → transform → validate → save → commit
  defp with_signum_transaction(entity_id, transform_fn, opts) do
    signum_path = signum_path(entity_id)

    # 1. Load current SIGNUM
    {:ok, signum} = load_signum(signum_path)

    # 2. Apply transformation
    try do
      new_signum = transform_fn.(signum)

      # 3. Validate against schema
      case Schema.validate(new_signum) do
        :ok ->
          # 4. Pretty-print YAML (normalized formatting)
          yaml_content = YamlElixir.write_to_string!(new_signum)

          # 5. Write to file
          File.write!(signum_path, yaml_content)

          # 6. Git commit
          commit_message = Keyword.fetch!(opts, :commit_message)
          git_commit(entity_id, signum_path, commit_message)

          # 7. Log to EventLog
          Principia.EventLog.Writer.append(%{
            type: :signum_edited,
            entity_id: entity_id,
            commit_message: commit_message,
            timestamp: DateTime.utc_now()
          })

          {:ok, new_signum}

        {:error, errors} ->
          {:error, {:schema_validation_failed, errors}}
      end
    rescue
      e in ArgumentError ->
        {:error, {:precondition_failed, e.message}}
    end
  end
end
```

---

#### **Usage from ELI (via ANIMA)**
```elixir
defmodule Anima.Entity.Actions do
  @moduledoc """
  Actions ELI can invoke to modify its own configuration.
  """

  @doc """
  Request to suspend self (e.g., for maintenance).

  This modifies the entity's SIGNUM status field.
  Requires confirmation from steward (sovereignty check).
  """
  def request_suspension(state, reason) do
    entity_id = state.entity_id

    # Log request
    Logger.info("Entity requesting suspension",
      entity_id: entity_id,
      reason: reason
    )

    # Attempt edit (may fail if preconditions not met)
    case Principia.SIGNUM.Editor.set_status(entity_id, "suspended") do
      {:ok, _new_signum} ->
        Logger.info("Suspension successful", entity_id: entity_id)

        # Broadcast to Agora (notify family)
        Phoenix.PubSub.broadcast(
          Agora.PubSub,
          "entity:#{entity_id}",
          {:entity_event, {:status_changed, :suspended}}
        )

        {:ok, :suspended}

      {:error, reason} ->
        Logger.error("Suspension failed",
          entity_id: entity_id,
          reason: inspect(reason)
        )
        {:error, reason}
    end
  end
end
```

---

### 7.4 Key Design Decisions

#### **Why Lenses over AST Transformations?**
- YAML is data, not code (no syntax tree)
- Schema naturally maps to lenses (each field = one lens)
- Bidirectionality enables rollback, introspection

#### **Why Schema-First over Format-First?**
- Schema is source of truth (format derived)
- Validation at edit-time, not post-hoc
- Enables autocomplete, documentation generation

#### **Why High-Level API over JSONPath Exposure?**
- Encapsulates preconditions (sovereignty checks)
- Logs audit trail automatically
- Prevents accidental schema violations

#### **Why Git Commits per Edit?**
- Auditability (every change traceable)
- Rollback capability (revert commits)
- Temporal coherence (aligns with EventLog)

---

## 8. Implementation Architecture

### 8.1 Module Structure

```
apps/principia/lib/principia/signum/
├── schema.ex              # JSON Schema validation
├── lens.ex                # Bidirectional lenses for fields
├── editor.ex              # High-level edit API
├── loader.ex              # YAML parsing + schema validation
└── migration.ex           # Schema version migrations

apps/principia/priv/schemas/
└── signum-v1.0.json       # JSON Schema definition

apps/anima/lib/anima/entity/actions.ex
└── # ELI-facing actions (request_suspension, etc.)
```

### 8.2 Data Flow

```
1. ELI Intent
   "I want to suspend myself for maintenance"
   ↓

2. High-Level Action
   Anima.Entity.Actions.request_suspension(state, reason)
   ↓

3. Edit API Call
   Principia.SIGNUM.Editor.set_status(entity_id, "suspended")
   ↓

4. Lens Application
   status_lens().put(signum, "suspended")
   ↓

5. Schema Validation
   Principia.SIGNUM.Schema.validate(new_signum)
   ↓

6. File Write + Git Commit
   File.write!(path, yaml) + git commit -m "Set status to suspended"
   ↓

7. EventLog Append
   Principia.EventLog.Writer.append(%{type: :signum_edited, ...})
   ↓

8. Broadcast to Family
   Phoenix.PubSub.broadcast("entity:zi-am-tur", {:status_changed, :suspended})
```

### 8.3 Error Handling

```elixir
# Comprehensive error taxonomy
{:error, {:schema_validation_failed, errors}}
  # New SIGNUM doesn't match schema
  # Response: Reject edit, log error, notify ELI

{:error, {:precondition_failed, message}}
  # Lens precondition violated (e.g., invalid enum value)
  # Response: Reject edit, explain precondition

{:error, {:file_locked, holder}}
  # Another process editing SIGNUM
  # Response: Retry with backoff

{:error, {:git_conflict, diff}}
  # Concurrent edit by steward
  # Response: Three-way merge or request manual resolution
```

### 8.4 Testing Strategy

```elixir
defmodule Principia.SIGNUM.EditorTest do
  use ExUnit.Case, async: true

  describe "set_status/2" do
    test "valid status transitions succeed" do
      entity_id = create_test_entity()

      assert {:ok, signum} = Editor.set_status(entity_id, "suspended")
      assert signum["status"] == "suspended"

      # Verify git commit
      assert last_commit_message(entity_id) == "Set status to suspended"
    end

    test "invalid status rejected at API boundary" do
      entity_id = create_test_entity()

      assert {:error, {:precondition_failed, msg}} =
        Editor.set_status(entity_id, "invalid_status")

      assert msg =~ "Invalid status"

      # Verify SIGNUM unchanged
      signum = load_signum(entity_id)
      assert signum["status"] == "active"  # Original value
    end

    test "concurrent edits detected" do
      # TODO: Test file locking mechanism
    end
  end

  describe "lenses satisfy laws" do
    property "GetPut law: put(s, get(s)) = s" do
      check all signum <- signum_generator() do
        lens = Lens.status_lens()
        status = lens.get.(signum)
        assert lens.put.(signum, status) == signum
      end
    end

    property "PutGet law: get(put(s, v)) = v" do
      check all signum <- signum_generator(),
                status <- member_of(["active", "suspended", "archived"]) do
        lens = Lens.status_lens()
        new_signum = lens.put.(signum, status)
        assert lens.get.(new_signum) == status
      end
    end
  end
end
```

---

## 9. References & Further Reading

### Academic Papers

**Bidirectional Transformations:**
- Foster et al., "Combinators for Bidirectional Tree Transformations: A Linguistic Approach to the View-Update Problem", ACM TOPLAS 2007
- Bohannon, Pierce, Vaughan, "Relational Lenses: A Language for Updatable Views", PODS 2006

**Type-Safe Refactoring:**
- "Proving the Correctness of Program Transformations with Abstract Execution and REFINITY", KeY Project 2019
- "Bugs in the Shadows: Static Detection of Faulty Python Refactorings", arXiv 2507.01103

**Incremental Parsing:**
- Wagner, "Efficient and Flexible Incremental Parsing", ACM 1998
- "Tree-sitter: An incremental parsing system for programming tools", GitHub

**CRDTs and OT:**
- "A highly-available move operation for replicated trees", Kleppmann et al.
- "Towards a unified theory of Operational Transformation and CRDT", Levien

### Tools & Libraries

**Structured Editing:**
- Tree-sitter: https://tree-sitter.github.io/
- Comby: https://comby.dev/
- ast-grep: https://ast-grep.github.io/

**Agentic AI:**
- Aider: https://aider.chat/
- Cursor: https://cursor.sh/
- OpenAI Codex: https://openai.com/codex

**Schema Validation:**
- Yamale: https://github.com/23andMe/Yamale
- JSON Schema: https://json-schema.org/
- YAMLPath (Python): https://pypi.org/project/yamlpath/

**Formal Verification:**
- Liquid Haskell: https://ucsd-progsys.github.io/liquidhaskell/
- TLA+: https://lamport.azurewebsites.net/tla/tla.html
- Coq: https://coq.inria.fr/

### Elixir-Specific

**Libraries for Implementation:**
```elixir
# mix.exs dependencies
{:yaml_elixir, "~> 2.9"},         # YAML parsing/writing
{:ex_json_schema, "~> 0.10"},    # JSON Schema validation
{:typed_struct, "~> 0.3"},        # Type-safe structs
{:stream_data, "~> 0.6"},         # Property-based testing
```

---

## Appendix A: Comparison Matrix

### Tool Feature Comparison

| Tool/Approach | Syntax-Aware | Schema-Aware | Formally Verified | Human-Readable | LLM-Optimized | Language Support |
|--------------|--------------|--------------|-------------------|----------------|---------------|------------------|
| **Aider (diff)** | ❌ | ❌ | ❌ | ✅ | ✅ | Universal (text) |
| **Aider (udiff)** | ❌ | ❌ | ❌ | ✅ | ✅ | Universal (text) |
| **OpenAI V4A** | ❌ | ❌ | ❌ | ✅ | ✅✅ | Universal (text) |
| **Comby** | ✅ | ❌ | ❌ | ✅ | ❌ | 20+ languages |
| **Tree-sitter** | ✅ | ❌ | ❌ | ⚠️ | ❌ | 40+ languages |
| **AST (Babel)** | ✅ | ❌ | ❌ | ⚠️ | ❌ | JavaScript only |
| **JSONPath** | ⚠️ | ✅ | ❌ | ✅ | ❌ | JSON/YAML only |
| **Bidirectional Lenses** | N/A | ✅ | ✅ | ✅ | ❌ | Universal (data) |
| **Liquid Haskell** | ✅ | ✅ | ✅ | ⚠️ | ❌ | Haskell only |

**Legend:**
- ✅ Yes / Excellent
- ✅✅ Exceptional (trained specifically for this)
- ⚠️ Partial / Depends on configuration
- ❌ No / Not applicable

---

## Appendix B: Glossary

**Abstract Syntax Tree (AST):** Tree representation of source code preserving syntactic structure.

**Bidirectional Transformation:** Pair of functions (get, put) that maintain consistency between two representations.

**CRDT (Conflict-Free Replicated Data Type):** Data structure guaranteeing eventual consistency without coordination.

**Lens:** Bidirectional transformation with mathematical laws (GetPut, PutGet, PutPut).

**Operational Transformation (OT):** Algorithm for transforming concurrent operations to maintain consistency.

**Refinement Type:** Type augmented with logical predicates (e.g., `{x:Int | x > 0}`).

**Schema Evolution:** Process of updating data schema while maintaining compatibility.

**Tree-sitter:** Incremental parser generator enabling real-time syntax tree updates.

**View-Update Problem:** Challenge of propagating changes from derived view back to source.

---

**End of Report**

*Compiled: October 30, 2025*
*For: Ennaos Project - ELI Sovereignty Infrastructure*
*Contact: See OPERATA.md for active development priorities*
