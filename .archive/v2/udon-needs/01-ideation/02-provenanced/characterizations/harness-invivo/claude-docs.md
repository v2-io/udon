---
source: harness/CLI in-vivo sweep — repo ~/src/_ref/claude-docs (Anthropic official developer-docs clone)
gathered: 2026-07-21
status: vetted mining-spot map
---

# claude-docs — Anthropic official tooling model (docs clone)

**What this repo is.** Not code — a static clone of Anthropic's developer documentation site (platform.claude.com/docs). No `.git` (clone date from file mtimes: **2026-07-17**; `llms.txt` says 1894 English pages). It is the **canonical spec** for how Anthropic's own harnesses/SDKs define tools, drive the agentic loop, and design edit/streaming/structured-output tooling — i.e. the "what should the in-vivo harness do" reference rather than a running harness.

**Format caveat (matters for mining).** The high-value pages under `docs/en/agents-and-tools/tool-use/` and `docs/en/build-with-claude/` are **clean Markdown** (with `<CodeGroup>`/`<Accordion>`/`<Note>` MDX components and real cURL/Python/TS/JSON snippets). Some sibling pages are **rendered HTML dumps** (`<!DOCTYPE html>` — Next.js) and are painful to mine: `agent-sdk/overview.md`, `agent-sdk/permissions.md`, `mcp.md`, and everything under `cookbook/*.html`. The top-level `*.html` files (`docs.html`, `claude-code.html`, `cost.html`, …) and `llms-full.txt` (90 MB, all pages concatenated) are redundant with the clean Markdown — skip them; mine the Markdown.

**Center of mass:** `docs/en/agents-and-tools/tool-use/` — 27 clean-Markdown files, this is where the tool-definition schema model, edit-tool design, the agentic loop, streaming, and every recent tooling advancement live.

---

## HIGH priority — tool-definition model, edit tool, agentic loop

- **`docs/en/agents-and-tools/tool-use/define-tools.md`** (917 lines) — the tool schema contract: the `name`/`description`/`input_schema`/`input_examples` parameter table (L36–44), the JSON-Schema tool-definition shape with worked `get_weather` example (L46+), how to write effective tool descriptions, and controlling when Claude calls a tool. This is the primary "how a tool is defined" source. Date: current (references Opus 4.8). **Highest priority.**

- **`docs/en/agents-and-tools/tool-use/how-tool-use-works.md`** (100 lines) — concise conceptual model: the "tool-use contract" framed as a typed function interface (L11–15); the three execution buckets — user-defined (client), Anthropic-schema client tools (`memory`/`bash`/`text_editor`/`computer`, "trained-in schemas" L37–41), server-executed (`web_search`/`web_fetch`/`code_execution`/`tool_search`); and the canonical `while stop_reason == "tool_use"` agentic loop (L60–80). Best single orientation file. Current.

- **`docs/en/agents-and-tools/tool-use/text-editor-tool.md`** (2277 lines) — **the edit-tool design source.** Tool name `str_replace_based_edit_tool`, type `text_editor_20250728`, optional `max_characters` view-truncation (L26–34). Commands section L261+: `view` (L265), **`str_replace`** with `old_str` (exact-match incl. whitespace) / `new_str` (L305–330), `create` (L332), `insert` with `insert_line`/`insert_text` (L357–368). Directly answers "str-replace? patches? verification?": it's exact-string-match replace + line-insert + full-file create, no diff/patch. Current (Opus 4.8 examples).

- **`docs/en/agents-and-tools/tool-use/overview.md`** (903 lines) — full tool-use landing page with parallel cURL/CLI/Python/TS examples (L11+), when-to-use each tool type, and the server-side loop / `pause_turn` behavior. Current (`web_search_20260209`, `claude-opus-4-8`). Overlaps how-tool-use-works but has the runnable multi-language snippets.

- **`docs/en/agents-and-tools/tool-use/handle-tool-calls.md`** (277 lines) — the tool-call lifecycle by hand: reading `tool_use` blocks (`id`/`name`/`input` L18–22), formatting `tool_result` blocks, error signaling; explicitly the manual alternative to Tool Runner. Current. High for "how results flow back."

