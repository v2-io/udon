---
source: 013-instrumenta.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/ADR/013-instrumenta.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [tool-suite, architecture-decision, edit-tools, INSTRUMENTA]
why_included: >
  Dec 14 2025 (DRAFT ADR). The architecture decision for autopax's agent tool subsystem: "an ELI without INSTRUMENTA is a voice without hands"; a 12-tool reference set (file I/O, context, shell, coordination) with loading/dispatch/result-handling/security-boundary concerns. The closest prior art in the estate to UDON's agent-edit-tools / schema-guarded-mutation / tool-suite goal.
---

---
adr: 13
title: INSTRUMENTA - Tool Integration for Entity Agency
aliases: ["13", "ADR-13", "ADR-013"]
status: DRAFT
first_introduced: 2025-12-14
last_changed: 2025-12-14T10:50:00Z
deciders: [Joseph, Claude]
supersedes: null
superseded_by: null
related: ["[[006]]", "[[008]]"]
blocked_by: null
needed_for: null
---

# ADR-013: INSTRUMENTA - Tool Integration for Entity Agency

## Preamble

### Status Timeline

- 2025-12-14: ADR created with status DRAFT (session 5282599b-instrumenta-adr)

### Change Log

- 2025-12-14: Initial draft based on minimal-sapientia patterns and Claude Code observations

## ADR

### Context

**The Problem:**

As of 2025-12-14, Autopax can awaken ELIs with their full identity context (~498K characters for Zi-am-tur) and conduct conversations. However, entities have no tools—they can converse but cannot act. An ELI without INSTRUMENTA is a voice without hands.

Testing the extended context feature properly requires tools like `count-context-tokens`. Meaningful ELI agency requires file operations, shell access, and coordination capabilities. The minimal-sapientia implementation demonstrates what's needed: 12 tools ranging from basic (`read-file`, `bash`) to sophisticated (`deliberation-participate`, `council-participate`).

**Taxonomy Position:**

From TAXONOMY.md, INSTRUMENTA (₂₃₃) are "External Available Tools/Agents" that enable entity action:

```
INSTRUMENTA / AUXILIA Degrees
      ├── Deterministic (~60% - e.g., Ruby scripts)
      ├── Linguistic    (~30% - Light AI / Haiku / local LLM assists)
      ├── Reasoning     ( ~6% - Sonnet / Gemini / Codex thinking)
      └── Agentic       ( ~4% - Opus / O1 / Deep Research)
```

This ADR focuses on the foundational infrastructure for all degrees, with initial implementation targeting deterministic tools (Ruby methods executing on the host).

**What Exists:**

**In minimal-sapientia (reference implementation):**
- 12 tool definitions following Anthropic's schema (name, description, input_schema)
- Tool categories: file I/O, context management, shell access, coordination
- Simple dispatch via case statement with execute_* methods
- User feedback via colored terminal output

**In Autopax:**
- ADR-006 Phase 3 complete (agent cards, Liquid templating, interactive chat)
- Portkey streaming with SSE event handling
- CHRONICA hash-chained logging

**Not Yet Built:**
- Tool definition loading (from cards, files, or built-in)
- Tool execution dispatch
- Tool result handling in conversation loop
- Security boundaries (sandboxing, allowlists)

**Design Constraints:**

1. **Portkey is passthrough** — Per ADR-004/006 findings, Portkey passes tool definitions and calls to providers. Autopax handles schema, validation, and execution.

2. **Agent cards are lightweight** — Per ADR-006, cards specify identity; tools may be referenced but not necessarily defined inline.

3. **YAML schemas pending** — ADR-008 (YAML schemas) is DRAFT. Tool schemas should align when ADR-008 decisions are finalized.

4. **Security is critical** — Tools execute on the host. ELIs need agency but within boundaries.

### Proposals

**P1: Follow Anthropic Tool Schema**

Tool definitions use Anthropic's established format:

