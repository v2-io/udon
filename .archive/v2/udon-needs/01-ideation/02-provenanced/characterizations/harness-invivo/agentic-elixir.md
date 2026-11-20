---
source: harness-invivo sweep of ~/src/_ref/agentic-elixir (repo: github.com/josephwecker/v2-cortex)
gathered: 2026-07-21
status: vetted mining-spot map
---

# agentic-elixir (SimpleAgent / "v2-cortex") — in-vivo harness map

## What this repo is (provenance)

An Elixir/OTP agent runtime ("SimpleAgent") built around the **Anthropic Messages API tool-use loop** plus a heavily-engineered **MCP client** (STDIO + WebSocket transports, security sandbox, connection pooling, telemetry). Last commit **2025-08-21** ("production-ready MCP STDIO transport"); all source files dated Aug 2025. Remote is `josephwecker/v2-cortex` — i.e. **this is Joseph's own earlier agent-harness experiment**, not a third-party clone. Treat it as first-party prior art rather than an external ecosystem data point.

Center of mass for *this* sweep's question (how does the harness define and use tools in vivo): `lib/simple_agent/tools/` (native Claude tool schemas + executor), `lib/simple_agent/agent.ex` (the tool-use loop + system prompts), `lib/simple_agent/anthropic_client.ex` + `anthropic_options.ex` (wire/beta headers), and `lib/simple_agent/mcp/` (the larger, more mature subsystem). The docs/ tree is secondary (guides + competitive research), noted at the bottom.

**Caveat worth carrying:** several "tool" implementations are aspirational stubs — `run_tests` returns a canned message, `query_database`/`analyze_data` are placeholders, `execute_code` for elixir is `Code.eval_string` with an *unrestricted* binding despite a "sandboxed environment" description, and streaming is declared "not yet implemented." So this is a design-of-a-harness reference, not a battle-tested one. Where the design is real and interesting is the tool *schemas*, the loop structure, MCP, and prompt-caching.

## Highest-value mining spots

### Native tool definitions & JSON schemas
- **`lib/simple_agent/tools/definitions.ex`** (1–471) — the whole file is a hand-written catalog of 11 Claude tools as Elixir maps mirroring Anthropic's `{name, description, input_schema}` shape. Concrete per-tool schemas with `type/properties/required/enum/default`: `read_file` (84–105, enum encoding utf8/binary/base64), `write_file` (111–143, mode enum write/append), `list_files` (148, glob + recursive), `delete_file` (178, requires a `confirm` boolean — an interesting "destructive-action gate in the schema"), `create_directory`, `web_search` (230), `fetch_url` (258, extract enum text/links/images/all), `execute_code` (285, language enum), `run_tests` (318), `query_database` (348), `analyze_data` (380, analysis_type enum). Priority: **HIGH** — this is exactly "how a harness spells its tool schemas," and the `confirm`-flag and encoding-enum choices are directly relevant to UDON-as-tool-argument-format thinking. Date: Aug 2025.
- **`lib/simple_agent/tools/definitions.ex`** (426–470) — `validate_tool_input/2`: a hand-rolled schema validator (required-field check + default application, string/atom key coercion) rather than a JSON-Schema library. HIGH — shows what "validate the model's tool call against the schema" costs when done by hand. Aug 2025.

### The tool-use loop & result envelope
- **`lib/simple_agent/tools/executor.ex`** (40–66) — `execute/1` dispatches on `%{"name","input","id"}` (Anthropic tool_use block shape) and, crucially, **always returns `{:ok, tool_result}`** even on error (wraps the error into a `tool_result` with `is_error`), so a failed tool feeds back to the model instead of crashing the loop. HIGH. Aug 2025.
- **`lib/simple_agent/tools/executor.ex`** (361–376) — `build_tool_result` / `build_tool_error`: the exact `%{"type"=>"tool_result","tool_use_id"=>..., "content"=>Jason.encode!(output)}` envelope, error variant adds `"is_error"=>true`. Tool output is **JSON-encoded into the content string**. HIGH — canonical Anthropic tool_result shaping. Aug 2025.
- **`lib/simple_agent/tools/executor.ex`** (67–85) — `execute_batch/1` runs multiple tool_uses via `Task.async_stream` (parallel, ordered, 60s timeout) — parallel tool execution within one assistant turn. MEDIUM. Aug 2025.
- **`lib/simple_agent/tools/executor.ex`** (274–330) — `validate_file_path` (path-traversal `".."` rejection = the *entire* sandbox), `validate_file_size` (10 MB cap), encoding round-trips, append-mode writes. MEDIUM — the edit/write-tool design is **whole-file overwrite or append; there is no str-replace / patch / diff edit tool at all** (a notable absence for a demand-side comparison). Aug 2025.
- **`lib/simple_agent/tools/executor.ex`** (207–228) — `execute_code` for elixir is `Code.eval_string` with unrestricted binding; non-elixir languages return "not supported." LOW (as impl) but MEDIUM as a cautionary datapoint on "sandboxed code execution" claims. Aug 2025.

