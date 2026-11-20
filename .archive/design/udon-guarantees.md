# UDON Guarantees: An Exploration

**How do we provide appropriate guarantees for structured data without losing the
flexibility that makes UDON useful?**

This document explores the design space around consistency, validation, and
storage for UDON documents. It is exploratory, not prescriptive — the goal is to
understand the territory before choosing paths.

---

## The Problem Space

UDON occupies an underserved territory: documents that have both **soft parts**
(prose, commentary, narrative, subjective) and **hard parts** (structured data,
computable, deterministic). This is increasingly common in AI/agentic contexts,
where:

- Experiment logs combine hypothesis (prose) with metrics (data)
- Runbooks combine instructions (prose) with configuration (data)
- Conversations combine natural language with structured annotations
- Knowledge bases combine explanations with queryable facts

The same document might contain:

```udon
|experiment[checkout-button]
  :status running                 ; HARD: enum, machine-consumed
  :traffic-allocation 0.5         ; HARD: constrained numeric

  ## Hypothesis                   ; SOFT: free prose

  We believe the orange button will increase conversion by at least
  |{metric :value 0.15 :type relative-lift 15%}    ; HARD: inline
  because orange creates visual contrast...

  |variant[control]               ; HARD: schema-constrained
    :weight 0.5
    :description "Current blue"   ; SOFT: any string
```

The soft parts need flexibility. The hard parts need guarantees. These aren't
separate documents — they're interleaved.

---

## What "Guarantee" Means

Different levels of guarantee, roughly ordered by strength:

| Guarantee | Meaning |
|-----------|---------|
| **Syntactic validity** | Parses without error |
| **Schema conformance** | Values have correct types, required fields present |
| **Referential integrity** | References (`@element[key]`) resolve to existing targets |
| **Atomic operations** | Multi-element changes succeed or fail together |
| **Concurrent safety** | Parallel writes don't corrupt |
| **Queryability** | Can efficiently find/aggregate across documents |

Different use cases need different guarantees. The question: can you get partial
guarantees cleanly, or is it all-or-nothing?

---

## The Soft/Hard Distinction

**Hard parts** are:
- Machine-consumed for deterministic processing
- Contractual (other systems depend on them)
- Schema-constrained (values must conform)
- Identity-bearing (elements with keys that are referenced)

**Soft parts** are:
- Human-consumed for understanding
- Contextual (meaning comes from surrounding narrative)
- Flexible (any content valid)
- Subjective (commentary, rationale, alternatives)

The challenge: these aren't cleanly separable regions. Hard parts appear inline
within soft prose. Soft commentary explains hard configurations. The boundary is
fractal, not linear.

### Schema Implications

A schema for mixed content needs to express:
- "This element is required and must conform to this structure"
- "This element allows free prose children"
- "This inline annotation (`|{metric ...}`) has its own schema"
- "This string attribute is constrained" vs "this string is freeform"

This is more nuanced than typical schema languages, which assume everything is
either constrained or absent.

---

## Design Paths

### Path A: Better Serialization

UDON as replacement for JSON/YAML in config, data interchange, API responses.

- Structure-primary, prose incidental
- Schema validation available but optional
- Files as storage, standard text tooling
- The "hard" is everything; "soft" is just comments

**Guarantee profile**: Syntactic validity always; schema conformance when
schema provided; no consistency guarantees beyond filesystem.

### Path B: Better Markup

UDON as replacement for Markdown/AsciiDoc for documentation.

- Prose-primary with structural annotations
- Rendering to HTML/PDF
- Files + git, collaborative editing
- The "soft" is everything; "hard" is element structure for rendering

**Guarantee profile**: Syntactic validity; structural well-formedness; no
data-level constraints.

### Path C: Mixed Content

The experiment log, runbook, annotated conversation.

- Neither pure data nor pure prose
- Partial schema enforcement (hard islands in soft sea)
- Files + validation tooling
- **This is the underserved territory**

**Guarantee profile**: Syntactic validity; schema conformance on hard parts;
soft parts unconstrained; referential integrity desirable but challenging.

### Path D: Structured Document Store

When consistency guarantees actually matter.

- Database-backed storage
- ACID semantics on hard parts
- Query capability across documents
- The XML database vision, hopefully not the XML database outcome

**Guarantee profile**: Full database guarantees on hard parts; soft parts
stored but not constrained.

### Path E: DSL Substrate

UDON as syntax for domain-specific languages (parser generators, schema
languages, taxonomies).

- UDON provides notation; domain provides semantics
- Like S-expressions for Lisps
- Each DSL inherits UDON affordances, adds own constraints
- Storage/validation needs vary per DSL

