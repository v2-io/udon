# UDON

**Universal Document & Object Notation**

UDON is what you get when "Markdown with YAML frontmatter" grows up—structure and prose interleaved freely, at any depth, without the seams, crystal clear even without syntax highlighting, for humans and AI alike.

```
|article[intro].featured
  :author Joseph Wecker
  :date 2025-12-22
  :tags [udon notation design]

  |heading Welcome to UDON

  UDON treats documents and data as the same thing—because they are.
  Structure and prose coexist naturally.

  - The **readability** of Markdown for prose
  - The **structure** of XML without closing tags
  - The **simplicity** of YAML without the footguns

  !:elixir:
    defmodule Hello do
      def world, do: IO.puts("Hello from UDON")
    end
```

The project originated in 2011, paused, and is now being revived with the benefit of 14 years of hindsight—including the rise of AI agents that read and write configuration constantly, streaming output in terminals without syntax highlighting, and the hard-won lessons of YAML's "Norway problem."

Dynamics (`!if`, `!for`, `!{interpolation}`) leverage indentation to eliminate closing tags entirely.

## Tiers of Voice

UDON provides multiple layers of expression, each serving a different purpose:

| Tier | Syntax | Purpose |
|------|--------|---------|
| **Prose** | Plain text | Human narrative, explanations, context |
| **Comments** | `; ...` | Meta-notes, TODOs, maintainer context |
| **Elements** | `\|element` | Structural containers, semantic units |
| **Inline elements** | `\|{element ...}` | Embedded structure within prose |
| **Attributes** | `:key value` | Metadata on elements |
| **Dynamics** | `!if`, `!{...}` | Templating, logic, interpolation |

These tiers coexist naturally:

```
|scenario[agent-recovery]
  ; RL experiment from 2025-01-15

  |given the pole at |{state :theta 0.15 slight tilt}
  |when the agent |{select :action right :confidence 0.89}
  |then expect |{reward 1.0} and recovery

  Although to be fair, we had thrown a pebble at it—
  see |{ref :experiment perturbation-study} for details.
```

This layering makes UDON suitable as a **host for domain-specific languages**—Gherkin-like BDD for any domain, with prose flowing naturally alongside formal structure.

### When to Use Attributes vs Child Elements

A common question from XML/HTML: when should data be an `:attribute` vs a `|child` element?

UDON provides clearer guidance than the traditional "attributes for metadata" rule:

| Question | → `:attribute` | → `|child` |
|----------|----------------|------------|
| **Type** | Typed scalar (string, number, bool, list of scalars) | Untyped, arbitrary structure |
| **Cardinality** | One per key (hash semantics) | Can repeat (sequence semantics) |
| **Order** | Doesn't matter | Matters |

```udon
; Attributes: typed scalars, one per key
|message :timestamp "2025-01-15" :role user :priority 3
  Can you help with my account?

; Children: structured, repeatable, ordered
|author
  |name Jane Doe
  |affiliation
    |org Acme Corp
    |role Principal Engineer
```

The simplest test: **Can it be expressed as a typed scalar?** If yes, use `:attribute`. If it needs structure, repetition with order, or contains prose, use `|child` or inline content.

> **Note:** The example documents in `examples/` don't yet fully illustrate this distinction. Improvements pending.

### Self-Chunking for RAG/Embeddings

A key insight: UDON documents **self-segment** for retrieval-augmented generation.

Traditional text requires heuristic chunking (split on paragraphs? sentences? token windows?). UDON's structure *is* the chunking strategy:

| Tier | Embedding Granularity |
|------|----------------------|
| Elements | Discrete semantic units |
| Prose paragraphs | Natural language claims |
| Inline elements | Annotated concepts |
| Attributes | Property assertions |

No sentence-boundary detection needed. No sliding windows. The author's intent about semantic boundaries is encoded in the structure itself.

### Size Comparison with Other Formats

Real-world conversions show UDON's size relative to other formats:

| Conversion | Typical Range | Notes |
|------------|---------------|-------|
| **XML → UDON** | 38-76% of original | Deep nesting saves most; no closing tags |
| **YAML → UDON** | 43-81% of original | Similar indentation; less quoting overhead |
| **JSON → UDON** | 79-83% of original | JSON already compact; saves braces/quotes |
| **Markdown → UDON** | 102-114% of original | Explicit elements cost slightly more |

**Detailed XML comparisons:**

