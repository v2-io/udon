---
source: ~/src/_core/nexum/docs/capabilities-design.md — whole file, promoted 2026-07-21
  (rebasing pass) from a witnessed-only Part II §3 disposition
gathered: 2026-07-21
status: gathered (verbatim whole-file copy). Supersedes the §3 witness-line disposition
  ("About *model*-capability detection, not agent-tool ergonomics — vetted-and-mostly-
  out-of-scope"). Under the Brief's full-tooling-surface scope this is harness-consumer
  runtime prior art.
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/capabilities-design.md
source_commit: c87c75c
categories: [harness, runtime, model-management, capability-negotiation, beta-headers, cost-model, mergeable-config, superseded-disposition]
why_included: >
  A worked model-capability catalog design (Nov 2025, marked "Implemented — Ruby DSL"):
  capabilities that are discoverable / configurable / conditional / validated / mergeable,
  with a concrete schema for context-window tiers (200k/1m + beta_header + support-tier
  note), cache_ttl (5m/1h + beta_header + cost_multiplier), and thinking modes. The
  original bar ("not agent-tool ergonomics") is the tool-ergonomics slice; a harness that
  runs across a shifting fleet of models MUST negotiate exactly these capabilities, and
  the mergeable-refresh-without-clobbering-manual-edits concern is a real durable-config
  design problem. Runtime/model-management prior art for the harness master thesis, not
  UDON-the-notation — a clean case of the two consumers diverging.
---


# Capability System Design

**Author**: Claude Code
**Date**: 2025-11-07
**Status**: ✅ Implemented (Ruby DSL)

## Problem

Model capabilities need to be:
1. **Discoverable** - what CAN a model do?
2. **Configurable** - what do we WANT to enable?
3. **Conditional** - some require beta headers, tier access, etc.
4. **Validated** - incompatible combinations should be caught
5. **Mergeable** - catalog refresh shouldn't blow away manual edits

## Proposed Structure

### Catalog Entry (JSON - Phase 1, Ruby DSL - Phase 2)

```json
{
  "substrate_id": "anthropic/claude-3-5-sonnet",
  "provider": "anthropic",
  "model": "claude-3-5-sonnet",

  "capabilities": {
    "context_window": {
      "200k": {"default": false},
      "1m": {
        "default": true,
        "beta_header": "context-1m-2025-08-07",
        "note": "Requires support tier 4"
      }
    },
    "cache_ttl": {
      "5m": {"default": true},
      "1h": {
        "default": false,
        "beta_header": "extended-cache-ttl-2025-04-11",
        "cost_multiplier": 2.0
      }
    },
    "thinking": {
      "none": {"default": true},
      "interleaved": {
        "default": false,
        "beta_header": "interleaved-thinking-2025-05-14",
        "requires": {"temperature": 1.0}
      }
    },
    "json_mode": true,
    "alternation_required": true,
    "prompt_caching": true,
    "max_output_tokens": 64000
  }
}
```

### Manifest (Session Config)

```json
{
  "session_id": "abc123",
  "active_substrate": "anthropic/claude-3-5-sonnet",
  "preferred_capabilities": {
    "context_window": "1m",
    "cache_ttl": "1h",
    "thinking": "interleaved"
  }
}
```

### Adapter Logic

```ruby
def build_headers(session:)
  headers = base_headers

  # Get model capabilities from catalog
  capabilities = get_capabilities(session.manifest.active_substrate)

  # Get requested capabilities from manifest
  requested = session.manifest.preferred_capabilities || {}

  # Collect beta headers needed
  beta_headers = []

  requested.each do |capability_name, value|
    capability_spec = capabilities.dig(capability_name, value)

    if capability_spec.nil?
      raise AdapterError, "#{value} not available for #{capability_name}"
    end

    if capability_spec['beta_header']
      beta_headers << capability_spec['beta_header']
    end
  end

  headers['anthropic-beta'] = beta_headers.join(',') unless beta_headers.empty?
  headers
end
```

## Capability Types

### Multi-valued Capabilities
Options with different enablement requirements:
- `context_window`: 200k, 1m
- `cache_ttl`: 5m, 1h
- `thinking`: none, interleaved, full

### Boolean Capabilities
Simple on/off:
- `json_mode`: true/false
- `alternation_required`: true/false
- `prompt_caching`: true/false

### Numeric Capabilities
Limits:
- `max_output_tokens`: 64000
- `max_input_tokens`: 1000000

## Catalog Refresh Strategy

**Problem**: API doesn't provide capability info, so we manually maintain it. Need to merge on refresh.

**Solution**:
```ruby
def merge_capabilities(api_entry, manual_entry)
  merged = api_entry.dup

  # Preserve manually defined capabilities
  if manual_entry && manual_entry['capabilities']
    merged['capabilities'] = deep_merge(
      api_entry['capabilities'] || {},
      manual_entry['capabilities']
    )
  end

  merged
end
```

**Rules**:
1. API data takes precedence for `model`, `provider`, basic fields
2. Manual `capabilities` are preserved and merged
3. API can add new capability values, but not remove manual ones
4. Delta log tracks capability changes

## Future: Ruby DSL (Phase 2)

```ruby
# storage/catalog/logostratum.rb
Nexum::Catalog.define do
  model "anthropic/claude-3-5-sonnet" do
    provider :anthropic

    context_window :1m, default: true, beta: 'context-1m-2025-08-07'
    context_window :200k

    cache_ttl :1h, beta: 'extended-cache-ttl-2025-04-11', cost: 2.0
    cache_ttl :5m, default: true

    thinking :interleaved, beta: 'interleaved-thinking-2025-05-14' do
      requires temperature: 1.0
    end

    boolean_capability :json_mode, true
    boolean_capability :prompt_caching, true

    validate do
      if thinking == :interleaved && temperature != 1.0
        error "Interleaved thinking requires temperature = 1.0"
      end
    end
  end
end
```

**Benefits**:
- Comments
- Symbols instead of strings
- Validation blocks
- Type safety
- Better IDE support
- More expressive

## Implementation Status

### ✅ Phase 1: JSON Structure
1. ✅ Design capability structure
2. ✅ Created catalog structure
3. ⏳ CatalogRefresh merge logic (future work)
4. ✅ Added Manifest#preferred_capabilities
5. ✅ Updated AnthropicAdapter
6. ✅ Updated tests

### ✅ Phase 2: Ruby DSL (Completed)
1. ✅ Created `Nexum::Providers::CatalogDSL`
2. ✅ Created Ruby DSL catalog (storage/catalog/logostratum.rb)
3. ⏳ Validation framework (future enhancement)
4. ✅ Updated LogostratumCatalog loader
5. ✅ Migrated adapter code

### Implementation Details

**Files Created:**
- `lib/nexum/providers/catalog_dsl.rb` - DSL for defining model capabilities
- `storage/catalog/logostratum.rb` - Canonical catalog definition using Ruby DSL
- `spec/nexum/providers/catalog_dsl_spec.rb` - DSL tests
- `spec/nexum/conversation/manifest_capability_spec.rb` - Manifest capability tests
- `spec/nexum/providers/anthropic_adapter_capability_spec.rb` - Adapter capability negotiation tests

**Files Modified:**
- `lib/nexum/conversation/manifest.rb` - Added preferred_capabilities support
- `lib/nexum/providers/anthropic_adapter.rb` - Implemented capability-driven beta header negotiation
- `lib/nexum/providers/logostratum_catalog.rb` - Added Ruby DSL loading
- `lib/nexum/providers/switch_policy.rb` - Fixed deep copy for new catalog structure

## Decisions Made

1. **Default selection**: ✅ Auto-select defaults via `Manifest.build_default_preferences`
   - Implemented: Catalog entries marked with `default: true` are auto-selected
   - Can be overridden via explicit `preferred_capabilities` parameter

2. **Validation location**: ✅ Adapter enforces requirements
   - Catalog defines metadata (beta headers, cost, notes)
   - Adapter extracts and applies beta headers based on preferred_capabilities
   - Future: Add validation framework in CatalogDSL

3. **Unknown capabilities**: ✅ Warn to STDERR, continue processing
   - Adapter warns when requested capability name not found in catalog
   - Adapter warns when requested capability value not found (with available options)
   - Continues processing after warning (non-fatal)
   - Helps catch typos: `'1M'` vs `'1m'`, `'context_windw'` vs `'context_window'`

4. **Catalog format**: ✅ Ruby DSL with quoted symbols
   - Use `:'1m'` instead of `:1m` for numeric-starting symbols
   - More readable than JSON
   - Supports comments and better structure
