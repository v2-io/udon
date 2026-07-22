---
source: rowan — empirical schema-evolution pattern analysis (1,950 Rails migrations), ~/src/rowan/docs/exp/schema-evolution-patterns.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/docs/exp/schema-evolution-patterns.md
source_commit: 0ecf61a (rowan)
categories: [empirical-evidence, migration-corpus, forward-backward-asymmetry, evolution-taxonomy, cross-tier]
why_included: >
  EMPIRICAL: 1,950 real migrations across 15 Rails repos categorized into 6 evolution ladders (normalization, cardinality, type-refinement, identity, temporal, constraint) with forward/backward asymmetry + frequency table (only 8.5% asymmetric). A Tier-2 empirical counterpart to the yaml-spike crown; grounds the versioning DSL's primitives in observed reality, not intuition. NB: the 1,950-migration dataset (_ref/rails-migrations-survey/) is flagged unverified in TARGET-FILES dry-wells.
---

# Schema Evolution Patterns Analysis

## Research Question

What are the principled evolutionary patterns in database schemas, and which are:
- **Automatable** with proper declarations
- **Asymmetric** (easy forward, hard/lossy backward)
- **Common** enough to warrant first-class support in Archema

## Dataset

`~/src/_ref/rails-migrations-survey/` contains 1,950 migrations from 15 Rails repos.

## Evolutionary Pattern Categories

### 1. Normalization Ladder (blob → columns → table)

**Direction**: Increasing normalization (1NF → 2NF → 3NF)

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| Serialized blob | `preferences TEXT` (YAML/JSON) | — | Lossy: lose type safety |
| Multiple columns | `pref_theme, pref_lang, pref_tz` | Extract fields | Combine + serialize |
| Related table | `preferences` table with FK | Create table + FK | Denormalize + drop |

**Asymmetry**: Forward preserves data perfectly. Backward loses type information and constraints.

**Archema support**: `field :preferences, :jsonb, extract_to: Preference`

### 2. Cardinality Evolution (1 → N → M:N)

**Direction**: Increasing relationship richness

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| Single value | `user.email` | — | Pick one, lose others |
| Array column | `user.emails[]` | Add array type | Flatten |
| One-to-many | `emails` table, `user_id` FK | Create table | Denormalize |
| Many-to-many | `user_emails` join table | Add second FK | Pick primary |
| Rich join | `memberships` with `role`, `joined_at` | Add columns | Drop metadata |

**Asymmetry**: Each forward step is lossless. Each backward step loses data.

**Archema support**:
- `has_many :emails` (1:N)
- `has_many :groups, through: :memberships` (M:N)
- `Membership` as first-class resource (rich join)

### 3. Type Refinement (loose → strict)

**Direction**: Increasing type precision

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| String | `status VARCHAR` | — | Cast + validate |
| Enum | `status ENUM('active','inactive')` | Add constraint | Remove constraint |
| Check constraint | `CHECK (status IN (...))` | Add constraint | Remove constraint |
| FK to lookup | `status_id` → `statuses` table | Create table | Inline values |

**Asymmetry**: Forward adds constraints (may fail on invalid data). Backward is lossless.

**Archema support**: `field :status, Types::Status` with enum definition

### 4. Identity Evolution (implicit → explicit → composite)

**Direction**: Increasing identity precision

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| Autoincrement | `id SERIAL` | — | Regenerate |
| UUID | `id UUID` | Generate UUIDs | N/A (different semantics) |
| Natural key | `(tenant_id, email)` unique | Add constraint | Remove constraint |
| Composite PK | `PRIMARY KEY (tenant_id, user_id)` | Restructure | Pick single column |

**Asymmetry**: Autoincrement → UUID is one-way (semantic change). Natural keys are additive.

### 5. Temporal Evolution (point-in-time → versioned → event-sourced)

**Direction**: Increasing temporal awareness

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| Current state only | `users` table | — | Collapse history |
| Soft delete | `deleted_at` column | Add column | Hard delete |
| Versioning | `user_versions` table | Create audit table | Drop history |
| Event sourcing | `user_events` append-only | Create event log | Materialize snapshot |

**Asymmetry**: Forward preserves all history. Backward loses temporal information.

**Archema support**: `timestamps`, `soft_delete`, future: `versioned`, `event_sourced`

