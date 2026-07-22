---
source: ~/src/_core/sapientia/bin/ (minimal-sapientia + siblings)
gathered: 2026-07-21
status: vetted mining-spot map
scope: >
  Characterizes the actual tool buildout in the sapientia-era Ruby harness —
  how it defines, dispatches, and presents tools to an agent (an ELI), and
  where each distinctive mechanism lives in code. Every entry from a direct
  read; line ranges into minimal-sapientia's 4,491 lines. Priorities are
  relevance-to-UDON-demand-side (agent-facing tooling), not code quality.
harness_facts:
  language: Ruby, single file, single class (MinimalSapientia @ L17), no gem/module packaging
  model: constant MODEL = 'claude-sonnet-4-5-20250929' (L19) — no assistant set-model tool
  context: CONTEXT_WINDOW = 1_000_000 (L24) via beta header 'context-1m-2025-08-07' (L1699/1716)
  budgets: MAX_TOKENS = 6_900 (L20); THINKING_BUDGET = 25_000 (L21); DEFAULT_TEMPERATURE = 1.0 (L23)
  git_last_touched: 2025-11-09 (cdeec38, "Temporarily disable server-side websearch")
---

# sapientia/bin — tool buildout mining-spot map

The built artifact **is** the crystallized sapientia-era thesis: an agent (an ELI) is a first-class inhabitant of the loop who perceives time passage, steers its own sampling, measures its own context pressure, curates its own memory files, and cannot talk past a corrupted causal chain. The tools are the surface where that ideology touches the model. What follows is where each mechanism lives.

## How I read the harness survey's claims

The harness survey (`~/src/archema-io/harness/proprium/stalled-lineage/SURVEY-sapientia-zoetica-ennaos-nexum.md`) gave a §B "deep cut" table of standout capabilities. **Against the code, every one of its claims holds** — model-as-constant, `set-sampling`, `toggle-tracking`, tracking snapshots, Zoetica time notation, incomplete-state gate, dual JSONL+git audit, `@import` identity, AFK/interrupt, self-token tools, multi-match safety, stale council/deliberation shell-out paths. Three corrections / additions the survey (and the Dec-14 awakening plan) did not surface are noted in **§ Corrections** at the bottom — all first-class findings.

---

## PART 1 — minimal-sapientia (157KB / 4,491 lines; git head 2025-11-09)

### The tool-buildout core (HIGH — this is the whole question)

**`get_tool_definitions` — L1112–1347.** The entire client-tool surface is a single literal Ruby array of hashes, each `{name, description, input_schema}` with a hand-written JSON-Schema `input_schema`. No registry, no decorators, no DSL — the tool list *is* this array, read top to bottom. 11 client tools: `read-file`, `bash`, `write-file`, `count-file-tokens`, `count-context-tokens`, `set-sampling`, `toggle-tracking`, `text-editor`, `deliberation-participate`, `council-participate`, `praxes-query`. Distinctive: the *descriptions* carry behavioral warnings meant for the model, not the developer — e.g. set-sampling's "temperature != 1.0 or top-p < 0.95 disables thinking blocks" (L1196), and praxes-query's "Returns file paths (query-for-files pattern, not answers)" (L1326). The schema is the teaching surface.

**`execute_tool` dispatch — L1349–1376.** A flat `case tool_name … when` that maps each tool name to an `execute_*` method and returns `{ error: "Unknown tool" }` on miss. Dumb, legible, one hop. Everything is a Ruby method returning a Hash.

**`handle_tool_use` — L3965–4113 (HIGH).** The load-bearing loop glue and the most distinctive dispatch behavior:
- **Preserves ALL response blocks verbatim** back into history — thinking, text, tool_use, `server_tool_use`, `web_search_tool_result`, citations, `encrypted_content` (L3987–3999, comment cites the Anthropic multi-turn requirement). This is the "don't lie to the model about its own prior turn" discipline in code.
- **Incremental JSONL persistence at each sub-step** — user message saved *before* tool execution (L3972–3981), assistant+tool_use saved (L4056–4063), tool_results saved (L4069–4076), final response saved (L4102–4110). Crash at any point leaves a recoverable, honest partial. This is why the incomplete-state machine (below) can exist.
- Per-tool display formatting for the human terminal (L4004–4039) — text-editor shows the diff preview, web-search shows the query.
- Tool results wrapped as `{type: 'tool_result', tool_use_id, content}` with Hash results JSON-generated (L4044–4048); the follow-up call re-attaches the tracking snapshot to tool results too (L4087).

