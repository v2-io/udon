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
3. **spec/FULL-SPEC.md** — the authoritative language specification
   (v0.7-draft, with known divergences catalogued in the review's §2
   genealogy table).

## Layout

```
spec/               Ratified layer: FULL-SPEC.md, TIME-SPEC.md, FULL-EBNF.md
                    (future home of the fused literate source — CTQ-E)
design/             Ahead-of-spec layer: udon-ast, udon-paths, udon-agentic,
                    schema + guarantees explorations
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
- Invent syntax rules that aren't in spec/FULL-SPEC.md
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

**spec/FULL-SPEC.md is the authoritative specification**, *modulo* the
per-feature genealogy (review §2): several implementation behaviors are the
later deliberate decision awaiting spec backport (fence rules), and several
spec'd features were never implemented (sameline fences, typed bracket-IDs,
attr ordering). For any NEW divergence you find, add it to the genealogy
table with git-dated evidence rather than picking a side silently. The
`_archive/` Ruby validator is NOT authoritative. The December usability
corpus (`test/usability/`) is evidence, not spec.

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

1. Re-read the spec/FULL-SPEC.md section for the construct in question
2. Check examples/ and core/udon-core/tests/fixtures/ for usage patterns
3. Check the review's genealogy table — your "bug" may be a known divergence
4. **Ask Joseph** — ambiguity is valuable information, not a blocker
