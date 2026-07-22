---
source: harness-invivo sweep — Warp terminal (~/src-ext/warp)
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: git HEAD 37c26a8b, committed 2026-07-18 23:51 UTC (clone ~same day)
repo: warpdotdev/warp (source-available, AGPL/MIT); Rust monorepo, 77 crates
---

# Warp terminal — in-vivo agentic tooling map

## Orientation & the one big caveat

Warp is an AI-native terminal whose agent is a **thin client to a Warp cloud
server**. The consequence for this sweep: **the raw JSON tool schemas and the
system prompts are NOT in this repo.** They live in an externally-pinned proto
package and on Warp's servers:

- `Cargo.toml:345` — `warp_multi_agent_api = { git =
  "https://github.com/warpdotdev/warp-proto-apis.git", rev =
  "3d26f166b74469d5c12080ef6a3423fadee4d0e3" }`. This is the wire contract
  (the `message::tool_call::*` proto types). Not vendored here; would need
  that separate repo to read the actual field-level schema.

So what this repo *does* give you, in vivo and high-value, is the **client
half**: the complete tool taxonomy as a typed model, the proto↔model
conversion (which reveals every wire tool name), the **edit-tool
implementation** (str-replace + OpenAI V4A apply-patch, with a 3-tier
fuzzy matcher), the **MCP client**, the **permission/autonomy model**, and
the **skills** system. Center of mass is one crate: `crates/ai/` (~30k LOC).

Everything below was opened and read; nothing is filename-judged.

---

## HIGH priority — tool taxonomy, edit tool, wire contract

### `crates/ai/src/agent/action/mod.rs` (979 lines) — the complete tool catalog
The single best file. `AIAgentActionType` enum (lines 31–213) is Warp's entire
agent tool surface as one Rust enum, each variant richly doc-commented:
`RequestCommandOutput` (with `is_read_only`/`is_risky`/`uses_pager`/
`wait_until_completion` flags the LLM sets, L35–58), `WriteToLongRunningShellCommand`,
`ReadFiles`, `SearchCodebase`, `RequestFileEdits`, `Grep`, `FileGlob`/`FileGlobV2`,
`ReadMCPResource`, `CallMCPTool`, `ReadDocuments`/`EditDocuments`/`CreateDocuments`
(agent-managed planning docs), `UseComputer`/`RequestComputerUse`,
`StartRecording`/`StopRecording` (computer-use video), `ReadSkill`,
`StartAgent`/`RunAgents`/`SendMessageToAgent`/`WaitForEvents` (multi-agent
orchestration, L173–212), `AskUserQuestion` (structured multiple-choice, L692–738),
`TransferShellCommandControlToUser`. Also: `RunAgentsRequest`/`StartAgentExecutionMode`
Local-vs-Remote config (L215–325), `FileEdit` enum = Edit(ParsedDiff)/Create/Delete
(L956–978), `AIAgentPtyWriteMode` Raw/Line/Block with escape-sequence decoration incl.
bracketed-paste (L844–895). `user_friendly_name()` (L444) and `Display` (L496) give a
plain-English gloss of every tool. **Date:** current (HEAD). **Why high:** this is the
authoritative, exhaustive answer to "what tools does a shipping agent terminal expose."

### `crates/ai/src/diff_validation/mod.rs` (1274 lines) — the edit-tool engine
The str-replace/patch apply logic. `ParsedDiff` (L20–35) supports **two edit
formats**: `StrReplaceEdit{file,search,replace}` AND `V4AEdit` — OpenAI's V4A
apply-patch format (explicitly cited: `cookbook.openai.com/examples/
gpt4-1_prompting_guide#apply-patch`, L30, L230). The apply is a **3-tier fuzzy
matcher** (`fuzzy_match_file_diffs`, L486+; method doc L341–360): exact match →
whitespace/indentation-agnostic match (`MakeIndentationAgnosticMatch`) →
Jaro-Winkler similarity (`strsim` crate) with a `SECTION_MATCH_THRESHOLD`; when
line numbers are supplied in the search block it disambiguates ties by proximity
to expected line. Handles `{n}|{line}` line-number-prefixed search blocks
(`LINE_NUMBER_PARSE` regex L12, `remove_extra_line_num_prefix` L317),
noop/identical-diff detection, overlapping-delta dedup (L464), and emits
`DiffMatchFailures{fuzzy_match_failures, missing_line_numbers, noop_deltas}` for
**telemetry** (L327). `warrants_failure()` (L144) decides when a fuzzy edit is too
degraded to apply. **Date:** current. **Why high:** this is exactly the "edit-tool
design (str-replace? patches? verification?)" question, answered by a production
implementation that hedges LLM sloppiness with fuzzy matching + failure metrics.

