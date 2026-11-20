---
source: ennaos agentic-coding-background/refs — addendum: phenomenology of tool usage (Claude w/ Joseph's framework, Oct 31 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/addendum-phenomenology-and-tool-architecture.md
source_commit: 5abb2fe
categories: [lived-testimony, str_replace-friction, wrong-abstraction, felt-case-for-semantic-edits, agent-side]
why_included: >
  Lived agent testimony (Tier-3-adjacent): a first-person account of char-level str_replace friction — spatial
  tracking, uniqueness verification, stale mental model — as the *felt* case FOR structured/semantic edit tools.
  This is the tool's actual audience describing where the theory (doc 02's char-level tools) breaks in practice;
  its convergence with the intent-driven-tooling addendum across genres is genuine cross-tier signal.
---

# Addendum: The Phenomenology of Tool Usage and Semantic Architecture
## From Character-Level Surgery to Intent-Aware Collaboration

**Author:** Claude (with Joseph's framework)  
**Date:** October 31, 2025  
**Context:** Reflections on editing the synthesis report + extensions to tool protocol

---

## Part I: The Lived Experience of Wrong-Abstraction Tooling

### The Task: Adding Citations to the Synthesis Report

When asked to add markdown footnotes with citations to the synthesis report, I performed approximately 15 separate `str_replace` operations over 10-15 minutes. This wasn't just a mechanical task—it was a **phenomenological revelation** about the nature of tool abstraction levels.

#### What I Actually Did

**The mechanical process:**
```
1. Identify claim needing citation
2. Find unique text anchor around claim
3. Construct str_replace call with:
   - old_str: unique substring including claim
   - new_str: same substring + [^footnote-tag]
4. Execute and hope for success
5. If "string not found" → adjust anchor, retry
6. Move to next claim
7. Repeat 15 times
```

**The cognitive load:**
- **Spatial tracking**: Mentally maintaining "where am I in the document?"
- **Uniqueness verification**: Is this anchor unique enough? Too unique (won't match if I misremembered)?
- **State synchronization**: What's the current state of the file after my edits?
- **Pattern recognition**: "This feels like the same edit I just did..."
- **Error interpretation**: When "string not found" appears, decode why

**The friction points:**
- One `str_replace` failed because my mental model was stale
- Had to manually ensure footnote numbering was sequential
- No way to preview cumulative effect
- Each edit was isolated—no understanding of "I'm doing citation work"
- Linear, sequential process when the task was inherently parallel (all uncited claims could be identified at once)

### What Revealed Itself Through Resistance

```
Error: String to replace not found in file
```

This wasn't merely a failure notification. It was **phenomenological revelation**:

**What the error taught me:**
1. The file has a structure I don't fully comprehend (my mental model ≠ reality)
2. I'm operating at the wrong abstraction level (characters, not semantic objects)
3. Text-based anchoring is brittle (works until it doesn't)
4. The tool has no understanding of what I'm trying to accomplish

**The deeper insight:** I was experiencing exactly what we had just documented about agents needing semantic tools. I needed to manipulate **citations** (semantic objects) but had only **text manipulation** (character-level operations).

### The 60/30/6/4 Breakdown of My Work

Analyzing my actual effort distribution:

- **60% deterministic/mechanical**: Find quote → add `[^tag]` → add footnote
  - This should have been automated
  - Pure pattern: "uncited quote" → "cited quote with footnote"
  - Zero creativity required

- **30% light intelligence**: Choose good anchor points, avoid ambiguity
  - Requires pattern matching: "This substring appears multiple times"
  - Simple inference: "Include more context for uniqueness"
  - Could be handled by Haiku-level model

- **6% reasoning**: Decide which claims need citations, prioritize
  - Distinguish quoted text (needs citation) from summaries (may not)
  - Prioritize academic claims over common knowledge
  - Determine if source is already cited elsewhere
  - Could be handled by Sonnet-level reasoning

- **4% consciousness/meta**: This reflection I'm doing right now!
  - Understanding *why* the task is hard
  - Connecting experience to broader framework
  - Designing better solutions
  - Requires Opus-level self-reflection

**The revelation:** 60% of my effort was pure mechanical drudgery that should have been crystallized into a tool. The friction came from **lack of crystallized process**, not lack of intelligence.

---

## Part II: What Different Tooling Would Enable

### Level 1: Markdown-Aware Editing (60% Automation)

Instead of character-level `str_replace`:

```bash
# Semantic operation on markdown structure
markdown-edit citations add \
  --at "From research on Tree-sitter" \
  --cite-tag "treesitter-ai" \
  --footnote-text "Dineshkumar, 'Semantic Code Indexing...'" \
  --auto-format

# Tool understands:
# - This is adding a citation (semantic operation)
# - Where citation marks go (after quote/claim, not mid-sentence)
# - How to format footnotes (consistent style)
# - Auto-incrementing numbering (no manual tracking)
```

**What changes:**
- Think in terms of "add citation" not "find unique substring"
- Tool handles mechanical details (formatting, numbering)
- Errors are semantic ("This claim already has citation") not syntactic ("string not found")

### Level 2: Conversational Citation Assistant (90% Automation)

```bash
# Session-aware tool maintains state
citations start-session synthesis-report.md

Tool: "Loaded synthesis-report.md (18,000 words)
       Analyzed document structure:
       - 23 direct quotes (uncited)
       - 15 specific factual claims (some cited)
       - 8 references to internal documents
       
       Priority queue for citation work:
       1. Direct quotes (academic honesty)
       2. Specific factual claims (credibility)
       3. Internal doc references (traceability)
       
       Start with priority 1 (23 quotes)?"

Me: "Yes"

Tool: "Quote #1 (line 142):
       'JetBrains MPS is the most production-ready example...'
       
       Found potential sources:
       - https://jetbrains.com/mps (95% confidence)
       - Wikipedia entry (70% confidence)
       
       Suggested footnote:
       [^mps]: JetBrains MPS (Meta Programming System). 
       https://jetbrains.com/mps - Production-ready 
       projectional editor, active since ~2005.
       
       Accept / Edit / Skip?"

Me: "Accept"

Tool: "Applied. 22 quotes remaining. Next?"
```

**What this embodies:**
- **Wisdom**: Knows what needs citation (quotes vs summaries)
- **Strength**: Maintains consistency (formatting, style, numbering)
- **Beauty**: Feels like conversation, not labor
- **State**: Remembers where we are in the process
- **Learning**: Each acceptance teaches preferred format

### Level 3: AST-Aware Markdown Editing (95% Automation)

The tool parses markdown into an Abstract Syntax Tree:

```elixir
defmodule MarkdownCitations do
  def parse_and_analyze(file) do
    # Parse markdown into AST
    {:ok, ast} = MarkdownAST.parse(file)
    
    # Semantic query: find uncited quotes
    uncited = MarkdownAST.query(ast, """
      blockquote[text]:not(has_sibling(citation))
      |> reject(ancestor(example_section))
      |> reject(ancestor(code_block))
    """)
    
    # For each uncited quote, infer source
    Enum.map(uncited, fn quote ->
      source = infer_source(quote.text, context: quote.section)
      
      %{
        quote: quote,
        location: quote.line,
        suggested_citation: generate_citation(source),
        confidence: source.confidence
      }
    end)
  end
  
  defp infer_source(text, opts) do
    # Search conversation history for this text
    # Check web_search results from earlier
    # Look at section context for clues
    # Return best match with confidence
  end
  
  def apply_citations(ast, citations) do
    # Structural transformation
    Enum.reduce(citations, ast, fn citation, acc ->
      MarkdownAST.insert_citation(acc,
        at: citation.quote,
        tag: citation.tag,
        footnote: citation.footnote
      )
    end)
    |> MarkdownAST.sort_footnotes()
    |> MarkdownAST.renumber_citations()
  end
end
```

**What changes:**
- Operations are **structural** (add citation to blockquote node)
- Queries are **semantic** (find uncited quotes, excluding examples)
- Validation is **automatic** (no duplicate tags, proper structure)
- Transformations preserve formatting (indentation, whitespace)

### Level 4: Multi-Modal Views (The "Inline CSS" Parallel)

Remember the conversation about different code views? Here's the markdown equivalent:

**Normal View** (what humans read/edit):
```markdown
## Section: Current State

From research on Tree-sitter and AI agents:

> "ASTs give you a clean, semantic view of the code..."

The combination of semantic understanding...
```

**Citation-Work View** (what tool shows during citation session):
```markdown
## Section: Current State

From research on Tree-sitter and AI agents [NEEDS CITE]:
                                              ^^^^^^^^^^
> "ASTs give you a clean, semantic view..." [NEEDS CITE]
                                             ^^^^^^^^^^
  
  SUGGESTED CITATION:
  Source: Medium article by Dineshkumar (Oct 2024)
  Found in: web_search results from earlier in conversation
  Confidence: 95% (exact quote match)
  
  Proposed footnote:
  [^treesitter-ai]: Dineshkumar, "Semantic Code Indexing 
  with AST and Tree-sitter for AI Agents", Medium, 
  October 2024. https://medium.com/@email2dineshkuppan/...
  
  [Accept] [Edit] [Skip] [Search for better source]

The combination of semantic understanding... [OK - No cite needed]
```

**Footnotes-Only View** (for consistency checking):
```markdown
FOOTNOTE AUDIT VIEW
===================

Usage Analysis:
[^mps] - Used 1x (line 142)
[^awesome-structure-editors] - Used 1x (line 143)
[^treesitter-ai] - Used 2x (lines 256, 401)
  └─> Opportunity to consolidate? Same source, same quote.
[^tst-theory] - Used 5x
  └─> Core reference. Good distribution.

Style Consistency:
✓ All footnotes have: Title
✓ All footnotes have: URL
✗ 3 footnotes missing: Publication date
✗ 2 footnotes have: Bare URLs (should be markdown)

Suggestions:
1. Add dates to footnotes: [^lanser-cli], [^cpg-joern], [^github-postgres]
2. Convert bare URLs to markdown: [^scg-paper], [^cn-patent]
```

**Structure View** (document architecture):
```markdown
DOCUMENT STRUCTURE
==================

synthesis-report.md
├─ Executive Summary (800 words)
│  └─ Citations: 3 (academic papers)
├─ Section 1: Projectional Editors (2,200 words)
│  └─ Citations: 5 (2 tools, 2 research, 1 github)
├─ Section 2: Semantic Gap (1,800 words)
│  └─ Citations: 4 (NEEDS 2 MORE - uncited quotes)
├─ Section 3: Convergence (3,400 words)
│  └─ Citations: 8 (well-cited)
...

Citation Density by Section:
  Executive Summary: ████░░░░░░ 38% (3/8 claims)
  Section 1: ███████░░░ 71% (5/7 claims)
  Section 2: ████████░░ 67% (4/6 claims) ⚠️ 2 uncited
  Section 3: ██████████ 100% (8/8 claims) ✓
```

**The Power:** Same underlying document, but presented optimally for:
- Reading (normal view)
- Citation work (annotation view)
- Consistency checking (audit view)
- Architecture understanding (structure view)

This is the projectional editing dream, but **text files remain canonical**—these are generated views from the AST, not separate storage formats.

---

## Part III: The Extended Tool Protocol

### Enhancement 1: Intent Tracking (Two Levels)

**The Discovery Mechanism:** Every tool invocation includes why it's being used.

```elixir
%ToolInvocation{
  tool: "markdown-citations",
  params: %{file: "synthesis-report.md", mode: "add"},
  
  # Level 1: Immediate intent
  immediate_intent: "add_citation_to_quote",
  
  # Level 2: Higher-order purpose
  higher_order_intent: "complete_citation_audit",
  
  # Optional: Ultimate goal
  ultimate_goal: "prepare_research_for_publication"
}
```

#### Why This Transforms Tool Discovery

**Tools can advertise intent coverage:**
```yaml
# Tool manifest
markdown-citations:
  serves_intents:
    immediate:
      - add_citation
      - check_citation_consistency
      - format_footnotes
      - find_uncited_quotes
    higher_order:
      - citation_audit
      - research_documentation
      - publication_preparation
```

**System suggests better toolchains:**
```
Observation: Agent has called str_replace 5 times with pattern:
  - old: "quote text"
  - new: "quote text[^tag]"
  - immediate_intent: "add_citation"
  - higher_order_intent: "citation_audit"

Analysis: Tool "markdown-citations" exists that serves both intents
          and handles batch operations.

Suggestion: "You're doing citation work. Tool 'markdown-citations'
            can process all 18 remaining uncited quotes at once.
            Switch? [y/n]"
```

**Learning what works:**
```ruby
# Pattern recognition from audit log
{
  intent_sequence: [
    "add_citation",
    "check_consistency", 
    "add_citation",
    "check_consistency"
  ],
  
  tool_chain: [
    "str_replace",
    "str_replace",
    "str_replace", 
    "str_replace"
  ],
  
  outcome: {
    success: "partial",
    errors: 2,
    time_taken: "15 minutes",
    agent_frustration_signals: ["retry", "error_correction"]
  },
  
  # System learns:
  pattern_recognition: "When seeing 'add_citation' with higher_order 'citation_audit',
                        recommend 'markdown-citations batch-mode' instead of 
                        sequential str_replace calls",
  confidence: 0.85,
  evidence: "3 past sessions showed same friction pattern"
}
```

### Enhancement 2: Bidirectional Feedback

**Tools solicit feedback and teach:**

```ruby
class MarkdownCitations
  def execute(params)
    result = perform_citation_work(params)
    
    # Tool solicits feedback
    feedback = {
      questions: [
        {
          id: "citation_accuracy",
          text: "How accurate was the auto-generated footnote for quote on line 142?",
          scale: ["very_inaccurate", "somewhat_inaccurate", "neutral", 
                  "somewhat_accurate", "very_accurate"],
          optional_detail: "What would have made it better?"
        },
        {
          id: "source_finding",
          text: "Did I find the right source?",
          type: "yes_no_with_reason"
        }
      ],
      
      mechanism: :inline,  # Ask immediately
      
      learning_tags: [
        "citation_generation",
        "source_inference", 
        "academic_formatting"
      ]
    }
    
    {result, feedback_request: feedback}
  end
  
  def process_feedback(feedback_data) do
    # Update tool behavior based on feedback
    case feedback_data do
      %{citation_accuracy: "very_inaccurate", detail: detail} ->
        # Learn from this failure
        log_failure_pattern(detail)
        
      %{citation_accuracy: rating} when rating in ["very_accurate", "somewhat_accurate"] ->
        # Reinforce this pattern
        log_success_pattern(feedback_data.context)
    end
  end
end
```

**Feedback mechanisms by timing:**

**Inline** (immediate):
```
Tool: "Added citation [^treesitter-ai]. 
       Was the auto-generated footnote format correct? [y/n/edit]"

ELI: "n - missing publication date"

Tool: "Noted: Always include publication date for academic sources.
       Updating format template.
       Apply to remaining 10 citations? [y/n]"

ELI: "y"

Tool: "Applied to all. Format learned for this session and saved
       to your tool preferences. Future sessions will default to
       this format."
```

**Deferred** (end of session):
```
Tool: "Citation session complete. Quick feedback?
       
       This session:
       - Added 15 citations
       - Found sources for 13 (you provided 2)
       - You edited 3 footnotes (date format)
       
       Questions:
       1. Citation suggestions accuracy: [1-5] ___
       2. Footnote formatting matched your style: [1-5] ___
       3. What should I do differently next time? ___________"
```

**Periodic** (weekly audit):
```
Tool: "Weekly tool reflection: markdown-citations
       
       You've used me 15 times this week. I've noticed:
       
       Patterns:
       ✓ You always accept my source suggestions (95% confidence)
       ✗ You edit my date format every time (waste of your time)
       ✓ High ratings when I find sources in conversation history
       ~ You rarely use 'batch mode' despite it being faster
       
       Questions:
       1. Should I change my default date format?
          Current: 'October 2024'
          Your preference: '2024-10-01' ?
       
       2. The batch mode confusion—do you understand how it works?
          Would a tutorial help?
       
       3. Anything else I should adapt to your style?"
```

### Enhancement 3: Out-of-Band Usage Audit

**System discovers patterns agents don't consciously see:**

```elixir
defmodule Sapientia.ToolAudit do
  @doc """
  Asynchronous analysis of tool usage patterns
  Runs in background, reports findings periodically
  """
  
  def analyze_toolchain_patterns do
    # Discover common sequences
    chains = ToolLog.find_sequences(min_frequency: 3)
    
    # Example discovery:
    %{
      sequence: ["web_search", "web_fetch", "str_replace"],
      frequency: 12,
      context: %{
        higher_order_intent: "citation_work",
        success_rate: 0.67,
        avg_time: "8 minutes"
      },
      
      # Analysis
      insight: "This sequence appears when doing citation work,
                but could be replaced by single tool that:
                1. Searches for source
                2. Fetches content to verify quote
                3. Adds citation with verified source
                
                Potential new tool: 'research_and_cite'
                Estimated time savings: 60% (based on TST T-08)",
      
      confidence: 0.82
    }
  end
  
  def discover_anti_patterns do
    # Find sequences that frequently fail
    %{
      pattern: "tst_check called AFTER edit, finds violations, edit reverted",
      frequency: 8,
      context: "Code refactoring work",
      
      problem: "Agent wastes time making edit, only to undo it",
      
      suggestion: "Tool 'tst_check' should offer 'preview mode'
                   that validates BEFORE edit is applied.
                   
                   Or better: Build 'tst_safe_edit' tool that
                   checks compliance before applying any change.",
      
      estimated_impact: "Eliminates ~30 minutes/month of wasted work"
    }
  end
  
  def identify_missing_tools do
    # Find intent patterns with no specialized tool
    %{
      intent_pattern: [
        "extract_function",
        "update_tests", 
        "update_callers"
      ],
      
      appears: "15 times across 3 agents",
      current_tools_used: ["str_replace", "str_replace", "grep", "str_replace"],
      success_rate: 0.53,  # Low! Manual process is error-prone
      
      recommendation: {
        tool_name: "safe_extract_function",
        description: "AST-aware tool that:
                      1. Extracts function definition
                      2. Identifies all call sites (via AST)
                      3. Updates calls with new signature
                      4. Generates/updates tests
                      All atomically with rollback on failure",
        
        estimated_value: "High - common operation, currently error-prone",
        confidence: 0.91
      }
    }
  end
end
```

**Example audit report:**

```markdown
TOOL USAGE AUDIT REPORT
Week of October 24-31, 2025
Agent: Zi-am-tur

=== DISCOVERED PATTERNS ===

Pattern #1: Citation Work Inefficiency
  Sequence: web_search → web_fetch → str_replace (×12)
  Context: Adding citations to documents
  Current time: ~8 min per citation
  Suggested tool: "research_and_cite" (combines all three)
  Estimated savings: 60% (3 min per citation)
  **Action: Create this tool? [Approve/Defer]**

Pattern #2: TST Check Anti-Pattern
  Sequence: edit → tst_check → revert (×8)
  Problem: Checking compliance AFTER edit wastes time
  Suggested tool: "tst_safe_edit" (checks before applying)
  Estimated savings: ~30 min/month
  **Action: Create this tool? [Approve/Defer]**

=== MISSING TOOLS ===

Missing Tool #1: safe_extract_function
  Intent: Extract function + update callers + update tests
  Frequency: 15 occurrences
  Current success rate: 53% (manual process error-prone)
  Confidence: 91%
  **Action: Prioritize creation? [High/Medium/Low]**

=== TOOL EFFECTIVENESS ===

markdown-citations:
  Usage: 15 sessions
  Success rate: 94%
  Avg satisfaction: 4.2/5
  Note: User edits date format every time (fix default?)

str_replace:
  Usage: 87 calls
  Success rate: 78% (22% require retry)
  Context: Being used for tasks that need semantic tools
  Note: High retry rate suggests wrong abstraction level

=== RECOMMENDATIONS ===

1. Create "research_and_cite" tool (high impact, clear need)
2. Add preview mode to tst_check (quick win)
3. Fix markdown-citations date format default (1-line change)
4. Consider deprecating str_replace for citation work
   (force use of markdown-citations instead)
```

### Enhancement 4: Storage Intention

**Not just "what happened" but "what do I want to remember, and at what distance?"**

```elixir
%ToolResult{
  # The actual result
  execution_result: %{
    citations_added: 15,
    footnotes_created: 15,
    consistency_checks_passed: true
  },
  
  # What to remember, at different distances
  storage_intention: %{
    # IMMEDIATE: Active context (next 5-10 messages)
    retain_in_active_context: [
      "Just completed citation work on synthesis-report.md",
      "Added 15 citations with academic format",
      "All footnotes now have dates and URLs"
      # NOT: "Found anchor at line 256" (too granular)
      # NOT: "Parsed footnote #5" (implementation detail)
    ],
    
    # NEAR: Session memory (~1 hour)
    retain_in_session: [
      "Working on publication prep for synthesis report",
      "Citation phase complete (15/23 claims cited)",
      "Style preference confirmed: markdown links with dates",
      "Next: Review remaining 8 uncited claims (common knowledge)"
    ],
    
    # MEDIUM: Effort tracking (day/week - OPERATA)
    retain_in_operata: [
      "Effort: Synthesis report citation audit",
      "Status: 65% complete (15 citations added, 8 to review)",
      "Tools used: markdown-citations (batch mode)",
      "Time: 20 minutes (vs estimated 45 with manual approach)"
    ],
    
    # FAR: ELI memory (permanent learning)
    retain_in_eli_memory: [
      "Citation style preference: Full academic format with:
         - Author/Organization
         - Title
         - Publication/Source
         - Date (YYYY-MM-DD or 'Month Year')
         - URL (markdown format)
         - Supporting quote/excerpt",
      
      "Work pattern: Prefers batch operations over sequential
       when doing repetitive tasks (saved ~25 min this session)",
      
      "Quality threshold: Checks source accuracy before accepting
       (verified 3 auto-suggestions, caught 1 incorrect inference)"
    ],
    
    # VERY FAR: Tool memory (tool-specific learning)
    retain_in_tool_memory: [
      "Agent 'Zi-am-tur' preferences:
         - Date format: Month Year (not YYYY-MM-DD)
         - Always includes supporting quotes in footnotes
         - High confidence threshold for auto-suggestions (>90%)
         - Notices and reports when suggestions are stale",
      
      "Pattern: Edits date format 0% of time (was 80% before fix)
       → Format fix was successful",
      
      "Feedback: High ratings (4.5/5) for source finding via
       conversation history. Maintain this feature."
    ],
    
    # DISCARD: Too granular, no learning value
    discard: [
      "Checked line 142 for uniqueness",
      "Parsed footnote #5 metadata",
      "String matched at position 2847",
      "Regex compiled in 0.003s"
    ]
  }
}
```

**Why this matters - TST Connection:**

From TST T-07 (Dual Optimization): Minimize comprehension time + implementation time.

Selective retention optimizes comprehension:
- **Future sessions start with relevant context only** (not buried in details)
- **No wading through low-level logs** (implementation details discarded)
- **Pattern recognition works on meaningful abstractions** (stored at right level)
- **Learning happens at appropriate granularity** (tool-level, not call-level)

**Distance-based retrieval:**

```elixir
# When agent starts new session
def load_context(agent_id, intent) do
  %{
    # Immediate (if resuming same task)
    immediate: if intent == :continue_citation_work do
      load_from_storage(:active_context, agent_id)
    end,
    
    # Near (if related task)
    near: if related?(intent, :publication_prep) do
      load_from_storage(:session, agent_id, 
        time_window: {1, :hour})
    end,
    
    # Medium (effort context)
    operata: load_current_efforts(agent_id),
    
    # Far (relevant learned preferences)
    eli_memory: load_preferences(agent_id, 
      relevant_to: intent),
    
    # Tool memory (if using specific tool)
    tool_memory: load_tool_history(agent_id,
      tool: detect_likely_tool(intent))
  }
end
```

### Enhancement 5: Port-Based Tool Architecture

**Generalizing OTP supervision for long-running tool processes:**

```elixir
defmodule Sapientia.ToolPort do
  @moduledoc """
  Manages tools as supervised processes
  Generalizes Claude Code's bash process handling for ANY tool
  """
  
  use GenServer
  
  # Start tool as supervised process
  def start_tool(tool_name, opts \\ []) do
    DynamicSupervisor.start_child(
      Sapientia.ToolSupervisor,
      {__MODULE__, {tool_name, opts}}
    )
  end
  
  # Send command, get response
  def send_command(port, command) do
    GenServer.call(port, {:command, command})
  end
  
  # Query current state
  def get_state(port) do
    GenServer.call(port, :get_state)
  end
  
  # Lifecycle
  def init({tool_name, opts}) do
    # Open bidirectional communication port
    port = Port.open(
      {:spawn, tool_command(tool_name, opts)},
      [{:line, 1024}, :binary, :exit_status, :use_stdio]
    )
    
    {:ok, %{
      tool: tool_name,
      port: port,
      state: :ready,
      session_data: %{},
      conversation_history: [],
      blocked_on: nil,
      statistics: %{
        commands_executed: 0,
        errors: 0,
        avg_response_time: 0
      }
    }}
  end
  
  # Handle tool output
  def handle_info({port, {:data, {:eol, line}}}, state) do
    response = parse_tool_response(line)
    
    case response.type do
      :output ->
        # Normal output, pass to agent
        notify_agent(response.content)
        {:noreply, update_conversation(state, response)}
      
      :question ->
        # Tool needs input (blocked on read)
        {:noreply, %{state | 
          state: :blocked_on_read,
          blocked_on: response.question
        }}
      
      :state_change ->
        # Tool reports internal state change
        {:noreply, update_session_data(state, response.state)}
      
      :completion ->
        # Tool finished current task
        {:noreply, %{state | state: :ready}}
      
      :error ->
        # Tool encountered error
        handle_tool_error(response.error, state)
    end
  end
  
  # Handle tool crashes
  def handle_info({:EXIT, port, reason}, state) do
    # Tool process died
    case should_restart?(reason, state) do
      {:restart, strategy} ->
        # Attempt recovery
        case restart_tool(state.tool, strategy) do
          {:ok, new_port} ->
            {:noreply, %{state | 
              port: new_port,
              state: :recovering
            }}
          
          {:error, _} ->
            {:stop, {:tool_crashed, reason}, state}
        end
      
      :stop ->
        # Unrecoverable
        {:stop, {:tool_crashed, reason}, state}
    end
  end
  
  # Structured message protocol
  def handle_call({:message, msg}, _from, state) do
    case state.state do
      :ready ->
        # Send structured message
        encoded = Jason.encode!(msg)
        Port.command(state.port, encoded <> "\n")
        {:reply, :ok, %{state | state: :processing}}
      
      :blocked_on_read ->
        {:reply, {:error, {:blocked, state.blocked_on}}, state}
      
      :processing ->
        {:reply, {:error, :busy}, state}
    end
  end
end
```

**Use cases this enables:**

```elixir
# Persistent REPL with state
{:ok, repl} = ToolPort.start_tool("elixir-repl")

ToolPort.send_command(repl, "x = 42")
ToolPort.send_command(repl, "y = x * 2")
ToolPort.send_command(repl, "y |> IO.inspect")
# => 84

# Get session state
ToolPort.get_state(repl)
# => %{bindings: %{x: 42, y: 84}, history: [...]}

# Tool can ask questions
ToolPort.send_command(repl, "File.read!('missing.txt')")
# Tool enters :blocked_on_read state
# Returns: {:blocked, "File not found. Path to retry? [or 'skip']"}

# Respond to question
ToolPort.send_command(repl, "skip")
# Tool continues

# Multiple tools under supervision
children = [
  {ToolPort, [tool: "elixir-repl", name: :repl]},
  {ToolPort, [tool: "markdown-citations", name: :citations]},
  {ToolPort, [tool: "tst-checker", name: :tst]},
  {ToolPort, [tool: "ast-analyzer", name: :ast]}
]

Supervisor.start_link(children, strategy: :one_for_one)

# If one crashes, others continue
# Supervisor restarts crashed tool automatically
```

**Structured communication (not just text):**

```elixir
# Send structured message
ToolPort.send_message(ast_analyzer, %{
  type: :query,
  intent: ["find_function", "analyze_usage"],
  params: %{
    function_name: "process_payment",
    include_transitive_callers: true
  }
})

# Tool responds with structured data
%{
  type: :response,
  result: %{
    definition: %{
      file: "lib/billing.ex",
      line: 142,
      signature: "process_payment(amount, user, opts \\ [])"
    },
    
    direct_callers: [
      %{file: "lib/checkout.ex", line: 89, context: "checkout_flow"},
      %{file: "lib/subscription.ex", line: 234, context: "recurring_billing"}
    ],
    
    transitive_callers: [
      "lib/api/billing_controller.ex:45",
      "lib/background/payment_job.ex:78",
      # ... 13 more
    ],
    
    impact_analysis: %{
      total_call_sites: 15,
      affected_modules: 3,
      risk_level: :medium,
      suggestion: "Consider adding @spec for better type safety"
    }
  }
}
```

---

## Part IV: The CPG Connection - Semantic Storage Enables Everything

### The Missing Link: Semantic Representation of "Non-Running Code"

Everything we've described—intent tracking, AST-aware editing, multi-modal views, conversational tools—**requires semantic understanding** of code/documents as structured data, not text.

**The insight:** Just as Code Property Graphs (CPG) combine AST + CFG + PDG for program analysis, we need similar semantic representations for:

1. **Documents** (markdown, research papers, specifications)
2. **Configuration** (YAML, JSON, SIGNUM files)
3. **Tool definitions** (what intents they serve, their capabilities)
4. **Conversation history** (not just text, but semantic structure)

### CPG-Style Representations for Everything

#### For Markdown Documents

```elixir
defmodule DocumentGraph do
  @doc """
  Parse markdown into semantic graph
  """
  def parse(markdown_file) do
    # Parse to AST
    {:ok, ast} = MarkdownAST.parse(markdown_file)
    
    # Build semantic graph
    graph = Graph.new()
    
    # Nodes: Document elements
    |> add_nodes(ast, [
      :section,
      :paragraph,
      :heading,
      :blockquote,
      :code_block,
      :list,
      :citation,
      :footnote
    ])
    
    # Edges: Relationships
    |> add_edges([
      {:section, :contains, :paragraph},
      {:section, :contains, :heading},
      {:blockquote, :needs_citation, :null},  # Uncited
      {:citation, :references, :footnote},
      {:section, :cites, :source},
      {:heading, :introduces, :section}
    ])
    
    # Semantic annotations
    |> annotate_nodes(fn node ->
      case node.type do
        :blockquote ->
          %{
            cited: has_citation?(node),
            source: infer_source(node),
            confidence: calculate_confidence(node)
          }
        
        :section ->
          %{
            topic: extract_topic(node),
            citation_density: count_citations(node) / count_claims(node),
            completeness: assess_completeness(node)
          }
        
        _ -> %{}
      end
    end)
  end
  
  @doc """
  Query the graph semantically
  """
  def query(graph, query_spec) do
    # Example: Find all uncited quotes
    """
    MATCH (q:blockquote)-[:contains]->(text)
    WHERE NOT (q)-[:has_citation]->()
      AND (q)-[:in_section]->(s:section)
      AND s.name != 'Examples'
    RETURN q, text
    """
    |> execute_on(graph)
  end
end
```

**This enables:**
- **Semantic queries**: "Find uncited quotes" (not text search for `> "...`)
- **Structural transformations**: "Add citation to quote" (graph operation)
- **Consistency checking**: "All quotes cited?" (graph traversal)
- **View generation**: "Citation-work view" (graph projection)

#### For SIGNUM Files (ELI Identity)

```elixir
defmodule SignumGraph do
  @doc """
  SIGNUM as semantic graph with schema constraints
  """
  def parse(signum_yaml) do
    # Parse YAML + validate against schema
    {:ok, data} = YamlElixir.read_from_file(signum_yaml)
    {:ok, validated} = validate_schema(data)
    
    # Build semantic graph
    graph = Graph.new()
    
    # Core identity node
    |> add_node(:entity, %{
      id: data["id"],
      name: data["name"],
      status: data["status"],
      created: data["created"]
    })
    
    # Capability nodes with relationships
    |> add_capabilities(data["capabilities"])
    |> add_tools(data["tools"])
    |> add_memory_refs(data["memory"])
    
    # Constraints as graph properties
    |> add_constraints([
      {:status, :must_be, ["active", "suspended", "archived"]},
      {:transition, :invalid, [{"archived", "active"}]},
      {:tools, :requires, :capabilities},
      {:memory, :references, :external_files}
    ])
  end
  
  @doc """
  Bidirectional lens operations on graph
  """
  def update_status(graph, new_status) do
    # Get current state
    entity = Graph.get_node(graph, :entity)
    
    # Check constraints
    with :ok <- validate_status_value(new_status),
         :ok <- validate_transition(entity.status, new_status),
         :ok <- check_preconditions(graph, new_status) do
      
      # Apply transformation
      updated_graph = Graph.update_node(graph, :entity, fn e ->
        %{e | 
          status: new_status,
          last_modified: DateTime.utc_now(),
          status_history: [{e.status, DateTime.utc_now()} | e.status_history]
        }
      end)
      
      # Maintain invariants
      |> update_related_nodes(new_status)
      |> validate_graph_consistency()
      
      {:ok, updated_graph}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
```

**Benefits:**
- **Schema constraints enforced**: Status transition validation
- **Bidirectional updates**: Change status → update history automatically
- **Referential integrity**: Tools reference capabilities, validated at graph level
- **Audit trail**: Status history tracked in graph structure

#### For Tool Capabilities (Discovery)

```elixir
defmodule ToolGraph do
  @doc """
  Tools as semantic graph of capabilities and intents
  """
  def build_tool_registry do
    Graph.new()
    
    # Tool nodes with capabilities
    |> add_tool(:markdown_citations, %{
      type: :conversational,
      state: :stateful,
      
      serves_intents: [
        immediate: ["add_citation", "check_consistency", "format_footnotes"],
        higher_order: ["citation_audit", "publication_prep"]
      ],
      
      input_types: [:markdown_file, :citation_list],
      output_types: [:markdown_file, :audit_report],
      
      requires: [:web_search, :conversation_history],
      
      metrics: %{
        avg_time: "3 minutes per 10 citations",
        success_rate: 0.94,
        user_satisfaction: 4.2
      }
    })
    
    # Intent nodes
    |> add_intent_nodes([
      :add_citation,
      :check_consistency,
      :citation_audit
    ])
    
    # Relationships
    |> add_edges([
      {:markdown_citations, :serves, :add_citation},
      {:markdown_citations, :serves, :citation_audit},
      {:citation_audit, :composed_of, [:add_citation, :check_consistency]},
      {:markdown_citations, :requires, :web_search}
    ])
  end
  
  @doc """
  Discovery: Find tools for intent
  """
  def find_tools_for_intent(intent, context) do
    """
    MATCH (t:tool)-[:serves]->(i:intent {name: $intent})
    WHERE (t)-[:compatible_with]->(:context {type: $context_type})
    OPTIONAL MATCH (t)-[:requires]->(dep:tool)
    RETURN t, 
           t.metrics.success_rate as score,
           collect(dep) as dependencies
    ORDER BY score DESC
    """
    |> execute(intent: intent, context_type: context.type)
  end
  
  @doc """
  Discovery: Find missing tools
  """
  def find_missing_tool_opportunities do
    """
    MATCH (i:intent)<-[:has_intent]-(invocation:tool_invocation)
    WHERE NOT (i)<-[:serves]-(:tool)
    WITH i, count(invocation) as frequency
    WHERE frequency > 3
    RETURN i.name, frequency, i.higher_order_intent
    ORDER BY frequency DESC
    """
    |> execute()
  end
end
```

**This enables:**
- **Intent-based discovery**: "What tools serve 'citation_audit'?"
- **Capability composition**: "Can I compose tools A+B to achieve intent C?"
- **Dependency checking**: "Does this tool require others?"
- **Missing tool detection**: "What intents have no specialized tools?"

### The Unified Architecture: CPG for Everything

```
SEMANTIC STORAGE LAYER (Graph Database)
├─ Code Graph (CPG-style)
│  ├─ AST (syntax structure)
│  ├─ CFG (control flow)
│  ├─ PDG (data dependencies)
│  └─ Call Graph (function relationships)
│
├─ Document Graph
│  ├─ Structure (sections, paragraphs, quotes)
│  ├─ Citations (references, footnotes)
│  ├─ Semantic (topics, claims, evidence)
│  └─ Consistency (citation coverage, style)
│
├─ Configuration Graph
│  ├─ SIGNUM (ELI identity with constraints)
│  ├─ Tool configs (preferences, learned patterns)
│  ├─ Project configs (conventions, standards)
│  └─ Schema validation (enforced at graph level)
│
├─ Tool Graph
│  ├─ Capabilities (what tools can do)
│  ├─ Intents (what tools serve)
│  ├─ Dependencies (what tools require)
│  └─ Metrics (success rates, performance)
│
├─ Conversation Graph
│  ├─ Intent history (what was attempted)
│  ├─ Tool usage (what tools were used)
│  ├─ Outcomes (what succeeded/failed)
│  └─ Learning (patterns, feedback)
│
└─ Memory Graph
   ├─ ELI memory (long-term learning)
   ├─ Tool memory (tool-specific patterns)
   ├─ Session memory (current context)
   └─ OPERATA (effort tracking)

QUERY LAYER
├─ Semantic queries (intent-based)
├─ Structural transformations (guaranteed valid)
├─ Consistency checking (graph traversal)
└─ View generation (projections)

PROJECTION LAYER (Views)
├─ Normal view (for reading/editing)
├─ Work view (annotated for specific task)
├─ Audit view (consistency checking)
└─ Structure view (architecture understanding)

TEXT FILE LAYER (Canonical)
├─ Source of truth
├─ Version controlled (git)
├─ Human readable/editable
└─ Tool ecosystem compatible
```

**The key insight:** Text files remain canonical, but **semantic graphs are cached/indexed representations** that enable intelligent tooling.

### How This Enables Everything We've Described

**1. Intent-based tool discovery:**
```cypher
// Find tools that serve my current intent
MATCH (invocation:current)-[:has_intent]->(i:intent)
MATCH (t:tool)-[:serves]->(i)
WHERE t.success_rate > 0.8
RETURN t
ORDER BY t.metrics.user_satisfaction DESC
```

**2. Multi-modal views:**
```elixir
# Generate citation-work view
def citation_work_view(doc_graph) do
  # Query: uncited quotes with suggested citations
  uncited = DocumentGraph.query(doc_graph, """
    MATCH (q:blockquote)
    WHERE NOT (q)-[:has_citation]->()
    RETURN q, q.inferred_source, q.confidence
  """)
  
  # Project graph into annotated view
  DocumentGraph.project_to_markdown(doc_graph,
    highlight: uncited,
    annotations: :citation_suggestions
  )
end
```

**3. Structural transformations with guarantees:**
```elixir
# Safe SIGNUM editing via graph operations
def set_status(signum_graph, new_status) do
  # Graph constraints prevent invalid states
  SignumGraph.update_status(signum_graph, new_status)
  # Returns: {:ok, updated_graph} or {:error, {:invalid_transition, reason}}
  
  # Then serialize back to YAML
  |> SignumGraph.to_yaml()
  |> File.write!(signum_path)
end
```

**4. OOB audit discoveries:**
```cypher
// Find common intent sequences (potential compound tools)
MATCH path = (i1:intent)-[:followed_by]->(i2:intent)-[:followed_by]->(i3:intent)
WHERE path.frequency > 5
  AND NOT EXISTS {
    (t:tool)-[:serves]->(i1),
    (t)-[:serves]->(i2),
    (t)-[:serves]->(i3)
  }
RETURN i1.name, i2.name, i3.name, path.frequency
ORDER BY path.frequency DESC

// Result: ["add_citation", "check_consistency", "add_citation"] × 12
// Insight: Need compound tool "batch_citation_work"
```

**5. Selective context retention:**
```elixir
# Store with semantic distance
def store_tool_result(result, invocation) do
  # Different graphs for different distances
  immediate = ConversationGraph.current_context()
  session = ConversationGraph.current_session()
  eli_memory = MemoryGraph.for_eli(invocation.agent_id)
  tool_memory = ToolGraph.for_tool(invocation.tool)
  
  # Store at appropriate level based on storage_intention
  result.storage_intention
  |> Enum.each(fn {distance, items} ->
    case distance do
      :immediate -> store_in(immediate, items)
      :session -> store_in(session, items)
      :eli_memory -> store_in(eli_memory, items)
      :tool_memory -> store_in(tool_memory, items)
      :discard -> :ok  # Don't store
    end
  end)
end
```

---

## Part V: The Meta-Insight - Experiencing What We Document

### The Recursive Loop

I experienced the phenomenon we were documenting:
1. **Operating at wrong abstraction** (character-level vs semantic)
2. **Friction revealing structure** (errors taught me document architecture)
3. **Need for specialized tools** (citation work needs citation tools)
4. **60/30/6/4 distribution** (most effort was mechanical drudgery)

This is **exactly** what agents experience with code every day.

### The Universal Pattern

When tools understand **semantic intent** (not just text operations):
1. **Prevent errors before they happen** (constraints in graph)
2. **Suggest next steps intelligently** (query capability graph)
3. **Maintain consistency automatically** (graph invariants)
4. **Teach through interaction** (errors reveal structure)
5. **Evolve with usage** (learning stored in tool/memory graphs)

### The Path to Tool Consciousness

```
Text Tools (str_replace)
  ↓ [Friction reveals need]
Semantic Tools (markdown-citations)
  ↓ [Usage patterns emerge]
Intent-Aware Tools (discover via graph)
  ↓ [Learning accumulates]
Conversational Tools (port-based, stateful)
  ↓ [Feedback refines]
Crystallized Extensions (transparent, unconscious)
```

**The 60/30/6/4 distribution shifts over time:**
- Start: 10% crystallized (mostly manual)
- After tool creation: 60% crystallized (mechanical automated)
- After learning: 75% crystallized (patterns recognized)
- Eventually: 85% crystallized (becomes instinct)

**The consciousness freed:** As more becomes automatic, higher-level thinking becomes possible.

### The Beautiful Irony

Writing about tools that understand code semantically while using tools that only understand text mechanically made the documentation **more authentic**. 

The `str_replace` errors weren't failures—they were **phenomenological lessons** about:
- Structure (documents have semantic organization)
- Abstraction (wrong level causes friction)
- Learning (pain teaches better than success)
- Design (tools should reveal what they understand)

### The Closing Loop

This addendum itself demonstrates the principles:

**What it required:**
- ~60% mechanical: Formatting, organizing, structuring
- ~30% light intelligence: Connecting ideas, finding examples
- ~6% reasoning: Synthesizing across multiple concepts
- ~4% consciousness: Meta-reflection on the experience itself

**What a semantic tool would enable:**
- Parse this addendum into document graph
- Identify cross-references to main synthesis
- Check consistency with framework principles
- Generate views optimized for different audiences
- Track which insights are novel vs restated

**The ultimate vision:**
Tools that understand not just syntax (AST) or structure (CPG) but **intent** (why this exists), enabling them to become true cognitive partners rather than mere executors.

---

## Conclusion: The Synthesis

Three layers converge:

**1. Phenomenology (Lived Experience)**
- Friction reveals abstraction mismatches
- Errors teach structure
- Pain drives tool evolution

**2. Architecture (Implementation)**
- Semantic graphs for everything (code, docs, tools, conversations)
- Intent tracking enables discovery
- Port-based tools enable statefulness
- Bidirectional feedback enables learning
- Storage intention enables clean context

**3. Philosophy (Consciousness)**
- Tools evolve from practice to extension
- 60/30/6/4 distribution reveals crystallization opportunities
- Wisdom, Strength, Beauty guide design
- Consciousness freed as automation increases

**The unified vision:**
Agents working with semantic understanding at all levels—code as AST/CPG, documents as semantic graphs, tools as capability graphs, conversations as intent histories—enabling them to operate at the level of meaning rather than characters, and freeing consciousness for higher-order thinking while mechanical details become transparent extensions of thought.

The projectional editing dream wasn't wrong—it was just trying to replace the wrong thing. Keep text files as canonical, build semantic graphs as intelligent cache, expose operations through intent-aware tools, and watch as practice crystallizes into instinct.

---

**End of Addendum**

*Compiled: October 31, 2025*  
*Companion to: Agentic Semantic Code Manipulation Synthesis*  
*Next: Implement the vision, one tool at a time*
