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
- [ ] **Literal inline-form openers mid-prose** (consequence of the 2026-07-14
      escape rewrite). With mid-prose `\` now passed through, there is no escape
      for a *literal* `|{` / `!{` / `;{` **inside flowing prose or an embedded
      `|{...}`** (the old `\|{` / `\;` did this). CORE is currently silent (a
      freeform fence gives verbatim UDON-syntax for block cases, but not inline).
      Decide: accept the gap (fence-only) / add a narrow inline escape / other.
      Bare `;` and no-preceding-space `;` are already literal, so this is a rare
      case — but a real capability regression from the old model.

*(Otherwise CORE is current with all ratified decisions as of 2026-07-14.
History lives in git; decisions in `_archive/DECIDED.bak.md`.)*
