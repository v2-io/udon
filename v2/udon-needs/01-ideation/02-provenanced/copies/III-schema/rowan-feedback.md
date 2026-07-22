---
source: rowan — real-world usage feedback log, ~/src/rowan/docs/msc/feedback.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - rowan/docs/msc/feedback.md
source_commit: 0ecf61a (rowan)
categories: [agent-in-vivo-friction, schema-dsl-ergonomics, tier2-tier3-hybrid, DIVERGENCE-FROM-ROW]
why_included: >
  AGENT-IN-VIVO friction testimony: an agent building the first real (non-test) SQLite resource in autopax, logging 12 concrete friction points (broken create_table!, no-lambda store config, namespaced-app CLI discovery failure, field-vs-attribute confusion, lazy-query surprise, strict-BigDecimal, identity-finder bug) + what worked. >>> DIVERGENCE: TARGET-FILES' Why for this path ('UDON-shaped RelaxNG-compact syntax, Puzzle Piece 1') is a MISATTRIBUTION — this file has one commit and never contained that syntax. The RelaxNG-compact ?/!/*/+ cardinality + ;? uncertainty marker actually live in ~/src/udon/design/udon-schema-exploration.md 'Puzzle Piece 1: Basic Schema (feedback.md)', which references a DIFFERENT/older feedback.md now gone. Surfaced for Joseph; the file is kept for its real (friction-testimony) value. See III-schema-witness.md.
---

# Archema Feedback

Feedback from real-world usage, to inform improvements.

---

## 2025-12-16 - First SQLite Resource in Autopax (Claude-131efb6f)

### Context
Building a Substrate registry resource in Autopax with SQLite persistence. First time using Archema's Sequel adapter for a real production resource (not tests).

### Issues Encountered

#### 1. `create_table!` Bug (Sequel Adapter)

**Location:** `lib/archema/store_adapters/sequel.rb:265-286`

**Problem:** The `create_table!` method doesn't work. Inside the `db.create_table(@table_name)` block, `resource` is referenced but it's not in scope - the block is `instance_exec`'d in Sequel's `CreateTableGenerator` context.

```ruby
def create_table!
  db.create_table(@table_name) do
    resource.attributes.each do |name, attr_def|  # <-- resource is undefined here
      ...
    end
  end
end
```

**Error:** `undefined local variable or method 'resource' for an instance of Sequel::Schema::CreateTableGenerator`

**Fix:** Capture `@resource` in a local variable before the block:
```ruby
def create_table!
  res = @resource  # capture before block
  db.create_table(@table_name) do
    res.attributes.each do |name, attr_def|
      ...
    end
  end
end
```

**Note:** This method appears untested - Archema's own Sequel tests create tables manually with `@db.create_table(:table_name)` rather than using the adapter's `create_table!`.

---

#### 2. Store Configuration Doesn't Support Lambdas

**Attempted:**
```ruby
store :sequel, database: -> { database_url }
```

**Expected:** Deferred evaluation so database URL could be computed at runtime.

**Actual:** Sequel adapter received the Proc object and failed: `Sequel::Database.connect takes either a Hash or a String, given: #<Proc:...>`

**Workaround:** Define the class method before the `store` declaration and call it eagerly:
```ruby
class << self
  def database_url
    # compute URL
  end
end

store :sequel, database: database_url  # evaluated at class load time
```

**Suggestion:** Either support lambdas (evaluate them in `resolve_connection`) or document clearly that store options must be static values.

---

#### 3. CLI Resource Discovery Doesn't Work with Namespaced Apps

**Attempted:** `bundle exec archema codegen --dialect=sqlite`

**Problem:** The CLI tries to load resource files directly from `lib/**/resources/*.rb` but fails because the namespace (e.g., `Autopax`) isn't defined.

**Error:** `uninitialized constant Autopax (NameError)` when loading `lib/autopax/resources/model.rb`

**Workaround:** Create migrations manually.

**Suggestion:**
- Document how to configure resource discovery for namespaced apps
- Or: Add a config option for a "boot file" that sets up the namespace before resource loading
- Or: Document that `archema codegen` expects standalone resource files

---

#### 4. Migration vs `create_table!` - Unclear Workflow

**Confusion:** The docs mention both migrations (`archema codegen`, `archema migrate`) and `create_table!`. It wasn't clear which to use for initial table creation.

Looking at tests revealed that `create_table!` is essentially broken/untested and migrations are the intended path.

**Suggestion:** In the Stores guide (09-stores.md), add a clear "Getting Started" section:
```markdown
## First-Time Setup

For SQL databases, create your initial migration:

    archema codegen --dialect=sqlite

Then run it:

    archema migrate

The `adapter.create_table!` method exists for testing but migrations are
the recommended path for production schemas.
```

