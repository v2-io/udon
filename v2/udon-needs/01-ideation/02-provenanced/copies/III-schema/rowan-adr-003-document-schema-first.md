---
source: rowan — ADR-003 Document-Schema-First, ~/src/rowan/docs/dev/adr-003-document-schema-first.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/docs/dev/adr-003-document-schema-first.md
source_commit: 0ecf61a (rowan)
categories: [founding-adr, document-schema-first, json-schema-superset, three-worlds-unification]
why_included: >
  The founding schema-first ADR: constraint vocabulary comes from JSON Schema (superset), NOT RDBMS limitations; Archema validation is canonical, RDBMS constraints are optional defense-in-depth projections. 'Three-worlds unification' (RDBMS + document + event-sourcing). Document stores are first-class, the MORE expressive target.
---

# ADR-003: Document-Schema-First Architecture

**Status:** Partially Implemented
**Date:** 2025-12-10
**Updated:** 2025-12-14

## Implementation Status

The core constraint vocabulary is **implemented** in `lib/archema/resource/constraints.rb`:

| Constraint | JSON Schema | Status | DSL |
|------------|-------------|--------|-----|
| `one_of` | `oneOf` | ✅ Implemented | `one_of { present :a; present :b }` |
| `any_of` | `anyOf` | ✅ Implemented | `any_of { present :a; present :b }` |
| `when_value` | `if/then/else` | ✅ Implemented | `when_value :x, :y { required :z }` |
| `dependent_required` | `dependentRequired` | ✅ Implemented | `dependent_required :x, requires: [:y]` |
| `all_of` | `allOf` | ❌ Not yet | — |
| `not_schema` | `not` | ❌ Not yet | — |

**What works today:**
- Constraint DSL in `constraints do` blocks
- Validation via `Resource.validate_constraints(attributes)`
- JSON Schema export via `Resource.constraints_to_json_schema`
- Integration with Changeset validation

**What remains:**
- `belongs_to_one_of` convenience DSL for polymorphic associations
- RDBMS projection (CHECK constraints, triggers)
- Per-constraint custom error message refinements
- See [Plan: Document Schema Constraints](../msc/plan-document-schema-constraints.md)

## Context

Traditional ORMs approach schema design from an RDBMS-first perspective:

```
RDBMS constraints → ORM abstractions → awkwardly extended to documents
```

This leads to compromises when expressing constraints that RDBMS can't natively enforce (e.g., "exactly one of these FKs must be set" for polymorphic associations). The ORM either:
1. Uses workarounds (Rails `*_type` string columns—no FK integrity)
2. Declares it impossible
3. Punts to application-level validation as an afterthought

Meanwhile, JSON Schema has had rich constraint vocabulary for years: `oneOf`, `anyOf`, `allOf`, `dependentRequired`, `if/then/else`. These constructs are well-specified and widely implemented.

## Decision

Archema adopts a **document-schema-first** architecture:

```
JSON Schema constraints (superset) → Archema DSL → projected to each store adapter
  ├─ JSONL/YAML: validate directly against schema
  ├─ Memory: Archema validation
  └─ RDBMS: Archema validation + optional triggers/constraints for defense-in-depth
```

### Implications

1. **Constraint vocabulary comes from JSON Schema**, not RDBMS limitations. Constructs like `oneOf`, `anyOf`, `dependentRequired` become first-class DSL elements.

2. **Archema validation is canonical.** RDBMS constraints are optional projections that provide defense-in-depth, not the source of truth.

3. **Document stores are first-class**, not awkward adaptations. They're actually the more expressive target for many constraints.

4. **Migration complexity shifts.** RDBMS migrations become "best-effort projection" of the true schema. Triggers fill gaps where native constraints can't express the full intent.

### Example: Polymorphic Associations

The "polymorphic FK" problem dissolves under this model:

```ruby
# DSL expresses the constraint directly
belongs_to_one_of :commentable, [Post, Photo, Video]
```

**What this generates:**

| Store | Implementation |
|-------|----------------|
| JSON/YAML | `oneOf` constraint in schema |
| Memory | Archema validation |
| PostgreSQL | Three nullable FKs + CHECK constraint + Archema validation |
| SQLite | Three nullable FKs + trigger + Archema validation |

The constraint is fully expressed. RDBMS gets what it can handle; Archema ensures correctness regardless.

## The Three-Worlds Unification

Archema's broader vision is unifying the best of three paradigms:

| Paradigm | What We Take |
|----------|--------------|
| **RDBMS** | Relationship semantics, JOIN efficiency, referential integrity, ACID |
| **Document stores** | Schema expressiveness, versioning, readability, flexible structure |
| **Event sourcing** | Temporal awareness, audit trails, `as_of` queries, immutable history |

This isn't about replacing any paradigm—it's about a unified resource definition that projects appropriately to each storage layer.

### Future: Cross-Store Composition

The architecture enables scenarios like:

```ruby
class AuditedUser < Archema::Resource
  store :primary, :sequel, database: :main
  store :replica, :sequel, database: :read_replica, read_only: true
  store :audit, :jsonl, path: "audit/users.jsonl", immutable: true

  # Writes go to :primary and :audit
  # Reads can use :replica for scaling
end
```

Or cross-store relationships:

```ruby
class Reference < Archema::Resource
  store :sequel

  relationships do
    # Join RDBMS records against YAML frontmatter files
    belongs_to :document, Document  # Document uses yaml_frontmatter store
  end
end
```

## Consequences

### Positive

- Richer constraint vocabulary than any single storage paradigm
- Document stores become fully capable, not second-class
- Clear separation: schema truth (Archema) vs storage projection (adapters)
- Future-proof for new storage backends

### Negative

- More validation logic in Archema (not purely delegated to DB)
- RDBMS migrations are "best effort"—some constraints only enforced at app layer
- Developers expecting pure RDBMS semantics may find this unfamiliar

### Neutral

- Triggers/check constraints still available for RDBMS defense-in-depth
- Performance characteristics depend on storage layer, not Archema

## References

- [JSON Schema Validation](https://json-schema.org/draft/2020-12/json-schema-validation.html)
- [ADR-001: Store Composition](adr-001-store-composition.md)
- [Plan: Safe RDBMS Evolution](plan-safe-rdbms-evolution.md)
