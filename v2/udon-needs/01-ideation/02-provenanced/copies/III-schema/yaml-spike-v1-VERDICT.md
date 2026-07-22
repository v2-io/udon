---
source: autopax operata-yaml-spike (autopax/docs/tactical/2025-12-03-operata-yaml-spike/VERDICT.md) — Dec 2025 empirical stress test of YAML+yq for document/schema storage
gathered: 2026-07-21
status: gathered (verbatim copy of v1 spike doc)
paths:
  - CROWN ROW — the 'before' of the epistemic arc: the optimistic initial verdict ('YES, with caveats', 80% score). Kept because the arc from this to VERDICT_UPDATED is itself the finding: happy-path testing under-counts the demand a checker must serve. Also the clearest statement of WHY human-readable+git-diffable storage is chosen over SQLite despite technical inferiority — the demand behind UDON's whole positioning.
source_commit: 033af13 (autopax); yaml-spike dir last touched a6942e8 2025-12-04
categories: [schema-versioning, schema-validation, empirical-stress-test, yaml-failure-modes, agent-recovery, cross-tier-convergence]
why_included: >
  v1 initial spike
---

# VERDICT: YAML + yq for OPERATA Storage

**Date:** 2025-12-03
**Author:** Claude (stress test spike)
**Status:** Recommendation for decision

---

## Executive Summary

**Is YAML + yq viable for OPERATA?**

**✅ YES, with caveats**

YAML + yq is a **solid choice** for OPERATA's hierarchical effort/task tracking system **if** the expected scale stays under 100-200 effort files and write patterns are primarily single-agent sequential.

The approach excels at git integration, human readability, and simplicity. Performance is acceptable for human-interactive use (~0.7s queries). Major limitations are concurrency safety and lack of built-in schema validation.

---

## Strengths (Why This Works)

### 1. Git Integration (⭐⭐⭐⭐⭐)

**Outstanding.** This is the killer feature.

- **Diffs are readable:** Changes show exactly what task status changed
- **Merges work well:** Conflicts only when same task edited by two agents
- **History is clear:** Can track who changed what and when
- **Blame works:** Can trace any task back to when it was added
- **Revert is trivial:** `git checkout -- file.yml` fixes corruption instantly

**Real example:**
```diff
  - id: task-001
    name: Implement authentication
-   status: pending
+   status: completed
```

This is **far superior** to SQLite (binary, no diffs) or JSON (noisy diffs).

### 2. Human Readable/Editable (⭐⭐⭐⭐⭐)

**Excellent.** Agents with 100% context turnover can understand the format immediately.

- Self-documenting structure
- Easy to manually fix broken tasks
- Can edit in any text editor
- No special tools required
- Unicode support (emojis, international characters)

**For OPERATA specifically:** Future agents can read effort files directly without learning complex APIs or schemas.

### 3. Performance (⭐⭐⭐⭐)

**Good enough.**

- **0.7s** to query 100 files (32K tasks)
- **0.015s** to update one task
- **15 MB** peak memory
- **Linear scaling:** Predictable performance as data grows

**For OPERATA use case:**
- Queries are human-driven (seconds between requests): ✅ Fine
- Scale expectation is < 100 efforts: ✅ Well within limits
- No real-time requirements: ✅ 0.7s is acceptable

### 4. Simplicity (⭐⭐⭐⭐⭐)

**Minimal dependencies.** Just yq (single binary, 3MB).

- No database server
- No migrations
- No connection management
- No ORM complexity
- Shell scripts are the API

**For agent handoffs:** New agents can start working immediately without setup.

### 5. Resilience (⭐⭐⭐⭐)

**Robust against common errors.**

- Syntax errors fail fast with clear messages
- One broken file doesn't affect others
- Extra whitespace is tolerated
- Deep nesting works without issues
- Git is the backup/recovery mechanism

---

## Weaknesses (Why This Might Not Work)

### 1. Concurrency (⭐)

**Major limitation.** YAML files are **not safe for concurrent writes**.

