# UDON Reboot Plan — July 2026

**The actionable successor to [REVIEW-JULY-2026.md](REVIEW-JULY-2026.md) §8.**
The review is the *why* and the evidence; this is the *what, in what order*.
Drafted 2026-07-09 by Claude with Joseph. Structural decisions Joseph has not
yet ratified are marked **⚖ DECIDE**; everything else is executable as
written. Correct the carve freely.

---

## 1. Target shape — the umbrella repo

`udon/` becomes the umbrella; the satellite repos move inside. Precedent
already exists in-tree: `tree-sitter-udon/` has lived here as a plain
directory since January.

```
udon/                          # THE repo: spec, core, tools, history
├── README.md                  # umbrella orientation
├── CLAUDE.md                  # umbrella agent guide
├── REVIEW-JULY-2026.md        # the estate review (evidence layer)
├── REBOOT-PLAN.md             # this file (action layer)
├── spec/                      # FULL-SPEC.md, TIME-SPEC.md, FULL-EBNF.md,
│                              #   FULL-SPEC-supplement.md
│                              #   → eventual home of the FUSED literate source
├── design/                    # udon-ast.md, udon-paths.md, udon-agentic.md,
│                              #   udon-schema-exploration.md, udon-guarantees.md
├── notes/                     # analysis.md, feedback.md, positioning.md,
│                              #   markup-feature-matrix.md, parser-strategy.md,
│                              #   implementation-*.md, integration-*.md, NEXT.md
├── core/                      # ⚖ libudon: ABSORBED subtree (recommended)
│   ├── Cargo.toml             #   or submodule (fallback — see §2)
│   ├── udon-core/             #   parser + tree + fixtures
│   └── generator/             #   udon.desc, values.desc, regenerate-parser
├── tools/
│   └── descent/               # SUBMODULE → v2-io/descent (pinned generator SHA)
├── tree-sitter-udon/          # stays (already in-tree)
├── examples/                  # stays
├── test/usability/            # stays (the eval harness)
└── _archive/
    ├── (existing archived spec pieces)
    ├── udon-ruby/             # SUBMODULE → v2-io/udon-ruby (frozen, not
    │                          #   auto-initialized on clone — a feature)
    └── udon-2011/             # optional: submodule/copy of the _ref ancestor
```

Why this serves the review's CTQs directly: the **fused-ground-truth** item
(CTQ-E) wants spec, grammar, and fixtures on **one clock** — the §2 genealogy
showed exactly what two clocks cost (spec froze 18:02, impl walked until
Jan 13, nobody noticed for six months). An umbrella with the core absorbed
makes spec+grammar+fixture changes **atomic in a single commit**.

## 2. The one structural pushback — ⚖ DECIDE: absorb libudon, don't submodule it

Joseph's sketch had all satellites as submodules. Recommendation: **descent
and udon-ruby yes; libudon no — absorb it as a subtree merge (history
preserved).** The asymmetry is principled:

| | descent | udon-ruby | libudon |
|---|---|---|---|
| Independent life? | Yes — its own gem (0.7.1 published), future Rust tool | No — frozen | No — it *is* UDON's core; no other consumer wants it apart from UDON |
| Change cadence vs spec | Rare, versioned releases | Never | **Constantly co-changes with spec/fixtures** — the fusion partner |
| Submodule pin semantics | A *feature*: pins the exact generator SHA used for regeneration (reproducibility) | A feature: archive frozen at a SHA | A *hazard*: every spec↔grammar↔fixture co-change needs a pointer bump; a stale pin is the genealogy failure mode reborn in git form |
| Verdict | **Submodule** at `tools/descent` | **Submodule** at `_archive/udon-ruby` | **Absorb** at `core/` via `git subtree add` (full history retained) |

Two practical notes that make absorption safe: (a) **consumability is
unaffected** — vivarium can use `udon-core = { git = "https://github.com/v2-io/udon" }`
(cargo locates workspace members automatically) or a path dep; publishing
`udon-core` to crates.io from a subdirectory is standard practice. (b) The
**breakage surface is tiny** [verified]: only udon-ruby's path dep (frozen —
gets a README note, not a fix) and `regenerate-parser`'s `DESCENT_DIR`
default (one-line change to prefer `../tools/descent`, env-var override
kept). vivarium has no Cargo references yet — restructuring now is the
cheapest it will ever be.

Fallback if Joseph prefers submodule-everything: it works, but adopt two
disciplines from day one: a `just sync` / bump script that updates and
commits the pointer, and CI that fails when the umbrella's pin is behind the
submodule's main. (Agents forget `git submodule update`; make the harness
remember.)

### Rust-ecosystem norms (the deciding question — verified 2026-07-09)

Crates published from subdirectories of broader-scoped repos is **thoroughly
typical — arguably the dominant pattern** for single-reference-implementation
projects. Verified via crates.io `repository` metadata:

