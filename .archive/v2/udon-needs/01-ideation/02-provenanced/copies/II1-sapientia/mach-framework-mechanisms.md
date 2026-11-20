---
source: sapientia docs/advanced-claude-agent-architecture.md (Joseph & Zi-am-tur, Sept 2025) — full-body deep read this pass (STEWARD-CALLS #8); the concrete mechanism blocks excerpted verbatim
gathered: 2026-07-21
status: gathered (verbatim mechanism/pseudocode spans + the paradigm-selection thresholds made concrete in the Ruby; supersedes the head-read summary in characterizations/II1-sapientia-architecture-and-guides.md §MACH)
paths:
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:78-140
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:148-170
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:184-284
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:638-670
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:754-858
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:1071-1090
  - ~/src/_core/sapientia/docs/advanced-claude-agent-architecture.md:1766-1789
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [harness-facing, agent-architecture, paradigm-selection, multi-agent, hierarchy, verification, memory-hierarchy, human-oversight, progressive-autonomy, tier1-ideology]
why_included: >
  FOR THE HARNESS CONSUMER especially. MACH (Modular Adaptive Cognitive Hybrid)
  is Joseph's Sept-2025 vocabulary for the question a harness sits inside:
  "what MODE is this agent loop in, and who decides?" The 2988-line doc is
  ~2000 lines of aspirational Ruby (many stubs marked "more sophisticated in
  practice"); the transferable content is the framework pseudocode blocks and the
  handful of places the Ruby makes a decision concrete. Excerpted here: the
  request-analysis dimensions + paradigm-selection decision tree (prose AND the
  concrete Ruby thresholds), the dynamic-switching triggers, the four-layer
  hierarchy, the multi-level verification framework, the human-oversight /
  progressive-autonomy framework, the five-level memory hierarchy, and the
  sub-agent capability/permission config table. This is more agent-platform than
  notation — but it frames the ecosystem UDON and the harness live inside, and the
  "what mode / what verification level / what autonomy level" vocabulary is directly
  reusable by a harness designer.
---

# MACH framework — the concrete mechanisms (verbatim)

> **Read for:** the harness consumer. The witness question answered here is
> *"an agent system shouldn't run one fixed loop — so what are the modes, how does
> it pick one, when does it switch, how is the work verified, and how much autonomy
> gets granted?"* MACH's thesis: **select a cognitive paradigm per request** — the
> "expert consulting team" model over the "assembly line" model. The four paradigms:
> **Cognitive Scaffolding** (creative/exploratory, à la TodoWrite) · **Explicit Task
> Cycle** (mission-critical, verified steps, à la TaskWeaver) · **Code-First
> Execution** (data-intensive, à la LLMCompiler) · **Human-in-Loop Collaboration**
> (sensitive decisions, checkpoints). Below are the mechanism blocks verbatim.

## Request Analysis Framework — the five dimensions a request is scored on (verbatim)

```
1. COMPLEXITY ASSESSMENT
   - Simple: Direct tool usage, single domain
   - Moderate: Multi-step process, some coordination needed
   - Complex: Requires planning, multiple domains, dependencies
   - Highly Complex: Strategic thinking, unknown unknowns, creative solutions

2. TIME SENSITIVITY EVALUATION
   - Immediate: Real-time response required
   - Urgent: Quick turnaround needed, some planning acceptable
   - Standard: Normal processing time, full planning beneficial
   - Extended: Long-term project, deep thinking valuable

3. DOMAIN REQUIREMENTS ANALYSIS
   - Single Domain / Multi-Domain / Interdisciplinary / Novel Domain

4. RISK LEVEL ASSESSMENT
   - Low Risk: Experimental approaches acceptable
   - Medium Risk: Balanced approach with some verification
   - High Risk: Extensive verification and validation required
   - Critical Risk: Mission-critical, maximum safety protocols

5. RESOURCE AVAILABILITY CHECK
   - Computational budget available
   - Time constraints and deadlines
   - External dependencies and access requirements
   - Human oversight and approval requirements
```

## Paradigm Selection Decision Tree (verbatim, prose form)

```
IF request involves creative exploration OR unclear requirements OR novel problem domain:
    SELECT Cognitive Scaffolding Mode — CONFIGURE for iterative refinement and discovery
ELSE IF request is mission-critical OR has strict requirements OR needs verification:
    SELECT Explicit Task Cycle Mode — CONFIGURE for maximum reliability and validation
ELSE IF request is data-intensive OR computation-heavy OR benefits from code execution:
    SELECT Code-First Execution Mode — CONFIGURE for efficient data manipulation and analysis
ELSE IF request involves sensitive decisions OR requires human judgment OR has ethical implications:
    SELECT Human-in-Loop Collaboration Mode — CONFIGURE for appropriate oversight and input
ELSE IF request has mixed characteristics OR evolving requirements:
    SELECT Hybrid Mode — CONFIGURE dynamic switching between paradigms as needed
```

**The same tree made concrete in the Ruby (the thresholds that were prose above):**

```ruby
def select_paradigm(analysis, request_id)
  if analysis[:complexity] == :creative_exploration ||
     analysis[:domain_requirements].include?(:novel_domain)
    @paradigms[:cognitive_scaffolding]
  elsif analysis[:risk_level] == :high || analysis[:risk_level] == :critical
    @paradigms[:explicit_task_cycle]
  elsif analysis[:complexity] == :data_intensive ||
        analysis[:domain_requirements].include?(:computational)
    @paradigms[:code_first]
  elsif analysis[:collaboration_needs] == :high ||
        analysis[:risk_level] == :requires_human_approval
    @paradigms[:human_in_loop]
  else
    @paradigms[:hybrid]  # mixed or unclear requirements
  end
end
```

## Dynamic Paradigm Switching — the mid-execution re-evaluation triggers (verbatim)

```
PERFORMANCE DEGRADATION DETECTED:
- Task taking longer than expected for paradigm type
- Error rates higher than paradigm norms
- Resource utilization inefficient for paradigm

TASK CHARACTERISTICS EVOLUTION:
- Initially simple task reveals hidden complexity
- Creative exploration discovers need for structured execution
- Routine execution encounters unexpected novel elements

CONTEXT CHANGES:
- Time constraints become more or less pressing
- Additional resources become available or unavailable
- Risk level assessment changes based on new information

EXPLICIT PARADIGM CONFLICT:
- Current paradigm fundamentally unsuited to task requirements
- Better paradigm clearly available for task type
- Human explicitly requests different approach
```

Switching is implemented through **"cognitive checkpoints"** — regular evaluation
points where the system assesses progress and decides whether the current approach
is still optimal, so it never continues an ineffective approach merely because it
was the initial choice.

## Hierarchical Agent Structure — the four layers (verbatim)

```
ORCHESTRATION LAYER (Strategic Level)
- Analyzes incoming requests for complexity and requirements
- Selects appropriate paradigms and overall execution strategies
- Manages resource allocation across the entire system
- Handles high-level coordination and final result synthesis

COORDINATION LAYER (Tactical Level)
- Breaks down strategic plans into executable tasks
- Manages dependencies and sequencing between tasks
- Coordinates communication between specialist agents
- Monitors progress and handles dynamic replanning

EXECUTION LAYER (Operational Level)
- Specialist agents with deep expertise in specific domains
- Execute specific tasks within their areas of competency
- Maintain isolated contexts for security and reliability
- Report results and status back to coordination layer

INFRASTRUCTURE LAYER (Support Level)
- Memory management and context preservation systems
- Security and permissions enforcement mechanisms
- Resource monitoring and optimization services
- Logging, debugging, and performance analysis tools
```

## Controlled Collaboration Principles — isolation vs collaboration balance (verbatim)

```
ISOLATED CONTEXTS: Each sub-agent operates in its own secured context; no direct
  access to other agents' internal state; all communication through controlled
  interfaces; clear boundaries around data access and permissions.
STRUCTURED COMMUNICATION: Standard protocols for requesting assistance; formatted
  data exchange; version control and audit trails for all inter-agent comms; clear
  escalation paths.
SHARED RESOURCES: Common memory via controlled interfaces; shared skill libraries
  with contribution/usage tracking; collaborative workspaces; resource pooling.
DYNAMIC TEAM FORMATION: Agents grouped into temporary teams per project; composition
  optimized to task; clear leadership roles; automatic dissolution on completion.
```

## Sub-agent capability/permission config (verbatim from the Ruby — the concrete schema)

```ruby
data_analyst: {
  expertise: ['statistical_analysis', 'data_visualization', 'pattern_recognition'],
  tools: ['pandas_operations', 'matplotlib_plotting', 'statistical_tests'],
  permissions: { read_data: true, write_results: true, network_access: 'limited' },
  context_mode: 'isolated',
  learning_enabled: true
},
code_architect: {
  expertise: ['software_design', 'system_architecture', 'code_quality'],
  tools: ['code_analysis', 'design_patterns', 'refactoring_tools'],
  permissions: { read_code: true, write_code: true, execute_code: 'sandbox' },
  context_mode: 'isolated', learning_enabled: true
},
research_agent: {
  expertise: ['information_gathering', 'source_evaluation', 'synthesis'],
  tools: ['web_search', 'document_analysis', 'citation_management'],
  permissions: { network_access: 'full', external_apis: true },
  context_mode: 'isolated', learning_enabled: true
}
```

The reusable idea for a harness: an agent is declared by **{expertise, tools,
permissions (scoped, with graded values like `sandbox`/`limited`/`full`),
context_mode, learning_enabled}** — a capability manifest, not a code class.
(Note the direct rhyme with the shipped Elixir sapientia's agent-as-document
compiler — see `characterizations/II1-sapientia-elixir-consciousness-compiler.md`.)

## Multi-Level Verification Framework (verbatim)

```
LOGICAL VERIFICATION: Check internal consistency of plans and reasoning; validate
  actions align with stated objectives; identify contradictions; ensure plans are
  coherent and achievable.
CONSTRAINT VERIFICATION: Validate actions respect defined constraints; check resource
  usage against budgets; ensure security/permissions policies respected; verify
  timing/scheduling constraints.
ENVIRONMENTAL VERIFICATION: Test proposed actions in safe environments before real
  execution; validate assumptions about external systems' current states; check for
  conflicts with other activities.
OUTCOME VERIFICATION: Validate results match intended objectives; check quality and
  correctness; identify unintended consequences/side effects; ensure results meet
  quality/safety standards.
HUMAN VERIFICATION: Present proposed actions to human supervisors when appropriate;
  provide clear explanations of reasoning and expected outcomes; enable intervention;
  maintain audit trails.
```

## Human Oversight Integration + Progressive Autonomy (verbatim)

```
INTELLIGENT ESCALATION: Automatically identify situations that require human
  judgment; provide relevant context to support the decision; enable efficient
  review without overwhelming supervisors; learn from human decisions to improve
  future escalation.
TRANSPARENT REASONING: Clear explanations of agent reasoning; enable humans to
  understand and validate plans; support modification; maintain audit trails.
COLLABORATIVE DECISION-MAKING: Real-time collaboration on complex decisions; tools
  for humans to guide/constrain agent behavior; iterative refinement on feedback.
PROGRESSIVE AUTONOMY: Gradually increase agent autonomy as reliability is
  demonstrated; maintain human oversight for high-risk or novel situations; enable
  supervisors to adjust autonomy levels based on performance; provide mechanisms for
  RETURNING to higher oversight levels when needed.
```

## Hierarchical Memory — the five timescales (verbatim)

```
WORKING MEMORY (Immediate Context): current task state, active variables/intermediate
  results, real-time execution state. Rapid access, frequent updates.
SESSION MEMORY (Task-Specific State): persistent state within a task/project;
  accumulated context and discoveries; maintained across interruptions/resumptions.
EPISODIC MEMORY (Experience-Based Learning): records of past tasks, approaches,
  outcomes; patterns of success/failure; enables learning from experience.
SEMANTIC MEMORY (Knowledge and Skills): accumulated expertise; reusable skills/
  patterns; domain knowledge bases; continuously updated.
PROCEDURAL MEMORY (Automated Capabilities): well-learned procedures executed
  automatically; optimized implementations of frequent patterns; cached solutions.
```

## What the harness consumer should take from this

- A vocabulary for **"what mode is this loop in"** — creative-scaffold vs
  verified-task-cycle vs code-first vs human-in-loop vs hybrid — and an explicit,
  reproducible **decision rule** (the tree, with concrete thresholds) for choosing,
  plus **cognitive checkpoints** as the mechanism for switching mid-flight rather
  than committing to the initial choice.
- **Verification is layered** (logical → constraint → environmental → outcome →
  human), so a harness can decide *which* levels a given risk-tier warrants rather
  than treating verification as one on/off gate.
- **Progressive autonomy is bidirectional** — autonomy earned by demonstrated
  reliability, and explicitly revocable back to higher oversight for novel/high-risk
  work. The "return to higher oversight" clause is the part most autonomy schemes omit.
- An agent as a **capability manifest** ({expertise, tools, scoped-permissions,
  context_mode, learning}) rather than a code class — the same shape the shipped
  Elixir sapientia reaches via agent-documents.
- Honest caveat for synthesis: the Ruby is largely aspirational (self-labeled
  "more sophisticated in practice" stubs). Treat MACH as **design-tier demand
  vocabulary**, not shipped-practice evidence; its value is the taxonomy, not a
  proven implementation.
