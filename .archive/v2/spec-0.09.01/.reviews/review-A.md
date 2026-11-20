# Review A — current-0.9.1-spec

*De-novo fresh-eyes pass, 2026-07-22. Reviewer A (independent; did not see review-B). Primary sources consulted at point of use: the suite itself, `spec/CORE.md` (the alpha.2 delta baseline), `spec/msc/CHANGELOG.md` "Ruled" batches (the deepest authority), `v2/DECISIONS.md` + `v2/OPEN.md`, `defining-udon.md`, and the three greenfields (2a/3a/3b) + their pedagogy files.*

**Overall.** The suite is in strong shape. Fidelity to the ruled law is high: I spot-checked every DELTAS row and the load-bearing carve-outs against the CHANGELOG and DECISIONS, and found no misquoted ruling and no carve-out that had quietly closed. The failure mode the CARVEOUTS register was built to prevent (per-construct closure of ML) is correctly held open in both CORE §13.2 and CARVEOUTS ML, with the demand-side reason carried. The findings below are ordered by severity; the first is a genuine internal contradiction, the rest are polish, teachability, and best-available-wording opportunities that would make the suite shine rather than merely work.

---

## Findings

### F1 — HIGH — CORE §14.1 asserts "the one current case" of a non-loss Error, but the suite defines two

- **Where:** `CORE.md` §14.1 (line ~1172) vs §6.8, §14.3 representative table (line ~1204), Appendix B (line ~1264).
- **What I found:** §14.1 states the loss rule and then names its sole exception: *"unless a more specific rule names Error for an absent intended value (**the one current case**: plain `:key` with no value → assignment with Nil + Error)."* But the suite defines a **second** Error whose keep-shape loses no author-visible bytes: **attribute-under-attribute** (§6.8, §14.3 table, Appendix B `AttributeUnderAttribute`) is ruled an **Error** while its keep shape is *"offending line kept as text of the open value"* — every byte represented as text. Under §14.1's own mechanical rule ("if every author-visible byte is represented in the model as structure or text, severity MUST be Warning"), attr-under-attr keeps all bytes, so either it is the "absent intended value" exception too (making "the one current case" false), or it is mis-severitied. The three tables list two non-loss Errors; the prose claims one.
- **Primary source:** the Error status is genuinely ruled — `DECISIONS.md` R6 ("attr-under-attr error status") and L6 ("kept shape: text of the open value **+ error**"); L0 ("Error = loss only … unless a more specific rule names Error for *absent intended value* — e.g. plain `:key` → Nil+Error under R6"). Note L0's own text gives **only** the missing-value case as the named exception, so the tension is inherited from the source — but the suite is the place to reconcile it, and instead §14.1 hard-asserts uniqueness its own tables contradict.
- **Suggested disposition:** either (a) reword §14.1 to admit both non-loss Errors and give attr-under-attr its "absent intended structure" justification (the author intended a nested attribute; that node is genuinely absent from the model even though the bytes survive as flat text) — the cleaner fix, since it also teaches *why* it's an Error; or (b) if attr-under-attr is truly loss-free-and-intent-preserving, reclassify to Warning — but that would contradict R6/L6, so (a) is almost certainly right. Drop "the one current case."

### F2 — MEDIUM — Pedagogy stub is thinner than the ruling requires and thinner than freely available greenfield material

- **Where:** `PEDAGOGY.md` (whole file) vs `greenfield-2a/new-spec/PEDAGOGY.md` and `greenfield-3b/new-spec/pedagogy/tour.md`.
- **What I found:** P4 licenses "outline only," and the suite's 10-rung ladder satisfies the letter of that. But the widened bar is "is what exists any good, and does the suite teach the language well?" — and the two greenfield pedagogy files carry load-bearing teaching assets the suite's stub drops even though they cost almost nothing and are *outline-compatible*:
  - **2a's "Mental models to install"** — five heuristics ("Columns are the syntax," "A line starts open and commits," "`\` = the rest is text," "Repeat a key to say it twice," "When something looks wrong, nothing was thrown away"). 2a's own sequencing note nails the pedagogical spine: *"The attribute-vs-child test and the open/commit model are the two ideas that predict everything else."* That single sentence is the best teaching insight in any of the four documents and is absent from the suite.
  - **2a's "Idiom over allowance (one-way list)" table** — directly realizes defining-udon §Part-3.4 ("idiom over allowance"), the one pedagogy principle a spec-allows-many language most needs, and the suite's stub only names it abstractly.
  - **3b's tour** — worked "whose name is it?" table with a runnable request example, and a clean Level-by-Level running example.
