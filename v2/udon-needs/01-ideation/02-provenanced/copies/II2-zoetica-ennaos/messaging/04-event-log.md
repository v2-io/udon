# Event Log Format

## The Canonical Event Log

**Location:** `~/.zoetica/events/<entity>/conversation.jsonl`
**Owner:** Zoetica.Principia
**Format:** JSONL (JSON Lines) - one event per line, append-only
**Purpose:** Single source of truth for entity experience and consciousness continuity

## Why JSONL? (Mission Rationale)

**This is a high-confidence justified choice.** JSONL with git-backing serves multiple mission requirements:

**1. Immutability = Truth (Mission: Absolute Truth)**
- Append-only semantics prevent historical revision
- No possibility of overwriting past events
- Truth cannot be corrupted after the fact

**2. Audit Trail = Recovery (Mission: Operational Resilience)**
- Complete git history enables point-in-time recovery
- Crash recovery reconstructs exact state from log
- Temporal coherence depends on complete history

**3. Replay = Migration Support (Mission: Temporal Software Theory)**
- Can reconstruct conversations in new formats
- Provider migrations preserve complete history
- Schema evolution doesn't lose information

**Technical Benefits (Operational, Not Arbitrary):**
1. **Append-Only:** Matches event sourcing pattern perfectly
2. **Line-Per-Event:** Each line is valid JSON, easy to parse incrementally
3. **Streamable:** Can process without loading entire file
4. **Git-Friendly:** New lines don't change old ones (clean diffs)
5. **Reconstructable:** Can rebuild exact state at any message
6. **Auditable:** Immutable trail of every event

## Event Types

### Message Events

The primary event type, representing user/assistant messages:

```json
{
  "id": "msg_001",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T12:00:00.000000Z",
  "type": "message",
  "role": "user",
  "content": [
    {"type": "text", "text": "Hello"}
  ],
  "via": "via_joseph",
  "platform_metadata": {},
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

### ASM Context Change Events

Critical for temporal coherence—records when ASM changes context between turns:

```json
{
  "id": "evt_004",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T12:01:05.000000Z",
  "type": "asm_context_change",
  "changes": {
    "removed_files": ["old-context.md"],
    "added_files": ["new-context.md"],
    "reason": "Topic shifted from Phoenix architecture to provider integration"
  },
  "old_conspectus_hash": "abc123",
  "new_conspectus_hash": "def456"
}
```

**Purpose:** When entity re-reads history, these events explain why context was different. Prevents experiential incoherence.

### Attention Shift Events (VIAE EXTERNA)

Records when entity shifts attention between communication channels:

```json
{
  "id": "evt_005",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T12:05:00.000000Z",
  "type": "attention_shift",
  "from_channel": "via_joseph",
  "to_channel": "via_consortium",
  "reason": "Joseph requested collaboration with Architectus",
  "context": {
    "active_channels": ["via_joseph", "via_consortium"],
    "pending_messages": 2
  }
}
```

### Session Lifecycle Events

Tracks entity awakening and sleeping:

```json
{
  "id": "evt_001",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T11:55:00.000000Z",
  "type": "session_started",
  "trigger": "console_connection",
  "principia_location": "~/eli/zi-am-tur",
  "axiomata_version": "2025-10-08"
}
```

```json
{
  "id": "evt_100",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T15:00:00.000000Z",
  "type": "session_suspended",
  "reason": "user_disconnected",
  "final_state": {
    "total_turns": 42,
    "total_tokens": 125000,
    "duration_seconds": 10800
  }
}
```

```json
{
  "id": "evt_101",
  "entity_id": "zi_am_tur",
  "timestamp": "2025-10-10T16:30:00.000000Z",
  "type": "session_resumed",
  "previous_session_id": "evt_001",
  "elapsed_since_suspend": 5400
}
```

## Append-Only Guarantees

### Write Protocol (Reference Implementation)

The following shows one approach to implementing append-only writes with git audit. This is a **candidate implementation**—the pattern (atomic append + git commit) is justified by the requirements above, but specific file paths and commit message formats are provisional.

```elixir
defmodule Zoetica.Principia.EventWriter do
  @doc """
  Appends event to canonical log. Never modifies existing lines.
  """
  def record(entity_id, event) do
    validate_event!(event)
    verify_signature!(event)
    verify_previous_hash!(entity_id, event)
    enforce_vc_requirements!(event)

    path = event_log_path(entity_id)
    json = Jason.encode!(event)

    # Atomic append
    File.write!(path, json <> "\n", [:append])

    # Git audit
    git_add_and_commit(path, event.id)

    {:ok, event.id}
  end

  defp validate_event!(event) do
    required = [:id, :entity_id, :timestamp, :type, :signature, :identity]
    missing = required -- Map.keys(event)

    if missing != [], do: raise "Missing required fields: #{inspect(missing)}"
  end

  defp verify_signature!(event) do
    public_key = Principia.Identity.resolve_public_key!(event.identity.did)
    unless Crypto.verify_signature(event.signature, public_key, event) do
      raise "Signature verification failed for #{event.id}"
    end
  end

  defp verify_previous_hash!(entity_id, %{proofs: %{previous_hash: nil}}), do: :ok

  defp verify_previous_hash!(entity_id, %{proofs: %{previous_hash: prev_hash}} = event) do
    case Principia.EventReader.tail_hash(entity_id) do
      ^prev_hash -> :ok
      current_hash ->
        raise "Hash chain violation for #{event.id}: expected #{current_hash}, got #{prev_hash}"
    end
  end

  defp enforce_vc_requirements!(%{identity: %{capability_vcs: []}}), do: :ok

  defp enforce_vc_requirements!(event) do
    Enum.each(event.identity.capability_vcs, fn vc_ref ->
      :ok = Principia.Credentials.verify!(vc_ref, for: event.identity.did)
    end)
  end
