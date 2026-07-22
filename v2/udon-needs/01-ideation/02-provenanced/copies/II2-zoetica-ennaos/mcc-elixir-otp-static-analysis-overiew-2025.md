---
source: ennaos mutable-code-comprehension — Elixir/OTP static analysis overview 2025 (research output)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy; Elixir-specific research output)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/mutable-code-comprehension/elixir-otp-static-analysis-overiew-2025.md
source_commit: 5abb2fe
categories: [static-analysis, type-systems, elixir-specific, background-research]
why_included: >
  Elixir/OTP static-analysis + type-system survey (2025). The most narrowly Elixir-specific of the group; kept as
  commit-pinned background so the comprehension-research lane is complete rather than papered over. Transferable
  only at the level of "static guarantees reduce the feedback-loop latency the tool-honesty ladder cares about."
---

Now I'll compile a comprehensive report on Elixir/OTP static code analysis with all the requested information and proper markdown footnote citations.

# Elixir/OTP Static Code Analysis: Tools, Techniques, and Type Systems (2025)

## Executive Summary

Elixir and the BEAM (Erlang Virtual Machine) ecosystem are undergoing a significant transformation in static code analysis capabilities, with the introduction of a gradual set-theoretic type system in Elixir versions 1.17-1.19. This report provides an up-to-date overview of static analysis tools, techniques, algorithms, and approaches available for Elixir/OTP development, with special emphasis on the emerging type system and its implications for code transformation.

## Current State of Elixir Static Type System

### Type System Implementation (2024-2025)

Elixir has officially become a gradually typed language as of v1.17[1][2]. The type system is based on semantic subtyping with set-theoretic types and represents the first "safe erasure gradual typing" system[3].

**Key Characteristics:**

- **Sound**: Inferred types align with program behavior
- **Gradual**: Includes `dynamic()` type for runtime-checked expressions
- **Developer-friendly**: Uses set operations (unions, intersections, negations)
- **Non-invasive**: No compilation changes, types erased before execution[4]

### Implementation Timeline

**Elixir 1.17 (June 2024)**[5]:
- First release with type system components
- Support for integers, floats, atoms (`:ok`, `:error`, `true`, `false`)
- Binaries and maps with atom keys

**Elixir 1.18**[6]:
- Lists and tuples support
- Type inference for patterns
- Improved bug detection through pattern analysis

**Elixir 1.19 (October 2025)**[7][8]:
- Precise support for all data types
- Type checking of all language constructs
- Type inference of patterns and return types
- Up to 4x faster compilation for large projects
- Protocol type checking

**Future Roadmap (v1.20-1.21)**[9]:
- Complete function type inference (v1.20)
- Explicit `$`-prefixed function type annotations (v1.21)
- Struct annotations

## Static Analysis Tools

### 1. Credo

**Description**: The most popular static code analysis tool for Elixir, focusing on code consistency and teaching[10][11].

**Key Features**[12]:
- Detects code smells and anti-patterns
- Enforces code style and conventions
- Identifies refactoring opportunities
- Customizable checks via `.credo.exs`
- CI/CD integration

**Usage**:
```elixir
# mix.exs
{:credo, "~> 1.7", only: [:dev, :test], runtime: false}

# Run analysis
mix credo
```

**Custom Checks**: Developers can write custom checks by implementing the `Credo.Check` behavior and analyzing the Elixir AST[13].

**Limitations**: Only detects 2 traditional code smells and 1 Elixir-specific smell automatically out of 22 traditional smells identified by developers[14].

### 2. Dialyzer (via Dialyxir)

**Description**: DIscrepancy AnaLYZer for ERlang programs, a powerful static analysis tool based on success typing[15][16].

**Key Features**[17][18]:
- Type mismatch detection
- Unreachable code identification
- Unnecessary function detection
- Flow analysis
- Works on BEAM bytecode or source code

**Advantages**[19]:
- No false positives guarantee (success typing)
- No PLT regeneration in incremental mode (OTP 26+)
- 7x faster than previous versions
- Operates without explicit type specifications

**Setup**:
```elixir
# mix.exs
{:dialyxir, "~> 1.4", only: [:dev], runtime: false}

# Run analysis
mix dialyzer
```

**Type Specifications**:
```elixir
@spec add(integer(), integer()) :: integer()
def add(x, y), do: x + y
```

**Challenges**[20]:
- Historically slow analyses (addressed in OTP 26+)
- Confusing error messages
- Limited guarantees compared to full static typing
- Best with client code analyzed together with libraries

### 3. Gradualizer

**Description**: Experimental gradual type checker for Erlang with Elixir support via Gradient[21][22].

**Key Features**[23]:
- Gradual typing approach
- No PLT required
- Fast analysis
- Real-time IDE integration via ErlangLS
- Easily understandable error messages

**Comparison with Other Tools**[24]:
- Better performance than Dialyzer (no PLT build)
- Good Erlang syntax coverage
- Experimental polymorphism support (v0.3+)
- 25-45% disagreement with ETC and eqWAlizer on test cases

### 4. Gradient

**Description**: Elixir wrapper for Gradualizer providing seamless gradual type checking[25].

**Setup**:
```elixir
{:gradient, github: "esl/gradient", only: [:dev], runtime: false}

# Run
mix gradient
```

**Features**:
- Presents errors in Elixir syntax
- Lightning-fast analysis
- Configurable warning ignoring via `.gradient_ignore.exs`

### 5. Sobelow

**Description**: Security-focused static analysis tool for Phoenix applications[26].

**Focus Areas**:
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Cross-site request forgery (CSRF)
- Command injection
- Insecure configuration

### 6. CodeScene

**Description**: Advanced code analysis focusing on technical debt and team dynamics[27].

**Features**:
- Behavioral code analysis
- Hotspot detection
- Team coordination insights
- Trend analysis over time

## Core Erlang and Intermediate Representations

### Core Erlang

Core Erlang is the primary intermediate form in the Erlang/Elixir compilation pipeline[28][29].

**Characteristics**[30]:
- Human-readable plain text format
- Simplified language with explicit constructs
- All pattern matching in `case` statements only
- All function calls qualified with module names
- No macro expansion needed

**Compilation Pipeline**[31]:
```
Elixir → Expanded Elixir → Core Erlang → Kernel Erlang → SSA → BEAM
```

**Accessing Core Erlang**:
```bash
# Generate Core Erlang from Erlang
erlc +to_core module.erl

# Compile Core Erlang
erlc module.core
```

**Use Cases**:
- Creating alternative language frontends targeting BEAM
- Compiler optimization development
- Advanced code analysis
- Code transformation tools

### SSA (Static Single Assignment)

Introduced in Erlang/OTP 22 (2019), SSA is the modern intermediate representation[32][33].

**Key Properties**[34]:
- Each variable assigned exactly once
- Facilitates optimization
- Better than previous BEAM-based IR for analysis

**Example SSA Code**[35]:
```
function blog:foo(_0) {
0:
  @ssa_bool:6 = bif:is_tuple _0
  br @ssa_bool:6, label 7, label 3
7:
  @ssa_arity = bif:tuple_size _0
  @ssa_bool:8 = bif:'=:=' @ssa_arity, literal 4
  br @ssa_bool:8, label 5, label 3
...
}
```

**Benefits for Analysis**:
- Easier to perform data-flow analysis
- Simplified optimization passes
- Better constant propagation
- More precise type inference

## Control Flow Graph (CFG) Analysis

### CFG Fundamentals

A Control Flow Graph represents program execution paths as a directed graph[36][37].

**Components**[38]:
- **Nodes**: Basic blocks (sequences of instructions)
- **Edges**: Control flow paths between blocks
- **Entry Block**: Single entry point
- **Exit Block**: Single exit point

**Construction from Code**[39]:
1. Identify basic blocks (single entry/exit instruction sequences)
2. Create nodes for each block
3. Add edges for control flow transfers (jumps, branches, calls)
4. Label edges with conditions (True/False for branches)

**Applications in Static Analysis**[40]:
- Liveness analysis
- Reaching definitions
- Available expressions
- Dead code detection
- Loop detection and optimization

### CFG in BEAM Context

The BEAM compiler generates CFG during compilation for:
- Optimization passes
- Type inference
- Guard analysis
- Exhaustiveness checking[41]

**Tools for CFG Analysis**:
- **angr**: General CFG recovery tool with CFGFast (static) and CFGEmulated (dynamic) modes[42]
- **Joern**: Code Property Graph framework with CFG support[43]