- **Primary source:** `defining-udon.md` §Part-3 (progressive disclosure, mental models, relate-before-naming, idiom-over-allowance, ruthless consistency) — the aspiration the pedagogy pillar is held to; 2a/3b pedagogy files show the bar is reachable within "outline."
- **Suggested disposition:** without violating P4, fold 2a's two mental-model anchors (attribute-vs-child + open/commit as "the two ideas that predict everything else") and the idiom one-way table into the stub as the load-bearing choices the outline commits to. Keep prose thin; carry the *spine*, not the manual.

### F3 — MEDIUM — "ADM" (Abstract Document Model) is dropped entirely, breaking continuity with defining-udon §5 and the DECISIONS charter

- **Where:** `MODEL.md` (title/body), `GLOSSARY.md` retired-terms table, vs `defining-udon.md` §Part-2.5 and `DECISIONS.md` C3/C5.
- **What I found:** the suite renames the model pillar to "MODEL / The UDON Document Model" and never mentions "ADM." But (a) `defining-udon.md` §5 — the documentation philosophy the suite is *held to* — establishes the term formally: *"Define the Abstract Document Model (ADM)."* (b) The charter the suite consolidates, `DECISIONS.md` C3 and C5, names the pillar **"ADM"** ("SPEC + ADM + GLOSSARY + WIRE + SEMANTICS…"; "Fixtures assert events and assembly/ADM product"). (c) greenfield-2a and 3b both use "ADM" consistently. A fresh reader arriving from any of those three and searching the suite for "ADM" finds nothing — and GLOSSARY, which claims to be *the* source of truth for every formal term and its retired synonyms, does not carry the mapping. This is precisely the "ruthless vocabulary consistency" defining-udon §Part-3.5 warns about, applied across the suite boundary.
- **Suggested disposition:** either restore "ADM" as the pillar name, or (if "Document Model" is the deliberate choice) add one GLOSSARY retired-terms row — `ADM / Abstract Document Model → the (UDON) Document Model (MODEL.md)` — and a parenthetical in MODEL's opening. Cheap, and it closes a real cross-document search hole. (This is a naming-only fix; no behavior surface.)

### F4 — LOW — CORE §11.5 cites "ruled §1.8", which reads as an internal section reference but no §1.8 exists in the suite

- **Where:** `CORE.md` §11.5 (Lists), "…are all valid items (ruled §1.8; the enumeration is illustrative…)".
- **What I found:** "§1.8" is the *CHANGELOG's* clause number (CHANGELOG "Interpolation / reference as array items → yes (§1.8)"; carried as `DECISIONS.md` R17), not a section of this suite — whose §1 is Conformance with only a §1.1. A fresh implementer will scan CORE for a §1.8 and be confused.
- **Primary source:** `spec/msc/CHANGELOG.md` line ~156 (§1.8); `DECISIONS.md` R17.
- **Suggested disposition:** change to "(ruled — CHANGELOG §1.8 / DECISIONS R17)" or just drop the bare "§1.8". Sweep for other bare "§N.N" cites that are actually CHANGELOG clause numbers.

### F5 — LOW — Open question S4 is effectively answered in Appendix B without being flagged as open

- **Where:** `CORE.md` Appendix B `InconsistentIndentation` row ("prose **or comment-continuation** line under the content base") vs `OPEN.md` S4 ("`InconsistentIndentation` prose-only? — STEWARD/fact — Grammar intent").
- **What I found:** `OPEN.md` still lists S4 as a live question about whether that warning is prose-only. Appendix B describes it as firing on prose *and* comment-continuation lines — a de-facto answer — without noting S4 is open. Appendix B is explicitly **non-normative**, so this is not a normative quiet closure, and the description may well be correct; but it is the one place a reader could mistake an open steward-question for settled fact, and CARVEOUTS (which lists IND, S9, S12, etc.) omits S4 entirely.
- **Suggested disposition:** either add a one-line CARVEOUTS/Appendix-B note that S4 (prose-only vs prose+continuation scope of `InconsistentIndentation`) is an open steward/fact question, or, if it's genuinely settled, close S4 in OPEN.md with a cite rather than leaving the two documents disagreeing.

