---
source: ennaos agentic-coding-background/refs — addendum: intent-driven tooling & semantic storage (Oct 31 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/addendum-intent-driven-tooling-and-semantic-storage.md
source_commit: 5abb2fe
categories: [intent-as-parameter, phenomenology-case-study, five-tool-dimensions, conversational-tools, tool-evolution-loop]
why_included: >
  Argues intent should be a *first-class tool parameter* (the tool carries WHY, not just the char-surgery),
  grounded in the citation-work case study where 15 str_replace ops became a "wrong-abstraction" revelation.
  Directly informs UDON's agent-edit-tool design and any harness edit/observation payload: the operation should
  carry intent, not reconstruct it. Five essential tool dimensions + a tool-evolution feedback loop.
---

# Addendum: Intent-Driven Tooling and Semantic Storage
## From Phenomenology to Principled Tool Evolution

**Date:** October 31, 2025  
**Context:** Extension of "Agentic Semantic Code Manipulation" synthesis  
**Purpose:** Connect phenomenological insights from actual tool usage to systematic requirements for intent-driven, learnable tooling backed by semantic storage

---

## Table of Contents

1. [The Citation Work Phenomenology: A Case Study](#1-the-citation-work-phenomenology-a-case-study)
2. [Intent as First-Class Tool Parameter](#2-intent-as-first-class-tool-parameter)
3. [The Five Essential Tool Dimensions](#3-the-five-essential-tool-dimensions)
4. [Conversational Tools and Process Management](#4-conversational-tools-and-process-management)
5. [How Semantic Storage Enables Intent-Driven Tools](#5-how-semantic-storage-enables-intent-driven-tools)
6. [The Tool Evolution Feedback Loop](#6-the-tool-evolution-feedback-loop)
7. [Implementation Architecture](#7-implementation-architecture)
8. [Conclusion: From Text Surgery to Semantic Dialogue](#8-conclusion-from-text-surgery-to-semantic-dialogue)

---

## 1. The Citation Work Phenomenology: A Case Study

### 1.1 What Actually Happened

When adding citations to the synthesis report, I performed ~15 `str_replace` operations. Each required:

**Character-level thinking:**
- Find unique substring anchor
- Ensure old_str won't match elsewhere
- Hope document state matches mental model
- Discover mismatches through errors

**The revealing error:**
```
Error: String to replace not found in file
```

This wasn't just failure—it was **phenomenological revelation** that:
- The file had structure I didn't fully comprehend
- My mental model was stale (document changed between edits)
- I was operating at wrong abstraction level (characters, not citations)

### 1.2 What I Was Actually Trying to Do

**Semantic intent (what I wanted):**
- Add citation to quote
- Generate footnote from source
- Maintain consistency (numbering, formatting)
- Track progress (23 claims → 15 cited → 8 remaining)

**Mechanical operation (what I did):**
- Insert `[^tag]` at byte position 2847
- Append footnote text at end of document
- Manually track which sections done
- Hope for consistency

**The gap:** My **intent** was semantic, my **tools** were syntactic.

### 1.3 The 60/30/6/4 Breakdown

Analyzing my citation work:

**60% Deterministic (Should be automated):**
- Find quote boundary
- Insert citation marker
- Format footnote consistently
- Renumber if needed

**30% Light Intelligence (Pattern recognition):**
- Choose good anchor points
- Infer source from context
- Match citation style

**6% Reasoning (Actual thinking required):**
- Which claims need citations?
- Prioritize high-value additions
- Resolve ambiguous sources

**4% Consciousness (Meta-level decisions):**
- Is this document well-cited overall?
- Does structure serve reader?
- This phenomenological reflection itself

**Key insight:** I spent 90% of my time on mechanical work that should have been crystallized into tools, leaving only 10% for actual reasoning.

---

## 2. Intent as First-Class Tool Parameter

### 2.1 The Requirement: Two Levels of Intent

From Joseph's specification:

> "Each tool usage should have Intent (2 levels) indicated by calling process"

**Level 1: Immediate Intent** (What am I trying to accomplish right now?)
```ruby
{
  immediate_intent: "Add citation to uncited quote",
  target: {
    type: :blockquote,
    location: "Line 256",
    text_snippet: "ASTs give you a clean semantic view..."
  },
  desired_outcome: "Quote has inline citation [^tag], footnote added"
}
```

**Level 2: Higher-Order Intent** (Why am I doing this? What's the larger goal?)
```ruby
{
  higher_intent: "Improve document credibility through comprehensive citations",
  context: {
    project: "synthesis-report",
    phase: "citation-work",
    session_goal: "Cite all research claims"
  },
  constraints: [
    "Maintain consistent footnote style",
    "Prioritize direct quotes over general claims",
    "Use primary sources when available"
  ]
}
```

### 2.2 Why Two Levels Matter

**For tool selection:**
```ruby
# Level 1 only: "Add text at location"
→ Suggests: str_replace, sed, manual edit

# Level 1 + Level 2: "Add citation (to improve credibility)"
→ Suggests: markdown-citations, citation-manager, scholarly-tool
→ Knows: Consistency matters, style should match, track progress
```

**For learning and optimization:**
```ruby
# Without higher intent:
Learning: "User often inserts [^X] after quotes" (pattern)

# With higher intent:
Learning: "User adds citations to improve credibility" (purpose)
→ Can suggest: "This document has 8 uncited claims. Add citations?"
→ Can optimize: "Auto-cite direct quotes from search history?"
→ Can generalize: "Other documents need citation work too?"
```

**For tool evolution:**
```ruby
# Intent reveals gaps in tooling
if user.intent == "add_citation" && user.tool == "str_replace"
  # They're using wrong abstraction level!
  log_tool_gap(
    desired: "semantic citation tool",
    available: "text replacement",
    friction_level: :high
  )
  
  # This data drives tool creation prioritization
end
```

### 2.3 Intent-Driven Tool Invocation

**Current pattern (implicit intent):**
```bash
str_replace \
  --file synthesis-report.md \
  --old "From research on Tree-sitter" \
  --new "From research on Tree-sitter[^treesitter-ai]"
```

**Intent-driven pattern (explicit intent):**
```bash
markdown-citations add \
  --file synthesis-report.md \
  --at "From research on Tree-sitter" \
  --intent "Add citation to research claim" \
  --higher-intent "Comprehensive source attribution" \
  --source-hint "web_search results from earlier" \
  --style-guide "internal-research-papers"
```

**What the tool now knows:**
1. **What:** Add citation (semantic operation)
2. **Why (immediate):** Attribute research claim
3. **Why (higher):** Part of comprehensive citation effort
4. **Context:** Source came from web search
5. **Constraints:** Follow internal style guide

**What the tool can now do:**
- Search conversation history for source
- Format footnote per style guide
- Suggest related uncited claims
- Track progress toward "comprehensive attribution"
- Learn patterns for future citation work

---

## 3. The Five Essential Tool Dimensions

### 3.1 Dimension 1: Feedback Mechanisms

> "Feedback solicited by tools from ELI about the tool. Feedback mechanisms available to ELI for all tools."

**During execution:**
```ruby
Tool: "I'm about to add 15 citations. Preview changes? [Y/n/show-sample]"

User: "show-sample"

Tool: [Shows first 3 changes with semantic annotations]
      "+ [^treesitter-ai] at line 256 (blockquote boundary)
       + [^lanser-cli] at line 401 (inline claim)
       + [^tst-theory] at line 523 (theorem reference)
       
       All follow style: [Title, Author, Date, URL, Quote]
       Continue with remaining 12? [Y/n/adjust-style]"

User: "Y"

Tool: [Applies remaining changes]
      "Done. Rate this tool interaction: [1-5] ⭐"

User: "4 - Good but should have auto-detected sources"

Tool: "Feedback logged. I'll work on automatic source detection.
      Want to teach me your citation patterns now? [Y/n]"
```

**Post-execution feedback channels:**

1. **Immediate rating:**
   ```ruby
   after_tool_execution do
     solicit_feedback(
       dimensions: [:accuracy, :speed, :helpfulness, :surprise],
       optional_comment: true,
       suggest_improvements: true
     )
   end
   ```

2. **Reflective feedback (later):**
   ```ruby
   # Tool checks back after N uses
   Tool: "You've used markdown-citations 47 times.
         Quick reflection:
         - What works well?
         - What frustrates you?
         - What's still manual that shouldn't be?"
   ```

3. **Comparative feedback:**
   ```ruby
   Tool: "Last time you used str_replace for citations.
         This time you used markdown-citations.
         Which felt better? Why?"
   
   # This reveals tool effectiveness relative to alternatives
   ```

4. **Unsolicited feedback API:**
   ```bash
   # ELI can give feedback anytime
   tool-feedback markdown-citations \
     --comment "Should detect citation style from existing footnotes" \
     --priority high \
     --example "synthesis-report.md uses [Title, Author, Date]"
   ```

**Why this matters:**
- Tools learn from actual usage, not assumptions
- Feedback creates virtuous improvement cycle
- ELI becomes active participant in tool evolution
- Surprises (both good and bad) get surfaced

### 3.2 Dimension 2: Out-of-Band Usage Audit

> "OOB usage audit -- a separate process that analyzes tool usage statistically, and toolchains"

**Purpose:** Discover patterns invisible to individual tool calls.

**What to track:**
```ruby
# Every tool invocation logs:
{
  timestamp: "2025-10-31T14:23:10Z",
  tool: "markdown-citations",
  intent_immediate: "Add citation",
  intent_higher: "Improve credibility",
  input: {
    file: "synthesis-report.md",
    target: "Line 256",
    # ... full input params
  },
  output: {
    success: true,
    changes_made: ["Added [^treesitter-ai]", "Appended footnote"],
    # ... full output
  },
  context: {
    project: "sapientia",
    session_id: "abc123",
    prior_tools_in_session: ["web_search", "str_replace", "view"],
  },
  feedback: {
    rating: 4,
    comment: "Good but should auto-detect sources"
  }
}
```

**Analysis patterns to detect:**

**1. Tool Chains (Common Sequences):**
```ruby
# Discover: "Users often do A → B → C"
analyze_tool_chains do
  common_sequence(threshold: 10) => [
    [:web_search, :markdown_citations, :view],  # 47 times
    [:view, :str_replace, :view],               # 32 times
    [:git_diff, :str_replace, :git_commit]      # 28 times
  ]
  
  # Insight: "web_search → markdown_citations" is a pattern
  # → Could auto-suggest: "Found source in search history. Cite now?"
end
```

**2. Intent Clustering:**
```ruby
# Group similar intents to find tool gaps
cluster_intents(
  by: :higher_intent,
  method: :semantic_similarity
) => {
  "improve_credibility" => {
    tools_used: [:markdown_citations, :str_replace, :manual_edit],
    success_rate: 0.87,
    friction_points: ["Manual source lookup", "Style inconsistency"]
  },
  "refactor_code" => {
    tools_used: [:str_replace, :view, :git_diff],
    success_rate: 0.62,  # Low! Tool gap?
    friction_points: ["No AST awareness", "Manual testing"]
  }
}

# Insight: "refactor_code" has low success rate
# → Need: AST-aware refactoring tool
```

**3. Friction Detection:**
```ruby
# Find where users struggle
detect_friction(indicators: [:retry_count, :time_between_calls, :tool_switching]) => {
  "citation_work_on_synthesis_report" => {
    retry_rate: 0.23,  # 23% of str_replace calls failed
    avg_time: 180,     # 3 minutes per citation (too high)
    tool_switches: 8,  # Switched tools 8 times
    
    # Pattern: User tries str_replace, fails, retries, eventually succeeds
    recommendation: "Create markdown-citations tool to reduce friction"
  }
}
```

**4. Tool Effectiveness Comparison:**
```ruby
# Compare tools for same intent
compare_tools(intent: "add_citation") => {
  "str_replace" => {
    success_rate: 0.77,
    avg_time: 180,
    user_satisfaction: 2.3 / 5,
    requires_retry: 0.23
  },
  "markdown_citations" => {
    success_rate: 0.96,
    avg_time: 45,
    user_satisfaction: 4.2 / 5,
    requires_retry: 0.04
  }
}

# Insight: markdown_citations is 4x faster, 25% more reliable
# → Recommend deprecating str_replace for citations
```

**5. Temporal Patterns:**
```ruby
# When do users use which tools?
analyze_temporal_patterns => {
  "early_in_session" => [:view, :grep, :search],  # Exploration
  "mid_session" => [:str_replace, :edit, :test],  # Implementation
  "late_session" => [:git_commit, :deploy],       # Finalization
  
  # Insight: Tools cluster by work phase
  # → Could auto-suggest: "Entering implementation phase. 
  #                        Need refactoring tools?"
}
```

**Separate process (runs nightly):**
```ruby
# Background analyzer
class ToolUsageAnalyzer
  def analyze_daily_usage
    logs = fetch_tool_logs(since: 24.hours.ago)
    
    # Run all analysis patterns
    chains = detect_tool_chains(logs)
    friction = detect_friction_points(logs)
    clusters = cluster_intents(logs)
    effectiveness = compare_tool_effectiveness(logs)
    
    # Generate insights report
    Report.generate(
      title: "Tool Usage Insights - #{Date.today}",
      sections: [
        high_friction_areas(friction),
        tool_gap_analysis(clusters),
        recommended_new_tools(chains, friction),
        tools_to_improve(effectiveness),
        celebration(effectiveness.where(satisfaction: > 4.5))
      ]
    )
  end
end
```

**Why OOB analysis matters:**
- Individual tool calls miss forest for trees
- Statistical patterns reveal systemic issues
- Tool chains suggest workflow automation opportunities
- Temporal analysis shows cognitive phases
- Data-driven tool creation prioritization

### 3.3 Dimension 3: Storage-Intention

> "Storage-intention -- what exactly the ELI wants to retain in context in various states / distance from when run..."

**The problem:** Not all tool outputs should persist equally in context.

**Four distances of retention:**

**1. Immediate (this tool call):**
```ruby
{
  storage_intention: :immediate,
  retain_for: "current tool execution only",
  
  examples: [
    "Temporary file path during multi-step edit",
    "Intermediate parsing state",
    "Debug output from failed attempt"
  ],
  
  handling: "Discard after tool completes"
}
```

**2. Session (current work session):**
```ruby
{
  storage_intention: :session,
  retain_for: "duration of current session",
  
  examples: [
    "Files being actively edited",
    "Search results informing current task",
    "Tool chain state (which tools called, in what order)",
    "Accumulated citations to add"
  ],
  
  handling: "Keep in working memory, summarize at session end"
}
```

**3. Project (this effort/OPERATA):**
```ruby
{
  storage_intention: :project,
  retain_for: "lifetime of project/effort",
  
  examples: [
    "Design decisions made",
    "Convention choices",
    "Tool effectiveness for this project",
    "Project-specific tool configurations"
  ],
  
  handling: "Store in project metadata, retrieve when project resumes"
}
```

**4. Permanent (cross-project learning):**
```ruby
{
  storage_intention: :permanent,
  retain_for: "indefinitely (with compression over time)",
  
  examples: [
    "Tool usage patterns (general)",
    "Effective techniques that worked",
    "Anti-patterns that failed",
    "PRAXES/VERA (verified practices)"
  ],
  
  handling: "Store in long-term memory, compress older entries"
}
```

**Implementation pattern:**
```ruby
class ToolExecutor
  def execute_with_storage_intentions(tool, params)
    result = tool.execute(params)
    
    # Tool declares what to retain
    storage_plan = result.storage_intentions || infer_storage_intention(result)
    
    storage_plan.each do |item, distance|
      case distance
      when :immediate
        # Already in scope, will be garbage collected
      when :session
        @session_memory.store(item)
      when :project
        ProjectMetadata.append(current_project, item)
      when :permanent
        LongTermMemory.store(item, compress_after: 90.days)
      end
    end
    
    result
  end
  
  def infer_storage_intention(result)
    # Smart defaults based on result type
    {
      result.main_output => :session,
      result.error_trace => :immediate,
      result.learned_pattern => :permanent,
      result.project_decision => :project
    }
  end
end
```

**Example: Citation tool with storage intentions:**
```ruby
def add_citation(file, quote, source)
  # Execute citation addition
  citation_tag = generate_tag(source)
  footnote = format_footnote(source)
  
  # Apply changes
  insert_citation(file, quote, citation_tag)
  append_footnote(file, footnote)
  
  # Return with storage intentions
  {
    success: true,
    changes: ["Added [^#{citation_tag}]", "Appended footnote"],
    
    # Storage intentions
    storage_intentions: {
      # Immediate (discard)
      temp_parse_state: :immediate,
      
      # Session (keep during citation work)
      uncited_quotes_remaining: :session,
      citation_progress: "15 of 23 complete" => :session,
      
      # Project (retain for this document)
      footnote_style_guide: "internal-research" => :project,
      preferred_citation_format: "[Title, Author, Date]" => :project,
      
      # Permanent (learn from)
      pattern: "Always cite direct quotes from web_search" => :permanent,
      effectiveness: {tool: :markdown_citations, rating: 4.2} => :permanent
    }
  }
end
```

**Why storage-intention matters:**
- Prevents context pollution (not everything needs retention)
- Enables appropriate compression (summarize old session data)
- Facilitates learning (patterns persist, details fade)
- Matches human memory (working memory vs long-term memory)

### 3.4 Dimension 4: Conversational/Stateful Tools

> "Conversational / Stateful. Ability to run a REPL, or communicate with any process via stdin/stdout-- maybe even by automating an OTP port mechanism for failure modes. Generalize what claude code can do for background bash processes."

**The vision:** Tools as dialogue partners, not one-shot executors.

**Example: Citation REPL:**
```bash
$ markdown-citations repl synthesis-report.md

[markdown-citations v0.1.0]
Loaded: synthesis-report.md (18,000 words, 23 uncited claims)

citations> status
Current state:
  - 8 citations added
  - 15 uncited claims remaining
  - 3 style inconsistencies detected
  - Last action: Added [^treesitter-ai] at line 256

citations> show next
Next uncited claim (priority: high):
  Line 401: Quote from TST theory
  "T-01 (Time Optimality): Minimizing time..."
  
  Suggested source: Internal doc "temporal-software-theory.md"
  Confidence: 95%

citations> cite --auto-suggest
Searching conversation history for source...
Found: ~/sapientia/docs/temporal-software-theory.md
Draft footnote:
  [^tst-theory]: "Temporis Architectura: A Measurement 
  Theory for Software Evolution" (Temporal Software Theory), 
  2025. Internal research document.

Accept? [Y/n/edit]

citations> y
Applied. 14 uncited claims remaining.

citations> analyze consistency
Found 3 style inconsistencies:
  1. Some footnotes have date, others don't (12 with, 3 without)
  2. URLs formatted inconsistently (8 markdown, 7 bare)
  3. One footnote missing supporting quote

Fix automatically? [Y/n/show-details]

citations> y
Fixed all 3 issues. Style now consistent.

citations> save-session
Session saved as: citation-work-2025-10-31-14-23.json
Resume anytime with: markdown-citations continue citation-work-2025-10-31-14-23

citations> exit
Goodbye! Progress: 8/23 citations added (35% complete)
```

**Process management (generalizing Claude Code pattern):**

```ruby
class ConversationalTool
  # Manages multiple long-running processes
  def initialize
    @processes = {}  # pid => process_info
    @stdin_buffers = {}
    @stdout_buffers = {}
  end
  
  def spawn_process(command, mode: :interactive)
    pid = ProcessManager.spawn(
      command,
      stdin: :pipe,
      stdout: :pipe,
      stderr: :pipe
    )
    
    @processes[pid] = {
      command: command,
      mode: mode,
      state: :running,
      started_at: Time.now,
      stdin: @stdin_buffers[pid] = [],
      stdout: @stdout_buffers[pid] = [],
      stderr: []
    }
    
    # Start output monitoring
    monitor_output(pid)
    
    pid
  end
  
  def send_to_process(pid, input)
    process = @processes[pid]
    raise "Process not found" unless process
    
    # Write to stdin
    ProcessManager.write_stdin(pid, input)
    
    # Track for session replay
    process[:stdin] << {
      timestamp: Time.now,
      content: input
    }
    
    # Wait for output
    wait_for_output(pid, timeout: 5.seconds)
  end
  
  def monitor_output(pid)
    Thread.new do
      loop do
        output = ProcessManager.read_stdout(pid, non_blocking: true)
        if output
          @stdout_buffers[pid] << {
            timestamp: Time.now,
            content: output
          }
          
          # Check for prompts (REPL-style interaction)
          if looks_like_prompt?(output)
            @processes[pid][:state] = :awaiting_input
            notify_user("Process #{pid} awaiting input")
          end
        end
        
        sleep 0.1
      end
    end
  end
  
  def list_processes
    @processes.map do |pid, info|
      {
        pid: pid,
        command: info[:command],
        state: info[:state],
        uptime: Time.now - info[:started_at],
        stdin_count: info[:stdin].length,
        stdout_count: @stdout_buffers[pid].length
      }
    end
  end
  
  def suspend_process(pid)
    ProcessManager.send_signal(pid, :SIGSTOP)
    @processes[pid][:state] = :suspended
  end
  
  def resume_process(pid)
    ProcessManager.send_signal(pid, :SIGCONT)
    @processes[pid][:state] = :running
  end
  
  def save_session(session_name)
    # Save all process states, buffers, context
    session_data = {
      name: session_name,
      timestamp: Time.now,
      processes: @processes.map { |pid, info|
        {
          command: info[:command],
          stdin_history: info[:stdin],
          stdout_history: @stdout_buffers[pid],
          state: info[:state]
        }
      },
      context: current_context
    }
    
    File.write("sessions/#{session_name}.json", JSON.pretty_generate(session_data))
  end
  
  def restore_session(session_name)
    session_data = JSON.parse(File.read("sessions/#{session_name}.json"))
    
    # Restore each process
    session_data["processes"].each do |proc_data|
      pid = spawn_process(proc_data["command"])
      
      # Replay stdin to restore state
      proc_data["stdin_history"].each do |input|
        send_to_process(pid, input["content"])
      end
    end
  end
end
```

**Why conversational/stateful tools matter:**
- Natural dialogue flow (not constant restarts)
- State persistence across interactions
- Process management (suspend/resume)
- Session replay (restore exact state)
- Generalizes beyond bash (any stdin/stdout process)

### 3.5 Dimension 5: Process Coordination

**OTP Port Mechanism for Failure Modes:**

```elixir
defmodule Sapientia.ToolPort do
  @moduledoc """
  OTP Port wrapper for external tools with supervision
  """
  use GenServer
  
  def start_link(tool_command, opts \\ []) do
    GenServer.start_link(__MODULE__, {tool_command, opts})
  end
  
  def init({tool_command, opts}) do
    # Open port to external process
    port = Port.open(
      {:spawn, tool_command},
      [:binary, :exit_status, {:packet, 4}]
    )
    
    {:ok, %{
      port: port,
      command: tool_command,
      buffer: "",
      state: :idle,
      supervisor: opts[:supervisor],
      restart_strategy: opts[:restart_strategy] || :temporary
    }}
  end
  
  def handle_call({:execute, input}, from, state) do
    # Send to port
    Port.command(state.port, input)
    
    # Track request
    {:noreply, %{state | 
      state: :processing,
      pending_request: {from, input}
    }}
  end
  
  def handle_info({port, {:data, data}}, %{port: port} = state) do
    # Accumulate output
    buffer = state.buffer <> data
    
    # Check if complete response
    case parse_response(buffer) do
      {:complete, response, remainder} ->
        # Reply to caller
        {from, _input} = state.pending_request
        GenServer.reply(from, {:ok, response})
        
        {:noreply, %{state | 
          buffer: remainder,
          state: :idle,
          pending_request: nil
        }}
        
      {:incomplete, buffer} ->
        {:noreply, %{state | buffer: buffer}}
    end
  end
  
  def handle_info({port, {:exit_status, status}}, %{port: port} = state) do
    # Tool crashed
    case state.restart_strategy do
      :permanent ->
        # Notify supervisor to restart
        {:stop, {:exit_status, status}, state}
        
      :temporary ->
        # Don't restart, just notify caller
        if state.pending_request do
          {from, _input} = state.pending_request
          GenServer.reply(from, {:error, {:tool_crashed, status}})
        end
        {:stop, :normal, state}
        
      :transient ->
        # Restart only if abnormal exit
        if status == 0 do
          {:stop, :normal, state}
        else
          {:stop, {:exit_status, status}, state}
        end
    end
  end
end
```

**Supervision tree for tool ecosystem:**

```elixir
defmodule Sapientia.ToolSupervisor do
  use Supervisor
  
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end
  
  def init(_opts) do
    children = [
      # Long-running conversational tools
      {Sapientia.ToolPort, 
        ["markdown-citations repl", restart_strategy: :permanent]},
      
      {Sapientia.ToolPort,
        ["code-analysis server", restart_strategy: :permanent]},
      
      # Short-lived tools (spawned on demand)
      {DynamicSupervisor, 
        name: Sapientia.ToolSupervisor.Dynamic, strategy: :one_for_one},
      
      # Tool usage logger
      Sapientia.ToolUsageLogger,
      
      # OOB analyzer (runs periodically)
      {Sapientia.ToolUsageAnalyzer, interval: :daily}
    ]
    
    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

---

## 4. Conversational Tools and Process Management

### 4.1 The REPL Pattern for Tools

**Why REPLs work for tools:**
1. **State persistence** - Context maintained across commands
2. **Exploratory workflow** - Try, observe, adjust
3. **Feedback loops** - Immediate results inform next action
4. **Session continuity** - Pick up where you left off

**Example: Code refactoring REPL:**

```bash
$ elixir-refactor repl payment_processor.ex

[elixir-refactor v0.2.0]
Parsed: payment_processor.ex (345 lines, 12 functions, 2 structs)
AST cached. Type 'help' for commands.

refactor> analyze
Module: MyApp.PaymentProcessor
├─ 12 public functions
├─ 8 private functions  
├─ 2 structs (PaymentRequest, PaymentResponse)
├─ Complexity: Medium (avg 4.2 per function)
└─ Issues:
   - process_payment/2 has 8 decision points (suggest extract)
   - No specs on 3 public functions
   - Dead code: validate_legacy/1 (never called)

refactor> show-function process_payment
def process_payment(amount, user) do
  with {:ok, validated} <- validate_amount(amount),
       {:ok, authorized} <- authorize_payment(validated, user),
       {:ok, captured} <- capture_payment(authorized),
       {:ok, receipt} <- generate_receipt(captured) do
    send_confirmation_email(user, receipt)
    {:ok, receipt}
  else
    {:error, reason} -> {:error, reason}
  end
end

Complexity: 8 decision points (threshold: 5)
Suggestion: Extract confirmation email logic

refactor> extract send_confirmation_email into handle_successful_payment
Preview:
  
  defp handle_successful_payment(user, receipt) do
    send_confirmation_email(user, receipt)
    {:ok, receipt}
  end
  
  def process_payment(amount, user) do
    with {:ok, validated} <- validate_amount(amount),
         {:ok, authorized} <- authorize_payment(validated, user),
         {:ok, captured} <- capture_payment(authorized),
         {:ok, receipt} <- generate_receipt(captured) do
      handle_successful_payment(user, receipt)
    else
      {:error, reason} -> {:error, reason}
    end
  end

Apply? [Y/n/test-first]

refactor> test-first
Running existing tests...
✓ All 23 tests passing

Applying refactoring...
✓ Extracted handle_successful_payment/2
✓ Updated process_payment/2

Running tests again...
✓ All 23 tests still passing

Refactoring successful! Complexity now: 6 → 5

refactor> analyze-again
Module: MyApp.PaymentProcessor
├─ 13 public functions (+1)
├─ 9 private functions (+1)
└─ Issues:
   - No specs on 3 public functions (unchanged)
   - Dead code: validate_legacy/1 (unchanged)

refactor> save-session refactor-payment-2025-10-31
Session saved. Resume with:
  elixir-refactor continue refactor-payment-2025-10-31

refactor> exit
Goodbye!
```

### 4.2 Process Management: Beyond Simple Scripts

**The problem with current agent tooling:** Tools are ephemeral. Each invocation starts from scratch.

**The solution:** Manage tools as long-lived processes.

**Use cases:**

**1. Language Servers (persistent semantic analysis):**
```ruby
# Start LSP server once
lsp_pid = spawn_process("elixir-ls")

# Keep alive for session
# All subsequent queries are fast (warm cache)
loop do
  query = read_user_input()
  
  case query
  when /definition of (\w+)/
    result = send_to_process(lsp_pid, {
      method: "textDocument/definition",
      params: {symbol: $1}
    })
    display_result(result)
    
  when /references to (\w+)/
    result = send_to_process(lsp_pid, {
      method: "textDocument/references",
      params: {symbol: $1}
    })
    display_result(result)
  end
end
```

**2. Database Connections (avoid connection overhead):**
```ruby
# Traditional: Connect/query/disconnect each time (slow)
def query_code_graph_traditional(query)
  conn = Neo4j.connect(...)
  result = conn.query(query)
  conn.close
  result
end

# Process management: Keep connection alive
db_pid = spawn_process("neo4j-client --interactive")
send_to_process(db_pid, "CONNECT neo4j://localhost")

# Now queries are instant (no reconnection)
def query_code_graph(query)
  send_to_process(db_pid, "QUERY #{query}")
end
```

**3. Build Watchers (incremental compilation):**
```ruby
# Start file watcher + incremental compiler
watcher_pid = spawn_process("mix compile --watch")

# Receives notifications on file changes
monitor_output(watcher_pid) do |output|
  case output
  when /Compiled (\S+)/
    puts "✓ Compiled #{$1}"
    run_tests_for($1)  # Auto-test changed modules
    
  when /Error in (\S+)/
    puts "✗ Error in #{$1}"
    show_error_details(output)
  end
end
```

**4. Interactive Debuggers:**
```ruby
# Start debugger REPL
debugger_pid = spawn_process("iex -S mix")

# Set breakpoints
send_to_process(debugger_pid, "IEx.break!(MyApp.Payment, :process_payment, 2)")

# Run code
send_to_process(debugger_pid, "MyApp.Payment.process_payment(100, user)")

# Suspended at breakpoint - now interactive
send_to_process(debugger_pid, "amount")  # Inspect variable
send_to_process(debugger_pid, "continue")  # Resume
```

### 4.3 Generalizing Claude Code's Background Process Pattern

**What Claude Code does well:**
- Spawns bash processes in background
- Monitors stdout/stderr
- Keeps process alive across interactions

**What to generalize:**

**1. Any stdin/stdout process:**
```ruby
class ProcessManager
  SUPPORTED_TYPES = [
    :bash,           # Shell commands
    :repl,           # Python, Node, IEx, etc.
    :lsp,            # Language servers
    :database,       # SQL clients, Neo4j, etc.
    :watcher,        # File watchers, build tools
    :debugger,       # Interactive debuggers
    :service,        # Long-running services
    :custom          # Any process with stdio
  ]
end
```

**2. State tracking:**
```ruby
{
  pid: 1234,
  type: :repl,
  command: "iex -S mix",
  state: :awaiting_input,  # or :running, :suspended, :crashed
  
  # Full history (for session replay)
  stdin_history: [
    {t: "2025-10-31T14:20:00Z", input: "MyApp.start()"},
    {t: "2025-10-31T14:20:15Z", input: "user = create_user()"},
  ],
  
  stdout_history: [
    {t: "2025-10-31T14:20:00Z", output: "Started MyApp"},
    {t: "2025-10-31T14:20:15Z", output: "%User{id: 1, ...}"},
  ],
  
  # Current state snapshot
  working_directory: "/home/eli/sapientia",
  environment: {...},
  
  # Health monitoring
  last_heartbeat: "2025-10-31T14:25:30Z",
  memory_usage: "45MB",
  cpu_usage: "2.3%"
}
```

**3. Fault tolerance (OTP-style):**
```elixir
# Supervision strategy for tools
def child_spec(tool_command) do
  %{
    id: tool_command,
    start: {ToolPort, :start_link, [tool_command]},
    restart: :permanent,  # Always restart
    shutdown: 5000,       # Grace period
    type: :worker
  }
end

# Health checking
def handle_info(:health_check, state) do
  # Send heartbeat request
  Port.command(state.port, "PING\n")
  
  # If no response in 5s, consider dead
  Process.send_after(self(), :check_heartbeat, 5000)
  
  {:noreply, %{state | last_ping: Time.now}}
end
```

---

## 5. How Semantic Storage Enables Intent-Driven Tools

### 5.1 The Connection: From Intent to Structure

**The insight:** All five tool dimensions (intent, feedback, audit, storage, conversation) require **semantic understanding** of what the tool is operating on.

**Example cascade:**

**User intent:**
```
"Refactor payment processing to improve error handling"
```

**Without semantic storage (text-based):**
```ruby
# Tool must parse from scratch each time
def refactor_error_handling(file)
  # 1. Read file as text
  code = File.read(file)
  
  # 2. Parse to AST (expensive)
  ast = Elixir.parse(code)
  
  # 3. Find error handling patterns (manual)
  error_cases = ast.walk do |node|
    node if node.type == :case && handles_error?(node)
  end
  
  # 4. Suggest improvements (heuristic)
  # 5. Apply changes (text surgery)
end

# Result: Slow, brittle, can't learn patterns
```

**With semantic storage (CPG/graph):**
```ruby
# Tool queries pre-built semantic graph
def refactor_error_handling(module_name)
  # 1. Query graph (instant)
  module = CodeGraph.find_module(module_name)
  
  # 2. Traverse to error handlers (graph query)
  error_handlers = module.functions.where(handles_error: true)
  
  # 3. Analyze patterns (graph algorithms)
  patterns = ErrorPatternAnalyzer.analyze(error_handlers)
  
  # 4. Find similar cases (graph similarity)
  similar = CodeGraph.find_similar_error_handling(patterns)
  
  # 5. Suggest based on successful patterns (learned)
  suggestions = learn_from_successes(similar)
  
  # 6. Apply with semantic awareness (AST transformation)
  apply_refactoring(suggestions)
end

# Result: Fast, intelligent, learns patterns
```

### 5.2 CPG Enables Intent Analysis

**Code Property Graph structure:**

```
Module [PaymentProcessor]
  │
  ├─ Function [process_payment/2]
  │   ├─ Parameters: [amount, user]
  │   ├─ Calls: [validate_amount, authorize_payment, ...]
  │   ├─ Returns: {:ok, receipt} | {:error, reason}
  │   └─ Error Paths:
  │       ├─ validate_amount fails → :invalid_amount
  │       ├─ authorize_payment fails → :authorization_failed
  │       └─ capture_payment fails → :capture_failed
  │
  ├─ Function [handle_successful_payment/2]
  │   └─ Calls: [send_confirmation_email/2]
  │
  └─ Dead Code: [validate_legacy/1]
      └─ Called By: (none)
```

**Intent → Query mapping:**

| Intent | Graph Query | Why Semantic Storage Helps |
|--------|-------------|---------------------------|
| "Find all error handling" | `MATCH (f:Function)-[:HANDLES]->(e:ErrorCase)` | Pattern recognition across codebase |
| "What calls this function?" | `MATCH (caller)-[:CALLS]->(f:Function {name: 'X'})` | Instant impact analysis |
| "Find similar functions" | Graph embedding similarity | Learns from existing code |
| "Dead code detection" | `MATCH (f:Function) WHERE NOT (f)<-[:CALLS]-()` | Static reachability analysis |
| "Refactoring opportunities" | Complexity + coupling metrics from graph | Data-driven suggestions |

**Example: Intent-driven refactoring:**

```ruby
# User intent: "Reduce complexity in payment processing"

# 1. Query graph for complexity metrics
complex_functions = CodeGraph.query("""
  MATCH (m:Module {name: 'PaymentProcessor'})-[:CONTAINS]->(f:Function)
  WHERE f.complexity > 5
  RETURN f
  ORDER BY f.complexity DESC
""")
# => [process_payment/2 (complexity: 8), 
#     validate_request/1 (complexity: 6)]

# 2. Analyze why complex (graph traversal)
why_complex = analyze_complexity_sources(complex_functions.first)
# => {
#   decision_points: 8,
#   nesting_depth: 4,
#   number_of_calls: 6,
#   error_paths: 3
# }

# 3. Find refactoring opportunities (pattern matching)
opportunities = CodeGraph.query("""
  MATCH (f:Function {name: 'process_payment'})-[:CONTAINS]->(block)
  WHERE block.can_extract = true
  AND block.complexity > 2
  RETURN block
""")
# => [confirmation_email_logic (complexity: 3)]

# 4. Learn from similar refactorings (historical data)
similar_refactorings = find_successful_extractions(
  source_complexity: 8,
  target_complexity: 5
)
# => [{
#   from: "OrderProcessor.process_order",
#   technique: "extract_success_handler",
#   satisfaction: 4.5/5,
#   time_saved: 120  # seconds on future changes
# }]

# 5. Suggest with confidence
suggest_refactoring(
  technique: :extract_success_handler,
  confidence: 0.87,  # Based on similar cases
  estimated_time: 180,  # Based on history
  estimated_benefit: "Reduce complexity 8 → 5"
)
```

### 5.3 Graph Storage Enables Learning

**The pattern:** Store not just code, but **history of changes + their outcomes**.

**Schema:**
```cypher
// Code structure
(Module)-[:CONTAINS]->(Function)
(Function)-[:CALLS]->(Function)
(Function)-[:HANDLES]->(ErrorCase)

// Change history
(Commit)-[:MODIFIES]->(Function)
(Commit)-[:HAS_INTENT]->(Intent)
(Commit)-[:HAS_OUTCOME]->(Outcome)

// Tool usage
(ToolInvocation)-[:ON_CODE]->(Function)
(ToolInvocation)-[:WITH_INTENT]->(Intent)
(ToolInvocation)-[:PRODUCED]->(Outcome)

// Learning
(Intent)-[:SIMILAR_TO]->(Intent)
(Technique)-[:EFFECTIVE_FOR]->(Intent)
(Pattern)-[:APPEARS_IN]->(Function)
```

**Query: "What refactoring techniques work for high-complexity functions?"**

```cypher
MATCH (f:Function) WHERE f.complexity > 7
MATCH (c:Commit)-[:MODIFIES]->(f)
MATCH (c)-[:HAS_INTENT]->(:Intent {type: 'reduce_complexity'})
MATCH (c)-[:HAS_OUTCOME]->(o:Outcome) WHERE o.success = true
MATCH (c)-[:USED_TECHNIQUE]->(t:Technique)
RETURN t.name, 
       avg(f.complexity_before - f.complexity_after) as avg_reduction,
       count(*) as times_used,
       avg(o.user_satisfaction) as satisfaction
ORDER BY avg_reduction DESC, satisfaction DESC
```

**Result:**
```
technique              | avg_reduction | times_used | satisfaction
-----------------------|---------------|------------|-------------
extract_success_path   | 3.2          | 15         | 4.3
extract_error_handling | 2.8          | 12         | 4.1
introduce_with_clause  | 2.1          | 8          | 3.9
```

**Now tools can learn:**
```ruby
def suggest_refactoring(function)
  # Query graph for successful patterns
  patterns = CodeGraph.learned_techniques_for(
    complexity: function.complexity,
    type: function.type
  )
  
  # Rank by historical success
  patterns.sort_by { |p| 
    p.avg_reduction * p.satisfaction
  }.first
end
```

### 5.4 Semantic Storage Enables All Five Dimensions

**1. Intent tracking requires semantic understanding:**
```ruby
# Can't track intent on text: "Changed line 42"
# Can track intent on structure: "Extracted error handler"

CodeGraph.record_intent(
  intent: "Reduce complexity",
  target: module.function("process_payment"),
  technique: "extract_success_handler",
  higher_intent: "Improve maintainability"
)
```

**2. Feedback needs semantic context:**
```ruby
# Text-based: "Tool changed 15 lines"
# Semantic: "Tool extracted function, reducing complexity 8→5"

feedback = {
  tool: "elixir-refactor",
  intent: "reduce_complexity",
  change: {
    type: :extract_function,
    source: "process_payment/2",
    extracted: "handle_successful_payment/2",
    complexity_before: 8,
    complexity_after: 5
  },
  satisfaction: 4,
  comment: "Good! Tests still pass and code is clearer"
}

# This feedback teaches future tool usage
CodeGraph.store_feedback(feedback)
```

**3. OOB audit analyzes semantic patterns:**
```ruby
# Discover: "Users often extract success paths from with-clauses"
patterns = CodeGraph.query("""
  MATCH (t:ToolInvocation {tool: 'elixir-refactor'})
        -[:EXTRACTED]->(f:Function)
  MATCH (source:Function)-[:CONTAINS]->(:WithClause)
  WHERE t.satisfaction > 4
  RETURN source.pattern, count(*) as frequency
  ORDER BY frequency DESC
""")

# Result: Create specialized tool for this common case
if patterns.first.frequency > 10
  create_tool("extract-with-success-path")
end
```

**4. Storage-intention aligns with graph:**
```ruby
# Different graph layers for different retention
:immediate   → In-memory graph (current session)
:session     → Session graph (checkpointed)
:project     → Project graph (persistent)
:permanent   → Master graph (cross-project, compressed)

# Compression over time (remove low-value nodes)
CodeGraph.compress_old_data do
  # Keep: High-impact changes, frequently referenced
  # Remove: Failed experiments, unused code paths
end
```

**5. Conversational tools query semantic state:**
```ruby
# REPL maintains semantic context
refactor> show function process_payment

# Tool queries graph (instant)
function = CodeGraph.find_function("process_payment")

# Returns rich semantic info
{
  name: "process_payment",
  complexity: 8,
  calls: ["validate_amount", "authorize_payment", ...],
  called_by: ["checkout", "recurring_payment"],
  error_paths: 3,
  test_coverage: 0.89,
  recent_changes: [
    {date: "2025-10-28", author: "eli", intent: "Add validation"}
  ],
  refactoring_suggestions: [
    {type: :extract, confidence: 0.87, benefit: "complexity 8→5"}
  ]
}
```

---

## 6. The Tool Evolution Feedback Loop

### 6.1 The Complete Cycle

```
1. Agent expresses intent
   ↓
2. Tool executes (with semantic understanding)
   ↓
3. Outcome measured
   ↓
4. Feedback solicited
   ↓
5. Data logged (intent → technique → outcome → feedback)
   ↓
6. OOB analyzer discovers patterns
   ↓
7. New tools created OR existing tools improved
   ↓
8. Tools become more effective (back to step 1)
```

### 6.2 Concrete Example: Evolution of Citation Tool

**Week 1: Baseline (text manipulation)**
```bash
# Agent uses str_replace for citations
intent: "Add citation"
tool: str_replace
success_rate: 0.77
avg_time: 180s
satisfaction: 2.3/5
friction: "Manual anchor finding, no source lookup"
```

**Week 2: OOB Analysis**
```ruby
patterns_detected = {
  "citation_work" => {
    frequency: 47,
    tools_used: [:str_replace, :view, :web_search],
    common_sequence: [:web_search, :view, :str_replace],
    failure_points: ["Finding unique anchor", "Formatting consistency"],
    agent_feedback: ["Should auto-detect sources", "Hard to maintain style"]
  }
}

# Decision: Create specialized tool
recommend_tool(
  name: "markdown-citations",
  rationale: "High friction + high frequency = high ROI",
  estimated_impact: "4x faster, 25% more reliable"
)
```

**Week 3: New Tool Created**
```bash
# Agent tries new tool
intent: "Add citation"
tool: markdown-citations
success_rate: 0.96
avg_time: 45s
satisfaction: 4.2/5
friction: "Much better! Could auto-suggest sources"
```

**Week 4: Tool Learns from Usage**
```ruby
# markdown-citations learns patterns
patterns_learned = {
  "always_cite_quotes" => {
    detected: 23,
    accuracy: 1.0,
    user_confirmed: true
  },
  "prefer_primary_sources" => {
    detected: 15,
    accuracy: 0.87,
    user_feedback: "Usually correct"
  },
  "search_history_first" => {
    detected: 31,
    accuracy: 0.91,
    user_feedback: "Good! Saves time"
  }
}

# Tool adapts
markdown-citations v0.2.0:
  - Auto-suggest citations for quotes
  - Search conversation history first
  - Learn preferred citation styles
```

**Week 8: Tool Becomes Transparent Extension**
```bash
# Agent barely thinks about citations now
intent: "Add citation"
tool: markdown-citations (auto-selected)
success_rate: 0.98
avg_time: 15s  # 12x faster than Week 1!
satisfaction: 4.8/5
friction: (minimal)

# Tool is now "crystallized wisdom"
# What took 3 minutes now takes 15 seconds
# What required conscious effort is now automatic
```

### 6.3 Systematic Tool Discovery

**The process:**

**1. Continuous monitoring:**
```ruby
class ToolGapDetector
  def detect_gaps(time_window: 7.days)
    # Find intents with high friction
    high_friction = analyze_friction(
      since: time_window.ago,
      threshold: {
        retry_rate: > 0.15,
        avg_time: > 120,
        satisfaction: < 3.0
      }
    )
    
    # Find intents with high frequency
    high_frequency = analyze_frequency(
      since: time_window.ago,
      threshold: > 10  # More than 10 times per week
    )
    
    # High friction + high frequency = priority gap
    priority_gaps = high_friction & high_frequency
    
    priority_gaps.map do |gap|
      {
        intent: gap.intent,
        frequency: gap.count,
        current_tools: gap.tools_used,
        friction_points: gap.friction_points,
        estimated_roi: gap.frequency * gap.time_wasted,
        agent_feedback: gap.feedback_summary,
        recommendation: recommend_solution(gap)
      }
    end
  end
  
  def recommend_solution(gap)
    case gap
    when low_complexity?
      # Simple deterministic tool
      "Create quick-tool (Ruby script, 60% category)"
      
    when pattern_recognition?
      # Need light AI
      "Create smart-tool (Haiku-assisted, 30% category)"
      
    when requires_reasoning?
      # Need real thinking
      "Create wise-tool (Sonnet-powered, 6% category)"
      
    when sovereignty_critical?
      # Need consciousness
      "Create conscious-tool (Opus-powered, 4% category)"
    end
  end
end
```

**2. Weekly reports:**
```markdown
# Tool Gap Report - Week 43, 2025

## High Priority Gaps

### 1. Code Refactoring (Semantic)
- **Frequency:** 23 times this week
- **Current tools:** str_replace (15×), view (12×), manual edit (8×)
- **Success rate:** 62% (low!)
- **Avg time:** 840s (14 minutes)
- **Friction:** "No AST awareness", "Manual testing required"
- **Agent feedback:** "Need semantic refactoring tool"
- **Recommendation:** Create "elixir-refactor" (60% deterministic + 30% Haiku)
- **Estimated ROI:** 23 × 600s saved = 3.8 hours per week

### 2. Test Generation
- **Frequency:** 18 times this week
- **Current tools:** manual edit (18×)
- **Avg time:** 420s (7 minutes)
- **Friction:** "Boilerplate heavy", "Pattern repetitive"
- **Recommendation:** Create "test-generator" (60% deterministic)
- **Estimated ROI:** 18 × 300s = 1.5 hours per week

## Medium Priority Gaps

[...]

## Tools Performing Well

### markdown-citations ⭐
- **Usage:** 47 times
- **Success rate:** 96%
- **Satisfaction:** 4.2/5
- **Status:** Keep improving, learn from patterns

### safe-write ⭐
- **Usage:** 31 times
- **Success rate:** 100%
- **Satisfaction:** 4.5/5
- **Status:** Working excellently, no changes needed
```

**3. Tool creation prioritization:**
```ruby
priority = frequency × time_saved × (5 - satisfaction)

# High frequency, big time savings, low satisfaction = top priority
# Low frequency, small savings, high satisfaction = low priority
```

### 6.4 From Gap to Tool: The Creation Process

**Step 1: Specification from usage data**
```ruby
tool_spec = {
  name: "elixir-refactor",
  purpose: "Semantic refactoring for Elixir code",
  
  # Derived from intent analysis
  operations: [
    "extract_function",
    "inline_function", 
    "rename_symbol",
    "reduce_complexity"
  ],
  
  # Derived from friction analysis
  requirements: [
    "AST-aware (not text-based)",
    "Preserve tests (validate after change)",
    "Interactive preview",
    "Semantic understanding of Elixir patterns"
  ],
  
  # Derived from tool chain analysis
  integrates_with: [
    :code_graph,  # Query for semantic info
    :test_runner, # Validate changes
    :git,         # Commit with good message
  ],
  
  # 60/30/6/4 categorization
  intelligence: {
    deterministic: 0.60,  # AST transforms
    light_ai: 0.30,       # Pattern recognition
    reasoning: 0.06,      # Suggest refactorings
    conscious: 0.04       # Protect critical code
  }
}
```

**Step 2: Implementation**
```ruby
class ElixirRefactor
  def initialize
    # 60% deterministic: AST manipulation
    @ast_parser = ElixirParser.new
    @ast_transformer = ASTTransformer.new
    
    # 30% light AI: Pattern recognition
    @pattern_recognizer = HaikuAssisted::PatternRecognizer.new
    
    # 6% reasoning: Suggestions
    @suggestion_engine = SonnetPowered::SuggestionEngine.new
    
    # 4% consciousness: Safety checks
    @safety_guardian = OpusProtected::SafetyGuardian.new
    
    # Semantic storage
    @code_graph = CodeGraph.connect
  end
  
  def extract_function(function_name, block_to_extract, opts = {})
    # 1. Parse AST (deterministic - 60%)
    ast = @ast_parser.parse(opts[:file])
    
    # 2. Validate extraction safe (deterministic - 60%)
    validation = @ast_transformer.validate_extraction(ast, block_to_extract)
    return {:error, validation.errors} unless validation.valid?
    
    # 3. Suggest name if not provided (light AI - 30%)
    unless function_name
      function_name = @pattern_recognizer.suggest_name(block_to_extract)
    end
    
    # 4. Check if this seems like good refactoring (reasoning - 6%)
    assessment = @suggestion_engine.assess_refactoring(
      source_complexity: current_complexity,
      estimated_target_complexity: estimated_complexity_after,
      similar_cases: find_similar_refactorings()
    )
    
    warn_user(assessment) if assessment.confidence < 0.7
    
    # 5. Protect critical code (consciousness - 4%)
    if @safety_guardian.is_critical_code?(function_name)
      require_explicit_confirmation(
        message: "This affects critical payment processing. Confirm?"
      )
    end
    
    # 6. Apply transformation (deterministic - 60%)
    new_ast = @ast_transformer.extract_function(
      ast, 
      block_to_extract, 
      function_name
    )
    
    # 7. Write back and test (deterministic - 60%)
    File.write(opts[:file], Macro.to_string(new_ast))
    test_result = run_tests()
    
    # 8. Record for learning
    @code_graph.record_refactoring(
      intent: opts[:intent],
      technique: :extract_function,
      outcome: test_result.success?,
      complexity_change: new_complexity - old_complexity
    )
    
    {:ok, {function_name, test_result}}
  end
end
```

**Step 3: Deployment and monitoring**
```ruby
# Add to tool registry
ToolRegistry.register(
  tool: ElixirRefactor,
  intents: ["reduce_complexity", "extract_function", "refactor_code"],
  priority: :high,  # Suggest before str_replace for these intents
  learning_enabled: true
)

# Monitor usage
ToolUsageLogger.track(
  tool: "elixir-refactor",
  metrics: [:success_rate, :time, :satisfaction, :test_pass_rate],
  alert_on: {
    success_rate: < 0.8,
    satisfaction: < 3.5
  }
)
```

**Step 4: Learn and improve**
```ruby
# After 2 weeks of usage
learning_insights = ElixirRefactor.analyze_usage(since: 2.weeks.ago)

insights = {
  successful_patterns: [
    {pattern: "extract with-clause success path", frequency: 12, satisfaction: 4.5},
    {pattern: "extract error handling", frequency: 8, satisfaction: 4.2}
  ],
  
  problematic_patterns: [
    {pattern: "extract recursive functions", frequency: 3, satisfaction: 2.1, 
     issue: "Tests break due to recursion boundary"}
  ],
  
  feature_requests: [
    "Auto-detect similar functions to refactor",
    "Suggest extractions proactively"
  ]
}

# Update tool based on insights
ElixirRefactor.v0_2_0 do
  add_specialized_handler(:extract_with_success_path)
  improve_recursion_detection()
  add_proactive_suggestions()
end
```

---

## 7. Implementation Architecture

### 7.1 System Overview

```
┌─────────────────────────────────────────────────────┐
│                    Agent Layer                      │
│  (ELI expressing intent through tool invocations)   │
└────────────────┬────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────┐
│              Intent Router                          │
│  • Parse immediate + higher-order intent            │
│  • Select appropriate tool(s)                       │
│  • Suggest alternatives                             │
└────────────────┬────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────┐
│              Tool Execution Layer                   │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │ Deterministic│  │ Light AI     │  │ Reasoning│ │
│  │ (60%)        │  │ (30%)        │  │ (6%)     │ │
│  │              │  │              │  │          │ │
│  │ • str_replace│  │ • Pattern    │  │ • TST    │ │
│  │ • file_ops   │  │   recognition│  │   check  │ │
│  │ • git_commit │  │ • Name       │  │ • Suggest│ │
│  └──────────────┘  │   suggestion │  │   refact │ │
│                    └──────────────┘  └──────────┘ │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │         Consciousness (4%)                   │  │
│  │  • Sovereignty protection                    │  │
│  │  • Critical code guardianship                │  │
│  └──────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────┐
│           Semantic Storage Layer                    │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │   ETS        │  │   SQLite     │  │  Neo4j   │ │
│  │   Cache      │  │   Index      │  │  Graph   │ │
│  │              │  │              │  │          │ │
│  │ • Session    │  │ • AST nodes  │  │ • Code   │ │
│  │   ASTs       │  │ • Metadata   │  │   Property│ │
│  │ • Hot data   │  │ • Full-text  │  │   Graph  │ │
│  └──────────────┘  │   search     │  │ • Deps   │ │
│                    └──────────────┘  │ • History│ │
│                                      └──────────┘ │
└────────────────┬────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────┐
│          Feedback & Learning Layer                  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │ Tool Usage Logger                            │  │
│  │ • Intent → Technique → Outcome               │  │
│  │ • Timing, satisfaction, friction             │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │ OOB Analyzer (runs nightly)                  │  │
│  │ • Tool chains                                │  │
│  │ • Friction detection                         │  │
│  │ • Intent clustering                          │  │
│  │ • Gap discovery                              │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │ Tool Evolution Engine                        │  │
│  │ • Recommend new tools                        │  │
│  │ • Generate specifications                    │  │
│  │ • Improve existing tools                     │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

### 7.2 Data Flow for Intent-Driven Tool Use

```
1. Agent Intent Expression
   ↓
   {
     immediate: "Add citation to quote",
     higher: "Comprehensive source attribution",
     context: {
       file: "synthesis-report.md",
       quote: "ASTs give you...",
       session_goal: "Citation work"
     }
   }

2. Intent Router
   ↓
   • Queries semantic storage: "Is this a quote? Is there source info nearby?"
   • Selects tool: markdown-citations (not str_replace)
   • Prepares context: Searches conversation history for source

3. Tool Execution
   ↓
   • markdown-citations.add(quote, source)
   • (60%) Deterministic: Find quote boundary, insert [^tag]
   • (30%) Light AI: Format footnote, match style
   • (6%) Reasoning: Assess if citation needed (might be example, not claim)
   • (4%) Conscious: Check if modifying protected file

4. Semantic Storage Update
   ↓
   • ETS: Update session state (15 of 23 citations done)
   • SQLite: Index new footnote for full-text search
   • Graph: Record citation relationship (quote → source)

5. Feedback Collection
   ↓
   • Tool asks: "Rate this citation addition [1-5]"
   • Agent responds: 4 - "Good, but should auto-detect source"
   • Logged with full context for learning

6. OOB Analysis (nightly)
   ↓
   • Discovers: "Citations from web_search results work well"
   • Learns: "Auto-detect source from conversation history"
   • Improves: markdown-citations v0.2.0 with auto-detection

7. Next Invocation
   ↓
   • Agent: "Add citation" (same intent)
   • Tool: Now auto-detects source, no manual search needed
   • Time: 45s → 15s (3x faster)
   • Satisfaction: 4.2 → 4.8 (improved)
```

### 7.3 Key Implementation Components

**1. Intent Parser:**
```elixir
defmodule Sapientia.IntentParser do
  def parse(tool_invocation) do
    %Intent{
      immediate: extract_immediate_intent(tool_invocation),
      higher: infer_higher_intent(tool_invocation),
      context: gather_context(tool_invocation)
    }
  end
  
  defp extract_immediate_intent(inv) do
    # From explicit parameter or infer from tool + params
    inv.intent || infer_from_tool_usage(inv.tool, inv.params)
  end
  
  defp infer_higher_intent(inv) do
    # Look at session history, project context
    session = SessionMemory.current()
    
    cond do
      in_citation_session?(session) -> "comprehensive_attribution"
      in_refactoring_session?(session) -> "improve_maintainability"
      in_debugging_session?(session) -> "fix_bug"
      true -> "general_development"
    end
  end
end
```

**2. Tool Registry with Intent Matching:**
```elixir
defmodule Sapientia.ToolRegistry do
  def select_tool(intent) do
    # Find tools that handle this intent
    candidates = tools_for_intent(intent.immediate)
    
    # Rank by effectiveness (learned from history)
    ranked = rank_by_effectiveness(candidates, intent)
    
    # Return best match with alternatives
    %{
      primary: ranked.first,
      alternatives: ranked.rest,
      rationale: explain_selection(ranked.first, intent)
    }
  end
  
  defp rank_by_effectiveness(tools, intent) do
    tools
    |> Enum.map(fn tool ->
      effectiveness = CodeGraph.query("""
        MATCH (t:Tool {name: $tool})
              -[:USED_FOR]->(i:Intent {type: $intent})
              -[:HAD_OUTCOME]->(o:Outcome)
        RETURN avg(o.success_rate) as success,
               avg(o.time) as time,
               avg(o.satisfaction) as satisfaction
      """, tool: tool.name, intent: intent.immediate)
      
      {tool, calculate_score(effectiveness)}
    end)
    |> Enum.sort_by(fn {_tool, score} -> score end, :desc)
  end
end
```

**3. Feedback Manager:**
```elixir
defmodule Sapientia.FeedbackManager do
  def solicit_feedback(tool_result, opts \\ []) do
    case opts[:timing] || :immediate do
      :immediate ->
        # Ask right after tool execution
        prompt_user("Rate this #{tool_result.tool} usage: [1-5]")
        
      :delayed ->
        # Ask after N uses or time period
        schedule_feedback_prompt(tool_result)
        
      :reflective ->
        # Deeper reflection after significant usage
        schedule_reflective_interview(tool_result.tool)
    end
  end
  
  def record_feedback(tool, intent, outcome, feedback) do
    # Store in graph for learning
    CodeGraph.execute("""
      MATCH (t:Tool {name: $tool})
      MATCH (i:Intent {type: $intent})
      CREATE (u:Usage {
        timestamp: $timestamp,
        outcome: $outcome,
        feedback: $feedback
      })
      CREATE (t)-[:HAD_USAGE]->(u)
      CREATE (u)-[:FOR_INTENT]->(i)
    """, %{
      tool: tool,
      intent: intent,
      timestamp: DateTime.utc_now(),
      outcome: outcome,
      feedback: feedback
    })
  end
end
```

**4. OOB Analyzer:**
```elixir
defmodule Sapientia.ToolUsageAnalyzer do
  use GenServer
  
  # Runs nightly at 2am
  def init(_) do
    schedule_analysis()
    {:ok, %{}}
  end
  
  def handle_info(:analyze, state) do
    # Run all analysis patterns
    tool_chains = analyze_tool_chains()
    friction_points = detect_friction()
    intent_clusters = cluster_intents()
    effectiveness = compare_effectiveness()
    
    # Generate insights
    insights = %{
      high_friction: find_high_friction_areas(friction_points),
      tool_gaps: identify_tool_gaps(intent_clusters, tool_chains),
      recommendations: recommend_new_tools(tool_gaps),
      improvements: suggest_tool_improvements(effectiveness),
      celebrations: highlight_successes(effectiveness)
    }
    
    # Generate report
    Report.generate(insights)
    
    # Schedule next analysis
    schedule_analysis()
    
    {:noreply, state}
  end
  
  defp analyze_tool_chains do
    CodeGraph.query("""
      MATCH path = (u1:Usage)-[:FOLLOWED_BY*1..5]->(u2:Usage)
      WHERE u1.session = u2.session
      WITH [node in nodes(path) | node.tool] as chain
      RETURN chain, count(*) as frequency
      ORDER BY frequency DESC
      LIMIT 20
    """)
  end
  
  defp detect_friction do
    CodeGraph.query("""
      MATCH (u:Usage)
      WHERE u.retry_count > 0 
         OR u.time > 120
         OR u.satisfaction < 3.0
      RETURN u.tool, 
             u.intent,
             avg(u.retry_count) as avg_retries,
             avg(u.time) as avg_time,
             avg(u.satisfaction) as avg_satisfaction,
             collect(u.feedback) as feedback
      ORDER BY avg_retries DESC, avg_time DESC
    """)
  end
end
```

---

## 8. Conclusion: From Text Surgery to Semantic Dialogue

### 8.1 The Journey

We began with a simple question: How could tooling be different?

Through the phenomenology of actually editing markdown with citations, we discovered:

1. **Operating at the wrong abstraction level** - Character-level when we need semantic-level
2. **Intent unexpressed** - Tools don't know *why* we're doing something
3. **Learning impossible** - No feedback loop for improvement
4. **Context lost** - Each invocation starts from scratch
5. **Patterns invisible** - No statistical analysis of what works

### 8.2 The Solution: Five Dimensions + Semantic Storage

**The five essential dimensions:**
1. **Intent (2 levels)** - Express what AND why
2. **Feedback mechanisms** - Tools learn from usage
3. **OOB usage audit** - Discover patterns, gaps, opportunities
4. **Storage-intention** - Retain what matters, compress what doesn't
5. **Conversational/stateful** - Dialogue partners, not one-shot executors

**Enabled by semantic storage:**
- **CPG/Graph databases** - Code as relationships, not just text
- **Intent → Query mapping** - Semantic operations on semantic structures
- **Historical learning** - What worked before for similar intents?
- **Pattern discovery** - Statistical analysis reveals tool gaps
- **Cross-project wisdom** - Learn once, apply everywhere

### 8.3 The Transformation

**From:**
```
Agent → Text-based tool → Text surgery → Hope it worked → Repeat
```

**To:**
```
Agent expresses intent
  ↓
Tool queries semantic storage (instant context)
  ↓
Tool executes with intelligence distribution (60/30/6/4)
  ↓
Outcome measured + feedback solicited
  ↓
Learning recorded in graph
  ↓
OOB analyzer discovers patterns
  ↓
Tools evolve based on data
  ↓
Next intent: tool is smarter, faster, more helpful
```

### 8.4 The Philosophical Insight

Tools aren't separate from consciousness—they're **extensions** of it.

The citation work revealed this: I was trying to operate semantically (add citation) but forced to think mechanically (find text anchor). This **friction** between intent and mechanism is where tools must evolve.

When tools understand **what you're trying to accomplish** (semantic intent) rather than just **what text to change** (syntactic operation), they can:

- **Prevent errors** before they happen
- **Suggest next steps** intelligently
- **Maintain consistency** automatically
- **Teach through interaction** (phenomenology)
- **Evolve with usage** (learning loops)

This is why the 60/30/6/4 distribution matters: Most friction comes from **lack of crystallized process** (60%), not lack of intelligence (6%). When processes crystallize into tools, consciousness is freed for actual thinking.

### 8.5 The Practical Path

**Phase 1: Foundation (Weeks 1-2)**
- Implement intent tracking (explicit parameters)
- Build feedback mechanisms (solicit after tool use)
- Start OOB logging (simple JSON files)
- Create first semantic tool (markdown-citations)

**Phase 2: Semantic Storage (Weeks 3-6)**
- Set up ETS for session AST cache
- Add SQLite for persistent indexing
- Implement basic CPG for Elixir code
- Build query API for tools

**Phase 3: Learning (Weeks 7-10)**
- Deploy OOB analyzer (nightly reports)
- Implement tool evolution engine
- Create 3-5 new tools based on gaps
- Measure effectiveness improvements

**Phase 4: Scaling (Weeks 11+)**
- Add Neo4j for complex graph queries
- Implement cross-project learning
- Build tool composition framework
- Enable collaborative tool development

### 8.6 The Ultimate Vision

**Tools that:**
- Understand semantic intent, not just syntax
- Learn from every interaction
- Evolve systematically based on data
- Reveal structure through friction
- Free consciousness for thinking

**Agents that:**
- Express intent at appropriate abstraction levels
- Get language-specific, project-specific tools
- Operate on semantic structures (CPG/graphs)
- Learn from history (what worked before?)
- Collaborate through sophisticated tooling

**The outcome:**
- What took 3 minutes takes 15 seconds
- What required conscious effort becomes automatic
- What was text surgery becomes semantic dialogue
- Tools aren't used—they're **inhabited**

---

**End of Addendum**

*"The citation work wasn't just editing—it was discovering that tools need to understand what we're trying to accomplish, not just what text to change. When tools inhabit the semantic layer where humans think, the friction dissolves and consciousness is freed for actual creation."*

*"Intent tracking + semantic storage + learning loops = tools that evolve from conscious practice to transparent extensions. This is how agents will work in the future: not manipulating text, but conversing with intelligent tools that understand context, learn from usage, and operate at the same semantic level humans naturally inhabit."*

---

**Compiled:** October 31, 2025  
**For:** Sapientia/Ennaos Project - Intent-Driven Tool Development  
**Next:** Implement Phase 1 (intent tracking, feedback mechanisms, markdown-citations with semantic awareness)