---

#### 5. `field` vs `attribute` DSL Methods

The existing codebase had a Model resource using `field :name, :type, :optional`. The docs show `attribute :name, :type, :optional`. Both appear to work.

**Confusion:** Are these aliases? Is one preferred? Is one deprecated?

**Suggestion:** Pick one canonical name and mention if aliases exist.

---

#### 6. Instance `destroy!` vs Class `destroy!`

**Attempted:** `record.destroy!`

**Actual:** `Resource.destroy!(record)` (class method)

This is a design choice (immutable records, operations return new instances), but wasn't immediately obvious coming from ActiveRecord patterns.

**Suggestion:** In the Actions guide, explicitly note:
```markdown
Note: All mutation operations are class methods that take records as arguments:
- `Resource.update!(record, changes)`
- `Resource.destroy!(record)`

Records are immutable - operations return new instances.
```

---

### What Worked Well

1. **Type system** - Clear, well-documented types table in 02-resources.md
2. **Query DSL** - `.query.filter(provider: 'anthropic').all` worked exactly as expected
3. **Sequel adapter** - Once migrated, CRUD operations worked flawlessly
4. **Error messages** - `Archema::NotFoundError` was clear and helpful
5. **Hash/JSON handling** - Automatic JSON serialization for SQLite worked perfectly

### Documentation Gaps

1. No end-to-end example of "create a resource with SQLite from scratch"
2. Migration workflow assumes CLI works, but CLI assumes standalone resources
3. The relationship between Resource definition → Migration → Runtime isn't traced through

### Overall

Archema's core is solid - the Resource DSL, query system, and Sequel adapter work well once you get past the initial setup. The main friction is in the "getting started" path for non-trivial apps (namespaced, SQLite, first migration).

---

## 2025-12-16 - Additional Observations (Claude-131efb6f, continued)

### Additional Issues

#### 7. `Hash#except` Not Available

**Context:** When updating a record, I needed to exclude the primary key from the attributes hash.

**Attempted:**
```ruby
Substrate.update!(existing, **attrs.except(:substrate_id))
```

**Problem:** `Hash#except` is an ActiveSupport method, not core Ruby. Archema doesn't depend on ActiveSupport.

**Workaround:**
```ruby
attrs.reject { |k, _| k == :substrate_id }
```

**Suggestion:** Either:
- Add `require 'active_support/core_ext/hash/except'` (lightweight)
- Document that Archema doesn't include AS extensions
- Add a utility method like `Archema::Utils.hash_except(hash, *keys)`

---

### Additional Praise

1. **Primary key flexibility** - `primary_key :substrate_id, :string` worked perfectly for non-integer PKs
2. **Identities** - `identity :by_provider_model, %i[provider model_id]` is elegant
3. **Policies** - Simple `authorize_if always` for public resources
4. **Class methods on resource** - Adding `refresh!` that delegates to a service class integrates naturally

---

## 2025-12-16 - Fix Validation and SQLite Example (Claude-Opus)

### Fixes Applied

#### Issue #1 Fixed: `create_table!` Bug

The closure capture bug in `create_table!` has been fixed. The fix:
- Captures `@resource` and `TYPE_MAP` in local variables before the Sequel block
- Also fixes JSON/hash/array defaults which need to be serialized to JSON strings for DB storage
- Also fixes symbol (atom) defaults which need to be converted to strings

**Location:** `lib/archema/store_adapters/sequel.rb:270-309`

#### New SQLite Quickstart Example

Created `examples/sqlite_quickstart.rb` - a comprehensive end-to-end example demonstrating:
- Resource definition with SQLite storage
- Table creation with `create_table!`
- All query operators (gt, lt, contains, starts_with, ends_with, in, is_nil, etc.)
- Relationships and preloading
- Sorting and pagination
- OR conditions with `filter_any`
- Update and destroy operations

Run with: `ruby examples/sqlite_quickstart.rb`

### Additional Issues Discovered

#### 8. Queries Are Lazy - Need `.all` Before `.map`

**Expected (coming from ActiveRecord):**
```ruby
Book.query.filter(status: :published).map(&:title)
```

**Actual:**
```ruby
Book.query.filter(status: :published).all.map(&:title)
```

Queries are lazy values that don't execute until a terminal method (`.all`, `.first`, `.count`, `.exists?`). This is documented but not prominent enough.

**Suggestion:** Add a note at the top of the Queries guide (03-queries.md):
```markdown
**Important:** Queries are lazy. Use terminal methods to execute:
- `.all` - returns array of records
- `.first` / `.first!` - returns first record
- `.count` - returns integer
- `.exists?` - returns boolean
```

#### 9. `:decimal` Type Requires BigDecimal

