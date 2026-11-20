---
source: sar (archived "AI-FIRST" BEAM language project) — docs/error-messages-plan.md
gathered: 2026-07-21
status: gathered — partial excerpt (source is ~355 lines / 11KB). The sar/Nim/Elixir-specific
  implementation plumbing (custom Nim pragma handlers, .exs source-map generation, phased
  build plan) is elided; the transferable DX *principle* and the "great error messages"
  exemplars are kept.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar/docs/error-messages-plan.md
source_commit: 3840e23
categories: [tier1-ideology, error-messages, developer-experience, errors-that-teach,
  compile-time-over-runtime, domain-vocabulary]
why_included: >
  2025-11-10, tagged "Priority: HIGH (User Request)". The demand signal is narrow but clean:
  errors should speak the *user's domain concepts*, not the underlying tool's — a compiler
  built on Nim that emits Nim terminology to a Sar/Elixir developer is failing them. Errors
  as a first-class concern (detect at compile time not runtime; link error → docs; suggest the
  fix). Relevant to the "errors should teach" thread in UDON agent UX and to any harness tool
  whose failures an agent has to act on. The Elm/Rust exemplars name the bar.
---

> **Editorial.** The reusable content is the DX *principle* and its exemplars; the sar-specific
> implementation plan (Nim pragmas, `validateAst()`, `.exs` source maps) is project plumbing,
> elided.

---

# Error Messages Improvement Plan (DX principle + exemplars)

**Date:** 2025-11-10 · **Goal:** Improve developer experience through better error messages at all stages

## The core problem (verbatim, condensed)

- **Error messages reference the underlying tool's concepts, not the user's.** e.g. Nim's
  "expression 'foo' has no type (or is ambiguous)" — *could say* "Elixir function needs return
  type annotation." The compiler is built on Nim but the developer writes Sar/Elixir; leaking
  Nim vocabulary is a failure of fit.
- **Cryptic FFI / keyword-conflict errors** give generic "identifier expected" with no hint.
- **Silent backend failures** emit `# unsupported: nkWhileStmt` + `nil` instead of a
  compile-time error that explains *why* and suggests the idiomatic alternative.
- **No source maps:** runtime errors reference generated `.exs` lines and mangled names
  (`__sar_main__`), not the original source — the developer can't trace back.

## The bar — what a good error does (verbatim shape)

```
/path/to/file.sar(23, 5) Error: 'cast' is a reserved Nim keyword
  Hint: Use backticks to escape: `cast`
  Hint: This is needed for Elixir atoms that conflict with Nim keywords
  See: https://docs.sar-lang.org/atoms-and-keywords
```
```
Backend Error: While loops are not supported in Sar
  Reason: Elixir uses immutable data and recursion instead of loops
  Suggestion: Use recursion or Enum.reduce/Enum.each instead
  Example: [ recursion pattern shown ]
```

A good error carries: **location · what's wrong in the user's vocabulary · why · a concrete
suggested fix · a docs link.** Detect at compile time what would otherwise be a confusing
runtime failure; report *all* issues at once, not just the first.

## Exemplars named as the standard (verbatim)

**Elm:**
```
-- TYPE MISMATCH ---------------------------------------------- Main.elm
The 2nd argument to `map` is not what I expect:
18|     List.map String.length [1, 2, 3]
                               ^^^^^^^^^
This `map` call produces: List Int   But I need it to be: List String
Hint: Only strings work with String.length. Try using String.fromInt … first!
```

**Rust:**
```
error[E0382]: use of moved value: `s`
 = help: consider using `&s` to borrow instead of moving
```

> "We should aim for this level of clarity and helpfulness!"

## Success metric (the DX demand, measurable)

- Time to resolve common errors: reduce by 50%
- Number of "how do I fix this error" questions: reduce by 70%

## Open questions (still-live design tensions, verbatim)

1. How much should we deviate from the underlying tool's error messages? (Too different →
   confusing for tool-native devs; too similar → unhelpful for the target context.)
2. Should we suppress underlying-tool warnings that don't apply?
3. How to handle errors in generated code — a wrapper that catches and translates, or just
   better docs?
4. What's the right balance between compile-time and runtime errors in a dynamically-typed target?
