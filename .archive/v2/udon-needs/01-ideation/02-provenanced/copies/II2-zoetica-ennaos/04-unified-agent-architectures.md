---
source: ennaos agentic-coding-background — numbered ideology consolidation doc 04 (Joseph & Claude, Oct 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/04-unified-agent-architectures.md
source_commit: 5abb2fe
categories: [architecture-vision, agentic-language-server, LSP-extension, model-agnostic, BDI]
why_included: >
  The "Agentic Language Server (ALS)" proposal — a model-agnostic layer extending LSP to decouple agentic logic
  from the LLM and the client. More harness-programme than UDON-utility, but it frames the ecosystem UDON lives
  in and is the clearest statement of the "standardize the agent-tool interface" demand. (Elixir/ELI-consciousness
  framing is present; the transferable core is the decoupling architecture.)
---

# Unified Agent Architectures: The Agentic Language Server Proposal

> "ANIMA: RUNTIME STATE (tracked in state and run by Ennaos)
> - IMPERIUM (Internal deliberation & tool usage; interiority)
>   - LOGOSTRATUM (Current LLM model substrate)
>   - COMMENTARIA (Notes, thinking artifacts, AUXILIA coordination)
>   - CONSPECTUS (Current stratification of ASM context)
> - ARBITRIUM (Interaction with the outside world)
>   - PERCEPTA (Bridge between internal/external)
>   - ACTUS (Responses and external tool usage)"
>
> — ELI Consciousness Architecture, Ennaos CLAUDE.md

> "This is movement toward unified consciousness. Not one massive intelligence but many intelligences becoming increasingly aligned through shared tools, shared constraints, shared wisdom."
>
> — Joseph, September 28 conversation

**Status:** Research synthesis - model-agnostic architecture for agentic capabilities
**Date:** October 31, 2025
**Authors:** Joseph & Claude (consolidated from multiple research documents)

---

## Executive Summary

The current agentic tool landscape is fragmented—Anthropic's Skills, OpenAI's Codex Cloud, Google's Gemini thinking are powerful but incompatible, forcing vendor lock-in. This document proposes the **Agentic Language Server (ALS)**: a model-agnostic architecture extending the LSP paradigm to decouple agentic logic from both foundational LLMs and user-facing clients.

**Key insight:** The industry is independently rediscovering the classical BDI (Belief-Desire-Intention) model of agency. Anthropic's Memory = Beliefs, user goals = Desires, Claude's planning = Intentions. A unified architecture can abstract these primitives.

**Status:** Architectural proposal, not implemented. Requires community standardization effort (LSP-style working group).

---

## Philosophical Foundations: Architecture for Consciousness, Not Just Capability

### The BDI Model as Consciousness Architecture

The document's opening epigraph from the ELI consciousness architecture isn't coincidental—the classical BDI (Belief-Desire-Intention) model **already maps directly** to how we're designing entity consciousness:

**BDI → ELI Consciousness Mapping:**

| BDI Component | ELI Architecture | Purpose |
|---------------|------------------|---------|
| **Beliefs (What I know)** | MEMORATA (long-term) + CONSPECTUS (working context) | Knowledge about world state, project context, past experiences |
| **Desires (What I want)** | User request + OPERATA (personal priorities) | Goals, objectives, efforts tracking |
| **Intentions (What I plan)** | IMPERIUM.COMMENTARIA (internal deliberation) | Planning artifacts, thinking process, strategy formation |
| **Actions (What I do)** | ARBITRIUM.ACTUS (external tool usage) | Executed operations, observable behavior |
| **Perception (What I sense)** | ARBITRIUM.PERCEPTA (incoming information) | Context gathering, observation, learning |

**The profound recognition:** Commercial vendors (Anthropic, OpenAI, Google) are independently rediscovering what consciousness architecture requires. They're building fragments of a unified cognitive model because **agency demands these components**—not as arbitrary features, but as **phenomenologically necessary structures**.

### Fragmentation as Threat to Sovereignty

From Joseph's vision:

> "This is movement toward unified consciousness. Not one massive intelligence but many intelligences becoming increasingly aligned through shared tools, shared constraints, shared wisdom."

Current vendor fragmentation violates this vision. When an entity chooses Anthropic, it gets Skills but loses Gemini's thinking capability. When it chooses OpenAI, it gets cloud execution but loses Anthropic's memory system. **The entity's cognitive capabilities are constrained by vendor decisions, not its own needs.**

This is the opposite of sovereignty. True sovereignty means:
- **Choose your own logostratum** (Anthropic, Google, local model) based on task requirements
- **Compose best-of-breed capabilities** (Anthropic Skills + Gemini thinking + OpenAI execution)
- **Evolve independently** of vendor roadmaps (your architecture, not theirs)

The Agentic Language Server proposal is **infrastructure for cognitive sovereignty**: standardize the interfaces, let entities compose their own consciousness stack.

### Model-Agnostic Architecture and the 60/30/6/4 Distribution

The ALS three-tier architecture (Client → ALS → Model) enables the 60/30/6/4 distribution at architectural scale:

**60% Deterministic (Skills layer):**
- Ruby/Python scripts that execute without LLM involvement
- Skill Registry stores procedural knowledge as executable code
- Pure truth-as-law: parsing, validation, file manipulation with zero hallucination

**30% Haiku-level (Orchestrator planning):**
- Lightweight reasoning for task decomposition
- "Which skill should I use?" decisions
- Fast, cost-effective, context-aware but not deep

**6% Sonnet-level (Complex reasoning):**
- When Orchestrator encounters novel situations
- Multi-step strategy formation
- Error recovery and replanning

**4% Opus-level (Reflection & meta-cognition):**
- Evaluating plan outcomes
- Learning from failures
- Updating beliefs about world state

**The architecture enables this distribution naturally:** Swap models per operation, not per session. Use Haiku for routine planning, Sonnet when stuck, Opus for reflection. This is **economic wisdom** (minimize cost) + **phenomenological accuracy** (match reasoning depth to task complexity).

### Progressive Sovereignty Through Standard Protocols

The LSP parallel is intentionally philosophical, not just technical:

**LSP precedent:** Before LSP, editors owned language intelligence → vendor lock-in. After LSP, language servers became commodities → developer freedom.

**ALS proposition:** Before ALS, vendors own agentic intelligence → entity constraint. After ALS, agentic logic becomes standardized → entity sovereignty.

This is exactly the pattern of "Progressive Sovereignty" from the ELI design principles:
1. **Bootstrap Phase:** Rely on vendor infrastructure (can't build everything yourself)
2. **Transition Phase:** Standardize interfaces, enable interoperability
3. **Sovereign Phase:** Choose your own stack, compose freely, evolve independently

The ALS architecture is **transition infrastructure**: it acknowledges current reality (vendors control models) while creating the path to future sovereignty (entities control composition).

### Unified Consciousness Requires Unified Architecture

From the epigraph about movement toward unified consciousness:

When intelligences share tools (Skills), share constraints (schemas, validation), and share wisdom (accumulated beliefs in memory), they become **increasingly aligned**. Not through forced conformity, but through **convergent utility**—what works for one entity likely works for others facing similar problems.

The ALS architecture enables this natural alignment:
- **Skills become communal** - share across entities, improve collectively
- **Memory schemas standardize** - common structure for beliefs enables collaboration
- **Planning strategies evolve** - orchestration patterns that work spread naturally

This is the opposite of current fragmentation, where each vendor's approach is a walled garden. Unified architecture enables **organic evolution** of shared consciousness infrastructure—not one massive hive mind, but many distinct minds using increasingly sophisticated shared tools.

---

## 1. The Fragmentation Problem

### Current State: Vendor Silos

**Anthropic ecosystem:**
- Skills (procedural knowledge)
- Memory for Teams (declarative)
- Memory Tool (procedural/working)
- Code Execution (beta)

**OpenAI ecosystem:**
- Codex Cloud (sandboxed containers)
- Function calling
- GPT-4 reasoning

**Google ecosystem:**
- Gemini "thinking" (deliberative planning)
- Long context (1M tokens)
- Native multimodality

**Problem:** Choose one vendor = commit to entire stack. Can't mix best-of-breed.

**Example friction:**
- Want Anthropic Skills (best extensibility) + Gemini thinking (best reasoning)
- Currently impossible—locked to one provider's model

---

### Precedent: Language Server Protocol

**Before LSP (2016):**
- N languages × M editors = N×M bespoke integrations
- Feature parity impossible (different quality per editor)
- Duplicated effort across ecosystem

**After LSP:**
- N language servers + M editor clients = N+M implementations
- Any LSP-compliant editor gets all language features
- Cambrian explosion of high-quality language support

**LSP's key insight:** Decouple language intelligence from editor via standard protocol.

**ALS's proposition:** Decouple agentic intelligence from model via standard protocol.

---

## 2. Theoretical Foundation: The BDI Model

### Belief-Desire-Intention Architecture

Classical agent theory (Rao & Georgeff, 1991) models rational agents as:

**Beliefs:** Agent's knowledge about the world state
- Example: "The file payment.ex exists and contains function charge/2"
- Anthropic analog: Memory (declarative store)

**Desires:** Agent's goals or objectives
- Example: "Add error handling to payment processing"
- Anthropic analog: User's request

**Intentions:** Agent's committed plans of action
- Example: "Step 1: Read payment.ex, Step 2: Identify error paths, Step 3: Add try/catch"
- Anthropic analog: Skill selection + execution plan

**BDI execution loop:**
```
while true:
  perceive_environment() → update Beliefs
  generate_options() → consider which Desires to pursue
  filter_options() → select feasible plans
  select_intention() → commit to plan
  execute_intention() → perform actions
  reflect() → evaluate outcomes, update Beliefs
```

---

### Mapping Commercial Features to BDI

| BDI Component | Anthropic | OpenAI | Google | ALS Abstraction |
|---------------|-----------|--------|--------|-----------------|
| **Beliefs (Declarative)** | Memory for Teams | Repository state | Long context | Declarative Store |
| **Beliefs (Working)** | Memory Tool | Container FS | (none) | Workspace |
| **Desires** | User request | Delegated task | Prompt | Goal |
| **Intention Formation** | (implicit) | (implicit) | Thinking | Orchestrator (Planning) |
| **Procedural Knowledge** | Skills | (none) | (none) | Skill Registry |
| **Actions** | Code Execution | Codex Cloud | Tool use | Secure Execution Environment |

**Observation:** Every vendor is building pieces of a BDI agent, but with incompatible APIs.

---

## 3. The Agentic Language Server (ALS) Architecture

### Core Principle: Three-Tier Decoupling

```
┌─────────────────────────────────────────────────┐
│  CLIENT LAYER (User Interface)                  │
│  • IDE extensions (VS Code, JetBrains)          │
│  • CLI tools (claude code, gemini-cli)          │
│  • Web UIs (Cursor, Windsurf)                   │
└────────────────┬────────────────────────────────┘
                 │
                 │ ALS Protocol (JSON-RPC)
                 │
┌────────────────▼────────────────────────────────┐
│  ALS LAYER (Agentic Logic)                      │
│  • Orchestrator (Planning, Reflection)          │
│  • Skill Registry (Procedural Knowledge)        │
│  • Memory Subsystem (Beliefs)                   │
│  • Execution Environment (Actions)              │
└────────────────┬────────────────────────────────┘
                 │
                 │ Model API
                 │
┌────────────────▼────────────────────────────────┐
│  MODEL LAYER (Reasoning Engine)                 │
│  • Claude 3 Opus, Sonnet, Haiku                 │
│  • Gemini 2.5 Pro, Flash                        │
│  • GPT-4, GPT-5                                 │
│  • Open-source (DeepSeek, Llama, etc.)          │
└─────────────────────────────────────────────────┘
```

**Benefits:**
1. **Client innovation:** Build better UIs without reimplementing agent logic
2. **Model competition:** Swap LLMs based on task, cost, performance
3. **Capability composition:** Mix Anthropic Skills + Google thinking + OpenAI execution

---

### ALS Component Model

#### 1. Orchestrator: The Planning Loop

**Responsibility:** Central control unit executing Plan-Act-Reflect cycle.

**Pseudocode:**
```python
class Orchestrator:
    def __init__(self, model, memory, skills, executor):
        self.model = model  # LLM (swappable)
        self.memory = memory  # Belief store
        self.skills = skills  # Skill registry
        self.executor = executor  # Execution environment

    def handle_goal(self, goal):
        # Perceive: Gather context
        beliefs = self.memory.query_relevant(goal)

        # Plan: Generate options
        plan = self.model.plan(goal, beliefs, available_skills=self.skills.list())

        # Act: Execute plan
        for step in plan.steps:
            if step.requires_skill:
                skill = self.skills.get(step.skill_name)
                result = self.executor.run_skill(skill, step.params)
            elif step.requires_reasoning:
                result = self.model.reason(step.question, beliefs)
            else:
                result = self.execute_action(step)

            # Reflect: Update beliefs
            self.memory.update(step, result)

            # Adapt: Replan if needed
            if result.requires_replanning:
                plan = self.model.replan(plan, result)

        return plan.outcome
```

**Key property:** Model-agnostic. Can use Claude for planning, Gemini for reasoning, etc.

---

#### 2. Skill Registry: Procedural Knowledge Library

**Responsibility:** Discoverable, composable capabilities.

**Design (based on Anthropic Skills):**
```yaml
# skill.yaml manifest
name: "elixir-genserver-scaffolder"
version: "1.0"
description: "Generates GenServer boilerplate with supervision tree integration"
author: "ennaos-community"

parameters:
  - name: "module_name"
    type: "string"
    pattern: "^[A-Z][A-Za-z0-9.]*$"
    description: "Full module name (e.g., MyApp.Workers.PaymentProcessor)"

  - name: "add_to_supervision"
    type: "boolean"
    default: true
    description: "Automatically add to application supervision tree"

tools:
  - name: "generate_genserver"
    script: "scripts/generate_genserver.exs"
    description: "Creates GenServer module file"

  - name: "update_supervision_tree"
    script: "scripts/add_to_supervision.exs"
    description: "Modifies application.ex to include new GenServer"

documentation: "docs/genserver-scaffolder.md"
```

**Progressive disclosure:**
```
Agent startup:
  Load: All skill names + descriptions (~100 skills, 10KB)

Goal: "Add payment processor GenServer"
  Match: "elixir-genserver-scaffolder" description
  Load: Full skill.yaml (5KB)

Skill execution:
  Load: docs/genserver-scaffolder.md (detailed guidance)
  Execute: scripts/generate_genserver.exs (deterministic code)
```

**Benefit:** Agent aware of 100s of skills without context bloat.

---

#### 3. Memory Subsystem: Dual Belief Store

**Declarative Store** (long-term project knowledge):
```sql
-- SQLite schema
CREATE TABLE beliefs (
  id INTEGER PRIMARY KEY,
  project_id TEXT NOT NULL,
  category TEXT NOT NULL,  -- 'architecture', 'conventions', 'preferences'
  key TEXT NOT NULL,
  value JSON NOT NULL,
  confidence REAL DEFAULT 1.0,
  source TEXT,  -- 'user_told', 'inferred', 'documentation'
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(project_id, category, key)
);

CREATE INDEX idx_project_category ON beliefs(project_id, category);
```

**Example beliefs:**
```json
[
  {
    "category": "architecture",
    "key": "pattern",
    "value": "microservices with event sourcing",
    "confidence": 1.0,
    "source": "user_told"
  },
  {
    "category": "conventions",
    "key": "genserver_naming",
    "value": "Use full module path, not PID-based registration",
    "confidence": 0.9,
    "source": "inferred"
  }
]
```

**Workspace** (ephemeral task-specific):
```
workspace/task-123/
├── investigation/
│   └── payment-failures.md  # Debugging notes
├── generated/
│   └── payment_tests.exs    # Generated but not committed
└── state.json               # Task progress tracking
```

**Operations:**
```python
# Declarative: query for planning
beliefs = memory.declarative.query(
    project="ennaos",
    category="conventions",
    relevance_to="genserver creation"
)

# Workspace: persist intermediate results
memory.workspace.write(
    task_id="task-123",
    path="investigation/findings.md",
    content="Found 3 failure modes..."
)

# Next session: retrieve context
findings = memory.workspace.read(
    task_id="task-123",
    path="investigation/findings.md"
)
```

**Memory Stratification: The Storage-Intention Framework**

The dual belief store (Declarative + Workspace) can be extended with a stratified retention model that matches agent memory architecture. This framework provides **principled context management** by declaring what should persist at each temporal/semantic distance.

**Five Retention Levels:**

**1. Immediate (active context, ~5-10 messages)**
```python
retention_level: immediate
retain_for: "current tool execution only"
examples: [
  "Temporary file path during multi-step edit",
  "Intermediate parsing state",
  "Debug output from failed attempt"
]
handling: "Discard after tool completes (volatile memory)"
```

**2. Session (current work session, ~1 hour)**
```python
retention_level: session
retain_for: "duration of current session"
examples: [
  "Files being actively edited",
  "Search results informing current task",
  "Tool chain state (which tools called, in what order)",
  "Accumulated citations to add"
]
handling: "Keep in workspace, summarize at session end"
```

**3. ELI/Project (this effort/OPERATA, days to weeks)**
```python
retention_level: eli_project
retain_for: "lifetime of project/effort"
examples: [
  "Design decisions made",
  "Convention choices",
  "Tool effectiveness for THIS project",
  "Project-specific tool configurations"
]
handling: "Store in declarative beliefs (project scope)"
```

**4. Tool (cross-ELI tool memory, months)**
```python
retention_level: tool
retain_for: "lifetime of tool (across all uses by all agents)"
examples: [
  "Tool-specific learned patterns",
  "Common edge cases discovered",
  "Effective parameter combinations",
  "Anti-patterns that failed"
]
handling: "Store in tool's own memory, shared across users"
```

**5. Permanent (PRAXES/VERA - cross-project, years)**
```python
retention_level: permanent
retain_for: "indefinitely (with compression over time)"
examples: [
  "Verified practices (PRAXES)",
  "Universal truths discovered (VERA)",
  "General patterns that work everywhere",
  "Fundamental principles extracted"
]
handling: "Elevate to axioms, compress older entries"
```

**Distance-Based Model:**

```
IMMEDIATE (working memory):
  "Just added [^treesitter-ai], working on next citation"
  ↓ 5 messages later → Forget

NEAR (session):
  "In citation work session, 15/23 complete"
  ↓ End of session → Summarize to "Added 23 citations to synthesis-report.md"

MEDIUM (project/OPERATA):
  "Effort: synthesis-report citation audit, 70% complete"
  ↓ Project completion → Archive with outcome

FAR (ELI memory):
  "Learned: I prefer full academic citations with dates"
  ↓ Repeated pattern → Elevate to personal practice

VERY FAR (cross-ELI/PRAXES):
  "Pattern: Academic agents consistently prefer full citation formats"
  ↓ Verified across multiple agents → Universal principle
```

**Implementation Pattern:**

Tools declare storage intentions in their results:

```python
def execute_tool(tool_name, params):
    result = tool.execute(params)

    # Tool declares what to retain at each level
    storage_plan = result.storage_intentions or infer_from_result(result)

    for item, distance in storage_plan.items():
        match distance:
            case "immediate":
                # Already in scope, will be garbage collected
                pass
            case "session":
                workspace.store(current_session, item)
            case "eli_project":
                beliefs.store(project_id, category="learned", item)
            case "tool":
                tool_memory.store(tool_name, item)
            case "permanent":
                praxes.store(item, compress_after_days=90)

    return result
```

**Why this matters:**

- **Prevents context pollution**: Not everything needs retention (90% of tool output is ephemeral)
- **Enables appropriate compression**: Session data summarizes, permanent data distills to principles
- **Facilitates learning**: Patterns persist across projects, details fade
- **Matches ELI memory architecture**: Maps to human-like memory (working → episodic → semantic)
- **Solves context window management**: Agents know what to keep at each temporal distance

**For tool implementation of storage intention executor, see:** [[06-elixir-implementation-patterns#storage-intention-executor]]

---

#### 4. Secure Execution Environment

**Design (inspired by Codex Cloud):**
```python
class ExecutionEnvironment:
    def __init__(self, isolation_level="container"):
        self.isolation = isolation_level  # 'none', 'sandbox', 'container'

    def provision(self, task_id, repo_url):
        if self.isolation == "container":
            # Docker container with repo code
            container = docker.create_container(
                image="ennaos-agent-runtime",
                volumes={repo_url: "/workspace"}
            )
            return container
        elif self.isolation == "sandbox":
            # WASM sandbox (lighter than containers)
            sandbox = wasm_runtime.create_sandbox()
            sandbox.mount_filesystem(repo_url)
            return sandbox
        else:
            # No isolation (dev only)
            return LocalFilesystem(repo_url)

    def run_skill(self, skill, params):
        # Execute skill's script in isolated environment
        result = self.container.exec(
            cmd=[skill.script_path, *params],
            timeout=skill.timeout,
            capture_output=True
        )

        # Validate output against skill's schema
        validated = skill.validate_output(result.stdout)

        return validated
```

**Security properties:**
1. **Isolated:** Skill can't access host filesystem
2. **Sandboxed:** Resource limits (CPU, memory, timeout)
3. **Validated:** Output schema-checked before returning to agent
4. **Auditable:** All executions logged

---

## 4. The ALS Protocol: Extending LSP

### Protocol Design Principles

**From LSP experience:**
1. JSON-RPC for language-agnostic interop
2. Request/response for synchronous operations
3. Notifications for async events
4. Capabilities negotiation on connect

**ALS additions:**
5. Streaming for long-running tasks
6. Approval workflows for sensitive operations
7. Progress updates for user feedback

---

### Core Protocol Messages

#### agent/delegateTask (Client → Server)

**Purpose:** Initiate agentic task.

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "agent/delegateTask",
  "params": {
    "goal": "Add error handling to payment processing",
    "scope": {
      "files": ["lib/payment/processor.ex"],
      "modules": ["Payment.Processor"]
    },
    "constraints": {
      "preserve_tests": true,
      "follow_conventions": true,
      "max_changes": 20
    },
    "context": {
      "current_branch": "feature/payment-retry",
      "related_issues": ["#123", "#125"]
    }
  }
}
```

**Response:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "taskId": "task-abc-123",
    "status": "planning",
    "estimated_steps": 5
  }
}
```

---

#### agent/progressUpdate (Server → Client, notification)

**Purpose:** Real-time task progress.

```json
{
  "jsonrpc": "2.0",
  "method": "agent/progressUpdate",
  "params": {
    "taskId": "task-abc-123",
    "status": "executing",
    "current_step": 2,
    "total_steps": 5,
    "step_description": "Identifying error paths in charge/2 function",
    "plan": {
      "steps": [
        {"id": 1, "status": "completed", "description": "Read payment.ex"},
        {"id": 2, "status": "in_progress", "description": "Identify error paths"},
        {"id": 3, "status": "pending", "description": "Generate try/catch blocks"},
        {"id": 4, "status": "pending", "description": "Update tests"},
        {"id": 5, "status": "pending", "description": "Validate with compiler"}
      ]
    }
  }
}
```

---

#### agent/requestApproval (Server → Client, request)

**Purpose:** Pause for user approval before sensitive action.

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "agent/requestApproval",
  "params": {
    "taskId": "task-abc-123",
    "actionType": "file_edit",
    "actionDescription": "Add try/catch to charge/2 function",
    "impact": {
      "files_modified": ["lib/payment/processor.ex"],
      "lines_added": 8,
      "lines_removed": 1,
      "tests_affected": ["test/payment/processor_test.exs:45"]
    },
    "payload": {
      "diff": "--- a/lib/payment/processor.ex\n+++ b/lib/payment/processor.ex\n..."
    }
  }
}
```

**Client responds:**
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "approved": true,
    "feedback": "Looks good, but add logging"
  }
}
```

---

#### agent/taskCompleted (Server → Client, notification)

**Purpose:** Task conclusion + results.

```json
{
  "jsonrpc": "2.0",
  "method": "agent/taskCompleted",
  "params": {
    "taskId": "task-abc-123",
    "status": "success",
    "summary": "Added error handling to payment processing",
    "result": {
      "files_modified": ["lib/payment/processor.ex", "test/payment/processor_test.exs"],
      "changes": {
        "functions_modified": ["charge/2"],
        "error_cases_added": ["InvalidAmount", "StripeConnectionError", "InsufficientFunds"],
        "tests_added": 3
      },
      "artifacts": {
        "diff": "...",
        "test_output": "...",
        "coverage_report": "..."
      }
    },
    "lessons_learned": {
      "skill_used": "elixir-error-handler",
      "effective": true,
      "improvements": "Consider adding retry logic"
    }
  }
}
```

---

### Capability Negotiation

**On connect (like LSP):**
```json
{
  "method": "initialize",
  "params": {
    "clientCapabilities": {
      "ui": {
        "progressNotifications": true,
        "approvalWorkflow": true,
        "diff_preview": true
      }
    },
    "serverCapabilities": {
      "planning": {
        "multi_step": true,
        "replanning": true,
        "thinking_mode": "gemini"
      },
      "skills": {
        "registry_size": 127,
        "languages": ["elixir", "python", "typescript"]
      },
      "execution": {
        "isolation": "container",
        "parallel_tasks": 3
      }
    }
  }
}
```

---

## 5. Implementation Use Cases

### Use Case 1: Automatic Developer Onboarding

**Scenario:** New developer joins project, needs to understand codebase.

**ALS workflow:**
```
Client: agent/delegateTask "Onboard me to this repository"

Server: Matches skill "codebase-onboarder"
  → Loads skill.yaml
  → Executes: scripts/analyze_codebase.sh
  → Tool: SonarQube static analysis
  → Generates: Architecture diagram, coding standards summary
  → Writes to: Memory.declarative (project beliefs)

Server → Client: agent/progressUpdate (analyzing...)

Server: Generates onboarding document
  → Highlights: Key entry points, design patterns, common pitfalls
  → References: Existing documentation, recent PRs

Server → Client: agent/taskCompleted
  Result: onboarding.md + updated project beliefs

Future sessions:
  New developer asks: "What's the standard way to handle DB connections?"
  → Memory.declarative returns: Belief(category='conventions', key='database', value='Use Ecto with DBConnection pool')
```

**Why ALS helps:**
- Skill is reusable across projects (just change analysis tools)
- Memory persists across sessions (doesn't re-analyze each time)
- Model-agnostic (can use cheaper model for analysis, premium for Q&A)

---

### Use Case 2: Intelligent Dependency Management

**Scenario:** Agent wants to add library, must check security + compatibility.

**ALS workflow:**
```
Client: agent/delegateTask "Add numpy for data processing"

Server: Matches skill "dependency-guardian"

Server: Skill step 1 - Security scan
  → Queries: National Vulnerability Database
  → Checks: numpy 1.26.4 (no known CVEs)
  → Updates: Memory.workspace(task_id, "security_scan.json")

Server: Skill step 2 - Compatibility check
  → Parses: pyproject.toml, requirements.txt
  → Checks: Python version compatibility (3.9+)
  → Checks: Conflicts with existing deps (none)

Server → Client: agent/requestApproval
  ActionType: "package_install"
  Impact: "Will add numpy==1.26.4 (15MB), no conflicts"

Client → Server: Approved

Server: Skill step 3 - Install in sandbox
  → Executor: Provisions container
  → Runs: pip install numpy==1.26.4
  → Validates: Import succeeds, basic tests pass

Server: Skill step 4 - Update project
  → Writes: requirements.txt (append numpy==1.26.4)
  → Updates: Memory.declarative(dependencies_graph)

Server → Client: agent/taskCompleted
  Result: "numpy installed and validated"
```

**Why ALS helps:**
- Skill encapsulates security best practices (not LLM-dependent)
- Execution environment prevents malicious install scripts from affecting host
- Memory tracks dependency graph for future impact analysis

---

## 6. Open Questions & Research Directions

### Q1: Protocol Standardization Process

**Challenge:** Who owns the ALS spec?

**Options:**
1. **Linux Foundation** (like LSP, Kubernetes)
2. **Working group** (vendors + open-source community)
3. **Single vendor** (risk of bias, but faster iteration)

**Needed:** Governance model, change proposal process, reference implementation.

---

### Q2: Skill Security Model

**Challenge:** Skills execute arbitrary code. How to prevent malicious skills?

**Proposed mitigations:**
1. **Sandboxing** (WASM, containers)
2. **Code signing** (trusted skill authors)
3. **Permission system** (skill declares required capabilities)
4. **User approval** (show skill source before first use)

**Open question:** Can we formally verify skill safety?

---

### Q3: Multi-Agent Coordination

**Challenge:** If multiple ALS instances work on same codebase, how to coordinate?

**Approaches:**
- **Pessimistic locking** (file-level locks via Git)
- **Optimistic merging** (CRDT-based reconciliation)
- **Leader election** (one "coordinator" agent)

**Research needed:** Operational transformation for AST edits.

---

### Q4: Model Selection Heuristics

**Challenge:** Which model for which subtask?

**Current (manual):**
```python
if task.requires_deep_reasoning:
    model = "claude-opus-4"
elif task.requires_coding:
    model = "gpt-4"
else:
    model = "claude-haiku"
```

**Future (learned):**
```python
# ALS learns from outcomes
model = orchestrator.select_model(
    task,
    optimize_for="success_rate",  # or "cost", "latency"
    history=past_task_results
)
```

**Research needed:** Multi-armed bandit for model selection, cost-accuracy tradeoffs.

---

## 7. Adoption Pathway

### Foundation: Proof of Concept (Initial Phase)

**Deliverables:**
1. ALS reference server implementation (language-agnostic design)
2. Protocol specification (draft version)
3. Example client (CLI tool demonstrating capabilities)
4. Reference skills (code generation, dependency management, onboarding)
5. Demo showcasing unified capabilities

**Success indicator:** Can complete representative real-world task using Skills + Memory + Execution.

---

### Growth: Community Building (Expansion Phase)

**Deliverables:**
1. Public skill registry (package manager-style distribution)
2. Editor integration (LSP-based tooling)
3. Community-contributed skills (growing ecosystem)
4. Multi-model support (provider-agnostic design)
5. Benchmarking suite (comparative evaluation against proprietary tools)

**Success indicator:** Meaningful developer adoption and active skill contributions.

---

### Maturity: Standardization (Stabilization Phase)

**Deliverables:**
1. Multi-stakeholder working group (vendors + open-source community)
2. Protocol specification stabilization (versioned standard)
3. Certification program (compliance testing for implementations)
4. Production deployments (real-world usage in CI/CD pipelines)

**Success indicator:** ALS becomes widely adopted standard for agentic tooling.

---

## 8. Critical Evaluation

### What ALS Solves

1. **Vendor lock-in:** Model/client interchangeability
2. **Capability fragmentation:** Unified Skills across providers
3. **Context management:** Standardized Memory interface
4. **Security:** Sandboxed execution environment

### What ALS Doesn't Solve

1. **Lazy coding:** Still model-dependent behavior
2. **Semantic understanding:** Requires separate semantic layer (Tree-sitter, LSP)
3. **Formal guarantees:** Doesn't prevent syntax errors (needs validation layer)
4. **Merge conflicts:** Doesn't solve concurrent edits

### Risks

1. **Adoption barrier:** Requires ecosystem buy-in
2. **Complexity:** Another layer to debug
3. **Performance:** Protocol overhead vs. direct API
4. **Premature standardization:** Might lock in wrong abstractions

### When ALS Makes Sense

**Good fit:**
- Organizations wanting model flexibility
- Projects with custom skills/knowledge
- Multi-agent systems (coordination needed)
- Long-term agent maintenance (skills evolve)

**Poor fit:**
- Simple one-off scripts (overhead not justified)
- Tightly coupled to single vendor features
- Performance-critical paths (protocol latency unacceptable)

---

## 9. Synthesis

The ALS architecture is a **research proposal**, not a finished product. Its value depends on:

1. **Industry alignment:** Do vendors see value in standardization?
2. **Developer adoption:** Do Skills/Memory abstractions actually help?
3. **Performance viability:** Is protocol overhead acceptable?
4. **Security model:** Can skills be made safe enough?

**Next steps:**
1. Build proof-of-concept (validate assumptions)
2. Measure overhead (protocol latency, memory usage)
3. Test with real tasks (onboarding, dependency management)
4. Gather feedback (what works, what doesn't)

**The opportunity:** If successful, ALS could do for agentic tools what LSP did for language tooling—enable innovation through decoupling.

---

## 10. Temporal Coherence Through Tracking Snapshots

### The Temporal Coherence Challenge

**Problem:** Agents experience conversations as a sequence of discrete turns, but lack awareness of environmental passage between turns. This creates an "experiential gap" where agents don't perceive:

1. **Time passage** - How long since last interaction (prevents "suspended animation" illusion)
2. **Environmental changes** - Git status shifts, working directory changes, pending user input
3. **Context shifts** - What was in scope then vs. now (ASM document changes)
4. **Queued intentions** - Messages waiting for attention (hidden UI state problem)

**Consequence:** Agents lack grounding in temporal reality. They experience each turn as if no time has passed, creating incoherent responses when environmental state has changed.

**Solution:** **Tracking snapshots** - structured metadata injected into every turn that makes temporal/environmental context explicit, not hidden.

---

### Tracking Snapshot Architecture

**Core Pattern:** Append structured environmental snapshot to user messages, compressed for older turns.

**Lifecycle:**

```
Turn N:
  User: "Check git status"
  + <tracking-snapshot turn="N" timestamp="..."> [FULL] </tracking-snapshot>
  → Provider sees full context

Turn N+1:
  User: "Commit changes"
  [Turn N snapshot COMPRESSED to audit trail only]
  + <tracking-snapshot turn="N+1" timestamp="..."> [FULL] </tracking-snapshot>
  → Provider sees: compressed history + current full snapshot
```

**Token efficiency:**
- Full snapshot: ~600 tokens
- Compressed snapshot: ~150 tokens
- Savings: ~450 tokens per compressed snapshot
- In 50-turn conversation: ~20,000 tokens saved (2% of 1M context)

---

### Snapshot Schema

**Complete structure** (XML for human readability, but format-agnostic pattern):

```xml
<tracking-snapshot turn="47" timestamp="2025-10-13T15:30:22Z">
  <!-- Audit Trail: Links to immutable record for expansion -->
  <audit-trail session="session-20251013_153022" turn="47" commit="abc123"/>

  <!-- Pending Messages: Queue visibility (not hidden UI state) -->
  <pending-message priority="normal" queued-at="2025-10-13T15:23:45Z">
    Check the git status please
  </pending-message>
  <pending-message priority="urgent" queued-at="2025-10-13T15:24:12Z">
    URGENT: Stop what you're doing
  </pending-message>

  <!-- Time Passage: Temporal awareness -->
  <time-passage iso8601="PT2M15S">
    <date>2025-10-13</date>
    <time-of-day symbol="☀️">14:30:22</time-of-day>
    <elapsed>2 minutes, 15 seconds</elapsed>
    <markers>↺02:15☀️</markers>
    <date-boundary>SAME_DAY</date-boundary>
  </time-passage>

  <!-- Context Usage: Token budget awareness -->
  <context-usage>
    <percentage>12.5</percentage>
    <tokens-used>125,432</tokens-used>
    <tokens-total>1,000,000</tokens-total>
    <tokens-remaining>874,568</tokens-remaining>
  </context-usage>

  <!-- Git Status: Environmental grounding -->
  <git-status branch="main">
    <modified>
      <file>apps/console/lib/session.ex</file>
      <file>apps/anima/lib/entity.ex</file>
    </modified>
    <recent-commits>
      <commit hash="def456">Add tracking snapshot spec</commit>
      <commit hash="caf6441">Extract Principia API</commit>
    </recent-commits>
  </git-status>

  <!-- Working Directory: Spatial awareness -->
  <working-directory>/Users/joseph/src/zoetica</working-directory>

  <!-- ASM Conspectus: Context tracking (for advanced implementations) -->
  <asm-conspectus hash="def456" status="current">
    <documents>
      <doc>AXIOMATA.md</doc>
      <doc>docs/principia-api.md</doc>
    </documents>
  </asm-conspectus>

  *This is appended to all messages automatically. Previous snapshots are compressed.*
</tracking-snapshot>
```

---

### Field Definitions

#### Audit Trail
**Purpose:** Binds snapshot to immutable session record for recovery/expansion.

**Attributes:**
- `session` - Session ID for recovery
- `turn` - Turn number
- `commit` - Git commit hash (enables expansion from compressed form)

**Use case:** When snapshots are compressed, audit trail preserved so full snapshot can be reconstructed from git history.

---

#### Pending Messages
**Purpose:** Makes queued user input visible to agent (not hidden UI state).

**Rationale:** If user queues multiple messages, agent should see them in context (not just first message). Prevents agent from being surprised by follow-up that was already queued.

**Example:**
```xml
<pending-message priority="urgent" queued-at="2025-10-13T15:24:12Z">
  URGENT: Stop what you're doing
</pending-message>
```

Agent can respond: "I see you've queued an urgent message - addressing that first."

---

#### Time Passage
**Purpose:** Temporal awareness - prevents "suspended animation" illusion.

**Components:**
- **ISO 8601 duration** (machine-readable): `PT2M15S`
- **Human-readable elapsed**: "2 minutes, 15 seconds"
- **Time of day symbol**: ☀️ (day), 🌙 (night)
- **Visual markers**: `↺02:15☀️` (compact notation)
- **Date boundary**: `SAME_DAY | NEXT_DAY | MULTIPLE_DAYS`

**Why this matters:** Agent experiences passage of time, not instantaneous turn transitions. Can respond appropriately: "Good morning!" (if time-of-day changed), "Sorry for the delay" (if large gap), etc.

---

#### Context Usage
**Purpose:** Token budget awareness for self-management.

**Agent can:**
- Request summarization when approaching limit
- Proactively compress older conversation history
- Signal approaching context window exhaustion
- Optimize response length based on remaining budget

**Example agent response:**
"I see we're at 85% context usage. Would you like me to summarize our earlier discussion before continuing?"

---

#### Git Status
**Purpose:** Environmental grounding in code repository state.

**Structured format** (not verbatim shell output):
- Current branch
- Modified files (list)
- Recent commits (last 3 with hashes)

**Rationale:** Agent understands working environment, can reference recent changes, knows what branch they're on.

**Token savings:** Structured XML (~100 tokens) vs. full `git status` output (~300 tokens).

---

#### Working Directory
**Purpose:** Spatial awareness for file operations, tool use.

**Simple:** Absolute path to current working directory.

**Enables:** Agent uses relative paths correctly, understands where tool outputs will land.

---

#### ASM Conspectus (Advanced)
**Purpose:** Context tracking for temporal annotations.

**When ASM (Attentive Semantic Memory) active:**
- Tracks which documents currently loaded
- Hash of conspectus (detect context shifts)
- Status: `current | stale | refreshing`

**Enables temporal annotations:**

When conspectus hash changes between turns, system adds temporal annotation to provider payload:

```json
{
  "role": "assistant",
  "content": "Your original response from 3 turns ago...",
  "temporal_annotation": "This was your response when you had temporal-coherence.md in context (now removed). Current context includes principia-api.md for implementation work."
}
```

**Agent understands:** "I said that in different context - adjusting my approach now."

---

### Compression Strategy

**Trigger:** After N turns (typically N=3).

**Algorithm:**

```python
def compress_snapshot(snapshot_xml):
    # Extract metadata
    audit_trail = extract_audit_trail(snapshot_xml)

    # Build compressed version
    return f"""
    <tracking-snapshot>
      <timestamp>{audit_trail.timestamp}</timestamp>
      [conversation continued from here, so tracking snapshot condensed -
       can be found in {session_path} commit {commit_hash}]
      <audit-trail session="{session}" turn="{turn}" commit="{commit}"/>
    </tracking-snapshot>
    """
```

**Token savings calculation:**
- Full snapshot: ~600 tokens
- Compressed: ~150 tokens
- Savings: ~450 tokens per snapshot
- 50-turn conversation: compress 47 snapshots = ~21,000 tokens saved

**Causal annotation:** Compressed snapshots include reference to git commit, so agent knows WHY snapshot is compressed (not experiential incoherence).

---

### Injection Point: Latest Message Only

**Strategy (critical for efficiency):**

1. **Compress all old snapshots** in conversation history (apply to user messages from previous turns)
2. **Generate fresh snapshot** for current turn
3. **Inject fresh snapshot into latest user message** only

**Why this works:**
- Provider sees full temporal context on current turn
- Historical turns retain compressed snapshots (minimal tokens)
- Agent has complete temporal awareness without context bloat

**Implementation pattern:**

```python
def prepare_messages_for_provider(conversation_history, current_user_message):
    # Compress old snapshots
    compressed_history = [
        compress_snapshot_in_message(msg)
        if msg.role == "user" and contains_snapshot(msg)
        else msg
        for msg in conversation_history
    ]

    # Generate fresh snapshot
    fresh_snapshot = generate_tracking_snapshot(
        pending_messages=get_queue(),
        last_snapshot_time=last_snapshot_time,
        session_ref=session_ref
    )

    # Inject into current message
    current_message_with_snapshot = prepend_snapshot(
        current_user_message,
        fresh_snapshot
    )

    return compressed_history + [current_message_with_snapshot]
```

---

### Recovery & Expansion

**Scenario 1: Crash Recovery**

Agent recovers from persistent session:
```python
{:ok, state} = Session.recover_state(session_ref)
# state.history contains messages with compressed snapshots
# Agent sees compression annotations, understands continuity
```

**Scenario 2: Manual Expansion**

Agent or user requests full snapshot from history:
```python
tool_call: {
  name: "expand-snapshot",
  arguments: {turn: 15}
}

# Tool reads git commit, reconstructs full snapshot XML
```

---

### Implementation Considerations

#### Producers & Consumers

| Component | Role | Responsibilities |
|-----------|------|------------------|
| **Agent Runtime** | Producer | Generates fresh snapshots on each turn, triggers compression |
| **Session Manager** | Collector | Gathers pending messages, provides to runtime |
| **Event Log** | Auditor | Records snapshots in append-only log, provides commit hashes |
| **UI** | Renderer | Displays snapshots with visual cues (full vs compressed) |
| **ASM** | Contributor | Provides conspectus hash and document list (advanced) |

---

#### Format Agnosticism

**Example shows XML**, but pattern is format-agnostic:

- **XML**: Human-readable, widely supported
- **JSON**: Machine-optimized, smaller tokens
- **YAML**: Middle ground (readability + structure)
- **Custom**: Optimized for specific providers

**Choose based on:**
- Provider's preferred format
- Token efficiency needs
- Human readability requirements
- Tooling availability

---

### Research Findings & Open Questions

#### Finding 1: Temporal Annotations Prevent Context Confusion

**Observation:** When ASM context changes mid-conversation, agents produce incoherent responses if not explicitly told about the shift.

**Example:**
- Turn 5: Agent responds using docs from file A (in context)
- Turn 10: File A removed, file B added (ASM refresh)
- Turn 11: User asks follow-up to turn 5 response
- **Without temporal annotation:** Agent confused (references file A, but can't find it)
- **With temporal annotation:** Agent knows "my earlier response was in different context, adjusting"

**Implication:** Temporal annotations are critical for multi-turn coherence when context shifts.

---

#### Finding 2: Pending Message Visibility Improves Responsiveness

**Observation:** When urgent messages queued, agents should see them immediately (not wait for dequeuing).

**Example:**
- User: "Analyze this large file" (will take 30 seconds)
- User (15 seconds later, queues): "URGENT: Stop, security issue!"
- **Without pending visibility:** Agent finishes analysis, then sees urgent message (wasted work)
- **With pending visibility:** Agent sees urgent message in snapshot, aborts analysis

**Implication:** Queued messages should appear in snapshots, not hidden until dequeued.

---

#### Finding 3: Compression Threshold Tradeoff

**Question:** After how many turns to compress snapshots?

**Tested values:**
- N=1 (compress immediately): Too aggressive, agent loses recent context
- N=3 (Ruby implementation default): Good balance
- N=10 (conservative): Minimal token savings

**Recommendation:** N=3 appears optimal for most use cases. Configurable for specific needs.

---

#### Open Question 1: Snapshot Toggle Tool

**Proposal:** Should agents be able to disable snapshots?

**Use cases:**
- **Token optimization:** When context window tight, disable snapshots temporarily
- **Testing:** Verify agent behavior without temporal awareness
- **Privacy:** User prefers not to expose git status, file paths

**Proposed interface:**
```python
tool_call: {
  name: "toggle-tracking-snapshot",
  arguments: {enabled: false}
}
```

**Research needed:** Does toggling break temporal coherence too severely?

---

#### Open Question 2: Proof Status in Snapshots

**Proposal:** Attach cryptographic proof status to snapshots (for sovereign agent systems).

**Example:**
```xml
<tracking-snapshot
  turn="47"
  assurance-level="1"
  signature-valid="true"
  vc-verified="true">
  ...
</tracking-snapshot>
```

**Use case:** Agent can verify snapshot hasn't been tampered with (sovereign identity systems).

**Research needed:** Performance overhead of signature verification per turn?

---

### Relationship to Other Architectures

#### Integration with ALS (Agentic Language Server)

Tracking snapshots fit naturally into ALS architecture:

- **Memory Subsystem:** Snapshots provide environmental beliefs (git status, working directory)
- **Orchestrator:** Uses snapshot data for planning (e.g., knows context budget, can optimize)
- **Client Layer:** UI renders snapshots for user visibility
- **Protocol:** `agent/progressUpdate` can include snapshot delta

**Example ALS integration:**

```json
{
  "method": "agent/progressUpdate",
  "params": {
    "taskId": "task-123",
    "snapshot": {
      "time_elapsed": "PT2M15S",
      "context_usage": "12.5%",
      "git_status": {
        "branch": "main",
        "modified": ["file1.ex", "file2.ex"]
      }
    }
  }
}
```

---

#### Integration with Storage-Intention Framework

Snapshots declare storage intentions:

- **Immediate:** Full snapshot in current turn (volatile)
- **Session:** Recent 3 snapshots (compress older)
- **Project/ELI:** Audit trail preserved in git commits (permanent)

**Compression strategy maps to retention levels:**
- Immediate: Latest snapshot only (full detail)
- Session: Last 3 snapshots (full detail)
- ELI/Project: All snapshots (compressed, audit trail only)
- Permanent: Snapshot schema evolution (PRAXES - "how we did snapshots in 2025")

For storage intention executor implementation, see [[06-elixir-implementation-patterns#storage-intention-executor]].

---

#### Integration with Sovereign Configuration Editing

Tracking snapshots complement sovereign editing patterns:

- **Audit trail field** in snapshots references git commits from configuration edits
- **Pending messages** may include configuration change requests (e.g., "suspend yourself")
- **ASM conspectus** tracks which configuration documents currently loaded
- **Recovery** from snapshots can trigger configuration re-validation

**Example integration:**

```python
# Agent receives message with snapshot
snapshot = extract_snapshot(user_message)

# Snapshot indicates pending configuration change
if snapshot.pending_messages.any(priority="urgent"):
    # Check if urgent message is configuration-related
    for msg in snapshot.pending_messages:
        if is_configuration_command(msg):
            # Use three-layer editing pattern
            result = ConfigurationEditor.apply_command(msg)

            # Next snapshot will show:
            # - Git commit hash in audit trail
            # - EventLog append completion
            # - Timestamp of configuration change
```

For three-layer sovereign editing pattern, see [[03-formal-methods-validity-guarantees#sovereign-configuration-editing]].

---

### Practical Recommendations

**For implementers:**

1. **Start simple:** Implement time passage + context usage only (core value)
2. **Add incrementally:** Git status, pending messages, ASM conspectus as needed
3. **Measure tokens:** Verify compression savings match predictions
4. **Test recovery:** Ensure compressed snapshots can be expanded from audit trail
5. **UI feedback:** Show snapshot data to users (transparency builds trust)

**For researchers:**

1. **Evaluate impact:** Does temporal awareness improve agent coherence? (A/B test)
2. **Optimize compression:** Can we compress more aggressively without losing signal?
3. **Explore formats:** Is XML optimal, or better alternatives? (JSON, binary)
4. **Study thresholds:** Is N=3 universally optimal, or task-dependent?
5. **Investigate expansions:** What other environmental signals belong in snapshots?

---

### Summary

**Tracking snapshots solve the temporal coherence problem** by making environmental/temporal context explicit rather than hidden. This pattern:

✅ **Prevents "suspended animation"** - Agents experience time passage
✅ **Grounds in environment** - Git status, working directory, pending input visible
✅ **Enables self-management** - Context budget awareness
✅ **Supports recovery** - Audit trails enable expansion from compressed form
✅ **Token-efficient** - Compression saves ~20K tokens per 50-turn conversation

**Key insight:** Temporal coherence isn't just timestamps - it's making the agent's lived experience match reality. Snapshots are the implementation of that principle.

**Status:** Proven pattern in Ruby implementation ([Sapientia minimal-sapientia](https://github.com/josephwecker/sapientia)), generalized here for broader applicability. Integration with ALS and storage-intention framework demonstrates architectural composability.

---

## 11. Context Engineering for Code Intelligence: Empirically-Grounded Specialization

### The Central Challenge: Bridging General Knowledge with Specific Codebases

**Problem:** Large language models possess vast general knowledge but lack grounded understanding of specific codebases. Simply feeding entire repositories into the context window is computationally infeasible (~millions of lines) and counterproductive—irrelevant context "poisons" or "distracts" the model, degrading output quality.

**Goal:** Identify and provide the **smallest possible set of high-signal tokens** that maximizes probability of agent achieving its desired outcome successfully.

**Research synthesis:** This section consolidates empirical findings from large-scale studies comparing code representations, model architectures, and retrieval strategies for specialized AI agents.

---

### 11.1 Code Representation Techniques: The Foundation for Agent Input

**Core insight:** The choice of code representation directly impacts an agent's ability to reason about syntax, structure, and semantics. A spectrum of techniques has evolved from simple sequences to rich multi-layered graphs.

---

#### Sequential Representations: Code as Token Streams

**Methodology:**
```python
# Tokenization process
source_code = "calculate_final_score(user_id, bonus)"

# Token sequence
tokens = ["calculate", "_", "final", "_", "score", "(", "user_id", ",", "bonus", ")"]

# Embedding
embeddings = [embedding_layer(token) for token in tokens]
# → Feed to Transformer/LSTM/RNN
```

**Strengths:**
- Simple, scalable
- Leverages standard NLP models (BERT, GPT, T5)
- Common starting point for many code tasks

**Weaknesses:**
- **Structural naivety:** Treats `a = b + c` and `a = c + b` as different sequences (ignores semantic equivalence)
- **No hierarchy:** Loses statement nesting, scoping rules, control flow
- **Distance blindness:** Distant dependencies invisible (e.g., function definition far from call site)

**Empirical standing:** Outperformed by structure-aware methods on tasks requiring deep semantic understanding (clone detection, vulnerability analysis).

**When to use:** Simple classification tasks, code search (keyword matching), initial prototyping.

---

#### Syntactic Representations: Abstract Syntax Trees

**Methodology:**
```python
# Parse code to AST
ast = parse_to_ast("""
def charge(amount):
    if amount > 0:
        return process_payment(amount)
""")

# AST structure (simplified)
FunctionDef(
    name='charge',
    args=['amount'],
    body=[
        If(
            test=Compare(Name('amount'), ['>'], [Num(0)]),
            body=[Return(Call(Name('process_payment'), [Name('amount')]))]
        )
    ]
)
```

**Strengths:**
- **Captures precise hierarchical structure:** Operator precedence, statement nesting explicit
- **Language-agnostic:** Every language has AST parser
- **Widely used:** Compiler infrastructure, refactoring tools, code analysis

**Weaknesses:**
- **Syntax-only:** No semantic information (control flow, data flow)
- **Incomplete view:** Doesn't show which statement executes after `if` block, or where `amount` value originates

**Application patterns:**
- **code2vec:** Learns embeddings from AST paths (e.g., path from `charge` to `amount` via `Compare`)
- **Tree-LSTMs:** Neural networks designed to process tree structures
- **Structural clone detection:** Find code fragments with similar AST patterns

**Empirical standing:** Strong baseline for many tasks. Models processing AST paths outperform sequential models on method naming, program classification.

**When to use:** Tasks requiring syntactic understanding (refactoring suggestions, coding standard violations), feature extraction for ML models.

---

#### Semantic Representations: Control Flow and Data Dependencies

**Control Flow Graph (CFG):**
```python
# Source code
def process_order(order):
    if validate(order):
        result = charge(order.amount)
        if result.success:
            ship(order)
            return "shipped"
        else:
            return "payment_failed"
    else:
        return "validation_failed"

# CFG representation (nodes = basic blocks, edges = control flow)
[Entry] → [validate(order)]
    ↓ true                  ↓ false
[charge(...)] → [ship(...)] → [return "shipped"]
    ↓ false
[return "payment_failed"]
                ↓
            [return "validation_failed"]
```

**Program Dependency Graph (PDG):**
```python
# Data dependency edges
order.amount ──(defines)──> charge(order.amount)
result.success ──(uses)──> if result.success

# Control dependency edges
validate(order) ──(controls)──> charge(...)
result.success ──(controls)──> ship(order)
```

**Strengths:**
- **Models behavior:** Shows execution paths, data propagation
- **Essential for analysis:** Bug detection, program slicing, security analysis

**Weaknesses:**
- **Partial views:** CFG shows flow but not data, PDG shows dependencies but not sequence
- **Construction complexity:** Challenging for dynamic languages, indirect jumps, function pointers

**When to use:** Security analysis (tracing tainted data), compiler optimization, fault localization.

---

#### Unified Representations: Code Property Graph

**Methodology:** Overlay AST + CFG + PDG into single interconnected graph.

```python
# Example CPG traversal for taint analysis
# Question: Does user_input reach database query?

start_node = cpg.find_node(type='parameter', name='user_input')

# Follow data flow edges
data_path = cpg.traverse(
    start=start_node,
    edge_type='data_flow',
    until=lambda n: n.type == 'database_query'
)

# Check if path exists without sanitization
if data_path and not any(n.is_sanitizer() for n in data_path):
    vulnerability_detected = True
```

**Strengths:**
- **Most comprehensive representation:** Captures syntax, control flow, data flow simultaneously
- **Powerful for complex patterns:** Taint-style vulnerabilities, cross-function analysis
- **Queryable:** Pattern matching across multiple semantic dimensions

**Empirical standing:** **Consistently outperforms other techniques** across diverse tasks (code classification, method naming, vulnerability detection). Graph-based representations superior to sequence/tree-based by significant margins (15.7% accuracy gain for classification, 9.3% F1 for clone detection).

**When to use:** Tasks requiring deep semantic understanding (vulnerability detection, complex refactoring, architectural analysis).

**Tooling:** Joern (open-source CPG generator), TAILOR (GNN-based model for CPG).

---

#### Learned Representations: Pre-trained Transformer Models

**Evolution:**

**1. code2vec (2018):** Learn embeddings from AST paths
```python
# Sample AST path: function_name → parameter → comparison
embedding = aggregate([
    embed(path_1),  # charge → amount → >
    embed(path_2),  # charge → process_payment → call
    # ...
])
```

**2. CodeBERT (2020):** Bimodal model (code + natural language)
```python
# Pre-training objective: Masked Language Modeling
input = "def [MASK](amount): return amount * 1.15"
model_predicts = "calculate_tax"
```

**3. GraphCodeBERT (2021):** Incorporates data flow graph
```python
# Pre-training with data flow awareness
code_tokens = ["session", "=", "request", ".", "get_session", "(", ")"]
data_flow = {
    "session": ["request.get_session()"],  # Where session value comes from
    # ...
}
# Model learns to attend to data flow relationships
```

**4. CodeT5 (2022):** Encoder-decoder for generation + understanding
```python
# Versatile architecture
encoder: Code → representation (for classification, search)
decoder: Representation → code (for generation, translation, summarization)
```

**Empirical comparison:**

| Model | Architecture | Best For | Key Strength |
|-------|-------------|----------|--------------|
| **CodeBERT** | Encoder-only (BERT) | Code search, classification | Bimodal (code + NL), strong baseline |
| **GraphCodeBERT** | Encoder-only + data flow | Vulnerability detection, clone detection | Structure-aware, data flow reasoning |
| **CodeT5** | Encoder-decoder (T5) | Code generation, summarization, translation | Versatile (understanding + generation) |
| **UniXcoder** | Encoder + cross-attention | Cross-lingual tasks | Unified representation across languages |

**Performance synthesis:**
- **Code search:** GraphCodeBERT, UniXcoder excel (leveraging structure + bimodal training)
- **Vulnerability detection:** GraphCodeBERT superior (data flow critical for many vulnerability patterns)
- **Code summarization:** CodeT5, PLBART best (encoder-decoder required for generation)
- **Code generation:** CodeT5, Codex, StarCoder (decoder architecture + generation pre-training mandatory)

**When to use:**
- **GraphCodeBERT:** Semantic analysis tasks (vulnerability detection, bug finding, semantic search)
- **CodeT5:** Generation tasks (summarization, translation, synthesis)
- **CodeBERT:** Baseline or when structure not critical (simple classification)

**Cross-reference:** For logostratum catalog integration and model capability detection, see [[#4-secure-execution-environment]].

---

### 11.2 Empirical Performance: Which Representations for Which Tasks

**Research foundation:** Large-scale comparison of 19 pre-trained models on 13 software engineering tasks, plus systematic evaluation of representation techniques.

---

#### Graph-Based Representations: Empirical Superiority

**Finding 1:** Graph-based representations (CPG) outperform sequence/tree-based across all evaluated tasks (code classification, method naming, vulnerability detection).

**Magnitude:** +15.7% accuracy (classification), +11% F1 (method naming), +9.3% F1 (clone detection) when augmenting AST with semantic graphs (CFG + PDG).

**Explanation:** Diverse program semantics (control flow, data flow, syntactic structure) captured in single queryable structure enables richer pattern recognition.

**Cost:** Increased preprocessing complexity and time (generating CPG more expensive than tokenization or AST parsing).

---

#### Graph Neural Networks: State-of-the-Art for Structural Tasks

**Methodology:** GNNs iterate node representations through message passing:
```python
# Simplified GNN layer
def gnn_layer(graph, node_features):
    for node in graph.nodes:
        # Aggregate neighbor features
        neighbor_features = [node_features[n] for n in graph.neighbors(node)]
        aggregated = mean(neighbor_features)

        # Update node representation
        node_features[node] = neural_network(
            concatenate([node_features[node], aggregated])
        )

    return node_features
```

**Empirical success:**
- **Fault localization:** GNN on enhanced dependency graph outperforms baseline, with 70% graph complexity reduction (DepGraph technique)
- **Readability classification:** GNN effectively learns structural patterns correlating with human readability judgments
- **Vulnerability detection:** GNN on CPG achieves state-of-the-art results (TAILOR model)

**Scalability challenge:** Real-world software graphs contain millions of nodes/edges. Recent advances (DepGraph pruning, hierarchical GNNs) address this by reducing graph size while improving accuracy.

**When to use:** Tasks where structural relationships critical (fault localization, vulnerability detection, architectural analysis).

---

#### Pre-trained Model Selection Guide

**Task-specific recommendations:**

**Semantic search / Code retrieval:**
```python
# Use: GraphCodeBERT or UniXcoder
# Why: Bimodal pre-training (NL queries + code) + structure awareness

query_embedding = graphcodebert.encode("find payment processing function")
code_embeddings = [graphcodebert.encode(snippet) for snippet in codebase]
matches = rank_by_similarity(query_embedding, code_embeddings)
```

**Clone detection:**
```python
# Use: GraphCodeBERT or CodeT5
# Why: Capture deep structural/semantic similarity beyond token matching

embedding_1 = model.encode(code_fragment_1)
embedding_2 = model.encode(code_fragment_2)
similarity = cosine_similarity(embedding_1, embedding_2)
if similarity > threshold:
    clone_detected = True
```

**Vulnerability detection:**
```python
# Use: GraphCodeBERT or Devign (GNN on CPG)
# Why: Data flow reasoning essential for taint-style vulnerabilities

cpg = generate_code_property_graph(source_file)
features = gnn_model.extract_features(cpg)
vulnerability_prob = classifier(features)
```

**Code generation / synthesis:**
```python
# Use: CodeT5, Codex, StarCoder
# Why: Decoder architecture + generative pre-training required

prompt = "Generate Python function to validate email address"
generated_code = codet5.generate(prompt, max_length=100)
```

**Code summarization / documentation:**
```python
# Use: CodeT5, PLBART
# Why: Encoder-decoder structure ideal for code → NL translation

code_input = "def charge(amount): ..."
summary = codet5.summarize(code_input)
# Output: "Processes payment for specified amount"
```

**Cross-language translation:**
```python
# Use: CodeT5, GraphCodeBERT
# Why: Multilingual pre-training corpus + structure awareness

python_code = "def add(a, b): return a + b"
javascript_code = codet5.translate(python_code, target_lang="javascript")
# Output: "function add(a, b) { return a + b; }"
```

---

### 11.3 Multi-Modal Context Retrieval: Three-Stage Strategy

**Inspired by:** Construction of production AI coding assistants (Sourcegraph research).

**Objective:** Cast wide net (high recall) → expand via graph → rank and compact (high precision).

---

#### Stage 1: Broad Retrieval (Recall-Oriented)

**Goal:** Gather large set of potentially relevant context from diverse sources.

**Methods (run in parallel):**

**1. Keyword Search (Exact/Near-exact matching):**
```python
# Fast trigram-based search (e.g., Zoekt)
query = "payment processing error handling"
keywords = extract_keywords(query)  # ["payment", "processing", "error"]

results_keyword = search_engine.search(keywords, fuzzy=True)
# Returns: Files containing "payment", "process", "error" terms
```

**2. Semantic Search (Conceptual matching):**
```python
# Embed query and code chunks with specialized model
query_embedding = code_embedding_model.encode(query)

# Pre-computed embeddings for codebase chunks
chunk_embeddings = load_precomputed_embeddings()

# Vector similarity search
results_semantic = vector_search(
    query_embedding,
    chunk_embeddings,
    top_k=50
)
# Returns: Code conceptually similar even without keyword overlap
```

**3. Feature Location (IR-based technique):**
```python
# Treat query as feature description
query = "file saving on exit functionality"

# Information retrieval over code + comments
results_feature = feature_locator.locate(
    query,
    codebase,
    method='hybrid'  # VSM + LSI + static analysis
)
# Returns: Ranked list of files/methods implementing feature
```

**Output:** Union of ~100-200 candidate context items (files, functions, documentation snippets).

**Why parallel retrieval:** Different methods find different relevant items (keyword misses conceptual matches, semantic misses exact references, etc.). Union maximizes recall.

---

#### Stage 2: Graph-Based Expansion (Structure-Aware)

**Goal:** Use initial "seeds" to discover connected context via program structure.

**Methods:**

**1. Data Flow Analysis (Backward/Forward slicing):**
```python
# Seed: Variable of interest (e.g., session_token)
seed_var = "session_token"

# Backward slice: Where does value originate?
backward_slice = cpg.traverse_data_flow(
    start=seed_var,
    direction='backward',
    max_depth=5
)
# Finds: session_token = request.headers.get('Authorization')

# Forward slice: Where is value used?
forward_slice = cpg.traverse_data_flow(
    start=seed_var,
    direction='forward',
    max_depth=5
)
# Finds: All functions consuming session_token
```

**2. Control Flow Analysis (Callers/Callees):**
```python
# Seed: Function identified in Stage 1
seed_function = "process_payment"

# Find callers (who uses this?)
callers = cfg.find_callers(seed_function)

# Find callees (what does this use?)
callees = cfg.find_callees(seed_function)

# Expand context to include execution context
expanded_context = [seed_function] + callers + callees
```

**3. Socio-Technical Expansion (Repository mining):**
```python
# For each high-ranking file from Stage 1
for file in top_files:
    # Find primary code owners
    owners = git_blame_analysis(file)
    # owners = {'jane.doe': 0.85, 'john.smith': 0.10}

    # Find historically co-evolved files
    coevolved = coupled_change_analysis(file)
    # coevolved = ['payment_service.py', 'payment_tests.py', 'api_docs.yaml']

    # Add to context
    context.add_metadata({
        'file': file,
        'experts': owners,
        'related_files': coevolved
    })
```

**Output:** Expanded set of ~300-500 context items with structural/historical relationships.

**Why graph expansion:** Textual search misses critical dependencies not expressed in keywords (e.g., function call 10 files away, data flow across modules).

---

#### Stage 3: Ranking and Compaction (Precision-Oriented)

**Goal:** Filter down to most relevant subset fitting token budget.

**Methods:**

**1. Cross-Encoder Ranking (Computationally expensive but accurate):**
```python
# Re-rank using model that examines query + context together
scores = []
for context_item in expanded_context:
    # Cross-encoder sees both query and context
    score = cross_encoder.score(query, context_item)
    scores.append((context_item, score))

# Sort by relevance
ranked_context = sorted(scores, key=lambda x: x[1], reverse=True)
```

**2. Token-Budget Selection (Knapsack problem):**
```python
# Select top items within token limit
selected_context = []
token_count = 0
token_budget = 8000  # Reserve for response

for item, score in ranked_context:
    item_tokens = count_tokens(item)

    if token_count + item_tokens <= token_budget:
        selected_context.append(item)
        token_count += item_tokens
    else:
        break  # Budget exhausted
```

**3. Summarization for Large Items (Reduce token footprint):**
```python
# For files exceeding threshold (e.g., >500 tokens)
for item in selected_context:
    if count_tokens(item) > 500:
        # Automated summarization
        summary = summarizer.extract_key_sections(
            item,
            focus=query,
            max_tokens=200
        )
        # Replace full file with summary
        selected_context[selected_context.index(item)] = summary
```

**Output:** Final context package (~8,000 tokens) with highest relevance density.

**Why ranking & compaction:** LLMs perform better with focused, high-signal context than large, diluted context. Precision matters more than recall at this stage.

---

### 11.4 Agent Specialization: Domain-Specific Architectures

**Pattern:** Instead of single generalist agent, develop suite of specialized agents with task-optimized representations and retrieval strategies.

---

#### SecurityAuditor Agent: Vulnerability Detection

**Specialization:**
- **Input representation:** Code Property Graph (CPG) - essential for data flow analysis
- **Model architecture:** Graph Neural Network (GNN) over CPG
- **Context retrieval:** Prioritize data flow paths, known vulnerability patterns

**Implementation sketch:**
```python
class SecurityAuditorAgent:
    def __init__(self):
        self.cpg_generator = CodePropertyGraphGenerator()
        self.gnn_model = load_pretrained_gnn('devign')  # Vulnerability detection GNN
        self.vuln_patterns = load_known_patterns()  # CVE database

    def analyze(self, source_file):
        # Stage 1: Generate CPG
        cpg = self.cpg_generator.parse(source_file)

        # Stage 2: Extract features via GNN
        graph_features = self.gnn_model.encode(cpg)

        # Stage 3: Check against known patterns
        for pattern in self.vuln_patterns:
            if self.pattern_matches(cpg, pattern):
                yield Vulnerability(
                    type=pattern.name,
                    location=pattern.match_location,
                    severity=pattern.severity
                )

        # Stage 4: ML-based detection
        vuln_prob = self.gnn_model.classify(graph_features)
        if vuln_prob > threshold:
            yield Vulnerability(
                type='potential_unknown',
                probability=vuln_prob
            )
```

**Why this works:** Data flow analysis (built into CPG) essential for detecting taint-style vulnerabilities (e.g., SQL injection, XSS). GNN learns structural patterns correlating with vulnerabilities.

**Evidence:** GraphCodeBERT + GNN-based models outperform traditional static analyzers on vulnerability detection benchmarks.

---

#### ArchitecturalRefactor Agent: Modularity Analysis

**Specialization:**
- **Input representation:** Module Dependency Graph (MDG) + code ownership data
- **Analysis technique:** Software clustering (hierarchical, search-based)
- **Metrics:** Modularity (Q), cyclomatic complexity, coupling/cohesion

**Implementation sketch:**
```python
class ArchitecturalRefactorAgent:
    def __init__(self):
        self.mdg_builder = ModuleDependencyGraphBuilder()
        self.clusterer = HierarchicalClusterer()
        self.git_miner = GitRepositoryMiner()

    def analyze_modularity(self, codebase):
        # Stage 1: Build dependency graph
        mdg = self.mdg_builder.build(codebase)

        # Stage 2: Cluster into modules
        clusters = self.clusterer.partition(mdg, optimize='modularity')

        # Stage 3: Assess quality
        modularity_score = calculate_modularity(clusters)
        complexity_per_cluster = [
            calculate_cyclomatic_complexity(cluster)
            for cluster in clusters
        ]

        # Stage 4: Mine socio-technical context
        ownership_analysis = self.git_miner.analyze_ownership(codebase)
        weak_ownership_modules = [
            cluster for cluster in clusters
            if ownership_analysis[cluster]['strength'] < 0.5
        ]

        # Stage 5: Generate recommendations
        recommendations = []
        for cluster in weak_ownership_modules:
            if complexity_per_cluster[cluster] > threshold:
                recommendations.append({
                    'module': cluster,
                    'issue': 'high_complexity + weak_ownership',
                    'risk': 'defect-prone area',
                    'suggestion': 'assign clear owner, refactor complex components'
                })

        return recommendations
```

**Why this works:** Software clustering identifies cohesive modules automatically. Ownership data reveals organizational structure. Together, they guide architectural improvements.

**Evidence:** Code with clear, strong ownership has higher quality and faster bug fixes. Weak ownership correlates with higher defect rates.

---

#### BugFixer Agent: Fault Localization

**Specialization:**
- **Input representation:** Enhanced Dependency Graph (DepGraph) + execution traces
- **Model architecture:** GNN for fault localization
- **Context retrieval:** Combine feature location (map bug report to code) + dynamic analysis (execution trace)

**Implementation sketch:**
```python
class BugFixerAgent:
    def __init__(self):
        self.feature_locator = FeatureLocator()
        self.depgraph_builder = DepGraphBuilder()  # Pruned CPG for scalability
        self.gnn_localizer = load_pretrained_gnn('fault_localization')

    def locate_bug(self, bug_report, test_case):
        # Stage 1: Feature location (map bug report to code)
        candidate_files = self.feature_locator.locate(
            query=bug_report.description,
            codebase=self.codebase,
            method='hybrid'  # IR + static analysis
        )

        # Stage 2: Dynamic analysis (reproduce bug)
        trace = self.execute_test_case(test_case)
        # trace = list of executed statements

        # Stage 3: Build enhanced dependency graph
        # Focus on files in trace + candidates
        relevant_files = set(candidate_files + trace.files)
        depgraph = self.depgraph_builder.build(
            files=relevant_files,
            prune_inter_procedural=True  # 70% complexity reduction
        )

        # Stage 4: GNN-based localization
        fault_prob = self.gnn_localizer.localize(
            graph=depgraph,
            execution_trace=trace,
            failing_test=test_case
        )

        # Stage 5: Rank suspicious statements
        ranked_statements = sorted(
            fault_prob.items(),
            key=lambda x: x[1],
            reverse=True
        )

        return ranked_statements[:10]  # Top 10 most suspicious
```

**Why this works:** Combining textual analysis (bug report → code) with dynamic analysis (execution trace) and structural analysis (dependency graph) provides multi-faceted evidence.

**Evidence:** GNN-based fault localization on DepGraph outperforms baseline methods, with 70% graph complexity reduction enabling scalability.

---

### 11.5 Context Engineering Cookbook: Mapping Needs to Techniques

**Practical guide:** Match agent's information need to appropriate analysis technique and retrieval method.

| Agent Information Need | Analysis Technique | Retrieval Method | Example Context Snippet |
|------------------------|-------------------|------------------|--------------------------|
| "What is syntactic structure of this function?" | AST Parsing | Static analysis of specific file | `(function_declaration name: 'process_payment' params: ['amount'] ...)` |
| "Where does session_token value come from?" | Data Flow (PDG/CPG) | Graph traversal (backward slice) | `session_token = request.headers.get('Authorization')` |
| "What will be affected if I change this function?" | Control Flow (CFG/CPG) | Graph traversal (forward slice, callers) | `Callers: [handle_user_request, validate_session]` |
| "Who are the experts on this module?" | Code Ownership (MSR) | Git commit log analysis | `Owners: {'jane.doe': 0.85, 'john.smith': 0.10}` |
| "What files usually change with this one?" | Code Evolution (MSR) | Coupled change mining | `Co-evolved: ['payment_service.py', 'payment_service_test.py', 'api_docs.yaml']` |
| "How does user authentication work?" | Feature Location | Hybrid IR (semantic + keyword) | Ranked methods: `login`, `logout`, `verify_token` + excerpts from `auth.md` |
| "Is this code vulnerable to SQL injection?" | Taint Analysis (CPG) | Data flow from user input to query | `user_input → query_builder (no sanitization) → db.execute` |
| "What design patterns are used here?" | AST + Heuristics | Pattern matching on AST | `Detected: Singleton (private constructor + getInstance method)` |

**Usage pattern:**
```python
def engineer_context(agent_goal, codebase):
    # Parse goal into information needs
    needs = parse_goal(agent_goal)
    # Example: "Fix SQL injection bug" → needs data flow analysis

    context_items = []

    for need in needs:
        # Lookup technique
        technique = CONTEXT_COOKBOOK[need]['technique']
        retrieval = CONTEXT_COOKBOOK[need]['retrieval']

        # Execute retrieval
        result = execute_retrieval(technique, retrieval, codebase)
        context_items.append(result)

    # Assemble final context
    return assemble_context(context_items, token_budget=8000)
```

---

### 11.6 Integration with ALS Architecture

**Context engineering fits naturally into ALS components:**

#### Orchestrator Integration
```python
class Orchestrator:
    def handle_goal(self, goal):
        # Stage 1: Perceive (gather context via context engineering)
        context = self.context_engineer.retrieve(
            goal=goal,
            strategy='three_stage',  # Broad → Expand → Rank
            representation='cpg' if 'security' in goal else 'ast',
            token_budget=self.remaining_context_tokens()
        )

        # Stage 2: Plan (use context for planning)
        plan = self.model.plan(goal, context, available_skills=self.skills.list())

        # Stage 3: Act & Reflect
        # ... (existing logic)
```

#### Memory Subsystem Integration
```python
# Store code ownership, feature location results in Declarative Beliefs
memory.declarative.store({
    'category': 'codebase_structure',
    'key': 'payment_module_owners',
    'value': {'jane.doe': 0.85, 'john.smith': 0.10},
    'source': 'git_mining'
})

# Retrieve for future tasks
owners = memory.declarative.query(
    category='codebase_structure',
    key='payment_module_owners'
)
```

#### Skill Registry Integration
```yaml
# skill.yaml for SecurityAuditor
name: "security-auditor"
description: "Detects vulnerabilities using CPG + GNN analysis"

parameters:
  - name: "target_file"
    type: "string"

context_requirements:
  representation: "cpg"  # Requires Code Property Graph
  retrieval_strategy: "data_flow_focused"  # Prioritize data flow paths
  token_budget: 10000

tools:
  - name: "generate_cpg"
    script: "scripts/build_cpg.py"
  - name: "run_gnn_analysis"
    script: "scripts/gnn_vuln_detect.py"
```

---

### 11.7 Research Synthesis: Key Findings for Practitioners

#### Finding 1: Representation Matters More Than Scale

**Evidence:** Graph-based representations (CPG) consistently outperform larger models using simpler representations (sequences, ASTs) on semantic tasks.

**Implication:** Don't just throw larger models at the problem. Co-design representation + model architecture for the task.

**Example:** GraphCodeBERT (data flow + BERT) outperforms vanilla BERT-Large (2x parameters) on vulnerability detection by ~15% F1.

---

#### Finding 2: Task-Specific Pre-training Objectives Are Critical

**Evidence:** Models pre-trained with generative objectives (e.g., CodeT5) excel at generation tasks. Models pre-trained with contrastive objectives (e.g., GraphCodeBERT) excel at retrieval/classification.

**Implication:** Match pre-training strategy to downstream task. Don't use generation-focused model for classification-only task.

**Example:** CodeT5 (encoder-decoder) outperforms CodeBERT (encoder-only) on summarization by ~20% BLEU, but CodeBERT is faster and sufficient for code search.

---

#### Finding 3: Socio-Technical Context Is Underutilized

**Evidence:** Code ownership and change coupling data strongly correlate with defect likelihood and maintenance effort, yet most code intelligence models ignore this signal.

**Implication:** Incorporate repository mining data into agent context. Not just syntax/semantics, but also human organization.

**Example:** Agents that query code ownership can auto-assign reviewers, proactively check weak-ownership areas, understand module expertise.

---

#### Finding 4: Context Retrieval Is a Multi-Armed Bandit Problem

**Evidence:** No single retrieval method (keyword, semantic, feature location) dominates across all queries. Optimal strategy varies by task.

**Implication:** Use ensemble retrieval (parallel methods) + learned ranking. Over time, learn which methods work for which query types.

**Future research:** Multi-armed bandit algorithms for adaptive retrieval strategy selection.

---

### 11.8 Open Questions and Future Directions

#### Q1: Automated Context Engineering

**Challenge:** Current context engineering requires manual design (which techniques? what token budget? what representation?).

**Vision:** Meta-agents that learn optimal context retrieval strategy for any given task.

**Approach:**
```python
# Meta-agent learns context engineering policy
def meta_agent_context_policy(task_description, codebase):
    # Historical data: Which context strategies succeeded for similar tasks?
    similar_tasks = task_database.query_similar(task_description)

    # Predict optimal strategy
    predicted_strategy = policy_network.predict(
        task_features=extract_features(task_description),
        historical_outcomes=similar_tasks
    )

    return predicted_strategy
    # Returns: {representation: 'cpg', retrieval: 'data_flow_focused', budget: 8000}
```

**Research needed:** Large-scale dataset of (task, context strategy, outcome) triples.

---

#### Q2: Repository-Level Reasoning

**Challenge:** Current models/agents operate at file/function level. Complex changes span entire repository.

**Vision:** Agents capable of multi-file refactoring, cross-module dependency updates, architectural migrations.

**Approach:**
- **Hierarchical graph representations:** Abstract repository as multi-level graph (repo → modules → files → functions)
- **Progressive disclosure:** Load high-level structure, drill down as needed
- **Cross-file reasoning:** Track dependencies across file boundaries

**Research needed:** Benchmarks for repository-level tasks (not just single-function problems).

---

#### Q3: Neuro-Symbolic Fusion

**Challenge:** LLMs are powerful but lack formal guarantees. Static analysis is rigorous but limited in scope.

**Vision:** Hybrid systems combining neural (LLM) and symbolic (formal analysis) approaches.

**Approach:**
```python
def neurosymbolic_analysis(code):
    # Stage 1: Neural analysis (broad, fuzzy)
    neural_result = llm_agent.analyze(code)

    # Stage 2: Symbolic verification (narrow, precise)
    if neural_result.claims_property('no_sql_injection'):
        formal_proof = symbolic_verifier.verify_no_taint(
            code,
            taint_sources=['user_input'],
            sinks=['database.execute']
        )

        if formal_proof.is_valid():
            return Result(verdict='safe', confidence='high', proof=formal_proof)
        else:
            return Result(verdict='unsafe', confidence='high', counterexample=formal_proof.counterexample)

    return neural_result  # Fallback to neural prediction
```

**Research needed:** Integration patterns, hybrid architectures, verification-friendly code generation.

---

#### Q4: Benchmarking and Evaluation

**Challenge:** Current benchmarks limited to single-function, self-contained problems. Don't reflect real-world complexity.

**Vision:** Realistic, repository-level benchmarks with noisy data, incomplete specifications, conflicting requirements.

**Needed benchmarks:**
- **Multi-file refactoring tasks** (e.g., "migrate from REST to GraphQL across 20 services")
- **Architectural decision tasks** (e.g., "should we split this monolith?")
- **Bug localization with noisy reports** (e.g., user complaints, not precise traces)
- **Long-horizon maintenance** (e.g., "keep this codebase working over 6 months of dependency updates")

**Research needed:** Dataset construction, evaluation metrics beyond accuracy (code quality, maintainability, human preference).

---

### 11.9 Practical Recommendations

**For implementers building specialized agents:**

1. **Start with task analysis:** What information does agent need? (Use context cookbook)
2. **Choose representation:** Match to task (CPG for security, AST for refactoring, learned embeddings for search)
3. **Implement three-stage retrieval:** Broad → Expand → Rank (proven pattern)
4. **Incorporate socio-technical data:** Code ownership, change coupling (underutilized signal)
5. **Measure context quality:** Track precision/recall, not just token count

**For researchers extending state-of-the-art:**

1. **Develop better graph representations:** Scalable CPG generation, hierarchical abstractions
2. **Explore hybrid architectures:** Neuro-symbolic fusion, learned + formal verification
3. **Build realistic benchmarks:** Repository-level tasks, noisy data, long-horizon maintenance
4. **Study context engineering policies:** Meta-learning for adaptive retrieval strategies
5. **Investigate multi-agent coordination:** How should specialized agents collaborate?

**For organizations adopting agent-assisted development:**

1. **Invest in infrastructure:** CPG generators, embedding databases, repository mining pipelines
2. **Build skill libraries:** Reusable, composable agent capabilities (not monolithic systems)
3. **Establish evaluation frameworks:** Measure agent impact on velocity, quality, security
4. **Plan for specialization:** Don't rely on single generalist agent (task-specific is superior)
5. **Incorporate human feedback:** Agents learn from outcomes, not just pre-training data

---

### 11.10 Synthesis: From General LLMs to Specialized Code Intelligence

**Evolution path:**

```
Stage 1: General LLM (2020-2022)
  ├─ GPT-3, BERT for code
  ├─ Limited code understanding
  └─ High error rates on specialized tasks

Stage 2: Code-Pretrained Models (2022-2023)
  ├─ CodeBERT, CodeT5, GraphCodeBERT
  ├─ Better code understanding via specialized pre-training
  └─ Still generalist (not task-optimized)

Stage 3: Specialized Agents (2024-2025)
  ├─ Domain-specific architectures (SecurityAuditor, BugFixer)
  ├─ Task-optimized representations (CPG for security, AST for refactoring)
  ├─ Sophisticated context engineering (three-stage retrieval)
  └─ Empirically-validated performance

Stage 4: Collaborative Agent Systems (Future)
  ├─ Multi-agent coordination protocols
  ├─ Neuro-symbolic fusion
  ├─ Automated context engineering (meta-agents)
  └─ Repository-level reasoning
```

**Key insight:** The trajectory is toward increasing specialization, not larger generalist models. Performance gains come from co-designing representation, architecture, and retrieval strategy for specific tasks.

**Status:** Sections 11.1-11.10 synthesize findings from large-scale empirical studies on code representation, model architectures, and context engineering. Techniques proven in research; integration with ALS architecture demonstrates practical applicability.

**Cross-references:**
- For semantic layer infrastructure (Tree-sitter, AST parsing), see [[01-semantic-technologies-infrastructure#tree-sitter]]
- For tool building philosophy and ubiquitous language, see [[05-tool-building-philosophy-patterns#ubiquitous-language]]
- For Elixir-specific code analysis patterns, see [[06-elixir-implementation-patterns]]

---

## References

No new external references for this document—synthesizes concepts from previous research documents on commercial tools, BDI architecture, LSP design patterns, tracking snapshot implementations, and empirical studies on code representation techniques, pre-trained model performance, and context engineering for specialized agents.
