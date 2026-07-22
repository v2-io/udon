---
source: agentic-tooling in-vivo sweep — repo ~/src/_ref/gemini-cli (Google Gemini CLI)
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: main @ 2515b89e2 (last commit 2025-12-18; `git describe` = v0.1.12-2399-g2515b89e2). Most source files dated Dec 18 2025. Provider = Gemini (Claude-API skill N/A).
---

# Gemini CLI — in-vivo harness/tool map

**What this repo is:** Google's official terminal agent for Gemini models, a TypeScript monorepo (`packages/{core,cli,a2a-server,vscode-ide-companion,test-utils}`). The tool/prompt center of mass is **`packages/core/src/`** — specifically `tools/`, `core/prompts.ts`, and `agents/`. The CLI package is mostly UI/React (Ink); the interesting agent behavior lives in `core`.

**Headline findings for UDON (agent-facing notation):**
1. **The edit tool is LLM-self-correcting** — a failed str-replace is repaired by a *second* Gemini call driven by a semantic `instruction` field, not just fuzzy matching. This is the freshest tooling advancement here.
2. **Multi-strategy text matching** before giving up: exact → whitespace-flexible → token/regex-flexible.
3. **A subagent framework** (`agents/`) with agents definable in **TOML**, structured JSON output contracts, and a built-in "Codebase Investigator" delegate.
4. **Model routing** — a classifier LLM decides flash-vs-pro per request.
5. **XML-structured context compression** prompt (the "only memory" snapshot).
6. The system prompt is **heavily conditional** (interactive vs non-interactive, Gemini-2 vs Gemini-3, feature flags) assembled from labeled blocks.

---

## Tier 1 — the gold (edit-tool design + LLM self-correction)

- **`packages/core/src/tools/smart-edit.ts`** (1010 lines) — the current default edit tool (`SmartEditTool`, replaces the older `edit.ts`). Key spots:
  - **L845–919: schema + tool description.** Params: `file_path`, `old_string`, `new_string`, `expected_replacements` (default 1, replaces ALL matches), and a distinctive **`instruction`** field. Description mandates "≥3 lines of context BEFORE and AFTER", "NEVER escape", "prefer smaller atomic calls". (Dec 2025) — HIGH
  - **L877–892: the `instruction` param description** — explicitly framed as "a high-quality prompt for an expert LLM assistant" that must answer WHY/WHERE/WHAT/desired-outcome, with GOOD/BAD examples. This is the input to the self-correction fixer. (Dec 2025) — HIGH
  - **L251–296: `calculateReplacement`** — the multi-strategy matcher: `calculateExactReplacement` → `calculateFlexibleReplacement` (line-trim whitespace-insensitive, L120) → `calculateRegexReplacement` (tokenize + `\s*` join, L178), emitting a `SmartEditStrategyEvent` telemetry marker per strategy used. (Dec 2025) — HIGH
  - **L400–475 `attemptSelfCorrection` / `EditToolInvocation`** — on match failure, calls `FixLLMEditWithInstruction(instruction, old_string, new_string, error, content)`; handles the "file changed since attempt" and "no change required (already applied)" cases with distinct error types. (Dec 2025) — HIGH
  - **L965–1008 `getModifyContext`** — supports user-editing of the proposed `new_string` in the confirmation diff; tracks `modified_by_user` / `ai_proposed_string`. — MEDIUM

- **`packages/core/src/utils/llm-edit-fixer.ts`** (L17–90) — the **secondary edit-repair LLM prompt** (`EDIT_SYS_PROMPT` + `EDIT_USER_PROMPT`). System prompt: "specializing in debugging failed search-and-replace… correction as minimal as possible… DO NOT GIVE ADVICE". Output is structured JSON (`SearchReplaceEditSchema`: search/replace/explanation/noChangesRequired), 40s timeout, LRU-cached (50). The literal recipe for "make str-replace robust with an LLM backstop". (Dec 2025) — HIGH

- **`packages/core/src/tools/edit.ts`** (626 lines) — the *older* non-smart edit tool, still present; simpler exact/flexible matcher without the LLM fixer. Useful as the before/after comparison to smart-edit. (Dec 2025) — MEDIUM

- **`packages/core/src/tools/write-file.ts`** (522 lines) — full-file write tool with diff-confirmation + user-modifiable proposed content; same `ModifiableDeclarativeTool` pattern as edit. — MEDIUM

## Tier 1 — system prompt & context management

