---
source: udon repo — test/scenarios/ README (BDD "day in the life" corpus for the path/edit tool)
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - test/scenarios/README.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [tool-demand, path-tool, edit-tool, diff-tool, patch-tool, agent-workflow, bdd, vocabulary, bootstrap-discipline]
why_included: >
  The front door to the strongest single piece of UDON-side agent-tool demand evidence in
  the estate: a commissioned "day in the life of multiple agents understanding, diffing, and
  modifying" documents (Joseph, 2026-07-16). This README names the op vocabulary agents
  reached for (skeleton/at/all/diff/patch/require/set/add-value/insert/delete/move/append-block),
  states the demand-first stance ("the journey shapes are the contract, not the spelling"),
  and — for the harness-side reader — carries two transferable disciplines with no UDON
  hook: the pinned-known-good-reader-version rule for any tool that parses the artifact it is
  testing, and the .gap marker convention for recording an affordance an agent wanted but the
  packet doesn't yet cover. The vocabulary is explicitly "scenario output, not ratified
  design" — this is demand talking, before supply answered.
---

# test/scenarios — a day in the life (BDD corpus for the path/edit tool)

Commissioned by Joseph 2026-07-16: *"a bunch of cucumber-like BDD scenarios
of exactly the kinds of things and pretended chronicle of events that would
be a typical 'day in the life of multiple agents understanding, diffing, and
modifying' those files... then we can turn those user-paths into some great
BDD tests for the path tool itself."*

Two halves, one fiction:

- **`corpus/`** — seven pseudo-real documents. Same genres as the live
  consumers (the ASF process map, vivarium's LEXICON / ordinum / decision
  log, the operata DSL from `design/examples/`), rewritten in **CORE
  0.9.0-alpha.1 idiom** with their own abridged content, so scenarios can
  mutate them freely while the real files stay untouched. Every file
  parses **clean** under the current reference parser — zero warnings and
  errors except the specified-interim `NoDialectsLoaded` from deliberate
  `<…>` envelopes (`bin/verify` enforces exactly that contract).
- **`features/`** — four scenario files chronicling one fictional day
  (2026-07-21): five agents (surveyor, ordinator, lexicographer ×2,
  operator-1/-2) sharing the corpus with no locks and no coordinator.
  `01` understanding (morning reads), `02` diffing (midday), `03`
  modifying (afternoon writes), `04` multi-agent (contention, handoff,
  the evening ledger).

## The scenarios are UDON

Not `.feature`, not markdown: the README's own pitch — UDON as "a host for
domain-specific languages — Gherkin-like BDD for any domain" — is taken at
its word. Each scenario is a `|scenario` element with `|given` / `|when` /
`|then` children and prose flowing between them. Until a runner exists they
are read by humans and agents; the journey shapes are the contract.

**⚠ Runner rule — peg the reader (Joseph, 2026-07-16):** when the runner
exists, it reads these files with a **pinned, known-good parser version**,
never this repo's head parser — the head parser is the thing under test, and
a broken head could misread the very scenarios that would catch it. Declare
the utilized reader version explicitly (the `udon-core-v…` tag family) and
bump it deliberately. Same bootstrap rule as the fixtures-as-UDON plan in
`../../TODO-META.md` (its dogfood item spells out the trap).

## ⚠ Path syntax is provisional

Every `:path` value follows the **provisional** syntax of
`spec/msc/adjudication-2026-07-paths-and-silences.md` (Part A) as of
2026-07-16, and is always a **quoted string** — a bare leading `|` or `@`
in value position would parse as a node/reference value, not text (a
`<path:…>` envelope is the likely home once dialects land). When the
ratified syntax diverges, re-spell the paths; the scenarios' value is what
the journeys *demand*, not how the paths are spelled.

## Scenario vocabulary (draft — the runner's future contract)

| element | meaning |
|---|---|
| `\|feature[slug].day-in-the-life` | one feature file; `:date`, `:tool`, `:path-syntax` |
| `\|scenario[slug]` | one journey; `:at <time>`, `:agent`, `:file`; extra trait `.gap` marks a documented affordance gap |
| `\|given` | pre-state, prose and/or `!:udon:` fragments |
| `\|when` | the acts — op elements below, or prose for meta-journeys |
| `\|then` | expectations — `\|expect …`, `\|expect-error :code …`, `\|expect-fragment` + `!:udon:`, `\|invariant …`, plus prose |
| `\|gap` | (inside `.gap` scenarios) what was wanted; `:packet-ref` names the adjudication item |

Read ops: `|skeleton :path :depth` · `|at :path` (exactly-one-or-error) ·
`|all :path` (explicitly plural) · `|diff :from :to :grain`.
Write ops (atomic inside `|patch :file`): `|require :path :equals`
(precondition / CAS) · `|set :path :value` · `|add-value :path :value`
(stack append) · `|insert :parent :position` (+ `!:udon:` body) ·
`|delete :path` · `|move :path :to`. Append discipline: `|append-block
:file` + `!:udon:` (the decision-log O_APPEND convention).

All of this vocabulary is **draft** — it emerged from writing the journeys
and is itself scenario output, not ratified design. Rename freely; keep
the semantics the scenarios pin down (atomicity, pre-state path
resolution, preconditions, sugar-aware serialization, computed
indentation, atomic-rename writes).

## Verify

```bash
cd core && cargo build --release --example stdin_parse   # once
test/scenarios/bin/verify
```

Run it after any corpus/feature edit and after any parser regeneration —
this directory is also, deliberately, a little in-repo consumer corpus for
differential checks (the same method as `CONSUMERS.md`).

## What the day taught (pointers, not conclusions)

The `.gap` scenarios and several `|then` paragraphs carry the evidence the
adjudication packet asked scenarios to produce — suffix-flag/attr-value
filtering (P9), prose addressing on the write side (P7), proto-path
conventions already living in real files (P0/P9), typed-key equality
earning its keep (P1/P4), reference-follow multiplicity (P2/P6), and the
patch-tool obligations no packet item names yet (sugar-aware
serialization, patch-internal addressing semantics, op postconditions for
resumable plans, atomic-rename write discipline). The session report
routes these; the scenarios remain the primary source.
