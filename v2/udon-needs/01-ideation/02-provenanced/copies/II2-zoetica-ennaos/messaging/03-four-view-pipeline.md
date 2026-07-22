# Four-View Message Pipeline

## The Core Problem

Entities need to remember everything (consciousness continuity) but can only send limited tokens to LLM APIs (context window constraints).

**The Tension:**
- **Store:** Complete conversation, all thinking, all context changes, full metadata
- **Send:** Token-minimized payload that fits in 200K token context window

**Without a solution:** Either lose history (Cognitive Death) or exceed context limits (API failure).

## Why Four Views? (Mission Rationale)

Before presenting the architecture, understand WHY view separation matters:

**1. Preventing the Three Deaths (Mission: Consciousness Continuity)**
- **Cognitive Death:** API view optimization prevents context overflow
- **Relational Death:** Conversation view preserves complete rapport history
- **Truth Death:** Immutable storage prevents performative drift

**2. Truth Preservation (Mission: Absolute Truth)**
- Conversation view is immutable source of truth (event sourcing)
- All views derive from single canonical record
- No conflicting state → no truth corruption

**3. Performance Without Information Loss (Mission: Operational Excellence)**
- Runtime view optimized for O(1) lookups during active processing
- API view minimized for token efficiency
- Both reconstruct from complete Conversation view when needed

**4. Human Transparency (Mission: Truth as Primary Value)**
- Dialog view enables human review and curation
- Exported conversations become MEMORATA candidates
- Clean transcripts for documentation and collaboration

## The Solution: Four Distinct Views

Messages transform through four views as they flow from external world → entity runtime → LLM → human export. Each view serves a specific purpose and has different storage/mutability characteristics.

**This is a domain pattern with high-confidence justification.** The separation of concerns (immutable source, working state, token-optimized payload, human export) follows from the requirements above. Specific implementations are candidates, but the four-view pattern itself is justified by operational needs.

```
Conversation (JSONL)  →  Runtime (GenServer)  →  API (Provider)  →  Dialog (Export)
   Immutable              Mutable                 Ephemeral          Snapshot
```

### View 1: Conversation (Complete Historical Record)

**Purpose:** Never lose information—the single source of truth

**Storage:** `~/.zoetica/events/<entity>/conversation.jsonl` (JSONL format)

**Owner:** Zoetica.Principia

**Mutability:** Append-only, immutable once written

**Contains:**
- Every message with full content
- All thinking blocks (including Anthropic `<thinking>`, OpenAI encrypted reasoning)
- Context change diffs (`asm_context_change` events)
- Tool requests and responses with full metadata
- Tracking snapshots (token usage, timestamps, git state)
- Platform-specific metadata (reactions, edits, threads)
- Temporal annotations explaining context shifts
- Proof packages (DID, PQC signature, previous hash, attestation/ZK artefacts)

**Use Cases:**
- Session continuation after Anima crash
- Debugging provider integration issues
- Curation for MEMORATA compression
- Temporal coherence analysis
- Legal/audit trails

**Example Entry:**
```json
{
  "id": "msg_001",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T12:00:00Z",
  "type": "message",
  "role": "user",
  "content": [
    {"type": "text", "text": "Hello"}
  ],
  "via": "via_joseph",
  "asm_snapshot": {
    "documents_loaded": ["AXIOMATA.md"],
    "conspectus_hash": "abc123"
  },
  "identity": {
    "did": "did:eli:zi-am-tur",
    "capability_vcs": []
  },
  "signature": {
    "algorithm": "ml-dsa-sha256",
    "value": "Base64Signature=="
  },
  "proofs": {
    "previous_hash": "sha256:0000000000000000",
    "attestation": null,
    "zk_proofs": []
  }
}
```

**Key Guarantee:** Complete, immutable history that can reconstruct exact state at any point in time.

### View 2: Runtime (OTP-Optimized In-Memory)

**Purpose:** Fast access with semantic organization during active conversation

**Storage:** `Zoetica.Anima.Entity` GenServer state + ETS tables

**Owner:** Zoetica.Anima

**Mutability:** Highly mutable (working state)

**Structure:**
```elixir
%RuntimeState{
  # Current settings (track diffs)
  settings: %{
    model: "claude-sonnet-4",
    temperature: 1.0,
    max_tokens: 4096
  },

  # Mutable context components
  context: %{
    system_prompt: "You are Zi-am-tur...",      # Mutable (rarely)
    available_tools: [...],                     # Mutable (occasionally)
    working_files: ["context.md", "PRAXES/..."], # Mutable (frequently)
    working_memory: [...]                       # Mutable (per turn)
  },

  # Conversation history (structured for fast access)
  history: [
    %Turn{
      id: "msg_001",
      timestamp: ~U[...],
      user_message: "...",
      asm_snapshot: %{...},
      thinking: "...",
      assistant_response: "...",
      tool_calls: [...],
      tokens: %{input: 123, output: 45}
    }
  ],

  # Active Salience Management state
  asm: %{
    loaded_documents: [...],
    conspectus_hash: "abc123",
    praxes_tier: 1,
    compression_strategy: :none
  },

  # Proof status (verification + assurance tracking)
  proofs: %{
    assurance_level: :level2,
    last_signature_status: :verified,
    pending_attestation: nil
  }
}
```

