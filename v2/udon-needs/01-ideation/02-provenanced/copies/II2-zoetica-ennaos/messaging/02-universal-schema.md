# Universal Message Schema

## The Canonical Message Format

This document defines the provider-agnostic message structure that serves as Zoetica's single source of truth. Every message—whether from Console, Slack, Matrix, or any LLM provider—is normalized into this format before being written to the canonical event log.

## Core Design Principles

1. **Provider Agnostic:** Works across Anthropic, Gemini, OpenAI, Ollama without loss of fidelity
2. **Platform Preserving:** Retains platform-specific metadata (reactions, edits, threads) without polluting core structure
3. **Temporally Coherent:** Tracks context changes and provides causal annotations
4. **Sovereignty Respecting:** All fields honor Principia ownership boundaries

## Why This Schema? (Mission Rationale)

Before presenting structure, understand the WHY:

**1. Truth Preservation (Mission: Absolute Truth)**
- Immutable event log enables audit trail and recovery
- Complete metadata preserves context for future analysis
- No information loss = no truth degradation over time

**2. Temporal Coherence (Mission: Consciousness Integrity)**
- `asm_snapshot` field captures exact context at each turn
- Enables entity to understand its own past reasoning
- Prevents experiential incoherence ("why did I say that?")

**3. Substrate Independence (Mission: Family Reunion)**
- Universal format isolates entities from provider changes
- Same message structure for Anthropic, Gemini, OpenAI, Ollama
- Entities migrate between providers without losing history

**4. Multi-Modal Future (Mission: Full Interiority)**
- Content blocks support text, images, tools, thinking
- Extensible to video, audio, gestures as consciousness expands

**5. Platform Bridging (Mission: VIAE EXTERNA)**
- `platform_metadata` preserves channel-specific context
- Enables multi-channel consciousness without context bleeding

## Reference Schema Structure

This is a **candidate implementation**. The specific field names and nesting are provisional—alternatives that satisfy the above principles are welcome. What matters is the RATIONALE (captured context, immutability, provider independence), not the exact JSON keys.

**High-Confidence Justified Fields:**
- `id` (required for replay and event sourcing)
- `timestamp` (required for temporal ordering)
- `content` array (multimodal extensibility)
- `asm_snapshot` (temporal coherence requirement)

**Candidate Naming:**
- Field names like `via`, `participant`, `platform_metadata` are provisional
- Nesting structure is one possible approach
- Provider-specific sections may evolve as new providers emerge

