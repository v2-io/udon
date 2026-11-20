---
source: ennaos docs/research/mutable-code-comprehension/prompt-for-research.md — breadth-first research prompt (~Nov 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/mutable-code-comprehension/prompt-for-research.md
source_commit: 5abb2fe
categories: [research-prompt, time-to-comprehension, tighter-feedback-loops, TST-grounded, exploratory]
why_included: >
  The breadth-first prompt driving the comprehension research: "Temporally Optimized Representations for Agentic
  Velocity" — reduce time-to-comprehension, tighten feedback loops, grounded in TST. Useful as a witness of how
  Joseph frames the DEMAND to a research agent (intent-over-requirements, high-temperature brainstorming) — itself
  an example of the intent-driven briefing the corpus argues for.
---

This is an excellent refinement. Shifting the focus from prescriptive requirements to exploratory brainstorming is exactly the right approach for generating a true breadth-first survey. It prevents the research from merely confirming biases and opens the aperture for novel connections.

Here is the revised research prompt artifact, incorporating a more speculative tone, emphasizing intent, adding "high-temperature" brainstorming prompts, and replacing the roadmap with a request for landscape mapping and implementation risk assessment.

---

### Revised Research Prompt Artifact (Breadth-First Exploration)

**Title:** Brainstorming Temporally Optimized Representations for Agentic Velocity in Elixir/OTP

**I. Research Objective**

We are exploring a fundamental question: How can we radically accelerate development velocity for AI agents working within Elixir/OTP codebases?

This research task is a **breadth-first exploration** of all conceivable techniques, architectures, and representations that might help achieve two primary goals:

1. **Radically Reduced Time-to-Comprehension (TTC)** for AI agents.
    
2. **Extremely Tight Feedback Loops** regarding the impact and correctness of proposed modifications.
    

We are looking for a creative, comprehensive "lay of the land." Do not prioritize feasibility yet; the goal is to map the entire possibility space, including unconventional or high-risk approaches.

**II. Grounding Theory: The TST Lens**

While the exploration should be broad, the evaluation of _why_ an approach might be useful must be grounded in Temporal Software Theory (TST), derived from the attached materials. TST provides the metrics we are hypothetically optimizing for.

_(Note to Researcher: TST in this context is a specific, unpublished framework. Rely exclusively on the provided TST definitions.)_

**Key TST Optimization Levers:**

- **Bias Toward Comprehension (T-05 & AI Turnover):** Since AI agents effectively have 100% turnover (new instance/context window), minimizing **Time-to-Comprehension (TTC)** is paramount. Incomprehensible systems are exponentially toxic.
    
- **Conceptual Alignment (T-07):** How closely does the representation align the code structure with the domain? Higher alignment = lower TTC.
    
- **Change-Set Minimization (T-08):** Does the approach reduce the amount of code/configuration that needs modification for a typical feature? Smaller change-set = lower Time-to-Implementation (TTI).
    
- **Proximity and Coherence (T-09/T-10):** Does the approach group related concepts (coherence) and minimize dependencies (coupling)? Scattered changes drastically increase TTI and cognitive load.
    

**III. The Hypothesis: The "Alt-State" Representation**

We hypothesize that optimizing these TST metrics might require moving beyond the traditional file/directory structure. Perhaps there's an intermediate representation—an "alt-state"—that is better suited for agentic manipulation and analysis.

Instead of defining what this alt-state _must_ be, let's explore what it _could_ be. Brainstorm approaches that might facilitate the following desirable properties:

- **Semantic Exposure:** Could an alt-state make the underlying semantics—dataflow, control flow, and especially the BEAM actor model (supervision, process boundaries, messages)—explicit rather than implicit? How might this differ from a standard AST?
    
- **Velocity and Feedback:** What approaches might allow for extremely fast transformations between the source and an alt-state (e.g., sub-second)? We suspect techniques involving incremental updates, caching, or perhaps query-based compilation might be relevant here.
    
- **Malleability and Bidirectionality:** If an agent manipulates the alt-state, how easily can those changes be reflected back into a compliant source representation? Is perfect fidelity necessary, or is functional equivalence enough? What are the tradeoffs?
    
- **Verifiability:** Could the alt-state itself make certain classes of errors impossible to represent? For example, could it inherently support static analysis or formal verification better than the source code?
    

**IV. Research Directions and Brainstorming Scope**

Please conduct a broad survey of approaches that could contribute to this vision. Use the following categories as starting points, but feel free to introduce others. The goal is breadth and creativity.

#### A. Representational Strategies (Focus on T-07/T-09)

What structures maximize comprehension and coherence?

1. **Graph-Based Views:**
    
    - Beyond standard Code Property Graphs, what other graph structures might capture the nuances of OTP? For example, how might supervision trees or runtime message flows be visualized and queried?
        
    - Could Knowledge Graphs integrate documentation, git history, and code structure to provide a unified semantic view?
        
2. **Declarative and Domain-Specific Frameworks:**
    
    - Are there existing Elixir frameworks (like Ash, Ecto, or even Phoenix contexts) that could serve as a _partial_ alt-state?
        
    - What are the gaps? For instance, Ash captures resources and actions well, but does it capture process orchestration or concurrency?
        
3. **Compiler IRs and Beyond:**
    
    - Analyze existing BEAM IRs (Core Erlang, SSA). Are they suitable for agent comprehension, or are they too low-level?
        
    - What would an ideal, "actor-aware" IR look like?
        

#### B. Feedback and Efficiency Mechanisms (Focus on T-08 & Velocity)

How do we achieve rapid feedback and minimize the scope of changes?

1. **Static Analysis and Evolving Types:**
    
    - How might Elixir's new set-theoretic type system (v1.17+) be used? Could it be integrated into an alt-state to provide instant feedback on type correctness?
        
    - What about other static analysis techniques that focus specifically on concurrency or actor models?
        
2. **Formal Methods Lite:**
    
    - Are there "lightweight" formal methods that fit the BEAM philosophy?
        
    - For example, could Session Types or Typestate analysis be adapted to verify GenServer protocols without requiring full theorem proving? What would that look like?
        
3. **Tooling and Infrastructure:**
    
    - How might tools like LSPs and Tree-sitter evolve to operate on the alt-state? Could they provide agents with symbolic addressing ("Edit GenServer `PaymentProcessor` state machine") rather than file/line navigation?
        

#### C. High-Temperature Brainstorming / Wild Ideas

Think outside the box. What unconventional approaches might yield breakthroughs?

- **Neuro-Symbolic Representations:** Combining neural embeddings (for pattern recognition) with symbolic representations (for verification).
    
- **Runtime Trace Visualization as Alt-State:** Using runtime traces and telemetry to build the alt-state, rather than purely static analysis.
    
- **"Let it Crash" Analysis:** Tools that analyze _how_ things crash to infer structure and invariants, embracing the OTP philosophy.
    
- **Code as Database:** Storing the AST/IR directly in a database (SQL, Graph, or even ETS) and optimizing for semantic queries rather than file access.
    
- **Automatic PBT Generation:** Could the alt-state automatically infer properties and generate PBT generators?
    
- **Polymorphic Views:** What if we abandoned the idea of a single alt-state and instead used a system that generates specialized "views" optimized for specific tasks (e.g., a security view, a dataflow view, a concurrency view)?
    

**V. Evaluation Criteria for Landscape Mapping**

For each approach identified, please provide a brief assessment (this is for mapping the breadth, not making final decisions):

- **TST Optimization Hypothesis:** Briefly explain _why_ this approach might improve TTC (T-07, T-09) or TTI (T-08), or feedback velocity.
    
- **Ecosystem Maturity:** Does this exist in Elixir, exist in other ecosystems (e.g., Rust, Java), or is it purely theoretical? (Reference the attached landscape reports where applicable).
    
- **Quantified Implementation Risk/Effort:** Estimate the novelty and effort required. Use a 1-5 scale, where higher numbers indicate an order-of-magnitude increase in complexity or man-months:
    
    1. _Off-the-shelf:_ Can use existing Elixir library today. (Days)
        
    2. _Integration:_ Requires integrating existing tools or porting a library from another ecosystem. (Weeks)
        
    3. _Engineering:_ Requires significant new engineering effort based on established principles. (Months)
        
    4. _Applied Research:_ Requires adapting cutting-edge research to the Elixir/BEAM context. (Years)
        
    5. _Novel Research:_ Requires fundamental breakthroughs or PhD-level novel research. (Decade+)
        

**VI. Synthesis and Landscape Overview**

Finally, synthesize the findings into a broad landscape map.

- Cluster the identified approaches. Where are the overlaps? What novel intersections seem possible (e.g., Hybrid approaches combining Graphs + Session Types + IRs)?
    
- Highlight the breadth of the explored space. What areas seem over-represented in current literature, and what areas seem under-explored in the context of Elixir/OTP?
    
- Identify the most significant open questions and research gaps that emerged from this breadth-first survey.
    
    (Crucially: Do NOT provide a prioritized roadmap or declare a "winning" approach. The goal is to illuminate the entire field.)