---
source: harness-in-vivo sweep — MoonshotAI/kimi-code (agent CLI harness)
gathered: 2026-07-21
status: vetted mining-spot map
repo: ~/src-ext/kimi-code
repo_provenance: git remote github.com/MoonshotAI/kimi-code; HEAD a41a09c (2026-07-19, "feat(cli): replace the kimi server command tree with kimi web"); working-tree files dated 2026-07-18 (clone date). TypeScript/pnpm monorepo.
center_of_mass: packages/agent-core-v2/src — the v2 agent loop. (packages/agent-core is the v1 predecessor; agent-core-v2 is where all current tool/prompt design lives. All paths below are relative to packages/agent-core-v2/src/ unless noted.)
---

# Kimi Code — in-vivo agent harness mining map

Moonshot AI's own coding-agent CLI. Native model is Kimi (K2), but the harness
is multi-provider (Kimi, OpenAI chat/responses/legacy, Anthropic, Google GenAI).
The interesting fraction is a small slice of a large monorepo: the tool
contracts, the `.md` tool-description prompts (loaded via `?raw` imports), the
system prompt, and the provider wire adapters. Tool descriptions live as
**Markdown files next to each tool's `.ts`**, so the prompt text is
version-controlled prose, not string literals — grep target: `find . -name '*.md' | grep -v test`.

## Tier 1 — tool contracts, schemas, edit-tool design (highest value)

- **`tool/toolContract.ts`** (235 lines) — HIGH. The core tool model. Beyond the
  usual name/description/parameters, defines a **`ToolAccesses` resource-access
  declaration** (`ToolFileAccess` with read/write/readwrite/search operations +
  recursive flag) that each tool execution emits so the host scheduler can run
  **non-conflicting tool calls concurrently**; lines 178–229 implement the
  path-overlap + read-vs-write conflict semantics. Also `ExecutableToolResult`
  (success/error union with `stopTurn`, `truncated`, `note`, `delivery` steer),
  streaming `ToolUpdate` (stdout/stderr/progress/status/custom), and
  `resolveExecution → ToolExecution → execute(ctx)` two-phase contract. Date: 2026-07 tree.
  *This concurrency-by-declared-resource-access model is a genuine tooling advancement worth noting.*

- **`tool/input-schema.ts`** (44 lines) — HIGH. `toInputJsonSchema()`: renders
  zod v4 → JSON Schema in **`io:'input'` view** (draft-7) specifically to fix
  the "field carries `.default()` yet gets marked `required`" bug that makes
  AJV reject legal calls; forces `additionalProperties:false` on every object
  node so unknown args are rejected. Concrete, load-bearing lesson about
  tool-arg schema generation. Date: 2026-07 tree.

- **`app/edit/tools/edit.ts`** (142 lines) + **`app/edit/tools/edit.md`** (13 lines) — HIGH.
  The edit tool is **exact string replacement** (`old_string`/`new_string`/`replace_all`),
  Anthropic-style str-replace, NOT diff/patch. The `.md` is a tight rules prose:
  "Edit is mandatory for every incremental change… DO NOT use Write or Bash sed";
  "Read before every Edit"; uniqueness-or-`replace_all`; "DO NOT issue consecutive
  Edit calls on the same file" (a prior edit invalidates a later `old_string`).
  The `.ts` declares `ToolAccesses.readWriteFile` + a `file_io/edit` display with
  before/after. Date: header says "Ported from v1". 

- **`app/edit/editService.ts`** (51 lines) + `fileEditService.ts`, `textModel.ts` — MEDIUM-HIGH.
  The pure edit logic: uniqueness check, occurrence counting, and the exact
  user-facing error strings ("old_string not found… use the Read Tool to reload",
  "old_string is not unique… set replace_all=true"). Also the **CRLF handling**:
  raw file normalized to LF for matching, re-materialized to original line-ending
  style on write (documented at top of `tools/edit.ts`). Date: 2026-07 tree.

- **`os/backends/node-local/tools/read.ts`** (524 lines) + **`read.md`** (17 lines) — HIGH.
  Read tool: `<line-number>\t<content>` output format; 1000-line / KB caps;
  `line_offset`/`n_lines` pagination incl. **negative offset = tail mode**;
  refuses `.env`/SSH-key/secret files (with `.env.example` etc. exempted);
  UTF-8-only. Rides a **`<system>…</system>` status block** on the `note` side
  channel summarizing lines/bytes read, truncation, line-ending notes. The `.md`
  explicitly discourages "re-read to prove the write landed" and instructs
  parallel multi-file reads. Date: 2026-07 tree.

