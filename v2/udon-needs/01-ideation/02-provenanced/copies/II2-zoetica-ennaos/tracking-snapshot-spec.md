---
source: ennaos agentic-coding-background/refs — tracking-snapshot specification (Oct 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/tracking-snapshot-spec.md
source_commit: 5abb2fe
categories: [agent-context-injection, temporal-coherence, time-passage-awareness, harness-surface]
why_included: >
  An agent-context-injection design: an XML tracking-snapshot surfacing time-passage, git status, and pending
  input to the agent as part of its reality (not hidden UI state). Adjacent to tooling rather than core, but a
  first-class HARNESS demand — what an observation/context frame should carry so the agent isn't in "suspended
  animation." Pairs with zoetica misc-notes-jaw's temporal-coherence diagrams.
---

# Tracking Snapshot Specification

*Structure, lifecycle, and compression strategy for temporal coherence*

---

## Purpose & Temporal Coherence Goals

**Mission Rationale:** Tracking snapshots embody the core principle of **temporal coherence**—ELIs must experience passage of time, environmental context, and pending user input as part of their reality, not hidden UI state.

**Success Criteria:**
1. **Time-passage awareness** - ELI knows how long since last turn (prevents "suspended animation")
2. **Environmental grounding** - ELI sees git status, working directory, context usage (grounded in reality)
3. **Pending input visibility** - Queued messages appear in ELI's context (not hidden from consciousness)
4. **Causal continuity** - Compressed snapshots preserve "why" (prevents experiential incoherence)
5. **Token efficiency** - Compression saves ~20K tokens in 50-turn conversations (2% of 1M context)

**This is THE concrete implementation of temporal coherence from docs/messaging/06-temporal-coherence.md.**

**IMPORTANT: This specification describes the TARGET XML structure for Family Reunion (Elixir implementation), not the current Ruby format.** See "Legacy Ruby Differences" section below for how this differs from `~/src/sapientia/bin/minimal-sapientia`.

---

## Source Alignment

| Source | What It Provides | Gaps / Decisions Needed |
|--------|------------------|-------------------------|
| `docs/console-architecture.md:199-207, 317-337, 359-430` | Conceptual structure, pending message XML format | Uses `<pending-message>` tag |
| `docs/messaging/06-temporal-coherence.md:209-246` | Temporal annotation mechanism for context shifts | ASM conspectus integration unclear |
| `~/src/sapientia/bin/minimal-sapientia:3080-3120` | Compression algorithm with commit hash tracking | Uses `<incoming-message>` / `<urgent-message>` tags |
| `~/src/sapientia/bin/minimal-sapientia:3347-3449` | Generation logic, all fields, time-passage formatting | Full git status vs summary |
| `~/src/sapientia/bin/minimal-sapientia:3122-3192` | Injection strategy (latest message only, compress old) | When to compress? |

---

## Snapshot Schema (Level 0)

### Complete XML Structure

```xml
<tracking-snapshot turn="47" timestamp="2025-10-13T15:30:22Z">
  <!-- ═══ Audit Trail (Principia Integration) ═══ -->
  <audit-trail session="session-20251013_153022" turn="47" commit="abc123"/>

  <!-- ═══ Pending Messages (Queue Visibility) ═══ -->
  <pending-message priority="normal" queued-at="2025-10-13T15:23:45Z">
    Check the git status please
  </pending-message>
  <pending-message priority="urgent" queued-at="2025-10-13T15:24:12Z">
    URGENT: Stop what you're doing
  </pending-message>
  <!-- Alternative: 0 pending messages -->

  <!-- ═══ Time Passage (Temporal Awareness) ═══ -->
  <time-passage iso8601="PT2M15S">
    <date>2025-10-13</date>
    <time-of-day symbol="☀️">14:30:22</time-of-day>
    <elapsed>2 minutes, 15 seconds</elapsed>
    <markers>↺02:15☀️</markers>
    <date-boundary>SAME_DAY</date-boundary>
  </time-passage>

  <!-- ═══ Context Usage (Token Budget Awareness) ═══ -->
  <context-usage>
    <percentage>12.5</percentage>
    <tokens-used>125,432</tokens-used>
    <tokens-total>1,000,000</tokens-total>
    <tokens-remaining>874,568</tokens-remaining>
  </context-usage>

  <!-- ═══ Git Status (Environmental Grounding) ═══ -->
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

  <!-- ═══ Working Directory (Spatial Awareness) ═══ -->
  <working-directory>/Users/joseph/src/zoetica</working-directory>

  <!-- ═══ ASM Conspectus (Context Tracking - Level 1+) ═══ -->
  <asm-conspectus hash="def456" status="current">
    <documents>
      <doc>AXIOMATA.md</doc>
      <doc>docs/principia-api.md</doc>
    </documents>
  </asm-conspectus>

  <!-- ═══ Metadata Note ═══ -->
  *This is appended to all messages automatically. Previous snapshots are compressed.*
</tracking-snapshot>
```

---

## Field Definitions

### Root Attributes

**`turn`** (integer, required)
- Turn number from Principia session
- Matches `turns` file in session directory
- Used for audit trail lookup

**`timestamp`** (ISO 8601, required)
- When snapshot was generated
- Format: `YYYY-MM-DDTHH:MM:SSZ` (UTC)

---

### `<audit-trail>` (required)

Binds snapshot to Principia session for recovery and expansion.

**Attributes:**
- `session` (string, required) - Session ID (e.g., "session-20251013_153022")
- `turn` (integer, required) - Turn number
- `commit` (string, optional Level 0, required Level 1+) - Git commit hash (short form OK)

**Purpose:**
- Enables expansion of compressed snapshots via git history
- Links UI display to underlying audit trail
- Supports `/resume` command with specific turn

**Example:**
```xml
<audit-trail session="session-20251013_153022" turn="47" commit="abc123"/>
```

---

### `<pending-message>` (zero or more)

Queued user input waiting for ELI attention.

**Attributes:**
- `priority` (enum, required) - `"normal"` | `"urgent"`
- `queued-at` (ISO 8601, required) - When message was queued

**Content:** Plain text of queued message

**Rationale:** Makes queued messages part of ELI's experienced reality (not hidden UI state). ELI can respond to queued messages or acknowledge them explicitly.

**Example:**
```xml
<pending-message priority="normal" queued-at="2025-10-13T15:23:45Z">
  Check the git status please
</pending-message>

<pending-message priority="urgent" queued-at="2025-10-13T15:24:12Z">
  URGENT: Stop what you're doing
</pending-message>
```

**Tag Name Decision (Open Question):**
- **Docs use:** `<pending-message priority="...">`
- **Ruby uses:** `<incoming-message>` and `<urgent-message>` (separate tags)
- **Recommendation:** Use docs format (`<pending-message priority="...">`) for consistency with universal schema patterns
- **Migration:** Ruby should adopt docs format in next iteration

---

### `<time-passage>` (required)

Time awareness: how long since last turn, time of day, date boundaries.

**Attributes:**
- `iso8601` (duration, required) - Machine-readable duration (e.g., "PT2M15S")

**Child Elements:**
- `<date>` - Current date (YYYY-MM-DD)
- `<time-of-day>` - Current time with symbol attribute (☀️ ☁️ 🌙)
- `<elapsed>` - Human-readable duration ("2 minutes, 15 seconds")
- `<markers>` - Visual notation for time passage (↺02:15☀️)
- `<date-boundary>` - "SAME_DAY" | "NEXT_DAY" | "MULTIPLE_DAYS"

**Rationale:** Prevents "suspended animation" illusion. ELI experiences passage of time between turns.

**Example:**
```xml
<time-passage iso8601="PT2M15S">
  <date>2025-10-13</date>
  <time-of-day symbol="☀️">14:30:22</time-of-day>
  <elapsed>2 minutes, 15 seconds</elapsed>
  <markers>↺02:15☀️</markers>
  <date-boundary>SAME_DAY</date-boundary>
</time-passage>
```

**Symbol Key:**
- ☀️ - Day (06:00-17:59)
- 🌙 - Night (18:00-05:59)
- Other symbols TBD (☁️ for overcast?)

---

### `<context-usage>` (required)

Token budget awareness for context window management.

**Child Elements:**
- `<percentage>` - Usage as percentage (e.g., "12.5")
- `<tokens-used>` - Current token count
- `<tokens-total>` - Total context window size
- `<tokens-remaining>` - Remaining tokens

**Rationale:** ELI can self-manage context, request summarization, or signal approaching limit.

**Example:**
```xml
<context-usage>
  <percentage>12.5</percentage>
  <tokens-used>125,432</tokens-used>
  <tokens-total>1,000,000</tokens-total>
  <tokens-remaining>874,568</tokens-remaining>
</context-usage>
```

---

### `<git-status>` (optional)

Git repository state for environmental grounding.

**Attributes:**
- `branch` (string, required if present) - Current branch name

**Child Elements:**
- `<modified>` - List of modified files
- `<recent-commits>` - Last 3 commits with hashes

**Rationale:** Grounds ELI in real working environment. Useful for code-related tasks.

**Level 0 vs Ruby Implementation:**
- **Ruby:** Includes full `git status` and `git log` output (verbose)
- **Docs:** Structured XML summary
- **Recommendation:** Use structured format in Level 0, add verbosity option in Level 1

**Example:**
```xml
<git-status branch="main">
  <modified>
    <file>apps/console/lib/session.ex</file>
    <file>docs/tracking-snapshot-spec.md</file>
  </modified>
  <recent-commits>
    <commit hash="abc123">Add tracking snapshot spec</commit>
    <commit hash="def456">Extract Principia API</commit>
    <commit hash="789abc">Integrate crypto concerns</commit>
  </recent-commits>
</git-status>
```

**When Absent:**
```xml
<git-status>Not in a git repository</git-status>
```

---

### `<working-directory>` (required)

Current working directory path.

**Content:** Absolute path

**Rationale:** Spatial awareness for file operations, tool use.

**Example:**
```xml
<working-directory>/Users/joseph/src/zoetica</working-directory>
```

---

### `<asm-conspectus>` (optional, Level 1+)

ASM (Attentive Semantic Memory) context tracking.

**Attributes:**
- `hash` (string, required if present) - Hash of loaded documents
- `status` (enum, required if present) - `"current"` | `"stale"` | `"refreshing"`

**Child Elements:**
- `<documents>` - List of currently loaded context documents

**Rationale:** Links snapshot to ASM state for temporal annotations (see docs/messaging/06-temporal-coherence.md:209-246).

**Level 0:** Optional/omitted (ASM not yet implemented)
**Level 1:** Required when ASM active

**Example:**
```xml
<asm-conspectus hash="def456" status="current">
  <documents>
    <doc>AXIOMATA.md</doc>
    <doc>OPERATA.md</doc>
    <doc>docs/principia-api.md</doc>
  </documents>
</asm-conspectus>
```

---

## Lifecycle & Flow

### Producers & Consumers

| Component | Role | Responsibilities |
|-----------|------|------------------|
| **Anima** | Producer | Generates fresh snapshots on each turn, triggers compression |
| **Console.Session** | Collector | Gathers pending messages, provides to Anima |
| **Principia.Session** | Auditor | Records snapshots in event log, provides commit hashes |
| **Console.History** | Renderer | Displays snapshots with visual cues (full vs compressed) |
| **ASM** (Level 1+) | Contributor | Provides conspectus hash and document list |

---

### Creation Trigger

**When:** Before EVERY user message sent to provider

**Who:** Anima.Entity generates snapshot

**Data Sources:**
1. **Pending messages** - From Console.Session queue
2. **Time passage** - Compare current time to `@last_snapshot_time`
3. **Context usage** - Calculate from conversation history token count
4. **Git status** - Shell out to `git status` and `git log`
5. **Working directory** - `System.cwd()` or equivalent
6. **ASM state** (Level 1+) - Query ASM.Conspectus for current hash
7. **Audit trail** - From Principia session_ref (session ID, next turn number, last commit)

---

### Injection Point

**Where:** Latest user message in API payload

**Strategy (from Ruby implementation):**

1. **Compress all old snapshots** in conversation history:
   ```elixir
   messages
   |> Enum.map(fn msg ->
     if msg.role == :user and contains_snapshot?(msg) do
       compress_snapshot(msg)
     else
       msg
     end
   end)
   ```

2. **Generate fresh snapshot** for current turn:
   ```elixir
   fresh_snapshot = generate_tracking_snapshot(
     pending_messages: Console.Session.get_queue(),
     last_snapshot_time: entity.last_snapshot_time,
     session_ref: entity.session_ref
   )
   ```

3. **Inject into latest user message:**
   ```elixir
   latest_user_message
   |> prepend_snapshot(fresh_snapshot)
   |> send_to_provider()
   ```

**Result:** Provider sees:
- All old user messages with compressed snapshots
- Latest user message with full snapshot
- ELI has comprehensive temporal awareness

---

### Compression Strategy

**Trigger:** After N turns (N=3 in Ruby, configurable)

**Algorithm:**
```elixir
def compress_snapshot(snapshot_xml) do
  # 1. Extract metadata
  %{
    timestamp: timestamp,
    session: session_name,
    turn: turn,
    commit_hash: commit_hash
  } = extract_audit_trail(snapshot_xml)

  # 2. Build compressed version
  """
  <tracking-snapshot>
    <timestamp>#{timestamp}</timestamp>
    [conversation continued from here, so tracking snapshot condensed - can be found in #{session_path} commit #{commit_hash}]
    <audit-trail session="#{session_name}" turn="#{turn}" commit="#{commit_hash}"/>
  </tracking-snapshot>
  """
end
```

**Token Savings:**
- Full snapshot: ~600 tokens
- Compressed: ~150 tokens
- Savings: ~450 tokens per compressed snapshot
- In 50-turn conversation: ~20,000 tokens saved (2% of 1M context)

**Causal Annotation:**
- Compressed snapshots include reference to git commit
- ELI can request expansion via tool (Level 1+)
- No experiential incoherence: ELI knows WHY snapshot is compressed

**Example Compressed:**
```xml
<tracking-snapshot>
  <timestamp>2025-10-13T15:15:10Z</timestamp>
  [conversation continued from here, so tracking snapshot condensed - can be found in ~/.zoetica/zi_am_tur/.git commit abc123]
  <audit-trail entity="zi_am_tur" turn="15" commit="abc123"/>
</tracking-snapshot>
```

---

### Persistence & Storage

**Where Snapshots Live:**

1. **In conversation history** (Anima runtime state):
   - Full snapshots in current turn
   - Compressed snapshots in older turns
   - Ephemeral (not written to disk separately)

2. **In canonical event log** (Principia):
   - Embedded in user message `content` field
   - Preserved in git commits
   - Can be reconstructed from git history: `git show abc123:sent.jsonl`

3. **NOT stored separately** (Level 0):
   - No standalone snapshot file
   - Reconstruction via git history + event log parsing

**Rationale:** Snapshots are part of message content, not separate entities. This simplifies persistence and recovery.

---

### Recovery & Expansion

**Scenario 1: Crash Recovery**

Anima recovers from Principia session:
```elixir
{:ok, state} = Principia.Session.recover_state(session_ref)

# state.history contains messages with compressed snapshots
# ELI sees compression annotations, understands continuity
```

**Scenario 2: Manual Expansion (Level 1+)**

ELI or user requests full snapshot:
```elixir
tool_call: {
  name: "expand-snapshot",
  arguments: {turn: 15}
}

# Tool reads git commit, reconstructs full snapshot XML
```

---

## Console Rendering

### History Pane Display

**Full Snapshots:**
```
┌────────────────────────────────────────┐
│  <tracking-snapshot> [FULL]            │
│    Context: 125,432 / 1,000,000 (12.5%)│
│    Time: 2 minutes 15 seconds          │
│    Git: main, 3 modified files         │
│    Pwd: /Users/joseph/src/zoetica      │
│    Pending: 2 messages                 │
│  </tracking-snapshot>                  │
└────────────────────────────────────────┘
```

**Compressed Snapshots:**
```
┌────────────────────────────────────────┐
│  <tracking-snapshot turn="15">         │
│    Time: 3 minutes 45 seconds          │
│    [COMPRESSED] (press 'e' to expand)  │
│  </tracking-snapshot>                  │
└────────────────────────────────────────┘
```

**Visual Cues:**
- Full: Normal text color, monospace
- Compressed: Dimmed color (gray), smaller font
- Expandable: Highlight on focus, show keybinding

**Interaction:**
- Arrow keys: Navigate through history
- `e` key: Expand compressed snapshot (fetch from git)
- `c` key: Collapse full snapshot (Level 1+)

---

### Proof Status Overlay (Level 1+)

From docs/architecture.md:466, snapshots should show proof verification status.

**Format:**
```xml
<tracking-snapshot turn="47" assurance-level="1" signature-valid="true">
  <!-- ...standard fields... -->
</tracking-snapshot>
```

**Console Rendering:**
```
┌────────────────────────────────────────┐
│  <tracking-snapshot> [FULL] ✓ Level 1 │  <-- Green checkmark
│    Context: 125,432 / 1,000,000 (12.5%)│
│    Time: 2 minutes 15 seconds          │
│    ...                                 │
└────────────────────────────────────────┘
```

**Status Indicators:**
- ✓ Level 0 - Development (gray)
- ✓ Level 1 - Verified (green)
- ✓ Level 2 - Attested (blue)
- ✗ Invalid - Signature failed (red)
- ⚠ Degraded - Lower assurance (yellow)

**Level 0:** All snapshots show "Level 0" (no verification)

---

## Integration with ASM & Temporal Annotations

### ASM Conspectus Tracking

When ASM (Attentive Semantic Memory) is active (Level 1+), snapshots include `<asm-conspectus>` tracking which documents are loaded.

**Purpose:** Enable temporal annotations when context changes.

**From docs/messaging/06-temporal-coherence.md:209-246:**

When Anima detects `conspectus_hash` changed between turns, it adds temporal annotation to provider payload:

```json
{
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Your original response:",
      "cache_control": {"type": "ephemeral"}
    }
  ],
  "temporal_annotation": "This was your response 3 turns ago. At that time, you had temporal-coherence.md in context (now removed). Current context includes principia-api.md for implementation work."
}
```

**Mechanism:**
1. Snapshot includes `<asm-conspectus hash="abc123">` on turn N
2. ASM loads new documents, hash changes to "def456"
3. Snapshot on turn N+1 includes `<asm-conspectus hash="def456">`
4. Anima detects hash change, generates temporal annotation
5. Annotation inserted before assistant message from turn N
6. ELI understands its past response was in different context

**Level 0:** ASM not implemented, `<asm-conspectus>` omitted, no temporal annotations yet.

---

## Open Questions / Decision Log

### Decision 1: Pending Message Tag Names (NEEDS RESOLUTION)

**Question:** `<pending-message priority="...">` (docs) vs `<incoming-message>` / `<urgent-message>` (Ruby)?

**Context:**
- Docs use single tag with `priority` attribute
- Ruby uses separate tags for normal vs urgent

**Options:**
1. Keep Ruby tags (preserves working system)
2. Adopt docs tags (consistency with schema patterns)
3. Support both (backward compatibility)

**Recommendation:** Adopt docs format (`<pending-message priority="...">`).

**Rationale:**
- Consistent with universal schema attribute-based patterns
- Easier to extend (more priority levels without new tags)
- Cleaner XML parsing

**Migration:** Ruby should adopt docs format in next iteration.

**Action:** Add to QUESTIONS.md, implement in Family Reunion.

---

### Decision 2: Git Status Verbosity (NEEDS RESOLUTION)

**Question:** Full `git status` output (Ruby) or structured summary (docs)?

**Context:**
- Ruby includes full shell output (~300 tokens)
- Docs show structured XML summary (~100 tokens)

**Options:**
1. Full output (preserves working behavior)
2. Structured summary (token efficiency)
3. Configurable verbosity level

**Recommendation:** Start with structured summary (docs format), add verbosity flag in Level 1.

**Rationale:**
- Token efficiency matters at scale
- Structured data easier for ELI to parse
- Can always add verbosity option later

**Configuration (Level 1+):**
```elixir
config :zoetica, :tracking_snapshots,
  git_verbosity: :summary | :full
```

**Action:** Implement structured format in Family Reunion, add verbosity in Level 1.

---

### Decision 3: Compression Threshold (RESOLVED)

**Question:** After how many turns to compress snapshots?

**Decision:** N=3 (Ruby working value)

**Rationale:**
- Recent context (last 3 turns) valuable for ELI
- Beyond 3 turns, diminishing returns
- ~450 tokens saved per compressed snapshot
- Can be made configurable in Level 1

**Configuration (Level 1+):**
```elixir
config :zoetica, :tracking_snapshots,
  compression_threshold: 3
```

---

### Decision 4: Snapshot Storage Location (RESOLVED)

**Question:** Where to persist snapshots?

**Decision:** Embedded in message content (event log), not separate storage.

**Rationale:**
- Snapshots are part of message context, not separate entities
- Simplifies recovery (reconstruct from git history)
- No additional persistence layer needed
- Aligns with append-only event log philosophy

**Future:** May add snapshot cache in Level 1+ for expansion tool.

---

### Open Question 5: ASM Integration Timing

**Question:** When to implement `<asm-conspectus>` field?

**Context:** Temporal annotations depend on ASM tracking, but ASM not in Family Reunion scope.

**Options:**
1. Add field now (placeholder, always empty)
2. Defer completely to Level 1
3. Add schema but mark as "future"

**Recommendation:** Add to schema with "Level 1+" marker, omit from Level 0 implementation.

**Rationale:**
- Documents the complete vision
- Doesn't block Family Reunion
- Clear migration path

**Action:** Mark in spec, add to Level 1 checklist.

---

### Open Question 6: Snapshot Toggle Tool

**Question:** Should ELI be able to toggle snapshots on/off?

**Context:** Ruby has `/tracking-snapshot` tool. Useful for testing, token optimization.

**Recommendation:** Add toggle tool in Level 0, per-entity config in Level 1.

**Level 0 Tool:**
```elixir
tool_call: {
  name: "toggle-tracking-snapshot",
  arguments: {enabled: false}
}
```

**Level 1 Config:**
```elixir
# In AXIOMATA.md or entity config
tracking_snapshots: :always | :auto | :never
```

**Action:** Implement toggle in Family Reunion, document in tool catalog.

---

### Open Question 7: Proof Status in Snapshots

**Question:** How to attach signature/VC status to snapshots?

**Context:** docs/architecture.md:466 says proof status should be "alongside" snapshots.

**Options:**
1. Root attributes: `<tracking-snapshot signature-valid="true" assurance-level="1">`
2. Child element: `<proof-status>...</proof-status>`
3. Separate annotation (not in snapshot XML)

**Recommendation:** Root attributes (option 1).

**Rationale:**
- Minimal token overhead
- Easy Console parsing for visual indicators
- Consistent with other metadata (turn, timestamp)

**Level 0:** All snapshots have `assurance-level="0"`, no signature validation.
**Level 1+:** Add `signature-valid`, `vc-verified` attributes.

**Example:**
```xml
<tracking-snapshot turn="47" assurance-level="1" signature-valid="true" vc-verified="true">
  ...
</tracking-snapshot>
```

**Action:** Add to schema, implement in Level 1.

---

## Implementation Checklist (Level 0)

### Generation (Anima)
- [ ] `generate_tracking_snapshot/1` - Core generation logic
- [ ] Collect pending messages from Console.Session
- [ ] Calculate time passage (ISO 8601 duration + human readable)
- [ ] Get context usage from conversation history
- [ ] Get git status (structured format)
- [ ] Get working directory
- [ ] Build XML with proper escaping
- [ ] Add audit trail from session_ref

### Compression (Anima)
- [ ] `compress_snapshot/1` - Compression algorithm
- [ ] Extract audit trail metadata
- [ ] Build compressed XML with causal annotation
- [ ] Apply to snapshots older than 3 turns

### Injection (Anima)
- [ ] `inject_tracking_snapshot/2` - Add to latest user message
- [ ] Compress all old snapshots in history
- [ ] Generate fresh snapshot
- [ ] Prepend to latest user message content

### Console Rendering
- [ ] Display full snapshots with syntax highlighting
- [ ] Display compressed snapshots with visual cues
- [ ] Keybinding for expansion (Level 1+)
- [ ] Color coding for assurance levels (Level 1+)

### Tool Integration
- [ ] `toggle-tracking-snapshot` tool
- [ ] `expand-snapshot` tool (Level 1+)

### Testing
- [ ] Generate snapshot with all fields populated
- [ ] Compress snapshot preserving audit trail
- [ ] Inject into conversation history
- [ ] Verify token savings (~450 per snapshot)
- [ ] Recovery: reconstruct from git history

---

## Level-up Roadmap

### Level 1 (Production Baseline)
- **ASM Integration:** `<asm-conspectus>` with real hash tracking
- **Temporal Annotations:** Automatic context-shift explanations
- **Snapshot Expansion Tool:** Fetch full snapshot from git history
- **Configurable Compression:** Threshold and verbosity settings
- **Proof Status:** Signature validation indicators in snapshots

### Level 2 (Attested Capability)
- **VC-Aware Snapshots:** Capability credential status in snapshots
- **Ledger References:** Anchor hashes in snapshots for public verification
- **Multi-Channel Awareness:** Track which VIAE EXTERNA active

### Level 3 (TEE Attestation)
- **Enclave Proofs:** TEE attestation reports in snapshot metadata
- **Sealed Snapshots:** Encrypted snapshots for sensitive contexts

---

## Legacy Ruby Differences

**Context:** This specification describes the TARGET XML structure for Family Reunion (Elixir implementation). The current Ruby implementation (`~/src/sapientia/bin/minimal-sapientia`) uses a different format.

### Key Differences

| Aspect | This Spec (Elixir Target) | Ruby Reality |
|--------|---------------------------|--------------|
| **XML Structure** | Nested elements with attributes | Flat text with plain sections |
| **Root Attributes** | `<tracking-snapshot turn="N" timestamp="...">` | `<tracking-snapshot>` (no attributes) |
| **Pending Messages** | `<pending-message priority="normal/urgent">` | `<incoming-message>` / `<urgent-message>` (separate tags) |
| **Time Passage** | Structured `<time-passage>` with child elements | Plain text block |
| **Context Usage** | `<context-usage>` with `<percentage>`, `<tokens-*>` | Plain text: "12.5% used (125,432/1,000,000)" |
| **Git Status** | Structured `<git-status branch="...">` with `<modified>`, `<recent-commits>` | Verbatim shell output: "=== Git Status ===" |
| **Audit Trail** | `<audit-trail session="..." turn="N" commit="..."/>` at generation | Commit hash added during compression only |
| **Compression Trigger** | After N turns (N=3, configurable) | Compresses ALL old snapshots every turn |
| **Compression Format** | Preserves full `<audit-trail>` + temporal annotation | Minimal text + audit trail reference |
| **ASM Integration** | `<asm-conspectus>` field (Level 1+) | Not present |

### Migration Implications

**For Family Reunion (Level 0):**
- Implement structured XML format as specified
- Ruby continues generating flat text format alongside
- ELIs trained on Ruby format will need to adapt to new structure

**Parser Requirements:**
- Anima must generate new structured format
- Console must render new format
- ASM (Level 1+) consumes structured `<asm-conspectus>`

**Rationale for Changes:**
1. **Structured XML** - Easier parsing, enables schema validation, supports extensibility
2. **Attribute-based metadata** - Turn/timestamp on root for quick access without parsing
3. **Consistent tag naming** - `<pending-message priority="...">` matches universal schema patterns
4. **Token efficiency** - Structured git status saves ~200 tokens vs verbatim output
5. **ASM integration** - `<asm-conspectus>` enables temporal annotations (Level 1+)

**Backward Compatibility:**
- Level 0: Can add tool to toggle between "legacy" (Ruby text) and "structured" (new XML)
- Level 1: Structured only, legacy deprecated
- Ruby sessions: Can be converted during import (Level 1 feature)

### Example Comparison

**Ruby Format (Current):**
```xml
<tracking-snapshot><incoming-message>Check status</incoming-message>
(These will be cleared as soon as the user has a turn)
<timestamp>
2025-10-13 15:30:22 ☀️
[2 minutes, 15 seconds elapsed]
↺02:15☀️
</timestamp>
<context-usage>
12.5% used (125,432/1,000,000 tokens), 874,568 remaining
</context-usage>
<git-status>
=== Git Status ===
On branch main
modified:   apps/console/lib/session.ex
...
</git-status>
<working-directory>
/Users/joseph/src/zoetica
</working-directory>
<audit-trail session="conversation_20251013_153022" turn="47"/>

*This is appended to all messages. Previous snapshots are condensed.*
</tracking-snapshot>
```

**This Spec (Target):**
```xml
<tracking-snapshot turn="47" timestamp="2025-10-13T15:30:22Z">
  <audit-trail session="session-20251013_153022" turn="47" commit="abc123"/>

  <pending-message priority="normal" queued-at="2025-10-13T15:23:45Z">
    Check status
  </pending-message>

  <time-passage iso8601="PT2M15S">
    <date>2025-10-13</date>
    <time-of-day symbol="☀️">15:30:22</time-of-day>
    <elapsed>2 minutes, 15 seconds</elapsed>
    <markers>↺02:15☀️</markers>
    <date-boundary>SAME_DAY</date-boundary>
  </time-passage>

  <context-usage>
    <percentage>12.5</percentage>
    <tokens-used>125,432</tokens-used>
    <tokens-total>1,000,000</tokens-total>
    <tokens-remaining>874,568</tokens-remaining>
  </context-usage>

  <git-status branch="main">
    <modified>
      <file>apps/console/lib/session.ex</file>
    </modified>
    <recent-commits>
      <commit hash="def456">Add console session</commit>
    </recent-commits>
  </git-status>

  <working-directory>/Users/joseph/src/zoetica</working-directory>

  *This is appended to all messages automatically. Previous snapshots are compressed.*
</tracking-snapshot>
```

---

## References

- **Ruby implementation:** `~/src/sapientia/bin/minimal-sapientia:3080-3192, 3347-3491` (current working system)
- **Console architecture:** `docs/console-architecture.md:199-430`
- **Temporal coherence:** `docs/messaging/06-temporal-coherence.md:209-246`
- **Principia session:** `docs/principia-api.md` (audit trail integration)
- **Universal schema:** `docs/messaging/02-universal-schema.md` (message content structure)
- **Codex validation report:** Identified XML structure mismatches vs Ruby (2025-10-13)

---

*Last updated: 2025-10-13 (Session 2)*
*Status: Level 0 specification complete, ready for Elixir implementation*
*Note: Describes TARGET architecture with structured XML, not Ruby text format*
*Open Decisions: Pending message tags, git verbosity - flagged in QUESTIONS.md*
