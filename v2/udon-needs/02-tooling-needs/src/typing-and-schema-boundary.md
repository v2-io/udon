---
slug: typing-and-schema-boundary
type: demand
evidence: [T1, T2, T4, T5]      # genre only; see method-evidence-tiers "three axes"
register: evidenced             # the four demands are evidenced by cross-kind convergence; the ideation section is proposed
strength: robust-qualitative    # a convergent direction across independent evidence kinds; individual legs measured/conditional (marked in prose)
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
- **The external anchor.** The first large-scale fault taxonomy of the
  Model Context Protocol ecosystem — 407 labeled issues drawn from 385
  server repositories, 2026 — found two things this chapter's demands
  predict. Configuration faults *dominate* the whole population (the three
  configuration categories together account for the clear majority of
  issues); and the single largest *execution*-fault subcategory is
  tool-call/execution errors, inside which the emblematic case is
  schema-serialization mismatch: wrappers whose serialized output their
  own clients cannot parse, breaking *every* invocation until explicit
  fields were exposed. Neither failure is the model being wrong; both are
  the format-and-schema layer being unguarded. The outside world's
  failures concentrate exactly where this chapter's demands point —
  measured, at the conditions of one study of Python-SDK servers, and
  named as such.
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

> [!capability] A taxonomy of the undetectable
> **What:** a side-by-side catalog of what each candidate format's own
> parser *cannot see* — the duplicate-key silent-discard is YAML's
> entry, but every format has a set of corruptions it blesses. Enumerate
> them per format so choosing a format for agent state becomes risk
> assessment, not taste.
> **Principles that apply:** an observation that resolves sharply is a
> bias-reduction instrument; the failure the format can't surface is
> pure observation ambiguity handed to the agent.
> **Hypothesized impact:** collapses observation ambiguity A on the
> read channel toward its floor — the residual A that no schema can
> remove because the *parser* won't report it — making that irreducible
> floor an explicit, chooseable quantity per format instead of a latent
> hazard.
> **In tension with:** format familiarity (the most-blessed corruptions
> tend to live in the most-installed formats); the catalog dates as
> parsers change.
> **Potential downsides:** a "clean" score invites false confidence —
> undetectable-set-empty is a claim about the parser, not the data.

> [!capability] The guessing-tax catalog as a portable test suite
> **What:** the production gotcha table (bare `1.0`→float, `01234`→octal,
> `yes`→bool, ISO-string→date) is executable — feed each row to any
> candidate format and score the silent retypes. A standing "Norway
> suite" any notation, UDON included, runs to *prove* its typing
> discipline rather than assert it.
> **Principles that apply:** conformance as a machine verdict; a demand
> stated as a checklist a write gate can consume.
> **Hypothesized impact:** turns "no silent retype" from an asserted
> design property into a measured one — the strongest thing a typing
> discipline can carry, an adversarial pass/fail with observation
> ambiguity A ≈ 0 on the retype question.
> **In tension with:** suites ossify — a format can pass every known row
> and still retype something nobody thought to test.
> **Potential downsides:** a green suite is evidence of discipline on
> the *tested* inputs only; it is not a proof of the general property.

> [!capability] Evolution in both directions
> **What:** read-time schema translation as designed is forward-only
> (new schema reads old documents). Agent estates also need the inverse —
> old tools reading *newer* documents during a staged rollout. Whether a
> declared rename can be run backwards (or paired with a `becomes:`
> forward marker) is the open question; the payoff is no flag-day
> anywhere in a fleet.
> **Principles that apply:** durable state must survive the boundary of
> the writer's own version, not just its own context; schema as a
> versioned object.
> **Hypothesized impact:** strengthens the reinjection channel across a
> heterogeneous fleet — a document written by a newer agent stays
> reloadable by an older one, so version skew stops severing the
> externalize-then-reload path that is the *only* cross-boundary
> persistence there is.
> **In tension with:** bidirectional translation can be lossy (a new
> field has no old home); every added direction is more upcaster surface
> to keep correct.
> **Potential downsides:** backward translation that silently drops
> new-only data reintroduces exactly the duplicate-key failure class one
> layer up.

> [!capability] Documents that know their schema version
> **What:** a document stamped with the schema version it was written
> under makes every future read *self-locating* in the schema history —
> the read-time translator knows exactly which upcasters apply, and
> staleness against the current schema becomes a checkable fact.
> **Principles that apply:** provenance as first-class data; a parked or
> re-entered document is read cold and must describe itself.
> **Hypothesized impact:** drives observation ambiguity A toward zero on
> the "is this document current?" question — today an agent *infers*
> staleness (high A); a version stamp makes it a lookup (A ≈ 0) — and
> lowers comprehension time on cold re-entry after context turnover.
> **In tension with:** a stamp is metadata that can go stale itself if
> hand-edited; it costs a reserved field every document must carry.
> **Potential downsides:** a *wrong* stamp is worse than none — it routes
> the translator to the wrong upcasters with full confidence.

## Honest edges

The design side of this family is heavily single-author; the genuinely
independent legs are the external fault data and the stress test's
adversarial protocol (self-run, but measured and reproducible). Three of
the schema-family source documents were read at depth for this chapter;
roughly thirteen siblings were not and may hold counter-detail (the
report's coverage notes carry this). Schema *composition* — nested,
composable, neither — has no evidence either way; it is genuinely open
and correctly left to the schema design work ahead.
