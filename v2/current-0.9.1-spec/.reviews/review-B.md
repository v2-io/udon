# Review B — de-novo audit of `current-0.9.1-spec/`

*Reviewer B (independent; unprimed by Review A or the coordinator's read).
Method: read the whole suite, then read the primary sources at the point of
each claim — `spec/msc/CHANGELOG.md` "Ruled" batches, `spec/CORE.md` (live
alpha.2), `v2/DECISIONS.md`, `v2/OPEN.md`, the three greenfields, and
`defining-udon.md`. Comparative greenfield reading was targeted, not
exhaustive; that limit is flagged where it bites.*

## Headline

The suite is **high-fidelity consolidation**. I checked every DELTAS row and
every CARVEOUTS item against a primary source and found no ruling misquoted,
no ruling landed stronger or weaker than its source, and no carve-out that
substantively closed. DELTAS rows 1–2 match live `spec/CORE.md` verbatim
("the line is dropped" at CORE.md L~53; root `:key` "undefined … free-floating
`Attr` … do not rely" at CORE.md L395). Rows 3–7, 9–10 match the CHANGELOG
"Ruled" batches and `v2/DECISIONS.md` (L0/L1/L2/L4/L5/L6/L7, R21, S2/ML,
R8, N-pos/N-scan/3b-D4). The inline-brace principle, `$partial-key`,
empty-forced-tail, EOF≡eol+dedent, the text law — all land accurately.

So the findings below are mostly **traceability, vocabulary-consistency, and
teachability** gaps, not fidelity breaks. Ordered by severity.

---

## Medium

### M1. Version identity (`0.9.1`) contradicts the ratified charter (`0.10.0`) with no reconciling cite
**Files:** README.md ¶1, ¶"Authority"; DELTAS title. **Source:** `v2/DECISIONS.md`
Charter **C0** ("**Greenfield replacement** … not brownfield merge") and **C2**
("Version line **0.10.0**; 0.9.x stays transitional history"); packaging **P1**
("Author new suite under **`v2-spec/`**").

The ratified charter says the successor suite is a *0.10.0 greenfield
replacement* authored under `v2-spec/`. This suite instead presents as a
*0.9.1 consolidation* under `current-0.9.1-spec/`. Those are three separate
divergences from C0/C2/P1, and nothing in the suite or in DECISIONS.md carries
a cite explaining the pivot. A future spec author reading DECISIONS.md (still
C2=0.10.0, P1=`v2-spec/`) next to this suite will hit an unexplained
contradiction and not know which is current.

I believe the pivot is *intentional* (a consolidation-of-current-law snapshot
is a genuinely different artifact from the 0.10 greenfield replacement, and the
demand-first turn plausibly deferred the latter). But intent that isn't
ledgered isn't law. **Disposition:** add one Overturn/amend row to
`v2/DECISIONS.md` recording that the 0.10 greenfield-replacement charter
(C0/C2/P1) is superseded/deferred in favor of the 0.9.1 consolidation, with
date + provenance — then the README's "0.9.1" has a cite the way every DELTAS
row does. Cheap, and it closes the one place a reader could conclude the suite
contradicts its own governing ledger.

### M2. `ADM` → `Document Model` renamed silently; breaks the term used by every source and by `defining-udon.md` itself
**Files:** MODEL.md (title + throughout), GLOSSARY.md (no entry; retired-terms
table omits it), CORE.md (says "the model"). **Sources:** `defining-udon.md`
Part 2 §5 ("Define the **Abstract Document Model (ADM)**"); `v2/DECISIONS.md`
C3/C5/L1 ("in the **ADM**"); all three greenfields use "Abstract Document
Model" (2a has an `ADM.md`; 3b's MODEL.md and CORE.md say ADM).

The suite uses "Document Model" / `MODEL.md` exclusively — zero occurrences of
"ADM" — with no glossary definition and no retired-terms bridge. This is the
one aspiration in `defining-udon.md` §7 ("The Glossary as the Source of Truth")
and §5 (the ADM is a *named* pillar) that the suite quietly drops. It's a
defensible simplification ("Abstract" adds little), but per the suite's own
retired-terms discipline it should be *recorded* as a rename, not made to
vanish — otherwise a reader arriving from DECISIONS.md, defining-udon.md, or a
greenfield can't tell that MODEL ≡ ADM. **Disposition:** either restore "ADM"
as the term, or add GLOSSARY entries "**Model / Document Model** — the ADM of
prior drafts" and a retired-terms row `ADM → the Document Model (MODEL.md)`.

### M3. `S4` (is `InconsistentIndentation` prose-only?) is listed OPEN, but the suite takes a position without flagging it
**Files:** CORE.md Appendix B (`InconsistentIndentation` row: "prose **or
comment-continuation** line") and §8 continuation / §7.2. **Sources:**
`v2/OPEN.md` — **S4** still open ("`InconsistentIndentation` prose-only? —
STEWARD / fact — Grammar intent"); live `spec/CORE.md` L31 already reads
"Prose (or comment-continuation)".

The suite extends the warning to comment-continuation lines. That is *faithful
to live CORE* (so not an invention), but `v2/OPEN.md` still lists whether the
warning is prose-only as an **open steward/fact question**. The suite thus
answers S4 in the affirmative-plus (also comment-continuation) while CARVEOUTS
and DELTAS say nothing about it. This is the mildest version of the "carve-out
that quietly closed" failure mode: a genuinely-open row settled in passing.
**Disposition:** lowest-friction is a one-line CARVEOUTS note (or an S4 mention
under an existing item) that the comment-continuation extent of
`InconsistentIndentation` follows live CORE pending the S4 steward call — so the
position is *marked as inherited*, not silently ratified. (If Joseph has since
ruled S4, cite it and drop the OPEN row instead.)

---

## Low

### L1. "Recognition / Recognizer" is pervasive formal vocabulary but absent from the GLOSSARY
**Files:** CORE.md §1 ("A conforming **recognizer**"), §1.1, throughout;
GLOSSARY.md (defines Consumer, Host, Document layer — but not
Recognition/Recognizer). **Source aspiration:** `defining-udon.md` §7; 3b's
CORE treats "Recognizer" as a formal noun.

The conformance target of the whole suite ("recognizer") and its central verb
("recognition") have no glossary entry, though "Consumer," "Host," and
"Document layer" (its peers in the layer stack) do. The suite keeps them
lowercase, which technically dodges the "don't capitalize an undefined formal
noun" rule — but a reader can't look up the one role the normative documents
are addressed to. **Disposition:** add a GLOSSARY entry: "**Recognizer** — the
conformance target: the layer performing surface **recognition** (source →
model), below every Consumer." One line; completes the layer vocabulary.

### L2. DELTAS row 10 cites "D4 (3b)" — collides with CHANGELOG's unrelated "D4"
**File:** DELTAS.md row 10 ("N-pos, N-scan, **D4 (3b)**"). **Sources:**
greenfield-3b `DECISIONS.md` §"D4 — Vocabulary stabilization" (the intended
referent — verified, cite is *correct*); CHANGELOG.md 2026-07-19 third batch
"**D4** — ruled Text: `BlankLine` … `\n`" (a different D4, one the suite also
relies on).

The cite is accurate, but two distinct rulings named "D4" are both live in this
suite's provenance (3b-D4 = vocabulary; CHANGELOG-D4 = BlankLine newline). A
reader checking the cite could land on the wrong one. **Disposition:** write
"3b-D4" or "greenfield-3b D4 (vocabulary)" to disambiguate from the CHANGELOG
D4. Trivial.

### L3. DELTAS "complete list" claim — one candidate omission to confirm, not assert
**File:** DELTAS.md ¶1 ("**complete list** … Everything not listed here is
consolidation … no behavior change").

I could not find a behavior change that is missing from DELTAS — the ten rows
plus the organizational note appear to cover the surface. The one place I'd ask
the author to double-check against their own memory rather than trust my read:
the `< >` → nil vs `<>` → interim-string split (CORE §11.6 / CARVEOUTS
ENV-EMPTY). It's correctly *carried* from the CHANGELOG empty-brackets ruling +
the 2026-07-19 "empty envelope interim string" ruling, so it's existing law,
not a change — but it's the subtlest "same document, two behaviors" case in the
suite, and if any row belongs in DELTAS-as-clarification it's this one.
**Disposition:** author confirms it's pure consolidation (I believe it is); no
change expected. Logged only so the completeness claim is *checked*, not
assumed.

---

## Prose quality, teachability, and best-of-greenfields (widened scope)

Honest framing: the suite's prose is **strong** — dense but ruthlessly
cross-referenced, RFC-2119 disciplined, rationale cleanly separated
(RATIONALE.md is excellent and does exactly what `defining-udon.md` §6 asks).
My greenfield comparison was targeted; I did not find a section where a
greenfield's *wording* is clearly better and was dropped, with two caveats:

- **P1 (best-of-greenfields):** The suite's CORE §1 is visibly synthesized from
  3b's Recognizer framing plus 2a's honest conformance clause — a good pull.
  The one term the greenfields carried *better* is **ADM** itself (see M2):
  2a even gave it its own pillar file. That's the single "greenfield said it
  better" finding I'm confident in.

- **P2 (defining-udon aspirations):** Met well except the two vocabulary gaps
  above (M2 ADM, L1 Recognizer) — both under §7 "Glossary as the Source of
  Truth," which is the aspiration most worth maximizing and the one with the
  most residual slack. The 4 C's are otherwise well served; the ADM pillar
  (§5) is present as MODEL.md and genuinely good.

- **P3 (pedagogy):** PEDAGOGY.md is a *good* thin stub — the 10-rung ladder,
  the per-rung "one example / one footgun / one you-now-know-enough-to," and
  the explicit deferral-with-reason all honor P4 and `defining-udon.md` Part 3.
  No complaint about what exists. One teachability note for the *suite as a
  whole*: CORE.md is 1266 lines and a fresh implementer meets the full density
  before any on-ramp. **Appendix A (quick surface map) is the natural on-ramp
  and is buried at the end.** Consider referencing Appendix A from README's
  reading-order table and/or CORE §1 ("new to UDON? read Appendix A first"), so
  the annotated example greets the reader instead of trailing them. Pure
  navigation; no content change.

---

## What I explicitly checked and found clean (so the author can skip re-deriving)

- All CARVEOUTS still-open items map to a live OPEN.md/DECISIONS source: **ML**
  (OPEN ML / R3), **ENV-ROUTE** (OPEN S12), **PATHS**+PATH-1 (OPEN S3 /
  DECISIONS PATH-1 steward mark), **PRAGMA** (S15), **DIALECT-DEF**,
  **MD** (S16), **MIXIN** (S13), **ANNOT** (C2), **IND** (OPEN IND — nicely
  carried, incl. the "CORE 2-space note is non-normative" verification),
  **RC-SPELL** (L5/R21), **S9**, **W** (R8), **CODES** (W4). None closed.
- The ML carve-out's interim-behavior box is framed descriptively ("PINS
  CURRENT BEHAVIOR" / S2) in both CARVEOUTS and CORE §13.2 — the calcification
  guard the whole register exists to protect is intact.
- Internal consistency across the pillars: FlowValue/Segment definitions agree
  (CORE §7.1 / MODEL §4 / GLOSSARY); stacking-≠-list is stated identically in
  CORE §6.7, MODEL §3, SEMANTICS §2.4; the text law is consistent in CORE §7.4,
  MODEL §6, RATIONALE. The final-terminator disposition (kept vs ornamental)
  correctly follows the *later* 2026-07-19 ruling over the earlier S6-wire
  "edge→ornamentation" phrasing — the suite resolved that source-level tension
  the right way.

*Reviewer B standing by for follow-ups.*
