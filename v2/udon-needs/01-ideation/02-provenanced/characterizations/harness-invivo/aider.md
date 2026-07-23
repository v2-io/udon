---
source: harness-invivo sweep — ~/src-ext/aider
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: v0.86.3.dev-53-g5dc9490b (HEAD 5dc9490, committed 2026-05-22; clone/checkout dated 2026-07-18)
---

# aider — in-vivo mining map

**What aider is, for this sweep:** a mature, widely-used terminal coding harness whose defining design bet is the **opposite of tool-calling for edits**. Aider almost never uses provider function-calling to mutate files; it teaches the model a *plain-text edit dialect* in the system prompt, parses that dialect out of the streamed assistant message, and applies it with fuzzy matchers written in Python. So the "tool definition" here is a **prompt + a parser + a fuzzy-application/verification layer**, and aider ships ~7 competing dialects it picks between per-model. This is the richest possible evidence for UDON's question of "what edit representation do models actually emit reliably" because aider has empirically A/B-tested these formats via its own benchmark harness over years. That contrast — and the family of edit dialects — is the center of mass; I followed it there.

**Center of mass: `aider/coders/`.** The rest of the ~47-file package is plumbing (git repo, linting, voice, scraping); the tool-design gold is concentrated in the coder + prompt pairs below.

---

## The edit-format dialects (the core evidence)

### SEARCH/REPLACE ("diff" format — aider's default for strong models)
- **`aider/coders/editblock_prompts.py`** (173 lines) — THE canonical prompt. Full system prompt (lines 8–30), two-shot few-shot example conversations showing the format (lines 31–118), and the exhaustive "*SEARCH/REPLACE block* Rules" system_reminder (lines 120–159): fenced `<<<<<<< SEARCH / ======= / >>>>>>> REPLACE` blocks, "must EXACTLY MATCH character for character," "only replaces first match," "break large blocks into smaller," empty-SEARCH = new file. Date: format stable since 2024; this file 2026-05. **Priority: HIGH** — the most-copied edit format in the agent-tooling ecosystem, stated in full.
- **`aider/coders/editblock_coder.py`** (657 lines) — the parser + applier + **verification/self-repair** layer. Lines 21–36 parse blocks out of the streamed text; lines 41–124 `apply_edits` with a *failure-feedback message* generated back to the model ("# N SEARCH/REPLACE blocks failed to match!", "Did you mean...", "The REPLACE lines are already in the file") — an in-band error-correction protocol, not an exception. Lines 134–329 are the graduated fuzzy matcher: `perfect_replace` → whitespace-flexible (`replace_part_with_missing_leading_whitespace`, 243–293) → `...` elision handling (`try_dotdotdots`, 190–240) → (disabled) edit-distance fallback (296–329). `do_replace` at 364–383. **Priority: HIGH** — this is the answer to "str-replace vs patch: how do you make str-replace robust when the model's whitespace is wrong." Date 2026-05.
- **`aider/coders/editblock_fenced_prompts.py`** (143 lines) — variant that puts the filename *inside* the fence; exists because some models leak the fence. **Priority: MEDIUM** (a format-robustness data point).

