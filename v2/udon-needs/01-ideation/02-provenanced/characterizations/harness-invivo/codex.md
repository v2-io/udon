---
source: harness-invivo sweep — OpenAI Codex CLI codebase (~/src-ext/codex)
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: git HEAD 0fb559f0 (2026-07-19), cloned 2026-07-18; origin github.com/openai/codex, branch main
language: Rust workspace (codex-rs/, 112 crates); TS SDK (sdk/), thin npm launcher (codex-cli/)
---

# Codex CLI — in-vivo tool-use mining map

**What this harness is:** OpenAI's terminal coding agent. Talks to GPT-5-family
models over the **OpenAI Responses API** (not chat-completions). Tools serialize
as Responses-API "Tool" objects. The interesting-fraction is small: `codex-rs/tools/`
(shared tool models + JSON-schema machinery) and `codex-rs/core/src/tools/` (the
handlers + specs that actually define each tool). Prompts are checked-in `.md` files
in `codex-rs/core/`.

Center of mass is exactly where expected: tool **specs** (schema authoring) live in
`core/src/tools/handlers/*_spec.rs`; the shared schema/serialization layer is the
`codex-tools` crate. Two things stood out as recent advancements worth flagging:
**(1) apply_patch shipped as a grammar-constrained "freeform" tool** (lark grammar, not
JSON), and **(2) "code mode"** — a V8/JS runtime where the model calls tools by writing
JavaScript instead of emitting individual function calls.

---

## Tier 1 — tool definitions & JSON schemas (the gold)

- **`codex-rs/core/src/tools/handlers/shell_spec.rs`** (414 lines) — THE core tool
  authoring file. Defines, in Rust that serializes to Responses-API tool JSON:
  `exec_command` (L21–111, PTY-backed, `cmd`/`workdir`/`tty`/`yield_time_ms`/
  `max_output_tokens`, non-strict, with an `output_schema`), `write_stdin` (L113–155,
  drives a running "unified exec" session by `session_id`), `shell_command` (L157–225,
  the simpler one-shot; description literally instructs "Always set `workdir`… Do not use
  `cd`"), `request_permissions` (L227–262, sandbox-escalation tool), the
  `unified_exec_output_schema` (L264–296: `chunk_id`/`exit_code`/`session_id`/
  `original_token_count`/`output`, `additionalProperties:false`), per-command sandbox
  approval params (L298–344: `sandbox_permissions` enum use_default/with_additional_permissions/
  require_escalated, `prefix_rule` for reusable approval prefixes), and Windows PowerShell
  safety guidance embedded in the tool description (L405–410). High priority — this is the
  canonical example of how a shipping harness writes tool schemas + inline usage rules. Date: current (HEAD).

- **`codex-rs/core/src/tools/handlers/apply_patch_spec.rs`** (32 lines) + **`apply_patch.lark`**
  (co-located, ~22 lines) — the edit tool. Notable design: apply_patch is a **`ToolSpec::Freeform`**
  with `format.syntax = "lark"` — i.e. the model output is constrained by a **lark grammar**, not
  a JSON schema ("do not wrap the patch in JSON"). The grammar defines the `*** Begin Patch` /
  `*** Add|Delete|Update File` / `@@` hunk / `+`/`-`/` ` line envelope. A variant injects an
  `*** Environment ID:` line for multi-environment runs. High priority — grammar-constrained
  edit tool is a real advancement over str-replace/JSON-diff. Date: current.

- **`codex-rs/prompts/templates/apply_patch_tool_instructions.md`** (75 lines) — the natural-language
  spec of the same patch format handed to the model: envelope grammar, the 3-lines-of-context rule,
  the `@@ class/def` disambiguation escalation when 3 lines aren't unique, full EBNF-ish grammar at
  the bottom. High priority — this is the prose "how to use the edit tool" contract. Date: current.

- **`codex-rs/tools/src/tool_spec.rs`** (133 lines) — the `ToolSpec` enum: the discriminated union of
  everything the model can be offered (`Function`, `Namespace`, `ToolSearch`, `WebSearch`, `Freeform`/custom),
  serializing with `#[serde(tag="type")]` straight into Responses-API tool objects. `create_tools_json_for_responses_api`
  (L77) is where the wire array is built. Medium-high — the top-level shape of the tool contract. Date: current.

- **`codex-rs/tools/src/json_schema.rs`** (26KB) + **`json_schema_tests.rs`** (62KB of fixtures) — the
  JSON-Schema builder used by every `*_spec.rs`: `JsonSchema` type with `string`/`number`/`integer`/`boolean`/
  `array`/`object`/`string_enum`/`any_of`/`one_of`/`all_of`, `AdditionalProperties`, plus
  `parse_tool_input_schema` (L189, sanitizes/compacts inbound MCP schemas). The 62KB test file is a
  large corpus of concrete schema-shape examples. Medium-high (schema machinery + examples). Date: current.

- **`codex-rs/core/src/tools/handlers/plan_spec.rs`** (~57 lines) — `update_plan` tool: `plan[]` of
  `{step, status: pending|in_progress|completed}`, "At most one step can be in_progress." Clean example
  of a structured-state agent tool. Medium. Date: current.

- **Other handler `*_spec.rs` in `core/src/tools/handlers/`** (dry-scanned, listed for completeness):
  `view_image_spec`, `get_context_remaining_spec`, `new_context_window_spec`, `request_user_input_spec`,
  `mcp_resource_spec`, `tool_search_spec`, `multi_agents_spec`, `agent_jobs_spec`,
  `list_available_plugins_to_install_spec`. Each authors one tool's schema the same way as shell_spec.
  Medium — mine these if you want the full tool catalog (context window mgmt, sub-agents, MCP resources,
  user-input-request, image viewing). Date: current.

## Tier 1 — system prompts & tool-use instructions

- **`codex-rs/core/gpt-5.2-codex_prompt.md`** (80 lines) — the current shipping system prompt for the
  newest model. Covers: prefer `rg`; ASCII-default editing; **"Try to use apply_patch for single-file
  edits… Do not use apply_patch for auto-generated files or when scripting a codebase-wide search/replace
  is more efficient"** (L11 — explicit edit-tool selection guidance); dirty-worktree rules (never revert
  user changes); plan-tool usage; and a detailed **final-answer formatting contract** (L62–80: plain text,
  header/bullet rules, monospace rules, clickable file-reference format `path:line`). High priority — how
  the harness steers tool selection + machine-consumed output format. Date: current (targets gpt-5.2-codex).

