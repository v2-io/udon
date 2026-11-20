---
source: agentic-tooling-sweep 2026-07-21 / harness-invivo — ~/src-ext/qwen-code
gathered: 2026-07-21
status: vetted mining-spot map
repo: QwenLM/qwen-code (fork), package version 0.19.12
repo_clone_date: files timestamped 2026-07-18 22:30; HEAD commit 2026-07-19 04:29 (68b4440f, PR #7190)
---

# qwen-code — in-vivo harness/CLI tooling mining map

## What this repo actually is (orientation)

`@qwen-code/qwen-code` v0.19.12 — Alibaba's Qwen-branded fork of Google's gemini-cli, but by mid-2026 it has grown FAR past gemini-cli: it now carries a large body of **Claude-Code-style agentic machinery** (skills, worktrees, plan mode, subagents/teams, a deferred-tool `tool_search`, `monitor`, `notebook_edit`, `todo_write`, cron, ACP host integration, a daemon + web-shell + chat channels). The preferred models are Qwen (DashScope) via an **OpenAI-compatible** API, with adapters for DeepSeek, Grok, MiniMax, Mistral, ModelScope, ZhipuAI, plus a separate Anthropic content-generator path. This makes it unusually good in-vivo evidence: it shows how a non-Anthropic harness re-implements the current generation of agent-tool conventions, and where OpenAI-compatible streaming forces different plumbing.

Interesting-parts are a small fraction of a very large tree. Center of mass for this sweep: **`packages/core/src/tools/`** (tool defs + schemas + descriptions), **`packages/core/src/core/prompts.ts`** (system prompts), and **`packages/core/src/core/openaiContentGenerator/`** (streaming/tool-call plumbing). A second, unexpectedly rich seam: **`docs/design/`** (~180 dated design docs, many on tooling advancements).

---

## HIGH priority — system prompts & tool-use instructions

### `packages/core/src/core/prompts.ts` (1246 lines) — the canonical system prompt
- **L215–303** — the full `getCoreSystemPrompt` body: "You are Qwen Code…", `# Core Mandates` (convention-mimicry, no-comments-by-default, denied-tool-call anti-circumvention rules), `# Task Management` (todo_write usage policy), `# Primary Workflows` (Plan/Implement/Adapt/Verify(Tests)/Verify(Standards)/ Report-faithfully), `## Tone and Style`, `## Using Your Tools`. High.
- **L282–288** — explicit "prefer dedicated tools over shell" mapping (read_file NOT cat/head/tail; edit NOT sed/awk; write_file NOT heredoc; glob NOT find; grep NOT grep/rg). Directly relevant to why an agent-facing notation needs first-class tools. High.
- **L253–254** — `<system-reminder>` and `<persisted-output>` tag conventions injected into tool results (large output spilled to disk, model told to re-read). Context-management-via-markup evidence. High.
- **L20–84** — three interaction modes (`interactive`/`headless`/`acp`) each swap the "ask questions" clause; headless = "never ask, report the blocker." Machine/agent-mode conventions. High.
- **L304–344** — sandbox-conditional prompt blocks (seatbelt/container/none) and a `# Git Repository` block (git-status-first, no `git add -A`). Medium.
- **L434–477** — the **context-overflow summarizer** prompt: emits a strict `<state_snapshot>` XML with `<primary_request_and_intent>`, `<files_and_code_ sections>`, `<all_user_messages>`, `<next_step>` etc. — a machine-readable compaction schema. High (structured-output-as-memory).
- **L485–507** — markdown project-summary prompt with `[DONE]/[IN PROGRESS]/ [TODO]` status markers. Medium.
- **L990–1028** — iterative plan-mode pair-planning prompt (the loop, asking good questions, blocked-tool handling). Medium.
- **L1152–1246** — a "QC FEATURES REFERENCE" + a self-improvement prompt that proposes JSON additions to `QWEN.md` from workflow patterns. Low-medium.

### `AGENTS.md` (root, 15KB) + `CLAUDE.md` + `.qwen/` — repo's own agent guidance
- Project-level agent instructions the harness authors themselves use; the `.qwen/skills/` (~25 skills: triage, bugfix, prepare-pr, structured-debugging, e2e-testing, autofix…) and `.qwen/agents/` show how they package agent workflows. Medium (meta: how a harness team writes for its own agents).

---

## HIGH priority — tool definitions, JSON schemas & edit-tool design

### `packages/core/src/tools/tools.ts` (976 lines) — the Tool base abstraction
- **L158–260** — `ToolBuilder`/`DeclarativeTool`/`BaseDeclarativeTool`: how every tool declares `name`, `description`, `parameterSchema`, and exposes a `@google/genai` `FunctionDeclaration` via `get schema()` using `parametersJsonSchema`. The one place that defines the schema contract. High.
- **L404–430** — `BaseDeclarativeTool.build()` runs `SchemaValidator.validate` against the JSON schema before constructing an invocation (validation before execution). High.
- **L534–615** — `hasCycleInSchema()` detects `$ref` cycles in JSON schemas (some model APIs choke on recursive schemas). Concrete schema-compat evidence. Medium.
- **L475–760+** — `ToolResult`/`ToolArtifact`/`FileDiff`/`AgentResultDisplay`/ `AnsiOutputDisplay` result-shape interfaces (how tool output is structured for the model vs. the UI). High.

### `packages/core/src/tools/edit.ts` (914 lines) — the str-replace edit tool
- **L760–800** — the edit tool **description + JSON schema**: `file_path`, `old_string`, `new_string`, `replace_all`. The canonical str-replace design: "provide ≥3 lines of context before AND after", "NEVER escape old_string", empty `old_string` = create file, multi-match fails unless `replace_all`. High (this is the reference edit-tool contract).
- **L291–313** — the failure messages the model sees (0 occurrences → "check whitespace/indentation, use read_file to verify"; >1 occurrence → "provide more context or set replace_all"). Verification-loop design. High.
- **L77, L147–211** — intelligent `$`-sequence-safe replacement + CRLF normalization before matching. Medium.
- **L344** — post-edit secret-scan over the whole resulting file (not just new_string) so a secret split across the boundary is caught. Medium.

### `packages/core/src/utils/editHelper.ts` — edit reconciliation
- **L295–369** — `normalizeEditStrings`, `maybeAugmentOldStringForDeletion`, `countOccurrences`: how LLM-proposed edits are reconciled with on-disk text (trailing-whitespace tolerance while preserving new_string intent). High (the "make fuzzy model edits land" layer).

### `packages/core/src/utils/sedEditParser.ts` + `tools/priorReadEnforcement.ts`
- `sedEditParser.ts` **L12–30+** — parses `sed s/…/…/` shell commands into a structured `SedEditInfo` (so a shell-issued sed edit can be routed through the file-history/diff machinery instead of opaque shell). Novel. Medium.
- `priorReadEnforcement.ts` **L57–209** — `checkPriorRead()` **blocks edit/write unless the file was read first** (`PriorReadDecision`, "re-run read_file before editing"). A hard read-before-write invariant. High.

### `packages/core/src/tools/read-file.ts` (671 lines) — read tool
- **L67–116** — schema: `file_path`, `offset`, `limit`, **`pages`** (PDF page ranges, `PDF_MAX_PAGES_PER_READ`). Line-window + PDF + image/vision handling. High.
- **L180–270** — "full read" detection (no offset/limit/pages) vs truncated read; binary/image/audio/video/PDF/notebook branch flags; truncation semantics distinct from "fully read." Context-budget-aware reading. Medium.

### `packages/core/src/tools/write-file.ts` (808 lines) & `shell.ts` (210KB!)
- `shell.ts` **L4868–4986** — shell tool description + schema (`command`, `is_background`, `timeout` max 600000, `description`, `directory`); explicit background-vs-foreground guidance table, "don't use shell for file ops", `task_stop` instead of `pkill`. High.
- `shell.ts` **L369–398, L558–870, L1155+** — a very large **command-safety static analyzer**: exit-status parsing, git-subcommand/cwd-change detection, commit-context detection, blocked-sleep-pattern detection, `env`/`sudo`/`git` cwd-relocation flag awareness. Deep evidence of shell-command guardrails. High.

### `packages/core/src/tools/tool-names.ts` — the canonical tool roster
- Enumerates every built-in tool name; fastest index of the full toolset (edit, read_file, write_file, glob, grep, ripgrep, ls, shell, web_fetch, web_search, todo_write, task_*, team_*, cron_*, agent, skill, monitor, notebook_edit, lsp, send_message, ask_user_question, enter/exit_plan_mode, enter/exit_worktree, record_artifact, tool_search…). High (map/index).

---

## HIGH priority — deferred tools, streaming & structured output

### `packages/core/src/tools/tool-search.ts` (625 lines) — deferred-tool loading
- **L8–20, L115–130** — `ToolSearch`: tools can be **deferred** (name known, schema withheld to save tokens); the model calls `tool_search` with `select:<name>` or free-text keywords to fetch `FunctionDeclaration`s into the next request, returned inside a `<functions>` block. This is the exact context-budget-vs-tool-count mechanism (mirrors the harness running THIS sweep). High.
- **L162–405** — truncation to avoid loading unbounded schemas, keyword fuzzy scoring over name/description, `</functions>`-injection sanitization. Medium.

### `packages/core/src/core/openaiContentGenerator/streamingToolCallParser.ts`
- **L12–80+** — `StreamingToolCallParser`: reassembles tool calls that arrive as fragmented/interleaved chunks over OpenAI-compatible streaming — handles missing IDs/names, **index collisions**, partial JSON, and **auto-repairs** unclosed JSON strings (`repaired` flag). The gritty reality of getting structured tool calls out of a streaming non-Anthropic API. High.

### `packages/core/src/core/openaiContentGenerator/taggedThinkingParser.ts`
- **L11–24+** — parses `<think>`/`<thinking>` reasoning tags out of the text stream (binary mode toggle; MiniMax/DeepSeek reasoning-token handling). Medium.

### `packages/core/src/core/openaiContentGenerator/` (dir) + `provider/`
- `converter.ts`, `pipeline.ts` — Gemini↔OpenAI request/response conversion and the streaming pipeline; `provider/{dashscope,deepseek,grok,minimax,mistral, modelscope,zai}.ts` each patch per-vendor tool-call/schema quirks. Per-model tool-compat evidence. Medium-high (breadth of "how different models emit tools").

### `docs/design/structured-output/structured-output.md`
- The `--json-schema` headless feature: constrain the model's FINAL answer to a caller-supplied JSON Schema and emit validated machine-readable output for downstream scripts. Agent-mode structured output. High. (User-facing: `docs/users/features/structured-output.md`.)

### `packages/core/src/output/types.ts`
- **L11–17** — `InputFormat`/`OutputFormat` enums incl. `json` and **`stream-json`** (NDJSON agent I/O). Machine-readable I/O conventions. Medium.

---

## MEDIUM priority — subagents, tasks, plan mode, other agent-facing tools

### `packages/core/src/subagents/builtin-agents.ts`
- **L31–116** — built-in subagent **system prompts**: `general-purpose` ("don't expand scope"), **`Explore`** (READ-ONLY, strictly prohibited from writing, "fast agent, return quickly"), a status-line setup agent. Shows delegation-prompt design + read-only enforcement via tool-omission (ask_user_question deliberately absent). High for delegation patterns.
- `subagents/agent-frontmatter-schema.ts` — YAML frontmatter schema for user-defined agents (`.md` agent files). Medium.

### `packages/core/src/tools/` — the Claude-Code-parity agent tools
Each is a self-contained tool def + schema worth a look for schema style:
- `todoWrite.ts` (L…) — task-tracking tool schema. `enterPlanMode.ts`/ `exitPlanMode.ts` — plan-mode tool contracts + approval. `askUserQuestion.ts` — structured multiple-choice question tool. `monitor.ts` (29KB) — wait-on- condition tool. `notebook-edit.ts` — Jupyter cell edit tool. `send-message.ts` — inter-agent messaging. `record-artifact.ts` — artifact capture. `enter-worktree.ts`/`exit-worktree.ts` (22KB) — git-worktree session tools. `cron-*.ts`, `task-*.ts`, `team-*.ts` — scheduling + multi-agent orchestration. All medium; pick by the specific tool-design question.
- `mcp-tool.ts`, `mcp-client.ts` (77KB), `mcp-client-manager.ts` (141KB), `mcp-transport-pool.ts` — MCP client/tool integration at scale. Medium (if MCP tool-schema handling is the question).
- `tool-registry.ts` (32KB) — how tools are registered/filtered/surfaced to the model (allowlists, per-mode filtering). Medium.

### `docs/design/` (~180 dated design docs, 2026-05 → 2026-07) — advancement seam
Notably tooling-relevant (dates = provenance, most "Implemented"):
- `2026-07-17-adaptive-tool-call-cap.md` — replaces blunt 100-tool-calls/turn circuit breaker with an adaptive cap. High (recent advancement).
- `2026-07-16-subagent-prompt-guardrails.md` — rewrites Agent/Explore/fork prompts to fix "trust subagent output" + unsafe guidance. High.
- `2026-07-16-default-background-subagents.md`, `fork-subagent/` — subagent execution model. Medium.
- `2026-07-11-tool-call-preparing-events.md` — streaming tool-call lifecycle events. Medium. `tool-use-summary.md` + `users/features/tool-use-summaries.md` — condensing tool output for context. High (context-management).
- `2026-06-15-simulated-sed-file-history.md`, `2026-06-13-file-history-snapshot- persistence.md` — edit/undo history model. Medium.
- `2026-07-11-managed-memory-microcompaction.md`, `auto-compaction-threshold- redesign.md`, `compaction-image-stripping/` — context-window management. High.
- `2026-07-13-pdf-vision-bridge-fallback.md` — PDF→vision read fallback. Medium.
- `markdown-syntax-extension.md`, `2026-07-14-markdown-syntax-extension` (users: `markdown-rendering.md`) — markdown handling extensions. Medium (UDON-adjacent).
- `2026-06-30-unified-reasoning-effort-cli.md` — reasoning-effort CLI flag. Low.
- `shell-safety-classification.md`, `shell-timeout-error-semantics.md`, `2026-06-12-session-shell-permission-policy.md` — shell guardrail design. Medium.

### `docs/users/features/` — user-facing feature docs (secondary but readable)
- `headless.md`, `structured-output.md`, `dual-output.md`, `sub-agents.md`, `tool-use-summaries.md`, `token-caching.md`, `hooks.md`, `mcp.md`, `worktree.md`, `computer-use.md`, `lsp.md` — concise per-feature explanations; good fast orientation before diving into the `src` implementation. Medium.

---

## Dry wells / notes
- `packages/core/src/prompts/` (the dir) is NOT where the system prompt lives — it's a tiny `prompt-registry` for MCP prompts (`mcp-prompts.ts` is 467 bytes). The real prompts are in `core/prompts.ts`. Logged so the next miner doesn't chase the directory name.
- No single JSON file of all tool schemas — schemas are declared inline per-tool in each `tools/*.ts` constructor (`parametersJsonSchema`). Enumerate via `tools/tool-names.ts` then read each tool file.
- `packages/{desktop,webui,web-shell,channels/*,audio-capture,cua-driver, mobile-mcp,zed-extension,vscode-ide-companion}` are product surface, not tool-design — skipped as out of scope for this question.
- `CHANGELOG.md` is 344KB — not read; if version-history of a specific tool is needed it's there but low-yield for schema/design questions.

## Searches / commands run
- `git log -1`, `git branch` → HEAD 2026-07-19, version 0.19.12, files stamped 2026-07-18.
- `find packages/core/src -type d` + `ls tools/` → tool inventory (130 files).
- `grep` for `schema|description|parameters|abstract class` in tools.ts; `old_string|replace_all|description` in edit.ts; shell description block L4868+.
- `grep -n` for prompt section headers in core/prompts.ts; read L215–344, L434–507.
- `ls core/openaiContentGenerator/` + head of streamingToolCallParser.ts, taggedThinkingParser.ts.
- `grep STREAM_JSON` output/types.ts; `ls docs/design/` + `docs/users/features/`.
- `grep 'You are' subagents/builtin-agents.ts`.
- Dry-well greps: `response_format|json_schema|responseSchema` in core/providers/ output → no hits (structured output is `--json-schema` headless, in docs/design, not a provider response_format field).