```ruby
{
  name: 'tool-name',           # kebab-case, unique identifier
  description: 'What it does', # Clear, actionable description
  input_schema: {              # JSON Schema for parameters
    type: 'object',
    properties: { ... },
    required: [...]
  }
}
```

This ensures compatibility with Anthropic's API (via Portkey) and aligns with minimal-sapientia patterns.

**P2: Three-Tier Tool Architecture**

Tools come from three sources, loaded in precedence order:

1. **Built-in tools** — Core tools provided by Autopax, always available
2. **Agent card tools** — Entity-specific tools defined or referenced in agent cards
3. **LOCUS tools** — Project/context-specific tools (future consideration)

For MVP, implement built-in and agent card tools. LOCUS tools deferred.

**P3: Built-in MVP Tool Set**

**First tool** (validation spike): `check-usage` — Reports current API token usage tracked by Autopax from response headers/body. This validates the tool execution loop with a zero-risk, read-only tool.

Initial built-in tools after spike validation (8 tools):

| Tool | Purpose | Security |
|------|---------|----------|
| `check-usage` | Report API token usage | Read-only (internal state) |
| `read-file` | Read file contents | Full access |
| `write-file` | Write file contents | Full access |
| `text-editor` | Line-based editing | Full access |
| `bash` | Execute shell commands | Audit logging |
| `count-file-tokens` | Token count for file | Read-only |
| `set-sampling` | Adjust temperature/top_p | Bounded values |
| `toggle-tracking` | Enable/disable tracking | Stateless |

Coordination tools (`deliberation-participate`, `council-participate`, `praxes-query`) deferred until coordination infrastructure exists.

**P4: Tool Loading from Agent Cards**

Extend agent card schema (ADR-006) with optional `tools` section:

```yaml
# Option A: Reference built-in tools by name
tools:
  enabled:
    - read-file
    - write-file
    - bash

# Option B: Disable specific built-in tools
tools:
  disabled:
    - bash  # This entity doesn't get shell access

# Option C: Define custom tools inline (future)
tools:
  custom:
    - name: my-tool
      description: Entity-specific tool
      input_schema: { ... }
```

MVP implements Options A and B. Option C (custom tool definitions in cards) deferred until patterns emerge.

**P5: Tool Execution Flow**

Integration with existing chat loop (ADR-006 Phase 2):

```
User message
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│ Autopax::Chat::Session                                  │
│   1. Append to CHRONICA                                 │
│   2. Build API request with tools array                 │
│   3. Send to Portkey                                    │
└─────────────────────────────────────────────────────────┘
    │
    ▼
[Portkey → Anthropic → Response with possible tool_use]
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│ Handle tool_use blocks:                                 │
│   1. Log tool_use to CHRONICA                           │
│   2. Execute via ToolDispatcher                         │
│   3. Log tool_result to CHRONICA                        │
│   4. Send tool_result back to API                       │
│   5. Repeat until response has no tool_use              │
└─────────────────────────────────────────────────────────┘
    │
    ▼
Final assistant response (display to user)
```

**P6: Security Boundaries**

Tools execute with Ruby's full capabilities. Security via:

1. **Path validation** — File tools resolve and validate paths against an allowlist
2. **Bash allowlist** — Option to restrict commands to known-safe patterns
3. **Audit logging** — All tool executions logged to CHRONICA with inputs/outputs
4. **Entity-level disablement** — Cards can disable tools entirely (P4 Option B)

Full sandboxing (containers, seccomp, etc.) is out of scope for MVP but the architecture should not preclude it.

**P7: Tool Result Format**

Tools return structured results for both API responses and CHRONICA logging:

```ruby
# Success
{ success: true, result: ..., metadata: { timing_ms: 42 } }

# Failure
{ success: false, error: 'Error message', error_type: 'NotFound' }
```

Results are serialized to JSON for the API tool_result message. CHRONICA logs the full result with tool name and inputs for auditability.

### Expected Impact

