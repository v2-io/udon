# Where v2/ stands — a plain-language orientation (2026-09-27)

**What this is:** a head-start for Joseph's next deliberate session on v2/. It says what happened, in date order, and what each directory is — in plain words, with no new terms. **Who wrote it:** Claude (Opus 5.5), from the repo files and git history, plus Joseph's own words from the 2026-09-01 session where noted. Where it gives an interpretation rather than a fact, it says so. **What it is not:** a decision, or a design proposal. Delete it once it has done its job.

---

## The short version

- The v2 effort has run since July 19. It has produced **three spec versions** (0.9.1, 0.10.0, 0.10.1-draft), a large **needs-gathering** body of work, a **theory** corpus, and an **addressing theory** (paths and references) in `references/`.
- Across all three spec versions, the **basic language barely changed**: indentation for nesting, `|element`, `:label value`, same-line material, repeated labels stacking instead of overwriting, text, the six plain value types, and "keep everything, warn instead of dropping."
- What **kept changing** is everything that points elsewhere or runs later: `@` references, `!` directives, `<…>` typed values, raw/verbatim code blocks, `!{{…}}` interpolation, and whether lists may span lines.
- The last spec attempt, **0.10.1-draft** (`spec-0.10.01/`, Aug 27), was judged a **misfire** by Joseph on Sep 1. That judgment is not yet written down anywhere in the repo except this note.
- The last activity was **Sep 21**: Joseph committed the Sep 1 audit, its test cases, and an alternative proposal (`JOSEPH-FOR-0.10.01-FIX.md`). Nothing since.

---

## Timeline

Dates are commit dates unless marked otherwise.

**Before v2 (to 2026-07-19).** The spec lived at `../spec/CORE.md` (version 0.9.0-alpha.2), with rulings in `../spec/msc/CHANGELOG.md` and a working parser in `../core/`. On July 19 the parser's event format (the "flat attribute wire") was withdrawn, and several AI agents wrote fresh independent versions of the spec from scratch (the "greenfield" rewrites, now in `.archived/first-pass/`).

**July 20 (night).** A Grok agent, given freedom to move the work forward, built a complete spec/wire/process skeleton in a `v2-spec/` directory.

**July 21.** In `udon-needs/pipeline-discussion.md` Joseph judged that skeleton premature: it was designed from what a parser can do, not from what users need. It was archived whole to `.archived/second-pass/`; `v2-spec/` was renamed `v2/`. Joseph set an **eight-step order** (bottom of pipeline-discussion.md): (1) gather needs → (2) synthesize → (3) prioritize → (4) decide paths, dialects, schemas, embeds → (5) build parsers/utilities → (6) extra engine needs → (7) decide pipeline architecture → (8) write the pipeline/"parsing framework" spec. `udon-needs/` was created, and step 1 (gathering, ~270 collected source excerpts) was done the same day.

**July 22.** Two things landed:

- **The 0.9.1 consolidated spec** (then `current-0.9.1-spec/`, now `spec-0.09.01/`): everything already ruled, gathered into one clean suite so agents had one place to read. It added no new design. `DECISIONS.md` row C7 marks it as the baseline.
- **The needs monograph** (`udon-needs/02-tooling-needs/`): about 30 chapters on what agents need from tools like UDON (step 2), reviewed by several models.

Also ruled that day: authoring conventions X1–X6 (how to write cross-references, etc.).

**July 28–29.** Long big-picture sessions. Products:

- Joseph's brainstorms, recorded verbatim with an assessment of each, as O1–O19a in `theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon`. Several became working principles. O17: language decisions flow *from* user needs and theory *to* grammar, never the other way. O18: now is the cheapest time ever to make a deep change to the language, if it can be shown to be principled.
- Measured probes: CommonMark compatibility, a table of ~130 spelling edge cases, and a schema-extraction experiment. A type-algebra study. Research on how older formats failed.
- DECISIONS row **C8**: 0.9.1 is "semi-frozen" and spec-only (not necessarily meant to be implemented as-is).

**July 29–31.** `theory/` was started as a corpus of one-claim-per-file "segments." On July 31 Joseph threw out much of an Opus 5 pass on it (commit message: "complete garbage / watered-down and de-principled ASF-TST") and restarted with a small canonical outline and six segments. It has not been touched since, except for the Aug 27 files below.

**Aug 6–8.** Paths/addressing work was started in `v2/paths/` (renamed `references/` on Aug 10). It went through two editions in three days, with a lot of tooling (term files, diagram generators, a decision ledger). On Aug 8 Joseph reset it to a skeleton and archived the second edition to `references/.archive/`. The third edition started vocabulary-first, using ordinary old words (reference, binding, scope, location…) and grounded in published "scope graph" research papers (copies in `references/ref/`).

