---
slug: tracking-snapshots-as-perception
type: finding
evidence: [T1, T2, T4]
status: cross-tier-convergent (built 2025 / designed 2025 / theorized exact)
stage: drafted
consumers: harness-primary
depends: [persistence-is-imported, context-economy]
sources:
  - ../../01-ideation/02-provenanced/copies/II2-zoetica-ennaos/tracking-snapshot-spec.md  # head read (schema + fields)
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # cluster 12
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C11 (state-snapshot family)
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md  # §4.2 duality; temporal markers
---

# Structured context-injection is perception design

**Claim.** The recurring "tracking snapshot" — a structured frame injected
into the agent's context carrying elapsed time, environment state, queue
visibility, and budget — is not UI convenience leaking into the prompt.
It is **designed perception**: the deliberate construction of the
observation channels an embodied creature gets for free and a logogenic
agent otherwise lacks. Built in 2025, specified in the same year,
theorized exact in the dossier.

## The evidence

- **Built (Sept 2025):** minimal-sapientia injected an XML
  tracking snapshot per turn; the zoetica spec (Oct 2025) is its
  design-of-record successor, and its stated mission is the point:
  "ELIs must experience passage of time, environmental context, and
  pending user input **as part of their reality, not hidden UI state**."
  The schema is a perception inventory — time-passage with elapsed
  duration and symbols (the logarithmic time-glyphs: elapsed time as a
  perceptum), git status (environmental grounding), working directory
  (spatial awareness), context usage (budget awareness), pending
  messages (queue visibility — arrivals are visible before they are
  attended), and an audit-trail binding (session/turn/commit) so
  compressed snapshots stay expandable from history. Compression of
  *old* snapshots with the latest kept whole is the two-timescale
  structure in miniature.
- **The ecosystem's parallel:** the state-snapshot compaction family —
  "this snapshot is the agent's *only* memory" — plus system-reminder
  catalogs are the same mechanism grown independently for context
  management rather than temporal coherence; the same idea arriving three
  ways (built, designed, theorized) is what gives this claim its weight.
- **The theory (why it's structural):** out-of-band temporal markers are a
  *prerequisite for the agent computing its own tempo* — suspension gaps
  are invisible at the sequence level; the multi-channel provisioning
  argument ("you must provision high-bandwidth, multi-channel,
  asynchronous sensory input to align the agent's subjective event-rate
  with the physical world's") makes snapshot channels an
  empathy/coordination requirement; and the ephemeral/persistent duality
  gives the design rule — snapshots are the high-frequency *ephemeral*
  leg (sent up, not persisted), distinct in physics from the durable
  stores (#persistence-is-imported), with compress-to-stub as the
  low-frequency projection. The channel-redundancy caveat travels:
  correlated channels drawing one source overcount — a snapshot's value
  is in *independent* signals (time, git, queue), not in restating the
  conversation.

## What it generates

- **For the harness:** treat the snapshot schema as a perception budget
  to design deliberately: which independent channels, at which
  frequencies, ephemeral-vs-persisted per field, with an audit pointer so
  ephemeral frames stay reconstructible. The zoetica spec is a working
  draft of exactly this, ready to build from.
- **For UDON:** snapshots are a *document class* with unusual physics —
  emitted constantly, read once, compressed aggressively, never
  hand-authored — the purest ephemeral-instrument case in the
  ephemeral/durable split the format story should keep visible. (And
  time-glyphs are a reminder that perceptual density sometimes beats
  structural purity — a design sensibility, not a rule.)

## Honest edges

The built and designed legs share an author; the independent shipped leg
(state-snapshot compaction) converged on *content* (git status, elapsed
context) but not on the temporal-coherence *rationale* — the ecosystem
built it for token budgets, not for time perception, so the perceptual
framing rests on the design work and the theory. No measurements exist of
snapshot-driven behavior
deltas (does time-passage visibility actually change agent pacing? —
testable, untested).
