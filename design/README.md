# design/ — ahead-of-spec exploration (partly superseded)

> [!note] **Status, honestly:** much of this directory is **superseded by
> `../spec/CORE.md`**, having been written ahead of (or before) the 2026-07 spec
> work — and there is **no process keeping it in sync**. Treat every file here as
> *exploration and future ideas*, not current truth; verify anything against CORE
> before relying on it. It is kept because it is **rich in genuinely good future
> directions** (composite types, paths, agentic tooling, schema, guarantees) —
> the ideas outlive their now-stale details.

Actionable items get extracted from these notes into the co-located TODO lanes
(`../spec/TODO-AUX.md` for schema/paths/patch; `../spec/TODO-SPEC-OTHER.md` for
dialects/markdown; `../TODO-UTILS.md`, `../ux/TODO-AGENT-UX.md`). The notes stay as
reference. When pulling, the drain rule holds: **deprecate, don't re-track,
anything subsumed by the fixture + grammar iteration passes** — a "make the
parser do spec-behavior X" item *is* a compliance fixture, not a lane task;
only genuine residuals survive.

Arrivals 2026-07-16 (from the dissolved `notes/`, each with its own status
banner): `desc-design-principles.md` (Joseph's .desc measuring stick, current),
`positioning.md` (agent-voice positioning essay, README source material),
`markup-feature-matrix.md` (26-language survey, Markdown-subset evidence),
`semachrome.md` (highlighting/theme-generation exploration; autocolors since
landed). Historical `notes/` material went to `../_archive/` (`analysis.md`,
`feedback.md`, `implementation-status.md`, `parser-strategy.md`,
`implementation-phase-2.md`, `spikes/`).

**Current (an exception to the superseded-banner above):**
`agentic-ux-principles.md` — synthesized 2026-07-16 from the 2025 tool-
phenomenology corpus + ASF/AAT's mathematics; the WHY layer under
`udon-agentic.md` (which remains the tool-suite WHAT) and the design of
record for the tooling pipeline's UX. Where a sketch elsewhere in this
directory disagrees with it, the principle governs.
