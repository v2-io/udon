# Coverage audit — the "use udon for" demand-phrase angle

**Prompted by:** Joseph's suspicion (2026-07-21) that "there was still some
good stuff that hasn't surfaced yet" — things he remembered being in the estate
that the directory-sweep + earlier memorata passes may not have caught, because
the *demand-phrase* angle ("here's what we'd use UDON for") is a different query
shape than a path sweep.

**Method:** `memorata3-search --json` over the literal phrase plus 12 variant
phrasings (iterated off what returned), union-deduped to unique
`(path, line-span)` hits, then each hit's source classified against the gathered
corpus. "Represented" = its path appears in `TARGET-FILES.md` (any disposition)
**or** its content is present in a `02-provenanced/` copy/excerpt/characterization
**or** it falls in a legitimately-excluded category (session corpora = the
README's *deferred reservoir*; claude-docs API reference = lexical noise; syntax
law / impl detail = "never signal" per the BRIEF). Stale paths were verified on
disk before any miss was declared.

**Queries run** (`-n` 40–100 each): `use udon for` · `udon would be great for` ·
`udon lets us` · `with udon we could` · `udon is perfect for` · `use udon to` ·
`udon for agents` · `why udon` · `udon would be ideal` · `store it as udon` ·
`udon as the format` · `compelling agent tools` · `udon handoff generator`.

---

## Bottom line

**Coverage is strong. One genuine, actionable miss surfaced** —
`~/src/_self/OPERATA.md` (a personal idea-notebook holding an independent UDON
agent-tooling demand brainstorm), plus one minor secondary (descent's
bootstrap-demand). Everything else the demand-phrase angle returned is either
already in the corpus, a stale path pointing at a file that *is* in the corpus,
or a legitimately-excluded category. So Joseph's instinct was right that *some*
demand-shaped material slipped the path-sweep — but it's a small, well-bounded
gap, not a systemic hole.

## Summary counts

| Category | Unique hits | Disposition |
|---|---:|---|
| SESSION `.jsonl` (raw agent sessions) | 203 | **Excluded** — README deferred reservoir ("query it; don't sweep it") |
| UDON-file (representation-checked) | 95 | See breakdown below |
| claude-docs API reference | 53 | **Excluded** — pure lexical `use…for` noise, no UDON relation |
| libudon `_archive/generator/` build logs | 9 | **Excluded** — raw dev-diary/session transcripts (spurious lexical match) |
| sapientia/synaptic/emerson `.md` transcripts | 7 | **Excluded** — session corpora (deferred reservoir) |
| `.sapientia` audit-trails | 3 | **Excluded** — session corpora (deferred) |
| `_ref/books` | 3 | **Excluded** — noise |
| `.gemini/tmp` checkpoint logs | 2 | **Excluded** — noise |
| **TOTAL** | **375** | |

Of the 95 UDON-file hits (63 unique paths):

- **Design-of-record (`design/*`)** — `udon-agentic`, `UDON-AGENT-TOOLS`,
  `UDON-AS-ACP-FORMAT`, `agentic-ux-principles`, `positioning`, `udon-guarantees`,
  `udon-ast`, `udon-paths`, `schema-workbench-2026-07`, `schema-notes-2026-07`,
  `udon-schema-exploration`, `semachrome`, `AGENT-CONTEXT-PROTOCOL`,
  `GRAMMAR-CONSTRAINED-GENERATION` → **REPRESENTED** (copied/excerpted into
  `02-provenanced/copies/{I3-design-of-record,extracts}/`).
- **`docs/*` and root `positioning.md` hits** → **STALE PATHS.** `~/src/udon/docs/`
  no longer exists on disk and `~/src/udon/positioning.md` moved to
  `design/positioning.md`; the memorata index carries a pre-2026-07-16 snapshot.
  Content is the current `design/` files, which **are** copied. (This is exactly
  the archema→rowan rename class the brief flagged — verified by `ls`.)
- **spec / archive / repo-meta** — `spec/CORE.md`, `spec/TIME-SPEC.md`,
  `CLAUDE.md`, `core/README.md`, `ux/README.md`, `tools/descent/CHANGELOG.md`,
  `_archive/{REBOOT-PLAN,parser-strategy,implementation-phase-2,SPEC}.md` →
  **Excluded** — syntax law / implementation detail / project bookkeeping, which
  the BRIEF names as "never signal." (`_archive/{REVIEW-JULY-2026,analysis,feedback}.md`
  are additionally already REPRESENTED.)
- **Historical repo docs** — `_ref/libudon/README.md`, `_ref/udon-ruby/{README,CLAUDE}.md`,
  `tmp/{udon,libudon,udon-ruby}.md` → witness-level / derived summary cards; their
  substantive content ("what is UDON," size/perf claims) is restated in the
  **current** `README.md` (copied). `tmp/udon.md` is in TARGET-FILES.
- **Off-topic** — `vivarium/{VIVARIA-DEFINITIONS, scratch/05-architecture}`,
  `autopax/.archive/…unified_catalog`, `ops/papers/_legacy/06-adjacent-repos.md`
  (a stale registry pointer to `FULL-SPEC.md`) → not UDON-demand; **Excluded**.

---

## MISSING — actionable for a follow-up extraction pass

### 1. `~/src/_self/OPERATA.md`  (PRIMARY MISS — real, unrepresented, gold)

- **Not in** `TARGET-FILES.md` **nor any** `02-provenanced/` **file** (grep-confirmed;
  the "OPERATA" token elsewhere in the corpus refers to the distinct
  `harness/proprium/stalled-lineage/{sapientia,autopax}-OPERATA.md` and the
  `test/scenarios/corpus/operata.*` files — different artifacts).
