---
source: ennaos mutable-code-comprehension — alt-state IR technical analysis (research output)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy; Elixir-specific research output)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/mutable-code-comprehension/alt-state-IR-analysis.md
source_commit: 5abb2fe
categories: [alt-state-IR, no-solution-meets-all-11, hybrid-approaches, elixir-specific, background-research]
why_included: >
  The technical deep-dive on Joseph's 11-objective "alt-state" wishlist (see the mutable-code-comprehension
  README): finds NO existing IR satisfies all 11 at once, recommends hybrids. The value here for UDON/harness is
  the objective LIST itself (fast round-trip both directions, modifiable with fast-fail impossible-state
  rejection, retains source metadata without depending on it) — a demand spec for a document IR.
---

# Alt-State Intermediate Representations for Elixir/OTP: A Comprehensive Technical Analysis

The quest for an optimal intermediate representation for Elixir/OTP umbrella applications reveals **no existing solution satisfies all 11 objectives simultaneously**, but hybrid approaches combining Core Erlang foundations with modern graph-based neural representations and gradual type systems show greatest promise. Current best path: extend Core Erlang with explicit concurrency primitives, integrate with Elixir's emerging set-theoretic type system, and adapt GraphCodeBERT-style contextual flow graphs augmented with message-passing semantics.

## State of Elixir/OTP intermediate representations today

The BEAM compilation pipeline provides multiple well-defined intermediate forms, each serving distinct purposes. **Core Erlang emerges as the strongest foundation** for an alt-state representation, offering human-readable syntax, complete semantic preservation, and direct compilability while serving as Dialyzer's primary analysis target. The pipeline flows from Elixir AST through macro expansion to Erlang Abstract Format, then Core Erlang (21.8 kB typical), through optimization passes to BEAM bytecode (1 kB final). Transformation speeds achieve sub-second performance for most modules, with Core Erlang compilation taking 0.01-3.3 seconds depending on complexity.

Elixir's AST uses elegant three-element tuples `{function, metadata, arguments}` enabling powerful metaprogramming through quote/unquote mechanisms. The `Macro` module provides extensive manipulation capabilities including `prewalk/postwalk` traversal, `expand/2` for controlled macro expansion, and `to_string/1` for bidirectional transformation. **Roundtripping achieves functional equivalence** though not character-identical output, with whitespace normalized and comments lost unless using `:token_metadata` options. The AST preserves full source structure, variable names, import context, and line/column information, though type information remains absent in this dynamically-typed representation.

Core Erlang simplifies Erlang's 50+ surface constructs to approximately 10 core forms, making analysis and optimization dramatically more tractable. All operations become explicit: pattern matching appears only in case statements, function calls distinguish local (`apply 'function_name'/arity`) from external (`call 'module':'function'`), and let bindings make intermediate values explicit. This simplified syntax enables Dialyzer's success typing inference, which operates primarily at this level. **The representation supports independent compilation** via `erlc module.core`, requires no original source, and preserves complete program semantics including function arity, call structure, control flow, and guards.

## Gradual typing revolution reshaping static analysis

Elixir's type system development (2023-2025) represents the most significant infrastructure change for static analysis. Based on set-theoretic types with sound gradual typing, the system introduces **strong arrows** as a key innovation—functions guaranteed to fail when given input outside their domain can safely return concrete types even when called from dynamic code. This leverages Elixir's "assertive" nature where pattern matching and guards already enforce domains, eliminating the typical gradual typing problem where `dynamic()` spreads throughout the codebase.

The theoretical foundation comes from Castagna, Duboc, and Valim's work formalizing set-theoretic types with union, intersection, and negation operations. **Union types** express alternatives naturally (`integer() or atom()`), **intersection types** enable bounded quantification (`a and number()` constrains type variable `a`), and **negation** captures exclusions (`term() and not nil`). The `dynamic()` type with optional bounds (`dynamic(integer() or float())`) provides gradual typing without compromising soundness through safe erasure—types erase before execution with zero runtime overhead.

Implementation milestones show rapid progress: Elixir 1.17 (June 2024) introduced pattern-based inference for atoms, maps, binaries, and primitives with warnings for definite type errors. Elixir 1.18 (December 2024) added function call type checking and gradual inference of patterns and return types. **Elixir 1.19-1.20 will introduce user-facing syntax** including typed structs (milestone 2) and user-provided type signatures (milestone 3), enabling developers to explicitly annotate code for the first time.