- **`docs/en/agents-and-tools/tool-use/tool-reference.md`** (77 lines) — the **version/registry table**: every Anthropic-provided tool with its dated `type` strings and GA/beta status (web_search `_20260318`/`_20260209`/`_20250305`, code_execution `_20260521`…, advisor `_20260301` beta, tool_search `_regex_20251119`/`_bm25_20251119`, mcp `mcp_toolset` beta, memory/bash/text_editor client, etc.), plus the optional tool-definition properties (`cache_control`, `strict`, `defer_loading`, `allowed_callers`). Compact index into everything else. Current.

- **`docs/en/build-with-claude/structured-outputs.md`** (2866 lines) — structured output + strict tool use: two mechanisms — JSON outputs via `output_config.format` and `strict: true` for schema-guaranteed tool inputs via constrained decoding (L7–11, L40+); model support matrix (L18, names Fable 5 / Mythos 5 / Opus 4.8); migration note `output_format`→`output_config.format` (L27). Core for machine-readable/typed output. Current.

- **`docs/en/agents-and-tools/tool-use/strict-tool-use.md`** (1069 lines) — `strict: true` deep dive: grammar-constrained sampling guarantees inputs match JSON Schema, why it matters for agents (avoids `"2"` vs `2` / missing fields L20+), supported JSON-Schema subset pointer. Current.

---

## HIGH priority — recent tooling advancements (context/scale)

- **`docs/en/agents-and-tools/tool-use/tool-search-tool.md`** (868 lines) — the **tool-search advancement**: on-demand tool discovery/loading for hundreds/thousands of tools; concrete numbers — multiserver setups burn ~55k tokens up front, tool search cuts >85%; tool-selection accuracy degrades past 30–50 tools (L7–13). Server-side `tool_search_tool_regex/bm25_20251119`, plus a custom client-side implementation section. Recent (Nov-2025 type strings). This is a headline "recent tooling advancement."

- **`docs/en/agents-and-tools/tool-use/programmatic-tool-calling.md`** (1584 lines) — Claude writes code in a code-execution container to call your tools programmatically instead of per-call model round-trips; cuts latency + tokens, +11% on BrowseComp/DeepSearchQA with 24% fewer input tokens (L7–9); the 20-employee budget-check worked example (L11). Requires code_execution. Recent advancement.

- **`docs/en/agents-and-tools/tool-use/manage-tool-context.md`** (65 lines) — the four context-management levers as a decision table (L11–19): tool-search (defs), programmatic tool calling (`tool_result` roundtrips), prompt caching (repeated defs), context editing (old `tool_result` blocks). Best one-screen map of the "context-management around tool results" question. Current.

- **`docs/en/agents-and-tools/tool-use/fine-grained-tool-streaming.md`** (928 lines) — streaming a tool's input as generated, no server buffering/validation via `eager_input_streaming: true` per-tool (replaces the old `fine-grained-tool-streaming-2025-05-14` beta header, L20–24); warns you may get partial/invalid JSON and must guard the parse (L11–15). Directly the "streaming handling" gold. Current.

- **`docs/en/agents-and-tools/tool-use/advisor-tool.md`** (~500+ lines) — the **advisor pattern** (beta `advisor_20260301`): a fast executor model consults a higher-intelligence advisor model mid-generation for a plan/course-correction; targeted at long-horizon agentic/coding/computer-use workloads (L7–11), with a mermaid sequence diagram. Newest tooling primitive here (Mar-2026). Recent.

- **`docs/en/build-with-claude/context-editing.md`** (3065 lines) — automatic clearing of stale `tool_result` blocks from history to bound context in long agent runs. Large; the "context-management around tool results" mechanism in full. Current.

---

## MEDIUM priority — server tools, MCP, skills, streaming/stop-reasons, tool runner

