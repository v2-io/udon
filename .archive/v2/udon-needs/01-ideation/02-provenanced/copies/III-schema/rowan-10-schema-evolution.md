---
source: rowan — user guide: Schema Evolution, ~/src/rowan/docs/usr/10-schema-evolution.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/docs/usr/10-schema-evolution.md
source_commit: 0ecf61a (rowan)
categories: [schema-evolution, user-need-framing, was-syntax, branch-safety, read-time-translation]
why_included: >
  The clearest USER-NEED framing in the family: why Rails-style migrations are insufficient (renames across merged feature branches, out-of-sync staging DBs, old backups read by new code, YAML/JSON files migrations never touch). was: read-time translation, branch-conflict detection, cross-storage evolution. 'schema changes as safe as code changes.'
---

---
title: Schema Evolution
order: 10
tags: [guide, core, schema, evolution, migrations]
related: ["[[02-resources]]", "[[09-data-layers]]"]
---

# Schema Evolution

Schema changes are where things break. A field rename in your feature branch merges to main, and suddenly production reads fail because old data has the old field name. A type change corrupts data silently. A removed field loses data you needed.

Archema treats schema evolution as a first-class concern, not an afterthought bolted onto migrations.

## The Problem with Traditional Migrations

In Rails, you write migrations that transform the database:

```ruby
class RenameNameToFullName < ActiveRecord::Migration
  def change
    rename_column :users, :name, :full_name
  end
end
```

This works until:
- Your feature branch has a different rename, and both merge
- You deploy to a staging database that's out of sync
- You read old data from a backup that predates the migration
- Your YAML/JSON files weren't migrated (because migrations only touch SQL)

Migrations transform the *database*. Schema evolution needs to transform the *data model*—across all storage backends, with conflict detection, and with the ability to read old data with new code.

## The `was:` Syntax

Archema tracks what fields used to be:

```ruby
field :full_name, :string, was: :name
```

This declares:
1. The field is now called `:full_name`
2. Old data stored as `:name` should be read as `:full_name`
3. New writes use `:full_name`

The YAML file that says `name: "John Doe"` is read as `full_name: "John Doe"`. No migration needed for the data—Archema translates at read time.

For SQL databases, Archema generates the column rename migration. But unlike traditional migrations, the intent is recorded in the Resource definition, making the change auditable and the translation automatic.

### Type Changes

```ruby
field :config, :hash, was: { name: :config, type: :string }
```

Old data stored `:config` as a JSON string. New data stores it as a native hash. Archema can provide an upcaster to parse the old format:

```ruby
field :config, :hash,
  was: { name: :config, type: :string },
  upcast: ->(old_value) { JSON.parse(old_value) }
```

### Rename + Type Change

```ruby
field :settings, :hash,
  was: { name: :config, type: :string },
  upcast: ->(old_value) { JSON.parse(old_value) }
```

Field was `:config` (string), now `:settings` (hash). Old data transforms automatically.

## Schema History

Archema maintains a history of your schema in `.archema/schema_history/`:

```
.archema/schema_history/
  user/
    v1.0.0.yaml
    v1.1.0.yaml
    v2.0.0.yaml
```

Each version records the schema at that point. When you change a Resource, Archema can:

```bash
# Detect changes
archema schema:check User

# Record the evolution
archema schema:record User

# Show history
archema schema:history User
```

## Automatic Detection

When you modify a Resource definition:

```ruby
class User < Archema::Resource
  field :full_name, :string  # Was :name
  field :email, :string      # New field
  # removed :legacy_field
end
```

Archema detects:
- `:name` is missing → might be renamed to `:full_name` (ambiguous until you add `was: :name`)
- `:email` is new → add to schema
- `:legacy_field` is gone → might be intentional removal or accidental deletion

For ambiguous changes, Archema asks you to clarify (via the CLI or `was:` syntax) rather than guessing.

## Branch Safety

Two developers create feature branches:

**Branch A**: Renames `name` → `full_name`
**Branch B**: Renames `name` → `display_name`

Both merge to main. Traditional migrations: conflict, data corruption, or lost data.

Archema's schema history detects this. The schema evolution for `name` was recorded differently in each branch. When both try to record their evolution, Archema flags the conflict:

```
CONFLICT: Field 'name' has divergent evolutions:
  - Branch A renamed to 'full_name'
  - Branch B renamed to 'display_name'
Resolution required.
```

You decide how to resolve, and the resolution is recorded in the schema history.

## Version Metadata

Track when fields were added, deprecated, or removed:

```ruby
field :email, :string                          # Original field
field :session_token, :uuid8, since: "2.0.0"   # Added in v2
field :legacy_id, :integer, deprecated: "3.0.0" # Deprecated in v3
field :old_field, :string, removed: "4.0.0"    # Reserved name
```

The `since:`, `deprecated:`, and `removed:` metadata is informational but becomes powerful when combined with schema history—you can ask "what did User look like in v1.5?" and get an accurate answer.

## Migration Generation

For SQL backends, Archema generates Sequel migrations:

```bash
archema codegen
# Creates db/migrate/20240115_rename_name_to_full_name.rb
```

The generated migration:

```ruby
Sequel.migration do
  change do
    rename_column :users, :name, :full_name
  end
end
```

For YAML and JSONL backends, no migration is needed—the `was:` syntax handles translation at read time. But the schema change is still recorded in history for consistency.

## Decision Log

When you resolve an ambiguous change (is this a rename or add+remove?), Archema records your decision:

```yaml
# .archema/decisions.yaml
- resource: User
  field: full_name
  decision: rename_from
  was: name
  recorded_at: 2024-01-15T10:30:00Z
  reason: "Renamed for clarity, same data"
```

This serves as an audit trail and helps future developers (or agents) understand why the schema looks the way it does.

## Cross-Storage Evolution

The same evolution applies across storage backends. Your User resource might be in PostgreSQL. Your UserPreferences might be in YAML frontmatter. When you rename a field:

```ruby
class UserPreferences < Archema::Resource
  store :yaml_frontmatter, directory: "prefs/"

  field :theme_color, :string, was: :color
end
```

Old YAML files with `color: blue` are read as `theme_color: blue`. No file migration. No data loss. The intent is in the code.

## Upcasting

For type changes that need transformation:

```ruby
field :tags, :array, of: :string,
  was: { name: :tags, type: :string },
  upcast: ->(old_value) { old_value.split(",").map(&:strip) }
```

Old data stored tags as `"ruby, elixir, postgres"`. New data stores them as `["ruby", "elixir", "postgres"]`. The upcaster transforms old format on read.

## Why This Matters

Schema changes are inevitable. Business requirements change, models evolve, mistakes get fixed. The question isn't whether you'll change schemas—it's whether those changes will be safe.

Traditional approaches:
- Hope migrations run in order
- Hope all environments are in sync
- Hope no one reads old backups with new code
- Hope nothing changes while you're deploying

Archema's approach:
- Intent is recorded in the Resource (`was:`)
- History is tracked (`.archema/schema_history/`)
- Conflicts are detected (branch safety)
- Old data reads correctly (upcasting)
- All storage backends follow the same rules

This is what "schema changes as safe as code changes" means.

## Next

- [[14-schema-api]] covers the programmatic Ruby API for schema operations
- [[11-multi-store]] covers event sourcing patterns
- [[12-tool-export]] covers AI agent integration
