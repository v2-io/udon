---
slug: typing-and-schema-boundary
type: demand
evidence: [T1, T2, T4, T5]
status: cross-tier-convergent (empirical stress test + design family + external fault data + theory slot)
stage: drafted
consumers: both (udon-primary)
depends: [schema-guarded-mutation, structured-output-two-mechanisms]
sources:
  - ../../01-ideation/02-provenanced/copies/III-schema/yaml-spike-v2-RECOVERY_SCENARIOS.md  # read whole
  - ../../01-ideation/02-provenanced/copies/III-schema/autopax-ADR-008-yaml-and-schemas.md  # head read
  - ../../01-ideation/02-provenanced/copies/III-schema/rowan-10-schema-evolution.md  # head read
  - ../../01-ideation/02-provenanced/syntheses/external-landscape-2026-07.md  # finding 7
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 9
---

# Typing discipline and the schema boundary: what the wounds demand

**Claim.** The schema-side evidence — one empirical stress test, one
production catalog of typing accidents, one schema-evolution design,
and external fault data — converges on four demands a typed document
format must meet: **no silent retype** (type comes from syntax, never
from guessing at content), **duplicate and malformation detection at
the format layer** (not bolted-on linting), **schema as a versioned,
evolving object** (renames and type changes with read-time translation,
not one-shot migrations), and **conformance as a machine verdict** a
write gate can consume.

## The evidence, wound by wound

- **The measured wound.** The six-scenario adversarial recovery test
  (told in full in the [guarded-mutation
  chapter](schema-guarded-mutation.md); reproduced whole as
  [the YAML stress test](../reports/yaml-stress-test.md)) bottom-lined
  YAML for agent-written documents: recoverable only with ~500 lines of
  custom backup, validation, and salvage infrastructure — and its worst
  failure, duplicate keys silently discarding data, is *undetectable at
  the format layer* because the parser accepts it happily. The test's
  own comparison table states the demand as a checklist: a database
  gets transactions, constraint enforcement, and duplicate rejection
  *before* the write; "YAML requires custom infrastructure" for every
  one. A format for agent state either supplies those properties or
  taxes every consumer into rebuilding them.
- **The guessing tax, cataloged in production.** A 2025 architecture
  decision record from the same schema work catalogs YAML's
  type-guessing accidents as they actually bit: bare `1.0` parses as a
  float, so version strings corrupt; `01234` parses as octal, so a
  postal code becomes 668; `yes` and `no` become booleans; ISO dates
  silently become date objects. The documented behavioral consequence:
  agents trained on JSON *over-quote defensively*, and the record
  spends pages on when quoting is mandatory. Every row of that catalog
  is a cost UDON's already-ruled design refuses to charge — bare
  recognition is a closed set, everything else is typed inside an
  explicit envelope, so adding a type can never retype an existing
  document. Here the demand and the design met before this report
  existed; the catalog is the evidence the design answers.
- **The lifecycle demand.** A schema-evolution design from the same
  programme's application-framework work starts from the failure
  everyone has met: migrations transform *databases*, but the estate's
  YAML and JSON files "weren't migrated (migrations only touch SQL)" —
  renames collide across merged branches, staging lags production, new
  code reads old backups. Its mechanism: declare the rename or type
  change *on the field itself* (a `was:` marker), translate at read
  time, keep upcasters and schema history as versioned files — "schema
  changes as safe as code changes." For any format whose documents
  outlive their schemas — which is *all* agent memory and every
  tracking document — this is the difference between versioning as
  metadata and versioning as a working mechanism.
- **The external anchor.** In a 2026 fault-taxonomy study of the Model
  Context Protocol ecosystem, the largest execution-failure subcategory
  is schema-serialization mismatch — wrappers whose output their own
  clients cannot parse — and configuration dominates real-world tool
  faults overall. The outside world's failures concentrate exactly
  where this chapter's demands point.
- **The theory's slot.** A schema converts an interpretive observation
  into a pass/fail one — the sharpest-signal move the
  [observation chapter](tools-are-observation-infrastructure.md)
  prices; and a conformance verdict is only consumable by a write gate
  if it is machine-shaped — codes, addresses, counts — which is the
  [refusal chapter](errors-that-teach.md)'s requirement arriving at the
  schema layer.

## What it generates

- **For UDON:** the schema design work ahead inherits a second axis.
  Static-versus-composable is the question already on record ("can
  schemas be nested or otherwise composable?"); *evolution* — declared
  renames, read-time translation, schema history — is a first-class
  demand from the family that has lived without it. And the job
  separation already ruled in the [[DECISIONS.md|design ledger]] —
  dialects say what a value *means*, schemas say what is *allowed*,
  never trading jobs — is precisely what keeps the guessing-tax catalog
  unreproducible in UDON.
- **For the harness:** its document estate — agent definitions,
  tracking files, memory — is exactly the population the stress test
  exercised. Until a guarded format exists, the test's own mitigations
  are the floor: backup before write, validate after read, lint for
  duplicates, escalate to a human — enforced as harness machinery, not
  as prompt lines.

## What this opens (ideas, not designs)

- **A taxonomy of the undetectable.** The duplicate-key failure matters
  because it is *invisible at the format layer* — the format's own
  parser blesses the corruption. Every format has such a set; nobody
  has enumerated them side by side. A catalog of
  what-each-format-cannot-see would turn format selection for agent
  state from taste into risk assessment.
- **The guessing-tax catalog as a portable test suite.** The
  architecture record's gotcha table is executable: feed each row to
  any candidate format and score silent retypes. A standing
  "Norway suite" would let every notation — UDON included — *prove*
  its typing discipline rather than assert it.
- **Evolution in both directions.** Read-time translation as designed
  is forward-only: new schema reads old documents. The inverse has
  real uses in an agent estate — old tools reading newer documents
  during staged rollouts. Whether `was:`-style declarations can be run
  backwards (or paired with `becomes:`) is a design question with a
  concrete payoff: no flag-day anywhere in a fleet of agents.
- **Documents that know their schema version.** If schema history is
  versioned, a document stamped with the schema version it was written
  under makes every future read *self-locating* in that history — the
  read-time translator knows exactly which upcasters apply, and
  staleness of the document against its schema becomes a checkable
  fact rather than a discovery.

## Honest edges

The design side of this family is heavily single-author; the genuinely
independent legs are the external fault data and the stress test's
adversarial protocol (self-run, but measured and reproducible). Three of
the schema-family source documents were read at depth for this chapter;
roughly thirteen siblings were not and may hold counter-detail (the
report's coverage notes carry this). Schema *composition* — nested,
composable, neither — has no evidence either way; it is genuinely open
and correctly left to the schema design work ahead.