## Code Property Graph (CPG)

### CPG Overview

A Code Property Graph unifies multiple program representations into a single graph[44][45].

**Integrated Representations**[46]:
- **AST (Abstract Syntax Tree)**: Syntactic structure
- **CFG (Control Flow Graph)**: Execution order
- **PDG (Program Dependence Graph)**: Data/control dependencies
- **DFG (Data Flow Graph)**: Value flow

**Benefits**[47]:
- Query program structure and behavior simultaneously
- Pattern-based vulnerability detection
- Cross-language analysis support
- Graph database integration (Neo4j, Cosmos, Neptune)

### CPG Tools

**Joern**[48]:
- Open-source CPG framework
- C/C++ support
- Query language for code analysis
- Vulnerability pattern detection

**Fraunhofer AISEC CPG Library**[49]:
- Supports: Java, C/C++, Go, Python, TypeScript, LLVM IR, Ruby
- Multiple analysis types (dataflow, reachability, constant propagation)
- Neo4j export
- Extensible language frontends

**LLVM-based CPG**[50]:
- llvm2cpg: LLVM Bitcode to CPG conversion
- Integration with Joern
- Supports any LLVM-compiled language

### CPG for Erlang/Elixir

While no specific Erlang/Elixir CPG tool exists, potential approaches include:
1. **Core Erlang → CPG**: Parse Core Erlang AST and build CFG/DFG
2. **BEAM → CPG**: Reverse engineer from bytecode[51]
3. **Elixir AST → CPG**: Direct transformation from quoted expressions

## Erlang-Specific Analysis Tools

### RefactorErl

**Description**: Comprehensive source code analysis and transformation tool for Erlang[52][53].

**Key Features**[54]:
- Semantic graph representation
- Semantic Query Language for code analysis
- Refactoring transformations
- Code smell detection
- Dependency analysis
- Metric calculation

**Semantic Query Language Examples**[55]:
```erlang
% Find value of variable
@expr.origin

% Find call chain
@fun.(called_by)+
mods.funs[name==calc].(called_by)+

% Detect side effects
mods.funs.dirty
```

**Architecture**:
- Builds semantic graph from source code
- Enables complex queries about code relationships
- Supports incremental analysis

### Dialyzer Variants

**Comparison of Type Checkers**[56]:

| Tool | Approach | Performance | Accuracy |
|------|----------|-------------|----------|
| Dialyzer | Success typing | Moderate | No false positives |
| Gradualizer | Gradual typing | Fast | Sound but incomplete |
| ETC | Bidirectional | Limited syntax | High for supported code |
| eqWAlizer | Type inference | Fast | High precision |

## Elixir Type System: Advanced Features

### Gradual Typing with Strong Functions

**Strong Functions**: Functions guaranteed to return within their codomain or fail on type checks when applied outside their domain[57][58].

**Example**:
```elixir
# Strong function (checked by VM)
$ {term(), integer(), ..} -> integer()
def inc_second(x), do: elem(x,1) + 1

# Type deduced for inc_second(dyn) is integer()
# (not dynamic()) because + checks integer arguments
```

**Benefits**[59]:
- Precise static types without runtime check insertion
- Leverages existing VM type checks
- Enables "safe erasure" gradual typing

### Guard Analysis

**Capabilities**[60][61]:
- Infers types from complex boolean guard expressions
- Handles nested conditions with `or`, `and`, `not`
- Generates multiple type environments for union branches
- Computes "surely accepted" and "potentially accepted" types

**Example**:
```elixir
defguard is_data(d) when is_tuple(d) and tuple_size(d) == 2 and
  (elem(d, 0) == :is_an_int and is_integer(elem(d, 1)) or
   elem(d, 0) == :is_a_bool and is_boolean(elem(d, 1)))

# System deduces type:
# data() = {:is_an_int, integer()} or {:is_a_bool, boolean()}
```

**Type Narrowing**[62]:
```elixir
$ result() -> _
def handle(r) when r.output == :ok, do: {:accepted, r.socket}
def handle(r) when is_atom(r.message), do: r.message
def handle(r), do: {:retry, elem(r.message, 1)}

# Type of r narrowed in each branch based on guard
```

### Set-Theoretic Types

**Type Operators**[63][64]:
- **Union (`or`)**: `integer() or boolean()`
- **Intersection (`and`)**: `(integer() -> integer()) and (boolean() -> boolean())`
- **Negation (`not`)**: `not integer()`
- **Singleton types**: `:ok`, `:error`, `true`, `false`, `nil`

**Semantic Subtyping**[65]:
- Types interpreted as sets of values
- Subtyping = set containment
- Decidable in EXPTIME[66]
- Distributivity and commutativity properties

**Polymorphism**[67]:
```elixir
$ tree(a) -> [a] when a: term()
def flatten([]), do: []
def flatten([x | xs]), do: flatten(x) ++ flatten(xs)
def flatten(x), do: [x]
```

### Multi-Arity Functions

**Problem**: Traditional semantic subtyping treats functions as unary on tuples, making arity tests impossible to type[68].

**Solution**: Explicit arity syntax[69]:
```elixir
# Type of all binary functions
(none(), none()) -> term()

# Curry example
$ (((none(), none()) -> term()) -> none() -> none() -> term()) and
  (((none(), none(), none()) -> term()) -> none() -> none() -> none() -> term())
def curry(f) when is_function(f,2), do: fn a -> fn b -> f.(a,b) end end
def curry(f) when is_function(f,3), do: fn a -> fn b -> fn c -> f.(a,b,c) end end end
```

## Code Transformation with Elixir Macros

### Metaprogramming Fundamentals

Elixir is **homoiconic**: code is represented as AST that can be manipulated[70][71].

**AST Representation**[72]:
```elixir
iex> quote do: 1 + 2
{:+, [context: Elixir, import: Kernel], [1, 2]}
```

**Core Functions**:
- `quote/2`: Convert code to AST
- `unquote/1`: Inject values into quoted expressions
- `defmacro/2`: Define macros
- `Macro.expand/2`: Expand macros
- `Macro.to_string/2`: Convert AST to readable code

### Macro-Based Transformations

**Simple Transformation Example**[73]:
```elixir
defmodule SimpleMacro do
  defmacro plus(x, y) do
    quote do: unquote(x) + unquote(y)
  end
end
```

**Complex AST Traversal**[74]:
```elixir
defmodule Checker do
  def run(ast) do
    Macro.prewalk(ast, [], fn
      {:def, meta, [{name, _, args} | _]} = node, acc ->
        {node, [{name, length(args)} | acc]}
      node, acc ->
        {node, acc}
    end)
  end
end
```

### Building Static Analyzers with AST

**Custom Credo Check Example**[75]:
```elixir
defmodule MyApp.Check do
  use Credo.Check
  
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)
    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end
  
  defp traverse({:defmodule, meta, _} = ast, issues, issue_meta) do
    # Analyze module definition
    {ast, issues}
  end
end
```

### Quick Code Transformations

**AST-Based Refactoring**[76]:
1. Parse source file: `Code.string_to_quoted(source, columns: true)`
2. Transform AST with `Macro.prewalk/3` or `Macro.postwalk/3`
3. Generate code: `Macro.to_string/2`
4. Write back to file

**Example: Renaming Functions**:
```elixir
def rename_function(ast, old_name, new_name) do
  Macro.prewalk(ast, fn
    {:def, meta, [{^old_name, def_meta, args} | body]} ->
      {:def, meta, [{new_name, def_meta, args} | body]}
    node ->
      node
  end)
end
```

## Gleam Integration for Type Analysis

### Gleam Overview

Gleam is a statically-typed functional language targeting BEAM and JavaScript[77][78].

**Key Features**[79]:
- Strong static typing with full type inference
- No null/nil/undefined
- Exhaustive pattern matching
- Interoperability with Erlang/Elixir
- Compiles to Erlang

**Type System**[80]:
- Row types for flexible records
- Generics
- No subtyping
- ADT-style enums

### Using Gleam for Type Analysis

**Approach 1: Mixed Codebase**[81]
```gleam
// Gleam module with strong types
pub fn process_data(input: List(Int)) -> Result(String, String) {
  // Type-safe implementation
}
```

```elixir
# Call from Elixir
:my_gleam_module.process_data([1, 2, 3])
```

**Approach 2: Type Specification Generation**
- Write critical functions in Gleam
- Extract type information from Gleam compiler
- Generate Elixir typespecs or type annotations