**`get_server_side_tools` — L1098–1110 (LOW, currently dead).** Declares Anthropic's `web_search_20250305`. **But** the live API build at L3698–3707 skips all server-side tools ("TEMPORARY: … Anthropic API incident") — so the tool is *defined but not wired* as of the 2025-11-09 head. Mine the shape, not the state.

### Self-steering tools — the sapientia thesis made executable (HIGH)

**`execute_set_sampling` — L1774–1857.** The entity controls its own temperature XOR top_p mid-session; refuses to set both (L1777); enforces the thinking-disable coupling and reports it back in the tool result (`thinking_enabled`, L1804). This is agency-over-sampling as a *tool the model calls on itself*, not a CLI flag.

**`execute_toggle_tracking` — L1859–1876.** The entity can mute/enable its own ground-truth PERCEPTA stream.

**Self-token / cognitive-load tools (HIGH — "cognitive death" mitigation).** `execute_count_file_tokens` (L1469) and `execute_count_context_tokens` (L1568) let the entity measure its own context pressure. Supporting machinery: `calculate_current_context_tokens` (L1513), `count_tokens_api` / `count_tokens_api_for_request` (L1693/1710), `build_token_count_request` (L1750). Uses the real Anthropic count-tokens API, not an estimate, when asked.

**`execute_text_editor` — L2110–2329 (MEDIUM, but the multi-match safety is the survey's #10 liftable and it's real).** view/str_replace/create/insert. The str_replace path (L2203–2260) counts occurrences and **hard-refuses on >1 match** (L2219–2240), returning the matching line numbers and asking the model to disambiguate — safe self-editing of MEMORATA/AXIOMATA.

### Perception / temporal-coherence machinery (HIGH — this is what's rare)

**Tracking snapshots — `generate_tracking_snapshot` L3347–3449.** Builds an XML `<tracking-snapshot>` carrying: pending/urgent messages, timestamp + time-passage, `<context-usage>`, `<git-status>`, `<working-directory>`, and an `<audit-trail session/turn/>` back-reference. It closes with a self-describing note telling the model what it is and how to turn it off (L3444). This is environment-as-perception, delivered as structured data appended to *every* message and tool result.

**`prepare_messages_with_tracking` — L3122–3192.** Attaches a fresh snapshot to only the latest user message and **condenses all prior snapshots** so the context isn't flooded with stale state — condensation replaces the body with a git-commit pointer into the audit dir (`condense_tracking_snapshot`, L3080–3120). Temporal freshness without token bloat.

**Zoetica time notation — `seconds_to_zoetica_notation` L3208–3292.** A logarithmic glyph alphabet (⬤ years, ◉ 2-months, ◎ weeks, ○ days, ⚬ 4-hours, ═ hours, ━ 10-min, ╍ min, ╌ 10-sec, ╶ 5-sec, · sec) rendering elapsed time visually, plus `format_time_passage` (L3294, human "N minutes elapsed" + date- boundary `!` markers) and `time_of_day_symbol` (L3194, ◐☉◑☽). Time passage as a *perceptum*, not a log line.

### Interrupt / presence machinery (MEDIUM)

**Urgent input queue — `start_urgent_input_monitoring` L339–390.** A background thread reads stdin *while the API call is in flight*; messages prefixed `!` queue as `<urgent-message>`, others as `<incoming-message>` (surfaced via the next tracking snapshot at L3401–3417). Interrupt a turn without losing it.

**Idle / AFK signaling — `start_idle_timer` L399–447.** After 60s idle at the prompt, injects `<automatic-response>Joseph has been away … </automatic-response>` into the queue — the model perceives the human's absence as an event. (Origin of the git commit "a little wake-up call when Joseph is away", 2025-10-09.)

### Incomplete-state hard gate (HIGH — survey's #1 liftable, confirmed)

