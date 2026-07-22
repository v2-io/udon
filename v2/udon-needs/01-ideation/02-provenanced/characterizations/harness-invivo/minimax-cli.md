---
source: parallel gathering sweep (2026-07-21) — harness/CLI in-vivo evidence, area = ~/src-ext/minimax-cli
gathered: 2026-07-21
status: vetted mining-spot map
repo: minimax-cli (mmx) — MiniMax AI platform CLI + TypeScript SDK
repo_provenance: HEAD 3615170 dated 2026-07-19 02:18 (+0800); history spans 2026-03-26 → 2026-07-19; Bun-native, TypeScript strict, ESM
---

# minimax-cli (`mmx`) — mining-spot map

## What this repo actually is (read before mining)

`mmx` is a **thin API-client CLI + SDK** for the MiniMax platform (text/chat,
image, video, music, speech, vision, web-search, quota, files). It is **not** a
coding-agent harness — there is **no edit-tool, no diff/str-replace, no
agentic tool-execution loop, no file-editing at all**. That means the usual
"gold" (edit-tool design, verification, context management around tool results)
is a **dry well here** — say so plainly. See the dry-well log at bottom.

**Where the relevant center of mass actually is** — two things, both genuinely
useful to a document/notation-for-agents project:

1. **The CLI-as-agent-tools story:** the text/chat surface speaks the
   **Anthropic Messages API** wire format verbatim (tool_use / tool_result /
   input_schema / tool_choice), *and* the CLI can auto-emit its own commands as
   **Anthropic/OpenAI-compatible JSON tool schemas** (`config export-schema`).
   So this repo is a worked example of "a CLI presenting itself to an agent as
   a set of typed tools."
2. **Agent-mode CLI conventions:** an explicit machine-facing contract —
   non-interactive detection, `--output json`, clean-stdout/`--quiet`,
   structured JSON errors keyed to a fixed exit-code table, `--dry-run` request
   preview, async task-ID + polling. This is the "how a CLI behaves for a
   non-human caller" material.

---

## High priority

### `src/types/api.ts` (lines 1–88) — the Anthropic Messages wire, in types
The chat surface is typed as the **Anthropic Messages API**: `ContentBlock`
union (`text` / `thinking` / `tool_use` {id,name,input} / `tool_result`
{tool_use_id,content}), `ChatTool` = {name, description, `input_schema`},
`ChatRequest.tool_choice` = {type: 'auto'|'any'|'tool', name?}, and the full
streaming event union (`message_start`, `content_block_start/delta/stop`,
delta subtypes `text_delta`/`thinking_delta`/`input_json_delta`,
`message_delta`, `message_stop`). This is the exact JSON schema a MiniMax-M3
agent tool-call rides on. Date: 2026-07-14. **Priority: high** — canonical
example of the tool-use/streaming block vocabulary a notation would need to
round-trip.

### `src/commands/config/export-schema.ts` (full, 57 lines) — CLI commands → JSON tool schemas
`mmx config export-schema [--command "<name>"]` walks the command registry and
emits each command as an **"Anthropic/OpenAI-compatible JSON tool schema"**
(name `mmx_<command>`, `input_schema` object), explicitly skipping
auth/config/update as "not suitable as Agent tools." The stated purpose (SKILL
line 167): "dynamically register mmx commands as tools in your agent
framework." Date: 2026-04-08. **Priority: high** — a shipping instance of a
tool auto-describing itself to an agent.

### `src/utils/schema.ts` (full, 79 lines) — the flag→JSON-Schema inference rules
Backs the export above: `parseFlag` infers types from flag *spelling*
(no `<...>` ⇒ boolean like `--stream`; `<n>`/`<hz>`/`<bps>`/`<count>` ⇒ number;
"repeatable" in description ⇒ array), `generateToolSchema` builds
`{name, description, input_schema:{type:object, properties, required}}` with
explicit `OptionDef.type` overriding inference. Date: 2026-04-08.
**Priority: high** — the concrete heuristics for turning a human CLI surface
into a machine tool schema (directly relevant to notation-driven tool defs).

### `skill/SKILL.md` (440 lines; key sections below) — the agent-facing usage contract
This is the model-facing skill doc (YAML frontmatter name/description). Mine:
- **"Agent Flags"** (~lines 44–56): the canonical non-interactive kit —
  `--non-interactive` (fail fast vs prompt), `--quiet` (pure-data stdout),
  `--output json`, `--async`, `--dry-run`, `--yes`.
