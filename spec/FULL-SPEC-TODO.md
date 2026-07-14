# FULL-SPEC-TODO — spec-text edits pending for FULL-SPEC.md

**Scope: only edits to `FULL-SPEC.md` itself.** Parser / grammar work lives in
`core/PLAN.md` ("Spec Alignment" section, + REVIEW §4 defect numbers); the
companion specs (`DYNAMICS.md`, `MARKDOWN.md`, `TIME-SPEC.md`) carry their own
status banners and track their own recasts.

The 2026-07-13 integration of the ratified decisions is **complete** — FULL-SPEC
now reflects identity `key`/`traits`, `<…>` typing, fences, escapes, `@`-inert,
attribute stacking, head-position, and the rest (see git history +
`decisions/DECIDED.bak.md`; predecessor briefs in `decisions/_superseded/`).

> *Discipline (META-1): read the FULL-SPEC section before editing or advising on
> it, and re-grep line numbers — they drift.*

---

## Remaining FULL-SPEC spec-text

One tiny pre-existing gap, never part of the decision batch:

- [ ] `}` before `]` in an array is "malformed (unspecified behavior)" — specify
      or leave. (Lean: define as an error — unclosed array.)

*(Resolved 2026-07-14: quoted strings in arrays — a closing `"` ends the item, so
`["x"y]` = two items; documented as a nuance in FULL-SPEC "Array Item Values".)*

*Everything else once queued here has landed in FULL-SPEC. Parser catch-up is in
`core/PLAN.md`; companion-spec recasts are tracked by their in-file banners.*