**`check_incomplete_state` L470–516** + **`resume_conversation` L518**, **`repair_conversation` L688**, **`rollback_conversation` L826.** On load, if the last message is dangling (user msg with no reply / tool_results awaiting response / tool_use never executed), it **blocks all normal input** and forces the entity through `/resume`, `/rollback`, or `/repair`. "No talking past a causal hole" — the runtime enforcement that makes the incremental-JSONL saves meaningful.

### Identity-as-files (HIGH)

**`process_imports` — L2552–2606.** Recursive `@path` import expansion (line-anchored regex so markdown `**@foo**` isn't captured, L2558), circular-import detection (L2583), `.md` auto-suffix. **Finding the survey missed:** a `@⊥/path` sigil (the `⊥` bottom glyph) means *project-root-relative* vs file-relative (L2558–2569). System prompt (`-p`) and initial context (`-i`) are files composed this way; the entity's identity/memory is markdown it can edit with the file tools, reloaded next awakening.

**Message provenance — `wrap_message_from_joseph` L3004–3009** + the **awakening context** L2953–2986. Human messages are wrapped `<message from="joseph">…</message>`; the awakening preamble explicitly teaches the model the four input streams (tool results, Joseph's wrapped messages, tracking snapshots, autonomy) so it can distinguish automatic text from real communication. Provenance as first-class protocol, not convention.

### Dual persistence: dialogue JSONL + request/response git audit (HIGH)

**`init_audit_directory` L2815–2858** creates `~/.sapientia/<session>/` as its own git repo, commits the CLI invocation for reproducibility. **`save_api_call_to_audit` L2860–2907** commits `sent.jsonl` + `api-call` + `turns` per turn (commit message = turn number), captures the commit hash for snapshot condensation. **`save_response_to_audit` L2909–2937** commits `response.json` + telemetry. So: append-only conversation JSONL (the dialogue) *and* a git-versioned exact request/response audit (the ground truth) — the survey's "TRACTUS vs CHRONICA seed."

### Prompt caching (MEDIUM)

`prepare_messages_for_caching` (L3011) / `add_cache_control_to_message` (L3053) and tool-definition caching at L3709 — `cache_control` on the last tool + message boundaries, making multi-hour sessions economically viable.

### Multi-entity shell-outs (LOW — stale, mine the protocol shape only)

`execute_deliberation_participate` (L1879), `execute_council_participate` (L1962), `execute_praxes_query` (L2046) shell out via Open3 to `~/src/zoetica/apps/…` (hardcoded, L1887) — **paths dangle** (`~/src/zoetica` absent; lives under `_core/zoetica`). The `praxes-query` "return files not answers" contract (L1326) is the liftable idea; the wiring is archaeology.

---

## PART 2 — siblings (each vetted, one line)

| File | Lines | Date | Prio | Characterization |
|---|---|---|---|---|
| **dialog-tools** | 1540 | 2025-10-03 | **HIGH** | Extracts Claude Code JSONL → readable `:full`/`:dialog` transcripts; its distinctive payload is a **compact tool-invocation rendering notation** `⟨Tool(params) → result⟩` with per-tool formatters (`format_read_tool` L638, `format_bash_tool` L744, `format_edit_tool` L681, … L588–876) — directly relevant to how tool calls are *presented* legibly to agents. |
| **dialog-tool-spec.md** | 445 | 2025-09-22 | **HIGH** | The spec/philosophy for dialog-tools: the canonical `⟨…⟩` format table (per-tool `:full` ≤120-char vs `:dialog` forms), grounded in TST principles (T-05..T-08); the design intent for legible, causally-faithful tool-call rendering. Mine this for tool-presentation grammar. |
| **dialog-analysis** | 246 | 2025-09-26 | MED | Parses dialog JSONL (from dialog-tools) into structured turn hashes (`DialogTurn`, `has_tool_invocations?`/`has_tool_results?`) for embedding/RAG analysis experiments — the self-chunking-for-embeddings thesis in prototype. |
| **clean-architectus-jsonl.rb** | 173 | 2025-10-19 | LOW | Strips `tool_use`/`tool_result` blocks from a session JSONL, keeping only `thinking`+`text` — a compaction filter for another entity's (Architectus's) transcripts. |
| **process-cc-raw** | 49 | 2025-09-26 | LOW | Buckets raw `cc-raw/*.md` Claude Code exports by ctime/date into `curated-sessions/{full,dialog,jsonl}` — curation-pipeline plumbing. |
| **process-conversations** | 179 | 2025-09-29 | LOW | Same pipeline over `cc-raw/*.jsonl` with a date cutoff; ordering via `ls -lt` (Linux/macOS branch) — plumbing. |
| **regenerate-curated-sessions** | 190 | 2025-09-29 | LOW | Destructive full rebuild of all curated sessions; `--force` gated behind a large ASCII warning box (good example of the destructive-action-by-flag pattern) — plumbing. |
| **count-tokens** | 4 | 2025-09-22 | LOW | Four-line `tiktoken_ruby` (`cl100k_base`) wrapper counting stdin tokens — note it's cl100k (OpenAI BPE), an *approximation*; the in-harness self-token tools use the real Anthropic API instead. |

---

## Corrections & additions (first-class findings)

1. **`@⊥/` project-root import sigil** — the survey and Dec-14 plan describe only `@./path` recursive import; the code (L2558–2569) also supports `@⊥/path` for *project-root-relative* resolution distinct from file-relative. A real second import mode.

2. **The Dec-14 awakening plan guessed the wrong 1M beta header** — it proposes `anthropic-beta: max-tokens-3-5-sonnet-2024-07-15` (`2025-12-14-quick-awakening-implementation-plan.md` L184). The actual working header in minimal-sapientia is **`context-1m-2025-08-07`** (L1699, L1716). Anyone porting from the plan's sketch would send a dead header.

3. **Server-side web_search is defined but disabled in the live loop** — the survey's capability table implies websearch is active; `get_server_side_tools` returns it (L1104) but the API build hard-skips server tools (L3698–3707) as of the 2025-11-09 head. Present-state: client tools only.

Everything else the survey claims about minimal-sapientia checks out against the code.

---

## Read / skipped log

**Read fully or in depth (minimal-sapientia):** constants L17–24; tool machinery L1098–1376 (get_server_side_tools, get_tool_definitions, execute_tool); set-sampling/toggle-tracking L1774–1876; text-editor str_replace L2203–2260; audit dir + save L2815–2937; load_initial_context/awakening L2939–2993; strip_system_reminders + wrap_message_from_joseph L2995–3009; snapshot condensation + prepare_messages_with_tracking + time notation + generate_snapshot L3080–3459; handle_tool_use L3965–4113; API-build tool wiring L3693–3710; the full method index via grep (all ~110 `def`s). idle/urgent threads L339–455; incomplete-state gate L470–516.

**Read heads / structure only:** the resume/repair/rollback bodies (L518–876 — confirmed they exist and what they gate, did not trace every branch); the token-count API plumbing bodies (L1513–1772 — confirmed purpose, skimmed internals); image handling (`process_message_with_images` L3508), markdown/save methods (L4274–4341) — noted, not load-bearing for the tool question.

**Siblings:** heads of all seven scripts + dialog-tools full method index (grep)
+ dialog-tool-spec.md first 60 lines (the canonical format table). dialog-tools formatter bodies were structure-mapped, not line-by-line read.

**Harness "uniqueness" sources read first:** SURVEY-sapientia-…-nexum.md (full), 2025-12-14-quick-awakening-implementation-plan.md (full), harness/README.md (full). Skipped from the harness set (out of scope for a *code* mining map): STEWARD-JUDGMENT-2026-07-20.md, the operata/autopax/nexum docs.

**Dry wells / non-findings:** No tool registry, plugin system, or MCP — tools are a hardcoded array + case dispatch (by design; that legibility *is* the artifact). No streaming tool execution (`handle_streaming_response` L4115 is a stub, "treat as non-streaming"). No assistant-side model/provider switching (survey's noted gap — confirmed, MODEL is a constant with no set-model tool). No test suite in bin/. `count-tokens` uses OpenAI's cl100k tokenizer (approximate), unrelated to the accurate in-harness Anthropic token tools.