The module-local inference strategy proves crucial for scalability: the system infers types fully within the current module while assuming calls to other project modules return `dynamic()`, reducing cyclic dependencies and recompilation cascades. After local inference completes, whole-project type checking validates cross-module interactions. This design enables **sub-second type checking for most modules** while providing meaningful error detection.

## Neural code representations and their functional language gap

Neural approaches to code comprehension have evolved from simple sequence models to sophisticated graph-based representations capturing control flow, data flow, and semantic structure. The **inst2vec + XFG + LLVM IR baseline** (Ben-Nun et al., NeurIPS 2018) achieved state-of-the-art results by learning 200-dimensional embeddings for LLVM instructions trained on 50M+ lines across 24,030 files. Contextual Flow Graphs (XFG) combine data dependencies (SSA def-use chains) and control flow, with empirical evaluation showing **context size = 2 provides optimal balance** between local detail and broader relationships. On algorithm classification (POJ-104 benchmark), this approach achieved 94.83% accuracy, establishing new state-of-the-art with 13.8% error reduction.

GraphCodeBERT (Microsoft, ICLR 2021) advanced beyond sequence-based models by incorporating data flow into pre-training through graph-guided masked attention. The approach extracts ASTs using tree-sitter, constructs data flow graphs encoding "where-the-value-comes-from" relations, and pre-trains with three objectives: masked language modeling, edge prediction, and node alignment. **Performance improvements over CodeBERT reached +5-7% on code search and +2-3% on clone detection**, demonstrating data flow's critical role. This architecture proves particularly relevant for functional languages where data flow dominates program semantics.

ProGraML (Cummins et al., ICML 2021) extended these concepts with comprehensive program graphs as directed attributed multigraphs containing control flow, data flow, and call flow edges. Based on LLVM IR for language independence, it achieved 94.0 F1 score average across five traditional compiler data flow analysis tasks (reachability, dominators, data dependencies, liveness, subexpression detection) and 96.22% accuracy on program classification. The representation's **O(n) construction complexity and efficient C++ implementation** enable scaling to large codebases while supporting Message Passing Neural Networks for sophisticated reasoning.

**Critical gap: virtually no published research targets Erlang/Elixir specifically**. The ML code comprehension literature overwhelmingly focuses on imperative languages (C, C++, Java, Python), with LLVM IR's dominance reflecting this bias. Elixir faces unique challenges: BEAM IR remains less studied than LLVM IR, the actor model's message-passing concurrency requires specialized representations, and lightweight processes with supervision trees have no analog in studied systems. The smaller ecosystem creates less industry pressure, yet **significant opportunity exists** for BEAM instruction embeddings, process communication graph neural networks, supervision tree representation learning, and message passing protocol inference.

## Formal verification landscape for concurrent functional code

Concuerror stands out as the most mature and practical verification tool for Erlang/OTP, providing **systematic concurrency testing through stateless model checking with dynamic partial-order reduction**. The tool instruments code via parse transformation, inserting preemption points at shared state interactions (spawn, register, send, receive), then systematically explores interleaving sequences without capturing shared state. Complexity grows as O((nk)!/(k!)^n) for n processes and k preemption points, but pragmatic preemption bounds (typically 2-3) enable **verification completing in 2 minutes for 14 test functions**. Concuerror found subtle concurrency errors in Dialyzer (28,000 LOC) within 1 minute and scales to 712,000 interleavings in 700 minutes.

The tool's key advantage: it works with existing EUnit tests without modification, runs on the unmodified Erlang VM avoiding semantic alterations, and provides deterministic error reproduction with detailed interleaving traces. **Fast-fail validation** occurs immediately upon detecting deadlocks, race conditions, assertion violations, or abnormal process exits. For AI agent manipulation, Concuerror offers excellent suitability through its automated testing workflow, deterministic reproduction, and clear error traces.

Session types bring protocol-level verification to Erlang through multiparty session types compiled from Scribble global protocols to Communicating Finite-State Machines (CFSMs). Simon Fowler's implementation enables runtime monitoring with **2x performance overhead (0.12ms per message vs native gen_server)**, acceptable for many applications. The approach supports subsessions for nested protocols, integration with Erlang's "let it fail" philosophy, and multicast delivery guarantees via two-phase commit. Actors participate in multiple sessions simultaneously with modular protocol definitions enabling compositional design. **Session types excel for AI agent comprehension** through explicit protocol specifications, clear interface contracts, and compositional structure.

