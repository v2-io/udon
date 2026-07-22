---
source: agentic-tooling gathering sweep 2026-07-21 / area = in-vivo harness codebase (~/src-ext/kilocode)
gathered: 2026-07-21
status: vetted mining-spot map
repo: github.com/Kilo-Org/kilocode (VS Code + JetBrains + CLI/TUI AI coding agent)
repo_version: cloned ~2026-07-18; last commit 938919a "chore: update nix node_modules hashes" 2026-07-17; history 2025-08-27 → 2026-07-17
---

# kilocode — in-vivo harness/tool mining map

## Orientation

Kilocode is a shipping AI coding agent (VS Code + JetBrains extensions and a CLI/TUI).
Under `packages/` there are **two parallel, live tool+prompt systems**, and the
interesting evidence is concentrated in exactly two subtrees:

- **`packages/opencode/`** — a vendored/forked **opencode** base (the CLI/TUI engine),
  carrying `.txt` tool descriptions and per-model system prompts. Kilocode-specific
  changes are marked inline with `// kilocode_change`. This is the richest reservoir:
  real model-facing tool prose + 12+ per-model system prompts + a codex-style patch tool
  alongside a fuzzy str-replace edit tool.
- **`packages/core/`** — kilocode's newer **Effect-Schema** rewrite of the tool layer,
  where the JSON schema and the tool are the same value (`Tool.make`) and descriptions
  live in `Schema.annotate({description})`. Cleaner, "V2" design intent documented in
  co-located `AGENTS.md` files.

Center of mass matched expectations: `packages/opencode/src/tool/`,
`packages/opencode/src/session/prompt/`, `packages/opencode/src/kilocode/`, and
`packages/core/src/tool/`. Everything else in the ~50-package tree (UI, telemetry,
indexing, i18n, sandbox…) is not tool/prompt evidence.

---

## GOLD — edit-tool design (str-replace + patch, both shipped)

### `packages/opencode/src/tool/edit.ts` (~760 lines)
- **The standout artifact.** A str-replace edit tool with a **9-strategy fuzzy-match
  replacer cascade** tried in order until one yields a unique match: `SimpleReplacer` →
  `LineTrimmedReplacer` → `BlockAnchorReplacer` (first/last line anchors + Levenshtein
  similarity on the middle, thresholded) → `WhitespaceNormalizedReplacer` →
  `IndentationFlexibleReplacer` → `EscapeNormalizedReplacer` → `TrimmedBoundaryReplacer`
  → `ContextAwareReplacer` → `MultiOccurrenceReplacer`. Includes its own `levenshtein()`
  (L251), a `SINGLE_CANDIDATE_SIMILARITY_THRESHOLD`, `isDisproportionateMatch()` guard
  (L756), and `buildFileDiff`/`trimDiff` for the result diff.
- Key line-ranges: replacer type + cascade `replace()` at **L242–756**; params/schema at
  **L73–84**; `Tool.define` body **L84–240**; line-ending/BOM normalization **L48–62**.
- Date: repo @2026-07-17. **Priority: HIGH** — this is the concrete answer to "how does a
  real harness make LLM str-replace edits robust against near-miss whitespace/indent."

### `packages/opencode/src/tool/edit.txt` (28 lines)
- The **exact model-facing description** of the edit tool: mandates a prior `Read`,
  explains the line-number-prefix stripping rule (`N: ` format), the exact error strings
  ("oldString not found in content" / "Found multiple matches…"), and `replaceAll` usage.
- Date: repo @2026-07-17. **Priority: HIGH** — a battle-tested edit-tool prompt verbatim.

### `packages/opencode/src/tool/apply_patch.ts` (~13 KB) + `apply_patch.txt`
- A **codex-style patch tool** offered alongside `edit`: `*** Begin/End Patch` envelope with
  `*** Add File / Delete File / Update File / Move to:` headers and `@@` hunk context. The
  `.txt` is the full patch-language spec handed to the model.
- Date: repo @2026-07-17. **Priority: HIGH** — evidence that a shipping harness gives the
  model *both* a whole-file diff envelope and a surgical string edit, and how it phrases each.