**Test results:**
- Multiple processes writing same file → race conditions, data loss
- Read during write → unpredictable results
- No built-in locking mechanism

**Mitigation options:**
- **Assume single-agent:** If only one agent/human writes at a time, no problem
- **File locking:** Implement advisory locks (added complexity)
- **Git coordination:** Use branches/PRs for concurrent work
- **Separate files:** Each agent works on different effort files

**For OPERATA:**
- If workflow is single-agent sequential: ✅ Not an issue
- If multiple agents might write simultaneously: ❌ Need locking or alternative

### 2. Schema Validation (⭐⭐)

**No built-in validation.** yq parses YAML but doesn't validate semantics.

**What goes undetected:**
- Misspelled fields (`statuss: pending` instead of `status`)
- Invalid enum values (`status: active` instead of `in_progress`)
- Missing required fields
- Duplicate IDs
- Type errors (`tasks: "not an array"`)

**Mitigation:**
- Build `validate_all.sh` (done in spike)
- Run in git pre-commit hook
- Validate after manual edits

**For OPERATA:**
- Acceptable if validation is added to workflow
- Risk of silent data corruption without validation

### 3. Query Performance at Scale (⭐⭐⭐)

**Degrades linearly.**

| Files | Query Time | User Experience |
|-------|------------|-----------------|
| 50 | 0.35s | ✅ Responsive |
| 100 | 0.70s | ✅ Acceptable |
| 200 | 1.4s | ⚠️ Noticeable |
| 500 | 3.5s | ❌ Slow |

**Bottleneck:** Every query re-parses all files (no index, no cache).

**Mitigation:**
- Add in-memory cache (Ruby objects)
- Build index file for common queries
- Use SQLite index layer (keep YAML as canonical storage)

**For OPERATA:**
- If staying < 100 efforts: ✅ Fast enough
- If growing > 200 efforts: ⚠️ Need optimization

### 4. No Transactions (⭐⭐)

**Atomicity limitations.**

- Can't update multiple files atomically
- Can't ensure consistency across efforts
- No rollback mechanism (except git)

**Example failure scenario:**
1. Update task in effort-001.yml (succeeds)
2. Update related task in effort-002.yml (fails)
3. Now in inconsistent state

**For OPERATA:**
- If most operations are single-file: ✅ Not an issue
- If need multi-file consistency: ⚠️ Need to handle manually

---

## Decision Matrix

| Criterion | Weight | Score (1-5) | Weighted | Notes |
|-----------|--------|-------------|----------|-------|
| **Git integration** | 5 | 5 | 25 | Critical for archaeology/provenance |
| **Human readable** | 4 | 5 | 20 | Essential for agent handoffs |
| **Query performance** | 3 | 4 | 12 | Acceptable at expected scale |
| **Write performance** | 2 | 5 | 10 | Fast enough for single-agent |
| **Concurrency safety** | 3 | 1 | 3 | Requires mitigation |
| **Schema validation** | 3 | 2 | 6 | Requires external validation |
| **Simplicity** | 4 | 5 | 20 | Minimal dependencies |
| **Resilience** | 3 | 4 | 12 | Good error handling |

**Total Score: 108 / 135 (80%)**

---

## Comparison to Alternatives

### SQLite

**Pros:**
- Fast queries (< 1ms)
- Built-in schema validation
- ACID transactions
- Concurrent access

**Cons:**
- Binary format (no git diffs)
- Not human-readable
- Requires Ruby bindings
- No direct editing
- Migration complexity

**Verdict:** Better for high-scale or concurrent scenarios, worse for git integration and agent archaeology.

### Markdown + Frontmatter

**Pros:**
- Human readable
- Git friendly
- Simple

**Cons:**
- No structured queries
- Hard to update programmatically
- No recursive nesting
- Performance worse than YAML

**Verdict:** Good for documents, poor for structured data.

### JSON

**Pros:**
- Structured data
- Wide tooling support
- Similar performance to YAML

