---
source: ennaos mutable-code-comprehension — landscape map, TST perspective (research output)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy; Elixir-specific research output)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/mutable-code-comprehension/accelerating-elixir-ai-agent-dev.md
source_commit: 5abb2fe
categories: [landscape-map, agent-velocity, TST-perspective, elixir-specific, background-research]
why_included: >
  Companion landscape map framed through Temporal Software Theory — durable AI agents and development velocity.
  Elixir/OTP-specific; kept as commit-pinned background for the "make the codebase legible to agents fast"
  demand-thesis that recurs across this whole section.
---



# **A Landscape Map for Accelerating AI Agent Development in Elixir/OTP: A Temporal Software Theory Perspective**

## **Introduction: The Challenge of Durable AI Agents and Development Velocity**

The proliferation of advanced AI agents has introduced a new class of software architecture that merges the concerns of machine learning with those of complex, stateful, long-running distributed systems. These agents are not merely stateless models processing inputs; they are durable entities that must maintain context, manage state over extended periods, and recover gracefully from failures. The Elixir programming language, built upon the Erlang Open Telecom Platform (OTP), presents a compelling foundation for such systems. Its core principles—lightweight, isolated processes, fault-tolerance through supervision, and inherent concurrency—provide a natural substrate for building robust, scalable agent architectures.1  
However, building these systems efficiently requires a rigorous analytical framework. Temporal Software Theory (TST) offers such a framework, positing that reliable applications are best constructed by making business logic inherently durable and recoverable.3 TST decomposes application logic into two primary constructs: **Workflows**, which orchestrate long-running, stateful processes with guaranteed execution, and **Activities**, which encapsulate failure-prone interactions with the external world (e.g., API calls, database transactions) and are subject to robust retry policies.3  
This report evaluates strategies for accelerating AI agent development in Elixir/OTP through the lens of TST. Development velocity is assessed against a set of core TST-aligned metrics:

* **Durability and State Management:** The ease with which an agent's state can be preserved and managed across failures and long-running executions.  
* **Failure Handling:** The cognitive load and boilerplate required to implement robust error handling, retries, and compensation logic.  
* **Observability and Debugging:** The transparency of an agent's execution history and current state, crucial for diagnostics.  
* **Composability and Modularity:** The ability to decompose agent logic into verifiable, reusable components.

The central research question is: **Which architectural and tooling strategies for Elixir/OTP codebases best align with TST principles to maximize AI agent development velocity?** This investigation explores two primary avenues. The first is the hypothesis of a novel 'alt-state' intermediate representation (IR)—a comprehensive, queryable graph of the codebase—that could unlock new forms of automated analysis and tooling. The second explores alternative paths that leverage higher-level abstractions, such as declarative frameworks and neuro-symbolic models, to achieve similar goals without requiring a low-level IR.

## **Part I: The 'Alt-State' Intermediate Representation Hypothesis**

This section investigates the feasibility and potential impact of creating a novel, graph-based intermediate representation for Elixir/OTP codebases. The central hypothesis is that a unified, queryable model of a program's structure and semantics can enable powerful new forms of analysis and tooling, thereby directly accelerating the development of TST-compliant AI agents.

### **1.1 Foundations: The Anatomy of an Elixir/OTP Program and its Representations**

Understanding the potential for a new IR requires first understanding the existing compilation pipeline and the inherent nature of OTP applications.

#### **The BEAM Compilation Pipeline**

Elixir and Erlang code undergoes a multi-stage transformation before execution on the BEAM virtual machine. Elixir source code is first compiled into an Erlang Abstract Syntax Tree, known as the Erlang Abstract Format.4 This AST is then converted into **Core Erlang**, a crucial intermediate representation used by the compiler for a wide range of optimizations and program analyses.4 Finally, after these transformations, Core Erlang is compiled into BEAM bytecode for execution.5

#### **Core Erlang as a Potential Source**

