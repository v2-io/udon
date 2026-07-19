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

UDON provides clearer guidance than the traditional "attributes for metadata" rule — ask **whose name is it?**

| Question | → `:attribute` | → `|child` |
|----------|----------------|------------|
| **Whose name?** | The **parent's** relationship-label (`my author`, `my timeout`) | The thing's **own** name (what it *is*) |
| **Cardinality** | Usually one per key; same-key assignments **stack** (all values kept, in order) — schemas constrain cardinality | Can repeat (sequence semantics) |
| **Order** | Assignment order preserved; rarely semantic | Matters |

Attributes are edges, elements are nodes — and as of core 0.9 an edge may terminate at a leaf value *or* at a node, so the old "structure must be a child" pressure is gone:

```udon
; Attributes: what things are TO the message (0.9 model: flags take ?)
|message :timestamp "2025-01-15" :role user :priority 3 :urgent?
  Can you help with my account?

; Attribute whose value IS a node (it's still "my author" — the parent's label)
|book :title "The Craft"
  :author
    |person :name "Jane Doe" :affiliation "Acme Corp"

; Children: what things ARE, in sequence
|chapter Introduction
|chapter The Middle Part
|chapter Conclusion
```

The test: if the label describes the *relationship to the parent*, it's an `:attribute` (scalar or node value); if the name describes the thing *itself* and position matters, it's a `|child`.

> **Note:** The example documents in `design/examples/` don't yet fully illustrate this distinction. Improvements pending.

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
| [spec/CORE.md](spec/CORE.md) | Full specification (0.9.0-alpha.2 in progress; 0.8.0 tagged `core-v0.8.0`) |
| [spec/msc/CHANGELOG.md](spec/msc/CHANGELOG.md) | Spec changelog + the 0.9 rulings ledger |
| [design/](design/) | Ahead-of-spec design layer (AST, paths, agentic tools, schema, positioning) — see its README |
| [design/examples/](design/examples/) | Comprehensive syntax examples |
| [CONSUMERS.md](CONSUMERS.md) | Live-usage registry: who parses UDON outside this repo |
| [_archive/](_archive/) | The record: estate review + reboot plan (drained 2026-07-16), integrated spikes, superseded analyses |

## Implementation

This repo became the umbrella on 2026-07-09 (record:
`_archive/REBOOT-PLAN.md` Phase R):

| Location | Description |
|----------|-------------|
| [core/](core/) | Rust workspace: `udon-core` parser + arena tree + fixtures (absorbed from the archived v2-io/libudon, full history); `udon-wasm` (event-driven highlighting + the autocolors engine) |
| [tools/descent](tools/descent) | Parser-generator submodule (independent repo; tracker `TODO-DESCENT.md` there) |
| [ux/](ux/) | Editor + agent UX: Obsidian plugin, autocolors, tree-sitter spike, vim, TextMate |
| [_archive/udon-ruby](_archive/) | Frozen Ruby binding (archived; submodule, not auto-initialized) |

```bash
cd core && cargo test --workspace     # build + test the reference parser
```

Rust consumers: `udon-core = { git = "https://github.com/v2-io/udon" }`
(crates.io publication pending — `TODO-PUBLISHING.md`).

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

**Rebooted July 2026**; the estate review that seeded it and the reboot plan
are archived — fully drained into the per-area TODO lanes on 2026-07-16 —
at [_archive/REVIEW-JULY-2026.md](_archive/REVIEW-JULY-2026.md) and
[_archive/REBOOT-PLAN.md](_archive/REBOOT-PLAN.md).

**Active work (2026-07-18) — CORE `0.9.0-alpha.2`, the EOF recast.** The biggest
change since alpha.1: end-of-input and its edges were reconceived as **positional
vs delimited** constructs with **two-level severity** (each per-construct
`Unclosed*` = a *Warning*, content kept; the document-level "incomplete input" is
a separate *result*, not a wire event). CORE's "End of input" / "Anomaly posture"
/ "Line-boundedness" / "Emission order" sections are rewritten; the design of
record is [`_archive/TODO-EOF-refactor.md`](_archive/TODO-EOF-refactor.md)
(archived 2026-07-19 — realized; CORE is normative) and **the full
ruling ledger is [`spec/msc/CHANGELOG.md`](spec/msc/CHANGELOG.md) (0.9.0-alpha.2
"Ruled")** — every EOF decision is there (line-boundedness = multi-line
deliberately undefined; emission order content→warning→End; `$partial-key` for
unclosed keys; inline `!{…}` codes; empty/whitespace brackets; root-`:x`
undefined; EOF≡eol edges; …). Warning-code **spellings are provisional** pending
descent's auto-derivation (see the CHANGELOG guardrail) — do not cement them.

