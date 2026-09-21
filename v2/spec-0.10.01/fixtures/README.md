# spec-0.10.01 fixtures — a design corpus against the PROPOSAL DRAFT

**Status: authored 2026-09-01 against the unratified draft; no harness runs these.** They exist to *test the spec text*, not a parser: every case was written from the section it cites, and every place the text would not settle an expectation became a `descriptive/` case pointing at the audit (`../working-notes/AUDIT-2026-09-01.md`). Nothing here is law; when the draft's ⟨PROPOSED⟩ rows are ratified or reverted, the `deltas:` field finds every case that flips.

Shape follows the archived second-pass corpus (`../../.archived/second-pass/FIXTURES.md`, DECISIONS C5/C6): one YAML list per file; `id · profile · desc · udon · result · adm · anomalies`, plus:

| Field | Meaning |
|---|---|
| `deltas: N` | the case pins DELTAS row N (⟨P⟩ rows especially) — a ratification pass greps this |
| `gap: X` | descriptive only — the audit item the case probes; the case carries `readings:` (the text-licensed alternatives) instead of one `adm` |
| `open: X` | descriptive only — a CARVEOUTS/OPEN item the case pins nothing against |
| `notes:` | the lean taken where an `adm` needed one, said out loud |
| `root_only: true` | do not run indentation/wrap variations on this case (EOF-truncated or root-level input) |

Profiles: **idiomatic** (happy path, one idea, readable as teaching) · **comprehensive** (edges, twins, every carried nuance the NUANCE-AUDIT lists) · **descriptive** (never gate; `gap:` or `open:` required).

`adm` vocabulary is this draft's: `assignments: [{label, value}]` (or `content:` for a deferred body), `content: [...]`; value spellings `int/float/string/text/bool/nil/list/flow/capture/reference/held_reference/inline_element/inline_generator/node`; nodes `element/generator/annotation/capture/reference/text/blank_line`. `text:` is a string whose line terminators are part of it (the text law); `text_contains:` / `body_contains:` when the exact bytes are not the point. Spellings are targets, not a wire.

```text
fixtures/
├── idiomatic/surface.yaml        19 cases — the surface map, one construct each
├── comprehensive/material.yaml   ~90 — geometry · guards · hold · elements · assignments · scan · text · annotations · values · EOF
├── comprehensive/deferred.yaml   ~40 — references · cardinality · held refs · generators · captures · dispatch
├── descriptive/gaps.yaml         ~40 — one per audit gap, with the readings the text licenses
└── lint_corpus.py                shape check only (ids unique, profiles, result values, gap/open on descriptive)
```

```bash
python3 lint_corpus.py
```

What the corpus deliberately does not do: pin any `gap:` case as law; pin event/wire spellings; invent head grammar beyond the selector subset; test anything a vocabulary owns (construal, evaluation, resolution).
