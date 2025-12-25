# CLAUDE.md - Agent Guidelines for UDON Specification

This is the UDON specification repository. The parser implementation lives in
separate repos:

- **libudon** (`~/src/libudon`): Rust parser core + C FFI
- **udon-ruby** (`~/src/udon-ruby`): Ruby gem with native extension

This repo contains:
- **SPEC.md** - The authoritative specification
- **examples/** - Test fixtures and demonstrations
- **test/** - Benchmarks comparing UDON to YAML/XML
- **lib/** - Thin wrapper that loads the udon gem

## Critical Workflow Instruction

**WHEN YOU ENCOUNTER AMBIGUITY, STOP AND DISCUSS.**

Do NOT:
- Invent syntax rules that aren't in SPEC.md
- Assume the "obvious" interpretation is correct
- Silently make design decisions to unblock yourself

DO:
- Ask Joseph for clarification
- Note where SPEC.md is silent or contradictory
- Propose alternatives and discuss trade-offs
- Document decisions made in conversation

The specification is still evolving. Your job is not just to implement, but to
help discover where the spec needs refinement.

## Repository Structure

```
udon/
├── SPEC.md              # Authoritative specification
├── README.md            # Overview and examples
├── examples/            # Test fixtures
│   ├── comprehensive.udon
│   ├── data/
│   └── document/
├── test/                # Benchmarks
│   └── benchmark.rb
├── lib/
│   └── udon.rb          # Wrapper that loads udon gem
├── parser-strategy.md   # Architecture notes
└── _archive/            # Old Ruby validator (not authoritative)
```

## Related Repositories

### libudon (~src/libudon)

Core Rust parser and C FFI:
- `udon-core`: Zero-copy streaming parser (~1.3 GiB/s)
- `udon-ffi`: C ABI bindings (cdylib)
- `generator`: Code generator from .machine DSL

### udon-ruby (~src/udon-ruby)

Ruby gem with native Rust extension:
- Uses rb_sys + magnus for native Ruby bindings
- Creates Ruby objects directly (no JSON serialization)
- 8 passing tests

## Running Benchmarks

```bash
# First, ensure udon-ruby is compiled
cd ~/src/udon-ruby && bundle exec rake compile

# Then run benchmarks
cd ~/src/udon && ruby test/benchmark.rb
```

## Ground Truth

**SPEC.md is the authoritative specification.** The archived Ruby validator
in `_archive/` is NOT authoritative - it predates the current spec.

## When Stuck

1. Re-read SPEC.md section for the construct in question
2. Check examples/ for existing usage patterns
3. **Ask Joseph** - ambiguity is valuable information, not a blocker