**Update (2026-07-18) — the EOF *generation* landed (out of the fixtures-first
order, by explicit call).** descent now auto-supplies both EOF halves — delimited
**force-unwind** (keep content + `Warning(Unclosed<Construct>)` + End, from a
positional/delimited classification it computes) and positional **EOF ≡ newline**
(a state reuses its own `\n`/`default` arm) — so the grammar stops hand-writing
`|eof` arms (~90 → ~56). This **fixed** the embed any-phase-drop, the number-state
silent-drops, and the bare-marker-at-EOF drops; **normalized** `UnterminatedFreeform`
→ `UnclosedFreeform`; and the compliance gate improved 2 → 1. Design record:
[`_archive/eof-descent-classification.md`](_archive/eof-descent-classification.md)
(archived 2026-07-19);
shipped in [`tools/descent/CHANGELOG.md`](tools/descent/CHANGELOG.md); residuals in
[`core/TODO-CORE-PARSING.md`](core/TODO-CORE-PARSING.md) +
[`tools/descent/TODO-DESCENT.md`](tools/descent/TODO-DESCENT.md) (the `|unclosed`
directive; inline-raw/-directive content-keeping + codes). Both parser backends
are at parity (recursive + pushdown, `pushdown_differential` green). The
alpha.2 **fixture finalization** now reconciles against this new behavior +
vocabulary rather than the pre-spike output.

*Where it stands, and what's next (READ THIS if you're picking up the work):*
**The compliance gate is fully GREEN and CORE is finalized for the recast.** A
later 2026-07-18 pass — Joseph reopened grammar/descent/spec, sequencing at the
executor's discretion — resolved the harvest's headline reds *in the grammar*
and closed the CORE gaps:
- descent gained a **`|unclosed <Name>`** directive; **inline `!{…}` directive /
  `!{:kind:…}` raw** at EOF now keep their content and derive
  `UnclosedInlineDirective` / `UnclosedInlineRaw` (was: dropped body / wrong
  code). The **sameline `!` guard** was completed (`|el :go? !:sh:` opens a child
  raw block) — the last standing gate red.
- **CORE finalized**: the array line-boundedness §66/§76 contradiction resolved,
  the `UnclosedInline*` registry rows added, `$partial-key` documented,
  references / interpolations blessed as array items, provisional-names note
  corrected (codes now derive from the grammar).

The exhaustive **fixture harvest** (104 draft cases) was triaged and
**densified 2026-07-19**: the 86 green/probe cases were promoted from
`core/fixtures/_wip/` into three new `v0.9/` files (`eof_delimited.yaml`,
`eof_positional_bare.yaml`, `eof_composition.yaml`); backend parity was verified
first-hand (recursive vs pushdown agree on every case) and the harness's
variation-skip was generalized from an id-substring proxy to the semantic
`Unclosed*`-in-expected-events signal. The `<…>` envelope's content-first
emission order **landed** (commit `e377585`; extracted into its own multi-line
`/envelope` delimited function, classifier MIXED=0). A **non-gating exploratory
sandbox** for undefined multi-line behavior is in `core/fixtures/exploratory/`
(run: `cargo test -p udon-core --test exploratory -- --ignored --nocapture`).
The three "ruling-needed" cases were ruled and promoted, and the named
inline-directive EOF gap (`!{inc`<EOF>) was **fixed** (both backends).
**What remains** — 14 genuine reds kept in `_wip/` as the grammar-phase target
spec (banner in [`FINDINGS.md`](core/fixtures/_wip/FINDINGS.md)): the
**identity/reference-key EOF** warning (`UnclosedIdentityKey` + `$partial-key`,
the shared `parse_element_identity` gap-2 — `|el[k`<EOF> emits `$key` with no
warning today, `core/TODO-CORE-PARSING.md`); the *nameless* `!{`<EOF> (ruled to
prose `Text "!{"`); interp partial-closer (gap-4); and `;{`-in-blob.