- **`codex-rs/core/prompt_with_apply_patch_instructions.md`** (351 lines) — the fuller/older-style base
  prompt. Sections worth reading: capabilities/personality (L1–14), **AGENTS.md spec** (L16–29: how
  nested AGENTS.md files scope agent instructions — a directory-tree instruction-inheritance model),
  **preamble-message** discipline before tool calls (L33–60), and (further down) sandbox/approvals model.
  High priority for the AGENTS.md-scoping model and pre-tool-call narration convention. Date: current.

- **Sibling shipping prompts** in `codex-rs/core/`: `gpt_5_codex_prompt.md`, `gpt-5.1-codex-max_prompt.md`,
  `gpt_5_1_prompt.md`, `gpt_5_2_prompt.md`, plus `templates/model_instructions/gpt-5.2-codex_instructions_template.md`
  and `templates/collab/experimental_prompt.md`. Per-model prompt variants — diffing them would show how
  tool-use instruction wording evolves per model. Medium (mine if you want the deltas). Date: current.

## Tier 2 — advancements: code-mode, deferred/searchable tools, output handling

- **`codex-rs/tools/src/code_mode.rs`** (6.9KB) + **`codex-rs/code-mode/`** crate (lib.rs, `v8_init.rs`,
  `session_runtime/`, `runtime/`, `service.rs`) + **`code-mode-host/`** crate — "**code mode**": instead of
  emitting one function-call per tool, the model writes **JavaScript executed in an embedded V8 runtime**,
  and tools are exposed as callable JS functions. `augment_tool_spec_for_code_mode` (code_mode.rs L7)
  rewrites each tool's description to add "exec samples" showing how to call it from code. `v8_init.rs`
  exposes `V8JitMode`/`initialize_v8`. High priority as a genuinely-recent tool-invocation paradigm
  (tools-as-code vs tools-as-JSON-calls). Date: current.

- **`codex-rs/tools/src/tool_search.rs`** (4.3KB) + `tool_discovery.rs` (4.5KB) + `tool_config.rs` — **deferred
  tool loading / tool search**: tools can be registered with `defer_loading = true` and `output_schema` stripped
  (tool_search.rs L36–41), then surfaced on demand via a `tool_search` meta-tool rather than all being in-context
  at once. This is the context-management-for-large-tool-catalogs pattern (same idea as this very harness's
  ToolSearch). Medium-high. Date: current.