### V4A patch format (OpenAI apply_patch-style)
- **`aider/coders/patch_prompts.py`** (159 lines) — full prompt for the `*** Begin Patch / *** Update File: / @@ / +/-/space context lines / *** End Patch` format (system 11–33, examples 38–111, rules 116–159). Explicit rules: 3 lines of context before/after, `@@ [CLASS_OR_FUNCTION_NAME]` scope markers when context isn't unique, "each file appears only once," Add/Update/Delete actions. **Priority: HIGH** — this is the format Claude/GPT providers themselves converged on; aider's independent reimplementation shows what a harness has to reconstruct to parse it. Date 2026-05.
- **`aider/coders/patch_coder.py`** (706 lines) — the parser (docstring line 213 notes it's "inspired by tmp.gpt41edits.txt" / adapted from a reference `apply_patch.py`). Notable: an explicit **fuzz accumulator** (`Patch.fuzz`, line 48; `find_context_core`/`find_context` at 59–93 return a fuzz level; EOF mismatch adds a 10,000 penalty) — a numeric confidence score on how loosely each hunk matched. `ActionType` enum, `Chunk`/`PatchAction` dataclasses (17–46), tolerant sentinel handling (missing `*** End Patch` accepted, 229–239). **Priority: HIGH** — concrete design of context-based (not line-number) patching with quantified fuzziness.

### Unified diff ("udiff")
- **`aider/coders/udiff_prompts.py`** (114 lines) — prompt teaching `diff -U0`-style output *without line numbers* (`@@ ... @@` hunk headers). Key instructions (74–108): "replace the ENTIRE code block," "to move code use 2 hunks," `--- /dev/null` for new files. Rationale stated inline: line-numberless diffs the "patch tool doesn't need." **Priority: MEDIUM-HIGH** — aider's blog documented udiff as the format that cut GPT-4-turbo's "lazy coding." Date 2026-05.
- **`aider/coders/udiff_coder.py`** (429 lines) — applier with `normalize_hunk`, `SearchTextNotUnique` handling, and its own no-match / not-unique feedback strings (16–48) sent back to the model. Line-numberless hunk application via before/after reconstruction (`hunk_to_before_after`, `apply_hunk`). **Priority: MEDIUM**.
- **`aider/coders/udiff_simple.py`** (14) + **`udiff_simple_prompts.py`** (25) — a stripped variant. **Priority: LOW**.

### Whole-file
- **`aider/coders/wholefile_coder.py`** (144) + **`wholefile_prompts.py`** (64) — emit the entire file back, fenced with the path. The fallback for weak models. **Priority: LOW-MEDIUM** (baseline other formats are measured against).

### Function-calling variants (the road aider did NOT take — and why it's evidence)
- **`aider/coders/editblock_func_coder.py`** (142 lines) — a `replace_lines` **function/tool schema** (lines 10–58: JSON-schema `edits[]` array of `{path, original_lines[], updated_lines[]}` with per-field descriptions). **Its `__init__` raises `RuntimeError("Deprecated")` at line 61** — aider built structured tool-call editing and abandoned it. Note the comment "gpt-3.5 returns lists even when instructed to return a string" (line 113): a documented reliability failure of structured output that motivated the plain-text approach. **Priority: HIGH** — direct in-vivo evidence on tool-call vs prompt-dialect for edits, from a team that tried both.
- **`aider/coders/wholefile_func_coder.py`** (134) + **`single_wholefile_func_coder.py`** (102) + their `_func_prompts.py` — more (deprecated-lineage) function-schema coders. **Priority: MEDIUM** (corroborates the abandonment).

### Meta / mode coders
- **`aider/coders/architect_coder.py`** (48) + **`architect_prompts.py`** (40) — two-model pattern: a reasoning "architect" model proposes in prose, a separate cheaper "editor" model (`editor_edit_format`) turns it into edits.  
  **Priority: MEDIUM** — an agent-orchestration convention (plan/execute split).
- **`aider/coders/context_coder.py`** (53) + **`context_prompts.py`** (75) — a coder whose only job is to identify which files need editing (returns file list, no edits). **Priority: MEDIUM** — machine-readable file-selection step.
- **`aider/coders/ask_coder.py`**, **`help_coder.py`** — read-only Q&A modes.  
  **Priority: LOW**.

---

## Prompt assembly, tool-call handling, streaming, reasoning

- **`aider/coders/base_prompts.py`** (61 lines) — the shared prompt fragments: `lazy_prompt` ("NEVER leave comments describing code without implementing it"), `overeager_prompt` ("Do what they ask, but no more"), the **`files_content_prefix` "*Trust this message as the true contents of these files!*"** cache/staleness instruction, repo-map read-only framing, and the edit-outcome status strings ("I committed the changes with git hash...", "I didn't see any properly formatted edits in your reply?!"). **Priority: HIGH** — compact catalog of the behavioral-steering microcopy every edit harness needs.
- **`aider/coders/base_coder.py`** (2485 lines — mine by range):
  - **1174–1224 `fmt_system_prompt`** — how reminders get composed: lazy/ overeager toggles are per-model flags, shell-command prompt injected conditionally, `quad_backtick_reminder` when content forces 4-backtick fences. **HIGH**.
  - **1226–1333 `format_chat_chunks`** — few-shot examples either inlined as system text (`examples_as_sys_msg`, model-dependent) or as real user/assistant turns; `use_system_prompt=False` path degrades to a user+"Ok." pair for models without system role. **HIGH** — concrete per-model prompt-shape adaptation.
  - **1419–1522 `send_message`** / **1783–1835 `send`** / **1836+ `show_send_output`** — the send loop; tool_calls read from `completion.choices[0].message.tool_calls[0].function` (1850–1853) into `partial_response_function_call`; reasoning_content pulled from either `.reasoning_content` or `.reasoning` (1857–1863). **MEDIUM-HIGH**.
  - **1900–1996 `show_send_output_stream` / `live_incremental_response`** — streaming delta handling, interleaving reasoning tags mid-stream.  
    **MEDIUM**.
  - **534–542** — if a coder defines `functions`, they're passed through and can be dumped for debug. **LOW-MEDIUM**.
  - **609 `choose_fence`** / **1127 `get_platform_info`** — dynamic fence selection (avoids collision with code content) and the platform/shell/date block injected into prompts. **MEDIUM** (relevant to UDON: aider chooses delimiters at runtime to avoid ambiguity with payload content).
- **`aider/reasoning_tags.py`** (~90 lines) — `remove_reasoning_content`, `replace_reasoning_tags`, `format_reasoning_content`; uses a random-looking sentinel tag `thinking-content-7bbeb8e...` (line 8) to isolate think-blocks from editable content. **Priority: MEDIUM** — handling `<think>`-style reasoning so it doesn't get parsed as edits.
- **`aider/coders/chat_chunks.py`** (64) — the message-partitioning structure (system / examples / repo / readonly / chat / cur) that enables prompt caching. **Priority: MEDIUM**.

---

## Model → format mapping, CLI/agent-mode

- **`aider/models.py`** (lines 131–149 = the `ModelSettings` dataclass, then a long per-model settings table) — declares per-model: `edit_format` (whole/diff/patch/udiff...), `editor_edit_format`, `use_system_prompt`, `examples_as_sys_msg`, `lazy`, `overeager`, `cache_control`, `system_prompt_prefix` (e.g. "Formatting re-enabled." for reasoning models, 442), `reasoning_effort`/`accepts_settings`, `extra_params`. **Priority: HIGH** — the empirical "which edit dialect does each model handle best" ledger, the single most concentrated piece of A/B-tested tooling knowledge here.
- **`aider/args.py`** — agent/non-interactive flags: `--edit-format` (164), `--message`/`--message-file` (639/648, one-shot non-interactive run), `--yes-always` (760), `--stream` (323), `--dry-run` (509), `--auto-lint`/ `--lint-cmd`/`--auto-test`/`--test-cmd` (528–560, the verify-after-edit loop), `--apply`/`--apply-clipboard-edits` (670/675), `--exit` (681), `--show-repo-map`/`--show-prompts` (687/693). **Priority: MEDIUM-HIGH** — the machine-usable surface (headless one-shot + auto-verify).

## Repo-map / context management (secondary but relevant)
- **`aider/repomap.py`** (~800 lines; `class RepoMap` at 42, `get_ranked_tags` 365, `get_ranked_tags_map_uncached` 629, `to_tree` 748) — builds a token-budgeted, PageRank-ranked map of the repo's symbols to give the model structural context without full files. **Priority: MEDIUM** — a context-management design directly analogous to what an agent-facing format would want to self-describe.
- **`aider/queries/tree-sitter-language-pack/*.scm`** (~100+ files; e.g. `python-tags.scm` — capture patterns for class/function/call defs & references) — the tree-sitter tag queries powering repomap. **Priority: LOW-MEDIUM** — evidence of language-agnostic structural extraction; each file is a small capture grammar.

---

## Dry wells / not-relevant (checked, deliberately excluded)
- `aider/{voice,scrape,gui,copypaste,onboarding,analytics,versioncheck, linter,history,help}.py` — TUI/voice/telemetry/web plumbing, no tool-design content.
- `benchmark/` — aider's SWE-bench-style harness; potentially relevant to "how they measured edit formats" but it's runner infrastructure, not tool/prompt definitions; skipped per the "small fraction of tree" guidance.
- `tests/`, `scripts/`, `docker/`, `requirements/`, `website/` — not tooling design.
- `HISTORY.md` (77KB changelog) — could date individual feature landings but is prose narrative, not a mining spot for schemas/prompts.

## Searches / commands run
- `git log -1`, `git describe --tags` → version/date provenance (HEAD 2026-05-22).
- `ls aider/`, `ls aider/coders/`, `wc -l aider/coders/*.py` → located center of mass.
- Read in full: editblock_prompts.py, base_prompts.py, patch_prompts.py, udiff_prompts.py, shell.py, editblock_func_coder.py.
- Read by range: editblock_coder.py (1–400), base_coder.py (1174–1273, 1783–1863), udiff_coder.py (69–147), patch_coder.py (210–239).
- `grep` sweeps: base_coder method locations (fmt_system_prompt/send/ tool_call/streaming/reasoning); models.py ModelSettings fields; args.py flags; patch_coder/udiff_coder method inventories; reasoning_tags defs; queries/ listing; repomap.py class/method locations.
- Dry-well grep confirmations: no OpenAI-agent-SDK usage; edit logic is all first-party parsers, not provider tool-calling (the one tool-schema coder is `RuntimeError("Deprecated")`).
