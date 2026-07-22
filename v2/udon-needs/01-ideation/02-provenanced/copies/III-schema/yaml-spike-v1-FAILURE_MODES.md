---
source: autopax operata-yaml-spike (autopax/docs/tactical/2025-12-03-operata-yaml-spike/FAILURE_MODES.md) — Dec 2025 empirical stress test of YAML+yq for document/schema storage
gathered: 2026-07-21
status: gathered (verbatim copy of v1 spike doc)
paths:
  - CROWN ROW. The catalog of what YAML+yq SILENTLY ACCEPT (misspelled fields, invalid enums, missing required, wrong types, duplicate IDs, orphaned refs) is a direct requirements list for a schema/document checker: every 'accepted silently' row is a check UDON/harness tooling must add. Cross-tier: empirical practice (Tier-2) generating checker demand that Tier-1 ideology only asserted.
source_commit: 033af13 (autopax); yaml-spike dir last touched a6942e8 2025-12-04
categories: [schema-versioning, schema-validation, empirical-stress-test, yaml-failure-modes, agent-recovery, cross-tier-convergence]
why_included: >
  v1 initial spike
---

# YAML + yq Failure Modes

This document catalogs how the system behaves when things go wrong.

## Syntax Errors

yq provides **clear, actionable error messages** for YAML syntax errors:

### Test Results

| Error Type | yq Behavior | Error Message Quality | Recovery |
|------------|-------------|----------------------|----------|
| **Unclosed quote** | ✗ Rejects file | Clear: `found unexpected end of stream` | Edit file, fix quote |
| **Bad indentation** | ✗ Rejects file | Clear: `mapping values not allowed in context` | Fix indentation |
| **Missing colon** | ✗ Rejects file | Clear: `could not find expected ':'` | Add colon |
| **Unclosed bracket** | ✗ Rejects file | Clear: `did not find expected ',' or ']'` | Close bracket |
| **Mixed tabs/spaces** | ✗ Rejects file | Clear: `found tab character that violates indentation` | Use spaces only |

**Finding:** yq is **strict about syntax** but provides **helpful error messages**. Files fail fast with clear guidance.

### Example Error Output

```
Error: bad file 'test.yml': yaml: line 3: found unexpected end of stream
```

- Shows exact line number
- Describes what went wrong
- Deterministic (same error every time)

## Schema Violations

yq parses YAML structure but **does not validate semantics**:

| Error Type | yq Behavior | Impact | Mitigation |
|------------|-------------|--------|------------|
| **Misspelled field** (`statuss: pending`) | ✓ Accepts | Silent data corruption | Manual validation |
| **Invalid enum value** (`status: active`) | ✓ Accepts | Logic errors downstream | Manual validation |
| **Missing required field** | ✓ Accepts | Queries may fail | Manual validation |
| **Wrong type** (`tasks: "not an array"`) | ✓ Accepts | Queries behave unexpectedly | Manual validation |

**Finding:** yq is **permissive about content**. Schema validation must be implemented separately.

### Recommendation

Create a validation script (already implemented: `validate_all.sh`) that checks:
1. Required fields present
2. Status values are in allowed set
3. IDs are unique
4. Tasks field is an array

Run validation:
- Before commit (git pre-commit hook)
- After manual edits
- Periodically in CI

## Multi-File Resilience

**Question:** Does one broken file affect others?

**Answer:** No. Each file is parsed independently.

### Test Results

Setup:
- 2 valid YAML files
- 1 broken YAML file (unclosed quote)

Behavior when querying across all files:
```bash
$ for file in *.yml; do yq eval '.id' "$file"; done

Error: bad file 'broken-001.yml': yaml: line 3: found unexpected end of stream
valid-001
valid-002
```

**Finding:**
- ✅ Valid files are processed successfully
- ✗ Broken file produces error but doesn't crash
- ✅ Processing continues to next file

This is **good for resilience** - one corrupted effort file doesn't break the entire system.

## Human Error Resilience

### Extra Newlines

**Test:** File with many blank lines

**Result:** ✅ Accepted without issues