- **`docs/en/agents-and-tools/tool-use/tool-runner.md`** (1728 lines) — the SDK abstraction that auto-drives the agentic loop (runs tools, manages conversation state, type-safety/validation); Python `@beta_tool`/`@beta_async_tool` decorator, per-SDK links (Python/TS/C#/Go/Java/PHP/Ruby, L18); tools return string or content blocks incl. multimodal (L30–32). Beta. Shows Anthropic's own harness ergonomics.

- **`docs/en/agents-and-tools/tool-use/memory-tool.md`** (1025 lines) — client-side `memory_20250818` tool: Claude auto-checks a `/memories` dir before a task and writes learnings back across sessions (L27–31); the app maps `/memories` onto real storage and must restrict path traversal (L33). Worked call/tool_result trace (L42+). Relevant to persistent-context tooling. Current.

- **`docs/en/agents-and-tools/tool-use/bash-tool.md`** (1984 lines) — Anthropic-schema `bash_20250124` client tool (shell execution). Mine for its schema + agent-mode shell conventions. Current.

- **`docs/en/agents-and-tools/tool-use/code-execution-tool.md`** (1562 lines) — server-side sandboxed code execution (`code_execution_20260521`…); underpins programmatic tool calling. Current.

- **`docs/en/agents-and-tools/tool-use/computer-use-tool.md`** (2181 lines) — `computer` client tool (screen/mouse/keyboard control) schema + loop. Current. Medium unless computer-use is in scope.

- **`docs/en/agents-and-tools/tool-use/web-search-tool.md`** (683 lines) & **`web-fetch-tool.md`** — server tools; schemas + `server_tool_use` result shapes. Current.

- **`docs/en/agents-and-tools/tool-use/parallel-tool-use.md`** (1577 lines) — emitting/handling multiple `tool_use` blocks in one turn; batching semantics. Current.

- **`docs/en/agents-and-tools/tool-use/server-tools.md`**, **`tool-combinations.md`**, **`tool-choice`** (in overview) — server-loop mechanics, combining tool types, forcing/disabling tool calls. Current. Skim-level.

- **`docs/en/agents-and-tools/agent-skills/best-practices.md`** (1179 lines) — **Skill-authoring / instruction-design gold**: "Concise is key" (L13), degrees-of-freedom (L61), progressive-disclosure patterns (high-level+refs / domain-org / conditional-details, L251–369), naming conventions (L168), writing effective descriptions (L201), test-with-all-models (L134), TOC-structured reference files (L399). This is how Anthropic tells authors to write tool/agent instructions — directly relevant to UDON-as-agent-instruction-surface. Current.  
  **High if instruction ergonomics are in scope.**

- **`docs/en/agents-and-tools/agent-skills/overview.md`** (337 lines) — Agent Skills model (SKILL.md + bundled files, filesystem-based progressive disclosure). Current. Companions: `quickstart.md`, `enterprise.md`, `claude-api-skill.md`.

- **`docs/en/agents-and-tools/mcp-connector.md`** (1499 lines) — MCP client via Messages API without a separate MCP client; beta header `mcp-client-2025-11-20` (L11), `mcp_toolset` type, all/allowlist/denylist tool config, per-tool config, OAuth (L18–24). The clean-Markdown MCP source (prefer over the HTML `mcp.md`). Current.

- **`docs/en/build-with-claude/streaming.md`** (1521 lines) — SSE streaming event model (`content_block_start`/`delta`/`stop`, `input_json_delta` for tool inputs). The substrate fine-grained tool streaming rides on. Current.

- **`docs/en/build-with-claude/handling-stop-reasons.md`** (3619 lines) — every `stop_reason` (`tool_use`, `end_turn`, `max_tokens`, `pause_turn`, `refusal`, …) and how a harness should branch on each — the control logic of the agentic loop. Current.

- **`docs/en/cli-sdks-libraries/cli/scripting.md`** (181 lines) — the **`ant` API CLI** agent-mode/automation: version-controlling API resources, chaining list output into a second command (L146), inspecting errors (L159), using the CLI from Claude Code (L173). Machine-readable/scripting conventions. Current.

- **`docs/en/cli-sdks-libraries/cli/using.md`** (216 lines) — CLI global flags, output formats (yaml/json), GJSON output transforms (L66), stdin/file request bodies (L128–150), debugging. The "non-interactive flags / machine-readable output" material. Current. Companions: `authentication.md`, `quickstart.md`.

---

## LOW priority / situational

- **`docs/en/agents-and-tools/tool-use/tool-use-with-prompt-caching.md`** (105 lines) — caching tool definitions across requests; one of the four context levers.
- **`docs/en/agents-and-tools/tool-use/build-a-tool-using-agent.md`** (4674 lines) — long end-to-end tutorial; redundant with the reference pages, useful only for a full worked trajectory.
- **`docs/en/agents-and-tools/tool-use/troubleshooting-tool-use.md`** (79 lines) — short FAQ of common tool-use failures.
- **`docs/en/agents-and-tools/tool-use/tool-use-with-*` / `server-tools.md` / `remote-mcp-servers.md`** (33 lines, stub).
- **`cookbook/*.html`** (84 files, HTML dumps) — agent-SDK / tool-use / managed-agents notebooks (`tool-use-tool-choice`, `tool-use-memory-cookbook`, `patterns-agents-*`, `claude-agent-sdk-0X-*`, `managed-agents-*`). Real runnable examples but HTML-rendered (hard to mine); go here only if a specific pattern (evaluator-optimizer, orchestrator-workers) is needed.

## Dry wells / avoid

- **`agent-sdk/overview.md`, `agent-sdk/permissions.md`, `api/agent-sdk/overview.md`, `mcp.md`** — HTML dumps (`<!DOCTYPE html>`), not clean Markdown. The agent-SDK *concepts* aren't well-served in clean form in this clone; the tool-use Markdown pages carry the substance instead. Skip unless you parse the HTML.
- **Top-level `*.html`** (`docs.html`, `claude-code.html`, `cost.html`, `dashboard.html`, `usage.html`, `sitemap.xml.html`) and **`llms-full.txt` (90 MB)** — rendered/aggregated duplicates of the Markdown. No unique content.
- **`docs/en/api/{python,typescript,go,java,ruby,php,csharp,cli}/`** and `api/**/mcp_oauth_validate.md` etc. — per-language API method reference, mostly generated stubs; not tooling-design signal.

---

## Log of searches / commands run

- `ls`, `find -maxdepth 2 -type d` on repo root and `docs/en` — mapped section tree; no `.git` (confirmed clone, not repo); file mtimes → clone date 2026-07-17.
- `ls docs/en/agents-and-tools/tool-use/` — enumerated the 27-file tool-use dir (the center of mass).
- `find docs/en -iname '*mcp*'` — located mcp-connector.md (clean) vs mcp.md (HTML) and the per-language oauth stubs.
- `head -c 15` probe across candidates to separate clean Markdown (`#`) from HTML dumps (`<!DOCTYPE html>`) — found agent-sdk/*, mcp.md, cookbook/* are HTML.
- Read intros/bodies (`head`/`sed -n`) of: overview, how-tool-use-works, define-tools, text-editor-tool (grepped str_replace/insert command sections), tool-search-tool, programmatic-tool-calling, manage-tool-context, strict-tool-use, fine-grained-tool-streaming, tool-reference, handle-tool-calls, memory-tool, tool-runner, structured-outputs, advisor-tool, mcp-connector, skills/best-practices (grepped headers), cli/scripting, cli/using.
- `find cookbook -type f | wc -l` = 84; grepped tool/agent/mcp — all `.html`.
- `head llms.txt` — confirmed it's a docs-index manifest (1894 EN pages), and llms-full.txt is the 90 MB concatenation (skip).

**Dry wells:** agent-sdk conceptual docs are HTML-only in this clone (no clean-Markdown agent-SDK narrative); cookbook is entirely HTML; per-language `api/` trees and the top-level `*.html` snapshots carry no unique tooling-design content. The genuinely minable signal is a small, well-bounded fraction: `docs/en/agents-and-tools/tool-use/*` plus a handful under `build-with-claude/` and `cli-sdks-libraries/cli/`.
