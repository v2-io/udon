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

  !raw:elixir
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