### `packages/core/src/tool/edit.ts` + `apply-patch.ts` (Effect-Schema V2 rewrite)
- The newer design: `Input = Schema.Struct({...}).annotate({description})` so the JSON schema
  IS the tool contract; `edit.ts` header comment (L1–8) documents a "Location"-scoped path
  model (relative-within-Location, external absolute paths need a separate
  `external_directory` approval, named project refs are read-only). `apply-patch.ts` takes a
  single `patchText` and returns a structured `{applied:[{type,resource,target}]}` output.
- Date: repo @2026-07-17. **Priority: MEDIUM-HIGH** — shows the schema-as-contract direction
  and a permission/path model for mutation tools.

### `packages/core/src/tool/AGENTS.md` (~90 lines)
- Design-doc prose for the V2 tool architecture: the single canonical
  `Tool.make({description,input,output,execute,toModelOutput})` value, registry overlay of
  Location-over-application registrations, "translate only expected typed errors into
  ToolFailure; interruption/defects must survive," permission-source construction.
- Date: repo @2026-07-17. **Priority: MEDIUM** — rationale layer for the tool-representation design.

---

## GOLD — tool roster, definitions & JSON-schema generation

### `packages/opencode/src/tool/` — the `.txt` description set
- One `.txt` per tool = the **verbatim model-facing description** for each: `read.txt`,
  `grep.txt`, `glob.txt`, `write.txt`, `webfetch.txt`, `websearch.txt`, `lsp.txt`,
  `todowrite.txt`, `skill.txt`, `question.txt`, `plan-enter.txt`/`plan-exit.txt`,
  `warpgrep.txt`, `recall.txt` (memory), `repo_clone.txt`. Each is a self-contained
  "usage + when-not-to-use + notes" block.
- Date: repo @2026-07-17. **Priority: HIGH** — a whole corpus of production tool-description prose.

### `packages/opencode/src/tool/task.txt` + `task.ts` (~20 KB)
- **Sub-agent orchestration** description: `subagent_type` selection, "launch multiple agents
  concurrently in one message," fresh-context-per-invocation with a reusable `task_id` to
  resume a subagent session, "agent output not visible to user — summarize it," and explicit
  guidance to tell the agent code-vs-research + how to verify.
- Date: repo @2026-07-17. **Priority: HIGH** — real multi-agent delegation contract.

### `packages/opencode/src/tool/registry.ts` (~22 KB)
- The **assembly point**: yields every tool service (read/grep/glob/write/edit/apply_patch/
  shell/task/lsp/webfetch/websearch/skill/todo/question/plan + kilocode_change extras
  repo_clone, repo_overview, suggest, notebook, memory) and wires plugin-provided tools,
  converting plugin Zod args → JSON schema (`zodJsonSchema`) or a `legacyJsonSchema` fallback
  (L145–177). Shows how the final tool list is composed per agent/config.
- Date: repo @2026-07-17. **Priority: MEDIUM-HIGH** — the "which tools exist and how they're built" map.

### `packages/opencode/src/tool/json-schema.ts` (~150 lines) + `tool.ts`
- `fromSchema()`/`fromTool()` convert Effect Schema → **JSONSchema7** for the wire
  (draft-2020-12, `additionalProperties:true`, inlines `$defs`, strips nulls, WeakMap-cached).
  `tool.ts` defines `Tool.Def` (`description`, `parameters`, `execute`) and a
  `DynamicDescription = (agent) => Effect<string>` — descriptions can vary by agent.
- Date: repo @2026-07-17. **Priority: MEDIUM** — the schema-generation seam feeding the model.

### `packages/opencode/src/tool/lsp.ts`(+`.txt`), `diagnostics.ts`, `truncate.ts`
- `lsp` exposes language-server hover/diagnostics to the model as a tool; `truncate.ts` is the
  **tool-output bounding** policy: `MAX_LINES=2000`, `MAX_BYTES=50KB`, head/tail direction,
  overflow spilled to a `TRUNCATION_DIR` file with 7-day retention (L1–30).