- **"Tool Schema Export"** (~155–167): documents `config export-schema` for
  agent frameworks.
- **"Exit Codes"** (~171) and **"Piping Patterns"** (~185–205): "stdout is
  always clean data — safe to pipe," `| jq '.content'`, chain examples
  (generate image → describe it), async task-ID → `video task get`.
- **"Configuration Precedence"** (~206): flags → env → config file → defaults.
Date: 2026-07-16. **Priority: high** — a compact, explicit statement of the
human-vs-agent behavioral split, written *for* the model.

### `src/commands/text/chat.ts` (full, 326 lines) — tool pass-through + streaming consumption in vivo
The chat command: `--tool <json-or-path>` (repeatable) accepts a tool def as
inline JSON or a file, parsed into `body.tools` (lines 219–237); message
parsing supports `role:` prefixes and `--messages-file -` (stdin JSON)
(97–147); streaming loop consumes Anthropic SSE, routing `thinking` blocks to a
spinner on **stderr** while `text_delta` goes to **stdout** (264–308), with
`thinking_delta` deliberately dropped; `--dry-run` prints the request body
instead of sending (239–242); output-format/stream decision keys off TTY +
`--output json` (201–213). **Note the honest limit:** tools are *forwarded to
the API* but the CLI never executes a returned `tool_use` or loops — no agent
loop here. Date: 2026-07-16. **Priority: high** — shows exactly how tool defs
enter and how a mixed thinking/text/tool stream is demuxed for a terminal.

---

## Medium priority

### `src/errors/handler.ts` (full, ~130 lines) + `src/errors/codes.ts` (13 lines) — structured errors + fixed exit codes
`ExitCode` is a fixed table (0 success, 1 general, 2 usage, 3 auth, 4 quota,
5 timeout, 6 network, 10 content-filter). `handleError` emits **JSON errors to
stderr** when output format is json (`{error:{code,message,hint}}` via
`json.ts:formatErrorJson`), else human text with hint + "(exit code N)";
classifies timeout/network/filesystem errors into codes with actionable hints.
Dates: handler 2026-05-11, codes earlier. **Priority: medium** — a clean
machine-consumable error contract (code + structured body) for a non-human
caller.

### `src/errors/api.ts` (lines 1–60+) — HTTP/base_resp status → exit-code + hint mapping
`mapApiError` folds both HTTP status and MiniMax's `base_resp.status_code`
envelope into `CLIError`s: 401/403→AUTH, 429→QUOTA, 408/504→TIMEOUT, plus
plan-tier hints inferred from URL path. Date: within repo range.
**Priority: medium** — dual error-channel (HTTP + in-body `base_resp`)
normalization, a pattern any structured-API notation hits.

### `src/utils/env.ts` (full, 38 lines) — interactive vs agent/CI detection
`isInteractive()` returns false on non-TTY stdin/stdout, `--non-interactive`,
or `CI` env; `isCI()` checks GITHUB_ACTIONS/GITLAB_CI/JENKINS/TRAVIS/CIRCLECI.
This is the switch that makes commands prompt a human vs fail-fast for an agent.
**Priority: medium** — the concrete "am I talking to a machine?" heuristic.

### `src/client/stream.ts` (full, 82 lines) — hand-rolled SSE parser
Generic `parseSSE(Response)` async-generator: buffers, splits on `\n`, handles
`\r`, multi-line `data:` concatenation, comment lines (`:`), flushes trailing
event. Consumed by chat/repl to decode Anthropic streaming. **Priority: medium**
— reference SSE-frame handling for streamed structured events.

### `src/sdk/text/index.ts` (full, 63 lines) — SDK chat surface + streaming overloads
`TextSDK.chat` overloaded: `{stream:true}` returns `AsyncGenerator<StreamEvent>`,
else `Promise<ChatResponse>`; validates messages non-empty; defaults model
`MiniMax-M3`, max_tokens 4096; enforces SSE content-type. **Priority: medium** —
the programmatic (non-CLI) tool-call/stream entry point.

