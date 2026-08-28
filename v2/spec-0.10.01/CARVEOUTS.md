# Carve-outs — deferred with owners (0.10.1-draft)

**Status: PROPOSAL DRAFT; normative as to scope.** Every item is deliberately unspecified here **and has a named owner** — the change from 0.10.0's register, where openness carried only its reason: deferral-with-an-owner replaces fence-with-a-reason. Implementations MUST NOT treat their own behavior as settling any item. 0.10.0 CARVEOUTS rows not restated here are either dissolved (DELTAS 4: ML) or carried unchanged (UNI, S4-SCOPE, S9, IND, MD, CODES, W — same owners as before).

## PATH — the head grammar
**Owner: the addressing theory** (`../references/`). Outer-path/logical-path → inner-selection, filters, origin-posture spelling (relative vs universal-origin), composite heads, structural-key matching, cross-document addressing. The core holds: the selector subset + delimited raw heads (CORE §9.1), frozen — no incremental growth; the grammar replaces the subset wholesale.

## HOLD — composition and evaluation-time hold
**Owner: the addressing theory + the schedule work.** Whether hold composes without bound or saturates; the spelling of a generator held *through an evaluation* (template-writing-templates at the surface — `!<…>`? depth marks?); whether hold-depth and origin-passage are one number. Recognition-level hold (this suite) is settled: everything is held once.

## CAP — capture-sugar and the geometric spelling
**Owner: the vocabulary/dialect work.** Whether strings and lists are blessed sugar for captures (which would give them capture-owned line spans and finish the ML dissolution — until then lists/identity brackets keep stated current behavior); the geometric capture's spelling (`!:kind:` retained-but-re-owned; a `<kind:`-headed geometric form is the alternative); `< >`→nil; nested-capture routing.

## EVAL — evaluation policy and failure vocabulary
**Owner: def-generator + the vocabulary work.** Does evaluation policy factor like resolution's (admissibility/preference)? What replaces the miss vocabulary for a failed evaluation? Output seating (where produced material lands). The baseline template vocabulary (if/for/let/…) is a companion spec against these answers.

## VOCAB — vocabulary definition, declaration, binding
**Owner: the addressing theory (scope edges) + dialect work.** What a vocabulary is as an artifact; how a document declares its vocabulary scope (the old PRAGMA — now an edge-declaration question); default active sets; override order beyond declared-preference.

## SCHED — schedules and the store
**Owner: the pipeline/store work** (`../notebook-sketch-pipeline.md` lineage). Which determinations fire at which stage; store-at-rest holding; per-query as-of; mediated-step termination in practice (the includes loop).