- Date: repo @2026-07-17. **Priority: MEDIUM** — context-management of tool results.

---

## GOLD — system prompts (per-model, in vivo)

### `packages/opencode/src/session/prompt/*.txt` (18 files)
- **Per-model system prompts**, hand-tuned by family: `anthropic.txt` (8 KB, Claude-Code-style —
  opens "You are Kilo… interactive CLI tool," TodoWrite discipline, tone/objectivity sections),
  `beast.txt` (11 KB, GPT-4/o1/o3 "beast mode"), `gpt.txt`, `codex.txt`, `gemini.txt` (15 KB),
  `kimi.txt`, `ling.txt`, `trinity.txt`, `kilocode-gpt-5.5.txt`, `default.txt`, plus
  `plan-mode.txt`, `plan.txt`, `plan-reminder-anthropic.txt` (plan/act mode), `max-steps.txt`,
  `code-switch.txt`, `summary.txt`.
- Date: repo @2026-07-17. **Priority: HIGH** — direct evidence that tool-use instructions are
  *specialized per model*; a comparative goldmine (same harness, N phrasings).

### `packages/opencode/src/session/system.ts` (172 lines)
- The **prompt-selection logic**: `switch(model.prompt)` plus fallback matching on `model.api.id`
  (`gpt-4/o1/o3→beast`, `codex→codex`, `gemini-→gemini`, `claude→anthropic`, `kimi`, `ling`,
  else `default`) at **L46–87**; assembles system = selected prompt + kilocode environment lines
  + memory blocks + SOUL. Shows how prompt, env, and memory are layered per turn.
- Date: repo @2026-07-17. **Priority: HIGH** — the routing that ties model → prompt → tools.

### `packages/opencode/src/agent/prompt/*.txt` (7 files)
- **Sub-agent role prompts**: `orchestrator.txt`, `explore.txt`, `debug.txt`, `ask.txt`,
  `compaction.txt`, `summary.txt`, `title.txt` — the personas the `task` tool spawns.
- Date: repo @2026-07-17. **Priority: MEDIUM** — agent-mode conventions / role decomposition.

### `packages/opencode/src/kilocode/soul.txt` + `system-prompt.ts`
- `soul.txt` is kilocode's **persona/behavior overlay** ("You are Kilo… STRICTLY FORBIDDEN from
  starting with 'Great'/'Certainly'…", "NEVER end with a question," question-tool discipline).
  `system-prompt.ts` builds the `environment(...)` block (editor context, cwd) and `memoryBlocks(...)`
  that instruct the model to call `kilo_memory_recall` for typed durable memory (L33–67).
- Date: repo @2026-07-17. **Priority: MEDIUM-HIGH** — the kilocode-specific behavioral + memory layer.

---

## GOLD — recent tooling advancements

### `packages/opencode/src/kilocode/swe-pruner.ts`
- **SWE-Pruner: self-adaptive context pruning** (cites arXiv 2601.16746, L12–22). When enabled,
  supported tools (`read`, `grep`, `bash`) advertise an optional **`context_focus_question`**
  parameter; if the model supplies it, raw tool output is skimmed by a small model that keeps
  only relevant lines (omissions marked inline), with full-output fallback on any failure.
- Date: repo @2026-07-17. **Priority: HIGH** — a genuinely recent, tool-output-shaping advancement
  directly relevant to how much a tool returns and how it's framed.

### `packages/opencode/src/kilocode/provider-options.ts`
- Per-provider **reasoning/thinking wiring** from OpenRouter settings into Anthropic
  (`thinking:{type:"adaptive"|"disabled"}`), OpenAI (`reasoningEffort`), and enable-thinking flags
  (L15–34). Uses `AnthropicProviderOptions` from `@ai-sdk/anthropic`.
- Date: repo @2026-07-17. **Priority: MEDIUM** — how thinking/reasoning is toggled per model.