- **What it is:** Joseph's personal working idea-notebook (git repo `~/src/_self/`,
  file last-committed **2026-04-01**; a mixed brain-dump — brew casks, todos,
  principles, and captured agent-dialogue). The UDON material is a live
  brainstorm captured mid-session (contains "*Let me share these ideas with
  Joseph*," "*Which of these resonate most with your vision?*"), i.e. this looks
  like an **original seeding conversation** that predates/parallels the cleaned-up
  `design/UDON-AGENT-TOOLS.md` — restatement-in-different-context, which the BRIEF
  explicitly wants ("shows evolution / independent re-derivation"), **plus**
  net-new content the design doc doesn't carry.
- **The UDON demand content, by span:**
  - **~1262–1288** — "Given UDON's properties (mixed prose+structure · tiers of
    voice · streaming-friendly · AI-agent readable/writable) → **15 compelling
    generic agent tools**": Parser/Emitter, Validator, Formatter, Query Language,
    Semantic Diff, JSON/YAML round-trip, Template Processor, Schema Inference,
    Semantic Merge, Streaming Parser, "Explain" (doc→prose), "Structurize"
    (prose→structure), Context Window extractor, DSL Compiler, Annotation Tool.
  - **~1290–1313** — a second, **agent-oriented** cut of 13 tools (Streaming
    Parser, Query Language w/ concrete syntax `//|endpoint[@method='POST']`,
    Semantic Diff, **Context Compactor**, **Structurizer**, **Handoff Generator**,
    DSL Validator/Compiler, bidirectional conversions, **Annotator**
    `|{note :by claude …}`, **Trace** — read/write provenance for debugging).
  - **~1316–1420** — **Tier 1/2/3 deep dives** on the highest-value ones, with
    worked sketches: streaming parser with *partial-tree access* (cursor mid-write
    → "we have `|article[foo]` open, `:status` partially written"; interrupt
    handling), **semantic merge** (prose=paragraph-level, structure=element-aware
    conflict, attributes=LWW-with-audit-trail-in-comments), **context handoff
    generator** (fluent `UdonHandoff.new(doc).preserve_structure.summarize_prose(500)…`),
    **"What Changed" narrator** (diff→prose for agent→human), inline annotation
    layer, and a `udon-dsl init "…"` CLI sketch.
  - **~1420–1422** — a **topic-clustering finding**: "UDON's value proposition
    clusters around Human-AI interaction — **16 of 25 unique topics merged into one
    mega-cluster** about agents, cognition, trust, and explanation. The outliers
    (OpenID Connect, JAMstack) are where UDON didn't find as natural a fit." A
    genuine demand-shape signal about *where* UDON pulls.
  - **~850–860** (adjacent, same file) — a **usability-harness demand**: eval
    design holding LLM model and language independently variable
    ("SAME LLM MODEL — VARIABLE LANGUAGE / SAME LANGUAGE — VARIABLE LLM MODEL")
    plus "lots and lots of telemetry on tool usage — time taken to get the correct
    change implemented." Feeds the AGENT-UX empirical-harness lane.
- **Recommended disposition:** **[COPY]** the UDON spans (~1262–1422, plus the
  ~850–860 harness note) into `02-provenanced/copies/` with an editorial banner
  noting the lineage ("live seeding-brainstorm behind `design/UDON-AGENT-TOOLS.md`;
  kept for the raw enumeration + the topic-clustering finding + the eval-harness
  demand, none fully carried by the cleaned doc"). Cross-tier value is modest
  (single-author, Tier-1 ideology) but the **independent re-derivation of the same
  tool taxonomy months apart** is itself convergence evidence worth flagging.
  Steward call worth surfacing: `~/src/_self/` is a personal notebook — confirm
  it's in-scope to copy from (I'd assume yes; it's Joseph's own design thinking,
  same tier as the `design/` docs).

### 2. `~/src/descent/implementation-spec.md`  (SECONDARY — minor, mostly restated)

- **Not in** the corpus (the copied descent material is `tools/descent/TODO-DESCENT.md`;
  the standalone `~/src/descent/` repo's `implementation-spec.md`, `AGENTS.md`,
  `TODO.md` are not).
- **The demand:** the **bootstrap / self-hosting** thesis — "the `.desc` format is
  valid UDON → descent can eventually use the UDON parser to parse its own grammar
  DSL." A "UDON as its own meta-language" demand witness.
- **Caveat:** this exact point is **restated** in already-represented sources
  (`_ref/libudon/_archive/implementation-phase-3.md` carries it, and the
  self-describing-DSL idea is present in the schema/genre-seeds copies). So this is
  **witness-level at most** — a one-line capture if a pass is already touching
  descent, not worth a dedicated spawn. Flagged for honesty, not urgency.

### Explicitly NOT misses (verified, so a re-check doesn't re-chase them)

- All `~/src/udon/docs/*` and root `positioning.md` hits — **stale paths**, files
  live in `design/` now and are copied.
- libudon `_archive/generator/2025-12-2*.md` — high lexical scores on
  "handoff"/"great for" are **spurious**; the files are raw build-session
  transcripts (tool logs, commits, test-fixing), not demand brainstorms →
  deferred-reservoir/session category.
- sapientia/synaptic/`.sapientia`/emerson transcripts, all `.jsonl` — **deferred
  reservoir** by README design.
- claude-docs / books / gemini-logs — lexical `use…for` noise, no UDON relation.