**Aug 7–9 — the K-rulings (K1–K16 in `DECISIONS.md`).** A run of decisions on the language surface. They came largely out of actually writing documents in experimental syntax (the paths cheat-sheet). In plain terms:

- An element may have several `[key]`s, and they stack.
- `!` directives may sit anywhere an element can, but do nothing yet: they are carried as written.
- An attribute cannot have attributes.
- Everything on an element's first line is a value of some attribute. Loose text there becomes a hidden `$main` attribute.
- An unquoted value ends at the next ` :label`, ` |name` (and similar markers), or ` ; `.
- Repeated labels stack silently.
- Labels may contain almost any character, and "flag" labels are gone.
- `\` is split into two jobs: a one-character escape, and "rest of line is plain text."
- Attributes written after the element's content has started are accepted, with a warning.
- A `[key]` takes any value, just as an attribute value does.

**Aug 9 (overnight).** Two agent passes rewrote the spec with the K-rulings built in: **0.10.0-alpha.1**. Their open questions for Joseph went to `msc/for-joseph/01-PLAIN-DECISIONS.md` (D1–D11). The sheet still shows D1, D3–D9, and D11 as open. They may have been answered in conversation; the file doesn't say.

**Aug 9–10.** The first six definition files in `references/def/` were drafted, with several rounds of Joseph's corrections, plus a tool (`references/bin/compose-defs`) that joins their opening paragraphs into `references/LEXICON-overview.md`.

**Aug 10.** Merging the 0.10.0 rewrite accidentally overwrote the 0.9.1 baseline. It was repaired, and the two suites were separated into `spec-0.09.01/` and `spec-0.10.00/`. The v2/ root was tidied (`paths/` → `references/`; the for-joseph notes → `msc/`).

**Aug 10–11.** The last changes to 0.10.0: K15/K16 folded in, and the opening "axioms" section rewritten as a "guiding model" after Joseph's critique that they weren't axioms. *Why 0.10.0 later felt like it "wasn't really working" is not recorded anywhere I found.*

**Aug 27 — one Fable session, several products:**

- `notebook-sketch-pipeline.md`: Joseph's notebook sketch of how directories of documents become a logical UDON store, recreated with his redrawn version.
- `theory/to-integrate/lexical-forms-redux.md`: a from-scratch reframing. Every item in a document is either written directly ("material": elements, attributes, text) or determined later ("deferred": references, which point at things, and "generators", which produce things — the new name for directives).
- `theory/to-integrate/unification-matrix-2026-08-27.md`: each 0.10.0 construct mapped into that frame. It recommends, in order: Joseph reviews the matrix, then the addressing theory continues, and "only then" a spec restructure.
- `references/def/def-generator.ud`: a new definition file for "generator."
- `spec-0.10.01/`: the restructured spec itself, drafted in the same session under Joseph's license that "theory leads." It is marked PROPOSAL DRAFT, unratified, single-author. It renames much of the vocabulary and adds new spellings, and it merges `<…>` typed values and raw code blocks into one family.

**Aug 30.** `INBOX-REQUESTS.md`: Joseph asks for tiny, dependency-free "simplified udon" parsers in Python, Rust, Ruby, etc., each warning on anything it doesn't handle.

**Sep 1.** A session was asked to audit 0.10.1-draft. It wrote 199 test cases (`spec-0.10.01/fixtures/`) and an audit (`spec-0.10.01/working-notes/AUDIT-2026-09-01.md`). The most serious finding: under the draft, a raw code block can no longer be an attribute's value, and a code body written in the `<…>` form closes at the first `>` in the code. In the conversation that followed, Joseph said (from the session transcript):

> "So... seems like 0.10.01 mostly renames the parser to recognizer, says it doesn't do things *on purpose* instead of warning that nothing will handle it, and viola. Except it doesn't seem to work well for the verbatim capture you say?"
>
> "Ugh, so much jargon and changed terms for such a simple thing, and the one thing that's not obvious is the thing that's broken."
>
> "All three things were my suggestions early on before any of the theory."
>
> "It's not like there's a ton of theory even. I'm going to call 0.10.01 a misfire."

The session then proposed an alternative: **0.10.0 exactly as it stands, plus three changes**, shown as eight UDON-in / tree-out examples:

1. `@{…}` replaces `!{{…}}` interpolation.
2. A `!` line is parsed the same way as a `|` line (name, keys, attributes, body).
3. The parser never looks anything up or runs anything, so the "nothing will handle this" warnings go away.

Joseph saved that answer; it is `JOSEPH-FOR-0.10.01-FIX.md`. **The text is the agent's, not Joseph's.** Joseph's recollection (Sep 27): it was captured, but it seemed less and less principled as he questioned it, and other work took over.

**Sep 21.** Joseph committed the Sep 1 files (audit, fixtures, the alternative proposal, the inbox request). Nothing since.

---

## What each directory is

| Where | What it is | State | Last changed |
|---|---|---|---|
| `spec-0.09.01/` | 0.9.1 consolidated spec — ruled law as of July 22, one clean suite; also holds `udon-0.9.1-primer.md` (a ~240-line introduction for agents) | baseline, semi-frozen (C8) | Aug 10 |
| `spec-0.10.00/` | 0.10.0-alpha.1 — 0.9.1 plus the K-rulings | stalled since Aug 11; open questions in `msc/for-joseph/` | Aug 11 |
| `spec-0.10.01/` | 0.10.1-draft — the Aug 27 restructure, plus the Sep 1 audit and test cases | called a misfire Sep 1 (not yet marked in the files) | Sep 21 |
| `JOSEPH-FOR-0.10.01-FIX.md` | the Sep 1 "0.10.0 + three changes" proposal, eight examples | captured; not adopted | Sep 21 |
| `references/` | the addressing theory, third edition. `def/` holds seven definition files: reference, binding, match, scope, location, resolution, generator. `ref/` holds the research papers. `.archive/` holds the reset second edition | Part I (definitions) drafted; Part II (the actual theory) empty | Aug 27 |
| `theory/` | one-claim-per-file theory corpus (`src/`, 6 files) plus a large pile of material waiting to be integrated (`to-integrate/`), including DISCUSSION-THOUGHTS, the lexical-forms documents, the redux, and the matrix | mostly idle since Jul 31 | Aug 27 |
| `udon-needs/` | the needs work: gathering (`01-ideation/`) and the monograph (`02-tooling-needs/`) plus `pipeline-discussion.md`, where the demand-first order was set | steps 1–2 done; step 3 partly | Jul 30 |
| `spikes/` | leftover experiment harnesses (extraction probe, markdown probe) and methodology notes | idle | Jul 31 |
| `msc/` | the for-joseph decision sheets (Aug 9–11), a best-with-UDON note, reading logs | decision sheet still open | Aug 11 |
| `DECISIONS.md` / `OPEN.md` | the ruling ledger (C, R, L, W, S, X, K rows) and open questions | not updated since Aug 9–10 | Aug 9–10 |
| `.archived/` | the July clean-room rewrites and the July 20 night skeleton; `INDEX.md` says what's worth recovering | archive | Aug 8 |
| `README.md` | v2 front door | stale — doesn't mention 0.10.x or `references/` | Aug 10 |

---

## Stale pointers found (all small)

- `references/ref/current-0.9.1-spec` and `references/ref/udon-0.9.1-primer.md` are **broken symlinks**; the targets moved to `spec-0.09.01/` on Aug 10. `references/ORIENT.md` (→ `sop/src/disc-orient.md`) sends readers to the 0.9.1 spec through the broken link.
- 38 other files outside the archives still say `current-0.9.1-spec` (some are dated records where the old name is correct history), including `theory/FORMAT.md` and `theory/README.md`.
- `references/PRACTICA.ud` is dated Aug 8 and says the definitions are blocked; seven now exist. `references/LEXICON.md` is empty (its generator was never built).
- `spec-0.10.01/README.md` still presents the draft as live. The Sep 1 "misfire" call isn't recorded there or in `DECISIONS.md`.

---

## What this note does not cover

Read whole for this note: the v2 commit history, `references/` (current edition), both 0.10 CORE files, all of 0.10.01 except the test-case files, the lexical-forms documents, DISCUSSION-THOUGHTS, pipeline-discussion, DECISIONS, OPEN, the for-joseph sheets, and the Sep 1 session.

**Not read:** the needs monograph, the gathered corpus, most of `theory/to-integrate/`, the 0.9.1 suite itself, 0.10.0's companion files (MODEL, SEMANTICS, etc.), the archived second addressing-theory edition, and the 199 test cases. Anything this note says about those areas comes from commit messages or other files describing them.

---

## Questions only Joseph can answer

1. What wasn't working about 0.10.0?
2. Is the "three changes" proposal worth keeping as a starting point, or does it go the same way as 0.10.1-draft?
3. Should the misfire judgment be recorded in `spec-0.10.01/` and `DECISIONS.md` (and the stale pointers above fixed) before the next session?
