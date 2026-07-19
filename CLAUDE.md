# CLAUDE.md — Agent Guidelines for the UDON Umbrella Repo

This is **the** UDON repository: specification, reference implementation,
tooling, and history, restructured as an umbrella on 2026-07-09 and tidied
into its current shape on 2026-07-16 (planning documents drained into
per-area TODO lanes and archived). The old standalone repos (v2-io/libudon,
v2-io/udon-ruby) are archived; descent remains independent, pinned here as
a submodule.

## Orientation (read in this order)

1. **README → Status + How the work is organized** (imported below) — the
   current state, the map of co-located TODO lanes, per-area compliance,
   and how work propagates.
2. **spec/CORE.md** — the authoritative language specification
   (0.9.0-alpha.2 in progress; 0.8.0 released and tagged `core-v0.8.0` —
   canonical version in `spec/CORE-VERSION`; changelog + rulings ledger in
   `spec/msc/CHANGELOG.md`).
3. **The TODO lane for your area** (table in the README import below) —
   every lane holds only open items; closed work lives in git and the
   changelog.
4. *History, when you need the deep why:* `_archive/REVIEW-JULY-2026.md`
   (the estate review + evidence) and `_archive/REBOOT-PLAN.md` (the reboot
   plan) — fully drained into the lanes 2026-07-16, kept as the record. The
   dense predecessor ledgers `_archive/DECIDED.bak.md` +
   `_archive/FULL-SPEC-TODO.bak.md` are reference only. None of these is
   the spec; CORE.md is.

## Layout

```
spec/               Ratified layer: CORE.md + companions (DYNAMICS.md,
                    MARKDOWN.md, TIME-SPEC.md — each carries a status
                    banner) + the spec lanes; msc/ holds CHANGELOG.md and
                    the demoted FULL-EBNF.md (illustration only).
                    (Future home of the fused literate source — see
                    TODO-META's literate-fusion item.)
design/             Ahead-of-spec exploration (udon-ast, udon-paths,
                    udon-agentic, schema + guarantees, the Dec-2025 agent
                    brainstorms, positioning, feature matrix) + the .udon
                    example corpus (design/examples/). Partly SUPERSEDED by
                    CORE — status banners mark what; see design/README.md.
core/               Rust workspace (absorbed libudon, full history):
                    udon-core (parser + tree), generator/*.descent.udon,
                    fixtures/ (versioned compliance groups), udon-wasm
                    (highlighting + autocolors engine), regenerate-parser
tools/descent/      SUBMODULE — the parser generator (independent repo),
                    pinned at the SHA used for regeneration; its tracker is
                    TODO-DESCENT.md there
ux/                 Human + agent UX: both lanes (TODO-HUMAN-UX.md,
                    TODO-AGENT-UX.md), obsidian-udon/, autocolors/,
                    tree-sitter-udon/, vim/, udon.tmLanguage.json
test/usability/     Agent eval harness + Dec-2025 results (stale; rebuild
                    tracked in ux/TODO-AGENT-UX.md)
bin/                find-consumers (the CONSUMERS.md re-scan tool)
_archive/           The record: estate review, reboot plan, drained
                    trackers/notes, integrated spikes (spikes/README.md has
                    per-spike status), old spec pieces, dead Ruby scaffolding,
                    cover-2.udon (git-lfs), udon-ruby (submodule,
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
cd core && cargo test --workspace --no-fail-fast
                                           # unit + streaming tests green;
                                           # compliance_gate runs the ACTIVE
                                           # fixture group (fixtures/v0.9/) and
                                           # goes RED as its cases are updated
                                           # ahead of the grammar (live
                                           # per-file burn-down counts)
cargo test -p udon-core --test canonical compliance_gate
                                           # the compliance gate by itself
./regenerate-parser                        # regenerates parser.rs from
                                           # generator/*.descent.udon via tools/descent
```

Compliance RED is the honest, intended signal whenever the spec is ahead of
the parser — burn it down by fixing the grammar to CORE, never by editing
fixture expectations toward parser output. (The parser passes the frozen
v0.8 group — tag `core-v0.8.0`; the 0.9 burn-down happens in `fixtures/v0.9/`.)

- `core/udon-core/src/parser.rs` is **generated — do not hand-edit**. Change
  `core/generator/*.descent.udon` and regenerate. The generator is the pinned
  `tools/descent` submodule (`git submodule update --init tools/descent`).
- The estate review's numbered defect table is history — everything on it
  was fixed or routed into the lanes (archived at
  `_archive/REVIEW-JULY-2026.md` §4 if you need the archaeology). Open
  parser residuals live in `core/TODO-CORE-PARSING.md`, nowhere else.

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

The spec has known open decisions — the lane items marked
`*(discuss w/ Joseph)*` — and if your work touches one, it's blocked on his
ruling, not on you. Say so.

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
wrong or lagging — the behavior is never "settled" by the code.** The descent
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
section or grammar rule before acting on it; memory of an earlier read, a
secondary artifact (`spec/msc/FULL-EBNF.md`, fixtures, archived notes), or a
summary is not the source. This is the single most-reproduced mistake in this
repo's history.

## Conventions

- **File naming**: `<name>.<schema/type>.udon` (e.g. `udon.desc.udon`) —
  designator is application-level semantics for now; migrate as we go.
  See design/file-naming.md.

## Related

- `tools/descent` — the generator (independent repo v2-io/descent; Rust-only
  in practice — the rust/ workspace generates both parser backends; the old
  Ruby gem `descent` 0.7.1 remains published; Ruby-scaffolding sunset is
  tracked in its TODO-DESCENT.md).
- **Live consumers**: see `CONSUMERS.md` — the registry of UDON documents
  outside this repo (ASF process maps, vivarium, autopax), re-scanned per
  spec release with `bin/find-consumers`.
- crates.io: `udon-core`/`udon-cli` verified available 2026-07-09 (reserve
  early — TODO-PUBLISHING); `udon` and `descent` are squatted by unrelated
  2021 crates.

## When Stuck

1. Re-read the spec/CORE.md section for the construct in question
2. Check design/examples/ and core/fixtures/ for usage patterns
3. Check `spec/msc/CHANGELOG.md`'s rulings ledger — your "bug" may be a
   ratified decision (and `_archive/REVIEW-JULY-2026.md` §2 has the old
   genealogy if you're spelunking pre-reboot behavior)
4. **Ask Joseph** — ambiguity is valuable information, not a blocker