- **`packages/core/src/core/prompts.ts`** (451 lines) — the master system-prompt builder. Read whole; highlights:
  - **L80–386 `getCoreSystemPrompt`** — assembles the prompt from labeled blocks (`preamble`, `coreMandates`, `primaryWorkflows_*`, `operationalGuidelines`, `sandbox`, `git`, `finalReminder`) with per-block env-var disable (`GEMINI_PROMPT_<NAME>=0`) and full override via `GEMINI_SYSTEM_MD` file. (Dec 2025) — HIGH
  - **Conditional variants:** interactive vs non-interactive (L138, L148, L153), Gemini-3 preview vs older (`isGemini3`, L114–119 "Do not call tools in silence"), and workflow variants keyed on whether the Codebase-Investigator subagent / write-todos tool are enabled (L336–351). — HIGH
  - **L139–157 Core Mandates** — conventions/idiomatic-changes/comments-sparingly/"NEVER talk to the user through comments". — MEDIUM
  - **L220–276 Operational Guidelines** — shell-output token-efficiency block (redirect to temp files, grep/tail), tone ("fewer than 3 lines"), parallel tool calls, memory tool usage, "Respect User Confirmations". — HIGH
  - **L277–325** sandbox-awareness (seatbelt/container) and git-workflow blocks injected only when relevant. — MEDIUM
  - **L393–450 `getCompressionPrompt`** — the history-compression prompt: a private `<scratchpad>` then a dense `<state_snapshot>` XML with `<overall_goal>/<key_knowledge>/<file_system_state>/<recent_actions>/<current_plan>` — "this snapshot is the agent's *only* memory". Concrete example of structure-as-context-management. (Dec 2025) — HIGH

## Tier 1 — tool infrastructure / schema shape

- **`packages/core/src/tools/tools.ts`** (755 lines) — the base tool framework. `DeclarativeTool`/`BaseDeclarativeTool`/`ToolInvocation` abstractions; **`Kind` enum** (L730: Read/Edit/Delete/Move/Execute/Search/Think/Fetch…) with `MUTATOR_KINDS` (L743) driving confirmation policy; `ToolResult` with dual **`llmContent`** (for model) vs **`returnDisplay`** (for user, can be a `FileDiff`/`AnsiOutput`/`TodoList`); schema carried as raw `parametersJsonSchema`. Shows the definition→invocation→build→execute lifecycle. (Dec 2025) — HIGH

- **`packages/core/src/tools/tool-registry.ts`** (533 lines) — how tools register and get exposed as Gemini `FunctionDeclaration`s. — MEDIUM
- **`packages/core/src/tools/tool-names.ts`** (91 lines) — canonical tool-name constants (grep/glob/read_file/edit/write_file/shell/memory/web_fetch/…). Quick index of the tool surface. — LOW/reference