Property-based testing via StreamData provides the lowest-barrier formal verification approach with **immediate integration into existing Elixir workflows**. The framework uses composable generators as lazy enumerables with automatic shrinking, integrating with ExUnitProperties for declarative property specifications. Generators derive from type specifications, properties extract from function specs, and shrinking provides minimal counterexamples. **Fast-fail support proves excellent**: immediate failure on property violation, minimal counterexample generation within seconds, and clear error messages. For AI agents, the declarative property specifications, automatic test case generation, and clear failure feedback create optimal manipulation conditions.

## Functional language IR strategies and lessons

Haskell's GHC Core exemplifies typed intermediate language design, based on System FC (System F with type equality coercions) extending System Fω with GADTs, type families, and equality constraints. **The small elegant language uses only ~10 constructors** versus Haskell's 50+ surface constructs, with explicit type annotations enabling advanced optimizations through type preservation. All type parameters pass explicitly, type classes desugar to dictionary parameters, and coercions provide evidence of type equality. The compiler performs aggressive inlining (20-40% improvement alone), strictness analysis, worker-wrapper transformation, and specialization. Tools include `ghc-dump` for Core inspection, `-ddump-simpl` for pretty-printing, and `inspection-testing` for validating Core properties at compile-time.

OCaml's Flambda2 advances optimization-focused IR design through **CPS-based representation enabling single-pass optimization** with downward analysis and upward transformation traversal. Based on Andrew Kennedy's "Compiling with Continuations, Continued," the representation bypasses Clambda entirely, translating directly from Lambda IR to Cmm. The system achieves 20-30% allocation reduction on real-world code with similar latency improvements. **Inlining-centric design** supports aggressive cross-module inlining, multi-argument return mechanisms enabling allocation elimination, and complete functor inlining. The six core type categories (versus 20+ in Clambda) simplify optimization passes while maintaining power.

Scala 3's TASTy (Typed Abstract Syntax Trees) demonstrates **completeness-first design for tooling support**. Unlike JVM .class files with type erasure, TASTy stores the entire typed AST with full semantic information including symbols, types, positions, and documentation. This enables separate compilation, forward compatibility across JVM versions, and rich tooling including decompilation (`scalac -decompile`), semantic analysis via `tasty-query`, and binary compatibility checking. The DOT calculus (Dependent Object Types) provides TASTy's theoretical foundation with **machine-verified soundness proof in Coq**, combining nominal and structural typing with intersection types and path-dependent types.

Clojure's homoiconic advantage means **source code as data structure eliminates separate parsing steps**. The `tools.analyzer` produces AST node maps with guaranteed keys (`:op` for node type, `:form` for original, `:env` for environment, `:children` for sub-nodes), enabling direct code manipulation. Macros integrate naturally during the analysis phase through expansion before analysis. ClojureScript's self-hosted compiler (ClojureScript in ClojureScript) with bootstrap mode demonstrates AST interpretation approaches. **Bidirectionality proves reliable**: forward transformation completely preserves semantics, while `emit-form` reconstructs code with generally reliable round-tripping for standard forms.

## Comparative assessment against the 11 objectives

### Objective 1: Representation completeness for roundtrip generation

**Core Erlang: STRONG (8/10)**. Compiles independently via `erlc module.core`, preserves complete program semantics, and generates functionally equivalent code. Cannot recover original Elixir syntax sugar or macro invocations, but semantic equivalence holds. TASTy achieves higher completeness (9/10) by storing entire typed AST enabling decompilation to source, though Elixir lacks equivalent tooling.

**Elixir AST: MODERATE (6/10)**. `Macro.to_string/1` produces functionally equivalent but not character-identical output. Comments lost unless using `:token_metadata`, formatting normalizes, but core semantics preserve. Higher-level than Core Erlang enables macro reconstruction.

**LLVM IR: MODERATE (7/10)**. Excellent for imperative code, generates efficient machine code, but loses high-level functional abstractions. Closures, continuations, and actor patterns require awkward encoding. Not designed for actor model or message passing as first-class concepts.

