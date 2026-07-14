# FULL-SPEC-TODO — what's left

The spec-text integration of the ratified decisions is **complete** (2026-07-13);
**`FULL-SPEC.md` is authoritative.** This file now tracks only what remains.

*History: the dense predecessor ledgers are archived at `decisions/DECIDED.bak.md`
and `spec/FULL-SPEC-TODO.bak.md` (reference only); the per-decision briefs are in
`decisions/_superseded/`. Decision provenance is in git history + DECIDED.bak.*

> **Discipline (learned the hard way — see the .bak files' META-1):** read the
> FULL-SPEC section before editing or advising on it, and re-grep line numbers
> (they drift).

---

## Landed in FULL-SPEC (2026-07-13 pass)

Identity model (`[key]`/`.trait` sugar → `$key`/`$traits`/`$?…`, specially-
designated, Host Views, Anonymous Elements); References & Mixins (`@` inert,
`:[id]` removed, mixins experimental, Duplicate Definitions, reference
immutability); Attribute Stacking (⊥ array-literals); Core-minimalism framing;
Escapes (`'`→`\`); Freeform fences; Head Position + Marker Recognition guards +
Bounded-Lookahead appendix; Explicit typing `<…>`; BlankLine/Warning events;
terminology sweep (`id`→`key`, `class`→`traits`). Extractions: Dynamics →
`spec/DYNAMICS.md`; Markdown → `spec/MARKDOWN.md` (draft). Trailing
"not-authoritative / being-recast" banners on `FULL-EBNF.md` and `TIME-SPEC.md`.

## Remaining — Tier-2 parser / grammar

*The spec is right; the parser must catch up. All grammar/tree/tests — **no spec
decisions left in here.** Held pending Joseph opening the grammar phase.*

- [ ] Wire-names: emit `$key`/`$traits`/`$?…` (grammar `$id`/`$class` symbols),
      no aliases.
- [ ] Fix the `:id`/`:class` hijack: a bare `:id foo` must be an ordinary
      attribute; intercept `$key`/`$traits` in `tree.rs`, not `"id"`/`"class"`.
      `[defect #4]`
- [ ] Type bracket/key values (`[01]`→int, `["01"]`→string). `[defect #2]`
- [ ] Enforce `:`-attributes-before-children. `[defect #9]`
- [ ] Document-layer duplicate-`(element,key)` check + policy enum.
- [ ] Head-position `!{{value}}` wraps in a block Directive → should be prose +
      Interpolation. `[defect]`
- [ ] Accessors (tree / udon-utl): `attr` (scalar/last) + `attr_all` (list);
      `traits` view always a list.
- [ ] Streaming rebuild — explicit-stack backend in descent-core. `[defect #1]`
- [ ] "multi-attr block lines" — a parser Warning to drop? Block values run to
      EOL, so there's no spec text; **confirm intent with Joseph.**
- [ ] Regenerate parser + fixtures/tests to match the above.

## Remaining — companion specs (their own passes)

- [ ] `TIME-SPEC.md` → recast as the `temporal@1` dialect (value grammar *inside*
      `<…>`). Banner-flagged out-of-date.
- [ ] `spec/MARKDOWN.md` enumerations: the Layer-1 subset (D4a) and Layer-2 `doc`
      vocabulary (D4b). Flagged draft.
- [ ] `spec/DYNAMICS.md` — content-complete (moved verbatim); optional tidy.

## Two tiny pre-existing FULL-SPEC gaps (never part of the decision batch)

- [ ] Open Question: do quoted strings in arrays follow the same rules as other
      typed values? (FULL-SPEC "Open Questions".)
- [ ] `}` before `]` in an array is "malformed (unspecified behavior)" — specify
      or leave.
