---
slug: headless-io-contract
type: finding
evidence: [T2, T1]
status: genuine-independent-convergence (survives lineage correction)
stage: drafted
consumers: both
depends: [method-evidence-tiers]
sources:
  - ../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C16
  - ../01-ideation/02-provenanced/syntheses/tier2-lineage.md        # C16 survivor
  - ../01-ideation/02-provenanced/syntheses/CONVERGENCES.md          # cluster 18
---

# The headless I/O contract — the machine caller's Bill of Rights

**Claim.** When the caller is a program (or an agent), a CLI's contract
converges on: **stdout carries data, stderr carries diagnostics; a
`--json`/`--output-format` flag family with a streaming-NDJSON variant;
non-zero exit with a structured error object; a single-shot
prompt-and-exit mode; `--dry-run`; and interactive-vs-agent auto-detection
via TTY/CI signals.** This is one of only two Tier-2 patterns that survives
lineage correction as *genuine independent convergence* — essentially every
shipping harness built it separately against the same hard external
constraint (a machine on the other end), which is the strongest evidence
shape Tier 2 can produce.

## The evidence

- **T2:** convergent across effectively all 14 real harnesses (the one
  exception is an honest dry well); the cleanest standalone statement of the
  detection heuristic is minimax-cli's `isInteractive()`/`isCI()`. Lineage
  verdict: independently built — hard-constraint convergence, not copying.
- **T1:** the sapientia cli-conventions corpus specified the same contract
  from first principles in 2025 (stdout=data / stderr=diagnostics /
  sysexits / `--format=json` / `!isatty()`), before most of these harnesses
  existed — the corpus's clearest case of ideology anticipating practice.
  (Same-author caveat noted; the T2 convergence carries the weight, T1
  supplies the earlier articulation.)
- Related but distinct micro-convergence: minimax-cli's *reverse-direction*
  schema export (the CLI describes itself as a tool, with flag→JSON-type
  inference) — a singleton, but directly relevant to any
  tool-generation-from-schema ambition.

## What it generates

- **For the harness (and every tool either program ships):** this is the
  floor contract; deviations need reasons. The auto-detection half matters
  as much as the flag half — agents shouldn't need to know the flag to get
  the machine path.
- **For UDON:** two distinct pulls. (a) Every UDON CLI (`udon fmt`, the edit
  tool, validators) inherits the contract verbatim — including that
  *diagnostics* (anomalies, verdicts) belong on the structured channel with
  stable codes, which meshes with the two-level severity model. (b) The
  contract names a document-shaped hole: NDJSON is the converged streaming
  answer because JSON has no honest partial form — a format whose prefixes
  parse (#streaming-and-partial-documents) can serve the same role natively;
  whether that's a real advantage or a nice-to-have is measurable, and
  shouldn't be claimed before measured.

## Honest edges

The contract is about *transport*, not content quality — it says nothing
about whether what's in the JSON is right (see #counter-register on
fail-plausible). And "near-universal in 2026 CLIs" is still a
coding-harness sample; non-coding agent tools are unsampled here.
