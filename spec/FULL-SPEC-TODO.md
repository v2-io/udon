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

*(none currently open — see closed list below)*

*Closed 2026-07-14:*
- *Bare-name / bare-trait **character class** — back-filled to the Unicode
  identifier set (`XID_Start` / `XID_Continue` + `-`) from `core/generator/
  udon.desc`; "Bare-name characters" paragraph in "Identity … and Classification"
  (`d844a72`).*
- ***Numeric-literal grammar** — "Numbers" rewritten from "Ruby conventions"-by-
  example to explicit int (four bases, incl. `0d`) + float productions sourced
  from `values.desc`; rational/complex marked provisional (`d844a72`).*
- *The `<…>` recognition rule (bare `<` in attribute-value position opens the
  envelope; quote for a literal — "Explicit Typing"); quoted-strings-in-arrays
  and `}`-before-`]` ("Array Item Values").*

*Everything once queued here has landed in FULL-SPEC. Parser catch-up is in
`core/PLAN.md`; companion-spec recasts are tracked by their in-file banners.*

**One design note deliberately parked** (not spec-text yet, awaiting Joseph's
call — raised 2026-07-14): a type-nesting / bracket-stack caveat for "Explicit
Typing". Today that section says "`>` terminates the value"; composite nesting
(`<r: <i: 3 -7> 0d83.23>`) will need `<>`-balance (the *matching* `>`), with
routing left open (possibly dialect-driven). Direction captured in
`design/composite-types.md`; add to FULL-SPEC only when the dialect layer is in
view.
