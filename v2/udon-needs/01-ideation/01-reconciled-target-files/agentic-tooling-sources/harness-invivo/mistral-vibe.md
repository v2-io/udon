---
source: agentic-tooling sweep (2026-07-21) — harness/CLI in-vivo evidence — ~/src-ext/mistral-vibe
gathered: 2026-07-21
status: vetted mining-spot map
repo: v2-io? no — Mistral AI "Vibe" CLI coding agent (Python 3.12+, `uv`); HEAD 0685654 tagged v2.21.0, dated 2026-07-17 (+0200); newest CHANGELOG entry 2.21.0 / 2026-07-17
---

# mistral-vibe — in-vivo harness/CLI mining map

**What this repo is:** Mistral's production "Vibe" CLI coding agent. Python, hexagonal architecture (`_port.py` interfaces), Pydantic-typed tools, three delivery surfaces sharing one engine: interactive Textual TUI (`vibe/cli`), the Agent Client Protocol bridge (`vibe/acp`), and a headless/programmatic mode (`vibe/core/programmatic.py`). **Center of mass for our question is `vibe/core/tools/builtins/` (the tool implementations + their `prompts/*.md` descriptions) and `vibe/core/prompts/cli_2026-07_v2.md` (the live system prompt).** The tool *description* the model actually sees is the sibling `prompts/<tool>.md` file, not a Python docstring — so those markdown files ARE the tool-definition text.

Directly relevant for UDON: (1) tool descriptions are authored as prose markdown, versioned separately from code; (2) the edit tool is exact-string str-replace with a hard "read-before-edit" gate and multi-match refusal; (3) machine-readable output has three formats incl. newline-delimited streaming JSON; (4) a formalized instruction hierarchy the model must resolve; (5) `@file` mentions are lowered into `read_file` tool calls (context injection as tool-call).

---

## Tier 1 — tool definitions the model sees (schemas + prose descriptions)

### The tool-description markdown files — `vibe/core/tools/builtins/prompts/*.md`
These are loaded verbatim as each tool's model-facing `description` (see `base.py:get_full_description` / `manager.py:available_tool_specs`). Small, dense, and the single best artifact for "how a shipping harness phrases tool contracts to the model."

- `prompts/edit.md` — [~12 lines, priority HIGH] Exact-string-replacement contract: mandates `read_file` first ("will error if you attempt an edit without reading"); fails if `old_string` absent OR found multiple times (add context or `replace_all`); "preserve exact indentation after the line-number prefix, never include the prefix"; "if not found, re-read — do not guess at variations." Date: file mtime 2026-07-18. The canonical str-replace edit-tool spec.
- `prompts/bash.md` — [~10 lines, HIGH] Stateless one-off bash; "prefer dedicated tools over shell equivalents" table (read_file not cat/head/sed; write_file not `echo >`; edit not `sed -i`; grep not `grep -r`/find/rg/ag). The classic "don't use bash for what a typed tool does" steering.
- `prompts/experimental_bash.md` — [~40 lines, HIGH] The *advanced* bash design: stateful PTY sessions with `session_id`, durable log files, merged stdout/stderr stream, background mode, soft vs hard foreground timeout, long-polling `bash_output(cursor, wait_seconds, max_bytes)` with byte-offset cursors, `bash_stdin` for driving REPLs/installers (incl. `ctrl_c`), `bash_sessions` list/inspect/kill/reset, spill files under `~/.vibe/bash-tool/`. A recent tooling advancement — worth close reading.
- `prompts/read_file.md` — [~10 lines, MED] 2000-line default, 50KB output cap, 1-indexed `offset`+`limit` paging, line-number-prefixed output, "call in parallel to read multiple files," refuse binary/model-weight files.
- `prompts/write_file.md` — [~7 lines, MED] Create-only (errors if file exists → use edit), auto-mkdir parents, "ALWAYS prefer editing," "NEVER proactively create .md/README," emoji prohibition.
- `prompts/grep.md` — [~9 lines, MED] Regex content search, respects .gitignore/.codeignore, "for open-ended multi-round searches use the `task` tool instead."
- `prompts/todo.md` — [~10 lines, MED] Structured task list; `read`/`write` (write *replaces* whole list — omitted items removed); exactly one `in_progress`; only `completed` when tests pass.
- `prompts/task.md` — [~9 lines, MED] Subagent launch; self-contained description, state exactly what to return, "subagents run read-only: cannot modify files or ask questions," parallel launch, result not shown to user (summarize back).
- `prompts/skill.md`, `prompts/web_fetch.md`, `prompts/web_search.md`, `prompts/ask_user_question.md`, `prompts/exit_plan_mode.md` — [each ~7–12 lines, LOW–MED] skill loading; web_fetch returns markdown w/ `was_truncated` flag; web_search cites sources + resolve-relative-time rule; ask_user_question multi-tab 1–4 questions × 2–4 options + auto "Other"; exit_plan_mode plan→accept-edits gate.