**Guarantee profile**: Varies by DSL.

---

## Storage Options and Tradeoffs

### Files + Git (Current Default)

**What you get:**
- Human-readable, diffable, mergeable
- Full history (immutable, content-addressed)
- Offline-first, no server
- Text editors and grep work
- Zero impedance mismatch — the format IS the storage

**What you don't get:**
- Rejection of invalid mutations (honor system)
- Concurrent write safety (conflicts possible)
- Efficient cross-document queries
- Transactional multi-file changes

**When it breaks down:**
- High-frequency concurrent writes
- Cross-document queries that can't be grep
- When invalid states cause real damage

### Files + Validation Gatekeeper

Add a validation layer that all writes pass through:

```
edit → validate against schema → accept/reject → write to file
```

**Implementation options:**
- Git pre-commit hooks (reject invalid commits)
- File watcher daemon (reject or quarantine invalid saves)
- Required CLI tooling (validate before writing)
- Editor integration (real-time validation)

**The fundamental problem:** Only works if all writes use the gatekeeper. A
rogue `vim` edit bypasses everything. You're relying on discipline, not
enforcement.

**When it's sufficient:**
- Team agrees to use prescribed tooling
- Invalid states are annoying but not catastrophic
- "Best effort" is acceptable

### Database-Backed

Store UDON documents in a database (PostgreSQL, SQLite, or native document
store).

**What you get:**
- Schema enforcement at write time
- Concurrent access with consistency
- Transactional multi-element changes
- Efficient queries with indexes
- Referential integrity via foreign keys

**What you lose:**
- Direct file editing (vim, text editors)
- Meaningful git diffs (unless you also render to files)
- Offline editing (unless you sync)
- Simplicity

**The impedance mismatch:**

UDON's AST doesn't map cleanly to relational tables:
- Heterogeneous node types (Element, Text, Comment, etc.)
- Polymorphic attribute values (Scalar | Array | Node)
- Ordered children and attributes
- Type-scoped keys (not globally unique)

PostgreSQL with JSONB is the pragmatic compromise — you get transactions and
queries, but type information lives in the application layer.

### Hybrid: Database for Hard Parts, Files for Soft

Extract hard parts into database, keep soft parts in files.

```
|experiment[checkout-button]     →  experiments table
  :status running
  :traffic-allocation 0.5

  ## Hypothesis                   →  stored as text, or separate file
  We believe...
```

**What you get:**
- ACID on the parts that need it
- Flexibility on the parts that don't
- Queries on structured data

**What's hard:**
- Two representations to keep in sync
- Unclear ownership on conflict
- Rendering requires joining DB + files
- Complexity

### Append-Only Log with Materialized View

The file isn't the document — it's a log of validated changes:

```udon
|change :id 001 :time 2025-01-14T10:00:00Z
  |set |experiment[checkout]:status completed

|change :id 002 :time 2025-01-14T11:00:00Z
  |append |experiment[checkout]|results
    |variant-result[control] :sessions 23450 :conversions 798
```

Current state is computed by replay. Each change is validated before append.

**What you get:**
- Append-only is easier to make safe
- Full audit trail
- Can validate incrementally
- Git history of the history

**What's awkward:**
- Need tooling to see "current state"
- Editing means appending corrections, not modifying
- Large documents = long replay

---

## Consistency Profiles

Perhaps different use cases need different profiles, with the same notation and
AST but different storage/validation:

### "Casual" Profile

- Files as storage
- Validation optional (linting)
- Git for history
- Human-edited, evolving, exploratory

**Use case:** Early exploration, personal notes, drafts.

### "Careful" Profile

- Files as storage
- Validation required (gatekeeper)
- Atomic writes (rename dance)
- Prescribed tooling

**Use case:** Team configs, shared knowledge bases, anything where invalid
states cause friction but not disaster.

### "Critical" Profile

- Database-backed (or database-like)
- Schema enforcement at write time
- Transactional consistency
- Referential integrity

**Use case:** Production configs, contractual data, anything where invalid
states cause real damage.

### Profile Transitions

A document might start casual and need to become critical as it proves useful.

**Key question:** Can the same UDON document move between profiles without
rewriting? If so:
- What do you lose at each transition?
- What do you gain?
- Can you go back?

```
Casual → Careful:  Gain validation, lose ability to save invalid states
Careful → Critical: Gain ACID/queries, lose direct file editing
Critical → Casual:  Probably shouldn't go back?
```

The notation staying constant across profiles is important — the investment in
learning UDON shouldn't be tied to a particular storage backend.

---

## RDBMS Mapping Considerations

If Path D (database-backed) is pursued, how does the AST map to tables?

### What Maps Well

