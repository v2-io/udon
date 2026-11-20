---
source: operata — storage/document-infrastructure exploration session (Joseph + Claude, 2025-12-03), ~/src/operata/docs/exp/2025-12-03-operata-storage-exploration.md
gathered: 2026-07-21
status: gathered (verbatim copy)
paths:
  - operata/docs/exp/2025-12-03-operata-storage-exploration.md
source_commit: 624f840 (operata)
categories: [schema-versioning, storage-values-decision, cross-tier-hub, yaml-vs-sqlite, document-infrastructure, agent-100pct-turnover]
why_included: >
  The CONNECTIVE HUB of this whole section: the session that commissioned the crown yaml-spike, and
  the one document that ties it to the autopax ADRs and rowan. Frames storage as a VALUES decision
  ("human-readable/git-friendly is core to the vision, not a nice-to-have") driven by the agent-with-100%-
  context-turnover needing to read effort-state immediately. Names the schema/versioning/migration layer
  as "the real decision to be made next" — the exact demand rowan+ADR-008/012 answer. Also the repository-
  pattern sketch and the honest "apparent simplicity hides real complexity" reflection.
---

# Session: OPERATA Storage and Document Infrastructure Exploration

**Date**: 2025-12-03
**Participants**: Joseph, Claude
**Duration**: Extended session (~3 hours)
**Status**: Exploratory - no commits, findings documented

## What We Set Out to Do

Joseph wanted to think through the structure of OPERATA - the "hierarchical and meaningful graph of ongoing efforts" from the taxonomy. The current OPERATA.md is ad-hoc markdown, and he wanted to evolve it into something more principled.

The session became a wide-ranging exploration of storage approaches for structured documents in Autopax.

## Documents Reviewed

### Taxonomy and Architecture
- `TAXONOMY.md` - OPERATA appears at entity-level (PRINCIPIA) and LOCUS-level
- `docs/ADR/002b-signum-schema.md` - SIGNUM identity documents
- `docs/ADR/migration-proposals/006-mvp-conversation-sprint.md` - Agent cards section
- `docs/ADR/migration-proposals/008-yaml-and-schemas.md` - YAML conventions, Schemacop, versioning
- `docs/ADR/migration-proposals/010-markdown-parsing-and-validation.md` - Structural schemas for markdown

### Research Documents
- `docs/exp/2025-11-14-operata-principles.md` - 10 principles for intent management
- `docs/exp/2025-11-26-operata-system.md` - HTN decomposition, multi-agent coordination, speculative decomposition
- `docs/exp/2025-11-26-Hierarchical-Goal-and-Task-Based-Intent-Management.md` - 2025 landscape survey

### External Tools
- `~/src-ext/yq/` - Mike Farah's yq (jq for YAML/JSON/CSV)

## How Our Mental Model Evolved

### Starting Point: OPERATA as Index of Efforts

We began with Joseph's vision:
- OPERATA.md as an index of "efforts" (ADRs, phases, initiatives, tangents, curiosities)
- Each effort has: origin, intent, current state, what's next
- Each effort links to a per-effort task hierarchy
- 2-3 levels of nesting within OPERATA itself

The question: where do the per-effort task files live?

### First Fork: Where to Store Things?

Options emerged:
1. `operata/` at project root
2. `locus/operata/` where `locus/` contains all LOCUS-level components

Joseph leaned toward `locus/` - it mirrors the taxonomy and separates "how we work on this project" from "the project itself."

### Second Fork: Document vs Database

Joseph raised the fundamental tension:

> "At least until ELIs are further along, the context-window threshold means constant turnover and it is very easy for SOPs to either drift chaotically or become overly prescriptive in the wrong ways."

The ad-hoc markdown approach has limits:
- 100% session turnover amplifies mistakes
- Accumulated bureaucracy burdens focus-limited agents
- Minor corruptions propagate and magnify
- Prescriptive controls dampen creativity

And the resource efficiency question:
- We're using 4%-tier cognition (Opus-level) on 60%-tier problems (deterministic operations)
- "Where do finished tasks go?" is trivially easy in a database - it's just a status field

