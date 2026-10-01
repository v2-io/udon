# *Volume* SOP — how work is done in spec-lite-0.1.0

**The SOP store's main outline:** a view over `sop/src/` and `sop/def/`. Its rows are current truth, the results of decisions; the process decisions themselves are in `sop/adr/` and are cited from records through ⟦per⟧, not listed here ([[decision:outline-is-current-truth]]). This store records how work is done here, separately from what lite is. It is a small verisectorium of its own, with its own kinds (`sop/.vsect/kinds.yaml`), decisions (`sop/adr/`), and integration surface (`sop/influx/`). Start with [[dir:orient]].

**Register:** carved 2026-09-30 from `sop/influx/`. Every row here is `proposed` until Joseph reviews it. The process decisions cited in ⟦per⟧ are in `sop/adr/`, written by the coordinator alongside this carving.

**Columns:**
- *Row-type* is authored here ([[conv:row-type]]).
- *Record* is a `[[kind:slug]]` reference ([[conv:references]]).
- *Description* is this view's own one-line perspective on the record.
- No ※ or ∂ columns until a linter exists to compute them ([[decision:no-computed-columns-yet]]). When `bin/` has an outline linter, this view adds ∂(Doc-state) and lets the linter fill it.

---

## *Chapter* Orientation

| Row-type | Record | Description |
|---|---|---|
| proposed | [[dir:orient]] | How a mind meets this corpus: doctrina, praxes, professio, and the feedback channel. Read first. |
| proposed | [[dir:scope]] | The SOP side writes examples, proposals, and templates for lite. Lite's own decisions are the udon team's. |
| proposed | [[ref:hazards]] | Failures already paid for here, each with its tell and the check that catches it. |
| proposed | [[ref:spec-layout]] | Where things are usually kept. A map, not a rule. |

## *Chapter* The outline

| Row-type | Record | Description |
|---|---|---|
| proposed | [[conv:outline]] | The outline must always be true; the four concerns; `main.outline.md`; views choose their columns. |
| proposed | [[conv:row-type]] | The six row-types. Only `landed` needs a decision; `landed` is not `integrated`. |
| proposed | [[conv:doc-state]] | `missing` · `drafted` · `conforms`: computed, exhaustive, and not a ladder. |
| proposed | [[conv:column-notation]] | ※ and ∂ columns; `—`, `∅`, and `⚠` in computed cells; ※ shows `—` on rows with no document. |
| proposed | [[conv:ordering]] | Outline order against `depends` (undecided): a candidate practice, held until a linter needs it. |
| gap | [[conv:outline-lint]] | What the `bin/` outline linter checks, what it writes, and how it reports. The convention records above say what a violation looks like; this would collect those into one contract. |
| gap | [[conv:applicability]] | The row-type × kind × field table that tells the linter where `—` belongs. |

## *Chapter* Records

| Row-type | Record | Description |
|---|---|---|
| proposed | [[conv:records]] | One record per file; kind declared in frontmatter; identity is (kind, slug); directories only organize. |
| proposed | [[conv:kind-change]] | A record never changes kind: the old one is retired and new ones emerge, linked by `was:`. |
| proposed | [[conv:references]] | `[[kind:slug]]`, `[[store/kind:slug]]` across stores, bare slugs in single-kind fields; unwritten vs dangling; templates excluded. |
| proposed | [[conv:record-flags]] | `awaiting-second`, `awaiting-decision`, and `needs-work`: each describes only its own record, and is cleared by the act it waits on. |
| proposed | [[conv:verification-and-status]] | Each kind declares its ladder; the verifying act writes the level and its `evidence` into frontmatter; ∂(status) is computed. |
| proposed | [[conv:working-notes]] | Any record may have working notes, holding anything; each note is dispositioned (resolved, kept, deferred, promoted) before the record is frozen. |
| proposed | [[conv:term-delimiters]] | `«…»` for lite terms, `⟦…⟧` for SOP terms; each store's lexicon is in its `def/`. |
| proposed | [[conv:record-cadence]] | Which sections each kind contains, in order, including the optional Why, Sources, Cautions and Regression guards. `conforms` is checked against this. |

## *Chapter* The spec store

*Conventions for how the spec store is organized. Lite's content is the udon team's ([[dir:scope]]).*

| Row-type | Record | Description |
|---|---|---|
| proposed | [[conv:fixtures]] | Fixtures are records that no outline lists: one YAML mapping with `cases:`. Rules cite them; case ids are stable anchors. |
| proposed | [[conv:purpose-layer]] | Principle, fitness, and objective: one concern, up to three records; split on demand; four force levels; the Goodhart and commitment guards. |
| proposed | [[conv:decisions]] | ADRs from the template, with reasoning and assumptions required; supersession, never editing in place; two separate decision sets. |
| gap | [[dir:land-a-row]] | The practice for moving a spec row to `landed`: the decision, the `per` citation, and who may do it. |

## *Chapter* Integration and delegation

| Row-type | Record | Description |
|---|---|---|
| proposed | [[dir:integrate]] | Carrying material out of `.int/` or `sop/influx/`: the four outcomes and the delete-test. |
| gap | [[dir:delegate]] | Briefing agents who work here, adapting `~/src/arch/AGENTIC-DELEGATION.md` and `SPIKE-PROMPT.template.md` to this store: a bare brief for de novo reviews; spiker, verifier, and integrator kept apart. |
| gap | [[conv:changelog]] | The history layer: where "what happened and when" goes, including working notes deferred to it. |

## *Chapter* Vocabulary

*The SOP store's lexicon. Terms from these records are written `⟦…⟧` everywhere in this store. Each row describes its record in words rather than copying its `terms:` list, which is frontmatter and would drift here ([[decision:no-computed-columns-yet]]).*

| Row-type | Record | Description |
|---|---|---|
| proposed | [[def:record]] | What a record is: identity as (kind, slug), views and the main outline, standing, working notes |
| proposed | [[def:outline]] | The outline's own vocabulary: concerns, row-type, doc-state, column markers and cell marks |
| proposed | [[def:record-kinds]] | The spec store's kinds, each with how it fails and how it is repaired |
| proposed | [[def:sop-kinds]] | The SOP store and its three kinds: directive, convention, reference |
| proposed | [[def:record-fields]] | The frontmatter fields: links, the three flags, verification level and evidence, record status, and the spec store's own fields |
| proposed | [[def:decision]] | What a decision record carries: status and authority, wording, assumptions, reopen conditions, who was consulted |
| proposed | [[def:supersession]] | How a newer decision replaces an older one: the type and scope of a supersession |
| proposed | [[def:fixture-profiles]] | What each fixture case is for, by profile, and the case fields that go with it |
| proposed | [[def:question-closers]] | Who can close an open question: the closer categories |
| proposed | [[def:integration]] | Carrying material across an integration surface: crossings, their outcomes, and the delete-test |

---

## *Working Notes (outline-level)*

- **What is still in `sop/influx/`:**
  - `jaw-proposal-and-feedback.md` is **needs-review** and stays: it is the live thread of Joseph's rulings, and new ones still arrive there. Its settled parts are carried into the records above; its open items for the udon team are in `../.int/questions-from-the-examples.md`.
  - `proposed-verisectorium.md` is **needs-review** and stays. Its kinds, fields, purpose layer, decisions, question lifecycle and rule cadence are carried over. Its spec-store layout and "What needs you" sections are for the spec store and the udon team; its vsect requirements are in `../.int/vsect-requirements-on-lite.md`.
  - `adr-check-notes.md`, the independent check of the delegated decisions: its crossing isn't recorded yet.