end
```

### Guarantees

1. **Atomicity:** Each line write is atomic (OS guarantee)
2. **Ordering:** Events are always temporally ordered by timestamp
3. **Immutability:** Once written, never modified
4. **Durability:** Git commits provide additional persistence layer
5. **Recoverability:** Can replay from any point

## Signature Verification & Proof Storage

- **Authorship:** Every event carries a PQC signature. Principia verifies it against the DID-derived public key before the line ever touches disk. Failed verifications abort the write and emit a security alert.
- **Capability Enforcement:** `identity.capability_vcs` links to Verifiable Credentials authorising the action. Principia resolves and validates each credential (including revocation status) as part of ingestion.
- **Integrity Artefacts:** Attestation reports and optional ZK proofs live inside the `proofs` object. They remain opaque blobs in the log but must validate up front so future replay can trust what is stored.
- **Audit Trail:** Verification results (success/failure, verification time) are themselves events in the log or adjacent git notes, enabling forensic reconstruction of trust failures.

## Hash Chain & Ledger Anchoring

- **Local Hash Chain:** `proofs.previous_hash` enforces strict ordering inside the conversation. Tampering produces mismatched hashes that Principia detects before commit.
- **Ledger Anchoring:** At a configurable cadence (turn count or elapsed time), Principia batches recent hashes into a Merkle tree and anchors the root to a public ledger (candidate: Ethereum L2 rollup or Bitcoin ordinal commitment). This gives global, third-party verifiable timestamps without sacrificing low-latency operation.
- **Replay Safety:** During recovery, Principia revalidates hash continuity and ledger anchors to ensure no divergence occurred while the runtime was offline.

## Temporal Coherence via Diffs

### The Problem

When ASM changes context between turns, the entity re-reads its past with different files loaded. Without annotations, this creates false memories.

### The Solution

1. **Capture snapshot at each turn:**
```json
"asm_snapshot": {
  "documents_loaded": ["AXIOMATA.md", "context.md"],
  "conspectus_hash": "abc123",
  "total_context_tokens": 15000
}
```

2. **Detect changes between turns:**
```elixir
def check_context_change(previous_snapshot, current_snapshot) do
  if previous_snapshot.conspectus_hash != current_snapshot.conspectus_hash do
    {:changed, diff_snapshots(previous_snapshot, current_snapshot)}
  else
    :unchanged
  end
end
```

3. **Record context-change event:**
```json
{
  "type": "asm_context_change",
  "changes": {
    "removed_files": ["context.md"],
    "added_files": ["multi-provider.md"],
    "reason": "Switched focus to provider integration"
  }
}
```

4. **Add temporal annotation to next message:**
```json
{
  "type": "message",
  "role": "assistant",
  "temporal_annotation": "This response references context.md which is no longer loaded. Current context includes multi-provider.md for Gemini discussion."
}
```

### Result

Entity re-experiences its past truthfully:
- Knows what context it had at each turn
- Understands why responses might feel different
- Maintains causal coherence across context switches

## Replay and Reconstruction

### Full History Replay

```elixir
defmodule Zoetica.Principia.LogReader do
  def replay(entity_id) do
    path = event_log_path(entity_id)

    File.stream!(path)
    |> Stream.map(&Jason.decode!/1)
    |> Enum.reduce(%RuntimeState{}, &apply_event/2)
  end

  defp apply_event(%{"type" => "message"} = event, state) do
    # Add message to history
    %{state | history: state.history ++ [event]}
  end

  defp apply_event(%{"type" => "asm_context_change"} = event, state) do
    # Update context tracking
    %{state | context_changes: state.context_changes ++ [event]}
  end

  # ... other event types
