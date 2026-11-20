---
source: ~/src/_ref/_arch/sar2/experiment/README-GAME-ENGINE.md — the comprehension-experiment design that tested whether notation alignment measurably helps agents read code
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/README-GAME-ENGINE.md
source_commit: (non-git) source_mtime 2025-11-13
categories: [agent-comprehension, eval-methodology, notation-design, alignment-cognitive-load, empirical-demand-evidence, tier2-shipped-practice]
why_included: >
  Witness: a designed, model-run experiment asking "does syntax affect an agent's
  comprehension of a complex multi-module codebase?" — 857-line game engine in
  three variants (Elixir / SAR / aligned-SAR, the aligned version 49% shorter),
  20 questions incl. 2 planted bugs, measuring re-read (tool-call) behavior, turn
  count, accuracy, speed. Carries the ONLY concrete comprehension claim in the
  neighborhood: the prior genserver run's "aligned SAR = 100% immediate
  comprehension (no tool re-reads) vs 60% for Elixir/SAR; ~14% faster." READ
  ALONGSIDE the actual measured latency data (sar2-experiment-latency-data.md),
  which does NOT cleanly reproduce the speed claim across models — the claim here
  is a hypothesis + one prior result, not this experiment's verdict. For the
  harness consumer: a reusable template for empirically testing whether a
  notation/representation change helps the model, including the re-read-count
  metric as a comprehension proxy.
---

# Game Engine Comprehension Experiment

Tests whether syntax affects comprehension of complex, multi-module codebases.

## The Code

**857-line turn-based game engine** with:
- 6 modules (Logger, Data, StateHelpers, EffectHandlers, EventHandlers, Processor, Engine)
- Complex pattern matching & guards
- Recursive helpers (no lambdas)
- Multi-clause dispatch
- Event-driven architecture
- Status effect system
- Turn processing pipeline

## Test Files

- `game-engine.exs` - Original Elixir (856 lines)
- `game-engine.sar` - SAR syntax (761 lines)
- `game-engine-aligned.sar` - Aligned SAR (**436 lines!**)

The aligned version is 49% shorter while being more readable!

## Questions

20 comprehensive questions testing:
- **Architecture** - Execution paths, data flow, turn pipeline
- **Pattern Matching** - Multi-clause dispatch, guards, edge cases
- **Recursion** - Understanding recursive helpers
- **State Management** - Immutable updates, clamping, death handling
- **Complex Interactions** - Skill mechanics, effect application, multi-step flows
- **Data Structures** - Design decisions, performance implications
- **Bug Finding** - There are 2 intentional typos!
- **Integration** - Calculations, adding features, modifications

## Running the Experiment

```bash
cd experiment

# Quick test (3 runs per file = 9 total)
RUNS=3 ./run-game-engine.rb

# Full test (10 runs per file = 30 total)
./run-game-engine.rb

# Big test for statistical power
RUNS=20 ./run-game-engine.rb
```

## Expected Insights

With the complex game engine:
1. **Tool usage** - Will agents need to re-read the aligned version less?
2. **Turn count** - Can they answer from the prompt alone?
3. **Accuracy** - Do they catch the bugs? Calculate correctly?
4. **Speed** - Does alignment help with 800+ line files?

The genserver experiment showed:
- **Aligned SAR: 100% immediate comprehension** (no tool re-reads)
- **Elixir/SAR: 60% immediate** (40% tried to re-read file)
- **Time savings: ~14% faster** for aligned version

With 3x more code, these differences should be even more pronounced!

## Analysis

```bash
# View results
./analyze_turns.rb results_game_<timestamp>/
./analyze.rb results_game_<timestamp>/

# Check specific responses
cat results_game_*/elixir_run1.json | jq .
```

## Hypothesis

The overwhelming aligned syntax should:
- Reduce re-reading behavior (less uncertainty)
- Improve answer accuracy (clearer structure)
- Faster response times (less cognitive load)
- Better bug detection (patterns stand out)