Core Erlang presents itself as a strong candidate for programmatic analysis due to several key characteristics. It is human-readable plain text, unlike binary BEAM files, and its syntax is a simplified, more explicit subset of Erlang.6 This simplicity, which includes features like fully qualified function calls and pattern matching being restricted to case statements, makes it well-suited for programmatic generation and analysis.6  
However, leveraging Core Erlang is not without significant risk. There is no official, up-to-date specification; the most reliable reference is the compiler's source code itself.4 Furthermore, error messages when compiling malformed Core Erlang can be unhelpful, and there are subtle semantic differences from source Elixir that can trap tool builders, such as the strict distinction between literals and expressions.6

#### **The Challenge of Representing OTP Dynamics**

The most fundamental challenge for any static representation of an Elixir/OTP application is that OTP's core abstractions are inherently *runtime* concepts. The supervision tree, a hierarchical arrangement of worker and supervisor processes, is the cornerstone of OTP's fault tolerance.7 This tree is often constructed dynamically. Processes can be started by dynamic supervisors in response to runtime events, registered under names computed at runtime, and communicate via messages sent to PIDs that are only known after a process is spawned.1  
This dynamism means that a purely static analysis of the source code can only ever produce an incomplete approximation of the system's true architecture and communication patterns. The gap between the static code and the dynamic process graph is a central and unavoidable challenge for the 'alt-state' IR hypothesis.

### **1.2 Code Property Graphs (CPGs) as a Candidate 'Alt-State' IR**

A Code Property Graph (CPG) is a promising model for a unified 'alt-state' IR. It is a data structure specifically designed to merge multiple classic program representations into a single, queryable graph.8

#### **The CPG Model**

A CPG is formally a directed, edge-labeled, attributed multigraph.8 It integrates the following views of a program:

* **Abstract Syntax Tree (AST):** Represents the syntactic structure of the code.  
* **Control Flow Graph (CFG):** Represents the order in which statements are executed.  
* **Data Flow Graph (DFG):** Represents the flow of data between variables and function calls.

The power of the CPG lies in its ability to support queries that seamlessly traverse between these different representations. For example, a query could start at a function call in the AST, follow a data-flow edge to trace an argument's origin, and then follow control-flow edges to understand the conditions under which that function is called.8

#### **Modeling Elixir/OTP in a CPG**

Mapping Elixir/OTP constructs onto a CPG would involve representing program elements as nodes and their relationships as edges:

