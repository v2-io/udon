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

**Claim.** The schema family of the corpus — one empirical stress test,
one convention wishlist, one evolution design, external fault data —
converges on four demands a typed document format must meet: **no silent
retype** (typing by syntax, never by sniffing), **duplicate and
malformation detection at the format layer** (not bolted-on linting),
**schema as a versioned, evolving object** (rename/type-change with
read-time translation, not one-shot migrations), and **conformance as a
machine verdict** a write gate can consume.

## The evidence, wound by wound

- **T2 — the yaml-spike (the measured wound):** the six-scenario
  adversarial recovery test (#schema-guarded-mutation carries the drama)
  bottom-lined YAML for agent-written documents: recoverable only with
  ~500 LOC of custom backup/validation/salvage infrastructure, and its
  worst failure — duplicate keys silently discarding data — is
  *undetectable at the format layer* because the parser accepts it. The
  spike's comparison table is the demand stated as a checklist: SQLite
  gets transactions, constraint enforcement, duplicate rejection *before
  write* — "YAML requires custom infrastructure" for each. A format for
  agent state either supplies those properties or taxes every consumer
  into rebuilding them.
- **T1 — ADR-008 (the sniffing tax, cataloged):** the YAML quoting-gotcha
  table is the Norway problem in production dress: bare `1.0` parses as a
  float (version strings corrupt), `01234` as octal (postal codes become
  668), `yes`/`no` as booleans, ISO dates silently become Date objects —
  so agents trained on JSON *over-quote defensively*, and the ADR spends
  pages on when quoting is mandatory. Every row of that table is a cost
  UDON's frozen bare set + envelope already refuses to charge: bare
  recognition is closed, dialects act only inside `<…>`, so adding a type
  can never retype an existing document. The demand and the design met
  before this report was written; the table is the evidence the design
  answers.
- **T1 — rowan schema evolution (the lifecycle demand):** migrations
  transform *databases*; agent estates need the *data model* to evolve —
  because renames collide across merged branches, staging lags, old
  backups get read by new code, "and your YAML/JSON files weren't
  migrated (migrations only touch SQL)." The `was:` mechanism (rename and
  type-change declared on the field, read-time translation, upcasters,
  schema history as versioned files) makes evolution declarative and
  auditable — "schema changes as safe as code changes." For any format
  whose documents outlive their schemas (all agent memory, all tracking
  docs), this is the difference between versioning as metadata and
  versioning as a working mechanism.
- **T5 — the external anchor:** the MCP fault taxonomy's largest
  execution subcategory is schema-serialization mismatch (wrappers
  unparseable by clients, breaking every invocation), and configuration
  dominates real-world tool faults overall. The outside world's tool
  failures concentrate exactly where this segment's demands point.
- **T4 — the slot:** schemas convert interpretive observations into
  pass/fail (the low-A move); typed write boundaries are the W₂
  separation mechanism; and a validation verdict is only consumable by a
  gate if it is machine-shaped — codes, paths, counts
  (#errors-that-teach).

## What it generates

- **For UDON:** the schema spike's inherited agenda
  (#priorities-and-spike-agenda) gains the lifecycle leg: static-vs-
  composable is not the only axis — *evolution* (was:/upcast/history) is a
  first-class demand from the family that has lived without it. And the
  dialect/schema job separation already ruled (dialects type, schemas
  constrain, never trade) is what keeps the gotcha table unreproducible.
- **For the harness:** its document estate (agent cards, tracking files,
  memory) is exactly the population the yaml-spike stress-tested; until a
  guarded format exists, the spike's own mitigations (backup-before-write,
  post-read validation, duplicate linting, escalation) are the floor —
  and they are harness-enforceable guardrails, not prompt lines (the
  taxonomy's INC-4 routing).

## Honest edges

The family is heavily single-author on the design side; the genuinely
independent legs are the external fault data and the yaml-spike's
adversarial protocol (self-run but measured). The III-schema copies were
flagged at gathering for re-vet at point of load-bearing use — the three
read here were read; the remaining ~13 family files were not and may hold
counter-detail (RESIDUALS carries this). Schema *composition* (S8's
nested/composable question) has no evidence either way in the corpus —
genuinely open, correctly deferred to the spike.
