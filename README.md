# UDON

**Universal Document & Object Notation**

UDON is what you get when "Markdown with YAML frontmatter" grows up—structure and prose interleaved freely, at any depth, without the seams, crystal clear even without syntax highlighting, for humans and AI alike.

```
|article[intro].featured
  :author Joseph Wecker
  :date 2025-12-22  ; bare date is a string; temporal is moving to a <…> dialect
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
| **Cardinality** | Usually one per key; same-key assignments **stack** (all values kept, in order) — schemas constrain cardinality | Can repeat (sequence semantics) |
| **Order** | Assignment order preserved; rarely semantic | Matters |

```udon
; Attributes: typed scalars (same-key assignments stack; schemas may constrain)
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
| [REVIEW-JULY-2026.md](REVIEW-JULY-2026.md) | The estate review: verified state, defects, open decisions |
| [REBOOT-PLAN.md](REBOOT-PLAN.md) | Prioritized plan: phases, backlog, spikes |
| [spec/CORE.md](spec/CORE.md) | Full specification (0.9.0-alpha.1 in progress; 0.8.0 tagged `core-v0.8.0`) |
| [design/](design/) | Ahead-of-spec design layer (AST, paths, agentic tools, schema) |
| [notes/analysis.md](notes/analysis.md) | Design rationale and historical context |
| [examples/](examples/) | Comprehensive syntax examples |

## Implementation

This repo became the umbrella on 2026-07-09 (see REBOOT-PLAN.md Phase R):

| Location | Description |
|----------|-------------|
| [core/](core/) | Rust workspace: `udon-core` parser + arena tree + fixtures (absorbed from the archived v2-io/libudon, full history) |
| [tools/descent](tools/descent) | Parser-generator submodule (independent repo + gem) |
| [_archive/udon-ruby](_archive/) | Frozen Ruby binding (archived; submodule, not auto-initialized) |

```bash
cd core && cargo test --workspace     # build + test the reference parser
```

Rust consumers: `udon-core = { git = "https://github.com/v2-io/udon" }`
(crates.io publication pending — see REBOOT-PLAN.md R8).

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

**Rebooted July 2026** — see [REVIEW-JULY-2026.md](REVIEW-JULY-2026.md)
(the audit) and [REBOOT-PLAN.md](REBOOT-PLAN.md) (the plan).

Current state (2026-07-15):
- **CORE 0.8.0 released — first version with a compliant parser.** The
  rebooted spec (escape unification, `<…>` typing, numbers/`0d`, identity
  `key`/`traits`, `@`-inert, warning codes, references as selector tuples)
  froze and `udon-core` passed its full compliance-fixture group in the same
  cycle. Tag: `core-v0.8.0`; frozen group: `core/fixtures/v0.8/`. Canonical
  current version: `spec/CORE-VERSION`.
- **CORE `0.9.0-alpha.1` underway — the attribute-model reconception**, the
  one area 0.8.0 explicitly left unsettled. Plain attrs always take a value;
  flags are `:key?`; values may be nodes / text blobs / segment arrays;
  uniform scan replaces block run-to-EOL. Carriers:
  `design/attribute-model-proposal-3-substrate.md` (decided floor) +
  `design/attribute-model-proposal-3.md`; nail-downs in
  `spec/TODO-SPEC-CORE-0.9-supplement.md`. Active fixture group:
  `core/fixtures/v0.9/` (seeded from v0.8; edited as CORE text lands). Gate:
  `cd core && cargo test -p udon-core --test canonical compliance_gate` —
  RED during the burn-down is the honest signal.
- **The old world is set aside.** Pre-0.8 fixtures → `core/fixtures/legacy-pre-0.8/`
  (frozen, mining source); pre-0.8 grammar →
  `core/generator/udon-legacy-pre-0.8.descent.udon` + git tag `grammar-v0.7`.
- First consumers: agentic-systems (ASF process maps) and vivarium.

Next: write the 0.9 attribute-model spec text (TODO-SPEC-CORE + the 0.9
supplement), update the v0.9 fixtures from it, then burn the grammar down to
green and tag `core-v0.9.0`.

## How the work is organized

Work is layered, and changes propagate **spec → event-parser → AST /
streaming-AST → aux · utils · human-ux · agent-ux → publishing**. Load-bearing
rule: **you can't work a layer without the one above it in hand** — no parser
work without the whole spec; no utils without a compliant parser.

**Compliance is measured, not tracked.** `spec/CORE.md` is semver'd (canonical
version in [`spec/CORE-VERSION`](spec/CORE-VERSION)); each version has a frozen
**compliance-fixture group**, and an implementation is "compliant with core-vX"
iff it passes that group. Maturity ladder: `-alpha` (evolving) → `-beta`
(feature-complete) → `-rc` (frozen, validating) → `X.Y.Z` (a parser passes; tag
`core-vX.Y.Z`). Every component versions **independently** with a prefixed tag
(`core-v…`, `udon-core-v…`, `temporal-v…`) and declares which upstream it obeys
as a range — so `core-v…` never implies the whole stack.

Each area keeps a **co-located** `TODO-*.md` holding only **open** items (closed
→ git, no "done" section). Items needing Joseph are marked `*(discuss w/ Joseph)*`
inline, not in a separate valve.

| Area (→ TODO) | Covers | Complies now | Core target |
|---|---|---|---|
| **META** (`TODO-META.md`) | tracking system; compliance-versioning keystone | — | — |
| **SPEC-CORE** (`spec/TODO-SPEC-CORE.md`) | the core spec `CORE.md` | *is the contract* | **`0.9.0-alpha.1`** |
| **SPEC-OTHER** (`spec/TODO-SPEC-OTHER.md`) | dialects, markdown, temporal, composite | — none yet | `core ^0.9` |
| **AUX** (`spec/TODO-AUX.md`) | schema, paths, patch | — none yet | `core ^0.9` |
| **CORE-PARSING** (`core/TODO-CORE-PARSING.md`) | event parser + descent grammar | **`core-v0.8.0`** | `core ^0.9` |
| **PARSER** (`core/TODO-PARSER.md`) | AST one-shot + streaming-AST | — none yet | `core ^0.9` |
| **HUMAN-UX** (`editors/TODO-HUMAN-UX.md`) | Obsidian, syntax highlighting | pre-0.8 (old spec) | `core ^0.9` |
| **UTILS** (`TODO-UTILS.md`) | `udon-utl` — accessors, conversion, `fmt` | — none yet | parser → `core ^0.9` |
| **AGENT-UX** (`TODO-AGENT-UX.md`) | cheat-sheets, empirical harness | pre-0.8 (old models+spec) | `core ^0.9` |
| **PUBLISHING** (`TODO-PUBLISHING.md`) | README, release, crates.io | — | — |

`spec/CORE-VERSION` and the SPEC-CORE target above move together; a
`core-v…` tag marks each *released* version (latest: `core-v0.8.0`), so the
tag trails the version file while an alpha is in progress. Migration in progress: the `design/` notes,
`REVIEW-JULY-2026.md` §4/§7-F, and the `REBOOT-PLAN.md` backlog are still
draining into these lanes (see the `TODO-META.md` bootstrap task; delete a
source when empty — `core/PLAN.md` and the retired `JOSEPH-TODO` are already
drained and deleted). `REVIEW-JULY-2026.md` and `REBOOT-PLAN.md` remain the
historical *why* and phase plan.