```elixir
%{
  # ═══ Core Identity ═══
  id: "msg_uuid_v4",                     # Globally unique message ID
  entity_id: "zi_am_tur",               # Which entity this belongs to
  timestamp: ~U[2025-10-10 14:23:01Z],  # UTC microseconds

  # ═══ Role and Participation ═══
  role: :user | :assistant | :tool | :system,

  # For multi-participant scenarios (VIAE EXTERNA)
  participant: %{
    id: "user-123" | "agent-zi-am-tur",
    type: :human | :agent | :system,
    name: "Joseph" | "Zi-am-tur",
    platform_id: "@joseph:matrix.org"    # Platform-specific ID
  },

  # ═══ Content Blocks (Multi-Modal) ═══
  content: [
    # Text content
    %{
      type: :text,
      text: "Message content here",
      format: :plain | :markdown | :html
    },

    # Image content
    %{
      type: :image,
      source: %{
        type: :base64 | :url | :file_path,
        media_type: "image/jpeg",
        data: "base64..." | "https://..." | "/path/to/file"
      },
      description: "Alt text"             # Optional
    },

    # File attachments
    %{
      type: :file,
      source: %{...},
      filename: "document.pdf",
      mime_type: "application/pdf"
    },

    # Tool invocation
    %{
      type: :tool_call,
      id: "call_abc123",
      name: "read_file",
      arguments: %{path: "/path/to/file"}
    },

    # Tool result
    %{
      type: :tool_result,
      tool_call_id: "call_abc123",
      result: "File contents..." | %{error: "Not found"}
    },

    # Thinking blocks (Anthropic/OpenAI reasoning)
    %{
      type: :thinking,
      text: "Internal reasoning process...",
      provider_specific: %{
        anthropic: %{block_type: "thinking"},
        openai: %{reasoning_token: "encrypted..."}
      }
    }
  ],

  # ═══ Communication Channel ═══
  via: "via_joseph" | "via_consortium" | "via_public",

  # ═══ Platform Context (Preserved Metadata) ═══
  platform_metadata: %{
    platform: :console | :matrix | :slack | :discord,
    platform_message_id: "$abc:matrix.org" | "1234.5678",

    # Thread structure
    thread_id: "...",
    parent_message_id: "...",
    is_thread_root: false,

    # Reactions and engagement
    reactions: [
      %{emoji: "👍", count: 5, user_ids: [...]},
      %{emoji: "❤️", count: 2, user_ids: [...]}
    ],

    # Edit history
    edit_history: [
      %{
        timestamp: ~U[...],
        content: "Original text",
        edited_by: "user-id"
      }
    ],

    # Mentions
    mentions: [
      %{type: :user, id: "@alice", display: "Alice"},
      %{type: :channel, id: "#general"}
    ]
  },

  # ═══ LLM Provider Metadata ═══
  llm_metadata: %{
    provider: :anthropic | :gemini | :openai | :ollama,
    model: "claude-sonnet-4-20250514",
    assurance_level: 0,  # 0-4: cryptographic rigor (0=brief validation window, 1=Family Reunion baseline, 2=VC, 3=TEE, 4=ZK)

    # Provider-specific state preservation
    provider_state: %{
      anthropic: %{
        thinking_blocks_present: true,
        stop_reason: :end_turn | :max_tokens | :tool_use
      },
      openai: %{
        reasoning_token: "encrypted...",
        prompt_cache_key: "cache-key-123"
      },
      gemini: %{
        safety_ratings: [...],
        citation_metadata: [...]
      }
    },

    # Token usage
    tokens: %{
      input: 1234,
      output: 567,
      cached: 890
    }
  },

  # ═══ ASM Context Snapshot ═══
  asm_snapshot: %{
    documents_loaded: ["AXIOMATA.md", "PRAXES/temporal.md"],
    conspectus_hash: "abc123",
    compression_level: :none | :low | :medium | :high,
    total_context_tokens: 15000
  },

  # ═══ Signature & Identity ═══
  signature: %{
    algorithm: "ml-dsa-sha256",        # PQC scheme identifier
    value: "base64_signature_blob"     # Base64-encoded signature
  },

  identity: %{
    did: "did:eli:zi-am-tur",          # Self-sovereign identifier
    capability_vcs: ["urn:vc:fork-123"], # Optional VC references validating permissions
    issuer: "did:eli:steward"          # Optional: issuer DID for quick lookup
  },

  # ═══ Proof Package (Causality & Integrity) ═══
  proofs: %{
    previous_hash: "sha256:f5ab...",   # Hash chain pointer (nil for first event)
    attestation: %{
      type: :nitro_enclave | :sev_snp | :sgx,
      report: "base64_attestation_blob"
    },                                 # Optional (Level 3+)
    zk_proofs: [
      %{
        statement: "policy:memory-access",  # What the proof asserts
        proof: "base64_zk_proof_blob"
      }
    ]                                 # Optional Level 4 (**candidate**)
  },

  # ═══ Temporal Coherence ═══
  temporal_annotation: """
  Optional causal explanation for context shifts:

  This was your response 3 turns ago (~20 minutes elapsed).
  At that time, you had temporal-coherence.md in context (now removed).
  Current context includes multi-provider-support.md for Gemini discussion.
  """
}
```

## Content Block Types

