# CLAUDE.md — Agent Guidelines for the UDON Umbrella Repo

This is **the** UDON repository: specification, reference implementation,
tooling, and history, restructured as an umbrella on 2026-07-09
(REBOOT-PLAN.md Phase R). The old standalone repos (v2-io/libudon,
v2-io/udon-ruby) are archived; descent remains independent, pinned here as
a submodule.

## Orientation (read in this order)

1. **REVIEW-JULY-2026.md** — the estate review: what exists, what's verified
   broken, open decisions, evidence. The *why*.
2. **REBOOT-PLAN.md** — the prioritized plan: phases, backlog, spike track.
   The *what, in what order*.
3. **Tracking & Workflow** (below) — the map of co-located TODO lanes and how
   work propagates. Core spec-text edits live in `spec/TODO-SPEC-CORE.md`. The
   dense predecessor ledgers are archived at **_archive/DECIDED.bak.md** +
   **_archive/FULL-SPEC-TODO.bak.md** (reference only — e.g. the
   core/host/schema/dialect ownership discussion). Neither is the spec; CORE.md is.
4. **spec/CORE.md** — the authoritative language specification
   (v0.7-draft, with known divergences catalogued in the review's §2
   genealogy table).

## Layout

```
spec/               Ratified layer: CORE.md, TIME-SPEC.md, FULL-EBNF.md
                    (future home of the fused literate source — CTQ-E)
design/             Ahead-of-spec exploration (udon-ast, udon-paths, udon-
                    agentic, schema + guarantees). Partly SUPERSEDED by CORE,
                    no sync process, rich in future ideas — see design/README.md.
notes/              Working analyses, historical planning, feedback
core/               Rust workspace (absorbed libudon, full history):
                    udon-core (parser + tree + fixtures), generator/*.desc,
                    regenerate-parser
tools/descent/      SUBMODULE — the parser generator (independent gem),
                    pinned at the SHA used for regeneration
tree-sitter-udon/   Editor grammar spike
examples/           .udon corpus (cheatsheet, comprehensive, practices)
test/usability/     Agent eval harness + Dec-2025 results (see review §3)
docs/               Early agent-protocol brainstorms (Dec 2025)
_archive/           Superseded: old spec pieces, udon-ruby (submodule,
                    update=none — init only if you need it)
```

## Tracking & Workflow

Work is layered, and changes propagate **spec → event-parser → AST /
streaming-AST → aux · utils · human-ux · agent-ux → publishing**. Load-bearing
rule: **you cannot work in a lane without its upstream layer in hand** — no
parser work without the whole spec; no utils without a compliant parser.

Compliance is *measured*, not tracked: `spec/CORE.md` is **semver'd**, and each
version has a **compliance-fixture group**; a unified gate proves the parser
against a tagged CORE version (event-level by default; AST-level where a
core-syntax property is easier to assert there). Once that keystone lands
(`TODO-META.md` [P0]), the parser lanes hold only residuals and decompositions.

Each area keeps its own **co-located** TODO list, holding only **open** items:
when an item closes, delete it (its record lives in git) — don't accumulate a
"done" section, and a lane with nothing open should read empty. Nothing needing
Joseph sits in a separate valve — such items carry `*(discuss w/ Joseph)*`
inline, in context.

| Lane | Covers | Location |
|------|--------|----------|
| **TODO-META** | Tracking system; compliance-versioning keystone; dogfood | `TODO-META.md` |
| **TODO-SPEC-CORE** | Open edits to the core spec | `spec/TODO-SPEC-CORE.md` |
| **TODO-SPEC-OTHER** | Companion specs — dialects, markdown, temporal, composite types | `spec/TODO-SPEC-OTHER.md` |
| **TODO-AUX** | Aux syntaxes — schema, paths, patch (lexical/parser, non-dialect) | `spec/TODO-AUX.md` |
| **TODO-CORE-PARSING** | Event parser + descent grammar; cleanup; streaming; pending descent items | `core/TODO-CORE-PARSING.md` |
| **TODO-PARSER** | AST one-shot + streaming-AST parsers + API | `core/TODO-PARSER.md` |
| **TODO-HUMAN-UX** | Obsidian, syntax highlighting, editors | `editors/TODO-HUMAN-UX.md` |
| **TODO-UTILS** | `udon-utl` — accessors, conversion, fmt, guarantees | `TODO-UTILS.md` |
| **TODO-AGENT-UX** | Cheat-sheets, empirical usability harness | `TODO-AGENT-UX.md` |
| **TODO-PUBLISHING** | README, release, crates.io, outward docs | `TODO-PUBLISHING.md` |