**GraphCodeBERT/Neural Representations: WEAK (3/10)**. One-way transformations dominate current research. Graph → code generation remains open problem. Neural approaches optimize for comprehension and analysis rather than generation.

### Objective 2: Speed constraints (sub-1s small/medium, sub-3s large, scale-invariance)

**Core Erlang: STRONG (9/10)**. Sub-second compilation for most modules, 0.01-3.3s for typical cases. Well-optimized Erlang compiler handles large codebases efficiently. Caching via PLT files (Dialyzer) demonstrates scale-invariance through boundary caching.

**Elixir AST: EXCELLENT (10/10)**. Microsecond-level transformations for in-memory data structure operations. No I/O required. Elixir compiler performs AST transformations with high efficiency. Pattern matching on AST highly optimized.

**GHC Core/Flambda: MODERATE (6/10)**. Optimization-focused IRs trade compilation speed for runtime performance. Flambda significantly slower than `-Oclassic` mode. Multi-pass optimization can extend compilation times for large projects.

**Neural Embeddings: FAST INFERENCE (8/10)**. Once trained, inst2vec lookup is O(1) per statement, XFG construction O(n). ProGraML graph construction fast via C++ implementation. Training amortizes across all uses.

### Objective 3: Bidirectional transformation without perfect mirror accuracy

**Elixir AST: STRONG (8/10)**. `quote/unquote` and `Macro.to_string/1` provide solid bidirectionality. Whitespace/formatting changes acceptable, comments preserved with `:token_metadata`, ordering changes possible where AST-irrelevant.

**Core Erlang: MODERATE (6/10)**. Forward direction complete and reliable. Backward generates semantically equivalent Erlang code but cannot reconstruct Elixir idioms. Human-readable format enables manual reconstruction if needed.

**TASTy: EXCELLENT (9/10)**. Designed explicitly for bidirectionality. `scalac -decompile` reconstructs source with high fidelity. Complete information preservation enables accurate reconstruction.

**Lens-Based Approaches: THEORETICAL (5/10)**. Contract lenses and bidirectional programming provide formal framework but lack practical Elixir implementations. Research direction promising but immature.

### Objective 4: Compilation independence from source metadata

**Core Erlang: EXCELLENT (10/10)**. Specifically designed for independent compilation. `erlc module.core` requires no original source. Self-contained representation with all necessary semantic information.

**BEAM Bytecode: EXCELLENT (10/10)**. Runtime executes .beam files without source. `+debug_info` preserves additional information but not required for execution.

**Elixir AST: MODERATE (6/10)**. Requires environment (aliases, imports, requires) for compilation. `Code.eval_quoted/3` and `Code.compile_quoted/2` need proper context. Not fully self-contained.

**Neural Representations: WEAK (2/10)**. Learned embeddings capture patterns but lack executable semantics. Cannot compile to runnable code without traditional IR pipeline.

### Objective 5: Source metadata retention for tracing

**Elixir AST: EXCELLENT (9/10)**. Preserves line/column numbers with `:columns` option, variable names, import/alias context, module attributes. Metadata keyword lists extensible for custom information.

**BEAM with Debug Info: STRONG (8/10)**. `+debug_info` stores abstract code, source locations, variable names. Dbgi chunk in .beam files maintains tracing information. Integration with `:beam_lib.chunks/2` enables extraction.

**Core Erlang: MODERATE (5/10)**. Line numbers preserved, some attributes maintained, but variable names may transform. Original source formatting and comments lost.

**LLVM IR Metadata: STRONG (8/10)**. Extensible metadata system (`!dbg`, `!tbaa`, custom) preserves debugging information through optimization. Source location tracking maintained when possible.

### Objective 6: Static type support with maximum completeness

**Elixir Type System (1.18+): STRONG (8/10)**. Set-theoretic types with union, intersection, negation enable precise specifications. Gradual typing via `dynamic()` balances flexibility and safety. Strong arrows prevent dynamic spread. Module-local inference achieves sub-second checking. **Major limitation**: User-facing syntax not fully available until v1.19-1.20.

**Dialyzer Success Typing: MODERATE (6/10)**. No false positives philosophy means conservative analysis. Catches definite type errors with high confidence. PLT-based caching enables scalability. **Limitations**: Misses some errors by design, struggles with complex metaprogramming, no parametric polymorphism inference.