### `packages/opencode/src/session/` (context management neighborhood)
- `compaction.ts`, `overflow.ts`, `reminders.ts`, `summary.ts`, `truncate` usage — the
  conversation/context-window management around tool results (compaction, overflow handling,
  reminder injection). Not individually deep-read; flagged as the context-management cluster.
- Date: repo @2026-07-17. **Priority: MEDIUM** — worth a targeted read if context-mgmt is the focus.

---

## Agent-mode / non-interactive CLI

### `packages/opencode/src/kilocode/cli/cmd/run.ts` (+ `cmd/*.ts`)
- Non-interactive **`run`** entry (headless session via `@kilocode/sdk/v2` client), builtin
  commands (`compact`/`summarize`) requiring `--continue`/`--session`, `process.exit(1)` on
  validation failure. Sibling `cmd/` files (`roll-call.ts`, `profile.ts`, `dev-setup.ts`) set
  `process.exitCode` — evidence of scriptable exit-code conventions.
- Date: repo @2026-07-17. **Priority: MEDIUM** — machine-mode/exit-code conventions (lighter than the tool/prompt gold).

---

## Supporting / lower-priority

- **`AGENTS.md`** (repo root, 17 KB) + `CONTEXT.md` (14 KB) — contributor/agent guide to repo
  structure and the `// kilocode_change` convention. Date @2026-07-17. **Priority: LOW-MEDIUM** —
  orientation, not tool evidence.
- **`packages/llm/`** (`@opencode-ai/llm`, imported by core tools for `ToolFailure`) — the LLM/tool
  primitive package; not read in depth. **Priority: LOW** unless chasing the `ToolFailure` contract.
- **`packages/opencode/src/tool/skill.ts`(+`.txt`), `recall.ts`(+`.txt`)** — skill invocation and
  memory recall tools; descriptions confirm skills + typed memory are surfaced as tools.
  **Priority: MEDIUM** for the memory/skill-as-tool pattern specifically.
- **`specs/`, `plans/`, `perf/`** (repo root dirs) — not opened; likely product/perf docs, not
  tool/prompt evidence. **Priority: LOW.**

---

## Dry wells / notes

- `packages/core/src/session/prompt.ts` (46 lines) is **only** a Prompt/attachment data schema —
  NOT the system-prompt text. Core's actual system-prompt assembly lives elsewhere (the opencode
  `session/system.ts` path is the live one); did not locate a separate core prompt-text corpus,
  so opencode is the prompt center of mass.
- The bulk of the ~50 packages (`kilo-ui`, `kilo-web-ui`, `kilo-telemetry`, `kilo-i18n`,
  `kilo-indexing`, `kilo-sandbox`, `containers`, `storybook`, `translations/`) are UI/infra and
  hold no tool-definition or prompt evidence — deliberately excluded.
- Two tool systems coexist (`packages/opencode` vendored base vs `packages/core` Effect rewrite);
  I did not fully trace which is wired into the shipping extension entrypoint — both are live code,
  and both are worth citing since the question is "how does this harness design tools," and it
  answers it twice (mature str-replace-cascade + patch, and a schema-as-contract V2).

## Searches / commands run
- `git log -1`, first/last commit dates, root `ls -la` — established version/clone provenance.
- `find packages -maxdepth 3 -type d -iname '*prompt*|*tool*|*diff*'` — located the two tool systems.
- `ls packages/{core,opencode}/src/tool/` — full tool file inventory.
- `find … -iname '*.txt' -path '*prompt*'`; `ls session/prompt/ agent/prompt/` — prompt corpus.
- Read: opencode `edit.txt`, `apply_patch.txt`, `task.txt`; `edit.ts` (grep replacer cascade);
  `registry.ts`, `json-schema.ts`, `tool.ts`, `truncate.ts` heads; `session/system.ts` (grep);
  `kilocode/soul.txt`, `system-prompt.ts`, `swe-pruner.ts`, `provider-options.ts`;
  core `prompt.ts`, `edit.ts` head, `apply-patch.ts` head, `tool/AGENTS.md`; `cli/cmd/run.ts`.
- `grep process.exit|exitCode … cli/` — confirmed non-interactive/exit-code conventions.
