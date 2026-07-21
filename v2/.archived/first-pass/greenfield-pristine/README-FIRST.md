# README-FIRST — clean-room materials

This directory is a **clean-room presentation of the UDON language**: the
specification with implementation, event, and wire prescription deliberately
removed, a broad corpus of `.udon` snippets, and — where present — a terminology
probe and a document-design guide. Everything here is *input*. What you produce
from it and/or how you modify it is described in your separate task brief.

## Important Notes on the spec (`spec/*`)

1. You can ignore the `[!caution] CURRENT BEHAVIOR` and `[!attention] UNDEFINED
   BEHAVIOR` callouts — those are our current-reference choices, deliberately
   **not** language contract currently, and don't need to be reflected in your
   work in any way.
2. The "the parser does X" behavioral-framing voice — we kept it because it
   defines real behavior (indent/dedent and the like). You'll likely want to
   take the required *behavior* it describes without necessarily using the
   parser terminology or having it unduly influence implementation concernts.

## Important Notes on the snippets (`snippets/`)

These come from the test-fixture corpus and worked examples — lots of edge and
corner cases, not a style guide:

1. No snippet is particularly idiomatic or pedagogical unless *you* decide it is.
2. As a whole they should give errors and corner cases a good workout.
3. `from-fixtures/v0.8` in particular is pre-modern — fine as input, but if
   something looks like it has been or should have been retired, that's very
   likely correct. (And not even the v0.9 ones are exhaustive on the current
   spec — they test corners.) You may still find them useful for seeing what
   your ideas would do in those cases.
4. Don't limit yourself to what's here — invent more inputs whenever an idea
   needs exercising.

## Layout

- **`spec/`** — the language specification, scrubbed of the event/wire layer.
  Syntax and semantics (what each construct *means*, and the *behavior* on
  malformed input — "a warning is issued if X is unclosed", "an unclosed
  identity key yields a `$partial-key`") are intact; event/warning-code names,
  emission ordering, wire-encoding sections, and the event-emitting parts of the
  implementation sketches are gone. Live decision-status ("deliberately
  undefined", "provisional", "interim", "normative", "needs a ruling") is kept;
  dated provenance breadcrumbs are removed. `MARKDOWN.md` / `CORE-supplement.md`
  needed no scrub.

- **`snippets/from-corpus/`** — udon snippets an earlier spec-only pass
  generated, by topic heading; its derived answers removed, only the udon kept.
- **`snippets/from-fixtures/`** — udon inputs from the reference test corpus
  (v0.9 / v0.8 / exploratory / _wip), one file per group; assertions,
  descriptions, and behavior-hinting ids stripped (ids are opaque labels). The
  pre-reboot `legacy-pre-0.8` group is excluded (retired syntax).
- **`snippets/from-spec/`** — the udon examples embedded in the scrubbed `spec/`,
  lifted out for convenience.
- **`snippets/from-examples/`** — whole-document worked examples (configs,
  schemas, docs), modernized to the current spec and parser-validated — the one
  place you see UDON at realistic document scale.

- **`extracted-jargon.txt`** *(you might not see this)* — a sampling of jargon
  from the current spec, its design docs, and adjacent project areas. It was
  gathered as terms used *potentially inconsistently and almost certainly
  redundantly* across the project — a jumping-off point for seeing what is
  unclear, uneven, or simply redundant already.

- **`defining-udon.md`** — a short guide on structuring a format's docs into
  three separated pillars (Grammar / Specification / Pedagogy), with the
  principle that implementation jargon must not bleed into the outer layers.
  Useful background on the intended *shape* of the spec.
