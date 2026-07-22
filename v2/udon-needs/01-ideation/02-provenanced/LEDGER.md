# Extraction ledger — append-only

One line per **visit** to a target (from `../01-reconciled-target-files/TARGET-FILES.md`
or discovered en route). Append at the bottom; never edit or reorder existing
lines (multi-agent safety — appends don't collide, edits do). A visit that
yields nothing gets a line too: coverage must be legible, not just output.

**Disposition vocabulary:** `copied` (verbatim file/span → `copies/`) ·
`excerpted` (selected spans → `copies/`) · `characterized` (report →
`characterizations/`) · `witnessed` (1–2 evidence lines → `commentary/`) ·
`synthesized` (→ `syntheses/`; normally a higher-level pass, not extraction) ·
`dry` (visited, nothing met the vision bar) · `blocked` (couldn't verify/access
— say why). **Strive for `copied`/`excerpted` where the source allows** — the
concrete artifact travels; higher-level views can always be built over copies
later, but not the reverse.

| Date | Target | Disposition | Output | By | Note |
|---|---|---|---|---|---|
| 2026-07-21 | 14 in-repo design/consumer files (see each file's frontmatter `paths:`) | copied | `copies/extracts/*` | grok early pass | pre-template; frontmatter carries provenance |
| 2026-07-21 | `pipeline-discussion.md` (3 Joseph turns, line-spans in frontmatter) | excerpted | `copies/discussion-excerpts/*` | grok early pass | stable annotated copies vs drifting live line numbers |
| 2026-07-21 | 14 shipping-harness repos + claude-docs + obsidian×2 + yq | characterized | `characterizations/harness-invivo/*.md` (17) | opus sweep-3 | per-repo tool-usage maps; sources too large/foreign to copy |
| 2026-07-21 | `~/src/_core/sapientia/bin/` (minimal-sapientia + siblings) | characterized | `characterizations/sapientia-bin-buildout.md` | opus targeted | line-ranged mechanism map; verified harness-survey claims |
| 2026-07-21 | `~/src/archema-io/asf/**` (all four parts) | synthesized | `syntheses/asf-dossier.md` (+ reading log) | fable, 2 passes | theory tier; third consolidation pass expected |
| 2026-07-21 | cross-map convergence analysis | synthesized | `syntheses/CONVERGENCES.md` | opus reconciliation | 4 tiers, 18 clusters, lineage caveat |
| 2026-07-21 | 17 in-vivo maps (read-across) | synthesized | `syntheses/tier2-invivo-digest.md` | reconciliation sub-agent | bucket digest kept as phase-2 aid |
| 2026-07-21 | ELI first-person testimony (zi-am-tur ×6, gemini adjacent, katan/test-cavy dry) | characterized | via quarantine reconciliation (registry §1f → TARGET-FILES Part III) | sonnet sweeps, reconciled | quarantine's one content-read tier, carried forward |