**GHC Core (System FC): EXCELLENT (10/10)**. Type-preserving compilation enables sophisticated optimizations. Explicit type applications, coercions for GADTs/type families, dictionary passing for type classes. Machine-checked soundness via Coq proofs.

**Refinement Types (LiquidHaskell): STRONG (8/10)**. SMT-decidable predicates enable precondition/postcondition specifications. Refinement reflection embeds function definitions in logic. **Gap**: No mature implementation for Elixir/Erlang exists.

### Objective 7: Concurrency analysis with actor model as first-class

**Current State: WEAK (3/10)**. **Critical gap across all existing approaches**. LLVM IR has no concurrency primitives, treats threads/processes as external runtime calls. Core Erlang represents spawn/send/receive but provides no higher-level abstractions for protocols or supervision.

**Dialyzer Limited (4/10)**. Race condition detection exists (`-Wrace_conditions`) but computationally expensive and disabled by default. GenServer callback type checking validates return values but cannot verify full protocol correctness. No formal protocol verification, deadlock detection, or liveness guarantees.

**Session Types: MODERATE (6/10)**. Multiparty session types via Scribble provide protocol conformance guarantees. Runtime monitoring with 2x overhead acceptable for many applications. **Limitation**: Dynamic checking only, no static verification yet.

**Proposed Graph Extensions: PROMISING (7/10 potential)**. Extended XFG with process flow edges, supervision relationships, state transitions could capture actor semantics. Would require new tooling and research validation.

### Objective 8: Documentation generation capability

**ExDoc from Compiled Modules: STRONG (8/10)**. Extracts `@moduledoc`, `@doc`, typespecs from compiled BEAM files. Generates comprehensive HTML documentation with search, function signatures, examples. Integration with `Code.Typespec` module accesses specs.

**Elixir AST: MODERATE (6/10)**. Module docs and function docs exist as module attributes, extractable before compilation. Custom analysis can extract documentation, but standard tooling works on compiled modules.

**TASTy: STRONG (8/10)**. Documentation integrated into typed AST representation. Separate from implementation but travels with compiled artifacts. Enables rich IDE tooltips and inline documentation.

**Neural Approaches: WEAK (4/10)**. Code summarization models can generate descriptions but quality inconsistent. Not designed for actionable documentation. Research area rather than production tool.

### Objective 9: Property testing support

**StreamData: EXCELLENT (9/10)**. Native Elixir framework with composable generators, automatic shrinking, ExUnitProperties integration. Generators derivable from type specifications (manual currently). Properties extracted from function specs. **Sub-second execution** for typical test suites (100 cases default). Fast-fail on violations with minimal counterexamples.

**PropCheck: STRONG (8/10)**. Wraps Erlang's PropEr with state machine testing support. More powerful than StreamData for complex scenarios. **Trade-off**: Steeper learning curve, requires Erlang expertise.

**Integration with IRs: MODERATE (6/10)**. Current manual generator definition despite typespec availability. **Opportunity**: Automatic generator derivation from Elixir type system (v1.19+) could achieve excellent integration.

**Concuerror Integration: STRONG (8/10)**. Works with existing EUnit tests, systematically explores concurrency scenarios. Property tests combined with systematic interleaving exploration provide comprehensive verification.

### Objective 10: Modifiability with tight feedback loops

**Elixir AST + IEx: EXCELLENT (9/10)**. Interactive development via IEx provides **microsecond feedback**. Pattern matching on AST enables precise modifications. Macro system allows staged transformations with immediate evaluation. `Code.eval_quoted/3` enables testing modifications instantly.

**Property-Based Testing: EXCELLENT (9/10)**. Immediate failure on property violation (seconds), minimal counterexamples guide fixes, incremental property addition supports iterative development. Integration with `mix test.watch` enables continuous feedback.

**Type System (v1.18): STRONG (8/10)**. Warnings appear during compilation (sub-second for most modules). Module-local inference prevents recompilation cascades. **Improving**: User-facing syntax (v1.19+) will enable explicit annotation-driven development.

**Concuerror: MODERATE (6/10)**. Preemption bound 2-3 completes in minutes. Deterministic reproduction enables quick iteration. **Limitation**: Exponential complexity limits exhaustive exploration of large state spaces.