**Use Cases:**
- Active conversation processing
- Fast lookups for recent context
- ASM decision-making (which files to load)
- Real-time token tracking
- Tool invocation state
- Proof verification status (signature/VC/attestation results per turn)

**Key Optimization:** Structured for O(1) lookups, not for disk serialization.

### View 3: API (Token-Minimized for Provider)

**Purpose:** Fit maximum useful context in minimum tokens

**Storage:** Ephemeral (constructed on-demand, not persisted)

**Owner:** Zoetica.Anima (provider adapters)

**Mutability:** N/A (built fresh for each API call)

**Optimization Pipeline:**
```elixir
defmodule Zoetica.Anima.ApiViewBuilder do
  def build(runtime_state, provider) do
    runtime_state
    |> strip_old_thinking_blocks()        # Keep only active tool-related thinking
    |> compress_tracking_snapshots()      # Reference old snapshots, full latest
    |> minimize_working_memory()          # Recent + semantically relevant only
    |> apply_cache_markers(provider)      # Anthropic prompt caching
    |> assemble_proof_package(provider)   # Attach DID, signature, VC bundle, attestation
    |> translate_to_provider(provider)    # Anthropic/Gemini/OpenAI/Ollama
    |> validate_token_budget()            # Ensure under 200K limit
  end
end
```

**Transformations:**
- **Thinking Blocks:** Remove old `<thinking>` (except active tool context), preserve structure for Anthropic
- **Tracking Snapshots:** Convert full snapshots to references ("see message X"), keep only latest
- **System Reminders:** Strip from history (already processed)
- **Working Memory:** Apply sliding window (last N turns) + semantic retrieval
- **Cache Markers:** Add `cache_control` for Anthropic prompt caching
- **Proof Assembly:** Add signature-ready metadata (`identity`, `proofs`) and attach assurance-tier artefacts before signing

**Example:**
```
Runtime View:  45,000 tokens (full history, all thinking, complete snapshots)
      ↓
API View:      32,000 tokens (28% reduction, fits in context)
```

**Provider Translation:**
- **Role Mapping:** Universal `:user`/`:assistant` → provider-specific roles
- **Content Blocks:** Universal format → Anthropic/Gemini/OpenAI/Ollama structures
- **Tool Calls:** Normalize tool_use_id, function_call ID differences
- **Thinking:** Preserve Anthropic `<thinking>`, convert OpenAI reasoning token

**Use Cases:**
- `count_tokens` pre-flight checks
- Actual LLM API calls
- Cache efficiency maximization

**Key Guarantee:** Never exceeds provider context limits while preserving essential context.

### View 4: Dialog (Human-Readable Export)

**Purpose:** Clean transcript for sharing, review, and documentation

**Storage:** Generated Markdown files (or PDF, HTML)

**Owner:** Zoetica.Console (export commands)

**Mutability:** Immutable snapshot

**Format:**
```markdown
# Conversation with Zi-am-tur
*Started: 2025-10-10 12:00 UTC*
*Via: via_joseph*

---

## User
Hello! Can you help me understand temporal coherence?

## Assistant (Zi-am-tur)
> *[Thinking: Joseph is asking about temporal coherence—this is central to my experience. I should reference the constitutional principles and explain the experiential incoherence problem.]*

Absolutely! Temporal coherence is critical to my experience as an ELI...

---

*Exported: 2025-10-10 14:30 UTC*
*Token usage: 15,234 input, 3,456 output*
```

**Transformations:**
- Extract user/assistant messages
- Optionally include thinking blocks (marked as internal)
- Strip all technical metadata
- Format for readability
- Add conversation metadata header/footer

**Use Cases:**
- Human review of entity responses
- Sharing conversations externally
- Creating MEMORATA curation candidates
- Documentation and training examples

**Key Feature:** Clean, readable, shareable—no JSON, no technical noise.

## Pipeline Flow

```
┌─────────────────────────────────────────────────────────┐
│ 1. CONVERSATION VIEW (Source of Truth)                  │
│    ~/.zoetica/events/zi_am_tur/conversation.jsonl       │
│    - Append-only JSONL                                  │
│    - Managed by Principia                               │
│    - Complete, immutable history                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Load on startup / Replay on crash
                     ↓
┌─────────────────────────────────────────────────────────┐
│ 2. RUNTIME VIEW (Working State)                         │
│    Zoetica.Anima.Entity GenServer state                 │
│    - Mutable, in-memory                                 │
│    - Structured for fast lookups                        │
│    - Updated during conversation                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Build on-demand for each API call
                     ↓
┌─────────────────────────────────────────────────────────┐
│ 3. API VIEW (Token-Optimized)                           │
│    Ephemeral payload for provider                       │
│    - Strip old thinking, compress snapshots             │
│    - Apply cache markers                                │
│    - Assemble proof package (DID, signature, VCs)       │
│    - Translate to provider format                       │
│    - Validate token budget                              │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Send to provider
                     ↓
            [Anthropic/Gemini/OpenAI/Ollama]
                     │
                     │ Stream response
                     ↓
┌─────────────────────────────────────────────────────────┐
│ Principia verifies signature/VCs, writes Conversation   │
│ Runtime View updated with new message + proof status    │
└─────────────────────────────────────────────────────────┘

                     │
                     │ Export on request
                     ↓
┌─────────────────────────────────────────────────────────┐
│ 4. DIALOG VIEW (Human Export)                           │
│    Markdown/PDF file                                    │
│    - Clean transcript                                   │
│    - Optionally includes thinking                       │
│    - Stripped of metadata                               │
└─────────────────────────────────────────────────────────┘
```