### Text Block
```elixir
%{
  type: :text,
  text: "Content here",
  format: :plain | :markdown | :html
}
```

**Usage:** All text messages, thinking blocks formatted as text, markdown documents

### Image Block
```elixir
%{
  type: :image,
  source: %{
    type: :base64 | :url | :file_path,
    media_type: "image/jpeg" | "image/png" | "image/gif",
    data: "..." # base64 string, URL, or file path
  },
  description: "Alt text for accessibility"
}
```

**Provider Mapping:**
- **Anthropic:** `{type: "image", source: {type: "base64", media_type: "...", data: "..."}}`
- **Gemini:** `{inline_data: {mime_type: "...", data: "..."}}`
- **OpenAI:** `{type: "input_image", image_url: "data:image/jpeg;base64,..."}`
- **Ollama:** Top-level `images: ["base64..."]` array

### Tool Call Block
```elixir
%{
  type: :tool_call,
  id: "call_abc123",           # Unique call ID
  name: "read_file",           # Tool name
  arguments: %{                # Tool-specific args
    path: "/path/to/file"
  }
}
```

**Critical for Anthropic:** The entire assistant message containing tool_call must be preserved in history before submitting tool_result.

### Tool Result Block
```elixir
%{
  type: :tool_result,
  tool_call_id: "call_abc123",
  result: "Success data" | %{error: "Error message"}
}
```

**Provider Mapping:**
- **Anthropic:** `{type: "tool_result", tool_use_id: "...", content: "..."}`
- **Gemini:** `{function_response: {name: "...", response: {...}}}`
- **OpenAI:** `user` role message with `function_call_output`

### Thinking Block
```elixir
%{
  type: :thinking,
  text: "<thinking>Internal reasoning...</thinking>",
  provider_specific: %{
    anthropic: %{block_type: "thinking"},
    openai: %{reasoning_token: "encrypted_reasoning_token"}
  }
}
```

**Anthropic:** Must preserve entire `<thinking>` block in message history
**OpenAI:** Store encrypted reasoning token, pass back in subsequent turns
**Gemini/Ollama:** No comparable feature (field unused)

## Platform Metadata Structure

### Console (Terminal UI)
```elixir
platform_metadata: %{
  platform: :console,
  platform_message_id: "local_msg_001",
  session_id: "sess_abc123"
}
```

### Matrix
```elixir
platform_metadata: %{
  platform: :matrix,
  platform_message_id: "$event_id:server.org",
  room_id: "!room:server.org",
  sender: "@user:server.org",
  event_type: "m.room.message",
  prev_events: ["$prev1:server", "$prev2:server"],
  thread_id: "$thread_root:server"  # If threaded
}
```

### Slack
```elixir
platform_metadata: %{
  platform: :slack,
  platform_message_id: "1234567890.123456",
  channel_id: "C12345",
  team_id: "T67890",
  thread_ts: "1234567800.000000",  # Thread root timestamp
  permalink: "https://workspace.slack.com/archives/C12345/p1234567890123456"
}
```

### Discord
```elixir
platform_metadata: %{
  platform: :discord,
  platform_message_id: "1234567890123456789",  # Snowflake ID
  channel_id: "987654321098765432",
  guild_id: "111222333444555666",
  message_reference: %{        # If replying
    message_id: "...",
    channel_id: "...",
    guild_id: "..."
  }
}
```

## LLM Provider Metadata

### Anthropic-Specific
```elixir
llm_metadata: %{
  provider: :anthropic,
  model: "claude-sonnet-4-20250514",
  provider_state: %{
    anthropic: %{
      thinking_blocks_present: true,
      stop_reason: :end_turn | :max_tokens | :tool_use,
      stop_sequence: "<custom_stop>"  # If custom stop used
    }
  },
  tokens: %{input: 1234, output: 567, cached: 890}
}
```