### F6 — LOW / INFO — DELTAS row 10 provenance is a greenfield [ORG] decision, not a Joseph ruling; and a no-behavior rename sits inside the behavior-change table

- **Where:** `DELTAS.md` row 10 (Vocabulary), cite "N-pos, N-scan, D4 (3b)".
- **What I found (and verified):** the "D4" cite is **correct** — it is greenfield-3b's `DECISIONS.md` §D4 "Vocabulary stabilization **[ORG]**" (retires freeform/embedded/blob/positional/head-position). I flag it only for transparency: DELTAS's header says "each row cites its ruling," but D4 is a greenfield *organizational* decision, not a ratified Joseph ruling in the CHANGELOG (N-pos/N-scan *are* in DECISIONS). This is consistent with charter C1/C3 ("seeded authoring… tactical deference to authors"), so it's defensible — but a reader auditing provenance strictly will notice the asymmetry. Separately, DELTAS's own closing paragraph says vocabulary is "organizational (no behavior surface)," yet the rename is also row 10 *inside* the behavior-change table. Minor internal redundancy/tension.
- **Suggested disposition:** either add "(org, per 3b D4 — reader-facing, no behavior surface)" to row 10, or move the vocabulary rename out of the numbered behavior table into the organizational paragraph where DELTAS already says it belongs.

### F7 — LOW — MODEL §2 lists `Interpolation` as a top-level Node kind, but no block syntax yields a bare Interpolation node

- **Where:** `MODEL.md` §2 (`Node = … | Interpolation | …`) and `GLOSSARY.md` Node entry, vs `CORE.md` §9 ("Interpolations may appear in flow, as whole attribute values, as list items, and as a whole identity key").
- **What I found:** CORE never gives a block-level production for a standalone interpolation — a line-initial `!{{x}}` fails the `!` block guard (`!` followed by `{`, not identifier/`:`) and becomes flow text, inside which the `!{{…}}` is a *Segment*. Whole-attribute-value and whole-identity-key interpolations are a `Value` and a `$key` respectively, not a content Node. So `Interpolation` as a member of the top-level `Node` union looks like it has no producer (unlike Reference and Directive, which clearly can be block nodes). It may be defensible as "a flow whose sole segment is an interpolation," but then the Node-level listing is redundant with the Segment listing.
- **Suggested disposition:** confirm whether a bare `Interpolation` Node is ever produced. If not, drop it from the §2 Node union (keep it in §4 Segment), or add a one-line note on how a top-level interpolation surfaces. Low stakes; worth an author confirm since MODEL is normative.

---

## Strengths worth preserving (so a later edit doesn't regress them)

- **The carve-out register does exactly its job.** ML is held open in *both* CORE §13.2 and CARVEOUTS with the dissolution reason ("captures may be sugar for dialect-typed captures") carried verbatim from the pipeline discussion — the single most important fidelity requirement of this consolidation, met.
- **Deratification handled cleanly.** The wire is absent by design; MODEL §6 correctly retains the *adequacy test* (the text law) any future wire must pass, rather than either smuggling the dead wire back in or dropping the constraint. This is textbook integration-is-replacement.
- **Isolation principle (defining-udon §Part-1) respected.** Implementation code-names (`Unclosed*`, `$partial-key`) are quarantined to the non-normative Appendix B with an explicit "working names, not contract" banner; GLOSSARY keeps parser jargon out of the normative nouns.
- **The text law and the two-severity/loss model are stated once, cleanly, and carried consistently** across CORE §14, MODEL §6/§7, SEMANTICS, and RATIONALE — a genuine 4-C's "Concise + Consistent" win. (F1 is the one seam in it.)
- **DELTAS fidelity.** Rows 1–9 each check out against CHANGELOG/DECISIONS with correct baselines (I verified the tab "line lost"→warn, root-`:key` "undefined"→warn, and multi-line framing against live `spec/CORE.md`).

---

*Reviewer A remaining on the line for follow-ups.*