This led to the honest question: **implied text-based database (YAML/JSON with conventions) vs actual RDBMS?**

### Third Fork: Existing Tools vs Custom

We surveyed existing CLI task tools:
- Taskwarrior - mature, UUIDs, dependencies, but flat hierarchy
- dstask - git-friendly YAML, but no hierarchy
- Org-mode - unlimited hierarchy, but no persistent IDs

Joseph's requirements (unlimited hierarchy + extension + git-friendly) meant none fit perfectly.

But he noted: "I've quite possibly spent more time waiting for analyses and reviewing existing task systems than it would have taken with agentic help to simply build one bespoke to our needs."

### Convergence: Document Infrastructure Serves Multiple Purposes

The insight: we need document infrastructure (yq wrappers, schema validation, versioning) for SIGNUM, agent cards, and ADRs anyway. If we build it for those, it could also serve OPERATA.

```
DOCUMENT INFRASTRUCTURE
├── yq wrappers (query, update, validate)
├── Schema validation (Schemacop / ADR-008)
├── Structural schemas (ADR-010)
├── Comment-preserving normalization (psych-pure)
└── Serves: OPERATA, SIGNUM, Agent Cards, ADRs
```

### The Spike: YAML + yq Hypothesis

We launched a stress test to validate: "Can YAML files + yq serve as a reliable, git-friendly, schema-validatable task management backend?"

**v1 Spike** (too gentle):
- Found: 1126 level nesting limit (Ruby stack), linear query scaling
- Missed: Real breaking points, adversarial testing, CSV, memory limits

**v2 Spike** (adversarial):
- Found the real issues:
  1. **Duplicate keys = SILENT data loss** - YAML parsers accept duplicates, last value wins, no error
  2. **Memory: 50x file size** - 20MB file = 1GB RAM
  3. **~1% pathological queries** - `.. | ..` causes exponential slowdown
  4. **CSV 50% slower** - Despite being smaller (ruled out as alternative)
  5. **Schema migrations need ~200 LOC custom infrastructure**
  6. **Agent recovery needs backups** - Without backups, only 16% of corruption scenarios recoverable

### The Real Comparison

| Capability | YAML + yq | SQLite |
|------------|-----------|--------|
| Human-readable | Yes | No |
| Git-friendly | Yes (diffable) | No (binary) |
| Data integrity | ~500 LOC custom | Built-in |
| Recovery | ~200 LOC custom | Transactions |
| Schema migrations | ~200 LOC custom | ALTER TABLE |
| Query safety | ~100 LOC custom | Built-in |
| **Infrastructure cost** | **~800 LOC** | **0 LOC** |

### Where We Landed

**YAML + yq is viable** for OPERATA if:
- You invest ~500-800 LOC in safeguards (backup, validation, timeouts, recovery)
- Expected usage stays <10MB files, <10K tasks
- Schema changes are rare

**SQLite is technically superior** but:
- Loses human-readability
- Loses git-friendliness (binary diffs)
- Could use generated YAML exports for archaeology

**Hybrid approach** (SQLite + generated YAML views):
- Best of both worlds
- More moving parts

The choice is now a **values decision**, not a technical mystery.

## My Honest Perspective

The adversarial testing revealed something I should have suspected earlier: **apparent simplicity hides real complexity**.

