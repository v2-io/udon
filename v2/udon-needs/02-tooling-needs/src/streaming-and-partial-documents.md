---
slug: streaming-and-partial-documents
type: demand
evidence: [T1, T2, T4]
status: cross-tier-convergent (partial-is-normal); product shapes open
stage: drafted
consumers: both (udon-primary on format; harness on transport)
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §1, §5, P-A/P-B
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C10
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md  # §2.5 obs-context-turnover; §4.2
  - ../../../DECISIONS.md  # rows: R2, C6, W0, W1d
---

# Partial documents are the normal case

**Claim.** Agents emit bytes in long runs without visual feedback, stop
mid-document, resume after tool calls, and produce almost-valid structure —
so an agent-facing format's honesty under *incompleteness* is a first-class
property, not an error path. The demand: mid-generation feedback ("the agent
equivalent of syntax highlighting"), truncation surfaced as a **verdict** an
agent can branch on rather than a malformed tree or silent loss, and
stage-appropriate products (events for streaming/constrained decode;
assembled trees for structural ops) rather than one mandatory "the AST."

## The evidence

- **The transport layer (independently rediscovered at least five
  times):** streaming
  tool-call *reassembly* is a real, nontrivial, repeatedly-solved problem —
  arguments arrive fragmented and out of order; harnesses buffer,
  reassemble, tolerate malformed partial JSON, and in one case auto-repair
  unclosed strings; the official docs warn "you may get partial/invalid
  JSON and must guard the parse." The ecosystem pays a standing tax for
  formats whose partial prefixes are illegible. A format whose every prefix
  parses to an honest partial state (bounded lookahead, keep-everything,
  warnings citing the opener) removes the tax at the source — UDON's
  existing recognition posture is exactly this property; the demand
  evidence says it is load-bearing, not incidental.
- **The affordance list (from the design corpus — Appendix C carries the
  full exploration):** partial-tree query
  mid-parse (open-element stack, current attribute — "where am I?"); early
  anomaly surfacing before 500 more tokens compound the mistake;
  prefix/candidate validation against schema or enum; grammar-constrained
  generation derived from the grammar (guaranteed-valid emission for local
  models); interrupt/resume fidelity — the partial tree + verdict as the
  handoff substrate.
- **Ruled substrate (carried, not re-argued):** incomplete-input is a
  **recognition verdict, not an event** (R2/C6) — you don't recover it by
  folding harder; sufficiency at product boundaries (W0) and
  self-delimiting value extents (W1d) are the wire-side laws that make
  partial products honest.
- **The theory:** the reconstruction-adequacy condition and the two-timescale
  buffer/triage structure give the theory frame: arrival ≠ processing, and
  a session that begins with poor reconstruction produces unreliable
  diagnostics — partial-state honesty is what makes mid-stream diagnostics
  mean anything.

## The named tension (design input, not resolved)

Generation wants **soft recovery** mid-stream (keep-everything, warn,
continue); careful writes want **mutation-free refusal**
(#schema-guarded-mutation). Same language, different stage + profile — the
soft/hard dial again. The tooling mistake would be letting one posture
colonize the other.

**Who reads this and when:** UDON reads it as the case for
recognition-layer products being *public agent surfaces* with the
verdict channel; the harness reads the reassembly evidence as transport
reality and the
verdict shape as what its tool results should expose for long-running
generation. Divergence: none substantive; the harness benefits even for
non-UDON payloads (NDJSON etc.).

## Honest edges

Multi-line policy (ML) stays WAIT-DEMAND/possibly-dissolved: this segment's
scenarios are the demand side that should eventually force it — pain
in concrete stream/repair cases, not deliberation in the abstract. The
"grammar-constrained decode from descent" idea is technique-known but
never harnessed; unmeasured.