- **`os/backends/node-local/tools/write.md`** (11 lines) — MEDIUM-HIGH. Write-tool
  policy prose: Write forbidden for incremental edits (use Edit); creates missing
  parent dirs; **"Do not create unsolicited documentation files"**; chunking rule
  (overwrite first chunk then append) — never chunk-Write to modify existing.

- **`os/backends/node-local/tools/bash.ts`** (549 lines) + **`bash.md`** (43 lines) — HIGH.
  Bash tool. The `.md` is a strong "translate to a dedicated tool" table
  (cat/head/tail→Read, sed/awk→Edit, find/ls→Glob, grep/rg→Grep, echo→text),
  with the *why* ("keeps raw stdout out of the conversation"). Background-task
  model: `run_in_background`, task IDs, `TaskOutput`/`TaskStop`, timeout→background
  promotion, auto-notify on completion. Parallel-vs-chained command guidance
  (`&&` only for genuine dependencies; independent reads as parallel calls).
  Fresh-shell-per-call (no cwd/env persistence). Date: 2026-07 tree.

- **`os/backends/node-local/tools/grep.md`** (9 lines) + **`glob.md`** (16 lines) — MEDIUM.
  ripgrep-backed Grep/Glob. Grep: ripgrep-regex (not POSIX), searches dotfiles by
  default, `include_ignored` flag, always skips secrets. Glob: files-only (never
  dirs), gitignore-respecting, 100-match cap, good/bad pattern examples, the
  "avoid node_modules/** floods" caveat. Practical tool-boundary design.

## Tier 2 — system prompt & agent-mode conventions

