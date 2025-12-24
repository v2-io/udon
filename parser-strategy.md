# UDON Parser Strategy

## Overview

A Rust core parser with two build targets (C ABI shared library + WASM) to
maximize ecosystem coverage from a single codebase. Template evaluation (Liquid)
is deferred to host language implementations.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Rust Core Parser                         │
│                                                             │
│  Responsibilities:                                          │
│    - Structural parsing: |elements, :attrs, prose, |{...}  │
│    - Directive recognition: !name, !raw:name               │
│    - Streaming via ring buffer / pull-based batching       │
│                                                             │
│  Does NOT handle:                                           │
│    - Template evaluation (!if, !for, !{...})               │
│    - Dialect semantics (what !cqrs means)                  │
│    - Output rendering                                       │
└───────────────┬─────────────────────────┬───────────────────┘
                │                         │
         C ABI export                WASM build
           (cdylib)                 (wasm32-unknown)
                │                         │
    ┌───────────┴───────────┐    ┌───────┴────────┐
    │  Python, Ruby, C#,    │    │  Browser JS,   │
    │  Swift, Lua, Julia,   │    │  Deno, Node*,  │
    │  Node* (native addon) │    │  Edge runtimes │
    └───────────────────────┘    └────────────────┘

              * Node.js can use either path

    ┌─────────────────────────────────────────────┐
    │  Native ports (community/later):            │
    │  Go, Java, Elixir                           │
    └─────────────────────────────────────────────┘
```

---

## Directive System

The parser's only directive-level knowledge is body mode:

| Syntax | Body | Parser Behavior |
|--------|------|-----------------|
| `!foo` | UDON | Parse body recursively as UDON |
| `!raw:foo` | Raw | Capture body verbatim, tag with "foo" |

That's it. No dialect registry. No special cases in the parser.

### Examples

```udon
!if user.admin              ; UDON body — parser recurses
  |div Admin tools

!warning :severity high     ; UDON body — unknown directive, still parses
  Do |{em not} run in prod.

!raw:sql                    ; Raw body — captured verbatim
  SELECT * FROM users
  WHERE active = true

!raw:json {"status": "ok"}  ; Raw body — inline form
```

### Event Output

```rust
enum Event {
    DirectiveStart { name: String, is_raw: bool, attrs: Vec<Attr> },
    DirectiveEnd,
    // ... other structural events
}
```

For `!raw:sql`, the parser emits:
- `DirectiveStart { name: "sql", is_raw: true, ... }`
- `RawContent { text: "SELECT * FROM users\n..." }`
- `DirectiveEnd`

For `!warning`, the parser emits:
- `DirectiveStart { name: "warning", is_raw: false, ... }`
- Normal UDON events for the body
- `DirectiveEnd`

---

## Markdown in Prose

Unlike Liquid (deferred to host implementations), **Markdown parsing may belong
in the core parser**. Rationale:

- Markdown is ubiquitous and stable (CommonMark spec)
- UDON explicitly prefers Markdown over inline UDON for simple formatting
- Consistent Markdown handling across all host languages is valuable
- Inline UDON elements (`|{...}`) must interleave with Markdown—this is easier
  if one parser handles both

**Status:** Not yet decided. Options include:

1. Core parser handles Markdown (CommonMark) as part of prose parsing
2. Core parser emits prose as-is; host applies Markdown post-processing
3. Core parser recognizes Markdown structure but defers rendering to host

This needs further design work before implementation.

---

## Liquid / Template Layer

Liquid directives (`!if`, `!for`, `!let`, `!{...}`) are **not special to the
parser**. They're just directives with UDON bodies.

The **host language layer** intercepts these by name and routes them to its
native Liquid implementation:

| Host Language | Liquid Implementation |
|---------------|----------------------|
| Ruby | `liquid` gem (Shopify's original) |
| Python | `python-liquid` |
| JavaScript | LiquidJS |
| Go | `liquid` (osteele) — if native port exists |
| Elixir | Solid — if native port exists |
| C#/.NET | Fluid, DotLiquid |
| Java | Liqp — if native port exists |
| PHP | Liquid for PHP |

### Liquid Implementation Differences

Liquid implementations vary in feature completeness and edge-case behavior
(filters, whitespace handling, error modes, etc.). This is not yet specified
by UDON. If formal alignment becomes necessary, UDON will likely defer to
**Shopify's Liquid specification** as the reference standard, with host
implementations expected to be "close enough" for practical use.

### Processing Flow

```
Parser events
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                     Host Layer                              │
│                                                             │
│  Intercepts by directive name:                              │
│                                                             │
│    !if, !elif, !else, !for, !let, !{...}                   │
│      → Route to native Liquid                               │
│                                                             │
│    !raw:X                                                   │
│      → Pass raw content to consumer (syntax highlight,      │
│        execute, embed — host decides)                       │
│                                                             │
│    Everything else (!warning, !cqrs, !api, ...)            │
│      → Pass through as labeled UDON subtree                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
     │
     ▼