### `crates/ai/src/agent/action/convert.rs` (805 lines) — proto → tool model
`From<api::message::tool_call::X>` impls that map every wire tool-call message to
the action enum — so this file enumerates the **actual on-the-wire tool names**:
`RunShellCommand`, `WriteToLongRunningShellCommand`, `ApplyFileDiffs`, `EditDocuments`,
`CreateDocuments`, `ReadDocuments`, `ReadFiles`, `SearchCodebase`, `Grep`, `FileGlob`/
`FileGlobV2`, `CallMcpTool`, `ReadMcpResource`, `UseComputer`/`RequestComputerUse`/
`ScreenshotParams`, `StartRecording`/`StopRecording`, `InsertReviewComments`,
`SuggestPrompt`/`SuggestNewConversation`, `FetchConversation`,
`TransferShellCommandControlToUser`. First impl (L20–39) shows the LLM-supplied
`RunShellCommand` fields verbatim. **Date:** current. **Why high:** closest you can
get in-repo to the server tool schema — the field names and shapes of each call.

### `crates/ai/src/agent/action_result/mod.rs` (1573 lines) — tool-result shapes
The typed **return values** fed back to the model. `AIAgentActionResultType`
(L18) with a per-tool result enum each carrying `Success{...}`/`Error(String)`/
`Cancelled` plus tool-specific richness: `RequestCommandOutputResult::Completed`
vs `LongRunningCommandSnapshot` vs `Denylisted{command}` (L191–214, the agent-mode
command allow/deny outcome), `FileContext` (L360) as the read-file result payload.
Sibling `action_result/convert.rs` (1605 lines) maps these back to proto. **Date:**
current. **Why high:** shows how tool *output* is structured/labeled for the model,
including truncation-snapshot semantics for long-running commands.

---

## MEDIUM priority — autonomy model, MCP client, skills, orchestration

### `crates/cloud_object_models/src/ai_execution_profile.rs` (~270+ lines read)
The **agent autonomy / permission model** ("agent-mode conventions"). Enums:
`ActionPermission` (AgentDecides / AlwaysAllow / AlwaysAsk / Unknown catch-all,
with human-facing `description()` strings, L19–52), `WriteToPtyPermission`,
`ComputerUsePermission`, `RunAgentsPermission`, `AskUserQuestionPermission`. Plus
`AgentModeCommandExecutionPredicate` (L258+) — **regex allow/deny predicates** for
which shell commands auto-run vs require approval (`new_regex`, `matches`), with a
`schemars` JSON-schema impl. Note the deliberate `#[serde(other)] Unknown` and
`#[serde(alias="Never")]` **forward-compat** pattern for evolving the permission
enum without breaking old clients. **Date:** current. **Why medium:** the
autonomy/approval config, not the tool wire, but directly relevant to agent-mode
tool-use governance.

### `crates/mcp/` (11 files, ~2685 LOC) — MCP client runtime
Warp as an **MCP client** built on the `rmcp` crate. `src/lib.rs` —
`TemplatableMCPServerInfo` holding a live `rmcp` RunningService, its `tools:
Vec<rmcp::model::Tool>` and `resources: Vec<rmcp::model::Resource>` (L10–50).
`src/runtime.rs` (largest), `src/oauth.rs` + `oauth/loopback.rs` (OAuth incl.
loopback flow), `src/sse_transport/` (SSE transport: `sse_client.rs`,
`client_side_sse.rs`, `auth_impl.rs`). `.mcp.json` at repo root is the server
config. **Date:** current. **Why medium:** how a shipping harness consumes
third-party tools over MCP (transport + auth), vs Warp's own native tools.

### `crates/ai/src/skills/` (14 files) — Anthropic-style skills system
Warp implements **skills** (SKILL.md + frontmatter). `parse_skill.rs` (225 lines):
frontmatter `name`/`description` parsing, `MAX_SKILL_DESCRIPTION_CHARS=512`,
block/sentence regex trimming; `skill_provider.rs` (scope: local vs remote
project); `conversion.rs`; `read_skills.rs`. The `ReadSkill` tool (in action/mod.rs)
lets the agent pull a skill on demand. Real skills live at `.agents/skills/*/SKILL.md`
(28 of them — e.g. `review-pr-local`, `changelog-draft` with Python helper scripts)
and `.warp/skills/`. **Date:** current. **Why medium:** progressive-disclosure
skill loading is a live "recent tooling advancement" pattern.