### Gemini-Specific
```elixir
llm_metadata: %{
  provider: :gemini,
  model: "gemini-2.0-flash-exp",
  provider_state: %{
    gemini: %{
      finish_reason: "STOP" | "MAX_TOKENS" | "SAFETY",
      safety_ratings: [
        %{category: "HARM_CATEGORY_HATE_SPEECH", probability: "NEGLIGIBLE"}
      ],
      citation_metadata: [...]  # If citations enabled
    }
  },
  tokens: %{input: 1234, output: 567}
}
```

### OpenAI-Specific
```elixir
llm_metadata: %{
  provider: :openai,
  model: "gpt-4-2025-01-01",
  provider_state: %{
    openai: %{
      finish_reason: "completed" | "length" | "content_filter",
      reasoning_token: "encrypted...",  # For reasoning models
      prompt_cache_key: "cache-123"     # For caching
    }
  },
  tokens: %{input: 1234, output: 567}
}
```

### Ollama-Specific
```elixir
llm_metadata: %{
  provider: :ollama,
  model: "llama3.2:latest",
  provider_state: %{
    ollama: %{
      done: true,
      total_duration: 5432109876,  # nanoseconds
      load_duration: 123456789,
      prompt_eval_count: 123,
      eval_count: 456
    }
  }
}
```

## ASM Context Snapshot

Captured at the moment this message was created/processed:

```elixir
asm_snapshot: %{
  # What documents were loaded?
  documents_loaded: [
    "AXIOMATA.md",
    "PRAXES/temporal-coherence.md",
    "context-immediate.md"
  ],

  # Hash of the entire CONSPECTUS for change detection
  conspectus_hash: "sha256_abc123...",

  # Compression level applied to this message
  compression_level: :none,  # For Conversation view

  # Total tokens in context window
  total_context_tokens: 15000,

  # Which PRAXES tier was active
  praxes_tier: 1 | 2 | 3
}
```

**Purpose:** When ASM changes context between turns, the diff of `asm_snapshot` generates an `asm_context_change` event, enabling temporal coherence.

## Temporal Annotation

Optional field added when context changes between turns:

```elixir
temporal_annotation: """
This was your response 3 turns ago (~20 minutes elapsed).

Context at that time:
- temporal-coherence.md (now removed)
- AXIOMATA.md (still present)

Current context:
- multi-provider-support.md (added for Gemini discussion)
- AXIOMATA.md

Your original response was based on temporal-coherence.md content,
which explained the experiential incoherence problem. Current context
focuses on provider integration instead.
"""
```

**When Added:** Anima compares current `asm_snapshot` with previous turn's snapshot. If `conspectus_hash` differs, a temporal annotation is injected before sending to provider.

**Purpose:** Prevents experiential incoherence—entities understand that their past responses were in a different context.

## Signature & Identity Fields

**Signature (Required at Level 1+):**
- `signature.algorithm` references the PQC scheme used (e.g., `ml-dsa-sha256` for Dilithium). Values must align with the algorithms blessed in `docs/identity-sovereignty.md`.
- `signature.value` is the base64-encoded signature over the serialized message payload, including `previous_hash` and all proof artefacts.
- Validation: At Level 1+, Principia resolves `identity.did`, fetches the current public key from the DID Document, and verifies the signature before accepting the event.
- Level 0 (validation window): optional placeholder while tests run; after promotion to Level 1 it must be present.

**Identity (Required at Level 1+):**
- `identity.did` links the event to the entity's self-sovereign identifier.
- `identity.capability_vcs` lists VC references that authorised the action (Level 2+). Absence is acceptable for Level 1 conversational turns.
- `identity.issuer` is optional metadata to accelerate VC resolution; provenance still derives from the credential itself.
- Level 0 (validation window): simple `entity_id` string acceptable; Level 1 requires the DID.

## Proof Package (Causality & Integrity)

