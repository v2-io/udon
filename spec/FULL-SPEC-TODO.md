# FULL-SPEC-TODO — ratified decisions not yet integrated into FULL-SPEC

**This is a staging queue — NOT the spec, NOT normative.** The *rules* live in
`FULL-SPEC.md`; the *history* lives in `decisions/DECIDED.md`; this file lists
what still needs writing **into** FULL-SPEC, and how. When an item lands in
the spec, delete it here.

*(Renamed from `AUTHORITY.md` on 2026-07-11 — it was being mistaken for the
spec itself, and had drifted into re-explaining grammar rules in denser prose
than FULL-SPEC. See DECIDED.md META-1. There is no "decision-routing
authority": there is no group of owners to route between — only **the core,
and what the core deliberately leaves to consumers.**)*

---

## 0. The framing to write into the spec (core minimalism)

Not "five authorities" — one boundary: **the core is deliberately small.**

- **Core (FULL-SPEC forces it):** the sigils and head-position recognition,
  the core scalar types, stacking + order preservation, define(`|`)/refer
  (`@`), the `<…>` envelope *syntax*, the event vocabulary. Every conformant
  parser implements these identically.
- **What the core deliberately does NOT decide (left to consumers):**
  - **projection** — how a *host* turns a validated string into a native
    value (Date → chrono/Time/jiff/…). Host's call.
  - **constraint** — what is allowed/required (cardinality, no array-valued
    `$key`, vocabularies). A **schema**'s job. *Proscription lives here,
    never in core.*
  - **exotic typing** — what non-core bare patterns mean. A **dialect**'s
    job (recognition/typing, e.g. `temporal@1`) — not constraint.
- **Menu vs knob** — the core may fix an option-*space* + default while a
  consumer picks within it (duplicate-key policy: core forces
  `error|first-wins|…`; a parser/host chooses). A consumer may never invent
  options outside the menu.
- **Dialects ≠ schema** — meaning/typing vs allowed/required; never trade jobs.
- The **pragma** (future) binds a document to its schema + dialects.

This §0 is genuinely new conceptual material and *should* be written into
FULL-SPEC (a short "What the core decides, and what it leaves open" section).

## A. New material to WRITE INTO FULL-SPEC (genuine changes/additions)

| Item | Ref | Target spec area |
|---|---|---|
| `<…>` explicit-typing envelope; `<type:…>`/`<dialect:type:…>` ladder; unlabeled dispatch = declared dialects in declared order, first-claim, all-decline → error | D2-ET | new "Explicit typing" §, near Value Types |
| Bare typing = **frozen core scalars only**; all dialect types (incl. all temporal, ISO dates included) require `<…>`; accretion structurally impossible | D2-ET-ext | Value Types; TIME-SPEC recast as `temporal@1` dialect |
| Identity model (C): total sugar-desugaring into **specially-designated** (not reserved) `$key`/`$traits`/`$?`; `$`-names ordinary; recommended host views (`all_attributes`; `key`/`traits`/`attributes`); parser/host knobs; `traits` always-list | D1-FINAL, D1b-partial, D1-terms | Identity & Classification; new "Host views (recommended)" § |
| `\|` **defines**, `@` **refers** (inert typed pointer; `@[key]` errors if ambiguous); duplicate `(type,key)` **definition** → Document-layer error (policy-configurable) | D1a | Implicit References (rewrite the `@[id]`-inserts text); Elements |
| Attribute value **stacking**, order-preserved, uniform; stacking ⊥ array-literals (two multiplicity axes) | D-ATTR-1 | Attributes |
| Duplicate-key policy **menu** `error\|allow-if-identical\|first-wins\|last-wins\|keep-all` + `warn` (default error) | D-ATTR-3 | Attributes / consumer notes |
| Dereference = never core; parser flag + host default per mode | D-ATTR-2 | Implicit References / consumer notes |
| Multi-`$key` aliases via stacking (schema constrains cardinality) | D1-FINAL | Identity |
| **Remove `'` as a head-position escape** (→ `\` only). Confirmed 2026-07-11. Sub-call open: does `'`-as-string-delimiter also go? Migration: scan live `'`-escape usage first | D-ESCAPE | Prefixes / Block-Level Escape (§104) |
| §0 core-minimalism framing (above) | D-AUTH-1 (reframed), D2-ET, D2-ET-ext | new short section |
| **Fences** — *mix of change + re-affirmation* (reconciled vs Joseph's paragraph 2026-07-11): CHANGES — closer = **any-indent** ``` closes (FULL-SPEC:1179 says opening-indent-*or-less*); opener is **not** a fence after prose (FULL-SPEC:1160/1164 allow ``` after any content — **:1164 example must be rewritten**); closer must be **followed by newline** (trailing ws ignored, not in spec). RE-AFFIRMED (already correct): indentation→parent (:1159), content-after-``` = body (:1161), recommend closer at opening indent (:1178). Sameline fence works in *scan position* (`\|a \|b \`\`\``), NOT after prose. | D8, D8-unify | FULL-SPEC §Triple-Backtick (1154–1189) — rewrite closer rule + :1164 example |

## B. ALREADY in FULL-SPEC — impl violates it (NOT spec changes; these are DEFECTS)

*These felt like "decisions" only because we were reading the broken
implementation, not the spec. The spec already settles them; the work is
impl enforcement, not spec text.*

| "Decision" | Spec already says it | Reality |
|---|---|---|
| `:` is an attribute only before children/text (`:one for the ages` after prose = text) | **FULL-SPEC:1591–1598** "Attributes must precede child content" | impl doesn't enforce → **defect #9** |

## C. Gap-fills — FULL-SPEC silent, needs new (small) text

| Gap | Ref | Note |
|---|---|---|
| `:`/`;`/`!` head-position recognition predicates | D9 | FULL-SPEC gives only `\|`'s (line 157). `!` = identifier/`:` (`!{…}` is prose-level inline, per FULL-SPEC:1126); `;` guard = skip (S3: zero incidence); `:` = the phase rule above |
| "Head position" as a named term | LEX-1 | a *name for* the existing block/sameline model (§32), not a new mechanism — introduce it in Positional Contexts |
| Bounded-lookahead invariant (≤~3 chars, no deep backtrack) | ARCH-1 | non-normative design-rationale appendix |

## Still genuinely open (not yet ratified → JOSEPH-TODO)
Markdown subset (decision 4) · reference augmentation (6) · BlankLine/Warning
event spec-status (7) · multi-attr-block-line legalization · the two
authority-compliance tensions (T1 reserved-suffix contradiction, T3 dynamics
grammar) · mixins (rethink/drop).