### `crates/ai/src/project_context/global_rules.rs` (394 lines) + `model.rs` (666)
The **rules/context-injection** system: watches well-known locations for rule
files — notably `~/.agents/AGENTS.md` (`GlobalRuleSource::Agents`, L18–30) — plus
per-project `ProjectRule`s, via directory watchers. This is Warp's equivalent of
CLAUDE.md/AGENTS.md auto-context. **Date:** current. **Why medium:** shows the
convention (AGENTS.md) a shipping harness reads for standing instructions.

### `crates/ai/src/agent/orchestration_config.rs` (219) + `ask_user_question_session.rs` (517)
`orchestration_config.rs`: client model of multi-agent `OrchestrationConfig`
(model_id / harness_type / Local-vs-Remote execution) + user approval state.
`ask_user_question_session.rs`: the structured **AskUserQuestion** interaction
(multiple-choice, multiselect, "other" option) session state — a machine-readable
clarification tool rather than free-text. **Date:** current. **Why medium:**
multi-agent + structured-clarification conventions.

---

## LOW priority — adjacent / meta

- `crates/ai/src/index/full_source_code_embedding/` (largest subtree in the
  crate, ~7k LOC: `codebase_index.rs` 2347, `manager.rs`, `merkle_tree/`,
  `chunker/`, `sync_client.rs`) — Warp's **codebase indexing/embedding** engine
  (Merkle-tree change detection + chunking) backing the `SearchCodebase` tool.
  Read enough to characterize: it's RAG-for-code infra, tangential to tool-wire
  design but relevant if the interest is semantic-search tooling. **Date:** current.
- `crates/ai/src/agent/citation.rs` (77) + `document_action_presentation.rs` (147)
  — how tool outputs are cited/presented in the UI. Low relevance to schema.
- `AGENTS.md` (repo root, 15KB) + `.agents/skills/*` — instructions for agents
  *building Warp* (contributor workflow), not Warp's own agent tool design. Meta;
  skim only if you want a shipping team's internal agent-skill authoring examples.
- `crates/warp_multi_agent_client/` (247 LOC) — thin client wrapper; the substance
  is the external proto (see caveat) and server.
- `crates/warp_completer/` (18k LOC, 67 files) — shell command-line **autocompletion**
  (clap signature parsing, command specs), not LLM tool-use. Dry-ish for this question.

---

## Searches / commands run (incl. dry wells)

- `git log -1` → HEAD 37c26a8b, 2026-07-18; established clone/version date.
- `ls crates | grep -iE 'agent|ai|tool|mcp|llm|...'` → found ai/mcp/
  warp_multi_agent_client/command-signatures-v2/warp_completer as candidates.
- `find crates/{ai,mcp,...} -name '*.rs' | wc -l` + size sort → identified
  `crates/ai/` (30k LOC) as center of mass; read the top files by size.
- `grep -rilE 'system.?prompt|you are warp|tool_schema|json_schema|input_schema'`
  → **DRY WELL** for actual system prompts / raw tool JSON schemas: hits were
  settings-schema, graphql, mcp — none contained a Warp system prompt or the
  tool JSON schema. Confirms prompts/schemas are server-side/external.
- `find . -name '*.proto'` → **DRY WELL**: only 2 protos, both `remote_server`
  (SSH/remote-dev), NOT the multi-agent tool proto. Led to finding the external
  pinned `warp-proto-apis` git dep in Cargo.toml (the real wire schema, not vendored).
- `grep 'tool_call::[A-Z]'` in action/convert.rs → enumerated all wire tool names.
- `grep -rilE 'truncat|max_tokens|token_limit|MAX_'` in ai/agent → little in the
  tool layer (context-window management is server-side); `MAX_SKILL_DESCRIPTION_CHARS`
  in skills is the notable client-side limit. Mostly a **dry well** for client-side
  context-management of tool results.
- Read: action/mod.rs (full), action/convert.rs (head), action_result/mod.rs
  (grepped variants), diff_validation/mod.rs (head + fuzzy-match sections),
  ai_execution_profile.rs (permission enums), mcp/lib.rs (head), llm_id.rs (full),
  orchestration_config.rs, global_rules.rs, parse_skill.rs (heads).

**Center-of-mass note:** it landed exactly where expected inside `crates/ai/src/agent/`
and `crates/ai/src/diff_validation/` — but the *schemas/prompts* people usually
want from a harness are deliberately absent (external proto + cloud server). The
in-repo gold is the edit-tool fuzzy-match engine and the exhaustive typed tool
taxonomy, both of which are implementation-grade, not just declarations.
