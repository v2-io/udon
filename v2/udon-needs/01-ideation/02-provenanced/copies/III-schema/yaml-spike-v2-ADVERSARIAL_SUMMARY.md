---
source: autopax operata-yaml-spike (autopax/docs/tactical/2025-12-03-operata-yaml-spike-v2/ADVERSARIAL_SUMMARY.md) — Dec 2025 empirical stress test of YAML+yq for document/schema storage
gathered: 2026-07-21
status: gathered (verbatim copy of v2 adversarial doc)
paths:
  - CROWN ROW — the methodology/epistemic-arc doc: what happy-path testing MISSED and why. The 'Lessons' ('Works != Production Ready', 'design for failure', 'measure don't assume') are agentic-tooling design wisdom independent of the storage choice — directly reusable by harness engineers designing any agent-facing store/checker.
source_commit: 033af13 (autopax); yaml-spike dir last touched a6942e8 2025-12-04
categories: [schema-versioning, schema-validation, empirical-stress-test, yaml-failure-modes, agent-recovery, cross-tier-convergence]
why_included: >
  v2 adversarial review
---

# Adversarial Testing Summary: What We Learned by Trying to Break YAML + yq

**Date**: 2025-12-03
**Approach**: Be ADVERSARIAL - try to break things, find edge cases, stress test realistically
**Duration**: ~4 hours of intensive testing
**Verdict**: **Found 6 critical issues** that the initial spike missed

## Why Adversarial Testing?

The initial spike was "too gentle" - it validated that YAML + yq WORKS, but didn't ask:

- What happens when things go WRONG?
- Can agents RECOVER from corruption?
- What are the REAL performance limits?
- How HARD are schema migrations REALLY?
- What about CSV as an alternative?
- Can the system handle PATHOLOGICAL inputs?

This adversarial spike answers those questions **honestly**.

## The 6 Critical Findings

### 1. DUPLICATE KEYS = SILENT DATA LOSS ⚠ CRITICAL

**What we tested**:
```yaml
name: "Original Name"
status: pending
name: "Duplicate Name"  # OVERWRITES PREVIOUS
```

**Expected**: Parser error, data preserved.

**Actual**: ✗ YAML parser **silently accepts** duplicates, **last value wins**.

**Impact**: Data loss that is **UNDETECTABLE** without custom validation.

**Why missed in initial spike?** We assumed YAML parsers reject duplicates (they don't).

**Fix**: MUST implement duplicate key validator (~100 LOC).

**Blocker?** NO - but validator is MANDATORY.

---

### 2. MEMORY: >1GB at 10K Tasks

**What we tested**: Measured yq memory usage on files from 100 to 50,000 tasks.

**Finding**: Memory usage is **~50x file size**.

| Tasks | File Size | Memory |
|-------|-----------|--------|
| 10,000 | 21 MB | **1.1 GB** |
| 50,000 | 106 MB | **5.4 GB** |

**Why missed in initial spike?** Previous memory measurement FAILED (incorrect /usr/bin/time usage).

**Impact**: OPERATA files >20MB will consume >1GB memory (risky on typical laptops).

**Fix**: Enforce **max file size: 10 MB** (~10,000 tasks).

**Blocker?** NO - expected OPERATA usage is <10MB.

---

### 3. ~1% OF QUERIES ARE PATHOLOGICAL

**What we tested**: Ran 1000+ random queries, measured distribution.

**Finding**: **~1% of queries timeout** (>120 seconds).

**Pathological pattern discovered**:

| Query | Time |
|-------|------|
| `.. \| select(...)` | 100ms (OK) |
| `.. \| ..` | 20,600ms (SLOW) |
| `.. \| .. \| ..` | >120s (TIMEOUT) |

**Why missed in initial spike?** We only tested "sensible" queries, not adversarial combinations.

**Impact**: Agent-generated queries can **hang the system** without timeouts.

**Fix**:
- Query timeout: 5 seconds
- Detect `.. | ..` pattern and reject

**Blocker?** NO - can be mitigated with timeouts.

---

### 4. CSV IS 50% SLOWER (Despite Being Smaller)

**What we tested**: Compared YAML, JSON, CSV performance.

**Finding**:

| Format | File Size | Query Speed |
|--------|-----------|-------------|
| YAML | 130 KB | 11.12ms |
| CSV | 76 KB (42% smaller!) | 16.65ms (50% slower!) |

**Why missed in initial spike?** We assumed smaller = faster.

**Impact**: CSV is NOT a viable alternative for OPERATA.

**Additional CSV problems**:
- Multi-level hierarchy queries are COMPLEX
- Loss of type information (tags become strings)
- Arrays/objects become delimited strings

**Blocker?** N/A - just means CSV is ruled out.

---

### 5. SCHEMA MIGRATIONS REQUIRE CUSTOM TOOLING

**What we tested**: Migrated 100 files from schema v1 to v2.

**Finding**: Migration is POSSIBLE but:
- NOT atomic (can fail mid-migration)
- NOT transactional (no automatic rollback)
- Race conditions possible (concurrent writes)
- Requires ~50 LOC per migration + ~200 LOC infrastructure

**Comparison**:

| Aspect | YAML | SQLite |
|--------|------|--------|
| LOC per migration | ~50 | ~10 |
| Atomicity | ✗ Per-file | ✓ Per-transaction |
| Infrastructure | ~200 LOC custom | ✓ Existing tools |

**Why missed in initial spike?** We said "no migrations needed" - naive assumption.

**Impact**: Schema evolution is HARDER than expected.

**Fix**: Accept complexity OR choose SQLite.

**Blocker?** NO - acceptable if schema changes are RARE (<1/month).

---

### 6. AGENT RECOVERY REQUIRES BACKUPS

**What we tested**: Can Agent C recover if Agent B corrupts file?

**Finding**: Recovery rate:
- **With backups**: 83% (5/6 scenarios)
- **Without backups**: 16% (1/6 scenarios)

**Critical scenario**: Duplicate keys have **SILENT data loss** - no recovery possible.

**Why missed in initial spike?** We didn't test agent recovery at all.

**Impact**: **Backup infrastructure is MANDATORY** for agent resilience.

**Fix**: Implement automatic backups (~200 LOC).

**Blocker?** NO - but backups are REQUIRED for production.

---

## What the Initial Spike Got RIGHT

These findings from the initial spike remain **valid and important**:

1. ✓ **Nesting limit at 1126 levels** (Ruby stack overflow) - CONFIRMED
2. ✓ **Performance acceptable for expected scale** (100-1000 tasks) - CONFIRMED
3. ✓ **YAML more compact than JSON** for wide hierarchies - CONFIRMED
4. ✓ **Atomic writes need unique temp filenames** - CONFIRMED

**Credit**: Initial spike was methodical and thorough for happy-path testing.

## What the Initial Spike MISSED

The adversarial approach revealed:

1. ✗ **Duplicate keys** - Not tested, critical issue
2. ✗ **Memory limits** - Measurement failed, limits unknown
3. ✗ **Pathological queries** - Only tested "sensible" queries
4. ✗ **CSV alternative** - Not evaluated
5. ✗ **Schema migrations** - Assumed "no migrations needed"
6. ✗ **Agent recovery** - Not tested at all

**Lesson**: **Adversarial testing finds different bugs than happy-path testing.**

## Required Infrastructure (Updated)

Based on adversarial findings, YAML + yq requires:

### MANDATORY Safeguards (~500 LOC, 2-3 days)

1. **Duplicate Key Validator** (~100 LOC)
   - Detect duplicate keys before write
   - Fail loudly, not silently

2. **Backup System** (~200 LOC)
   - Automatic backup before every write
   - Keep last N backups
   - Restore on corruption

3. **Query Safety** (~100 LOC)
   - Timeout all queries (5 seconds)
   - Detect `.. | ..` patterns
   - Limit result set size (1000 items)

4. **Validation Layer** (~100 LOC)
   - Schema validation
   - File size limits (10 MB)
   - Circular reference detection

### RECOMMENDED Additional (~300 LOC, 1-2 days)

5. **Migration Framework** (~200 LOC)
   - Version tracking
   - Idempotent migrations
   - Rollback support

6. **Recovery Manager** (~100 LOC)
   - Automatic fix heuristics
   - Human escalation

**Total**: ~800 LOC, 4-5 days of work

**Is this acceptable?** Depends on OPERATA's priorities:
- **YES** if human-readable/git-friendly is critical
- **NO** if "just works" is priority (→ use SQLite)

## Comparison Matrix (Updated with Adversarial Findings)

| Criterion | YAML + yq | SQLite | Winner |
|-----------|-----------|--------|--------|
| Human-readable | ✓ Yes | ✗ Binary | **YAML** |
| Git-friendly | ✓ Diffable | ✗ Conflicts | **YAML** |
| Data safety | ✗ Needs validators | ✓ Constraints | **SQLite** |
| Memory efficiency | ⚠ 50x file size | ✓ 1-2x | **SQLite** |
| Query safety | ⚠ Needs timeouts | ✓ Built-in | **SQLite** |
| Schema migrations | ⚠ ~200 LOC custom | ✓ Tools exist | **SQLite** |
| Agent recovery | ⚠ ~500 LOC custom | ✓ Transactions | **SQLite** |
| Setup complexity | ✓ Just files | ~ Migrations | **YAML** |
| Required infra | ⚠ ~800 LOC | ✓ None | **SQLite** |

**Score**: YAML 3, SQLite 6

**Interpretation**: SQLite is **technically superior**, but YAML aligns with OPERATA philosophy.

**Decision**: Accept infrastructure cost for human/git benefits, OR choose SQLite for simplicity.

## Updated Recommendation

### RECOMMEND YAML + yq IF:

1. ✓ Willing to invest ~500-800 LOC in safeguards
2. ✓ Human-readable/git-friendly is TOP priority
3. ✓ Expected usage <10MB, <10K tasks
4. ✓ Schema changes rare (<1/month)
5. ✓ Single-user, local usage

### RECOMMEND SQLite IF:

1. ✓ "Just works" is priority (no custom infrastructure)
2. ✓ Data integrity is critical
3. ✓ Expect frequent schema changes
4. ✓ Multi-user or concurrent access
5. ✓ Files may exceed 10MB

## Lessons from Adversarial Testing

### 1. "Works" ≠ "Production Ready"

Initial spike showed YAML + yq **works**. Adversarial testing showed it needs **safeguards**.

**Lesson**: Always ask "What can go wrong?" not just "Does it work?"

### 2. Edge Cases Are Where Bugs Live

- Duplicate keys: Edge case, but CRITICAL
- Pathological queries: <1% occurrence, but HANGS system
- Memory limits: Only matters at scale, but HARD limit

**Lesson**: Test edge cases, not just happy paths.

### 3. Agent Resilience Requires Design

Agents WILL corrupt files (bugs, interruptions, etc.). System must recover WITHOUT human intervention.

**Lesson**: Design for failure, not just success.

### 4. "Simple" Systems Have Hidden Complexity

YAML + yq seems simple (just files + queries). But production needs:
- Duplicate key validation
- Backup infrastructure
- Query timeouts
- Recovery mechanisms

**Lesson**: Simplicity is not free - it requires work.

### 5. Measure, Don't Assume

- Assumption: "CSV smaller = faster" → WRONG (50% slower)
- Assumption: "No migrations needed" → WRONG (migrations are complex)
- Assumption: "yq uses minimal memory" → WRONG (50x file size)

**Lesson**: Measure reality, don't assume.

## Test Artifacts

**Generated files** (available in `data/`):
- CSV test files: ~180 KB
- Memory test files: 231 KB to 106 MB
- Adversarial test file: 5.4 MB
- Statistical test file: 5.4 MB
- Migration test files: 100 × ~2 KB
- Corruption test files: Various
- Agent recovery test files: Various

**Total test data**: ~220 MB

**Test scripts** (available in `bin/`):
- `test_csv_queries.rb`
- `test_memory_limits.rb`
- `test_statistical_performance.rb`
- `test_adversarial_queries.rb`
- `test_corruption_recovery.rb`
- `test_schema_migration.rb`
- `test_concurrent_stress.rb`
- `test_agent_recovery.rb`

**Total test code**: ~1,200 LOC

**Analysis documents**:
- `CSV_ANALYSIS.md` - CSV viability
- `MEMORY_ANALYSIS.md` - Memory limits
- `ADVERSARIAL_TESTS.md` - Pathological queries
- `RECOVERY_SCENARIOS.md` - Agent recovery
- `MIGRATION_REALITY.md` - Schema migrations
- `STATISTICAL_ANALYSIS.md` - Query distribution
- `VERDICT_UPDATED.md` - Comprehensive verdict
- `ADVERSARIAL_SUMMARY.md` (this document)

## Final Thoughts

**Initial spike**: "YAML + yq is viable"
**Adversarial spike**: "YAML + yq is viable **WITH SAFEGUARDS**"

The difference: **Epistemic honesty**.

Initial spike was **optimistic** - tested happy paths, assumed edge cases would be fine.

Adversarial spike was **skeptical** - tried to break things, found real limits.

**Both are valuable**:
- Initial spike: Proves concept, validates approach
- Adversarial spike: Finds risks, defines safeguards

**Together**: Provides **honest, complete assessment** for decision-making.

---

**Recommendation to Joseph**:

If OPERATA's philosophy (human-readable, git-friendly, agent-editable) is **core to the vision**:
→ **Accept YAML + yq**, invest in safeguards (~4-5 days)

If "just works" is more important:
→ **Choose SQLite**, save implementation time

Both are **valid choices** for different priorities.

The adversarial testing gives you the **real costs** to make an informed decision.

---

**Adversarial spike complete**. Every finding documented with evidence, not assumptions.
