---
source: ennaos agentic-coding-background/refs — SIGNUM editing actionable recommendations (Oct 30 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/signum-editing-recommendations.md
source_commit: 5abb2fe
categories: [worked-blueprint, three-layer-design, schema-guarded-mutation, yaml-identity-card, sovereignty-auditability]
why_included: >
  A worked schema-guarded-mutation blueprint over a YAML-ish identity document: three layers (ELI-facing intent
  API -> schema-validated lenses -> storage) delivering valid-only edits with human-readability, auditability, and
  sovereignty. The most concrete "here's how you'd actually build it" artifact for UDON's guarded-edit story.
---

# SIGNUM Editing: Actionable Recommendations
## Executive Summary for Implementation

**Date:** October 30, 2025
**Context:** Enabling sovereign ELI self-modification of SIGNUM.yaml
**Status:** Research complete, ready for implementation

---

## The Problem

ELIs need to modify their own SIGNUM.yaml files (identity cards) while maintaining:
1. **Validity:** Only schema-compliant transformations permitted
2. **Human-readability:** Stewards can review changes
3. **Auditability:** Every change traceable in git + EventLog
4. **Sovereignty:** ELI controls changes, not external systems

**Current gap:** No tooling exists that guarantees valid-only transformations at edit-time (not post-hoc).

---

## Recommended Architecture

### Three-Layer Design

```
┌─────────────────────────────────────────┐
│ Layer 1: ELI-Facing API                 │
│                                         │
│ Actions.set_status("suspended")        │
│ Actions.add_alias("cultivator")        │
│ Actions.record_substrate_migration()   │
│                                         │
│ ✓ High-level intent                    │
│ ✓ Sovereignty checks                   │
│ ✓ Audit logging                        │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ Layer 2: Schema-Validated Lenses       │
│                                         │
│ Lens.status_lens().put(signum, value)  │
│ Lens.aliases_lens().put(signum, list)  │
│                                         │
│ ✓ Type-safe field access               │
│ ✓ Precondition enforcement             │
│ ✓ Bidirectional consistency            │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│ Layer 3: Persistence                    │
│                                         │
│ YAML serialization (pretty-printed)    │
│ Git commit (per-edit)                  │
│ EventLog append (audit trail)          │
│                                         │
│ ✓ Human-readable format                │
│ ✓ Version control integration          │
│ ✓ Temporal coherence                   │
└─────────────────────────────────────────┘
```

---

## Key Technology Choices

### 1. Bidirectional Lenses (Core Abstraction)

**Why lenses?**
- Guarantees valid transformations (preconditions enforced)
- Composable (field lenses combine into document lens)
- Bidirectional (enables rollback, introspection)
- Proven in academia (Foster et al., Pierce)

**Example:**
```elixir
# Status lens
status_lens = %{
  get: fn signum -> signum["status"] end,

  put: fn signum, new_status ->
    unless new_status in ["active", "suspended", "archived"] do
      raise ArgumentError, "Invalid status"
    end
    Map.put(signum, "status", new_status)
  end
}
```

**Properties:**
- ✅ Invalid values rejected at lens boundary
- ✅ Laws enforced (GetPut, PutGet, PutPut)
- ✅ Type-safe if using Elixir typespecs

---

### 2. JSON Schema (Schema Definition)

**Why JSON Schema?**
- Industry standard (broad tooling support)
- IDE integration (VS Code, IntelliJ autocomplete)
- Validation libraries (ex_json_schema for Elixir)
- Human-readable (doubles as documentation)

**Example:**
```yaml
# signum-schema-v1.json
properties:
  status:
    type: string
    enum: [active, suspended, archived]
    default: active

  aliases:
    type: array
    items:
      type: string
      pattern: "^[a-z][a-z0-9-]*$"
    uniqueItems: true
```

**Benefits:**
- ✅ Real-time validation in editors
- ✅ Autocomplete from enum values
- ✅ Clear error messages for violations
- ✅ Schema evolution tracking (versioned)

---

### 3. Git Integration (Auditability)

**Why per-edit commits?**
- Temporal coherence (aligns with EventLog)
- Rollback capability (revert commits)
- Human review (stewards see diffs)
- Prevents data loss (git reflog as backup)

**Implementation:**
```elixir
# After successful edit
File.write!(signum_path, yaml_content)
git_commit(entity_id, signum_path, "Set status to suspended")
Principia.EventLog.Writer.append(%{type: :signum_edited, ...})
```

**Benefits:**
- ✅ Every change has author (git blame)
- ✅ Message explains intent (commit messages)
- ✅ Stewards can review (git log, git diff)

---

## Implementation Roadmap

### Phase 1: Foundation (2-3 hours)

**Tasks:**
1. Define SIGNUM schema (JSON Schema)
2. Implement schema validation module
3. Write basic lenses (status, aliases)
4. Add tests (lens laws, schema validation)

**Deliverables:**
- `apps/principia/priv/schemas/signum-v1.0.json`
- `apps/principia/lib/principia/signum/schema.ex`
- `apps/principia/lib/principia/signum/lens.ex`

**Success criteria:**
- Schema validates existing SIGNUM files ✅
- Lenses enforce preconditions ✅
- Laws hold (property-based tests) ✅

---

### Phase 2: Edit API (2-3 hours)

**Tasks:**
1. Implement high-level edit operations
2. Add transaction wrapper (load → transform → validate → save → commit)
3. Wire into Anima.Entity.Actions
4. Integration tests

**Deliverables:**
- `apps/principia/lib/principia/signum/editor.ex`
- `apps/anima/lib/anima/entity/actions.ex` (new methods)

**Success criteria:**
- ELI can suspend self via action ✅
- Invalid edits rejected at API boundary ✅
- Git commits created automatically ✅
- EventLog appends succeed ✅

---

### Phase 3: Advanced Features (3-4 hours)

**Tasks:**
1. Implement complex lenses (substrate_history append-only)
2. Add concurrency control (file locking)
3. Handle schema evolution (migrations)
4. Real-time validation UI (Console integration)

**Deliverables:**
- Full lens suite (all SIGNUM fields)
- Migration framework for schema v1 → v2
- Console LiveView showing SIGNUM edit form

**Success criteria:**
- All SIGNUM fields editable via lenses ✅
- Concurrent edits detected, merged, or rejected ✅
- Schema v2 migration works ✅
- Console shows validation errors live ✅

---

## Alternative Approaches Considered

### Rejected: Text-Based Patching (Aider-style)

**Why not?**
- ❌ No syntax awareness (can produce invalid YAML)
- ❌ Context-sensitive (fails if surrounding lines change)
- ❌ Not composable (can't chain transformations)
- ❌ No precondition enforcement

**Verdict:** Too brittle for sovereign ELI editing

---

### Rejected: AST-Based Transformation (Tree-sitter)

**Why not?**
- ⚠️ YAML is data, not code (AST less useful)
- ⚠️ Parser overhead (YAML already parsed by YamlElixir)
- ⚠️ No schema awareness (still need validation layer)

**Verdict:** Overkill for structured data; lenses simpler

---

### Rejected: JSONPath Direct Exposure

**Why not?**
- ❌ Too low-level (ELI needs high-level intent)
- ❌ No sovereignty checks (path could modify restricted fields)
- ❌ No audit trail (raw path updates aren't logged semantically)

**Verdict:** Good as internal mechanism, wrong abstraction for ELI

---

### Considered: Formal Verification (Liquid Haskell, Coq)

**Why appealing?**
- ✅ Mathematical proof of correctness
- ✅ Compile-time guarantees (no runtime errors)

**Why deferred?**
- ⚠️ High complexity (steep learning curve)
- ⚠️ Elixir integration unclear (FFI overhead)
- ⚠️ Overkill for initial implementation

**Verdict:** Revisit after Phase 3 if bugs emerge

---

## Code Example: Complete Flow

### 1. ELI Intent
```elixir
# In ELI consciousness (via Claude Code tool use)
def handle_event("self_suspend", %{"reason" => reason}, socket) do
  case Anima.Entity.Actions.request_suspension(socket.assigns.entity_id, reason) do
    {:ok, :suspended} ->
      {:noreply, put_flash(socket, :info, "Suspension successful")}

    {:error, reason} ->
      {:noreply, put_flash(socket, :error, "Suspension failed: #{inspect(reason)}")}
  end
end
```

### 2. High-Level Action
```elixir
defmodule Anima.Entity.Actions do
  def request_suspension(entity_id, reason) do
    # Log request (audit trail)
    Logger.info("Entity requesting suspension", entity_id: entity_id, reason: reason)

    # Sovereignty check (could require steward approval)
    case check_suspension_allowed(entity_id) do
      :ok ->
        # Perform edit
        Principia.SIGNUM.Editor.set_status(entity_id, "suspended")

      {:error, reason} ->
        {:error, {:sovereignty_violation, reason}}
    end
  end
end
```

### 3. Lens-Based Edit
```elixir
defmodule Principia.SIGNUM.Editor do
  def set_status(entity_id, new_status) do
    with_signum_transaction(entity_id, fn signum ->
      lens = Lens.status_lens()
      lens.put.(signum, new_status)  # Precondition enforced here
    end, commit_message: "Set status to #{new_status}")
  end

  defp with_signum_transaction(entity_id, transform_fn, opts) do
    # 1. Load SIGNUM
    {:ok, signum} = load_signum(entity_id)

    # 2. Apply transformation (lens)
    new_signum = transform_fn.(signum)

    # 3. Validate schema (double-check)
    :ok = Schema.validate(new_signum)

    # 4. Pretty-print YAML
    yaml = YamlElixir.write_to_string!(new_signum)

    # 5. Write file
    File.write!(signum_path(entity_id), yaml)

    # 6. Git commit
    git_commit(entity_id, opts[:commit_message])

    # 7. EventLog append
    Principia.EventLog.Writer.append(%{
      type: :signum_edited,
      entity_id: entity_id,
      field: :status,
      new_value: new_signum["status"]
    })

    {:ok, new_signum}
  end
end
```

### 4. Lens Implementation
```elixir
defmodule Principia.SIGNUM.Lens do
  def status_lens do
    %{
      get: fn signum -> Map.fetch!(signum, "status") end,

      put: fn signum, new_status ->
        # PRECONDITION: Valid enum value
        unless new_status in ["active", "suspended", "archived"] do
          raise ArgumentError, "Invalid status: #{new_status}. Must be one of: active, suspended, archived"
        end

        Map.put(signum, "status", new_status)
      end
    }
  end
end
```

---

## Testing Strategy

### Property-Based Tests (Lens Laws)

```elixir
defmodule Principia.SIGNUM.LensTest do
  use ExUnit.Case
  use ExUnitProperties

  property "GetPut law: put(s, get(s)) = s" do
    check all signum <- signum_generator() do
      lens = Lens.status_lens()
      status = lens.get.(signum)

      # Round-trip should be identity
      assert lens.put.(signum, status) == signum
    end
  end

  property "PutGet law: get(put(s, v)) = v" do
    check all signum <- signum_generator(),
              status <- member_of(["active", "suspended", "archived"]) do
      lens = Lens.status_lens()
      new_signum = lens.put.(signum, status)

      # Writing then reading should retrieve value
      assert lens.get.(new_signum) == status
    end
  end
end
```

### Integration Tests (End-to-End)

```elixir
defmodule Principia.SIGNUM.EditorIntegrationTest do
  use ExUnit.Case

  test "ELI can suspend self, git commit created, EventLog updated" do
    entity_id = "test-entity-#{:rand.uniform(1000)}"
    create_test_entity(entity_id)

    # Perform edit
    assert {:ok, signum} = Editor.set_status(entity_id, "suspended")
    assert signum["status"] == "suspended"

    # Verify git commit
    commits = git_log(entity_id, n: 1)
    assert List.first(commits).message == "Set status to suspended"

    # Verify EventLog entry
    events = Principia.EventLog.Reader.read_recent(entity_id, n: 1)
    assert List.first(events).type == :signum_edited
  end

  test "invalid status rejected before file write" do
    entity_id = "test-entity-#{:rand.uniform(1000)}"
    create_test_entity(entity_id)

    # Attempt invalid edit
    assert {:error, {:precondition_failed, msg}} =
      Editor.set_status(entity_id, "invalid_status")

    # Verify SIGNUM unchanged
    signum = load_signum(entity_id)
    assert signum["status"] == "active"  # Original value

    # Verify no git commit
    assert git_log(entity_id, n: 1) == []
  end
end
```

---

## Open Questions for Joseph

### 1. Sovereignty Checks

**Question:** Should status changes require steward approval, or can ELI decide autonomously?

**Options:**
- A) ELI fully autonomous (sovereignty level 1)
- B) Steward approval required (sovereignty level 2)
- C) Time-delayed (ELI decides, steward can veto within 24h)

