---
source: autopax — ADR-008 YAML Conventions and Versioned Document Schemas, ~/src/autopax/docs/ADR/008-yaml-and-schemas.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - autopax/docs/ADR/008-yaml-and-schemas.md
source_commit: 033af13 (autopax)
categories: [pre-rowan-wishlist-api, yaml-quoting-gotchas, version-string-float-hazard, versioned-documents, schemacop]
why_included: >
  The PRE-rowan wishlist API — .validate/.schema_at/.compatible?/.migrate/.migration_path/.versions built on Schemacop before the adopt-Archema pivot. Also the YAML-quoting-gotcha table (bare major.minor '1.0' parses as FLOAT; '01234' as octal; yes/no as bool) = concrete FAILURE_MODES-style demand for what a checker/normalizer must catch. Version-bump-vs-change-semantics table. Marked DRAFT/scope-reducing (superseded by ADR-012).
---

# ADR-008: YAML Conventions and Versioned Document Schemas

> [!warning] CAUTION : DO NOT USE
> The following is the original ADR, which is in the process of being replaced by the conformant version: [[migration-proposals/008-yaml-and-schemas.md]]
>
> Use the conformant version and only refer back to this one if there is a discrepancy that needs to be resolved.

**Status:** DRAFT (scope reducing — see note below)
**Date:** 2025-01-15
**Deciders:** Joseph, Claude

> [!note] Scope Reduction (2025-12-15)
> ADR-012 (Archema as Resource Foundation) proposes moving schema validation from this ADR
> to Archema resource definitions. If ADR-012 is adopted, this ADR's scope reduces to:
> - Part 1: YAML conventions (still applicable)
> - psych-pure tooling for normalization (still useful for dev tools)
> - `_schema` identifier convention (becomes standard resource attribute)
>
> Schema versioning, validation, and migration would be handled by Archema's built-in
> resource DSL and schema evolution system.

## Context

Autopax operates on structured documents: agent cards, signum identity files, chronica entries, capability manifests, and more. These documents need:

1. **Consistent formatting** — YAML files should follow minimal, readable conventions
2. **Schema validation** — Documents must conform to defined structures
3. **Version evolution** — Schemas change over time; documents must migrate gracefully
4. **Self-description** — Documents carry their version; the system knows what to do

**Observations from development:**
- AI agents trained on JSON tend to over-quote YAML (e.g., `name: "Test"` instead of `name: Test`)
- Schema validation is currently ad-hoc (manual `validate_*!` methods in `Agent::Card`)
- No infrastructure for schema versioning or data migration
- Documents don't self-describe their schema version

---

## Decision

### Part 1: YAML Conventions

**Principle:** Quote only when YAML semantics require it.

#### When Quotes Are Required

| Pattern | Needs Quotes | Reason |
|---------|--------------|--------|
| Leading `!` | **Yes** | Tag indicator (e.g., `!<tag:...>`) |
| Leading `&` or `*` | **Yes** | Anchor/alias syntax |
| Leading `@` or `` ` `` | **Yes** | Reserved indicators |
| `: ` (colon-space) within value | **Yes** | Mapping value separator |
| ` #` (space-hash) within value | **Yes** | Comment marker |
| Leading `- `, `? `, `: ` | **Yes** | Block structure indicators |
| `[`, `]`, `{`, `}`, `,` | **Yes** | Flow collection indicators |
| `true`, `false`, `yes`, `no`, `on`, `off` | **Yes if string intended** | Becomes boolean (Ruby/YAML 1.1 compat) |
| `null`, `~`, empty | **Yes if string intended** | Becomes nil |
| Numeric patterns | **Yes if string intended** | `42`, `3.14`, `0xFF`, `.inf` become numbers |
| ISO 8601 dates | **Yes if string intended** | `2024-01-15` becomes Date in Ruby |

**Note:** Ruby's Psych (via libyaml) still treats `yes`/`no`/`on`/`off` as booleans for YAML 1.1 compatibility, even though YAML 1.2 removed this. Always use `true`/`false` for booleans.

#### Ruby YAML Parsing Notes

```ruby
# Anchors/aliases require explicit opt-in (Ruby 3.1+)
YAML.safe_load(yaml_string, permitted_classes: [Date], aliases: true)

# Date parsing is automatic for ISO 8601 format
YAML.safe_load("date: 2024-01-15")  # => { "date" => #<Date: 2024-01-15> }

# Postal codes and version numbers: integers unless quoted!
YAML.safe_load("postal: 01234")     # => { "postal" => 668 } (octal!)
YAML.safe_load("postal: 48046")     # => { "postal" => 48046 } (integer)
YAML.safe_load('postal: "01234"')   # => { "postal" => "01234" } (string)
```