**Cons:**
- Harder to read than YAML
- Noisier diffs
- No comments allowed
- More quotes/braces (error-prone)

**Verdict:** Slightly worse than YAML for human editing, similar otherwise.

---

## Recommendations

### ✅ Use YAML + yq if:

1. **Scale expectation is < 200 effort files**
2. **Write pattern is single-agent sequential** (or willing to implement locking)
3. **Git integration is high priority** (archaeology, diffs, history)
4. **Human readability matters** (agent handoffs, manual edits)
5. **Simplicity is valued** (minimal dependencies, no database)

### ❌ Consider alternatives if:

1. **Scale will exceed 500 effort files** → Use SQLite with YAML export
2. **Multiple concurrent writers** → Use SQLite or implement robust locking
3. **Sub-100ms query latency required** → Use SQLite with caching
4. **Complex cross-effort queries needed** → Use relational database

### 🟡 Hybrid approach worth considering:

**YAML as canonical storage + SQLite as query index**

- Keep effort files in YAML (git-friendly, human-editable)
- Build SQLite index on startup for fast queries
- Rebuild index from YAML as source of truth
- Best of both worlds (but more complexity)

---

## Implementation Roadmap

If proceeding with YAML + yq:

### Phase 1: MVP (Proven in spike)

- [x] Define schema (`schema.md`)
- [x] Create tooling scripts (`create_effort.sh`, `add_task.sh`, etc.)
- [x] Implement validation (`validate_all.sh`)
- [x] Test at scale (100 files, 32K tasks)

### Phase 2: Production-Ready

- [ ] Add Ruby wrapper around yq (hide shell scripts)
- [ ] Implement caching layer (parse once, cache in memory)
- [ ] Add git pre-commit hook (run validation)
- [ ] Document editing guidelines
- [ ] Add ID uniqueness check to validation
- [ ] Implement safe update patterns (atomic writes)

### Phase 3: Optimization (if needed)

- [ ] Build index file for common queries
- [ ] Add "active tasks" materialized view
- [ ] Implement file locking for concurrent access
- [ ] Consider SQLite index layer if scale exceeds limits

---

## Risks and Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Scale exceeds 200 files** | Low | High | Monitor file count, plan migration to SQLite |
| **Concurrent writes cause data loss** | Medium | High | Document single-agent assumption, add locking if needed |
| **Schema drift (invalid data)** | Medium | Medium | Add validation to git hooks, run regularly |
| **Performance degrades** | Low | Medium | Add caching layer, build index |
| **File corruption** | Low | Low | Git is backup, validation detects issues |

---

## Final Recommendation

**Proceed with YAML + yq for OPERATA.**

The approach is **viable and appropriate** for the expected scale and usage patterns. The strengths (git integration, human readability, simplicity) align perfectly with OPERATA's goals of supporting agent archaeology and context handoffs.

The weaknesses (concurrency, schema validation) are **manageable** through process (single-agent sequential writes, validation in git hooks) and don't outweigh the benefits.

**Key success factors:**
1. Keep effort count < 200 (monitor and plan migration if approaching limit)
2. Implement validation layer (git pre-commit hook)
3. Document single-agent write assumption
4. Add caching if queries feel slow

**When to reconsider:**
- If effort count grows > 200
- If multiple agents need to write concurrently
- If query performance becomes a bottleneck

**Next step:**
Build Ruby wrapper around yq scripts to integrate into Autopax CLI, then implement validation layer.

---

## Appendix: Agent Perspective

**For an agent with 100% context turnover:**

**What you'll love:**
- YAML files are self-explanatory
- Can read and understand effort structure immediately
- Git history shows you exactly what changed
- Can manually fix issues in any text editor
- No "magic" - everything is explicit

**What you'll struggle with:**
- No IDE autocomplete for valid status values (until schema added)
- Easy to introduce typos in field names
- Have to remember to run validation
- Concurrent edits might conflict

**Overall experience: 8/10**

The format is intuitive and the tooling is simple. With validation in git hooks, the experience would be 9/10.