**Limitations**:
- No direct type system integration
- Manual synchronization required
- Different type paradigms (structural vs nominal)

## Semantic Subtyping Algorithms

### Decision Procedure

**Core Algorithm**[82][83]:
1. Model types as logical formulas in tree logic
2. Translate subtyping `s ≤ t` to formula implication
3. Check satisfiability of negated implication: `s ∧ ¬t`
4. If unsatisfiable → subtyping holds
5. If satisfiable → produce counterexample

**Complexity**: EXPTIME (2^O(n) where n is type size)[84]

**Implementation Approach**[85]:
```
Types → Tree Logic Formulas → μ-calculus → SAT Solver
```

**Key Innovation**: Semantic (model-theoretic) rather than syntactic (rule-based) subtyping enables completeness[86].

### Binary Decision Diagrams (BDDs)

Elixir's type system implementation uses BDDs for function types[87]:
- Efficient propositional formula representation
- Fast subtyping checks
- Compact storage of arrow types

**Example**:
```elixir
# Type: (integer() -> integer()) and (boolean() -> boolean())
# Represented as BDD encoding domain→codomain relationships
```

## Practical Applications

### Type-Driven Development

**Workflow**[88]:
1. Write function with guards expressing types
2. Type system infers precise types
3. Compiler finds type mismatches
4. Refine implementation based on warnings

**Example**:
```elixir
def handle_message(msg) when is_map(msg) and msg.type == :request do
  # Type system infers: %{type: :request, ...}
  process_request(msg)
end
def handle_message(msg) when is_map(msg) and msg.type == :response do
  # Type system infers: %{type: :response, ...}
  process_response(msg)
end
# Warning if cases not exhaustive for declared input type
```

### Bug Detection

**Real-World Impact**[89]:
- Phoenix: Found hidden bugs in production code
- Postgrex: Detected dead code
- Flame: Uncovered type inconsistencies
- LiveView: Identified unreachable branches

**Common Patterns Detected**:
- Missing pattern match cases
- Type mismatches in function calls
- Unused function definitions
- Incorrect protocol implementations

### CI/CD Integration

**GitHub Actions Example**[90]:
```yaml
- name: Type check
  run: mix dialyzer --format github
  
- name: Static analysis
  run: mix credo --strict

- name: Compile with warnings as errors
  run: mix compile --warnings-as-errors
  env:
    MIX_ENV: test
```

**Performance Considerations**[91]:
- Elixir 1.19: 4x faster compilation for large projects
- Minimal type checking overhead (< 5% in production)
- PLT caching for Dialyzer (OTP 26+ incremental mode)

## Future Directions

### Planned Enhancements[92]

**Type System (v1.20-1.21)**:
- User-provided type annotations via `$` prefix
- Struct type definitions
- Complete function type inference
- Polymorphic type variables

**Research Areas**:
- **Occurrence Typing**: More precise type reconstruction
- **Row Polymorphism**: Better map type handling
- **Message-Passing Types**: Actor model type checking with behavioral types
- **Behavior Integration**: Module-level type declarations

### Tools Evolution

**Expected Developments**:
- Enhanced Credo checks leveraging type information
- Dialyzer refinements based on type system feedback
- IDE integration with real-time type checking
- Cross-module type inference

## Conclusion

The Elixir/OTP ecosystem is experiencing a renaissance in static analysis capabilities. The gradual set-theoretic type system introduced in Elixir 1.17-1.19 represents a breakthrough in combining dynamic language flexibility with static typing benefits. Combined with mature tools like Credo and Dialyzer, developers now have a comprehensive toolkit for ensuring code quality without sacrificing the BEAM's runtime characteristics.

The semantic subtyping approach, particularly the guard analysis and strong function techniques, enables precise type checking while preserving backward compatibility. For developers seeking code transformation capabilities, Elixir's macro system provides powerful AST manipulation at compile time, complemented by Core Erlang for lower-level transformations.

As the type system continues to mature through v1.20 and beyond, the integration of these analysis techniques will only deepen, offering Elixir developers the safety of static typing with the agility of dynamic languages.

***

## References

[1]: Elixir Programming Language. "Strong arrows: a new approach to gradual typing." https://elixir-lang.org/blog/2023/09/20/strong-arrows-gradual-typing/, September 19, 2023. Accessed November 2, 2025. "A gradual type system is a type system that defines a dynamic() type."

[2]: Elixir Forum. "Jose Valim: 'Elixir is, officially, a gradually typed language'." https://elixirforum.com/t/jose-valim-elixir-is-officially-a-gradually-typed-language/60850, January 8, 2024. Accessed November 2, 2025. Quote: "Elixir is officially a gradually typed language."

[3]: Castagna, Giuseppe, and Guillaume Duboc. "Guard Analysis and Safe Erasure Gradual Typing: a Type System for Elixir." arXiv:2408.14345, August 26, 2024 (revised September 26, 2025). https://arxiv.org/pdf/2408.14345.pdf, Accessed November 2, 2025. "Our safe erasure gradual typing strategy maintains soundness and expressiveness without compromising compatibility or performance."

[4]: Hexdocs. "Gradual set-theoretic types — Elixir v1.19.1." https://hexdocs.pm/elixir/gradual-set-theoretic-types.html, Accessed November 2, 2025. Quote: "Elixir's type system is: sound, gradual, developer friendly."

[5]: Thinking Elixir Podcast. "Elixir Update & Q&A - José Valim | ElixirConf US 2025." https://www.youtube.com/watch?v=BUOTLZOyLvc, September 4, 2025. Accessed November 2, 2025. Timestamp 530: "elixir 1.17 was the first release to include some type system developments."

[6]: Ibid. Timestamp 564: "Then elixir 1.18 came and we started supporting lists and tpples."

[7]: Elixir Programming Language. "Elixir v1.19 released." https://elixir-lang.org/blog/2025/10/16/elixir-v1-19-0-released/, October 15, 2025. Accessed November 2, 2025. "Type system improvements. This release improves the type system by adding type inference of anonymous functions."

[8]: Thinking Elixir Podcast. "Thinking Elixir Podcast 276: Elixir v1.19 Types and Speed." https://www.youtube.com/watch?v=1-3mqnXgqZE, October 27, 2025. Accessed November 2, 2025. Quote: "major release of Elixir v1.19 with enhanced type checking, broader type inference, and up to 4x faster compilation."

[9]: Castagna, Giuseppe, Guillaume Duboc, and José Valim. "The Design Principles of the Elixir Type System." The Art, Science, and Engineering of Programming, vol. 8, no. 2, 2024. https://www.irif.fr/_media/users/gduboc/elixir-types.pdf, Accessed November 2, 2025. Section 5 (page 24): "First release... Second Milestone... Third Milestone."

[10]: GitHub. "rrrene/credo: A static code analysis tool for the Elixir language." https://github.com/rrrene/credo, September 26, 2015 (last updated 2025). Accessed November 2, 2025. "Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency."

[11]: Hexdocs. "Overview — Credo v1.7.13." https://hexdocs.pm/credo/overview.html, June 30, 2013 (updated 2024). Accessed November 2, 2025. "Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency."

[12]: SourceForge. "Credo." https://sourceforge.net/projects/credo.mirror/, October 14, 2025. Accessed November 2, 2025. Features list including: "Static code analysis focused on teaching and style consistency."

[13]: AppSignal Blog. "Writing a Custom Credo Check in Elixir." https://blog.appsignal.com/2023/08/29/writing-a-custom-credo-check-in-elixir.html, August 28, 2023. Accessed November 2, 2025. "Not only does it offer dozens of pre-made checks, but it also allows you to create your own."

[14]: ACM Digital Library. "Code Smells in Elixir: Early Results from a Grey Literature Review." https://dl.acm.org/doi/10.1145/3524610.3527881, March 15, 2022. Accessed November 2, 2025. "We conclude that only two traditional code smells and one Elixir-specific code smell are automatically detected by this tool."

[15]: Ubuntu Manpages. "Dialyzer is a DIscrepancy AnaLYZer for ERlang programs." https://manpages.ubuntu.com/manpages/plucky/man1/dialyzer.1.html, December 31, 2024. Accessed November 2, 2025. "Dialyzer is a static analysis tool that identifies software discrepancies."

[16]: Erlang.org. "dialyzer v5.4." https://www.erlang.org/doc/apps/dialyzer/dialyzer_chapter.html, Accessed November 2, 2025. "Dialyzer is a static analysis tool that identifies software discrepancies, such as definite type errors, code that is unreachable."