**Finding:** YAML is resilient to extra whitespace. Manual editing is safe.

### Unicode Characters

**Test:** Emoji and non-ASCII characters
```yaml
name: Implement 🚀 feature
intent: Add emoji support for 日本語
```

**Result:** ✅ Accepted and preserved correctly

**Finding:** Full Unicode support. International users can use native language.

### Deep Nesting

**Test:** 4 levels of nested tasks

**Result:** ✅ Accepted, no performance impact

**Finding:** Schema supports arbitrary nesting depth without issues.

## Concurrency Issues

See separate concurrency test results. Summary:

| Scenario | Safe? | Notes |
|----------|-------|-------|
| **Concurrent reads** | ✅ Yes | Always safe |
| **Concurrent writes (same file)** | ❌ No | Race conditions, data loss |
| **Read during write** | ⚠️ Unpredictable | May see old/new/corrupted data |
| **Writes to different files** | ✅ Yes | No conflicts |

**Finding:** File-based storage is **not safe for concurrent writes** without explicit locking.

### Mitigation Strategies

1. **Single-agent assumption:** If only one agent/process writes at a time, no issue
2. **File locking:** Implement advisory locks (see `test_concurrency.sh` for example)
3. **Git as coordination:** Use git branches/PRs for concurrent work
4. **Different files:** Design so agents work on separate effort files

## Recovery Mechanisms

### Git Checkout

**Test:** Corrupt a file, then `git checkout -- file.yml`

**Result:** ✅ Instant recovery to last committed state

**Finding:** Git is an **excellent backup mechanism** for corruption/mistakes.

### Detecting Corruption

**Script:** `validate_all.sh`

**What it does:**
1. Attempts to parse every YAML file
2. Reports which files are broken
3. Exit code 1 if any invalid

**Usage:**
```bash
$ ./scripts/validate_all.sh

ERROR: Invalid YAML syntax in broken-001.yml
WARNING: Missing _schema in old-format.yml

=== Validation Summary ===
Total files:   100
Valid files:   98
Invalid files: 2
```

**Finding:** Easy to detect and isolate broken files.

## Edge Cases

### Empty Tasks Array

**Test:** `tasks: []`

**Result:** ✅ Valid, queries return no results (expected)

### Null Values

**Test:** `intent: null`

**Result:** ✅ Valid, yq treats as missing field

### Very Long Strings

**Test:** 10,000 character task name

**Result:** ✅ Accepted, no truncation, no performance impact

## What CAN'T Be Validated

yq validates **syntax** but not **semantics**. These errors go undetected:

1. **Duplicate IDs:** yq won't detect `id: task-001` appearing twice
2. **Circular references:** Schema doesn't prevent a task referencing itself
3. **Orphaned references:** If tasks reference each other by ID, broken links go unnoticed
4. **Business logic:** e.g., "completed task with pending subtasks"

**Recommendation:** Build a semantic validator that checks:
- ID uniqueness across all files
- Status consistency (completed effort → all tasks completed)
- Date ordering (origin dates make sense)
- Reference integrity (if we add cross-references later)

## Summary

### What Fails Gracefully

✅ Syntax errors (clear messages, fail fast)
✅ Extra whitespace (ignored)
✅ Unicode content (full support)
✅ Deep nesting (no limits)
✅ One broken file (others still work)
✅ Corrupted file recovery (git checkout)

### What Doesn't Fail Gracefully

❌ Schema violations (accepted silently)
❌ Concurrent writes (data loss possible)
❌ Semantic errors (no detection)

### Recommendations for Production

1. **Add validation layer:**
   - Run `validate_all.sh` in git hooks
   - Check schema compliance, not just syntax
   - Validate IDs are unique

2. **Document editing rules:**
   - Use spaces, not tabs
   - Always use allowed status values
   - Don't manually edit deeply nested structures (error-prone)

3. **Use git for safety:**
   - Commit often
   - Review diffs before committing
   - Use branches for risky changes

4. **Assume single-writer:**
   - Don't allow concurrent writes without locking
   - If multi-agent, use file locking or separate files per agent
