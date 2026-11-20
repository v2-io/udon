---
source: autopax operata-yaml-spike (autopax/docs/tactical/2025-12-03-operata-yaml-spike-v2/MIGRATION_REALITY.md) — Dec 2025 empirical stress test of YAML+yq for document/schema storage
gathered: 2026-07-21
status: gathered (verbatim copy of v2 adversarial doc)
paths:
  - CROWN ROW, most on-topic for schema-VERSIONING specifically: worked v1->v2 schema migration over 100 files. Non-atomic, non-transactional, non-idempotent-without-checks, concurrent-unsafe; ~200 LOC infra + ~50 LOC/migration. Four worked migration examples (add field, rename, split, nested-transform) YAML vs SQLite. 'harder than expected' = the empirical counterweight to rowan's migration DSL claims.
source_commit: 033af13 (autopax); yaml-spike dir last touched a6942e8 2025-12-04
categories: [schema-versioning, schema-validation, empirical-stress-test, yaml-failure-modes, agent-recovery, cross-tier-convergence]
why_included: >
  v2 adversarial review
---

# Schema Migration Reality Check: YAML vs SQLite

**Date**: 2025-12-03
**Question**: How hard is schema migration in YAML really?
**Verdict**: **HARDER THAN EXPECTED** - requires custom tooling

## Executive Summary

The previous spike claimed "no migrations needed" - this was **naively optimistic**.

Schema migration in YAML is:
- ✗ **Not atomic** (can fail mid-migration)
- ✗ **Not transactional** (no automatic rollback)
- ✗ **Not idempotent** (without explicit checks)
- ✗ **Not concurrent-safe** (race conditions possible)
- ⚠ **Requires custom tooling** that doesn't exist yet

**Comparison**: SQLite's `ALTER TABLE` is **atomic, transactional, and idempotent** out of the box.

## Test Scenario

**Migration task**: Change model format from v1 to v2.

**v1 schema**:
```yaml
model: "@anthropic-default/claude-sonnet"  # String
```

**v2 schema**:
```yaml
model:
  substrate: "anthropic-default"  # Object
  variant: "claude-sonnet"
```

**Test corpus**: 100 YAML files with various edge cases:
- 97 clean v1 files
- 1 YAML syntax error (corrupt file)
- 1 already migrated (v2 format)
- 1 null model value

## Test Results

### Test 1: Clean Migration ⚠ COMPLEX

**Migration script** (simplified):

```ruby
def migrate_file(file_path)
  # 1. Read and parse YAML
  data = YAML.load_file(file_path)

  # 2. Check if already migrated
  return :already_migrated if data['_schema'] == 'autopax-effort/0.2.0'

  # 3. Transform model field
  if data['model'].is_a?(String) && data['model'] =~ /@([^\/]+)\/(.+)/
    substrate, variant = $1, $2
    data['model'] = { 'substrate' => substrate, 'variant' => variant }
  elsif data['model'].nil?
    data['model'] = { 'substrate' => 'unknown', 'variant' => 'unknown' }
  end

  # 4. Update schema version
  data['_schema'] = 'autopax-effort/0.2.0'

  # 5. Write atomically
  temp_file = "#{file_path}.tmp.#{Process.pid}"
  File.write(temp_file, YAML.dump(data))
  FileUtils.mv(temp_file, file_path)

  :migrated
rescue Psych::SyntaxError
  :yaml_error
rescue => e
  :error
end
```

**Complexity**: ~30 lines of code for a SIMPLE migration.

**Results**:
- Migrated: 97 files
- Already migrated: 1 file
- YAML error: 1 file (skipped)
- Null model: 1 file (handled with default)

**Issues encountered**:

1. **Error handling required**: Corrupt files must be skipped explicitly.
2. **Idempotency required**: Must check schema version to avoid double-migration.
3. **Null handling required**: Missing values need defaults.
4. **Regex complexity**: String parsing is error-prone.

