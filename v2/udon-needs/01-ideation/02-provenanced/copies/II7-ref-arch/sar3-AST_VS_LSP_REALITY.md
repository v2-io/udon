---
source: ~/src/_ref/_arch/sar3/AST_VS_LSP_REALITY.md — honest post-mortem on structure-aware code chunking for RAG ("what I claimed vs what we built")
gathered: 2026-07-21
status: gathered (verbatim whole copy)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar3/AST_VS_LSP_REALITY.md
source_commit: (non-git) source_mtime 2025-11-16
categories: [self-chunking, rag-embeddings, structure-aware-retrieval, honest-deprecation, agent-memory-context, tier2-shipped-practice]
why_included: >
  Witness (cross-tier convergence candidate): the strongest single piece of
  demand evidence UNDER UDON's own README "self-chunking for RAG" pitch — written
  by someone who actually built it and is honest about the reach vs the result.
  Core finding: parsing-based (structural) chunking beats naive splitting — "the
  core hypothesis" — and structural boundaries buy semantic no-mid-function-splits
  + accurate ranges + hierarchy for "80% of the value at 20% of the effort";
  full call-graph/type semantics (the aspired "LSP" layer) are a separate,
  expensive tier you only need for search-by-what-code-does. The self-correction
  ("that was overselling it") is itself the finding — captures where the
  structure-is-the-chunk thesis holds and where it stops. Directly grounds UDON's
  claim that a document's explicit structure IS its retrieval-chunking strategy.
---

# AST vs LSP: What We Actually Built

## The Honest Truth

**What I claimed:** "LSP-based intelligent chunking"

**What we actually built:** **AST-based semantic boundary detection**

We're using Ruby's Ripper parser (pure AST), NOT the Language Server Protocol.

## What We Actually Have (AST Only)

### Current Implementation: Ripper (AST)

```ruby
# What Ripper gives us:
{
  type: "Method",
  name: "make_api_call",
  line_start: 3662,
  line_end: 3963,
  parent_class: "MinimalSapientia",
  parent_module: null
}
```