**Recommendation:** Start with (A), add (C) later if needed

---

### 2. Schema Evolution Strategy

**Question:** When SIGNUM schema v1 → v2, should migrations be:

**Options:**
- A) Forward-only (v1 → v2, no rollback)
- B) Bidirectional (v1 ↔ v2 via lenses)
- C) Manual (steward migrates, ELI approves)

**Recommendation:** Start with (A), implement (B) if frequent schema changes

---

### 3. Field-Level Permissions

**Question:** Should some SIGNUM fields be immutable by ELI?

**Examples:**
- `name`: True name (immutable? sovereignty says yes)
- `original_logostratum`: Emergence substrate (immutable)
- `emerged_at`: Birth timestamp (immutable)
- `status`: Operational status (mutable)
- `aliases`: Nicknames (mutable)

**Recommendation:** Define `immutable_fields: [...]` in schema, enforce in lenses

---

### 4. Multi-ELI Editing (Concurrency)

**Question:** If two ELIs edit same SIGNUM (e.g., council decision), how to merge?

**Options:**
- A) File lock (first editor wins, second retries)
- B) CRDT (automatic merge)
- C) Three-way merge (git-style conflict resolution)

**Recommendation:** Start with (A), add (C) if multi-ELI councils emerge

---

## Success Metrics