**Type-scoped uniqueness**: `(element_name, key)` as compound primary key
is natural for RDBMS.

**Indexes**: `by_type`, `by_key`, `traits_index` are just SQL indexes.

**References**: A `references` table with `(source_node_id, target_type,
target_key)` enables bidirectional lookup.

**Tree structure**: Adjacency list (`parent_id`) + closure table for efficient
ancestor queries. PostgreSQL handles this well.

### What's Awkward

**Polymorphic attribute values**: `AttrValue = Scalar | [AttrValue] | Node`.
Options:
- JSONB (pragmatic, loses DB-level type info)
- Discriminated union with sparse columns (ugly)
- Separate tables per type (complex queries)

**Heterogeneous node types**: Single table with discriminator + nullable
columns, or table-per-type with joins.

**Ordering everywhere**: Children are ordered, attributes are ordered, traits
are ordered. Every relationship needs a `position` column.

**Schema sketch** (PostgreSQL):

```sql
CREATE TABLE nodes (
  id SERIAL PRIMARY KEY,
  document_id INTEGER NOT NULL,
  parent_id INTEGER REFERENCES nodes(id),
  position INTEGER NOT NULL,
  node_type TEXT NOT NULL,
  element_name TEXT,
  element_key TEXT,
  content TEXT,
  UNIQUE(document_id, element_name, element_key)
    WHERE element_key IS NOT NULL
);

CREATE TABLE element_traits (
  element_id INTEGER NOT NULL REFERENCES nodes(id),
  trait TEXT NOT NULL,
  position INTEGER NOT NULL
);

CREATE TABLE attributes (
  id SERIAL PRIMARY KEY,
  element_id INTEGER NOT NULL REFERENCES nodes(id),
  name TEXT NOT NULL,
  position INTEGER NOT NULL,
  value JSONB NOT NULL  -- pragmatic surrender on polymorphism
);
```

The JSONB for attribute values is the key compromise — you get transactions and
queries, but the database doesn't deeply understand value types.

---

## Open Questions

### On Schema Language

- How do you express "this region is constrained, that region is free"?
- Can constraints be gradual? (mandatory / typed / suggested / free)
- How do inline structures (`|{metric ...}`) get their own schemas?
- What does schema inheritance/composition look like?

### On Storage

- Is there a clean hybrid that doesn't require complex sync?
- Can append-only logs work for documents that are heavily edited?
- What's the minimum database-like infrastructure for "Critical" profile?

### On Boundaries

- Is the soft/hard boundary expressible in schema, or implicit in usage?
- Can the same element be hard in one context, soft in another?
- How do references work across the boundary? (hard ref to soft target?)

### On Tooling

- What's the minimal gatekeeper for "Careful" profile?
- Can editors provide real-time validation without a server?
- How do you render "current state" from an append-only log efficiently?

### On the Broader Vision

- Should UDON have opinions about storage, or be storage-agnostic?
- Is "one notation, multiple backends" achievable without leaky abstractions?
- What can we learn from XML databases (both successes and failures)?

---

## Historical Context: What XML Tried

XML faced similar challenges and developed:

- **Native XML databases** (MarkLogic, eXist-db, BaseX): Stored XML natively,
  XQuery for queries, ACID transactions, schema validation.

- **Relational with XML types** (Oracle, PostgreSQL): XML as column type, XPath
  in SQL, ACID from relational layer.

- **Middleware validation**: Pipelines with schema stages, application servers
  enforcing schemas.

**What went wrong** (arguably):
- Ecosystem complexity defeated "human-readable" premise
- XSD became nearly unreadable itself
- Tooling sprawl — specialized everything
- The cure was worse than the disease for many use cases

**Lessons:**
- Don't let the tooling become more complex than the problem
- Human-readability is a feature worth protecting
- Schema languages can become their own complexity trap
- "Works with existing tools" (git, grep, vim) is valuable

---

## Summary: The Seams

The key decision points (seams) in this design space:

1. **File-based ↔ Database-backed**: When do you need guarantees that files
   can't provide?

2. **Schema-optional ↔ Schema-required**: When does validation become
   enforcement?

3. **Soft ↔ Hard**: How do you express and enforce the boundary within a
   document?

4. **Single-document ↔ Cross-document**: When do you need queries/indexes?

5. **Human-edited ↔ Machine-generated**: Different consistency needs, different
   tooling.

Understanding these seams — where they are, what you gain/lose crossing them —
is prerequisite to choosing paths. The goal is not to pick one path, but to
understand the territory well enough to make good choices as needs evolve.

---

*This document is exploratory. It represents thinking-in-progress, not
conclusions. Additions, corrections, and alternative framings welcome.*
