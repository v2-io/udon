# spec-0.10.00 — the consolidated UDON spec suite

```udon
|article[intro].featured :author "Joseph Wecker" :draft? true
  Structure and prose, freely interleaved — no closing tags, and prose
  is just prose (Markdown survives; ; only a framed semicolon comments).
  |section :title Typed values
    :when <2026-07-11>          ; envelope: a dialect types it
    :tags [udon notation]       ; frozen bare scalars stay boring
```

**Bare recognition is frozen forever, so adding a dialect can never silently retype an existing document — UDON's dates structurally cannot be Norway'd.** New readers: [TUTORIAL.md](TUTORIAL.md) (twenty minutes, settled core only), then CORE's Appendix A.

**What this is.** The single place to learn what UDON *is* right now: 0.9-era law consolidated from four scattered sources — the live `spec/CORE.md` (0.9.0-alpha.2), the `spec/msc/CHANGELOG.md` rulings ledger, the three greenfield clean-room rewrites (2a/3a/3b, archived at `../.archived/first-pass/`), and the `v2/DECISIONS.md` closes — into one coherent suite, organized per `defining-udon.md`'s pillar discipline. Version **0.10.0-alpha.1 (value-space unification)**: the 0.9.1 consolidation plus the K-series rulings (DECISIONS K1–K16, 2026-08-07/09 — sameline as value-space, `$main`, value terminators, silent stacking, expressive labels, the `\` frame split, accepted late attributes) stated natively. Open questions raised by the rewrite: [working-notes/UNIF-PASS-QUESTIONS.md](working-notes/UNIF-PASS-QUESTIONS.md); the change record since the rewrite is [working-notes/CHANGELOG.md](working-notes/CHANGELOG.md).

**Authority.** This suite is the working base for all v2-route work (steward mark **C7**, `../DECISIONS.md`: the 0.9.1 consolidation is the baseline; the C0–C2 0.10 design line is unchanged and builds on it). **Status refinement (C8, jaw 2026-07-28): semi-frozen and spec-only** — provisionally frozen, remaining open for audit-revealed modifications from the old 0.9/fixtures and for critical parser-grammar-facing nuance that must land to avoid corner-painting; and not *necessarily* intended to be implemented as-is — unknown, pending findings from the territory work. The old route (`spec/CORE.md` + companions) is the published 0.9.0-alpha.2 record — no work continues there, and it will be archived when v2 becomes the main route. Behavior differences between this suite and the old text are exactly the ledgered rows in [DELTAS.md](DELTAS.md) — if you find one not listed there, that's a defect here; say so rather than picking a side. Language-law history stays in `../../spec/msc/CHANGELOG.md` (append-only); new rulings land in `../DECISIONS.md` and get folded into this prose.

**Ruling-ID namespaces.** Three registries share short IDs, and the labels collide (`C2`, `S4`, `D4` each mean two different things across them). This suite therefore always namespaces: bare IDs (`L4`, `R19`, `W4`, `S14`, `PATH-1`) are `../DECISIONS.md` rows; `CHANGELOG …` prefixes the `spec/msc/CHANGELOG.md` batch clauses (`CHANGELOG S6`, `CHANGELOG C2`); `OPEN Sn` is an `../OPEN.md` row; `3b-Dn` is a greenfield decision. If you add a cite, namespace it.

## Reading order

| File | Role |
|---|---|
| [CORE.md](CORE.md) | **Normative.** Surface recognition + core semantics — the contract. *(Fresh readers: its Appendix A one-screen surface map is the on-ramp — read it first.)* |
| [MODEL.md](MODEL.md) | **Normative.** What recognition produces; the text law and its adequacy test. |
| [GLOSSARY.md](GLOSSARY.md) | **Normative.** Every formal term; retired synonyms. |
| [SEMANTICS.md](SEMANTICS.md) | **Normative.** When two documents mean the same; round-trip rules. |
| [CARVEOUTS.md](CARVEOUTS.md) | **Normative as to scope.** Deliberately unspecified items, each with its demand-side reason and closing condition. **Spike agents (paths/dialects/schema/value-typing): start here.** |
| [DELTAS.md](DELTAS.md) | The complete behavior-change ledger vs 0.9.0-alpha.2. |
| [RATIONALE.md](RATIONALE.md) | Non-normative why. |
| [TUTORIAL.md](TUTORIAL.md) | Non-normative provisional baseline tutorial — the settled core in twenty minutes. |
| [working-notes/](working-notes/) | Open questions, adjudication record, and the post-rewrite change log. |
| [PEDAGOGY.md](PEDAGOGY.md) | Teaching-ladder outline + committed mental models (manual deferred — P4). |

Deliberately **absent**: an event/wire encoding (the 0.9 flat wire was deratified; the successor is demand-gated — see CARVEOUTS §W), full dialect specs (the old DYNAMICS/TIME-SPEC companions remain reference for the baseline `!` dialect and `temporal@1` value grammar, pending the dialect architecture work), and a formal grammar document (the Nesting Rule's mechanical spelling is in CORE §2.1).

## For the demand-side work

The v2 effort is demand-first (`../udon-needs/`): end-user needs generate the architecture. This suite is the *supply-side floor* that work pushes against — current law stated once, cleanly, with the negative space marked honestly. When a demand decision closes a carve-out or overturns a rule, the change lands here with a DELTAS row and a DECISIONS cite; when you find this suite quietly answering a question CARVEOUTS says is open, that is a bug in this suite.

*Assembled 2026-07-21 (consolidation, not new design). Sources and comparative notes: `../.archived/INDEX.md`; deliberation record: `../udon-needs/pipeline-discussion.md`.*