### Arg schemas (Pydantic → JSON Schema) — `vibe/core/tools/builtins/*.py`
The `*Args(BaseModel)` classes; each `Field(description=...)` becomes a JSON-schema property description. `base.py:get_parameters()` (below) strips `title`/`description` off the schema envelope before sending.

- `edit.py:32-41` — [HIGH] `EditArgs`: `file_path`, `old_string` ("The text to replace"), `new_string` ("must be different from old_string"), `replace_all` (default false). `edit.py:44-63` `EditResult` carries `_ui_occurrences` diff-render hints. mtime 2026-07-18.
- `edit.py:74-231` — [HIGH] Full edit implementation: `run()` at 126-194 does the read → substring-count → refuse-if->1-and-not-replace_all (verbatim error strings at 137-149) → `_apply_edit` (`str.replace`, count=1 unless replace_all); `_validate_args` at 196-223 enforces non-empty old_string, old≠new, file exists/is-file; `file_write_lock` + atomic write. This is the reference str-replace edit engine.
- `read_file.py:52-91` — [MED] `ReadFileArgs` (`file_path`/`offset`/`limit`), `ReadFileConfig.max_read_bytes`, `ReadFileState.injected_agents_md` (tracks which AGENTS.md were auto-injected on read).
- `experimental_bash.py` `class *Args` (grep-mapped) — [HIGH] `ExperimentalBashArgs` (command, timeout, background, timeout_seconds, hard_timeout, cwd, env, shell); plus `BashOutputArgs` (session_id, cursor≥0, wait_seconds, max_bytes w/ `AliasChoices("max_bytes","max_chars")`), `BashStdinArgs` (text, `control: list[ControlKey]`, bytes_base64), `BashSessionsArgs` (action enum), `BashLogFileArgs`. The multi-verb stateful-shell tool surface.
- `todo.py:20-56` — [MED] `TodoStatus`/`TodoPriority` enums, `TodoItem` (id/content/status/priority), `TodoArgs` (action, todos).
- `task.py:37-53` — [MED] `TaskArgs` (task, agent), `TaskResult` (response, turns_used, completed), `TaskToolConfig.allowlist` defaults to EXPLORE subagent only.

