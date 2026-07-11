# DECIDED — ratified decisions log

Append-only. Each entry: exact ratified scope, date, follow-up actions
spawned. The briefs stay as evidence; this file is what was *decided*.

---

## D1a — Reference sigil semantics (2026-07-11)

**Ratified (Joseph, verbatim scope):** `@` survives with exactly one
meaning — **inert typed pointer**: `@element[key]` explicit, `@[key]`
shorthand that **errors when ambiguous**. Transclusion/insertion is not a
parser semantic; resolution is tooling-layer.

**Explicitly still open from the same brief:** D1b (`key`/`traits` as AST
fields) and D1c (bare `?` suffix naming) — Joseph inclined but not yet
ratified.

**Spawned spec-work (queued):**
- Spec edit: `@` reference section rewritten to inert-pointer semantics;
  remove/redirect the old `@[id]`-inserts-element text (FULL-SPEC ~"Implicit
  References").
- **Key-scope enforcement text** (raised by Joseph at ratification):
  type-scoped uniqueness `(element-type, key)` is already specified in
  design/udon-ast.md:104-134 with an ERROR example, but the enforcement
  layer was underdefined. Coordinator rec pending Joseph's confirm:
  event/streaming layer never checks (statelessness is what keeps UDON
  streamable); **Document/tree layer errors on duplicate definition by
  default** (DB-pk semantics: duplicate = corruption); `@`-references
  irrelevant to definition-time uniqueness; `@[key]` ambiguity-error is the
  separate reference-time check. Both checks live at Document layer.
- Un-ban `@` references in vivarium's PROCESS norms once spec text lands.