Consumer/Renderer
```

Custom directives that aren't Liquid and aren't `!raw:` just flow through as
**semantic markers** — labeled UDON subtrees that the final consumer interprets.

---

## Streaming Strategy

### For C ABI consumers (Python, Ruby, C#, Swift, etc.)

**Ring buffer in Rust-allocated memory:**

```
Host                         Rust Parser
  │                              │
  │── write input to buffer ────▶│
  │── call parse(len) ──────────▶│
  │                              │ (parses, writes events to ring buffer)
  │◀── (events_written, ─────────│
  │     bytes_consumed)          │
  │── read events via pointer ──▶│ [event buffer in Rust memory]
```

- Host writes input chunks to a buffer
- Parser processes, writes events to ring buffer
- Host reads events directly via pointer (zero-copy where possible)
- Minimal FFI boundary crossings

### For WASM consumers (Browser JS, Deno, Edge)

**Ring buffer in WASM linear memory:**

```
Host (JS)                    WASM Parser
  │                              │
  │── write to WASM memory ─────▶│ [input buffer]
  │── call parse(len) ──────────▶│
  │                              │ (parses, writes to event buffer)
  │◀── (events_written, ─────────│
  │     bytes_consumed)          │
  │── read via Memory view ─────▶│ [event buffer]
```

- Input and output buffers in WASM linear memory
- Host reads events via `WebAssembly.Memory` buffer views
- String data requires copy across JS/WASM boundary

### Rust API (internal)

```rust
pub struct Parser {
    // internal state, partial token buffer, etc.
}

impl Parser {
    pub fn new(options: Options) -> Self;

    /// Feed a chunk, get batch of events
    pub fn feed(&mut self, chunk: &[u8]) -> Vec<Event>;

    /// Flush remaining after final chunk
    pub fn finish(&mut self) -> Vec<Event>;
}

// For zero-copy native Rust usage
impl Parser {
    pub fn feed_iter<'a>(&'a mut self, chunk: &'a [u8]) -> impl Iterator<Item = Event<'a>>;
}
```

---

## Language Coverage

### Tier 1: C ABI shared library

High-performance FFI via direct memory access.

| Language | Binding Approach |
|----------|------------------|
| Python | PyO3 or cffi |
| Ruby | magnus, rutie, or FFI gem |
| C#/.NET | P/Invoke with Span<T> |
| Swift | Native C interop |
| Lua/LuaJIT | LuaJIT FFI |
| Julia | ccall |
| Node.js | N-API (optional, for perf-critical) |

### Tier 2: WASM

Portable, no native compilation required.

| Target | Notes |
|--------|-------|
| Browser JavaScript | Required — only option |
| Deno | Idiomatic |
| Node.js | Easier distribution than native addons |
| Cloudflare Workers | WASM only |
| Other edge runtimes | WASM typically required |

### Tier 3: Native ports

For ecosystems that strongly prefer pure implementations.

| Language | Reason | Priority |
|----------|--------|----------|
| Go | cgo friction, "pure Go" culture | When demand exists |
| Java | JNI/Panama friction | When demand exists |
| Elixir | NIFs block scheduler | When demand exists |

Native ports would implement the same spec, potentially with different
performance characteristics.

---

## Build Artifacts

From the Rust codebase:

```
cargo build --release
  → target/release/libudon.{so,dylib,dll}     # C ABI shared library

cargo build --release --target wasm32-unknown-unknown
  → target/wasm32-unknown-unknown/release/udon.wasm

wasm-bindgen / wasm-pack (for JS ergonomics)
  → pkg/udon.js, pkg/udon_bg.wasm
```

---

## Summary

1. **Parser is simple**: Knows UDON structure + `!raw:` = raw body. That's all.
2. **Liquid is host-native**: Each language uses its own Liquid implementation.
3. **Custom directives pass through**: Semantic markers for consumers to interpret.
4. **One Rust codebase, two targets**: cdylib + WASM covers ~80% of ecosystem.
5. **Native ports later**: Go, Java, Elixir when demand justifies.