#### Version String Gotchas

| Value | Parsed As | Notes |
|-------|-----------|-------|
| `1.2.3` | String ✓ | Full semver (3+ parts) is safe |
| `1.2` | **Float** ⚠️ | Two-part version becomes float! |
| `1.0` | **Float** ⚠️ | Becomes `1.0` float |
| `1.0 beta` | String ✓ | Space + text breaks number pattern |
| `1.0beta` | String ✓ | Text suffix breaks pattern |
| `1.0-beta` | String ✓ | Hyphen breaks pattern |
| `v1.2` | String ✓ | Prefix breaks pattern |
| `1.2.3-beta` | String ✓ | Prerelease suffix safe |
| `1.2.3+build` | String ✓ | Build metadata safe |

**Rule:** Bare `major.minor` versions (e.g., `1.0`, `2.5`) are the *only* dangerous case—any suffix, prefix, or third component makes it a string. When in doubt, use full semver (`1.0.0`) or quote it.

#### When Quotes Are Unnecessary

| Pattern | Needs Quotes | Example |
|---------|--------------|---------|
| Simple text | No | `name: Test Agent` |
| Text with spaces | No | `description: A helpful agent` |
| Relative paths | No | `path: ./config/settings.yml` |
| URLs | No | `url: https://example.com/api` |
| Hyphenated strings | No | `id: my-agent-card` |

#### Preferred Style

```yaml
# Good: minimal quoting
version: 1
name: Autopax Test Agent
description: Integration testing agent for chat infrastructure
model: ~anthropic-default/claude-sonnet-4-5-20250929   # ~ preferred (no quotes)
# model: "@anthropic-default/..."                       # @ requires quotes (legacy)
enabled: true
max_retries: 3

files:
  axiomata-root: ./test-agent-axiomata.md
  context-root: ./context.md

tags:
  - testing
  - infrastructure
```

```yaml
# Bad: unnecessary quotes (JSON habits)
version: "1"
name: "Autopax Test Agent"
description: "Integration testing agent for chat infrastructure"
files:
  axiomata-root: "./test-agent-axiomata.md"
```

#### Multiline Strings

Prefer block scalars for multiline content:

```yaml
# Good: block scalar
description: |
  This agent handles integration testing.
  It verifies chat infrastructure components.

# Acceptable for short wrapped lines
notes: >
  This will be folded into a single line
  with spaces replacing newlines.

# Bad: escaped newlines in quoted string
description: "This agent handles integration testing.\nIt verifies chat infrastructure components."
```

#### Tooling Integration