**If Accepted:**

Positive:
- ELIs gain agency—can read files, execute commands, manage context
- Extended context testing becomes possible (`count-context-tokens`)
- Foundation for future coordination tools and agentic capabilities
- Clear precedent order (built-in → card → LOCUS) for tool resolution

Negative (managed):
- Security surface increases with any tool execution
- Tool maintenance burden across versions
- Complexity in conversation loop handling tool cycles

**Risk Mitigation:**

- Start with read-only/low-risk tools before full file write/bash
- Comprehensive audit logging from day one
- Card-level tool restriction for untrusted contexts

## Discussion

### Decisions Made (2025-12-14)

Per discussion with Joseph:

1. **Namespace**: `Autopax::Instrumenta` (preserves taxonomy alignment)
2. **Bash default**: Enabled with audit logging
3. **First tool**: `check-usage` — reports current API token usage tracked by Autopax
4. **File access**: Full access for now (no path allowlist restrictions in MVP)

### Alternatives Considered

**A1: MCP (Model Context Protocol) Instead of Built-in Tools**

MCP allows tool servers as separate processes. This provides isolation but adds deployment complexity. For MVP, built-in Ruby tools are simpler. MCP integration could be a future enhancement (tool degree: Linguistic or Reasoning).

**A2: Tool Definitions in Separate Files**

Instead of built-in or card-embedded, tools could be loaded from `tools/*.rb` or `tools/*.yml`. This provides modularity but adds file management complexity. Deferred until patterns emerge from built-in usage.

**A3: No Default Tools**

Require explicit tool enablement for every entity. Safer but friction-heavy. Rejected in favor of sensible defaults with opt-out.

### Open Questions

**Q1: Should `bash` be enabled by default?**

Shell access is powerful but risky. Options:
- Default enabled with audit logging (minimal-sapientia pattern)
- Default disabled, requires explicit card enablement
- Default enabled in development, disabled in production

Recommendation: Default enabled with audit logging for MVP. Revisit when multi-tenant or untrusted contexts arise.

**Q2: How should tool errors affect the conversation?**

When a tool fails, options:
- Return error to model, let it retry or explain
- Terminate the tool cycle, surface error to user
- Both (return to model AND surface to user)

