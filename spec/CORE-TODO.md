# CORE-TODO — spec-text edits pending for CORE.md

**Scope: only edits to `CORE.md` itself.** Parser / grammar work lives in
`core/PLAN.md`; the companion specs (`DYNAMICS.md`, `MARKDOWN.md`, `TIME-SPEC.md`)
carry their own status banners.

> *Discipline (META-1): read the CORE section before editing or advising on
> it, and re-grep line numbers — they drift.*

---

## Open

- [ ] **Adjudicate `FULL-EBNF.md`'s fate** (raised 2026-07-14). It is a derived,
      perpetually-lagging illustrative grammar; a second grammar artifact
      undercuts CORE-as-sole-source-of-truth and it has already caused confusion
      (cited as if corroborating CORE). Decide: delete / reduce to a pointer /
      keep. Deferred by Joseph for a deliberate call.
- [ ] **Finalize the inline-form escape** (from the 2026-07-14 escape rewrite).
      **Requirement (Joseph, firm):** the inline forms we support now —
      especially inline directives `!{…}`, plus `|{…}`, `!{{…}}`, `;{…}` — MUST be
      escapable. Candidate mechanism: a mid-prose `\` before an opener (`|{` /
      `!{` / `;{`) is consumed and makes it literal; a `\` before ordinary text
      stays literal (so `C:\Users` is untouched). This is one uniform inline rule
      (not the old per-context `\;` mess), but it *is* a second `\` behavior
      beside head-position force-prose — **watch the complexity**; Joseph flagged
      that if the escape story starts feeling too complicated we rethink the
      whole approach. Not yet ratified.

*(Otherwise CORE is current with all ratified decisions as of 2026-07-14.
History lives in git; decisions in `_archive/DECIDED.bak.md`.)*
