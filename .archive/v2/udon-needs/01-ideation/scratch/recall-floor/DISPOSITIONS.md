# Recall-floor disposition — every needs-disposition path judged

**Done 2026-07-21 (opus recall-floor disposition pass).** This dispositions **every** path in `UNION-needs-disposition.txt` against the vision/witness question (`BRIEF §vision`). Per-path verdict + reason is the exhaustive record in **`DISPOSITIONS-full.tsv`** (`path \t verdict \t reason`, one row per path); this file is the human summary, the rule set, the crown-jewel find, and the checkable numbers.

## The two checkable numbers (they reconcile)

| Check | Count |
|---|---|
| paths in `UNION-needs-disposition.txt` | **16,329** |
| paths in `DISPOSITIONS-full.tsv` (excl. header) | **16,329** |
| **hits-in-union vs. hits-dispositioned** | **16,329 = 16,329 ✓** |

| Verdict | Count |
|---|---|
| **already-represented** | 13,721 |
| **dismissed** (content reason) | 2,584 |
| **witnessed** (landed as new witness lines) | 24 |
| **landed as new artifacts this pass** | 2 files (see below) |

Reproduce: `python3 disposition.py` (in this dir; reads `UNION-needs-disposition.txt`, writes `DISPOSITIONS-full.tsv`). `awk -F'\t' 'NR>1{print $2}' DISPOSITIONS-full.tsv | sort | uniq -c` gives the verdict split; column 3 gives the reason and, for already-represented, the covering artifact.

## Method — and its honest limit

16,329 files is far past per-file opening in one context. The disposition is **territory-based with sampled verification**: every path is assigned a content-based verdict by a rule keyed on its territory + file-type, where each rule was justified by opening representative files in that territory (samples logged below). This is the coverage model the compilation already runs on (≈30 mining maps + territory sweeps + characterizations), applied to the residual to answer the recall-floor's one question: *did a relevant file match no query and thereby escape every sweep?* The answer for the residual is **one material territory did — `~/src/archema-io/harness/`** (below); the rest resolves to already-swept territory or content-dismissible noise.

**Every dismissal is by CONTENT, never location** (README transcript-corpus rule). E.g. transcript `.jsonl` are `already-represented` as searchable substrate, not excluded; external ML clones are dismissed for *what their matched strings are* (incidental code tokens), not for being external.

**Limit stated plainly:** `already-represented` here is **territory-level** — it means the file's territory was swept/characterized by the named artifact, not that this exact file was individually read. For the big swept territories (ASF theory, sapientia/zoetica core, the 12 characterized CLI repos, `_ref` archaeology, vaults) that is the same coverage claim the compilation makes everywhere. A phase-2 deep pass that wants file-granular certainty on any one territory can intersect `DISPOSITIONS-full.tsv` on that path prefix.

## THE FIND — `~/src/archema-io/harness/` was un-swept (crown jewel)

The single material recall-floor catch. The harness workshop repo — **the very repo this compilation is being assembled FOR** (BRIEF §purpose 2) — was never mined by any map, because it is the *destination*, and it holds some of the densest agentic-tooling demand evidence in the estate:

- **`msc/system/dossier/`** — a *parallel compilation to ours*: an adversarially-verified taxonomy of agent corrected-behaviors (`summary-not-sufficient`, `plausibility-asserted-as-verification`, `sycophancy-affirm-and-flip`, `depth-over-haste`, …). `summary-not-sufficient` independently re-derives the compilation's own `read-primary-source` discipline in the same words → a **Tier-1↔harness cross-tier convergence**.
- **`ai-cli-tools-source-assessment.md`** — Joseph's *primary* from-the-code census of 10 shipping CLIs (indexing mechanism, agent-brain locality, fork lineage) — a read-the-code companion to and corrector of the deep-research external-landscape.
- **`proprium/`** — the harness-consumer's own demand grounded in ASF: the compaction-as-task-sheet lived failure (`INTERPRES-COMPACTION-NOTE`), inviolate CHRONICA history, the ASF agentic-loop spine, Joseph's steward judgments.

**Landed** → `02-provenanced/characterizations/recall-floor-archema-harness.md` (territory characterization, source_commit `archema-io/harness @ 01c4d30`), with a standing recommendation to deep-COPY the dossier + census if the harness thesis is written. **Raised** → STEWARD-CALLS #15: is the destination repo in-scope as a *source*? (Lean yes — folding its wisdom in is what makes the compilation the *consolidated* statement; but the scope call is Joseph's.) The harness `.claude/` session state and images are dispositioned as searchable-substrate / non-prose.

## Landed this pass (2 new artifacts + 24 witness lines)

| Output | Kind | Covers |
|---|---|---|
| `02-provenanced/characterizations/recall-floor-archema-harness.md` | characterization | the whole `harness/` workshop territory (67 residual paths → this file) |
| `02-provenanced/commentary/recall-floor-witnesses.md` | commentary/witness | 24 witness-scale files (below) |