### System prompts & the agent turn-loop
- **`lib/simple_agent/agent.ex`** (567–628) — `execute_with_tools/5`: the actual agentic loop. Hard-capped at **5 iterations**, appends `{assistant: response.content}` + `{user: [tool_results]}` each round, re-detects tool_use, exits when none. Iteration-limit returns a `:tool_iteration_limit` error. HIGH — compact reference implementation of the tool-call loop. Aug 2025.
- **`lib/simple_agent/agent.ex`** (660–675) — `extract_tool_uses`/`extract_content`: filters the response `content` array by `"type"=="tool_use"` vs `"text"`. MEDIUM. Aug 2025.
- **`lib/simple_agent/agent.ex`** (677–760+) — `build_system_prompt/2`: a real, **XML-tag-structured system prompt** (`<role>`, `<task_config>`, `<reasoning_framework>` with analysis/planning/execution/verification steps, `<tools_guidance>`, `<output_format>`) plus per-task-type specialist blocks (`<specialist_expertise>`, `<review_checklist>`). HIGH — a worked example of prompt-engineering conventions (tag scaffolding, when-to-search guidance) that a harness bakes in. Aug 2025.
- **`lib/simple_agent/task_behavior.ex`** (1–356) — a `@behaviour` defining a task type: `build_prompt/2`, `process_response/2`, `recommended_llm_config/0`, `required_tools/0`; concrete impls for code_review/research/documentation each with their own prompt + recommended model/temperature/max_tokens. MEDIUM — "structured task → prompt + tool set + model config" pattern. Aug 2025.

### Anthropic wire, beta headers, model list
- **`lib/simple_agent/anthropic_client.ex`** (20–28) + (511–542) — `@beta_headers` map from feature atom → the exact `anthropic-beta` header string, and `build_headers` joining multiple with commas (`X-API-Key`, `anthropic-version: 2023-06-01`). Values captured as of Aug 2025: `output-128k-2025-02-19`, `context-1m-2025-08-07`, `token-efficient-tools-2025-02-19`, `search-results-2025-06-09`, `fine-grained-tool-streaming-2025-05-14`, `interleaved-thinking-2025-05-14`. HIGH — a dated snapshot of which Anthropic beta tool/streaming features a harness opted into. Aug 2025.
- **`lib/simple_agent/anthropic_options.ex`** (8–27) — `@available_models` (opus-4-1/opus-4/sonnet-4/3.7-sonnet/3.5-haiku/... as of Aug 2025) and `@beta_features` atoms (`token_efficient_tools`, `interleaved_thinking`, `fine_grained_streaming`, `search_results`, ...). Note stream option is documented "(not yet implemented)". MEDIUM. Aug 2025.
- **`lib/simple_agent/llm/anthropic.ex`** (197–238) — `format_tools_for_anthropic` (strips native tool maps down to `{name,description,input_schema}`) and tool_use extraction from the response. MEDIUM. Aug 2025.
- **`lib/simple_agent/config.ex`** (13–23) — default model `claude-3-5-sonnet-20241022`; multi-provider defaults (gemini-1.5-flash). LOW. Aug 2025.

### Prompt/context caching (cost-side of tool defs)
- **`lib/simple_agent/context_cache.ex`** (1–150) — attaches `cache_control: %{type: "ephemeral"}` breakpoints to system prompt, **tool definitions**, and messages; `build_request_params` injects them. MEDIUM — directly relevant to "tool schemas are big, cache them" and shows where in the request the breakpoints land. Aug 2025. (Companion guide: `docs/CONTEXT_CACHING.md`.)

