---
source: gathering pass (Grok), in-repo design/UX/utils/usability mines
gathered: 2026-07-21
status: mining-spot listing + pointers to extracts/ — not a synthesis
scope: |
  Inside the udon repo only. Fable owns external sapientia-era tooling and
  autopax/rowan/operata schema-versioning maps (sources-agentic-tooling.md,
  sources-schema-versioning.md).
---

# Sources — UDON repo design / UX / utils (demand-side)

Purpose: map **where in this repo** end-user and agent needs are already written down, and which pieces were **copied into** `extracts/` / `spikes/` with provenance. Inclusive; overlap with Fable’s external maps is fine when the same idea appears in both places (different context).

Exploration ranked by explore-agent 2026-07-21; high-value items copied below. Live originals remain authoritative for updates — extracts are snapshots at gather time.

## Already extracted (see sibling dirs)

| Gathered file | Original | Notes |
|---------------|----------|--------|
| `spikes/agent-utility-NOTES.md` | `.archived/second-pass/spikes/agent-utility/NOTES.md` | Whole; P-A…P-H + top-12 |
| `spikes/paths-NOTES.md` | `…/spikes/paths/NOTES.md` | Whole; D1–D9 |
| `spikes/paths-sketches.udon` | `…/spikes/paths/sketches.udon` | Whole |
| `extracts/agentic-ux-principles.md` | `design/agentic-ux-principles.md` | Whole; design-of-record WHY |
| `extracts/TODO-AGENT-UX.md` | `ux/TODO-AGENT-UX.md` | Whole |
| `extracts/TODO-UTILS.md` | `TODO-UTILS.md` | Whole |
| `extracts/TOOLING-WISHLIST.md` | `TOOLING-WISHLIST.md` | Whole |
| `extracts/CONSUMERS.md` | `CONSUMERS.md` | Whole |
| `extracts/positioning.md` | `design/positioning.md` | Whole |
| `extracts/udon-guarantees.md` | `design/udon-guarantees.md` | Whole |
| `extracts/UDON-AS-ACP-FORMAT.md` | `design/UDON-AS-ACP-FORMAT.md` | Whole |
| `extracts/schema-notes-2026-07.md` | `design/schema-notes-2026-07.md` | Whole |
| `extracts/GRAMMAR-CONSTRAINED-GENERATION.md` | `design/GRAMMAR-CONSTRAINED-GENERATION.md` | Whole |
| `extracts/udon-agentic-head.md` | `design/udon-agentic.md` | **Head only** (~220 lines); full ~1200 |
| `extracts/UDON-AGENT-TOOLS-head.md` | `design/UDON-AGENT-TOOLS.md` | **Head only**; Dec residue |
| `discussion-excerpts/joseph-*.md` | `../pipeline-discussion.md` | Joseph demand turns |
| `extracts/consumer-vivarium-*` | `~/src/archema-io/vivarium/…` | Live consumer heads |

## High-value not yet copied (continue pass)

| Path | Why | Suggest |
|------|-----|---------|
| `test/scenarios/` (README + features + corpus) | Day-in-the-life multi-agent understand/diff/modify; fail-loudly, span-minimal patch, CAS | Copy README + 01–04 feature heads, or whole dir later |
| `design/schema-workbench-2026-07.md` | Long survey companion to schema-notes | Excerpt or whole if phase (2) schema-heavy |
| `design/AGENT-CONTEXT-PROTOCOL.md` | Dec phenomenology of agent friction; propose/validate/apply | Excerpt if ACP texture still missing after tools-head |
| `design/udon-paths.md` | Stale spelling; surviving at/all ideas | Pointer only — paths spike re-read is better |
| `design/udon-ast.md` | Skeleton paths, SourceInfo, streaming fragments | Excerpt skeleton/SourceInfo sections |
| `spec/TODO-AUX.md` | Critical path packaging paths→schema→patch | Whole (short) |
| `ux/TODO-HUMAN-UX.md` | Editor/Obsidian, S11 | Whole (short) |
| `design/file-naming.md` | Aspirational designators | Whole if small |
| `test/usability/enablement-synthesis.md` | Domain situations (mixed content) | Whole |
| `test/usability/results/AGENT_FEEDBACK.md` | Empirical agent feedback (large, noisy) | Sample, not whole dump |
| `design/examples/{schema-dsl,ash-like-*,practices-gotchas,operata*}.udon` | Usage genres implying tool needs | Pointers or small set |
| `design/udon-schema-exploration.md` | Older “single source of truth” vision | Pointer if workbench/notes supersede |

## Lower priority / supply-side (skip for demand gathering)

Attribute-model proposal series, descent-experience, markup-feature-matrix, tmLanguage/vim internals, pure parser TODOs without user-facing surface.

## Relation to Fable’s maps

- **sources-agentic-tooling.md** — external sapientia/nexum/… ideology; do not duplicate here. Overlap: both care about agent-facing tools; this map is *UDON-specific* design of record.
- **sources-schema-versioning.md** — external rowan/autopax/operata; this map only has `schema-notes` / workbench / guarantees as *UDON-side* schema demand.