YAML files seem simple - they're just text, you can edit them, git diffs work beautifully. But production-readiness requires:
- Validation (YAML doesn't do this)
- Backup/recovery (files don't do this)
- Schema evolution (files don't do this)
- Concurrent access safety (files don't do this)

SQLite provides all of this out of the box. The cost is losing human-readability and git archaeology.

For OPERATA specifically, I lean toward **the human-readable/git-friendly properties being core to the vision**, not nice-to-haves. The whole point is that agents with 100% context turnover need to be able to understand the state of efforts immediately. YAML achieves this in a way SQLite exports never quite would.

But the infrastructure cost (~500-800 LOC, 4-5 days work) is real and should be accepted with eyes open, not rationalized away.

## What Might Come Next

Joseph mentioned wanting to "back up and focus on the schema/versioning/migration layer as the real decision to be made next."

This makes sense. ADR-008 (YAML schemas, Schemacop, versioning) is foundational to all of this. Whether storage is YAML files, SQLite, or hybrid, you need:
- Schema definitions
- Version tracking
- Migration infrastructure
- Validation layer

Getting that right first, then deciding storage, is probably the right order of operations.

The spike artifacts in `docs/tactical/2025-12-03-operata-yaml-spike-v2/` provide detailed findings if you want to revisit the specific numbers.

## Files Created This Session

### Spike v1 (shallow, superseded)
- `docs/tactical/2025-12-03-operata-yaml-spike/` - Initial spike, too gentle

### Spike v2 (adversarial, useful)
- `docs/tactical/2025-12-03-operata-yaml-spike-v2/`
  - `ADVERSARIAL_SUMMARY.md` - Executive summary of adversarial findings
  - `VERDICT_UPDATED.md` - Complete verdict with infrastructure costs
  - `BREAKING_POINTS.md` - Specific failure thresholds
  - `BENCHMARK.md` - Performance analysis
  - `RECOVERY_SCENARIOS.md` - Agent recovery capabilities
  - `MIGRATION_REALITY.md` - Schema migration complexity
  - `CSV_ANALYSIS.md` - CSV ruled out
  - `MEMORY_ANALYSIS.md` - Real memory measurements
  - `lib/` - Ruby test code (~1200 LOC)
  - `bin/` - Test runners
  - `data/` - Generated test data (~220 MB)
  - `results/` - Benchmark JSON files

## Ruby Approaches to Schema/Model Work

Joseph asked about abstractions that let you "think in terms of the schema and valid operations on the schema and let someone else worry about how it's stored."

| Approach | What It Gives You |
|----------|-------------------|
| **ROM (Ruby Object Mapper)** | Multi-backend (YAML, SQL, memory). Repository pattern built-in. |
| **Sequel** | Lightweight ORM, supports SQLite and PostgreSQL. Less magic than ActiveRecord. |
| **Dry-rb stack** | dry-struct for typed entities, dry-system for DI. Build your own repos. |
| **Custom + Repository pattern** | POROs + interface. Maximum control, minimum magic. |
| **Ash-like declarative** | Doesn't exist in Ruby at Ash's level of sophistication. |

The idea was: define domain objects (Effort, Task) with operations, abstract storage behind a repository interface, then swap backends (YAML, SQLite, PostgreSQL) without touching domain logic.

```ruby
# Domain - doesn't know about storage
class Effort
  def transition_to(new_status)
    validate_transition!(new_status)
    @status = new_status
  end
end

# Repository interface
class EffortRepository
  def find(id); end
  def save(effort); end
  def active; end
end

# Swappable adapters
class YamlEffortRepository < EffortRepository; end
class SqliteEffortRepository < EffortRepository; end
```

This pattern would let you start with YAML (simplest), swap to SQLite if needed, without rewriting domain logic.

## Open Questions

1. **Schema/versioning first?** - Should ADR-008 implementation precede storage decisions?
2. **Hybrid viable?** - SQLite + generated YAML exports - worth exploring?
3. **Infrastructure investment** - Is ~500-800 LOC acceptable for YAML + yq benefits?
4. **PostgreSQL consideration** - Joseph mentioned familiarity and scalability - worth comparing to SQLite?

## Session Reflection

This was a good example of using an AI agent as a "sounding board" - Joseph had intuitions about the right direction but needed to explore the space to validate or invalidate them.

The spikes were valuable not because they gave a definitive answer, but because they gave **honest data** to make a values-based decision. The first spike was too gentle; the adversarial follow-up found the real issues.

The duplicate keys finding (silent data loss, undetectable) was genuinely surprising and important. That's the kind of thing that only adversarial testing reveals.

---

*Session notes by Claude. No commits made - exploratory session only.*
