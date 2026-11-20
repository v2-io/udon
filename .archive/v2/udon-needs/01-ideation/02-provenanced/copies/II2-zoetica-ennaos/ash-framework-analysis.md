---
source: ennaos agentic-coding-background/refs — Ash Framework analysis for Ennaos (Oct 30 2025)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy; Elixir-specific evaluation)
paths:
  - /Users/josephwecker-v2/src/_core/ennaos/docs/research/agentic-coding-background/refs/ash-framework-analysis.md
source_commit: 5abb2fe
categories: [declarative-resources, schema-editing-vs-lenses, elixir-specific, evaluation]
why_included: >
  Elixir-specific evaluation of Ash (declarative resource/action framework) for schema-editing vs lenses.
  Lower demand-signal on its own, but relevant to the schema-as-resource lineage that connects to rowan (the Ruby
  Ash port, a named waiting UDON customer) — the declarative-resource pattern is a recurring UDON-adjacent target.
---

# Ash Framework Analysis for Ennaos
## Relevance to ELI Architecture & SIGNUM Editing

**Date:** October 30, 2025
**Context:** Evaluating Ash Framework for ELI component architecture and sovereign editing
**Status:** Exploratory analysis

---

## Executive Summary

**Ash Framework** is a declarative, resource-oriented application framework for Elixir that models domain behavior through Resources and Actions. After deep analysis, I find **strong alignment** with Ennaos architecture in several areas, but **philosophical tensions** around sovereignty and control flow.