**Migration in progress:** the old `core/PLAN.md`, `JOSEPH-TODO.md` (retired),
and the `design/` notes are draining into these lanes — each carries a "pull from
X" task; delete X when empty. `REVIEW-JULY-2026.md` and `REBOOT-PLAN.md` remain
the historical *why* and phase plan.

## Working in core/ (the Rust workspace)

```bash
cd core && cargo test --workspace          # 38+ tests; keep green
cargo test --workspace -- --ignored       # FULL fixture conformance suite
                                           # (making this default-on is H2)
./regenerate-parser                        # regenerates parser.rs from
                                           # generator/*.desc via tools/descent
```

- `core/udon-core/src/parser.rs` is **generated — do not hand-edit**. Change
  `core/generator/*.desc` and regenerate. The generator is the pinned
  `tools/descent` submodule (`git submodule update --init tools/descent`).
- Known defects and their status: review §4 (twelve verified, numbered — cite
  them by number).

## Critical Workflow Instruction (unchanged from day one)

**WHEN YOU ENCOUNTER AMBIGUITY, STOP AND DISCUSS.**

Do NOT:
- Invent syntax rules that aren't in spec/CORE.md
- Assume the "obvious" interpretation is correct
- Silently make design decisions to unblock yourself

DO:
- Ask Joseph for clarification
- Note where the spec is silent or contradictory
- Propose alternatives and discuss trade-offs
- Document decisions made in conversation

The spec has known open decisions (review §7-F, nine of them) — if your work
touches one, it's blocked on the valve, not on you. Say so.

## Ground Truth

**spec/CORE.md is the authoritative specification.** As of 2026-07-13 it
reflects the ratified decisions (identity `key`/`traits`, `<…>` typing, fences,
escapes, `@`-inert, etc.); the companion specs (`DYNAMICS.md`, `MARKDOWN.md`,
`TIME-SPEC.md`) each carry their own status banner. The spec is *ahead of the
parser*; parser catch-up is **measured** by the versioned compliance fixtures
(see Tracking & Workflow) with its residual tracked in
`core/TODO-CORE-PARSING.md`. For a NEW *spec-text* gap, add it to
`spec/TODO-SPEC-CORE.md`; for a NEW *parser* divergence, `core/TODO-CORE-PARSING.md`
— with git-dated evidence rather than picking a side silently.
The `_archive/` Ruby validator is NOT authoritative. The December usability
corpus (`test/usability/`) is evidence, not spec.

**When the parser or descent grammar diverges from CORE, the implementation is
wrong or lagging — the behavior is never "settled" by the code.** The `.desc`
grammar and generated `parser.rs` are *never* authoritative. A divergence has
three possible resolutions, and which applies is a spec-reasoning call
(Joseph's), not inferred from what the code does: (a) the grammar holds
better-developed thinking to **backport** into CORE (rare); (b) the impl is buggy
or built to an older spec and gets **fixed** to CORE (common); or (c) the full
picture prompts CORE to **evolve** to something new, leaving the impl
non-compliant in a fresh way. When you surface a divergence, give the factual
three-way picture — exactly what the grammar does, what the parser does, and what
CORE says (including where CORE says different things in different places) — **not
a verdict**.

**Read the primary source at the point you rely on it.** Re-open the actual CORE
section or `.desc` rule before acting on it; memory of an earlier read, a
secondary artifact (`FULL-EBNF.md`, fixtures, older notes), or a summary is not
the source. This is the single most-reproduced mistake in this repo's history.

## Conventions

- **File naming**: `<name>.<schema/type>.udon` (e.g. `udon.desc.udon`) —
  designator is application-level semantics for now; migrate as we go.
  See design/file-naming.md.

## Related

- `tools/descent` — the generator (independent repo v2-io/descent; gem
  `descent` on rubygems, 0.7.1 published).
- **First consumers**: vivarium and agentic-systems (ASF) — the ASF process
  maps are live UDON documents.
- crates.io: `udon-core`/`udon-cli` verified available 2026-07-09 (reserve
  early — plan R8); `udon` and `descent` are squatted by unrelated 2021
  crates.

## When Stuck

1. Re-read the spec/CORE.md section for the construct in question
2. Check examples/ and core/udon-core/tests/fixtures/ for usage patterns
3. Check the review's genealogy table — your "bug" may be a known divergence
4. **Ask Joseph** — ambiguity is valuable information, not a blocker