[17]: Learn You Some Erlang. "Type Specifications and Erlang." https://learnyousomeerlang.com/dialyzer, Accessed November 2, 2025. "Dialyzer thus begins each analysis optimistically assuming that all functions are good."

[18]: AppSignal Blog. "Getting Started with Dialyzer in Elixir." https://blog.appsignal.com/2025/03/18/getting-started-with-dialyzer-in-elixir.html, March 17, 2025. Accessed November 2, 2025. "Dialyzer (DIscrepancy AnaLYZer for ERlang programs) is a powerful static analysis tool."

[19]: Erlang Solutions Blog. "Type-checking Erlang and Elixir." https://www.erlang-solutions.com/blog/type-checking-erlang-and-elixir/, June 9, 2024. Accessed November 2, 2025. "However, since Erlang OTP 26, the situation has greatly improved thanks to the 'incremental' mode."

[20]: Ibid. "Historically slow analyses, confusing errors, and limited guarantees, even quite prominent community figures have voiced skepticism."

[21]: GitHub. "josefs/Gradualizer: A Gradual type system for Erlang." https://github.com/josefs/Gradualizer, October 28, 2017 (updated 2025). Accessed November 2, 2025. "Gradualizer is a static type checker for Erlang with some support for gradual typing."

[22]: Erlang Forums. "Gradualizer - an experimental static type checker for Erlang." https://erlangforums.com/t/gradualizer-an-experimental-static-type-checker-for-erlang-0-3-0-just-out/2158, July 6, 2023. Accessed November 2, 2025. "Gradualizer is a static/gradual typechecker for Erlang and thanks to Gradient, also for Elixir."

[23]: GitHub. "erszcz/erlang-type-checker-comparison." https://github.com/erszcz/erlang-type-checker-comparison, July 26, 2022. Accessed November 2, 2025. "better performance than Dialyzer (significantly shorter run times on the same files, no PLT build/check time)."

[24]: Ibid. "Gradualizer, Etylizer, and eqWAlizer disagree on 25% - 45% of test cases across all test suites."

[25]: GitHub. "esl/gradient: Gradient is a static typechecker for Elixir." https://github.com/esl/gradient, October 17, 2021 (updated 2024). Accessed November 2, 2025. "Gradient is a gradual typechecker for Elixir... aims to make jumping the hoops between your Elixir code and the Erlang abstract syntax tree that Gradualizer works on effortless."

[26]: Daily.dev. "6 Best Elixir Static Analysis Tools 2024." https://daily.dev/blog/6-best-elixir-static-analysis-tools-2024, May 19, 2024. Accessed November 2, 2025. "Sobelow: Security-focused code analysis for Phoenix applications."

[27]: Ibid. "CodeScene: Code analysis, team dynamics, software delivery insights."

[28]: 8th Light. "The Core of Erlang." https://8thlight.com/insights/the-core-of-erlang, September 9, 2025. Accessed November 2, 2025. "Core Erlang is the major intermediate form that powers the Erlang (and Elixir) multi-pass compiler."

[29]: Elixir Forum. "Inspect intermediate representations of code." https://elixirforum.com/t/inspect-intermediate-representations-of-code/32858, July 5, 2020. Accessed November 2, 2025. "The Erlang compiler supports a few flags +to_pp +to_exp +to_core +to_kernel +to_asm."

[30]: 8th Light. "The Core of Erlang." Section "Why it's cool," subsection 2-3. "Unlike intermediate forms in some other languages, the Erlang compiler can read and write Core files without any hack-ery."

[31]: Ibid. Diagram showing: "Elixir → Expanded Elixir → Core Erlang → Kernel Erlang → BEAM."

[32]: Erlang.org. "Introduction to SSA." https://www.erlang.org/blog/introducing-ssa/, September 4, 2018. Accessed November 2, 2025. "SSA stands for Static Single Assignment... each variable is assigned exactly once."

[33]: Erlang.org. "The Optimizations in Erlang/OTP 27." https://www.erlang.org/blog/optimizations/, April 22, 2024. Accessed November 2, 2025. "Erlang/OTP 22 introduced a new SSA-based intermediate representation in the compiler."

[34]: Wikipedia. "Static single-assignment form." https://en.wikipedia.org/wiki/Static_single-assignment_form, November 19, 2003 (last updated 2025). Accessed November 2, 2025. "SSA is a type of intermediate representation (IR) where each variable is assigned exactly once."

[35]: Erlang.org. "Introduction to SSA." Code example from blog post. "function blog:foo(_0) { 0: @ssa_bool:6 = bif:is_tuple _0..."

[36]: Nicolo.dev. "The Role of the Control Flow Graph in Static Analysis." https://nicolo.dev/en/blog/role-control-flow-graph-static-analysis/, October 29, 2023. Accessed November 2, 2025. "The flow control graph is an important building block in static program analysis."

[37]: GeeksforGeeks. "Control Flow Graph (CFG) - Software Engineering." https://www.geeksforgeeks.org/software-engineering/software-engineering-control-flow-graph-cfg/, May 14, 2019 (updated July 11, 2025). Accessed November 2, 2025. "A Control Flow Graph (CFG) is the graphical representation of control flow or computation during the execution of programs."

[38]: Ibid. "Entry Block: The entry block allows the control to enter into the control flow graph. Exit Block: Control flow leaves through the exit block."

[39]: Nicolo.dev. "The Role of the Control Flow Graph in Static Analysis." Section "Constructing the CFG." "Each elementary block cannot contain more than one flow change instruction."

[40]: Ibid. Final paragraph. "Compilers use the control flow graph to implement a number of optimizations involving expressions and variables."

[41]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Section 3.2 (pages 9-12). Discussion of exhaustivity and redundancy checking using guard analysis.

[42]: angr documentation. "Control-flow Graph Recovery (CFG)." https://docs.angr.io/built-in-analyses/cfg, Accessed November 2, 2025. "CFGFast uses static analysis to generate a CFG. It is significantly faster."

[43]: Joern. "Code Property Graph Specification 1.1." https://cpg.joern.io, Accessed November 2, 2025. "The Code Property Graph is a language-agnostic intermediate graph representation of code designed for code querying."

[44]: CoderPad. "An Intro to the Code Property Graph." https://coderpad.io/blog/development/code-property-graph-oriented-databases-source-code-analysis/, June 4, 2023. Accessed November 2, 2025. "A Code Property Graph (CPG) is a static code analysis innovation composed of three sub-graphs: AST, CFG, and PDG."

[45]: GitHub. "Fraunhofer-AISEC/cpg." https://github.com/Fraunhofer-AISEC/cpg, December 1, 2019 (updated 2025). Accessed November 2, 2025. "A code property graph (CPG) is a representation of source code in form of a labelled directed multi-graph."

[46]: CoderPad. "An Intro to the Code Property Graph." Section "What is a Code Property Graph (CPG)?". "You need three sub-graphs to capture all mandatory entities and relationships."

[47]: GitHub. "Fraunhofer-AISEC/cpg." README introduction. "This representation is supported by a range of graph databases such as Neptune, Cosmos, Neo4j."

[48]: Joern website. "Code Property Graph Specification 1.1." Introduction. Discussion of Joern as open-source CPG framework for C/C++.

[49]: Fraunhofer AISEC GitHub Pages. "Home - Code Property Graph." https://fraunhofer-aisec.github.io/cpg/, December 31, 2022. Accessed November 2, 2025. "Supported Languages: Java, C/C++, Go, Python, TypeScript, LLVM-IR, Ruby."

[50]: LLVM Blog. "LLVM meets Code Property Graphs." https://blog.llvm.org/posts/2021-02-23-llvm-meets-code-property-graphs/, February 22, 2021. Accessed November 2, 2025. "This article presents ShiftLeft's open-source implementation of llvm2cpg."

[51]: Erlang Factory. "Recovering Erlang AST from BEAM bytecode." http://www.erlang-factory.com/static/upload/media/14979662117233382melindatothwhatwefoundinthebeamcode.pdf, Accessed November 2, 2025. "Enable the RefactorErl static analysis system for Erlang to recover information from source dependencies stored as Erlang BEAM bytecode."

[52]: ELTE RefactorErl Wiki. "SemanticQuery." http://pnyf.inf.elte.hu/trac/refactorerl/wiki/SemanticQuery, February 26, 2015. Accessed November 2, 2025. "A semantic query language was designed to query syntactic and semantic information about Erlang programs."

