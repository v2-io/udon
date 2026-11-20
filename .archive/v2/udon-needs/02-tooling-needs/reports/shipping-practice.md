# Shipping practice: the fourteen-harness examination and the descent analysis

**How to read this.** Two documents: first the source-level examination of fourteen shipping coding harnesses and CLIs — what they actually build for editing, context, tools, and I/O — then the descent analysis that determines which uniformities are genuine independent agreement and which are inheritance from one influential design. The second document changes what the first one's counts mean; read them together, and treat any "everyone does X" as unresolved until the descent analysis has weighed in.

> **Provenance.** Promoted to the body of this report 2026-07-22. Refinements: this framing introduction; nothing else touched — the text below is the assembled original (gathered 2026-07-21; original file paths in its own frontmatter, which is auditor apparatus).

---

<!-- auditor apparatus — original gathered frontmatter:
- - -
source: read-across of the 17 harness-invivo characterizations (not a primary-source read)
gathered: 2026-07-21
status: synthesis — digest of secondary artifacts; provenance traces back to harness-invivo/<name>.md
paths:
  - 02-provenanced/characterizations/harness-invivo/*.md
categories: [tier-2, in-vivo-practice, cross-map-digest, edit-formats, tool-schemas]
why_included: phase-2 aid — cross-map patterns over the 17 shipped-harness maps; reopen the named map for exact line numbers/dates
- - -
-->

# BUCKET — Tier 2: In-vivo shipped practice

Source: `agentic-tooling-sources/harness-invivo/*.md` (17 vetted mining-spot maps, gathered 2026-07-21). Each source map is itself a secondary artifact (someone already read the real repo); this bucket digests all 17 into cross-map patterns. Provenance for every claim traces back to `harness-invivo/<name>.md` — reopen that file for exact line numbers/dates.

**Real harnesses in this set (14):** agentic-elixir (first-party/Joseph's own, Aug 2025 — treat as prior-art-but-thin), aider, claude-code-snapshot, codex, gemini-cli, grok-build, kilocode, kimi-code, minimax-cli (thin API client, not an editing harness), mistral-vibe, opencode, qwen-code, warp (client-only; schemas live in an external unvendored proto). **claude-docs** is Anthropic's own official spec/doc corpus (not a running harness) — treated as the canonical reference model. **obsidian-help** and **obsidian-linter** are NOT agent harnesses at all — pure markdown-family document/lint prior art, folded in only where relevant (format model, fmt/lint architecture). **yq** is not a harness either — it's path/query-language + structural-edit prior art, closest analogue to UDON's own path/patch ambitions.

---

## Part A — Per-source one-line characterization

| Source | What it actually is | Edit-tool paradigm | Standout finding |
|---|---|---|---|
| **agentic-elixir** | Joseph's own 2025 Elixir agent runtime (SimpleAgent); several tools are stubs | whole-file overwrite/append only, no str-replace | hand-rolled schema validator; `confirm`-flag destructive-gate in schema |
| **aider** | mature terminal coding harness, edit-format-first design bet | **7 competing dialects**, empirically A/B-tested per-model (SEARCH/REPLACE default, V4A patch, unified diff, whole-file) | abandoned function-calling for edits (`RuntimeError("Deprecated")`) after finding it unreliable — direct evidence against tool-call-based editing |
| **claude-code-snapshot** | shipping Claude Code CLI (~Mar 2026 snapshot) | exact str-replace with curly-quote/whitespace fuzzing | ToolSearch deferred-tool-loading + StructuredOutput/Ajv agent-mode schema |
| **claude-docs** | Anthropic's official dev docs (spec-of-record, not code) | str-replace (`text_editor_20250728`) + insert + create, no diff | tool-search-tool, programmatic-tool-calling, fine-grained-tool-streaming, advisor-tool — the "menu" of recent official advancements |
| **codex** (OpenAI) | Rust CLI, Responses API | **grammar-constrained apply_patch** (lark grammar, not JSON) | "code mode": model writes JS in embedded V8 to call tools instead of one-shot function calls |
| **gemini-cli** | Google's official TS CLI | str-replace **with LLM self-correction fallback** on failed match | XML `<state_snapshot>` compaction prompt; TOML-authorable subagents |
| **grok-build** (xAI) | Rust CLI, 4 parallel tool "personalities" | **three paradigms coexist**: str-replace, hashline anchor-edit, apply_patch | hashline: `LINE:HASH→content` anchors, atomic bottom-up batch apply, stale-anchor rejects whole batch |
| **kilocode** | VS Code/JetBrains/CLI agent, two parallel tool systems | str-replace (**9-strategy fuzzy cascade**) + apply_patch, both shipped | SWE-Pruner: tool output skimmed by a small model per-call via `context_focus_question` |
| **kimi-code** (Moonshot) | TS monorepo, multi-provider | str-replace, "no consecutive edits on same file" rule | `ToolAccesses` resource-declaration lets scheduler run non-conflicting tool calls concurrently |
| **minimax-cli** | thin API-client CLI, NOT an editing harness | none — no edit tool at all | CLI **auto-exports its own commands as Anthropic/OpenAI tool schemas** (`config export-schema`) |
| **mistral-vibe** | Python hexagonal-arch CLI, 3 delivery surfaces | str-replace, hard read-before-edit gate | numbered **instruction hierarchy** (critical > user > repo AGENTS.md > user AGENTS.md > defaults > skills/MCP > external-data-as-data) |
| **obsidian-help** | NOT a harness — Obsidian's own docs corpus | n/a | typed frontmatter "Properties" model: 6 scalar types, explicitly **no nesting, no markdown-in-properties** |
| **obsidian-linter** | NOT a harness — TS lint/fmt plugin for markdown | n/a | region-protection (`ignoreListOfTypes`) before running any rule; rule-ordering is non-commutative and hand-tuned |
| **opencode** | Bun/TS monorepo, Effect-based | str-replace (9-strategy cascade, near-identical to kilocode's — shared lineage) + apply_patch, **model-conditional routing** | "code mode": MCP tools exposed as namespaced JS functions in a sandboxed interpreter, one `execute` tool instead of N |
| **qwen-code** (Alibaba) | fork of gemini-cli, grown far past it | str-replace, secret-scan on whole post-edit file | OpenAI-compatible streaming tool-call reassembly with **auto-repair of unclosed JSON strings** |
| **warp** | Rust terminal, thin client to Warp cloud | str-replace **+ V4A apply-patch**, 3-tier fuzzy matcher (exact→whitespace-agnostic→Jaro-Winkler) | actual JSON schemas/system prompts are NOT in-repo (external proto+cloud) — a dry well by design |
| **yq** | NOT a harness — path/query language over YAML | n/a (structural path-assignment, not text edit) | `match()` returns `{string,offset,length,captures}`; `line`/`column` operators expose source position on parsed nodes |

---

## Part B — Cross-tool convergence clusters (the highest-value signal)

### C1. Edit representation: str-replace (exact-match) is the near-universal default
**Convergent across 11 of 14 real harnesses:** claude-code-snapshot, claude-docs (`text_editor` tool), codex (alongside patch), gemini-cli, kilocode, kimi-code, mistral-vibe, opencode, qwen-code, grok-build (`grok_build` family), agentic-elixir (partially — whole-file only, no str-replace but same "exact match" ethos in matching).  
Shape: `old_string`/`new_string` pair, must match **exactly** (post line-number-prefix-stripping), fails loud on 0-matches or >1-matches-without-`replace_all`, mandates a prior Read this session. This is the single most repeated concrete pattern in the whole corpus.

### C2. Fuzzy-match tolerance layered on top of str-replace, independently reinvented
Every serious str-replace implementation adds tolerance because raw exact-match fails too often in practice:
- **claude-code-snapshot**: curly/straight-quote normalization, `preserveQuoteStyle` typography reapplication, trailing-whitespace strip.
- **aider** (`editblock_coder.py`): perfect→whitespace-flexible→`...`-elision→(disabled) edit-distance cascade, with a failure-feedback message sent back to the model.
- **gemini-cli** (`smart-edit.ts`): exact→whitespace-flexible (line-trim)→token/regex-flexible cascade, PLUS a secondary LLM call (`llm-edit-fixer.ts`) if all three fail — the only source with an **LLM-as-repair-layer**, not just string fuzzing.
- **kilocode / opencode** (near-identical code, shared lineage): **9-strategy replacer cascade** — Simple→LineTrimmed→BlockAnchor (Levenshtein-thresholded first/last-line anchoring)→WhitespaceNormalized→IndentationFlexible→EscapeNormalized→TrimmedBoundary→ContextAware→MultiOccurrence, with an `isDisproportionateMatch` guard that refuses overlarge spans.
- **warp** (`diff_validation`): 3-tier — exact→indentation-agnostic→Jaro-Winkler similarity (`strsim`), with line-number-hinted disambiguation and telemetry on fuzzy-match failures.
- **grok-build** (`search_replace/helpers.rs`): whitespace-normalized matching.
- **qwen-code** (`editHelper.ts`): trailing-whitespace tolerance while preserving intent.
- **mistral-vibe**: exact substring-count check, refuses on ambiguity, no fuzzy fallback documented (stricter than the rest).

**Convergent insight:** raw LLM-emitted `old_string` is reliably *almost* right (whitespace/indentation drift, quote-style drift) but reliably *not byte-exact*; every mature harness independently built a graduated fuzzy-match ladder rather than either (a) trusting exact match or (b) falling back to whole-file. This is exactly UDON's "what edit representation do models actually emit reliably" question, answered empirically by ~8 independent teams landing on the same shape of solution.

### C2b. Singleton escalation beyond string-fuzzing: LLM-as-repair-layer (gemini-cli only)
gemini-cli is the only source where, after string-fuzzing fails, a **second LLM call** (`FixLLMEditWithInstruction`) repairs the edit using a semantic `instruction` field the model was required to supply up front ("why/where/what/desired outcome"). This is a materially different tier of robustness than anyone else's approach and worth flagging as a possible UDON design input even though it's currently a singleton.

### C3. Patch/diff envelope as the alternate edit paradigm, converging on the same grammar
**Convergent across 5 sources:** aider (`patch_prompts.py`/`patch_coder.py`), codex (`apply_patch.lark`, the origin), grok-build (vendored codex), kilocode (`apply_patch.ts`+`.txt`), opencode (`apply_patch.ts`+`.txt`, model-conditionally routed for GPT-family), warp (`V4AEdit`, explicitly cites the OpenAI apply_patch cookbook).  
Shape: `*** Begin Patch` / `*** Add|Delete|Update File:` / `@@ [scope marker]` / context lines (+/-/space) / `*** End Patch`. Multiple independent harnesses **reimplemented the same envelope from OpenAI's reference** rather than inventing their own — strong convergent evidence this specific grammar is "the" patch format in the ecosystem right now. Codex's version is the most advanced: it's **grammar-constrained** (lark, `ToolSpec::Freeform`, not JSON) rather than free-text-then-parsed.

### C4. Model-conditional tool/format routing (a repeated meta-pattern)
**Convergent across 5 sources:** aider (`ModelSettings.edit_format` per-model table — the single largest empirically-tuned artifact in the corpus), opencode (`usePatch = modelID.includes("gpt-")` routes GPT-class models to apply_patch, everyone else to str-replace edit/write), kilocode (18 per-model system-prompt files, `session/system.ts` routing table), grok-build (4 parallel "personalities": grok_build/concise/hashline + vendored codex/opencode), kimi-code (multi-provider adapters with per-model capability matrices).  
**Convergent insight:** no shipping harness treats "the tool contract" as model-agnostic. Every mature one either swaps edit format, swaps system-prompt wording, or both, keyed on model identity. This bears directly on any claim that a single agent-facing notation format could be "the" universal interface — the empirical practice is per-model tuning, not one-size-fits-all.

### C5. "Prefer dedicated tool over shell equivalent" steering table
**Convergent, nearly verbatim, across 7 sources:** claude-code-snapshot, kimi-code (`bash.md`), mistral-vibe (`prompts/bash.md`), opencode (`shell.txt`), qwen-code (`prompts.ts` L282-288), gemini-cli (implied via tool `Kind` classification), grok-build (bash guardrails). All state some version of: Read not cat/head/tail, Edit not sed/awk, Write not heredoc, Glob not find, Grep not grep/rg — "keeps raw stdout out of the conversation" (kimi-code's stated rationale). This is a load-bearing, independently-converged piece of microcopy across the entire ecosystem.

### C6. Read-before-edit as a hard, enforced gate
**Convergent across 8+ sources:** claude-code-snapshot ("will error if you attempt an edit without reading"), gemini-cli, kilocode, kimi-code, mistral-vibe (also bans same-turn read+edit), opencode, qwen-code (`priorReadEnforcement.ts` — a dedicated module), grok-build (hashline: "anchors valid only for file state at read time"). Universally treated as a hard invariant, not a suggestion, and usually enforced in code (typed error), not just prompted.

### C7. Deferred/on-demand tool loading for large tool catalogs — a genuine recent advancement, independently converged
**Convergent across 5 sources, roughly simultaneous (2026):** claude-code-snapshot (`ToolSearchTool`, this very harness's own mechanism — `select:`/keyword/`+term` query forms), claude-docs (`tool-search-tool.md`: >85% token reduction cited, accuracy degrades past 30–50 tools without it), codex (`tool_search.rs`/`tool_discovery.rs`, `defer_loading=true`), kimi-code (`agent/toolSelect/`, `select_tools` meta-tool, survives history-undo/compaction), qwen-code (`tool-search.ts`, near-identical mechanism, explicitly noted by the mapper as mirroring the harness doing this very sweep). This is the strongest "recent tooling advancement" convergence in the corpus — five independent teams landed on the same context-budget solution (name-only registration + on-demand schema fetch) within the same window.

### C8. Oversized tool-result → disk-spill-with-preview pattern
**Convergent across 5 sources:** claude-code-snapshot (`Tool.ts` `maxResultSizeChars`), kilocode (`truncate.ts`, `TRUNCATION_DIR`, 7-day retention), kimi-code (`toolResultTruncation.ts`, recoverable preview + `output_path`), opencode (`truncate.ts`, identical 2000-line/50KB thresholds to kilocode — shared lineage), codex (`exec.rs` byte-capped chunks). Consistent numeric ballpark: ~2000 lines / ~50KB triggers the spill in the JS-family harnesses specifically.

### C9. Structured-output / machine-readable final-answer contract
**Convergent across 8 sources, several distinct mechanisms:** claude-code-snapshot (`SyntheticOutputTool`, Ajv-validated against caller schema), claude-docs (`structured-outputs.md`, `output_config.format` + `strict:true` constrained decoding), codex (`--output-schema FILE` CLI flag), mistral-vibe (`--output {text,json,streaming}` formatter classes, NOT constrained decoding — message-serialization only), qwen-code (`--json-schema` headless flag), minimax-cli (`config export-schema` — inverse direction, describing itself as tools), gemini-cli (`generateJson` forcing `responseMimeType`), grok-build (`--output-format {plain,json,streaming-json}` with a documented NDJSON event contract). **Convergent insight, but with a real split:** some harnesses achieve "structured output" via true grammar/schema-constrained decoding (Anthropic `strict`, codex schema flag), others via after-the-fact JSON-serialization of internal message objects (mistral-vibe explicitly notes this distinction in its own dry-well log) — worth not conflating these when Tier 4 attaches theory names.

### C10. Streaming tool-call reassembly is a real, nontrivial, repeatedly-solved problem
**Convergent across 5 sources:** kimi-code (`chat-completions-stream.ts`, buffers OpenAI-style deltas by stream index), qwen-code (`streamingToolCallParser.ts`, handles missing IDs/index collisions, **auto-repairs unclosed JSON strings**), claude-docs (`fine-grained-tool-streaming.md`, explicit warning: "you may get partial/invalid JSON and must guard the parse"), minimax-cli (hand-rolled SSE parser, `parseSSE`), gemini-cli (`turn.ts`, `handlePendingFunctionCall`). Every implementation independently confirms: tool-call arguments arrive fragmented and out-of-order across chunks and the harness must buffer/reassemble/tolerate malformed partial JSON. Directly relevant to any UDON claim about streaming/incremental parseability of tool payloads.

### C11. Context-management-around-tool-results as its own subsystem (not just truncation)
**Convergent across 6 sources with a real diversity of technique:** claude-docs (four explicit levers: tool-search / programmatic-tool-calling / prompt-caching / context-editing — `manage-tool-context.md` is the clearest overview in the whole corpus), gemini-cli (`<state_snapshot>` XML compaction prompt — "this snapshot is the agent's *only* memory"), kimi-code (`compaction-instruction.md`, first-person handoff-note prompt), mistral-vibe (`AutoCompactMiddleware` + `<vibe-warning>` injected at ≥50% context), qwen-code (`<state_snapshot>` XML, near-identical to gemini-cli — direct fork lineage), kilocode (`swe-pruner.ts` — a small model skims raw tool output per-call before it reaches the main model, cites arXiv 2601.16746). Two families of solution: **compact the conversation history** (compaction prompts, mostly XML-snapshot shaped) vs. **shrink each tool result before it lands** (pruning/truncation/spill). Both are "context management around tool results" but are different mechanisms and Tier 4 should probably not merge them into one bucket.

### C12. Structured multiple-choice "ask the user" tool, converged shape
**Convergent across 6 sources, near-identical field shape:** claude-code-snapshot (`AskUserQuestionTool`, optional ASCII/HTML `preview`), kimi-code (`ask-user.md`, 1-4 questions × 2-4 options, "(Recommended)" convention), mistral-vibe (`ask_user_question.md`, multi-tab, auto "Other"), opencode (`question.ts`, "(Recommended)" convention — verbatim match to kimi-code), qwen-code (`askUserQuestion.ts`), warp (`AskUserQuestion`, multiselect + "other"). The "(Recommended)" default-option convention and the 1-4-questions/2-4-options-each shape recur closely enough across unrelated codebases to be a real convention, not coincidence — likely all downstream of the same original (Claude Code / Cursor-family) design.

### C13. Subagent/delegation-as-a-tool, converged shape
**Convergent across 9 sources:** claude-code-snapshot (`AgentTool`, fork-mode background), aider (architect/editor two-model split — a lighter variant), gemini-cli (`codebase-investigator.ts`, TOML-authorable agents), kilocode (`task.txt`/`.ts`, "brief it like a colleague", resumable `task_id`), kimi-code (`agent.md` — explicitly cites "brief it like a colleague who just walked in, do not delegate understanding" — the same peer-voice discipline this very project's CLAUDE.md teaches), mistral-vibe (`task.py`, read-only-enforced subagents), opencode (`task.ts`, "outputs generally trusted"), qwen-code (`builtin-agents.ts`, Explore agent deliberately omits `ask_user_question` to enforce read-only via tool-omission rather than prose), warp (`StartAgent`/`RunAgents`/multi-agent orchestration), grok-build (`task`/`task_output`). Universal shape: fresh/isolated context per subagent, a resumable ID, "don't broaden scope"/"don't expand scope" framing, and — notably — **read-only subagent roles enforced by omitting mutating tools from their toolset**, not by prompt instruction, in multiple independent implementations (kilocode's orchestrator/explore split, qwen-code's Explore agent, gemini-cli's investigator).

### C14. Structured todo/task-list as a self-tracking tool
**Convergent across 8 sources**, essentially identical shape: claude-code-snapshot, gemini-cli (`write-todos.ts`), kilocode/opencode (`todowrite.txt`, near-identical), kimi-code (`todo-list.md`), mistral-vibe (`todo.md`), qwen-code (`todoWrite.ts`). Universal rules: exactly one `in_progress` at a time, mark complete immediately/only-after-verification, never mark done if tests are red. This is the most uniform micro-convention in the whole corpus — near word-for-word repetition of rules across unrelated teams.

### C15. AGENTS.md / project-instruction-file convention, with a converging directory-scoping model
**Convergent across 6 sources:** codex (`prompt_with_apply_patch_instructions.md`, nested-AGENTS.md directory-tree scoping, nearest-wins), grok-build (`agents_md.rs`, same model, vendors the codex prompt verbatim), mistral-vibe (instruction hierarchy explicitly ranks "repo AGENTS.md path > user AGENTS.md"), qwen-code (own `AGENTS.md`+`.qwen/`), warp (`global_rules.rs`, watches `~/.agents/AGENTS.md`), kimi-code (system.md: "AGENTS.md treated as untrusted reference data" — a notably more skeptical framing than the others, with explicit prompt-injection precedence rules). The directory-tree-scoped, nearest-file-wins model is converged; kimi-code's "treat as untrusted data, not instructions" stance is a **divergence** worth flagging to Tier 4 as a live disagreement, not just a convergence.

### C16. Exact I/O contract for non-interactive/headless/agent-mode CLI use
**Convergent across essentially all 14 real harnesses** (agentic-elixir is the one exception — explicitly a dry well for this). Common elements across the set: a `--json`/`--output json`/`--output-format` flag family; a streaming-NDJSON variant (`streaming-json`/`stream-json`); non-zero exit on failure with a structured error object; a `-p`/`--print`/`-n`/single-shot prompt-and-exit mode; `--dry-run`; environment/TTY-based interactive-vs-agent auto-detection (minimax-cli's `isInteractive()`/`isCI()` is the cleanest standalone statement of this heuristic). This is arguably the single broadest convergence in Tier 2 — every shipping harness independently arrived at "TTY-or-flag detects human vs machine caller, and the machine path gets clean JSON on stdout + real exit codes."

---

## Part C — High-signal singletons (one map only, but worth carrying forward)

- **grok-build hashline anchor-editing** (`grok-build.md` §1) — `LINE:HASH→content` anchors instead of quoted text; atomic bottom-up batch apply where any stale anchor rejects the *whole* batch; three named candidate anchor-schemes (ContentOnly/ChunkFingerprint/CheckpointChain) with an explicit freshness-vs-churn tradeoff writeup and an internal benchmark harness comparing them. This is a materially different edit-addressing paradigm from every str-replace/patch tool in the rest of the corpus — content-addressed-by-hash rather than content-addressed-by-quoted-text. Directly relevant if UDON's own path/patch work considers anchor-based (vs. text-quoting) edit addressing.

- **codex "code mode" / opencode "code mode"** (codex.md §Tier 2, opencode.md §Code-mode) — technically a convergence between these two (both call it "code mode," both let the model write JS/script against tools-as-functions instead of one-call-per-tool), but no other source has anything like it, so flagging as a near-singleton pairing: a genuinely different tool-invocation paradigm (tools-as-callable-API-in-a-sandboxed-runtime vs. tools-as-individual-function-calls). claude-docs' "programmatic-tool-calling" (code_execution container) is the third, official-Anthropic instance of the same idea — so this is actually a 3-way convergence once claude-docs is counted, just newer/rarer than the others above.

- **kimi-code `ToolAccesses` declared-resource-access concurrency model** (`kimi-code.md` §Tier1) — each tool execution declares its file read/write footprint so the scheduler can run non-conflicting calls concurrently without the model having to reason about parallel-safety itself. No other source has this; most others (e.g. claude-code-snapshot's `isConcurrencySafe`) only expose a boolean flag per tool, not a per-call resource declaration.

- **kilocode SWE-Pruner** (`kilocode.md` §GOLD recent advancements) — per-call optional `context_focus_question` param that triggers a small model to skim/filter raw tool output before it reaches the main model, with full-output fallback on failure. Cites an arXiv paper (2601.16746). A genuinely different context-management lever than truncation/compaction — content-aware pruning rather than size-based cutting.

- **minimax-cli reverse-direction tool schema export** (`minimax-cli.md` §High) — a CLI that auto-generates Anthropic/OpenAI-compatible JSON tool schemas *from its own command-flag definitions* (`config export-schema`), with documented flag-spelling→JSON-type inference heuristics (no `<...>` ⇒ boolean, `<n>`/`<hz>` ⇒ number, "repeatable" in description ⇒ array). This is the only source demonstrating "CLI describes itself as a tool" rather than "harness defines its tools." Directly relevant to any UDON ambition around auto-deriving tool schemas from a notation.

- **claude-docs advisor-tool** (`claude-docs.md` §High recent advancements) — beta pattern where a fast executor model consults a separate higher-intelligence "advisor" model mid-generation for plan/course-correction. No other source has this; newest primitive in the whole corpus (Mar-2026 beta).

- **obsidian-help typed Properties model's explicit anti-nesting stance** (`obsidian-help.md` §High) — "no nested properties, no Markdown inside properties... intentional limitation as properties are meant for small, atomic bits of information that are both human and machine readable." This is a *deliberate design constraint* from a widely-used tool, directly opposable to UDON's own attribute-value-can-be-a-node ambition — worth Tier 4 treating as a considered counter-position, not an oversight.

- **yq `match()` span primitive** (`yq.md` §Path addressing) — `{string, offset, length, captures}` as the return shape for a regex match against a parsed node's value, plus `line`/`column` operators surfacing source position on any matched node. This is the cleanest small worked example in the whole Tier 2 corpus of "a structured-format query language treats byte/line/column position as first-class queryable data," which is exactly the primitive a UDON value-bracket wire redesign (per the 2026-07-19 pivot noted in project memory) would need.

- **obsidian-linter's non-commutative rule-ordering admission** (`obsidian-linter.md` §High, README note) — the project's own README states plainly that some rule combinations interfere with each other and lint rules are "not cleanly composable." An honest, load-bearing caution if UDON's `fmt` ever offers many independently-toggleable rules.

---

## Part D — Notable non-convergences / open disagreements worth flagging to Tier 4

1. **Tool-call-based editing vs. prompt-dialect editing**: aider explicitly tried and abandoned tool-call-based structured editing (`RuntimeError("Deprecated")`, citing "gpt-3.5 returns lists even when instructed to return a string"). Every other harness in this set uses str-replace or patch dialects, mostly *as* the tool contract (not a competing alternative) — so aider's abandonment isn't contradicted by the rest so much as it explains *why* the rest converged where they did. Worth stating plainly to Tier 4: the convergence on str-replace/patch dialects (C1, C3) is not an accident of taste, it is the empirical residue of at least one team trying the JSON-tool-call alternative and finding it unreliable.
2. **AGENTS.md as trusted instruction vs. untrusted data**: kimi-code diverges from the codex/grok-build/mistral-vibe/warp/qwen-code convergence (C15) by explicitly treating AGENTS.md content as untrusted reference data with prompt-injection precedence rules, rather than as authoritative instruction. A live disagreement, not resolved in this tier.
3. **Structured-output mechanism**: true constrained/grammar decoding (Anthropic `strict`, codex `--output-schema`) vs. after-the-fact JSON serialization of a message stream (mistral-vibe's three `OutputFormatter` classes, which the mapper explicitly notes are NOT constrained decoding). Both get called "structured output" in their respective harnesses' own docs; they are not the same guarantee.
4. **Anthropic vs. everyone-else edit-tool naming/shape** is otherwise so convergent (C1/C2) that the *interesting* finding is how uniform it is — worth Tier 4 double-checking whether this is genuine independent convergence or just widespread copying of the Claude Code / Anthropic `text_editor` design (several maps note "Claude-Code-style" or "mirrors Claude Code conventions" explicitly: grok-build, kilocode's `anthropic.txt`, qwen-code's whole architecture, kimi-code, warp's skills system). If it's mostly copying rather than independent convergence, that changes how much evidentiary weight Tier 4 should put on it as "agents need X" versus "one influential design got cloned."

---

## Part E — Feedback on the harvest / how this reconciliation could go better

- **The maps are unusually high quality and unusually consistent in structure** (frontmatter + tiered priority sections + a "searches/commands run" audit trail + an explicit dry-well log). That structure made this digest fast and let me trust priority labels the original mappers assigned rather than re-deriving them. Worth preserving that template for future tiers if it isn't already codified somewhere.
- **The "Claude-Code-style convergence" question (Part D.4) is the one place I'd flag as needing a second pass**, ideally by someone who can trace git/commit history or blog posts for these tools rather than just source-reading: several maps note explicit borrowing (kilocode literally vendors an `anthropic.txt` prompt variant; warp/grok-build/qwen-code all note structural mirroring). If Tier 4 wants to use Tier 2 convergence counts as evidence of "what agents need," the counts should probably be weighted down for patterns that look like lineage/copying rather than independent arrival — otherwise one influential 2024-2025 Anthropic design decision gets counted as ~8 independent votes.
- **Two of the 17 files (obsidian-help, obsidian-linter) and one more (yq) are not harnesses at all** — they're deliberately included as adjacent prior art (markdown-family format design, fmt/lint architecture, path/query-language design) per the original gathering brief. I kept them in this bucket since they're evidence for different, still Tier-2-relevant questions (document-format prior art, not agent-tool-use prior art), but a future synthesizer skimming just for "how agents use tools" should know to route those three differently than the other 14.
- **minimax-cli and agentic-elixir are both honest, well-flagged dry wells** for the "edit tool" gold specifically (minimax-cli has no editing surface at all; agentic-elixir's tools are partly aspirational stubs from Aug 2025). Both maps say so explicitly and I've carried that framing forward rather than padding them to look more relevant than they are.
- **A gap I noticed but didn't chase** (out of scope for a Tier-2-only digest): none of the 17 maps discuss how these harnesses handle *multi-file atomic edits* (i.e., transactional all-or-nothing changes across several files in one tool call) except grok-build's hashline batch semantics. If Tier 4 wants that specific angle, it may need another Tier-2 pass or Tier-3 (adjacent-fields) sourcing.

---

*Compiled by a Tier-2 digest pass, 2026-07-21. Provenance for every bullet traces to the named `harness-invivo/<file>.md`; re-open those for line numbers and exact quotes before citing further downstream.*

---

<!-- auditor apparatus — original gathered frontmatter:
- - -
source: lineage-disentangle pass over the 17 harness-invivo repos (git histories, in-repo attributions, README fork statements, vendored subtrees, citation URLs)
gathered: 2026-07-21
status: synthesis — verdicts confidence-tiered (established / probable / unknown); an honest "unknown" is preferred to a manufactured tree
paths:
  - 02-provenanced/characterizations/harness-invivo/*.md   # the maps whose counts this reweights
  - 02-provenanced/syntheses/tier2-invivo-digest.md         # the C1–C16 within-Tier-2 clusters
  - 02-provenanced/syntheses/CONVERGENCES.md                # the Tier-2 caveat this resolves
  # repos examined (external; HEAD SHA at examination = source_commit):
  - ~/src-ext/aider @ 5dc9490b
  - ~/src-ext/codex @ 0fb559f0f
  - ~/src-ext/grok-build @ 7cfcb20
  - ~/src-ext/kilocode @ 938919ab72
  - ~/src-ext/opencode @ f5573281c
  - ~/src-ext/qwen-code @ 68b4440f9
  - ~/src-ext/warp @ 37c26a8b
  - ~/src-ext/minimax-cli @ 3615170
  - ~/src-ext/mistral-vibe @ 0685654
  - ~/src-ext/kimi-code @ a41a09c3
  - ~/src/_ref/gemini-cli @ 2515b89e2
  - ~/src/_ref/claude-code-snapshot @ d7de150
categories: [tier-2, lineage, provenance, evidence-weighting, edit-formats, tool-schemas]
why_included: >
  Resolves CONVERGENCES.md's load-bearing Tier-2 caveat — separates copying/lineage
  from independent arrival so phase-2 synthesis doesn't count one influential design
  as N independent votes. Bottom line: three shipping "convergences" collapse to a
  single origin each (apply_patch → OpenAI; the opencode-family clusters → one fork;
  the gemini-family clusters → one fork), and the ecosystem-wide str_replace/todo/
  ask-user uniformity is convention-adoption of Claude Code, not independent invention.
  What survives reweighting is the cross-TIER triangulation and a genuinely-independent
  fuzzy-match-ladder convergence.
- - -
-->

# Tier-2 lineage map — copying vs. independent arrival across the 17 harnesses

> **Who this is for and why.** Phase-2 synthesizers, before Tier-4 theory leans on "N harnesses agree" as evidence weight; and the harness programme, which cares about the lineage picture in its own right. The one-line takeaway: **the shipping uniformity is mostly one-design-adopted-widely, not many-teams-arriving- independently.** That does *not* zero out Tier-2's value — survivorship-by-adoption is still real evidence — but it changes the *kind* of claim the counts support (see "How to reread the counts" at the end).

## Confidence tiers used

- **ESTABLISHED** — documentary proof: identical root-commit hash, an explicit README/attribution fork statement, a vendored source subtree present in-repo, or a direct citation URL to the origin.
- **PROBABLE** — strong circumstantial: near-verbatim convention text across unrelated codebases with a known common influence, but no direct copy provable.
- **UNKNOWN** — couldn't be settled from the trees; stated as such.

---

## Part 1 — The family tree (established lineage nodes)

| Child | Parent / origin | Verdict | Evidence |
|---|---|---|---|
| **qwen-code** | **gemini-cli** (fork) | ESTABLISHED | qwen-code's root commit is *byte-identical* to gemini-cli's: `add233c5…` "Initial commit of Gemini Code CLI" (same SHA in both repos). README §157: "originally based on Google Gemini CLI v0.8.2 … Starting from Qwen Code v0.1, we stopped syncing with upstream." So: forked, then diverged. |
| **kilocode (Kilo CLI)** | **opencode** (fork) | ESTABLISHED | README L171: "Kilo CLI is a fork of [OpenCode]." In-repo: packages are literally scoped `@opencode-ai/core`, `@opencode-ai/effect-drizzle-sqlite`, …; there is a whole `packages/opencode/` subtree; its `tool/edit.ts` differs from real opencode's by only 65 of ~750 lines. *(Note: kilocode-the-VS-Code-extension is separately Roo/Cline lineage; the **CLI** surface that generates the C2/C3/C8/C12/C14 rows IS opencode.)* |
| **grok-build** | **codex** (vendored subtree) | ESTABLISHED | Literal vendored tree `crates/codegen/xai-grok-tools/src/implementations/codex/` containing `apply_patch/`, `read_file/`, `grep_files/`, `list_dir/`. grok-build ships its own novel work (hashline) *alongside* vendored codex tools — it is a vendor-plus-original, not a fork. |
| **apply_patch envelope** (the `*** Begin Patch` format) | **OpenAI** (codex / GPT-4.1 "apply patch" cookbook, Apr 2025) | ESTABLISHED | codex is the reference impl (`codex-rs/apply-patch/`, `prompt_with_apply_patch_instructions.md`). opencode's `apply_patch.txt` is the OpenAI envelope verbatim. warp cites the origin by URL in code: `https://cookbook.openai.com/examples/gpt4-1_prompting_guide#apply-patch` and names its type `V4AEdit`. grok-build vendors codex's. kilocode inherits it via opencode. |
| **str_replace / `text_editor` edit tool** | **Anthropic Claude Code** (`text_editor_20250728`) | PROBABLE (imitation, not code-copy — Anthropic's impl isn't open) | The name `text_editor_20250728`/`str_replace` originates in Anthropic's docs (present only in `claude-docs` and in warp's *bundled Anthropic skills*, nowhere as shared code). Multiple maps note "Claude-Code-style"/"mirrors Claude Code conventions" (grok-build, kilocode `anthropic.txt`, qwen-code, kimi-code, warp). Each harness reimplements its own str-replace (different code, different languages) — so this is **convention-imitation of one influential design**, not vendoring. |
| **ask-user "(Recommended)" convention** | **Anthropic Claude Code** `AskUserQuestion` (probable common ancestor) | PROBABLE | opencode `question.txt`: *"add '(Recommended)' at the end of the label"*; kimi-code `ask-user.md`: *"append '(Recommended)' to its label"* — near-verbatim across unrelated codebases. opencode↔kilocode share it by fork; opencode↔kimi share it as a Claude-Code-family convention, not a direct copy. |
| **`<state_snapshot>` compaction prompt** | gemini-cli → qwen-code (fork) | ESTABLISHED (as fork inheritance) | Both carry it at the same path `packages/core/src/core/prompts.ts`; qwen inherited it from the gemini-cli fork. The "two independent sources" reading in digest C11 is one source counted twice. |

**Genuinely independent origins (no fork/vendor lineage found):**

- **aider** — oldest repo in the set (Aider-AI/aider, history to Aug 2024). Its SEARCH/REPLACE block dialect and its per-model `edit_format` A/B-tuning table are its *own* early contribution, predating most of the ecosystem. The single strongest "independent arrival" node for edit-format-as-a-tunable-variable thinking. Its abandonment of tool-call-based editing (`RuntimeError("Deprecated")`) is independent primary evidence, not downstream of anyone.
- **gemini-cli** — Google first-party original; its LLM-as-repair-layer (`llm-edit-fixer.ts`) is unique and independent.
- **codex** — OpenAI first-party; the *origin* of apply_patch, not a copier.
- **claude-code** — the *origin/influence node* for str_replace, ask-user, todo, ToolSearch, subagent shapes; upstream of the copies, not a copier.
- **kimi-code** — own monorepo; adopts Claude-Code-family *conventions* (ask-user, todo) in independently-written code; its `ToolAccesses` declared-resource concurrency model is unique.
- **mistral-vibe** — own hexagonal-architecture build; no fork/vendor evidence; its numbered instruction-hierarchy is its own. str-replace is convention-adoption in independent code.
- **minimax-cli** — thin client, no edit tool at all; its reverse-direction schema export is unique. Independent.
- **warp** — own Rust harness; *adopts* OpenAI's V4A apply-patch (cited) but its 3-tier fuzzy matcher and the rest are its own.

---

## Part 2 — Cluster-by-cluster reweighting (digest C1–C16)

Reading key: **raw** = the vote-count the digest reports · **independent** = how many survive as separate arrivals after collapsing forks/vendored-copies/single-origin adoptions · **verdict** on what kind of evidence it is.

| Digest cluster | Raw | Independent | Lineage verdict |
|---|---|---|---|
| **C1 str-replace default** | 11/14 | ~2–3 origins, N adopters | **Convention-adoption of Claude Code**, not independent invention. aider's SEARCH/REPLACE is the one clearly-independent alternate origin. Reread as survivorship (below), not as 11 votes. |
| **C2 fuzzy-match ladder** | ~8 | **~5–6 (survives)** | kilocode=opencode (fork → 1), gemini=qwen (fork → 1). Genuinely independent ladders remain: aider, gemini-cli, warp, grok-build, claude-code, +mistral's strict variant. Different code, different languages, same graduated-tolerance shape → **this is the one cluster that survives as genuine independent convergence.** The *problem* (raw LLM `old_string` is almost-but-not-byte-exact) was hit independently; the *solution shape* recurs. |
| **C2b LLM-as-repair-layer** | 1 (gemini-cli) | 1 | Singleton; unaffected. Inherited by qwen (fork) — still one origin. |
| **C3 apply_patch envelope** | 5 | **1 origin (OpenAI), 0 independent** | **Collapses hardest.** codex=origin; opencode adopts verbatim; kilocode=opencode; grok-build vendors codex; warp cites the cookbook. Five "votes" = one reference format adopted. **Not** evidence agents independently need this envelope. |
| **C4 model-conditional routing** | 5 | ~4 | aider's per-model table is independent and primary; opencode's `usePatch=gpt-*` routing is inherited by kilocode (fork → 1). Meta-pattern still broadly independent. |
| **C5 "prefer dedicated tool over shell" microcopy** | 7 | ~4–5 | Near-verbatim text; opencode=kilocode (fork). Strong *convention* spread (Claude-Code-family), partly independent restatement. |
| **C6 read-before-edit gate** | 8+ | ~6 | opencode=kilocode, gemini=qwen collapse. Still broadly independent as an enforced invariant; qwen-code's dedicated `priorReadEnforcement.ts` is its own hardening. |
| **C7 deferred tool loading** | 5 | ~3 | claude-code is origin; qwen-code map *explicitly notes mirroring the harness doing this sweep* (Claude Code ToolSearch); qwen also inherits infra from gemini fork. codex and kimi-code are more plausibly independent. Partial lineage. |
| **C8 disk-spill-with-preview** | 5 | 4 | opencode=kilocode share *identical 2000-line/50KB thresholds* — that's the fork, not agreement (1 not 2). claude-code, kimi, codex independent. |
| **C9 structured-output contract** | 8 | ~7 | Mostly independent; the real split (constrained decoding vs after-the-fact JSON) the digest already flags is orthogonal to lineage. |
| **C10 streaming tool-call reassembly** | 5 | ~4–5 | Largely independent (forced by each provider's wire format); gemini/qwen partial overlap. Genuine shared *problem*. |
| **C11 context-mgmt around tool results** | 6 | ~5 | gemini `<state_snapshot>` = qwen `<state_snapshot>` is fork inheritance (1 not 2); rest independent with real technique diversity. |
| **C12 ask-user "(Recommended)"** | 6 | ~2–3 | opencode=kilocode (fork); opencode↔kimi = Claude-Code-family convention. The recurring "(Recommended)" + 1-4Q/2-4-options shape is **one convention adopted**, not six inventions. Digest already suspected "downstream of the same original." |
| **C13 subagent-as-tool** | 9 | ~6 | opencode=kilocode, gemini=qwen collapse; "brief it like a colleague" text recurs verbatim (kimi, kilocode) = convention spread. Read-only-by-tool-omission is a genuinely independent *technique* seen in ≥3. |
| **C14 todo tool** | 8 | ~2–3 origins | **"most uniform micro-convention" = strongest COPY signal, weakest independent-arrival.** Near-word-for-word rules (one `in_progress`, never-done-if-red) across teams ⇒ Claude-Code TodoWrite convention adopted wholesale. opencode=kilocode fork. |
| **C15 AGENTS.md scoping** | 6 | ~4 | grok-build vendors codex's `agents_md` prompt (codex+grok → 1). Directory-tree nearest-wins model otherwise independently adopted. kimi-code's "untrusted data" stance is a genuine *divergence* (real signal, unaffected by lineage). |
| **C16 headless/agent-mode I/O contract** | 14 | broadly independent | Each harness's CLI/TTY-detection is independently built to the same forced constraint (machine caller needs clean JSON + exit codes). **Survives** as genuine — this is convergence under a hard external constraint, not copying. |

---

## Part 3 — Effect on the cross-TIER clusters (CONVERGENCES.md #1–18)

**Key point for phase-2: the lineage caveat mostly does *not* threaten the cross-tier clusters — it threatens the within-Tier-2 vote-counts.** The cross-tier clusters (#1–18 in CONVERGENCES.md) triangulate across tiers whose failure modes are *independent* (ideology can be aspirational; shipped practice can be lineage; testimony can be n-of-few; theory can have an abstraction gap). Lineage only compromises the *Tier-2 leg*. Where a cluster stands on ≥2 tiers, discounting the Tier-2 leg to "one influential design" still leaves the triangulation intact.

Concretely:

- **#1 edit-representation landscape / "no validity guarantees"** — its Tier-2 leg is exactly the C1/C3 material that collapses. But it also stands on zoetica (ideology), Architectus testimony (Tier-3), and dossier §2.4/§6 (theory). **The cross-tier claim survives; drop the "many harnesses independently agree" framing and keep "the whole shipping ecosystem edits at text/char level with no validity guarantee" — which is true precisely *because* they share lineage.** The uniformity is real; its cause is common-descent, and that's arguably a *stronger* statement of the gap UDON targets.
- **#8 str_replace multi-match HARD-REFUSE** — the "4-tier lock" is its strength: built (sapientia) + theorized (dossier §2.4) + shown-failing (Architectus) are the independent legs. The Tier-2 leg (that shipping tools refuse multi-match) is Claude-Code-convention-adopted, but the *other three legs are independent* — so this remains the best worked example. Just don't add "and N harnesses independently invented it."
- **#17 tool-definition anatomy** and **#18 agent-mode auto-detection** — #18's Tier-2 leg (C16) survives as genuine independent convergence (hard external constraint); #17 is partly convention-spread but multiply-tiered.

**Net:** no cross-tier cluster needs to be *dropped*; several need their prose changed from "independently converged across N harnesses" to "uniform across the shipping ecosystem (largely by common descent from Claude Code / OpenAI reference designs)."  
The uniformity-by-descent is itself a finding worth stating plainly.

---

## Part 4 — How to reread the Tier-2 counts (the practical rule for phase-2)

1. **Never cite a raw harness-count as "N independent votes" for these clusters:** C1 (str-replace), C3 (apply_patch), C12 (ask-user), C14 (todo), C15 (AGENTS.md). These are *one design adopted*, not many arrivals. For C3 in particular, the honest count of independent arrivals is **one** (OpenAI).
2. **Collapse these fork pairs to one wherever they co-occur in a count:** `kilocode ≡ opencode` (Kilo CLI is an opencode fork) and `qwen-code ≡ gemini-cli` (fork, pre-divergence infrastructure). grok-build's codex-derived tools are `≡ codex`.
3. **Two clusters survive as genuine independent convergence — lean on these:** **C2** (the graduated fuzzy-match ladder — independently reinvented against the same empirical fact that LLM `old_string` is almost-but-not-byte-exact) and **C16** (headless I/O contract — independently built against a hard external constraint). These are "many teams hit the same wall and built the same shape" — the evidence type the caveat was worried about losing, here genuinely present.
4. **The most-uniform clusters are the most-copied, not the most-needed.** C14 (todo) being "near word-for-word across teams" is a *tell of copying*, not of deep need. Invert the intuition: suspiciously-verbatim uniformity ⇒ lineage; independent arrivals show *shape*-convergence with *implementation* divergence (that's C2).
5. **Uniformity-by-descent is still a real finding** — "the entire shipping ecosystem edits at text/char level with no formal validity guarantee, because they all descend from two reference designs that made that choice" is a legitimate and arguably *sharper* statement of the gap than "N teams independently chose it." Use that framing; don't silently inflate it into independent corroboration.

---

## Method / evidence log

**Approach.** For each of the 17 repos: `git remote -v`, root-commit and HEAD (`git log --reverse`), README/attribution grep for fork/vendor statements, in-repo grep for the origin's names/subtrees, and direct diff where a fork was suspected. Web search was available but **not needed** — every verdict above is settled from the trees, in-repo attributions, and citation URLs already committed in the code.

**Established-tier evidence (documentary):**
- qwen-code ⟵ gemini-cli: identical root SHA `add233c5043264d47ecc6d3339a383f41a241ae8` in both repos; qwen README §157.
- kilocode-CLI ⟵ opencode: kilocode README L171; `@opencode-ai/*` package scopes; `packages/opencode/` subtree; `edit.ts` 65/750-line diff.
- grok-build vendors codex: `crates/codegen/xai-grok-tools/src/implementations/codex/…` subtree (apply_patch, read_file, grep_files, list_dir).
- apply_patch ⟵ OpenAI: opencode `apply_patch.txt` = OpenAI envelope verbatim; warp `crates/ai/src/diff_validation/mod.rs:30` cites the cookbook URL; codex `codex-rs/apply-patch/` reference impl.

**Probable-tier (convention-imitation, no code-copy provable):**
- str_replace/`text_editor` naming confined to `claude-docs` + warp's *bundled Anthropic skills*; every harness's str-replace is independently-written code → imitation of Claude Code's design, not vendoring.
- ask-user "(Recommended)" near-verbatim across opencode + kimi-code (unrelated codebases, different languages) → common Claude-Code ancestor, not direct copy.

**Genuinely independent (no lineage found):** aider (own SEARCH/REPLACE, 2024 origin), gemini-cli (Google original), codex (OpenAI original), claude-code (the influence node), kimi-code, mistral-vibe, minimax-cli, warp (own harness, adopts one cited format).

**Unknowns / not chased (honest gaps):**
- The *timing* of who-adopted-str_replace-first among the non-Anthropic harnesses isn't pinned — the origin (Claude Code) is clear, the adoption order isn't, and it doesn't change the weighting. Left UNKNOWN.
- Whether kimi-code's deferred-tool-loading (C7) is truly independent of Claude Code's ToolSearch or a convention-adoption — its code is independent but the idea's provenance isn't provable from the tree. Marked PROBABLE-partial, not established.
- `warp`'s actual JSON tool schemas live in an external unvendored proto (dry well by design per its map) — lineage of its *schemas* (vs its cited V4A format) is UNKNOWN.
- obsidian-help/obsidian-linter/yq are prior-art, not harnesses; excluded from the copying analysis (they share no lineage with the agent-harness set).

**Repos examined at the SHAs in frontmatter `paths:`.** Fork/vendor findings are stable against those pins; live repos may advance.

*— lineage-disentangle pass, 2026-07-21.*