- **`app/agentProfileCatalog/system.md`** (158 lines) — HIGH. The full system
  prompt, Jinja-templated (`{{ KIMI_OS }}`, `{{ KIMI_WORK_DIR }}`, `{{ KIMI_AGENTS_MD }}`,
  `{% if %}` blocks). Sections: Language (reply in user's language even after long
  English tool output), **Prompt and Tool Use** (task-vs-question default, "one
  short 8–10-word sentence before non-trivial tool calls", `path:line` citation
  convention, **strong parallel-tool-call encouragement**), the **`<system>` vs
  `<system-reminder>` tag semantics** (latter = authoritative directives that
  override normal behavior), Context Management (auto-compaction contract from the
  model's POV), Working Environment (secret-file guards per tool, sandbox warning),
  Project Information (AGENTS.md treated as untrusted reference data, explicit
  prompt-injection precedence rules), and "Ultimate Reminders" (verify-before-done,
  no-placeholder-stubs, candor). Date: 2026-07 tree. *Dense, current, real.*

- **`app/agentProfileCatalog/promptPrefix.ts`** — MEDIUM. Assembles the per-profile
  prompt prefix (role-additional injection point `{{ ROLE_ADDITIONAL }}`). Pair
  with `session/agentLifecycle/profile/explore-overlay.md` (23 lines, the "explore"
  read-only subagent profile) and `session/sessionInit/profile/init.md` (21 lines).

- **`agent/prompt/prompt.ts` / `promptService.ts` / `promptStepRequests.ts`** — MEDIUM.
  The prompt-assembly service (how system prompt + tools + history + reminders are
  composed into a provider request each step). Entry point for "how the harness
  actually builds the model call." Not yet deep-read; flagged as the assembly seam.

## Tier 3 — advanced agent-loop tooling (advancements)

- **`agent/toolSelect/`** (toolSelect.ts, dynamicTools.ts, tools/select-tools.ts,
  flag.ts) — HIGH. **Progressive tool disclosure / dynamic tool loading**: a
  `select_tools` meta-tool lets the model load deferred tool schemas on demand
  (MCP tools loaded lazily). `dynamicTools.ts` header documents the two protocol
  message kinds (`dynamic_tool_schema` system messages + `<tools_added>/<tools_removed>`
  reminders) and how they survive/reconcile across history-undo/compaction. Directly
  relevant to "context-management around tool results." Date: 2026-07 tree.

- **`agent/toolResultTruncation/toolResultTruncation.ts`** — HIGH. Oversized tool
  results are persisted to agent-scoped storage and the inline model-visible payload
  is replaced with a **recoverable preview + `output_path`**. The context-window
  management pattern for large tool outputs. Date: 2026-07 tree.

- **`agent/toolDedupe/toolDedupe.ts`** (+ service) — MEDIUM-HIGH. Per-turn tool-call
  **deduplication**: suppresses same-step duplicate calls and injects cross-step
  "you already ran this" repeat reminders, wired via the executor will/did hooks.
  Loop-quality tooling. Date: 2026-07 tree.

- **`agent/toolExecutor/`** (toolExecutor.ts, toolScheduler.ts, toolHooks.ts,
  toolExecutorEvents.ts) — MEDIUM-HIGH. The execution engine: scheduler uses the
  `ToolAccesses` conflict semantics to run non-conflicting calls concurrently;
  will/did hook system that dedupe + truncation plug into. The concrete "how a
  batch of tool calls is actually run" seam. Date: 2026-07 tree.

- **`agent/fullCompaction/compaction-instruction.md`** (78 lines) — HIGH. The
  full prose the model is handed when context is about to overflow: write a
  first-person handoff note (what the request asks, constraints in force, exact
  commands/paths/results done, what's unknown, the forward plan). A polished,
  battle-tested compaction/handoff prompt worth reading whole. Date: 2026-07 tree.

- **`agent/plan/tools/enter-plan-mode.md`** (26) + **`exit-plan-mode.md`** (25) +
  `agent/plan/injection/*.md` — MEDIUM-HIGH. **Plan mode**: read-only-enforced
  planning phase, plan written to a file (not passed as a param), `ExitPlanMode`
  reads it for approval; permission-mode-conditional behavior (auto/yolo/manual).
  Agent-mode convention design. Date: 2026-07 tree.

- **`session/subagent/tools/agent.md`** (16) + **`agent/swarm/tools/agent-swarm.md`** (11) — HIGH.
  **Subagent delegation + swarm.** `agent.md` is a compact peer-delegation brief
  ("brief it like a colleague who just walked in", "do not delegate understanding",
  resume-by-id, 2h timeout). `agent-swarm.md`: launch up to **128 subagents** from
  a `{{item}}` template over `items`, resume-map for failed/timed-out agents,
  distinctness enforcement, must-be-sole-tool-call constraint. Date: 2026-07 tree.

- **`agent/questionTools/tools/ask-user.md`** (21) — MEDIUM-HIGH. **Structured
  user-question tool**: 1–4 questions, 2–4 options each, multi_select, "(Recommended)"
  convention, JSON `answers` result keyed by question text, explicit dismissal
  semantics. Structured-interaction design. Date: 2026-07 tree.

- **`agent/goal/`** (tools/create-goal.md 20, update-goal.md, set-goal-budget.md,
  get-goal.md; injection/goal-*-reminder.md) + **root `GOAL.md`** (11.6KB, Chinese)
  — MEDIUM. A **durable-goal / autonomous-multi-turn state machine** (active/paused/
  blocked/complete, token budgets, machine-readable completion criteria). `GOAL.md`
  is the design doc. Relevant as "agent-mode autonomy conventions." Date: 2026-07 tree.

- **`session/todo/tools/todo-list.md`** (30) — LOW-MEDIUM. Structured TODO tool with
  the familiar one-in_progress-at-a-time / never-done-if-tests-red discipline.

## Tier 4 — provider wire adapters (structured-output & streaming)

- **`app/llmProtocol/providers/kimi-schema.ts`** (433 lines) — HIGH. Kimi's own
  **tool-schema normalization**: `normalizeKimiToolSchema` = `derefJsonSchema`
  (inline all `$ref`/`$defs`, cycle-safe) + `ensureKimiPropertyTypes` (fills missing
  `type` on schema nodes). Concrete evidence that the native model needs
  **fully-dereferenced, type-complete** JSON schemas — a real interop lesson for
  anyone defining tool schemas for K2. Date: 2026-07 tree.

- **`app/llmProtocol/providers/chat-completions-stream.ts`** (97 lines) — HIGH.
  The **streaming tool-call reassembly** logic: buffers OpenAI-style
  `tool_call` deltas by stream index, emits a header (`type:'function'`) once the
  name is known then `tool_call_part` argument fragments. The exact
  incremental-tool-call parsing every harness needs. Date: 2026-07 tree.

- **`app/llmProtocol/providers/kimi.ts`** (589 lines) — MEDIUM-HIGH. The Kimi
  provider (OpenAI-SDK-based): request building, streaming, tool conversion,
  tool-call-id sanitization, file uploads. The in-vivo "how tools reach the native
  model" path. Date: 2026-07 tree.

- **`app/llmProtocol/providers/anthropic.ts`** (1149) + **`anthropic-profile.ts`** (153) — MEDIUM.
  Anthropic adapter + a **model-capability matrix** (opus/sonnet/haiku/fable/mythos
  families, thinking-effort levels incl. low/medium/high/xhigh/max, budget-vs-adaptive
  thinking modes, cites platform.claude.com effort/extended-thinking docs). Useful
  cross-provider tool_use/streaming reference. Date: 2026-07 tree.
  (Also present: `openai-responses.ts` 1140, `openai-legacy.ts` 631, `google-genai.ts` 857
  — parallel adapters; MEDIUM/LOW, read if cross-provider tool-encoding matters.)

- **`app/llmProtocol/tool.ts`** (13) + `message.ts` (150) + `provider.ts` (105) — MEDIUM.
  The provider-neutral `Tool`, `ToolCall`, `Message`, `StreamedMessagePart`,
  `ResponseFormat` types — the abstraction all adapters normalize to.

## Tier 5 — protocol / host-UI contract & ACP

- **`packages/protocol/src/display.ts`** (162 lines) — MEDIUM. `ToolInputDisplaySchema`:
  a discriminated union (`command`/`file_io`/`diff`/`search`/`url_fetch`/`agent_call`…)
  describing how each tool call renders in the host UI — the structured, machine-readable
  per-tool display contract. Date: 2026-07 tree.

- **`packages/protocol/src/events.ts`** (1833) + `ws-control.ts` (617) + `session.ts` — LOW-MEDIUM.
  The full WS/session event protocol between core and clients. Large; relevant only
  if the streaming/event envelope (not the tool design) is the question.

- **`packages/acp-adapter/src/`** (session.ts 1656, server.ts 1116, events-map.ts 527,
  convert.ts, approval.ts) — LOW-MEDIUM. Adapter to the **Agent Client Protocol**
  (editor integration, e.g. Zed). `convert.ts`/`events-map.ts` map internal tool
  events to ACP tool-call updates — a real "expose agent tools over a standard
  protocol" example if that angle matters.

## Root docs (orientation, not deep evidence)

- **`AGENTS.md`** (11KB) — LOW-MEDIUM. Repo-level agent guide (working principles,
  project map, monorepo maintenance, coding rules). `CLAUDE.md` is a symlink to it.
- **`README.md`** (5.4KB), `CONTRIBUTING.md` — LOW. Standard project docs.

## Dry wells / deliberately skipped

- `packages/agent-core/` (v1) — superseded by agent-core-v2; same shapes, older.
  Skipped except as the port-source noted in edit.ts. Not separately listed to avoid padding.
- `apps/` (kimi-code TUI, kimi-web, kimi-inspect, vis, vscode) — UI/rendering, not
  tool/prompt design. `apps/kimi-code/test/tui/components/messages/tool-renderers/`
  is display-only. Skipped.
- `packages/{kaos,kap-server,klient,minidb,oauth,telemetry,node-sdk,pi-tui,migration-legacy}`
  — infra (DB, server, TUI toolkit, auth, telemetry). Not tool-use evidence. Skipped.
- `packages/kosong` — "LLM abstraction layer" per its README, but the live abstraction
  used at runtime is in agent-core-v2/app/llmProtocol; kosong is a thin published-package
  facade. LOW; not deep-read.
- `pnpm-lock.yaml` (674KB), `flake.nix`, build config — not evidence.

## Searches / commands run
- `git log -1`, `git branch`, `git remote -v` → provenance (HEAD 2026-07-19, clone 2026-07-18).
- `ls packages apps plugins`; `find packages apps -type d -iname '*tool*'/'*prompt*'/'*agent*'/'*edit*'` → located center of mass in agent-core-v2.
- `find agent-core-v2/src -path '*tool*' -name '*.ts'` (non-test) + `-ipath '*prompt*'` → tool/prompt inventory.
- `find . -name '*.md' | grep -v test | xargs wc -l | sort -n` → the `.md` tool-description corpus (key discovery: descriptions are `?raw`-imported Markdown files).
- Read whole: toolContract.ts, input-schema.ts, edit.ts, editService.ts(partial), system.md, compaction-instruction.md, chat-completions-stream.ts, kimi-schema.ts(partial), display.ts(partial); cat'd edit/read/write/bash/grep/glob/plan/todo/agent/swarm/ask-user/create-goal `.md`; grep'd read.ts for the `<system>` status block.
- `find app/llmProtocol -name '*.ts' | wc -l sort` → provider adapter sizes.
- Dry-well confirmations via `ls`/`head`: kosong README, GOAL.md (Chinese design doc), acp-adapter file sizes.
