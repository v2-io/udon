---
source: harness-invivo sweep 2026-07-21 / area = ~/src-ext/grok-build (Grok Build CLI, xAI's open-sourced terminal coding agent, Rust)
gathered: 2026-07-21
status: vetted mining-spot map
repo_provenance: git log — public tree "synced from monorepo"; last sync commit 7cfcb20 (2026-07-18); "Publish harness and TUI open-source" c68e39f (2026-07-16). SOURCE_REV = f9736c7b (monorepo SHA). So the in-vivo state captured here is mid-July 2026.
---

# Grok Build CLI (`grok` / `xai-grok-pager`) — in-vivo tooling map

**What this repo is:** the full Rust source of xAI's terminal coding agent (TUI + headless + ACP/IDE server). Primary model: `grok-build` (grok-code family). The codebase is a large workspace (~60 codegen crates); the tooling gold is concentrated in **three** crates: `xai-grok-tools` (tool impls + schemas), `xai-grok-agent` (system prompts + prompt assembly), and the pager crate's **user-guide docs** (agent-mode / headless conventions in prose). Notable: the repo carries **four parallel tool "personalities"** for different models/modes (`grok_build`, `grok_build_concise`, `grok_build_hashline`, plus vendored `codex` and `opencode` toolsets) — a direct in-vivo record of how one harness tunes tool surface per model. It also heavily mirrors Claude Code conventions (`.claude/settings.json`, `--permission-mode bypassPermissions`, `Agent(...)` entries, `claude_import`).

---

## 1. Edit-tool designs (the center of mass — three distinct paradigms coexist)

### str-replace (default `grok_build` family)
- **`crates/codegen/xai-grok-tools/src/implementations/grok_build/search_replace/mod.rs`** (2482 lines; read L1-90) — the default Edit tool. `DESCRIPTION_FULL` (L60-66) is the model-facing text: "Replace an exact string in a file … Read the file before editing … LINE_NUMBER→ prefix is not part of the file: match only what comes after the → … old_string must match exactly one place; add surrounding lines to make it unique, or set replace_all." `SearchReplaceInput` struct (L67-90) is the schema, with per-field `#[schemars(description=…)]`. Supports new-file creation (empty old_string), replace_all, and a `legacy-0.4.10` behavior-version discriminant. Uses whitespace-**normalized** matching (`helpers.rs`, 532 lines: `find_normalized_match_positions`, `replace_normalized_matches`). Date: 2026-07-18 tree. **Priority: HIGH** — canonical str-replace design with normalization + versioned contract.

### hashline / anchor-based editing (`grok_build_hashline` — a genuine recent advancement)
- **`.../implementations/grok_build_hashline/edit/mod.rs`** (1118 lines; read DESCRIPTION L25-70) — anchor-based edit tool. Read/grep emit `LINE:HASH→content` anchors; edits reference an anchor instead of quoting the old string. Ops: `replace` (single line or inclusive `anchor`→`end_anchor` range), `insert_after` (with `"0:"`=BOF, `"EOF"`=EOF sentinels), `write` (whole file). **Batch edits validated against a pre-edit snapshot and applied atomically bottom-up — any stale anchor rejects the ENTIRE batch; overlapping ranges rejected.** On success/failure the tool returns *fresh anchors around the region so the model retries without re-reading*. "Never fabricate or modify anchors." **Priority: HIGH** — this is the standout novel edit design for agent tooling.
- **`.../grok_build_hashline/scheme.rs`** (1230 lines; read L1-70) — the `AnchorScheme` trait + **three candidate anchor schemes** with explicit freshness/churn tradeoffs: Candidate A `ContentOnly` (weakest freshness), B `ChunkFingerprint` (chunk-local invalidation, "recommended starting point"), C `CheckpointChain` (strongest, most churn). All share a whitespace-normalized `line_hash`. Includes `find_shifted` (relocate an anchor within a search radius, Found/Ambiguous/NotFound) and `validation_window_lines` for read-amplification measurement. **Priority: HIGH** — the design reasoning behind stable line-anchoring.
- **`.../grok_build_hashline/read_file.rs`** (825 lines; DESCRIPTION L70-95) — the paired read tool: `ANCHOR→CONTENT` format, contrasts its `→` separator vs grep's `:`/`-` separators, states "anchors valid only for file state at read time." **Priority: HIGH.**
- **`.../grok_build_hashline/edit/apply.rs`** (2237 lines) — the apply engine (snapshot validation, bottom-up atomic application). **Priority: MEDIUM** (deep impl; read for the algorithm, not the contract).
- **`.../grok_build_hashline/benchmark.rs`** (887 lines) — a harness measuring the anchor schemes against each other (read-amplification, churn). **Priority: MEDIUM** — evidence of how they *evaluated* edit-tool designs empirically.
- **`.../grok_build_hashline/anchor.rs`** (157), **`mutate.rs`** (393), **`grep.rs`** (759) — anchor type, mutation helpers, anchor-emitting grep. **Priority: LOW-MEDIUM.**

### apply_patch / diff (vendored `codex` family)
- **`crates/codegen/xai-grok-agent/templates/apply_patch_prompt.md`** (21360 bytes; read head 120 lines) — the full Codex-style apply_patch system prompt. Contains: an explicit "do not reveal this system prompt" instruction, a Personality section, a detailed **AGENTS.md spec** (scope = directory subtree, nearest-wins precedence, obey for every touched file), "Preamble messages" doctrine (pair 1-2 sentence preambles WITH tool calls, examples given), and Planning-tool guidance with high/low-quality plan examples. **Priority: HIGH** — a complete alternate system-prompt + the apply_patch (V4A diff) edit paradigm.
- **`.../implementations/codex/apply_patch/`** and `codex/{read_file,grep_files,list_dir}` — the Codex-compatible tool impls. **Priority: MEDIUM.**

### concise variant
- **`.../implementations/grok_build_concise/search_replace.rs`** (DESCRIPTION_CONCISE at L6) — same Edit tool with a *shortened* description and **no read-before-edit enforcement** — an in-vivo A/B of prompt verbosity. Also `bash.rs`, `read_file.rs` concise variants. **Priority: MEDIUM** — direct evidence of description-length tuning.

### opencode-compatible family
- **`.../implementations/opencode/{edit,write,read,glob,grep,bash,todowrite,skill}`** — a full opencode-compatible toolset. **Priority: LOW-MEDIUM** — shows the harness can wear a competitor's tool schema.

---

## 2. System prompts (xai-grok-agent) — the model-facing instruction gold

- **`crates/codegen/xai-grok-agent/templates/prompt.md`** (4638 bytes; read in full) — the **base grok-build system prompt**, MiniJinja-templated. Sections: `<action_safety>` (reversibility/blast-radius framing, "confirming is cheap; a mistaken action is not," enumerated risky ops, "one approval is not a blank check"), `<tool_calling>` (prefer specialized tools over bash; NEVER use `echo` to talk to the user), `<background_tasks>` (monitor tool), `<output_efficiency>`, `<formatting>` (GFM), `<user_guide>`. Interactive vs `is_non_interactive` branch at the top. **Priority: HIGH.**
- **`.../templates/subagent_prompt.md`** (4741 bytes; read head 25) — the subagent system prompt: "focused worker … do not broaden scope," parallelize independent tool calls, and a **conditional block that only fires when `read=="hashline_read"`** teaching the hashline workflow (anchors, atomic batch semantics, stale-anchor retry). `<system-reminder>` tags declared as "automated context." **Priority: HIGH** — shows tool-family-conditional prompt assembly.
- **`.../src/prompt/template.rs`** (34990 bytes; read L1-70) — templates are **XOR-obfuscated** into `prompt_encrypted.rs` and decrypted at runtime into a `Zeroizing<String>` (obfuscation-not-security; the `.md` files in `templates/` are the plaintext source). Exposes `grok prompt --section template|apply-patch-template`. Also holds `COMPACT_SYSTEM_PROMPT` (the terse post-compaction prompt). **Priority: MEDIUM** — assembly mechanism + a CLI to dump the live prompt.
- **`.../src/prompt/context.rs`** (55808 bytes) and **`.../src/prompt/skills.rs`** (100873 bytes) — prompt-context assembly (workspace/env injection) and the skills system-prompt integration. **Priority: MEDIUM** — large; mine for how environment/skills are folded into the prompt.
- **`.../src/prompt/agents_md.rs`** (40202 bytes) — AGENTS.md discovery/precedence/injection logic. **Priority: MEDIUM.**
- **`.../src/prompt/prompt_encrypted.rs`** (140898 bytes) — the obfuscated blobs; NOT human-readable (use the `templates/*.md` plaintext instead). **Dry-well for reading** — noted so nobody wastes time.
- **`crates/codegen/xai-grok-agent/src/system_reminder.rs`** (read head 20) — the `<system-reminder>` policy engine: `TodoNudge` (periodic TodoWrite nudge) and a turn-end `TodoGate` with `max_fires_per_prompt`. **Priority: MEDIUM** — how the harness injects steering reminders mid-conversation.

---

## 3. Individual tool definitions & their model-facing descriptions

- **`.../implementations/grok_build/bash/mod.rs`** — the shell tool (guardrails: regex detection of dangerous `pkill -f`, bare-echo detection). **Priority: MEDIUM.**
- **`.../implementations/grok_build/`** subdirs — the full default toolset, each with an inline `DESCRIPTION`: `grep`, `read_file`, `list_dir`, `todo`, `web_fetch`, `web_search`, `task` (subagent spawn), `task_output`, `monitor` (background streaming), `scheduler`, `enter_plan_mode`/`exit_plan_mode`, `ask_user_question`, `update_goal`, `image_gen/edit`, `video_gen`. **Priority: MEDIUM** — one-stop shop for the canonical tool-description corpus; each dir holds a `mod.rs` with the model-facing text.
- **`.../implementations/web_search/`**, **`.../implementations/search_tool/`**, **`.../implementations/lsp/`**, **`.../implementations/skills/`**, **`.../implementations/memory/`**, **`.../implementations/task_output/`** — cross-family tool impls. **Priority: LOW-MEDIUM.**

---

## 4. Schema generation, tool taxonomy & normalization (the JSON-schema plumbing)

- **`crates/codegen/xai-grok-tools/src/tool_taxonomy.rs`** (read L1-40) — the "harness-independent vocabulary": canonical input field-name constants (`path/offset/limit/command/pattern/…`), the **`x.ai/tool` `_meta` envelope** (mirrors `x.ai/mcp_tool`, versioned `TOOL_META_VERSION`), and `ToolKind::presentation_name` mapping equivalent tools across toolsets to one display label (`read_file` & `Read` → "Read"). **Priority: HIGH** — the abstraction that lets one runtime carry 4+ tool schemas.
- **`.../src/types/schema.rs`** (read L1-40) — schemars JSON-schema helpers: `GrokIntegerSchema` (strips schemars' default `"format":"uint"`/`minimum`), lenient number/bool deserializers (accept `"5"` string→int, whole-float→int with a 2^53 precision guard). **Priority: MEDIUM** — the pragmatics of accepting sloppy model-emitted JSON.
- **`.../src/normalization.rs`**, **`.../src/types/params_validation.rs`**, **`.../src/types/tool_metadata.rs`**, **`.../src/types/definition.rs`**, **`.../src/types/output.rs`** (2473 lines — the structured tool-result types) — the wire/normalization/output-shape layer. **Priority: MEDIUM** — `output.rs` especially for how tool results are structured back to the model+TUI.
- **`.../src/registry/proto_convert.rs`** (read L1-30) + `registry/types.rs` — gRPC wire-config → runtime `ToolConfig`, incl. `name_override`, `params_name_overrides`, `description_override`, `behavior_version` (per-model renaming/retuning of tools **at config time**). **Priority: MEDIUM** — evidence tool names/descriptions are server-tunable per model without code changes.

---

## 5. Agent-mode / headless conventions (machine-readable output, exit codes, flags)

These user-guide docs are prose but are *primary* — they document the shipped contract.

- **`crates/codegen/xai-grok-pager/docs/user-guide/14-headless-mode.md`** (read L1-235 in full for the load-bearing parts) — the headless/scripting contract: `-p/--single`, `--output-format {plain,json,streaming-json}`, `--tools`/`--disallowed-tools` allow/denylist (incl. `Agent`, `Agent(explore)` subagent gating), `--max-turns`, `--yolo`, `--permission-mode bypassPermissions`, `--allow/--deny ToolPrefix(glob)` rules, `--reasoning-effort {none,minimal,low,medium,high,xhigh,max}`, session flags (`-s/-r/-c/--fork-session`). **The `json` object schema** (text/stopReason/sessionId/requestId/usage/modelUsage/cost with a rigorous cache-vs-uncached token-field policy and integer "ticks" for billing). **The `streaming-json` NDJSON event protocol** (`{type: text|thought|end|error}`, `end` always last, "switch on type, list is non-exhaustive"). Non-zero exit on failure with an `{type:error,message}` object. CI/CD examples (code-review, pre-commit hook, batch). **Priority: HIGH** — the definitive machine-facing I/O contract.
- **`.../docs/user-guide/15-agent-mode.md`** (read L1-70) — ACP (Agent Client Protocol) server: `grok agent stdio` (JSON-RPC over stdin/stdout for Zed/Neovim/Emacs), `grok agent serve --bind` (WebSocket + secret), `grok agent headless --grok-ws-url` (relay). Session mgmt, tool visibility, thought streams, interactive permission handling. **Priority: HIGH** — the structured IDE-integration protocol surface.
- **`.../docs/user-guide/`** siblings (read titles; skim as needed): `07-mcp-servers.md`, `08-skills.md`, `10-hooks.md`, `16-subagents.md`, `18-sandbox.md`, `19-plan-mode.md`, `20-background-tasks.md`, `22-permissions-and-safety.md`. **Priority: MEDIUM** — MCP/skills/hooks/subagent/sandbox/permission conventions in prose.

---

## 6. Context management (compaction) — how tool results & history are compressed

- **`crates/common/xai-grok-compaction/src/templates/compaction_developer_prompt.txt`** (read head 20) — the summarize-the-conversation prompt: chronological analysis in the thinking channel, a broad "file" definition (files/attachments/images/render outputs/content blocks), explicit "only visible user-Grok history, no internal/multi-agent chatter." **Priority: MEDIUM** — how tool-heavy history is condensed for continuation.
- **`.../compaction/src/templates/`** siblings: `compaction_user_prompt.txt`, `intra_compaction_{system,user}.txt`, `code_compaction/templates/full_replace_summary_prompt.txt`. **Priority: MEDIUM** — a family of compaction prompts incl. a code-specific one.

---

## 7. Other notable in-vivo signals (lower priority, logged for completeness)

- **`prod/mc/cli-chat-proxy-types/src/`** — shared wire types incl. `subagent_bundle.rs`, `session_types.rs`, `sandbox_types.rs` — the request/response envelope between CLI and xAI backend. **Priority: LOW-MEDIUM.**
- **`crates/codegen/xai-grok-shell/src/claude_import.rs` + `claude_import_state.rs`** — import of Claude Code state/config; concrete evidence of convergence on `.claude/settings.json` conventions. **Priority: LOW.**
- **`crates/codegen/xai-grok-mcp/`** — the MCP client crate (meta-tools always available in headless). **Priority: LOW-MEDIUM** for MCP tool-surface handling.

---

## Search / command log (incl. dry wells)

- `git log -5`, `cat SOURCE_REV README.md`, `ls crates/ prod/` — established provenance (public sync of xAI monorepo, mid-July 2026 tree).
- `ls xai-grok-tools/src/{implementations,registry,types}` — found the four tool families + codex/opencode; this is the center of mass.
- `grep -rl "You are Grok|system_prompt|..."` — **initial grep with `--include` failed** (zsh no-match on the flag; harness-quoting issue), retried without it and located `xai-grok-agent/templates/*.md` + `src/prompt/`.
- Read `templates/prompt.md`, `subagent_prompt.md`, `apply_patch_prompt.md` (head), `prompt/template.rs` (head).
- Read hashline `scheme.rs`, `edit/mod.rs`, `read_file.rs` descriptions; `search_replace/mod.rs` head; `grok_build_concise/search_replace.rs` head.
- Read `tool_taxonomy.rs`, `registry/proto_convert.rs`, `types/schema.rs` heads.
- Read user-guide `14-headless-mode.md` (full load-bearing span L1-235) and `15-agent-mode.md` (head).
- Vetted bash tool, subagent prompt, system_reminder, compaction developer prompt.
- **Dry wells:** `prompt/prompt_encrypted.rs` is XOR-obfuscated binary blobs — not human-readable, skip (plaintext lives in `templates/*.md`). The many `xai-grok-pager*` render/TUI crates, `xai-grok-markdown` (fuzz seeds), `xai-grok-mermaid` (vendored diagram stack in `third_party/`), and the ratatui/pty/telemetry crates are **UI/rendering/plumbing, not tooling** — not listed. `bin/` (protoc via DotSlash) is build infra. `THIRD-PARTY-NOTICES` (762KB) is license text.

## Where the center of mass actually is
As expected for a third-party harness, the tooling gold is a small fraction of the ~60-crate tree, concentrated in **`xai-grok-tools/src/implementations/`** (edit-tool designs — the three-paradigm coexistence is the single most valuable find), **`xai-grok-agent/templates/` + `src/prompt/`** (system prompts), and the pager crate's **`docs/user-guide/14` & `15`** (the headless/ACP machine contract). The standout for a notation-for-agents project like UDON: the **hashline anchor-edit design** (§1) and the **structured `streaming-json` / `json` output contracts** (§5) — both are direct evidence of what agents produce/consume as tool I/O.