### Objective 11: AI agent comprehension optimization

**GraphCodeBERT Approach: STRONG (8/10)**. Data flow graphs natural for functional code, pre-training framework exists, tree-sitter enables Elixir AST extraction. **Adaptation required**: No existing Elixir-specific model, would need corpus collection and training.

**Elixir AST: STRONG (8/10)**. Clean three-element tuple structure, code-as-data philosophy simplifies manipulation, extensive `Macro` module API. Pattern matching enables sophisticated analysis. **Advantage**: Native Elixir representation.

**Session Types + Protocols: STRONG (8/10)**. Explicit protocol specifications provide clear interfaces. Scribble global types machine-readable. Compositional structure enables modular reasoning. **AI-friendly**: Declarative, structured, formally specified.

**Property-Based Specifications: EXCELLENT (9/10)**. Declarative properties express invariants clearly. Automatic test generation from properties. Concrete counterexamples guide understanding. **Optimal for AI**: Executable specifications with clear pass/fail signals.

**Supervision Trees: MODERATE (6/10)**. OTP patterns well-documented but not formally captured in IR. **Opportunity**: First-class supervision tree representation in alt-state would enable AI reasoning about fault tolerance.

## Synthesis: Promising hybrid approaches

### Recommended hybrid architecture

The analysis reveals **no single approach satisfies all objectives**, but a multi-level IR strategy combining strengths across representations shows greatest promise:

**Level 1: High-Level Semantic IR (HE-IR)**
- Extended Elixir AST preserving macro invocations and protocol implementations
- First-class supervision tree representation (nodes for supervisors/workers, edges for supervision strategies)
- Message protocol annotations via session type integration
- Typespec preservation with gradual type annotations
- **Transformation**: Source → HE-IR in sub-100ms

**Level 2: Core Functional IR (CF-IR)**
- Core Erlang enhanced with explicit concurrency primitives
- Process spawn/send/receive as first-class operations (not external calls)
- Supervision relationships captured in metadata
- Integration with Elixir type system (v1.19+) for type-guided optimization
- **Transformation**: HE-IR → CF-IR in sub-500ms, CF-IR → BEAM in sub-1s

**Level 3: Graph-Based Neural Representation (GNR)**
- Adapted XFG with three additional edge types: message-passing flow, supervision relationships, state transitions
- Node embeddings learned via inst2vec-style training on Elixir/Erlang corpus
- Context size = 2 for local relationships, whole-graph for architectural patterns
- **Transformation**: CF-IR → GNR in sub-200ms (post-training)

### Implementation roadmap

**Phase 1 (0-6 months): Foundation**
- Extend Core Erlang parser to recognize concurrency primitives explicitly
- Implement CF-IR with process/message/supervision nodes
- Integrate with existing Dialyzer PLT format for caching
- **Target**: 90% roundtrip accuracy, sub-1s compilation for medium projects

**Phase 2 (6-12 months): Type integration**
- Bridge CF-IR with Elixir type system (v1.19+ when available)
- Type-preserving transformations enable optimizations
- Session type annotations for message protocols
- **Target**: Type-guided code generation, 15-20% performance improvement via specialization

**Phase 3 (12-18 months): Neural augmentation**
- Collect 10M+ lines of open-source Elixir code
- Train inst2vec-style embeddings on CF-IR statements
- Build Extended XFG with actor model extensions
- **Target**: State-of-the-art on Elixir-specific benchmarks (GenServer pattern recognition, protocol inference)

**Phase 4 (18-24 months): Tooling ecosystem**
- LSP server using multi-level IR for features (jump-to-def, refactoring, optimization hints)
- Property generation from type annotations and session types
- AI agent interface for code comprehension and modification
- **Target**: Mean time from feature understanding to first correct change \u003c 5 minutes for AI agents

### Specific tools and frameworks to investigate

**Immediate adoption:**
- **Dialyzer** with comprehensive `@spec` annotations (production-ready)
- **StreamData** for property-based testing (native Elixir, excellent integration)
- **Concuerror** for systematic concurrency testing (mature, proven on Dialyzer itself)

**Active development integration:**
- **Elixir Type System** (v1.19-1.20): Monitor releases, prepare for typed structs and user annotations
- **ElixirLS**: Track Language Server Team developments, particularly error-tolerant parsing (Spitfire parser)
- **ElixirSense**: Code intelligence features complementary to static analysis