| Published crate | Registered repository |
|---|---|
| `grep-searcher` | `BurntSushi/ripgrep/tree/master/crates/searcher` — a crate whose registered home *is a subdirectory* of an application repo |
| `cranelift-codegen` | `bytecodealliance/wasmtime` — a whole compiler backend inside a broader project |
| `tokio-util` | `tokio-rs/tokio` — workspace siblings |
| `tree-sitter` | `tree-sitter/tree-sitter` — the closest udon analogy: multi-language umbrella (C lib + CLI + docs + bindings) publishing its Rust crate from a subdir |
| `naga` | `gfx-rs/wgpu` — **was its own repo, absorbed into wgpu with history**: the exact operation R4 proposes, performed by a flagship project |

Publishing mechanics from a workspace subdir are what the standard release
tooling is built for: `cargo publish -p udon-core` from a tag-triggered
GitHub workflow; **release-plz** (workspace-aware release PRs + auto-publish
of changed crates) or **cargo-release** if we want automation; the monorepo
tag convention is `udon-core-v0.10.0` (per-crate tags, tokio-style). Crates
version independently within the workspace; `cargo package` includes only
the crate directory, so per-crate `readme`/`license` use workspace
inheritance (standard).

Honest caveats: (a) git-dependency consumers clone the whole umbrella —
udon carries an 8.5 MB example file (`cover-2.udon`) and ~2 MB of eval
results, worth pruning/LFS-ing at R6 for pre-crates.io git-dep ergonomics
(irrelevant once published); (b) one shared issue tracker for
language-vs-crate concerns — fine at this scale; (c) the countervailing
norm — spec repos kept separate from implementations (CommonMark, TOML) —
applies to mature **multi-implementation standards**, which UDON may become
someday but is not in this phase. The single-reference-impl phase is
exactly when tree-sitter/ripgrep-style consolidation is normal.

## 3. Naming & registry facts (checked 2026-07-09)

- **crates.io `udon` is squatted by a stranger** — a dormant 2021 audio
  library (0.0.1-alpha). `descent` likewise (2021 optimization lib). Neither
  is ours to have.
- **Available now: `udon-core`, `udon-cli`, `udon-utils`.** Reserve early
  (the rubygems `udon`-squatted-by-past-self story, but with strangers).
- The installed **binary can still be `udon`**: a `udon-cli` crate with
  `[[bin]] name = "udon"` gives `cargo install udon-cli` → `udon fmt`,
  `udon lint`, `udon skeleton`, `udon parse`, `udon convert`. One tool, many
  subcommands — the umbrella pattern at the CLI layer too.
- The descent **Rust rewrite needs a non-`descent` crate name** when its day
  comes (⚖ candidates: `descent-parser`, `udon-descent`; no urgency).

## 4. The plan, prioritized

Phases R and 0 are mechanical (agent-runnable, Joseph reviews). Phase 1 is
the valve. Phases 2–3 are the payload. Spikes (review §9) weave in as a
parallel track — S1/S2/S3 can start **today**, independent of everything.

### Phase R — Restructure (the umbrella move) — *do first, ~1 day*

Everything else references paths; move the ground before building on it.

| # | Step | Notes |
|---|---|---|
| R1 | Tag pre-migration baselines in all four repos (`pre-umbrella-2026-07`) | First tags in the ecosystem's history; cheap insurance |
| R2 | ⚖ Ratify absorb-vs-submodule for libudon (§2) | Blocks R4 |
| R3 | Add `tools/descent` submodule (pin = current main `07d09fc`); update `regenerate-parser` default path | Gem-install fallback kept for submodule-less checkouts |
| R4 | Absorb libudon: `git subtree add --prefix=core <libudon> main` (or submodule per R2) | History preserved; then archive v2-io/libudon on GitHub with a pointer README |
| R5 | Add `_archive/udon-ruby` submodule; mark v2-io/udon-ruby **archived** on GitHub; note the broken path-dep in its README | Not initialized by default on clone — correct for an archive |
| R6 | Root-doc sort into `spec/` `design/` `notes/` (21 root .md files today); sweep links (`grep -rn '\](\w'`), update CLAUDE.md/README | One disruption, not two; `git log --follow` keeps history legible |
| R7 | Umbrella README + CLAUDE.md rewrite: orientation, layout map, "start at REVIEW → PLAN" | The 100%-turnover on-ramp |
| R8 | Reserve `udon-core`, `udon-cli` on crates.io (placeholder 0.0.1 or just squat-publish `udon-core` honestly) | ⚖ Joseph holds the crates.io account |

### Phase 0′ — Remaining hygiene — *~2 days, parallel-safe after R*

| # | Step | From |
|---|---|---|
| H1 | **Regeneration validation** (spike S7): regenerate parser with pinned descent, diff event streams over examples+fixtures, confirm only the intended `/error`-semantics delta | Review §7-E |
| H2 | Fixture suite **default-on** (drop `#[ignore]`; keep a `--fast` filter if wanted) | Defect-adjacent hygiene |
| H3 | Kill codegen warnings; fix the broken StreamingParser doctest (or delete with D3 below) | Defect #7 |
| H4 | **CI with a drift gate**: build + full fixtures + *regenerate-and-`git diff --exit-code`* on parser.rs | ⊕ makes CTQ-B's spec-impl sync discipline *mechanical* — the genealogy failure mode gets a tripwire |
| H5 | Tag `v0.8.0-reboot` on the umbrella once green — one version clock from here on | Supports the fused clock |

