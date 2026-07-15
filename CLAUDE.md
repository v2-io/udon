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
3. **README → How the work is organized** (imported below) — the map of
   co-located TODO lanes, per-area compliance, and how work propagates. Core
   spec-text edits live in `spec/TODO-SPEC-CORE.md`. The
   dense predecessor ledgers are archived at **_archive/DECIDED.bak.md** +
   **_archive/FULL-SPEC-TODO.bak.md** (reference only — e.g. the
   core/host/schema/dialect ownership discussion). Neither is the spec; CORE.md is.
4. **spec/CORE.md** — the authoritative language specification
   (v0.8.0-alpha.1, with known divergences catalogued in the review's §2
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

@README.md

The README's **How the work is organized** section is the canonical front door —
the propagation order, the layer-prerequisite rule, the per-area
compliance/target table, and the versioning ladder — imported above so this file
and the README can't drift. What follows is agent-specific guidance that doesn't
belong in the human README.

## Working in core/ (the Rust workspace)

```bash
cd core && cargo test --workspace          # unit + streaming tests green;
                                           # v0_8_compliance_group stays RED
                                           # until the grammar fully catches
                                           # up to CORE 0.8 (it reports the
                                           # live per-file burn-down count)
cargo test -p udon-core --test canonical v0_8_compliance_group
                                           # the compliance gate by itself
./regenerate-parser                        # regenerates parser.rs from
                                           # generator/*.desc via tools/descent
```

Compliance RED is the honest, intended signal — burn it down by fixing the
grammar to CORE, never by editing fixture expectations toward parser output.

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
