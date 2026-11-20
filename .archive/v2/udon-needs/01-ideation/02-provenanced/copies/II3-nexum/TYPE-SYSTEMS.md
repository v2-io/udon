---
source: nexum repo — research doc (gradual/static type-system comparison)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/research/TYPE-SYSTEMS.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [type-systems, schema-validation, tool-composition, gradual-typing]
why_included: >
  ~2025-11. Feature comparison of gradual/static type systems (Sorbet, RBS, Elixir set-theoretic, Gleam,
  Crystal, Nim), with the agent-relevant finding that separate-file types (RBS-style, like TS .d.ts) are
  "most tooling-natural for AI agents." Feeds the compositional-type / schema-guarded direction (Extension 4
  of the vision doc) and connects to UDON's schema work — the demand for typed contracts an agent can read
  without executing code.
---
  Type System Feature Comparison Matrix

| Feature                   | Ruby Sorbet                      | Ruby RBS                                             | Elixir (New Gradual)                        | Elixir (Dialyzer)          | Nim                  | Gleam                      | Crystal                    |
| ------------------------- | -------------------------------- | ---------------------------------------------------- | ------------------------------------------- | -------------------------- | -------------------- | -------------------------- | -------------------------- |
| Annotation Location       | Inline (primary) + separate .rbi | Separate .rbs files (+ experimental inline comments) | Inline                                      | Inline (@spec)             | Inline               | Inline (optional)          | Inline (optional)          |
| Typing Philosophy         | Gradual (optional)               | Gradual (optional)                                   | Gradual with set-theoretic types            | Success typing (find bugs) | Static (required)    | Static (complete)          | Static (complete)          |
| Type Inference            | Local only                       | Local (with Steep)                                   | Complete/Global (v1.20 goal)                | Limited (via analysis)     | Local                | Complete (Hindley-Milner)  | Global                     |
| Annotations Required?     | Yes (for coverage)               | Yes (explicit)                                       | No (optional)                               | Optional                   | Yes (mostly)         | No (optional)              | Minimal (optional)         |
| Runtime Behavior          | Optional runtime checks          | Erased (no runtime)                                  | Safe erasure (no runtime)                   | Erased (no runtime)        | Erased               | Erased                     | Erased                     |
| Type System Basis         | Structural + nominal             | Structural + nominal                                 | Set-theoretic (union / intersection / negation) | Set-based (union types)    | Nominal + structural | Hindley-Milner + row types | Union types + nominal      |
| Checking Time             | Compile + runtime (opt)          | Compile                                              | Compile                                     | Post-compile analysis      | Compile              | Compile                    | Compile                    |
| Interop with Dynamic Code | Excellent (Ruby)                 | Excellent (Ruby)                                     | Excellent (BEAM)                            | Excellent (BEAM)           | N/A (static only)    | Good (BEAM FFI)            | Limited (Ruby-like syntax) |
| Metaprogramming Support   | Limited (conflicts)              | Limited (conflicts)                                  | Good (macro-aware)                          | Limited                    | Extensive (macros)   | None (by design)           | Good (macros)              |
| Tooling Integration       | Mature (LSP, IDE)                | Growing (RubyMine, VSCode)                           | Upcoming                                    | Mature (Dialyxir)          | Good                 | Excellent (LSP)            | Good                       |
| Null Safety               | Manual (T.nilable)               | Manual (Type?)                                       | Built-in (pattern matching)                 | Via typespecs              | Via Option types     | Built-in (no null)         | Via Nil union              |

Similarity Analysis

Most Similar to Elixir's Upcoming Gradual Typing:

Winner: Crystal's Global Inference

Reasoning:
- Both have complete/global type inference without requiring annotations
- Both support gradual adoption (types are optional but inferred globally)
- Both target similar "write less, get more safety" philosophy
- Key difference: Elixir uses set-theoretic types (union/intersection/negation) while Crystal uses simpler union types

Close second: Gleam (Hindley-Milner complete inference, but 100% static rather than gradual)

Most Similar to Current Elixir Dialyzer/Typespecs:

Winner: Ruby RBS (separate files)

Reasoning:
- Both use separate type definition locations (though Elixir's are inline)
- Both are optional and don't affect runtime
- Both used primarily for tooling and analysis
- Both maintained by core language teams
- Key difference: RBS types are separate files; Elixir typespecs are inline decorators

However: In terms of usage pattern, Elixir typespecs are inline like Sorbet, making Sorbet similar in developer experience even though philosophically RBS is closer.

Most Similar to Nim's Type System:

Winner: Crystal

Reasoning:
- Both compile to native code with no runtime overhead
- Both emphasize clean syntax with powerful static typing
- Both use inline optional annotations with strong inference
- Both support similar metaprogramming capabilities
- Key difference: Crystal has more powerful global inference; Nim requires more explicit annotations

Close second: Gleam (similar inference, but more functional/ML-style)

Most Similar to Gleam's Type System:

Winner: Elixir's New Gradual Typing

Reasoning:
- Both target the BEAM/Erlang VM ecosystem
- Both support complete type inference without required annotations
- Both designed for functional programming patterns
- Both support pattern matching with type refinement
- Key difference: Gleam is 100% static (Hindley-Milner); Elixir is gradual (set-theoretic)

Close second: Crystal (similar complete inference, but imperative rather than functional)

Most Similar to Crystal's Type System:

Winner: Nim

Reasoning:
- Both are compiled languages targeting native performance
- Both support inline annotations with inference
- Both have similar imperative/OOP syntax style
- Both support powerful macro systems
- Key difference: Crystal has superior global inference; Nim requires more annotations

Close second: Elixir's new gradual typing (similar global inference philosophy)

Key Insights for Your Question

1. For AI Agents: RBS's separate files would likely be most natural for tooling, similar to TypeScript's .d.ts files or Crystal's approach
2. For Developer Experience: Crystal and Gleam show that complete inference with optional annotations is the sweet spot (matches Elixir's vision)
3. Gradual vs Complete: Elixir and Ruby choose gradual (mix typed/untyped); Gleam/Crystal/Nim choose complete coverage
4. Inference Power Spectrum:
  - Weakest: Sorbet, RBS (local only, explicit required)
  - Medium: Nim (local with good inference)
  - Strongest: Gleam (Hindley-Milner), Crystal (global), Elixir's new system (set-theoretic)