| Document Type | XML | UDON | Savings |
|---------------|-----|------|---------|
| Deep nesting (minimal content) | 988B | 377B | **62%** |
| HTML-like structure | 1,387B | 890B | **36%** |
| Config-style | 501B | 344B | **32%** |
| Twitter feed | 16,717B | 12,846B | **24%** |
| Attribute-heavy (long text values) | 7,418B | 7,277B | **2%** |

The pattern: **deeply nested structure sees 50-60% reduction**; typical documents see **20-40% reduction**; prose-heavy documents see minimal savings (the prose dominates).

**Why Markdown → UDON is slightly larger:** Markdown's shortcuts (`#`, `**`, `*`) are terser than explicit UDON elements (`|h1`, `|{strong}`, `|{em}`). But UDON offers what Markdown cannot: arbitrary element names, typed attributes, and structured data intermixed with prose—all in a single unified format.

### Parser Performance Comparison

Benchmarks parsing semantically equivalent documents (~50% structure, ~30% short text, ~20% prose):

| Format | Parser | s10 (MB/s) | s10 (El/s) | s50 (MB/s) | s50 (El/s) | s200 (MB/s) | s200 (El/s) | Size |
|--------|--------|------------|------------|------------|------------|-------------|-------------|------|
| UDON | libudon | 897 | 9.4M | 744 | 7.7M | 748 | 7.7M | 100% |
| XML | quick-xml | 935 | 7.6M | 983 | 7.9M | 1,003 | 8.0M | 129% |
| JSON | serde_json | 353 | 3.4M | 372 | 3.6M | 335 | 3.2M | 108% |
| Markdown | pulldown-cmark | 199 | 2.2M | 196 | 2.1M | 207 | 2.2M | 98% |
| TOML | toml | 54 | 0.5M | 56 | 0.5M | 55 | 0.5M | 122% |
| YAML | serde_yaml | 41 | 0.3M | 43 | 0.4M | 43 | 0.4M | 126% |

- **s10/s50/s200**: 10, 50, 200 item documents (22, 101, 401 elements)
- **MB/s**: Raw byte throughput
- **El/s**: Semantic elements parsed per second
- **Size**: Average document size relative to UDON

UDON achieves the highest elements/sec because it parses fewer bytes for the same semantic content.

## Documentation

| Document | Description |
|----------|-------------|
| [SPEC.md](SPEC.md) | Full specification (v0.7-draft) |
| [implementation-phase-2.md](implementation-phase-2.md) | Development roadmap for parser implementation |
| [analysis.md](analysis.md) | Design rationale, TST evaluation, and historical context |
| [examples/](examples/) | Comprehensive syntax examples |

## Implementation

The parser is implemented in Rust with language bindings:

| Repository | Description |
|------------|-------------|
| `~/src/libudon` | Rust core parser + C FFI |
| `~/src/udon-ruby` | Ruby gem with native extension |

See [implementation-phase-2.md](implementation-phase-2.md) for the complete roadmap including:
- Streaming parser with ring buffer
- Arena-allocated tree structure
- Lazy Ruby object projection
- World-class error messages

## Historical Repositories

The original work is preserved in reference repositories:

| Repository | Contents |
|------------|----------|
| `~/src/_ref/udon/` | Main specification, examples, Ruby parser |
| `~/src/_ref/udon-c/` | C implementation with high-performance state machine parser |

### Key Files in Historical Repos

| Purpose | Location |
|---------|----------|
| Best syntax examples | `~/src/_ref/udon/examples/overview.udon` |
| Original design decisions | `~/src/_ref/udon-c/docs/DECIDED.md` |
| C parser source | `~/src/_ref/udon-c/lib/udon.c` |
| Original objectives | `~/src/_ref/udon/doc/objectives.asciidoc` |
| State machine spec | `~/src/_ref/udon/ruby/udon/udon.statetable` |

## Published Artifacts

- **RubyGems:** `udon` gem, version 0.0.4 (namespace reserved)
- **License:** MIT

## Status

Active development. Phase 2 implementation in progress—see [implementation-phase-2.md](implementation-phase-2.md) for the complete roadmap.

Current state:
- SPEC.md complete (v0.7-draft)
- Rust parser bootstrap working (~30% of spec)
- Ruby gem compiles and runs tests
- Benchmarking infrastructure in place

Next: Complete parser implementation, streaming architecture, tree API.
