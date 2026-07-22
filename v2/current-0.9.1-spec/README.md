# current-0.9.1-spec — the consolidated UDON spec suite

**What this is.** The single place to learn what UDON *is* right now:
0.9-era law consolidated from four scattered sources — the live
`spec/CORE.md` (0.9.0-alpha.2), the `spec/msc/CHANGELOG.md` rulings ledger,
the three greenfield clean-room rewrites (2a/3a/3b, archived at
`../.archived/first-pass/`), and the `v2/DECISIONS.md` closes — into one
coherent suite, organized per `defining-udon.md`'s pillar discipline.
Version **0.9.1**: essentially 0.9, with the ledgered rulings landed in
prose and the deliberately-open questions carrying their reasons.

**Authority.** This suite is the working base for all v2-route work. The
old route (`spec/CORE.md` + companions) is the published 0.9.0-alpha.2
record — no work continues there, and it will be archived when v2 becomes
the main route. Behavior differences between this suite and the old text
are exactly the ledgered rows in [DELTAS.md](DELTAS.md) — if you find one
not listed there, that's a defect here; say so rather than picking a side.
Language-law history stays in `../../spec/msc/CHANGELOG.md` (append-only);
new rulings land in `../DECISIONS.md` and get folded into this prose.

## Reading order

| File | Role |
|---|---|
| [CORE.md](CORE.md) | **Normative.** Surface recognition + core semantics — the contract. |
| [MODEL.md](MODEL.md) | **Normative.** What recognition produces; the text law and its adequacy test. |
| [GLOSSARY.md](GLOSSARY.md) | **Normative.** Every formal term; retired synonyms. |
| [SEMANTICS.md](SEMANTICS.md) | **Normative.** When two documents mean the same; round-trip rules. |
| [CARVEOUTS.md](CARVEOUTS.md) | **Normative as to scope.** Deliberately unspecified items, each with its demand-side reason and closing condition. **Spike agents (paths/dialects/schema/value-typing): start here.** |
| [DELTAS.md](DELTAS.md) | The complete behavior-change ledger vs 0.9.0-alpha.2. |
| [RATIONALE.md](RATIONALE.md) | Non-normative why. |
| [PEDAGOGY.md](PEDAGOGY.md) | Teaching-ladder outline stub (deliberately thin — P4). |

Deliberately **absent**: an event/wire encoding (the 0.9 flat wire was
deratified; the successor is demand-gated — see CARVEOUTS §W), full dialect
specs (the old DYNAMICS/TIME-SPEC companions remain reference for the
baseline `!` dialect and `temporal@1` value grammar, pending the dialect
architecture work), and a formal grammar document (the Nesting Rule's
mechanical spelling is in CORE §2.1).

## For the demand-side work

The v2 effort is demand-first (`../udon-needs/`): end-user needs generate
the architecture. This suite is the *supply-side floor* that work pushes
against — current law stated once, cleanly, with the negative space marked
honestly. When a demand decision closes a carve-out or overturns a rule,
the change lands here with a DELTAS row and a DECISIONS cite; when you find
this suite quietly answering a question CARVEOUTS says is open, that is a
bug in this suite.

*Assembled 2026-07-21 (consolidation, not new design). Sources and
comparative notes: `../.archived/INDEX.md`; deliberation record:
`../udon-needs/pipeline-discussion.md`.*