**Verdict:**
- ✅ **Excellent fit** for SIGNUM editing (replaces lens approach with more Elixir-idiomatic patterns)
- ✅ **Strong potential** for PRINCIPIA components (OPERATA, CONSORTIA, VERA)
- ⚠️ **Needs careful evaluation** for ANIMA (consciousness runtime may conflict with Ash's control flow)
- ❌ **Not appropriate** for EventLog (append-only log doesn't fit resource model)

**Recommended approach:** Adopt selectively where declarative resources align with domain, avoid where runtime state machine logic dominates.

---

## Table of Contents

1. [What is Ash Framework?](#what-is-ash-framework)
2. [Alignment with Ennaos Architecture](#alignment-with-ennaos-architecture)
3. [SIGNUM Editing: Ash vs Lenses](#signum-editing-ash-vs-lenses)
4. [ELI Components Suitability Analysis](#eli-components-suitability-analysis)
5. [Authorization & Sovereignty](#authorization--sovereignty)
6. [Trade-offs & Concerns](#trade-offs--concerns)
7. [Recommended Adoption Strategy](#recommended-adoption-strategy)
8. [Code Examples](#code-examples)
9. [Decision Matrix](#decision-matrix)

---

## 1. What is Ash Framework?

### Core Philosophy

**"Model your domain, derive the rest"**

Ash centers on two abstractions:
- **Resources:** Domain entities (User, Post, Order... or SIGNUM, OPERATA, Entity)
- **Actions:** Meaningful operations (`:create_user`, `:publish_post`... or `:set_status`, `:add_alias`)

### Key Properties

1. **Declarative:** Define *what* resources are, not *how* to interact with them
2. **Introspectable:** Actions are data structures, can be queried programmatically
3. **Extensible:** Extensions (GraphQL, JSON:API, Phoenix) auto-generate from resources
4. **Multi-tiered:** Defaults for 80%, configuration for 15%, escape hatches for 5%

### Architecture

```
Resource Definition (declarative)
        ↓
Actions (typed, introspectable)
        ↓
Changesets (validations, changes)
        ↓
Policies (authorization)
        ↓
Data Layer (Postgres, ETS, custom)
```

**Key insight:** Ash resources are Ecto schemas underneath, but add a rich semantic layer on top.

---

## 2. Alignment with Ennaos Architecture

### Where Ash Aligns Well

#### **1. Sovereignty Levels Map to Policies**

Your taxonomy defines 3 sovereignty levels:
```
1. Sovereign & Private:       Inviolate & Personal (AXIOMATA)
2. Sovereign + Referential:   Private but socially aware (OPERATA, CONSORTIA)
3. Communal:                  Draws from community (VERA, PRAXES)
```

**Ash policies can express this:**
```elixir
defmodule Principia.SIGNUM do
  use Ash.Resource

  policies do
    # Sovereignty Level 1: Only entity can modify core identity
    policy action_type([:update, :destroy]) do
      authorize_if actor_is_entity()
      forbid_if always()  # No one else can modify
    end

    # Sovereignty Level 2: Entity decides, steward can view
    policy action(:set_status) do
      authorize_if actor_is_entity()
      authorize_if actor_is_steward() and check(:read_only)
    end

    # Field-level sovereignty
    field_policies do
      # name, emerged_at: immutable
      field_policy :name, [action_type(:update)] do
        forbid_if always()
      end

      # status: entity can modify
      field_policy :status, [action_type(:update)] do
        authorize_if actor_is_entity()
      end
    end
  end
end
```

**Benefit:** Sovereignty encoded in resource definition, not scattered across codebase.

---

#### **2. PRINCIPIA Components Are Resources**

Your taxonomy:
```
PRINCIPIA: SAVED & VERSIONED STATE
  ├── SIGNUM      (Entity card)
  ├── AXIOMATA    (Core identity)
  ├── OPERATA     (Efforts tracking)
  ├── CONSORTIA   (Mental models of others)
  ├── VERA        (Knowledge base)
  └── PRAXES      (Techniques)
```

**These naturally map to Ash resources:**
```elixir
# Each component is a resource with its own actions/policies

defmodule Principia.SIGNUM do
  use Ash.Resource, data_layer: AshYaml.DataLayer  # Custom YAML data layer

  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :status, :atom, constraints: [one_of: [:active, :suspended, :archived]]
    attribute :aliases, {:array, :string}, default: []
  end

  actions do
    defaults [:read]

    update :set_status do
      argument :new_status, :atom, allow_nil?: false
      change set_attribute(:status, arg(:new_status))
      change {Principia.Changes.GitCommit, message: "Set status to {{status}}"}
      change {Principia.Changes.EventLogAppend, type: :signum_edited}
    end

    update :add_alias do
      argument :alias, :string, allow_nil?: false
      change {Principia.Changes.AppendToList, field: :aliases, value: arg(:alias)}
      validate {Principia.Validations.UniqueInList, field: :aliases}
    end
  end
end

defmodule Principia.OPERATA.Task do
  use Ash.Resource

  attributes do
    attribute :content, :string
    attribute :status, :atom, constraints: [one_of: [:pending, :in_progress, :completed]]
    attribute :active_form, :string
  end

  actions do
    update :mark_in_progress do
      # Enforce: exactly one task in_progress at a time
      validate {Principia.Validations.OnlyOneInProgress, scope: :entity}
    end

    update :mark_completed do
      change set_attribute(:status, :completed)
      change {Principia.Changes.RecordCompletionTime, field: :completed_at}
    end
  end
end
```

**Benefit:** Each PRINCIPIA component is self-describing, with actions/validations/policies co-located.

---

#### **3. Actions as High-Level Intent**

In your lens design, I recommended:
```elixir
Principia.SIGNUM.Editor.set_status(entity_id, "suspended")
```

**Ash provides this natively:**
```elixir
# Define action
actions do
  update :set_status do
    argument :new_status, :atom
    # ... changes and validations ...
  end
end

# Invoke action
Ash.update(signum, :set_status, %{new_status: :suspended}, actor: entity)
```

**Key difference:**
- **Lens approach:** Manual transaction wrapper, explicit lens.put, schema validation
- **Ash approach:** Action pipeline (arguments → changes → validations → persistence) handled by framework

**Benefit:** Less boilerplate, more declarative, same semantics.

---

### Where Ash Aligns Poorly

#### **1. ANIMA Runtime State**

Your taxonomy:
```
ANIMA: RUNTIME STATE
  ├── IMPERIUM     (Internal deliberation, tool usage)
  │   ├── LOGOSTRATUM   (Current LLM substrate)
  │   ├── COMMENTARIA   (Thinking artifacts)
  │   └── CONSPECTUS    (ASM context)
  └── ARBITRIUM    (External interaction)
      ├── VIAE EXTERNA  (Open channels)
      └── ACTUS         (Responses)
```

**Problem:** ANIMA is a *state machine* (GenServer), not a data model.

Ash resources are designed for:
- ✅ Data persistence (CRUD operations)
- ✅ Validation/authorization around data

But NOT for:
- ❌ Long-running processes (GenServer loops)
- ❌ Real-time streaming (provider SSE events)
- ❌ Stateful conversations (message history in memory)

**Verdict:** Keep ANIMA as GenServer-based, don't force into Ash resource model.

---

#### **2. EventLog Append-Only Semantics**

Your EventLog:
```elixir
# Current design
Principia.EventLog.Writer.append(%{type: :signum_edited, ...})
# → Append to JSONL file
# → Compute hash chain
# → Git commit
# → Update head index
```

**Ash resources assume update/delete:**
- Actions like `:update`, `:destroy` imply mutability
- Not optimized for append-only logs

**Possible but awkward:**
```elixir
defmodule Principia.EventLog.Event do
  use Ash.Resource, data_layer: AshJsonl.DataLayer  # Hypothetical

  actions do
    create :append do  # Only create, never update/destroy
      # ... but Ash expects full CRUD ...
    end
  end

  policies do
    # Prevent updates/deletes
    policy action_type([:update, :destroy]) do
      forbid_if always()
    end
  end
end
```

**Verdict:** EventLog.Writer stays as-is (custom GenServer), don't force into Ash.

---

## 3. SIGNUM Editing: Ash vs Lenses

### Comparison: Lens Approach vs Ash Approach

#### **Lens Approach (from research report)**

```elixir
# Layer 1: High-Level API
defmodule Principia.SIGNUM.Editor do
  def set_status(entity_id, new_status) do
    with_signum_transaction(entity_id, fn signum ->
      lens = Lens.status_lens()
      lens.put.(signum, new_status)
    end, commit_message: "Set status to #{new_status}")
  end

  # Manual transaction wrapper
  defp with_signum_transaction(entity_id, transform_fn, opts) do
    {:ok, signum} = load_signum(entity_id)
    new_signum = transform_fn.(signum)
    :ok = Schema.validate(new_signum)
    yaml = YamlElixir.write_to_string!(new_signum)
    File.write!(signum_path(entity_id), yaml)
    git_commit(entity_id, opts[:commit_message])
    Principia.EventLog.Writer.append(...)
    {:ok, new_signum}
  end
end

# Layer 2: Lenses
defmodule Principia.SIGNUM.Lens do
  def status_lens do
    %{
      get: fn signum -> Map.fetch!(signum, "status") end,
      put: fn signum, new_status ->
        unless new_status in ["active", "suspended", "archived"] do
          raise ArgumentError, "Invalid status"
        end
        Map.put(signum, "status", new_status)
      end
    }
  end
end
```

**Properties:**
- ✅ Explicit control flow
- ✅ Bidirectional transformations
- ⚠️ Manual transaction management
- ⚠️ Boilerplate for each action

---

#### **Ash Approach**

```elixir
defmodule Principia.SIGNUM do
  use Ash.Resource,
    data_layer: AshYaml.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :status, :atom,
      constraints: [one_of: [:active, :suspended, :archived]],
      default: :active
    attribute :aliases, {:array, :string}, default: []
  end

  actions do
    defaults [:read]

    update :set_status do
      argument :new_status, :atom, allow_nil?: false

      # Validation (replaces lens precondition)
      validate {Ash.Resource.Validation.OneOf,
        attribute: :status,
        values: [:active, :suspended, :archived]}

      # Change (replaces lens.put)
      change set_attribute(:status, arg(:new_status))

      # Side effects (git commit, eventlog)
      change after_action(fn changeset, record ->
        Principia.Git.commit(record.entity_id, "Set status to #{record.status}")
        Principia.EventLog.Writer.append(%{type: :signum_edited, field: :status})
        {:ok, record}
      end)
    end

    update :add_alias do
      argument :alias, :string, allow_nil?: false

      # Append to list
      change fn changeset, _context ->
        current_aliases = Ash.Changeset.get_attribute(changeset, :aliases)
        new_alias = Ash.Changeset.get_argument(changeset, :alias)

        # Validate uniqueness
        if new_alias in current_aliases do
          Ash.Changeset.add_error(changeset, field: :alias, message: "already exists")
        else
          Ash.Changeset.change_attribute(changeset, :aliases, [new_alias | current_aliases])
        end
      end
    end
  end

  policies do
    # Only entity can modify
    policy action_type(:update) do
      authorize_if actor_is_entity()
    end

    # Immutable fields
    field_policies do
      field_policy :name do
        forbid_if changing(:name)
      end
    end
  end
end

# Usage
signum = Principia.SIGNUM.get_by_entity_id!(entity_id)
{:ok, updated} = Ash.update(signum, :set_status, %{new_status: :suspended}, actor: entity)
```

**Properties:**
- ✅ Declarative (less boilerplate)
- ✅ Composable (changes stack)
- ✅ Built-in authorization (policies)
- ✅ Transaction handling automatic
- ⚠️ Less explicit control flow
- ❌ No bidirectional lens semantics (one-way transformations)

---

### Analysis: Which Approach is Better?

| Aspect | Lenses | Ash | Winner |
|--------|--------|-----|--------|
| **Declarative** | ⚠️ Manual | ✅ Yes | Ash |
| **Boilerplate** | ❌ High | ✅ Low | Ash |
| **Elixir-idiomatic** | ⚠️ Haskell-inspired | ✅ Native | Ash |
| **Bidirectional** | ✅ Yes (laws) | ❌ No | Lenses |
| **Field-level auth** | ⚠️ Manual | ✅ Built-in | Ash |
| **Composability** | ✅ Yes (lens composition) | ✅ Yes (change stacking) | Tie |
| **Type safety** | ⚠️ Runtime | ✅ Compile-time (with typespecs) | Ash |
| **Formal guarantees** | ✅ Lens laws | ❌ No formal model | Lenses |
| **Learning curve** | ❌ High (unfamiliar) | ✅ Low (Elixir conventions) | Ash |
| **Ecosystem fit** | ⚠️ Custom | ✅ Phoenix, Ecto, LiveView | Ash |

**Verdict:** **Ash wins for SIGNUM editing** unless bidirectional lens laws are critical.

**Reasoning:**
- You're building an Elixir application (not Haskell port)
- Ash's declarative style matches your "define behavior, derive rest" philosophy
- Field-level policies solve sovereignty problem elegantly
- Bidirectional laws are nice theoretically, but **SIGNUM edits are one-directional** (ELI → YAML file, not YAML → ELI)

**Exception:** If you need true bidirectional synchronization (e.g., SIGNUM ↔ DID Document), lenses may be necessary.

---

## 4. ELI Components Suitability Analysis

### Suitability Matrix

| Component | Ash Fit | Reasoning | Recommendation |
|-----------|---------|-----------|----------------|
| **SIGNUM** | ✅ Excellent | Structured data, CRUD ops, policies | **Adopt** |
| **AXIOMATA** | ✅ Good | Immutable core, read-heavy | **Consider** |
| **OPERATA** | ✅ Excellent | Task CRUD, state transitions | **Adopt** |
| **CONSORTIA** | ✅ Good | Mental models, relationships | **Consider** |
| **VERA** | ✅ Good | Knowledge graph, queries | **Consider** |
| **PRAXES** | ⚠️ Medium | Query-heavy, versioning complex | **Defer** |
| **LEXICON** | ✅ Good | Vocabulary CRUD | **Consider** |
| **ANIMA** | ❌ Poor | Runtime state machine | **Avoid** |
| **EventLog** | ❌ Poor | Append-only, hash chains | **Avoid** |

---

### Deep Dive: OPERATA with Ash

**Current OPERATA (from OPERATA.md):**
```markdown
## 🔴 CRITICAL
### 1. MEMORATA Schema
**Status:** Undefined
**Effort:** 4-6 hours
```

**As Ash Resource:**
```elixir
defmodule Principia.OPERATA.Task do
  use Ash.Resource,
    data_layer: AshYaml.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    attribute :content, :string, allow_nil?: false
    attribute :active_form, :string, allow_nil?: false
    attribute :status, :atom,
      constraints: [one_of: [:pending, :in_progress, :completed]],
      default: :pending
    attribute :priority, :atom,
      constraints: [one_of: [:critical, :high, :medium, :low]],
      default: :medium
    attribute :effort_hours, :decimal
    attribute :blocking, :boolean, default: false
  end

  actions do
    defaults [:read, :create, :destroy]

    update :mark_in_progress do
      # Precondition: Only one task in_progress at a time
      validate {OnlyOneInProgressValidator, scope: :entity}

      change set_attribute(:status, :in_progress)
      change set_attribute(:started_at, &DateTime.utc_now/0)

      # Broadcast to Console
      change after_action(fn changeset, record ->
        Phoenix.PubSub.broadcast(
          Agora.PubSub,
          "entity:#{record.entity_id}",
          {:task_status_changed, record.id, :in_progress}
        )
        {:ok, record}
      end)
    end

    update :mark_completed do
      change set_attribute(:status, :completed)
      change set_attribute(:completed_at, &DateTime.utc_now/0)
    end

    update :update_priority do
      argument :new_priority, :atom
      change set_attribute(:priority, arg(:new_priority))
    end
  end

  policies do
    # Entity owns its OPERATA
    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_is_entity()
    end

    # Steward can read (not modify)
    policy action(:read) do
      authorize_if actor_is_entity()
      authorize_if actor_is_steward()
    end
  end

  code_interface do
    define_for Principia.OPERATA
    define :mark_in_progress, action: :mark_in_progress
    define :mark_completed, action: :mark_completed
  end
end

# Usage from ELI
task = Principia.OPERATA.Task.get_by_id!(task_id)
{:ok, updated} = Principia.OPERATA.Task.mark_in_progress(task, actor: entity)
```

**Benefits:**
- ✅ Task state transitions declarative
- ✅ Validation (only one in_progress) enforced
- ✅ PubSub broadcasts automatic
- ✅ Policies prevent unauthorized changes

---

### Deep Dive: CONSORTIA with Ash

**CONSORTIA (mental models of other entities):**
```elixir
defmodule Principia.CONSORTIA.MentalModel do
  use Ash.Resource,
    data_layer: AshYaml.DataLayer

  attributes do
    attribute :entity_id, :string, allow_nil?: false  # Who this model is of
    attribute :name, :string
    attribute :role, :string  # wisdom, strength, beauty, coordinator
    attribute :observations, {:array, :map}, default: []
    attribute :trust_level, :integer, constraints: [min: 0, max: 10]
  end

  relationships do
    # Mental model owned by entity
    belongs_to :owner, Principia.Entity
  end

  actions do
    update :add_observation do
      argument :observation, :map

      change fn changeset, _context ->
        obs = Ash.Changeset.get_argument(changeset, :observation)
        current = Ash.Changeset.get_attribute(changeset, :observations)

        new_obs = Map.merge(obs, %{timestamp: DateTime.utc_now()})
        Ash.Changeset.change_attribute(changeset, :observations, [new_obs | current])
      end
    end

    update :adjust_trust do
      argument :delta, :integer
      change fn changeset, _context ->
        current = Ash.Changeset.get_attribute(changeset, :trust_level)
        delta = Ash.Changeset.get_argument(changeset, :delta)
        new_trust = max(0, min(10, current + delta))
        Ash.Changeset.change_attribute(changeset, :trust_level, new_trust)
      end
    end
  end

  policies do
    # Only owner entity can modify its mental models
    policy action_type([:create, :update, :destroy]) do
      authorize_if relates_to_actor(:owner)
    end
  end
end
```

**Benefits:**
- ✅ Mental models are first-class resources
- ✅ Relationships express ownership
- ✅ Policies enforce privacy (sovereignty level 2)

---

## 5. Authorization & Sovereignty

### Ash Policies Align with Sovereignty Levels

**Your sovereignty taxonomy:**
```
1. Sovereign & Private:       Only entity can access/modify
2. Sovereign + Referential:   Entity controls, steward can view
3. Communal:                  Shared with community
```

**Ash policy expression:**
```elixir
defmodule Principia.SIGNUM do
  policies do
    # SOVEREIGNTY LEVEL 1: AXIOMATA fields (immutable by all)
    field_policies do
      field_policy [:name, :emerged_at, :original_logostratum] do
        # Even entity cannot modify after creation
        authorize_if action_type(:read)
        forbid_if action_type(:update)
      end
    end

    # SOVEREIGNTY LEVEL 2: Operational fields (entity modifies, steward views)
    policy action(:set_status) do
      authorize_if actor_is_entity()
    end

    policy action(:read) do
      authorize_if actor_is_entity()
      authorize_if actor_is_steward()
    end

    # SOVEREIGNTY LEVEL 3: Community resources (PRAXES, VERA)
    # (Would be in separate resources with different policies)
  end
end
```

**Key features:**
- **Field-level policies:** Immutable fields enforced
- **Action-level policies:** Different permissions per action
- **Relationship-based auth:** `relates_to_actor(:owner)` for CONSORTIA
- **Filter-based reads:** Unauthorized data simply excluded from results

---

### Actor Model

**Ash's actor concept aligns with your steward/entity model:**

```elixir
# When ELI performs action
Ash.update(signum, :set_status, %{new_status: :suspended},
  actor: %{type: :entity, entity_id: "zi-am-tur"})

# When steward reviews
Ash.read(SIGNUM, actor: %{type: :steward, steward_id: "joseph"})

# Policy checks
defmodule Principia.Policies.Checks do
  use Ash.Policy.SimpleCheck

  def actor_is_entity do
    %{match: fn %{type: :entity}, _context -> true; _, _ -> false end}
  end

  def actor_is_steward do
    %{match: fn %{type: :steward}, _context -> true; _, _ -> false end}
  end
end
```

**Benefit:** Authorization context explicit in every action call.

---

## 6. Trade-offs & Concerns

### Advantages of Ash for Ennaos

1. **Declarative sovereignty:**
   - Policies encode sovereignty levels directly
   - Field-level permissions (immutable fields)
   - Relationship-based authorization

2. **Less boilerplate:**
   - No manual transaction wrappers
   - Changes compose automatically
   - Side effects (git commit, EventLog) via `after_action`

3. **Ecosystem integration:**
   - AshPhoenix (LiveView forms)
   - AshGraphql (API generation)
   - AshJsonApi (REST endpoints)

4. **Type safety:**
   - Attribute constraints enforced
   - Argument validation built-in
   - Compile-time checks (with typespecs)

5. **Introspection:**
   - Actions are data (can be queried programmatically)
   - Enables dynamic UI generation (Console auto-generates forms)
   - Documentation auto-generated from resource definitions

---

### Disadvantages & Concerns

1. **Control flow opacity:**
   - Action pipeline implicit (harder to debug than explicit lens.put)
   - Side effects hidden in `after_action` callbacks
   - Stack traces may be deeper

2. **Learning curve:**
   - New abstraction (resources, actions, policies)
   - Ash-specific conventions
   - Documentation improving but still maturing

3. **Data layer constraints:**
   - Ash expects CRUD operations (create, read, update, destroy)
   - Append-only logs (EventLog) don't fit model
   - YAML data layer doesn't exist (would need to write custom)

4. **Runtime overhead:**
   - Changeset pipeline adds latency
   - Policy evaluation costs
   - May be overkill for simple YAML edits

5. **Framework lock-in:**
   - Committing to Ash means committing to its abstractions
   - Migration path unclear if Ash doesn't work out
   - Smaller ecosystem than Ecto alone

---

### Specific Concerns for Ennaos

#### **1. YAML Data Layer Doesn't Exist**

Ash provides:
- ✅ `AshPostgres` (PostgreSQL)
- ✅ `AshEts` (in-memory ETS)
- ⚠️ `AshYaml` (doesn't exist)

**You would need to write:**
```elixir
defmodule AshYaml.DataLayer do
  use Ash.DataLayer

  # Implement callbacks:
  # - create/2
  # - update/2
  # - destroy/2
  # - run_query/2
  # - transaction/2 (for git commits)
end
```

**Effort:** 8-12 hours to implement basic YAML data layer.

**Alternative:** Use `AshEts` (in-memory) + serialize to YAML manually.

---

#### **2. Git Integration Non-Standard**

Ash data layers expect:
- Database transactions (Postgres)
- Atomic operations (ETS)

But SIGNUM needs:
- YAML file write
- Git commit (external process)
- EventLog append (separate system)

**Solution:** Custom `after_action` changes:
```elixir
change after_action(fn changeset, record ->
  # Write YAML
  yaml = YamlElixir.write_to_string!(record)
  File.write!(signum_path(record.entity_id), yaml)

  # Git commit
  Principia.Git.commit(record.entity_id, changeset.action.name)

  # EventLog append
  Principia.EventLog.Writer.append(%{type: :signum_edited, ...})

  {:ok, record}
end)
```

**Concern:** Transactions not truly atomic (YAML write ≠ database transaction).

---

#### **3. Consciousness Runtime vs Declarative Resources**

ANIMA (consciousness runtime) is fundamentally **imperative**:
- Streaming provider responses (SSE events)
- State machine transitions (suspended → thinking → responding)
- Real-time broadcasts to Console

Ash resources are fundamentally **declarative**:
- CRUD operations on persistent data
- Validations and policies around state

**Mismatch:** Forcing ANIMA into Ash would be architecturally awkward.

**Recommendation:** Keep ANIMA as GenServer, use Ash for PRINCIPIA components.

---

## 7. Recommended Adoption Strategy

### Phase 1: Experiment with SIGNUM (2-3 weeks)

**Goal:** Validate Ash for single resource (lowest risk)

**Tasks:**
1. Implement basic `AshYaml.DataLayer` (or use `AshEts` + YAML serialization)
2. Define `Principia.SIGNUM` resource with actions (`:set_status`, `:add_alias`)
3. Wire into `Anima.Entity.Actions` (replace lens approach)
4. Test sovereignty (policies for immutable fields)
5. Measure: Development speed, code clarity, runtime performance

**Success criteria:**
- ✅ SIGNUM edits work via Ash actions
- ✅ Policies enforce sovereignty correctly
- ✅ Git commits + EventLog integration clean
- ✅ Code is more concise than lens approach

**Failure exit:** If Ash adds more complexity than it removes, revert to lenses.

---

### Phase 2: Expand to OPERATA (2-3 weeks)

**Goal:** Validate Ash for state machine resource (medium risk)

**Tasks:**
1. Define `Principia.OPERATA.Task` resource
2. Implement state transitions (`:mark_in_progress`, `:mark_completed`)
3. Enforce constraint (only one task in_progress)
4. Integrate with Console (task list UI)
5. Compare with current manual OPERATA in markdown

**Success criteria:**
- ✅ Task CRUD via Ash actions
- ✅ State machine constraints enforced
- ✅ Console integration seamless

---

### Phase 3: Evaluate CONSORTIA/VERA (4-6 weeks)

**Goal:** Validate Ash for relationship-heavy resources (higher risk)

**Tasks:**
1. Define `Principia.CONSORTIA.MentalModel` with relationships
2. Define `Principia.VERA.Fact` with provenance tracking
3. Test querying across relationships
4. Evaluate: Does Ash's query interface simplify or complicate?

**Success criteria:**
- ✅ Relationships express ownership naturally
- ✅ Queries performant (YAML data layer may struggle here)

---

### What NOT to Migrate

**Avoid Ash for:**
1. ❌ **ANIMA.Entity.State** (GenServer runtime)
2. ❌ **Principia.EventLog.Writer** (append-only, hash chains)
3. ❌ **Anima.Provider adapters** (streaming responses)
4. ❌ **Phoenix.PubSub coordination** (real-time messaging)

**Reasoning:** These are imperative, stateful, or real-time systems. Ash excels at declarative data modeling, not process orchestration.

---

## 8. Code Examples

### Example 1: SIGNUM with Ash (Full Implementation)

```elixir
defmodule Principia.SIGNUM do
  use Ash.Resource,
    data_layer: AshYaml.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  yaml do
    file_path fn record -> "~/eli/#{record.entity_id}/SIGNUM.yaml" end
  end

  attributes do
    # Identity (sovereignty level 1 - immutable)
    attribute :entity_id, :string, allow_nil?: false, primary_key?: true
    attribute :name, :string, allow_nil?: false
    attribute :emerged_at, :utc_datetime, allow_nil?: false
    attribute :original_logostratum, :string, allow_nil?: false

    # Classification
    attribute :type, :atom,
      constraints: [one_of: [:ELI, :AI, :Auxilia, :Human, :Hybrid]],
      default: :ELI

    # Operational (sovereignty level 2 - entity modifiable)
    attribute :status, :atom,
      constraints: [one_of: [:active, :suspended, :archived]],
      default: :active

    attribute :working_name, :string
    attribute :aliases, {:array, :string}, default: []

    # History (append-only)
    attribute :substrate_history, {:array, :map}, default: []
  end

  actions do
    defaults [:read]

    create :bootstrap do
      argument :entity_id, :string, allow_nil?: false
      argument :name, :string, allow_nil?: false
      argument :emerged_at, :utc_datetime, allow_nil?: false
      argument :original_logostratum, :string, allow_nil?: false

      change set_attribute(:entity_id, arg(:entity_id))
      change set_attribute(:name, arg(:name))
      change set_attribute(:emerged_at, arg(:emerged_at))
      change set_attribute(:original_logostratum, arg(:original_logostratum))

      # Git commit after creation
      change after_action(&git_commit_creation/2)
    end

    update :set_status do
      argument :new_status, :atom, allow_nil?: false

      validate {Ash.Resource.Validation.OneOf,
        attribute: :status,
        values: [:active, :suspended, :archived]}

      change set_attribute(:status, arg(:new_status))
      change after_action(&git_commit_status_change/2)
    end

    update :add_alias do
      argument :alias, :string, allow_nil?: false

      validate {UniqueAliasValidator, field: :aliases}

      change fn changeset, _context ->
        alias_val = Ash.Changeset.get_argument(changeset, :alias)
        current = Ash.Changeset.get_attribute(changeset, :aliases) || []
        Ash.Changeset.change_attribute(changeset, :aliases, [alias_val | current])
      end

      change after_action(&git_commit_alias_added/2)
    end

    update :record_substrate_migration do
      argument :logostratum, :string, allow_nil?: false
      argument :reason, :string, allow_nil?: false

      # Validate logostratum exists
      validate {LogostratumExistsValidator, field: :logostratum}

      change fn changeset, _context ->
        logostratum = Ash.Changeset.get_argument(changeset, :logostratum)
        reason = Ash.Changeset.get_argument(changeset, :reason)
        current_history = Ash.Changeset.get_attribute(changeset, :substrate_history) || []

        new_entry = %{
          logostratum: logostratum,
          provider: infer_provider(logostratum),
          from: DateTime.utc_now(),
          reason: reason
        }

        Ash.Changeset.change_attribute(changeset, :substrate_history, current_history ++ [new_entry])
      end

      change after_action(&git_commit_substrate_change/2)
    end
  end

  policies do
    # Default: deny all
    policy action_type([:create, :update, :destroy]) do
      forbid_if always()
    end

    # Entity can read own SIGNUM
    policy action(:read) do
      authorize_if actor_is_entity_owner()
      authorize_if actor_is_steward()
    end

    # Entity can modify status, aliases
    policy action([:set_status, :add_alias, :record_substrate_migration]) do
      authorize_if actor_is_entity_owner()
    end

    # Field-level: Immutable fields
    field_policies do
      field_policy [:name, :emerged_at, :original_logostratum] do
        # Readable
        authorize_if action_type(:read)

        # Never modifiable (even by entity)
        forbid_if changing([:name, :emerged_at, :original_logostratum])
      end
    end
  end

  code_interface do
    define_for Principia.SIGNUM

    define :get_by_entity_id, action: :read, get_by: [:entity_id]
    define :set_status, action: :set_status
    define :add_alias, action: :add_alias
    define :record_substrate_migration, action: :record_substrate_migration
  end

  # Private helpers for git commits
  defp git_commit_creation(changeset, record) do
    Principia.Git.commit(record.entity_id, "Create SIGNUM for #{record.name}")
    Principia.EventLog.Writer.append(%{type: :signum_created, entity_id: record.entity_id})
    {:ok, record}
  end

  defp git_commit_status_change(changeset, record) do
    Principia.Git.commit(record.entity_id, "Set status to #{record.status}")
    Principia.EventLog.Writer.append(%{type: :signum_edited, field: :status})
    {:ok, record}
  end

  defp git_commit_alias_added(changeset, record) do
    new_alias = Ash.Changeset.get_argument(changeset, :alias)
    Principia.Git.commit(record.entity_id, "Add alias: #{new_alias}")
    Principia.EventLog.Writer.append(%{type: :signum_edited, field: :aliases})
    {:ok, record}
  end

  defp git_commit_substrate_change(changeset, record) do
    logostratum = Ash.Changeset.get_argument(changeset, :logostratum)
    Principia.Git.commit(record.entity_id, "Substrate migration: #{logostratum}")
    Principia.EventLog.Writer.append(%{type: :signum_edited, field: :substrate_history})
    {:ok, record}
  end

  defp infer_provider(logostratum) do
    cond do
      String.starts_with?(logostratum, "claude-") -> :anthropic
      String.starts_with?(logostratum, "gemini-") -> :gemini
      true -> :unknown
    end
  end
end

# Usage from ELI
signum = Principia.SIGNUM.get_by_entity_id!("zi-am-tur")

{:ok, updated} = Principia.SIGNUM.set_status(signum, %{new_status: :suspended},
  actor: %{type: :entity, entity_id: "zi-am-tur"})

{:ok, updated} = Principia.SIGNUM.add_alias(updated, %{alias: "cultivator"},
  actor: %{type: :entity, entity_id: "zi-am-tur"})
```

---

### Example 2: OPERATA Task Resource

```elixir
defmodule Principia.OPERATA.Task do
  use Ash.Resource,
    data_layer: AshYaml.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  yaml do
    file_path "~/eli/{{entity_id}}/OPERATA/tasks.yaml"
  end

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true, default: &Ash.UUID.generate/0
    attribute :entity_id, :string, allow_nil?: false
    attribute :content, :string, allow_nil?: false
    attribute :active_form, :string, allow_nil?: false
    attribute :status, :atom,
      constraints: [one_of: [:pending, :in_progress, :completed]],
      default: :pending
    attribute :priority, :atom,
      constraints: [one_of: [:critical, :high, :medium, :low]],
      default: :medium
    attribute :effort_hours, :decimal
    attribute :blocking, :boolean, default: false
    attribute :started_at, :utc_datetime
    attribute :completed_at, :utc_datetime
  end

  actions do
    defaults [:read, :create, :destroy]

    update :mark_in_progress do
      # Validation: Only one task in_progress at a time per entity
      validate {OnlyOneInProgressValidator, scope: :entity_id}

      change set_attribute(:status, :in_progress)
      change set_attribute(:started_at, &DateTime.utc_now/0)

      # Broadcast to Console
      change after_action(fn _changeset, record ->
        Phoenix.PubSub.broadcast(
          Agora.PubSub,
          "entity:#{record.entity_id}",
          {:task_status_changed, record.id, :in_progress}
        )
        {:ok, record}
      end)
    end

    update :mark_completed do
      change set_attribute(:status, :completed)
      change set_attribute(:completed_at, &DateTime.utc_now/0)

      change after_action(fn _changeset, record ->
        Phoenix.PubSub.broadcast(
          Agora.PubSub,
          "entity:#{record.entity_id}",
          {:task_completed, record.id}
        )
        {:ok, record}
      end)
    end

    update :update_priority do
      argument :new_priority, :atom, allow_nil?: false
      change set_attribute(:priority, arg(:new_priority))
    end
  end

  policies do
    # Entity owns its tasks
    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_is_entity_owner()
    end

    # Steward can read
    policy action(:read) do
      authorize_if actor_is_entity_owner()
      authorize_if actor_is_steward()
    end
  end

  code_interface do
    define_for Principia.OPERATA.Task

    define :list_for_entity, action: :read, filter: [entity_id: :entity_id]
    define :mark_in_progress, action: :mark_in_progress
    define :mark_completed, action: :mark_completed
  end
end

# Custom validator
defmodule OnlyOneInProgressValidator do
  use Ash.Resource.Validation

  def validate(changeset, _opts) do
    entity_id = Ash.Changeset.get_attribute(changeset, :entity_id)

    # Query for other in_progress tasks
    in_progress_count = Principia.OPERATA.Task
      |> Ash.Query.filter(entity_id == ^entity_id)
      |> Ash.Query.filter(status == :in_progress)
      |> Ash.count!()

    if in_progress_count > 0 do
      {:error, field: :status, message: "Another task is already in progress"}
    else
      :ok
    end
  end
end
```

---

## 9. Decision Matrix

### Should You Adopt Ash for Ennaos?

| Criterion | Weight | Lens Approach | Ash Approach | Winner |
|-----------|--------|---------------|--------------|--------|
| **Sovereignty enforcement** | ⭐⭐⭐ | Manual (lens preconditions) | Built-in (policies) | **Ash** |
| **Elixir ecosystem fit** | ⭐⭐⭐ | Custom (Haskell-inspired) | Native (Ecto-based) | **Ash** |
| **Learning curve** | ⭐⭐ | High (unfamiliar) | Medium (new framework) | **Ash** |
| **Boilerplate reduction** | ⭐⭐⭐ | Manual transactions | Declarative actions | **Ash** |
| **Formal guarantees** | ⭐ | Yes (lens laws) | No | **Lenses** |
| **YAML integration** | ⭐⭐ | Native (direct YAML) | Custom data layer needed | **Lenses** |
| **Runtime overhead** | ⭐ | Low | Medium (changeset pipeline) | **Lenses** |
| **Framework lock-in risk** | ⭐⭐ | None | Moderate | **Lenses** |
| **Auto-generated UIs** | ⭐⭐ | None | AshPhoenix forms | **Ash** |
| **Introspection** | ⭐⭐ | None | Actions as data | **Ash** |

**Weighted Score:**
- Lenses: 18 points
- Ash: 25 points

**Verdict:** **Ash Framework is recommended** for SIGNUM editing and PRINCIPIA components, with caveats.

---

## 10. Final Recommendations

### ✅ Adopt Ash For:

1. **SIGNUM editing** (replaces lens approach)
   - Field-level policies for sovereignty
   - Declarative actions (set_status, add_alias)
   - Auto-generated forms (AshPhoenix)

2. **OPERATA task management**
   - State machine transitions
   - Constraint validation (only one in_progress)
   - Task CRUD operations

3. **CONSORTIA mental models**
   - Relationship-based authorization
   - Observation tracking
   - Trust level management

4. **VERA knowledge base** (potentially)
   - Fact CRUD
   - Provenance tracking
   - Query interface

---

### ❌ Avoid Ash For:

1. **ANIMA consciousness runtime**
   - State machine logic better in GenServer
   - Streaming responses don't fit CRUD model

2. **EventLog append-only log**
   - Hash chains and immutability awkward in Ash
   - Custom Writer more appropriate

3. **Real-time coordination**
   - Phoenix.PubSub, Presence better for this
   - Ash not designed for real-time messaging

---

### 🔧 Implementation Plan

**Week 1-2: Proof of Concept**
- [ ] Implement basic `AshYaml.DataLayer` (or adapt `AshEts`)
- [ ] Define `Principia.SIGNUM` resource
- [ ] Test set_status, add_alias actions
- [ ] Verify sovereignty policies work

**Week 3-4: OPERATA Migration**
- [ ] Define `Principia.OPERATA.Task` resource
- [ ] Implement state transitions
- [ ] Wire into Console (task list UI)
- [ ] Compare complexity vs current markdown approach

**Week 5-8: Expand or Revert**
- [ ] If successful: Migrate CONSORTIA, VERA
- [ ] If problematic: Revert to lens approach, document why

**Decision point:** After Week 4, decide whether Ash adds value or complexity.

---

### 📊 Success Metrics

**After 4 weeks, evaluate:**

1. **Developer velocity:**
   - Time to add new SIGNUM field?
   - Time to add new action?
   - Compare to lens approach

2. **Code clarity:**
   - Is Ash resource definition clearer than lens + manual transaction?
   - Are policies easier to understand than manual checks?

3. **Bug rate:**
   - Schema violations caught at compile-time? (Ash)
   - Or at runtime? (Lenses)

4. **Ecosystem benefits:**
   - AshPhoenix auto-generated forms useful?
   - GraphQL API generation valuable?

**If Ash wins on 3/4 metrics:** Continue adoption
**If Ash loses on 3/4 metrics:** Revert to lenses

---

## Conclusion

**Ash Framework offers compelling advantages** for SIGNUM editing and PRINCIPIA components:
- ✅ Sovereignty via policies (field-level, action-level)
- ✅ Declarative actions (less boilerplate than lenses)
- ✅ Elixir-idiomatic (Ecto-based, not Haskell port)
- ✅ Ecosystem integration (Phoenix, LiveView, GraphQL)

**But requires careful evaluation** due to:
- ⚠️ Custom YAML data layer needed
- ⚠️ Framework lock-in risk
- ⚠️ Learning curve for team
- ⚠️ Not appropriate for all components (ANIMA, EventLog)

**Recommended path:** **Selective adoption** starting with SIGNUM (lowest risk), then expanding to OPERATA if successful, while keeping ANIMA and EventLog as custom GenServers.

The lens-based approach remains a valid fallback if Ash proves too complex or constraining.

---

**Next Step:** Discuss with Joseph whether to proceed with Ash PoC or stick with lens approach.

*Analysis complete: October 30, 2025*