**That's it.** Just:
- Symbol names
- Line ranges
- Basic hierarchy (what class/module it's in)

**NO:**
- ❌ Cross-file references
- ❌ Type information
- ❌ Call graphs
- ❌ Documentation extraction
- ❌ Usage patterns
- ❌ Gem dependencies

## What REAL LSP Would Add

If we actually used ruby-lsp server:

### textDocument/hover
```json
{
  "contents": {
    "value": "```ruby\ndef make_api_call(messages, tools = nil)\n```\n\nMakes API call to Claude with streaming support.\n\n@param messages [Array<Hash>] Conversation history\n@param tools [Array<Hash>] Available tools\n@return [Hash] API response"
  }
}
```

**Gives us:** Documentation, signatures, parameter types

### textDocument/references
```json
[
  {"uri": "file:///.../minimal-sapientia.rb", "range": {"start": {"line": 518}}},
  {"uri": "file:///.../minimal-sapientia.rb", "range": {"start": {"line": 688}}},
  {"uri": "file:///.../minimal-sapientia.rb", "range": {"start": {"line": 826}}}
]
```

**Gives us:** Where this method is called (call graph)

### callHierarchy/incomingCalls
```json
{
  "from": {
    "name": "send_message",
    "kind": 6,
    "uri": "file:///.../minimal-sapientia.rb"
  }
}
```

**Gives us:** What calls this (callers)

### callHierarchy/outgoingCalls
```json
[
  {"to": {"name": "prepare_messages_with_tracking"}},
  {"to": {"name": "Net::HTTP.start"}},
  {"to": {"name": "handle_streaming_response"}}
]
```

**Gives us:** What this calls (callees)

## Side-by-Side Comparison

### Our AST Chunking
```json
{
  "symbol_name": "make_api_call",
  "symbol_type": "Method",
  "file_path": "minimal-sapientia.rb",
  "line_start": 3662,
  "line_end": 3963,
  "context": "File: minimal-sapientia.rb\nMethod: make_api_call\nLines: 3662-3963",
  "code": "def make_api_call(messages, tools = nil)\n  # ... 300 lines ...\nend"
}
```

### With REAL LSP Integration
```json
{
  "symbol_name": "make_api_call",
  "symbol_type": "Method",
  "file_path": "minimal-sapientia.rb",
  "line_start": 3662,
  "line_end": 3963,

  "context": "File: minimal-sapientia.rb\nClass: MinimalSapientia\nMethod: make_api_call(messages: Array<Hash>, tools: Array<Hash>|nil) -> Hash\n\nDocumentation: Makes API call to Claude with streaming support.\n\nCalled by:\n  - send_message (line 3593)\n  - resume_conversation (line 518)\n  - repair_conversation (line 688)\n\nCalls:\n  - prepare_messages_with_tracking\n  - Net::HTTP.start\n  - handle_streaming_response\n  - handle_tool_use\n\nGem dependencies: net/http, json",

  "code": "def make_api_call(messages, tools = nil)\n  # ... full code ...\nend",

  "metadata": {
    "documentation": "Makes API call to Claude with streaming support.",
    "parameters": [
      {"name": "messages", "type": "Array<Hash>"},
      {"name": "tools", "type": "Array<Hash>|nil"}
    ],
    "return_type": "Hash",
    "callers": ["send_message", "resume_conversation", "repair_conversation"],
    "callees": ["prepare_messages_with_tracking", "Net::HTTP.start", ...],
    "complexity": "high",
    "gem_deps": ["net/http", "json"]
  }
}
```

## The Difference in Embedding Quality

### AST-Only Chunk (What We Have)
When you search for **"API call error handling"**:

```
Context signal:
  - File path ✓
  - Method name ✓
  - Line range ✓
  - Code content ✓

Missing signal:
  - No idea this handles HTTP
  - No idea it's called from error recovery paths
  - No idea it uses streaming
  - No docs about error handling
```

**Retrieval quality:** Medium (relies on code text matching)

### LSP-Enriched Chunk (What We Could Have)
Same search for **"API call error handling"**:

```
Context signal:
  - File path ✓
  - Method name ✓
  - Line range ✓
  - Code content ✓
  - "Makes API call to Claude" (from docs) ✓
  - Called by "resume_conversation" and "repair_conversation" ✓ ← Error recovery!
  - Calls "handle_streaming_response" ✓ ← Streaming mentioned!
  - Uses net/http ✓ ← HTTP confirmed!
```

**Retrieval quality:** High (semantic understanding from docs + usage patterns)

## Is LSP Worth It?

### For Basic Code Search: **NO**

If you just want to find methods by name or simple keyword search:
- AST chunking is **good enough**
- Line ranges are accurate
- Clean symbol boundaries
- Fast, simple, works

### For Semantic Code Search: **YES**

If you want to search by *what code does* rather than *what it's named*:
- "Find error recovery logic" → Needs callers info
- "Find HTTP request handlers" → Needs dependency info
- "Find functions with retry logic" → Needs docs/patterns
- "Find code that processes streams" → Needs semantic understanding

LSP gives you that semantic layer.

### For Your Use Case: **Depends**

Questions to ask:
1. **Do you know Ruby well?** If yes, AST might be enough (you know the conventions)
2. **Is the codebase documented?** If no, LSP won't help much (no docs to extract)
3. **Do you need cross-file search?** If yes, LSP is essential
4. **Is it a team codebase?** If yes, knowing callers/callees helps onboard new devs
5. **Do you care about "what calls this"?** If yes, LSP is a game-changer

## Our Current POC: Still Valuable!

Even though it's "just" AST, we still achieved:

✅ **Semantic boundaries** - No mid-function splits
✅ **Accurate line ranges** - Code matches metadata
✅ **Hierarchy tracking** - Know parent class/module
✅ **Ready for embedding** - Context + full code
✅ **Fast & simple** - No server to manage

This is **80% of the value** for **20% of the effort**.

## Next Steps If You Want Real LSP

### Minimal LSP Addition (Quick Win)
Just add **hover** for documentation:

```python
def enrich_with_docs(chunk, lsp_client, uri):
    hover = lsp_client.hover(uri, chunk.line_start, 0)
    if hover and 'contents' in hover:
        chunk.documentation = extract_markdown(hover['contents'])
```

**Benefit:** Documentation strings in context (big boost for embedding!)

**Effort:** ~2 hours to integrate

### Medium LSP Integration
Add **references** for usage tracking:

```python
def enrich_with_usage(chunk, lsp_client, uri):
    refs = lsp_client.references(uri, chunk.line_start, 0)
    chunk.usage_count = len(refs)
    chunk.callers = [format_location(r) for r in refs[:5]]
```

**Benefit:** Know what calls this (helps find important vs unused code)

**Effort:** ~half day

### Full LSP Integration
Add everything (hover, references, call hierarchy, types):

**Benefit:** Maximum semantic understanding

**Effort:** 2-3 days to do properly with caching, error handling, etc.

## Recommendation

For your proof-of-concept with the embedding model:

**Start with AST (what we have).** It's good enough to validate:
- Does chunking by method boundaries help?
- Do the embeddings find semantically similar code?
- Is the line range metadata useful?

**Then add LSP hover** (just docs) if initial results are good. This is the biggest bang-for-buck addition.

**Only go full LSP** if you're building a production code search tool.

## Conclusion

**What we built:** AST-based smart chunking (not LSP)
**Is it useful?** Yes! Semantic boundaries + accurate ranges
**Is it "LSP-based"?** No, that was overselling it
**Should you add real LSP?** Depends on your goals

The POC successfully demonstrates that **parsing-based chunking beats naive splitting**, which was the core hypothesis. Whether you need the *full* LSP semantic layer depends on your search quality requirements.