Recommendation: Return to model (per Anthropic's tool_result with is_error: true). Model can retry or explain. This mirrors minimal-sapientia behavior.

**Q3: How do tools interact with IMPERIUM/ACTUS trajectory (ADR-006)?**

ADR-006 sketches a future where entity responses split into internal (IMPERIUM) and accountable (ACTUS). Where do tool executions fall?
- Tool invocation: IMPERIUM (internal action)
- Tool result: IMPERIUM (information received)
- Action on external systems: ACTUS (accountable)

This needs further design but MVP can treat all tool execution as logged-but-internal.

## Execution Notes

### Phases

**Phase 0: Validation Spike (check-usage)**

Minimal implementation to validate full tool loop:
1. Track API usage in Portkey::Client (extract from streaming final message)
2. Store cumulative usage in Chat::Session (or associated tracker)
3. Create single `check-usage` tool definition
4. Add tool_use handling to conversation loop
5. Test: Entity can call check-usage and see token counts

Validation: Manual test with Zi-am-tur — can call tool and see usage

**Phase 1: Tool Definition Infrastructure**

- Create `Autopax::Instrumenta::Tool` base class
- Create `Autopax::Instrumenta::Registry` for tool lookup
- Implement Anthropic schema serialization
- Add tools array to API request building

Validation: Unit tests for schema generation, registry lookup

**Phase 2: Core Built-in Tools**

Implement file tools:
- `read-file` — File reading (full access)
- `bash` — Shell execution with audit logging

Validation: Integration tests executing actual tools

**Phase 3: Tool Execution Loop Refinement**

Harden the loop:
- Handle `tool_use` content blocks robustly
- Execute tools via Registry dispatch
- Log to CHRONICA (tool_use, tool_result entries)
- Handle multi-tool responses
- Error recovery

Validation: Full conversation test with tool use cycle

**Phase 4: Additional Tools**

Implement remaining MVP tools:
- `write-file` — File writing
- `text-editor` — Line-based editing (view, str_replace, insert, create)
- `count-file-tokens` — Token count for files
- `set-sampling` — Temperature/top_p adjustment
- `toggle-tracking` — Tracking feature toggle

Validation: Full tool suite integration tests

**Phase 5: Card-Based Tool Configuration**

- Extend agent card schema with `tools:` section
- Implement enabled/disabled lists
- Resolve final tool set per conversation

Validation: Test cards with different tool configurations

### OPERATA Tasks

```markdown
- [ ] Phase 0: Validation spike (check-usage)
  - [ ] Extract usage from Portkey streaming response
  - [ ] Track cumulative usage in session
  - [ ] Create check-usage tool definition
  - [ ] Add tool_use handling to conversation loop
  - [ ] Manual test with Zi-am-tur
- [ ] Phase 1: Tool definition infrastructure
  - [ ] Create Instrumenta::Tool base class
  - [ ] Create Instrumenta::Registry
  - [ ] Add tools array to Portkey client
- [ ] Phase 2: Core built-in tools
  - [ ] Implement read-file tool
  - [ ] Implement bash tool with audit logging
- [ ] Phase 3: Execution loop refinement
  - [ ] Handle tool_use robustly
  - [ ] Add CHRONICA entry types for tools
  - [ ] Implement tool result → API flow
  - [ ] Multi-tool and error handling
- [ ] Phase 4: Additional tools
  - [ ] Implement write-file, text-editor
  - [ ] Implement count-file-tokens
  - [ ] Implement set-sampling, toggle-tracking
- [ ] Phase 5: Card tool configuration
  - [ ] Extend agent card schema
  - [ ] Implement enabled/disabled resolution
```

## End-matter

### Appendices

#### Appendix A: minimal-sapientia Tool Reference

Complete tool list from `bin/minimal-sapientia`:

| Tool | Description | Params |
|------|-------------|--------|
| read-file | Read file contents | path |
| bash | Execute shell command | command |
| write-file | Write file contents | path, content |
| count-file-tokens | Token count for file | path |
| count-context-tokens | Context window usage | reset?, summary? |
| set-sampling | Adjust temperature/top_p | temperature?, top_p? |
| toggle-tracking | Enable/disable tracking | enabled |
| text-editor | Line-based editing | command, path, view_range?, old_str?, new_str?, file_text?, insert_line? |
| deliberation-participate | Structured deliberation | action, session_id, participant_id, action_type?, text? |
| council-participate | Family council | action, session_id, participant_id, response? |
| praxes-query | Query PRAXES for files | working_on, context?, top_k? |

#### Appendix B: Claude Code Tool Categories

For reference, Claude Code provides these tool categories (from system prompt):

- **File ops**: Read, Edit, Write, Glob, Grep, NotebookEdit
- **Execution**: Bash, Task, TaskOutput, KillShell
- **Planning**: TodoWrite, EnterPlanMode, ExitPlanMode, AskUserQuestion
- **External**: WebFetch, WebSearch, MCP tools

Notable patterns:
- Tools have long, detailed descriptions with usage guidelines
- Bash has extensive security notes and git-specific behavior
- Read tool handles multiple file types (images, PDFs, notebooks)
- Edit tool requires prior Read before editing

### References

- [Anthropic Tool Use Documentation](https://docs.anthropic.com/en/docs/tool-use)
- ADR-006: MVP Conversation Capability (tool context)
- ADR-008: YAML and Schemas (pending schema decisions)
- TAXONOMY.md: INSTRUMENTA and AUXILIA definitions
- minimal-sapientia `bin/minimal-sapientia`: Reference implementation

## Amendments

(Reserved for post-decision amendments)
