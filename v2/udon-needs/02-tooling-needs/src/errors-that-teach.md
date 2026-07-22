---
slug: errors-that-teach
type: principle
evidence: [T4, T2, T3, T1]
status: cross-tier-convergent (4-tier — the strongest lock in the corpus)
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md   # §2.4
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 8, 15
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C1, C2, C6
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2 principles
---

# A well-designed refusal is mutation-free, revelation-rich, and law-rich

**Claim.** Every tool interaction decomposes into three components — *mutate
state*, *reveal state*, *teach law* (what invariantly governs this tool's
jurisdiction) — and errors are the interactions where the law component
dominates. A refusal is the *safe* channel for an agent to learn a system's
constraint surface (the alternatives are destructive learning, or a
constraint that never surfaces until it bites). The design criteria fall out:
a good refusal **mutates nothing** (atomic failure, so the law signal is
unconfounded), **reveals state** (what matched, where, what exists), and
**teaches the law** that was violated — ideally as a menu of exact next
actions.

## The four-tier lock: the str_replace multi-match refuse

The single best worked example in the harvest, present in every tier — and
worth actually seeing. The original tool silently replaced *every* match
(`gsub`) and reported a count; the author discovered the damage only later.
The evolved sapientia tool refuses instead:

```text
⚠️  WARNING: Pattern matches 3 locations:
  - Line 1246 (deliberation-participate tool)
  - Line 1273 (council-participate tool)
  - Line 1890 (execute method)
Pattern matches 3 locations. Make pattern more specific.
```

Read that refusal against the three components: **mutation — zero** (the
file is untouched; the failure is atomic). **State revealed** — not just
"3 matches" but *where*, which teaches the reader something true about the
file itself: it has repeated structure (three tools with similar schemas),
and the anchor was at the content level when it needed to be at the
structural level. **Law taught** — uniqueness is required here, and the
message points at the repair ("make pattern more specific"; the companion
principle: anchor on closing delimiters and method boundaries, which occur
once, not on field lists, which repeat). The agent doesn't just recover
from this error — it comes out knowing more about the codebase than it
knew before the refusal. That is what "errors as teaching moments" means
mechanically, and it's why the safe default became `sub` (one) rather than
`gsub` (all).

The lock, tier by tier:

- **Built (sapientia, 2025):** the refusal above, shipped, with its
  design rationale recorded (fail *before* corruption; rich diagnostics;
  message guides toward the fix).
- **Shipped ecosystem-wide:** exact-match editing that "fails loud on
  0-matches or >1-matches" with a mandated prior Read is the near-universal
  contract (11 of the 14 harnesses examined) — largely by descent from one
  influential design, which makes the *survivorship* point: nothing
  displaced it.
- **Shown failing when absent:** Architectus's first-person account of
  tool failure where the refusal-shape was missing.
- **Theorized:** accumulated law-feedback is what establishes the
  known-action-mechanism gate (C3) — law-teaching errors are how a tool loop
  *earns* interventional (Level-2) status; laws are the slow,
  otherwise-bottlenecked stratum of the world model, observed almost only at
  violation attempts, so law-rich refusals accelerate exactly the stratum
  nothing else can. "Well-taught laws become infinite-velocity components of
  the agent's environment model — learned once, never re-derived."

The same demand recurs across the wider design corpus (the theory's full
treatment of law-teaching is in Appendix A §2.4) — an error-message
plan built on speaking domain concepts rather than mechanics, a
failure-mode quality ladder ranking diagnostics by how much they teach —
and in the theory's specification of located, structure-revealing
refusals.

## Design consequences

1. **Error taxonomy is first-class language/tool design.** Classify every
   diagnostic by which component it carries; bias hard toward law-rich,
   located, structure-revealing refusals.
2. **Atomicity of failed operations is an epistemic requirement**, not just a
   safety nicety — a refusal that half-mutates confounds the law signal.
3. **Error-as-menu:** candidates offered as ready-to-use exact paths; on zero
   match, name the stale-model hypothesis ("the file may have changed since
   you read it").
4. **Name the failure class** — structural vs parametric, not-found vs
   not-unique vs plural (#addressing-is-the-long-pole carries the concrete
   vocabulary demand).
5. **Severity must track loss** and diagnostics must stay machine-legible —
   the UDON anomaly posture (keep-everything; warning = kept, error = lost)
   is this principle already applied at the notation layer.

**Who reads this and when:** the harness applies it to every tool result and
system message; UDON applies it to parser/validator diagnostics and to the
edit tool's refusal design (#schema-guarded-mutation). Same principle, two
surfaces; no divergence.

## Honest edges

The theory's own scope note travels with this: in-loop diagnostics (per
event) and cross-session imports (per boundary) are deliberately distinct
channels with different design physics — this segment is the in-loop half;
#persistence-is-imported is the other.