- **`codex-rs/tools/src/tool_output.rs`** (293 lines) — the model-facing **tool-result contract**. `ToolOutput`
  trait (L16): `to_response_item` builds the `FunctionCallOutput` / `CustomToolCallOutput` / `McpToolCallOutput`
  wire item; `JsonToolOutput` (L92); `telemetry_preview` (L254) truncates logged previews to 2KB / 64 lines.
  Also carries `PostToolUse` hook hooks and `contains_external_context` (feeds a "disable memory generation on
  external context" policy). Medium-high — how results are structured + previewed back. Date: current.

- **`codex-rs/core/src/exec.rs`** (L69–80, L730–855) — exec output **truncation/context management**:
  `EXEC_OUTPUT_MAX_BYTES = DEFAULT_OUTPUT_BYTES_CAP = 1 MiB` (defined `utils/pty/src/lib.rs:12`), read in 8KB
  chunks, capped ≤10,000 output deltas/call (`MAX_EXEC_OUTPUT_DELTAS_PER_CALL`), `append_capped`/tail logic.
  Medium — the byte-budget mechanics for tool output before it reaches the model. Date: current.

- **`codex-rs/core/src/tools/runtimes/`** (`shell.rs`, `apply_patch.rs`, `unified_exec.rs`, `mod.rs`) — the
  execution side of each tool spec (the "runtime" that actually runs the shell/patch). Pair with the `*_spec.rs`
  files above to see spec↔execution. Medium. Date: current.

- **`codex-rs/apply-patch/src/`** — the standalone apply_patch parser/applier crate: `parser.rs` (661 lines),
  `streaming_parser.rs` (944 lines — streaming patch application), `seek_sequence.rs` (163 lines, fuzzy context
  matching), `standalone_executable.rs`. This is the actual diff-format engine + how it fuzzily locates context.
  Medium-high if you want the edit-tool internals (fuzzy matching, streaming apply). Date: current.

## Tier 2 — agent-mode / non-interactive surface

- **`codex-rs/exec/src/cli.rs`** (312 lines) — the **non-interactive "agent mode"** CLI (`codex exec`).
  Machine-facing flags: `--json`/`--experimental-json` (JSONL event stream to stdout, L63–70),
  `--output-schema FILE` (JSON Schema constraining the model's **final** response — structured output, L52–54),
  `--output-last-message/-o FILE` (write final agent message to file, L72–79), `--ephemeral` (no session
  persistence), `--skip-git-repo-check`, prompt via arg or stdin (`-`). Subcommands `resume` and `review`
  (`--uncommitted`/`--base`/`--commit`). High priority — this is the "how do you script this agent" surface.
  Date: current.

- **`codex-rs/exec/src/event_processor_with_jsonl_output.rs`** (+ tests) — emits the JSONL event schema for
  `--json` mode: tool-call events, MCP results with `meta` (`raw_messages`/`ref_id` for web-search
  provenance), `last_message` handling. Medium — the machine-readable event contract. Date: current.

## Tier 3 — reference / catalog (lower priority, characterized)

- **`AGENTS.md`** (repo root, 22KB) — Codex's own contributor/agent guide for working in this repo (build,
  test, conventions). Not tool-schema material, but a large real-world example of the AGENTS.md instruction
  format the harness consumes. Low-medium. Date: current.
- **`codex-rs/docs/protocol_v1.md`** and **`docs/codex_mcp_interface.md`** — the app-server / MCP protocol
  docs (how a host drives Codex as an MCP server). Low-medium — relevant only if the MCP framing matters. Date: current.
- **`codex-rs/tools/README.md`** — narrative of the `codex-tools` crate boundary/migration; explains where
  `ToolSpec`/`ToolExecutor`/`ToolOutput`/code-mode augmentation live. Low — orientation, not content. Date: current.
- **`codex-rs/core/src/tools/handlers/`** also has: `multi_agents.rs`/`multi_agents_v2.rs`/`agent_jobs.rs`
  (sub-agent spawning), `mcp_resource.rs`, `request_user_input.rs`, `sleep.rs`, `current_time.rs`,
  `new_context_window.rs`, `get_context_remaining.rs` (model can query its own remaining context budget).
  Low-medium — the long tail of the tool catalog; `get_context_remaining` is a mildly novel self-introspection tool. Date: current.

---

## Searches / commands run (incl. dry wells)

- `git log -1` / `git branch` / `git remote` — established HEAD 0fb559f0 (2026-07-19), branch main, origin openai/codex.
- `find codex-rs -type f -name '*.rs' | grep -iE 'tool|apply_patch|edit|exec|unified'` — located the tools crate + core/src/tools tree.
- `ls core/src/tools/handlers/*.rs` — enumerated the full tool handler/spec set.
- `find . -name '*prompt*' -o -name '*.md'` grep instruction — found the checked-in system prompts in core/.
- Read in full: shell_spec.rs, apply_patch_spec.rs, apply_patch.lark, apply_patch_tool_instructions.md, tool_spec.rs,
  tool_output.rs, plan_spec.rs, exec/src/cli.rs, gpt-5.2-codex_prompt.md; partial: prompt_with_apply_patch_instructions.md
  (L1–50), tool_search.rs, code_mode.rs (heads).
- **Dry well:** no separate "middle-out" truncation module (`truncate*.rs` doesn't exist); truncation lives inline in
  `exec.rs` + `tool_output.rs::telemetry_preview` — captured above rather than as its own entry.
- **Dry well:** `docs/` at repo root has only bazel/mcp/protocol docs — no standalone "tool design" doc; the tool
  design lives in the `*_spec.rs` code, which is why those are Tier 1.
- **Note / follow-the-mass:** the truly load-bearing material is in Rust `*_spec.rs` files (schema authored in code),
  NOT in a config/JSON manifest — anyone expecting a `tools.json` should look at `shell_spec.rs`/`apply_patch_spec.rs` instead.
- Did NOT open other agents' outputs or scratch/first-sweep (per instructions).
