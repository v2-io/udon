---
source: sapientia — context-queries.md (2025-09-24) — empirics excerpt
gathered: 2026-07-21
status: gathered (excerpt — head L1-110 carries the context-window accounting empirics; full file 243 lines)
paths:
  - ~/src/_core/sapientia/context-queries.md:1-110
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, context-window, token-accounting, budget-aware-tooling, empirics, harness-facing]
why_included: >
  Hard empirics on what actually counts toward an agent's context window: tool
  definitions consume 5-10K+ tokens and are easy to under-count; previous-turn
  thinking blocks are auto-stripped by the API (so local counting inflates);
  tracking snapshots and system-reminders leak in if not stripped. This is
  ground-truth demand evidence for budget-aware tooling and for UDON's
  streaming/agent-consumption + self-chunking claims — the harness side needs
  exactly this to reason about what a tool's presence costs an agent.
---

# Context Window and Token Counting: Research Synthesis

## Executive Summary

After extensive research into Anthropic's token counting API and analysis of the minimal-sapientia implementation, I've identified several critical issues causing the discrepancy between reported context usage (47%) and actual usage (95%). The main problems are:

1. **Tool definitions are not included in token counts** but consume significant tokens
2. **Thinking blocks from previous turns ARE being counted** when they shouldn't be
3. **Tracking snapshots are not properly excluded** from token calculations
4. **Initial context and system reminders** are not consistently tracked

## How Token Counting Actually Works

### What the API Count_Tokens Endpoint Includes

Based on official documentation, the `/v1/messages/count_tokens` endpoint counts:
- System prompt
- All messages in the conversation
- Tool definitions (when provided)
- Structured content blocks (thinking, tool_use, tool_result)

### What Counts Toward Context Window (200K for Opus 4.1)

According to Anthropic's documentation:

**DOES Count:**
- System prompt (always)
- All user messages
- All assistant messages EXCEPT thinking blocks from previous turns
- Tool definitions (significant overhead - can be 5-10K+ tokens)
- Tool use blocks and tool results
- Current turn's thinking blocks
- Any files or context loaded via @mentions or initial_context
- Tracking snapshots (if not properly stripped)
- System reminders added by Claude Code

**Does NOT Count:**
- Thinking blocks from previous assistant turns (automatically stripped by API)
- Redacted thinking content from previous turns

### Critical Discovery: Thinking Block Behavior

From the documentation:
> "Previous thinking tokens are automatically stripped from context window calculations. All other previous blocks still count as part of the token window, and the thinking block in the current Assistant turn counts as part of the context window."

This means:
1. When you send messages to the API, you should NOT include thinking blocks from previous assistant messages
2. The API automatically strips them to save context
3. But if you're counting them locally, you'll get inflated numbers

## Problems Found in minimal-sapientia

### Problem 1: Tool Definitions Not Counted

The `build_token_count_request` method doesn't include tool definitions:

```ruby
def build_token_count_request(messages, include_system_prompt = true)
  request = {
    model: MODEL,
    messages: flattened_messages
  }
  # System prompt is added, but NO TOOLS!
  if include_system_prompt && @system_prompt
    request[:system] = @system_prompt
  end
  request
end
```

But in `make_api_call`, tools ARE sent to the API:
```ruby
if @tools_enabled
  body[:tools] = get_tool_definitions  # This can be 5-10K tokens!
end
```

### Problem 2: Thinking Blocks Incorrectly Counted

The `flatten_content_for_counting` method includes ALL thinking blocks:

```ruby
if block[:type] == 'thinking' || block['type'] == 'thinking'
  # Include thinking content - it counts towards tokens!
  thinking_text = block[:thinking] || block['thinking'] || block[:text] || block['text']
  if thinking_text
    parts << "[Thinking: #{thinking_text}]"
  end
end
```

This is wrong for previous turns - only current turn thinking should count.

### Problem 3: Tracking Snapshots Not Properly Excluded

While `prepare_messages_with_tracking` strips tracking snapshots for sending, the token counting doesn't account for:
1. Tracking snapshots being added to messages
2. The difference between what's counted vs what's sent

### Problem 4: Initial Context Handling

Initial context is prepended to the first message but not properly tracked:
```ruby
if @messages.empty? && @initial_context_content
  context_prefix = <<~XML
    <initial_context>
    #{@initial_context_content}
    </initial_context>
  XML
  user_message = context_prefix + user_message
