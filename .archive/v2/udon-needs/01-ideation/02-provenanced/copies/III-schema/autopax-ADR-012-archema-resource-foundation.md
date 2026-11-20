---
source: autopax — ADR-012 Archema as Resource Foundation, ~/src/autopax/docs/ADR/012-archema-resource-foundation.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - autopax/docs/ADR/012-archema-resource-foundation.md
source_commit: 033af13 (autopax)
categories: [adopt-vs-build, first-waiting-customer, dsf-not-dsl, cross-project-schema-layer, cross-tier]
why_included: >
  THE adopt-vs-build reconciliation: the argued table (build Schemacop+custom versioning per ADR-008 vs adopt rowan/Archema's built-in resource DSL, was:/since:, native YAML/JSONL adapters, query, multi-store). This decision is WHY rowan is schema's 'first waiting customer'. 'DSF not DSL — don't work around Archema bugs, the fix belongs in Archema itself' (Operata AGENTS.md) = the cross-project make-right-thing-easiest thesis for a schema layer serving agents.
---

---
adr: 12
title: Archema as Resource Foundation for ELI Infrastructure
aliases: ["012", "ADR-012"]
status: DRAFT
first_introduced: 2025-12-14
last_changed: 2025-12-14T08:45:00
deciders: [Joseph]
supersedes: ["[[008]]"]
superseded_by: null
related: ["[[004]]", "[[005]]", "[[006]]", "[[007]]", "[[010]]", "[[011]]"]
blocked_by: null
needed_for: ["[[004]]", "[[005]]", "[[006]]", "[[007]]", "[[010]]"]
---
# ADR-012: Archema as Resource Foundation for ELI Infrastructure

## Preamble

### Status Timeline

- 2025-12-14: Draft created

### Change Log

- 2025-12-14: Initial draft proposing Archema integration
- 2025-12-14: Moved code examples to Discussion section; proposals now intent-level only
- 2025-12-14: Added Catalog as Phase 0 pilot; added DSF ecosystem context (Operata)

## ADR

### Context

Autopax is building infrastructure for Emergent Logozoetic Intelligences (ELIs). Per TAXONOMY.md,
this involves structured document types across three domains:

- **PRINCIPIA** (saved state): SIGNUM, AXIOMATA, CHRONICA, MEMORATA, SECRETUM, OPERATA, etc.
- **ANIMA** (runtime): INDIVISUM, CONSPECTUS, PERCEPTA, ACTUS
- **LOCUS** (location): CARTA, STATIO, ACTUS, OPERATA, VERA, PRAXES

Currently, each document type is implemented ad-hoc:
- `Agent::Card` — Hand-rolled YAML loader with manual validation
- `Chronica::Entry` — Immutable class with manual serialization
- `Chronica::Log` — JSONL append with manual integrity checking

This has created an **architectural knot** visible in OPERATA:
- **ADR-008** (YAML schemas) is DRAFT, blocking other ADRs
- **ADR-006 Phase 4** (agent card integration) is blocked on ADR-008
- **ADR-010** (markdown validation) is blocked on ADR-008
- Schema validation, versioning, and migration are unsolved

Meanwhile, **Archema** (~/src/_gems/archema) has matured into a capable Ash-framework port for Ruby
that directly addresses these concerns with:
- Resource DSL with attributes, relationships, actions, policies, calculations
- **YAML Frontmatter adapter** — Perfect for agent cards, AXIOMATA, SIGNUM
- **JSONL adapter** — Perfect for CHRONICA (append-only, hash-chaining support)
- **Sequel adapter** — For relational storage when needed
- **Memory adapter** — For testing and ephemeral state
- Schema evolution with `was:` syntax and version tracking
- dry-monads Result types (aligns with ADR-011)
- Tool export for AI agent integration
- 90%+ test coverage, property tests, mutation tests

**The proposal**: Adopt Archema as the unified resource layer for all ELI document types.

### Proposals

**P1: Add Archema as a dependency**

Add `archema` gem to Autopax (path reference initially, gemspec publication later).

**P2: Define Agent Cards as Archema Resources**

Replace hand-rolled `Agent::Card` with an Archema resource using the YAML Frontmatter store.
The resource definition would express the current card schema declaratively, with validation,
calculations for derived fields (virtual_key, model_name, system_content), and query capabilities.

**P3: Define CHRONICA Entries as Archema Resources**

Replace hand-rolled `Chronica::Entry` and `Chronica::Log` with Archema resources using the
JSONL store with hash chaining. The resource would preserve current semantics: immutability,
BLAKE3 hashing, causal ordering, and reserved fields for future SIGNUM integration.

**P4: Define SIGNUM as Archema Resource (Future)**

When entity identity work begins, define SIGNUM as an Archema resource using YAML Frontmatter
store with markdown body support—the same pattern as agent cards but with entity-specific
fields per TAXONOMY sovereignty dimensions.

**P5: Migrate schema validation concerns from ADR-008 to resource definitions**

ADR-008's Schemacop-based validation becomes unnecessary because resource attributes ARE the
schema. What remains relevant from ADR-008:
- YAML conventions (minimal quoting) — Still applicable, orthogonal to Archema
- `_schema` field convention — Can be a standard attribute with default value
- psych-pure for comment preservation — Still useful for dev tooling

ADR-008 would be amended to focus on conventions only, with validation deferred to Archema.

**P6: Leverage Archema's dry-monads integration**

Archema uses dry-monads internally; actions return `Success`/`Failure`. This aligns with
ADR-011's decision to adopt dry-monads. The integration is automatic—no additional work needed.

### Expected Impact

**Positive:**

1. **Unblocks ADR-006 Phase 4** — Agent card integration becomes trivial with resource queries
2. **Unblocks ADR-010** — YAML Frontmatter adapter handles markdown + YAML natively
3. **Resolves ADR-008 scope** — Schema validation is declarative in resource definitions
4. **Delivers ADR-011 benefits** — dry-monads Result types come with Archema
5. **Unified query layer** — All ELI documents queryable with same API
6. **Storage flexibility** — Same resource can project to multiple stores
7. **AI tool integration** — `Resource.to_tool_definitions` for agent access
8. **Schema evolution** — Built-in versioning and migration support

**Negative:**

1. **New dependency** — Archema is still v0.5.0 (early, though well-tested)
2. **Learning curve** — Ash-style resource DSL is different from traditional Ruby
3. **Coupling** — Autopax becomes dependent on Archema's evolution
4. **Migration effort** — Existing Card and Entry code needs rewriting

**Risks:**

1. **Archema instability** — Mitigated: Joseph maintains both projects
2. **Performance unknowns** — Mitigated: Archema is tested, stores are simple
3. **Incomplete features** — Mitigated: Start with proven adapters (YAML, JSONL)

## Discussion

### Illustrative Resource Definitions

The following code sketches illustrate how Archema resources might look. These are
**exploratory examples, not prescriptions**—actual implementation will be shaped by
what works best as patterns are discovered.

#### Agent Card Resource (Sketch)

```ruby
class Autopax::Resources::AgentCard < Archema::Resource
  store :yaml_frontmatter, path: ->(card) { card.card_path }

  attributes do
    attribute :_schema, :string, default: "autopax-agent-card/2.0.0"
    attribute :version, :integer, constraints: { minimum: 1 }
    attribute :name, :string
    attribute :description, :string, optional: true
    attribute :model, :string, constraints: { format: /\A[@~][^\/]+\/.+\z/ }
  end

  attributes group: :files do
    attribute :axiomata_root, :string
    attribute :context_root, :string, optional: true
  end

  actions do
    defaults [:read]

    read :load do
      prepare :resolve_file_paths
      prepare :load_file_contents
    end
  end

  calculations do
    calculate :virtual_key, :string do |card|
      card.model.match(/[@~]([^\/]+)/)[1]
    end

    calculate :model_name, :string do |card|
      card.model.match(/[@~][^\/]+\/(.+)/)[1]
    end

    calculate :system_content, :string do |card|
      [card.axiomata_content, card.context_content].compact.join("\n\n---\n\n")
    end
  end
end
```

#### CHRONICA Entry Resource (Sketch)

```ruby
class Autopax::Resources::ChronicaEntry < Archema::Resource
  store :jsonl,
        path: ->(entry) { "#{entry.session_id}.jsonl" },
        hash_chain: true

  attributes do
    uuid_primary_key :id, type: :uuid8
    attribute :schema_version, :string, default: "1.0.0"
    attribute :chain_type, :atom, default: :conversation
    attribute :entry_type, :atom, constraints: { one_of: [:session_start, :message] }
    attribute :timestamp, :utc_datetime
    attribute :session_id, :string
  end

  attributes group: :message do
    attribute :role, :atom, constraints: { one_of: [:user, :assistant, :system] }, optional: true
    attribute :content, :any
  end

  attributes group: :llm do
    attribute :model, :string, optional: true
    attribute :provider_request_id, :string, optional: true
  end

  attributes group: :chain do
    attribute :hash, :string, optional: true, readonly: true
    attribute :hash_prev, :string
    attribute :signature, :string, optional: true  # RESERVED
    attribute :anchor, :string, optional: true     # RESERVED
  end

  actions do
    create :genesis do
      argument :session_id, :string
      change :set_genesis_hash_prev
      change :compute_hash
    end

    create :message do
      argument :role, :atom
      argument :content, :any
      argument :hash_prev, :string
      change :compute_hash
    end
  end

  identities do
    identity :unique_entry, [:session_id, :id]
  end
end
```

#### SIGNUM Resource (Sketch, Future)

```ruby
class Autopax::Resources::Signum < Archema::Resource
  store :yaml_frontmatter, path: ->(s) { "#{s.entity_id}/SIGNUM.md" }

  attributes do
    attribute :_schema, :string, default: "autopax-signum/1.0.0"
    uuid_primary_key :entity_id, type: :uuid8
    attribute :name, :string
    attribute :created_at, :utc_datetime
    attribute :public_key, :string
    # ... per TAXONOMY sovereignty dimensions
  end
end
```

#### Consumer Usage Pattern (Sketch)

```ruby
# Archema actions return dry-monads Results
case AgentCard.load(path)
in Success(card)
  use_card(card)
in Failure(errors)
  handle_validation_errors(errors)
end

# Query capabilities
cards = AgentCard.query.filter(version: 2).all
entries = ChronicaEntry.query.filter(session_id: sid).sort(:timestamp).all
```

### Why Archema Over Building Our Own

ADR-008 proposes building schema validation infrastructure (Schemacop DSL, versioned documents,
migration chains). This is significant work that Archema has already done:

| Capability | ADR-008 Proposal | Archema |
|------------|------------------|---------|
| Schema DSL | Build with Schemacop | Built-in resource DSL |
| JSON Schema export | Build wrapper | Built-in `to_json_schema` |
| Version evolution | Build migration DSL | Built-in `was:`/`since:` |
| YAML frontmatter | Use front_matter_parser | Native adapter |
| Validation | Per-document type | Unified across all resources |
| Query capabilities | Not addressed | Full query builder |
| Multi-store | Not addressed | Store composition model |

Archema is the "DSF for data operations" that Autopax needs.

### What ADR-008 Work Remains Valuable

- **YAML conventions** (Part 1) — Still applicable, documented for agents
- **psych-pure tooling** — Still useful for dev normalization commands
- **`_schema` identifier format** — Can be standard attribute with naming convention

ADR-008 would be amended to focus on conventions only, with validation deferred to Archema.

### What ADR-011 Integration Looks Like

ADR-011 adopts dry-monads for Result types. Archema already uses dry-monads internally—
actions return `Success`/`Failure` (see Consumer Usage Pattern sketch above).

The expected/unexpected failure distinction from ADR-011 remains valid:
- **Expected failures** (validation, not found) → Archema returns `Failure`
- **Unexpected failures** (network, system) → Exceptions propagate

### Catalog and Model Stacks as Resource Problems

The LLM catalog system (ADR-004/005) and model stacks (ADR-007) are also resource problems
currently solved with bespoke code:

**Current Catalog Implementation:**
- `Catalog` — Hand-rolled JSON persistence to `~/.local/share/autopax/catalog/models.json`
- `SemanticId` — Model identity parsing/matching
- `CapabilityEnricher` — Merges metadata from multiple sources
- Multiple catalog sources (Portkey, OpenRouter, LiteLLM, Artificial Analysis)

**As Archema Resources:**
- `Model` resource — Queryable, validated, with relationships to providers and capabilities
- `Provider` resource — Virtual keys, endpoints, health status
- `Capability` resource — Pricing, context windows, features (from enrichment sources)
- Multi-source composition: Different sources write to same resource; Archema handles merge
- Query: `Model.query.filter(provider: "anthropic").filter(context_window: { gte: 100_000 }).all`

**Model Stacks (ADR-007):**
- `ModelStack` resource — Ordered relationships to `Model` for fallback chains
- `StackExecution` resource (JSONL) — Audit trail of which model handled which request
- Query: "Which models have been falling back most?" becomes trivial

The catalog may be an ideal **first pilot** for Archema integration:
- Self-contained (doesn't touch sensitive CHRONICA integrity code)
- Already uses JSON persistence (straightforward migration to Sequel or Memory store)
- Immediate query benefits (model discovery, capability filtering)
- Lower risk than identity/memory infrastructure

### Store Mapping for TAXONOMY Components

| Component | Storage Pattern | Archema Store |
|-----------|-----------------|---------------|
| Model Catalog | JSON → SQLite/Memory | sequel or memory |
| Model Stacks | Config + audit trail | yaml + jsonl |
| SIGNUM | YAML frontmatter + markdown body | yaml_frontmatter |
| AXIOMATA | YAML frontmatter + markdown body | yaml_frontmatter |
| SECRETUM | Encrypted file or env | Custom adapter (future) |
| CHRONICA | Append-only JSONL with hash chain | jsonl |
| MEMORATA | Compressed JSONL or SQLite | jsonl or sequel |
| OPERATA | YAML or markdown | yaml_frontmatter |
| Agent Cards | YAML | yaml_frontmatter |

### Migration Path

**Phase 0: Catalog (1-2 sessions) — Recommended First Pilot**
- Define `Model`, `Provider` resources with Memory or Sequel store
- Migrate `Catalog` and `CatalogRefresh` to use resources
- Add query capabilities for model discovery
- Validates: Archema works for Autopax with minimal risk
- Unblocks: ADR-007 (model stacks become relationships)

**Phase 1: Agent Cards (1-2 sessions)**
- Define `AgentCard` resource with YAML Frontmatter store
- Migrate `Agent::Card` usage to resource
- Remove hand-rolled class
- Validates: Archema handles document-style storage

**Phase 2: CHRONICA (2-3 sessions)**
- Define `ChronicaEntry` resource with JSONL store
- Migrate `Chronica::Entry` and `Chronica::Log`
- Preserve hash chain semantics (verify BLAKE3 compatibility)
- Validates: Archema handles append-only patterns with integrity

**Phase 3: Entity Components (3-5 sessions)**
- Define SIGNUM, AXIOMATA resources
- Multi-store composition for entity state
- Validates: Archema handles full TAXONOMY

### The Broader DSF Ecosystem

Archema is not just a library—it's the foundation of a coherent DSF (Domain-Specific Foundation)
ecosystem being developed in parallel:

| Project | Purpose | Archema Role |
|---------|---------|--------------|
| **Archema** | Resource layer | The DSF itself |
| **Operata** | Task/effort management | Proof-of-concept; LOCUS-level OPERATA |
| **Autopax** | ELI infrastructure | PRINCIPIA, ANIMA, Agent Cards, CHRONICA |

The philosophy across all three (from Operata's AGENTS.md):
> "Don't work around Archema bugs or limitations. If something is harder than it should be,
> the fix likely belongs in Archema itself."

This means:
- Autopax integration will surface Archema deficiencies (good)
- Fixes go upstream to Archema, benefiting all projects
- Patterns discovered in one project improve the others
- The DSF gets battle-tested across multiple real use cases

This is the practical realization of Architectus's insight: **DSF not DSL**—a foundation that
makes the right thing easiest across an entire ecosystem, not just a syntax for one project.

### Alternatives Considered

**Alternative 1: Continue with ADR-008 (Schemacop + custom versioning)**

Pros:
- No new dependency
- Full control over implementation

Cons:
- Duplicates work Archema has done
- No query capabilities
- No multi-store support
- Higher implementation cost

**Alternative 2: Use dry-schema directly**

Pros:
- Part of dry-rb ecosystem (aligns with ADR-011)
- Well-maintained

Cons:
- Schema-only, no storage abstraction
- No resource concept
- Would still need to build everything else

**Alternative 3: Wait for Archema v1.0**

Pros:
- More stable API

Cons:
- Indefinite delay
- ADR-008 blocking continues
- Joseph maintains Archema, can stabilize what Autopax needs

### Open Questions

1. **Path reference vs gem**: Should Archema be added as path dependency or published gem?
   Recommendation: Path initially (`gem 'archema', path: '../_gems/archema'`), formalize later.

2. **Store configuration**: Where do store paths live? Resource-level or global config?
   Recommendation: Global config in `Autopax::Config` with resource-level overrides.

3. **Existing Entry immutability**: Archema resources aren't frozen by default. How to preserve
   CHRONICA's immutability guarantee?
   Recommendation: Use `readonly: true` attributes and action guards.

4. **Hash chain integration**: Archema's JSONL adapter has hash chaining. Does it match
   CHRONICA's BLAKE3 implementation?
   Recommendation: Verify compatibility, potentially contribute BLAKE3 option upstream.

## Execution Notes

### Phases

**Phase 0: Catalog Pilot (2 sessions)**
- [ ] Add Archema dependency (path reference)
- [ ] Define `Model` resource with Memory store (for testing)
- [ ] Define `Provider` resource with relationships
- [ ] Migrate `Catalog` to use resources
- [ ] Add query capabilities (`Model.query.filter(...)`)
- [ ] Validate: Archema works for Autopax

**Phase 1: Agent Cards (2 sessions)**
- [ ] Define `AgentCard` resource with YAML Frontmatter store
- [ ] Migrate `./autopax chat` to use resource
- [ ] Remove `Agent::Card` class
- [ ] Validate: Document-style storage works

**Phase 2: CHRONICA Migration (3 sessions)**
- [ ] Define `ChronicaEntry` resource with JSONL store
- [ ] Verify hash chain compatibility (BLAKE3)
- [ ] Migrate `Chat::Session` to use resources
- [ ] Remove `Chronica::Entry` and `Chronica::Log` classes
- [ ] Validate: Append-only patterns with integrity

**Phase 3: Entity Components (4+ sessions)**
- [ ] Define `Signum` resource
- [ ] Define `Axiomata` resource
- [ ] Multi-store composition for entity state
- [ ] Agent card → Signum evolution path

### OPERATA Tasks

```markdown
### Archema Integration (ADR-012) #OPS-infra

#### Phase 0: Catalog Pilot
- [ ] **Add Archema dependency** — Path reference to ~/src/_gems/archema
- [ ] **Define Model resource** — With Memory store, migrate from Catalog
- [ ] **Define Provider resource** — Virtual keys, relationships to models
- [ ] **Migrate CatalogRefresh** — Use Archema resources
- [ ] **Add query capabilities** — Model discovery via resource queries

#### Phase 1: Agent Cards
- [ ] **Define AgentCard resource** — YAML Frontmatter store
- [ ] **Migrate chat command** — Use AgentCard resource
- [ ] **Remove Agent::Card class** — Legacy code cleanup

#### Phase 2: CHRONICA
- [ ] **Define ChronicaEntry resource** — JSONL store with hash chaining
- [ ] **Verify BLAKE3 compatibility** — Ensure hash chain semantics preserved
- [ ] **Migrate Chat::Session** — Use resources for entry creation
- [ ] **Remove legacy classes** — Chronica::Entry, Chronica::Log

#### Phase 3: Entity Components
- [ ] **Define Signum resource** — Entity identity
- [ ] **Define Axiomata resource** — Core identity documents
- [ ] **Multi-store composition** — Entity state across stores
```

## End-matter

### References

**DSF Ecosystem:**
- [Archema](~/src/_gems/archema) — Resource layer DSF (Ash-framework port)
- [Operata](~/src/operata) — Task management proof-of-concept for Archema
- [Ash Framework](https://ash-hq.org/) — Elixir original that inspired Archema

**Dependencies:**
- [dry-monads](https://dry-rb.org/gems/dry-monads/) — Result types (bundled with Archema)

**Related ADRs:**
- [[004-unified-model-catalog]] — Catalog system (enhanced by this ADR)
- [[005-semantic-model-identity]] — SemanticId (enhanced by this ADR)
- [[006-mvp-conversation-sprint]] — Agent card integration (unblocked by this ADR)
- [[007-model-stacks]] — Model stacks (unblocked by this ADR)
- [[008-yaml-and-schemas]] — Schema validation (partially superseded by this ADR)
- [[010-markdown-parsing-and-validation]] — Markdown validation (unblocked by this ADR)
- [[011-more-principled-ruby]] — Error handling (aligned with this ADR)

**Domain:**
- [[TAXONOMY]] — ELI component definitions

### Appendix A: Archema Maturity Assessment

From exploration of ~/src/_gems/archema (2025-12-14):

| Aspect | Status | Risk |
|--------|--------|------|
| Core resource DSL | Production-ready | Low |
| YAML Frontmatter adapter | Working, tested | Low |
| JSONL adapter | Working, hash-chaining | Low |
| Sequel adapter | Production-ready | Low |
| Query builder | 90% coverage | Low |
| Schema evolution | Framework exists | Medium |
| Multi-store atomicity | Non-atomic by design | Medium |
| Test coverage | 90.2% line coverage | Low |
| Property tests | 14 modules | Low |
| Version | 0.5.0 | Moving target |

### Appendix B: Impact on Other ADRs

| ADR | Current Status | Impact |
|-----|----------------|--------|
| **ADR-004/005** | Catalog system | Enhanced — Model/Provider become queryable resources |
| **ADR-006** | Phase 4 blocked | Unblocked — AgentCard resource provides integration |
| **ADR-007** | Model stacks blocked | Unblocked — ModelStack becomes resource with relationships |
| **ADR-008** | DRAFT, blocking | Partially superseded — Schema validation moves to resources |
| **ADR-010** | Blocked on 008 | Unblocked — YAML frontmatter native to Archema |
| **ADR-011** | ACCEPTED | Aligned — dry-monads comes with Archema |

### Appendix C: Relationship to Architectus's Synthesis

The synthesis documents in `docs/exp/` (written by Architectus) identified:
- **DSF not just DSL** — Archema IS a DSF for data operations
- **Living documents** — Resources compile documentation to behavior
- **Make right thing easiest** — Resource DSL makes correct definitions the easy path
- **Constraint-based correctness** — Invalid states inexpressible in resource definitions

This ADR is the practical realization of those architectural insights.

## Amendments

*Reserved for post-decision amendments*