* **Nodes:** Could represent modules, functions (identified by name/arity), GenServer state records, supervisor child specifications, Ecto schemas, and even individual expressions.8  
* **Edges:** Would represent a rich set of relationships, such as CALLS (function-to-function), DEFINES (module-to-function), SPAWNS (a function starting a new process), SUPERVISES (a supervisor's relationship to its children), and SENDS\_MESSAGE (an inferred data-flow link for message passing).10

While no off-the-shelf CPG generators exist for Elixir, the concept has been discussed within the community, and the general approach of representing code in graph databases for analysis is well-established in other ecosystems.10

### **1.3 Implementation Pathways and Ecosystem Analysis**

Building a CPG for Elixir would involve a multi-step process leveraging various tools from the ecosystem.

1. **Parsing and AST Generation:** The process would begin by parsing Elixir source code into an AST. The Tree-sitter parser generator is an excellent candidate for this task. Its design goals of being fast enough for keystroke-level parsing and robust enough to handle syntax errors make it ideal for integration into developer tools like IDEs.14  
2. **Graph Construction and Storage:** The AST forms the structural backbone of the CPG. This graph could be stored and manipulated using OTP's native :digraph module, which is backed by highly efficient in-memory ETS tables.11 Alternatively, for larger codebases or more complex query needs, an external graph database like Neo4j could be used, accessed via mature Elixir client libraries that support query languages like Cypher and Gremlin.16  
3. **Semantic Enrichment:** A raw AST is insufficient; it must be enriched with semantic information to become a true CPG. This crucial step can be accomplished through a combination of techniques:  
   * **Core Erlang Analysis:** Analyzing the compiled Core Erlang output can reveal data flow and control flow information that is implicit in the source code.6  
   * **Language Server Protocol (LSP):** The official Elixir Language Server (Expert, formerly ElixirLS) already performs deep symbolic analysis to power features like "go-to-definition" and "find references".19 This existing infrastructure could be leveraged to resolve symbols and build semantic edges in the graph.  
   * **Set-Theoretic Type System:** A significant enabler for a CPG is Elixir's new gradual set-theoretic type system, introduced in version 1.17.21 The compiler can now infer precise types for constructs like maps and structs within a function.24 This type information can be attached as properties to nodes and edges in the CPG, dramatically increasing the precision of data-flow analysis. Instead of tracking a generic "variable," the CPG could track the flow of a %User{} struct, enabling far more powerful and specific queries. This development significantly de-risks and enhances the potential of a CPG project by offloading the complex task of type inference to the official compiler.

### **1.4 Evaluation of the CPG Approach**

An 'alt-state' IR in the form of a CPG must be evaluated against its potential to accelerate TST-aligned development.

* **TST Alignment (High):** A CPG would enable powerful, whole-program static analysis to verify properties of TST Workflows and Activities. For example, a developer could write a query to find all Activities that call non-idempotent database operations or to trace the flow of unencrypted sensitive data through a Workflow. This aligns directly with TST's emphasis on durability, security, and correctness.3  
* **Ecosystem Maturity (Low-Medium):** The Elixir ecosystem provides strong foundational components, including excellent graph libraries and parsers.14 However, a production-grade CPG frontend for Elixir does not exist and would need to be built from scratch.  
* **Implementation Risk (High):** The primary risk is the fundamental difficulty of accurately modeling OTP's dynamic, concurrent behavior in a static graph. For instance, statically determining the recipient of a send/2 call is often undecidable, making data-flow analysis for message passing a best-effort approximation at best. This is a well-known, challenging problem in computer science.

## **Part II: Alternative Pathways to Accelerated Development**

This section explores strategies that aim to achieve the goals of TST alignment and enhanced development velocity without incurring the high cost and risk associated with building a novel, low-level intermediate representation. These alternatives focus on leveraging higher-level abstractions that are already present or emerging in the Elixir ecosystem.

### **2.1 Declarative Frameworks as High-Level, Human-Writable IRs**

Instead of creating a new machine-centric IR, an alternative approach is to view existing declarative frameworks as high-level, human-writable IRs that capture business logic and intent.

#### **The Ash Framework: A Declarative DSL for Business Logic**

The Ash framework is more than a web framework; it can be understood as a powerful, declarative Domain-Specific Language (DSL) for defining an application's core domain model and business logic.25 Ash resources provide a structured way to declare data entities, attributes, relationships, calculations, validations, and actions in a single, coherent unit.26 This declarative model abstracts away the vast amount of imperative boilerplate code that developers would otherwise need to write, such as Ecto queries, changeset functions, and context modules.28

#### **Mapping Ash to TST**

The abstractions provided by Ash map remarkably well to the concepts of Temporal Software Theory:

* **Ash Actions as TST Activities:** An Ash action, such as :create or a custom action like :approve\_post, serves as a perfect analogue for a TST Activity. It represents a self-contained, often transactional, unit of work with clearly defined inputs (arguments) and outputs. Ash's first-class support for validations, authorization policies, and side-effect-handling preparations provides a robust foundation for implementing secure and correct TST Activities.3  
* **Ash as a "Durability Engine":** By allowing developers to define *what* a state change should accomplish (e.g., "create a user with these attributes") rather than *how* to perform it (the sequence of database calls and checks), Ash simplifies the logic that needs to be made durable within a TST Workflow. This reduces the cognitive load on the developer, allowing them to focus on the orchestration logic of the Workflow itself.25

#### **Ecto Changesets: A Primitive for Composable State Transformation**

At a more granular level, the Ecto.Changeset data structure provides a functional primitive for composing and validating state transitions.29 A changeset is a pipeline that takes raw input data, casts it against a schema, applies a series of validation rules, and prepares a structured set of changes for persistence.30 This aligns perfectly with the TST goal of managing state changes in a predictable and safe manner. The functional composability of changesets allows developers to build up complex yet verifiable state manipulations within their Activities, for example, by chaining multiple transformation functions together to handle dependent fields or complex business rules.31

#### **Evaluation**

* **TST Alignment (High):** Declarative frameworks directly address the complexity of implementing TST Activities. They provide a high-level, safe, and composable abstraction for state management, which is the core of most Activity logic.  
* **Ecosystem Maturity (High):** Ash and Ecto are mature, well-documented, and widely adopted libraries with strong community support. They represent established best practices within the Elixir ecosystem.26  
* **Implementation Risk (Low):** This approach relies on adopting and integrating existing, battle-tested abstractions rather than undertaking novel and unproven research and development.

Furthermore, these declarative frameworks offer a significant secondary benefit. Because Ash resources provide a highly structured, machine-readable definition of an application's domain model, they serve as a form of "ground truth" specification.25 This explicit declaration of intent is far easier to parse and analyze than arbitrary imperative Elixir code, where the logic is hidden within function bodies. Consequently, instead of attempting to build a CPG from complex, raw source code, one could generate a CPG *from the Ash resources themselves*. This would be a vastly simpler and more accurate undertaking, as the semantic intent is already captured in the DSL. This positions declarative frameworks not merely as an alternative to a CPG, but as a potential *enabler* of a more tractable and powerful analytical model.

### **2.2 Neuro-Symbolic Models for Code Intelligence and Synthesis**

A third, more forward-looking pathway involves the application of neuro-symbolic AI to the problem of code generation and understanding.

#### **Bridging Neural Intuition and Symbolic Rigor**

Neuro-symbolic AI is a hybrid approach that seeks to combine the pattern-recognition and generative capabilities of neural networks (like Large Language Models) with the logical precision and verifiability of symbolic systems.34 Code is an ideal domain for this approach because it possesses both statistical properties (idiomatic patterns, common variable names) and rigid symbolic rules (syntax, type systems, semantics).

#### **Applying Kautz's Taxonomy to Elixir Development**

Henry Kautz's taxonomy of neuro-symbolic architectures provides a useful framework for envisioning how this hybrid approach could accelerate Elixir agent development 34:

* **Symbolic\[Neural\]:** A symbolic tool, such as a property-based test generator or a static analyzer, could use a neural model to guide its search. For instance, a fuzzer testing a GenServer could use an LLM to generate inputs that are more likely to trigger interesting edge cases based on the function signatures and documentation, rather than relying on purely random generation.  
* **Neural: Symbolic → Neural:** A symbolic analysis of an Elixir codebase—perhaps by parsing Ash resources or querying a CPG—could be used to generate a high-quality, curated dataset of code-description pairs. This dataset could then be used to fine-tune an LLM specifically for generating durable, idiomatic Elixir agent code, using symbolic rigor to create superior training data.37  
* **Neural (The Most Promising Path):** This architecture involves an LLM-based assistant (Neural) that interacts with a developer but grounds its responses in a symbolic reasoning engine (Symbolic). Instead of naively generating code and hallucinating APIs, the LLM would query a trusted symbolic source for context. This source could be the Elixir Language Server, the schema defined by Ash resources, or a CPG. The LLM could ask precise questions like, "What are the valid fields for a %MyApp.User{} struct?" or "List the actions defined on the Post resource." By using the precise, symbolic answers to these questions, the LLM can generate code that is correct, context-aware, and far less prone to the hallucination issues that plague purely generative models.34

#### **Evaluation**

* **TST Alignment (Very High \- Theoretical):** The ultimate vision for this approach is an AI agent that can reason about high-level durability requirements (e.g., "this operation must be idempotent," "this multi-step process must be compensatable") and automatically synthesize the correct OTP supervision strategies and TST Workflow/Activity patterns.  
* **Ecosystem Maturity (Very Low):** This is a frontier research area. While the individual components exist (LLMs, LSP, declarative frameworks), their integration into a coherent and effective neuro-symbolic system for Elixir development is nascent.  
* **Implementation Risk (Very High):** Realizing this vision would require a significant, multi-disciplinary R\&D effort, demanding expertise in compilers, AI/ML, and distributed systems.

## **Part III: Synthesis and The Possibility Space Landscape**

The preceding analysis reveals three distinct but interconnected pathways toward accelerating AI agent development in Elixir/OTP. This final section synthesizes these findings into a comparative landscape map, proposes a hybrid strategy that leverages the strengths of each approach, and outlines a concrete roadmap for implementation.

### **3.1 Comparative Analysis and Strategic Trade-offs**

Each strategy presents a unique profile of benefits, costs, and risks. The choice between them depends on an organization's time horizon, risk tolerance, and strategic goals. The following table provides a comparative summary to inform this decision-making process.  
**Table 3.1: Comparative Analysis of Acceleration Strategies**

| Approach | TST Alignment & Rationale | Ecosystem Maturity | Implementation Risk | Projected Impact on Dev Velocity |
| :---- | :---- | :---- | :---- | :---- |
| **'Alt-State' IR (CPG)** | **High.** Enables whole-program static analysis to verify durability properties of TST Workflows (e.g., idempotency, data flow). Foundational for deep, automated reasoning about agent behavior. | **Low-Medium.** Rich graph libraries \[16\] and parsers \[14\] exist, but a production-grade Elixir CPG frontend requires building from scratch. No off-the-shelf solution. | **High.** Accurately modeling OTP's dynamic, concurrent nature in a static graph is a known hard problem in computer science. Requires deep compiler and static analysis expertise. | **High (Long-term).** A foundational investment that would enable a new generation of powerful developer tools, but with no immediate payoff. |
| **Declarative Frameworks** | **High.** Drastically simplifies the implementation of TST Activities by abstracting state management, validation, and authorization.25 Reduces boilerplate and cognitive overhead for the most common parts of an agent's logic. | **High.** Ash and Ecto are mature, well-supported, and have strong community adoption.26 They represent established best practices. | **Low.** This path involves adopting and integrating existing, stable abstractions, not creating new, unproven technology. | **High (Short-term).** Provides immediate and significant productivity gains by allowing developers to focus on business logic rather than infrastructure. |
| **Neuro-Symbolic Models** | **Very High (Theoretical).** Potential to automate the *synthesis* of TST-compliant agent logic, translating high-level intent into durable OTP patterns. Represents a paradigm shift in development. | **Very Low.** Purely at the research and early-prototype stage. Requires integrating disparate, cutting-edge technologies.\[34, 37\] | **Very High.** A significant R\&D project requiring specialized, multi-disciplinary expertise in AI/ML, compilers, and distributed systems. | **Transformative (Very Long-term).** Could fundamentally change the developer workflow, but is a high-risk, multi-year research bet. |

### **3.2 Hybrid Strategies and Recommendations: The Optimal Path Forward**

The analysis reveals that these pathways are not mutually exclusive. In fact, their greatest potential lies in strategic combination, where each approach builds upon the strengths of the others. This leads to a powerful, phased strategy that balances short-term gains with long-term innovation.

#### **Recommendation 1: The "Declarative-First, Graph-Enhanced" Strategy**

This strategy provides a pragmatic path to achieving both immediate velocity and a foundation for future tooling.

* **Phase 1 (Immediate):** Standardize on declarative frameworks, primarily Ash and Ecto, as the core development paradigm for AI agent logic. This action yields immediate productivity improvements by reducing boilerplate and enforcing a consistent, understandable structure for TST Activities.  
* **Phase 2 (Mid-term):** Initiate a research and development effort to build a CPG generator that operates on the *declarative Ash resources* rather than raw Elixir source code. As established, this dramatically simplifies the CPG's construction and ensures its semantic accuracy. The resulting graph becomes a powerful tool for advanced verification, architectural validation, and impact analysis of the declarative model.

#### **Recommendation 2: The "AI-Augmented Declarative" Strategy**

This strategy represents the long-term vision, building directly on the foundation laid by the first recommendation.

* Develop a Neural AI assistant where the LLM's symbolic backend is a queryable API built on top of the Ash resources and the CPG generated from them.  
* The developer workflow transforms into a collaborative conversation. A developer might prompt: "Generate an Ash action to approve a user's request, ensuring it's idempotent and logs the approver's ID." The AI agent would query the Ash/CPG model for the necessary context (e.g., user schema, logging conventions) and generate high-quality, TST-aligned declarative code. This approach combines the rapid generation capabilities of AI with the correctness and rigor of declarative frameworks and symbolic verification.

This progression creates a virtuous cycle: a more expressive declarative layer enables a richer symbolic model, which in turn provides better grounding for a more intelligent and reliable AI development partner. The output of this AI partner is more high-quality declarative code, which feeds back into the system, continuously improving the symbolic model and the AI's capabilities. This flywheel effect represents a unified theory for achieving sustained, long-term acceleration in development velocity.

### **3.3 A Strategic Roadmap for Implementation**

A phased implementation allows for incremental investment and value delivery.

* **Quarters 1-2: Foundational Adoption.**  
  * **Action:** Focus on team-wide training and migration to a declarative-first approach using Ash and Ecto.  
  * **Goal:** Establish best practices for modeling agent logic as resources and actions. Measure initial productivity gains in terms of reduced boilerplate and faster feature implementation.  
* **Quarters 3-4: Prototyping the Symbolic Backend.**  
  * **Action:** Launch a focused R\&D project to build a prototype CPG generator that ingests Ash resources.  
  * **Goal:** Define and implement a core query API for this graph that can answer foundational architectural questions (e.g., "What actions modify the balance attribute of the Account resource?").  
* **Quarters 5-8: Developing the Neuro-Symbolic Interface.**  
  * **Action:** Begin experiments with fine-tuning LLMs on the existing declarative codebase. Build a prototype Neural tool that integrates an LLM with the CPG's query API and the Elixir Language Server.  
  * **Goal:** Create a developer assistant capable of answering contextual questions and generating correct, declarative code snippets.  
* **Beyond:**  
  * **Action:** Evolve the neuro-symbolic tool from a developer assistant to a more autonomous agent.  
  * **Goal:** Develop capabilities for suggesting large-scale refactors, generating entire TST Workflows from high-level descriptions, and automatically creating property-based tests based on the invariants discovered in the CPG.

#### **Works cited**

1. Elixir/OTP : Basics of processes \- Medium, accessed November 2, 2025, [https://medium.com/elemental-elixir/elixir-otp-basics-of-processes-d3437607d12b](https://medium.com/elemental-elixir/elixir-otp-basics-of-processes-d3437607d12b)  
2. Designing Elixir Systems with OTP, accessed November 2, 2025, [https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/](https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/)  
3. How the Temporal Platform Works, accessed November 2, 2025, [https://temporal.io/how-it-works](https://temporal.io/how-it-works)  
4. Scheme2Beam, accessed November 2, 2025, [https://zsisco.net/papers/Scheme2Beam.pdf](https://zsisco.net/papers/Scheme2Beam.pdf)  
5. A Peek Inside the Erlang Compiler, accessed November 2, 2025, [https://prog21.dadgum.com/127.html](https://prog21.dadgum.com/127.html)  
6. The Core of Erlang | 8th Light, accessed November 2, 2025, [https://8thlight.com/insights/the-core-of-erlang](https://8thlight.com/insights/the-core-of-erlang)  
7. Overview — Erlang System Documentation v28.1.1, accessed November 2, 2025, [https://www.erlang.org/doc/system/design\_principles.html](https://www.erlang.org/doc/system/design_principles.html)  
8. Code Property Graph | Joern Documentation, accessed November 2, 2025, [https://docs.joern.io/code-property-graph/](https://docs.joern.io/code-property-graph/)  
9. Semantic Code Graph – an information model to facilitate software comprehension \- arXiv, accessed November 2, 2025, [https://arxiv.org/html/2310.02128v2](https://arxiv.org/html/2310.02128v2)  
10. Mix OTP behaviour graph idea \- Google Groups, accessed November 2, 2025, [https://groups.google.com/g/elixir-lang-core/c/ybqm2rzPJ90/m/FQpqmVfvAAAJ](https://groups.google.com/g/elixir-lang-core/c/ybqm2rzPJ90/m/FQpqmVfvAAAJ)  
11. Storing system information in a graph database? \- Elixir Forum, accessed November 2, 2025, [https://elixirforum.com/t/storing-system-information-in-a-graph-database/54159](https://elixirforum.com/t/storing-system-information-in-a-graph-database/54159)  
12. Use of graph databases for static code analysis, accessed November 2, 2025, [https://richardg.users.greyc.fr/publis/Dauprat-All\_2022.pdf](https://richardg.users.greyc.fr/publis/Dauprat-All_2022.pdf)  
13. Application of Graph Databases for Static Code ... \- CEUR-WS.org, accessed November 2, 2025, [https://ceur-ws.org/Vol-2590/short30.pdf](https://ceur-ws.org/Vol-2590/short30.pdf)  
14. Tree-sitter: Introduction, accessed November 2, 2025, [https://tree-sitter.github.io/](https://tree-sitter.github.io/)  
15. tree-sitter-elixir \- NPM, accessed November 2, 2025, [https://www.npmjs.com/package/tree-sitter-elixir?activeTab=readme](https://www.npmjs.com/package/tree-sitter-elixir?activeTab=readme)  
16. Exploring Graphs with Elixir: Connect Data with Native Graph ..., accessed November 2, 2025, [https://pragprog.com/titles/thgraphs/exploring-graphs-with-elixir/](https://pragprog.com/titles/thgraphs/exploring-graphs-with-elixir/)  
17. Property graphs and Elixir. Accessing Neo4j from Elixir with Bolt… | by Tony Hammond | Medium, accessed November 2, 2025, [https://medium.com/@tonyhammond/property-graphs-and-elixir-13672940804b](https://medium.com/@tonyhammond/property-graphs-and-elixir-13672940804b)  
18. Graph to graph with Elixir. Moving data between semantic and… | by Tony Hammond | Medium, accessed November 2, 2025, [https://medium.com/@tonyhammond/graph-to-graph-with-elixir-9cd7fd6f2128](https://medium.com/@tonyhammond/graph-to-graph-with-elixir-9cd7fd6f2128)  
19. elixir-lsp/elixir-ls: A frontend-independent IDE "smartness ... \- GitHub, accessed November 2, 2025, [https://github.com/elixir-lsp/elixir-ls](https://github.com/elixir-lsp/elixir-ls)  
20. Announcing the official Elixir Language Server team \- The Elixir ..., accessed November 2, 2025, [https://elixir-lang.org/blog/2024/08/15/welcome-elixir-language-server-team/](https://elixir-lang.org/blog/2024/08/15/welcome-elixir-language-server-team/)  
21. Gradual set-theoretic types — Elixir v1.20.0-dev \- Hexdocs, accessed November 2, 2025, [https://hexdocs.pm/elixir/main/gradual-set-theoretic-types.html](https://hexdocs.pm/elixir/main/gradual-set-theoretic-types.html)  
22. Elixir v1.17 released: set-theoretic data types, calendar durations ..., accessed November 2, 2025, [https://elixir-lang.org/blog/2024/06/12/elixir-v1-17-0-released/](https://elixir-lang.org/blog/2024/06/12/elixir-v1-17-0-released/)  
23. The Design Principles of the Elixir Type System \- arXiv, accessed November 2, 2025, [https://arxiv.org/pdf/2306.06391](https://arxiv.org/pdf/2306.06391)  
24. Elixir \- 1.17.3 \- HexDocs, accessed November 2, 2025, [https://hexdocs.pm/elixir/1.17/Elixir.epub](https://hexdocs.pm/elixir/1.17/Elixir.epub)  
25. Everything you need to know about Ash Framework — Alembic, accessed November 2, 2025, [https://alembic.com.au/ash-framework](https://alembic.com.au/ash-framework)  
26. ash-project/ash: A declarative, extensible framework for building Elixir applications. \- GitHub, accessed November 2, 2025, [https://github.com/ash-project/ash](https://github.com/ash-project/ash)  
27. Ash 3.0: Better Together : r/elixir \- Reddit, accessed November 2, 2025, [https://www.reddit.com/r/elixir/comments/16oluw6/ash\_30\_better\_together/](https://www.reddit.com/r/elixir/comments/16oluw6/ash_30_better_together/)  
28. When Ash framework is needed? What does it replace from Phoenix framework? : r/elixir, accessed November 2, 2025, [https://www.reddit.com/r/elixir/comments/1mghwy4/when\_ash\_framework\_is\_needed\_what\_does\_it\_replace/](https://www.reddit.com/r/elixir/comments/1mghwy4/when_ash_framework_is_needed_what_does_it_replace/)  
29. Ecto.Changeset — Ecto v3.13.4 \- Hexdocs, accessed November 2, 2025, [https://hexdocs.pm/ecto/Ecto.Changeset.html](https://hexdocs.pm/ecto/Ecto.Changeset.html)  
30. Changesets · Elixir School, accessed November 2, 2025, [https://elixirschool.com/en/lessons/ecto/changesets](https://elixirschool.com/en/lessons/ecto/changesets)  
31. Reducing multiple chainable update\_all calls into a single UPDATE statement, accessed November 2, 2025, [https://stackoverflow.com/questions/44096038/reducing-multiple-chainable-update-all-calls-into-a-single-update-statement](https://stackoverflow.com/questions/44096038/reducing-multiple-chainable-update-all-calls-into-a-single-update-statement)  
32. Towards Maintainable Elixir: The Anatomy of a Core Module | by Saša Jurić | Very Big Things | Medium, accessed November 2, 2025, [https://medium.com/very-big-things/towards-maintainable-elixir-the-anatomy-of-a-core-module-b7372009ca6d](https://medium.com/very-big-things/towards-maintainable-elixir-the-anatomy-of-a-core-module-b7372009ca6d)  
33. Ecto.Repo — Ecto v3.13.4 \- Hexdocs, accessed November 2, 2025, [https://hexdocs.pm/ecto/Ecto.Repo.html](https://hexdocs.pm/ecto/Ecto.Repo.html)  
34. Neuro-symbolic AI \- Wikipedia, accessed November 2, 2025, [https://en.wikipedia.org/wiki/Neuro-symbolic\_AI](https://en.wikipedia.org/wiki/Neuro-symbolic_AI)  
35. Neurosymbolic AI: Bridging Neural Networks and Symbolic Reasoning for Smarter Systems, accessed November 2, 2025, [https://www.netguru.com/blog/neurosymbolic-ai](https://www.netguru.com/blog/neurosymbolic-ai)  
36. Neuro-Symbolic AI \- Codefinity, accessed November 2, 2025, [https://codefinity.com/blog/Neuro-Symbolic-AI](https://codefinity.com/blog/Neuro-Symbolic-AI)  
37. AI for Math: Neuro-Symbolic Auto-Formalization into Lean via Joint Embeddings \- YouTube, accessed November 2, 2025, [https://www.youtube.com/watch?v=R9E4t1yMxyc](https://www.youtube.com/watch?v=R9E4t1yMxyc)