**The 24 witnessed paths** (existence/shape is the evidence; 2 flagged copy-candidates): `src-ext/subagent-example-script/*` (external agent-command-as-document + orchestrator/worker convergence); `src-ext/llama.cpp/docs/function-calling.md` (external tool-call-format catalog); `src/v2.io/_archive/OODA*` (Boyd OODA → ASF Orient-cascade ancestry — **copy-cand**); `src/relata/{README,TODO-ingest}.md` (epistemic-state-primary, multi-agent-safe tool charter — **copy-cand**); `src/_exp/loom/refs/{elixir-living-code-guide, OBSIDIAN-ADVANCED-RESEARCH}.md` + `loom/AGENTS.md` (living-code instance); `src/llm-training-strategy-temporal-feedback{,-cmp}.md` (TFT-native control-loop demand); `src/causal-language/data/EXTERNAL-AGENT-DATA-GENERATION-BRIEF.md` (peer-voice agent-brief instance); `src/umi/{CLAUDE.md,_archive/survey-…}.md` (actor-based ELI-infra research).

## already-represented — where the 13,721 route (top rules)

Each row: count · covering artifact/reason. Full per-path in the TSV.

| n | already-represented via | verifying sample opened |
|---|---|---|
| 1,911 | `harness-invivo/claude-docs.md` — Anthropic public-docs snapshots (`_ref/claude-docs*.bak*`, verbatim-redundant copies) | dir listing; confirmed dup snapshots |
| 1,562 | `syntheses/asf-dossier.md` + reading-log — ASF/AAT theory program (`archema-io/asf` audits/spikes/mono/*-core) | asf subdir clustering |
| 1,211 | searchable-substrate/transcript — `asf/.claude` session/worktree state | `asf/.claude/*` sample |
| 1,167 | `II1-sapientia`/`II2-zoetica-ennaos` + `tst-tooling-roi-residue` — ELI-infra core (SC#8 deep passes) | `_core` subdir clustering |
| ~4,600 | `harness-invivo/{qwen-code,kilocode,kimi-code,grok-build,codex,warp,opencode,gemini-cli,agentic-elixir,mistral-vibe,claude-code,claude-code-snapshot,minimax-cli,aider}.md` — the characterized CLI/harness repos | `ai-cli-tools-source-assessment.md` census cross-check |
| 1,122 | `II7-ref-arch-witness` + `II7-ref-arch` copies — `_ref` archaeology (predecessor homes, backups) | `_ref/_arch`, `axiomata`, `second-other-client` samples |
| 641 | searchable-substrate — raw `.jsonl` session corpus (spans triaged via memorata3 transcript-triage + concurrent agent; whole-file telemetry is README-deferred) | LEDGER transcript-triage rows |
| rest | II4-autopax-practica, III-vaults-*, III-schema-rowan, I3-design-of-record (UDON `design/`), III-eli-testimony, corpus-own `.archived/` maps, memorata/relata tool-infra, vivarium consumer, firmatum/shoshin PROPRIUM | per-territory samples above |

## dismissed — where the 2,584 route (all by content)

| n | dismissed — content reason |
|---|---|
| 907 | non-prose binary/generated artifact (image, Ruby `.rbi/.rbs` type sig, test `.snap`, LaTeX `.aux/.toc/.bbl`, build `.log/.lock`, PDF, xhtml-ebook) |
| 336 | inside build/vendor/cache dir — compiled or third-party dependency artifact |
| 247 | official Anthropic SDK client source (python/ruby) — library plumbing |
| 195 | external Ruby gem clones (alba/avo/…) — incidental gem-domain tokens |
| 143 | third-party ML/inference/typesetting codebase (TTS/diffusion/llama.cpp/LaTeX) — incidental code tokens |
| 135 | academic-philosophy papers (Synthese/Inquiry) — off-target |
| 126 | external Rails app clones (migration-survey) — incidental tokens |
| 102 | publication-programme ops (funding/venue/outreach/ethics) — off-target |
| 41 | UDON repo spec/parser/impl/tests — syntax law, "never signal" per brief |
| 36 | ELI AXIOMATA identity/values (PROPRIUM-relational) — not tooling demand |
| 34 | bundled copy of global `~/.claude` memory-curation substrate — methodology, not tooling demand |
| 27 | venv/console-script shim — no prose |
| rest (~255) | NeurIPS/TACL papers, causal-language/behavioral-floor research adjuncts, umi OCR ebooks, neworld Flash docs, book-reader OCR scratch, v2.io site archive, misc backup/scratch, delegation-methodology instruction files |

## Where I stopped (honest frontier)

**No path was left undispositioned** — the set is closed (16,329 = 16,329). What I did *not* do, and a phase-2 pass should, if it wants it:

1. **Deep-copy the harness dossier + CLI census** — I characterized the territory and flagged the copy-candidates; I did not bring the L1 entries in verbatim (pending STEWARD-CALLS #15 in-scope ruling). This is the highest-value follow-up.
2. **File-granular reads inside already-represented territories** — I verified at territory + sample level, not file-by-file, for the big swept trees (ASF theory, `_ref` archaeology, the 12 CLI repos, `_core`). The TSV lets any territory be re-opened by prefix. The two OODA and relata files I marked copy-candidates but left at witness scale.
3. **Concurrent transcript-triage agent** — the 641 `.jsonl` (+ `asf/.claude` session state) are dispositioned here as searchable-substrate to avoid double-work; span-level transcript judgment is that agent's lane (no output file was present in `scratch/` at my run time — coordinate before treating any `.jsonl` as fully closed at span granularity).