### Phase 1 — The valve (decisions) — *Joseph-gated; briefs are agent work*

Priority order within the nine (review §7-F), by what they unblock:

1. **Identity syntax** (decision 1) — blocks defect #2 fix, paths impl, ASF exposure. → Spike S2a brief.
2. **Fence semantics** (decision 8) — blocks defects #10/#11 and spec backport. → S2c brief. *Lean already on record: adopt impl's any-indent close + info strings; drop sameline fences unless a use-case appears.*
3. **Value-dialects/temporal** (decision 2) — blocks temporal-validation work shape. → S2b brief.
4. **Sigil guards** (decision 9) — blocks defects #9/#12 fix shape; S3's corpus data feeds it.
5. **StreamingParser fate** (decision 3) — S5 feasibility spike feeds it; deletion is the interim default (D3 below).
6–9. Escapes, markdown subset, reference augmentation, BlankLine — batch into one decision session once briefs exist.

### Phase 2 — The utilities payload (vivarium/ASF) — *the main build, ~2–3 wks*

Ordered by dependency, not just priority:

| # | Item | Depends on | Defects closed |
|---|---|---|---|
| U1 | Defect sweep A (no decisions needed): `all_text` separators, `Raw.lang` wiring, dead code out (`span.rs` or wire it), char-correct columns, tree.rs paper cuts | H1 | #4,#5,#6 |
| U2 | **Node spans + error reporting** (multi-error, source snippets) | U1 | #4-partial |
| U3 | **Value coercion API** (`as_i64`, `as_date`, …) | — | — |
| U4 | Defect sweep B (post-decision): typed IDs, attr-ordering enforcement, colon-eating, temporal validation layer, fence fixes per decision 8 | Phase 1 items 1,2,4 | #2,#3,#9–#12 |
| U5 | **Serializer / round-trip** (spike S4 first — its no-go case writes the SourceInfo requirements) | U2 | — |
| U6 | **Paths implementation** (`at`/`all` MVP first = spike S8, against the live ASF process map) | U2 | — |
| U7 | **Skeleton view** | U6 | — |
| U8 | **`udon-cli`**: `parse`/`events`/`skeleton` first, then `lint` (incl. reflow-damage heuristics), then `fmt` | U5–U7 | — |
| U9 | **Conversions** (json/yaml/md, bidirectional, on the real tree) | U5 | — |
| D3 | Delete `StreamingParser` + its doctest (unless S5 lands explicit-stack quickly) | decision 5 | #1 |

### Phase 3 — The agentic layer

`propose`/`apply` on round-trip+spans+paths (U5,U2,U6); schema tooling
(design/ explorations → real validation woven into lint/convert); onboarding
refresh + **re-measurement** (spike S1 — current models, Codex/Gemini/
open-weights matrix); literate-fusion pilot on fences (spike S6) →
full fused-source migration into `spec/`.

### Spike track (parallel; review §9 numbering)

| Spike | Can start | Feeds |
|---|---|---|
| S1 onboarding re-measurement | today | Phase 3, adoption thesis |
| S2a/b/c decision briefs | today | Phase 1 items 1–3 |
| S3 prose-collision corpus | today | Phase 1 item 4 |
| S4 serializer hardest-part | after R | U5 |
| S5 explicit-stack feasibility | today (descent repo) | Phase 1 item 5 |
| S6 literate-fusion pilot | after R (wants `spec/`) | Phase 3 / CTQ-E |
| S7 regeneration validation | after R3 | H1 (same thing) |
| S8 paths MVP | after U2-ish | U6 (same thing) |

## 5. Risks & mitigations

- **Submodule staleness** (the new two-clock risk): CI pin-behind check
  (H4's sibling); `_archive/` submodules deliberately not auto-initialized;
  document `--recurse-submodules` in README for the one that matters
  (tools/descent).
- **Link breakage from the doc-sort** (R6): mechanical grep sweep +
  the review/plan cross-reference check; accept that external links to old
  GitHub paths 301 into the repo root (add a "moved" table to README).
- **History legibility after subtree absorb**: `git log --follow` works
  per-file; the pre-umbrella tags (R1) preserve clean per-repo history
  boundaries; v2-io/libudon stays archived-readable forever.
- **Path-dep fallout**: only udon-ruby [verified] — frozen, gets a note.
- **Scope creep in Phase R**: the doc-sort (R6) is the only discretionary
  piece; if it drags, ship R with docs unsorted — structure first, taxonomy
  second.

## 6. Decisions Joseph holds (rollup)

⚖ **R2** absorb-vs-submodule for libudon (recommendation: absorb) ·
⚖ **R8** crates.io reservation timing/names · ⚖ Phase-1 items 1–9 (the
valve, briefs incoming from S2) · ⚖ descent-Rust crate name (no urgency) ·
⚖ whether this plan file itself migrates to `.udon` once lint/highlighting
exist (dogfood when the tooling can catch our own reflow damage).