- **`packages/core/src/tools/shell.ts`** (528 lines) — shell tool. Schema L455–470: `command`, `description`, optional `directory`; **command allowlisting** with per-command confirmation (L123–137, L393), and output-summarization config. Distinct `is_background` handling. — MEDIUM
- **`packages/core/src/tools/read-file.ts`** (240), **`read-many-files.ts`** (543), **`glob.ts`**, **`grep.ts`**/**`ripGrep.ts`** — the read/search surface; ripGrep is the perf path. — LOW unless comparing read-tool ergonomics
- **`packages/core/src/tools/write-todos.ts`** (262) — todo-list tool; schema L156–195 (`todos[]` of `{description, status: pending|in_progress|completed|cancelled}`, "overwrites existing list"). Note **`responseJsonSchema`** declared alongside the parameter schema (L191). — MEDIUM

## Tier 1 — subagent framework (agents/)

- **`packages/core/src/agents/codebase-investigator.ts`** — a fully-specified built-in subagent. L47–152: `name`, `description`, `outputConfig` (structured JSON report schema), `modelConfig`, `runConfig` (max turns/time), `tools: [ls, read_file, glob, grep]`, and a long `systemPrompt` mandating a persisted `<scratchpad>` with Checklist/Questions-to-Resolve/Key-Findings, ending in a `complete_task` call returning a JSON report (worked example at L129–151). Canonical "how a delegated investigation agent is wired". (Dec 2025) — HIGH
- **`packages/core/src/agents/types.ts`** — the agent-definition contract: `PromptConfig` (systemPrompt vs `query` first-user-message split, L103–125), `ModelConfig`, `RunConfig`, `ToolConfig`, `OutputConfig<zod>`. The schema for defining any subagent. — HIGH
- **`packages/core/src/agents/toml-loader.ts`** — **user-defined agents in TOML** (`@iarna/toml`), zod-validated (name slug regex, description, optional `tools[]`, `model`); `tomlToAgentDefinition`. Notable: agents are user-authorable config, not just code. — MEDIUM
- **`packages/core/src/agents/delegate-to-agent-tool.ts`** — the tool the main model calls to delegate to a subagent (`DELEGATE_TO_AGENT_TOOL_NAME`). — MEDIUM
- **`packages/core/src/agents/local-executor.ts`**, **`subagent-tool-wrapper.ts`**, **`schema-utils.ts`** (`convertInputConfigToJsonSchema`, L40) — execution + schema conversion plumbing. — LOW/MEDIUM

## Tier 2 — routing, streaming, structured output

- **`packages/core/src/routing/strategies/classifierStrategy.ts`** — **model-routing classifier**: an LLM (`CLASSIFIER_SYSTEM_PROMPT`, L31) classifies each request SIMPLE(`flash`) vs COMPLEX(`pro`) against a `<complexity_rubric>`, returns structured JSON with `reasoning` (worked examples L78, L90–100). Composite/override/fallback/default strategies alongside. Evidence of cost/latency-aware tool orchestration. (Dec 2025) — MEDIUM
- **`packages/core/src/core/turn.ts`** — streaming event model. `GeminiEventType` enum (Content/Thought/ToolCallRequest/…), `ServerGeminiStreamEvent` union (L210), `run()` async-generator consuming the model stream (L245), **thought/"thinking" parsing** (L276–282 via `parseThought`), and `handlePendingFunctionCall` (L372) turning stream fn-calls into tool-call-request events. How tool calls are extracted from a streaming response. — MEDIUM
- **`packages/core/src/core/baseLlmClient.ts`** — **`generateJson`** (L108) structured-output helper: forces `responseMimeType: 'application/json'` + `responseSchema`. This is what edit-fixer/classifier/investigator use for machine-readable output. — MEDIUM
- **`packages/core/src/core/geminiChat.ts`**, **`contentGenerator.ts`**, **`nonInteractiveToolExecutor.ts`** — chat loop, content-generator abstraction, and non-interactive tool execution path. — LOW/MEDIUM
- **`packages/core/src/tools/mcp-client.ts`** (1837 lines) + **`mcp-tool.ts`** (446) — MCP integration: discovers external MCP tools and wraps them as native tools (schema translation, OAuth). Largest tool file; relevant if MCP tool-schema handling matters. — MEDIUM

## Tier 2 — agent-mode / non-interactive conventions

- **`packages/cli/src/nonInteractiveCli.ts`** + **`nonInteractiveCliCommands.ts`** + **`ui/noninteractive/nonInteractiveUi.ts`** — the headless/scripted execution path (no confirmations, "continue until resolved" per the non-interactive system-prompt branch). — MEDIUM
- **`packages/a2a-server/src/`** — an **Agent-to-Agent (A2A) HTTP server** exposing the agent over a protocol: `agent/executor.ts`, `agent/task.ts`, `http/{app,server}.ts`, GCS-backed task persistence (`persistence/gcs.ts`). Evidence of remote/agent-as-service tooling. — MEDIUM
- **`packages/cli/src/zed-integration/`** — editor-integration entry point. — LOW

## Tier 3 — human-readable tool docs (secondary, but concise spec of tool contracts)

- **`docs/tools/`** — `file-system.md`, `shell.md`, `todos.md`, `web-fetch.md`, `web-search.md`, `memory.md`, `mcp-server.md`, `index.md`. Prose docs of each tool's contract/params; a fast cross-check of the code schemas above. — LOW/MEDIUM
- **`GEMINI.md`** (repo root, 20KB) — the project's own agent-instructions file (dogfooded context file). — LOW
- **`schemas/`** (repo root) — JSON schemas (config settings). — LOW

---

## Dry wells / not-relevant

- `packages/cli/src/ui/**` — large React/Ink terminal UI (InputPrompt, components, hooks). Rendering, not tool/agent semantics. Skipped after confirming it's presentation.
- `integration-tests/` (53 files) — end-to-end test scaffolding; behavior is better read from source. Not mined.
- `packages/vscode-ide-companion/`, `packages/test-utils/` — editor companion + test helpers; no tool-design content.
- `*.test.ts` / `__snapshots__` throughout — excluded by intent (though `core/__snapshots__/prompts.test.ts.snap` contains a rendered full system prompt if a verbatim frozen copy is ever wanted — noted, not read in full).
- `.git/refs` branch names matching `*prompt*` (feat-log-custom-prompt, nuked_prompt, sys-prompt-breakdown) — surfaced by the prompt search; git refs, not content.

## Searches / commands run
- `git log -1`, `git describe --tags`, `git branch` → version/date provenance.
- `ls packages/`, `find -type d -name tools`, `find -iname '*prompt*'` → located centers of mass.
- `wc -l` over `packages/core/src/tools/*.ts` (non-test) → sized files; smart-edit (1010) and mcp-client (1837) largest.
- `grep -n` structure scans of: prompts.ts, smart-edit.ts, tools.ts, llm-edit-fixer.ts, shell.ts, write-todos.ts, codebase-investigator.ts, agents/types.ts, toml-loader.ts, classifierStrategy.ts, baseLlmClient.ts, turn.ts.
- Read in full: prompts.ts L80–451, smart-edit.ts L845–1009, llm-edit-fixer.ts L17–90.
- `ls routing/strategies`, `ls docs/tools`, `find packages/a2a-server/src`, `find packages/cli/src -iname '*nonInteractive*'`.
- Grep for schema sanitization (`sanitize|cleanSchema|Type.OBJECT`) → mostly telemetry/token-storage (dry for tool-schema purposes); real schema conversion lives in `agents/schema-utils.ts` and `mcp-client.ts`.
