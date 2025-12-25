# CLAUDE.md — Agent Guidelines for UDON

This document provides guidance for AI agents working on the UDON codebase.

## Project Overview

UDON (Universal Document & Object Notation) is a unified text notation for
documents, data, configuration, and templates. This repository contains:

- **SPEC.md** — The authoritative specification
- **crates/** — Rust parser implementation (in development)
- **lib/** — Ruby reference validator
- **examples/** — Test fixtures and demonstrations

## Critical Workflow Instruction

**WHEN YOU ENCOUNTER AMBIGUITY, STOP AND DISCUSS.**

Do NOT:
- Invent syntax rules that aren't in SPEC.md
- Assume the "obvious" interpretation is correct
- Silently make design decisions to unblock yourself
- Complete tasks by papering over unclear requirements

DO:
- Ask Joseph for clarification
- Note where SPEC.md is silent or contradictory
- Propose alternatives and discuss trade-offs
- Document decisions made in conversation

The specification is still evolving. Your job is not just to implement, but to
help discover where the spec needs refinement.

## Testing Philosophy

### TDD with Real Examples

Development is driven by test fixtures, not by reading the spec abstractly:

```
examples/
├── comprehensive.udon    # Kitchen sink of features
├── data/*.udon          # Data-focused examples
├── document/*.udon      # Document-focused examples
└── ...
```

For each grammar construct:
1. Find or create a .udon example that uses it
2. Write a test that parses it and asserts expected events
3. Implement until the test passes
4. Check for edge cases and add more tests

### Expected Events

Tests should specify the exact event stream expected:

```rust
#[test]
fn test_simple_element() {
    let events = parse(b"|div Hello");
    assert_events!(events, [
        ElementStart { name: Some(b"div"), .. },
        Text { content: b"Hello", .. },
        ElementEnd { .. },
    ]);
}
```

### Ground Truth

**SPEC.md is the authoritative specification.** The unit tests serve as executable
examples that Joseph can verify against the spec.

There is an archived Ruby validator in `_archive/` — it was an early rough sketch
and is NOT authoritative. Do not use it as reference for correct behavior.

## Error Handling

### Goals

UDON aims for **world-class error messages**:

- Clear description of what went wrong
- Exact source location (line, column, byte offset)
- Context showing the problematic text
- Suggestions for fixing common mistakes
- Recovery to continue parsing and find more errors

### Error vs Warning

- **Error**: Syntactically invalid, cannot produce correct AST
- **Warning**: Syntactically valid but suspicious (unused id, unusual nesting)

### Recovery Strategy

The parser should recover from errors when possible:

```
|div
  :attr with missing value   ; ERROR here
  |child                     ; should still parse this
```

After an error, find a recovery point (next line at lower indent) and continue.

## Performance Considerations

### Early Benchmarking

Use Criterion for benchmarks from the start:

```rust
// benches/parse.rs
fn bench_comprehensive(c: &mut Criterion) {
    let input = include_bytes!("../examples/comprehensive.udon");
    c.bench_function("comprehensive.udon", |b| {
        b.iter(|| Parser::new(input).parse())
    });
}
```

Track these metrics:
- Throughput (MB/s)
- Memory allocations
- Event emission rate

### Patterns to Prefer

- Zero-copy: `&'a [u8]` slices into input buffer
- SWAR/SIMD for character scanning (via `memchr` crate)
- Minimize allocations in hot paths
- State machine with enum (not dynamic dispatch)

### Patterns to Avoid

- String copying for every token
- Hash lookups in inner loops
- Heap allocation per event

## Architecture Notes

### Current State (Bootstrap)

```
.machine DSL → genmachine-rs → parser.rs → cargo build
```

The generator approach allows grammar tuning without hand-editing parser code.

### Target State

```
                    ┌─────────────────┐
                    │   Rust Parser   │
                    │ (udon-core)     │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────▼────┐   ┌─────▼─────┐   ┌────▼────┐
         │ cdylib  │   │   WASM    │   │  Tests  │
         │ (FFI)   │   │           │   │         │
         └────┬────┘   └─────┬─────┘   └─────────┘
              │              │
         Ruby, Python   Browser, Deno
         Swift, etc.    Edge runtimes
```

### Open Questions

These are explicitly undecided and require discussion:

1. **Markdown in prose** — Should core parser handle CommonMark, or defer to host?
2. **Inline control flow** — Syntax for inline `!if{cond}{then}{else}` under investigation
3. **Streaming API** — Ring buffer design for FFI not yet implemented

## File Organization

```
crates/
├── udon-core/           # Core parser (no_std compatible)
│   ├── src/
│   │   ├── lib.rs
│   │   ├── event.rs     # Event enum (hand-written, stable)
│   │   ├── span.rs      # Location types (hand-written)
│   │   ├── value.rs     # Attribute values (hand-written)
│   │   └── parser.rs    # Generated from .machine
│   └── Cargo.toml
├── udon-ffi/            # C ABI exports (TODO)
├── udon-wasm/           # WASM bindings (TODO)
└── generator/
    ├── genmachine-rs    # Generator script (Ruby)
    ├── bootstrap.machine # Minimal grammar for testing
    ├── udon.machine     # Full grammar (TODO)
    └── templates/
        └── parser.rs.liquid
```

## Commit Practices

- Commit working states, not work-in-progress
- Include test files with the code that passes them
- Note any spec clarifications needed in commit message

## When Stuck

1. Re-read SPEC.md section for the construct in question
2. Check examples/ for existing usage patterns
3. **Ask Joseph** — ambiguity is valuable information, not a blocker

Do NOT use the archived Ruby validator as reference — it predates the current spec.