### Tool framework — how definitions are built & serialized
- `vibe/core/tools/base.py` — [615-line class file; priority HIGH] The typed-tool contract. `BaseTool[Args,Result,Config,State]` generic; `get_tool_prompt()` (173-192, caches the sibling `.md`); `get_full_description()` (194-202, prompt-or-fallback); **`get_parameters()` (343-364): `model_json_schema()` then strips `title` off schema + every property + `$defs` — the exact JSON-schema-cleanup a harness does before sending tools to the model**; `get_name()` (366-370) CamelCase→snake_case; `ToolPermission` enum ALWAYS/NEVER/ASK (102-114); `resolve_permission`/`get_file_snapshot` hooks (383-416); `get_result_extra` (418-425, inject extra context alongside tool result — used to attach discovered AGENTS.md).
- `vibe/core/tools/manager.py:543-563` — [MED] `available_tool_specs()` → `AvailableFunction(name, description, parameters)` list; docstring explains description precedence (prompts/*.md → custom → inline) shared by "both the LLM tool formatter and the session logger."
- `vibe/acp/tools/base.py` + `vibe/acp/tools/builtins/edit.py` — [MED] ACP adapter layer: `edit.py:65-114` `tool_call_session_update` emits a `FileEditToolCallContent(type="diff", old_text, new_text)` + `ToolCallLocation` — how edits are streamed to an ACP client as structured diff events rather than text.
- `vibe/core/tools/mcp/tools.py:217-241,417-441` — [LOW] MCP/connector tools bypass the markdown path: `get_parameters()` returns the remote `input_schema` directly; description prefixed then falls back to remote description.

---

## Tier 2 — system prompts & agent-mode behavior

- `vibe/core/prompts/cli_2026-07_v2.md` — [149 lines, priority HIGH] The current production system prompt (selected via experiment/config in `system_prompt.py`). Gold content: a numbered **Instruction hierarchy** (critical > user > repo AGENTS.md path > user AGENTS.md > defaults > skills/MCP > external-data-as-data-not-instructions); **Critical/non-overridable "Blast radius"** rules for push/force-push/reset/rm-rf/migrations; "Read before you act" (never edit a file not read this session; don't edit same turn as first read); "Change minimally / minimal diff"; **"Prove it worked"** done-criteria; **"Stop when stuck"** heuristics (`lines_changed:0`, "string not found", same error twice, three edits w/o resolution, CRLF mismatch → re-read fresh); explicit anti-fabrication ("Do not claim verified/tested unless an execution step appears in the trajectory"); voice/length/format rules; blanket emoji ban. The single richest prompt-engineering artifact here.
- `vibe/core/prompts/cli.md` (136 ln), `lean.md` (148), `minimal.md`, `explore.md` (50), `tests.md`, `compact.md`/`compact_system.md`/`compact_summary_prefix.md`, `turn_summary.md` — [MED/LOW] Alternate/variant system prompts + the context-compaction prompt family. `explore.md` (1-25 read) is the read-only subagent prompt: "CODE/DIAGRAM FIRST, never prose first," strict never-do list, ASCII-tree/table/arrow-flow format rules — a tight machine-output style spec.
- `vibe/core/system_prompt.py` — [417 lines, HIGH] The assembler. `get_universal_system_prompt` (338-417) composes sections: headless block, commit-signature (`_add_commit_signature` 213-223, "Co-Authored-By: Mistral Vibe"), model-info, OS/shell block (incl. Windows bash-vs-cmd command-compat rules 178-210), available-skills XML section (`_get_available_skills_section` 226-258), subagents section, scratchpad section, project git-context (`ProjectContextProvider` 36-152: parallel `git branch/status/log` with caching), and AGENTS.md doc injection (397-415). `_get_headless_section` (327-335): "no human available, don't ask questions, complete in a single pass."
- `vibe/core/prompts/project_context.md`, `agents_doc.md`, `dangerous_directory.md` — [LOW, small] Template fragments interpolated into the above.

### Agent/headless mode conventions (non-interactive automation)
- `vibe/cli/entrypoint.py:33-165` — [HIGH] The CLI flag surface for automation: `-p/--prompt` (programmatic mode), `--max-turns`, `--max-price DOLLARS`, `--max-tokens`, **`--output {text,json,streaming}`** ("json = all messages at end, streaming = newline-delimited JSON per message"), `--enabled-tools`/`--disabled-tools` (glob or `re:` regex, multi-spec), `--agent`, `--auto-approve/--yolo`, `--trust` ("for non-interactive automation," skips trust prompt), `--worktree`, `--add-dir`, `--workdir`, `-c/--continue`, `--resume`. The machine-facing contract.
- `vibe/core/output_formatters.py` — [109 lines, HIGH] The three output formatters: `TextOutputFormatter` (final assistant content only), `JsonOutputFormatter` (dumps all `LLMMessage.model_dump(mode="json")` at finalize), `StreamingJsonOutputFormatter` (one JSON object per message, newline-delimited, flushed live). Concrete structured-output/streaming implementation.
- `vibe/core/programmatic.py` — [107 lines, MED] `run_programmatic()` — headless entry: wires formatter as `message_observer`, `enable_streaming=False`, feeds `agent_loop.act(prompt)` events to the formatter, raises `ConversationLimitException` on middleware stop. Shows how limits/headless plumb through.
- `vibe/cli/cli.py:270-322` — [MED] `output_format = OutputFormat(args.output...)`; headless run wiring + `sys.exit(0/1)` exit-code discipline (many `sys.exit` sites across cli.py/entrypoint.py = deliberate exit codes for automation).

---

## Tier 3 — context management, permissions, extension mechanisms

- `vibe/core/middleware.py` — [260 lines, MED–HIGH] Before-turn middleware chain governing context/limits: `TurnLimitMiddleware`, `PriceLimitMiddleware`, `TokenLimitMiddleware` (85-91), **`AutoCompactMiddleware` (100-108): triggers compaction when `context_tokens >= model.auto_compact_threshold`**, `ContextWarningMiddleware` (112-137): injects a `<vibe-warning>You have used N% of your total context (X/Y tokens)</...>` string back into the model at ≥50%. Concrete "manage tool-result context growth" logic — relevant to how UDON output volume interacts with context budgets.
- `vibe/core/tools/permissions.py` (68 ln) + `vibe/core/tools/utils.py:resolve_file_tool_permission` — [MED] ALWAYS/NEVER/ASK resolution, allowlist/denylist globs, `sensitive_patterns` (e.g. `**/.env`) force ASK even when ALWAYS. The per-tool-call gating model.
- `vibe/core/hooks/` (`_pre_tool.py`/`_post_tool.py`/`_post_agent.py`, `models.py`, `executor.py`) — [MED] The now-stable (2.21.0) hooks system: `pre_tool`/`post_tool`/`post_agent` events wrapping tool execution — an interception/verification seam around every tool call.
- `docs/adr/0004-typed-permissioned-tools.md` — [MED] The design rationale for the typed+permissioned tool contract; `0003-event-driven-agent-loop.md` (streaming/typed events/cancellation) and `0007-extension-mechanisms.md` (skills/subagents/hooks/MCP/custom tools) are the adjacent design records. Read these for the *why* behind the tool architecture.
- `CHANGELOG.md:8-52` — [MED] Recent tooling advancements worth noting: **"`@file` mentions now inject as `read_file` tool calls"** (context injection lowered to a tool call), hooks graduated from experimental with renamed events, "Config schema exposed through ACP," "Checkpointer engine state model / pending hunks" (edit checkpointing/rewind). 2.20.0 (2026-07-13): "Hardened bash tool permissions and cross-platform shell handling."
- `vibe/core/checkpoints` (referenced from `tools/base.py`) — [LOW-MED, not opened] `FileSnapshot`/`FileState` — pre-edit file snapshotting feeding the rewind/checkpoint feature. Noted, not read.

---

## Dry wells / not-relevant (checked, deliberately excluded)
- `vibe/cli/textual_ui/**` (widgets, app.tcss, model_picker, voice_manager, narrator_manager, onboarding, update_notifier) — TUI/UX chrome, no tool-contract content.
- `vibe/setup/**` (auth, onboarding, trusted_folders) — first-run wizards, auth flows. Not tooling.
- `vibe/acp/**` beyond `tools/` — ACP session/teleport/title plumbing; the tool adapters (`acp/tools/builtins/`) are the only relevant slice and mostly thin wrappers over `core/tools/builtins/` (already mapped).
- `tests/**` — behavioral tests; `test_system_prompt.py` could corroborate prompt content but adds nothing the source files don't state directly.
- `scripts/`, `pyinstaller/`, `flake.nix`, `action.yml`, `vibe.spec` — packaging/release/CI.

## Searches / commands run
- `git log -1 --format` → HEAD 0685654, 2026-07-17, tag v2.21.0.
- `find . -type f -not -path './.git/*'` — full tree enumeration (~200 files head).
- Read in full: `core/tools/builtins/edit.py`, `core/tools/base.py`, `acp/tools/base.py`, `acp/tools/builtins/edit.py`, `core/system_prompt.py`, `core/prompts/cli_2026-07_v2.md`, `core/output_formatters.py`, `core/programmatic.py`.
- `cat` all 13 files in `core/tools/builtins/prompts/`.
- grep for arg-schema Fields in read_file/todo/task/experimental_bash; `awk` block-extract of experimental_bash `*Args` classes.
- grep for `output.?format|max.?turns|headless|exit_code|sys.exit|OutputFormat` across cli.py/commands.py/entrypoint.py; read `entrypoint.py:30-170`.
- grep `middleware.py` for compact/token/window; `manager.py:540-575` for `available_tool_specs`; `mcp/tools.py` for input_schema.
- `sed` CHANGELOG head (2.21.0/2.20.0) + AGENTS.md head; `ls docs/adr/` + `vibe/core/hooks/`.
- Dry-well note: no dedicated "structured output schema / response_format" tool beyond the three OutputFormatters — Vibe streams typed `LLMMessage` events, not JSON-schema-constrained model output; structured-output = the message-serialization formatters, not constrained decoding.
