---
source: agentic-tooling-sources sweep — area ~/src/_ref/_arch/** (Joseph's archived predecessor projects, as a neighborhood)
gathered: 2026-07-21
status: vetted mining-spot map
---

# ~/src/_ref/_arch/** — archived predecessor projects

**Where the center of mass actually is.** The named early-look targets (sar2 =
notation, sar3 = LSP/AST chunking) turned out to be exactly right, and they are
the two strongest deposits in the whole neighborhood *for this sweep* — not
because of their filenames but because each contains **empirical evidence about
agent-facing document/notation design**, which is rare. Everything else in
`_arch/` is either (a) ELI-runtime/CLI-ergonomics work with tangential agent
ideology, or (b) unrelated infrastructure. I walked the whole directory; the
honest result is "two rich veins, a few medium ones, and a lot of dry rock."

Note on the brief's named siblings: **principia, cddf, crew-first are NOT under
`_arch/`** (they live elsewhere in `~/src/_ref/`, per the global project map —
`_ref` holds `principia`, `cddf`, `crew-first` at its own top level, outside my
area). Logged as out-of-area, not dry wells.

---

## HIGH priority

### sar2 — "does syntax/alignment change how well an AGENT comprehends code?" (empirical)
This is the single most on-target deposit: a **notation designed for agent
readability, then actually measured against agents**. UDON's core claim ("clear
even without syntax highlighting, for humans and AI alike," alignment as a
readability lever) has a direct predecessor experiment here.

- `sar2/sar-syntax-design.md` — full design of SAR (an Elixir-surface notation).
  The "Alignment Philosophy" section is the load-bearing part: it argues
  vertical token alignment (via consistent structural anchors `:` and `->`,
  dimmable atom quotes, kebab-case) reduces reader cognitive load, with worked
  before/after alignment blocks. Directly parallels UDON's alignment/autocolor
  ambitions. Date: ~Nov 2025 (dir mtime). **HIGH.**
- `sar2/experiment/README-GAME-ENGINE.md` — the experiment design: give models
  an 857-line game engine in three variants (Elixir, SAR, aligned-SAR, the
  aligned version 49% shorter), ask 20 comprehension questions incl. 2 planted
  bugs, measure re-read behavior / turn count / accuracy / speed. States a prior
  genserver result: "Aligned SAR: 100% immediate comprehension (no tool
  re-reads) vs Elixir/SAR 60%; ~14% faster." That's a concrete, citable
  agent-comprehension claim. Date: Nov 2025. **HIGH.**
- `sar2/experiment/haiku-run-2025-11-16-n10/prompt_sar.txt` (head ~30 lines) —
  the actual prompt handed to the model: a 14-point "SAR vs Elixir" cheat-sheet
  teaching the notation inline, then the code + questions. Concrete artifact of
  *how you teach an agent a new notation in-context* — relevant to UDON's
  agent-onboarding/cheat-sheet lane. Date: 2026-11-16. **HIGH.**
- `sar2/experiment/results/*/confidence_intervals.csv` (also under each
  `*-run-2025-11-14-n10/` dir: claude, codex, deepseek, ollama; plus
  haiku-run-2025-11-16) — the **actual measured data**: median response latency
  (µs) with MAD, bootstrap CIs, trimmed means, n=10, per variant
  {elixir, sar, sar_aligned}, per model. Honest surprise worth flagging to
  Joseph: in the claude n10 run, `sar_aligned` median (246,645) was *higher*
  than plain `elixir` (215,530) — i.e. this run does **not** reproduce the
  readme's "faster when aligned" hypothesis on latency. Real, un-cherry-picked
  evidence for/against the alignment thesis. Dates: 2026-11-14 / 2026-11-16.
  **HIGH** (this is the kind of data the demand-side phase wants).
- `sar2/experiment/analyze.rb`, `analyze_turns.rb`, `compare_answers.rb`,
  `plot_confidence_intervals.py` — the harness that scored the above (hyperfine
  timing + turn counting + answer comparison). Reusable methodology for a UDON
  agent-comprehension eval. **MEDIUM-HIGH** (method, not finding).

### sar3 — structure-based semantic chunking for RAG/embeddings (with an honest reckoning)
Directly maps to UDON's README claim that documents **self-chunk for
RAG/embeddings** ("the author's intent about semantic boundaries is encoded in
the structure itself"). sar3 is the predecessor *test* of "parsing-based chunking
beats naive splitting."

- `sar3/AST_VS_LSP_REALITY.md` — the best single file here. An honest post-mortem:
  "What I claimed: LSP-based chunking. What we built: AST-based semantic boundary
  detection." Lays out exactly what structure-aware chunking buys (semantic
  boundaries = no mid-function splits, accurate ranges, hierarchy) vs what needs
  a semantic layer (callers/callees/types), and concludes structure-based
  chunking is "80% of the value for 20% of the effort" and "parsing-based
  chunking beats naive splitting, which was the core hypothesis." That
  conclusion is *the* evidence UDON's self-chunking pitch rests on, stated by
  someone who tried it. Date: ~Nov 2025. **HIGH.**
- `sar3/lsp_chunking_concept.md` — the aspirational design: why cross-file /
  type / call-graph / doc context enrich a chunk's embedding, with concrete
  before/after chunk examples and a claimed "20-40% better retrieval accuracy."
  Relevant to UDON's "attributes = property assertions, elements = discrete
  semantic units" embedding-granularity table. Date: ~Nov 2025. **MEDIUM-HIGH.**
- `sar3/LSP_ENRICHMENT_RESULTS.md` + `sar3/COMPLETION_SUMMARY.md` — the measured
  output: 10 categories of semantic metadata extracted over 85 methods with
  coverage percentages (visibility 100%, callers 93%, callees 98%, complexity
  100%, etc.), producing `lsp_chunks.json` (86 chunks) ready for RAG. Evidence
  of *what a self-describing chunk's metadata payload actually looks like*.
  Date: ~Nov 2025. **MEDIUM.**
- Also present: `AST_VS_ACTUAL_LSP.md`, `ACTUAL_LSP_POC.md`,
  `LSP_CHUNKING_POC.md`, `SIDE_BY_SIDE_EXAMPLE.md`, `QUICK_REFERENCE.md` — same
  investigation, more angles; skim if the three above leave a gap. The `README.md`
  is just SFR-Embedding-Code-2B model setup (the embedding model used). **LOW-MED.**

---

## MEDIUM priority

### Top-level `_arch/*.md` — ELI-runtime feature syntheses (machine-first knowledge ideas)
These are Oct-2025 plans to unify predecessor agent tools into one runtime.
Relevant to *this* sweep only for their agent-consumption-of-documents ideas,
which are real but scattered.

- `codex-synthesis-plan.md` (Codex/GPT-5, 2025-10-07) — §on Zoetica RAG describes
  a **"machine-first 'query-for-files'"** RAG API (embeddings return file paths,
  not text) and a **"machine-first knowledge format strategy (praxis-protocol)"**
  — i.e. designing documents for agent consumption first. That framing is the
  demand-side thesis UDON serves. Also a capability matrix of 8 predecessor agent
  CLIs (Codex, Gemini CLI, SimpleAgent, minimal-sapientia) — useful map of what
  agent tools existed. **MEDIUM.**
- `UNIFIED-FEATURE-SPEC.md` (2025-10-07) — consolidates 8+ predecessor agent
  runtimes into one feature spec; the value here is the enumerated feature
  taxonomy of agent tooling (context resolution, `[[reference]]` resolution,
  tracking snapshots, tool registries). Adjacent, not central. **MEDIUM-LOW.**
- `IMPLEMENTATION-PLAN.md`, `codex-system-prompt.md` (Nov 2025, 20KB — a full
  agent system prompt) — agent-behavior/runtime, not notation. `codex-system-prompt.md`
  could be a reference for "how agents are instructed" if that lane needs it. **LOW.**

### geminex — Elixir agent-CLI project with agent-facing guides
- `geminex/AGENTS.md` (v0.3) — a real agent-onboarding briefing for a coding-agent
  CLI: provider/key layout, streaming display conventions (💭 thinking, tool
  requests, `[done]` token/cache footer), tool-registry design. Example of
  agent-facing documentation UX. **MEDIUM-LOW.**
- `geminex/methodology.md` — TST-flavored "AI-first delivery playbook" (tribunal
  ritual, prefactor-first). Process ideology, not notation. **LOW.**
- `geminex/elixir-otp-best-practices-for-ai.md`, `tst-distilled.md`,
  `tui-reference.md` — durable-execution philosophy / TST theorems / TUI visual
  crib. Off-target for notation. **LOW / dry-ish.**

### other-agents/ — reverse-engineered Claude Code CLI internals
- `other-agents/CLI_SPECIFICATION.md`, `TECHNICAL_SPECIFICATIONS.md`,
  `claude-code-idealized/`, deobfuscated `CLI_DEOBFUSCATED_SOURCE.js`, `sdk.d.ts`
  — a full spec + deobfuscated source of Anthropic's Claude Code CLI (MCP command
  structure, module system, tool SDK types). Relevant if UDON wants to understand
  *how the primary agent tool consumes files/tools*, but it's about CLI/MCP
  ergonomics, not document notation. **MEDIUM-LOW.**

### sapientia/synaptic sessions — multi-agent collaboration docs
- `sapientia-weaver-session/{ETHICAL_AGENT_COLLABORATION.md, MULTI_AGENT_COORDINATION.md, docs/AGENT_COLLABORATION_CHECKLIST.md}`,
  same in `sapientia-cultivator-session/` and `synaptic-cultivator/` — multi-agent
  process/ethics ideology (the sapientia-era stratum the brief expected). Real
  agent-tooling ideology, but about coordination/ethics, not document formats.
  Skim only if the sweep wants the "why agents are the primary users" worldview
  framing. **LOW-MEDIUM** (did not read line-by-line; characterized from titles +
  the neighborhood's known sapientia lineage — flagging as un-deep-read).

---

## LOW / marginal

- `shorthand/shorthand_0{1,2,3}.rb` — Joseph's Ruby terseness/monkeypatch
  experiments (Nilish, `blank?`, aligned one-liner method defs). Aesthetic
  ancestor of the "terse, aligned" impulse behind UDON/SAR, but it's a Ruby DSL,
  not a document notation. **LOW.**
- `glintty/{README.md, AGENTS.md, glintty-pilot-plan.md}`, `elixir-tui/{AGENTS.md,
  ROADMAP.md, NOTES.md}`, `tablize/*.exs` — TUI / table-rendering projects with
  AGENTS.md files. Agent-facing project docs but no notation/document-format
  content. **LOW.** (AGENTS.md files skimmed by title/context, not fully read.)
- `ash-exploration/`, `bak.archema.blown-away/`, `zoetica-ELIs/`,
  `obsidian-backup-config-from-tst/`, `second-other-client/`, `third-other-client/`
  — infrastructure / backups / config. Not vetted line-by-line; nothing in
  structure suggests notation-or-agent-document evidence. **DRY / not listed.**

---

## Dry wells & out-of-area (log)

- **Not in my area:** `principia`, `cddf`, `crew-first` — named in the brief but
  they are NOT under `_arch/`; they sit at `~/src/_ref/` top level (per the
  global project map). Out of area, not searched.
- **Pure dependency/venv noise (skipped):** `sar3/venv/**` (site-packages —
  hundreds of files), `geminex/deps/**` (ratatouille, mint, req, etc.),
  `claude-code/node_modules/**`. Zero project content.
- **Binary/data dumps (not openable as text evidence):** `llama-log` (128MB),
  `gemini.html` (1.5MB export), `openai-responses-api.html` (10MB API-doc dump),
  `context-osx-64.zip`, `cover*.udon`, `queue.json.old{,2,3}`.
- `extract_gemini_chat*.py`, `uuid_base58.py`, `venv/` — one-off scripts /
  environments, no evidence content.

## Searches / commands run

- `ls -la ~/src/_ref/_arch/` + `find -maxdepth 1 -type d` — full neighborhood map.
- `find sar2 -type f`; `find sar3 -type f -name '*.md/.txt'`;
  `find geminex -name '*.md'`; `find shorthand/tablize -type f` — per-sibling survey.
- Full reads: `sar2/sar-syntax-design.md`, `sar2/experiment/README-GAME-ENGINE.md`,
  `sar3/README.md`, `sar3/lsp_chunking_concept.md`, `sar3/AST_VS_LSP_REALITY.md`,
  `geminex/AGENTS.md`.
- Head reads: `sar3/{COMPLETION_SUMMARY,LSP_ENRICHMENT_RESULTS}.md`,
  `codex-synthesis-plan.md`, `UNIFIED-FEATURE-SPEC.md`, `geminex/{methodology,
  elixir-otp-best-practices-for-ai,tst-distilled}.md`, `shorthand_01.rb`,
  `other-agents/CLI_SPECIFICATION.md`, `sar2/experiment/haiku-run-.../prompt_sar.txt`,
  `sar2/experiment/analyze.rb`.
- Data inspection: `sar2/experiment/results/claude-run-.../confidence_intervals.csv`
  (verified the counter-hypothesis latency result firsthand).
- `grep -rl 'comprehension|accuracy|winner|conclusion' sar2/experiment/*.md` —
  only the README matched (no separate written conclusions file exists; the
  findings live in the CSVs + README claims).
- `find sapientia-*/synaptic-* -iname '*tool*' -o -iname '*agent*'` — located the
  multi-agent-collaboration docs (characterized, not deep-read).