### `src/polling/poll.ts` (lines 1–50+) — async-task polling contract
Generic `poll()` with `isComplete`/`isFailed`/`getStatus` predicates, interval
+ deadline, spinner suppressed under `--quiet`; failure surfaces `base_resp`
status_msg. Backs `--async`/`--no-wait` + `video task get`. **Priority: medium**
— the "return task-id now, poll later" agent pattern for long-running work.

### `docs/cli-design.md` (full, 64 lines) — the design contract in one page
`resource + verb` command grammar, the exit-code table, credential-resolution
order, config precedence. Date: 2026-07-16. **Priority: medium** — concise
statement of the CLI's machine-facing conventions (partial command tree, but
the grammar/exit-code/precedence rules are authoritative).

---

## Low priority

### `src/commands/text/repl.ts` (601 lines) — interactive TUI chat
Raw-mode line editor, slash-commands (`/system`, `/model`, `/save`, `/history`),
ANSI rendering. **Human**-facing conversational loop; **no** tool_use handling
(grep confirmed zero tool/tool_use/tool_choice references). **Priority: low** —
useful only as a contrast (the interactive half of the human/agent split).

### `src/commands/text/chat.ts` ThinkingIndicator (lines 25–90) — thinking-stream UX
HSL color-cycling braille spinner driven by `thinking` blocks; `thinking_delta`
text is intentionally *not* printed. **Priority: low** — a UX choice about
hiding reasoning tokens from terminal output; minor but a real "what to do with
the thinking channel" decision.

### `SDK.md` (206 lines) — SDK usage docs
Per-module examples (text/image/video/speech/music/vision/search/quota). The
text streaming example (lines 42–44) shows `event.choices[0]?.delta?.content`
— an **OpenAI-shaped** access pattern that contradicts the Anthropic-shaped
`StreamEvent` in `types/api.ts`; likely stale doc. **Priority: low** — mostly
media-generation ergonomics, not tool-use; noted for the one inconsistency.

### `AGENTS.md` (205 lines) — contributor guide (not in-vivo tool use)
Build/lint/test commands, TS style, error-hierarchy, command-definition
pattern. This is guidance for *coding agents editing this repo*, not evidence
of tool-use-at-runtime. **Priority: low** — a specimen of an AGENTS.md
convention file, nothing about UDON's target problem.

---

## Dry wells (checked, genuinely absent)

- **Edit tools / diffs / str-replace / patch / file-write tooling** — none. The
  CLI writes only downloaded media (`src/files/download.ts`) and `/save`
  transcripts; no code/document editing surface exists. This was the assigned
  "gold" and it is absent — the repo doesn't do that class of work.
- **Agentic tool-execution loop** — none. `--tool` and `tools` are forwarded to
  the MiniMax API but no returned `tool_use` is ever executed or fed back
  (`grep` for tool_result usage: only the type def in `api.ts`, never
  constructed/consumed).
- **System prompts / prompt templates baked into the harness** — none; `--system`
  is pure pass-through of user text. No embedded agent instructions.
- **Structured-output / JSON-schema constrained generation (response_format
  for text)** — none for chat; `response_format` appears only on the *image*
  endpoint (url|base64), not as JSON-schema output constraint.
- **Context-management around tool results** — N/A (no tool loop, no history
  compaction beyond the REPL's in-memory message array).

## Searches / commands run

- `git log -1` (HEAD 3615170, 2026-07-19), full-tree `find` (168 non-git files),
  `git log` first commit 2026-03-26.
- `grep -rniE "tool_call|tool_choice|function_call|functions|json_schema|response_format|structured|agent"` over `src/**.ts` → hits concentrated in `types/api.ts`, `commands/text/chat.ts`, `commands/config/export-schema.ts`, `utils/schema.ts`.
- Read in full: `types/api.ts`, `sdk/text/index.ts`, `client/stream.ts`,
  `commands/text/chat.ts`, `commands/config/export-schema.ts`, `utils/schema.ts`,
  `errors/handler.ts`, `errors/codes.ts`, `utils/env.ts`, `client/http.ts`,
  `docs/cli-design.md`, `AGENTS.md`; partial: `SDK.md`, `SKILL.md`,
  `errors/api.ts`, `polling/poll.ts`, `output/formatter.ts`, `output/json.ts`,
  `commands/text/repl.ts` (head + tool grep).
- `grep tool_use|tool_result|tools|tool_choice src/commands/text/repl.ts` → **zero** (confirmed REPL has no tool handling).
- Per-file `git log -1` dates recorded inline above.