### 6. Constraint Evolution (permissive → strict)

**Direction**: Increasing data integrity

| Stage | Example | Forward | Backward |
|-------|---------|---------|----------|
| No constraint | `email VARCHAR` | — | Remove constraint |
| NOT NULL | `email VARCHAR NOT NULL` | Add + backfill NULLs | Allow NULLs |
| UNIQUE | `UNIQUE(email)` | Add + dedup | Remove |
| FK | `REFERENCES users(id)` | Add + validate | Remove |
| CHECK | `CHECK (age >= 0)` | Add + validate/fix | Remove |

**Asymmetry**: Forward may require data cleanup. Backward is lossless.

**Archema support**: All constraints declarative; forward migration auto-generates cleanup

## Detection Heuristics

For each migration, look for:

### Blob → Columns
- `serialize :X` in model + later `add_column` for same data
- `YAML.load`, `JSON.parse` in migrations
- Remove column of type `:text` containing structured data

### Columns → Table
- Multiple `remove_column` + `create_table` with similar names
- Pattern: `user.url_a, url_b, url_c` → `user_urls` table

### 1:N → M:N
- Add second FK to existing join table
- `has_many :through` appearing in model history

### Array → 1:N
- `remove_column :X, :array` + `create_table :Xs`
- PostgreSQL array type to separate table

### Soft Delete Addition
- `add_column :deleted_at, :datetime`
- `add_column :discarded_at, :datetime`

### Dedup for Constraint
- `add_index :X, :Y, unique: true` preceded by data cleanup
- `WHERE ... GROUP BY` in migration

## Agent Instructions for Analysis

When analyzing a migration:

1. **Identify the operation type**: CREATE, ALTER, DROP, DATA
2. **Classify the evolutionary pattern** from categories above
3. **Note direction**: Forward (increasing X) or Backward (decreasing X)
4. **Assess asymmetry**: Is reverse operation lossy?
5. **Check for Archema coverage**: Could this be declared, not scripted?
6. **Extract the transformation**: What data operation is happening?

Output format:
```yaml
migration: 20200615_add_bmc_to_subnet.rb
repo: foreman
pattern: cardinality_evolution
direction: add_optional_relationship
asymmetric: false  # Can be removed without data loss
archema_declarable: yes  # `belongs_to :bmc, optional: true`
transformation: backfill_from_related  # Find existing BMC proxy
notes: |
  Domain logic to find "best" BMC proxy. Could be declarable
  with `default: -> { proxies.with_feature('BMC').first }`
```

## Empirical Findings (1,950 migrations across 15 repos)

### Pattern Frequency
| Pattern Direction | % of Migrations | Asymmetric? |
|-------------------|-----------------|-------------|
| Relational (join tables, FKs) | 14.8% | Partially |
| Constraining (NOT NULL, UNIQUE) | 14.1% | No |
| Temporal (soft delete, audit) | 4.0% | Yes |
| Identity (UUID, natural keys) | 1.6% | Yes |
| Cleanup (dedup, backfill) | 1.5% | No |
| Refining (lookup tables) | 0.5% | Yes |
| Normalizing (blob → table) | 0.5% | Yes |

**Only 8.5% of migrations are asymmetric** (hard to reverse).

### Real Examples Found

**Blob → Table (Tracks)**
```
006: users.preferences = TEXT (serialized hash)
012: CREATE TABLE preferences (typed columns)
013: MIGRATE data from blob → table
015+: Add columns to preferences
```

**Columns → Table (Moebooru)**
```
artists.url_a, url_b, url_c → artist_urls table with FK
```

**Anonymous Join → Rich Model (Foreman)**
```
users_roles (HABTM) → user_roles with filters, caching
```

### Archema Primitive Gaps

1. **Embedded schema extraction**: `extract_to: RelatedModel`
2. **Column-to-table normalization**: `normalize_to: RelatedModel`
3. **Cardinality change declaration**: `was_columns: [:url_a, :url_b, :url_c]`
4. **Deduplication strategy**: `on_conflict: :keep_newest`

## Questions to Answer

1. What % of migrations fit these evolutionary patterns?
2. Which patterns are most common?
3. Which patterns need Archema primitives we don't have yet?
4. Are there patterns we haven't identified?