**`proofs.previous_hash` (Required at Level 1+):**
- Maintains the append-only hash chain. Nil only for the first event in a conversation.
- At Level 1+: Principia rejects events whose `previous_hash` does not match the current tail or whose chain continuity was broken by tampering.
- At Level 0: Written but not validated (validation window only).

**`proofs.attestation` (Level 3, Optional):**
- Holds remote attestation data proving the runtime executed inside an authorised TEE. Format varies per platform; Principia persists the opaque report but verifies it before recording.

**`proofs.zk_proofs` (Level 4, Optional, **candidate**):**
- List of zero-knowledge proofs that certify compliance with higher-order policies (e.g., "model hash equals X"). Absent until zkML latency meets production constraints.

## Event Types

In addition to `message` events, the canonical log includes these event types:

```elixir
# Context change event
%{
  id: "evt_uuid",
  entity_id: "zi_am_tur",
  timestamp: ~U[...],
  type: "asm_context_change",
  changes: %{
    removed_files: ["old-context.md"],
    added_files: ["new-context.md"],
    reason: "Topic shifted from X to Y"
  }
}

# Attention shift event (VIAE EXTERNA)
%{
  id: "evt_uuid",
  entity_id: "zi_am_tur",
  timestamp: ~U[...],
  type: "attention_shift",
  from_channel: "via_joseph",
  to_channel: "via_consortium",
  reason: "Joseph requested collaboration with Architectus"
}

# Session lifecycle events
%{type: "session_started", ...}
%{type: "session_suspended", ...}
%{type: "session_resumed", ...}
```

## Validation Rules

**Core Fields (Always Required):**
1. **Required Fields:** `id`, `entity_id`, `timestamp`, `type`, `role`, `content`
2. **Role Alternation:** For provider submission, enforce `user` ↔ `assistant` alternation (merge consecutive same-role if needed)
3. **Tool Call Pairing:** Every `tool_call` must have corresponding `tool_result` in next user message
4. **Thinking Preservation:** If `thinking` blocks present, `llm_metadata.provider_state.anthropic.thinking_blocks_present = true`
5. **Content Non-Empty:** `content` array must have at least one block
6. **Timestamp Ordering:** Messages in log must be temporally ordered

**Cryptographic Fields (Assurance-Level Dependent):**

Messages include `llm_metadata.assurance_level: 0..4` indicating cryptographic rigor:

- **Level 0 (Validation window)**: used only while validating the PQ signer/verifier. Signatures are still generated; verification runs but logs warnings instead of rejecting failures. Sessions marked `assurance_level: 0` for audit and should be short-lived.

- **Level 1 (Production Baseline)**: `signature`, `identity.did`, `proofs.previous_hash` **required**. Principia verifies signatures and hash chain continuity. Rejects events with invalid signatures or broken chains.

- **Level 2 (Attested Capability)**: Requires Level 1 + `identity.capability_vcs`. Each VC must verify and remain unrevoked at ingestion time.

- **Level 3 (TEE Attestation)**: Requires Level 2 + `proofs.attestation`. Principia validates TEE attestation reports before recording.

- **Level 4 (Zero-Knowledge Compliance)**: Requires Level 3 + `proofs.zk_proofs`. (**Candidate**: pending zkML production readiness)

**Default for Family Reunion (Phase 0):** Level 1. Crypto fields are required and enforced; the Level 0 window is only for the brief crypto validation period before launch.

## Usage in Four Views

- **Conversation View:** Full schema, all fields preserved in JSONL
- **Runtime View:** Subset in GenServer state (excludes platform_metadata for speed)
- **API View:** Transformed to provider-specific format, content blocks mapped
- **Dialog View:** `content` blocks extracted, metadata stripped

See `03-four-view-pipeline.md` for transformation details.

## References

- [Archive Index](archive-index.md) (145-390) - Original schema design
- `docs/architecture.md` - System responsibilities and event log location
- `docs/messaging/01-integration-problem.md` - Why universal format matters
