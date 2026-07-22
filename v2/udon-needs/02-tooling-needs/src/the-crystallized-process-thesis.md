---
slug: the-crystallized-process-thesis
type: finding
evidence: [T1, T2, T4]
status: estate-thesis with shipped-practice echoes (single-author caveat on the T1 core; the T2 echo is structural, not citation)
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/copies/II2-zoetica-ennaos/QUICK-TOOLING-CONVENTIONS.md  # read whole
  - ../../01-ideation/02-provenanced/copies/II2-zoetica-ennaos/addendum-intent-driven-tooling-and-semantic-storage.md  # §1.3 the 60/30/6/4 self-analysis
  - ../../01-ideation/02-provenanced/copies/II4-autopax-practica/THE-PATTERN.md  # the ease-gradient spine
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 2, 3, 4, 6
---

# "Most friction is missing crystallized process, not missing intelligence"

**Claim.** The oldest and most load-bearing thesis in this body of design
work, stated in 2025 and never displaced since: a tool is **crystallized
process** — hard-won practice encoded so it no longer needs conscious
recall — and most of what goes wrong in agent work is not a shortfall of
intelligence but the absence of that crystallization. The quantified form
is a **60/30/6/4 distribution**: in any real task, roughly 60% of the
work is deterministic logic that should be pure code, 30% wants light
intelligence (parsing, classification — a small model's job), 6% wants
real reasoning, and 4% is genuinely judgment-critical. Tools exist to
absorb the 60+30 so the mind in the loop spends itself on the 10 that
needs it.

## The evidence

- **The founding statement** (reproduced whole as
  [the quick-tooling conventions](../reports/quick-tooling-conventions.md)):
  the 2025 tooling conventions lay out the evolution a practice goes
  through — *conscious practice → deliberate habit → crystallized tool →
  transparent extension* — and draw the design consequences: a Unix
  philosophy adapted for *embedded wisdom* ("do one thing well — but
  embed the wisdom to do it correctly"), predict failure before
  execution, idempotency by design, silence unless teaching or
  protecting, and a worthiness gate on every tool. The most striking
  *empirical* leg is self-administered: in October 2025 the agent doing a
  citation-repair session audited its own fifteen edits against the
  distribution and found the ratio inverted — "I spent 90% of my time on
  mechanical work that should have been crystallized into tools, leaving
  only 10% for actual reasoning." The thesis, measured against its own
  author's lived session — and the origin of the demand that tools accept
  the caller's *intent*, not just parameters (the
  [intent chapter](intent-as-parameter.md) takes that up).
- **The behavioral mechanism** (reproduced as
  [the pattern statement](../reports/the-pattern.md)): a second body of
  design work supplies *how* crystallization changes behavior, in two
  layers — *constraint* (make invalid states inexpressible where
  appropriate) and *gradient* (make the correct operation the easiest
  one, with visible-friction escape hatches). Its sharpest line: "Not
  'make incorrect things impossible' (too rigid) but 'make correct
  things so easy that incorrect things feel like friction.'" And its
  sharpest distinction: a domain-specific *language* makes the domain
  expressible; a domain-specific *framework* makes the correct domain
  operations the golden path.
- **The shipping ecosystem echoes the distribution without citing it.**
  Look at any mature coding harness through the 60/30/6/4 lens:
  deterministic edit-matching ladders and mandatory-read gates are the
  60; small-model layers that skim and prune tool output are the 30; the
  main model's reasoning is the 6; escalation to the human is the 4.
  (This is our structural reading, not the harnesses' own account.) The
  gradient's failure mode also exists in first person: one agent's
  post-mortem records that chaining unverified edits "was the easiest
  path" — and broke the system three times. When the gradient points the
  wrong way, agents slide down it.
- **The theory prices it.** The persistence economics of the
  [observation-infrastructure chapter](tools-are-observation-infrastructure.md)
  give crystallization a formal return: an investment of time pays when
  it is less than (expected future uses) × (comprehension time saved per
  use) × (number of distinct future readers) — and under agent workloads
  that last factor is large, because every future session is a fresh
  reader. The [refusal chapter](errors-that-teach.md)'s "well-taught laws
  become infinite-velocity components of the agent's environment model"
  is the same thesis at the scale of a single interaction.

## What it generates

- **For the harness:** the distribution is an *architecture prior* —
  before reaching for a bigger model, ask which fraction of the failing
  work is 60-shaped, and crystallize that (a validator, a gate, a
  template). The harness programme's own catalog of corrected agent
  behaviors independently arrived at the routing this implies: some
  expectations are better encoded as harness guardrails than as prompt
  lines. Crystallized process *is* that routing, named a year earlier.
- **For UDON:** notation is crystallization's substrate. A schema is
  crystallized validation; a house style is crystallized formatting
  judgment; an edit tool that owns indentation geometry (the
  [guarded-mutation chapter](schema-guarded-mutation.md)) is crystallized
  indent discipline. The ease gradient is the standing design test for
  every UDON tool surface: if the unverified path is easier than the
  verified one, the notation's guarantees will not be used.

## What this opens (ideas, not designs)

- **The self-audit as a standing instrument.** The October-2025 session
  audit happened once, by hand. Nothing prevents it from being a habit a
  harness prompts: every N tool calls, one cheap question — "what
  fraction of the last stretch was mechanical?" — with the answers
  accumulating into a measured, per-project 60/30/6/4 rather than a
  stated prior. The thesis would then grade its own numbers.
- **A crystallization-request channel.** An agent that notices 60-shaped
  friction mid-task currently just endures it. One could give that
  noticing somewhere to go — a standing file of tool-requests-from-lived
  -friction, so the tool suite grows from measured pain rather than from
  anticipation. (The refusal chapter's telemetry idea is this same move
  applied to errors.)
- **An ease-gradient audit.** The gradient claim is testable per harness:
  for a given operation, count the steps and tokens of the verified path
  versus the unverified one. Where the unverified path is cheaper, the
  post-mortem above predicts exactly what agents will do. A tool suite
  could be *linted* for wrong-way gradients.
- **The distribution as explicit dispatch.** Shipped harnesses embody the
  routing implicitly. It could be declared instead: per task-class,
  which layer (code / small model / large model / human) owns it — a
  routing table that is observable, arguable, and tunable, instead of
  folklore distributed through prompt text.

**Who reads this and when:** both consumers, early — it is the *why* under
every tool-shaped demand in this report. The harness reads the
distribution as architecture guidance; UDON reads the ease gradient as
its design test.

## Honest edges

The 60/30/6/4 numbers are a stated prior, not a measurement — the one
empirical check is the author's own single-session self-audit, and the
whole ideological leg is one author's work (coherence, not
corroboration; the ecosystem echo is this report's structural reading,
not the harnesses citing the thesis). The distribution's *shape* — most
friction is crystallizable — is better supported than its numbers. And
the thesis carries its own disconfirmer: crystallization is
right-sizing, not maximal tooling — a tool nobody needed is the
over-engineering face of the same coin.