[53]: Erlang Factory. "RefactorErl: a source code analyser and transformer tool." https://www.erlang-factory.com/upload/presentations/291/melinda_RefactorErl_euc10.pdf, Accessed November 2, 2025. Presentation slides on RefactorErl architecture and features.

[54]: Ibid. Slide on "Framework: The tool" showing semantic graph structure.

[55]: Ibid. Slides on "Semantic query examples" showing various query patterns.

[56]: GitHub. "erszcz/erlang-type-checker-comparison." Comparison table in README. "Dialyzer is a static analysis tool... ETC is a type checker... Gradualizer is a gradual type checker."

[57]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." arXiv:2408.14345. Section 1.2.2 (pages 4-6). "Strong functions are functions whose input and output types are entirely or partially checked by the VM."

[58]: Ibid. Page 5, example lines 9-10. Discussion of `inc_second` as a strong function due to VM checks.

[59]: Ibid. Abstract. "Central to our approach are two key innovations: the notion of strong functions... which can be assigned precise types even when applied to inputs that may fall outside their intended domain."

[60]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Section 3.2 (pages 9-12). Extensive discussion of guard analysis capabilities.

[61]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." Section 1.2.4 (pages 7-9). "Section 3 presents an analysis that characterizes this set in terms of types."

[62]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Page 11, code example lines 79-82. Shows type narrowing based on guard conditions.

[63]: Ibid. Section 2.2 (pages 4-6). "Unions, intersections, and—see later on—negations are called set-theoretic types."

[64]: Elixir Programming Language. "Strong arrows: a new approach to gradual typing." September 19, 2023. Discussion of union, intersection, and negation type operators.

[65]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Section 2.2, page 4. "if we think of a type as the set of all values of that type... then the union of two types is the set that contains the union of their values."

[66]: ACM Digital Library. "A Logical Approach to Deciding Semantic Subtyping." https://dl.acm.org/doi/10.1145/2812805, Accessed November 2, 2025. Abstract: "show how this relation can be decided in EXPTIME, answering an open question."

[67]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Page 7, code example lines 39-42. Polymorphic `flatten` function with type `tree(a) -> [a]`.

[68]: Ibid. Section 3.1 (pages 8-9). "While it is possible to test the arity of a function using the expression is_function... it is not possible in semantic subtyping to express the type of exactly all functions with a specific arity."

[69]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." Section 1.2.5 (pages 9-10), code examples lines 24-27. Shows multi-arity curry function with explicit arity types.

[70]: Dorgan.ar. "A deep dive into the Elixir AST." https://dorgan.ar/posts/2021/04/the_elixir_ast/, March 31, 2021. Accessed November 2, 2025. "Elixir is a homoiconic language, meaning that its code is represented using simple data structures that can be manipulated."

[71]: Ada Beat. "Metaprogramming in Elixir." https://adabeat.com/fp/metaprogramming-in-elixir/, April 1, 2025. Accessed November 2, 2025. "Elixir's homoiconic nature — meaning that code is represented as data structures that can be manipulated at compile time."

[72]: Hexdocs. "Macro — Elixir v1.20.0-dev." https://hexdocs.pm/elixir/main/Macro.html, Accessed November 2, 2025. Code example showing `quote do: 1 + 2` produces `{:+, [line: 3], [1, 2]}`.

[73]: Elixir School. "Metaprogramming." https://elixirschool.com/en/lessons/advanced/metaprogramming, Accessed November 2, 2025. Code example of `SimpleMacro.plus(x, y)` macro definition.

[74]: Dorgan.ar. "A deep dive into the Elixir AST: Building a static code analyzer." https://dorgan.ar/posts/2021/04/the_elixir_ast_analyzer/, March 31, 2021. Accessed November 2, 2025. Code example showing `Macro.prewalk` for AST traversal.

[75]: AppSignal Blog. "Writing a Custom Credo Check in Elixir." Code example showing custom check implementation with `use Credo.Check`.

[76]: Elixir Forum. "A script for re-writing AST: where to start?" https://elixirforum.com/t/a-script-for-re-writing-ast-where-to-start/54247, February 28, 2023. Accessed November 2, 2025. Discussion of AST transformation workflow.

[77]: InfoQ. "Erlang-Runtime Statically-Typed Functional Language Gleam Reaches 1.0." https://www.infoq.com/news/2024/03/gleam-erlang-virtual-machine-1-0/, March 15, 2024. Accessed November 2, 2025. "Gleam, an actor-based highly-concurrent functional language running on the Erlang virtual machine (BEAM), has reached version 1.0."

[78]: Elixir Forum. "Gleam, a statically typed language for the Erlang VM." https://elixirforum.com/t/gleam-a-statically-typed-language-for-the-erlang-vm/20349, May 8, 2020. Accessed November 2, 2025. "Gleam is a statically typed language for the Erlang VM."

[79]: InfoQ. "Erlang-Runtime Statically-Typed Functional Language Gleam Reaches 1.0." Features list. "Gleam follows in the line of strong statically-typed languages like Elm, OCaml, and Rust."

[80]: Elixir Forum. "Gleam, a statically typed language for the Erlang VM." Quote: "The type system features full type inference without annotations, generics, flexible and ad-hoc records using row types."

[81]: InfoQ. "Erlang-Runtime Statically-Typed Functional Language Gleam Reaches 1.0." Code example showing Gleam-Elixir interop. "Gleam programs can use packages created for BEAM independently from the language used to write them."

[82]: Tyrex. "A Logical Approach to Deciding Semantic Subtyping." http://tyrex.inria.fr/publications/toplas15.pdf, Accessed November 2, 2025. Page 3: "types are translated into logical formulas describing precisely the set of model elements corresponding to the type."

[83]: Ibid. Page 3: "Deciding subtyping between two types can then be done by feeding to this checker the negation of the implication formula relating the two types."

[84]: Ibid. Abstract: "show how this relation can be decided in EXPTIME, answering an open question."

[85]: Ibid. Page 3: "Types → Tree Logic Formulas → μ-calculus → SAT Solver" (paraphrased from description).

[86]: pnwamk.github.io. "Down and Dirty with Semantic Set-theoretic Types." https://pnwamk.github.io/sst-tutorial/, November 21, 2021. Accessed November 2, 2025. Section 2.1: "For a complete treatment of subtyping for set-theoretic types, a semantic (instead of a syntactic) notion of subtyping is required."

[87]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." Section 7 (page 49). "Function: Represented using Binary Decision Diagrams (BDDs) for efficient handling of propositional logic formulas for arrow types."

[88]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Throughout Section 3. Numerous examples showing workflow of writing guards and inferring types.

[89]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." Section 7.4 (page 52): "It has successfully uncovered hidden bugs and dead code in major projects (Phoenix, Postgrex, Flame, LiveView)."

[90]: Massdriver. "Dilating GitHub Actions using Dialyzer." https://www.massdriver.cloud/blogs/dilating-github-actions-using-dialyzer, October 1, 2024. Accessed November 2, 2025. Example GitHub Actions configuration.

[91]: Castagna, Duboc. "Guard Analysis and Safe Erasure Gradual Typing." Section 7.3 (page 51). Performance results table showing Remote, Livebook, Phoenix compile/typecheck times.

[92]: Castagna, Duboc, Valim. "The Design Principles of the Elixir Type System." Section 5 (pages 24-25) and Section 7 (pages 29-30). Roadmap and future work discussion.

Sources
[1] Teaching Code Refactoring Using LLMs https://arxiv.org/abs/2508.09332
[2] Pel, A Programming Language for Orchestrating AI Agents https://arxiv.org/abs/2505.13453
[3] Code Smells in Elixir: Early Results from a Grey Literature Review https://dl.acm.org/doi/10.1145/3524610.3527881
[4] Fine with “1234”? An Analysis of SMS One-Time Password Randomness in Android Apps https://ieeexplore.ieee.org/document/9402042/
[5] Detecting defects in Erlang programs using static analysis https://dl.acm.org/doi/10.1145/1273920.1273926
[6] Using Static Analysis to Detect Type Errors and Concurrency Defects in Erlang Programs http://link.springer.com/10.1007/978-3-642-12251-4_2
[7] Redundancy : The Mutants ’ Elixir of Immortality https://www.semanticscholar.org/paper/141fdb666191e50be7a94a1ac277ebc7cd17202f
[8] Gradual typing of erlang programs: a wrangler experience https://dl.acm.org/doi/10.1145/1411273.1411284
[9] Steady state investigation of air intake system in automobile engine using CFD https://www.semanticscholar.org/paper/deaf541f8b6afe55da1b26e46e08469da347c709
[10] Purity in Erlang http://link.springer.com/10.1007/978-3-642-24276-2_9
[11] Code Smells in Elixir: Early Results from a Grey Literature Review https://arxiv.org/pdf/2203.08877.pdf
[12] CodeFuse-Query: A Data-Centric Static Code Analysis System for
  Large-Scale Organizations https://arxiv.org/pdf/2401.01571.pdf
