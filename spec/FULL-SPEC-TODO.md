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

Two spec-precision follow-ups surfaced by the 2026-07-14 EBNF audit (the spec
*works*; its prose is just looser than the descent grammar — source the exact
rule from `core/generator/*.desc`):

- [ ] Bare-name / bare-trait **character class** — precisely defined in the
      descent grammar (a Unicode-identifier set); the spec only uses bare names
      by example. Research and back-fill the exact rule.
- [ ] **Numeric-literal grammar** — the "Numbers" section says "Ruby conventions"
      by example; the descent grammar has exact productions. Back-fill.

*Closed 2026-07-14: the `<…>` recognition rule (bare `<` in attribute-value
position opens the envelope; quote for a literal — added to "Explicit Typing");
quoted-strings-in-arrays and `}`-before-`]` (documented in "Array Item Values").*

*Everything else once queued here has landed in FULL-SPEC. Parser catch-up is in
`core/PLAN.md`; companion-spec recasts are tracked by their in-file banners.*