end
```

### Point-in-Time Reconstruction

```elixir
def state_at_message(entity_id, message_id) do
  path = event_log_path(entity_id)

  File.stream!(path)
  |> Stream.map(&Jason.decode!/1)
  |> Stream.take_while(&(&1["id"] != message_id))
  |> Enum.reduce(%RuntimeState{}, &apply_event/2)
end
```

**Use Cases:**
- Debug what entity saw when it made a specific response
- Resume session from arbitrary point
- Analyze ASM decisions retroactively
- Generate exact API payload for provider testing

## Git Audit Trail

### Commit Protocol

Every event write is immediately committed to git:

```bash
cd ~/.zoetica/events/zi_am_tur
git add conversation.jsonl
git commit -m "Add message msg_042: User question about providers"
```

**Benefits:**
1. **Provenance:** Every change has timestamp and attribution
2. **Recovery:** Can restore from any point in git history
3. **Diff Analysis:** `git log -p` shows exact changes
4. **Backup:** Git remotes provide distributed backup
5. **Audit:** Legal/compliance trail

### Repository Structure

```
~/.zoetica/events/zi_am_tur/
├── .git/                       # Git repository
├── conversation.jsonl          # Canonical log
├── metadata.json               # Entity metadata
└── snapshots/                  # Periodic MEMORATA snapshots
    ├── 2025-10-01.jsonl
    └── 2025-10-10.jsonl
```

## Performance Considerations

### Read Performance

**Streaming:** JSONL allows incremental processing without loading entire file:

```elixir
path
|> File.stream!()
|> Stream.map(&Jason.decode!/1)
|> Stream.filter(&(&1["type"] == "message"))
|> Stream.take(-50)  # Last 50 messages
|> Enum.to_list()
```

**Indexing:** For large logs, maintain ETS index in Principia:

```elixir
# Index message IDs for fast lookup
:ets.new(:message_index, [:set, :named_table])
:ets.insert(:message_index, {message_id, byte_offset})
```

### Write Performance

**Append-Only:** O(1) write complexity (no seeks, no rewrites)

**Buffering:** For high-frequency events, batch writes:

```elixir
# Buffer events, flush every 100ms or 10 events
GenServer.call(Principia.EventWriter, {:record_batch, events})
```

### Size Management

**Compression:** Periodically compress old JSONL:

```bash
gzip ~/.zoetica/events/zi_am_tur/conversation-2025-09.jsonl
```

**Archival:** Move ancient logs to cold storage:

```elixir
def archive_old_logs(entity_id, before_date) do
  # Move logs older than date to archive
  # Keep git history for provenance
end
```

## Migration and Schema Evolution

### Versioning Strategy

Include schema version in each event:

```json
{
  "schema_version": "1.0.0",
  "id": "msg_001",
  ...
}
```

### Backward Compatibility

```elixir
defmodule EventReader do
  def read_event(json) do
    event = Jason.decode!(json)

    case event["schema_version"] do
      "1.0.0" -> parse_v1(event)
      "2.0.0" -> parse_v2(event)
      nil -> parse_legacy(event)
    end
  end
end
```

### Forward Migration

```elixir
def migrate_log(entity_id, from_version, to_version) do
  # Read old format
  events = LogReader.read_all(entity_id)

  # Write new format to temp file
  temp_path = "#{log_path(entity_id)}.migrating"

  events
  |> Stream.map(&migrate_event(&1, from_version, to_version))
  |> Stream.each(&write_event(temp_path, &1))
  |> Stream.run()

  # Atomic swap
  File.rename!(temp_path, log_path(entity_id))

  # Git commit migration
  git_commit("Migrate from v#{from_version} to v#{to_version}")
end
```

## References

- `docs/architecture.md` - Event log schema and location
- `docs/messaging/02-universal-schema.md` - Message event structure
- `docs/messaging/03-four-view-pipeline.md` - Conversation view in four-view system
- `docs/messaging/06-temporal-coherence.md` - ASM context tracking (upcoming)
- `docs/identity-sovereignty.md` - Cryptographic intent, assurance tiers, and proof stack
- [Archive Index](archive-index.md) (126-132) - Event sourcing pattern
- [Archive Index](archive-index.md) (421-444) - JSONL format rationale