[13] A Critical Comparison on Six Static Analysis Tools: Detection, Agreement, and Precision https://linkinghub.elsevier.com/retrieve/pii/S0164121222002515
[14] Deploying Static Analysis https://arxiv.org/pdf/2202.11861.pdf
[15] Integrating Static Code Analysis Toolchains http://arxiv.org/pdf/2403.05986.pdf
[16] A Critical Comparison on Six Static Analysis Tools: Detection,
  Agreement, and Precision https://arxiv.org/pdf/2101.08832.pdf
[17] Evaluation of Static Analysis Tools for Finding Vulnerabilities in Java
  and C/C++ Source Code https://arxiv.org/ftp/arxiv/papers/1805/1805.09040.pdf
[18] Scaling Symbolic Execution to Large Software Systems http://arxiv.org/pdf/2408.01909.pdf
[19] Best Static Code Analysis Tools For 2025 Compared : r/ChatGPTTutor https://www.reddit.com/r/ChatGPTTutor/comments/1jkhg5f/best_static_code_analysis_tools_for_2025_compared/
[20] The Role of the Control Flow Graph in Static Analysis - Nicolo.dev https://nicolo.dev/en/blog/role-control-flow-graph-static-analysis/
[21] Strong arrows: a new approach to gradual typing - Elixir https://elixir-lang.org/blog/2023/09/20/strong-arrows-gradual-typing/
[22] The Top 6 Best Static Code Analysis Tools of 2025 - Aikido https://www.aikido.dev/blog/static-code-analysis-tools
[23] Control-flow Graph Recovery (CFG) - angr documentation https://docs.angr.io/built-in-analyses/cfg
[24] [PDF] The Design Principles of the Elixir Type System - l'IRIF https://www.irif.fr/_media/users/gduboc/elixir-types.pdf
[25] A Guide to Process-oriented Programming in Elixir and OTP - Toptal https://www.toptal.com/elixir/process-oriented-programming-elixir-and-otp
[26] Control Flow Graph (CFG) - Software Engineering - GeeksforGeeks https://www.geeksforgeeks.org/software-engineering/software-engineering-control-flow-graph-cfg/
[27] [2408.14345] Guard Analysis and Safe Erasure Gradual Typing - arXiv https://arxiv.org/abs/2408.14345
[28] Top Static Code Analysis Software for Elixir in 2025 - Slashdot https://slashdot.org/software/static-code-analysis/for-elixir/
[29] GitHub - VahidN/awesome-static-analysis https://github.com/VahidN/awesome-static-analysis
[30] Gradual set-theoretic types — Elixir v1.20.0-dev - Hexdocs https://hexdocs.pm/elixir/main/gradual-set-theoretic-types.html
[31] Erlang OTP 28.0 Released - Elixir Forum https://elixirforum.com/t/erlang-otp-28-0-released/70967
[32] Understanding Control Flow in Elixir with Case and Cond https://elixirmerge.com/p/understanding-control-flow-in-elixir-with-case-and-cond
[33] Jose Valim: "Elixir is, officially, a gradually typed language" https://elixirforum.com/t/jose-valim-elixir-is-officially-a-gradually-typed-language/60850
[34] saleyn/erlang: Erlang/Elixir articles and projects - GitHub https://github.com/saleyn/erlang
[35] Static analysis in Elixir - how to have more static information? https://elixirforum.com/t/static-analysis-in-elixir-how-to-have-more-static-information/17347
[36] What is the latest on static/gradual typing with Elixir? - Reddit https://www.reddit.com/r/elixir/comments/1clgfmu/what_is_the_latest_on_staticgradual_typing_with/
[37] Erlang - Elixir Merge https://elixirmerge.com/tags/erlang
[38] Choosing an AST to develop a static code analyzer for Elixir? Core ... https://stackoverflow.com/questions/61143958/choosing-an-ast-to-develop-a-static-code-analyzer-for-elixir-core-erlang-or-exp
[39] Identifying Security Issues in Elixir Web Applications https://drops.dagstuhl.de/entities/document/10.4230/OASIcs.Programming.2025.22
[40] Evaluation of solvency assessment systems to improve the solvency system in Iran https://www.semanticscholar.org/paper/ab794cb3b6a1121081bc098563aeb5c023e0e40f
[41] Nutritional Status of Selected Gastrointestinal Cancer Patients in Coimbatore , India https://www.semanticscholar.org/paper/bdf286dd332c3b7c689cc3e24dfaa4986ce15d36
[42] Effects of cash flow Management on Financial Performance of Small and Medium Enterprise in Mogadishu Somalia (A case study of bakara market) https://www.semanticscholar.org/paper/f64a87c6c8f635a21d7de5c6b60d3c12acc29481
[43] Implementing and Executing Static Analysis Using LLVM and CodeChecker http://arxiv.org/pdf/2408.05657.pdf
[44] The Design Principles of the Elixir Type System https://arxiv.org/pdf/2306.06391.pdf
[45] Guard Analysis and Safe Erasure Gradual Typing: a Type System for Elixir http://arxiv.org/pdf/2408.14345.pdf
[46] Debugging Static Analysis http://arxiv.org/pdf/1801.04894v1.pdf
[47] Writing a Custom Credo Check in Elixir | AppSignal Blog https://blog.appsignal.com/2023/08/29/writing-a-custom-credo-check-in-elixir.html
[48] Getting Started with Dialyzer in Elixir - AppSignal Blog https://blog.appsignal.com/2025/03/18/getting-started-with-dialyzer-in-elixir.html
[49] Elixir Update & Q&A - José Valim | ElixirConf US 2025 - YouTube https://www.youtube.com/watch?v=BUOTLZOyLvc
[50] Credo download | SourceForge.net https://sourceforge.net/projects/credo.mirror/
[51] Comparison of Erlang type checkers: Dialyzer, ETC, and Gradualizer https://github.com/erszcz/erlang-type-checker-comparison
[52] Thinking Elixir Podcast 276: Elixir v1.19 Types and Speed - YouTube https://www.youtube.com/watch?v=1-3mqnXgqZE
[53] rrrene/credo: A static code analysis tool for the Elixir ... - GitHub https://github.com/rrrene/credo
[54] Dialyzer is a DIscrepancy AnaLYZer for ERlang programs. https://manpages.ubuntu.com/manpages/plucky/man1/dialyzer.1.html
[55] Keynoyte: Type System and Elixir Updates + Extended Q&A - YouTube https://www.youtube.com/watch?v=po-ckmSt1gI
[56] Overview — Credo v1.7.13 - Hexdocs https://hexdocs.pm/credo/overview.html
[57] Type Specifications and Erlang https://learnyousomeerlang.com/dialyzer
[58] Type System and Elixir Updates + Extended Q&A - José Valim https://elixirforum.com/t/keynote-type-system-and-elixir-updates-extended-q-a-jose-valim-elixirconf-eu-2025/71054
[59] 6 Best Elixir Static Analysis Tools 2024 - Daily.dev https://daily.dev/blog/6-best-elixir-static-analysis-tools-2024
[60] Common dialyzer errors and solutions in Erlang - Grant Winney https://grantwinney.com/common-dialyzer-errors-and-solutions-in-erlang/
[61] Elixir v1.19 released: enhanced type checking and up to 4x faster ... https://elixir-lang.org/blog/2025/10/16/elixir-v1-19-0-released/
[62] Credo - rrrene · https://rrrene.org/topics/credo/
[63] Type-checking Erlang and Elixir https://www.erlang-solutions.com/blog/type-checking-erlang-and-elixir/
[64] Type System and Elixir Updates + Extended Q&A - José Valim - Reddit https://www.reddit.com/r/elixir/comments/1kxk7pk/keynote_type_system_and_elixir_updates_extended/
[65] Elixir (and Phoenix) Static Code Analysis with Credo - YouTube https://www.youtube.com/watch?v=29RhlNt5qEc
[66] dialyzer v5.4 - Erlang https://www.erlang.org/doc/apps/dialyzer/dialyzer_chapter.html
[67] Same Same but Different: A Comparative Analysis of Static Type Checkers in Erlang https://dl.acm.org/doi/10.1145/3677995.3678189
[68] Computational Analysis of a Towed Jumper During Static Line Airborne Operations: A Parametric Study Using Various Airdrop Configurations https://arc.aiaa.org/doi/10.2514/6.2025-3504
[69] A Polyvariant Type Analysis for Erlang https://www.semanticscholar.org/paper/5c52a0dd4089f32c8b3ba0ae16e2164853aa2b00
[70] Static Analysis Based Support for Program Comprehension in Erlang http://www.aei.tuke.sk/papers/2011/3/01_T%C3%B3th.pdf
[71] Static analysis of communications for Erlang https://www.semanticscholar.org/paper/115fb7634405e0245c74409ee02a7b958be1186b
[72] Static Analysis of Complex Software Systems Implemented in Erlang http://link.springer.com/10.1007/978-3-642-32096-5_9
[73] Dynamic rate Erlang-A queues http://link.springer.com/10.1007/s11134-018-9581-2
[74] Set-theoretic Types for Erlang https://arxiv.org/pdf/2302.12783.pdf
[75] Detecting Oxbow Code in Erlang Codebases with the Highest Degree of
  Certainty https://arxiv.org/pdf/2107.08699.pdf