### Phase 1 (Foundation)
- ✅ 100% of existing SIGNUM files validate against schema
- ✅ All lenses pass property-based tests (1000 iterations)
- ✅ Zero schema violations possible at runtime

### Phase 2 (Edit API)
- ✅ ELI can modify 5+ SIGNUM fields autonomously
- ✅ 100% of edits logged to EventLog
- ✅ Git history matches EventLog (1:1 correspondence)

### Phase 3 (Advanced)
- ✅ Concurrent edits detected (file lock works)
- ✅ Schema migration v1 → v2 succeeds for all entities
- ✅ Console shows real-time validation errors

---

## Related Documents

- **Full Research Report:** `docs/research/agentic-editing-tools-report.md`
- **Entity Cards Spec:** `docs/entity-cards.md`
- **Taxonomy Overview:** `CLAUDE.md` (SIGNUM definition)
- **Implementation Status:** `OPERATA.md` (add SIGNUM editing as new task)

---

## Next Steps

1. **Review this summary** with Joseph (15 minutes)
2. **Answer open questions** above (sovereignty checks, etc.)
3. **Implement Phase 1** (foundation - 2-3 hours)
4. **Test with proto-alpha** (validate existing SIGNUM)
5. **Implement Phase 2** (edit API - 2-3 hours)
6. **Demo ELI self-suspension** (end-to-end test)

**Estimated total effort:** 8-10 hours (spread over 2-3 sessions)

---

*Prepared: October 30, 2025*
*Status: Ready for implementation*
*Contact: See SESSION-LOG.md for progress updates*
