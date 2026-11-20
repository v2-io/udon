---
source: live repo file `design/file-naming.md` at gather time
gathered: 2026-07-21
status: gathered source material — verbatim whole-file copy; NOT authoritative; live originals may advance
paths:
  - design/file-naming.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [file-naming, schema-designator, self-description, convention]
why_included: |
  Small but load-bearing convention: <name>.<schema>.udon designators. Demand
  content = self-description and schema-globbing as an authoring/tooling affordance,
  plus the deliberate 'application-level, not parser-wired yet' restraint (a
  product-vs-overbuild discipline). Pairs with the aspirational-designator item in
  TODO-AUX (a filename declaring a schema it doesn't yet have).
---

# File naming convention: `<name>.<schema/type>.udon`

*Adopted 2026-07-11 (Joseph; already in partial use in vivarium). Migrate
as we go — no bulk rename; apply when touching or creating files.*

UDON documents that follow a schema/type name it in a middle extension
segment:

- `udon.desc.udon` — the udon grammar, in the `desc` schema
- `taxonomy.taxonomy.udon`, `PROCESS.process.udon`, … — as their schemas
  get named
- plain `<name>.udon` — no declared schema (misc UDON with prose)

**Semantics: application-level for now, deliberately.** The designator is
*not* wired to any parser/tooling behavior yet. Whether it ever formally
binds to schema/dialect declaration (the future pragma / `!dialect` /
schema layer — design/udon-schema-exploration.md) is an open decision we
are intentionally not taking today; when that day comes, the filename
segment and the in-document declaration will need a
consistency-or-precedence rule.

Practical properties that motivated it: globbing by schema (`*.desc.udon`);
editor associations unaffected (all tooling keys on the final `.udon` —
verified against ux/); `bin/find-consumers` can later group/profile by
designator; and self-description — the bootstrap work made `udon.desc` a
first-class UDON document, so its name should say so.

Known soft edge (acceptable at application-level): dotted basenames can
false-read as designators (`notes.2026.udon`). Convention, not enforcement.