[76] Scaling Reliably: Improving the Scalability of the Erlang Distributed
  Actor Platform https://arxiv.org/pdf/1704.07234.pdf
[77] Modular Information Flow through Ownership https://arxiv.org/pdf/2111.13662.pdf
[78] Functional Federated Learning in Erlang (ffl-erl) http://arxiv.org/pdf/1808.08143.pdf
[79] Type-level Property Based Testing https://arxiv.org/html/2407.12726v1
[80] Erlang-Runtime Statically-Typed Functional Language Gleam ... https://www.infoq.com/news/2024/03/gleam-erlang-virtual-machine-1-0/
[81] Fraunhofer-AISEC/cpg: A library to extract Code Property Graphs ... https://github.com/Fraunhofer-AISEC/cpg
[82] Inspect intermediate representations of code - Elixir Forum https://elixirforum.com/t/inspect-intermediate-representations-of-code/32858
[83] Gleam, a statically typed language for the Erlang VM - Elixir Forum https://elixirforum.com/t/gleam-a-statically-typed-language-for-the-erlang-vm/20349
[84] Code Property Graph Specification 1.1 - Joern https://cpg.joern.io
[85] Introduction to SSA - Erlang/OTP https://www.erlang.org/blog/introducing-ssa/
[86] Gleam: The New Functional Language Developers Actually Want to ... https://pullflow.com/blog/gleam-functional-language-developers-actually-want-to-use/
[87] An Intro to the Code Property Graph - CoderPad https://coderpad.io/blog/development/code-property-graph-oriented-databases-source-code-analysis/
[88] The Core of Erlang | 8th Light https://8thlight.com/insights/the-core-of-erlang
[89] Thinking Elixir Podcast 23: Gleam and Static Types with Louis Pilfold https://podcast.thinkingelixir.com/23
[90] Home - Code Property Graph - GitHub Pages https://fraunhofer-aisec.github.io/cpg/
[91] Core Erlang: Why have <e_1,...,e_n>? https://erlangforums.com/t/core-erlang-why-have-e-1-e-n/3421
[92] LLVM meets Code Property Graphs https://blog.llvm.org/posts/2021-02-23-llvm-meets-code-property-graphs/
[93] A Gentle Introduction to Core Erlang: Part 2 https://baha.github.io/intro-core-erlang-2/
[94] v0.11 of Gleam, a statically typed language for the Erlang VM, is out https://www.reddit.com/r/elixir/comments/ii7k5x/v011_of_gleam_a_statically_typed_language_for_the/
[95] ShiftLeftSecurity/codepropertygraph: Code Property Graph - GitHub https://github.com/ShiftLeftSecurity/codepropertygraph
[96] The Road to the JIT - Erlang/OTP https://www.erlang.org/blog/the-road-to-the-jit/
[97] Context aware compilation | Gleam programming language https://gleam.run/news/context-aware-compilation/
[98] Storing system information in a graph database? - Elixir Forum https://elixirforum.com/t/storing-system-information-in-a-graph-database/54159
[99] Transformation-based implementation of S-expression based C languages https://www.semanticscholar.org/paper/0b106d5e5296e5d9011fc2810544bccf8eb26891
[100] Annotated imports https://www.semanticscholar.org/paper/6267d2b6c62abf43218f63b8af7bc0a437804f0e
[101] A Literature Review of Clone Detection Analysis https://www.semanticscholar.org/paper/d4f938f9c1f39dfd8396516859b82032aa4758cf
[102] CSA-Trans: Code Structure Aware Transformer for AST https://arxiv.org/pdf/2404.05767.pdf
[103] AST-Transformer: Encoding Abstract Syntax Trees Efficiently for Code
  Summarization https://arxiv.org/pdf/2112.01184.pdf
[104] CAST: Enhancing Code Summarization with Hierarchical Splitting and
  Reconstruction of Abstract Syntax Trees https://arxiv.org/pdf/2108.12987.pdf
[105] Towards Code Watermarking with Dual-Channel Transformations https://arxiv.org/pdf/2309.00860.pdf
[106] Transform Dialect Tutorial http://arxiv.org/pdf/2404.19350.pdf
[107] Fast, Flexible, and Declarative Construction of Abstract Syntax Trees
  with PEGs http://arxiv.org/pdf/1507.08610.pdf