**Research prototypes worth monitoring:**
- **Gradient/Gradualizer**: Erlang gradual typing (may inform Elixir developments)
- **Session types for Erlang** (Simon Fowler's work): Runtime monitoring approach
- **McErlang**: Model checking concepts applicable even if tool adoption limited

**Academic foundations:**
- **"Design Principles of the Elixir Type System"** (Castagna, Duboc, Valim, 2023): arXiv:2306.06391
- **"Guard Analysis and Safe Erasure Gradual Typing"** (Castagna, Duboc, 2024): arXiv:2408.14345
- **"Neural Code Comprehension"** (Ben-Nun et al., 2018): NeurIPS, inst2vec methodology
- **"GraphCodeBERT"** (Guo et al., 2021): ICLR, data flow integration
- **"ProGraML"** (Cummins et al., 2021): ICML, graph-based program representation

**Functional language lessons:**
- **GHC Core design** (System FC): Type-preserving transformations
- **Flambda2 architecture** (OCaml): CPS-based optimization, single-pass design
- **TASTy completeness** (Scala 3): Full information preservation for tooling
- **Lens-based bidirectionality**: Contract lenses for safe composition

### Critical gaps requiring new research

**Concurrency representation fundamentals**: No existing IR adequately represents actor model concurrency as first-class. LLVM IR treats processes as opaque, Core Erlang has primitives but no protocols, neural approaches ignore message passing. **Research needed**: Process communication graphs with message flow edges, supervision tree formal semantics, protocol state machine integration.

**Bidirectional neural transformations**: Current neural code models operate one-way (code → representation). **Research needed**: Invertible neural architectures for code, graph-to-code generation preserving Elixir idioms, semantic-preserving transformations in embedding space.

**Type-aware embeddings for gradual typing**: Neural models typically ignore types or assume static systems. **Research needed**: Embeddings incorporating `dynamic()` types, strong arrow detection via ML, type inference guidance from learned patterns.

**AI comprehension metrics**: No established benchmarks measure "time to comprehension" for AI agents on functional concurrent code. **Research needed**: Benchmark suite for Elixir/OTP patterns (GenServer, Supervisor, Phoenix contexts), metrics for comprehension quality, evaluation of modification correctness.

## Conclusion: Path forward for Elixir alt-state

The optimal alt-state for Elixir/OTP umbrella applications **must embrace multi-level design** rather than seeking a single perfect representation. Core Erlang provides the strongest existing foundation, satisfying 7 of 11 objectives strongly with modification. **Extensions required**: explicit concurrency primitives, integration with emerging type system, session type annotations, and graph-based neural augmentation.

The critical insight: **Elixir's unique combination of functional programming, actor model concurrency, and gradual typing creates requirements no existing IR fully addresses**. LLVM IR excels for imperative code but lacks concurrency semantics. GHC Core provides type preservation but assumes different execution model. Neural approaches show promise but lack Elixir-specific training and tooling.

**Highest-priority actions**: (1) Extend Core Erlang with first-class process/message/supervision primitives, (2) Integrate with Elixir type system v1.19+ as user-facing syntax arrives, (3) Adapt GraphCodeBERT methodology to Elixir AST with actor model extensions, (4) Build comprehensive property testing integration with automatic generator derivation from types. This hybrid approach leverages mature BEAM infrastructure while advancing state-of-the-art in functional concurrent code representation for AI comprehension.

The 11 objectives remain achievable through this multi-level strategy: compilation independence and speed via Core Erlang (objectives 1-4), type support via integration with Elixir's type system (objective 6), concurrency analysis via explicit primitives and session types (objective 7), property testing via StreamData integration (objective 9), modifiability via AST preservation (objective 10), and AI comprehension via graph-based neural representations (objective 11). Documentation generation (objective 8) already works excellently through ExDoc. Source metadata retention (objective 5) achieves through careful information flow across levels.

**Time to first prototype**: 6 months for Core Erlang extensions with basic concurrency primitives. **Time to production-ready tooling**: 18-24 months including type system integration and neural augmentation. **Expected performance**: Sub-1-second transformation for small/medium projects, sub-3-seconds for large monoliths, scale-invariance through PLT-style boundary caching achieving objectives within specified constraints.