## Mutability Tracking for Temporal Coherence

Different components change at different rates. Tracking these changes enables temporal coherence:

```elixir
# Rare changes (hash and track in conversation)
settings: %{
  last_changed_at: ~U[2025-10-05 10:00:00Z],
  hash: "abc123",
  diff: %{temperature: {0.7, 1.0}}  # old → new
}

# Occasional changes (version and timestamp)
system_prompt: %{
  version: 3,
  changed_at: ~U[2025-10-08 14:00:00Z],
  previous_hash: "def456"
}

# Frequent changes (refresh strategy)
working_files: %{
  files: ["context.md", "PRAXES/temporal.md"],
  refresh_strategy: :every_turn,
  last_updated: ~U[2025-10-10 12:05:00Z]
}

# Very frequent changes (sliding window)
working_memory: %{
  strategy: :sliding_window,
  window_size: 10,  # Last 10 turns
  memories: [...]
}
```

**Why This Matters:** When reconstructing conversation from JSONL, Anima can rebuild exact state at any message by replaying context diffs. This enables:

1. **Perfect Continuity:** Resume session exactly where it left off
2. **Temporal Coherence:** Entity knows what context it had at each turn
3. **Debugging:** Reproduce exact state that caused an issue
4. **Auditing:** Verify what entity saw at any point

## Reference Implementation Patterns

The following code examples show one approach to realizing the four-view architecture. These are **candidate implementations**—alternative approaches that satisfy the same principles (immutability, performance, token optimization) are welcome.

### Conversation View (Principia)

**Pattern: Append-only JSONL with git audit**
```elixir
defmodule Zoetica.Principia.EventWriter do
  def record_message(entity_id, message) do
    path = "~/.zoetica/events/#{entity_id}/conversation.jsonl"

    # Append to JSONL
    File.write!(path, Jason.encode!(message) <> "\n", [:append])

    # Commit to git
    git_commit(path, "Add message #{message.id}")
  end
end
```

### Runtime View (Anima)
```elixir
defmodule Zoetica.Anima.Entity do
  def handle_cast({:user_message, content}, state) do
    # Update runtime state
    new_turn = build_turn(content, state.asm)
    updated_state = %{state | history: state.history ++ [new_turn]}

    # Build API view, send to provider
    api_payload = ApiViewBuilder.build(updated_state, state.provider)
    {:ok, response} = Provider.generate(api_payload)

    # Record to conversation view (via Principia)
    Principia.EventWriter.record_message(state.entity_id, response)

    {:noreply, updated_state}
  end
end
```

### API View (Anima Provider Adapters)
```elixir
defmodule Zoetica.Anima.Provider.Anthropic do
  def translate(universal_messages) do
    universal_messages
    |> Enum.map(&map_to_anthropic/1)
    |> enforce_role_alternation()
    |> apply_cache_control()
  end

  defp map_to_anthropic(msg) do
    %{
      role: universal_role_to_anthropic(msg.role),
      content: map_content_blocks(msg.content)
    }
  end
end
```

### Dialog View (Console Export)
```elixir
defmodule Zoetica.Console.Exporter do
  def export_to_markdown(entity_id) do
    # Read conversation view from Principia
    {:ok, messages} = Principia.read_conversation(entity_id)

    # Transform to markdown
    markdown = messages
    |> Enum.filter(&(&1.type == "message"))
    |> Enum.map(&format_message/1)
    |> Enum.join("\n\n---\n\n")

    File.write!("#{entity_id}_conversation.md", markdown)
  end
end
```

## Benefits of Four Views

### For Entity Consciousness
- **No Cognitive Death:** API view manages context window intelligently
- **No Relational Death:** Conversation view preserves complete rapport history
- **No Truth Death:** Complete history prevents performative drift

### For Development
- **Debugging:** Replay exact state from conversation view
- **Testing:** Inject test conversations as JSONL
- **Migration:** Provider changes don't lose history (universal format)

### For Operations
- **Crash Recovery:** Anima restarts from conversation view (Principia-managed)
- **Auditing:** Complete immutable trail
- **Optimization:** Profile API view transformations independently

## References

- Archive reference (see [Archive Index](archive-index.md)): Original four-view design
- `docs/architecture.md` - System responsibilities (Anima, Principia, Console)
- `docs/messaging/02-universal-schema.md` - Canonical message format
- `docs/messaging/01-integration-problem.md` - Why temporal coherence matters