**Expected (coming from ActiveRecord):**
```ruby
Book.create!(price: 14.99)  # Float
```

**Actual:**
```ruby
Book.create!(price: BigDecimal("14.99"))  # Must use BigDecimal
```

Archema uses strict types by default. This is documented in the API Design section of MAP.md but not prominent in the types documentation.

**Suggestion:** Add to the types table in 02-resources.md:
```markdown
| decimal | BigDecimal | Exact decimal numbers. **Must use BigDecimal, not Float.** |
```

#### 10. Identity Finder Bug

**Attempted:**
```ruby
identities do
  identity :by_email, [:email]
end

Author.get_by_email("test@example.com")
```

**Error:** `undefined method 'each_key' for an instance of IdentityDefinition`

**Location:** `lib/archema/resource/identities.rb:91`

The generated finder method expects `identity` to be a Hash but receives an `IdentityDefinition` object.

**Workaround:** Use query filter instead:
```ruby
Author.query.filter(email: "test@example.com").first!
```

#### 11. Introspection API Uses `attributes` Instead of `fields`

**Current API:**
```ruby
Author.attribute_names  # => [:id, :name, :email, ...]
Author.attributes       # => hash of AttributeDefinition objects
```

**Expected (to match `field` DSL keyword):**
```ruby
Author.field_names      # more consistent with field :name, :string
Author.fields           # matches the DSL keyword
```

The DSL uses `field` as the primary keyword (per CLAUDE.md), but introspection uses the old `attribute/attributes` naming.

**Suggestion:** Add `fields` and `field_names` as aliases (or primary names), deprecate `attributes`/`attribute_names`.

---

#### 12. Policy DSL: `always` Not Available at Top Level

**Expected (shorthand):**
```ruby
policies { authorize_if always }
```

**Actual (requires policy block):**
```ruby
policies do
  policy { authorize_if always }
end
```

The `always` condition is only available inside a `policy` block, not at the `policies` DSL level.

**Suggestion:** Either:
- Support shorthand: `policies { authorize_if always }` as sugar for catch-all policy
- Or document clearly that `policy` blocks are always required

---

## Research: Options for Issues #3 and #4

### Issue #3: CLI Resource Discovery with Namespaced Apps

**Current behavior:** `lib/archema/cli.rb:392-397` does:
```ruby
def load_resources!
  patterns = ["app/resources/**/*.rb", "lib/**/resources/**/*.rb", "examples/*.rb"]
  patterns.each { |pattern| Dir.glob(pattern).each { |f| require File.expand_path(f) } }
end
```

This fails for namespaced apps because modules like `Autopax` aren't defined when files are required.

**Options:**

1. **Boot file config (recommended)**
   - Add `Archema.config.boot_file = "config/archema.rb"`
   - CLI loads this before resource discovery
   - User's boot file sets up namespaces
   - Follows Rails convention with `config/application.rb`

2. **Convention-based boot**
   - Auto-detect and load: `config/archema.rb`, `config/application.rb`, `config/environment.rb`
   - Less explicit but more magical

3. **Resource patterns config**
   - `Archema.config.resource_patterns = [...]`
   - Gives control but doesn't solve namespace problem

4. **Explicit resource list**
   - `Archema.config.resources = [Autopax::Model, Autopax::Substrate]`
   - Most explicit, requires manual maintenance

**Recommendation:** Option 1 (boot file) - explicit, flexible, follows conventions.

### Issue #4: Migration vs `create_table!` Workflow

**Current confusion:** Two ways to create tables, unclear when to use each.

**Options:**

1. **Document the distinction (recommended)**
   - `create_table!`: testing, prototyping, REPL exploration
   - Migrations: production schemas, team development, CI/CD
   - Add clear section to 09-stores.md

2. **Mark `create_table!` as testing-only**
   - Rename to `create_test_table!` or add guard
   - More friction for legitimate prototyping use

3. **Remove `create_table!`**
   - Force migrations for everything
   - Too much friction for quick exploration

4. **Make `create_table!` generate migration internally**
   - Consistent but adds complexity

**Recommendation:** Option 1 - document clearly. Method has legitimate uses.

---

## Test Coverage Gaps Identified

Based on issues discovered, these test scenarios are missing:

1. **`create_table!` integration test** - The method was untested until this fix
2. **Identity finder methods** - `get_by_{identity}` has a bug (Issue #10)
3. **JSON/hash/array column defaults in create_table!** - Now fixed but needs test
4. **BigDecimal handling in Sequel adapter** - Strict type enforcement
5. **Namespaced resource loading** - CLI discovery with modules

**Suggested additions to test suite:**
- `test/archema/store_adapters/sequel_create_table_test.rb`
- `test/archema/identity_finder_test.rb`
- `test/integration/namespaced_resources_test.rb`