[108] Code Completion by Modeling Flattened Abstract Syntax Trees as Graphs https://arxiv.org/pdf/2103.09499.pdf
[109] Deriving program transformations by demonstration http://arxiv.org/pdf/1301.4334.pdf
[110] A deep dive into the Elixir AST https://dorgan.ar/posts/2021/04/the_elixir_ast/
[111] [PDF] Master Thesis - Institute for Computing and Information Sciences https://www.cs.ru.nl/masters-theses/2010/E_Jumpertz___Using_QuickCheck_and_semantic_analysis_to_verify_correctness_of_Erlang_refactoring_transformations.pdf
[112] esl/gradient: Gradient is a static typechecker for Elixir - GitHub https://github.com/esl/gradient
[113] The minimum knowledge you need to start Metaprogramming in Elixir https://dockyard.com/blog/2016/08/16/the-minumum-knowledge-you-need-to-start-metaprogramming-in-elixir
[114] [PDF] RefactorErl: a source code analyser and ... - Erlang Factory https://www.erlang-factory.com/upload/presentations/291/melinda_RefactorErl_euc10.pdf
[115] josefs/Gradualizer: A Gradual type system for Erlang - GitHub https://github.com/josefs/Gradualizer
[116] Compile-time work with Elixir macros - Andrea Leopardi https://andrealeopardi.com/posts/compile-time-work-with-elixir-macros/
[117] SemanticQuery – RefactorErl - ELTE http://pnyf.inf.elte.hu/trac/refactorerl/wiki/SemanticQuery
[118] Macro — Elixir v1.20.0-dev - Hexdocs https://hexdocs.pm/elixir/main/Macro.html
[119] SemanticQuery/Examples – RefactorErl - ELTE http://pnyf.inf.elte.hu/trac/refactorerl/wiki/SemanticQuery/Examples
[120] Gradualizer - an experimental static type checker for Erlang (0.3.0 ... https://erlangforums.com/t/gradualizer-an-experimental-static-type-checker-for-erlang-0-3-0-just-out/2158
[121] A script for re-writing AST: where to start? - Elixir Forum https://elixirforum.com/t/a-script-for-re-writing-ast-where-to-start/54247
[122] Check your code with RefactorErl! | Melinda Tóth https://www.codesync.global/media/check-your-code-with-refactorerl-melinda-to-th/
[123] What's new in Gradualizer: Type checking Erlang and Elixir - YouTube https://www.youtube.com/watch?v=0Oo8ZBAsKVs
[124] Elixir Macros Guide: Metaprogramming Made Simple - Curiosum https://www.curiosum.com/blog/elixir-trickery-using-macros-metaprogramming
[125] [PDF] RefactorErl: a source code analyser and transformer tool https://www.erlang-factory.com/upload/presentations/321/tutorial10.pdf
[126] Overview — gradualizer v0.2.0 - Hexdocs https://hexdocs.pm/gradualizer/
[127] Understanding Elixir Macros, Part 1 - Basics - The Erlangelist https://www.theerlangelist.com/article/macros_1
[128] [PDF] Building a Refactoring Tool for Erlang* https://scg.unibe.ch/download/wasdett/wasdett2008-paper12.pdf
[129] Generalized instruction selection using SSA-graphs https://dl.acm.org/doi/10.1145/1375657.1375663
[130] Using Rewriting Logic to Match Patterns of Instructions from a Compiler Intermediate Form to Coarse-Grained Processing Elements http://ieeexplore.ieee.org/document/4228097/
[131] Fast Mapping-Based High-Level Synthesis of Pipelined Circuits https://ieeexplore.ieee.org/document/8697596/
[132] Pointer-Based Divergence Analysis for OpenCL 2.0 Programs https://dl.acm.org/doi/10.1145/3470644
[133] The Synchronization Treatment in Implementing Data-Parallel Programming Languages on CPUs http://ieeexplore.ieee.org/document/6832158/
[134] The Denotational Semantics of SSA http://arxiv.org/pdf/2411.09347.pdf
[135] Structural Operational Semantics for Control Flow Graph Machines https://arxiv.org/pdf/1805.05400.pdf
[136] Lambda the Ultimate SSA: Optimizing Functional Programs in SSA https://arxiv.org/pdf/2201.07272.pdf
[137] A Comparison of Big-step Semantics Definition Styles https://arxiv.org/pdf/2011.10373.pdf
[138] A Frame Stack Semantics for Sequential Core Erlang http://arxiv.org/pdf/2308.12403.pdf
[139] Verifying Peephole Rewriting In SSA Compiler IRs http://arxiv.org/pdf/2407.03685.pdf
[140] Non-Parametric Representation Learning with Kernels http://arxiv.org/pdf/2309.02028.pdf
[141] A deep dive into the Elixir AST: Building a static code analyzer https://dorgan.ar/posts/2021/04/the_elixir_ast_analyzer/
[142] scout119/beamdasm: Erlang\Elixir byte code viewer. BEAM ... - GitHub https://github.com/scout119/beamdasm
[143] SSA History - Erlang/OTP https://www.erlang.org/blog/ssa-history/
[144] Erlang -- dialyzer https://www.erlang.org/docs/17/man/dialyzer
[145] Static single-assignment form - Wikipedia https://en.wikipedia.org/wiki/Static_single-assignment_form
[146] lucasvegi/Elixir-Refactorings: Catalog of Elixir Refactorings - GitHub https://github.com/lucasvegi/Elixir-Refactorings
[147] Dialyxir download | SourceForge.net https://sourceforge.net/projects/dialyxir.mirror/
[148] [PDF] Modern Intermediate Representations (IR) - LLVM https://llvm.org/devmtg/2017-06/1-Davis-Chisnall-LLVM-2017.pdf
[149] Dilating GitHub Actions using Dialyzer - Massdriver https://www.massdriver.cloud/blogs/dilating-github-actions-using-dialyzer
[150] [PDF] Recovering Erlang AST from BEAM bytecode http://www.erlang-factory.com/static/upload/media/14979662117233382melindatothwhatwefoundinthebeamcode.pdf
[151] [PDF] Comparison of Compiler's Intermediate Representations and Input ... https://hps.vi4io.org/_media/research/theses/raul_torres_comparison_of_compiler_s_intermediate_representations_and_input_output_access_patterns_with_string_kernels.pdf
[152] szTheory/beamtoolbox: Curated BEAM language libraries by category https://github.com/szTheory/beamtoolbox
[153] The Optimizations in Erlang/OTP 27 https://www.erlang.org/blog/optimizations/
[154] Code — Elixir v1.20.0-dev - Hexdocs https://hexdocs.pm/elixir/main/Code.html
[155] Erlang -- dialyzer https://www.erlang.org/docs/26/man/dialyzer
[156] Erlang/OTP 22.0 https://www.erlang.org/patches/otp-22.0
[157] Customizing Credo for Enhanced Code Analysis in Elixir https://elixirmerge.com/p/customizing-credo-for-enhanced-code-analysis-in-elixir
[158] The Design Principles of the Elixir Type System https://programming-journal.org/2024/8/4
[159] A Gradual Type System for Elixir https://dl.acm.org/doi/10.1145/3427081.3427084
[160] Honey Potion: An eBPF Backend for Elixir https://dl.acm.org/doi/10.1145/3696443.3708923
[161] Session types in Elixir https://dl.acm.org/doi/10.1145/3486601.3486708
[162] A Microbial metabolism resource for Systems Biology: Shared semantic standards for reference data types (ELIXIR Implementation Study Deliverable Report) https://f1000research.com/documents/7-1369
[163] Privacy-Respecting Type Error Telemetry at Scale https://programming-journal.org/2024/8/12
[164] Special Delivery: Programming with Mailbox Types https://dl.acm.org/doi/10.1145/3607832
[165] Enhancing RDM in Galaxy by integrating RO-Crate https://riojournal.com/article/95164/
[166] Review of Lean Manufacturing Implementation in Textile Industry https://www.semanticscholar.org/paper/9269ad2eec28cb323da610bd53657125b119b213
[167] Dependent Session Types https://www.semanticscholar.org/paper/4093e3faa5312f3200424094e1b83dadda407824
[168] A Gradual Type System for Elixir https://arxiv.org/abs/2104.08366v1
[169] Session Fidelity for ElixirST: A Session-Based Type System for Elixir
  Modules https://arxiv.org/abs/2208.04631v1
[170] From ML to Ada: Strongly-typed language interoperability via source translation https://www.cambridge.org/core/services/aop-cambridge-core/content/view/S0956796898003086
[171] Dynamic Program Slices Change How Developers Diagnose Gradual Run-Time
  Type Errors http://arxiv.org/pdf/2502.20533.pdf
[172] Teaching Type Systems Implementation with Stella, an Extensible
  Statically Typed Programming Language https://arxiv.org/pdf/2407.08089.pdf
[173] Persimmon: Nested Family Polymorphism with Extensible Variant Types https://dl.acm.org/doi/pdf/10.1145/3649836
[174] [PDF] 3 A Logical Approach to Deciding Semantic Subtyping - Tyrex http://tyrex.inria.fr/publications/toplas15.pdf
[175] Metaprogramming in Elixir - Ada Beat https://adabeat.com/fp/metaprogramming-in-elixir/
[176] Gradual set-theoretic types — Elixir v1.19.1 - Hexdocs https://hexdocs.pm/elixir/gradual-set-theoretic-types.html
[177] A Logical Approach to Deciding Semantic Subtyping https://dl.acm.org/doi/10.1145/2812805
[178] Elixir Meta-programming Guide - Macros - YouTube https://www.youtube.com/watch?v=I0ZM-n_7fZM
[179] Down and Dirty with Semantic Set-theoretic Types (a tutorial) v0.4 https://pnwamk.github.io/sst-tutorial/
[180] Elixir v1.19 released: enhanced type checking, broader type ... - Reddit https://www.reddit.com/r/elixir/comments/1o80wfm/elixir_v119_released_enhanced_type_checking/
[181] [PDF] A Gentle Introduction to Semantic Subtyping - l'IRIF https://www.irif.fr/~gc/papers/icalp-ppdp05.pdf
[182] Metaprogramming - Elixir School https://elixirschool.com/en/lessons/advanced/metaprogramming
[183] Elixir v1.19.0-rc.1 released https://elixirforum.com/t/elixir-v1-19-0-rc-1-released/72781
[184] [PDF] A Gentle Introduction to Semantic Subtyping - ℂDuce https://www.cduce.org/papers/gentle.pdf
[185] Meta-programming anti-patterns — Elixir v1.19.1 - Hexdocs https://hexdocs.pm/elixir/macro-anti-patterns.html
[186] Set Theoretic Types in Elixir with José Valim - Reddit https://www.reddit.com/r/elixir/comments/1lwl9we/set_theoretic_types_in_elixir_with_jos%C3%A9_valim/
[187] [PDF] A Gentle Introduction to Semantic Subtyping - l'IRIF https://www.irif.fr/~gc/slides/icalp-ppdp05-slides.pdf
[188] [PDF] Guard Analysis and Safe Erasure Gradual Typing - l'IRIF https://www.irif.fr/~gc/papers/elixir-type-system.pdf
[189] Semantic subtyping for imperative object-oriented languages https://dl.acm.org/doi/10.1145/3022671.2983992