### MCP subsystem (the largest, most mature part)
- **`lib/simple_agent/mcp/transport/stdio_port.ex`** (1–80, file is 781 lines) — the newest/headline work: JSON-RPC 2.0 over Erlang Ports to `npx ... server-*`, request/response correlation, health checks, SIGTERM→SIGKILL shutdown, backoff. Config example (npx MCP filesystem server, `protocolVersion 2024-11-05`) is in the moduledoc at lines 19–40. HIGH for "how a harness actually speaks MCP." Aug 2025.
- **`lib/simple_agent/mcp/tool_executor.ex`** (200–296) — cross-server fallback + **local fallback**: capability inference from tool-name prefix (`fs_`,`github_`,`slack_`,`http_`→ 291–296), and basic local impls of `fs_read_file`/`fs_write_file`/`fs_list_directory`/`http_get`. MEDIUM. Aug 2025.
- **`lib/simple_agent/mcp/tool_registry.ex`** (1–203) — GenServer registry of MCP-server-advertised tools; `register_tools/list_all_tools/get_tool` with preferred-server resolution. MEDIUM. Aug 2025.
- **`lib/simple_agent/mcp/security/{validator,sandbox,credential_vault,audit_logger,rate_limiter}.ex`** — an MCP-tool-call security layer (arg validation, sandboxing, encrypted credential vault, JSONL audit logs in `logs/audit/`). MEDIUM — "guardrails around tool execution" as a design surface. Aug 2025.

## Secondary: docs/ (guides + competitive research, not in-vivo code)
- **`docs/TOOLS_SYSTEM.md`** (791 lines) — prose + diagrams of the Definitions/Executor/sandbox architecture above; the design rationale companion to the code. MEDIUM. Aug 2025.
- **`docs/CONTEXT_CACHING.md`** (453) — the ephemeral-cache design (claims 90% token cost cut, 2–4× latency); breakpoint placement guidance. MEDIUM.
- **`docs/MCP_CLIENT_STRATEGY.md`** (1153) / `MCP_STRATEGY.md` (586) / `MCP_USAGE_GUIDE.md` (717) / `Elixir Model-Context-Protocol Deep Dive.md` (467) / `mcp-security.md` / `mcp-performance.md` / `websocket-mcp-servers-2025.md` — the MCP-adoption strategy corpus. MEDIUM for MCP design thinking, LOW for the UDON tool-format question specifically. Aug 2025.
- **`docs/AI Development Tools Research.md`** (254) — a "2025 Landscape of AI-Enabled Development Tools" analyst-style report (capability ladder: completion→chat→agentic; codebase-context primacy; Cursor/Windsurf/Copilot/ Qodo/CodeRabbit/Snyk; MCP as interoperability response). MEDIUM — competitive landscape framing, overlaps the landscape-sweep areas. Aug 2025.
- **`docs/AI Dev Feature Matrix.html`** + **`AI Dev Feature Futures.html`** — Google-Sheets exports (single minified line each): a per-tool feature matrix and a "expected future features" table (fully-autonomous engineering, multi-agent systems, project orchestration, legacy modernization, generative UI, compliance intelligence — with per-vendor attributions). MEDIUM as a structured competitive snapshot; needs de-HTML'ing to read. Aug 2025.
- `docs/USAGE_GUIDE.md` (1181), `INTEGRATION_EXAMPLES.md` (898), `API_REFERENCE.md`, `ARCHITECTURE.md` — usage/API surface, mostly self-referential to this harness. LOW for the sweep.

## Dry wells / deliberately excluded
- **`lib/simple_agent/cli.ex`** (503) — the CLI is human-facing (emoji output, `System.halt(1)` exit codes, `--task/--count/--id` switches) with **no machine-readable/JSON output mode** and no non-interactive agent-mode flag. Checked for the "agent-mode conventions (structured output, exit codes)" gold and found little: exit codes exist, structured stdout does not. Noted, not mapped further.
- **Streaming**: grepped `stream` across `lib/` — appears in beta-header names, WebSocket-MCP framing, and option docs, but the Anthropic message streaming path is explicitly "not yet implemented" (`anthropic_options.ex` doc, and no SSE handling in `anthropic_client.ex`). Dry well for streaming-handling gold.
- `doc/` (generated ExDoc HTML) and `cover/` (coverage HTML) — build artifacts, redundant with source; not read.
- `deps/`, `_build/`, `erl_crash.dump`, `simple_agent` (4 MB compiled binary), `benchmarks/`, `test/` — skipped; tests confirm shapes already read in source.

## Searches / commands run
- `git log -1`, `git remote -v` → provenance (Aug 2025, v2-cortex, first-party).
- `find . -type f` (tree), `wc -l lib/**` → source layout.
- Read: definitions.ex (full), executor.ex (dispatch/sandbox/envelope/code-exec), agent.ex (loop + system-prompt builder), anthropic_client.ex (beta headers), anthropic_options.ex (models/betas), anthropic.ex (tool formatting), context_cache.ex (cache_control), mcp/tool_executor.ex + tool_registry.ex, stdio_port.ex (moduledoc), task_behavior.ex, config.ex, cli.ex.
- `grep -rln stream lib/` → streaming reality check (dry well).
- Sampled docs/*.md heads + de-HTML'd the two feature .html files.