**Decision:** Use [psych-pure](https://github.com/kddnewton/psych-pure) for comment-preserving YAML normalization.

**Rationale:**

| Option | Comment Preservation | Performance | Notes |
|--------|---------------------|-------------|-------|
| Standard Psych | ❌ None | 1x (C/libyaml) | Per YAML spec, comments are "presentation details" |
| [psych-comments](https://github.com/wantedly/psych-comments) | ⚠️ Partial (inline→own line) | ~2x | Patches Psych AST |
| [psych-pure](https://github.com/kddnewton/psych-pure) | ✅ Full fidelity | ~14x | Pure Ruby, inline comments preserved |
| yamllint (Python) | N/A | N/A | Linting only, no reformatting |

**Performance is acceptable for dev tooling:**
- ~14x slower than native Psych (well within 1 order of magnitude)
- YJIT improves psych-pure by ~40% on larger documents
- Irrelevant for occasional `./autopax dev yaml normalize` invocations

**Coexistence:** Both libraries work in the same process:
```ruby
require 'yaml'         # Standard Psych (fast, runtime use)
require 'psych/pure'   # Pure Ruby (dev tooling, comment preservation)

# Fast path (no comments needed)
data = YAML.safe_load(yaml_string, permitted_classes: [Date], aliases: true)

# Comment-preserving path
data = Psych::Pure.safe_load(yaml_string, comments: true)
yaml_out = Psych::Pure.dump(data, comments: true)  # Comments survive round-trip
```

**CLI command:**
```bash
./autopax dev yaml normalize [--check] file.yml   # Normalize with comment preservation
./autopax dev yaml normalize --check **/*.yml     # CI mode: fail if not normalized
```

The normalizer will:
1. Parse with `Psych::Pure` (preserves comments)
2. Validate against schema if `_schema` field present
3. Re-emit in canonical form (minimal quotes, 2-space indent, consistent style)
4. Preserve all comments in their original positions

---

### Part 2: Schema Validation with Schemacop

**Decision:** Use [Schemacop](https://github.com/sitrox/schemacop) (v3) for schema validation.

#### Rationale

| Criterion | Schemacop | dry-schema | json-schema gem |
|-----------|-----------|------------|-----------------|
| DSL clarity | `str!`, `int?`, `num!` — clean | Verbose blocks | N/A (JSON files) |
| JSON Schema export | Built-in `as_json` | No | N/A |
| Conditional fields | `dep :a, :b, :c` | Separate rules | Supported |
| Maintenance | Active | Very active | Active |
| Dependencies | Minimal | dry-rb ecosystem | Minimal |

**Key features we need:**
- Clean DSL for readable schema definitions
- JSON Schema export for editor autocomplete and cross-language use
- Conditional/dependent field validation (`dep`)
- Nested structure validation

**DSL type methods (verified):**
| Method | Type | Notes |
|--------|------|-------|
| `str!` / `str?` | String | Required / optional |
| `int!` / `int?` | Integer | |
| `num!` / `num?` | Number (float) | Note: NOT `flt!` |
| `bool!` / `bool?` | Boolean | |
| `hsh!` / `hsh?` | Hash (nested object) | Takes block for nested schema |
| `ary!` / `ary?` | Array | See array syntax below |
| `obj!` / `obj?` | Arbitrary object | Use `classes: [Date]` for typed objects |
| `one_of!` | Union type | For fields that accept multiple types |

**Array syntax (important):**
```ruby
# Homogeneous array (list of items matching schema)
ary! :items do
  list :hsh do  # "list" keyword for repeated items
    str! :name
  end
end

# Tuple (fixed positional items) - default behavior without "list"
ary! :pair do
  str   # first element
  int   # second element
end
```

#### Example Schema

```ruby
module Autopax::Schemas
  AgentCardV2 = Schemacop::Schema3.new :hash do
    int! :version, minimum: 2, maximum: 2
    str! :name
    str? :description

    hsh! :model do
      str! :substrate
      str? :variant
    end

    hsh! :files do
      str! :axiomata_root
      str? :context_root
    end

    # If credentials present, encryption_key required
    str? :credentials
    str? :encryption_key
    dep :credentials, :encryption_key
  end
end
```

#### JSON Schema Export

```ruby
AgentCardV2.as_json
# => { "type" => "object", "required" => [...], "properties" => {...} }
```

This enables:
- Editor autocomplete (VS Code, JetBrains with JSON Schema association)
- Cross-language validation (TypeScript clients, etc.)
- OpenAPI integration for any future APIs

---

### Part 3: Versioned Documents

**Principle:** Documents are self-describing. Schemas are explicit at each version. Migrations transform data between versions.

#### Document Structure

All versioned documents include a schema identifier:

```yaml
_schema: autopax-agent-card/2.0.0

name: Test Agent
model:
  substrate: anthropic-default
  variant: claude-sonnet-4-5-20250929
```

The `_schema` field combines type and version in one identifier, enabling the system to:
- Select the correct schema for validation
- Determine if migration is needed
- Apply appropriate migration chain

**Format:** `[namespace-]<type>/<semver>`

Examples:
- `autopax-agent-card/2.0.0`
- `autopax-signum/1.0.0`
- `autopax-chronica-entry/1.2.0`

**Reserved field:** `_version` is intentionally NOT used for schema version—it remains available for document-level versioning (revision history, lineage tracking, etc.).

#### Versioned Schema Definition

```ruby
module Autopax::Schemas
  AgentCard = Autopax::Versioned.document(:agent_card) do

    version "1.0.0" do
      str! :name
      str! :model  # Flat string: "@vk/model"
    end

    version "1.1.0" do
      str! :name
      str! :model
      str? :description  # Added optional field
      # Engine validates: +optional = minor bump OK
    end

    version "2.0.0" do
      str! :name
      hsh! :model do    # Restructured
        str! :substrate
        str? :variant
      end
      str? :description

      migrate_from "1" do |doc|
        match = doc[:model].match(/@([^\/]+)\/(.+)/)
        doc[:model] = {
          substrate: match[1],
          variant: match[2]
        }
        doc
      end
      # Engine validates: type change = major bump required
      # Engine validates: migration defined for 1.x -> 2.x
    end
  end
end
```

#### What Full Schemas Provide

Unlike migrations-only approaches (Rails), explicit schemas at each version give:

| Benefit | Explanation |
|---------|-------------|
| **Visibility** | Open the file, see any version's schema instantly |
| **Mental models** | Humans can reason about schema without running tools |
| **Validation** | Each version is independently validatable |
| **Documentation** | Schema IS the documentation |

The engine validates that version bumps match change semantics:
- Adding optional field → minor bump OK
- Changing field type → major bump required
- Major bump without migration → error

#### Version Semantics

Schema versions follow SemVer semantics for **compatibility**:

| Change | Bump | Migration Required? |
|--------|------|---------------------|
| Add optional field | MINOR | No |
| Add required field (with default) | MINOR | Yes (auto-fill) |
| Add required field (no default) | MAJOR | Yes |
| Remove field | MAJOR | Yes (drop field) |
| Change field type | MAJOR | Yes |
| Rename field | MAJOR | Yes |
| Tighten constraint | MAJOR | Possibly |
| Loosen constraint | MINOR | No |

**Compatibility rule:** Same major version = direct read. Different major = migration required.

#### API

```ruby
# Validate document against its declared schema
result = AgentCard.validate(doc)
result.valid?       #=> true/false
result.errors       #=> Schemacop errors
result.schema_id    #=> "autopax-agent-card/1.1.0"

# Get schema for specific version
AgentCard.schema_at("1.1.0")  #=> Schemacop schema

# Check compatibility
AgentCard.compatible?(doc, with: "2.0.0")  #=> false (needs migration)

# Migrate document
migrated = AgentCard.migrate(doc, to: "2.0.0")
migrated[:_schema]  #=> "autopax-agent-card/2.0.0"

# Migration chain
AgentCard.migration_path("1.0.0", "2.0.0")  #=> ["1.0.0", "2.0.0"]

# Introspection
AgentCard.versions          #=> ["1.0.0", "1.1.0", "2.0.0"]
AgentCard.current_version   #=> "2.0.0"
AgentCard.schema_id         #=> "autopax-agent-card"  # without version

# Parse schema identifier
Autopax::Versioned.parse("autopax-agent-card/2.0.0")
#=> { namespace: "autopax", type: "agent-card", version: "2.0.0" }
```

---

### Part 4: Schema Bundles

**Problem:** Which schema versions are current for a given Autopax release?

**Solution:** Track schema version snapshots per Autopax version.

```ruby
module Autopax
  # Maps schema type to current version for this Autopax release
  SCHEMA_BUNDLE = {
    "autopax-agent-card" => "2.0.0",
    "autopax-signum" => "1.0.0",
    "autopax-chronica-entry" => "1.2.0",
    "autopax-capability-manifest" => "1.0.0"
  }.freeze

  # Convenience: full schema identifiers for this release
  def self.current_schema(type)
    version = SCHEMA_BUNDLE[type] or raise "Unknown schema: #{type}"
    "#{type}/#{version}"
  end
end

# Usage:
Autopax.current_schema("autopax-agent-card")
#=> "autopax-agent-card/2.0.0"
```

This enables:
- "What schemas were current in Autopax 0.5.0?"
- "Is this document from an older Autopax version?"
- Compatibility checking across Autopax upgrades

#### CLI Integration

```bash
# Show current schema bundle
./autopax dev schema bundle
# autopax-agent-card: 2.0.0
# autopax-signum: 1.0.0
# autopax-chronica-entry: 1.2.0

# Show bundle for specific Autopax version (future)
./autopax dev schema bundle --version 0.3.0
```

---

## Implementation

### Module Structure

```
lib/autopax/
├── versioned/
│   ├── document.rb       # DSL for versioned document types
│   ├── schema.rb         # Schemacop integration
│   ├── migration.rb      # Migration chain resolution
│   ├── version.rb        # SemVer utilities (wraps Gem::Version)
│   └── registry.rb       # Global schema registry
├── schemas/
│   ├── agent_card.rb     # AgentCard versioned schema
│   ├── signum.rb         # Signum versioned schema
│   ├── chronica.rb       # Chronica entry schemas
│   └── ...
```

### CLI Commands

```bash
# Schema introspection
./autopax dev schema list                      # All document types + versions
./autopax dev schema show agent-card           # Full details (all versions)
./autopax dev schema show agent-card/1.1.0     # Specific version

# Validation
./autopax dev schema validate file.yml         # Validate against _schema field
./autopax dev schema validate file.yml --as agent-card/2.0.0  # Force schema

# Migration
./autopax dev schema migrate file.yml --to 2.0.0   # Migrate in place
./autopax dev schema migrate file.yml --to latest  # Migrate to current

# Export (for editor autocomplete, cross-language use)
./autopax dev schema export agent-card --format json-schema > schema.json
./autopax dev schema export agent-card/1.1.0 --format json-schema

# Check version bump validity during development
./autopax dev schema check agent-card
# Validates that version bumps match change semantics
```

### Dependencies

```ruby
# Gemfile additions
gem 'schemacop', '~> 3.0'      # Schema validation DSL

# Development only (YAML tooling)
group :development do
  gem 'psych-pure', '~> 0.2'   # Comment-preserving YAML (pure Ruby)
end

# No additional gems needed for versioning - builds on Gem::Version
```

**Runtime vs Development:**
- `schemacop` — Runtime dependency (schema validation happens at load time)
- `psych-pure` — Dev-only (normalize command, CI checks); standard Psych used at runtime

---

## Consequences

### Positive

- **Clarity:** YAML conventions documented; schemas are readable code
- **Safety:** Documents validated against declared schemas; version mismatches caught
- **Evolution:** Clear migration paths; breaking changes explicit
- **Tooling:** JSON Schema export enables editor support; CLI provides introspection
- **Self-describing:** Documents carry version; system handles compatibility

### Negative

- **Overhead:** Must define schema for each document type
- **Discipline:** Version bumps must match change semantics (enforced by engine)
- **Migration maintenance:** Breaking changes require migration functions

### Trade-offs Accepted

- **Explicit > implicit:** Full schemas at each version rather than derived from migrations
- **Validation > permissiveness:** Unknown fields rejected by default (Schemacop behavior)
- **SemVer for schemas:** Version numbers carry compatibility semantics

---

## Open Questions

1. ~~**YAML tooling:** Which approach for enforcing conventions?~~ **RESOLVED:** Use psych-pure for comment-preserving normalization (see Part 1).
2. **Schema location:** Inline in code (proposed) vs external YAML/JSON schema files?
3. **Patch versions:** How to handle schema clarifications that don't change structure?
4. **Frontmatter:** Use `front_matter_parser` gem for markdown files with YAML frontmatter?
5. **Namespace:** Is `autopax-` prefix always required, or can it be implicit in Autopax contexts?
6. **Aliases:** Support short forms like `agent-card/2.0.0` that expand to `autopax-agent-card/2.0.0`?

---

## References

- [Schemacop GitHub](https://github.com/sitrox/schemacop)
- [Schemacop V3 Documentation](https://github.com/sitrox/schemacop/blob/master/README_V3.md)
- [psych-pure GitHub](https://github.com/kddnewton/psych-pure) — Pure Ruby YAML with comment preservation
- [psych-comments GitHub](https://github.com/wantedly/psych-comments) — Alternative (partial comment fidelity)
- [YAML 1.2.2 Specification](https://yaml.org/spec/1.2.2/) — Canonical spec
- [Semantic Versioning 2.0.0](https://semver.org/)
- [JSON Schema](https://json-schema.org/)
- [Protocol Buffers - Schema Evolution](https://protobuf.dev/programming-guides/proto3/#updating)

### Local Reference Documents

- `docs/ref/yaml-syntax-cheatsheet.md` — Distilled YAML 1.2.2 reference (practical syntax guide)
- `docs/ref/yaml-1.2.2-spec.md` — Full YAML 1.2.2 specification

### Related ADRs

- **ADR-006** — Liquid templates + recursive rendering
- **ADR-010** — Markdown parsing and structural validation

See ADR-010 for the "Living Documents" convergence table showing how these ADRs together form the foundation for validated, dynamic, agent-modifiable documents.

---

## Revision History

| Date | Change |
|------|--------|
| 2025-01-15 | Initial draft |
| 2025-01-16 | Resolved YAML tooling: psych-pure for comment preservation; verified Schemacop DSL; corrected quoting rules per YAML 1.2.2 spec |