Current state (2026-07-16):
- **CORE 0.8.0 released — first version with a compliant parser.** The
  rebooted spec (escape unification, `<…>` typing, numbers/`0d`, identity
  `key`/`traits`, `@`-inert, warning codes, references as selector tuples)
  froze and `udon-core` passed its full compliance-fixture group in the same
  cycle. Tag: `core-v0.8.0`; frozen group: `core/fixtures/v0.8/`. Canonical
  current version: `spec/CORE-VERSION`.
- **CORE `0.9.0-alpha.1` — the attribute-model reconception — is written,
  ratified, and IMPLEMENTED** (2026-07-16): plain attrs always take a value;
  flags are `:key?`; values may be nodes / text blobs / stacked segments;
  uniform scan replaces block run-to-EOL; flat stacking wire (every `Attr`
  carries one value; multiplicity = re-emitted `Attr`). The v0.9 fixture
  group encodes the model and the parser passes it — gate GREEN
  (`cd core && cargo test -p udon-core --test canonical compliance_gate`).
  Rulings ledger: `spec/msc/CHANGELOG.md` (0.9.0-alpha.1 "Ruled"). Remaining before
  a `core-v0.9.0` tag: fixture densification (EOF/Unclosed* cases, legacy
  mining, edge combinations) and the residual editorial opens.
- **The old world is set aside.** Pre-0.8 fixtures → `core/fixtures/legacy-pre-0.8/`
  (frozen, mining source); pre-0.8 grammar →
  `core/generator/udon-legacy-pre-0.8.descent.udon` + git tag `grammar-v0.7`.
- **Live consumers are clean under 0.9** — a differential re-scan
  (2026-07-16, both parsers, event streams diffed) found zero
  errors/warnings across all six external documents; see `CONSUMERS.md`.

Next: **fixture densification** now that the spec is settled — promote the
already-green `_wip` cases into `v0.9/` (coverage) and broaden edge/combination
coverage; the identity/reference-key EOF warning is the one remaining grammar
residual; then the `core-v0.9.0` tag. (The alpha.2 EOF recast + the 2026-07-18
grammar pass + the envelope extraction delivered the EOF work the 2026-07-16
note called for; the gate is green.)

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
| **SPEC-CORE** (`spec/TODO-SPEC-CORE.md`) | the core spec `CORE.md` | *is the contract* | **`0.9.0-alpha.2`** |
| **SPEC-OTHER** (`spec/TODO-SPEC-OTHER.md`) | dialects, markdown, temporal, composite | — none yet | `core ^0.9` |
| **AUX** (`spec/TODO-AUX.md`) | schema, paths, patch | — none yet | `core ^0.9` |
| **CORE-PARSING** (`core/TODO-CORE-PARSING.md`) | event parser + descent grammar | **`core-v0.8.0`** | `core ^0.9` |
| **PARSER** (`core/TODO-PARSER.md`) | AST one-shot + streaming-AST | — none yet | `core ^0.9` |
| **HUMAN-UX** (`ux/TODO-HUMAN-UX.md`) | Obsidian, syntax highlighting | pre-0.8 (old spec) | `core ^0.9` |
| **UTILS** (`TODO-UTILS.md`) | `udon-utl` — accessors, conversion, `fmt` | — none yet | parser → `core ^0.9` |
| **AGENT-UX** (`ux/TODO-AGENT-UX.md`) | cheat-sheets, empirical harness | pre-0.8 (old models+spec) | `core ^0.9` |
| **PUBLISHING** (`TODO-PUBLISHING.md`) | README, release, crates.io | — | — |

`spec/CORE-VERSION` and the SPEC-CORE target above move together; a
`core-v…` tag marks each *released* version (latest: `core-v0.8.0`), so the
tag trails the version file while an alpha is in progress. The legacy-tracking
migration **completed 2026-07-16**: the estate review, reboot plan, 0.9
supplement, `notes/`, and the Dec-2025 brainstorms are all drained into these
lanes and archived (`_archive/` keeps the record; the drain rule for future
`design/`-note pulls lives in `design/README.md`).