**Verdict**: Migration WORKS but requires **careful implementation**.

---

### Test 2: Error Handling ✓ POSSIBLE

**Scenario**: File with YAML syntax error.

```yaml
invalid: yaml: syntax::
```

**Migration behavior**:

```ruby
begin
  YAML.load_file('corrupt.yaml')
rescue Psych::SyntaxError => e
  log.error "Skipping corrupt file: #{e.message}"
  return :skipped
end
```

**Outcome**: ✓ Migration script can SKIP corrupt files.

**Verdict**: Error handling is POSSIBLE but must be EXPLICIT. Unlike SQLite, there's no automatic transaction rollback.

---

### Test 3: Idempotency ✓ POSSIBLE

**Scenario**: Run migration twice on same files.

**First run**:
- Migrated: 97 files
- Already migrated: 1 file

**Second run**:
- Migrated: 0 files
- Already migrated: 98 files

**Implementation**:

```ruby
# Idempotency check
return :already_migrated if data['_schema'] == 'autopax-effort/0.2.0'
```

**Outcome**: ✓ Migration is idempotent WITH explicit version check.

**Verdict**: Idempotency is POSSIBLE but requires **manual implementation**. SQLite migrations have this built-in.

---

### Test 4: Concurrent Modification ✗ DATA RACE

**Scenario**: File is being written WHILE migration runs.

**Setup**:
- Thread 1: Migrates file (reads → transforms → writes)
- Thread 2: Updates file (reads → modifies → writes)
- Both start simultaneously

**Expected outcome**: One operation fails OR both succeed sequentially.

**Actual outcome**: ⚠ **DATA INCONSISTENCY**

**Example result**:
```yaml
_schema: "autopax-effort/0.2.0"  # From migration
model:
  substrate: "anthropic-default"  # From migration
  variant: "claude-sonnet"        # From migration
status: "updated"                 # From concurrent write
```

**Problem**: Last-write-wins semantics means:
- Migration's schema change applied
- Concurrent write's status change applied
- Result: Inconsistent state (partially migrated + partially updated)

**Verdict**: Concurrent writes during migration cause **UNPREDICTABLE RESULTS**. Requires file locking or coordination.

---

### Test 5: Partial Migration Recovery ✓ POSSIBLE

**Scenario**: Migration crashes after migrating 5/10 files.

**Initial state**:
- 10 files in v1 format

**After crash**:
- 5 files in v2 format
- 5 files in v1 format

**Recovery**:

```ruby
# Re-run migration (with idempotency)
Dir.glob('*.yaml').each do |file|
  migrate_file(file)  # Skips already-migrated files
end
```

**Result**: All 10 files migrated to v2.

**Verdict**: ✓ Partial migration recovery is POSSIBLE with **idempotent migration logic**.

**Contrast with SQLite**: SQLite transactions would **automatically rollback** all 5 migrations on crash, requiring manual retry.

---

## Complexity Comparison

### YAML Migration

**Required components**:

1. **Migration script** (~30-50 LOC per migration)
   - Read YAML
   - Parse and transform
   - Validate
   - Write atomically

2. **Error handling** (~20 LOC)
   - Try/catch for YAML errors
   - Skip corrupt files
   - Log failures

3. **Idempotency** (~10 LOC)
   - Check schema version
   - Skip if already migrated

4. **Atomic write** (~15 LOC)
   - Write to temp file
   - Move to target (atomic rename)

5. **Progress tracking** (~10 LOC)
   - Count migrated/skipped/failed
   - Report status

**Total**: ~85-105 LOC per migration (assuming reusable utilities).

**Plus**: Migration runner infrastructure (~100 LOC):
- Discover files
- Run migrations in order
- Handle dependencies
- Rollback on failure

**Grand total**: ~200 LOC for migration infrastructure + ~50 LOC per migration.

### SQLite Migration

**Required components**:

```sql
-- Migration script
ALTER TABLE efforts
  ADD COLUMN model_substrate TEXT;

ALTER TABLE efforts
  ADD COLUMN model_variant TEXT;

UPDATE efforts
  SET model_substrate = substr(model, 2, instr(model, '/') - 2),
      model_variant = substr(model, instr(model, '/') + 1)
  WHERE model LIKE '@%/%';

ALTER TABLE efforts
  DROP COLUMN model;
```

**Total**: ~10 lines of SQL.

**Plus**: Migration runner (using existing tools like ActiveRecord, Alembic, Flyway):
- Built-in transaction support
- Automatic rollback on error
- Version tracking
- Dependency management

**Grand total**: ~10 lines per migration + 0 LOC for infrastructure (using existing tools).

---

## Key Differences

| Aspect | YAML Migration | SQLite Migration |
|--------|----------------|------------------|
| **Atomicity** | ✗ Per-file only | ✓ Per-transaction |
| **Transactional** | ✗ No | ✓ Yes |
| **Rollback** | ✗ Manual | ✓ Automatic |
| **Idempotency** | ~ Manual | ✓ Version tracking |
| **Concurrency** | ✗ Race conditions | ✓ Locking built-in |
| **Infrastructure** | ~ Custom (~200 LOC) | ✓ Existing tools |
| **LOC per migration** | ~50 LOC (Ruby) | ~10 LOC (SQL) |

---

## Real-World Migration Examples

### Example 1: Add New Required Field

**Task**: Add `priority` field (default: 3).

**YAML approach**:

```ruby
data['priority'] = 3 unless data.key?('priority')
```

**SQLite approach**:

```sql
ALTER TABLE efforts ADD COLUMN priority INTEGER DEFAULT 3;
```

**Complexity**: YAML = 1 line (simple). SQLite = 1 line (simpler).

**Winner**: Tie.

---

### Example 2: Rename Field

**Task**: Rename `due_date` to `deadline`.

**YAML approach**:

```ruby
if data.key?('due_date')
  data['deadline'] = data.delete('due_date')
end
```

**SQLite approach**:

```sql
-- SQLite doesn't support RENAME COLUMN in older versions
-- Workaround: Create new column, copy data, drop old column
ALTER TABLE efforts ADD COLUMN deadline DATE;
UPDATE efforts SET deadline = due_date;
ALTER TABLE efforts DROP COLUMN due_date;
```

**Complexity**: YAML = 3 lines. SQLite = 3 lines (but transactional).

**Winner**: Tie (but SQLite safer).

---

### Example 3: Split Field into Multiple Fields

**Task**: Split `assignee` (string) into `assignee_name` and `assignee_email`.

**YAML approach**:

```ruby
if data['assignee'] =~ /^(.+) <(.+)>$/
  data['assignee_name'] = $1
  data['assignee_email'] = $2
  data.delete('assignee')
end
```

**SQLite approach**:

```sql
ALTER TABLE efforts ADD COLUMN assignee_name TEXT;
ALTER TABLE efforts ADD COLUMN assignee_email TEXT;

UPDATE efforts
  SET assignee_name = substr(assignee, 1, instr(assignee, ' <') - 1),
      assignee_email = substr(assignee, instr(assignee, ' <') + 2, length(assignee) - instr(assignee, ' <') - 2)
  WHERE assignee LIKE '% <%>';

ALTER TABLE efforts DROP COLUMN assignee;
```

**Complexity**: YAML = 5 lines (Ruby regex). SQLite = 8 lines (SQL string functions).

**Winner**: YAML (slightly simpler), but SQLite safer (transaction).

---

### Example 4: Complex Nested Transformation

**Task**: Migrate `metadata` object structure:

**Before**:
```yaml
metadata:
  created: "2024-01-01"
  updated: "2024-01-02"
```

**After**:
```yaml
timestamps:
  created_at: "2024-01-01T00:00:00Z"
  updated_at: "2024-01-02T00:00:00Z"
```

**YAML approach**:

```ruby
if data['metadata']
  data['timestamps'] = {
    'created_at' => parse_and_format(data['metadata']['created']),
    'updated_at' => parse_and_format(data['metadata']['updated'])
  }
  data.delete('metadata')
end
```

**SQLite approach**:

```sql
-- SQLite doesn't have nested JSON by default
-- Must store as JSON string or flatten to columns

ALTER TABLE efforts ADD COLUMN created_at TEXT;
ALTER TABLE efforts ADD COLUMN updated_at TEXT;

UPDATE efforts
  SET created_at = json_extract(metadata, '$.created') || 'T00:00:00Z',
      updated_at = json_extract(metadata, '$.updated') || 'T00:00:00Z';

ALTER TABLE efforts DROP COLUMN metadata;
```

**Complexity**: YAML = 7 lines (Ruby). SQLite = 8 lines (SQL + JSON functions).

**Winner**: YAML (more natural for nested structures), but SQLite safer.

---

## Verdict

### YAML Migrations Are:

**✓ Feasible**: Can implement complex transformations.

**✓ Flexible**: Ruby gives full programming language power.

**⚠ Complex**: Requires custom infrastructure (~200 LOC).

**⚠ Error-prone**: No automatic atomicity/transactions.

**⚠ Concurrent-unsafe**: Requires explicit locking.

### SQLite Migrations Are:

**✓ Simple**: ~10 LOC per migration using SQL.

**✓ Safe**: Automatic transactions + rollback.

**✓ Proven**: Existing tools (ActiveRecord, Alembic, Flyway).

**⚠ Less flexible**: SQL limitations for complex logic.

**⚠ Binary format**: Not human-editable.

---

## Recommendations

### For OPERATA

**Accept YAML migration complexity** because:

1. **Human-readable/editable** is core philosophy
2. **Git-friendly** is essential for version control
3. **Migration frequency is LOW** (schema changes are rare)
4. **Can invest in infrastructure** (~200 LOC is acceptable)

**Implement migration infrastructure**:

```ruby
class YAMLMigration
  attr_reader :version, :description

  def initialize(version, description)
    @version = version
    @description = description
  end

  def up(data)
    raise NotImplementedError
  end

  def down(data)
    raise NotImplementedError
  end
end

class MigrationRunner
  def run(file, target_version)
    data = YAML.load_file(file)
    current_version = data['_schema']

    migrations.each do |migration|
      next if migration.version <= current_version

      data = migration.up(data)
      data['_schema'] = migration.version

      # Write atomically after each migration
      backup_and_write(file, data)

      break if migration.version >= target_version
    end
  end
end
```

**Key features**:
- Version tracking (in `_schema` field)
- Incremental migrations (run in order)
- Atomic writes (backup + rename)
- Rollback support (down migrations)

**Estimated effort**: 1-2 days to build migration infrastructure.

### When to Reconsider

Reconsider YAML if:

1. **Migrations become frequent** (>1 per month)
2. **Migrations become complex** (>100 LOC each)
3. **Concurrent access required** (multi-user editing)
4. **Data integrity critical** (cannot tolerate partial migrations)

**At that point, consider**:
- SQLite (for relational benefits)
- JSON + JSON Schema (for validation)
- Custom binary format (for performance)

---

## Test Artifacts

**Generated files**:
- `data/migration_test/task_000.yaml` through `task_099.yaml` (100 test files)
- `data/migration_test/migrate.rb` (migration script)
- `data/migration_test/migrate_v2.rb` (idempotency test)

**Test results**:
- Clean migration: 97/97 successful
- Error handling: 1 corrupt file skipped
- Idempotency: 2nd run = 0 changes
- Concurrent modification: Data race detected
- Partial recovery: 100% success after retry

---

**Bottom line**: YAML migrations are **HARDER than SQLite** but **FEASIBLE** for OPERATA. The cost is ~200 LOC of infrastructure + ~50 LOC per migration. This is acceptable for OPERATA's low migration frequency and human-readable philosophy.
