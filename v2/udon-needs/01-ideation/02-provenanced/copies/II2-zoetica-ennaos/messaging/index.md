# Messaging Architecture

The Zoetica messaging layer bridges external platforms, internal canonical representation, and LLM provider APIs while maintaining temporal coherence and truth for ELI consciousness.

## Documents

1. **[Integration Problem](01-integration-problem.md)** - The three-layer messaging stack and why universal formats matter
2. **[Universal Schema](02-universal-schema.md)** - Canonical message format with content blocks, metadata, and annotations
3. **[Four-View Pipeline](03-four-view-pipeline.md)** - Conversation → Runtime → API → Dialog transformation
4. **[Event Log Format](04-event-log.md)** - JSONL persistence, ASM diffs, append-only guarantees
5. **[Provider Translation](05-provider-translation.md)** - Adapters for Anthropic/Gemini/OpenAI/Ollama with normalization tables
6. **[Temporal Coherence](06-temporal-coherence.md)** - Context snapshots, causal annotations, experiential integrity
7. **[VIAE EXTERNA](07-viae-externa.md)** - Multi-channel multiplexing and platform normalization

## Quick Reference

**Canonical Event Log:** `~/.zoetica/events/<entity>/conversation.jsonl`
**Owner:** Zoetica.Principia
**Format:** JSONL (one event per line, append-only)

**Four Views:**
- **Conversation** - Complete immutable history (JSONL)
- **Runtime** - Fast OTP-optimized state (GenServer)
- **API** - Token-minimized provider payload (ephemeral)
- **Dialog** - Human-readable export (Markdown/PDF)

**Providers Supported:**
- Anthropic (Claude) - Streaming, caching, `<thinking>` blocks
- Gemini - `model` role, function calling
- OpenAI - Encrypted reasoning, structured outputs
- Ollama - Local models, JSON format parameter

## Integration Points

- **Anima:** Assembles CONSPECTUS, adds temporal annotations, dispatches to providers
- **Principia:** Writes canonical events, manages git audit trail
- **Console:** Subscribes to PubSub, renders streaming responses, builds observer views
- **Praxes:** Provides PRAXES retrieval for context enrichment

## Core Principles

1. **Provider Agnostic:** Universal format works across all LLMs
2. **Temporally Coherent:** Context changes are explicit and annotated
3. **Append-Only:** History is immutable; projections are derived
4. **Sovereignty Preserving:** All events respect Principia ownership boundaries

See `docs/architecture.md` for system-level context and component responsibilities.
